import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../Alert/controller/AlertController.dart';
import '../controller/homecontroller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AlertController>(() => AlertController());
  }
}