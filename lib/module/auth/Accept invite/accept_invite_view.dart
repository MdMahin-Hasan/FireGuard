/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Background.dart';
import 'accept_invite_controller.dart';


class AcceptInviteView extends GetView<AcceptInviteController> {
  const AcceptInviteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("You're invited",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('Set up your account to join this device.'),
              const SizedBox(height: 20),

              CustomTextField(
                controller: controller.nameController,
                label: 'Full name',
                icon: Icons.person_outline,
              ),
              CustomTextField(
                controller: controller.passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
                helperText: "You'll be signed in right after this.",
              ),
              const SizedBox(height: 12),

              Obx(() => controller.errorMessage.value != null
                  ? Text(controller.errorMessage.value!,
                  style: const TextStyle(color: Colors.red))
                  : const SizedBox.shrink()),

              const SizedBox(height: 12),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submit,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Accept and join'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}*/