import '../../core/constant/api_constants.dart';
import '../../core/helper/logger_helper.dart';
import '../../core/network/api_client.dart';
import '../model/fire_alert.dart';
import '../model/sensor_reading.dart';

/// Fetches real sensor/alert data from the backend (API 8 and API 10).
/// Replaces the hardcoded seed data previously used on the home screen.
class DashboardService {
  DashboardService._();
  static final DashboardService instance = DashboardService._();

  final ApiClient _client = ApiClient();

  /// Newest-first sensor readings. [limit] defaults to the API's own
  /// default of 50; pass 1 when you only need the latest reading.
  Future<List<SensorReading>> getLatestReadings({int limit = 50}) async {
    final data = await _client.get(ApiConstants.latestReadings(limit: limit));
    final list = (data as List?) ?? [];
    return list
        .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Full alert history (requires login), newest first.
  Future<List<FireAlert>> getAlerts() async {
    final data = await _client.get(ApiConstants.alerts, authRequired: true);
    final list = (data as List?) ?? [];

    final alerts = <FireAlert>[];
    for (final e in list) {
      try {
        alerts.add(FireAlert.fromJson(e as Map<String, dynamic>));
      } catch (err, st) {
        // Don't let one malformed alert record blank out the whole list.
        LoggerHelper.instance.error(
          error: 'Skipping unparseable alert: $err\nraw: $e',
          stackTrace: st,
        );
      }
    }
    return alerts;
  }

  /// GET /api/alerts/{id} - one fully-populated alert (with `reading`).
  ///
  /// The socket events (`alert:new`, `alert:verified`, `alert:resolved`,
  /// `alert:notified`) only push the raw alert id as a string, not the
  /// object itself, so this is what turns that id into something
  /// [FireAlert.fromJson] can actually parse.
  Future<FireAlert> getAlertById(String id) async {
    final data = await _client.get(ApiConstants.alertById(id), authRequired: true);
    final json = (data is Map<String, dynamic> && data['alert'] is Map<String, dynamic>)
        ? data['alert'] as Map<String, dynamic>
        : data as Map<String, dynamic>;
    return FireAlert.fromJson(json);
  }

  /// API 14 - POST /api/alerts/{id}/dashboard-verify.
  /// [decision] must be "confirmed" or "false_alarm".
  ///
  /// Returns the *partial* alert object the backend sends back
  /// (`_id`, `status`, `verifiedBy`, `verifiedAt` - no `reading` /
  /// `createdAt`), so callers should merge it into their existing
  /// [FireAlert] rather than trying to parse it as a full one.
  Future<Map<String, dynamic>> verifyAlert(
      String alertId,
      String decision,
      ) async {
    final data = await _client.post(
      ApiConstants.verifyAlert(alertId),
      {'decision': decision},
      authRequired: true,
    );
    return (data['alert'] as Map<String, dynamic>?) ?? {};
  }

  /// API 15 - POST /api/alerts/{id}/resolve.
  /// Same partial-payload caveat as [verifyAlert].
  Future<Map<String, dynamic>> resolveAlert(String alertId) async {
    final data = await _client.post(
      ApiConstants.resolveAlert(alertId),
      {},
      authRequired: true,
    );
    return (data['alert'] as Map<String, dynamic>?) ?? {};
  }
}