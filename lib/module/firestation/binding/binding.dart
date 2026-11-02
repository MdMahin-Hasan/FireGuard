
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';


class FirestationBinding extends Bindings {

  @override
  void dependencies() {

    debugPrint("Profile Binding Loaded");

    Get.lazyPut<FireStationController>(() => FireStationController());

  }
}