import 'task_template.dart';

/// One instance of a [TaskTemplate] scheduled for a specific date, plus its
/// completion state.
///
/// `done` and `completedAt` are deliberately mutable (not `final`): for now
/// this app only lives in memory, so the Today screen mutates a DailyTask
/// directly and calls `setState` to redraw. Once Drift is wired up, saving a
/// change will mean writing a row to the database instead — at that point
/// this class will likely become immutable with a `copyWith`, but that's
/// unnecessary complexity today.
class DailyTask {
  final TaskTemplate template;
  final DateTime date;
  bool done;
  DateTime? completedAt;

  DailyTask({
    required this.template,
    required this.date,
    this.done = false,
    this.completedAt,
  });
}
