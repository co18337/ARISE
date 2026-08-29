import 'schedule_type.dart';
import 'stat_type.dart';
import 'task_category.dart';

/// A reusable definition of a task from the task catalog, e.g. "morning
/// skincare". This is the plan's *data* — the generator turns templates into
/// concrete [DailyTask]s for a given date. Nothing about "today" lives here.
class TaskTemplate {
  final String id;
  final String title;
  final TaskCategory category;
  final StatType stat;
  final ScheduleType schedule;

  /// Days this task runs on, where 1 = Monday .. 7 = Sunday (Dart's
  /// `DateTime.weekday` numbering). Only meaningful for
  /// [ScheduleType.specificDays] and [ScheduleType.weekly]; leave empty
  /// otherwise.
  final List<int> daysOfWeek;

  final int xp;

  /// When this step comes up, in minutes after local midnight — 5:35am is 335.
  ///
  /// Minutes-since-midnight rather than a DateTime for the same reason days
  /// are integers (see lib/data/day_key.dart): a time-of-day has no date and
  /// no timezone, and storing it as one invites a whole class of off-by-a-day
  /// bugs. Null means "anytime today".
  final int? scheduledMinutes;

  /// How long the step stays answerable after [scheduledMinutes]. Once this
  /// passes unanswered, the step closes itself as missed.
  final int graceMinutes;

  const TaskTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.stat,
    required this.schedule,
    this.daysOfWeek = const [],
    required this.xp,
    this.scheduledMinutes,
    this.graceMinutes = defaultGraceMinutes,
  });

  /// Two hours, unless the catalog says otherwise — long enough that a normal
  /// morning doesn't fail by accident, short enough that the day still moves.
  static const int defaultGraceMinutes = 120;
}
