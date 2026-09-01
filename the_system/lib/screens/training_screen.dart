import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../data/repositories/workout_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/exercise_demo.dart';
import '../widgets/exercise_guide_sheet.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_chip.dart';
import '../widgets/summon_gate.dart';
import 'day_rollover.dart';
import '../widgets/system_panel.dart';

/// TRAINING — today's actual workout, exercise by exercise.
///
/// Separate from the DAILY QUESTS routine on purpose. The routine asks "did
/// you train?", one tick. This asks "how many sets of what?", and records
/// every one — which is the only way progressive overload can know what to ask
/// for next time.
///
/// What appears here is decided by the programme phase, so month one is
/// running and nothing else, and the lifts arrive when the plan says they do.
class TrainingScreen extends StatefulWidget {
  final WorkoutRepository workoutRepository;

  /// For the status recital during the summoning. Null until it streams in.
  final PlayerSnapshot? player;

  /// Called when the session is finished, so the routine's workout step can be
  /// cleared without being ticked twice.
  ///
  /// Returns a Future and IS awaited. It used to be a VoidCallback, which
  /// meant the quest-completion future was dropped on the floor: if it failed
  /// there was no XP, no error and no log — the exact shape of a bug you
  /// cannot find.
  final Future<void> Function()? onSessionCompleted;

