import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/game/game.dart';

void main() {
  group('LevelCurve', () {
    const curve = LevelCurve(base: 100, increment: 50);

    test('starts at level 1 with no XP', () {
      expect(curve.levelForXp(0), 1);
      expect(curve.levelForXp(99), 1);
    });

    test('each level costs `increment` more than the last', () {
      expect(curve.xpForLevel(1), 100);
      expect(curve.xpForLevel(2), 150);
      expect(curve.xpForLevel(3), 200);
    });

    test('levels up exactly at the threshold, not one XP early', () {
      expect(curve.levelForXp(99), 1);
      expect(curve.levelForXp(100), 2);
      expect(curve.levelForXp(249), 2); // 100 + 150 = 250
      expect(curve.levelForXp(250), 3);
    });

    test('totalXpToReach agrees with levelForXp at every boundary', () {
      // The cumulative and incremental views of the curve must not drift
      // apart — the progress bar reads one and the level reads the other.
      for (var level = 1; level <= 60; level++) {
        final atThreshold = curve.totalXpToReach(level);
        expect(curve.levelForXp(atThreshold), level, reason: 'level $level');
        if (level > 1) {
          expect(curve.levelForXp(atThreshold - 1), level - 1);
        }
      }
    });

    test('progress reports position within the current level', () {
      // 100 XP reaches level 2; 60 more is 60/150 of the way to level 3.
      final progress = curve.progressFor(160);
      expect(progress.level, 2);
      expect(progress.xpIntoLevel, 60);
      expect(progress.xpForLevel, 150);
      expect(progress.xpRemaining, 90);
      expect(progress.fraction, closeTo(0.4, 1e-9));
    });

    test('negative XP is treated as zero rather than throwing', () {
      expect(curve.levelForXp(-50), 1);
      expect(curve.progressFor(-50).xpIntoLevel, 0);
    });
  });

  group('Rank', () {
    test('maps levels to the expected tiers', () {
      expect(Rank.forLevel(1), Rank.e);
      expect(Rank.forLevel(4), Rank.e);
      expect(Rank.forLevel(5), Rank.d);
      expect(Rank.forLevel(10), Rank.c);
      expect(Rank.forLevel(20), Rank.b);
      expect(Rank.forLevel(35), Rank.a);
      expect(Rank.forLevel(50), Rank.s);
      expect(Rank.forLevel(999), Rank.s);
    });

    test('every rank boundary is exact', () {
      for (final rank in Rank.values) {
        expect(Rank.forLevel(rank.minLevel), rank);
        if (rank != Rank.e) {
          expect(Rank.forLevel(rank.minLevel - 1), isNot(rank));
        }
      }
    });

    test('S rank has no next rank', () {
      expect(Rank.s.next, isNull);
      expect(Rank.e.next, Rank.d);
    });
  });

  group('streak qualification', () {
    test('needs 60% of the day available XP', () {
      expect(
        GameRules.dayQualifiesForStreak(xpEarned: 60, xpAvailable: 100),
        isTrue,
      );
      expect(
        GameRules.dayQualifiesForStreak(xpEarned: 59, xpAvailable: 100),
        isFalse,
      );
    });

    test('a day with nothing scheduled cannot break a streak', () {
      // That's the plan's doing, not the player's.
      expect(
        GameRules.dayQualifiesForStreak(xpEarned: 0, xpAvailable: 0),
        isTrue,
      );
    });
  });

  group('computeStreaks', () {
    test('no data means no streak', () {
      expect(computeStreaks(qualifyingDays: {}, today: 100).current, 0);
      expect(computeStreaks(qualifyingDays: {}, today: 100).longest, 0);
    });

    test('counts consecutive days ending today', () {
      final result = computeStreaks(
        qualifyingDays: {98, 99, 100},
        today: 100,
      );
      expect(result.current, 3);
    });

    test('today not yet qualifying does NOT break the streak', () {
      // Opening the app in the morning, before doing anything, must not show
      // the streak as already broken.
      final result = computeStreaks(
        qualifyingDays: {97, 98, 99},
        today: 100,
      );
      expect(result.current, 3);
    });

    test('a missed yesterday does break the streak', () {
      final result = computeStreaks(
        qualifyingDays: {96, 97, 98},
        today: 100, // 99 missing
      );
      expect(result.current, 0);
    });

    test('a gap resets the current streak but not the longest', () {
      final result = computeStreaks(
        qualifyingDays: {90, 91, 92, 93, 94, 99, 100},
        today: 100,
      );
      expect(result.current, 2);
      expect(result.longest, 5);
    });

    test('longest counts each run exactly once', () {
      final result = computeStreaks(
        qualifyingDays: {1, 2, 3, 10, 11, 20},
        today: 20,
      );
      expect(result.longest, 3);
      expect(result.current, 1);
    });
  });
}
