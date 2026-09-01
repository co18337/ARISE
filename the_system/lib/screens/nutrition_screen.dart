import 'package:flutter/material.dart';

import '../data/repositories/nutrition_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_bar.dart';
import '../widgets/system_panel.dart';
import 'day_rollover.dart';
import 'meal_plan_screen.dart';

/// NUTRITION — what you actually ate, typed in your own words.
///
/// The plan is REFERENCE, on its own tab: something to cook from, never
/// something to tick off. Tracking adherence to an ideal plan measures the
/// plan; typing what you ate measures you, and the two answers diverge on
/// exactly the days that matter.
///
/// The app totals and displays. It does not judge the meal — that is a
/// doctor's job, and the model is told so too.
class NutritionScreen extends StatefulWidget {
  final NutritionRepository nutritionRepository;

  const NutritionScreen({super.key, required this.nutritionRepository});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
    with WidgetsBindingObserver, DayRollover<NutritionScreen> {
  // Not `late final`: both are reissued when the day rolls over, and a final
  // field cannot be. Logging a late dinner at 00:05 onto YESTERDAY is the bug
  // this exists to stop. See DayRollover.
  late DateTime _today;
  late Stream<IntakeDay> _dayStream;

  @override
  Clock get rolloverClock => widget.nutritionRepository.clock;

  @override
  DateTime get shownDay => _today;

  @override
  void openDay() {
    _today = widget.nutritionRepository.clock.now();
    _dayStream = widget.nutritionRepository.watchDay(_today);
  }

  /// Entries currently being costed, so their buttons can show it.
  final Set<int> _analysing = {};

  Future<void> _analyse(FoodEntry entry) async {
    setState(() => _analysing.add(entry.id));
    try {
      final result = await widget.nutritionRepository.analyseEntry(entry.id);
      if (!mounted) return;
      if (!result.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _analysing.remove(entry.id));
    }
  }

  void _openPlan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MealPlanScreen(initialWeekday: _today.weekday),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IntakeDay>(
      stream: _dayStream,
      builder: (context, snapshot) {
        final day = snapshot.data ?? IntakeDay.empty(_today);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            Row(
              children: [
                Expanded(child: HudSectionTitle('NUTRITION')),
                const SizedBox(width: 8),
                // The ideal plan is a full page of its own rather than a tab
                // here. It is a WEEK of reference material, and a tab on the
                // screen where you log today's eating invited exactly the
                // confusion the design is trying to avoid: this screen is what
                // you ate, that page is what to cook from.
                _PlanButton(onTap: () => _openPlan(context)),
              ],
            ),
            const SizedBox(height: 18),
            ..._todayTab(day),
          ],
        );
      },
    );
  }

  List<Widget> _todayTab(IntakeDay day) => [
    HudEntrance(index: 0, child: _IntakePanel(day: day)),
    const SizedBox(height: 14),
    HudEntrance(index: 1, child: _Breakdown(day: day)),
    const SizedBox(height: 18),
    HudEntrance(
      index: 2,
      child: _AddEntryForm(
        onAdd: (slot, text) async {
          await widget.nutritionRepository.addEntry(_today, slot, text);
        },
      ),
    ),
    const SizedBox(height: 18),
    Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
      child: Text('WHAT I ATE TODAY', style: AppTextStyles.panelTitle),
    ),
    if (day.entries.isEmpty)
      SystemPanel(
        glow: 0.14,
        child: Text(
          'Nothing logged yet. Add what you ate above — in your own words.',
          style: AppTextStyles.body,
        ),
      ),
    for (final (i, entry) in day.entries.indexed)
      HudEntrance(
        index: i + 3,
        child: _EntryCard(
          entry: entry,
          canAnalyse: widget.nutritionRepository.canAnalyse,
          busy: _analysing.contains(entry.id),
          onEdit: (text) =>
              widget.nutritionRepository.updateEntry(entry.id, text),
          onDelete: () => widget.nutritionRepository.deleteEntry(entry.id),
          onAnalyse: () => _analyse(entry),
          onManual: (macros) =>
              widget.nutritionRepository.setMacrosManually(entry.id, macros),
        ),
      ),
  ];

}

