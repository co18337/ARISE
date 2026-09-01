import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/export/export_repository.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// Exports the whole database as JSON, and reads one back.
///
/// Everything in this app lives on one phone with no server behind it, so
/// this screen is the only thing standing between a lost device and a lost
/// record.
///
/// SHARE IS THE REAL BACKUP and is listed first for that reason. "Save to
/// file" writes into the app's own documents directory, which Android deletes
/// when the app is uninstalled — protection against every accident except the
/// one people actually have. The share sheet is the only route to somewhere
/// that outlives the app. The clipboard stays because it is the only route
/// that works in a browser.
///
/// RESTORE reads the JSON back and is deliberately awkward: it inspects the
/// file, says what it is about to overwrite, and waits to be told again. It
/// replaces rather than merges — see ExportRepository.restore.
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

  /// Set while a restore is running so the buttons cannot be pressed twice
  /// against a database mid-transaction.
  bool _busy = false;

  Future<void> _share(Backup backup) async {
    setState(() => _busy = true);
    try {
      final shared = await widget.exportRepository.share(backup.json);
      _report(
        shared
            ? 'Backup sent. Keep it somewhere that is not this phone.'
            : 'Nothing was chosen, so nothing was saved.',
        failed: !shared,
      );
    } catch (error) {
      _report('Could not share the backup: $error', failed: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final json = await showDialog<String>(
      context: context,
      builder: (_) => const _PasteBackupDialog(),
    );
    if (json == null || !mounted) return;

    // Inspected BEFORE anything is touched, so a file from a newer build or a
    // different app is refused while the current record is still intact.
    final plan = widget.exportRepository.inspect(json);
    if (!plan.isValid) {
      _report(plan.problem!, failed: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmRestoreDialog(plan: plan),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final rows = await widget.exportRepository.restore(plan);
      _report('Restored $rows rows. Close and reopen the app.');
    } catch (error) {
      _report('The restore failed and nothing was changed: $error',
          failed: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
        // Said outright, because a file that dies with the app is not a
        // backup and it should not be believed to be one.
        _report(
          'Saved to $path — but uninstalling the app deletes this. '
          'Use SHARE for a copy that lasts.',
        );
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
            HudSectionTitle('BACKUP'),
            const SizedBox(height: 18),
            if (backup == null)
              SystemPanel(
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
                  label: 'Share backup',
                  icon: Icons.ios_share,
                  colors: [AppColors.accentGold, AppColors.accentMagenta],
                  onPressed: _busy ? null : () => _share(backup),
                ),
              ),
              const SizedBox(height: 10),
              HudEntrance(
                index: 3,
                child: GradientButton(
                  label: 'Copy JSON',
                  icon: Icons.content_copy,
                  onPressed: _busy ? null : () => _copy(backup),
                ),
              ),
              const SizedBox(height: 10),
              HudEntrance(
                index: 4,
                child: GradientButton(
                  label: 'Save on this phone',
                  icon: Icons.save_alt,
                  onPressed: _busy ? null : () => _save(backup),
                ),
              ),
              const SizedBox(height: 22),
              HudSectionTitle('RESTORE', accent: AppColors.danger),
              const SizedBox(height: 14),
              HudEntrance(index: 5, child: _RestorePanel(
                busy: _busy,
                onRestore: _restore,
              )),
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
        StatRow('Training sessions', '${summary.sessions}'),
        // Named plainly: these are the rows a lost phone costs six months of.
        StatRow('Body scans', '${summary.scans}',
            valueColor: summary.scans > 0 ? AppColors.accentGold : null),
        StatRow('Lab results', '${summary.labs}'),
        StatRow('Memory documents', '${summary.documents}'),
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


/// The restore control, with the warning attached rather than hidden behind
/// the button.
class _RestorePanel extends StatelessWidget {
  final bool busy;
  final VoidCallback onRestore;

  const _RestorePanel({required this.busy, required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Restore from a backup',
      accent: AppColors.danger,
      glow: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste the contents of a backup file. This REPLACES everything '
            'currently in the app — quests, training, scans, memory. It does '
            'not merge.',
            style: AppTextStyles.body.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: 'Paste a backup',
            icon: Icons.settings_backup_restore,
            colors: [AppColors.danger, AppColors.accentMagenta],
            onPressed: busy ? null : onRestore,
          ),
        ],
      ),
    );
  }
}

/// Paste rather than a file picker.
///
/// A picker means another platform dependency and another permission for
/// something done perhaps twice in the app's life. The share sheet already
/// put the JSON somewhere it can be opened and copied, and the clipboard route
/// works in a browser too.
class _PasteBackupDialog extends StatefulWidget {
  const _PasteBackupDialog();

  @override
  State<_PasteBackupDialog> createState() => _PasteBackupDialogState();
}

class _PasteBackupDialogState extends State<_PasteBackupDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) _controller.text = data!.text!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('PASTE BACKUP', style: AppTextStyles.panelTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              style: TextStyle(
                fontFamily: AppFonts.mono,
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              decoration: InputDecoration(
                hintText: '{"app":"The System", ...',
                hintStyle: AppTextStyles.body.copyWith(
                  fontSize: 11,
                  color: AppColors.textDim,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _pasteFromClipboard,
              icon: const Icon(Icons.content_paste, size: 16),
              label: const Text('Paste from clipboard'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(_controller.text.trim()),
          child: Text('CONTINUE',
              style: TextStyle(color: AppColors.accentGold)),
        ),
      ],
    );
  }
}

/// The second ask, listing what the file actually holds.
///
/// A destructive action confirmed against a vague "are you sure?" is confirmed
/// against nothing. This one names the date and the row counts, so the wrong
/// backup can be spotted before it lands rather than after.
class _ConfirmRestoreDialog extends StatelessWidget {
  final RestorePlan plan;

  const _ConfirmRestoreDialog({required this.plan});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('REPLACE EVERYTHING?', style: AppTextStyles.panelTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.exportedAt != null)
            Text('Taken ${plan.exportedAt}',
                style: AppTextStyles.hudLabel.copyWith(fontSize: 10)),
          const SizedBox(height: 10),
          for (final line in [
            '${plan.quests} quests',
            '${plan.sessions} training sessions',
            '${plan.meals} meals logged',
            '${plan.scans} body scans',
            '${plan.labs} lab results',
            '${plan.documents} memory documents',
          ])
            Text('· $line', style: AppTextStyles.body.copyWith(fontSize: 12)),
          const SizedBox(height: 12),
          Text(
            'Everything now in the app is deleted first.',
            style: AppTextStyles.body
                .copyWith(fontSize: 12, color: AppColors.danger),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('RESTORE',
              style: TextStyle(color: AppColors.danger)),
        ),
      ],
    );
  }
}