  const TrainingScreen({
    super.key,
    required this.workoutRepository,
    this.player,
    this.onSessionCompleted,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with WidgetsBindingObserver, DayRollover<TrainingScreen> {
  // Fields, never built inside build() — a stream created per build makes
  // StreamBuilder re-subscribe forever. Same rule as TodayScreen.
  // Not `late final`: all four are reissued when the day rolls over, and a
  // final field cannot be. See DayRollover.
  late DateTime _today;
  late Future<WorkoutSessionView?> _ready;
  late Stream<WorkoutSessionView?> _sessionStream;

  /// Set while the finish is in flight, so the button cannot be double-tapped
  /// into two quest completions.
  bool _finishing = false;

  String? _error;

  /// Sessions finished ever — for the summoning's status recital.
  late Future<int> _sessionsRecorded;

  /// The phase gate and the scan emphasis, read together. Both are derived
  /// from the record rather than stored on the session, so they are fetched
  /// here rather than carried through the view.
  late Future<List<Object>> _standing;

  @override
  Clock get rolloverClock => widget.workoutRepository.clock;

  @override
  DateTime get shownDay => _today;

  @override
  void openDay() {
    _today = widget.workoutRepository.clock.now();
    _ready = widget.workoutRepository.openSession(_today);
    _sessionStream = widget.workoutRepository.watchSession(_today);
    _sessionsRecorded = widget.workoutRepository.completedSessionCount();
    _standing = Future.wait([
      widget.workoutRepository.readGate(_today),
      widget.workoutRepository.readEmphasis(),
      widget.workoutRepository.deloadFor(_today).then((d) => d ?? false),
    ]);
  }

  Future<void> _summon() => widget.workoutRepository.summon(_today);

  Future<void> _finish(WorkoutSessionView session) async {
    if (_finishing) return;
    setState(() {
      _finishing = true;
      _error = null;
    });
    try {
      await widget.workoutRepository.completeSession(session.id);
      await widget.onSessionCompleted?.call();
    } catch (error) {
      // Surfaced, not swallowed. Finishing a session is the one action here
      // that awards XP, so a silent failure is the worst possible outcome.
      if (mounted) setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WorkoutSessionView?>(
      future: _ready,
      builder: (context, opened) {
        if (opened.connectionState != ConnectionState.done) {
          return _Notice('BUILDING SESSION…');
        }
        if (opened.hasError) {
          return _Notice('SYSTEM ERROR\n${opened.error}');
        }
        // Null means the plan genuinely asks for nothing today.
        if (opened.data == null) return _RestDay(date: _today);

        return StreamBuilder<WorkoutSessionView?>(
          stream: _sessionStream,
          initialData: opened.data,
          builder: (context, snapshot) {
            final session = snapshot.data;
            if (session == null) return _RestDay(date: _today);
            return _buildSession(session);
          },
        );
      },
    );
  }

  Widget _buildSession(WorkoutSessionView session) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        HudSectionTitle('TRAINING'),
        const SizedBox(height: 18),
        if (!session.isSummoned) ...[
          FutureBuilder<int>(
            future: _sessionsRecorded,
            builder: (context, snapshot) => SummonGate(
              player: widget.player,
              sessionsRecorded: snapshot.data ?? 0,
              focus: session.focus,
              week: session.week,
              onArise: _summon,
            ),
          ),
          const SizedBox(height: 18),
        ],
        // Visible before it is accepted, but not yours to start. Hiding it
        // would make the ceremony a wall; showing it live would make the
        // ceremony pointless.
        IgnorePointer(
          ignoring: !session.isSummoned,
          child: AnimatedSlide(
            // Rises into place as it brightens. Before the summoning it sits
            // low and dim behind the gate; accepting it lifts the whole
            // session up from below, which is the moment the day arrives.
            offset: session.isSummoned ? Offset.zero : const Offset(0, 0.06),
            duration: const Duration(milliseconds: 620),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: session.isSummoned ? 1 : 0.3,
              duration: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _sessionBody(session),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sessionBody(WorkoutSessionView session) {
    return [
        HudEntrance(index: 0, child: _SessionHeader(session: session)),
        FutureBuilder<List<Object>>(
          future: _standing,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) return const SizedBox.shrink();
            final gate = data[0] as PhaseGate;
            final emphasis = data[1] as BodyEmphasis;
            final deload = data[2] is Deload ? data[2] as Deload : null;
            final lines = [
              // The back-off leads: it is the reason today looks lighter, and
              // a shorter session with no explanation reads as the app losing
              // your progress.
              if (deload != null)
                ('${deload.reason.label} WEEK · ${deload.reason.explanation}',
                    true),
              if (gate.holdReason != null) (gate.holdReason!, true),
              if (emphasis.reason != null && emphasis.hasPriority)
                (emphasis.reason!, false),
            ];
            if (lines.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (text, isHold) in lines) ...[
                    _StandingNote(text: text, isHold: isHold),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            );
          },
        ),
        if (session.notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          HudEntrance(
            index: 1,
            child: _TrainerNotes(
              notes: session.notes,
              source: session.noteSource,
            ),
          ),
        ],
        const SizedBox(height: 16),
        // The movement you are on: the first with sets still to log. Once the
        // session is done, nothing animates at all.
        for (final (i, exercise) in session.exercises.indexed) ...[
          HudEntrance(
            index: i + 1,
            // Further than the default 14: these are the thing the summoning
            // produces, so they should visibly arrive rather than settle.
            offset: 34,
            child: _ExerciseCard(
              view: exercise,
              animate: !session.isComplete &&
                  i == session.exercises.indexWhere((e) => !e.complete),
              // Locked once the session is signed off. Leaving the chips live
              // let a finished session be un-ticked behind its own back, so it
              // read "complete" while its sets said otherwise.
              locked: session.isComplete,
              onToggleSet: (setId, done) =>
                  widget.workoutRepository.setDone(setId, done),
              onLogAmount: (setId, amount, loadHalfKg) => widget
                  .workoutRepository
                  .setDone(
                    setId,
                    true,
                    actual: amount,
                    loadHalfKg: loadHalfKg,
                  ),
              onAddExtra: () => widget.workoutRepository
                  .addExtraSet(session.id, exercise.exercise.id),
              onRemoveExtra: widget.workoutRepository.removeExtraSet,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (session.isComplete) ...[
          const SizedBox(height: 6),
          _SignedOff(date: session.date),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            'Could not finish the session: $_error',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.danger),
          ),
        ],
        const SizedBox(height: 6),
        HudEntrance(
          index: session.exercises.length + 1,
          child: GradientButton(
            label: session.isComplete
                ? 'Session complete'
                : _finishing
                ? 'Finishing…'
                : session.allSetsDone
                ? 'Finish session'
                : '${session.totalSets - session.setsDone} sets remaining',
            icon: session.isComplete ? Icons.verified : null,
            colors: session.allSetsDone
                ? [AppColors.accentGold, AppColors.accentMagenta]
                : [AppColors.accentPurple, AppColors.primary],
            // Only offered once every set is genuinely logged. A "finish
            // anyway" button would quietly poison the progression history,
            // because overload counts sessions completed in full.
            onPressed: session.isSummoned &&
                    session.allSetsDone &&
                    !session.isComplete &&
                    !_finishing
                ? () => _finish(session)
                : null,
          ),
        ),
    ];
  }
}

/// Phase, week, focus and how far through the session you are.
class _SessionHeader extends StatelessWidget {
  final WorkoutSessionView session;

  const _SessionHeader({required this.session});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      glow: 0.32,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  session.focus,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.display.copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'WEEK ${session.week}',
                style: AppTextStyles.hudLabel.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${session.phase.label} · ${session.phase.focus}',
            style: AppTextStyles.body.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 14),
          StatBar(
            label: 'Sets logged',
            value: session.setsDone,
            max: session.totalSets,
            height: 10,
          ),
          if (session.extraSetsDone > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.add, size: 14, color: AppColors.accentGold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    session.extraSetsDone == 1
                        ? '1 set beyond the plan'
                        : '${session.extraSetsDone} sets beyond the plan',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),
                Text(
                  '+${session.extraSetsDone * GameRules.xpPerExtraSet} XP',
                  style: AppTextStyles.counter.copyWith(
                    fontSize: 12,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ],
          if (session.isSummoned) ...[
            const SizedBox(height: 8),
            Text(
              'SUMMONED ${_clockTime(session.summonedAt!)}',
              style: AppTextStyles.hudLabel.copyWith(fontSize: 8),
            ),
          ],
        ],
      ),
    );
  }
}

/// The session is signed off: what it earned, and that it is closed.
///
/// Without this the screen looked identical before and after finishing —
/// which is why it felt like nothing had happened.
class _SignedOff extends StatelessWidget {
  final DateTime date;

