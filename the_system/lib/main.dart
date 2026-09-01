import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ai/ai_log_repository.dart';
import 'ai/gemini_client.dart';
import 'ai/groq_client.dart';
import 'ai/llm_router.dart';
import 'ai/lanes/nutrition_lane.dart';
import 'ai/lanes/review_lane.dart';
import 'ai/lanes/trainer_lane.dart';
import 'config/app_config.dart';
import 'data/db/database.dart';
import 'data/exercise_guides.dart';
import 'data/export/export_repository.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/player_repository.dart';
import 'data/repositories/quest_repository.dart';
import 'data/memory/embedder.dart';
import 'data/memory/gemini.dart';
import 'data/memory/memory_repository.dart';
import 'data/memory/memory_trainer.dart';
import 'data/repositories/nutrition_repository.dart';
import 'data/alerts/notifier_factory.dart';
import 'data/repositories/alert_repository.dart';
import 'data/health/health_source_factory.dart';
import 'data/repositories/health_repository.dart';
import 'data/repositories/plan_repository.dart';
import 'data/repositories/progress_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'screens/app_shell.dart';
import 'theme/theme.dart';

Future<void> main() async {
  // Opening the database touches platform channels (to find the app's
  // documents directory), so the Flutter binding has to be initialised first.
  WidgetsFlutterBinding.ensureInitialized();
  _registerAssetLicences();
  // Reads the gitignored .env if it is there. Missing is fine — everything
  // works without a key, only less well.
  await AppConfig.load();
  // Small bundled asset; loading it here keeps the first TRAINING screen from
  // waiting on I/O.
  await ExerciseGuides.load();

  // Anything thrown here happens BEFORE the first frame, so without this
  // catch the app renders nothing at all — a blank white page with no error
  // anywhere on screen. Showing the failure instead makes startup bugs
  // debuggable without opening the browser console.
  try {
    final database = AppDatabase();
    // One memory store, shared: the trainer reads from it and finished
    // sessions write to it, which is the loop that fills it.
    // The real embedder when there is a key, the local one otherwise.
    //
    // RETRIEVAL IS THE FLOOR AND ALWAYS WORKS: HashingEmbedder needs no
    // network and no key, so recall functions offline. The key only changes
    // how good the matching is — hashed word overlap versus actual meaning.
    //
    // Switching does NOT convert the corpus on its own. Vectors from two
    // embedders are not comparable, so the store keeps both labelled and the
    // MEMORY screen offers the upgrade explicitly — a silent re-embed on
    // launch would spend a few hundred API calls without being asked.
    final memory = MemoryRepository(
      database,
      embedder: AppConfig.hasGeminiKey
          ? GeminiEmbedder()
          : const HashingEmbedder(),
    );
    // One client, shared by every lane. The nutrition lane is only attached
    // when a key exists — without one the app logs food and takes the figures
    // by hand, which is the whole offline path.
    // Groq first because it is markedly faster; Gemini behind it as the
    // deeper well. The router skips a provider with no key, so the app works
    // with either, both, or neither — and the cache sits above both, so an
    // answer is never bought twice.
    final llm = LlmRouter(
      db: database,
      providers: [GroqClient(), GeminiClient(database)],
    );
    final hasLlm = llm.hasAnyProvider;
    final nutritionLane = hasLlm ? NutritionLane(llm) : null;
    final trainerLane = hasLlm ? TrainerLane(llm) : null;
    runApp(
      MyApp(
        questRepository: QuestRepository(database),
        playerRepository: PlayerRepository(database),
        activityRepository: ActivityRepository(database),
        exportRepository: ExportRepository(database),
        workoutRepository: WorkoutRepository(
          database,
          advisor: MemoryTrainerAdvisor(memory: memory, lane: trainerLane),
          memory: memory,
        ),
        memoryRepository: memory,
        aiLogRepository: AiLogRepository(database),
        nutritionRepository: NutritionRepository(
          database,
          memory: memory,
          lane: nutritionLane,
        ),
        progressRepository: ProgressRepository(database),
        // The notifier is chosen by the compiler, not at runtime: the plugin
        // does not exist on web, so a conditional export picks the no-op
        // there. Nothing here can fail the launch.
        alertRepository: AlertRepository(
          quests: QuestRepository(database),
          notifier: createNotifier(),
        ),
        // Read-only and one-way. The compiler picks the no-op on web, so
        // nothing here can fail the launch.
        healthRepository: HealthRepository(
          db: database,
          source: createHealthSource(),
          quests: QuestRepository(database),
        ),
        planRepository: PlanRepository(database),
        reviewRepository: ReviewRepository(
          db: database,
          progress: ProgressRepository(database),
          memory: memory,
          lane: hasLlm ? ReviewLane(llm) : null,
        ),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('The System failed to start: $error\n$stackTrace');
    runApp(_StartupFailureApp(error: error));
  }
}

/// Declares the licence of the bundled emblem artwork.
///
/// The icons in assets/icons/ are CC BY 3.0, which makes attribution a
/// condition of using them at all. Registering here puts them in the standard
/// Flutter licence list (what `showLicensePage` renders); the BACKUP screen
/// also shows a human-readable credit, because a licence nobody can find is
/// not really attribution.
void _registerAssetLicences() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['game-icons.net emblems'],
      'Rank crests, stat emblems and achievement medals in assets/icons/ are '
      'from game-icons.net, by Lorc, Delapouite and sbed.\n\n'
      'Licensed under the Creative Commons Attribution 3.0 Unported licence '
      '(CC BY 3.0): https://creativecommons.org/licenses/by/3.0/\n\n'
      'The icons are recoloured and composited into frames drawn by this app; '
      'the underlying artwork is unmodified in shape. Full per-icon credits '
      'are in assets/icons/CREDITS.md.',
    );
  });
}

