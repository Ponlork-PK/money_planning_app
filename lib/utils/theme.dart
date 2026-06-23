import 'package:flutter/material.dart';
import 'package:money_planning_app/utils/base_colors.dart';

/// App theme
class AppTheme {

  /// LIGHT THEME
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: BaseColors.primary,
      brightness: Brightness.light,
      primary: BaseColors.primary,
      secondary: BaseColors.income,
      error: BaseColors.expense,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BaseColors.background,
      // fontFamily: 'SF Pro Display',
    );

    return base.copyWith(
      primaryColor: BaseColors.primary,

      // ===== AppBar =====
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: BaseColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: BaseColors.appBarTitle
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // ===== Bottom Navigation =====
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: BaseColors.primary,
        unselectedItemColor: BaseColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
      ),

      // ===== Cards =====
      cardTheme: CardThemeData(
        color: BaseColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: BaseColors.itemIconBg, width: 1),
        ),
      ),

      // ===== Buttons =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BaseColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ===== Text fields =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BaseColors.itemIconBg, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BaseColors.itemIconBg, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BaseColors.primary, width: 1.4),
        ),
        hintStyle: const TextStyle(
          color: BaseColors.textSecondary,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: BaseColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // ===== Chips =====
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: BaseColors.primary,
        disabledColor: BaseColors.itemIconBg,
        labelStyle: const TextStyle(
          color: BaseColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: BaseColors.itemIconBg),
        ),
      ),

      // ===== Text styles =====
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: BaseColors.textPrimary,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: BaseColors.textPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: BaseColors.textPrimary,
        ),
        bodyLarge: const TextStyle(fontSize: 22),
        bodyMedium: const TextStyle(fontSize: 18, color: BaseColors.textPrimary),
        bodySmall: const TextStyle(fontSize: 16, color: BaseColors.textSecondary),
      ),

      dividerColor: BaseColors.divider,
      iconTheme: const IconThemeData(color: BaseColors.textPrimary),
    );
  }

  /// DARK THEME
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: BaseColors.primary,
      brightness: Brightness.dark,
      primary: BaseColors.primary,
      secondary: BaseColors.income,
      error: BaseColors.expense,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BaseColors.darkBackground,
      // fontFamily: 'SF Pro Display',
    );

    return base.copyWith(
      primaryColor: BaseColors.primary,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: BaseColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: BaseColors.darkCard,
        selectedItemColor: BaseColors.primary,
        unselectedItemColor: BaseColors.darkTextSecondary,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
      ),

      cardTheme: CardThemeData(
        color: BaseColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side:
          const BorderSide(color: BaseColors.darkCardBorder, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BaseColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BaseColors.primaryLight,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BaseColors.darkCard,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: BaseColors.darkCardBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: BaseColors.darkCardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
          const BorderSide(color: BaseColors.primary, width: 1.4),
        ),
        hintStyle: const TextStyle(
          color: BaseColors.darkTextSecondary,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: BaseColors.darkTextSecondary,
          fontSize: 14,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: BaseColors.darkCard,
        selectedColor: BaseColors.primary,
        disabledColor: BaseColors.darkCardBorder,
        labelStyle: const TextStyle(
          color: BaseColors.darkTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: BaseColors.darkCardBorder),
        ),
      ),

      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: BaseColors.darkTextPrimary,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: BaseColors.darkTextPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: BaseColors.darkTextPrimary,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BaseColors.darkTextPrimary,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          color: BaseColors.darkTextSecondary,
        ),
      ),

      dividerColor: BaseColors.darkDivider,
      iconTheme: const IconThemeData(color: BaseColors.darkTextPrimary),
    );
  }
}
