import 'health_source.dart';

/// Web, and anywhere else without `dart:io`. The app runs; nothing syncs.
HealthSource createHealthSource() => NoopHealthSource();
