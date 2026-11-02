import 'package:flutter/material.dart';

import '../../../core/constant/app_color.dart';

enum BannerTone { safe, caution, danger, resolved }

/// The big rounded status banner used on Home, Alert details and Verify
/// alert (e.g. "Area safe", "Fire confirmed", "ML flagged: fire").
class StatusBanner extends StatelessWidget {
  final BannerTone tone;
  final IconData icon;
  final String title;
  final String subtitle;

  const StatusBanner({
    super.key,
    required this.tone,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  Color get _bg {
    switch (tone) {
      case BannerTone.safe:
        return FireGuardColors.safeBg;
      case BannerTone.caution:
        return FireGuardColors.cautionBg;
      case BannerTone.danger:
        return FireGuardColors.dangerBg;
      case BannerTone.resolved:
        return FireGuardColors.resolvedBg;
    }
  }

  Color get _fg {
    switch (tone) {
      case BannerTone.safe:
        return FireGuardColors.safeText;
      case BannerTone.caution:
        return FireGuardColors.cautionText;
      case BannerTone.danger:
        return FireGuardColors.dangerText;
      case BannerTone.resolved:
        return FireGuardColors.resolvedText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: _fg, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: _fg,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: _fg.withOpacity(0.85), fontSize: 13),
          ),
        ],
      ),
    );
  }
}