import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The three bundled font families. Referring to them through these constants
/// means a typo becomes a compile error instead of a silent fallback to the
/// system font.
class AppFonts {
  AppFonts._();

  /// Wide, angular, techno. Big headings only — too heavy to read in bulk.
  static const String display = 'Orbitron';

  /// Condensed technical face. HUD labels, stat readouts, numbers.
  static const String hud = 'Rajdhani';

  /// Plain, highly legible sans. Actual body text.
  static const String body = 'Inter';
}

/// All text styles in one place.
///
/// HUD labels are uppercase with wide letter-spacing; that spacing is what
/// sells the "machine readout" feel more than the font choice itself.
class AppTextStyles {
  AppTextStyles._();

  /// Big screen title, e.g. "DAILY QUESTS".
  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 3.5,
    height: 1.2,
  );

  /// Panel headings, e.g. a category name.
  static const TextStyle panelTitle = TextStyle(
    fontFamily: AppFonts.hud,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 2.4,
  );

  /// Small dim labels above a value, e.g. "HUNTER", "DAILY XP".
  static const TextStyle hudLabel = TextStyle(
    fontFamily: AppFonts.hud,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textDim,
    letterSpacing: 2.0,
  );

  /// Numeric readouts — XP counts, progress figures.
  static const TextStyle readout = TextStyle(
    fontFamily: AppFonts.hud,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
    // Tabular figures keep digits the same width, so a counter ticking
    // 9 -> 10 doesn't make the surrounding layout jitter.
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// The player's name in the status header.
  static const TextStyle hunterName = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
  );

  /// A quest's title — the one place we prioritise plain readability.
  static const TextStyle questTitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// The "+10 XP" badge on a quest row.
  static const TextStyle xpBadge = TextStyle(
    fontFamily: AppFonts.hud,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// General body copy.
  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
