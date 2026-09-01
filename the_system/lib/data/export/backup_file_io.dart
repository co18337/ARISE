import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
