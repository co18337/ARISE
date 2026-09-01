import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:the_system/ai/ai_result.dart';
import 'package:the_system/ai/gemini_client.dart';
import 'package:the_system/config/app_config.dart';
import 'package:the_system/data/db/database.dart';

void main() {
  group('choosing a model', () {
    // The real list this key returns, captured 2026-08-31. The app shipped
    // pinned to gemini-2.0-flash and broke the day it was retired, so the name
    // is now chosen from whatever the API actually offers.
    const available = [
      'gemini-2.5-flash',
      'gemini-2.5-flash-image',
      'gemini-2.5-flash-lite',
      'gemini-2.5-flash-preview-tts',
      'gemini-3-flash-preview',
      'gemini-3.1-flash-image',
      'gemini-3.1-flash-lite',
      'gemini-3.1-flash-tts-preview',
      'gemini-3.5-flash',
      'gemini-3.6-flash',
      'gemini-3.7-flash',
      'gemini-flash-latest',
      'gemini-flash-lite-latest',
      'gemini-omni-flash-preview',
      'gemini-2.5-pro',
    ];

    test('picks the newest plain flash model', () {
      expect(GeminiClient.bestOf(available), 'gemini-3.7-flash');
    });

    test('never picks an image, speech or omni variant', () {
      // These answer a completely different question and would fail the
      // schema in a way that looks like a bad prompt.
      for (final bad in ['image', 'tts', 'omni', 'audio']) {
        expect(GeminiClient.bestOf(available)!.contains(bad), isFalse);
      }
    });

    test('avoids preview and -latest when a stable model exists', () {
      // A preview can be withdrawn without notice, and -latest moves
      // underneath us — both are the failure we just had, in slow motion.
      final chosen = GeminiClient.bestOf(available)!;
      expect(chosen.contains('preview'), isFalse);
      expect(chosen.contains('latest'), isFalse);
    });

    test('prefers flash over pro, and full over lite', () {
      expect(GeminiClient.bestOf(['gemini-2.5-pro', 'gemini-2.5-flash']),
          'gemini-2.5-flash');
      expect(GeminiClient.bestOf(['gemini-3.1-flash-lite', 'gemini-3.1-flash']),
          'gemini-3.1-flash');
    });

    test('falls back to whatever is left rather than nothing', () {
      expect(GeminiClient.bestOf(['gemini-flash-latest']), 'gemini-flash-latest');
      expect(GeminiClient.bestOf(const []), isNull);
      expect(GeminiClient.bestOf(['some-other-vendor-model']), isNull);
    });

    test('the fallback chain spans capacity tiers, not siblings', () {
      // Measured on 2026-08-31: gemini-3.7-flash and gemini-flash-latest both
      // answered 503 "high demand" while 3.6, 3.5 and every lite variant
      // answered normally. Trying five models of the same generation would
      // have hit the same saturated capacity five times.
      final chain = GeminiClient.fallbackChain(available);

      expect(chain.first, 'gemini-3.7-flash', reason: 'best first');
      expect(chain.length, lessThanOrEqualTo(4), reason: 'not the whole list');
      expect(chain, contains('gemini-3.6-flash'));
      // The last resort is a LITE model — different, far less contended
      // capacity, and ample for costing a plate of food.
      expect(chain.last.contains('lite'), isTrue);
      // Each step is a genuinely different model.
      expect(chain.toSet().length, chain.length);
    });

    test('the chain still works when only lite models exist', () {
      final chain = GeminiClient.fallbackChain([
        'gemini-3.1-flash-lite',
        'gemini-3.5-flash-lite',
      ]);
      expect(chain, isNotEmpty);
      expect(chain.first, 'gemini-3.5-flash-lite');
    });

    test('ranks every usable model, so a busy one can be skipped', () {
      // Capacity is per-model: 3.7-flash and flash-latest both answered 503
      // while 3.6-flash worked. The client needs somewhere to go next.
      final ranked = GeminiClient.rank(available);
      expect(ranked.first, 'gemini-3.7-flash');
      expect(ranked, contains('gemini-3.6-flash'));
      expect(ranked.indexOf('gemini-3.6-flash'),
          lessThan(ranked.indexOf('gemini-2.5-flash')));
      expect(ranked.any((m) => m.contains('image')), isFalse);
    });

    test('reads two-part version numbers correctly', () {
      // 3.10 must beat 3.9, which a string sort would get wrong.
      expect(
        GeminiClient.bestOf(['gemini-3.9-flash', 'gemini-3.10-flash']),
        'gemini-3.10-flash',
      );
    });
  });

  group('paying for an answer once', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      AppConfig.overrideForTest(apiKey: 'test-key');
    });

    tearDown(() async {
      await db.close();
      AppConfig.overrideForTest();
    });

    /// A stand-in Gemini that counts what it is asked, and can be told to fail
    /// the first model the way a saturated one does.
    ({http.Client client, List<String> calls}) fakeGemini({
      Set<String> saturated = const {},
      Set<String> outOfQuota = const {},
    }) {
      final calls = <String>[];
      final client = MockClient((request) async {
        final path = request.url.path;
        if (path.endsWith('/models')) {
          calls.add('list');
          return http.Response(
            jsonEncode({
              'models': [
                for (final name in ['gemini-3.7-flash', 'gemini-3.6-flash'])
                  {
                    'name': 'models/$name',
                    'supportedGenerationMethods': ['generateContent'],
                  },
              ],
            }),
            200,
          );
        }
        final model = path.split('/').last.split(':').first;
        calls.add(model);
        if (saturated.contains(model)) {
          return http.Response('{"error":"high demand"}', 503);
        }
        if (outOfQuota.contains(model)) {
          return http.Response(
            '{"error":{"code":429,"message":"You exceeded your current '
            'quota"}}',
            429,
          );
        }
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {'text': '{"note":"hello"}'},
                  ],
                },
              },
            ],
          }),
          200,
        );
      });
      return (client: client, calls: calls);
    }

    Future<AiResult<Map<String, Object?>>> ask(GeminiClient gemini) =>
        gemini.completeJson(
          lane: 'trainer',
          systemPrompt: 'system',
          userPrompt: 'the same question',
          schema: const {'type': 'object'},
        );

    test('the same question is not paid for twice', () async {
      final fake = fakeGemini();
      final gemini = GeminiClient(db, client: fake.client);

      expect(await ask(gemini), isA<AiOk<Map<String, Object?>>>());
      final afterFirst = fake.calls.length;

      final second = await ask(gemini);
      expect(second, isA<AiOk<Map<String, Object?>>>());
      expect((second as AiOk).cached, isTrue);
      expect(fake.calls.length, afterFirst, reason: 'no second network call');
    });

    test('a demoted model still answers from the cache', () async {
      // The defect this exists for: the cache key used to include the model
      // name, and _modelIndex advances on every 503 and never resets. So the
      // second ask hashed differently from the first and went back out to the
      // network — during US business hours, which is when 503s happen, the
      // cache effectively did not exist.
      final fake = fakeGemini(saturated: {'gemini-3.7-flash'});
      final gemini = GeminiClient(db, client: fake.client);

      final first = await ask(gemini);
      expect(first, isA<AiOk<Map<String, Object?>>>());
      expect(fake.calls, contains('gemini-3.6-flash'), reason: 'it demoted');
      final afterFirst = fake.calls.length;

      final second = await ask(gemini);
      expect((second as AiOk).cached, isTrue);
      expect(fake.calls.length, afterFirst);
    });

    test('an exhausted quota is not retried, it is stepped over', () async {
      // The 429 seen on 2026-09-01. Two things were wrong at once: 429 was
      // retried like a 503, so each attempt spent two MORE requests against
      // the allowance that had just run out; and it was then treated as "our
      // fault, do not shop around", so the next model — which has a quota of
      // its own, because the free tier counts per model — was never asked.
      final fake = fakeGemini(outOfQuota: {'gemini-3.7-flash'});
      final gemini = GeminiClient(db, client: fake.client);

      final result = await ask(gemini);

      // It got an answer, from the model that still had allowance.
      expect(result, isA<AiOk<Map<String, Object?>>>());
      // And it spent exactly ONE request finding out the first was spent.
      expect(
        fake.calls.where((c) => c == 'gemini-3.7-flash').length,
        1,
        reason: 'a quota does not refill in one second',
      );
      expect(fake.calls, contains('gemini-3.6-flash'));
    });

    test('a 503 is still retried on the same model, because it does clear',
        () async {
      // The distinction that makes the fix above safe: overload is temporary
      // and worth waiting a second for, quota is not.
      final fake = fakeGemini(saturated: {'gemini-3.7-flash'});
      await ask(GeminiClient(db, client: fake.client));
      expect(
        fake.calls.where((c) => c == 'gemini-3.7-flash').length,
        greaterThan(1),
      );
    });

    test('a cached answer costs no network at all, not even a model list',
        () async {
      // resolveModel() memoises for the life of the PROCESS, so the first call
      // after every launch listed models before it looked in the cache — a
      // real round trip, against the key, to choose a model whose answer was
      // already on disk.
      final warm = fakeGemini();
      await ask(GeminiClient(db, client: warm.client));
      expect(warm.calls, contains('list'));

      // A second client on the same database is a second launch.
      final cold = fakeGemini();
      final second = await ask(GeminiClient(db, client: cold.client));

      expect((second as AiOk).cached, isTrue);
      expect(cold.calls, isEmpty, reason: 'not even GET /models');
    });
  });
}
