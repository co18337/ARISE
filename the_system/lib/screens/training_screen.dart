import 'package:flutter/material.dart';

import '../data/repositories/workout_repository.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/exercise_demo.dart';
import '../widgets/exercise_guide_sheet.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_chip.dart';
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
    this.onSessionCompleted,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  // Fields, never built inside build() — a stream created per build makes
  // StreamBuilder re-subscribe forever. Same rule as TodayScreen.
  late final DateTime _today = widget.workoutRepository.clock.now();
  late final Future<WorkoutSessionView?> _ready =
      widget.workoutRepository.openSession(_today);
  late final Stream<WorkoutSessionView?> _sessionStream =
      widget.workoutRepository.watchSession(_today);

  /// Set while the finish is in flight, so the button cannot be double-tapped
  /// into two quest completions.
  bool _finishing = false;

  String? _error;

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
          return const _Notice('BUILDING SESSION…');
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
        const HudSectionTitle('TRAINING'),
        const SizedBox(height: 18),
        HudEntrance(index: 0, child: _SessionHeader(session: session)),
        if (session.notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          HudEntrance(index: 1, child: _TrainerNotes(notes: session.notes)),
        ],
        const SizedBox(height: 16),
        for (final (i, exercise) in session.exercises.indexed) ...[
          HudEntrance(
            index: i + 1,
            child: _ExerciseCard(
              view: exercise,
              // Locked once the session is signed off. Leaving the chips live
              // let a finished session be un-ticked behind its own back, so it
              // read "complete" while its sets said otherwise.
              locked: session.isComplete,
              onToggleSet: (setId, done) =>
                  widget.workoutRepository.setDone(setId, done),
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
            onPressed: session.allSetsDone && !session.isComplete && !_finishing
                ? () => _finish(session)
                : null,
          ),
        ),
      ],
    );
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

/// What the trainer remembered about sessions like this one.
///
/// This is the visible half of the memory system: retrieval, running, with no
/// model involved. When the Gemini key arrives these same passages become the
/// context it writes from.
class _TrainerNotes extends StatelessWidget {
  final List<String> notes;

  const _TrainerNotes({required this.notes});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'The System remembers',
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
        ],
      ),
    );
  }
}

/// One exercise: what to do, how to do it, and a chip per set.
class _ExerciseCard extends StatelessWidget {
  final WorkoutExerciseView view;

  /// No more edits once the session is signed off.
  final bool locked;

  final Future<void> Function(int setId, bool done) onToggleSet;

  const _ExerciseCard({
    required this.view,
    required this.onToggleSet,
    this.locked = false,
  });

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
                  child: ExerciseDemo(exercise: exercise, size: 78),
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
                  ),
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

/// One set. Tap to log it, tap again to undo.
class _SetChip extends StatelessWidget {
  final WorkoutSetView set;
  final LoadUnit unit;
  final bool locked;
  final VoidCallback? onTap;

  const _SetChip({
    required this.set,
    required this.unit,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = set.done ? AppColors.remaining : AppColors.primary;

    return Semantics(
      button: !locked,
      label: 'Set ${set.setIndex}, ${set.done ? 'logged' : 'not logged'}'
          '${locked ? ', session finished' : ''}',
      child: Material(
        color: Colors.transparent,
        shape: AppShapes.control(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: ShapeDecoration(
              color: color.withValues(alpha: set.done ? 0.18 : 0.05),
              shape: AppShapes.control(
                side: BorderSide(
                  color: color.withValues(alpha: set.done ? 0.85 : 0.4),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  set.done ? Icons.check : Icons.radio_button_unchecked,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  '${set.target} ${unit.label}',
                  style: AppTextStyles.counter.copyWith(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
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
        const HudSectionTitle('TRAINING'),
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
