import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../daily_generator.dart';
import '../day_key.dart';
import '../db/database.dart';

/// The only thing the UI is allowed to talk to for quest data.
///
/// Screens never see Drift types or SQL — they get plain [DailyTask] /
/// [TaskTemplate] objects. That's what makes it possible to change the storage
/// layer later without touching a single widget.
class QuestRepository {
  final AppDatabase db;

  /// Every "what time is it" question goes through here rather than
  /// `DateTime.now()`, so tests can put the routine at any hour of the day.
  final Clock clock;

  QuestRepository(this.db, {this.clock = const Clock()});

  /// Streams the quests for [date], re-emitting automatically on every write.
  ///
  /// Drift's `.watch()` returns a Stream that fires whenever a row the query
  /// touches changes. That's why [DailyTask] is immutable and the screen no
  /// longer tracks completion in setState — the database pushes the new list.
  /// The day's steps, read once.
  ///
  /// Not `watchDay(date).first`. A stream's first value arrives on drift's own
  /// scheduling, which under flutter_test's fake clock does not arrive at all
  /// unless something pumps it — a caller that just wants today's list hangs
  /// forever instead of failing. A one-shot read is also simply the honest
  /// query for a one-shot question.
  Future<List<DailyTask>> readDay(DateTime date) =>
      _dayQuery(date).get().then(_toTasks);

  Stream<List<DailyTask>> watchDay(DateTime date) =>
      _dayQuery(date).watch().map(_toTasks);

  List<DailyTask> _toTasks(List<TypedResult> rows) => [
    for (final row in rows)
      _toDailyTask(
        row.readTable(db.dailyQuests),
        row.readTable(db.taskTemplates),
      ),
  ];

  JoinedSelectStatement<HasResultSet, dynamic> _dayQuery(DateTime date) {
    final key = dayKeyOf(date);

    final query = db.select(db.dailyQuests).join([
      innerJoin(
        db.taskTemplates,
        db.taskTemplates.id.equalsExp(db.dailyQuests.templateId),
      ),
    ])..where(db.dailyQuests.day.equals(key));

    // Routine order: earliest scheduled step first, ties broken by the
    // catalog's own order. Unscheduled ("anytime") steps coalesce to the end
    // of the day so they never gate anything that has a real time.
    query.orderBy([
      OrderingTerm.asc(
        coalesce([
          db.dailyQuests.scheduledMinutes,
          const Constant(minutesInDay),
        ]),
      ),
      OrderingTerm.asc(db.taskTemplates.sortOrder),
    ]);

    return query;
  }

  /// Brings the database up to date and opens today.
  ///
  /// Call this once on startup instead of [materialiseDay]. As well as
  /// creating today's quests it reconstructs any days the app wasn't opened
  /// on and closes out their lapsed steps, so a gap in the streak is an
  /// explicit run of missed days rather than simply absent data that the
  /// streak logic would silently skip over.
  Future<void> openToday() async {
    final now = clock.now();
    final today = dayKeyOf(now);
    final player = await _playerRow();
    final lastActive = player.lastActiveDay;

    if (lastActive != null && lastActive < today) {
      // Bounded so a wrong device clock can't trigger a huge backfill.
      final firstMissed = lastActive + 1;
      final floor = today - GameRules.maxBackfillDays;
      for (
        var day = firstMissed > floor ? firstMissed : floor;
        day < today;
        day++
      ) {
        await materialiseDay(dateOfDayKey(day));
        await closeLapsedSteps(day);
      }
    }

    await materialiseDay(now);
    await closeLapsedSteps(today);
    await _recomputeProgression();
  }

  /// Creates the `daily_quests` rows for [date] if they don't exist yet.
  ///
  /// Days are materialised LAZILY — the first time a day is opened — and the
  /// future is never pre-generated, because pre-generating would freeze
  /// today's plan into tomorrow and defeat an editable catalog.
  Future<void> materialiseDay(DateTime date) async {
    final key = dayKeyOf(date);

    await db.transaction(() async {
      final existing =
          await (db.select(db.dailyQuests)..where((q) => q.day.equals(key)))
              .get();
      final existingIds = existing.map((q) => q.templateId).toSet();

      final templates = await _activeTemplateRows();
      final due = templatesScheduledOn(
        templates.map(_toTemplate).toList(),
        date,
      );

      final missing = due.where((t) => !existingIds.contains(t.id)).toList();
      if (missing.isEmpty) return;

      await db.batch((b) {
        b.insertAll(db.dailyQuests, [
          for (final t in missing)
            DailyQuestsCompanion.insert(
              templateId: t.id,
              day: key,
              // Snapshots: the terms this quest is judged on, frozen now.
              xpAwarded: t.xp,
              stat: t.stat,
              scheduledMinutes: Value(t.scheduledMinutes),
              graceMinutes: Value(t.graceMinutes),
            ),
        ]);
      });

      await _recomputeRollup(key);
    });
  }

