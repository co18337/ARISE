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

  @override
  String get name => 'gemini-${AppConfig.geminiEmbeddingModel}-$dimensions';

  @override
  Future<List<Float32List>> embedAll(List<String> texts) async {
    if (!AppConfig.hasGeminiKey) {
      throw const GeminiUnavailable('no API key configured');
    }
    if (texts.isEmpty) return const [];

    final model = AppConfig.geminiEmbeddingModel;
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

/// One coaching note, generated from retrieved context.
///
/// Deliberately narrow: it is handed the prescription the rule engine already
/// produced plus the passages memory retrieved, and asked to comment. It is
/// NOT asked to choose the exercises. The plan stays deterministic and works
/// offline; the model adds the thing a lookup table cannot.
class GeminiCoach {
  final http.Client client;

  GeminiCoach({http.Client? client}) : client = client ?? http.Client();

  Future<String> coach({
    required String sessionSummary,
    required List<String> recalled,
  }) async {
    if (!AppConfig.hasGeminiKey) {
      throw const GeminiUnavailable('no API key configured');
    }

    final uri = Uri.parse(
      '$_base/models/${AppConfig.geminiModel}:generateContent'
      '?key=${AppConfig.geminiApiKey}',
    );

    final prompt = '''
You are a strength and conditioning coach writing one short note to a trainee
before today's session. Two sentences at most. Be specific and practical.
Do not give medical advice and do not interpret clinical measurements.

Today's prescribed session:
$sessionSummary

What the trainee's own history says:
${recalled.isEmpty ? '(no history yet)' : recalled.map((r) => '- $r').join('\n')}
''';

    final response = await client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0.4, 'maxOutputTokens': 160},
      }),
    );

    if (response.statusCode != 200) {
      throw GeminiUnavailable('coach failed ${response.statusCode}: '
          '${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, Object?>;
    final candidates = decoded['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw const GeminiUnavailable('response had no candidates');
    }

    final parts =
        ((candidates.first as Map)['content'] as Map)['parts'] as List;
    return [
      for (final part in parts) (part as Map)['text'] as String? ?? '',
    ].join().trim();
  }
}
