import 'package:drift/drift.dart';

import '../../ai/ai_result.dart';
import '../../ai/lanes/review_lane.dart';
import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import '../memory/memory_repository.dart';
import 'progress_repository.dart';

/// A week, as the app holds it.
class WeekReview {
  final DateTime weekEnding;
  final String summary;
  final String kept;
  final String change;

  /// 'model' or 'figures'. Shown, because they deserve different trust.
  final String source;

  final DateTime generatedAt;

  const WeekReview({
    required this.weekEnding,
    required this.summary,
    required this.kept,
    required this.change,
    required this.source,
    required this.generatedAt,
  });

  bool get fromModel => source == 'model';
}

/// The Sunday review: one call a week, looking backwards.
///
/// HOW "AUTOMATIC" ACTUALLY WORKS, because the honest answer matters here.
/// A notification cannot run Dart in this app — there is no background isolate
/// and adding a foreground service for one call a week would cost a permanent
/// notification in your tray. So the ALERT is scheduled for Sunday evening and
/// the review is generated the first time the app is opened at or after it.
/// In practice you tap the notification and it is there; if you ignore it
/// until Monday, Monday's opening writes it and it is still Sunday's review.
///
/// Written ONCE per week and kept, keyed by the Sunday it covers. Re-opening
/// does not spend another call.
///
/// The FIGURES are computed here and handed to the model already worked out.
/// It is asked to describe them, never to calculate them — the same rule that
/// keeps the nutrition totals in Dart.
class ReviewRepository {
  final AppDatabase db;
  final ProgressRepository progress;
  final MemoryRepository memory;
  final Clock clock;

  /// Null without a key. The review still gets written from the figures alone,
  /// which is the floor and always available.
  final ReviewLane? lane;

  /// Minutes after midnight on Sunday when the review is due.
  final int dueMinutes;

  ReviewRepository({
    required this.db,
    required this.progress,
    required this.memory,
    this.lane,
    this.clock = const Clock(),
    this.dueMinutes = 20 * 60,
  });

  /// The Sunday that closes the week [date] falls in.
  ///
  /// DateTime.sunday is 7, so the offset is simply what is left of the week.
  static DateTime weekEndingFor(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return day.add(Duration(days: DateTime.sunday - day.weekday));
  }

  /// The review for the week [date] falls in, or null if not yet written.
  Future<WeekReview?> read(DateTime date) async {
    final row = await (db.select(db.weeklyReviews)
          ..where((r) => r.weekEndDay.equals(dayKeyOf(weekEndingFor(date)))))
        .getSingleOrNull();
    return row == null ? null : _toView(row);
  }

  Future<List<WeekReview>> readAll() async => [
    for (final r
        in await (db.select(db.weeklyReviews)
              ..orderBy([(r) => OrderingTerm.desc(r.weekEndDay)]))
            .get())
      _toView(r),
  ];

  /// True when this week's review is due and has not been written.
  ///
  /// Due means Sunday has arrived AND the hour has passed — a review written
  /// at nine on Sunday morning would be describing a week that still has a
  /// long run left in it.
  Future<bool> isDue(DateTime date) async {
    final now = clock.now();
    final ending = weekEndingFor(date);
    final dueAt = ending.add(Duration(minutes: dueMinutes));
    if (now.isBefore(dueAt)) return false;
    return await read(date) == null;
  }

  /// Writes this week's review if it is due. Safe to call on every launch.
  Future<WeekReview?> generateIfDue(DateTime date) async {
    if (!await isDue(date)) return null;
    return generate(date);
  }

