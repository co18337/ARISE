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

  /// XP earned for training beyond the prescription. Added in schema v13.
  ///
  /// Kept SEPARATE from xpEarned on purpose: xpEarned is quest XP and is what
  /// the streak and the perfect-day bar are measured against. Folding bonus
  /// work into it would let an extra ten minutes of walking paper over a day
  /// of missed quests.
  IntColumn get bonusXp => integer().withDefault(const Constant(0))();

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

  /// Bonus XP is deliberately NOT mirrored here, unlike questsCleared.
  /// It lives once, on the day rollups, and the lifetime figure is summed
  /// from them in _recomputeProgression. A second copy on this row was
  /// declared in v13, never written, never read, and shipped without a
  /// migration — so every database upgraded to v13 crashed on open. One
  /// number, one home.
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

  /// Whether [notes] were written by the model or copied from the corpus.
  /// Added in schema v12.
  TextColumn get noteSource => textEnum<TrainerNoteSource>()
      .withDefault(const Constant('history'))();

  /// When ARISE was tapped and the session was accepted.
  ///
  /// The session EXISTS before this — it is built by the rule engine the
  /// moment the day opens, so a dead network or a flat battery still leaves
  /// you a workout. Summoning reveals it and lets the trainer speak; the
  /// ceremony must never be the thing holding the door shut.
  DateTimeColumn get summonedAt => dateTime().nullable()();

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

  /// Work done BEYOND what was prescribed.
  ///
  /// Recorded and rewarded, but deliberately excluded from progressive
  /// overload. Counting six sets as "completed the prescription" would make
  /// the engine ask for more next week — enthusiasm bootstrapping itself into
  /// an injury. Extra work is yours; it does not move the ladder.
  BoolColumn get isExtra => boolean().withDefault(const Constant(false))();
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

/// The meal rotation, seeded from MealCatalog on first run.
///
/// A table rather than a constant list for the same reason the task catalog is
/// one: the plan is DATA, and editing a meal in-app later must survive the
/// next launch.
@DataClassName('MealRow')
class Meals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slot => textEnum<MealSlot>()();

  /// Weekdays this meal is served on, 1 = Monday. Empty means every day.
  TextColumn get daysOfWeek =>
      text().map(const DaysOfWeekConverter()).withDefault(const Constant(''))();

  IntColumn get kcal => integer()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  RealColumn get fibreG => real()();
  TextColumn get detail => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// What was actually eaten, and how much of it.
///
/// [portions] is a fraction rather than a boolean because half a dinner is the
/// normal case, and recording it as "eaten" would quietly overstate the day.
@DataClassName('MealLogRow')
class MealLogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Integer day number — see lib/data/day_key.dart.
  IntColumn get day => integer()();

  IntColumn get portions => integer().withDefault(const Constant(100))();

  TextColumn get mealId => text().references(Meals, #id)();
  DateTimeColumn get loggedAt => dateTime()();

  /// One row per meal per day; logging again updates the portion.
  @override
  List<Set<Column>> get uniqueKeys => [
    {day, mealId},
  ];
}

