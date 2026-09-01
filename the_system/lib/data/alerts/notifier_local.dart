import 'dart:io' show Platform;

import 'package:flutter/material.dart' show Color;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../game/game.dart';
import 'notifier.dart';

Notifier createNotifier() =>
    Platform.isAndroid ? LocalNotifier() : NoopNotifier();

/// Posts the routine's alerts through flutter_local_notifications.
///
/// UNVERIFIED ON A DEVICE at the time of writing. Everything above this file
/// is pure and tested; this is the part that can only be proven by installing
/// it on the G34 and waiting for 5:30. It is written defensively for that
/// reason — every platform call is guarded, and a failure degrades to "no
/// notifications" rather than taking the app down with it.
class LocalNotifier implements Notifier {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotifier({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool _ready = false;
  String? _lastError;

  /// TWO channels, not one, and the split is the whole point.
  ///
  /// The wake alarm has to sound through a silenced phone and show over the
  /// lock screen; a reminder to drink water must not. Android fixes a
  /// channel's importance at creation and the user owns it afterwards, so
  /// putting both on one channel would mean either a shouting water reminder
  /// or a wake alarm you sleep through.
  /// The id carries a VERSION, and that is not decoration. An Android
  /// notification channel is IMMUTABLE once created — importance, sound and
  /// audio usage are fixed at creation and owned by the user from then on, so
  /// changing them in code does nothing at all on a phone that already has the
  /// channel. Shipping a corrected channel means shipping a new id.
  ///
  /// v1: usage=NOTIFICATION, so it played at notification volume.
  /// v2: usage fixed, but the SOUND was still the default notification tone —
  ///     the alarm rang with the notification chime. Heard on the G34.
  /// v3: the alarm tone as well.
  static const AndroidNotificationChannel _wakeChannel =
      AndroidNotificationChannel(
        'system_wake_v3',
        'Wake alarm',
        description: 'The 5:30 wake buzzer.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        // TWO SEPARATE THINGS, and getting one right is not enough.
        //
        // audioAttributesUsage decides which VOLUME SLIDER governs the sound —
        // alarm rather than notification, so it is audible on a phone set up
        // for sleeping.
        //
        // `sound` decides WHAT ACTUALLY PLAYS. Without it the channel keeps
        // the default notification tone, which is what v2 did: an alarm at
        // alarm volume playing the notification chime. This URI is Android's
        // standard default-alarm setting, so it follows whatever alarm tone
        // the phone is set to rather than shipping one.
        audioAttributesUsage: AudioAttributesUsage.alarm,
        sound: UriAndroidNotificationSound(
          'content://settings/system/alarm_alert',
        ),
        // Asked for, not assumed. Bypassing Do Not Disturb additionally needs
        // Do Not Disturb ACCESS, which is a separate toggle only the user can
        // grant in Settings; without it Android ignores this flag rather than
        // failing, so the description above no longer promises what it cannot
        // deliver.
        bypassDnd: true,
      );

  /// Channel ids that have been superseded.
  ///
  /// Deleted on start-up, or Android keeps showing every retired version in
  /// the app's notification settings — three entries called "Wake alarm", two
  /// of which do nothing.
  static const List<String> _retiredChannels = [
    'system_wake',
    'system_wake_v2',
  ];

  static const AndroidNotificationChannel _questChannel =
      AndroidNotificationChannel(
        'system_quests',
        'Quest reminders',
        description: 'Steps opening, and windows about to close.',
        importance: Importance.defaultImportance,
        playSound: true,
      );

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> initialise() async {
    if (_ready) return;
    try {
      // The plugin schedules in a named time zone, not in UTC and not in
      // "device local" — so the database has to be loaded first or every
      // zonedSchedule throws.
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(await _deviceTimeZone()));

      await _plugin.initialize(
        settings: const InitializationSettings(
          // A dedicated SILHOUETTE, not the launcher icon. Android repaints
          // every opaque pixel of this white and drops the rest, so a full
          // colour icon arrives in the status bar as a grey square.
          android: AndroidInitializationSettings('@drawable/ic_notification'),
        ),
      );

      final android = _android;
      for (final id in _retiredChannels) {
        await android?.deleteNotificationChannel(channelId: id);
      }
      await android?.createNotificationChannel(_wakeChannel);
      await android?.createNotificationChannel(_questChannel);

      _ready = true;
      _lastError = null;
    } catch (error) {
      // Never fatal. A phone that will not take notifications is still a phone
      // that runs the app — but this is NOT harmless, and it was invisible for
      // a day: initialise() failing means schedule() returns early and Android
      // holds no alarms at all, while the app looks perfectly healthy. The
      // ALERTS screen surfaces this string for exactly that reason, and it is
      // where to look first when nothing arrives.
      _lastError = '$error';
      debugPrint('[alerts] initialise failed: $error');
    }
  }

  /// The device's zone name, falling back to Asia/Kolkata.
  ///
  /// A fallback rather than a throw: getting the zone wrong shifts alerts by
  /// hours, but failing to schedule at all is worse, and this app has exactly
  /// one user in one time zone.
  Future<String> _deviceTimeZone() async {
    try {
      final name = DateTime.now().timeZoneName;
      // Abbreviations like "IST" are not zone database names; only trust an
      // Area/Location form.
      if (name.contains('/')) return name;
    } catch (_) {
      // fall through
    }
    return 'Asia/Kolkata';
  }

  @override
  Future<NotifierStatus> status() async {
    await initialise();
    final android = _android;
    if (android == null) {
      return NotifierStatus(supported: false, error: _lastError);
    }
    try {
      final pending = await _plugin.pendingNotificationRequests();
      return NotifierStatus(
        supported: true,
        notificationsAllowed: await android.areNotificationsEnabled() ?? false,
        exactAlarmsAllowed: await android.canScheduleExactNotifications() ??
            false,
        scheduled: pending.length,
        error: _lastError,
      );
    } catch (error) {
      return NotifierStatus(supported: true, error: '$error');
    }
  }

  @override
  Future<NotifierStatus> requestPermissions() async {
    await initialise();
    final android = _android;
    if (android == null) return NotifierStatus.unsupported;
    try {
      await android.requestNotificationsPermission();
      // Android 14 gates exact alarms behind a separate trip to Settings.
      // Asking is all that can be done from here; the user decides.
      await android.requestExactAlarmsPermission();
    } catch (error) {
      _lastError = '$error';
      debugPrint('[alerts] permission request failed: $error');
    }
    return status();
  }

  @override
  Future<void> schedule(List<ScheduledAlert> alerts) async {
    await initialise();
    if (!_ready) return;

    await cancelAll();

    final exact = (await status()).exactAlarmsAllowed;
    for (final alert in alerts) {
      try {
        await _plugin.zonedSchedule(
          id: alert.id,
          title: alert.title,
          body: alert.body,
          scheduledDate: tz.TZDateTime.from(alert.at, tz.local),
          notificationDetails: _detailsFor(alert),
          // Exact where allowed and where it matters. Falling back to the
          // inexact mode rather than refusing: a water reminder that lands
          // within a few minutes is still a water reminder.
          androidScheduleMode: alert.kind.isAlarm && exact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle,
          payload: alert.templateId,
        );
      } catch (error) {
        // One bad alert must not take the rest of the day's schedule with it.
        debugPrint('[alerts] could not schedule ${alert.id}: $error');
      }
    }
    debugPrint('[alerts] scheduled ${alerts.length} (exact: $exact)');
  }

  NotificationDetails _detailsFor(ScheduledAlert alert) {
    final channel = alert.kind.isAlarm ? _wakeChannel : _questChannel;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: alert.kind.isAlarm ? Priority.max : Priority.defaultPriority,
        category: alert.kind.isAlarm
            ? AndroidNotificationCategory.alarm
            : AndroidNotificationCategory.reminder,
        // Full screen for the wake alarm only. It is the difference between
        // an alarm clock and a note you find at lunchtime.
        fullScreenIntent: alert.kind.isAlarm,
        // NOTHING IS STICKY. Every alert can be swiped away and dismisses
        // itself when tapped — an ongoing notification you cannot clear is
        // the fastest way to make somebody turn the whole thing off.
        ongoing: false,
        autoCancel: true,
        ticker: alert.kind.label,
        // Tints the silhouette rather than leaving it plain white — the app's
        // signature cyan, matching AppColors.primary.
        color: const Color(0xFF22D3EE),
      ),
    );
  }

  /// A real scheduled alarm, a couple of minutes out.
  ///
  /// Deliberately identical to how the 5:30 buzzer is booked — wake channel,
  /// exact mode, AlarmManager — because the point is to exercise that path
  /// rather than a cheaper one that happens to look the same on screen.
  ///
  /// Uses a fixed id so repeated taps replace rather than stack. Note that
  /// rescheduling the day calls cancelAll and will take this with it; that is
  /// the honest behaviour rather than a special case carved out for a test.
  @override
  Future<void> fireTestIn(Duration delay) async {
    await initialise();
    final at = tz.TZDateTime.now(tz.local).add(delay);
    try {
      await _plugin.zonedSchedule(
        id: _testAlarmId,
        title: 'THE SYSTEM',
        body: 'Scheduled alarm fired. This is the path the 5:30 buzzer uses.',
        scheduledDate: at,
        notificationDetails: _detailsFor(
          ScheduledAlert(
            id: _testAlarmId,
            kind: AlertKind.wake,
            at: at,
            title: '',
            body: '',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('[alerts] test alarm booked for $at');
    } catch (error) {
      debugPrint('[alerts] test alarm failed: $error');
    }
  }

  /// Outside the planner's range in practice — its ids are FNV hashes, which
  /// do not land on small integers.
  static const int _testAlarmId = 7;

  @override
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (error) {
      debugPrint('[alerts] cancelAll failed: $error');
    }
  }

  @override
  Future<void> fireTest() async {
    await initialise();
    try {
      await _plugin.show(
        id: 0,
        title: 'THE SYSTEM',
        body:
            'Notifications are working. This is what a quest reminder looks '
            'like.',
        notificationDetails: _detailsFor(
          ScheduledAlert(
            id: 0,
            kind: AlertKind.stepDue,
            at: DateTime.now(),
            title: '',
            body: '',
          ),
        ),
      );
    } catch (error) {
      debugPrint('[alerts] test notification failed: $error');
    }
  }
}
