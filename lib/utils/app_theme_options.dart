import 'package:flutter/material.dart';

class AppThemeOptions {
  const AppThemeOptions({
    required this.mode,
    required this.labelKey,
    // required this.icon,
  });

  final ThemeMode mode;
  final String labelKey; // translation key
  // final IconData icon;

  static const light = AppThemeOptions(
    mode: ThemeMode.light,
    labelKey: 'light_mode',
    // icon: Icons.light_mode,
  );
  static const dark = AppThemeOptions(
    mode: ThemeMode.dark,
    labelKey: 'dark_mode',
    // icon: Icons.dark_mode,
  );

  static const supported = [light, dark];
}
