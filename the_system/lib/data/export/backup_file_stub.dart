/// Web build: there is no file system to write to.
///
/// The browser can't be handed a path, so the export screen falls back to
/// copying the JSON to the clipboard — which is the only route that works
/// everywhere anyway.
Future<String?> saveBackupFile(String fileName, String contents) async => null;

/// No share sheet in a browser either. Reported as "not shared" rather than
/// thrown, so the screen degrades to the clipboard instead of showing an error.
Future<bool> shareBackupFile(String fileName, String contents) async => false;
