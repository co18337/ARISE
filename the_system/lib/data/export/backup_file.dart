/// Saving a backup to disk, where there is a disk.
///
/// A CONDITIONAL EXPORT: the compiler picks the io implementation when
/// `dart:io` exists (Android, desktop) and the stub otherwise (web). This is
/// how a Flutter app touches the file system without breaking the web build —
/// importing `dart:io` unconditionally fails to compile for the browser, and
/// checking `kIsWeb` at runtime is too late, because the import is resolved
/// long before any code runs.
library;

export 'backup_file_stub.dart'
    if (dart.library.io) 'backup_file_io.dart';
