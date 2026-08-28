import '../models/models.dart';
import 'task_catalog.dart';

/// Builds the list of tasks scheduled for [date], by checking every template
/// in [catalog] against its [ScheduleType].
///
/// [catalog] defaults to the real [TaskCatalog.all] but can be overridden —
/// mainly so tests can pass in a small fake list instead of the whole plan.
List<DailyTask> generateTasksForDate(
  DateTime date, {
  List<TaskTemplate> catalog = TaskCatalog.all,
}) {
  return catalog
      .where((template) => _isScheduledOn(template, date))
      .map((template) => DailyTask(template: template, date: date))
      .toList();
}

bool _isScheduledOn(TaskTemplate template, DateTime date) {
  switch (template.schedule) {
    case ScheduleType.daily:
      return true;
    case ScheduleType.weekdays:
      // DateTime.weekday: 1 = Monday .. 7 = Sunday, so 1-5 is Mon-Fri.
      return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
    case ScheduleType.specificDays:
    case ScheduleType.weekly:
      return template.daysOfWeek.contains(date.weekday);
  }
}
