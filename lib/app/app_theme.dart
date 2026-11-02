import 'package:flutter/material.dart';

import '../core/constant/app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: FireGuardColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: FireGuardColors.flame,
      primary: FireGuardColors.flame,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: FireGuardColors.surface,
      surfaceTintColor: FireGuardColors.surface,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: FireGuardColors.textPrimary),
      titleTextStyle: FireGuardText.screenTitle,
    ),
    dividerTheme: const DividerThemeData(
      color: FireGuardColors.divider,
      thickness: 1,
      space: 1,
    ),
    fontFamily: FireGuardText.fontFamily,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 2,
    ),
  );
}