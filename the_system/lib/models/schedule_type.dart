/// How often a [TaskTemplate] repeats. The generator uses this to decide
/// whether a template should be instantiated for a given date.
enum ScheduleType {
  daily,

  /// Monday through Friday.
  weekdays,

  /// Specific days of the week, e.g. Mon/Wed/Fri. Which days are listed in
  /// the template's `daysOfWeek`.
  specificDays,

  /// Once a week, on the single day listed in the template's `daysOfWeek`.
  weekly,
}
