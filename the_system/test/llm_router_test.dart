import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/ai/ai_result.dart';
import 'package:the_system/ai/groq_client.dart';
import 'package:the_system/ai/llm_client.dart';
import 'package:the_system/ai/llm_router.dart';
import 'package:the_system/data/db/database.dart';

/// The switching between providers, with both stood in for.
///
/// Groq leads because it is faster; Gemini takes over when Groq is busy, spent
/// or absent. What matters is that falling through costs one request, never
/// re-asks a question already answered, and cannot be triggered by our own bad
/// prompt.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  Future<AiResult<Map<String, Object?>>> ask(LlmRouter router) =>
      router.completeJson(
        lane: 'trainer',
        systemPrompt: 'system',
        userPrompt: 'the same question',
        schema: const {'type': 'object'},
      );

  test('the first configured provider answers and the second is untouched',
      () async {
    final groq = _Fake('groq', answer: {'note': 'from groq'});
    final gemini = _Fake('gemini', answer: {'note': 'from gemini'});
    final router = LlmRouter(db: db, providers: [groq, gemini]);

    final result = await ask(router);

    expect((result as AiOk).value['note'], 'from groq');
    expect(groq.calls, 1);
    expect(gemini.calls, 0, reason: 'the fallback is not a second opinion');
  });

  test('a busy provider hands over after exactly one attempt', () async {
    final groq = _Fake('groq', fail: const AiOffline('503'));
    final gemini = _Fake('gemini', answer: {'note': 'from gemini'});
    final router = LlmRouter(db: db, providers: [groq, gemini]);

    expect((await ask(router) as AiOk).value['note'], 'from gemini');
    expect(groq.calls, 1, reason: 'a busy provider is not retried in place');
    expect(gemini.calls, 1);
  });

  test('a provider that reports itself spent is not called at all', () async {
    // The point of reading the quota rather than discovering it: a request
    // spent learning the allowance is gone is a request wasted.
    final groq = _Fake('groq', exhausted: true);
    final gemini = _Fake('gemini', answer: {'note': 'from gemini'});
    final router = LlmRouter(db: db, providers: [groq, gemini]);

    await ask(router);

    expect(groq.calls, 0);
    expect(gemini.calls, 1);
  });

  test('a provider with no key is skipped silently', () async {
    final groq = _Fake('groq', configured: false);
    final gemini = _Fake('gemini', answer: {'note': 'from gemini'});
    final router = LlmRouter(db: db, providers: [groq, gemini]);

    expect(await ask(router), isA<AiOk<Map<String, Object?>>>());
    expect(groq.calls, 0);
  });

  test('no keys at all is AiNoKey, not a failed call', () async {
    final router = LlmRouter(
      db: db,
      providers: [
        _Fake('groq', configured: false),
        _Fake('gemini', configured: false),
      ],
    );
    expect(await ask(router), isA<AiNoKey<Map<String, Object?>>>());
    expect(router.hasAnyProvider, isFalse);
  });

  test('an answer bought from one provider is never bought from the other',
      () async {
    // The reason the cache sits above the router rather than inside a client.
    final groq = _Fake('groq', answer: {'note': 'from groq'});
    final gemini = _Fake('gemini', answer: {'note': 'from gemini'});
    final router = LlmRouter(db: db, providers: [groq, gemini]);

    await ask(router);
    // Groq is now spent, so the same question would fall to Gemini — except
    // it never reaches a provider at all.
    groq.exhausted = true;
    final second = await ask(router) as AiOk<Map<String, Object?>>;

    expect(second.cached, isTrue);
    expect(second.value['note'], 'from groq');
    expect(gemini.calls, 0, reason: 'the answer was already paid for');
  });

  test('every provider failing returns the last failure, not silence',
      () async {
    final router = LlmRouter(
      db: db,
      providers: [
        _Fake('groq', fail: const AiOffline('503')),
        _Fake('gemini', fail: const AiOffline('429: quota')),
      ],
    );

    final result = await ask(router);
    expect(result, isA<AiOffline<Map<String, Object?>>>());
    expect((result as AiOffline).detail, contains('quota'));
  });

  test('the daily budget stops a runaway loop across all providers', () async {
    final groq = _Fake('groq', answer: {'note': 'ok'});
    final router = LlmRouter(db: db, providers: [groq], dailyBudget: 2);

    // Distinct prompts, or the cache would answer them.
    for (var i = 0; i < 4; i++) {
      await router.completeJson(
        lane: 'trainer',
        systemPrompt: 'system',
        userPrompt: 'question $i',
        schema: const {'type': 'object'},
      );
    }

    expect(groq.calls, 2, reason: 'the budget is across providers, not per one');
  });

  test('the log names the provider that answered', () async {
    final router = LlmRouter(
      db: db,
      providers: [
        _Fake('groq', fail: const AiOffline('503')),
        _Fake('gemini', answer: {'note': 'ok'}),
      ],
    );
    await ask(router);

    final calls = await db.select(db.aiCalls).get();
    final ok = calls.firstWhere((c) => c.ok);
    expect(ok.model, 'gemini', reason: 'not the one it started with');
    expect(calls.any((c) => c.model == 'groq' && !c.ok), isTrue);
  });

  group('groq model choice', () {
    test('it ranks usable text models and drops the rest', () {
      // The real list this key returns, captured 2026-09-02. The name this
      // client shipped pinned to — llama-3.3-70b-versatile — is NOT in it,
      // which is exactly why pinning was the wrong call.
      const available = [
        'allam-2-7b',
        'canopylabs/orpheus-arabic-saudi',
        'canopylabs/orpheus-v1-english',
        'groq/compound',
        'groq/compound-mini',
        'openai/gpt-oss-120b',
        'openai/gpt-oss-20b',
        'qwen/qwen3.6-27b',
        'qwen/qwen3.8-27b',
        'whisper-large-v3',
      ];

      final ranked = GroqClient.rank(available);

      expect(ranked.first, 'openai/gpt-oss-120b', reason: 'most capable first');
      expect(ranked.length, lessThanOrEqualTo(3), reason: 'not the whole list');
      // Speech, Arabic-only and safety models cannot answer a JSON prompt.
      for (final bad in ['whisper', 'orpheus', 'allam']) {
        expect(ranked.any((m) => m.contains(bad)), isFalse, reason: bad);
      }
      expect(ranked.toSet().length, ranked.length, reason: 'no duplicates');
    });

    test('nothing usable resolves to nothing, rather than to a guess', () {
      expect(GroqClient.rank(const []), isEmpty);
      expect(GroqClient.rank(const ['whisper-large-v3']), isEmpty);
    });
  });
}

/// A provider that answers however the test tells it to.
class _Fake implements LlmClient {
  @override
  final String name;

  final Map<String, Object?>? answer;
  final AiResult<Map<String, Object?>>? fail;
  final bool configured;

  bool exhausted;
  int calls = 0;

  _Fake(
    this.name, {
    this.answer,
    this.fail,
    this.configured = true,
    this.exhausted = false,
  });

  @override
  bool get isConfigured => configured;

  @override
  bool get isExhausted => exhausted;

  @override
  Future<AiResult<Map<String, Object?>>> completeJson({
    required String lane,
    required String systemPrompt,
    required String userPrompt,
    required Map<String, Object?> schema,
    double temperature = 0.2,
    int maxOutputTokens = 4096,
  }) async {
    calls++;
    return fail ?? AiOk(answer ?? const {});
  }
}
