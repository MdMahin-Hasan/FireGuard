import 'package:get/get.dart';
import '../../../core/helper/logger_helper.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/socket_service.dart';
import '../../../data/model/fire_alert.dart';
import '../../../data/service/dashboard_service.dart';

class AlertController extends GetxController {
  static const String deviceId = 'esp32-01';

  final RxList<FireAlert> alerts = <FireAlert>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<String?> loadError = Rx<String?>(null);

  /// Alert ids currently mid-request (confirm / false-alarm / resolve).
  /// UI can check `busyAlertIds.contains(id)` to disable buttons / show a
  /// spinner instead of letting a slow request be fired twice.
  final RxSet<String> busyAlertIds = <String>{}.obs;

  void Function(dynamic)? _onAlertNew;
  void Function(dynamic)? _onAlertVerified;
  void Function(dynamic)? _onAlertResolved;
  void Function(dynamic)? _onAlertNotified;

  @override
  void onInit() {
    super.onInit();
    loadAlerts();

    // Make sure the shared socket is actually connected. `on()` below is a
    // no-op if the socket hasn't been created yet, so relying on
    // HomeController to have called connect() first is fragile - it only
    // worked when Home happened to build before Alert. connect() itself is
    // idempotent (safe to call again if Home already connected it).
    SocketService.instance.connect();

    _onAlertNew = (data) async {
      try {
        // The server sends only the new alert's id as a raw string here
        // (confirmed by the "type 'String' is not a subtype of Map" error) -
        // not the alert object. Fetch the full, populated record instead of
        // trying to parse the payload itself.
        final id = data is String
            ? data
            : (data as Map<String, dynamic>)['_id'] as String?;
        if (id == null) {
          LoggerHelper.instance.error(
            error: 'alert:new payload has no usable id: $data',
          );
          return;
        }

        // Guard against duplicate inserts (e.g. a reconnect replaying the
        // event, or a race with an in-flight loadAlerts()).
        if (alerts.any((a) => a.id == id)) return;

        final alert = await DashboardService.instance.getAlertById(id);
        if (alert.deviceId != 'unknown' && alert.deviceId != deviceId) return;

        alerts.insert(0, alert);
      } catch (e, st) {
        LoggerHelper.instance.error(
          error: 'Failed to handle alert:new payload: $e\nraw: $data',
          stackTrace: st,
        );
      }
    };
    _onAlertVerified = (data) => _replaceFromJson(data);
    _onAlertResolved = (data) => _replaceFromJson(data);
    _onAlertNotified = (data) => _replaceFromJson(data);

    SocketService.instance
      ..on('alert:new', _onAlertNew!)
      ..on('alert:verified', _onAlertVerified!)
      ..on('alert:resolved', _onAlertResolved!)
      ..on('alert:notified', _onAlertNotified!);
  }

