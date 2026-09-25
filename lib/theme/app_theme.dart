import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const flutterBlue = Color(0xFF0175C2);
  static const List<Color> heroGradient = [
    Color(0xFF02569B),
    Color(0xFF0175C2),
    Color(0xFF13B9FD),
  ];

  static const success = Color(0xFF22C55E);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  // สีของกล่องโค้ด (โทนเดียวกับ editor ธีมมืด)
  static const codeBackground = Color(0xFF1E1E2E);
  static const codeText = Color(0xFFCDD6F4);
  static const codeKeyword = Color(0xFFCBA6F7);
  static const codeString = Color(0xFFA6E3A1);
  static const codeComment = Color(0xFF7F849C);
  static const codeNumber = Color(0xFFFAB387);
  static const codeType = Color(0xFFF9E2AF);
  static const codeFunction = Color(0xFF89B4FA);
  static const codeAnnotation = Color(0xFFF38BA8);
}

class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.flutterBlue,
      brightness: brightness,
    );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final textTheme = GoogleFonts.promptTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0F1420) : const Color(0xFFF4F7FC),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF151B2B) : Colors.white,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

/// ทางลัดสำหรับเรียกใช้ Theme ให้โค้ดสั้นลง เช่น `context.colors.primary`
extension ThemeShortcuts on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardColor => isDark ? const Color(0xFF1A2133) : Colors.white;
}
