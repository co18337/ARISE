import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Writes [contents] into the app's documents directory and returns the path.
///
/// The app documents directory (rather than a hardcoded path) is the one place
/// an Android app can always write without permissions, and it survives app
/// updates. Returns null if the platform has no such directory.
Future<String?> saveBackupFile(String fileName, String contents) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(contents, flush: true);
  return file.path;
}
