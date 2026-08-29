import 'package:drift/drift.dart';

import '../../models/models.dart';

/// Drift table definitions. See ARCHITECTURE.md §5 for the reasoning behind
/// the schema; the short version is in the comments here.
///
/// Drift note: these classes are *descriptions* of tables, not the row objects.
/// build_runner reads them and generates the real query API into
/// `database.g.dart` — that generated file must never be hand-edited.

/// Stores a `List<int>` of weekday numbers as a comma-separated string.
///
/// A TypeConverter keeps the conversion in ONE place, so every query reads and
/// writes `List<int>` and nothing else in the app has to know it's really TEXT.
class DaysOfWeekConverter extends TypeConverter<List<int>, String> {
  const DaysOfWeekConverter();

  @override
  List<int> fromSql(String fromDb) =>
      fromDb.isEmpty ? const [] : fromDb.split(',').map(int.parse).toList();

  @override
  String toSql(List<int> value) => value.join(',');
}

/// The task catalog — the plan itself, as data.
@DataClassName('TaskTemplateRow')
class TaskTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();

  // textEnum stores the enum's *name* ("skincareAM"), not its index, so
  // reordering the enum later can't silently corrupt existing rows.
  TextColumn get category => textEnum<TaskCategory>()();
  TextColumn get stat => textEnum<StatType>()();
  TextColumn get schedule => textEnum<ScheduleType>()();

  TextColumn get daysOfWeek =>
      text().map(const DaysOfWeekConverter()).withDefault(const Constant(''))();

  IntColumn get xp => integer()();

  /// When this step comes up, in minutes after local midnight (5:35am = 335).
  /// Null means "anytime today". Added in schema v3.
  IntColumn get scheduledMinutes => integer().nullable()();

  /// How long the step stays answerable after its scheduled time.
  IntColumn get graceMinutes => integer().withDefault(const Constant(120))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  /// Templates are archived, never deleted — history rows still reference them.
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per (template, day) actually issued.
@DataClassName('DailyQuestRow')
class DailyQuests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get templateId => text().references(TaskTemplates, #id)();

  /// Integer day number — see lib/data/day_key.dart for why not a timestamp.
  IntColumn get day => integer()();

  /// pending | done | missed. Replaced the `done` boolean in schema v3:
  /// "not ticked yet" and "definitively missed" are different facts, and one
  /// bit cannot hold both.
  TextColumn get status =>
      textEnum<QuestStatus>().withDefault(const Constant('pending'))();

  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Snapshots taken at issue time, NOT live lookups through the template.
  /// The timings are snapshotted for the same reason the XP is: re-timing a
  /// template must not retroactively change whether last Tuesday's step
  /// lapsed.
  IntColumn get xpAwarded => integer()();
  TextColumn get stat => textEnum<StatType>()();
  IntColumn get scheduledMinutes => integer().nullable()();
  IntColumn get graceMinutes => integer().withDefault(const Constant(120))();

  /// Stops the same quest being issued twice for one day.
  @override
  List<Set<Column>> get uniqueKeys => [
    {templateId, day},
  ];
}

/// One row per day. Pure cache: everything here is derivable from
/// [DailyQuests], but recomputing it on demand would mean scanning every quest
/// row to draw a streak or a 90-day chart.
@DataClassName('DayRollupRow')
class DayRollups extends Table {
  IntColumn get day => integer()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get xpAvailable => integer().withDefault(const Constant(0))();
  IntColumn get questsCleared => integer().withDefault(const Constant(0))();

  /// Steps that ended the day unanswered or answered as missed. Added in
  /// schema v3 so the weekly report can show misses without rescanning every
  /// quest row.
  IntColumn get questsMissed => integer().withDefault(const Constant(0))();

  IntColumn get questsTotal => integer().withDefault(const Constant(0))();
  BoolColumn get isPerfect => boolean().withDefault(const Constant(false))();
  IntColumn get strXp => integer().withDefault(const Constant(0))();
  IntColumn get staXp => integer().withDefault(const Constant(0))();
  IntColumn get disXp => integer().withDefault(const Constant(0))();
  IntColumn get recXp => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {day};
}

/// Exactly one row (id is always 0). Holds the player's running totals.
///
/// Level and rank are deliberately ABSENT — they are pure functions of
/// [totalXp] and computing them is an array lookup. Storing them would let
/// them drift out of sync with the XP that produced them.
/// [acknowledgedLevel] IS stored: it records the last level the player was
/// actually shown the animation for, which is what makes a level-up fire
/// exactly once and survive a restart. Filled in by Phase 4.
@DataClassName('PlayerStateRow')
class PlayerStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get hunterName => text().withDefault(const Constant('HUNTER'))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get strXp => integer().withDefault(const Constant(0))();
  IntColumn get staXp => integer().withDefault(const Constant(0))();
  IntColumn get disXp => integer().withDefault(const Constant(0))();
  IntColumn get recXp => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();

  /// Days where every scheduled quest was cleared. Added in schema v2.
  IntColumn get perfectDays => integer().withDefault(const Constant(0))();
  IntColumn get lastActiveDay => integer().nullable()();
  IntColumn get acknowledgedLevel => integer().withDefault(const Constant(1))();
  TextColumn get acknowledgedRank => text().withDefault(const Constant('E'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only event feed. Powers the LOG screen in Phase 9.
@DataClassName('ActivityLogRow')
class ActivityLogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  TextColumn get kind => textEnum<ActivityKind>()();
  TextColumn get title => text()();
  TextColumn get detail => text().nullable()();
  IntColumn get xpDelta => integer().nullable()();
}
