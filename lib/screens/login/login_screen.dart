import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/auth_controller.dart';
import 'package:money_planning_app/utils/base_colors.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:money_planning_app/widgets/base_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Allow the scaffold to resize when the keyboard appears
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final formMinHeight = screenHeight * 0.55;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: Container(
          width: double.infinity,
          color: BaseColors.primary,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ── Welcome text (primary-color area) ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "welcomeTitle".tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      color: BaseColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ── White card (form area) ──
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: formMinHeight),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: controller.emailController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSurface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "emailLabel".tr,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'emailRequired'.tr;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: controller.passwordController,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.onSurface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "passwordLabel".tr,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                            obscureText: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'passwordRequired'.tr;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // Error message
                          Obx(() {
                            final msg = controller.errorMessage.value;
                            if (msg.isEmpty) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                msg,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),

                          Obx(() {
                            final loading = controller.isLoading.value;
                            return BaseButton(
                              text: "getStart".tr,
                              onPressed: loading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate())
                                        return;
                                      final email = controller
                                          .emailController.text
                                          .trim();
                                      final password =
                                          controller.passwordController.text;
                                      final success = await controller.signIn(
                                          email: email, password: password);
                                      if (success) {
                                        Get.offAllNamed(RoutesName.home);
                                      } else {
                                        final msg = controller
                                                .errorMessage.value.isEmpty
                                            ? "loginFailed".tr
                                            : controller.errorMessage.value;
                                        Get.snackbar("login".tr, msg,
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
