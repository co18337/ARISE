import 'quest_status.dart';
import 'stat_type.dart';
import 'task_template.dart';

/// One instance of a [TaskTemplate] issued for a specific day, plus how it
/// ended up. Corresponds to a row in the `daily_quests` table.
///
/// This is IMMUTABLE. Before Phase 3 the screen mutated `done` in place and
/// called setState; now the database is the single source of truth and the
/// repository re-emits a fresh list on every write, so nothing should ever
/// edit one of these objects.
///
/// [xpAwarded], [stat], [scheduledMinutes] and [graceMinutes] are SNAPSHOTS
/// taken when the quest was issued, not live lookups through [template]. If
/// the catalog is later re-rated or re-timed, past days must keep the terms
/// they were actually judged on — the same reason an invoice records the price
/// it charged rather than pointing at today's price list.
class DailyTask {
  /// Primary key of the `daily_quests` row.
  final int id;

  final TaskTemplate template;
  final DateTime date;

  /// Pending, done or missed. Replaced the old `done` boolean in schema v3,
  /// because "not ticked" and "definitively missed" are different facts and
  /// one bit cannot hold both.
  final QuestStatus status;

  final DateTime? completedAt;
  final int xpAwarded;
  final StatType stat;

  /// Minutes after local midnight when this step comes up; null = anytime.
  final int? scheduledMinutes;

  /// How long after [scheduledMinutes] the step stays answerable.
  final int graceMinutes;

  const DailyTask({
    required this.id,
    required this.template,
    required this.date,
    required this.status,
    required this.completedAt,
    required this.xpAwarded,
    required this.stat,
    required this.scheduledMinutes,
    required this.graceMinutes,
  });

  bool get done => status == QuestStatus.done;
  bool get missed => status == QuestStatus.missed;

  /// The scheduled time as "5:35 AM", or "ANYTIME" for an unscheduled step.
  ///
  /// Formatting lives on the model next to the value it formats, the same way
  /// TaskCategory carries its own label — it keeps every screen showing times
  /// the same way without an intl dependency.
  String get scheduledLabel {
    final minutes = scheduledMinutes;
    if (minutes == null) return 'ANYTIME';

    final hour24 = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour24 < 12 ? 'AM' : 'PM';
    // 0 -> 12am and 13 -> 1pm; the modulo alone would render midnight as 0.
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }
}
