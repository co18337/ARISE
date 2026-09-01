import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../data/db/database.dart';
import '../game/game.dart';
import 'ai_result.dart';
import 'llm_client.dart';

/// Tries each provider in turn, and caches above all of them.
///
/// THE CACHE SITS HERE, not inside a provider, and that placement is the whole
/// design. Keyed by the prompt alone, it means a question Groq answered this
/// morning is never re-asked of Gemini this afternoon — and it means switching
/// providers costs nothing, because the answers are shared.
///
/// The order is Groq then Gemini: Groq is markedly faster, which is what makes
/// a second summoning feel instant. Gemini is the deeper well when Groq is
/// busy or spent.
///
/// Falling through happens for three reasons and no others:
///   - the provider has no key, so it is skipped without a request;
///   - it reports its allowance spent, which it knows from its own headers;
///   - it answers 429, 503 or times out.
/// A 400 is OUR fault and stops the chain — shopping a malformed prompt around
/// every provider just produces the same rejection twice.
class LlmRouter {
  final AppDatabase db;

  /// In order of preference.
  final List<LlmClient> providers;

  final Clock clock;

  /// Calls allowed per day across ALL providers before the router refuses.
  ///
  /// Not about cost — both tiers are free — but about a bug in a retry loop
  /// being unable to burn every allowance while you are asleep.
  final int dailyBudget;

  LlmRouter({
    required this.db,
    required this.providers,
    this.clock = const Clock(),
    this.dailyBudget = 200,
  });

  bool get hasAnyProvider => providers.any((p) => p.isConfigured);

  Future<AiResult<Map<String, Object?>>> completeJson({
    required String lane,
    required String systemPrompt,
    required String userPrompt,
    required Map<String, Object?> schema,
    double temperature = 0.2,
    int maxOutputTokens = 4096,
    bool useCache = true,
  }) async {
    if (!hasAnyProvider) return const AiNoKey();

    final key = _cacheKey(lane, systemPrompt, userPrompt);

    // Before ANY provider is considered, let alone called. A cached answer
    // costs no network at all.
    if (useCache) {
      final hit = await _readCache(key);
      if (hit != null) {
        await _record(lane: lane, model: 'cache', ok: true, cached: true);
        return AiOk(hit, cached: true);
      }
    }

    final used = await callsToday();
    if (used >= dailyBudget) {
      return AiOverBudget(used: used, limit: dailyBudget);
    }

    AiResult<Map<String, Object?>>? last;

    for (final provider in providers) {
      if (!provider.isConfigured) continue;
      if (provider.isExhausted) {
        debugPrint('[ai] skipping ${provider.name} — allowance spent');
        continue;
      }

      final started = DateTime.now();
      final result = await provider.completeJson(
        lane: lane,
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        schema: schema,
        temperature: temperature,
        maxOutputTokens: maxOutputTokens,
      );
      final ms = DateTime.now().difference(started).inMilliseconds;

      switch (result) {
        case AiOk(:final value):
          if (useCache) await _writeCache(key, lane, value);
          await _record(lane: lane, model: provider.name, ok: true, ms: ms);
          return result;

        case AiBadResponse():
          // The provider answered, and answered badly. That is worth trying
          // elsewhere — a different model may well produce the right shape.
          await _record(
            lane: lane,
            model: provider.name,
            ok: false,
            ms: ms,
            error: '${result.runtimeType}',
          );
          last = result;

        case AiOverBudget() || AiOffline():
          await _record(
            lane: lane,
            model: provider.name,
            ok: false,
            ms: ms,
            error: _detail(result),
          );
          last = result;

        case AiNoKey():
          continue;
      }
    }

    return last ?? const AiOffline('no provider answered');
  }

  Future<int> callsToday() async {
    final now = clock.now();
    final start = DateTime(now.year, now.month, now.day);
    final rows = await (db.select(db.aiCalls)
          ..where((c) => c.at.isBiggerOrEqualValue(start)))
        .get();
    return rows.where((c) => !c.cached).length;
  }

  static String _detail(AiResult<Object?> result) => switch (result) {
    AiOffline(:final detail) => detail,
    AiBadResponse(:final detail) => detail,
    AiOverBudget(:final used, :final limit) => 'over budget $used/$limit',
    _ => '',
  };

  /// A stable key for an identical request, with NO provider or model in it.
  ///
  /// That omission is deliberate and was learned the hard way: the Gemini
  /// client once put the model name in the key, and because its fallback chain
  /// advanced on every 503 and never reset, the same question hashed
  /// differently after one demotion and the cache silently stopped working.
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
    String? error,
  }) => db.into(db.aiCalls).insert(
    AiCallsCompanion.insert(
      at: clock.now(),
      lane: lane,
      model: model,
      ok: ok,
      cached: Value(cached),
      durationMs: Value(ms),
      error: Value(error),
    ),
  );
}
