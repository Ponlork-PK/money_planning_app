import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/auth_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 100),
        color: BaseColors.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Welcome to\nMoney Planning App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 500,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 1),

                    TextFormField(
                      controller: controller.emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: BaseColors.inputFieldBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) return 'Email is required';
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: controller.passwordController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: BaseColors.inputFieldBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Password is required';
                        return null;
                      },
                    ),

                    // Error message
                    Obx(() {
                      final msg = controller.errorMessage.value;
                      if (msg.isEmpty) return const SizedBox.shrink();
                      return Text(
                        msg,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      );
                    }),

                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final loading = controller.isLoading.value;
                            return ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                      final email = controller.emailController.text.trim();
                                      final password = controller.passwordController.text;
                                      final success = await controller.signIn(email: email, password: password);
                                      if (success) {
                                        Get.offAllNamed(RoutesName.home);
                                      } else {
                                        // optional toast/snackbar
                                        final msg = controller.errorMessage.value.isEmpty
                                            ? "Login failed"
                                            : controller.errorMessage.value;
                                        Get.snackbar("Login", msg, snackPosition: SnackPosition.BOTTOM);
                                      }
                                    },
                              child: loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text("Get Start"),
                            );
                          }),
                        ),
                      ],
                    ),

                    const Spacer(flex: 4),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
