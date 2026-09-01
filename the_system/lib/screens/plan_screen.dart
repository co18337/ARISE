import 'package:flutter/material.dart';

import '../data/repositories/plan_repository.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/system_panel.dart';

/// PLAN — the task catalog, editable.
///
/// This is the screen that makes "the plan is DATA" literally true. Every
/// other screen reads the catalog; this one writes it, so a step's time, its
/// XP or its very existence can change without a rebuild.
///
/// Two rules are enforced here and both follow from daily quests SNAPSHOTTING
/// their xp and timings when they are issued:
///
///   Editing changes TOMORROW, never yesterday. Re-timing a step must not
///   retroactively decide whether last Tuesday's lapsed.
///
///   A step with history is ARCHIVED, never deleted. Its issued quests point
///   at it, and removing the row would take days out of the weekly report.
class PlanScreen extends StatefulWidget {
  final PlanRepository planRepository;

  const PlanScreen({super.key, required this.planRepository});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final Stream<List<PlanEntry>> _entries = widget.planRepository.watch();
  bool _showArchived = false;

  Future<void> _edit(PlanEntry? entry) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        entry: entry,
        onSave: (template) =>
            widget.planRepository.save(template, isActive: entry?.isActive ?? true),
      ),
    );
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _remove(PlanEntry entry) async {
    final deleted = await widget.planRepository.delete(entry.template.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? '${entry.template.title} removed.'
              : '${entry.template.title} archived — it has '
                    '${entry.issuedCount} days of history behind it, and '
                    'deleting it would take them out of the record.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PlanEntry>>(
      stream: _entries,
      builder: (context, snapshot) {
        final all = snapshot.data ?? const <PlanEntry>[];
        final shown = [
          for (final e in all)
            if (e.isActive || _showArchived) e,
        ];
        final archived = all.where((e) => !e.isActive).length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            HudSectionTitle('PLAN'),
            const SizedBox(height: 16),
            SystemPanel(
              glow: 0.16,
              child: Text(
                'The day\'s steps, as data. Change a time or an XP value here '
                'and tomorrow follows it — days already answered keep the '
                'numbers they were issued with.',
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 14),
            GradientButton(
              label: 'Add a step',
              icon: Icons.add,
              onPressed: () => _edit(null),
            ),
            if (archived > 0) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: () => setState(() => _showArchived = !_showArchived),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    _showArchived
                        ? 'Hide $archived archived'
                        : 'Show $archived archived',
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 10,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            for (final (i, entry) in shown.indexed) ...[
              HudEntrance(
                index: i,
                child: _StepCard(
                  entry: entry,
                  onEdit: () => _edit(entry),
                  onToggle: () => widget.planRepository
                      .setActive(entry.template.id, !entry.isActive),
                  onRemove: () => _remove(entry),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _StepCard extends StatelessWidget {
  final PlanEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _StepCard({
    required this.entry,
    required this.onEdit,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final t = entry.template;
    final dim = !entry.isActive;

    return Opacity(
      opacity: dim ? 0.45 : 1,
      child: SystemPanel(
        glow: dim ? 0.08 : 0.16,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  t.scheduledMinutes == null
                      ? 'ANYTIME'
                      : _clock(t.scheduledMinutes!),
                  style: AppTextStyles.readout.copyWith(fontSize: 13),
                ),
                const SizedBox(width: 10),
                // Flexible, or a long title plus the XP badge overflows on a
                // narrow phone.
                Flexible(
                  child: Text(
                    t.title,
                    style: AppTextStyles.questTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Text(
                  '${t.xp} XP',
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 10,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _Tag(t.stat.name.toUpperCase(), AppColors.primary),
                _Tag(t.category.name, AppColors.accentPurple),
                _Tag(_scheduleLabel(t), AppColors.textDim),
                if (t.scheduledMinutes != null)
                  _Tag('${t.graceMinutes}m window', AppColors.textDim),
                if (entry.hasHistory)
                  _Tag('${entry.issuedCount} days', AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Action(Icons.edit_outlined, 'Edit', onEdit),
                const SizedBox(width: 6),
                _Action(
                  entry.isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  entry.isActive ? 'Archive' : 'Restore',
                  onToggle,
                ),
                const Spacer(),
                // Only offered where it is honest. A step with history cannot
                // be deleted, so the control does not pretend otherwise.
                if (!entry.hasHistory)
                  _Action(Icons.delete_outline, 'Delete', onRemove),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _clock(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';

  static String _scheduleLabel(TaskTemplate t) => switch (t.schedule) {
    ScheduleType.daily => 'every day',
    ScheduleType.weekdays => 'weekdays',
    ScheduleType.weekly => 'weekly',
    ScheduleType.specificDays =>
      t.daysOfWeek.map((d) => _dayNames[d - 1]).join(' '),
  };

  static const List<String> _dayNames = [
    'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN',
  ];
}

class _Tag extends StatelessWidget {
  final String text;
  final Color colour;

  const _Tag(this.text, this.colour);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: colour.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: colour.withValues(alpha: 0.3)),
    ),
    child: Text(
      text.toUpperCase(),
      style: AppTextStyles.hudLabel.copyWith(fontSize: 9, color: colour),
    ),
  );
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Action(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(6),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}

/// The editor. A bottom sheet rather than a page: it edits one step and
/// returns, and a full screen for six fields is a screen you dread opening.
class _EditSheet extends StatefulWidget {
  final PlanEntry? entry;
  final Future<void> Function(TaskTemplate) onSave;

  const _EditSheet({required this.entry, required this.onSave});

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.entry?.template.title ?? '',
  );
  late final TextEditingController _xp = TextEditingController(
    text: '${widget.entry?.template.xp ?? 10}',
  );
  late final TextEditingController _grace = TextEditingController(
    text: '${widget.entry?.template.graceMinutes ?? 120}',
  );

  late TaskCategory _category =
      widget.entry?.template.category ?? TaskCategory.hydration;
  late StatType _stat = widget.entry?.template.stat ?? StatType.rec;
  late ScheduleType _schedule =
      widget.entry?.template.schedule ?? ScheduleType.daily;
  late final List<int> _days = [...?widget.entry?.template.daysOfWeek];
  late int? _minutes = widget.entry?.template.scheduledMinutes;

  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _xp.dispose();
    _grace.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final start = _minutes ?? 8 * 60;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: start ~/ 60, minute: start % 60),
    );
    if (picked != null) {
      setState(() => _minutes = picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'A step needs a name.');
      return;
    }
    final xp = int.tryParse(_xp.text.trim());
    if (xp == null || xp <= 0) {
      setState(() => _error = 'XP must be a number above zero.');
      return;
    }
    if (_schedule == ScheduleType.specificDays && _days.isEmpty) {
      setState(() => _error = 'Pick at least one day.');
      return;
    }

    await widget.onSave(
      TaskTemplate(
        // The id is the identity, so an EXISTING step keeps its own — changing
        // it would orphan every quest ever issued from it and read as a
        // delete-plus-create in the record.
        id: widget.entry?.template.id ?? PlanRepository.idFor(title),
        title: title,
        category: _category,
        stat: _stat,
        schedule: _schedule,
        daysOfWeek: _schedule == ScheduleType.specificDays ? _days : const [],
        xp: xp,
        scheduledMinutes: _minutes,
        graceMinutes: int.tryParse(_grace.text.trim()) ?? 120,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet clear of the keyboard, or the save button sits under
      // it on a 360dp phone.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.entry == null ? 'NEW STEP' : 'EDIT STEP',
                style: AppTextStyles.panelTitle,
              ),
              const SizedBox(height: 14),
              _Field('Name', _title),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _Field('XP', _xp, number: true)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field('Window (min)', _grace, number: true),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _Label('TIME'),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text(
                        _minutes == null
                            ? 'Anytime'
                            : _StepCard._clock(_minutes!),
                      ),
                    ),
                  ),
                  if (_minutes != null)
                    TextButton(
                      onPressed: () => setState(() => _minutes = null),
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              _Label('STAT'),
              _Choice<StatType>(
                values: StatType.values,
                selected: _stat,
                label: (v) => v.name.toUpperCase(),
                onSelected: (v) => setState(() => _stat = v),
              ),
              const SizedBox(height: 14),
              _Label('CATEGORY'),
              _Choice<TaskCategory>(
                values: TaskCategory.values,
                selected: _category,
                label: (v) => v.name,
                onSelected: (v) => setState(() => _category = v),
              ),
              const SizedBox(height: 14),
              _Label('SCHEDULE'),
              _Choice<ScheduleType>(
                values: ScheduleType.values,
                selected: _schedule,
                label: (v) => v.name,
                onSelected: (v) => setState(() => _schedule = v),
              ),
              if (_schedule == ScheduleType.specificDays) ...[
                const SizedBox(height: 12),
                _Label('DAYS'),
                Wrap(
                  spacing: 6,
                  children: [
                    for (var d = 1; d <= 7; d++)
                      FilterChip(
                        label: Text(_StepCard._dayNames[d - 1]),
                        selected: _days.contains(d),
                        onSelected: (on) => setState(() {
                          on ? _days.add(d) : _days.remove(d);
                        }),
                      ),
                  ],
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    color: AppColors.danger,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              GradientButton(
                label: 'Save',
                icon: Icons.check,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: AppTextStyles.hudLabel.copyWith(
        fontSize: 9,
        color: AppColors.textDim,
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool number;

  const _Field(this.label, this.controller, {this.number = false});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Label(label.toUpperCase()),
      TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: AppTextStyles.body,
        decoration: const InputDecoration(isDense: true),
      ),
    ],
  );
}

class _Choice<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  const _Choice({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (final v in values)
        ChoiceChip(
          label: Text(label(v)),
          selected: v == selected,
          onSelected: (_) => onSelected(v),
        ),
    ],
  );
}
