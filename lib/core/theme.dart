import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color fire = Color(0xFF10B981);
  static const Color emerald = Color(0xFF10B981);
  static const Color green = Color(0xFF059669);
  static const Color gold = Color(0xFFF59F00);
  static const Color red = Color(0xFF047857);
  static const Color ink = Color(0xFF0B1410);
  static const Color pitch = Color(0xFF16A34A);
  static const Color booked = Color(0xFF64748B);
}

class AppTheme {
  const AppTheme._();

  static const String _fontFamily = 'Times New Roman';

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background =
        isDark ? const Color(0xFF0B1410) : const Color(0xFFF2F7F4);
    final surface = isDark ? const Color(0xFF13211B) : const Color(0xFFFFFFFF);
    final outline = isDark ? const Color(0xFF233A30) : const Color(0xFFD1E2D8);

    final baseTextTheme =
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    final romanTextTheme = baseTextTheme.apply(
      fontFamily: _fontFamily,
      bodyColor: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
      displayColor: isDark ? Colors.white : const Color(0xFF0F172A),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.emerald,
      onPrimary: isDark ? const Color(0xFF052E16) : Colors.white,
      secondary: AppColors.green,
      surface: surface,
      surfaceContainerLow: surface,
      outlineVariant: outline,
      primaryContainer:
          isDark ? const Color(0xFF143829) : const Color(0xFFD1FAE5),
      onPrimaryContainer:
          isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      textTheme: romanTextTheme,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: isDark ? const Color(0xFF052E16) : Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emerald,
          side: const BorderSide(color: AppColors.emerald, width: 1.5),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.emerald,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
