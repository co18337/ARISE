import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../exercise_guides.dart';
import 'media_store.dart';

/// Where a movement's demonstration is coming from.
sealed class DemoSource {
  const DemoSource();
}

/// Shipped with the app.
class BundledDemo extends DemoSource {
  final String assetPath;

  const BundledDemo(this.assetPath);
}

/// Downloaded after install and kept on disk.
class CachedDemo extends DemoSource {
  final String filePath;

  const CachedDemo(this.filePath);
}

/// Nothing to show — the written cue stands in.
class NoDemo extends DemoSource {
  const NoDemo();
}

/// Finds the demonstration for a movement, fetching it once if it has to.
///
/// The programme's own eighteen movements ship in the bundle, so the app works
/// offline out of the box. This exists for what comes after: when the trainer
/// starts choosing from the full 1,324-exercise library, a newly chosen
/// movement is fetched the first time it appears and kept from then on.
///
/// Bundling the whole library instead would add about 370 MB to the APK, which
/// is not a trade worth making for exercises that may never be prescribed.
class ExerciseMedia {
  ExerciseMedia._();

  static const String _base =
      'https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets';

  /// Refuses anything implausibly large, so a redirect to an HTML error page
  /// cannot quietly fill the cache.
  static const int _maxBytes = 3 * 1024 * 1024;

  /// In-memory result cache. Resolving happens on every card build, and it
  /// must not hit the disk each time.
  static final Map<String, DemoSource> _resolved = {};

  /// The bundled asset for [exerciseId], if the catalog declares one.
  static String? bundledAsset(String? demoAsset) =>
      demoAsset == null ? null : 'assets/exercises/$demoAsset.gif';

  /// Resolves a demonstration, downloading it only if it is not already here.
  ///
  /// [datasetId] is the exercises-dataset id (e.g. `0652` for a pull-up).
  /// Without one there is nothing to fetch, and the icon stands in.
  static Future<DemoSource> resolve({
    required String exerciseId,
    String? demoAsset,
    String? datasetId,
  }) async {
    final bundled = bundledAsset(demoAsset);
    if (bundled != null) return BundledDemo(bundled);

    final memo = _resolved[exerciseId];
    if (memo != null) return memo;

    final fileName = '$exerciseId.gif';
    final existing = await cachedMediaPath(fileName);
    if (existing != null) {
      return _resolved[exerciseId] = CachedDemo(existing);
    }

    // The dataset id can come from the bundled guides, or be passed in by
    // whatever chose this exercise.
    final id = datasetId ?? ExerciseGuides.forExercise(exerciseId)?.datasetId;
    if (id == null || id.isEmpty) {
      return _resolved[exerciseId] = const NoDemo();
    }

    try {
      final response = await http
          .get(Uri.parse('$_base/$id.gif'))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200 ||
          response.bodyBytes.length > _maxBytes ||
          response.bodyBytes.length < 1024) {
        return _resolved[exerciseId] = const NoDemo();
      }

      final path = await writeCachedMedia(fileName, response.bodyBytes);
      if (path == null) return _resolved[exerciseId] = const NoDemo();
      return _resolved[exerciseId] = CachedDemo(path);
    } catch (error) {
      // Offline, or the host is unreachable. Not an error worth surfacing:
      // the cue is still there, and it will try again next time.
      debugPrint('[media] could not fetch a demo for $exerciseId: $error');
      return const NoDemo();
    }
  }

  /// How much disk the downloaded demos are using.
  static Future<int> cacheBytes() => cachedMediaBytes();

  static Future<int> clearCache() async {
    _resolved.clear();
    return clearCachedMedia();
  }

  /// Test seam.
  static void primeForTest(String exerciseId, DemoSource source) =>
      _resolved[exerciseId] = source;
}
