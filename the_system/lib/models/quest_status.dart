/// How a quest ended up.
///
/// Deliberately three values and no more. A step is either still open, done,
/// or missed — there is no "skipped", "partial" or "postponed". Marking a step
/// missed yourself and letting its window lapse are the same outcome, because
/// the honest answer to "did you do it?" only has two endings, and every extra
/// state is a place to hide from that.
enum QuestStatus {
  /// Not answered yet. The only state that can still change on its own.
  pending,

  /// Completed — awards its XP.
  done,

  /// Not completed. Costs no XP (see [QuestStatus] note below) but fails the
  /// day's bar and breaks the streak.
  missed;

  /// True once the quest has an answer and can no longer lapse.
  bool get isResolved => this != QuestStatus.pending;
}

// Why a miss does not SUBTRACT XP:
//
// XP is the record of what actually happened. Deducting it would rewrite
// history and break the invariant the whole schema rests on — that every
// total is derivable from `daily_quests` alone. The penalty for a miss is
// real without touching XP: the day fails its 60% bar, the streak breaks, and
// an alert lands in the activity log. See ARCHITECTURE.md §6.
