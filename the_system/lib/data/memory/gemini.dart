import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import 'embedder.dart';

/// The Gemini endpoints, behind the key.
///
/// NOT VERIFIED AGAINST THE LIVE SERVICE. There is no key in this build, so
/// the request shapes below are written from the published API and have never
/// had a real response come back. Treat the first run with a key as the real
/// test — the failure will be a 400 with a readable message, not a silent
/// wrong answer, because everything here parses explicitly.
///
/// Nothing in the app depends on these classes existing: without a key the
/// hashing embedder and the rule-based trainer carry on exactly as before.
class GeminiUnavailable implements Exception {
  final String message;

  const GeminiUnavailable(this.message);

  @override
  String toString() => 'GeminiUnavailable: $message';
}

const String _base = 'https://generativelanguage.googleapis.com/v1beta';

/// Embeddings from Gemini, for when the corpus deserves better than hashing.
///
/// Swapping to this changes the vectors, which is exactly why every chunk
/// records the embedder that produced it: switching means running
/// [MemoryRepository.reembedAll], not trusting the old vectors.
class GeminiEmbedder implements Embedder {
  final http.Client client;

  @override
  final int dimensions;

  GeminiEmbedder({http.Client? client, this.dimensions = 768})
      : client = client ?? http.Client();

  /// Resolved once per session, like every other model name in this app.
  String? _model;

  @override
  String get name => 'gemini-${_model ?? 'auto'}-$dimensions';

  @override
  Future<void> prepare() => resolveModel();

  /// The embedding model this key can actually use.
  ///
  /// ASKED OF THE API. This class shipped pinned to `text-embedding-004`,
  /// which returns 404 on this key — the third pinned model name to be wrong
  /// in this codebase. Anything advertising embedContent will do; newer first.
  Future<String?> resolveModel() async {
    final configured = AppConfig.geminiEmbeddingModel;
    if (configured.isNotEmpty) return _model = configured;
    if (_model != null) return _model;

    try {
      final response = await client
          .get(
            Uri.parse('$_base/models?key=${AppConfig.geminiApiKey}&pageSize=200'),
          )
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body) as Map<String, Object?>;
      final names = [
        for (final m in (decoded['models'] as List? ?? const []))
          if (m is Map &&
              ((m['supportedGenerationMethods'] as List?) ?? const [])
                  .contains('embedContent'))
            (m['name'] as String? ?? '').replaceFirst('models/', ''),
      ]..removeWhere((n) => n.isEmpty || n.contains('preview'));

      names.sort((a, b) => b.compareTo(a));
      return _model = names.isEmpty ? null : names.first;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Float32List>> embedAll(List<String> texts) async {
    if (!AppConfig.hasGeminiKey) {
      throw const GeminiUnavailable('no API key configured');
    }
    if (texts.isEmpty) return const [];

    final model = await resolveModel();
    if (model == null) {
      throw const GeminiUnavailable('no embedding model available to this key');
    }
    final uri = Uri.parse(
      '$_base/models/$model:batchEmbedContents?key=${AppConfig.geminiApiKey}',
    );

    final response = await client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requests': [
          for (final text in texts)
            {
              'model': 'models/$model',
              'content': {
                'parts': [
                  {'text': text},
                ],
              },
            },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw GeminiUnavailable('embed failed ${response.statusCode}: '
          '${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, Object?>;
    final embeddings = decoded['embeddings'] as List?;
    if (embeddings == null) {
      throw const GeminiUnavailable('response had no embeddings');
    }

    return [
      for (final entry in embeddings)
        Float32List.fromList([
          for (final v in (entry as Map)['values'] as List)
            (v as num).toDouble(),
        ]),
    ];
  }
}
