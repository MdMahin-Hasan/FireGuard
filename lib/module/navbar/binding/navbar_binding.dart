import 'package:firedetection_system/module/Alert/binding/Alertbinding.dart';
import 'package:firedetection_system/module/firestation/binding/binding.dart';
import 'package:firedetection_system/module/profile/binding/profile_binding.dart';
import 'package:get/get.dart';

import '../../home/binding/homebinding.dart';
import '../controller/navbar_controller.dart';


class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(() => NavController());
    HomeBinding().dependencies();
    AlertBinding().dependencies();
    FirestationBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
