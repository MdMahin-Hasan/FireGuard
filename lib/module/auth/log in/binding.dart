import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';
import '../../../core/network/api_client.dart';
import 'logincontroller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(Get.find<AuthService>()));
  }
}