  /// Answers a step: done, missed, or back to pending.
  ///
  /// Wrapped in a transaction so the quest row, the day's rollup and the
  /// player's running totals can never end up disagreeing with each other.
  Future<void> setStatus(DailyTask task, QuestStatus status) async {
    await db.transaction(() async {
      // Compared against the DATABASE, not against `task.status`. The caller
      // holds an immutable snapshot that may already be out of date — a screen
      // reusing the object it was handed a moment ago would otherwise look
      // like a no-op and silently drop the write.
      final current =
          await (db.select(db.dailyQuests)..where((q) => q.id.equals(task.id)))
              .getSingle();
      if (current.status == status) return;

      await (db.update(db.dailyQuests)..where((q) => q.id.equals(task.id)))
          .write(
            DailyQuestsCompanion(
              status: Value(status),
              completedAt: Value(
                status == QuestStatus.done ? clock.now() : null,
              ),
            ),
          );

      await _recomputeRollup(dayKeyOf(task.date));
      await _recomputeProgression();
      await _logAnswer(task, from: current.status, to: status);
    });
  }

  /// Convenience for "tick / untick", kept so callers that only care about
  /// completion don't have to think in three states.
  Future<void> setDone(DailyTask task, bool done) =>
      setStatus(task, done ? QuestStatus.done : QuestStatus.pending);

  /// Marks the quest for [templateId] on [date] as done, if it was issued.
  ///
  /// Exists so finishing a training session can clear the routine's workout
  /// step: the two are the same commitment recorded in two places, and making
  /// you tick it twice would be the app not paying attention.
  Future<void> completeTemplate(String templateId, DateTime date) async {
    final key = dayKeyOf(date);

    // A one-shot JOIN, not `watchDay(date).first`. Awaiting a watched stream's
    // first event is not guaranteed to complete promptly — it hung outright
    // under flutter_test's fake clock — and this call is the one that awards
    // the XP for finishing a training session. It must not be able to stall.
    final row = await (db.select(db.dailyQuests).join([
      innerJoin(
        db.taskTemplates,
        db.taskTemplates.id.equalsExp(db.dailyQuests.templateId),
      ),
    ])..where(
          db.dailyQuests.day.equals(key) &
              db.dailyQuests.templateId.equals(templateId),
        ))
        .getSingleOrNull();
    if (row == null) return;

    await setStatus(
      _toDailyTask(
        row.readTable(db.dailyQuests),
        row.readTable(db.taskTemplates),
      ),
      QuestStatus.done,
    );
  }

  /// Closes out every step of [day] left unanswered past its window.
  ///
  /// This is what makes the day finish itself even if the app is never opened:
  /// the routine's promise is that a step is either done or missed, and
  /// "nobody looked" cannot be a third outcome. Returns how many were closed,
  /// so callers can skip the recompute when nothing changed.
  Future<int> closeLapsedSteps(int day) async {
    final now = clock.now();
    final cursor = dayCursor(
      dayKey: day,
      todayKey: dayKeyOf(now),
      now: now,
    );

    final pending =
        await (db.select(db.dailyQuests)..where(
              (q) =>
                  q.day.equals(day) &
                  q.status.equalsValue(QuestStatus.pending),
            ))
            .get();

    final lapsed = pending
        .where(
          (q) => hasLapsed(
            scheduledMinutes: q.scheduledMinutes,
            graceMinutes: q.graceMinutes,
            cursor: cursor,
          ),
        )
        .toList();

    if (lapsed.isEmpty) return 0;

    // Titles for the log entries, fetched once rather than per row.
    final titles = {
      for (final t in await db.select(db.taskTemplates).get()) t.id: t.title,
    };

    await db.transaction(() async {
      await (db.update(
        db.dailyQuests,
      )..where((q) => q.id.isIn(lapsed.map((e) => e.id)))).write(
        const DailyQuestsCompanion(status: Value(QuestStatus.missed)),
      );

      for (final quest in lapsed) {
        await _log(
          ActivityKind.questMissed,
          titles[quest.templateId] ?? quest.templateId,
          detail: 'Window closed unanswered',
        );
      }

      await _recomputeRollup(day);
      await _recomputeProgression();
    });

    return lapsed.length;
  }

