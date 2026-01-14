import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Available currencies (add more if you want)
  final currencies = <String>["KHR", "USD"].obs;

  // Selected currency
  final selectedCurrency = "KHR".obs;
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
    language.value = code; // "EN" / "KH"
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }
}
