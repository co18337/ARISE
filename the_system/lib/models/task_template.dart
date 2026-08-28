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

  const TaskTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.stat,
    required this.schedule,
    this.daysOfWeek = const [],
    required this.xp,
  });
}
