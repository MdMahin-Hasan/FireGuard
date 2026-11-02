import 'package:firedetection_system/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';
import '../log in/logincontroller.dart';



class RegisterController extends GetxController {
  final AuthService _authService;
  RegisterController(this._authService);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final deviceIdController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> submit() async {
    if (deviceIdController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.length < 8) {
      errorMessage.value = 'Fill every field — password needs 8+ characters.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _authService.registerOwner(
      deviceId: deviceIdController.text.trim(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (isClosed) return;

    isLoading.value = false;

    if (result.success) {
      Get.offNamed(AppRoutes.login);
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Something went wrong.';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    deviceIdController.dispose();
    super.onClose();
  }
}