import 'package:firedetection_system/module/Alert/view/alert_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_color.dart';
import '../../Alert/controller/AlertController.dart';
import '../../Alert/view/alertscreen.dart';
import '../../Alert/widget/alert_list_item.dart';
import '../controller/homecontroller.dart';
import '../widget/sensor_metric_grid.dart';
import '../widget/status_banner.dart';

class Homescreen extends GetView<HomeController> {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertController = Get.find<AlertController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: FireGuardColors.flame,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text(
              'Fire guard',
              style: FireGuardText.screenTitle,
            ),
          ],
        ),
        actions: [
          Obx(() {
            final connected = controller.isConnected.value;

            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(
                    connected ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: connected
                        ? FireGuardColors.connected
                        : FireGuardColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    connected ? 'Device Connected' : 'Offline',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: connected
                          ? FireGuardColors.connected
                          : FireGuardColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          final reading = controller.liveReading.value;

          if (reading == null) {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // No reading yet and nothing in flight - either the device
            // hasn't reported in, or the initial fetch failed.
            return RefreshIndicator(
              onRefresh: controller.refreshLiveReading,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
                children: [
                  Center(
                    child: Text(
                      controller.loadError.value ?? 'No sensor data yet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: FireGuardColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final isFire = reading.flameDetected;

          return RefreshIndicator(
            onRefresh: controller.refreshLiveReading,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                StatusBanner(
                  tone: isFire
                      ? BannerTone.danger
                      : BannerTone.safe,
                  icon: isFire
                      ? Icons.local_fire_department
                      : Icons.shield_outlined,
                  title: isFire ? 'Fire detected' : 'Area safe',
                  subtitle:
                  'Last checked ${controller.secondsSinceCheck.value} seconds ago',
                ),

                const SizedBox(height: 22),

                const Text(
                  'Live sensor readings',
                  style: FireGuardText.sectionLabel,
                ),

                const SizedBox(height: 12),

                SensorMetricGrid(
                  reading: reading,
                ),

                const SizedBox(height: 22),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent alerts',
                      style: FireGuardText.sectionLabel,
                    ),

                    TextButton(
                      onPressed: () => Get.to(
                            () => const AlertsHistoryScreen(),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: FireGuardColors.flame,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // AlertController handles alert data.
                Obx(() {
                  if (alertController.alerts.isEmpty) {
                    return const Text(
                      'No recent alerts',
                      style: TextStyle(
                        color: FireGuardColors.textSecondary,
                      ),
                    );
                  }

                  final alert = alertController.alerts.first;

                  return AlertListItem(
                    alert: alert,
                    onTap: () => Get.to(
                            () => AlertDetailsScreen(alertId: alert.id)
                      // alertId: alert.id,
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}