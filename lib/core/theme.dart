import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  const AppColors._();

  static const Color emerald = Color(0xFFC8102E);
  static const Color crimsonDark = Color(0xFF8B0018);
  static const Color fire = Color(0xFFC8102E);
  static const Color red = Color(0xFFC8102E);
  static const Color gold = Color(0xFFD97706);
  static const Color ink = Color(0xFF1F2937);
  static const Color green = Color(0xFF15803D);
  static const Color pitch = Color(0xFF16A34A);
  static const Color pitchGreen = Color(0xFF15803D);
  static const Color booked = Color(0xFF9CA3AF);
}

class AppTheme {
  const AppTheme._();

  static TextTheme _textTheme(TextTheme base, {bool isRtl = false}) {
    if (isRtl) {
      return GoogleFonts.notoSansArabicTextTheme(base);
    }
    final serif = GoogleFonts.playfairDisplayTextTheme(base);
    return serif.copyWith(
      headlineLarge: serif.headlineLarge?.copyWith(fontStyle: FontStyle.italic),
      headlineMedium: serif.headlineMedium?.copyWith(fontStyle: FontStyle.italic),
      headlineSmall: serif.headlineSmall?.copyWith(fontStyle: FontStyle.italic),
      titleLarge: serif.titleLarge?.copyWith(fontStyle: FontStyle.italic),
      titleMedium: serif.titleMedium?.copyWith(fontStyle: FontStyle.italic),
      labelLarge: serif.labelLarge?.copyWith(fontStyle: FontStyle.italic),
      bodyMedium: serif.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
      bodySmall: serif.bodySmall?.copyWith(fontStyle: FontStyle.italic),
    );
  }

  static ThemeData lightFor({bool isRtl = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      primary: AppColors.emerald,
      secondary: AppColors.ink,
      surface: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = _textTheme(base.textTheme, isRtl: isRtl);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFFF8F6F6),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8F6F6),
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: const Color(0xFF111827),
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emerald,
          side: const BorderSide(color: AppColors.emerald),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.emerald.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.all(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData darkFor({bool isRtl = false}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.emerald,
      primary: const Color(0xFFEF4444),
      secondary: const Color(0xFFF3F4F6),
      surface: const Color(0xFF181A20),
      brightness: Brightness.dark,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = _textTheme(base.textTheme, isRtl: isRtl);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFF101216),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF101216),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF181A20),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF181A20),
        indicatorColor: AppColors.emerald.withValues(alpha: 0.25),
        labelTextStyle: WidgetStateProperty.all(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData get light => lightFor();
  static ThemeData get dark => darkFor();
}
