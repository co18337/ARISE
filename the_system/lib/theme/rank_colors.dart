import 'package:flutter/material.dart';

import '../game/rank.dart';
import 'app_colors.dart';

/// Rank colours, escalating from dim grey to gold so that climbing a rank
/// reads instantly even out of the corner of your eye.
///
/// Kept out of lib/game/ deliberately — the game engine stays free of Flutter
/// imports. Same split as StatTypeColor in stat_colors.dart.
extension RankColor on Rank {
  Color get color {
    switch (this) {
      case Rank.e:
        return AppColors.textSecondary;
      case Rank.d:
        return AppColors.statSta;
      case Rank.c:
        return AppColors.primary;
      case Rank.b:
        return AppColors.accentPurple;
      case Rank.a:
        return AppColors.statStr;
      case Rank.s:
        return AppColors.accentGold;
    }
  }
}
