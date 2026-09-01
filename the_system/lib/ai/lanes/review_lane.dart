import '../ai_result.dart';
import '../llm_router.dart';

/// The week, read back to you.
class WeeklyReview {
  /// What actually happened, in plain terms. Three sentences at most.
  final String summary;

  /// The single thing that went best. Named, not praised in general.
  final String kept;

  /// The single thing to fix next week. One, not a list.
  final String change;

  const WeeklyReview({
    required this.summary,
    required this.kept,
    required this.change,
  });
}

/// Writes the Sunday review.
///
/// The one call a week that looks BACKWARDS. Everything else in the app is
/// about the day in front of you; this is the only moment it takes stock, and
/// it is the reason the memory corpus exists at all — a week of sessions,
/// meals and answered steps is exactly the material retrieval was built for.
///
/// Narrow, like every other lane. It is handed the week's figures and passages
/// from the record, and asked to describe them. It does not set targets, it
/// does not change the programme, and it names ONE thing to change rather than
/// producing a list nobody acts on.
class ReviewLane {
  final LlmRouter client;

  const ReviewLane(this.client);

  static const String name = 'review';

  static const String _system = '''
You are writing a short weekly review for someone following a fixed
transformation programme. You are given the week's own figures and passages
from their record.

Rules:
- summary: at most three sentences, speaking to them as "you". Describe what
  ACTUALLY happened using the figures you were given. No pep talk.
- kept: the single thing that went best this week, named specifically.
- change: ONE thing to change next week. Exactly one. A list of five is a list
  nobody acts on.
- Use only what you were given. If a figure is missing, do not guess at it and
  do not imply a trend you cannot see.
- Do NOT change the programme — not the exercises, the sets, the phase or the
  meal plan. Those are fixed and are not yours to edit.
- Do NOT give medical advice, diagnose anything, or interpret a body
  measurement, a heart rate or a blood result. If the record mentions pain,
  the only acceptable comment is to train within what feels safe.
- If the week is mostly empty, say that plainly. A quiet week honestly
  described is worth more than an invented one.
''';

  static const Map<String, Object?> _schema = {
    'type': 'OBJECT',
    'properties': {
      'summary': {'type': 'STRING'},
      'kept': {'type': 'STRING'},
      'change': {'type': 'STRING'},
    },
    'required': ['summary', 'kept', 'change'],
  };

  /// [figures] are the week's own numbers, already computed — never left to
  /// the model to work out. [recalled] are passages from the corpus.
  Future<AiResult<WeeklyReview>> review({
    required List<String> figures,
    required List<String> recalled,
  }) async {
    final result = await client.completeJson(
      lane: name,
      systemPrompt: _system,
      userPrompt: [
        'The week in figures:',
        if (figures.isEmpty) '(nothing recorded)' else
          for (final figure in figures) '- $figure',
        '',
        'From their record:',
        if (recalled.isEmpty)
          '(nothing recorded yet)'
        else
          for (final passage in recalled) '- $passage',
      ].join('\n'),
      schema: _schema,
      temperature: 0.5,
      maxOutputTokens: 2048,
    );

    return switch (result) {
      AiOk(:final value) => _parse(value),
      AiNoKey() => const AiNoKey(),
      AiOffline(:final detail) => AiOffline(detail),
      AiOverBudget(:final used, :final limit) =>
        AiOverBudget(used: used, limit: limit),
      AiBadResponse(:final detail) => AiBadResponse(detail),
    };
  }

  AiResult<WeeklyReview> _parse(Map<String, Object?> value) {
    final summary = value['summary'];
    final kept = value['kept'];
    final change = value['change'];
    // Checked explicitly rather than cast: a missing field should read as a
    // bad shape, not throw somewhere further up.
    if (summary is! String || kept is! String || change is! String) {
      return const AiBadResponse('the review was missing a field');
    }
    return AiOk(
      WeeklyReview(summary: summary, kept: kept, change: change),
    );
  }
}
