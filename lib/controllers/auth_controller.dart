import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/locale_controller.dart';
import 'package:money_planning_app/controllers/theme_controller.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/app_languages.dart';
import 'package:money_planning_app/utils/app_theme_options.dart';
import 'package:money_planning_app/utils/prefs.dart';
import 'package:money_planning_app/widgets/base_bottom_sheet.dart';
import 'package:money_planning_app/widgets/base_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final localeController = LocaleController.to;
  final _themeController = ThemeController.to;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Auth state
  final isLoggedIn = false.obs;

  late final RxString selectedCode =
      localeController.current.value.languageCode.obs;

  late final Rx<ThemeMode> selectedMode = _themeController.current.value.obs;

  ThemeMode get appliedMode => _themeController.current.value;
  bool get isDarkMode => appliedMode == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadLocalSession();
  }

  Future<void> _loadLocalSession() async {
    isLoggedIn.value = await Prefs.isLoggedIn();
  }

  /// Sign in via Supabase — validates credentials against real users.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Basic client-side validation
      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password are required.';
        return false;
      }

      // Show circle progress indicator
      BaseDialog().showCilcleProgress();

      // ✅ Authenticate with Supabase
      final response = await ApiService().signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        // Close circle progress
        Get.back();
        errorMessage.value = 'Login failed. Please check your credentials.';
        return false;
      }

      // ✅ Save session locally
      await Prefs.saveLogin(
        userId: response.user!.id,
        email: response.user!.email ?? email,
      );
      isLoggedIn.value = true;

      // Close circle progress
      Get.back();
      return true;
    } on Exception catch (e) {
      // Close circle progress
      Get.back();
      // Parse Supabase error messages into user-friendly text
      final raw = e.toString();
      if (raw.contains('Invalid login credentials') ||
          raw.contains('invalid_credentials')) {
        errorMessage.value = 'Incorrect email or password.';
      } else if (raw.contains('Email not confirmed')) {
        errorMessage.value = 'Please confirm your email before logging in.';
      } else if (raw.contains('too many requests') ||
          raw.contains('rate limit')) {
        errorMessage.value = 'Too many attempts. Please try again later.';
      } else {
        errorMessage.value = 'Login failed. Please try again.';
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out — clears Supabase session and local storage.
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // ✅ Sign out from Supabase
      await ApiService().signOut();

      // ✅ Clear local session
      await Prefs.logOut();
      isLoggedIn.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // The function for change Language
  Future<void> onPressedLanguage(BuildContext context) {
    return BaseBottomSheet.show(
        context: context,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      selectedCode.value =
                          prefs.getString("settings_language") ?? '';
                      Get.back();
                    },
                    child: Text("back".tr)),
                TextButton(
                    onPressed: () => applyChange(), child: Text("done".tr)),
              ],
            ),
          ),
          Obx(
            () => RadioGroup<String>(
              groupValue: selectedCode.value,
              onChanged: selectLanguage,
              child: Column(
                children: List.generate(2, (index) {
                  final lang = AppLanguages.supported[index];
                  return RadioListTile<String>(
                    value: lang.languageCode,
                    title: Text(
                      lang.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }),
              ),
            ),
          )
        ]);
  }

  // Just selected but not change yet
  void selectLanguage(String? code) {
    if (code != null) selectedCode.value = code;
  }

  Future<void> applyChange() async {
    final code = selectedCode.value;
    Get.back(); // close the sheet first to avoid a visible rebuild behind it
    await localeController.changeLanguageByCode(code);
  }

  // The function for change Theme mode
  Future<void> onPressedTheme(BuildContext context) {
    selectedMode.value = appliedMode;
    return BaseBottomSheet.show(
        context: context,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Get.back(), child: Text("back".tr)),
                TextButton(
                    onPressed: () => applyThemeChange(),
                    child: Text("done".tr)),
              ],
            ),
          ),
          Obx(
            () => RadioGroup<ThemeMode>(
              groupValue: selectedMode.value,
              onChanged: selectThemeMode,
              child: Column(
                children: List.generate(2, (index) {
                  final theme = AppThemeOptions.supported[index];
                  return RadioListTile<ThemeMode>(
                    value: theme.mode,
                    title: Text(
                      theme.labelKey.tr,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  );
                }),
              ),
            ),
          )
        ]);
  }

  void selectThemeMode(ThemeMode? mode) {
    if (mode != null) selectedMode.value = mode;
  }

  Future<void> applyThemeChange() async {
    Get.back();
    await _themeController.changeTheme(selectedMode.value);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
