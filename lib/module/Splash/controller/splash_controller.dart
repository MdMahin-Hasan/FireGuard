import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../../../core/storage/auth_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (Get.currentRoute != AppRoutes.splash) return;

    // Skip the login screen entirely if a session was already saved -
    // the JWT has no refresh token and is valid until it expires
    // server-side, so there's no reason to make the user log in again
    // just because they reopened the app.
    final isLoggedIn = await AuthStorage.isLoggedIn();

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.navbar);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}