  /// Loads real alert history from the API (GET /api/alerts) in place of
  /// the old hardcoded seed list.
  Future<void> loadAlerts() async {
    isLoading.value = true;
    loadError.value = null;

    try {
      final fetched = await DashboardService.instance.getAlerts();
      LoggerHelper.instance.info(
        'GET /api/alerts -> ${fetched.length} alert(s)',
      );
      alerts.assignAll(fetched);
    } on ApiException catch (e) {
      LoggerHelper.instance.error(
        error: 'GET /api/alerts failed (${e.statusCode}): ${e.message}',
      );
      loadError.value = e.message;
    } catch (e, st) {
      // Catches anything that isn't an ApiException - e.g. a JSON/shape
      // mismatch inside FireAlert.fromJson - which would otherwise vanish
      // silently and just leave the list empty.
      LoggerHelper.instance.error(error: e, stackTrace: st);
      loadError.value = 'Something went wrong loading alerts: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    SocketService.instance
      ..off('alert:new', _onAlertNew)
      ..off('alert:verified', _onAlertVerified)
      ..off('alert:resolved', _onAlertResolved)
      ..off('alert:notified', _onAlertNotified);
    super.onClose();
  }

  /// Swaps in the fresh copy of an alert pushed over the socket after a
  /// verify/resolve/notify event, keeping the list in sync without a
  /// manual refetch.
  ///
  /// Like `alert:new`, these events send just the alert's id as a raw
  /// string, not the object - refetch it rather than trying to parse the
  /// payload directly.
  Future<void> _replaceFromJson(dynamic data) async {
    try {
      final id = data is String
          ? data
          : (data as Map<String, dynamic>)['_id'] as String?;
      if (id == null) {
        LoggerHelper.instance.error(
          error: 'alert status-update payload has no usable id: $data',
        );
        return;
      }

      final index = alerts.indexWhere((a) => a.id == id);
      if (index == -1) return; // not an alert we're currently tracking

      final updated = await DashboardService.instance.getAlertById(id);
      alerts[index] = updated;
    } catch (e, st) {
      LoggerHelper.instance.error(
        error: 'Failed to handle alert status-update payload: $e\nraw: $data',
        stackTrace: st,
      );
    }
  }

  FireAlert? alertById(String id) {
    final matches = alerts.where((alert) => alert.id == id);

    return matches.isEmpty ? null : matches.first;
  }

  /// API 14 - "confirmed". Actually calls
  /// POST /api/alerts/{id}/dashboard-verify.
  Future<void> confirmAlert(String id) => _submitVerification(id, 'confirmed');

  /// API 14 - "false_alarm". [reason] is UI-only (the backend doesn't take
  /// a free-text reason for this endpoint) and is kept locally for display.
  Future<void> markFalseAlarm(
      String id, {
        String reason = 'verified by reviewer',
      }) =>
      _submitVerification(id, 'false_alarm', reason: reason);

  /// API 15 - POST /api/alerts/{id}/resolve.
  Future<void> markResolved(String id) async {
    if (!busyAlertIds.add(id)) return;
    try {
      final result = await DashboardService.instance.resolveAlert(id);
      _mergeApiResult(id, result, fallbackStatus: FireAlertOutcome.resolved);
    } on ApiException catch (e) {
      LoggerHelper.instance.error(
        error: 'POST resolve failed for $id (${e.statusCode}): ${e.message}',
      );
      Get.snackbar('Could not resolve alert', e.message);
    } catch (e, st) {
      LoggerHelper.instance.error(error: e, stackTrace: st);
      Get.snackbar('Could not resolve alert', 'Something went wrong: $e');
    } finally {
      busyAlertIds.remove(id);
    }
  }

  Future<void> _submitVerification(
      String id,
      String decision, {
        String? reason,
      }) async {
    if (!busyAlertIds.add(id)) return; // already in flight for this alert
    try {
      final result = await DashboardService.instance.verifyAlert(id, decision);
      final fallbackStatus = decision == 'confirmed'
          ? FireAlertOutcome.verified
          : FireAlertOutcome.falseAlarm;
      _mergeApiResult(
        id,
        result,
        fallbackStatus: fallbackStatus,
        falseAlarmReason: decision == 'false_alarm' ? reason : null,
      );
    } on ApiException catch (e) {
      LoggerHelper.instance.error(
        error:
        'POST dashboard-verify failed for $id (${e.statusCode}): ${e.message}',
      );
      Get.snackbar('Could not update alert', e.message);
    } catch (e, st) {
      LoggerHelper.instance.error(error: e, stackTrace: st);
      Get.snackbar('Could not update alert', 'Something went wrong: $e');
    } finally {
      busyAlertIds.remove(id);
    }
  }

  /// Merges a *partial* alert payload from the verify/resolve endpoints
  /// (which only send back `status` / `verifiedBy` / timestamps, not the
  /// full reading) into the existing local [FireAlert], instead of trying
  /// to parse it as one via [FireAlert.fromJson] (which would throw on the
  /// missing `createdAt`/`reading` fields).
  void _mergeApiResult(
      String id,
      Map<String, dynamic> alertJson, {
        required FireAlertOutcome fallbackStatus,
        String? falseAlarmReason,
      }) {
    final index = alerts.indexWhere((alert) => alert.id == id);
    if (index == -1) return;

    final old = alerts[index];

    final statusStr = alertJson['status'] as String?;
    final status = statusStr != null
        ? FireAlert.outcomeFromApiStatus(statusStr)
        : fallbackStatus;

    final verifiedByJson = alertJson['verifiedBy'] as Map<String, dynamic>?;
    final verifiedByName = verifiedByJson?['name'] as String? ?? old.verifiedBy;

    alerts[index] = FireAlert(
      id: old.id,
      deviceId: old.deviceId,
      status: status,
      falseAlarmReason:
      status == FireAlertOutcome.falseAlarm ? falseAlarmReason : null,
      timestamp: old.timestamp,
      mlConfidence: old.mlConfidence,
      reading: old.reading,
      otherVerifiersNotified: old.otherVerifiersNotified,
      verifiedBy: verifiedByName,
    );
  }
}