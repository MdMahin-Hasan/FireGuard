import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Background.dart';
import 'logincontroller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(

      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // ============================================================
            // MAIN LOGIN SCREEN
            // ============================================================
            Background(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==================================================
                    // LOGIN TITLE
                    // ==================================================
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: width < 400 ? 25 : 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2661FA),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==================================================
                    // EMAIL
                    // ==================================================
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
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
                    // ERROR MESSAGE
                    // ==================================================
                    Obx(
                          () => controller.errorMessage.value != null
                          ? Text(
                        controller.errorMessage.value!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // LOGIN BUTTON
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
                          'LOG IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ==================================================
                    // GO TO REGISTER
                    // ==================================================
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: const Text(
                        "Don't Have an Account? Sign up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
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
            Obx(
                  () => controller.isLoading.value
                  ? Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}