import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'snapshot_pruning.dart';

/// Writes [contents] into the app's documents directory and returns the path.
///
/// A CONVENIENCE COPY, not the backup. Android deletes this directory when the
/// app is uninstalled, so a file that lives only here is protected against
/// every accident except the one people actually have. Use [shareBackupFile]
/// to get a copy somewhere that outlives the app.
Future<String?> saveBackupFile(String fileName, String contents) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(contents, flush: true);
  return file.path;
}

/// Hands the backup to the Android share sheet — Drive, Gmail, WhatsApp, a
/// USB cable, whatever is installed.
///
/// Written into the CACHE directory first, deliberately. The file is a courier,
/// not storage: once the share sheet has copied it somewhere durable this copy
/// is dead weight, and the cache is the one directory Android will reclaim on
/// its own. Sharing straight out of the documents directory would leave a
/// growing pile of near-identical backups nobody ever deletes.
///
/// Returns false when the sheet was dismissed without choosing anything, so
/// the screen can avoid claiming a backup was saved when it was not.
Future<bool> shareBackupFile(String fileName, String contents) async {
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(contents, flush: true);

  final result = await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'application/json')],
      // Named so the file is recognisable a month later in a Drive folder.
      fileNameOverrides: [fileName],
      subject: 'The System — backup',
    ),
  );
  return result.status == ShareResultStatus.success;
}

/// The snapshots folder: dated copies written automatically, newest kept.
///
/// EXTERNAL rather than the documents directory, and that is the whole point.
/// This path is visible over a USB cable and to any file manager, so a copy can
/// be taken off the phone without opening the app at all. It is still
/// app-scoped — Android deletes it on uninstall — so it does NOT replace the
/// share sheet, which remains the only route to storage that outlives the app.
/// What it replaces is the real failure: no recent backup existing at all,
/// because taking one was a button nobody remembered to press.
Future<Directory> _snapshotFolder() async {
  final base =
      await getExternalStorageDirectory() ??
      await getApplicationDocumentsDirectory();
  final folder = Directory('${base.path}/snapshots');
  if (!folder.existsSync()) await folder.create(recursive: true);
  return folder;
}

/// Writes a dated snapshot and prunes to the newest [keep].
Future<String?> saveRollingSnapshot(
  String fileName,
  String contents, {
  int keep = 7,
}) async {
  final folder = await _snapshotFolder();
  final file = File('${folder.path}/$fileName');
  await file.writeAsString(contents, flush: true);

  final names = folder
      .listSync()
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .toList();
  for (final stale in staleSnapshots(names, keep: keep)) {
    try {
      File('${folder.path}/$stale').deleteSync();
    } catch (_) {
      // A snapshot that will not delete is not worth failing a backup over.
    }
  }
  return file.path;
}

/// When the newest snapshot was taken, or null if there is none.
Future<DateTime?> newestSnapshotAt() async {
  final folder = await _snapshotFolder();
  final files = folder.listSync().whereType<File>().toList();
  if (files.isEmpty) return null;
  return files
      .map((f) => f.statSync().modified)
      .reduce((a, b) => a.isAfter(b) ? a : b);
}
