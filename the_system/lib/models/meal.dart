/// Where a meal sits in the day.
///
/// Fixed slots rather than free-form times: the plan is a rotation, and every
/// day has the same shape. It is also what lets the plan be shown in the order
/// you actually eat it without storing a time on every row.
enum MealSlot {
  // Times are the plan's own, from the master daily schedule. The milkshake is
  // POST-WORKOUT at 7:40am and therefore comes BEFORE breakfast at 9:30 — it
  // was previously sat at 7pm, which put the day's meals in the wrong order on
  // screen.
  detoxDrink('DETOX DRINK', 5 * 60 + 35),
  milkshake('MILKSHAKE', 7 * 60 + 40),
  breakfast('BREAKFAST', 9 * 60 + 30),
  // The plan prescribes no lunch and no afternoon snack — it goes breakfast at
  // 9:30 straight to dinner at 8:30pm. Both slots stay so that a lunch you do
  // eat can still be LOGGED; they simply have nothing planned in them, and the
  // plan page says so rather than quietly inventing a meal.
  lunch('LUNCH', 13 * 60 + 30),
  snack('SNACK', 17 * 60),
  dinner('DINNER', 20 * 60 + 30);

  final String label;

  /// Roughly when it happens, in minutes after midnight. Used only for
  /// ordering the plan on screen — the routine's quests own the real timings.
  final int atMinutes;

  const MealSlot(this.label, this.atMinutes);
}

/// One meal in the rotation, with its macros.
///
/// This is reference data, not a food database. The plan is a fixed weekly
/// rotation of about sixteen known meals, which is the entire reason this
/// feature is a weekend of work rather than a month: no search API, no
/// barcode scanner, no per-ingredient breakdown.
class Meal {
  final String id;
  final String name;
  final MealSlot slot;

  /// Days of the week this meal is served, 1 = Monday .. 7 = Sunday. Empty
  /// means every day — the detox drink and the milkshake.
  final List<int> daysOfWeek;

  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fibreG;

  /// What is actually in it, for the day's plan.
  final String detail;

  const Meal({
    required this.id,
    required this.name,
    required this.slot,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fibreG,
    required this.detail,
    this.daysOfWeek = const [],
  });

  bool servedOn(int weekday) =>
      daysOfWeek.isEmpty || daysOfWeek.contains(weekday);
}
