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

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background =
        isDark ? const Color(0xFF0F1114) : const Color(0xFFF6F4F1);
    final surface = isDark ? const Color(0xFF1A1D22) : Colors.white;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.fire,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.fire,
      onPrimary: Colors.white,
      secondary: AppColors.green,
      surface: surface,
      surfaceContainerLow: surface,
      outlineVariant:
          isDark ? const Color(0xFF2E333A) : const Color(0xFFE3DED8),
      primaryContainer:
          isDark ? const Color(0xFF3A1F10) : const Color(0xFFFFE8D9),
      onPrimaryContainer: AppColors.fire,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
      ),
      snackBarTheme:
          const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface),
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
