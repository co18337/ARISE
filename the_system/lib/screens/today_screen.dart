import 'dart:async';

import 'package:flutter/material.dart';

import '../data/day_key.dart';
import '../data/repositories/quest_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/routine_step_tile.dart';
import '../widgets/stat_bar.dart';
import '../widgets/hud_route.dart';
import '../widgets/system_panel.dart';
import 'daily_report_overlay.dart';

/// The DAILY QUESTS screen — the day as a guided routine.
///
/// Not a checklist. The day is time-ordered and arrives one step at a time:
/// **time gates a step, answering it advances the day.** Everything else on
/// screen is context — what's already answered above, what's still coming
/// below — and exactly one step at a time can actually be acted on.
///
/// Content only: AppShell supplies the backdrop, the RankHeader and the
/// counter bar, so nothing here repeats the Hunter's name, rank or level.
class TodayScreen extends StatefulWidget {
  final QuestRepository questRepository;

  /// Opens the weekly report — used by the claim button once the day is done.
  final VoidCallback? onOpenReport;

  /// Opens the full training session. The routine's workout step is one tick;
  /// the session behind it is the actual exercises.
  final VoidCallback? onOpenTraining;

  const TodayScreen({
    super.key,
    required this.questRepository,
    this.onOpenReport,
    this.onOpenTraining,
  });

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

// WidgetsBindingObserver lets the screen notice when the app returns to the
// foreground, which is how the day rollover below is detected.
class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  /// Startup work and the live stream are separate concerns: the future covers
  /// the one-off "open today" (which also backfills missed days), the stream
  /// covers everything after.
  ///
  /// Both live in FIELDS, never created inside build(). Building a new stream
  /// on each build makes StreamBuilder re-subscribe, which emits, which
  /// rebuilds, which builds another stream — an infinite loop that never
  /// settles.
  late DateTime _today;
  late Future<void> _ready;
  late Stream<List<DailyTask>> _questStream;

  /// Re-evaluates the routine as the clock moves. The engine is pure, so the
  /// only thing that makes the screen go stale is time passing — nothing in
  /// the database changes when a window shuts.
  Timer? _ticker;

  /// The last XP award, and a counter that changes on every award so the
  /// floating "+XP" replays even when the same amount is earned twice.
  int? _rewardXp;
  int _rewardSeq = 0;

