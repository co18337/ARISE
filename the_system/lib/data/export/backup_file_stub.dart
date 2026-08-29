/// Web build: there is no file system to write to.
///
/// The browser can't be handed a path, so the export screen falls back to
/// copying the JSON to the clipboard — which is the only route that works
/// everywhere anyway.
Future<String?> saveBackupFile(String fileName, String contents) async => null;
