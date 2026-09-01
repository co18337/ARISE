import 'package:flutter/material.dart';

import '../data/meal_catalog.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
import '../widgets/stat_bar.dart';
import '../widgets/system_panel.dart';

/// THE PLAN — the ideal week, as written. Reference only.
///
/// Nothing on this page can be ticked, logged or edited, and that is the whole
/// design. The app used to ask "did you follow the plan?", which measures the
/// PLAN rather than the eating: a perfect adherence score on a rotation you
/// never cook is worth nothing. What you actually ate is typed in your own
/// words on NUTRITION. This page is what to cook FROM.
///
/// It also answers the one question the daily screen cannot: does eating the
/// whole plan even reach the targets? If it does not, no amount of adherence
/// fixes it and the rotation is what needs changing.
class MealPlanScreen extends StatefulWidget {
  /// Weekday to open on, 1 = Monday .. 7 = Sunday.
  final int initialWeekday;

  const MealPlanScreen({super.key, required this.initialWeekday});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  static const List<String> _dayLabels = [
    'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN',
  ];

  late int _weekday = widget.initialWeekday;

  /// The day's meals in the order they are eaten.
  List<Meal> _mealsFor(int weekday) => MealCatalog.forWeekday(weekday);

  MacroTotals _totalOf(List<Meal> meals) {
    var totals = MacroTotals.zero;
    for (final meal in meals) {
      totals = MacroTotals(
        kcal: totals.kcal + meal.kcal,
        proteinG: totals.proteinG + meal.proteinG,
        carbsG: totals.carbsG + meal.carbsG,
        fatG: totals.fatG + meal.fatG,
        fibreG: totals.fibreG + meal.fibreG,
      );
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final meals = _mealsFor(_weekday);
    final totals = _totalOf(meals);
    const targets = NutritionTargets.plan;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onClose: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  HudSectionTitle('THE IDEAL WEEK'),
                  const SizedBox(height: 14),
                  SystemPanel(
                    glow: 0.18,
                    child: Text(
                      'The plan as written, for reference. Nothing here is '
                      'logged and nothing is ticked — it is what to cook from '
                      'when the day allows. What you actually eat goes on '
                      'NUTRITION, typed in your own words.',
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(height: 16),
                  HudTabBar(
                    labels: _dayLabels,
                    selectedIndex: _weekday - 1,
                    onSelected: (i) => setState(() => _weekday = i + 1),
                  ),
                  const SizedBox(height: 18),
                  for (final (i, meal) in meals.indexed) ...[
                    HudEntrance(index: i, child: _PlanMealCard(meal: meal)),
                    const SizedBox(height: 10),
                  ],
                  if (meals.isEmpty)
                    SystemPanel(
                      child: Text(
                        'No meals set for this day.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Said plainly rather than filled in. The plan runs
                  // breakfast at 9:30 straight to dinner at 8:30pm, and
                  // inventing a lunch to make the day look complete would be
                  // inventing the plan.
                  if (MealCatalog.unplannedSlots.isNotEmpty) ...[
                    SystemPanel(
                      glow: 0.12,
                      child: Text(
                        'The plan prescribes nothing for '
                        '${MealCatalog.unplannedSlots.map((s) => s.label.toLowerCase()).join(' or ')}'
                        ' — it goes breakfast at 9:30 straight to dinner at '
                        '8:30pm. Anything you do eat then still gets logged '
                        'on NUTRITION.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _DayTotals(totals: totals, targets: targets),
                  const SizedBox(height: 14),
                  _PlanVerdict(totals: totals, targets: targets),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One meal, laid out the way the plan reads: when, what, what is in it.
class _PlanMealCard extends StatelessWidget {
  final Meal meal;

  const _PlanMealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      glow: 0.14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flexible on both halves: a long dish name and a four-digit
              // calorie count is how this row overflows on a 360dp phone.
              Flexible(
                child: Text(
                  meal.slot.label,
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 10,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${meal.kcal} kcal',
                style: AppTextStyles.hudLabel.copyWith(
                  fontSize: 10,
                  color: AppColors.textDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(meal.name, style: AppTextStyles.questTitle),
          const SizedBox(height: 6),
          Text(
            meal.detail,
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _MacroPill('P', meal.proteinG, AppColors.statStr),
              _MacroPill('C', meal.carbsG, AppColors.accentPurple),
              _MacroPill('F', meal.fatG, AppColors.accentGold),
              _MacroPill('FIB', meal.fibreG, AppColors.statRec),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final double grams;
  final Color color;

  const _MacroPill(this.label, this.grams, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withValues(alpha: 0.35)),
    ),
    child: Text(
      '$label ${grams % 1 == 0 ? grams.toInt() : grams.toStringAsFixed(1)} g',
      style: AppTextStyles.hudLabel.copyWith(fontSize: 10, color: color),
    ),
  );
}

/// What the whole day adds up to, against the targets.
class _DayTotals extends StatelessWidget {
  final MacroTotals totals;
  final NutritionTargets targets;

  const _DayTotals({required this.totals, required this.targets});

  @override
  Widget build(BuildContext context) {
    final rows = macroBreakdown(totals, targets);
    return SystemPanel(
      title: 'IF YOU ATE ALL OF IT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final macro in rows) ...[
            StatBar(
              label: macro.label,
              value: macro.value.round(),
              max: macro.target.round(),
              color: macro.met ? AppColors.primary : AppColors.accentPurple,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// The honest verdict on the rotation itself.
class _PlanVerdict extends StatelessWidget {
  final MacroTotals totals;
  final NutritionTargets targets;

  const _PlanVerdict({required this.totals, required this.targets});

  @override
  Widget build(BuildContext context) {
    final short = totals.proteinG < targets.proteinG;
    return SystemPanel(
      glow: 0.16,
      accent: short ? AppColors.danger : AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            short ? 'THE PLAN FALLS SHORT' : 'THE PLAN REACHES THE TARGETS',
            style: AppTextStyles.hudLabel.copyWith(
              color: short ? AppColors.danger : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            short
                ? 'Eating every meal on this day still lands under '
                      '${targets.proteinG.round()} g of protein. Adherence '
                      'cannot fix that — the rotation is what needs changing.'
                : 'Eating this day as written meets the protein target. '
                      'Measured BMR is ${NutritionTargets.measuredBmr} kcal; '
                      'eating below it is not a goal.',
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// A close control, matching the overlay pattern used across the app.
class _TopBar extends StatelessWidget {
  final VoidCallback onClose;

  const _TopBar({required this.onClose});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
    child: Row(
      children: [
        Text(
          'THE PLAN',
          style: AppTextStyles.hudLabel.copyWith(color: AppColors.textDim),
        ),
        const Spacer(),
        IconButton(
          onPressed: onClose,
          icon: Icon(Icons.close, color: AppColors.textSecondary),
          tooltip: 'Close',
        ),
      ],
    ),
  );
}
