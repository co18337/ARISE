/// Picks the health source that can exist on this platform.
///
/// A conditional export, the same trick the backup file and the notifier use:
/// the compiler takes the Health Connect implementation where `dart:io` exists
/// and the no-op everywhere else. The `health` package does not compile for the
/// browser, and a runtime kIsWeb check is far too late — imports are resolved
/// before any code runs.
library;

export 'health_source_stub.dart'
    if (dart.library.io) 'health_source_hc.dart';
