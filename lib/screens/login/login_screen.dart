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
            Text(
              "welcomeTitle".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                        labelText: "emailLabel".tr,
                      ),
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) return 'emailRequired'.tr;
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
                        labelText: "passwordLabel".tr,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'passwordRequired'.tr;
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
                                      if (!formKey.currentState!.validate()) return;
                                      final email = controller.emailController.text.trim();
                                      final password = controller.passwordController.text;
                                      final success = await controller.signIn(email: email, password: password);
                                      if (success) {
                                        Get.offAllNamed(RoutesName.home);
                                      } else {
                                        final msg = controller.errorMessage.value.isEmpty
                                            ? "loginFailed".tr
                                            : controller.errorMessage.value;
                                        Get.snackbar("login".tr, msg, snackPosition: SnackPosition.BOTTOM);
                                      }
                                    },
                              child: loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text("getStart".tr),
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
