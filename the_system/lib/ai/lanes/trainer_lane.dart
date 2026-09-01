import '../ai_result.dart';
import '../llm_router.dart';

/// One short note from the trainer, and what it was based on.
class CoachNote {
  /// Two sentences at most, in the second person.
  final String note;

  /// What in the history it keyed off, in a few words. Shown so a note that
  /// sounds confident can be checked against the thing it came from.
  final String basedOn;

  const CoachNote({required this.note, required this.basedOn});
}

/// Writes the note that sits above today's session.
///
/// Deliberately the NARROWEST possible job. It is handed a prescription that
/// has already been decided and some passages from your own history, and asked
/// to comment. It does not choose the exercises, the sets or the reps — the
/// phase plan and double progression do that, and they must, because they are
/// what keeps working when the network is gone.
///
/// This is the generation half of RAG. The retrieval half already ran; these
/// passages came out of the corpus, not out of the model's imagination.
class TrainerLane {
  /// The router, not a provider. The lane never learns which model answered —
  /// that is the router's business and the AI log's.
  final LlmRouter client;

  const TrainerLane(this.client);

  static const String name = 'trainer';

  static const String _system = '''
You are a strength and conditioning coach writing ONE short note to a trainee
just before their session. You are given the session they are about to do,
which has already been decided, and passages from their own training history.

Rules:
- Two sentences at most. Speak to them directly, as "you".
- Say something SPECIFIC that comes from the history you were given. If the
  history shows a session was cut short, or a movement was completed in full
  three times running, that is worth mentioning. Vague encouragement is not.
- Do NOT change the session. Do not suggest different exercises, more sets,
  fewer sets, different weights or a different order. The programme is fixed
  and is not yours to edit.
- Do NOT give medical advice, diagnose pain, or interpret any body measurement
  or blood result. If the history mentions pain or injury, the only acceptable
  comment is to train within what feels safe today.
- If the history says nothing useful about this session, say so plainly in one
  sentence rather than inventing a pattern.
- basedOn: name the thing in the history you used, in a few words.
''';

  static const Map<String, Object?> _schema = {
    'type': 'OBJECT',
    'properties': {
      'note': {'type': 'STRING'},
      'basedOn': {'type': 'STRING'},
    },
    'required': ['note', 'basedOn'],
  };

  /// [recalled] are passages the memory store retrieved for today's session.
  Future<AiResult<CoachNote>> coach({
    required String sessionSummary,
    required List<String> recalled,
  }) async {
    final result = await client.completeJson(
      lane: name,
      systemPrompt: _system,
      userPrompt: [
        "Today's session, already decided:",
        sessionSummary,
        '',
        'From their own history:',
        if (recalled.isEmpty)
          '(nothing recorded yet)'
        else
          for (final passage in recalled) '- $passage',
      ].join('\n'),
      schema: _schema,
      // A little warmth: a coaching note at temperature 0.1 reads like a
      // receipt. Still low enough that it stays anchored to the history.
      temperature: 0.5,
      maxOutputTokens: 2048,
    );

    return switch (result) {
      AiOk(:final value, :final cached) => _parse(value, cached),
      AiNoKey<Map<String, Object?>>() => const AiNoKey(),
      AiOffline(:final detail) => AiOffline(detail),
      AiOverBudget(:final used, :final limit) =>
        AiOverBudget(used: used, limit: limit),
      AiBadResponse(:final detail) => AiBadResponse(detail),
    };
  }

  AiResult<CoachNote> _parse(Map<String, Object?> json, bool cached) {
    final note = (json['note'] as String? ?? '').trim();
    if (note.isEmpty) return const AiBadResponse('the note came back empty');

    return AiOk(
      CoachNote(
        note: note,
        basedOn: (json['basedOn'] as String? ?? '').trim(),
      ),
      cached: cached,
    );
  }
}
