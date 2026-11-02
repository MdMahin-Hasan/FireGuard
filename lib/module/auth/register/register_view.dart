import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Background.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // ============================================================
            // MAIN REGISTER SCREEN
            // ============================================================
            Background(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==================================================
                    // REGISTER TITLE
                    // ==================================================
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: width < 400 ? 25 : 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2661FA),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // FULL NAME
                    // ==================================================
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // EMAIL
                    // ==================================================
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // PASSWORD
                    // ==================================================
                    TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // DEVICE ID
                    // ==================================================
                    TextField(
                      controller: controller.deviceIdController,
                      decoration: const InputDecoration(
                        labelText: 'Device ID',
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // ERROR MESSAGE
                    // ==================================================
                    Obx(
                          () => controller.errorMessage.value != null
                          ? Text(
                        controller.errorMessage.value!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 20),
                    // ==================================================
                   // SIGN UP BUTTON
                  // ==================================================
                    GestureDetector(
                      onTap: () {
                        if (!controller.isLoading.value) {
                          controller.submit();
                        }
                      },
                      child: Container(
                        width: width < 600 ? width * 0.4 : 220,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE5252A),
                              Color(0xFFB51218),
                            ],
                          ),
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ============================================================
            // FULL SCREEN LOADING OVERLAY
            // ============================================================
            Positioned.fill(
              child: Obx(
                    () => Visibility(
                  visible: controller.isLoading.value,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: false,
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}