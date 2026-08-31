import 'package:flutter/widgets.dart' show ImageProvider;

/// Web: no file system, so nothing is cached and nothing is downloaded.
Future<String?> cachedMediaPath(String name) async => null;

Future<String?> writeCachedMedia(String name, List<int> bytes) async => null;

Future<int> cachedMediaBytes() async => 0;

Future<int> clearCachedMedia() async => 0;

/// Web has no files to show, so nothing to provide.
ImageProvider? fileImageProvider(String path) => null;