  /// Writes the review, whether due or not. Used by the manual control.
  Future<WeekReview> generate(DateTime date) async {
    final ending = weekEndingFor(date);
    final figures = await _figuresFor(ending);

    var summary = _plainSummary(figures);
    var kept = figures.bestDay;
    var change = figures.weakest;
    var source = 'figures';

    final advisor = lane;
    if (advisor != null) {
      // Recall is scoped to the week's own material rather than the whole
      // corpus, or a review of this week quotes a session from March.
      List<String> passages;
      try {
        final hits = await memory.recall(
          'training nutrition sleep this week',
          limit: 6,
          kinds: {
            MemoryKind.workoutSession,
            MemoryKind.dailyLog,
            MemoryKind.healthSync,
          },
        );
        passages = [for (final hit in hits) '${hit.kind.label}: ${hit.passage}'];
      } catch (_) {
        passages = const [];
      }

      final result = await advisor.review(
        figures: figures.lines,
        recalled: passages,
      );
      if (result case AiOk(:final value)) {
        summary = value.summary;
        kept = value.kept;
        change = value.change;
        source = 'model';
      }
      // Anything else — no key, offline, over budget, bad shape — keeps the
      // figures version rather than showing nothing.
    }

    await db.into(db.weeklyReviews).insertOnConflictUpdate(
      WeeklyReviewsCompanion.insert(
        weekEndDay: Value(dayKeyOf(ending)),
        summary: summary,
        kept: kept,
        change: change,
        source: Value(source),
        generatedAt: clock.now(),
      ),
    );

    return (await read(date))!;
  }

  Future<_WeekFigures> _figuresFor(DateTime ending) async {
    final view = await progress.read(ChartRange.week);
    final start = ending.subtract(const Duration(days: 6));
    final days = [
      for (final d in view.days)
        if (!d.date.isBefore(start) && !d.date.isAfter(ending)) d,
    ];

    final cleared = days.fold(0, (s, d) => s + d.questsCleared);
    final missed = days.fold(0, (s, d) => s + d.questsMissed);
    final xp = days.fold(0, (s, d) => s + d.xpEarned);
    final perfect = days.where((d) => d.isPerfect).length;

    final health = [
      for (final h in view.health)
        if (!h.date.isBefore(start) && !h.date.isAfter(ending)) h,
    ];
    final stepDays = health.where((h) => h.steps != null).toList();
    final steps = stepDays.fold(0, (s, h) => s + (h.steps ?? 0));

    return _WeekFigures(
      lines: [
        'Days recorded: ${days.length} of 7',
        'Quests cleared: $cleared',
        'Quests missed: $missed',
        'Perfect days: $perfect',
        'XP earned: $xp',
        if (stepDays.isNotEmpty)
          'Steps: $steps over ${stepDays.length} days '
              '(${steps ~/ stepDays.length} a day)',
      ],
      daysRecorded: days.length,
      cleared: cleared,
      missed: missed,
      perfect: perfect,
      bestDay: perfect > 0
          ? '$perfect perfect ${perfect == 1 ? 'day' : 'days'}'
          : cleared > 0
          ? '$cleared quests cleared'
          : 'turning up at all',
      weakest: missed > cleared
          ? 'more steps were missed than cleared — start with the first one of '
                'the day'
          : days.length < 5
          ? 'the app was only opened on ${days.length} days'
          : 'hold the streak',
    );
  }

  String _plainSummary(_WeekFigures f) {
    if (f.daysRecorded == 0) {
      return 'Nothing was recorded this week. The week is not a failure '
          'because it is empty — it is empty because nothing was logged.';
    }
    return 'You recorded ${f.daysRecorded} of 7 days, cleared ${f.cleared} '
        'quests and missed ${f.missed}. '
        '${f.perfect} perfect ${f.perfect == 1 ? 'day' : 'days'}.';
  }

  WeekReview _toView(WeeklyReviewRow r) => WeekReview(
    weekEnding: dateOfDayKey(r.weekEndDay),
    summary: r.summary,
    kept: r.kept,
    change: r.change,
    source: r.source,
    generatedAt: r.generatedAt,
  );
}

class _WeekFigures {
  final List<String> lines;
  final int daysRecorded;
  final int cleared;
  final int missed;
  final int perfect;
  final String bestDay;
  final String weakest;

  const _WeekFigures({
    required this.lines,
    required this.daysRecorded,
    required this.cleared,
    required this.missed,
    required this.perfect,
    required this.bestDay,
    required this.weakest,
  });
}
