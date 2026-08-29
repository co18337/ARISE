import 'package:drift/drift.dart';

import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';

/// One event as the UI sees it.
class ActivityEntry {
  final int id;
  final DateTime at;
  final ActivityKind kind;
  final String title;
  final String? detail;
  final int? xpDelta;

  const ActivityEntry({
    required this.id,
    required this.at,
    required this.kind,
    required this.title,
    this.detail,
    this.xpDelta,
  });

  /// Day number this event belongs to — used to group the feed by date.
  int get day => dayKeyOf(at);
}

/// Read access to the append-only activity feed that the quest repository
/// writes to. Separate from QuestRepository because reading history and
/// mutating quests are genuinely different jobs.
class ActivityRepository {
  final AppDatabase db;

  ActivityRepository(this.db);

  /// Newest first. Capped because the log grows forever and no screen needs
  /// to render a year of it at once.
  Stream<List<ActivityEntry>> watchRecent({int limit = 200}) {
    final query = db.select(db.activityLogEntries)
      ..orderBy([(e) => OrderingTerm.desc(e.at)])
      ..limit(limit);

    return query.watch().map(
      (rows) => rows
          .map(
            (r) => ActivityEntry(
              id: r.id,
              at: r.at,
              kind: r.kind,
              title: r.title,
              detail: r.detail,
              xpDelta: r.xpDelta,
            ),
          )
          .toList(),
    );
  }
}
