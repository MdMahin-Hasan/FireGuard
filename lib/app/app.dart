import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_binding.dart';
import 'app_pages.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class FireAlert extends StatelessWidget {
  const FireAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Face Recognition',

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,

      initialBinding: AppBinding(),

      getPages: AppPages.pages,
    );
  }
}