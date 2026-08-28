import 'package:flutter/material.dart';

import '../models/models.dart';
import 'app_colors.dart';

/// Maps each stat to its signature colour, so a panel or bar can be
/// colour-coded by the stat it feeds. Phase 4's STATUS screen will lean on
/// this heavily; using it now means the colour language is already learned by
/// the time the stats themselves exist.
extension StatTypeColor on StatType {
  Color get color {
    switch (this) {
      case StatType.str:
        return AppColors.statStr;
      case StatType.sta:
        return AppColors.statSta;
      case StatType.dis:
        return AppColors.statDis;
      case StatType.rec:
        return AppColors.statRec;
    }
  }

  /// Three-letter label as shown in the HUD.
  String get label => name.toUpperCase();
}
