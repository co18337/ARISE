import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// The app-wide [ThemeData], built from an [AppPalette].
class AppTheme {
  AppTheme._();

  /// Builds the Material theme for [palette] — and installs it as the active
  /// palette first.
  ///
  /// The install is a deliberate side effect. [AppTextStyles] and every widget
  /// read colours through the AppColors facade rather than through
  /// `Theme.of(context)`, so the global has to be swapped before anything is
  /// built with it. Call this from the root and rebuild; see the note in
  /// app_colors.dart for why it works this way.
  static ThemeData build(AppPalette palette) {
    AppColors.use(palette);

    // Start from Material's matching baseline so any widget we haven't
    // explicitly styled still lands on sensible defaults.
    final ThemeData base = palette.isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      colorScheme: ColorScheme(
        brightness: palette.brightness,
        primary: palette.primary,
        secondary: palette.accentPurple,
        tertiary: palette.accentGold,
        surface: palette.surface,
        error: palette.danger,
        onPrimary: palette.background,
        onSecondary: palette.background,
        onTertiary: palette.background,
        onSurface: palette.textPrimary,
        onError: palette.background,
      ),
      // Inter is the default for anything we haven't styled explicitly.
      textTheme: base.textTheme.apply(
        fontFamily: AppFonts.body,
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.display,
      ),
      dividerTheme: DividerThemeData(
        color: palette.primaryDim,
        thickness: 1,
        space: 1,
      ),
      // Ripples on a dark HUD look like smudges; a faint wash in the signature
      // colour reads much better than Material's default grey splash.
      splashColor: palette.primary.withValues(alpha: 0.08),
      highlightColor: palette.primary.withValues(alpha: 0.05),
    );
  }

  static ThemeData get dark => build(AppPalette.dark);
  static ThemeData get warm => build(AppPalette.warm);

  /// The palette a mode resolves to, given what the phone is currently doing.
  ///
  /// [AppThemeMode.auto] is the reason this takes a brightness at all: the
  /// other two ignore it.
  static AppPalette paletteFor(AppThemeMode mode, Brightness platform) =>
      switch (mode) {
        AppThemeMode.dark => AppPalette.dark,
        AppThemeMode.warm => AppPalette.warm,
        AppThemeMode.auto =>
          platform == Brightness.dark ? AppPalette.dark : AppPalette.warm,
      };
}
