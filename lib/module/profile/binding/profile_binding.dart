import 'package:firedetection_system/module/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class ProfileBinding extends Bindings {

  @override
  void dependencies() {

    debugPrint("Profile Binding Loaded");

    Get.lazyPut<ProfileController>(() => ProfileController());

  }
}