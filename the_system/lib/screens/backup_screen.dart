import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/export/export_repository.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// Exports the whole database as JSON — the manual backup.
///
/// Everything in this app lives on one phone with no server behind it, so
/// this screen is the only thing standing between a lost device and a lost
/// record. Two routes out, because neither works everywhere: the clipboard
/// works on every platform including the browser, and a file gets written on
/// the phone where the app actually lives.
class BackupScreen extends StatefulWidget {
  final ExportRepository exportRepository;

  const BackupScreen({super.key, required this.exportRepository});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  // Built once when the screen opens rather than on every button press: it
  // reads the whole database, and the figures shown must match the JSON the
  // buttons actually hand over.
  late final Future<Backup> _backup = widget.exportRepository.build();

  String? _message;
  bool _failed = false;

  void _report(String message, {bool failed = false}) {
    if (!mounted) return;
    setState(() {
      _message = message;
      _failed = failed;
    });
  }

  Future<void> _copy(Backup backup) async {
    await Clipboard.setData(ClipboardData(text: backup.json));
    _report('Copied ${backup.summary.sizeLabel} to the clipboard.');
  }

  Future<void> _save(Backup backup) async {
    try {
      final path = await widget.exportRepository.saveToFile(backup.json);
      if (path == null) {
        _report(
          'No file system here — running in a browser. Use COPY instead.',
          failed: true,
        );
      } else {
        _report('Saved to $path');
      }
    } catch (error) {
      _report('Could not write the file: $error', failed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Backup>(
      future: _backup,
      builder: (context, snapshot) {
        final backup = snapshot.data;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            const HudSectionTitle('BACKUP'),
            const SizedBox(height: 18),
            if (backup == null)
              const SystemPanel(
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              HudEntrance(index: 0, child: _Contents(summary: backup.summary)),
              const SizedBox(height: 14),
              HudEntrance(index: 1, child: _Preview(json: backup.json)),
              const SizedBox(height: 18),
              HudEntrance(
                index: 2,
                child: GradientButton(
                  label: 'Copy JSON',
                  icon: Icons.content_copy,
                  onPressed: () => _copy(backup),
                ),
              ),
              const SizedBox(height: 10),
              HudEntrance(
                index: 3,
                child: GradientButton(
                  label: 'Save to file',
                  icon: Icons.save_alt,
                  colors: [AppColors.accentGold, AppColors.accentMagenta],
                  onPressed: () => _save(backup),
                ),
              ),
            ],
            const SizedBox(height: 18),
            const _Credits(),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(
                _message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: _failed ? AppColors.danger : AppColors.remaining,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Attribution for the bundled emblem artwork.
///
/// CC BY 3.0 requires the credit to actually be visible to whoever uses the
/// app, which a line in a repo file is not. It also goes into
/// LicenseRegistry — see main.dart.
class _Credits extends StatelessWidget {
  const _Credits();

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Credits',
      glow: 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rank crests, stat emblems and achievement medals are from '
            'game-icons.net, by Lorc, Delapouite and sbed.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 8),
          Text(
            'Licensed CC BY 3.0 · creativecommons.org/licenses/by/3.0',
            style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

/// What's actually in the file, so the export isn't taken on faith.
class _Contents extends StatelessWidget {
  final BackupSummary summary;

  const _Contents({required this.summary});

  @override
  Widget build(BuildContext context) {
    return StatListPanel(
      title: 'Contents',
      accent: AppColors.accentGold,
      rows: [
        StatRow('Task templates', '${summary.templates}'),
        StatRow('Quests issued', '${summary.quests}'),
        StatRow('Days recorded', '${summary.days}'),
        StatRow('Log entries', '${summary.logEntries}'),
        StatRow('File size', summary.sizeLabel),
      ],
    );
  }
}

/// The first few lines of the file, in the mono face.
///
/// Purely so the export is visibly real text and not a black box — a backup
/// you have never seen the inside of is one you don't trust when you need it.
class _Preview extends StatelessWidget {
  final String json;

  const _Preview({required this.json});

  @override
  Widget build(BuildContext context) {
    final lines = json.split('\n').take(14).join('\n');

    return SystemPanel(
      title: 'Preview',
      glow: 0.18,
      child: SizedBox(
        height: 170,
        width: double.infinity,
        // Long JSON lines must scroll sideways inside the panel rather than
        // forcing the whole screen to.
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            lines,
            style: TextStyle(
              fontFamily: AppFonts.mono,
              fontSize: 11,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
