import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';
import 'accept_invite_controller.dart';
import '../../../core/network/api_client.dart';

class AcceptInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<AcceptInviteController>(
          () => AcceptInviteController(Get.find<AuthService>()),
    );
  }
}