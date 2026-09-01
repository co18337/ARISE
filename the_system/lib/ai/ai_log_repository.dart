import 'package:drift/drift.dart';

import '../data/db/database.dart';
import '../game/game.dart';

/// What the model has been asked to do, and how it went.
class AiSummary {
  final int callsToday;
  final int failuresToday;
  final int cacheHitsToday;
  final int cachedAnswers;
  final int averageMs;
  final DateTime? lastCallAt;
  final String? lastError;

  const AiSummary({
    this.callsToday = 0,
    this.failuresToday = 0,
    this.cacheHitsToday = 0,
    this.cachedAnswers = 0,
    this.averageMs = 0,
    this.lastCallAt,
    this.lastError,
  });

  static const AiSummary empty = AiSummary();

  bool get everCalled => lastCallAt != null;
}

/// Reads the call log.
///
/// Diagnostics, not analytics. The first live call will fail on some detail of
/// the request shape, and without somewhere to read the error the only symptom
/// is a button that appears to do nothing.
class AiLogRepository {
  final AppDatabase db;
  final Clock clock;

  AiLogRepository(this.db, {this.clock = const Clock()});

  Future<AiSummary> summary() async {
    final now = clock.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final all = await (db.select(db.aiCalls)
          ..orderBy([(c) => OrderingTerm.desc(c.at)]))
        .get();
    if (all.isEmpty) return AiSummary.empty;

    final today = all.where((c) => !c.at.isBefore(startOfDay)).toList();
    final billable = today.where((c) => !c.cached).toList();
    final failures = today.where((c) => !c.ok).toList();
    final timed = today.where((c) => c.ok && !c.cached && c.durationMs > 0);

    final cached = await db.select(db.aiCacheEntries).get();

    return AiSummary(
      callsToday: billable.length,
      failuresToday: failures.length,
      cacheHitsToday: today.where((c) => c.cached).length,
      cachedAnswers: cached.length,
      averageMs: timed.isEmpty
          ? 0
          : timed.map((c) => c.durationMs).reduce((a, b) => a + b) ~/
                timed.length,
      lastCallAt: all.first.at,
      lastError: all.where((c) => c.error != null).firstOrNull?.error,
    );
  }

  Future<List<AiCallRow>> recent({int limit = 12}) => (db.select(db.aiCalls)
        ..orderBy([(c) => OrderingTerm.desc(c.at)])
        ..limit(limit))
      .get();

  /// Throws away remembered answers, so the next ask really calls out.
  /// Useful when a prompt changes and the old replies no longer apply.
  Future<int> clearCache() => db.delete(db.aiCacheEntries).go();
}
