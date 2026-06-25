import 'package:flutter/material.dart';

class AppColors {
  static const canvas = Color(0xFFF8F7F4);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1B6B5A);
  static const primarySoft = Color(0xFFE8F5F0);
  static const amber = Color(0xFFC67A1A);
  static const amberSoft = Color(0xFFFFF3E8);
  static const red = Color(0xFFC62828);
  static const redSoft = Color(0xFFFFF0F0);
  static const blue = Color(0xFF1565C0);
  static const blueSoft = Color(0xFFE3F2FD);
  static const purple = Color(0xFF6A1B9A);
  static const purpleSoft = Color(0xFFF3E5F5);
  static const ink = Color(0xFF1C1C1E);
  static const ink2 = Color(0xFF636366);
  static const ink3 = Color(0xFFAEAEB2);
  static const border = Color(0xFFE5E5EA);
  static const surface = Color(0xFFF0F0F0);

  // Member avatar colors (auto-assigned)
  static const memberColors = [
    Color(0xFF1B6B5A),
    Color(0xFF6B4C1B),
    Color(0xFF5A1B6B),
    Color(0xFFC67A1A),
    Color(0xFF1565C0),
    Color(0xFFC62828),
    Color(0xFF2E7D32),
    Color(0xFF4E342E),
  ];
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        error: AppColors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.ink3,
        ),
        labelSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.ink2,
          letterSpacing: 0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
        space: 0,
      ),
    );
  }
}
