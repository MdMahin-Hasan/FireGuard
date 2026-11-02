import 'package:firedetection_system/module/Alert/controller/AlertController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_color.dart';
import '../../../data/model/fire_alert.dart';
import '../widget/alert_list_item.dart';
import '../widget/filterchip.dart';
import 'alert_details_screen.dart';

enum _AlertFilter {
  all,
  verifiedFire,
  waitingVerification,
  falseAlarm,
  notified,
  resolved,
}

extension _AlertFilterLabel on _AlertFilter {
  String get label {
    switch (this) {
      case _AlertFilter.all:
        return 'All';
      case _AlertFilter.verifiedFire:
        return 'Verified fire';
      case _AlertFilter.waitingVerification:
        return 'Waiting verification';
      case _AlertFilter.falseAlarm:
        return 'False alarm';
      case _AlertFilter.notified:
        return 'Notified';
      case _AlertFilter.resolved:
        return 'Resolved';
    }
  }
}

class AlertsHistoryScreen extends StatefulWidget {
  const AlertsHistoryScreen({super.key});

  @override
  State<AlertsHistoryScreen> createState() => _AlertsHistoryScreenState();
}

class _AlertsHistoryScreenState extends State<AlertsHistoryScreen> {
  _AlertFilter _filter = _AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlertController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Alert history')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    for (final filter in _AlertFilter.values) ...[
                      AlertFilterChip(
                        label: filter.label,
                        selected: _filter == filter,
                        onTap: () => setState(() => _filter = filter),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.loadError.value != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.loadError.value!,
                            textAlign: TextAlign.center,
                            style: FireGuardText.caption,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.loadAlerts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final alerts = controller.alerts.where((a) {
                  switch (_filter) {
                    case _AlertFilter.all:
                      return true;
                    case _AlertFilter.verifiedFire:
                      return a.status == FireAlertOutcome.verified;
                    case _AlertFilter.waitingVerification:
                      return a.status == FireAlertOutcome.pending;
                    case _AlertFilter.falseAlarm:
                      return a.status == FireAlertOutcome.falseAlarm;
                    case _AlertFilter.notified:
                      return a.status == FireAlertOutcome.notified;
                    case _AlertFilter.resolved:
                      return a.status == FireAlertOutcome.resolved;
                  }
                }).toList();

                if (alerts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No alerts in this filter yet.',
                      style: FireGuardText.caption,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadAlerts,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: alerts.length,
                    separatorBuilder: (_, __) =>
                    const Divider(
                      height: 1,
                      color: FireGuardColors.divider,
                    ),
                    itemBuilder: (context, index) {
                      final alert = alerts[index];

                      return AlertListItem(
                        alert: alert,
                        onTap: () => Get.to(
                              () => AlertDetailsScreen(alertId: alert.id),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}