import 'package:firedetection_system/core/helper/logger_helper.dart';
import 'package:firedetection_system/module/Alert/view/alertscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../firestation/view/FirestationScreen.dart';
import '../../home/view/homeScreen.dart';
import '../../profile/view/profileScreen.dart';

class NavController extends GetxController {

  final List<Widget> screens = [
    Homescreen(),
    AlertsHistoryScreen(),
    FireStationScreen(),
    ProfileScreen(),
  ];

  final RxInt selectedIndex = 0.obs;

  /// Kept for any old call sites still using changeIndex(); routes through
  /// the same safe setter as selectedIndex.value = x.
  void changeIndex(int index) => setIndex(index);

  void setIndex(int index) {
    LoggerHelper.instance.info(
      'NavController.setIndex called with index=$index '
          '(current=${selectedIndex.value}, screens.length=${screens.length})',
    );

    if (selectedIndex.value == index) {
      return;
    }

    // Guard against an index that has no matching screen. Without this,
    // `screens[index]` in NavigationView throws a RangeError and takes
    // down the whole app with no useful message.
    if (index < 0 || index >= screens.length) {
      LoggerHelper.instance.error(
        error:
        'NavController.setIndex: index $index is out of range for '
            'screens (length ${screens.length}). Ignoring tap instead of '
            'crashing. Did you add a nav destination without adding its '
            'screen to `screens`?',
      );
      return;
    }

    /* if (index == 2 || index == 3) {
      if (Get.find<AuthController>().isTokenNotNull == false) {
        AuthController.goToLogin();
        return;
      }
    }*/

    selectedIndex.value = index;
    LoggerHelper.instance.success('NavController: switched to index=$index');
  }

  void backToHome() {
    setIndex(0);
  }
  void goToStation() {
    selectedIndex.value = 2;
    Get.back();
  }
}