import 'ai_result.dart';

/// One language-model provider.
///
/// Extracted from GeminiClient rather than designed up front — the contract is
/// exactly what the lanes already relied on, so adding a second provider
/// changed no calling code at all. TrainerLane and NutritionLane still call
/// `completeJson` and never learn which provider answered.
///
/// JSON mode rather than prose, on every provider: the caller supplies a
/// schema and anything that comes back in another shape is rejected as
/// [AiBadResponse] rather than half-understood. Fishing numbers out of a
/// paragraph with a regex is how a coaching note becomes a calorie count.
abstract class LlmClient {
  /// Shown on the AI log, so a call can be traced to a provider.
  String get name;

  /// False when no key was supplied. Checked BEFORE any network call, so a
  /// missing key costs nothing and the router simply moves on.
  bool get isConfigured;

  /// True when this provider should be skipped for now — a spent daily quota,
  /// or a refusal recent enough that retrying would just burn another request.
  ///
  /// The router asks before calling rather than discovering it from a 429,
  /// because discovering it from a 429 costs a request to learn something
  /// already known.
  bool get isExhausted;

  /// Asks for JSON matching [schema] and decodes it.
  ///
  /// Implementations must NOT cache: caching sits above the router, keyed by
  /// the prompt alone, so a question already answered by one provider is never
  /// re-asked of another.
  Future<AiResult<Map<String, Object?>>> completeJson({
    required String lane,
    required String systemPrompt,
    required String userPrompt,
    required Map<String, Object?> schema,
    double temperature,
    int maxOutputTokens,
  });
}
