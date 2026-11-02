import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constant/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/model/fire_station.dart';
import '../../../data/model/sensor_reading.dart';
import '../../../data/service/fire_station_service.dart';

class FireStationController extends GetxController {
  final ApiClient _client = ApiClient();
  final FireStationService _service = FireStationService(ApiClient());

  final RxList<FireStation> stations = <FireStation>[].obs;
  final RxBool isLoading = false.obs;

  /// Latest sensor reading, used to build the WhatsApp alert message
  /// and to sort stations by distance.
  final Rx<SensorReading?> latestReading = Rx<SensorReading?>(null);

  /// The verified-fire alert the user is currently trying to notify a
  /// station about. Set by AlertDetailsScreen right before navigating
  /// here (this screen is a persistent bottom-nav tab, so it has no
  /// alertId of its own otherwise). The API requires an `alertId` on
  /// every notify call, so this must be non-null for `notifyStation` to
  /// actually send anything.
  final Rx<String?> pendingAlertId = Rx<String?>(null);

  void setPendingAlert(String? alertId) => pendingAlertId.value = alertId;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await fetchLatestReading();
    await fetchStations();
  }

  Future<void> fetchLatestReading() async {
    try {
      final data = await _client.get(ApiConstants.latestReadings(limit: 1));
      final list = data as List;
      if (list.isNotEmpty) {
        latestReading.value =
            SensorReading.fromJson(list.first as Map<String, dynamic>);
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', 'Could not fetch sensor location: ${e.message}');
    }
  }

  Future<void> fetchStations() async {
    isLoading.value = true;
    try {
      final fetched = await _service.getFireStations();

      final reading = latestReading.value;
      if (reading?.latitude != null && reading?.longitude != null) {
        fetched.sort((a, b) => a
            .distanceFromKm(reading!.latitude!, reading.longitude!)
            .compareTo(
            b.distanceFromKm(reading.latitude!, reading.longitude!)));
      }

      stations.value = fetched;
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refetches both the reading and stations, re-sorting by distance.
  Future<void> refresh() async {
    await fetchLatestReading();
    await fetchStations();
  }

  /// Distance label for a station, relative to the latest sensor reading.
  String distanceLabelFor(FireStation station) {
    final reading = latestReading.value;
    if (reading?.latitude == null || reading?.longitude == null) return '--';
    return station.distanceLabelFrom(reading!.latitude!, reading.longitude!);
  }

  Future<void> notifyStation(String id) async {
    final alertId = pendingAlertId.value;
    if (alertId == null) {
      Get.snackbar(
        'No alert selected',
        'Open a confirmed fire alert and use "Notify fire service" first.',
      );
      return;
    }

    try {
      await _service.notifyFireStation(id, alertId: alertId);
      Get.snackbar('Sent', 'Fire station has been notified.');
      // Server pushes the updated alert (status -> notified) to
      // AlertController over the alert:notified socket event, so there's
      // no need to duplicate that update here - just clear the pending
      // reference now that this notify has gone through.
      pendingAlertId.value = null;
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    }
  }

  Future<void> openWhatsApp(
      String phoneNumber, {
        String message = '',
      }) async {
    var cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.startsWith('0')) {
      cleanNumber = '880${cleanNumber.substring(1)}';
    }

    final uri = Uri.parse(
      'https://wa.me/$cleanNumber${message.isNotEmpty ? '?text=${Uri.encodeComponent(message)}' : ''}',
    );

    print('Attempting to launch: $uri'); // debug

    try {
      final canLaunch = await canLaunchUrl(uri);
      print('canLaunchUrl result: $canLaunch'); // debug

      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('launchUrl result: $launched'); // debug
        if (!launched) {
          Get.snackbar('Error', 'Could not open WhatsApp');
        }
      } else {
        Get.snackbar('Error', 'Could not open WhatsApp');
      }
    } catch (e) {
      print('openWhatsApp error: $e'); // debug
      Get.snackbar('Error', 'Failed to open WhatsApp: $e');
    }
  }

  Future<void> callStation(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch phone dialer');
    }
  }
}