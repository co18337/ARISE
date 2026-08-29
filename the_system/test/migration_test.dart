import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/day_key.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
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

  test('a database created fresh is already at the current schema', () async {
    final db = AppDatabase(NativeDatabase(dbFile));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), db.schemaVersion);
    await db.close();
  });

  test('day numbers survive a round trip through the database', () {
    // Not a migration, but the same class of bug: every stored day is an
    // integer, and a day that decodes to a different date corrupts history
    // just as thoroughly as a bad ALTER TABLE.
    final date = DateTime(2026, 8, 26);
    expect(dateOfDayKey(dayKeyOf(date)), date);
  });
}

/// Rewinds a freshly created database so it looks like schema v2: the routine
/// columns removed and the old `done` boolean put back.
Future<void> _rewindToV2(AppDatabase db) async {
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
