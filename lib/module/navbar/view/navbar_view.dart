import 'package:firedetection_system/core/constant/app_color.dart';
import 'package:firedetection_system/module/navbar/controller/navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationView extends GetView<NavController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Get.isDarkMode;

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.setIndex,
          backgroundColor:
          dark ? const Color(0xFF121212) : FireGuardColors.surface,
          indicatorColor: dark
              ? Colors.white.withOpacity(0.1)
              : FireGuardColors.flame.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Alert'),
            NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), label: 'Stations'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
    );
  }
}