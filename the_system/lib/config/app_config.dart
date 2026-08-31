import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime configuration, loaded from the gitignored `assets/config/.env`.
///
/// The key is read at RUNTIME rather than compiled in, so it can be dropped
/// into the file and the app restarted — no rebuild, no Dart edited, and
/// nothing secret ever in the repo.
///
/// A note on what this can and cannot protect: a key bundled with a client app
/// is extractable by anyone holding the app. That is a fact of client-side
/// keys, not something a different file format fixes. For a single-user
/// personal build on a personal device it is an accepted risk; it would not be
/// acceptable in an app handed to other people.
class AppConfig {
  AppConfig._();

  static const String _envPath = 'assets/config/.env';

  static bool _loaded = false;

  /// Reads the env file if it is there. Missing is not an error — the whole
  /// app works without a key, and must (see CLAUDE.md).
  static Future<void> load() async {
    if (_loaded) return;
    try {
      await dotenv.load(fileName: _envPath, isOptional: true);
    } catch (error) {
      // A malformed or unreadable file must not stop the app from starting.
      debugPrint('[config] could not read $_envPath: $error');
    }
    _loaded = true;
    debugPrint(
      '[config] Gemini key ${hasGeminiKey ? 'present' : 'absent'} — '
      '${hasGeminiKey ? 'live' : 'offline'} trainer and embeddings',
    );
  }

  static String _read(String name, {String fallback = ''}) {
    if (!_loaded) return fallback;
    final value = dotenv.env[name];
    if (value == null) return fallback;
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String get geminiApiKey => _read('GEMINI_API_KEY');

  /// True once a key has actually been supplied. Everything network-dependent
  /// is gated on this, and everything else carries on without it.
  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;

  static String get geminiModel =>
      _read('GEMINI_MODEL', fallback: 'gemini-2.0-flash');

  static String get geminiEmbeddingModel =>
      _read('GEMINI_EMBEDDING_MODEL', fallback: 'text-embedding-004');

  /// Test seam: lets a test pretend a key is or isn't present.
  static void overrideForTest({String? apiKey}) {
    _loaded = true;
    dotenv.testLoad(
      fileInput: apiKey == null ? '' : 'GEMINI_API_KEY=$apiKey',
    );
  }
}
