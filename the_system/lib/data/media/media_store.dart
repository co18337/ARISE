/// Where downloaded exercise demonstrations are cached.
///
/// A CONDITIONAL EXPORT, the same pattern as the JSON backup writer: `dart:io`
/// cannot be imported at all in a web build, and a `kIsWeb` check at runtime
/// is too late because imports resolve before any code runs.
///
/// On web there is no cache, so an exercise that was not bundled simply shows
/// its icon. That is the right trade: web is the development target, the phone
/// is where the app is actually used.
library;

export 'media_store_stub.dart'
    if (dart.library.io) 'media_store_io.dart';
