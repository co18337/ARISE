import '../../game/game.dart';
import '../../models/models.dart';
import '../training_plan.dart';
import 'memory_repository.dart';

/// A trainer that reads its own history before prescribing.
///
/// It does not change the SETS — the phase plan and double progression still
/// decide those, and they must, because they are what keeps working with the
/// network off. What it adds is the thing a real trainer brings and a lookup
/// table cannot: "last time you did this, here is what happened".
///
/// This is the retrieval-augmented step with the generation left out. When the
/// Gemini key arrives, the same recalled passages become the context for a
/// model that writes the note instead of the template below — the retrieval,
/// which is the hard half, is already here and already tested.
class MemoryTrainerAdvisor implements TrainerAdvisor {
  final MemoryRepository memory;
  final TrainerAdvisor base;

  /// How many recalled passages to turn into notes.
  final int noteCount;

  const MemoryTrainerAdvisor({
    required this.memory,
    this.base = const RuleBasedTrainer(),
    this.noteCount = 2,
  });

  @override
  Future<SessionPlan> planSession({
    required int weekday,
    required int week,
    required Map<String, int> clearedByExercise,
  }) async {
    final plan = await base.planSession(
      weekday: weekday,
      week: week,
      clearedByExercise: clearedByExercise,
    );

    if (plan.isRestDay) return plan;

    // Query built from what today actually asks for, so the recall is about
    // this session rather than about training in general.
    final query = [
      plan.focus,
      for (final item in plan.items) item.exercise.name,
    ].join(' ');

    List<MemoryHit> hits;
    try {
      hits = await memory.recall(
        query,
        limit: noteCount,
        kinds: {MemoryKind.workoutSession, MemoryKind.bodyScan},
      );
    } catch (_) {
      // Memory is an enhancement. A failure here must never stop a session
      // being issued.
      return plan;
    }

    if (hits.isEmpty) return plan;

    return SessionPlan(
      phase: plan.phase,
      week: plan.week,
      focus: plan.focus,
      items: plan.items,
      notes: [for (final hit in hits) _noteFrom(hit)],
    );
  }

  /// One recalled passage, trimmed to something readable on a card.
  String _noteFrom(MemoryHit hit) {
    final passage = hit.passage.replaceAll('\n', ' ').trim();
    final trimmed =
        passage.length <= 150 ? passage : '${passage.substring(0, 147)}…';
    return '${hit.kind.label}: $trimmed';
  }
}
