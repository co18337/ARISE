/// The guided-routine engine: works out which step of the day you are on.
///
/// Pure, like the rest of lib/game — it takes the day's quests and a clock
/// reading and returns a state per step. No database, no Flutter, no
/// `DateTime.now()`. That is what makes "the 5:35 step has lapsed by 8am"
/// something a test can assert in one line.
///
/// It reads the [DailyTask] model directly. Models are plain Dart with no
/// Flutter or storage dependency, so the engine stays as portable as before.
library;

import '../models/models.dart';

/// How a step is presented on the routine screen.
///
/// Named RoutineState rather than StepState because Flutter's Material
/// library already exports a StepState (for Stepper), and a name collision in
/// every widget file is not worth the shorter word.
enum RoutineState {
  /// Its time hasn't come, or an earlier step is still open.
  locked,

  /// The step you're on — the only one that can be acted on.
  active,

  /// Completed. Awards XP.
  done,

  /// Not completed, either answered as missed or left until its window shut.
  missed,
}

/// Minutes in a day. Also the cursor value meaning "this day is over".
const int minutesInDay = 24 * 60;

/// Cursor value meaning "this day hasn't started yet".
const int _dayNotStarted = -1;

/// One step of the day, paired with the state the engine computed for it.
class RoutineStep {
  final DailyTask task;
  final RoutineState state;

  const RoutineStep({required this.task, required this.state});

  bool get isActive => state == RoutineState.active;
  bool get isResolved =>
      state == RoutineState.done || state == RoutineState.missed;
}

/// How far into [dayKey] the clock has got, in minutes since local midnight.
///
/// Days other than today get a cursor that is deliberately out of range, so
/// the same rules produce the right answer for history and for the future
/// without any special-casing further down: a past day is fully closed, and
/// nothing on a future day has opened yet.
int dayCursor({
  required int dayKey,
  required int todayKey,
  required DateTime now,
}) {
  if (dayKey < todayKey) return minutesInDay; // over: every window has shut
  if (dayKey > todayKey) return _dayNotStarted; // nothing has opened yet
  return now.hour * 60 + now.minute;
}

/// The minute of the day at which a step's window shuts.
///
/// Clamped to midnight: a generous grace period must not spill into tomorrow,
/// or a step could still be answerable on a day it was never issued for.
int windowClosesAt({int? scheduledMinutes, required int graceMinutes}) {
  final opens = scheduledMinutes ?? 0;
  final closes = opens + graceMinutes;
  return closes > minutesInDay ? minutesInDay : closes;
}

/// Whether an unanswered step's window has already shut.
bool hasLapsed({
  int? scheduledMinutes,
  required int graceMinutes,
  required int cursor,
}) =>
    cursor >=
    windowClosesAt(
      scheduledMinutes: scheduledMinutes,
      graceMinutes: graceMinutes,
    );

/// Pairs each step with its state, in the order given.
///
/// [steps] must already be in routine order (by scheduled time). The unlock
/// rule needs the order, because it is half sequential:
///
/// **Time gates a step; answering it advances the day.** A step goes ACTIVE
/// when its scheduled time has arrived AND every earlier step is resolved.
/// Sequential-only unlocking would strand you forever on a step you couldn't
/// do; time-only would put the 9pm dinner quest on screen at 6am. It needs
/// both conditions, which is the part that's easy to get wrong.
List<RoutineStep> buildRoutine({
  required List<DailyTask> steps,
  required int cursor,
}) {
  final result = <RoutineStep>[];
  // Set once the first unresolved step is met; everything after it is locked
  // behind that step, which is what makes the day arrive one item at a time.
  var blocked = false;

  for (final task in steps) {
    final state = _stateOf(task, cursor: cursor, blocked: blocked);
    result.add(RoutineStep(task: task, state: state));
    if (state == RoutineState.active || state == RoutineState.locked) blocked = true;
  }

  return result;
}

RoutineState _stateOf(
  DailyTask task, {
  required int cursor,
  required bool blocked,
}) {
  // An answered step keeps its answer; nothing below can change it.
  switch (task.status) {
    case QuestStatus.done:
      return RoutineState.done;
    case QuestStatus.missed:
      return RoutineState.missed;
    case QuestStatus.pending:
      break;
  }

  // A step left unanswered past its window is a miss, whether or not the app
  // was ever opened. The day always closes itself out.
  if (hasLapsed(
    scheduledMinutes: task.scheduledMinutes,
    graceMinutes: task.graceMinutes,
    cursor: cursor,
  )) {
    return RoutineState.missed;
  }

  if (blocked) return RoutineState.locked;
  if (cursor < (task.scheduledMinutes ?? 0)) return RoutineState.locked;
  return RoutineState.active;
}
