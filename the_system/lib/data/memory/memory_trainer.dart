import '../../ai/ai_result.dart';
import '../../ai/lanes/trainer_lane.dart';
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
/// Two ways of saying it, in order of preference:
///   1. the model WRITES a note from the recalled passages;
///   2. failing that, the passages are shown as they are.
/// The second is the floor and always available. Which one you are reading is
/// recorded and shown, because a written sentence and a quoted record deserve
/// different trust.
class MemoryTrainerAdvisor implements TrainerAdvisor {
  final MemoryRepository memory;
  final TrainerAdvisor base;

  /// Null until a Gemini key exists. Without it the passages speak for
  /// themselves, which is worse writing and exactly as true.
  final TrainerLane? lane;

  /// How many recalled passages to use.
  final int noteCount;

  const MemoryTrainerAdvisor({
    required this.memory,
    this.base = const RuleBasedTrainer(),
    this.lane,
    this.noteCount = 3,
  });

  @override
  Future<SessionPlan> planSession({
    required int weekday,
    required int week,
    required Map<String, int> clearedByExercise,
    int sessionsCompleted = 0,
    BodyEmphasis emphasis = BodyEmphasis.none,
    Map<String, ExerciseRecord> records = const {},
    Deload? deload,
  }) async {
    // Passed straight through. This advisor adds a NOTE; the phase gate and
    // the scan emphasis decide the numbers, and those belong to the rule
    // engine so they keep working with the network off.
    final plan = await base.planSession(
      weekday: weekday,
      week: week,
      clearedByExercise: clearedByExercise,
      sessionsCompleted: sessionsCompleted,
      emphasis: emphasis,
      records: records,
      deload: deload,
    );

    if (plan.isRestDay) return plan;

    // Built from what today actually asks for, so the recall is about THIS
    // session rather than about training in general.
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

    final passages = [for (final hit in hits) _passage(hit)];

    // The written note, if there is a key and it answers.
    final advisor = lane;
    if (advisor != null) {
      final result = await advisor.coach(
        sessionSummary: plan.summary,
        recalled: passages,
      );
      if (result case AiOk(:final value)) {
        return _withNotes(
          plan,
          [
            value.note,
            if (value.basedOn.isNotEmpty) 'Based on: ${value.basedOn}',
          ],
          TrainerNoteSource.model,
        );
      }
      // Anything else — no key, offline, over budget, bad shape — falls
      // through to the passages below rather than showing nothing.
    }

    if (hits.isEmpty) return plan;
    return _withNotes(
      plan,
      [for (final hit in hits) '${hit.kind.label}: ${_trim(hit.passage)}'],
      TrainerNoteSource.history,
    );
  }

  SessionPlan _withNotes(
    SessionPlan plan,
    List<String> notes,
    TrainerNoteSource source,
  ) => SessionPlan(
    phase: plan.phase,
    week: plan.week,
    focus: plan.focus,
    items: plan.items,
    notes: notes,
    noteSource: source,
    // Carried across. Dropping these here is how the gate and the emphasis
    // would silently vanish the moment a key was added.
    gate: plan.gate,
    emphasisReason: plan.emphasisReason,
    deload: plan.deload,
  );

  /// A recalled passage, flattened for a prompt.
  String _passage(MemoryHit hit) =>
      '${hit.kind.label}: ${hit.passage.replaceAll('\n', ' ').trim()}';

  /// Trimmed to something readable on a card.
  String _trim(String passage) {
    final flat = passage.replaceAll('\n', ' ').trim();
    return flat.length <= 150 ? flat : '${flat.substring(0, 147)}…';
  }
}
