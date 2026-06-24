import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/services/api_service.dart';
import 'package:money_planning_app/utils/prefs.dart';
import 'package:money_planning_app/utils/routes_name.dart';

class SettingsController extends GetxController {
  final isLoggingOut = false.obs;
  // Available currencies (add more if you want)
  final currencies = <String>["khr".tr, "usd".tr].obs;

  // Selected currency
  final selectedCurrency = "khr".tr.obs;
  final isDarkMode = false.obs;     // toggle
  final language = "EN".obs;        // "EN" or "KH"
  // Notification toggle
  final isNotificationEnabled = true.obs;

  void setCurrency(String value) {
    selectedCurrency.value = value;
  }

  void toggleDarkMode(bool v) {
    isDarkMode.value = v;

    // optional: apply app theme
    Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String code) {
    language.value = code; // 'en' or 'km'
    Get.updateLocale(Locale(code));
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  /// Sign out — clears local session and navigates to login.
  Future<void> logout() async {
    try {
      isLoggingOut.value = true;

      // ✅ Sign out from Supabase first
      await ApiService().signOut();

      await Prefs.logOut();

      // Navigate to login and clear the entire nav stack
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
