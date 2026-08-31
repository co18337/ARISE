import 'package:flutter/material.dart';

/// Which look the app is wearing.
enum AppThemeMode {
  /// The original: near-black ground, electric cyan signature.
  dark('DARK'),

  /// Warm daylight: sand and cream ground, espresso text, amber rewards.
  warm('WARM'),

  /// Follow the phone's own light/dark setting.
  auto('AUTO');

  final String label;

  const AppThemeMode(this.label);
}

/// One complete set of colours.
///
/// Every colour in the app comes from here — nothing else should hardcode a
/// hex value, so the whole look can be retuned, or swapped wholesale, from one
/// file.
///
/// The palette is a value, not a namespace of constants, so a second one can
/// exist. What each colour MEANS is fixed across both palettes (see the notes
/// on each field); only the value changes. A warm theme that quietly used gold
/// for something other than reward would not be a theme, it would be a
/// different app.
@immutable
class AppPalette {
  /// Drives Material's own light/dark defaults for anything unstyled.
  final Brightness brightness;

  // --- Grounds.
  final Color background;
  final Color surface;
  final Color surfaceRaised;

  /// Fill for panels, semi-transparent so the grid backdrop shows through.
  final Color panelFill;

  /// The soft bloom behind the top of every screen.
  final Color bloom;

  /// The faint technical grid drawn behind everything.
  final Color grid;

  // --- The signature. "Normal / default / structural".
  final Color primary;
  final Color primaryBright;
  final Color primaryDim;

  // --- Accents. Each has exactly ONE meaning, in both palettes.
  /// Energy and progress.
  final Color accentPurple;

  /// Reward, claim, earned. Rare on purpose.
  final Color accentGold;

  /// Live / urgent.
  final Color accentMagenta;

  /// Penalties, misses, broken streaks.
  final Color danger;

  /// The unfilled part of a tiered bar — what there still is to earn.
  final Color remaining;

  // --- Text.
  final Color textPrimary;
  final Color textSecondary;
  final Color textDim;

  // --- Per-stat, reserved. Never decorative.
  final Color statStr;
  final Color statSta;
  final Color statDis;
  final Color statRec;

  const AppPalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.panelFill,
    required this.bloom,
    required this.grid,
    required this.primary,
    required this.primaryBright,
    required this.primaryDim,
    required this.accentPurple,
    required this.accentGold,
    required this.accentMagenta,
    required this.danger,
    required this.remaining,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDim,
    required this.statStr,
    required this.statSta,
    required this.statDis,
    required this.statRec,
  });

  bool get isDark => brightness == Brightness.dark;

  /// The original dark sci-fi HUD: near-black navy, electric cyan.
  static const AppPalette dark = AppPalette(
    brightness: Brightness.dark,
    background: Color(0xFF05070D),
    surface: Color(0xFF0A0F18),
    surfaceRaised: Color(0xFF111826),
    panelFill: Color(0x140E7FA8),
    bloom: Color(0x2211304A),
    grid: Color(0x0F22D3EE),
    primary: Color(0xFF22D3EE),
    primaryBright: Color(0xFF7DF9FF),
    primaryDim: Color(0xFF0E7490),
    accentPurple: Color(0xFFA855F7),
    accentGold: Color(0xFFFFC53D),
    accentMagenta: Color(0xFFF0389D),
    danger: Color(0xFFFF4D6D),
    remaining: Color(0xFF4ADE80),
    // Never pure #FFFFFF — too harsh on OLED.
    textPrimary: Color(0xFFE6F1FF),
    textSecondary: Color(0xFF8BA3BC),
    textDim: Color(0xFF52657C),
    statStr: Color(0xFFFF6B6B),
    statSta: Color(0xFF4ADE80),
    statDis: Color(0xFFA855F7),
    statRec: Color(0xFF22D3EE),
  );

  /// Warm daylight. Sand and cream ground, espresso text.
  ///
  /// Every accent is darkened until it carries its meaning against a light
  /// ground — the dark palette's neon values would be unreadable here. The
  /// signature stays a deep teal rather than becoming another amber: it has to
  /// contrast with a warm background, and it keeps gold meaning reward alone.
  static const AppPalette warm = AppPalette(
    brightness: Brightness.light,
    background: Color(0xFFF7EFE3),
    surface: Color(0xFFFFFBF3),
    surfaceRaised: Color(0xFFEFE2CE),
    // Near-opaque on light: a 92%-transparent panel simply vanishes on sand.
    panelFill: Color(0xE8FFFBF2),
    bloom: Color(0x22C9A227),
    grid: Color(0x140F6F63),
    primary: Color(0xFF0F6F63),
    primaryBright: Color(0xFF13907F),
    primaryDim: Color(0xFFB9CFC9),
    accentPurple: Color(0xFF6D28D9),
    accentGold: Color(0xFFB45309),
    accentMagenta: Color(0xFFBE185D),
    danger: Color(0xFFB91C1C),
    remaining: Color(0xFF15803D),
    textPrimary: Color(0xFF2B2118),
    textSecondary: Color(0xFF6B5844),
    textDim: Color(0xFF9C876C),
    statStr: Color(0xFFB91C1C),
    statSta: Color(0xFF15803D),
    statDis: Color(0xFF6D28D9),
    statRec: Color(0xFF0F6F63),
  );
}

/// The palette currently in force, reachable from anywhere.
///
/// A deliberate trade-off. The idiomatic Flutter answer is a ThemeExtension
/// read through `Theme.of(context)`, which scopes correctly and rebuilds only
/// what depends on it. That would mean threading a BuildContext through all
/// 160-odd colour references, including the static text styles and the
/// per-rank and per-stat colour extensions, which cannot take one.
///
/// Instead the active palette is a single global that [AppTheme] swaps, and
/// the app is rebuilt from the root on change. It costs the ability to render
/// two themes at once — which this app will never do — and buys a
/// call-site-compatible swap. Every accessor below is a GETTER, not a const,
/// which is what makes the swap take effect.
class AppColors {
  AppColors._(); // never instantiated — this is just a namespace

  static AppPalette _active = AppPalette.dark;

  /// The whole palette, for code that wants to branch on [AppPalette.isDark].
  static AppPalette get palette => _active;

  /// Swapped by AppTheme when the mode changes. The caller is responsible for
  /// rebuilding the tree afterwards.
  static void use(AppPalette palette) => _active = palette;

  static Color get background => _active.background;
  static Color get surface => _active.surface;
  static Color get surfaceRaised => _active.surfaceRaised;
  static Color get panelFill => _active.panelFill;
  static Color get bloom => _active.bloom;
  static Color get grid => _active.grid;

  static Color get primary => _active.primary;
  static Color get primaryBright => _active.primaryBright;
  static Color get primaryDim => _active.primaryDim;

  static Color get accentPurple => _active.accentPurple;
  static Color get accentGold => _active.accentGold;
  static Color get accentMagenta => _active.accentMagenta;
  static Color get danger => _active.danger;
  static Color get remaining => _active.remaining;

  static Color get textPrimary => _active.textPrimary;
  static Color get textSecondary => _active.textSecondary;
  static Color get textDim => _active.textDim;

  static Color get statStr => _active.statStr;
  static Color get statSta => _active.statSta;
  static Color get statDis => _active.statDis;
  static Color get statRec => _active.statRec;
}