  /// Rebuilds every cached total from `daily_quests` alone.
  ///
  /// The rollup and player tables are caches. Being able to regenerate them
  /// from scratch means a bug in the incremental maths is always recoverable
  /// rather than permanently corrupting history.
  Future<void> recomputeAll() async {
    await db.transaction(() async {
      final days = await db
          .customSelect(
            'SELECT DISTINCT day FROM daily_quests',
            readsFrom: {db.dailyQuests},
          )
          .get();

      for (final row in days) {
        await _recomputeRollup(row.read<int>('day'));
      }
      await _recomputeProgression();
    });
  }

  // --- internals ----------------------------------------------------------

  Future<List<TaskTemplateRow>> _activeTemplateRows() =>
      (db.select(db.taskTemplates)
            ..where((t) => t.isActive.equals(true) & t.archivedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  /// Recomputes one day's rollup row from its quests.
  Future<void> _recomputeRollup(int day) async {
    final quests =
        await (db.select(db.dailyQuests)..where((q) => q.day.equals(day))).get();

    int earned = 0, available = 0, cleared = 0, missed = 0;
    final perStat = {for (final s in StatType.values) s: 0};

    for (final q in quests) {
      available += q.xpAwarded;
      switch (q.status) {
        case QuestStatus.done:
          earned += q.xpAwarded;
          cleared++;
          perStat[q.stat] = perStat[q.stat]! + q.xpAwarded;
        case QuestStatus.missed:
          missed++;
        case QuestStatus.pending:
          break;
      }
    }

    await db
        .into(db.dayRollups)
        .insertOnConflictUpdate(
          DayRollupRow(
            day: day,
            bonusXp: await _bonusXpFor(day),
            xpEarned: earned,
            xpAvailable: available,
            questsCleared: cleared,
            questsMissed: missed,
            questsTotal: quests.length,
            isPerfect: quests.isNotEmpty && cleared == quests.length,
            strXp: perStat[StatType.str]!,
            staXp: perStat[StatType.sta]!,
            disXp: perStat[StatType.dis]!,
            recXp: perStat[StatType.rec]!,
          ),
        );
  }

  /// XP for training beyond the prescription on [day].
  ///
  /// Read from workout_sets rather than stored anywhere, so it stays derivable
  /// the same way every other total is. The rollup is now derivable from
  /// daily_quests AND workout_sets — still fully re-computable from rows that
  /// record what actually happened.
  Future<int> _bonusXpFor(int day) async {
    final rows = await (db.select(db.workoutSets).join([
      innerJoin(
        db.workoutSessions,
        db.workoutSessions.id.equalsExp(db.workoutSets.sessionId),
      ),
    ])..where(
          db.workoutSessions.day.equals(day) &
              db.workoutSets.isExtra.equals(true) &
              db.workoutSets.done.equals(true),
        ))
        .get();

    return rows.length * GameRules.xpPerExtraSet;
  }

  Future<PlayerStateRow> _playerRow() =>
      (db.select(db.playerStates)..where((p) => p.id.equals(0))).getSingle();

  /// Recomputes every progression value from the day rollups, and records the
  /// milestones crossed along the way.
  ///
  /// A full re-derivation rather than incremental arithmetic: for a single
  /// user this is a few hundred rows, and it means the totals can never drift
  /// out of sync with the quests that produced them.
  ///
  /// Levels and ranks are NOT written anywhere — they're pure functions of
  /// totalXp (see GameRules). Only the crossing of a threshold is recorded,
  /// as an activity-log entry.
  Future<void> _recomputeProgression() async {
    final before = await _playerRow();
    final rollups = await db.select(db.dayRollups).get();
    final today = dayKeyOf(clock.now());

    int total = 0, str = 0, sta = 0, dis = 0, rec = 0, perfectDays = 0;
    int questsCleared = 0;
    final qualifyingDays = <int>{};

    for (final r in rollups) {
      // Bonus counts toward the lifetime total but NOT toward the streak bar
      // below, which is measured on quest XP alone. Ten extra minutes of
      // walking should not paper over a day of missed quests.
      total += r.xpEarned + r.bonusXp;
      questsCleared += r.questsCleared;
      str += r.strXp;
      sta += r.staXp;
      dis += r.disXp;
      rec += r.recXp;
      if (r.isPerfect) perfectDays++;
      if (GameRules.dayQualifiesForStreak(
        xpEarned: r.xpEarned,
        xpAvailable: r.xpAvailable,
      )) {
        qualifyingDays.add(r.day);
      }
    }

    final streaks = computeStreaks(
      qualifyingDays: qualifyingDays,
      today: today,
    );

    await (db.update(db.playerStates)..where((p) => p.id.equals(0))).write(
      PlayerStatesCompanion(
        totalXp: Value(total),
        strXp: Value(str),
        staXp: Value(sta),
        disXp: Value(dis),
        recXp: Value(rec),
        currentStreak: Value(streaks.current),
        longestStreak: Value(streaks.longest),
        perfectDays: Value(perfectDays),
        questsCleared: Value(questsCleared),
        lastActiveDay: Value(today),
      ),
    );

    final after = AchievementMetrics(
      longestStreak: streaks.longest,
      perfectDays: perfectDays,
      questsCleared: questsCleared,
      totalXp: total,
      statXp: {
        StatType.str: str,
        StatType.sta: sta,
        StatType.dis: dis,
        StatType.rec: rec,
      },
    );

    await _logMilestones(before: before, newTotalXp: total, streaks: streaks);
    await _logAchievements(before: metricsOf(before), after: after);
  }

  /// One activity-log entry per answered step.
  Future<void> _logAnswer(
    DailyTask task, {
    required QuestStatus from,
    required QuestStatus to,
  }) async {
    switch (to) {
      case QuestStatus.done:
        await _log(
          ActivityKind.questCleared,
          task.template.title,
          xpDelta: task.xpAwarded,
        );
      case QuestStatus.missed:
        // No xpDelta: a miss costs no XP by design. The penalty is the broken
        // streak and the failed day, not rewritten history.
        await _log(
          ActivityKind.questMissed,
          task.template.title,
          detail: 'Marked missed',
        );
      case QuestStatus.pending:
        await _log(
          ActivityKind.questUncleared,
          task.template.title,
          detail: 'Reopened',
          xpDelta: from == QuestStatus.done ? -task.xpAwarded : null,
        );
    }
  }

  /// Writes activity-log entries for any threshold crossed by this update.
  ///
  /// Comparing the level implied by the OLD total against the new one means a
  /// plain recompute (where the total doesn't move) logs nothing, so
  /// [recomputeAll] can't spam the feed with phantom level-ups.
  Future<void> _logMilestones({
    required PlayerStateRow before,
    required int newTotalXp,
    required StreakSummary streaks,
  }) async {
    final previousLevel = GameRules.hunter.levelForXp(before.totalXp);
    final newLevel = GameRules.hunter.levelForXp(newTotalXp);

    if (newLevel > previousLevel) {
      await _log(
        ActivityKind.levelUp,
        'LEVEL $newLevel',
        detail: 'Reached level $newLevel',
      );

      final previousRank = Rank.forLevel(previousLevel);
      final newRank = Rank.forLevel(newLevel);
      if (newRank != previousRank) {
        await _log(
          ActivityKind.rankUp,
          'RANK ${newRank.label}',
          detail: 'Promoted from ${previousRank.label} to ${newRank.label} rank',
        );
      }
    }

    if (before.currentStreak > 0 && streaks.current == 0) {
      await _log(
        ActivityKind.streakBroken,
        'Streak broken',
        detail: 'A ${before.currentStreak} day streak ended',
      );
    }
  }

  /// Reads the achievement metrics off a stored player row.
  ///
  /// Public so tests can assert a medal's standing straight from the database
  /// without going through the UI.
  static AchievementMetrics metricsOf(PlayerStateRow row) => AchievementMetrics(
    longestStreak: row.longestStreak,
    perfectDays: row.perfectDays,
    questsCleared: row.questsCleared,
    totalXp: row.totalXp,
    statXp: {
      StatType.str: row.strXp,
      StatType.sta: row.staXp,
      StatType.dis: row.disXp,
      StatType.rec: row.recXp,
    },
  );

  /// One log entry per tier newly reached.
  Future<void> _logAchievements({
    required AchievementMetrics before,
    required AchievementMetrics after,
  }) async {
    for (final award in newlyEarned(before: before, after: after)) {
      await _log(
        ActivityKind.achievementUnlocked,
        '${award.id.label} · ${award.tier.label}',
        detail: '${award.id.description} — ${award.id.thresholds[award.tier.index]} ${award.id.unit}',
      );
    }
  }

  Future<void> _log(
    ActivityKind kind,
    String title, {
    String? detail,
    int? xpDelta,
  }) =>
      db
          .into(db.activityLogEntries)
          .insert(
            ActivityLogEntriesCompanion.insert(
              at: clock.now(),
              kind: kind,
              title: title,
              detail: Value(detail),
              xpDelta: Value(xpDelta),
            ),
          );

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

  DailyTask _toDailyTask(DailyQuestRow q, TaskTemplateRow t) => DailyTask(
    id: q.id,
    template: _toTemplate(t),
    date: dateOfDayKey(q.day),
    status: q.status,
    completedAt: q.completedAt,
    xpAwarded: q.xpAwarded,
    stat: q.stat,
    scheduledMinutes: q.scheduledMinutes,
    graceMinutes: q.graceMinutes,
  );
}
