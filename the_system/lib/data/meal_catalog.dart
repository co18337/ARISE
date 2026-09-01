import '../models/models.dart';

/// The diet plan, transcribed from the COMPLETE 2027 TRANSFORMATION ROADMAP.
///
/// THE DISHES, THE DAYS AND THE TIMES ARE THE PLAN'S OWN. So is the target it
/// is built against: ~2000 kcal a day with 100-120 g of protein, a mild
/// deficit for fat loss while preserving muscle.
///
/// THE MACROS ARE ESTIMATES, with one exception. The plan states a protein
/// figure for every dinner ("Paneer — 20g protein") and those are used exactly
/// as written. Everything else — calories, carbohydrate, fat, fibre, and the
/// protein in the breakfasts — is a standard-portion estimate for the dish as
/// described, because the plan does not give them. They are honest arithmetic,
/// not a measurement, and the NUTRITION screen exists precisely so that what
/// you actually eat is costed separately rather than assumed from this.
///
/// The plan prescribes FOUR eating occasions: detox drink, post-workout
/// milkshake, breakfast, dinner. There is no lunch and no afternoon snack in
/// it — the master schedule runs breakfast at 9:30 to dinner at 8:30pm. That
/// is left as written rather than filled in.
///
/// Editing this file changes the plan; nothing else needs to change. From the
/// first launch onward the DATABASE is the source of truth, exactly like the
/// task catalog, so a meal edited in-app later will not be overwritten.
class MealCatalog {
  MealCatalog._();