/// What was actually eaten, typed in plain words.
///
/// The RAW TEXT is the source of truth and is never overwritten. The macros
/// beside it are a derived cache — estimated by the model, or typed by hand,
/// or absent. That ordering is deliberate: an estimate that quietly replaced
/// what you wrote would leave no way to re-run it or check it.
@DataClassName('FoodLogRow')
class FoodLogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Integer day number — see lib/data/day_key.dart.
  IntColumn get day => integer()();
  TextColumn get slot => textEnum<MealSlot>()();

  /// Named `body`, not `text`: a column called `text` makes `text()()` resolve
  /// to the getter itself rather than drift's builder, and drift fails that by
  /// silently generating an EMPTY schema.
  TextColumn get body => text()();

  DateTimeColumn get loggedAt => dateTime()();

  /// Where the macros came from: nothing yet, the model, or typed by hand.
  TextColumn get macroSource =>
      textEnum<MacroSource>().withDefault(const Constant('none'))();

  /// The model's own confidence, 0..1. Null when a person typed the numbers.
  RealColumn get confidence => real().nullable()();

  IntColumn get kcal => integer().nullable()();
  RealColumn get proteinG => real().nullable()();
  RealColumn get carbsG => real().nullable()();
  RealColumn get fatG => real().nullable()();
  RealColumn get fibreG => real().nullable()();

  /// Per-item breakdown as JSON, so "2 chapatis + tea" can be shown itemised
  /// rather than as one opaque total.
  TextColumn get items => text().nullable()();

  /// Why the last analysis failed, if it did. Shown rather than swallowed.
  TextColumn get analysisError => text().nullable()();

  // Deliberately NO unique key on (day, slot). Eating twice in an afternoon
  // is normal, and forcing the second snack to overwrite the first — or to be
  // appended to its text — would lose what actually happened.
}

/// Every model call, recorded.
///
/// Not analytics — diagnostics. The first live call will fail on some detail
/// of the request shape, and without this the only symptom is a button that
/// does nothing. It is also what the daily budget counts.
@DataClassName('AiCallRow')
class AiCalls extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();

  /// Which lane made it: `nutrition`, `trainer`, `embedding`.
  TextColumn get lane => text()();
  TextColumn get model => text()();

  BoolColumn get ok => boolean()();

  /// Served from the cache without touching the network.
  BoolColumn get cached => boolean().withDefault(const Constant(false))();

  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  IntColumn get promptChars => integer().withDefault(const Constant(0))();
  IntColumn get responseChars => integer().withDefault(const Constant(0))();

  TextColumn get error => text().nullable()();
}

/// Answers already given, keyed by what was asked.
///
/// The same meal text must not cost a second call — retries become free, and
/// re-opening the day costs nothing.
@DataClassName('AiCacheRow')
class AiCacheEntries extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get lane => text()();
  TextColumn get response => text()();
  DateTimeColumn get at => dateTime()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}

/// A body-composition scan. One row per measurement, keyed by the day taken.
///
/// DATED ROWS, never a "current measurements" record that gets overwritten.
/// The six-month re-scan is a second row, and the whole point of the exercise
/// is the line between them: a table holding only the latest reading can say
/// where you are and never how far you have come.
///
/// The full MC-780 panel, because that is what the machine prints and a
/// transcription that drops half of it is a transcription you have to redo.
/// Everything except the weight is nullable — a bathroom scale gives one
/// number, the Tanita gives twenty, and demanding the full panel would mean
/// recording neither.
///
/// The app CHARTS these. It does not interpret them — no "your visceral fat
/// is concerning", no targets derived from a formula. That reading belongs to
/// a doctor, and the same rule governs the blood work in [LabResults].
@DataClassName('BodyMeasurementRow')
class BodyMeasurements extends Table {
  IntColumn get day => integer()();

  /// Minutes after midnight the scan was taken. Body water swings across a
  /// day, so two scans at different hours are not quite comparable and the
  /// time is part of the reading rather than trivia.
  IntColumn get atMinutes => integer().nullable()();

  RealColumn get weightKg => real()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get bmi => real().nullable()();

  RealColumn get bodyFatPercent => real().nullable()();
  RealColumn get fatMassKg => real().nullable()();
  RealColumn get fatFreeMassKg => real().nullable()();
  RealColumn get muscleMassKg => real().nullable()();

  /// Skeletal muscle only — a subset of muscle mass, and the one the
  /// sarcopenic index is built from. Not interchangeable with it.
  RealColumn get skeletalMuscleKg => real().nullable()();
  RealColumn get skeletalMusclePercent => real().nullable()();

  RealColumn get boneMassKg => real().nullable()();
  RealColumn get proteinKg => real().nullable()();

  /// Tanita's visceral fat RATING — a 1-59 index, not kilograms or a percent.
  IntColumn get visceralFat => integer().nullable()();

