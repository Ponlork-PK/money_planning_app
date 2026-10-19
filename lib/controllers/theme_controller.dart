import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeController(this._prefs);

  static ThemeController get to => Get.find();

  static const _storageKey = 'settings_dark_mode';
  final SharedPreferences _prefs;

  late final Rx<ThemeMode> current;

  bool get isDark => current.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    final isDark = _prefs.getBool(_storageKey) ?? false;
    current = (isDark ? ThemeMode.dark : ThemeMode.light).obs;
  }

  Future<void> changeTheme(ThemeMode mode) async {
    if (mode == current.value) return;
    current.value = mode;
    Get.changeThemeMode(mode); // real-time update
    await _prefs.setBool(_storageKey, mode == ThemeMode.dark);
  }
}