class MyApp extends StatefulWidget {
  final QuestRepository questRepository;
  final PlayerRepository playerRepository;
  final ActivityRepository activityRepository;
  final ExportRepository exportRepository;
  final WorkoutRepository workoutRepository;
  final MemoryRepository memoryRepository;
  final AiLogRepository aiLogRepository;
  final NutritionRepository nutritionRepository;
  final ProgressRepository progressRepository;
  final AlertRepository alertRepository;
  final HealthRepository healthRepository;
  final PlanRepository planRepository;
  final ReviewRepository reviewRepository;

  /// Starting look. Tests pin it; the real app loads the saved one instead.
  final AppThemeMode? initialThemeMode;

  const MyApp({
    super.key,
    required this.questRepository,
    required this.playerRepository,
    required this.activityRepository,
    required this.exportRepository,
    required this.workoutRepository,
    required this.memoryRepository,
    required this.aiLogRepository,
    required this.nutritionRepository,
    required this.progressRepository,
    required this.alertRepository,
    required this.healthRepository,
    required this.planRepository,
    required this.reviewRepository,
    this.initialThemeMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

// WidgetsBindingObserver is what makes AUTO mode live: the phone flipping to
// dark mode at sunset has to repaint the app, and there is no other callback
// for it.
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppThemeMode _mode = widget.initialThemeMode ?? AppThemeMode.dark;

  /// The palette the current mode resolves to right now.
  ///
  /// Read from the platform dispatcher rather than MediaQuery so it can be
  /// resolved OUTSIDE build — installing the palette during a build meant the
  /// notifier fired mid-frame and the screens never repainted.
  AppPalette get _palette => AppTheme.paletteFor(
    _mode,
    WidgetsBinding.instance.platformDispatcher.platformBrightness,
  );

  void _applyPalette() => AppColors.use(_palette);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyPalette();
    if (widget.initialThemeMode == null) _loadSavedMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadSavedMode() async {
    final saved = await widget.playerRepository.readThemeMode();
    if (mounted && saved != _mode) {
      setState(() {
        _mode = saved;
        _applyPalette();
      });
    }
  }

  @override
  void didChangePlatformBrightness() {
    // Only AUTO cares, but rebuilding either way is a single frame and keeps
    // the condition out of a lifecycle callback.
    if (mounted) setState(_applyPalette);
  }

  void _setMode(AppThemeMode mode) {
    setState(() {
      _mode = mode;
      _applyPalette();
    });
    // Fire and forget: the UI has already changed, and a failed write costs
    // nothing worse than the app opening in the previous theme next time.
    widget.playerRepository.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The app is ARISE; the entity inside it is "The System", which is what
      // the headings and the notifications say. This title is what Android
      // shows in the recents switcher, so it matches the launcher.
      title: 'ARISE',
      debugShowCheckedModeBanner: false, // the red banner breaks the HUD look
      theme: AppTheme.build(_palette),
      // Repositories are passed by constructor down to AppShell, which hands
      // each screen only what it needs. Still no DI package: one hop is not
      // worth the indirection, and the shell is the only place that knows
      // about all of them.
      home: AppShell(
        questRepository: widget.questRepository,
        playerRepository: widget.playerRepository,
        activityRepository: widget.activityRepository,
        exportRepository: widget.exportRepository,
        workoutRepository: widget.workoutRepository,
        memoryRepository: widget.memoryRepository,
        aiLogRepository: widget.aiLogRepository,
        nutritionRepository: widget.nutritionRepository,
        progressRepository: widget.progressRepository,
        alertRepository: widget.alertRepository,
        healthRepository: widget.healthRepository,
        planRepository: widget.planRepository,
        reviewRepository: widget.reviewRepository,
        themeMode: _mode,
        onThemeModeChanged: _setMode,
      ),
    );
  }
}

/// Shown when the app cannot start at all, in place of a blank screen.
class _StartupFailureApp extends StatelessWidget {
  final Object error;

  const _StartupFailureApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SYSTEM OFFLINE',
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.danger,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
