import 'package:flutter/material.dart';

/// Brand colors inspired by Newroz (fire, spring and the Kurdish flag).
class AppColors {
  const AppColors._();

  static const Color fire = Color(0xFFE8590C);
  static const Color green = Color(0xFF2B8A3E);
  static const Color gold = Color(0xFFF59F00);
  static const Color red = Color(0xFFC92A2A);
  static const Color ink = Color(0xFF1B1F23);
  static const Color pitch = Color(0xFF2F9E44);
  static const Color booked = Color(0xFF9AA0A6);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.fire,
      primary: AppColors.fire,
      secondary: AppColors.green,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF6F4F1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
