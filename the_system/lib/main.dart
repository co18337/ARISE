import 'package:flutter/material.dart';

import 'data/db/database.dart';
import 'data/export/export_repository.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/player_repository.dart';
import 'data/repositories/quest_repository.dart';
import 'screens/app_shell.dart';
import 'theme/theme.dart';

void main() {
  // Opening the database touches platform channels (to find the app's
  // documents directory), so the Flutter binding has to be initialised first.
  WidgetsFlutterBinding.ensureInitialized();

  // Anything thrown here happens BEFORE the first frame, so without this
  // catch the app renders nothing at all — a blank white page with no error
  // anywhere on screen. Showing the failure instead makes startup bugs
  // debuggable without opening the browser console.
  try {
    final database = AppDatabase();
    runApp(
      MyApp(
        questRepository: QuestRepository(database),
        playerRepository: PlayerRepository(database),
        activityRepository: ActivityRepository(database),
        exportRepository: ExportRepository(database),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('The System failed to start: $error\n$stackTrace');
    runApp(_StartupFailureApp(error: error));
  }
}

class MyApp extends StatelessWidget {
  final QuestRepository questRepository;
  final PlayerRepository playerRepository;
  final ActivityRepository activityRepository;
  final ExportRepository exportRepository;

  const MyApp({
    super.key,
    required this.questRepository,
    required this.playerRepository,
    required this.activityRepository,
    required this.exportRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The System',
      debugShowCheckedModeBanner: false, // the red banner breaks the HUD look
      theme: AppTheme.dark,
      // Repositories are passed by constructor down to AppShell, which hands
      // each screen only what it needs. Still no DI package: one hop is not
      // worth the indirection, and the shell is the only place that knows
      // about all three.
      home: AppShell(
        questRepository: questRepository,
        playerRepository: playerRepository,
        activityRepository: activityRepository,
        exportRepository: exportRepository,
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
