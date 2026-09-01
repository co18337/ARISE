/// Picks the notifier that can exist on this platform.
///
/// A CONDITIONAL EXPORT, the same trick the backup file uses: the compiler
/// takes the plugin-backed implementation where `dart:io` exists (Android) and
/// the no-op everywhere else. Checking kIsWeb at runtime is too late — the
/// import is resolved long before any code runs, and flutter_local_notifications
/// does not compile for the browser at all.
library;

export 'notifier_stub.dart' if (dart.library.io) 'notifier_local.dart';
