import 'dart:async';

import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/socket_service.dart';
import '../../../data/model/sensor_reading.dart';
import '../../../data/service/dashboard_service.dart';

class HomeController extends GetxController {
  static const String deviceId = 'esp32-01';

  /// Null until the first real reading arrives (initial fetch or socket
  /// push) - there is no fallback/mock reading shown before that.
  final Rx<SensorReading?> liveReading = Rx<SensorReading?>(null);

  final RxBool isLoading = true.obs;
  final Rx<String?> loadError = Rx<String?>(null);

  final RxBool isConnected = true.obs;

  final RxInt secondsSinceCheck = 0.obs;

  void Function(dynamic)? _onSensorReading;
  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();

    _loadInitialReading();

    SocketService.instance.connect();

    // Reflect the actual socket connection state in the wifi icon
    // instead of a hardcoded value.
    SocketService.instance.onConnect(() => isConnected.value = true);
    SocketService.instance.onDisconnect(() => isConnected.value = false);

    _onSensorReading = (data) {
      final json = data as Map<String, dynamic>;

      // The event fires for every device; only react to ours.
      if (json['deviceId'] != deviceId) return;

      liveReading.value = SensorReading.fromJson(json);
      secondsSinceCheck.value = 0;
    };
    SocketService.instance.on('sensor:reading', _onSensorReading!);

    // Ticks "Last checked X seconds ago" up in real time between socket
    // events, instead of it sitting frozen until the next reading arrives.
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
          (_) => secondsSinceCheck.value++,
    );
  }

  /// Pulls the latest real reading from the API (GET /api/sensor-data/latest)
  /// so the home screen shows real data immediately, before any socket
  /// event has fired.
  Future<void> _loadInitialReading() async {
    isLoading.value = true;
    loadError.value = null;

    try {
      final readings = await DashboardService.instance.getLatestReadings(limit: 1);
      if (readings.isNotEmpty) {
        liveReading.value = readings.first;
        secondsSinceCheck.value =
            DateTime.now().difference(readings.first.timestamp).inSeconds;
      }
    } on ApiException catch (e) {
      loadError.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    SocketService.instance.off('sensor:reading', _onSensorReading);
    _ticker?.cancel();
    super.onClose();
  }

  Future<void> refreshLiveReading() => _loadInitialReading();

  void updateConnection(bool connected) {
    isConnected.value = connected;
  }
}