import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/screens/today_screen.dart';

/// Opening the day is a SEQUENCE and the order is load-bearing.
///
/// openToday closes every step whose window has already shut, and
/// HealthRepository only ever completes a quest still PENDING — deliberately,
/// so that a sensor can never fail your day. Together those rules mean a run
/// recorded at seven that reaches the database one minute after the window
/// closed is worth nothing.
///
/// This shipped wrong: the health sync was fired unawaited alongside the day,
/// and the local database won the race every time.
void main() {
  test('the sensors are read, and FINISH, before the day is opened', () async {
    final order = <String>[];
    final sensors = Completer<void>();

    final sequence = openDaySequence(
      beforeOpen: () async {
        order.add('sensors read');
        // Holding the read open is what proves the day WAITS for it rather
        // than merely starting second.
        await sensors.future;
        order.add('sensors stored');
      },
      open: () async => order.add('day opened'),
      afterOpen: () async => order.add('alerts armed'),
    );

    // THE REGRESSION CHECK: while the read is in flight, nothing has judged
    // the day. Fire the sync unawaited again and this line fails.
    await pumpEventQueue();
    expect(order, ['sensors read']);

    sensors.complete();
    await sequence;

    expect(order, [
      'sensors read',
      'sensors stored',
      'day opened',
      'alerts armed',
    ]);
  });

  test('a day with no sensors and no alerts still opens', () async {
    final order = <String>[];
    await openDaySequence(open: () async => order.add('day opened'));
    expect(order, ['day opened']);
  });
}
