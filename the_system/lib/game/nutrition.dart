/// What a day of eating is measured against, and how it adds up.
///
/// Pure, like the rest of lib/game — no database, no Flutter. The app totals
/// and displays; it does not interpret. Whether these targets are right for a
/// given person is a question for their doctor, not for this file.
library;

/// A running total of macros.
class MacroTotals {
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fibreG;

  const MacroTotals({
    this.kcal = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.fibreG = 0,
  });

  static const MacroTotals zero = MacroTotals();

  MacroTotals plus(MacroTotals other) => MacroTotals(
    kcal: kcal + other.kcal,
    proteinG: proteinG + other.proteinG,
    carbsG: carbsG + other.carbsG,
    fatG: fatG + other.fatG,
    fibreG: fibreG + other.fibreG,
  );

  /// Scales a meal by how much of it was actually eaten.
  MacroTotals scaled(double portions) => MacroTotals(
    kcal: (kcal * portions).round(),
    proteinG: proteinG * portions,
    carbsG: carbsG * portions,
    fatG: fatG * portions,
    fibreG: fibreG * portions,
  );

  bool get isEmpty => kcal == 0 && proteinG == 0;
}

/// The day's targets.
///
/// From the transformation plan and the measured body-composition scan: around
/// 2000 kcal against a measured BMR of 1713, and 100-120 g of protein to hold
/// muscle while losing fat. The protein figure is the one that matters most
/// here, which is why it is the first bar on the screen.
class NutritionTargets {
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fibreG;

  const NutritionTargets({
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fibreG,
  });

  /// The plan's numbers. Protein is the midpoint of the 100-120 g range; fat
  /// and fibre are conventional for the calorie target, and carbohydrate is
  /// whatever is left once the other two are paid for.
  static const NutritionTargets plan = NutritionTargets(
    kcal: 2000,
    proteinG: 110,
    carbsG: 255,
    fatG: 60,
    fibreG: 30,
  );

  /// Measured basal metabolic rate from the scan. Shown for context — eating
  /// below it is not a goal, and the app says so rather than leaving the
  /// number to be guessed at.
  static const int measuredBmr = 1713;
}

/// One macro's standing against its target.
class MacroProgress {
  final String label;
  final String unit;
  final double value;
  final double target;

  const MacroProgress({
    required this.label,
    required this.unit,
    required this.value,
    required this.target,
  });

  double get fraction => target <= 0 ? 0 : (value / target).clamp(0.0, 1.0);

  /// True once the target is met. Deliberately not "exceeded is bad": going
  /// over on protein or fibre is fine, and the screen should not scold.
  bool get met => value >= target;

  /// How far over the target, or zero. Only calories treat this as a problem.
  double get over => value > target ? value - target : 0;
}

/// Every macro, in the order they matter for this plan.
List<MacroProgress> macroBreakdown(MacroTotals eaten, NutritionTargets t) => [
  MacroProgress(
    label: 'PROTEIN',
    unit: 'g',
    value: eaten.proteinG,
    target: t.proteinG,
  ),
  MacroProgress(label: 'CALORIES', unit: 'kcal', value: eaten.kcal.toDouble(), target: t.kcal.toDouble()),
  MacroProgress(label: 'CARBS', unit: 'g', value: eaten.carbsG, target: t.carbsG),
  MacroProgress(label: 'FAT', unit: 'g', value: eaten.fatG, target: t.fatG),
  MacroProgress(label: 'FIBRE', unit: 'g', value: eaten.fibreG, target: t.fibreG),
];
