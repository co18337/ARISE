import 'dart:io';

import 'package:flutter/widgets.dart' show FileImage, ImageProvider;
import 'package:path_provider/path_provider.dart';

/// Demonstrations downloaded after install live here, beside the database.
///
/// Kept OUT of the app bundle on purpose: bundling all 1,324 exercises would
/// add roughly 370 MB to the APK, so the programme's own movements ship with
/// the app and anything the trainer reaches for later is fetched once and
/// kept.
Future<Directory> _mediaDirectory() async {
  final documents = await getApplicationDocumentsDirectory();
  final dir = Directory('${documents.path}/exercise_media');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  return dir;
}

Future<String?> cachedMediaPath(String name) async {
  final file = File('${(await _mediaDirectory()).path}/$name');
  return file.existsSync() ? file.path : null;
}

Future<String?> writeCachedMedia(String name, List<int> bytes) async {
  final file = File('${(await _mediaDirectory()).path}/$name');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

/// Total size of the cache, so the app can report what it is holding.
Future<int> cachedMediaBytes() async {
  final dir = await _mediaDirectory();
  var total = 0;
  for (final entity in dir.listSync()) {
    if (entity is File) total += entity.lengthSync();
  }
  return total;
}

Future<int> clearCachedMedia() async {
  final dir = await _mediaDirectory();
  var removed = 0;
  for (final entity in dir.listSync()) {
    if (entity is File) {
      entity.deleteSync();
      removed++;
    }
  }
  return removed;
}

/// An image provider for a cached file. Lives here because FileImage needs
/// `dart:io`, which a web build cannot even import.
/// Plain FileImage: the widget wraps it in a ResizeImage at display size, so
/// resizing here as well would decode twice.
ImageProvider? fileImageProvider(String path) => FileImage(File(path));
