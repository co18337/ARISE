import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

// database.g.dart is a `part of` this file, so it can only see the imports
// declared HERE — that's why the model enums, and TrainingPhase from the game
// engine, are imported even though this file never names them directly.
import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../task_catalog.dart';
import 'tables.dart';

// Tells build_runner to generate the query API into database.g.dart.
// That generated file is committed but NEVER hand-edited — regenerate with:
//   dart run build_runner build --delete-conflicting-outputs
part 'database.g.dart';

@DriftDatabase(
  tables: [
    TaskTemplates,
    DailyQuests,
    DayRollups,
    PlayerStates,
    ActivityLogEntries,
    WorkoutSessions,
    WorkoutSets,
    MemoryDocuments,
    MemoryChunks,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (`NativeDatabase.memory()`); leave it out in the
  /// app and it opens the real on-device file.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seed();
    },
    // Runs when an existing database was created by an older schemaVersion.
    // Each step is guarded by a version check. Steps are additive by default;
    // where a column genuinely has to go (v3 retires `done`), its values are
    // copied to the replacement FIRST, so no history is ever lost.
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(playerStates, playerStates.perfectDays);
      }
      if (from < 3) {
        await _upgradeToRoutineSchema(m);
      }
      if (from < 4) {
        // Purely additive. The value is backfilled by the first
        // recomputeAll()/openToday() that runs, which rebuilds every cached
        // total from daily_quests anyway.
        await m.addColumn(playerStates, playerStates.questsCleared);
      }
      if (from < 5) {
        // Purely additive, and it defaults to the look the app already had.
        await m.addColumn(playerStates, playerStates.themeMode);
      }
      if (from < 6) {
        // New tables plus one column; nothing existing is touched. The
        // programme start stays null until the first session opens, which is
        // what makes an upgraded database start at week 1 rather than
        // inheriting a week number from data that never existed.
        await m.createTable(workoutSessions);
        await m.createTable(workoutSets);
        await m.addColumn(playerStates, playerStates.programmeStartDay);
      }
      if (from < 7) {
        // New tables only; nothing existing is touched.
        await m.createTable(memoryDocuments);
        await m.createTable(memoryChunks);
      }
      if (from < 8) {
        await m.addColumn(playerStates, playerStates.acknowledgedMedals);
      }
    },
    beforeOpen: (details) async {
      // SQLite has foreign keys OFF by default; without this the
      // daily_quests -> task_templates reference would not be enforced.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// First-run seeding. From here on the DATABASE is the source of truth for
  /// the plan — TaskCatalog is only the initial seed, so editing a template
  /// in-app (Phase 9) won't be overwritten on next launch.
  Future<void> _seed() async {
    final now = DateTime.now();

    await batch((b) {
      b.insertAll(taskTemplates, [
        for (final (index, t) in TaskCatalog.all.indexed)
          TaskTemplatesCompanion.insert(
            id: t.id,
            title: t.title,
            category: t.category,
            stat: t.stat,
            schedule: t.schedule,
            daysOfWeek: Value(t.daysOfWeek),
            xp: t.xp,
            scheduledMinutes: Value(t.scheduledMinutes),
            graceMinutes: Value(t.graceMinutes),
            sortOrder: Value(index),
            createdAt: now,
          ),
      ]);
    });

    // The singleton player row must exist before anything tries to read it.
    //
    // id is passed EXPLICITLY. In SQLite a single INTEGER primary key is an
    // alias for the rowid, and an omitted rowid gets auto-assigned (1), which
    // silently ignores the column's `DEFAULT 0` — so every later
    // `where(id == 0)` lookup would find nothing.
    //
    // lastActiveDay starts at today so the missed-day backfill has a floor and
    // doesn't try to reconstruct history from before the app existed.
    await into(playerStates).insert(
      PlayerStatesCompanion(
        id: const Value(0),
        hunterName: const Value('PRINCE'),
        lastActiveDay: Value(dayKeyOf(now)),
      ),
    );
  }

  /// Schema v3 — the guided routine.
  ///
  /// Every step is additive except one: the `done` boolean genuinely has to
  /// go, because `status` supersedes it and leaving both would let them
  /// disagree. It is dropped only AFTER its values have been copied across, so
  /// no completion is ever lost.
  Future<void> _upgradeToRoutineSchema(Migrator m) async {
    await m.addColumn(taskTemplates, taskTemplates.scheduledMinutes);
    await m.addColumn(taskTemplates, taskTemplates.graceMinutes);
    await m.addColumn(dayRollups, dayRollups.questsMissed);
    await m.addColumn(dailyQuests, dailyQuests.status);
    await m.addColumn(dailyQuests, dailyQuests.scheduledMinutes);
    await m.addColumn(dailyQuests, dailyQuests.graceMinutes);

    // Carry every existing completion over to the new column. Anything not
    // done becomes `pending`, which is the honest starting point: the routine
    // engine will close it as missed once it sees the window has shut.
    await customStatement(
      "UPDATE daily_quests SET status = 'done' WHERE done = 1",
    );
    await customStatement('ALTER TABLE daily_quests DROP COLUMN done');

    await _applyRoutineTimings();
  }

  /// Writes the catalog's routine timings onto templates that were seeded
  /// before times existed, and copies them onto already-issued quests.
  ///
  /// Matched by id rather than by position, so a template the user has since
  /// added in-app is simply left alone instead of being given someone else's
  /// schedule.
  Future<void> _applyRoutineTimings() async {
    for (final (index, t) in TaskCatalog.all.indexed) {
      await (update(taskTemplates)..where((row) => row.id.equals(t.id))).write(
        TaskTemplatesCompanion(
          scheduledMinutes: Value(t.scheduledMinutes),
          graceMinutes: Value(t.graceMinutes),
          // The catalog is now kept in routine order, so re-seeding sortOrder
          // puts existing rows into the same order the day is walked in.
          sortOrder: Value(index),
        ),
      );
    }

    // Quests snapshot their timings, so existing rows need the values copied
    // across; without this every past quest would look like an "anytime" step.
    await customStatement('''
      UPDATE daily_quests SET
        scheduled_minutes = (
          SELECT scheduled_minutes FROM task_templates
          WHERE task_templates.id = daily_quests.template_id
        ),
        grace_minutes = COALESCE((
          SELECT grace_minutes FROM task_templates
          WHERE task_templates.id = daily_quests.template_id
        ), 120)
    ''');
  }
}