  RealColumn get totalBodyWaterKg => real().nullable()();
  RealColumn get totalBodyWaterPercent => real().nullable()();
  RealColumn get extracellularWaterKg => real().nullable()();
  RealColumn get intracellularWaterKg => real().nullable()();
  RealColumn get ecwOverTbwPercent => real().nullable()();

  IntColumn get bmrKcal => integer().nullable()();
  IntColumn get bmrKj => integer().nullable()();
  IntColumn get metabolicAge => integer().nullable()();

  /// Sarcopenic index, kg/m². Skeletal muscle scaled to height.
  RealColumn get sarcopenicIndex => real().nullable()();

  /// Phase angle in degrees at 50 kHz, and whole-body impedance in ohms.
  RealColumn get phaseAngleDeg => real().nullable()();
  IntColumn get impedanceOhm => integer().nullable()();

  /// Where it came from: 'Tanita MC-780', 'bathroom scale', and so on.
  TextColumn get source => text().withDefault(const Constant(''))();

  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {day};
}

/// One body region of one scan.
///
/// Its own table rather than thirty more columns on the scan: the MC-780
/// prints the same six figures for each of five segments, and a shape that
/// repeats is a row, not a column name with a prefix. It also means a scale
/// that reports no segments simply writes no rows.
@DataClassName('BodySegmentRow')
class BodySegments extends Table {
  IntColumn get day => integer()();

  /// trunk / rightArm / leftArm / rightLeg / leftLeg.
  TextColumn get segment => textEnum<BodySegment>()();

  RealColumn get fatPercent => real().nullable()();
  RealColumn get fatKg => real().nullable()();
  RealColumn get muscleKg => real().nullable()();
  RealColumn get fatFreeMassKg => real().nullable()();
  RealColumn get otherMassKg => real().nullable()();

  /// Tanita's balance ratings, -4..+4, against its reference population.
  /// Stored as printed. What they MEAN is not the app's to say.
  IntColumn get fatRating => integer().nullable()();
  IntColumn get muscleRating => integer().nullable()();

  /// Composite, not a surrogate id with a unique index beside it.
  /// insertOnConflictUpdate resolves against the PRIMARY KEY, so an id column
  /// here would mean a re-import silently appended a second copy of every
  /// segment instead of correcting the first. The same mistake already cost a
  /// day on the food log.
  @override
  Set<Column> get primaryKey => {day, segment};
}

/// One line from a lab report.
///
/// Long and thin on purpose. A blood panel is a different set of analytes
/// every time it is run, so a table with a column per test would need a
/// migration for every new panel; a row per result needs none, and the
/// reference interval travels WITH the value because ranges differ by lab,
/// method and age.
///
/// [flag] is copied from the report, never computed here. Deciding a number is
/// high is the interpretation this app does not do.
@DataClassName('LabResultRow')
class LabResults extends Table {
  IntColumn get day => integer()();

  /// Which group it was printed under: LIPID, LIVER, HEMOGRAM, VITALS.
  TextColumn get panel => text()();

  TextColumn get name => text()();

  /// Null for a text result like ABSENT, which lives in [textValue].
  RealColumn get value => real().nullable()();
  TextColumn get textValue => text().nullable()();

  TextColumn get unit => text().withDefault(const Constant(''))();

  RealColumn get refLow => real().nullable()();
  RealColumn get refHigh => real().nullable()();

  /// The range exactly as printed, for anything the two numbers cannot carry
  /// ("< 45", "9:1-23:1", "Adult : 17-43").
  TextColumn get refText => text().withDefault(const Constant(''))();

  /// As flagged on the report: '', 'high', 'low'. Copied, not decided.
  TextColumn get flag => text().withDefault(const Constant(''))();

  TextColumn get source => text().withDefault(const Constant(''))();

  /// One analyte, one panel, one day: that is the identity of a result, and
  /// making it the primary key is what lets a corrected transcription
  /// overwrite rather than accumulate.
  @override
  Set<Column> get primaryKey => {day, panel, name};
}
