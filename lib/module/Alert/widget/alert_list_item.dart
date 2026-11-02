import 'package:flutter/material.dart';

import '../../../core/constant/app_color.dart';
import '../../../data/model/fire_alert.dart';
import '../../../data/model/relative_time.dart';


class AlertListItem extends StatelessWidget {
  final FireAlert alert;
  final VoidCallback onTap;

  const AlertListItem({super.key, required this.alert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFire = alert.status.isFire;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isFire
                    ? FireGuardColors.dangerIconBg
                    : FireGuardColors.cautionChipBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isFire
                    ? Icons.local_fire_department
                    : Icons.cloud_outlined,
                color: isFire
                    ? FireGuardColors.dangerText
                    : FireGuardColors.cautionText,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.status.title(falseAlarmReason: alert.falseAlarmReason),
                    style: FireGuardText.bodyStrong,
                  ),
                  const SizedBox(height: 2),
                  Text(relativeTimeLabel(alert.timestamp),
                      style: FireGuardText.caption),
                ],
              ),
            ),
            _OutcomeChip(status: alert.status),
          ],
        ),
      ),
    );
  }
}

class _OutcomeChip extends StatelessWidget {
  final FireAlertOutcome status;
  const _OutcomeChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;

    switch (status) {
      case FireAlertOutcome.verified:
        bg = FireGuardColors.dangerChipBg;
        fg = FireGuardColors.dangerChipText;
        label = 'Verified';
        break;
      case FireAlertOutcome.notified:
        bg = FireGuardColors.dangerChipBg;
        fg = FireGuardColors.dangerChipText;
        label = 'Notified';
        break;
      case FireAlertOutcome.resolved:
        bg = FireGuardColors.safeBg;
        fg = FireGuardColors.safeText;
        label = 'Resolved';
        break;
      case FireAlertOutcome.falseAlarm:
        bg = FireGuardColors.cautionChipBg;
        fg = FireGuardColors.cautionChipText;
        label = 'Filtered';
        break;
      case FireAlertOutcome.pending:
        bg = FireGuardColors.surfaceMuted;
        fg = FireGuardColors.textSecondary;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}