import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'data/db/database.dart';
import 'data/exercise_guides.dart';
import 'data/export/export_repository.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/player_repository.dart';
import 'data/repositories/quest_repository.dart';
import 'data/memory/memory_repository.dart';
import 'data/memory/memory_trainer.dart';
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
    final memory = MemoryRepository(database);
    runApp(
      MyApp(
        questRepository: QuestRepository(database),
        playerRepository: PlayerRepository(database),
        activityRepository: ActivityRepository(database),
        exportRepository: ExportRepository(database),
        workoutRepository: WorkoutRepository(
          database,
          advisor: MemoryTrainerAdvisor(memory: memory),
          memory: memory,
        ),
        memoryRepository: memory,
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.initialThemeMode == null) _loadSavedMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadSavedMode() async {
    final saved = await widget.playerRepository.readThemeMode();
    if (mounted && saved != _mode) setState(() => _mode = saved);
  }

  @override
  void didChangePlatformBrightness() {
    // Only AUTO cares, but rebuilding either way is a single frame and keeps
    // the condition out of a lifecycle callback.
    if (mounted) setState(() {});
  }

  void _setMode(AppThemeMode mode) {
    setState(() => _mode = mode);
    // Fire and forget: the UI has already changed, and a failed write costs
    // nothing worse than the app opening in the previous theme next time.
    widget.playerRepository.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final platform = MediaQuery.platformBrightnessOf(context);

    return MaterialApp(
      title: 'The System',
      debugShowCheckedModeBanner: false, // the red banner breaks the HUD look
      theme: AppTheme.build(AppTheme.paletteFor(_mode, platform)),
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
