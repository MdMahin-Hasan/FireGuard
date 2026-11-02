import 'package:firedetection_system/module/Alert/controller/AlertController.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


class AlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertController>(() => AlertController());
  }
}