import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../game/game.dart';
import 'ai_result.dart';
import 'llm_client.dart';

/// Groq — the fast one, and the first the router tries.
///
/// Chosen over Gemini for the lead because it is markedly quicker: measured in
/// hundreds of milliseconds where Gemini takes two to eight seconds. That is
/// the difference between a summoning that feels instant on the second tap and
/// one that always feels ceremonial.
///
/// UNVERIFIED AGAINST THE LIVE SERVICE at the time of writing. Every field is
/// parsed explicitly so the first real call fails with a readable message
/// rather than a silent wrong answer — the same discipline the Gemini client
/// was written with, and for the same reason.
///
/// NO CACHE HERE. Caching sits above the router, keyed by the prompt alone, so
/// a question Groq has already answered is never re-asked of Gemini.
class GroqClient implements LlmClient {
  final http.Client http_;
  final Clock clock;

  GroqClient({http.Client? client, this.clock = const Clock()})
    : http_ = client ?? http.Client();

  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  /// Same reasoning as Gemini's: a saturated provider answers slowly as often
  /// as it answers 503, and there is a second provider one line down.
  static const Duration _timeout = Duration(seconds: 20);

  /// Every usable model, best first. Resolved once per session.
  List<String> _ranked = const [];
  int _modelIndex = 0;

  String? get _model =>
      _modelIndex < _ranked.length ? _ranked[_modelIndex] : null;

  /// Models that cannot answer a JSON prompt, whatever the list says.
  static const List<String> _excluded = [
    'whisper', 'tts', 'guard', 'vision', 'embed', 'orpheus', 'allam',
  ];

  /// The model to use, ASKED OF THE API rather than assumed.
  ///
  /// This client shipped pinned to `llama-3.3-70b-versatile` and returned 404
  /// on the very first real call: the model does not exist on this key. That
  /// is precisely the mistake the Gemini client already documents — a
  /// hardcoded model name is a dated assumption with a fuse on it — and
  /// pinning it here on the reasoning that "Groq's catalogue is small and
  /// stable" was wrong within a day.
  ///
  /// Setting GROQ_MODEL in .env overrides this entirely.
  Future<String?> resolveModel() async {
    final configured = AppConfig.configuredGroqModel;
    if (configured.isNotEmpty) return configured;
    if (_model != null) return _model;
    if (_ranked.isNotEmpty) return null; // every candidate exhausted

    try {
      final response = await http_
          .get(
            Uri.parse('https://api.groq.com/openai/v1/models'),
            headers: {'Authorization': 'Bearer ${AppConfig.groqApiKey}'},
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body) as Map<String, Object?>;
      final names = [
        for (final m in (decoded['data'] as List? ?? const []))
          if (m is Map) (m['id'] as String? ?? ''),
      ]..removeWhere((n) => n.isEmpty);

      _ranked = rank(names);
      _modelIndex = 0;
      debugPrint('[ai] groq using ${_model ?? '(none found)'}');
      return _model;
    } catch (_) {
      return null;
    }
  }

  /// Usable text models, most capable first.
  ///
  /// Every one of them answers in well under a second on this hardware, so
  /// capability decides the order rather than speed — the slowest measured was
  /// 873ms against Gemini's twenty-three SECONDS.
  static List<String> rank(List<String> names) {
    final usable = [
      for (final n in names)
        if (!_excluded.any((bad) => n.toLowerCase().contains(bad))) n,
    ];

    int score(String n) {
      if (n.contains('gpt-oss-120b')) return 100;
      if (n.contains('gpt-oss')) return 90;
      if (n.contains('qwen3.8')) return 80;
      if (n.contains('qwen')) return 70;
      if (n.contains('compound-mini')) return 50;
      if (n.contains('compound')) return 60;
      return 10;
    }

    usable.sort((a, b) => score(b).compareTo(score(a)));
    return usable.take(3).toList();
  }

  /// Steps to the next model. A 404 means this key cannot see that one.
  void _demote() {
    _modelIndex++;
    debugPrint('[ai] groq moving on to ${_model ?? '(none left)'}');
  }

  /// Set when the daily allowance is spent, cleared when the day turns.
  ///
  /// Groq reports what is left in response HEADERS, so exhaustion is READ
  /// rather than discovered one 429 at a time. Once it is known, the router
  /// stops trying and Gemini takes over for the rest of the day.
  DateTime? _exhaustedOn;

  @override
  String get name => 'groq';

