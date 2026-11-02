import 'package:flutter/material.dart';

/// Color + type tokens for the Fire Guard feature.
/// Derived from the approved reference screens:
///  - Safe / connected  -> green family
///  - Caution / filtered -> amber family
///  - Fire / danger      -> red family
class FireGuardColors {
  FireGuardColors._();

  // Brand
  static const Color flame = Color(0xFFB3261E);
  static const Color flameDark = Color(0xFF7A1913);

  // Status: safe
  static const Color safeBg = Color(0xFFD9EFDA);
  static const Color safeText = Color(0xFF2E7D32);
  static const Color safeIcon = Color(0xFF2E7D32);

  // Status: caution / false alarm
  static const Color cautionBg = Color(0xFFF6DFAE);
  static const Color cautionText = Color(0xFF8A6116);
  static const Color cautionChipBg = Color(0xFFF3D9A4);
  static const Color cautionChipText = Color(0xFF8A6116);

  // Status: danger / fire
  static const Color dangerBg = Color(0xFFF7D3D3);
  static const Color dangerText = Color(0xFFB3261E);
  static const Color dangerIconBg = Color(0xFFF6D1CF);
  static const Color dangerChipBg = Color(0xFFDCF3DE);
  static const Color dangerChipText = Color(0xFF2E7D32);

  // Status: resolved
  static const Color resolvedBg = Color(0xFFD3E3F7);
  static const Color resolvedText = Color(0xFF1A56A0);

  // ML confidence progress gauge (0-50% green, 50-70% pink, 70-100% red)
  static const Color progressLow = Color(0xFF2E7D32);
  static const Color progressMid = Color(0xFFE91E8C);
  static const Color progressHigh = Color(0xFFB3261E);

  // Neutrals
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF6F6F5);
  static const Color cardBg = Color(0xFFF7F7F6);
  static const Color divider = Color(0xFFECECEA);
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF7A7A78);
  static const Color connected = Color(0xFF2E7D32);

  // Action
  static const Color actionGreen = Color(0xFF1F9D3B);
  static const Color whatsapp = Color(0xFF25D366);
}

class FireGuardText {
  FireGuardText._();

  static const String fontFamily = 'Roboto';

  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: FireGuardColors.textPrimary,
  );

  static const TextStyle sectionLabel = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: FireGuardColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: FireGuardColors.textSecondary,
  );

  static const TextStyle metricValue = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: FireGuardColors.textPrimary,
  );

  static const TextStyle metricLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: FireGuardColors.textSecondary,
  );
}