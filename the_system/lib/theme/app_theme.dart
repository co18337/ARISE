import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// The app-wide [ThemeData]. Built once in main.dart and handed to
/// MaterialApp, so every screen inherits the System look without repeating
/// colours or fonts.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    // Start from Material's dark baseline so any widget we haven't explicitly
    // styled still lands on sensible dark defaults rather than light ones.
    final ThemeData base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accentPurple,
        tertiary: AppColors.accentGold,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
      ),
      // Inter is the default for anything we haven't styled explicitly.
      textTheme: base.textTheme
          .apply(
            fontFamily: AppFonts.body,
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.display,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.primaryDim,
        thickness: 1,
        space: 1,
      ),
      // Ripples on a dark HUD look like smudges; a faint cyan wash reads
      // much better than Material's default grey splash.
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.05),
    );
  }
}
