/// What sort of event an activity-log entry records. Feeds the LOG screen
/// (Phase 9) — written from Phase 3 onward so there's real history to show by
/// the time that screen exists.
enum ActivityKind {
  questCleared,
  questUncleared,

  /// A step that ended the day unanswered, or was answered as missed.
  questMissed,
  levelUp,
  rankUp,
  streakBroken,
  achievementUnlocked,
  dailyBriefing,
}