/// Calories so far, and an honest note when the total is incomplete.
class _IntakePanel extends StatelessWidget {
  final IntakeDay day;

  const _IntakePanel({required this.day});

  @override
  Widget build(BuildContext context) {
    final eaten = day.eaten;
    final over = eaten.kcal > day.targets.kcal;

    return SystemPanel(
      glow: 0.35,
      accent: over ? AppColors.accentGold : AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${eaten.kcal}',
                  style: AppTextStyles.display.copyWith(
                    fontSize: 34,
                    color: over ? AppColors.accentGold : AppColors.primary,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('OF ${day.targets.kcal} KCAL',
                      style: AppTextStyles.hudLabel),
                  const SizedBox(height: 4),
                  Text(
                    '${day.costedCount} OF ${day.typedCount} COSTED',
                    style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          StatBar(
            label: 'Calories',
            value: eaten.kcal,
            max: day.targets.kcal,
            height: 12,
            color: over ? AppColors.accentGold : null,
          ),
          if (day.hasUncosted) ...[
            const SizedBox(height: 10),
            Text(
              'Some entries have no figures yet, so this total is lower than '
              'what you actually ate.',
              style: AppTextStyles.body.copyWith(
                fontSize: 11,
                color: AppColors.accentGold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  final IntakeDay day;

  const _Breakdown({required this.day});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Breakdown',
      glow: 0.22,
      child: Column(
        children: [
          for (final macro in day.breakdown) ...[
            _MacroRow(macro: macro),
            if (macro != day.breakdown.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final MacroProgress macro;

  const _MacroRow({required this.macro});

  @override
  Widget build(BuildContext context) {
    // Going over on protein or fibre is fine; only calories warrant a warning.
    final overshootMatters = macro.label == 'CALORIES';
    final color = macro.met
        ? (overshootMatters && macro.over > 0
              ? AppColors.accentGold
              : AppColors.remaining)
        : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(macro.label,
                  style: AppTextStyles.hudLabel.copyWith(color: color)),
            ),
            Text(
              '${macro.value.round()} / ${macro.target.round()} ${macro.unit}',
              style: AppTextStyles.counter.copyWith(fontSize: 13, color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        StatBar(
          label: macro.label,
          value: macro.value.round(),
          max: macro.target.round(),
          color: color,
          height: 8,
          showHeader: false,
        ),
      ],
    );
  }
}

/// The ideal meal for a slot. Read-only.

/// What an entry came to, itemised.
class _Costed extends StatelessWidget {
  final FoodEntry entry;

  const _Costed({required this.entry});

  @override
  Widget build(BuildContext context) {
    final macros = entry.macros!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _Figure(label: 'KCAL', value: '${macros.kcal}'),
            _Figure(label: 'PROTEIN', value: '${macros.proteinG.round()}g'),
            _Figure(label: 'CARBS', value: '${macros.carbsG.round()}g'),
            _Figure(label: 'FAT', value: '${macros.fatG.round()}g'),
            _Figure(label: 'FIBRE', value: '${macros.fibreG.round()}g'),
          ],
        ),
        if (entry.items.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final item in entry.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '· ${item.quantity} ${item.name} — ${item.kcal} kcal, '
                '${item.proteinG.round()}g protein',
                style: AppTextStyles.body.copyWith(fontSize: 11),
              ),
            ),
        ],
        if (entry.uncertain) ...[
          const SizedBox(height: 8),
          // An estimate that had to guess a portion should not be shown as if
          // it were measured.
          Text(
            'Rough estimate — portions were assumed. Tap FIGURES to correct.',
            style: AppTextStyles.body.copyWith(
              fontSize: 11,
              color: AppColors.accentGold,
            ),
          ),
        ],
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  final String label;
  final String value;

  const _Figure({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: AppTextStyles.hudLabel.copyWith(fontSize: 8)),
      Text(value, style: AppTextStyles.counter.copyWith(fontSize: 13)),
    ],
  );
}

class _SmallButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SmallButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Material(
      color: Colors.transparent,
      shape: AppShapes.control(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: ShapeDecoration(
            color: color.withValues(alpha: enabled ? 0.10 : 0.04),
            shape: AppShapes.control(
              side: BorderSide(
                color: color.withValues(alpha: enabled ? 0.55 : 0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: enabled ? color : AppColors.textDim,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 9,
                    color: enabled ? color : AppColors.textDim,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Type the figures by hand. The path that works with no key at all, and the
/// way to correct an estimate that got a portion wrong.
class _FiguresDialog extends StatefulWidget {
  final MacroTotals? initial;

  const _FiguresDialog({required this.initial});

  @override
  State<_FiguresDialog> createState() => _FiguresDialogState();
}

class _FiguresDialogState extends State<_FiguresDialog> {
  late final Map<String, TextEditingController> _fields = {
    'kcal': TextEditingController(text: _initial(widget.initial?.kcal)),
    'protein': TextEditingController(text: _initial(widget.initial?.proteinG)),
    'carbs': TextEditingController(text: _initial(widget.initial?.carbsG)),
    'fat': TextEditingController(text: _initial(widget.initial?.fatG)),
    'fibre': TextEditingController(text: _initial(widget.initial?.fibreG)),
  };

  static String _initial(num? value) =>
      value == null || value == 0 ? '' : value.round().toString();

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _read(String key) =>
      double.tryParse(_fields[key]!.text.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: AppShapes.panel(
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      title: Text('Figures', style: AppTextStyles.panelTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in _fields.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: entry.value,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: entry.key.toUpperCase(),
                    labelStyle: AppTextStyles.hudLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL', style: AppTextStyles.hudLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            MacroTotals(
              kcal: _read('kcal').round(),
              proteinG: _read('protein'),
              carbsG: _read('carbs'),
              fatG: _read('fat'),
              fibreG: _read('fibre'),
            ),
          ),
          child: Text(
            'SAVE',
            style: AppTextStyles.hudLabel.copyWith(color: AppColors.accentGold),
          ),
        ),
      ],
    );
  }
}

/// The one place you add food: pick when, type what, press ADD.
///
/// An explicit button, not the keyboard's done key. A phone keyboard often has
/// no visible Enter at all in a multi-line field, and "type it then tap
/// somewhere else to save it" is not something anyone should have to guess.
class _AddEntryForm extends StatefulWidget {
  final Future<void> Function(MealSlot slot, String text) onAdd;

  const _AddEntryForm({required this.onAdd});

  @override
  State<_AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<_AddEntryForm> {
  final TextEditingController _controller = TextEditingController();
  MealSlot _slot = MealSlot.breakfast;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _slot = _slotForNow();
  }

  /// Starts on whichever meal it is nearest to, so the common case is no taps
  /// at all — you log lunch at lunchtime.
  MealSlot _slotForNow() {
    final now = DateTime.now();
    final minutes = now.hour * 60 + now.minute;
    var best = MealSlot.values.first;
    var closest = 24 * 60;
    for (final slot in MealSlot.values) {
      final gap = (slot.atMinutes - minutes).abs();
      if (gap < closest) {
        closest = gap;
        best = slot;
      }
    }
    return best;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;

    setState(() => _saving = true);
    try {
      await widget.onAdd(_slot, text);
      _controller.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Add what you ate',
      glow: 0.28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('WHEN', style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
          const SizedBox(height: 8),
          // Chips rather than a dropdown: every option visible, one tap to
          // change, and no menu to open on a phone.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in MealSlot.values)
                _SlotChip(
                  slot: slot,
                  selected: slot == _slot,
                  onTap: () => setState(() => _slot = slot),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text('WHAT', style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 2,
            textInputAction: TextInputAction.newline,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 2 chapatis whole wheat + 1 cup tea + salad',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.textDim,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: AppColors.surfaceRaised.withValues(alpha: 0.55),
              border: OutlineInputBorder(
                borderRadius: AppRadii.controlRadius,
                borderSide: BorderSide(color: AppColors.primaryDim),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.controlRadius,
                borderSide: BorderSide(
                  color: AppColors.primaryDim.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: _saving ? 'Adding…' : 'Add',
            icon: Icons.add,
            onPressed: _saving ? null : _add,
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  final MealSlot slot;
  final bool selected;
  final VoidCallback onTap;

  const _SlotChip({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentGold : AppColors.textDim;

    return Material(
      color: Colors.transparent,
      shape: AppShapes.pill(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: ShapeDecoration(
            color: color.withValues(alpha: selected ? 0.18 : 0.05),
            shape: AppShapes.pill(
              side: BorderSide(
                color: color.withValues(alpha: selected ? 0.9 : 0.35),
              ),
            ),
          ),
          child: Text(
            slot.label,
            style: AppTextStyles.hudLabel.copyWith(fontSize: 9, color: color),
          ),
        ),
      ),
    );
  }
}

/// One thing eaten: what you wrote, what it came to, and what to do about it.
class _EntryCard extends StatelessWidget {
  final FoodEntry entry;
  final bool canAnalyse;
  final bool busy;
  final Future<void> Function(String text) onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAnalyse;
  final ValueChanged<MacroTotals> onManual;

  const _EntryCard({
    required this.entry,
    required this.canAnalyse,
    required this.busy,
    required this.onEdit,
    required this.onDelete,
    required this.onAnalyse,
    required this.onManual,
  });

  @override
  Widget build(BuildContext context) {
    final costed = entry.costed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SystemPanel(
        glow: costed ? 0.24 : 0.14,
        accent: costed ? AppColors.remaining : AppColors.primary,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.slot.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.hudLabel.copyWith(
                      color: costed ? AppColors.remaining : AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  entry.source.label,
                  style: AppTextStyles.hudLabel.copyWith(fontSize: 8),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: AppColors.textDim,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              entry.body,
              style: AppTextStyles.questTitle.copyWith(fontSize: 15),
            ),
            if (costed) ...[
              const SizedBox(height: 10),
              _Costed(entry: entry),
            ],
            if (entry.analysisError != null) ...[
              const SizedBox(height: 8),
              Text(
                entry.analysisError!,
                style: AppTextStyles.body.copyWith(
                  fontSize: 11,
                  color: AppColors.danger,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                if (canAnalyse)
                  Expanded(
                    child: _SmallButton(
                      label: busy
                          ? 'WORKING…'
                          : costed
                          ? 'RE-ESTIMATE'
                          : 'ESTIMATE',
                      icon: Icons.auto_awesome,
                      color: AppColors.accentPurple,
                      onTap: busy || entry.source == MacroSource.manual
                          ? null
                          : onAnalyse,
                    ),
                  ),
                if (canAnalyse) const SizedBox(width: 8),
                Expanded(
                  child: _SmallButton(
                    label: 'FIGURES',
                    icon: Icons.edit_outlined,
                    color: AppColors.primary,
                    onTap: () async {
                      final macros = await showDialog<MacroTotals>(
                        context: context,
                        builder: (context) =>
                            _FiguresDialog(initial: entry.macros),
                      );
                      if (macros != null) onManual(macros);
                    },
                  ),
                ),
              ],
            ),
            if (!canAnalyse) ...[
              const SizedBox(height: 8),
              Text(
                'No API key set, so nothing is estimated — type the figures '
                'yourself, or add a key and restart.',
                style: AppTextStyles.body.copyWith(
                  fontSize: 11,
                  color: AppColors.textDim,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Opens the ideal-week reference. A quiet outline button, not a tab: it leads
/// somewhere else rather than switching what this screen is showing.
class _PlanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PlanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.45)),
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              'THE PLAN',
              style: AppTextStyles.hudLabel.copyWith(
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
