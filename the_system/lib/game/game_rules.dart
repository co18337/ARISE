import 'level_curve.dart';

/// Every tunable number in the game, in one place.
///
/// Balancing the game should mean editing this file and nothing else. If a
/// magic number about progression appears anywhere outside here, it's a bug.
class GameRules {
  GameRules._();

  /// The hunter level curve. Level 1->2 costs 100 XP, each level 50 more than
  /// the last. With the current catalog a perfect day is 88 XP, so the first
  /// couple of levels land in the first few days and then it settles down.
  static const LevelCurve hunter = LevelCurve(base: 100, increment: 50);

  /// Individual stats advance on a cheaper curve, because each stat only
  /// receives a fraction of the day's XP — on the same curve as the hunter
  /// level they'd feel permanently stuck.
  static const LevelCurve stat = LevelCurve(base: 60, increment: 30);

  /// Share of a day's available XP needed for that day to count toward the
  /// streak. Deliberately below 1.0: demanding a perfect day every day makes
  /// streaks brittle and punishing, and a brittle streak stops motivating.
  static const double streakQualifyingFraction = 0.6;

  /// Whether a day counts toward the streak.
  ///
  /// A day with nothing scheduled cannot break a streak — that's the plan's
  /// doing, not the player's.
  static bool dayQualifiesForStreak({
    required int xpEarned,
    required int xpAvailable,
  }) {
    if (xpAvailable <= 0) return true;
    return xpEarned >= xpAvailable * streakQualifyingFraction;
  }

  /// XP for one set done BEYOND the prescription.
  ///
  /// Roughly half what a prescribed set is worth: a session is 20 XP through
  /// its quest and typically four to six sets, so a prescribed set is worth
  /// about four. Extra work is real work and the app should honour it — at a
  /// lower rate, so the incentive still points at doing the plan rather than
  /// at padding the numbers.
  static const int xpPerExtraSet = 2;

  /// How far back to reconstruct missed days when the app hasn't been opened
  /// for a while. Bounded so a wrong device clock can't trigger a
  /// years-long backfill.
  static const int maxBackfillDays = 30;
}