  const _SignedOff({required this.date});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      accent: AppColors.remaining,
      glow: 0.32,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 18, color: AppColors.remaining),
              const SizedBox(width: 8),
              Text(
                'SESSION SIGNED OFF',
                style: AppTextStyles.panelTitle.copyWith(
                  color: AppColors.remaining,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Logged, locked and written to memory. The workout quest is '
            'cleared — check DAILY QUESTS for the XP.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// What the trainer has to say about today.
///
/// Either a note the model wrote from your recalled history, or — with no key,
/// or when the call fails — those passages shown as they are. The heading says
/// which, because the two deserve different trust.
/// Why the session is what it is: held back by the gate, or shaped by the scan.
///
/// Two different things and they read differently. A HOLD is the System
/// refusing to promote you and owes you the reason; an EMPHASIS is it telling
/// you where the extra set came from. Neither is a modal — this is reporting,
/// and only rewards interrupt.
class _StandingNote extends StatelessWidget {
  final String text;
  final bool isHold;

  const _StandingNote({required this.text, required this.isHold});

  @override
  Widget build(BuildContext context) {
    final accent = isHold ? AppColors.accentGold : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: accent, width: 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isHold ? Icons.lock_clock : Icons.center_focus_strong,
            size: 15,
            color: accent,
          ),
          const SizedBox(width: 9),
          // Expanded, not fixed: a two-line reason at a large system font is
          // exactly how a Row overflows on a 360dp phone.
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerNotes extends StatelessWidget {
  final List<String> notes;
  final TrainerNoteSource source;

  const _TrainerNotes({required this.notes, required this.source});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: source.heading,
      accent: AppColors.accentPurple,
      glow: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final note in notes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Icon(
                    Icons.circle,
                    size: 5,
                    color: AppColors.accentPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    note,
                    style: AppTextStyles.body.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            if (note != notes.last) const SizedBox(height: 8),
          ],
          if (source.caption.isNotEmpty) ...[
            const SizedBox(height: 10),
            // Said out loud: a sentence the model wrote and a line quoted out
            // of your own record are not the same kind of claim.
            Text(
              source.caption.toUpperCase(),
              style: AppTextStyles.hudLabel.copyWith(fontSize: 8),
            ),
          ],
        ],
      ),
    );
  }
}

String _clockTime(DateTime at) =>
    '${at.hour.toString().padLeft(2, '0')}:'
    '${at.minute.toString().padLeft(2, '0')}';

/// One exercise: what to do, how to do it, and a chip per set.
class _ExerciseCard extends StatelessWidget {
  final WorkoutExerciseView view;

  /// True for the ONE movement you are currently on. Only that card animates
  /// its demonstration — see ExerciseDemo for why.
  final bool animate;

