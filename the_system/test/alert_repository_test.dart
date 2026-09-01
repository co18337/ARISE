import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/alerts/notifier.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/alert_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// The reconciliation half of Phase 9, with the operating system stood in for.
///
/// NoopNotifier records what it was asked to do, so everything except "does
/// Android actually fire it" is provable here — which is most of what can go
/// wrong.
void main() {
  late AppDatabase db;
  late NoopNotifier notifier;
  late AlertRepository alerts;
  late QuestRepository quests;

  // Early enough that the whole day is still ahead of us.
  final clock = FixedClock.todayAt(4, 0);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    quests = QuestRepository(db, clock: clock);
    await quests.materialiseDay(clock.now());
    notifier = NoopNotifier();
    alerts = AlertRepository(
      quests: quests,
      notifier: notifier,
      clock: clock,
    );
  });

  tearDown(() async => db.close());

  test('the day plans a wake alarm and a reminder for every timed step',
      () async {
    final planned = await alerts.planAhead();

    // A week of wake alarms, not one — see the evening test below for why.
    expect(planned.where((a) => a.kind == AlertKind.wake), hasLength(7));
    expect(planned.where((a) => a.kind == AlertKind.stepDue), isNotEmpty);
    // Real titles from the real catalog, not placeholders.
    expect(
      planned.map((a) => a.body).join(' '),
      contains('Detox drink'),
    );
  });

  test('rescheduling hands the OS exactly the plan', () async {
    await alerts.reschedule();

    expect(notifier.lastScheduled, await alerts.planAhead());
    expect(notifier.lastScheduled, isNotEmpty);
  });

  test('answering a step takes its alerts away', () async {
    await alerts.reschedule();
    final before = notifier.lastScheduled.length;

    final today = await quests.watchDay(clock.now()).first;
    final detox =
        today.firstWhere((q) => q.template.id == 'detox_drink');
    await quests.setStatus(detox, QuestStatus.done);
    await alerts.reschedule();

    expect(notifier.lastScheduled.length, lessThan(before));
    expect(
      notifier.lastScheduled.map((a) => a.templateId),
      isNot(contains('detox_drink')),
      reason: 'a step you have done must stop nagging you',
    );
  });

  test('rescheduling twice does not duplicate anything', () async {
    // Stable ids are what make this safe to call on every answer.
    await alerts.reschedule();
    final first = [...notifier.lastScheduled];
    await alerts.reschedule();

    expect(notifier.lastScheduled, first);
    expect(
      notifier.lastScheduled.map((a) => a.id).toSet(),
      hasLength(notifier.lastScheduled.length),
    );
  });

  test('disabling clears the phone and stops planning', () async {
    await alerts.reschedule();
    expect(notifier.lastScheduled, isNotEmpty);

    await alerts.disable();
    expect(notifier.lastScheduled, isEmpty);
    expect(notifier.cancelCount, greaterThan(0));

    // And it stays cleared while disabled.
    await alerts.reschedule();
    expect(notifier.lastScheduled, isEmpty);

    await alerts.enable();
    expect(notifier.lastScheduled, isNotEmpty);
  });

  test('a notifier that throws cannot break opening the day', () async {
    // reschedule() is called by openToday and by every answer. If a refused
    // permission could throw here, the routine would stop working.
    final broken = AlertRepository(
      quests: quests,
      notifier: _BrokenNotifier(),
      clock: clock,
    );

    await expectLater(broken.reschedule(), completes);
  });

  test('tomorrow\'s wake alarm is scheduled tonight', () async {
    // The bug this exists for, caught on the G34 at 18:54: the app only ever
    // scheduled TODAY, so opening it in the evening left nothing for the
    // morning. The 5:30 alarm could then only fire on a day you had already
    // opened the app before 5:30 — which is nobody.
    final evening = AlertRepository(
      quests: quests,
      notifier: notifier,
      clock: FixedClock.todayAt(18, 54),
    );

    final planned = await evening.planAhead();
    final wakes = planned.where((a) => a.kind == AlertKind.wake).toList();

    expect(wakes, isNotEmpty, reason: 'the morning must be armed');
    // A week of them, so the alarm survives a week of never opening the app.
    expect(wakes.length, greaterThanOrEqualTo(6));
    expect(wakes.first.at.hour, 5);
    expect(wakes.first.at.minute, 30);
    expect(
      wakes.first.at.isAfter(evening.clock.now()),
      isTrue,
      reason: 'today\'s 5:30 is long gone',
    );

    // And every one of them has its own id, or scheduling one cancels another.
    expect(wakes.map((a) => a.id).toSet(), hasLength(wakes.length));
  });

  test('evening reminders survive alongside the wake alarms', () async {
    // The other half of the same bug: step alerts still have to be planned,
    // and the ones later tonight are still ahead of us.
    final evening = AlertRepository(
      quests: quests,
      notifier: notifier,
      clock: FixedClock.todayAt(18, 54),
    );

    final planned = await evening.planAhead();
    expect(
      planned.where((a) => a.kind == AlertKind.stepDue),
      isNotEmpty,
      reason: 'sleep, dinner and night skincare are all still to come',
    );
  });

  test('the test notification goes straight through', () async {
    await alerts.fireTest();
    expect(notifier.testFireCount, 1);
  });

  test('the test ALARM goes through the scheduling path, not the quick one',
      () async {
    // The distinction the device exposed: show() proves the permission and
    // the channel, and nothing at all about whether Android will wake the app
    // in eight hours. Only the scheduled path answers that.
    await alerts.fireTestIn(const Duration(minutes: 2));
    expect(notifier.lastTestDelay, const Duration(minutes: 2));
  });
}

/// A phone that refuses everything, loudly.
class _BrokenNotifier implements Notifier {
  @override
  Future<void> cancelAll() async => throw StateError('no');

  @override
  Future<void> fireTest() async => throw StateError('no');

  @override
  Future<void> fireTestIn(Duration delay) async => throw StateError('no');

  @override
  Future<void> initialise() async => throw StateError('no');

  @override
  Future<NotifierStatus> requestPermissions() async => throw StateError('no');

  @override
  Future<void> schedule(List<ScheduledAlert> alerts) async =>
      throw StateError('no');

  @override
  Future<NotifierStatus> status() async => throw StateError('no');
}