  Clock get _clock => widget.questRepository.clock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openDay();
    // Half a minute is fine: the smallest thing this drives is a step opening
    // or closing, and neither is worth a per-second rebuild of the list.
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => _onTick());
  }

  @override
  void dispose() {
    // A periodic Timer outlives its widget unless cancelled, and then calls
    // setState on a dead State.
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _openDay() {
    _today = _clock.now();
    _ready = widget.questRepository.openToday();
    _questStream = widget.questRepository.watchDay(_today);
  }

  /// Every 30s: close out anything whose window has just shut, then rebuild so
  /// the next step becomes active.
  Future<void> _onTick() async {
    if (!mounted) return;
    await widget.questRepository.closeLapsedSteps(dayKeyOf(_today));
    if (mounted) setState(() {});
  }

  /// Reissues the day when the app is resumed after midnight.
  ///
  /// Without this, an app left open overnight — the normal case on Android,
  /// where the process is rarely killed — keeps showing yesterday's quests and
  /// writes completions onto the wrong date.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (dayKeyOf(_clock.now()) == dayKeyOf(_today)) return;
    setState(_openDay);
  }

  /// Fired by the countdown hitting zero while the app is open and in view.
  void _onRefreshDue() {
    if (!mounted) return;
    if (dayKeyOf(_clock.now()) == dayKeyOf(_today)) return;
    setState(_openDay);
  }

  Future<void> _answer(DailyTask task, QuestStatus status) async {
    await widget.questRepository.setStatus(task, status);
    if (!mounted) return;
    setState(() {
      _rewardXp = status == QuestStatus.done ? task.xpAwarded : null;
      _rewardSeq++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        // AnimatedSwitcher crossfades between states instead of swapping them
        // in one frame; the keys tell it the child actually changed.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          child: switch (snapshot) {
            AsyncSnapshot(hasError: true, :final error) => _Notice(
              'SYSTEM ERROR\n$error',
              key: const ValueKey('error'),
            ),
            AsyncSnapshot(connectionState: != ConnectionState.done) =>
              const _Notice('ISSUING QUESTS…', key: ValueKey('loading')),
            _ => KeyedSubtree(
              key: const ValueKey('ready'),
              child: _buildRoutine(),
            ),
          },
        );
      },
    );
  }

  Widget _buildRoutine() {
    return StreamBuilder<List<DailyTask>>(
      stream: _questStream,
      builder: (context, snapshot) {
        final tasks = snapshot.data;
        if (tasks == null) return const _Notice('LOADING…');

        final now = _clock.now();
        final cursor = dayCursor(
          dayKey: dayKeyOf(_today),
          todayKey: dayKeyOf(now),
          now: now,
        );
        final routine = buildRoutine(steps: tasks, cursor: cursor);

        final cleared = tasks.where((t) => t.done).length;
        final missed = tasks.where((t) => t.missed).length;
        final pending = tasks.length - cleared - missed;
        final xpEarned = tasks
            .where((t) => t.done)
            .fold(0, (sum, t) => sum + t.xpAwarded);
        final xpAvailable = tasks.fold(0, (sum, t) => sum + t.xpAwarded);
        final dayAnswered = tasks.isNotEmpty && pending == 0;

        // Stack so the "+XP" can float over the list rather than shoving it.
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              // Bouncing physics carries momentum at the edges, which reads as
              // a smoother surface than Android's abrupt clamped stop.
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                const HudSectionTitle('DAILY QUESTS'),
                const SizedBox(height: 12),
                Center(
                  child: CountdownTimer(
                    target: nextMidnight(),
                    label: 'REFRESH IN',
                    onElapsed: _onRefreshDue,
                  ),
                ),
                const SizedBox(height: 18),
                HudEntrance(
                  index: 0,
                  child: _DayPanel(
                    date: _today,
                    xpEarned: xpEarned,
                    xpAvailable: xpAvailable,
                    cleared: cleared,
                    missed: missed,
                    total: tasks.length,
                  ),
                ),
                const SizedBox(height: 18),
                HudEntrance(index: 1, child: _buildTimeline(routine)),
                const SizedBox(height: 16),
                HudEntrance(
                  index: 2,
                  child: GradientButton(
                    label: dayAnswered
                        ? 'Claim day'
                        : '$pending quests remaining',
                    icon: dayAnswered ? Icons.verified : null,
                    colors: dayAnswered
                        ? [AppColors.accentGold, AppColors.accentMagenta]
                        : [AppColors.accentPurple, AppColors.primary],
                    // Deliberately NOT a "tick everything" shortcut — that
                    // would be cheating the whole point. It opens the day's
                    // debrief once every step has an answer.
                    onPressed: dayAnswered
                        ? () => _openDailyReport(tasks)
                        : null,
                  ),
                ),
              ],
            ),
            if (_rewardXp != null)
              _XpBurst(key: ValueKey(_rewardSeq), xp: _rewardXp!),
          ],
        );
      },
    );
  }

  /// The day as one panel: answered steps above, the live one in the middle,
  /// what's still coming below — in real time order.
  Widget _buildTimeline(List<RoutineStep> routine) {
    // Between windows there is no active step at all — the morning has closed
    // and the evening hasn't opened. Without something here the screen would
    // just show a list of grey rows and no explanation, which reads as broken
    // rather than as "nothing is being asked of you yet".
    final waitingFor = routine.any((s) => s.isActive)
        ? null
        : _firstLocked(routine);

    // No outer panel: the steps are cards in their own right now, and a panel
    // around a column of cards is a box inside a box. A plain section label
    // does the same job with far less furniture.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text('ROUTINE', style: AppTextStyles.panelTitle),
        ),
        ...[
          for (final step in routine) ...[
            if (identical(step, waitingFor))
              Padding(
                key: const ValueKey('waiting'),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _WaitingCard(next: step.task),
              ),
            // AnimatedSize + the keys let a step change shape in place when it
            // becomes (or stops being) the active one, instead of the whole
            // list jumping.
            if (step.isActive)
              Padding(
                key: ValueKey('active-${step.task.id}'),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ActiveStepCard(
                  task: step.task,
                  closesAt: _windowCloseTime(step.task),
                  onDone: () => _answer(step.task, QuestStatus.done),
                  onMissed: () => _answer(step.task, QuestStatus.missed),
                  // Only the workout step has somewhere deeper to go.
                  onOpenDetail:
                      step.task.template.id == 'workout_of_the_day'
                      ? widget.onOpenTraining
                      : null,
                  detailLabel: 'OPEN TRAINING',
                ),
              )
            else
              RoutineStepTile(
                key: ValueKey('step-${step.task.id}'),
                step: step,
                onReopen: _canReopen(step)
                    ? () => _answer(step.task, QuestStatus.pending)
                    : null,
              ),
          ],
        ],
      ],
    );
  }

  /// The next step still to come, or null if the day is fully resolved.
  RoutineStep? _firstLocked(List<RoutineStep> routine) {
    for (final step in routine) {
      if (step.state == RoutineState.locked) return step;
    }
    return null;
  }

  /// Closing the day should be an event, not the list quietly going grey.
  void _openDailyReport(List<DailyTask> tasks) {
    Navigator.of(context).push(
      hudRoute(
        DailyReportOverlay(
          date: _today,
          tasks: tasks,
          onOpenWeek: widget.onOpenReport,
        ),
      ),
    );
  }

  /// A resolved step can be un-answered only while its window is still open.
  ///
  /// Once the window has shut the answer is history: reopening it would put
  /// the step straight back to missed on the next tick, which looks like a
  /// bug. Mis-taps are recoverable exactly as long as the day still is.
  bool _canReopen(RoutineStep step) {
    if (!step.isResolved) return false;
    final now = _clock.now();
    return !hasLapsed(
      scheduledMinutes: step.task.scheduledMinutes,
      graceMinutes: step.task.graceMinutes,
      cursor: dayCursor(
        dayKey: dayKeyOf(_today),
        todayKey: dayKeyOf(now),
        now: now,
      ),
    );
  }

  /// The wall-clock instant this step's window shuts, for the countdown.
  DateTime _windowCloseTime(DailyTask task) {
    final closes = windowClosesAt(
      scheduledMinutes: task.scheduledMinutes,
      graceMinutes: task.graceMinutes,
    );
    final midnight = DateTime(_today.year, _today.month, _today.day);
    return midnight.add(Duration(minutes: closes));
  }
}

