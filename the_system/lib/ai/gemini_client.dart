import 'dart:convert';

import 'package:crypto/crypto.dart' show sha256;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../data/db/database.dart';
import '../game/game.dart';
import 'ai_result.dart';

/// The only thing in the app that talks to Gemini.
///
/// Lanes (nutrition, trainer) describe WHAT they want and hand over a schema;
/// everything else — the key, retries, timeouts, the daily budget, the cache,
/// parsing, and writing down what happened — belongs here. Two lanes that each
/// opened their own connection would each have to get all of that right.
///
/// NOT YET VERIFIED AGAINST THE LIVE SERVICE. Written from the published API
/// with no key to test against. Every field is parsed explicitly, so the first
/// real call fails with a readable message rather than a silent wrong answer.
class GeminiClient {
  final AppDatabase db;
  final http.Client http_;
  final Clock clock;

  /// Calls allowed per day before the client refuses.
  ///
  /// The free tier is generous and this app makes a handful of calls a day, so
  /// the cap is not about cost — it is about a bug in a retry loop not being
  /// able to burn the quota while you are asleep.
  final int dailyBudget;

  GeminiClient(
    this.db, {
    http.Client? client,
    this.clock = const Clock(),
    this.dailyBudget = 200,
  }) : http_ = client ?? http.Client();

  static const String _base =
      'https://generativelanguage.googleapis.com/v1beta';

  /// Every usable model, best first. Resolved once per session.
  List<String> _ranked = const [];

  /// Which of [_ranked] we are currently using.
  int _modelIndex = 0;

  String? get _resolvedModel =>
      _modelIndex < _ranked.length ? _ranked[_modelIndex] : null;

  /// Models we will not pick automatically, whatever the API lists.
  /// How long to wait on ONE attempt before giving up on that model.
  ///
  /// Deliberately short. A saturated model does not always answer 503 — it can
  /// simply crawl: one measured call took 80 SECONDS to come back, while the
  /// next model down answered the same question in 8. Nobody waits 80 seconds
  /// for a plate of food to be costed, and there is a faster model one line
  /// down the chain.
  static const Duration _attemptTimeout = Duration(seconds: 22);

  static const List<String> _excluded = [
    'image', 'tts', 'audio', 'live', 'embedding', 'vision', 'omni', 'thinking',
  ];

  /// The model to use, asked of the API rather than assumed.
  ///
  /// The app shipped pinned to `gemini-2.0-flash` and simply stopped working
  /// the day Google retired it — a 404 saying "no longer available". Hardcoding
  /// a model name is a dated assumption with a fuse on it, so the name is now
  /// resolved from the live list and cached for the session.
  ///
  /// Setting GEMINI_MODEL in .env overrides this entirely, for pinning a
  /// specific model deliberately.
  Future<String?> resolveModel() async {
    final configured = AppConfig.configuredGeminiModel;
    if (configured.isNotEmpty) return configured;
    if (_resolvedModel != null) return _resolvedModel;
    if (_ranked.isNotEmpty) return null; // exhausted every candidate

    final List<String> names;
    try {
      final response = await http_
          .get(Uri.parse('$_base/models?key=${AppConfig.geminiApiKey}&pageSize=200'))
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body) as Map<String, Object?>;
      final models = decoded['models'] as List? ?? const [];
      names = [
        for (final m in models)
          if (m is Map &&
              (m['supportedGenerationMethods'] as List? ?? const [])
                  .contains('generateContent'))
            (m['name'] as String? ?? '').replaceFirst('models/', ''),
      ]..removeWhere((n) => n.isEmpty);
    } catch (_) {
      return null;
    }

