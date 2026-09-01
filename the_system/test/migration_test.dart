import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/day_key.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/nutrition_repository.dart';
import 'package:the_system/data/repositories/player_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// Proves the upgrade paths work on a database that already holds data.
///
/// This matters because v1 and v2 both ran on a real device, so the upgrades
/// are not hypothetical. A migration only ever exercised by `onCreate` (a
/// fresh install) is untested where it counts — and v3 is the first one that
/// RETIRES a column, which is the kind of migration that loses history when
/// it's wrong.
void main() {
  late Directory tempDir;
  late File dbFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('the_system_migration');
    dbFile = File('${tempDir.path}/the_system.sqlite');
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  test('upgrading a v2 database keeps completions and gains timings', () async {
    final day = DateTime(2026, 8, 26);

    // 1. Create at the current schema and record a real completion.
    final old = AppDatabase(NativeDatabase(dbFile));
    final repo = QuestRepository(old);
    await repo.materialiseDay(day);
    final quests = await repo.watchDay(day).first;
    final skincare =
        quests.firstWhere((q) => q.template.id == 'morning_skincare');
    await repo.setStatus(skincare, QuestStatus.done);

    // 2. Rewind it to look exactly like schema v2.
    await _rewindToV2(old);
    await old.close();

    // 3. Reopening runs onUpgrade(from: 2, to: 3).
    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final after = await QuestRepository(upgraded).watchDay(day).first;

    // The completion survived the boolean being retired...
    final migrated = after.firstWhere((q) => q.id == skincare.id);
    expect(migrated.status, QuestStatus.done);
    // ...and nothing else was quietly marked done along with it.
    expect(
      after.where((q) => q.status == QuestStatus.done),
      hasLength(1),
    );
    expect(
      after.where((q) => q.status == QuestStatus.pending),
      hasLength(after.length - 1),
    );

    // Timings were backfilled onto both the catalog and the issued quests,
    // so days that predate the routine still take part in it.
    final detox = after.firstWhere((q) => q.template.id == 'detox_drink');
    expect(detox.scheduledMinutes, 5 * 60 + 35);
    expect(detox.graceMinutes, 45);
    expect(detox.template.scheduledMinutes, 5 * 60 + 35);

    // The retired column is genuinely gone, not just ignored.
    final columns = await upgraded
        .customSelect('PRAGMA table_info(daily_quests)')
        .get();
    expect(
      columns.map((c) => c.read<String>('name')),
      isNot(contains('done')),
    );

    await upgraded.close();
  });

  test('upgrading a v1 database adds perfect_days and keeps existing data', () async {
    final v1 = AppDatabase(NativeDatabase(dbFile));
    await v1.customStatement('SELECT 1'); // forces onCreate + seeding
    await v1.customStatement(
      'UPDATE player_states SET hunter_name = ?, total_xp = 500 WHERE id = 0',
      ['OLD_SAVE'],
    );
    await _rewindToV1(v1);
    await v1.close();

    // Reopening runs onUpgrade(from: 1, to: 3) — both steps, in order.
    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final player = await (upgraded.select(upgraded.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();

    // The new column exists and defaults sensibly...
    expect(player.perfectDays, 0);
    // ...and nothing that was already there was lost.
    expect(player.hunterName, 'OLD_SAVE');
    expect(player.totalXp, 500);

    // The seeded catalog survived and picked up its routine timings.
    final templates = await upgraded.select(upgraded.taskTemplates).get();
    expect(templates, isNotEmpty);
    expect(
      templates.every((t) => t.scheduledMinutes != null),
      isTrue,
      reason: 'every seeded template should have a time after v3',
    );

    await upgraded.close();
  });

  test('upgrading a v3 database gains the lifetime quest counter', () async {
    final day = DateTime(2026, 8, 26);

    final old = AppDatabase(NativeDatabase(dbFile));
    final repo = QuestRepository(old);
    await repo.materialiseDay(day);
    for (final quest in await repo.watchDay(day).first) {
      await repo.setStatus(quest, QuestStatus.done);
    }
    final clearedBefore = (await (old.select(old.playerStates)
              ..where((p) => p.id.equals(0)))
            .getSingle())
        .questsCleared;
    expect(clearedBefore, greaterThan(0));

    await _rewindToV3(old);
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    var player = await (upgraded.select(upgraded.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();
    // The column arrives at its default; nothing is lost, because the value is
    // a cache that recomputeAll rebuilds from daily_quests.
    expect(player.questsCleared, 0);

    await QuestRepository(upgraded).recomputeAll();
    player = await (upgraded.select(upgraded.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();
    expect(player.questsCleared, clearedBefore);

    await upgraded.close();
  });

  test('upgrading a v5 database gains the training tables', () async {
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1'); // force onCreate
    await old.customStatement(
      'UPDATE player_states SET hunter_name = ? WHERE id = 0',
      ['OLD_SAVE'],
    );
    await _rewindToV5(old);
    await old.close();

    // Reopening runs onUpgrade(from: 5, to: 6).
    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final repo = WorkoutRepository(
      upgraded,
      clock: FixedClock(DateTime(2026, 8, 31, 7)), // a Monday
    );

    // The new tables exist and a session can actually be built in them.
    final session = await repo.openSession(DateTime(2026, 8, 31));
    expect(session, isNotNull);
    expect(session!.exercises, isNotEmpty);

    // Week 1 of the programme, because the start day is recorded on first use
    // rather than inferred from data that predates training.
    expect(session.week, 1);
    expect(session.phase, TrainingPhase.reset);

    final player = await (upgraded.select(upgraded.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();
    expect(player.hunterName, 'OLD_SAVE');
    expect(player.programmeStartDay, isNotNull);

    await upgraded.close();
  });

  test('upgrading a v7 database gains the reward bookkeeping', () async {
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1');
    await old.customStatement(
      'UPDATE player_states SET total_xp = 5000, acknowledged_level = 3 '
      'WHERE id = 0',
    );
    await _rewindToV7(old);
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final player = await PlayerRepository(upgraded).read();

    // Nothing lost, and the new column starts empty — so medals already
    // earned are announced once on the next launch rather than never.
    expect(player.totalXp, 5000);
    expect(player.acknowledgedLevel, 3);
    expect(player.acknowledgedMedals, isEmpty);
    expect(player.pending, isNotEmpty);

    await upgraded.close();
  });

  test('upgrading a v8 database gains the meal rotation', () async {
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1'); // force onCreate
    await old.customStatement(
      'UPDATE player_states SET total_xp = 900 WHERE id = 0',
    );
    await _rewindToV8(old);
    await old.close();

    // Reopening runs onUpgrade(from: 8, to: 9), which must also SEED the
    // rotation — an existing database has no meals, and an empty plan would
    // look like a broken screen rather than a missing migration.
    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final wednesday = DateTime(2026, 9, 2);
    final day = await NutritionRepository(upgraded).readDay(wednesday);

    // The rotation survives as REFERENCE — something to cook from. Nothing is
    // logged against it any more; eating is typed in plain words.
    expect(day.plan, isNotEmpty);
    expect(day.plan.map((m) => m.id), contains('breakfast_wed'));
    expect(day.entries, isEmpty);

    final player = await PlayerRepository(upgraded).read();
    expect(player.totalXp, 900, reason: 'nothing lost');

    await upgraded.close();
  });

  test('upgrading a v11 database gains the note source', () async {
    final monday = DateTime(2026, 8, 31);

    // A session that existed BEFORE the column did — which is the only case
    // the column's default actually governs.
    final old = AppDatabase(NativeDatabase(dbFile));
    final before = await WorkoutRepository(
      old,
      clock: FixedClock(monday),
    ).openSession(monday);
    expect(before, isNotNull);
    await _rewindToV11(old);
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final after = await WorkoutRepository(
      upgraded,
      clock: FixedClock(monday),
    ).openSession(monday);

    // Still the same session, and its notes are labelled `history` — which is
    // what they were: passages quoted from the record, not written by anyone.
    expect(after!.id, before!.id);
    expect(after.noteSource, TrainerNoteSource.history);
    await upgraded.close();
  });

  test('adding a column twice is not an error', () async {
    // createTable builds the CURRENT shape, so an old database gets columns a
    // later addColumn would also try to add. This is the guard for that.
    final db = AppDatabase(NativeDatabase(dbFile));
    await db.customStatement('SELECT 1');

    final columns = await db
        .customSelect('PRAGMA table_info(workout_sessions)')
        .get();
    final names = {for (final r in columns) r.read<String>('name')};
    expect(names, contains('notes'));
    expect(names, contains('note_source'));

    await db.close();
  });

  test('a database created fresh is already at the current schema', () async {
    final db = AppDatabase(NativeDatabase(dbFile));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), db.schemaVersion);
    await db.close();
  });

  test('a column no migration step adds is healed on open', () async {
    // The guard for the bug that shipped in v13: a column was added to the
    // Dart table definition and given no migration step, so `createAll` built
    // it on fresh installs while every UPGRADED database went without. Drift's
    // row mapper null-checks a non-nullable column, so the app threw
    // "Unexpected null value" on open — before any screen could render.
    //
    // The test has to be careful not to be circular. Rewinding by dropping the
    // columns the migration is known to add would only ever re-prove what was
    // already written down. So it also drops one that NO step touches from
    // v12: quests_cleared is added by `from < 4`, which a v12 database never
    // runs. If it comes back, only the sweep can have brought it — and the
    // sweep reads the table definitions, so it covers v15 and everything
    // after without this test being edited.
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1');
    await _rewindToV12(old);
    await old.customStatement(
      'ALTER TABLE player_states DROP COLUMN quests_cleared',
    );
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    for (final table in upgraded.allTables) {
      final info = await upgraded
          .customSelect('PRAGMA table_info(${table.actualTableName})')
          .get();
      final live = {for (final row in info) row.read<String>('name')};
      for (final column in table.$columns) {
        expect(
          live,
          contains(column.name),
          reason:
              '${table.actualTableName}.${column.name} is declared in Dart '
              'but no migration adds it to an existing database',
        );
      }
    }

    // And the row is readable, which is the failure actually seen on device:
    // the whole app died on open with "Unexpected null value".
    final player = await PlayerRepository(upgraded).watch().first;
    expect(player.questsCleared, 0);
    await upgraded.close();
  });

  test('upgrading a v13 database gains the body-composition baseline',
      () async {
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1');
    await _rewindToV13(old);
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final view = await ProgressRepository(upgraded).read(ChartRange.all);

    // The migration seeds the baseline as well as creating the table. Same
    // reasoning as the v9 meal rotation: an upgrade that leaves the table
    // empty gives an existing install a chart with nothing on it, and the
    // 2026-08-07 scan is the origin the whole line is measured from.
    expect(view.baseline, isNotNull);
    expect(view.baseline!.weightKg, 79.5);
    expect(view.baseline!.date, DateTime(2026, 8, 7));

    await upgraded.close();
  });

  test('upgrading a v14 database keeps the scan and gains the full panel',
      () async {
    final old = AppDatabase(NativeDatabase(dbFile));
    await old.customStatement('SELECT 1');
    await _rewindToV14(old);

    // A v14 database holds the baseline in its six-column form. Read with
    // raw SQL, not the repository: the repository queries body_segments,
    // which does not exist yet at v14.
    final before = await old
        .customSelect('SELECT weight_kg FROM body_measurements')
        .getSingle();
    expect(before.read<double>('weight_kg'), 79.5);
    await old.close();

    final upgraded = AppDatabase(NativeDatabase(dbFile));
    final after = await ProgressRepository(upgraded).read(ChartRange.all);

    // alterTable rebuilt the table and carried the row across — the scan is
    // not re-created, it is widened.
    expect(after.scans, hasLength(1));
    expect(after.baseline!.weightKg, 79.5);
    expect(after.baseline!.skeletalMuscleKg, 29.1);
    expect(after.baseline!.segments, hasLength(5));
    expect(after.labs, isNotEmpty);

    await upgraded.close();
  });

  test('day numbers survive a round trip through the database', () {
    // Not a migration, but the same class of bug: every stored day is an
    // integer, and a day that decodes to a different date corrupts history
    // just as thoroughly as a bad ALTER TABLE.
    final date = DateTime(2026, 8, 26);
    expect(dateOfDayKey(dayKeyOf(date)), date);
  });
}

/// Rewinds a freshly created database so it looks like schema v14.
Future<void> _rewindToV14(AppDatabase db) async {
  await db.customStatement('DROP TABLE IF EXISTS body_segments');
  await db.customStatement('DROP TABLE IF EXISTS lab_results');
  // v14's body_measurements was the six-column version.
  for (final column in const [
    'at_minutes', 'height_cm', 'bmi', 'fat_mass_kg', 'fat_free_mass_kg',
    'skeletal_muscle_kg', 'skeletal_muscle_percent', 'bone_mass_kg',
    'protein_kg', 'total_body_water_kg', 'total_body_water_percent',
    'extracellular_water_kg', 'intracellular_water_kg', 'ecw_over_tbw_percent',
    'bmr_kj', 'sarcopenic_index', 'phase_angle_deg', 'impedance_ohm',
  ]) {
    await db.customStatement(
      'ALTER TABLE body_measurements DROP COLUMN $column',
    );
  }
  await db.customStatement('PRAGMA user_version = 14');
}

/// Rewinds a freshly created database so it looks like schema v13.
Future<void> _rewindToV13(AppDatabase db) async {
  await _rewindToV14(db);
  await db.customStatement('DROP TABLE IF EXISTS body_measurements');
  await db.customStatement('PRAGMA user_version = 13');
}

/// Rewinds a freshly created database so it looks like schema v12.
Future<void> _rewindToV12(AppDatabase db) async {
  await _rewindToV13(db);
  await db.customStatement(
    'ALTER TABLE workout_sessions DROP COLUMN summoned_at',
  );
  await db.customStatement('ALTER TABLE workout_sets DROP COLUMN is_extra');
  await db.customStatement('ALTER TABLE day_rollups DROP COLUMN bonus_xp');
  await db.customStatement('PRAGMA user_version = 12');
}

/// Rewinds a freshly created database so it looks like schema v11.
///
/// Each rewind chains through the one above it, so a test that opens a v9
/// database really does replay v9 -> v10 -> ... -> current, rather than
/// replaying one step against an otherwise-modern schema.
Future<void> _rewindToV11(AppDatabase db) async {
  await _rewindToV12(db);
  await db.customStatement(
    'ALTER TABLE workout_sessions DROP COLUMN note_source',
  );
  await db.customStatement('PRAGMA user_version = 11');
}

/// Rewinds a freshly created database so it looks like schema v10.
Future<void> _rewindToV10(AppDatabase db) async {
  await _rewindToV11(db);
  await db.customStatement('PRAGMA user_version = 10');
}

/// Rewinds a freshly created database so it looks like schema v9.
Future<void> _rewindToV9(AppDatabase db) async {
  await _rewindToV10(db);
  await db.customStatement('DROP TABLE IF EXISTS food_log_entries');
  await db.customStatement('DROP TABLE IF EXISTS ai_calls');
  await db.customStatement('DROP TABLE IF EXISTS ai_cache_entries');
  await db.customStatement('PRAGMA user_version = 9');
}

/// Rewinds a freshly created database so it looks like schema v8.
Future<void> _rewindToV8(AppDatabase db) async {
  await _rewindToV9(db);
  await db.customStatement('DROP TABLE IF EXISTS meal_log_entries');
  await db.customStatement('DROP TABLE IF EXISTS meals');
  await db.customStatement('PRAGMA user_version = 8');
}

/// Rewinds a freshly created database so it looks like schema v7.
Future<void> _rewindToV7(AppDatabase db) async {
  await _rewindToV8(db);
  await db.customStatement(
    'ALTER TABLE player_states DROP COLUMN acknowledged_medals',
  );
  await db.customStatement('PRAGMA user_version = 7');
}

/// Rewinds a freshly created database so it looks like schema v6.
Future<void> _rewindToV6(AppDatabase db) async {
  await _rewindToV7(db);
  await db.customStatement('DROP TABLE IF EXISTS memory_chunks');
  await db.customStatement('DROP TABLE IF EXISTS memory_documents');
  await db.customStatement('PRAGMA user_version = 6');
}

/// Rewinds a freshly created database so it looks like schema v5.
Future<void> _rewindToV5(AppDatabase db) async {
  await _rewindToV6(db);
  await db.customStatement('ALTER TABLE workout_sessions DROP COLUMN notes');
  await db.customStatement('DROP TABLE IF EXISTS workout_sets');
  await db.customStatement('DROP TABLE IF EXISTS workout_sessions');
  await db.customStatement(
    'ALTER TABLE player_states DROP COLUMN programme_start_day',
  );
  await db.customStatement('PRAGMA user_version = 5');
}

/// Rewinds a freshly created database so it looks like schema v4.
Future<void> _rewindToV4(AppDatabase db) async {
  await _rewindToV5(db);
  await db.customStatement('ALTER TABLE player_states DROP COLUMN theme_mode');
  await db.customStatement('PRAGMA user_version = 4');
}

/// Rewinds a freshly created database so it looks like schema v3.
Future<void> _rewindToV3(AppDatabase db) async {
  await _rewindToV4(db);
  await db.customStatement(
    'ALTER TABLE player_states DROP COLUMN quests_cleared',
  );
  await db.customStatement('PRAGMA user_version = 3');
}

/// Rewinds a freshly created database so it looks like schema v2: the routine
/// columns removed and the old `done` boolean put back.
Future<void> _rewindToV2(AppDatabase db) async {
  await _rewindToV3(db);
  await db.customStatement(
    'ALTER TABLE daily_quests ADD COLUMN done INTEGER NOT NULL DEFAULT 0',
  );
  await db.customStatement(
    "UPDATE daily_quests SET done = 1 WHERE status = 'done'",
  );
  await db.customStatement('ALTER TABLE daily_quests DROP COLUMN status');
  await db.customStatement(
    'ALTER TABLE daily_quests DROP COLUMN scheduled_minutes',
  );
  await db.customStatement('ALTER TABLE daily_quests DROP COLUMN grace_minutes');
  await db.customStatement(
    'ALTER TABLE task_templates DROP COLUMN scheduled_minutes',
  );
  await db.customStatement(
    'ALTER TABLE task_templates DROP COLUMN grace_minutes',
  );
  await db.customStatement('ALTER TABLE day_rollups DROP COLUMN quests_missed');
  // The version marker drift reads on open to decide which upgrades to run.
  await db.customStatement('PRAGMA user_version = 2');
}

/// v1 is v2 without the perfect-days counter.
Future<void> _rewindToV1(AppDatabase db) async {
  await _rewindToV2(db);
  await db.customStatement('ALTER TABLE player_states DROP COLUMN perfect_days');
  await db.customStatement('PRAGMA user_version = 1');
}
