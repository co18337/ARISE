import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/day_key.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/player_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

void main() {
  late AppDatabase db;
  late QuestRepository quests;
  late PlayerRepository player;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    quests = QuestRepository(db);
    player = PlayerRepository(db);
  });

  tearDown(() => db.close());

  /// Clears every quest on [date], which is a perfect day.
  Future<void> clearWholeDay(DateTime date) async {
    await quests.materialiseDay(date);
    for (final quest in await quests.watchDay(date).first) {
      await quests.setDone(quest, true);
    }
  }

  test('a new player starts at level 1, rank E, no streak', () async {
    final snapshot = await player.read();
    expect(snapshot.totalXp, 0);
    expect(snapshot.level, 1);
    expect(snapshot.rank, Rank.e);
    expect(snapshot.currentStreak, 0);
    expect(snapshot.perfectDays, 0);
    expect(snapshot.hasUnseenLevelUp, isFalse);
  });

  test('XP earned raises the level and is reflected in progress', () async {
    // A perfect Wednesday is 88 XP — not quite the 100 needed for level 2.
    await clearWholeDay(DateTime(2026, 8, 26));
    var snapshot = await player.read();
    expect(snapshot.totalXp, 88);
    expect(snapshot.level, 1);
    expect(snapshot.progress.xpIntoLevel, 88);

    // A second perfect day pushes past the threshold.
    await clearWholeDay(DateTime(2026, 8, 27));
    snapshot = await player.read();
    expect(snapshot.totalXp, 176);
    expect(snapshot.level, 2);
    expect(snapshot.progress.xpIntoLevel, 76); // 176 - 100
  });

  test('levelling up writes exactly one activity log entry', () async {
    await clearWholeDay(DateTime(2026, 8, 26));
    await clearWholeDay(DateTime(2026, 8, 27));

    final levelUps = await (db.select(db.activityLogEntries)
          ..where((e) => e.kind.equalsValue(ActivityKind.levelUp)))
        .get();
    expect(levelUps, hasLength(1));
    expect(levelUps.single.title, 'LEVEL 2');
  });

  test('recomputeAll does not re-log level-ups it already recorded', () async {
    await clearWholeDay(DateTime(2026, 8, 26));
    await clearWholeDay(DateTime(2026, 8, 27));

    await quests.recomputeAll();
    await quests.recomputeAll();

    final levelUps = await (db.select(db.activityLogEntries)
          ..where((e) => e.kind.equalsValue(ActivityKind.levelUp)))
        .get();
    expect(levelUps, hasLength(1));
  });

  test('perfect days are counted, partial days are not', () async {
    await clearWholeDay(DateTime(2026, 8, 26));

    // Clear only one quest on the next day.
    final partial = DateTime(2026, 8, 27);
    await quests.materialiseDay(partial);
    final some = await quests.watchDay(partial).first;
    await quests.setDone(some.first, true);

    expect((await player.read()).perfectDays, 1);
  });

  test('per-stat XP accumulates onto the right stat and levels it', () async {
    await clearWholeDay(DateTime(2026, 8, 26));
    final snapshot = await player.read();

    // Wednesday: REC gets detox 5 + morning 10 + sunscreen 5 + lip 3 +
    // water 10 + night 10 = 43. DIS gets dinner 10 + sleep 15 = 25.
    // STR gets the workout 20. STA has nothing scheduled.
    expect(snapshot.statXp[StatType.rec], 43);
    expect(snapshot.statXp[StatType.dis], 25);
    expect(snapshot.statXp[StatType.str], 20);
    expect(snapshot.statXp[StatType.sta], 0);

    // Stats use the cheaper curve (60 base), so 43 REC is still level 1.
    expect(snapshot.statProgress(StatType.rec).level, 1);
    expect(snapshot.statProgress(StatType.sta).level, 1);
  });

  test('consecutive qualifying days build a streak', () async {
    final today = DateTime.now();
    await clearWholeDay(today.subtract(const Duration(days: 2)));
    await clearWholeDay(today.subtract(const Duration(days: 1)));
    await clearWholeDay(today);

    final snapshot = await player.read();
    expect(snapshot.currentStreak, 3);
    expect(snapshot.longestStreak, 3);
  });

  test('a day below the 60% bar does not count toward the streak', () async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // Yesterday: clear a single low-value quest, well under 60%.
    await quests.materialiseDay(yesterday);
    final some = await quests.watchDay(yesterday).first;
    await quests.setDone(some.firstWhere((q) => q.xpAwarded == 3), true);

    await clearWholeDay(today);

    final snapshot = await player.read();
    expect(snapshot.currentStreak, 1); // today only
  });

  test('acknowledging a level clears the unseen level-up flag', () async {
    await clearWholeDay(DateTime(2026, 8, 26));
    await clearWholeDay(DateTime(2026, 8, 27));

    expect((await player.read()).level, 2);
    expect((await player.read()).hasUnseenLevelUp, isTrue);

    await player.acknowledgeCurrentLevel();
    expect((await player.read()).hasUnseenLevelUp, isFalse);
  });

  test('openToday backfills days the app was not opened on', () async {
    // Pretend the app was last used three days ago.
    await (db.update(db.playerStates)..where((p) => p.id.equals(0)))
        .write(PlayerStatesCompanion(lastActiveDay: Value(todayKey() - 3)));

    await quests.openToday();

    // The two skipped days now exist as explicit, uncleared days rather than
    // simply being absent — which is what makes the streak gap real.
    for (var back = 1; back <= 2; back++) {
      final rollup = await (db.select(db.dayRollups)
            ..where((r) => r.day.equals(todayKey() - back)))
          .getSingleOrNull();
      expect(rollup, isNotNull, reason: '$back day(s) ago should be backfilled');
      expect(rollup!.questsCleared, 0);
      expect(rollup.questsTotal, greaterThan(0));
    }
  });

  test('backfill is bounded so a bad device clock cannot explode', () async {
    await (db.update(db.playerStates)..where((p) => p.id.equals(0)))
        .write(PlayerStatesCompanion(lastActiveDay: Value(todayKey() - 5000)));

    await quests.openToday();

    final days = await db.select(db.dayRollups).get();
    expect(days.length, lessThanOrEqualTo(GameRules.maxBackfillDays + 1));
  });

  test('progression survives a full rebuild from quests alone', () async {
    await clearWholeDay(DateTime(2026, 8, 26));
    await clearWholeDay(DateTime(2026, 8, 27));
    final before = await player.read();

    // Corrupt every cached total.
    await db.update(db.dayRollups).write(
      const DayRollupsCompanion(xpEarned: Value(9999), isPerfect: Value(false)),
    );
    await (db.update(db.playerStates)..where((p) => p.id.equals(0))).write(
      const PlayerStatesCompanion(
        totalXp: Value(9999),
        currentStreak: Value(77),
        perfectDays: Value(77),
      ),
    );

    await quests.recomputeAll();

    final after = await player.read();
    expect(after.totalXp, before.totalXp);
    expect(after.level, before.level);
    expect(after.perfectDays, before.perfectDays);
    expect(after.currentStreak, before.currentStreak);
  });
}
