import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/prefs.dart';
import 'package:money_planning_app/utils/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // Singleton pattern — ensures one instance is shared across controllers
  static SettingsController get to => Get.find<SettingsController>();

  final isLoggingOut = false.obs;

  // Available currency codes (canonical, always uppercase)
  final currencies = <String>['USD', 'KHR'].obs;

  // Selected currency code — canonical (USD / KHR), persisted to prefs
  final selectedCurrency = 'USD'.obs;

  final isDarkMode = false.obs;
  final language = 'en'.obs;
  final isNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCurrency.value = prefs.getString('settings_currency') ?? 'USD';
    language.value = prefs.getString('settings_language') ?? 'en';
    isDarkMode.value = prefs.getBool('settings_dark_mode') ?? false;
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
    }
    Get.updateLocale(Locale(language.value));
  }

  Future<void> setCurrency(String value) async {
    selectedCurrency.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_currency', value);
  }

  Future<void> toggleDarkMode(bool v) async {
    isDarkMode.value = v;
    Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_dark_mode', v);
  }

  Future<void> setLanguage(String code) async {
    language.value = code;
    Get.updateLocale(Locale(code));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_language', code);
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  /// Currency symbol helper
  String get currencySymbol =>
      selectedCurrency.value == 'KHR' ? '៛' : '\$';

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
