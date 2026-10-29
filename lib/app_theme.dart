import 'package:flutter/material.dart';

// Warna merek (dipakai bersama oleh seluruh tampilan).
const Color forest = Color(0xFF176B52);
const Color mint = Color(0xFFDDF5DF);
const Color sky = Color(0xFFBCE8FF);
const Color ink = Color(0xFF183B35);
const Color orange = Color(0xFFFFB85C);

/// Palet warna terpusat untuk mode terang & gelap.
///
/// Semua widget cukup memanggil `AppPalette.of(context)` sehingga tidak perlu
/// lagi menulis percabangan `isDark ? ... : ...` di setiap tempat.
class AppPalette {
  final bool isDark;
  final Color background;
  final List<Color> backgroundGradient;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color warnBackground;
  final Color warnBorder;
  final Color warnText;
  final Color warnIcon;

  const AppPalette._({
    required this.isDark,
    required this.background,
    required this.backgroundGradient,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.warnBackground,
    required this.warnBorder,
    required this.warnText,
    required this.warnIcon,
  });

  static const AppPalette light = AppPalette._(
    isDark: false,
    background: Color(0xFFF4F8F1),
    backgroundGradient: [Color(0xFFF7FBF5), Color(0xFFEEF7F1), Color(0xFFFFF8EA)],
    surface: Colors.white,
    surfaceAlt: Color(0xFFEAF4E8),
    border: Color(0xFFDDE8DF),
    textPrimary: ink,
    textSecondary: Color(0xFF5B7067),
    accent: forest,
    accentSoft: Color(0xFFE3F2E6),
    onAccent: Colors.white,
    warnBackground: Color(0xFFFFF0E8),
    warnBorder: Color(0xFFFFD1BE),
    warnText: Color(0xFF75402F),
    warnIcon: Color(0xFFD9663F),
  );

  static const AppPalette dark = AppPalette._(
    isDark: true,
    background: Color(0xFF0F1A17),
    backgroundGradient: [Color(0xFF0F1A17), Color(0xFF14241D), Color(0xFF1B2219)],
    surface: Color(0xFF1A2924),
    surfaceAlt: Color(0xFF233630),
    border: Color(0xFF2B403A),
    textPrimary: Color(0xFFE6F1EB),
    textSecondary: Color(0xFFA9BDB3),
    accent: Color(0xFF6FD6B0),
    accentSoft: Color(0xFF244A3C),
    onAccent: Color(0xFF08261B),
    warnBackground: Color(0xFF3A2621),
    warnBorder: Color(0xFF7D4C3F),
    warnText: Color(0xFFFFD9CC),
    warnIcon: Color(0xFFFF9B78),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  /// Bayangan lembut untuk kartu (dihilangkan di mode gelap).
  List<BoxShadow> get cardShadow => isDark
      ? const []
      : const [
          BoxShadow(
            color: Color(0x14173D2D),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ];
}

ThemeData buildAppTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? AppPalette.dark : AppPalette.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: forest,
    brightness: brightness,
  ).copyWith(
    primary: p.accent,
    onPrimary: p.onAccent,
    surface: p.surface,
    onSurface: p.textPrimary,
    onSurfaceVariant: p.textSecondary,
    outline: p.border,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    cardColor: p.surface,
    fontFamily: 'Roboto',
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.accent,
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),
  );
}