  /// No more edits once the session is signed off.
  final bool locked;

  final Future<void> Function(int setId, bool done) onToggleSet;

  /// Logs a set at an amount other than the one prescribed. This is how
  /// "you said 20 minutes, I did 30" gets recorded as 30 rather than as 20.
  final Future<void> Function(int setId, int amount, int? loadHalfKg)
      onLogAmount;

  /// Adds a set beyond the prescription. No cap — if there is more in you,
  /// the app's job is to record it, not to argue.
  final Future<void> Function() onAddExtra;
  final Future<void> Function(int setId) onRemoveExtra;

  const _ExerciseCard({
    required this.view,
    required this.animate,
    required this.onToggleSet,
    required this.onLogAmount,
    required this.onAddExtra,
    required this.onRemoveExtra,
    this.locked = false,
  });

  /// Asks how much was actually done, defaulting to what was asked for.
  Future<void> _askAmount(
    BuildContext context,
    WorkoutSetView set,
  ) async {
    final exercise = view.exercise;
    final controller = TextEditingController(
      text: (set.actual ?? set.target).toString(),
    );

    // Only for movements that carry weight. Asking "how many kilos?" about a
    // plank is how a form starts being ignored.
    final loadController = TextEditingController(
      text: set.loadHalfKg == null ? '' : _kg(set.loadHalfKg!),
    );

    final result = await showDialog<({int amount, int? loadHalfKg})>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: AppShapes.panel(
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
        ),
        title: Text('How much?', style: AppTextStyles.panelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${exercise.name} — ${set.target} ${exercise.unit.label} asked '
              'for.',
              style: AppTextStyles.body.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                suffixText: exercise.unit.label,
                border: const OutlineInputBorder(),
              ),
            ),
            if (exercise.isLoaded) ...[
              const SizedBox(height: 12),
              TextField(
                controller: loadController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              exercise.isLoaded
                  ? 'The weight is what the next session starts from, so log '
                        'what was actually on the bar. More reps than asked '
                        'for is fine and earns XP.'
                  : 'More than asked for is fine — it is recorded and it earns '
                        'XP. It will not make next week harder on its own.',
              style: AppTextStyles.body.copyWith(fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL', style: AppTextStyles.hudLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop((
              amount: int.tryParse(controller.text.trim()) ?? set.target,
              // Half-kilos, so 27.5 stays 27.5 rather than drifting into
              // 27.500000000000004 the third time it is read back.
              loadHalfKg: exercise.isLoaded
                  ? _halfKg(loadController.text.trim())
                  : null,
            )),
            child: Text(
              'LOG IT',
              style:
                  AppTextStyles.hudLabel.copyWith(color: AppColors.accentGold),
            ),
          ),
        ],
      ),
    );

    controller.dispose();
    loadController.dispose();
    if (result != null && result.amount > 0) {
      await onLogAmount(set.id, result.amount, result.loadHalfKg);
    }
  }

  static String _kg(int halfKg) {
    final kg = halfKg / 2;
    return kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : '$kg';
  }

  static int? _halfKg(String text) {
    final kg = double.tryParse(text);
    if (kg == null || kg <= 0) return null;
    return (kg * 2).round();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = view.exercise;
    final complete = view.complete;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface.withValues(alpha: 0.55),
        shape: AppShapes.panel(
          side: BorderSide(
            color: complete
                ? AppColors.remaining.withValues(alpha: 0.55)
                : AppColors.primaryDim.withValues(alpha: 0.45),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The whole card opens the guide: mid-set is exactly when you
                // want to check the form, and hunting for a small info icon is
                // not what you want to be doing then.
                GestureDetector(
                  onTap: () => ExerciseGuideSheet.show(context, exercise),
                  // Only the movement you are actually on animates. Every
                  // other card falls back to its cue — see ExerciseDemo for
                  // the battery measurement behind that.
                  child: ExerciseDemo(
                    exercise: exercise,
                    size: 78,
                    animate: animate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ExerciseGuideSheet.show(context, exercise),
                    child: _ExerciseHeading(view: view),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  view.summary,
                  style: AppTextStyles.counter.copyWith(fontSize: 13),
                ),
                const Spacer(),
                Text(
                  exercise.kind.label,
                  style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final set in view.sets)
                  _SetChip(
                    set: set,
                    unit: exercise.unit,
                    locked: locked,
                    onTap: locked
                        ? null
                        : () => onToggleSet(set.id, !set.done),
                    // Long-press says how much you ACTUALLY did. Tap stays the
                    // one-handed common case; the amount is the exception.
                    onLongPress:
                        locked ? null : () => _askAmount(context, set),
                    onRemove: locked || !set.isExtra
                        ? null
                        : () => onRemoveExtra(set.id),
                  ),
                if (!locked) _AddSetChip(onTap: onAddExtra),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Name, stat and cue — the column beside the demonstration.
class _ExerciseHeading extends StatelessWidget {
  final WorkoutExerciseView view;

  const _ExerciseHeading({required this.view});

  @override
  Widget build(BuildContext context) {
    final exercise = view.exercise;
    final complete = view.complete;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (complete) ...[
              Icon(Icons.check, size: 16, color: AppColors.remaining),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                exercise.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.questTitle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: complete
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            StatChip(stat: exercise.stat, dimmed: complete),
          ],
        ),
        const SizedBox(height: 6),
        // The cue does the job the animation would, and does it whether or not
        // there is artwork for this movement.
        Text(exercise.cue, style: AppTextStyles.body.copyWith(fontSize: 12)),
      ],
    );
  }
}

/// One set. Tap to log it as asked, long-press to say what you really did.
class _SetChip extends StatelessWidget {
  final WorkoutSetView set;
  final LoadUnit unit;
  final bool locked;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Only extra sets can be removed. The prescription is the plan, and
  /// un-asking is not something the app should offer.
  final VoidCallback? onRemove;

  const _SetChip({
    required this.set,
    required this.unit,
    required this.locked,
    required this.onTap,
    this.onLongPress,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Gold for work beyond the prescription, green for the prescription met.
    final color = !set.done
        ? (set.isExtra ? AppColors.accentGold : AppColors.primary)
        : (set.isExtra || set.exceeded
              ? AppColors.accentGold
              : AppColors.remaining);

    final amount = set.done ? (set.actual ?? set.target) : set.target;

    return Semantics(
      button: true,
      label: '${set.isExtra ? 'Extra set' : 'Set ${set.setIndex}'}, '
          '${set.done ? 'logged' : 'not logged'}',
      child: Material(
        color: Colors.transparent,
        shape: AppShapes.control(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: ShapeDecoration(
              color: color.withValues(alpha: set.done ? 0.18 : 0.05),
              shape: AppShapes.control(
                side: BorderSide(
                  color: color.withValues(alpha: set.done ? 0.85 : 0.4),
                  width: set.isExtra ? 1.4 : 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  set.done
                      ? (set.isExtra || set.exceeded
                            ? Icons.add
                            : Icons.check)
                      : Icons.radio_button_unchecked,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  '$amount ${unit.label}',
                  style: AppTextStyles.counter.copyWith(
                    fontSize: 12,
                    color: color,
                  ),
                ),
                if (set.exceeded && !set.isExtra) ...[
                  const SizedBox(width: 5),
                  Text(
                    '+${set.actual! - set.target}',
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 9,
                      color: AppColors.accentGold,
                    ),
                  ),
                ],
                if (onRemove != null) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: onRemove,
                    child: Icon(
                      Icons.close,
                      size: 13,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "One more." Deliberately always available while the session is open.
class _AddSetChip extends StatelessWidget {
  final VoidCallback onTap;

  const _AddSetChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: AppShapes.control(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: ShapeDecoration(
            shape: AppShapes.control(
              side: BorderSide(
                color: AppColors.accentGold.withValues(alpha: 0.4),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 14, color: AppColors.accentGold),
              const SizedBox(width: 6),
              Text(
                'ONE MORE',
                style: AppTextStyles.hudLabel.copyWith(
                  fontSize: 9,
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The plan asks for nothing today.
class _RestDay extends StatelessWidget {
  final DateTime date;

  const _RestDay({required this.date});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        HudSectionTitle('TRAINING'),
        const SizedBox(height: 18),
        SystemPanel(
          title: 'Rest day',
          glow: 0.2,
          child: Text(
            'Nothing scheduled today. Rest is part of the programme, not a gap '
            'in it — the adaptation happens between sessions, not during them.',
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  final String text;

  const _Notice(this.text);

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