/// Opens the on-device database. drift_flutter picks the right backend per
/// platform: a `the_system.sqlite` file in the app documents directory on
/// Android, and sqlite3 compiled to WebAssembly (backed by OPFS or IndexedDB)
/// in the browser.
///
/// The `web:` options are REQUIRED — drift_flutter throws an ArgumentError on
/// web without them, and because this runs in main() before runApp() the app
/// dies before painting anything, showing a blank white page with no clue.
/// The two URIs are relative to the web root, i.e. the files committed in
/// `web/`. They are version-pinned to drift/sqlite3 — see ARCHITECTURE.md.
QueryExecutor _openConnection() => driftDatabase(
  name: 'the_system',
  web: DriftWebOptions(
    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
    driftWorker: Uri.parse('drift_worker.js'),
    onResult: _reportWebStorage,
  ),
);

/// Logs which storage backend the browser actually gave us.
///
/// This matters because the unreliable ones LOSE DATA SILENTLY — a quest ticked
/// just before a reload can simply not be there afterwards, with no error.
/// Without cross-origin isolation Chrome falls back to an IndexedDB-emulated
/// file system; see the run command in ARCHITECTURE.md. Android is unaffected
/// (it uses a real SQLite file), so this is a dev-on-web concern only.
void _reportWebStorage(WasmDatabaseResult result) {
  final bool durable = switch (result.chosenImplementation) {
    WasmStorageImplementation.opfsShared ||
    WasmStorageImplementation.opfsLocks => true,
    _ => false,
  };

  if (durable) {
    debugPrint('[db] web storage: ${result.chosenImplementation.name} (durable)');
  } else {
    debugPrint(
      '[db] WARNING: web storage is ${result.chosenImplementation.name}, which '
      'can lose recent writes on reload. Missing browser features: '
      '${result.missingFeatures}. Run with the cross-origin isolation headers '
      '(see ./run_web.sh) to get durable OPFS storage.',
    );
  }
}
