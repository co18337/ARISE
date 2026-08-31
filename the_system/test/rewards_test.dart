import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/player_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';
import 'package:the_system/screens/daily_report_overlay.dart';
import 'package:the_system/screens/reward_overlay.dart';
import 'package:the_system/theme/theme.dart';

void main() {
  List<RewardEvent> pending({
    required int totalXp,
    int seenLevel = 1,
    Rank seenRank = Rank.e,
    Map<AchievementId, AchievementTier> seenMedals = const {},
    AchievementMetrics metrics = AchievementMetrics.empty,
  }) => pendingRewards(
    totalXp: totalXp,
    curve: GameRules.hunter,
    achievements: evaluateAchievements(metrics),
    seen: AcknowledgedRewards(
      level: seenLevel,
      rank: seenRank,
      medals: seenMedals,
    ),
  );

  group('what gets celebrated', () {
    test('a fresh player is owed nothing', () {
      expect(pending(totalXp: 0), isEmpty);
    });

    test('crossing a level is owed once', () {
      // 100 XP is level 2 on the hunter curve.
      expect(pending(totalXp: 100).whereType<LevelUpReward>(), hasLength(1));
      // Already seen: nothing owed.
      expect(pending(totalXp: 100, seenLevel: 2), isEmpty);
    });

    test('crossing several levels at once is ONE moment, not three', () {
      // A backfill can jump multiple levels. Three identical modals to tap
      // through would be worse than one that says the level you reached.
      final events = pending(totalXp: 100000).whereType<LevelUpReward>();
      expect(events, hasLength(1));
      expect(events.single.level, GameRules.hunter.levelForXp(100000));
    });

    test('a rank promotion comes with its level-up, and lands last', () {
      // Level 5 is D rank.
      final xp = GameRules.hunter.totalXpToReach(5);
      final events = pending(totalXp: xp);

      expect(events.whereType<LevelUpReward>(), hasLength(1));
      expect(events.whereType<RankUpReward>(), hasLength(1));
      // Ordered smallest first, so the promotion is the one you remember.
      expect(events.last, isA<RankUpReward>());
    });

    test('a medal is owed once per tier reached', () {
      const metrics = AchievementMetrics(longestStreak: 10);

      final first = pending(totalXp: 0, metrics: metrics)
          .whereType<MedalReward>()
          .toList();
      expect(first, hasLength(1));
      expect(first.single.id, AchievementId.resolve);
      expect(first.single.tier, AchievementTier.silver);

      // Seen at silver: nothing owed.
      expect(
        pending(
          totalXp: 0,
          metrics: metrics,
          seenMedals: {AchievementId.resolve: AchievementTier.silver},
        ),
        isEmpty,
      );

      // Seen only at bronze: the silver is still owed.
      expect(
        pending(
          totalXp: 0,
          metrics: metrics,
          seenMedals: {AchievementId.resolve: AchievementTier.bronze},
        ).whereType<MedalReward>(),
        hasLength(1),
      );
    });
  });

  group('acknowledgement survives a restart', () {
    test('encodes and decodes, and shrugs off nonsense', () {
      const medals = {
        AchievementId.resolve: AchievementTier.gold,
        AchievementId.flawless: AchievementTier.bronze,
      };
      expect(decodeAcknowledgedMedals(encodeAcknowledgedMedals(medals)), medals);

      expect(decodeAcknowledgedMedals(''), isEmpty);
      expect(decodeAcknowledgedMedals(null), isEmpty);
      // A value written by a future build: skipped, never thrown on.
      expect(decodeAcknowledgedMedals('nosuchmedal:2,resolve:99'), isEmpty);
      expect(
        decodeAcknowledgedMedals('resolve:1,garbage'),
        {AchievementId.resolve: AchievementTier.silver},
      );
    });
  });

  group('through the database', () {
    late AppDatabase db;
    late PlayerRepository players;
    late QuestRepository quests;

    final wednesday = DateTime(2026, 8, 26);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      players = PlayerRepository(db);
      quests = QuestRepository(db);
    });

    tearDown(() => db.close());

    test('a perfect day owes a medal, and only until it is acknowledged',
        () async {
      await quests.materialiseDay(wednesday);
      for (final quest in await quests.watchDay(wednesday).first) {
        await quests.setStatus(quest, QuestStatus.done);
      }

      var player = await players.read();
      expect(player.pending, isNotEmpty);
      expect(
        player.pending.whereType<MedalReward>().map((m) => m.id),
        contains(AchievementId.flawless),
      );

      await players.acknowledgeRewards();

      player = await players.read();
      expect(player.pending, isEmpty, reason: 'nothing owed twice');

      // And it stays acknowledged across a reopen of the same file.
      expect(player.acknowledgedMedals[AchievementId.flawless], isNotNull);
      expect(player.acknowledgedLevel, player.level);
      expect(player.acknowledgedRank, player.rank);
    });

    test('acknowledging nothing is harmless', () async {
      await players.acknowledgeRewards();
      final player = await players.read();
      expect(player.pending, isEmpty);
      expect(player.acknowledgedLevel, 1);
    });
  });

  group('the surfaces', _uiTests);
}