  static const List<Meal> all = [
    // --- Every day, fixed. ------------------------------------------------
    Meal(
      id: 'detox_drink',
      name: 'Detox drink',
      slot: MealSlot.detoxDrink,
      kcal: 15,
      proteinG: 0.5,
      carbsG: 3,
      fatG: 0.3,
      fibreG: 1,
      detail:
          'Jeera 1 tsp + saunf 1 tsp + methi seeds ½ tsp + ginger 1 inch, '
          'boiled in 500 ml water 5-7 min. Half a lemon once it cools a '
          'little. Drink warm, empty stomach. Wait 20 min before the workout. '
          'Can be made the night before in a flask.',
    ),
    Meal(
      id: 'post_workout_milkshake',
      name: 'Post-workout milkshake',
      slot: MealSlot.milkshake,
      kcal: 520,
      proteinG: 15,
      carbsG: 62,
      fatG: 22,
      fibreG: 7,
      detail:
          '300 ml full-fat or toned milk + 3-4 soaked dates + 10 raisins + '
          '5-6 soaked almonds + 2-3 walnuts, blended. Within 30 min of '
          'finishing. Soak the almonds and dates the night before.',
    ),

    // --- Seven breakfasts, 9:30am. ----------------------------------------
    Meal(
      id: 'breakfast_mon',
      name: 'Moong dal chilla x2 + curd',
      slot: MealSlot.breakfast,
      daysOfWeek: [1],
      kcal: 420,
      proteinG: 22,
      carbsG: 52,
      fatG: 12,
      fibreG: 9,
      detail:
          'High protein, light, filling. Soak moong dal overnight, grind to a '
          'batter, cook like dosa.',
    ),
    Meal(
      id: 'breakfast_tue',
      name: 'Milk smoothie + paneer slice',
      slot: MealSlot.breakfast,
      daysOfWeek: [2],
      kcal: 430,
      proteinG: 24,
      carbsG: 42,
      fatG: 18,
      fibreG: 3,
      detail:
          'Blend 300 ml milk + 1 banana. Pan-fry 50 g paneer with salt. '
          'Quick 5-minute breakfast.',
    ),
    Meal(
      id: 'breakfast_wed',
      name: 'Poha with peanuts + chaach',
      slot: MealSlot.breakfast,
      daysOfWeek: [3],
      kcal: 400,
      proteinG: 12,
      carbsG: 58,
      fatG: 13,
      fibreG: 5,
      detail:
          'Rinse poha, add peanuts + mustard + onion + turmeric. Cook 5 min. '
          'Glass of chaach on the side.',
    ),
    Meal(
      id: 'breakfast_thu',
      name: 'Besan cheela x2 + curd',
      slot: MealSlot.breakfast,
      daysOfWeek: [4],
      kcal: 410,
      proteinG: 20,
      carbsG: 46,
      fatG: 14,
      fibreG: 8,
      detail:
          'Mix besan + water + salt + onion into a batter. Cook like a '
          'pancake. High-protein vegetarian breakfast.',
    ),
    Meal(
      id: 'breakfast_fri',
      name: 'Upma + 1 banana',
      slot: MealSlot.breakfast,
      daysOfWeek: [5],
      kcal: 430,
      proteinG: 10,
      carbsG: 72,
      fatG: 11,
      fibreG: 6,
      detail:
          'Good energy for HIIT day. Roast sooji dry, add mustard + onion + '
          'veggies + water. Cook 7 min.',
    ),
    Meal(
      id: 'breakfast_sat',
      name: 'Aloo paratha (1) + curd + salad',
      slot: MealSlot.breakfast,
      daysOfWeek: [6],
      kcal: 450,
      proteinG: 13,
      carbsG: 58,
      fatG: 18,
      fibreG: 6,
      detail:
          'Weekend reward. ONE paratha only, not three. Eat with curd and '
          'cucumber.',
    ),
    Meal(
      id: 'breakfast_sun',
      name: 'Sprouts chaat + warm milk',
      slot: MealSlot.breakfast,
      daysOfWeek: [7],
      kcal: 390,
      proteinG: 21,
      carbsG: 48,
      fatG: 10,
      fibreG: 12,
      detail:
          'Best protein + detox option. Soak moong overnight, sprout 6-8 hrs, '
          'add chaat masala + lemon.',
    ),

    // --- Seven dinners, 8:30pm. -------------------------------------------
    // No rice at night. Salad BEFORE the roti. Finished by 9pm — which is a
    // routine quest of its own.
    //
    // The protein figure on each of these is the plan's own number.
    Meal(
      id: 'dinner_mon',
      name: 'Palak paneer + 2 roti + cucumber salad',
      slot: MealSlot.dinner,
      daysOfWeek: [1],
      kcal: 620,
      proteinG: 20,
      carbsG: 62,
      fatG: 28,
      fibreG: 12,
      detail: 'Paneer — 20 g protein. Salad first, then the roti.',
    ),
    Meal(
      id: 'dinner_tue',
      name: 'Moong dal + 2 roti + onion salad',
      slot: MealSlot.dinner,
      daysOfWeek: [2],
      kcal: 540,
      proteinG: 14,
      carbsG: 78,
      fatG: 14,
      fibreG: 14,
      detail: 'Moong dal — 14 g protein.',
    ),
    Meal(
      id: 'dinner_wed',
      name: 'Soya chunks sabzi + 2 roti + curd',
      slot: MealSlot.dinner,
      daysOfWeek: [3],
      kcal: 600,
      proteinG: 25,
      carbsG: 66,
      fatG: 18,
      fibreG: 13,
      detail:
          'Soya — 25 g protein. The best vegetarian option in the plan: 100 g '
          'dry soya chunks carry 52 g of protein, cheaper than paneer.',
    ),
    Meal(
      id: 'dinner_thu',
      name: 'Rajma + 2 roti + salad',
      slot: MealSlot.dinner,
      daysOfWeek: [4],
      kcal: 580,
      proteinG: 15,
      carbsG: 84,
      fatG: 14,
      fibreG: 16,
      detail: 'Rajma — 15 g protein.',
    ),
    Meal(
      id: 'dinner_fri',
      name: 'Paneer bhurji + 2 roti + chaach',
      slot: MealSlot.dinner,
      daysOfWeek: [5],
      kcal: 610,
      proteinG: 20,
      carbsG: 58,
      fatG: 30,
      fibreG: 9,
      detail: 'Paneer — 20 g protein.',
    ),
    Meal(
      id: 'dinner_sat',
      name: 'Chhole + 2 roti + onion rings',
      slot: MealSlot.dinner,
      daysOfWeek: [6],
      kcal: 590,
      proteinG: 14,
      carbsG: 82,
      fatG: 17,
      fibreG: 15,
      detail: 'Chhole — 14 g protein.',
    ),
    Meal(
      id: 'dinner_sun',
      name: 'Mix veg sabzi + dal + 2 roti',
      slot: MealSlot.dinner,
      daysOfWeek: [7],
      kcal: 550,
      proteinG: 12,
      carbsG: 74,
      fatG: 17,
      fibreG: 14,
      detail: 'Dal — 12 g protein. Sunday is the reset day.',
    ),
  ];

  /// The meals planned for one weekday, in the order they are eaten.
  ///
  /// 1 = Monday .. 7 = Sunday, matching DateTime.weekday.
  static List<Meal> forWeekday(int weekday) => [
    for (final meal in all)
      if (meal.servedOn(weekday)) meal,
  ]..sort((a, b) => a.slot.atMinutes.compareTo(b.slot.atMinutes));

  /// Slots the plan deliberately leaves empty. Shown as such rather than
  /// filled in: the plan runs breakfast at 9:30 straight to dinner at 8:30pm.
  static List<MealSlot> get unplannedSlots => [
    for (final slot in MealSlot.values)
      if (!all.any((m) => m.slot == slot)) slot,
  ];
}