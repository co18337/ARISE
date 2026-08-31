/// Splits a document into retrievable pieces.
///
/// Retrieval returns CHUNKS, not documents: handing a model an entire
/// six-month transformation plan to answer "what did I do last Tuesday" wastes
/// the context window on text that cannot help. Chunks overlap slightly so a
/// sentence spanning a boundary is not lost to both sides.
library;

/// Roughly how long a chunk should be, in characters. Characters rather than
/// tokens because tokenisation is model-specific and this has to work with no
/// model at all.
const int defaultChunkSize = 400;

/// How much of the previous chunk to repeat at the start of the next.
const int defaultChunkOverlap = 60;

List<String> chunkText(
  String text, {
  int size = defaultChunkSize,
  int overlap = defaultChunkOverlap,
}) {
  final normalised = text.trim().replaceAll(RegExp(r'[ \t]+'), ' ');
  if (normalised.isEmpty) return const [];
  if (normalised.length <= size) return [normalised];

  final chunks = <String>[];
  var start = 0;

  while (start < normalised.length) {
    var end = start + size;
    if (end >= normalised.length) {
      chunks.add(normalised.substring(start).trim());
      break;
    }

    // Prefer to break at a sentence end, then at any whitespace, before
    // resorting to cutting a word in half.
    final window = normalised.substring(start, end);
    final sentence = window.lastIndexOf(RegExp(r'[.!?\n]'));
    final space = window.lastIndexOf(' ');
    if (sentence > size ~/ 2) {
      end = start + sentence + 1;
    } else if (space > size ~/ 2) {
      end = start + space;
    }

    chunks.add(normalised.substring(start, end).trim());
    final next = end - overlap;
    // Always move forward, whatever the break landed on.
    start = next > start ? next : end;
  }

  return chunks.where((c) => c.isNotEmpty).toList();
}
