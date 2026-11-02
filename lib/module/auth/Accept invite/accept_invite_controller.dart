import 'package:firedetection_system/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/auth_service.dart';

class AcceptInviteController extends GetxController {
  final AuthService _authService;
  AcceptInviteController(this._authService);

  late final String invitationToken;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      invitationToken = args;
    } else {
      invitationToken = '';
      // No token means the deep link was malformed or opened without one.
      errorMessage.value = 'This invite link looks invalid. Ask the owner to resend it.';
    }
  }

  Future<void> submit() async {
    if (invitationToken.isEmpty) {
      errorMessage.value = 'This invite link looks invalid. Ask the owner to resend it.';
      return;
    }

    if (nameController.text.trim().isEmpty || passwordController.text.length < 8) {
      errorMessage.value = 'Enter your name and a password of at least 8 characters.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _authService.acceptInvite(
      token: invitationToken,
      name: nameController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (result.success) {
      Get.offAllNamed(AppRoutes.navbar);
    } else {
      errorMessage.value = result.errorMessage ?? 'Could not accept this invite.';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}