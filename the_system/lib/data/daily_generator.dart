import '../models/models.dart';

/// Decides which catalog templates are due on a given date.
///
/// This is deliberately pure — it only answers "is this scheduled?" and never
/// touches the database. Creating the actual `daily_quests` rows is the
/// repository's job, so this logic stays trivially unit-testable.

/// Whether [template] is scheduled to run on [date].
bool isScheduledOn(TaskTemplate template, DateTime date) {
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

/// The subset of [catalog] due on [date], preserving catalog order.
List<TaskTemplate> templatesScheduledOn(
  List<TaskTemplate> catalog,
  DateTime date,
) => catalog.where((t) => isScheduledOn(t, date)).toList();
