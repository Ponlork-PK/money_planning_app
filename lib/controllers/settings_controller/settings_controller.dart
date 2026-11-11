import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/controllers/locale_controller.dart';
import 'package:money_planning_app/controllers/theme_controller.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/prefs.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Singleton pattern — ensures one instance is shared across controllers
  static SettingsController get to => Get.find<SettingsController>();
  final themeController = ThemeController.to;
  final localeController = LocaleController.to;

  final isLoggingOut = false.obs;

  // Available currency codes (canonical, always uppercase)
  final currencies = <String>['USD', 'KHR'].obs;

  // Selected currency code — canonical (USD / KHR), persisted to prefs
  final selectedCurrency = 'USD'.obs;

  final isNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCurrency.value = prefs.getString('settings_currency') ?? 'USD';
  }

  Future<void> setCurrency(String value) async {
    selectedCurrency.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_currency', value);
  }

  bool get isDarkMode => themeController.isDark;

  Future<void> toggleDarkMode(bool isDark) =>
      themeController.changeTheme(isDark ? ThemeMode.dark : ThemeMode.light);

  String get languageCode => localeController.current.value.languageCode;

  Future<void> setLanguage(String? code) =>
      localeController.changeLanguageByCode(code);

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  /// Currency symbol helper
  String get currencySymbol => selectedCurrency.value == 'KHR' ? '៛' : '\$';

  /// Sign out — clears local session and navigates to login.
  Future<void> logout() async {
    try {
      isLoggingOut.value = true;
      await ApiService().signOut();
      await Prefs.logOut();
      Get.offAllNamed(RoutesName.login);
      Get.snackbar(
        'loggedOut'.tr,
        'loggedOutMessage'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
