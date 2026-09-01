import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../db/database.dart';

/// One editable step of the plan.
class PlanEntry {
  final TaskTemplate template;
  final bool isActive;
  final int sortOrder;

  /// How many days have already been issued from it. An archived template
  /// with history behind it must never be deleted outright.
  final int issuedCount;

  const PlanEntry({
    required this.template,
    required this.isActive,
    required this.sortOrder,
    required this.issuedCount,
  });

  bool get hasHistory => issuedCount > 0;
}

/// Editing the plan from inside the app.
///
/// This is what finally makes "the plan is DATA" literally true rather than
/// aspirational. Until now changing a step's time meant editing Dart and
/// rebuilding, which made the app's author a dependency on its user's routine.
///
/// TWO RULES hold the whole thing together, and both come from the fact that
/// daily quests SNAPSHOT their xp and timings at issue time:
///
///  1. Editing a template changes TOMORROW, never yesterday. Re-timing a step
///     must not retroactively decide whether last Tuesday's lapsed.
///  2. A template with history is ARCHIVED, never deleted. Its issued quests
///     reference it, and removing the row would orphan them — the foreign key
///     would refuse, and if it did not, the weekly report would lose days.
class PlanRepository {
  final AppDatabase db;

  PlanRepository(this.db);

  /// Every step, in routine order: earliest first, unscheduled last.
  Stream<List<PlanEntry>> watch() {
    final query = db.select(db.taskTemplates)
      ..orderBy([
        (t) => OrderingTerm.asc(
          coalesce([t.scheduledMinutes, const Constant(minutesInDay)]),
        ),
        (t) => OrderingTerm.asc(t.sortOrder),
      ]);
    return query.watch().asyncMap(_withHistory);
  }

  Future<List<PlanEntry>> read() async {
    final rows =
        await (db.select(db.taskTemplates)
              ..orderBy([
                (t) => OrderingTerm.asc(
                  coalesce([t.scheduledMinutes, const Constant(minutesInDay)]),
                ),
                (t) => OrderingTerm.asc(t.sortOrder),
              ]))
            .get();
    return _withHistory(rows);
  }

  Future<List<PlanEntry>> _withHistory(List<TaskTemplateRow> rows) async {
    // One grouped count rather than a query per template: eighteen steps is
    // eighteen round trips through the executor for a number shown on a card.
    final counts = <String, int>{};
    final grouped = db.selectOnly(db.dailyQuests)
      ..addColumns([db.dailyQuests.templateId, db.dailyQuests.id.count()])
      ..groupBy([db.dailyQuests.templateId]);
    for (final row in await grouped.get()) {
      counts[row.read(db.dailyQuests.templateId)!] =
          row.read(db.dailyQuests.id.count()) ?? 0;
    }

    return [
      for (final r in rows)
        PlanEntry(
          template: _toTemplate(r),
          isActive: r.isActive,
          sortOrder: r.sortOrder,
          issuedCount: counts[r.id] ?? 0,
        ),
    ];
  }

  /// Saves an edit. The id is the identity, so this is an upsert.
  Future<void> save(TaskTemplate template, {bool isActive = true}) =>
      db.into(db.taskTemplates).insertOnConflictUpdate(
        TaskTemplatesCompanion.insert(
          id: template.id,
          title: template.title,
          category: template.category,
          stat: template.stat,
          schedule: template.schedule,
          daysOfWeek: Value(template.daysOfWeek),
          xp: template.xp,
          scheduledMinutes: Value(template.scheduledMinutes),
          graceMinutes: Value(template.graceMinutes),
          isActive: Value(isActive),
          createdAt: DateTime.now(),
        ),
      );

  Future<void> setActive(String id, bool active) =>
      (db.update(db.taskTemplates)..where((t) => t.id.equals(id))).write(
        TaskTemplatesCompanion(isActive: Value(active)),
      );

  /// Removes a step entirely — only ever allowed when nothing was issued
  /// from it. Anything with history is archived instead, so the record of
  /// what you actually did stays intact and readable.
  Future<bool> delete(String id) async {
    final issued = await (db.select(db.dailyQuests)
          ..where((q) => q.templateId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (issued != null) {
      await setActive(id, false);
      return false;
    }
    await (db.delete(db.taskTemplates)..where((t) => t.id.equals(id))).go();
    return true;
  }

  /// A stable id from a title, so a hand-added step reads sensibly in the
  /// database and in an export.
  static String idFor(String title) {
    final slug = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    return slug.isEmpty ? 'step_${DateTime.now().millisecondsSinceEpoch}' : slug;
  }

  TaskTemplate _toTemplate(TaskTemplateRow r) => TaskTemplate(
    id: r.id,
    title: r.title,
    category: r.category,
    stat: r.stat,
    schedule: r.schedule,
    daysOfWeek: r.daysOfWeek,
    xp: r.xp,
    scheduledMinutes: r.scheduledMinutes,
    graceMinutes: r.graceMinutes,
  );
}
