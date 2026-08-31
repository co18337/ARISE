import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// The medal ladder: bronze early, platinum a long way off, and always one
/// more in sight.
void main() {
  AchievementMetrics metrics({
    int streak = 0,
    int perfect = 0,
    int cleared = 0,
    int xp = 0,
    int str = 0,
    int rec = 0,
  }) => AchievementMetrics(
    longestStreak: streak,
    perfectDays: perfect,
    questsCleared: cleared,
    totalXp: xp,
    statXp: {StatType.str: str, StatType.rec: rec},
  );

  AchievementProgress progressFor(AchievementId id, AchievementMetrics m) =>
      evaluateAchievements(m).firstWhere((a) => a.id == id);

  group('tiers', () {
    test('nothing is earned from a standing start', () {
      for (final a in evaluateAchievements(AchievementMetrics.empty)) {
        expect(a.tier, isNull, reason: a.id.label);
        expect(a.earned, isFalse);
      }
    });

    test('the streak medal climbs at 3, 10, 20 and 50 days', () {
      const id = AchievementId.resolve;
      expect(tierFor(id, 2), isNull);
      expect(tierFor(id, 3), AchievementTier.bronze);
      expect(tierFor(id, 9), AchievementTier.bronze);
      expect(tierFor(id, 10), AchievementTier.silver);
      expect(tierFor(id, 20), AchievementTier.gold);
      expect(tierFor(id, 49), AchievementTier.gold);
      expect(tierFor(id, 50), AchievementTier.platinum);
      // Platinum is the top; going further does not invent a tier.
      expect(tierFor(id, 5000), AchievementTier.platinum);
    });

    test('thresholds ascend for every medal', () {
      for (final id in AchievementId.values) {
        expect(id.thresholds, hasLength(AchievementTier.values.length),
            reason: id.label);
        for (var i = 1; i < id.thresholds.length; i++) {
          expect(id.thresholds[i], greaterThan(id.thresholds[i - 1]),
              reason: '${id.label} tier $i');
        }
      }
    });
  });

  group('progress toward the next tier', () {
    test('is measured from the tier already held, not from zero', () {
      // 15 days: silver (10) held, gold (20) next. Ten days of span, five
      // done, so halfway — NOT 15/20.
      final p = progressFor(AchievementId.resolve, metrics(streak: 15));
      expect(p.tier, AchievementTier.silver);
      expect(p.nextThreshold, 20);
      expect(p.fraction, closeTo(0.5, 0.001));
    });

    test('an unearned medal counts up toward bronze', () {
      final p = progressFor(AchievementId.resolve, metrics(streak: 1));
      expect(p.tier, isNull);
      expect(p.nextTier, AchievementTier.bronze);
      expect(p.nextThreshold, 3);
      expect(p.fraction, closeTo(1 / 3, 0.001));
    });

    test('a maxed medal reports no next tier', () {
      final p = progressFor(AchievementId.resolve, metrics(streak: 80));
      expect(p.tier, AchievementTier.platinum);
      expect(p.isMaxed, isTrue);
      expect(p.nextThreshold, isNull);
      expect(p.fraction, 1);
    });
  });

  group('each medal reads its own metric', () {
    test('they do not cross-contaminate', () {
      final m = metrics(streak: 50, perfect: 0, cleared: 0, xp: 0);
      expect(progressFor(AchievementId.resolve, m).tier,
          AchievementTier.platinum);
      expect(progressFor(AchievementId.flawless, m).tier, isNull);
      expect(progressFor(AchievementId.diligence, m).tier, isNull);
    });

    test('stat medals read their own stat', () {
      final m = metrics(str: 600, rec: 50);
      expect(progressFor(AchievementId.ironwill, m).tier,
          AchievementTier.silver);
      expect(progressFor(AchievementId.vitality, m).tier, isNull);
    });
  });

  group('newly earned', () {
    test('reports a tier the moment it is crossed', () {
      final awards = newlyEarned(
        before: metrics(streak: 9),
        after: metrics(streak: 10),
      );
      expect(awards, hasLength(1));
      expect(awards.single.id, AchievementId.resolve);
      expect(awards.single.tier, AchievementTier.silver);
    });

    test('reports every tier when several are crossed at once', () {
      // A big backfill can jump two tiers; both should be announced, or the
      // player silently never hears about one they earned.
      final awards = newlyEarned(
        before: metrics(streak: 0),
        after: metrics(streak: 25),
      );
      expect(
        awards.map((a) => a.tier),
        containsAllInOrder([
          AchievementTier.bronze,
          AchievementTier.silver,
          AchievementTier.gold,
        ]),
      );
    });

    test('reports nothing when the totals have not moved', () {
      // recomputeAll() re-derives everything from scratch; it must not spam
      // the activity feed with medals that were already earned.
      final same = metrics(streak: 30, xp: 5000, cleared: 400);
      expect(newlyEarned(before: same, after: same), isEmpty);
    });

    test('reports nothing when a total goes backwards', () {
      // Un-completing a quest can lower a total. That is not a new medal, and
      // it must not re-announce the one still held.
      expect(
        newlyEarned(before: metrics(streak: 20), after: metrics(streak: 12)),
        isEmpty,
      );
    });
  });
}