/// Shown when nothing is active yet: which step is next, and when.
///
/// Quiet on purpose — cyan and flat, not the magenta breathing card. The
/// System is waiting, not asking.
class _WaitingCard extends StatelessWidget {
  final DailyTask next;

  const _WaitingCard({required this.next});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: ShapeDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        shape: AppShapes.row(
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.45),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT AT ${next.scheduledLabel}',
                  style: AppTextStyles.hudLabel.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  next.template.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.questTitle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Today's own figures — the date, the day's XP and how the steps ended up.
/// Level and rank deliberately absent; RankHeader already shows them.
class _DayPanel extends StatelessWidget {
  final DateTime date;
  final int xpEarned;
  final int xpAvailable;
  final int cleared;
  final int missed;
  final int total;

  const _DayPanel({
    required this.date,
    required this.xpEarned,
    required this.xpAvailable,
    required this.cleared,
    required this.missed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      glow: 0.35,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(_formatDate(date), style: AppTextStyles.body),
              ),
              if (missed > 0) ...[
                Text(
                  '$missed missed',
                  style: AppTextStyles.hudLabel.copyWith(
                    color: AppColors.danger,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                '$cleared / $total',
                style: AppTextStyles.counter.copyWith(
                  color: cleared == total && total > 0
                      ? AppColors.accentGold
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          StatBar(
            label: 'Daily XP',
            value: xpEarned,
            max: xpAvailable,
            height: 10,
          ),
        ],
      ),
    );
  }
}

/// The "+10 XP" that rises and fades after completing a step.
///
/// Lives at screen level rather than inside the step: the step is replaced by
/// a collapsed row the instant it's answered, so an animation owned by it
/// would be disposed halfway through.
class _XpBurst extends StatelessWidget {
  final int xp;

  const _XpBurst({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) => Align(
            alignment: Alignment(0, 0.15 - 0.35 * t),
            child: Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: child),
          ),
          child: Text(
            '+$xp XP',
            style: AppTextStyles.display.copyWith(
              fontSize: 30,
              color: AppColors.accentGold,
              shadows: [
                BoxShadow(color: AppColors.accentGold, blurRadius: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Centred HUD message, for loading and error states.
class _Notice extends StatelessWidget {
  final String text;

  const _Notice(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.panelTitle,
      ),
    ),
  );
}

const _weekdayNames = [
  'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
];
const _monthNames = [
  'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY',
  'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
];

// Hand-rolled instead of pulling in the `intl` package for one date string.
String _formatDate(DateTime date) {
  final weekday = _weekdayNames[date.weekday - 1];
  final month = _monthNames[date.month - 1];
  return '$weekday  ·  $month ${date.day}';
}
