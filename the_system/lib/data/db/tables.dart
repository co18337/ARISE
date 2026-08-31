import 'package:drift/drift.dart';

import '../../game/game.dart';
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

  /// Lifetime quests cleared. Added in schema v4.
  ///
  /// Derivable from the rollups, and the STATUS screen still derives it per
  /// time window. It is kept here because achievement unlocks are detected by
  /// comparing the totals BEFORE a write against the ones after, and "before"
  /// only exists on this row.
  IntColumn get questsCleared => integer().withDefault(const Constant(0))();
  IntColumn get lastActiveDay => integer().nullable()();

  /// Day the training programme began, which is what phase and week are
  /// counted from. Added in schema v6; null until the first session opens.
  IntColumn get programmeStartDay => integer().nullable()();
  IntColumn get acknowledgedLevel => integer().withDefault(const Constant(1))();

  /// Which look the app is wearing: dark | warm | auto. Added in schema v5.
  ///
  /// A UI preference on the player row rather than in its own settings table:
  /// this row is already the single "everything about me" record, and one
  /// column is not worth a second table and a second repository.
  TextColumn get themeMode =>
      text().withDefault(const Constant('dark'))();
  TextColumn get acknowledgedRank => text().withDefault(const Constant('E'))();

  /// Highest medal tier already celebrated, per medal: `resolve:2,flawless:0`.
  /// Added in schema v8. Bookkeeping for the modals, not history — the medals
  /// themselves are always derived from totals.
  TextColumn get acknowledgedMedals =>
      text().withDefault(const Constant(''))();

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

/// One training session — at most one per day.
///
/// Created lazily when the day's session is first opened, like daily_quests:
/// pre-generating the future would freeze today's programme into next month
/// and defeat a plan that adapts to what you have actually done.
@DataClassName('WorkoutSessionRow')
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Integer day number — see lib/data/day_key.dart.
  IntColumn get day => integer()();

  /// Snapshotted at issue time, exactly like a quest's XP: the phase you were
  /// actually in when you trained, not the one you are in now.
  TextColumn get phase => textEnum<TrainingPhase>()();
  IntColumn get week => integer()();
  TextColumn get focus => text()();

  /// What the trainer noticed in your history when it issued this session,
  /// newline-separated. Stored rather than recomputed: it was written against
  /// the corpus as it stood that day, and re-deriving it later would quietly
  /// rewrite the past.
  TextColumn get notes => text().nullable()();

  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {day},
  ];
}

/// One prescribed set. Rows are created with the session and filled in as the
/// work is done, so an abandoned session still records exactly how far it got.
@DataClassName('WorkoutSetRow')
class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();

  /// Not a foreign key into a table: the exercise library is code, not rows,
  /// and history must survive an exercise being retired from it.
  TextColumn get exerciseId => text()();

  /// Position of the exercise in the session, and of the set within it.
  IntColumn get orderIndex => integer()();
  IntColumn get setIndex => integer()();

  /// What was asked, and what was actually managed.
  IntColumn get target => integer()();
  IntColumn get actual => integer().nullable()();

  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// A document the System can remember and search — a body scan, the plan, a
/// finished session, a day of health data, a note.
///
/// The TEXT lives here; files never do. A scanned PDF is kept on disk and only
/// its path is stored, exactly as CLAUDE.md requires for images.
@DataClassName('MemoryDocumentRow')
class MemoryDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<MemoryKind>()();
  TextColumn get title => text()();
  TextColumn get body => text()();

  /// The day this document is ABOUT, which is not always the day it was
  /// written — a scan uploaded in March can describe January.
  IntColumn get day => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  /// Path to the source file on disk, if there is one. Never the file itself.
  TextColumn get sourcePath => text().nullable()();

  /// Caller-supplied identity, so re-ingesting the same thing updates it
  /// instead of duplicating it. Sessions use `session:DAY`, and without it
  /// every app launch would re-import the same history.
  TextColumn get externalId => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {externalId},
  ];
}

/// One embedded slice of a document — the unit retrieval actually returns.
@DataClassName('MemoryChunkRow')
class MemoryChunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(MemoryDocuments, #id, onDelete: KeyAction.cascade)();

  IntColumn get chunkIndex => integer()();

  /// The slice of text this vector was built from.
  ///
  /// Named `content`, not `text`: a column called `text` makes the body
  /// `text()()` resolve to the getter itself rather than to drift's builder,
  /// and drift fails that by silently generating an EMPTY schema instead of
  /// reporting an error. The same trap waits for any column named after a
  /// column builder.
  TextColumn get content => text()();

  /// The vector, as raw float32 bytes.
  BlobColumn get embedding => blob()();

  IntColumn get dimensions => integer()();

  /// WHICH embedder produced this vector.
  ///
  /// Vectors from different models are not comparable — a cosine similarity
  /// between a hashed vector and a Gemini one is noise. Recording the producer
  /// is what makes it possible to notice, and to re-embed the corpus when the
  /// embedder changes rather than silently returning nonsense.
  TextColumn get embedder => text()();
}
