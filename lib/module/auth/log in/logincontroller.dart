import 'package:firedetection_system/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/service/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService;

  LoginController(this._authService);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final obscurePassword = true.obs;

  Future<void> submit() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      errorMessage.value = 'Enter your email and password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!result.success) {
        errorMessage.value =
            result.errorMessage ?? 'Invalid email or password.';
        return;
      }

      // FCM token এখানে পাঠাতে হবে না:
      // AuthService._saveSession() আগেই PushNotificationHelper.registerToken() কল করে।

      Get.offAllNamed(AppRoutes.navbar);
    } catch (e) {
      errorMessage.value = 'Login failed. Please try again.';
      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToAcceptInvite() {
    Get.toNamed(AppRoutes.accept_invite);
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}