    _ranked = fallbackChain(names);
    _modelIndex = 0;
    debugPrint('[ai] using model ${_resolvedModel ?? '(none found)'}');
    return _resolvedModel;
  }

  /// Picks the newest plain text model, preferring the cheap fast family.
  ///
  /// Ranked rather than "first match": the list contains image, speech and
  /// preview variants that answer a completely different question, and a
  /// preview model can be withdrawn without notice.
  /// The best usable model, or null if none of them are.
  @visibleForTesting
  static String? bestOf(List<String> names) => rank(names).firstOrNull;

  /// The models to try, in order, best first.
  ///
  /// NOT simply the ranked list. Walking it top to bottom means trying five
  /// siblings of the same generation, and when a generation is saturated they
  /// are all saturated together — measured: 3.7-flash and flash-latest both
  /// answered 503 while 3.6, 3.5 and every lite variant answered normally.
  ///
  /// So the chain deliberately spans capacity tiers: the newest model, two
  /// older full models, then a LITE model last. Lite runs on different, much
  /// less contended capacity, and costing a plate of food is well within what
  /// it can do — a slightly rougher estimate beats no estimate.
  @visibleForTesting
  static List<String> fallbackChain(List<String> names) {
    final ranked = rank(names);
    if (ranked.isEmpty) return const [];

    final full = ranked.where((n) => !n.contains('lite')).toList();
    final lite = ranked.where((n) => n.contains('lite')).toList();

    final chain = <String>[
      ...full.take(3),
      if (lite.isNotEmpty) lite.first,
    ];

    // If there were no full models at all, fall back to whatever exists.
    return chain.isEmpty ? ranked.take(4).toList() : chain;
  }

  /// Every usable model, best first.
  @visibleForTesting
  static List<String> rank(List<String> names) {
    final candidates = names.where((n) {
      if (!n.startsWith('gemini')) return false;
      return !_excluded.any(n.contains);
    }).toList();
    if (candidates.isEmpty) return const [];

    int score(String name) {
      var points = 0;
      // Flash is the free tier's workhorse and fast enough to sit behind a
      // button someone is waiting on.
      if (name.contains('flash')) points += 1000;
      if (name.contains('lite')) points -= 200;
      if (name.contains('preview')) points -= 500;
      if (name.contains('latest')) points -= 100; // moves under us
      // Newest version wins: "gemini-3.6-flash" beats "gemini-2.5-flash".
      final version = RegExp(r'gemini-(\d+)(?:\.(\d+))?').firstMatch(name);
      if (version != null) {
        points += int.parse(version.group(1)!) * 100;
        points += int.parse(version.group(2) ?? '0') * 10;
      }
      return points;
    }

    candidates.sort((a, b) => score(b).compareTo(score(a)));
    return candidates;
  }

  /// Gives up on the current model for this session and moves to the next.
  ///
  /// Capacity is per-model: gemini-3.7-flash and gemini-flash-latest both
  /// answered 503 "high demand" within seconds of gemini-3.6-flash working
  /// normally. Retrying the same busy model forever is the wrong answer when
  /// another one is sitting there idle.
  void _demoteModel() {
    if (_ranked.isEmpty) return;
    _modelIndex++;
    debugPrint('[ai] moving on to ${_resolvedModel ?? '(none left)'}');
  }

  /// Asks the model for JSON matching [schema] and decodes it.
  ///
  /// JSON mode rather than parsing prose. Gemini takes a response schema and
  /// fills it; anything that comes back in another shape is rejected as
  /// [AiBadResponse] rather than half-understood. Fishing numbers out of a
  /// paragraph with a regex is how a coaching note becomes a calorie count.
  Future<AiResult<Map<String, Object?>>> completeJson({
    required String lane,
    required String systemPrompt,
    required String userPrompt,
    required Map<String, Object?> schema,
    double temperature = 0.2,
    // 4096, not 800. These models THINK before answering and the thinking
    // counts against this budget: a three-item dinner spent 801 tokens
    // thinking and 367 answering, so an 800 cap truncated the JSON mid-string
    // and surfaced as an unusable-shape error rather than as "ran out of room".
    int maxOutputTokens = 4096,
    bool useCache = true,
  }) async {
    if (!AppConfig.hasGeminiKey) return const AiNoKey();

    final key = _cacheKey(lane, systemPrompt, userPrompt);

    // The cache is consulted BEFORE a model is resolved, and that ordering is
    // the point. resolveModel() memoises only for the life of the process, so
    // on the first call after every launch it does a real GET /models — up to
    // a 20-second wait, against the key, to pick a model whose answer we were
    // never going to need. A cached answer now costs no network at all.
    if (useCache) {
      final hit = await _readCache(key);
      if (hit != null) {
        await _record(lane: lane, model: 'cache', ok: true, cached: true);
        return AiOk(hit, cached: true);
      }
    }

    final model = await resolveModel();
    if (model == null) {
      return const AiOffline('could not find a usable model for this key');
    }

    final used = await callsToday();
    if (used >= dailyBudget) {
      return AiOverBudget(used: used, limit: dailyBudget);
    }

    final body = jsonEncode({
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'contents': [
        {
          'parts': [
            {'text': userPrompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': temperature,
        'maxOutputTokens': maxOutputTokens,
        'responseMimeType': 'application/json',
        'responseSchema': schema,
      },
    });

    final started = DateTime.now();
    // The model that ANSWERS may not be the one we started with, and the call
    // log has to name the right one or the status page quietly lies about
    // which model produced a number.
    var answeredBy = model;
    http.Response response;
    try {
      final attempt = await _postTryingModels(body, model);
      response = attempt.response;
      answeredBy = attempt.model;
    } catch (error) {
      await _record(
        lane: lane,
        model: answeredBy,
        ok: false,
        ms: DateTime.now().difference(started).inMilliseconds,
        promptChars: body.length,
        error: '$error',
      );
      return AiOffline('$error');
    }

    final ms = DateTime.now().difference(started).inMilliseconds;

    if (response.statusCode != 200) {
      // The body carries Google's own explanation, which is the useful half.
      final detail = '${response.statusCode}: ${_trim(response.body)}';
      await _record(
        lane: lane,
        model: answeredBy,
        ok: false,
        ms: ms,
        promptChars: body.length,
        responseChars: response.body.length,
        error: detail,
      );
      return AiOffline(detail);
    }

    final Map<String, Object?> decoded;
    try {
      decoded = _extractJson(response.body);
    } catch (error) {
      await _record(
        lane: lane,
        model: answeredBy,
        ok: false,
        ms: ms,
        promptChars: body.length,
        responseChars: response.body.length,
        error: 'unparseable: $error',
      );
      return AiBadResponse('$error');
    }

    if (useCache) await _writeCache(key, lane, decoded);
    await _record(
      lane: lane,
      model: answeredBy,
      ok: true,
      ms: ms,
      promptChars: body.length,
      responseChars: response.body.length,
    );
    return AiOk(decoded);
  }

  /// Works down the fallback chain until something answers.
  ///
  /// A busy or retired model should cost a moment, not the whole request. The
  /// models list cannot be trusted to know which is which: gemini-2.5-flash is
  /// advertised with generateContent and returns 404 "no longer available to
  /// new users" when actually called. The only way to find out is to ask.
  Future<({http.Response response, String model})> _postTryingModels(
    String body,
    String startedWith,
  ) async {
    http.Response? last;
    var lastModel = startedWith;

    for (var attempt = 0; attempt < 4; attempt++) {
      final model = await resolveModel();
      if (model == null) break;

      final response = await _postWithRetry(model, body);
      lastModel = model;

      // No answer at all: it timed out or the socket died. Move on.
      if (response == null) {
        _demoteModel();
        continue;
      }

      if (response.statusCode == 200) {
        return (response: response, model: model);
      }
      last = response;

      // 404 is permanent for this model; 503 survived its retries; 429 means
      // this model's free-tier allowance is spent. All three say "not this
      // one", so move on rather than report a failure the next model would not
      // have had.
      //
      // 429 belongs HERE and not with the 4xx below, which is where it used to
      // fall. Free-tier quota is counted PER MODEL, so the next model in the
      // chain has an allowance of its own and will usually just answer. Giving
      // up on the first 429 threw that away and reported the whole call dead.
      if (response.statusCode == 404 ||
          response.statusCode == 503 ||
          response.statusCode == 429) {
        _demoteModel();
        continue;
      }
      // 400, 403 and friends are OUR fault — do not shop around.
      return (response: response, model: model);
    }

    return (
      response: last ??
          http.Response(
            '{"error":{"message":"no model in the fallback chain answered '
            'in time"}}',
            503,
          ),
      model: lastModel,
    );
  }

  /// One attempt at one model. Null means it did not answer at all.
  Future<http.Response?> _attempt(String model, String body) async {
    try {
      return await http_
          .post(
            Uri.parse(
              '$_base/models/$model:generateContent?key=${AppConfig.geminiApiKey}',
            ),
            headers: const {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(_attemptTimeout);
    } catch (_) {
      // Timed out, or the socket failed. Either way this model did not answer;
      // the caller decides whether to wait or to move on.
      return null;
    }
  }

  /// Retries only what is worth retrying on the SAME model.
  ///
  /// 503 means overloaded. It fails fast and usually clears within seconds, so
  /// a short backoff is worth it.
  ///
  /// 429 is NOT retried, and used to be. It means the quota is spent — "You
  /// exceeded your current quota" — and a quota does not refill in one second.
  /// Every retry was another request counted against the very allowance that
  /// had just run out, so a single summon spent THREE requests on an exhausted
  /// model and then gave up. It returns immediately now and the caller moves to
  /// the next model, which has its own allowance.
  ///
  /// A TIMEOUT is different again: it means this model is crawling, and waiting
  /// another 22 seconds for the same slow model to be slow again helps nobody.
  /// Also returned immediately.
  Future<http.Response?> _postWithRetry(String model, String body) async {
    const backoff = [Duration(seconds: 1), Duration(seconds: 2)];

    var response = await _attempt(model, body);
    for (final wait in backoff) {
      if (response == null) return null; // slow, not busy — move on
      if (response.statusCode != 503) break;
      await Future<void>.delayed(wait);
      response = await _attempt(model, body);
    }
    return response;
  }

  /// Pulls the model's JSON out of the envelope Gemini wraps it in.
  Map<String, Object?> _extractJson(String responseBody) {
    final envelope = jsonDecode(responseBody) as Map<String, Object?>;

    final candidates = envelope['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      // A blocked prompt comes back with no candidates and a reason.
      final feedback = envelope['promptFeedback'];
      throw FormatException('no candidates${feedback == null ? '' : ' ($feedback)'}');
    }

    final candidate = candidates.first as Map;

    // Said plainly rather than surfacing as a parse error further down: the
    // reply was cut off, and the fix is a bigger budget, not a better schema.
    final finish = candidate['finishReason'];
    if (finish == 'MAX_TOKENS') {
      throw const FormatException(
        'the reply was cut off before it finished (MAX_TOKENS)',
      );
    }

    final content = candidate['content'] as Map?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) {
      throw const FormatException('candidate had no content');
    }

    // Joined, because the reply arrives SPLIT across several parts — the JSON
    // starts in one and continues in the next.
    final text = [
      for (final part in parts) (part as Map)['text'] as String? ?? '',
    ].join();

    final value = jsonDecode(text);
    if (value is! Map<String, Object?>) {
      throw FormatException('expected an object, got ${value.runtimeType}');
    }
    return value;
  }

  /// How many calls have been made today, cache hits excluded.
  Future<int> callsToday() async {
    final start = _startOfToday();
    final rows = await (db.select(db.aiCalls)
          ..where((c) => c.at.isBiggerOrEqualValue(start) & c.cached.equals(false)))
        .get();
    return rows.length;
  }

  DateTime _startOfToday() {
    final now = clock.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// A stable key for an identical request.
  ///
  /// The model name was once part of this, on the reasoning that two models
  /// should not share an answer. That reasoning quietly destroyed the cache.
  /// _modelIndex advances on every 503 and never resets, so the SAME question
  /// asked twice in one session hashed differently the moment the chain
  /// demoted once — and a demotion during US business hours is the normal
  /// case, not the exception. The effect was a fresh network call for a
  /// question already answered.
  /// The cache answers "what came back for this exact prompt". WHICH model
  /// said it is metadata, and it is recorded on the call log where it belongs.
  String _cacheKey(String lane, String system, String user) =>
      sha256.convert(utf8.encode('$lane|$system|$user')).toString();

  Future<Map<String, Object?>?> _readCache(String key) async {
    final row = await (db.select(db.aiCacheEntries)
          ..where((c) => c.cacheKey.equals(key)))
        .getSingleOrNull();
    if (row == null) return null;
    try {
      return jsonDecode(row.response) as Map<String, Object?>;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(
    String key,
    String lane,
    Map<String, Object?> value,
  ) => db.into(db.aiCacheEntries).insertOnConflictUpdate(
    AiCacheEntriesCompanion.insert(
      cacheKey: key,
      lane: lane,
      response: jsonEncode(value),
      at: clock.now(),
    ),
  );

  Future<void> _record({
    required String lane,
    required String model,
    required bool ok,
    bool cached = false,
    int ms = 0,
    int promptChars = 0,
    int responseChars = 0,
    String? error,
  }) async {
    if (error != null) debugPrint('[ai/$lane] $error');
    await db.into(db.aiCalls).insert(
          AiCallsCompanion.insert(
            at: clock.now(),
            lane: lane,
            model: model,
            ok: ok,
            cached: Value(cached),
            durationMs: Value(ms),
            promptChars: Value(promptChars),
            responseChars: Value(responseChars),
            error: Value(error),
          ),
        );
  }

  static String _trim(String s) => s.length <= 300 ? s : '${s.substring(0, 300)}…';
}
