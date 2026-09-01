import 'notifier.dart';

/// Web, and anywhere else without `dart:io`. The app runs; nothing is posted.
Notifier createNotifier() => NoopNotifier();