/// Widget-level checks for the two Phase 7 surfaces.
///
/// Kept deterministic by building them directly with known input rather than
/// by playing a whole day through the app and hoping a reward happens to land.
void _uiTests() {
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Widget host(Widget child) => MaterialApp(
    theme: AppTheme.dark,
    home: child,
  );

  testWidgets('the reward overlay shows each moment, biggest last', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const RewardOverlay(
          events: [
            LevelUpReward(5),
            MedalReward(AchievementId.resolve, AchievementTier.silver),
            RankUpReward(Rank.d),
          ],
        ),
      ),
    );
    await settle(tester);

    // First: the level.
    expect(find.text('LEVEL UP'), findsOneWidget);
    expect(find.text('LEVEL 5'), findsOneWidget);
    // It says how many more are queued rather than surprising you each time.
    expect(find.textContaining('2 MORE'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await settle(tester);
    expect(find.text('SILVER MEDAL'), findsOneWidget);
    expect(find.text('RESOLVE'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await settle(tester);
    expect(find.text('RANK UP'), findsOneWidget);
    expect(find.text('D RANK'), findsOneWidget);
    expect(find.text('CONTINUE'), findsOneWidget);
  });

  testWidgets('a level-up alone offers Continue immediately', (tester) async {
    await tester.pumpWidget(
      host(const RewardOverlay(events: [LevelUpReward(2)])),
    );
    await settle(tester);
    expect(find.text('CONTINUE'), findsOneWidget);
    expect(find.textContaining('MORE'), findsNothing);
  });

  testWidgets('the daily report reports the misses too', (tester) async {
    tester.view.physicalSize = const Size(400 * 3, 1600 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    DailyTask task(String title, QuestStatus status, int xp, StatType stat) =>
        DailyTask(
          id: title.hashCode,
          template: TaskTemplate(
            id: title,
            title: title,
            category: TaskCategory.diet,
            stat: stat,
            schedule: ScheduleType.daily,
            xp: xp,
            scheduledMinutes: 8 * 60,
          ),
          date: DateTime(2026, 8, 26),
          status: status,
          completedAt: null,
          xpAwarded: xp,
          stat: stat,
          scheduledMinutes: 8 * 60,
          graceMinutes: 60,
        );

    await tester.pumpWidget(
      host(
        DailyReportOverlay(
          date: DateTime(2026, 8, 26),
          tasks: [
            task('Detox drink', QuestStatus.done, 5, StatType.rec),
            task('Workout of the day', QuestStatus.done, 20, StatType.str),
            task('Sleep by 11pm', QuestStatus.missed, 15, StatType.dis),
          ],
        ),
      ),
    );
    await settle(tester);

    expect(find.text('DAY CLOSED'), findsOneWidget);
    // Not a perfect day, and it says so rather than quietly rounding up.
    expect(find.text('PERFECT DAY'), findsNothing);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('MISSED'), findsWidgets);
    expect(find.text('Sleep by 11pm'), findsOneWidget);
    // XP is banked, and the miss costs none of it.
    expect(find.text('25'), findsWidgets);
  });

  testWidgets('a clean sweep reads as a perfect day', (tester) async {
    tester.view.physicalSize = const Size(400 * 3, 1600 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        DailyReportOverlay(
          date: DateTime(2026, 8, 26),
          tasks: [
            DailyTask(
              id: 1,
              template: const TaskTemplate(
                id: 'a',
                title: 'Morning skincare',
                category: TaskCategory.skincareAM,
                stat: StatType.rec,
                schedule: ScheduleType.daily,
                xp: 10,
                scheduledMinutes: 430,
              ),
              date: DateTime(2026, 8, 26),
              status: QuestStatus.done,
              completedAt: null,
              xpAwarded: 10,
              stat: StatType.rec,
              scheduledMinutes: 430,
              graceMinutes: 90,
            ),
          ],
        ),
      ),
    );
    await settle(tester);

    expect(find.text('PERFECT DAY'), findsOneWidget);
    expect(find.text('MISSED'), findsNothing);
  });
}