  @override
  bool get isConfigured => AppConfig.hasGroqKey;

  @override
  bool get isExhausted {
    final on = _exhaustedOn;
    if (on == null) return false;
    final now = clock.now();
    // A new day resets it. Groq's window is rolling rather than midnight-based,
    // so this is optimistic by design: the cost of being wrong is one request
    // that comes back 429 and puts the flag straight back.
    if (now.year != on.year || now.month != on.month || now.day != on.day) {
      _exhaustedOn = null;
      return false;
    }
    return true;
  }

  @override
  Future<AiResult<Map<String, Object?>>> completeJson({
    required String lane,
    required String systemPrompt,
    required String userPrompt,
    required Map<String, Object?> schema,
    double temperature = 0.2,
    int maxOutputTokens = 4096,
  }) async {
    if (!isConfigured) return const AiNoKey();

    final model = await resolveModel();
    if (model == null) {
      return const AiOffline('no usable Groq model for this key');
    }

    final body = jsonEncode({
      'model': model,
      'temperature': temperature,
      'max_tokens': maxOutputTokens,
      // JSON mode. Groq guarantees syntactically valid JSON but NOT the
      // schema, so the shape is still checked after parsing — the schema goes
      // in the system prompt where the model can act on it.
      'response_format': {'type': 'json_object'},
      'messages': [
        {
          'role': 'system',
          'content': '$systemPrompt\n\n'
              'Reply with JSON only, matching this schema exactly:\n'
              '${jsonEncode(schema)}',
        },
        {'role': 'user', 'content': userPrompt},
      ],
    });

    http.Response response;
    try {
      response = await http_
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppConfig.groqApiKey}',
            },
            body: body,
          )
          .timeout(_timeout);
    } catch (error) {
      // Timed out or the socket died. Not retried on this provider — a slow
      // provider is slow again a second later, and there is another one.
      return AiOffline('$error');
    }

    _readRemainingQuota(response);

    if (response.statusCode == 429) {
      // A quota, not congestion. Do not retry it here and do not retry it at
      // all: mark the day spent so the router stops asking, and let Gemini
      // take the rest of today.
      _exhaustedOn = clock.now();
      debugPrint('[ai] groq quota spent for today');
      return AiOverBudget(used: 0, limit: 0);
    }

    if (response.statusCode == 404) {
      // This key cannot see that model. Step down and try the next, exactly
      // once — the same shape as Gemini's chain.
      _demote();
      if (_model != null) {
        return completeJson(
          lane: lane,
          systemPrompt: systemPrompt,
          userPrompt: userPrompt,
          schema: schema,
          temperature: temperature,
          maxOutputTokens: maxOutputTokens,
        );
      }
    }

    if (response.statusCode != 200) {
      return AiOffline('${response.statusCode}: ${_trim(response.body)}');
    }

    try {
      return AiOk(_extract(response.body));
    } catch (error) {
      return AiBadResponse('$error');
    }
  }

  /// Reads what is left out of the rate-limit headers.
  ///
  /// The headers are the point: knowing the allowance is gone BEFORE spending
  /// a request to find out is the whole reason this provider can lead without
  /// wasting calls discovering its own limits.
  void _readRemainingQuota(http.Response response) {
    final remaining = response.headers['x-ratelimit-remaining-requests'];
    final left = int.tryParse(remaining ?? '');
    if (left != null && left <= 0) {
      _exhaustedOn = clock.now();
      debugPrint('[ai] groq reports no requests left today');
    }
  }

  /// Pulls the model's JSON out of the chat envelope.
  Map<String, Object?> _extract(String responseBody) {
    final envelope = jsonDecode(responseBody) as Map<String, Object?>;

    final choices = envelope['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw StateError('no choices in the reply');
    }

    final first = choices.first as Map<String, Object?>;

    // Reported as "cut off" rather than as a bad shape, because they are
    // different problems with different fixes — the same distinction the
    // Gemini client draws for finishReason: MAX_TOKENS.
    if (first['finish_reason'] == 'length') {
      throw StateError('the reply was cut off — raise maxOutputTokens');
    }

    final message = first['message'] as Map<String, Object?>?;
    final content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw StateError('the reply had no content');
    }

    final decoded = jsonDecode(content);
    if (decoded is! Map<String, Object?>) {
      throw StateError('expected an object, got ${decoded.runtimeType}');
    }
    return decoded;
  }

  static String _trim(String body) =>
      body.length <= 300 ? body : '${body.substring(0, 297)}…';
}
