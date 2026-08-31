import 'dart:math' as math;
import 'dart:typed_data';

/// Turns text into a vector.
///
/// Two implementations are planned and the interface is what keeps them
/// interchangeable: [HashingEmbedder], which runs locally and always works,
/// and a Gemini-backed one that needs a key and a network. The app has to keep
/// working with neither (CLAUDE.md), so the local one is the floor.
abstract class Embedder {
  /// Recorded on every stored vector. Vectors from different embedders are NOT
  /// comparable, so the corpus has to know which produced it — see the note on
  /// MemoryChunks.embedder.
  String get name;

  int get dimensions;

  Future<List<Float32List>> embedAll(List<String> texts);
}

/// The single-text convenience, as an extension rather than a method on the
/// interface: `implements Embedder` would otherwise force every implementation
/// to re-declare it for no reason.
extension EmbedOne on Embedder {
  Future<Float32List> embed(String text) async => (await embedAll([text])).first;
}

/// A local, deterministic embedder built on feature hashing.
///
/// Every token and token-pair is hashed into one of [dimensions] buckets and
/// accumulated with a sign, then the vector is L2-normalised so cosine
/// similarity is a plain dot product.
///
/// What it is: real, offline, dependency-free, reproducible, and good enough
/// that "sprint intervals" retrieves sprint sessions.
///
/// What it is NOT: semantic. It matches shared WORDS, not shared meaning, so
/// "shoulder pain" will not retrieve "rotator cuff discomfort". That is the
/// job of the Gemini embedder, and the reason this one records its name
/// against every vector it writes.
class HashingEmbedder implements Embedder {
  @override
  final int dimensions;

  /// 1024 by default, not 256.
  ///
  /// Signed hashing with bigrams puts a lot of features in play, and at 256
  /// buckets a colliding token can flip the sign of a bucket a real match
  /// depends on. Measured: a query that should have scored 0.08 against a
  /// matching session scored exactly 0.0000, because the three shared buckets
  /// were each cancelled by an unrelated collision. Four kilobytes per chunk
  /// is a price worth paying to make that vanishingly unlikely.
  const HashingEmbedder({this.dimensions = 1024});

  @override
  String get name => 'hashing-v1-$dimensions';

  @override
  Future<List<Float32List>> embedAll(List<String> texts) async =>
      [for (final text in texts) _embedOne(text)];

  Float32List _embedOne(String text) {
    final vector = Float32List(dimensions);
    final tokens = tokenise(text);

    void add(String feature) {
      final h = _fnv1a(feature);
      final index = h % dimensions;
      // Signed hashing: half the collisions cancel instead of compounding,
      // which keeps an unlucky bucket from dominating the vector.
      final sign = (h & 0x80000000) != 0 ? -1.0 : 1.0;
      vector[index] += sign;
    }

    for (var i = 0; i < tokens.length; i++) {
      add(tokens[i]);
      // Bigrams carry the little word order that matters here: "leg raises"
      // should not look identical to "raise legs day".
      if (i + 1 < tokens.length) add('${tokens[i]}_${tokens[i + 1]}');
    }

    return _normalise(vector);
  }

  /// Words that carry no retrieval signal.
  ///
  /// Without this the vector for "Steady run: 1 of 1 sets at 12 min" spends
  /// most of its length on "of", "at" and "the", and the two words that
  /// actually identify the session are a small fraction of it. Removing them
  /// roughly doubled the score of a correct match in testing.
  static const Set<String> stopwords = {
    'a', 'an', 'and', 'the', 'of', 'at', 'to', 'in', 'on', 'for', 'is', 'was',
    'were', 'be', 'been', 'it', 'its', 'this', 'that', 'with', 'as', 'by',
    'from', 'or', 'but', 'so', 'than', 'then', 'there', 'here', 'my', 'me',
    'i', 'you', 'he', 'she', 'they', 'we', 'am', 'are', 'do', 'did', 'done',
    'have', 'has', 'had', 'will', 'would', 'can', 'could', 'up', 'out',
    'after', 'before', 'into', 'over', 'under', 'again', 'very', 'just',
  };

  /// Lowercased alphanumeric words, stopwords dropped. Deliberately crude — a
  /// stemmer would help slightly and cost a dependency and a lot of edge
  /// cases. Numbers are KEPT: "12 min" and "20 seconds" are signal here.
  static List<String> tokenise(String text) => text
      .toLowerCase()
      .split(RegExp(r'[^a-z0-9]+'))
      .where((t) => t.isNotEmpty && !stopwords.contains(t))
      .toList();

  /// FNV-1a, 32-bit. A fixed, specified hash rather than Dart's `hashCode`,
  /// which carries no guarantee of stability across releases — and a stored
  /// corpus that stops matching after an SDK upgrade would be very hard to
  /// diagnose.
  static int _fnv1a(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  static Float32List _normalise(Float32List v) {
    var sum = 0.0;
    for (final x in v) {
      sum += x * x;
    }
    if (sum == 0) return v;
    final norm = math.sqrt(sum);
    for (var i = 0; i < v.length; i++) {
      v[i] = v[i] / norm;
    }
    return v;
  }
}

/// Cosine similarity. Both vectors are stored normalised, so this is a dot
/// product; the guard is there for anything that arrives un-normalised.
double cosineSimilarity(Float32List a, Float32List b) {
  if (a.length != b.length) return 0;
  var dot = 0.0, na = 0.0, nb = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  if (na == 0 || nb == 0) return 0;
  return dot / (math.sqrt(na) * math.sqrt(nb));
}

/// Vectors go into the database as raw float32 bytes.
///
/// Copied rather than viewed: `buffer.asUint8List()` would expose the whole
/// backing buffer, which is not always exactly this list.
Uint8List packVector(Float32List vector) =>
    Uint8List.fromList(vector.buffer.asUint8List(
      vector.offsetInBytes,
      vector.lengthInBytes,
    ));

Float32List unpackVector(Uint8List bytes) =>
    Float32List.fromList(bytes.buffer
        .asFloat32List(bytes.offsetInBytes, bytes.lengthInBytes ~/ 4));
