import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';

/// Time window for the STATUS screen's tabs.
enum StatScope {
  allTime('ALL TIME'),
  month('MONTH'),
  week('WEEK'),
  today('TODAY');

  final String label;

  const StatScope(this.label);

  /// Earliest day number included, or null for "everything".
  int? get firstDay => switch (this) {
    StatScope.allTime => null,
    StatScope.month => todayKey() - 29,
    StatScope.week => todayKey() - 6,
    StatScope.today => todayKey(),
  };
}

/// Totals over one [StatScope], aggregated from the day rollups.
class ScopedStats {
  final int xpEarned;
  final int xpAvailable;
  final int questsCleared;

  /// Steps that ended the window unanswered or were answered as missed.
  ///
  /// Worth reporting separately only since Phase 6: before the routine, "not
  /// cleared" and "missed" were the same thing, and a day that was simply
  /// never opened looked identical to one that was failed.
  final int questsMissed;

  final int questsIssued;
  final int perfectDays;
  final int daysRecorded;
  final Map<StatType, int> statXp;

  const ScopedStats({
    required this.xpEarned,
    required this.xpAvailable,
    required this.questsCleared,
    required this.questsMissed,
    required this.questsIssued,
    required this.perfectDays,
    required this.daysRecorded,
    required this.statXp,
  });

  static const ScopedStats empty = ScopedStats(
    xpEarned: 0,
    xpAvailable: 0,
    questsCleared: 0,
    questsMissed: 0,
    questsIssued: 0,
    perfectDays: 0,
    daysRecorded: 0,
    statXp: {},
  );

  /// Share of scheduled quests actually cleared, 0..1.
  double get completionRate =>
      questsIssued <= 0 ? 0 : questsCleared / questsIssued;
}

/// The player's progression, as the UI sees it.
///
/// Level, rank and per-stat levels are all COMPUTED here from stored XP rather
/// than read from columns. That's the rule from ARCHITECTURE.md §5: storing a
/// level lets it disagree with the XP that produced it, and then you're
/// debugging which one is lying.
class PlayerSnapshot {
  final String hunterName;
  final int totalXp;
  final Map<StatType, int> statXp;
  final int currentStreak;
  final int longestStreak;
  final int perfectDays;

  /// The last level the player has actually been shown a celebration for.
  /// When it trails [level] there's an unseen level-up — Phase 6 will use this
  /// to fire the modal exactly once.
  final int acknowledgedLevel;

  const PlayerSnapshot({
    required this.hunterName,
    required this.totalXp,
    required this.statXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.perfectDays,
    required this.acknowledgedLevel,
  });

  LevelProgress get progress => GameRules.hunter.progressFor(totalXp);

  int get level => progress.level;

  Rank get rank => Rank.forLevel(level);

  /// Level reached in one stat, on the cheaper stat curve.
  LevelProgress statProgress(StatType stat) =>
      GameRules.stat.progressFor(statXp[stat] ?? 0);

  /// True when the player has levelled up without seeing the celebration yet.
  bool get hasUnseenLevelUp => level > acknowledgedLevel;
}

/// Read access to the single player-state row.
class PlayerRepository {
  final AppDatabase db;

  PlayerRepository(this.db);

  /// Streams the player row, re-emitting whenever totals change.
  Stream<PlayerSnapshot> watch() =>
      (db.select(db.playerStates)..where((p) => p.id.equals(0)))
          .watchSingle()
          .map(_toSnapshot);

  Future<PlayerSnapshot> read() async =>
      _toSnapshot(await (db.select(db.playerStates)
            ..where((p) => p.id.equals(0)))
          .getSingle());

  /// Streams aggregated totals for one time window.
  ///
  /// Aggregating in Dart over the rollup rows rather than in SQL: there is one
  /// row per day, so even "all time" is a few hundred rows, and keeping the
  /// arithmetic in one readable loop beats a SUM() query per column.
  Stream<ScopedStats> watchScopedStats(StatScope scope) {
    final query = db.select(db.dayRollups);
    final firstDay = scope.firstDay;
    if (firstDay != null) {
      query.where((r) => r.day.isBiggerOrEqualValue(firstDay));
    }

    return query.watch().map((rollups) {
      int xpEarned = 0,
          xpAvailable = 0,
          cleared = 0,
          missed = 0,
          issued = 0,
          perfect = 0;
      int str = 0, sta = 0, dis = 0, rec = 0;

      for (final r in rollups) {
        xpEarned += r.xpEarned;
        xpAvailable += r.xpAvailable;
        cleared += r.questsCleared;
        missed += r.questsMissed;
        issued += r.questsTotal;
        if (r.isPerfect) perfect++;
        str += r.strXp;
        sta += r.staXp;
        dis += r.disXp;
        rec += r.recXp;
      }

      return ScopedStats(
        xpEarned: xpEarned,
        xpAvailable: xpAvailable,
        questsCleared: cleared,
        questsMissed: missed,
        questsIssued: issued,
        perfectDays: perfect,
        daysRecorded: rollups.length,
        statXp: {
          StatType.str: str,
          StatType.sta: sta,
          StatType.dis: dis,
          StatType.rec: rec,
        },
      );
    });
  }

  Future<void> setHunterName(String name) async {
    await (db.update(db.playerStates)..where((p) => p.id.equals(0))).write(
      PlayerStatesCompanion(hunterName: Value(name)),
    );
  }

  /// Marks the player's current level as seen, so its celebration doesn't
  /// replay on the next launch. Called by the level-up modal in Phase 6.
  Future<void> acknowledgeCurrentLevel() async {
    final snapshot = await read();
    await (db.update(db.playerStates)..where((p) => p.id.equals(0))).write(
      PlayerStatesCompanion(
        acknowledgedLevel: Value(snapshot.level),
        acknowledgedRank: Value(snapshot.rank.label),
      ),
    );
  }

  PlayerSnapshot _toSnapshot(PlayerStateRow r) => PlayerSnapshot(
    hunterName: r.hunterName,
    totalXp: r.totalXp,
    statXp: {
      StatType.str: r.strXp,
      StatType.sta: r.staXp,
      StatType.dis: r.disXp,
      StatType.rec: r.recXp,
    },
    currentStreak: r.currentStreak,
    longestStreak: r.longestStreak,
    perfectDays: r.perfectDays,
    acknowledgedLevel: r.acknowledgedLevel,
  );
}
