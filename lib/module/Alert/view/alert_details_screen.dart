import 'package:firedetection_system/module/firestation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_color.dart';
import '../../../data/model/fire_alert.dart';
import '../../../data/model/relative_time.dart';
import '../../home/widget/sensor_metric_grid.dart';
import '../../home/widget/status_banner.dart';
import '../../navbar/controller/navbar_controller.dart';
import '../controller/AlertController.dart';

class AlertDetailsScreen extends StatelessWidget {
  final String alertId;

  const AlertDetailsScreen({super.key, required this.alertId});

  /// ML confidence gauge color:
  /// 0-50% -> green, 50-70% -> pink, 70-100% -> red.
  Color _confidenceColor(double confidence) {
    final percent = confidence * 100;

    if (percent < 50) {
      return FireGuardColors.progressLow;
    } else if (percent < 70) {
      return FireGuardColors.progressMid;
    } else {
      return FireGuardColors.progressHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlertController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Alert details')),
      body: SafeArea(
        child: Obx(() {
          final alert = controller.alertById(alertId);

          if (alert == null) {
            return const Center(child: Text('Alert not found.'));
          }

          final isFire = alert.status.isFire;
          final isResolved = alert.status == FireAlertOutcome.resolved;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              StatusBanner(
                tone: isResolved
                    ? BannerTone.resolved
                    : (isFire ? BannerTone.danger : BannerTone.caution),
                icon: isResolved
                    ? Icons.check_circle_outline
                    : (isFire ? Icons.warning_rounded : Icons.cloud_outlined),
                title: alert.status.title(
                  falseAlarmReason: alert.falseAlarmReason,
                ),
                subtitle:
                'Device ${alert.deviceId}, ${relativeTimeLabel(alert.timestamp)}',
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FireGuardColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ML prediction',
                            style: FireGuardText.metricLabel,
                          ),
                          Text(
                            isFire ? 'Fire' : 'No fire',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isFire
                                  ? FireGuardColors.dangerText
                                  : FireGuardColors.safeText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Confidence',
                            style: FireGuardText.metricLabel,
                          ),
                          Text(
                            alert.confidenceLabel,
                            style: FireGuardText.bodyStrong,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: alert.mlConfidence,
                          minHeight: 6,
                          backgroundColor: FireGuardColors.divider,
                          valueColor: AlwaysStoppedAnimation(
                            _confidenceColor(alert.mlConfidence),
                          ),
                        ),
                      ),
                      const Divider(height: 28),
                      SensorMetricGrid(reading: alert.reading, showIcon: false),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              if (alert.status == FireAlertOutcome.pending) ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.confirmAlert(alert.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FireGuardColors.dangerText,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'Confirm real fire',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => controller.markFalseAlarm(
                            alert.id,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FireGuardColors.actionGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text(
                            'This is false fire',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (alert.status == FireAlertOutcome.verified) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.find<FireStationController>().setPendingAlert(alert.id);
                      Get.find<NavController>().goToStation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FireGuardColors.actionGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.campaign_outlined),
                    label: const Text(
                      'Notify fire service',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sends location and readings via WhatsApp',
                  textAlign: TextAlign.center,
                  style: FireGuardText.caption,
                ),
              ] else if (alert.status == FireAlertOutcome.notified) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.markResolved(alert.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FireGuardColors.actionGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.task_alt_outlined),
                    label: const Text(
                      'Resolve',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}