import 'package:flutter/material.dart';

import '../data/alerts/notifier.dart';
import '../data/repositories/alert_repository.dart';
import '../game/game.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';
import 'day_rollover.dart';

/// ALERTS — what the phone will say, and whether it is allowed to.
///
/// This screen exists because notifications are the one part of the app that
/// cannot be proven on this machine. Everything else is testable; whether
/// Android actually fires an alarm at 5:30 is only answerable by installing it
/// and waiting. So the screen reports exactly what it knows — which grants are
/// held, how many alerts the OS is holding, and the real times of today's —
/// and offers a test notification, so "is this thing on" has an answer that
/// does not involve going to bed.
class AlertsScreen extends StatefulWidget {
  final AlertRepository alertRepository;

  const AlertsScreen({super.key, required this.alertRepository});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen>
    with WidgetsBindingObserver, DayRollover<AlertsScreen> {
  late DateTime _today;
  late Future<(NotifierStatus, List<ScheduledAlert>)> _view;

  String? _message;
  bool _busy = false;

  @override
  Clock get rolloverClock => widget.alertRepository.clock;

  @override
  DateTime get shownDay => _today;

  @override
  void openDay() {
    _today = widget.alertRepository.clock.now();
    _view = _read();
  }

  Future<(NotifierStatus, List<ScheduledAlert>)> _read() async => (
    await widget.alertRepository.status(),
    await widget.alertRepository.planAhead(),
  );

  void _refresh() => setState(() => _view = _read());

  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
      if (mounted) setState(() => _message = done);
    } catch (error) {
      if (mounted) setState(() => _message = '$error');
    } finally {
      if (mounted) setState(() => _busy = false);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(NotifierStatus, List<ScheduledAlert>)>(
      future: _view,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            HudSectionTitle('ALERTS'),
            const SizedBox(height: 18),
            if (data == null)
              SystemPanel(
                child: Text('Reading…', style: AppTextStyles.body),
              )
            else ...[
              HudEntrance(index: 0, child: _StatePanel(status: data.$1)),
              const SizedBox(height: 12),
              HudEntrance(index: 1, child: _Controls(
                status: data.$1,
                busy: _busy,
                onRequest: () => _run(
                  widget.alertRepository.requestPermissions,
                  'Asked. Whatever Android showed you, the answer is above.',
                ),
                onTest: () => _run(
                  widget.alertRepository.fireTest,
                  'Sent. It should be in your tray now — that proves the '
                      'permission and the channel.',
                ),
                onTestAlarm: () => _run(
                  () => widget.alertRepository.fireTestIn(
                    const Duration(minutes: 2),
                  ),
                  'Booked for two minutes from now. Lock the phone and put it '
                      'down — this is the path the 5:30 alarm uses.',
                ),
                onReschedule: () => _run(
                  widget.alertRepository.reschedule,
                  'Rescheduled from today\'s routine.',
                ),
              )),
              if (_message != null) ...[
                const SizedBox(height: 10),
                Text(
                  _message!,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              HudEntrance(index: 2, child: _Planned(alerts: data.$2)),
            ],
          ],
        );
      },
    );
  }
}

class _StatePanel extends StatelessWidget {
  final NotifierStatus status;

  const _StatePanel({required this.status});

  @override
  Widget build(BuildContext context) {
    final ok = status.canWakeReliably;
    return StatListPanel(
      title: 'PERMISSION',
      accent: ok ? AppColors.primary : AppColors.accentGold,
      rows: [
        StatRow(
          'State',
          status.summary,
          valueColor: ok ? AppColors.primary : AppColors.accentGold,
        ),
        StatRow('Platform support', status.supported ? 'yes' : 'no'),
        StatRow('Notifications', status.notificationsAllowed ? 'on' : 'off'),
        // Named separately because it fails differently: without it alerts
        // still arrive, they just drift — fine for water, useless for 5:30.
        StatRow('Exact alarms', status.exactAlarmsAllowed ? 'on' : 'off'),
        StatRow('Held by Android', '${status.scheduled}'),
        if (status.error != null) StatRow('Last error', status.error!),
      ],
    );
  }
}

class _Controls extends StatelessWidget {
  final NotifierStatus status;
  final bool busy;
  final VoidCallback onRequest;
  final VoidCallback onTest;
  final VoidCallback onTestAlarm;
  final VoidCallback onReschedule;

  const _Controls({
    required this.status,
    required this.busy,
    required this.onRequest,
    required this.onTest,
    required this.onTestAlarm,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'CONTROLS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!status.supported)
            Text(
              'This build cannot post notifications — you are running in a '
              'browser. Install the APK on the phone to test them.',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )
          else ...[
            GradientButton(
              label: 'Grant permission',
              icon: Icons.lock_open,
              onPressed: busy ? null : onRequest,
            ),
            const SizedBox(height: 10),
            GradientButton(
              label: 'Send a test now',
              icon: Icons.notifications_active_outlined,
              onPressed: busy ? null : onTest,
            ),
            const SizedBox(height: 10),
            GradientButton(
              label: 'Test the alarm in 2 min',
              icon: Icons.alarm,
              onPressed: busy ? null : onTestAlarm,
            ),
            const SizedBox(height: 10),
            GradientButton(
              label: 'Reschedule today',
              icon: Icons.refresh,
              onPressed: busy ? null : onReschedule,
            ),
            const SizedBox(height: 12),
            Text(
              'If alerts arrive late or not at all after the phone has been '
              'idle, the cause is battery optimisation rather than these '
              'permissions. No API reports that reliably — it has to be '
              'switched off for The System in Android settings.',
              style: AppTextStyles.body.copyWith(
                fontSize: 11,
                height: 1.4,
                color: AppColors.textDim,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The real times, not a promise that something will happen.
class _Planned extends StatelessWidget {
  final List<ScheduledAlert> alerts;

  const _Planned({required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return SystemPanel(
        title: 'SCHEDULED',
        child: Text(
          'Nothing left today — every step is either answered or behind you. '
          'Alerts for a step you have already done are never scheduled.',
          style: AppTextStyles.body,
        ),
      );
    }

    return SystemPanel(
      title: 'SCHEDULED',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final alert in alerts) _AlertRow(alert: alert),
          const SizedBox(height: 8),
          Text(
            'Derived from today\'s routine, so they cannot disagree with it. '
            'Answer a step and its alert disappears.',
            style: AppTextStyles.body.copyWith(
              fontSize: 11,
              height: 1.4,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final ScheduledAlert alert;

  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final accent = alert.kind.isAlarm
        ? AppColors.accentGold
        : alert.kind == AlertKind.stepClosing
        ? AppColors.danger
        : AppColors.primary;

    final hh = alert.at.hour.toString().padLeft(2, '0');
    final mm = alert.at.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              '$hh:$mm',
              style: AppTextStyles.readout.copyWith(fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          // Expanded, not fixed: a long step title at a large system font is
          // how this row overflows on a 360dp phone.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.kind.label,
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 9,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.body,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
