import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:health/health.dart';

import 'health_source.dart';

HealthSource createHealthSource() =>
    Platform.isAndroid ? HealthConnectSource() : NoopHealthSource();

/// Reads daily totals out of Health Connect.
///
/// UNVERIFIED ON A DEVICE at the time of writing, like the notifier before it.
/// Written defensively for that reason: every platform call is guarded and a
/// failure degrades to "nothing synced" rather than taking the app down. The
/// System has always worked by hand and must continue to.
///
/// READ-ONLY. Nothing is ever written back to Health Connect.
class HealthConnectSource implements HealthSource {
  final Health _health;

  HealthConnectSource({Health? health}) : _health = health ?? Health();

  bool _configured = false;
  String? _lastError;

  /// Exactly what is asked for, and no more.
  ///
  /// Health Connect shows the user this list verbatim when it asks for
  /// permission, so every extra type is something else to justify. Weight and
  /// body fat are deliberately ABSENT: those come from the Tanita scale by
  /// hand, and a second source for the same figure is how two numbers start
  /// disagreeing about what you weigh.
  static const List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.WORKOUT,
  ];

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    try {
      await _health.configure();
      _configured = true;
    } catch (error) {
      _lastError = '$error';
      debugPrint('[health] configure failed: $error');
    }
  }

  @override
  Future<HealthStatus> status() async {
    await _ensureConfigured();
    try {
      final sdk = await _health.getHealthConnectSdkStatus();
      final available =
          sdk == HealthConnectSdkStatus.sdkAvailable;
      if (!available) {
        // Not an error — Health Connect ships with Android 14+ but can be
        // disabled, and on older phones it is a separate Play install.
        return HealthStatus(
          supported: true,
          available: false,
          error: _lastError,
        );
      }
      return HealthStatus(
        supported: true,
        available: true,
        authorised: await _health.hasPermissions(_types) ?? false,
        error: _lastError,
      );
    } catch (error) {
      return HealthStatus(supported: true, error: '$error');
    }
  }

  @override
  Future<HealthStatus> requestPermissions() async {
    await _ensureConfigured();
    try {
      await _health.requestAuthorization(_types);
    } catch (error) {
      _lastError = '$error';
      debugPrint('[health] permission request failed: $error');
    }
    return status();
  }

  @override
  Future<List<HealthDay>> readDays({required int days}) async {
    await _ensureConfigured();
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1));

    List<HealthDataPoint> points;
    try {
      points = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: start,
        endTime: now,
      );
    } catch (error) {
      debugPrint('[health] read failed: $error');
      return const [];
    }

    // Bucket by local day. Health Connect returns raw samples — a step count
    // every few minutes — and the app only ever draws daily totals, so the
    // folding happens here rather than storing thousands of rows.
    final steps = <int, num>{};
    final sleep = <int, num>{};
    final active = <int, num>{};
    final distance = <int, num>{};
    final workout = <int, num>{};
    final restingHr = <int, List<num>>{};

    for (final point in points) {
      final value = point.value;
      if (value is! NumericHealthValue) continue;
      final n = value.numericValue;
      final key = _dayIndex(point.dateFrom);

      switch (point.type) {
        case HealthDataType.STEPS:
          steps[key] = (steps[key] ?? 0) + n;
        case HealthDataType.SLEEP_ASLEEP:
          sleep[key] = (sleep[key] ?? 0) + n;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          active[key] = (active[key] ?? 0) + n;
        case HealthDataType.DISTANCE_DELTA:
          distance[key] = (distance[key] ?? 0) + n;
        case HealthDataType.WORKOUT:
          workout[key] = (workout[key] ?? 0) +
              point.dateTo.difference(point.dateFrom).inMinutes;
        case HealthDataType.RESTING_HEART_RATE:
          // AVERAGED, not summed — the one figure here that is a measurement
          // rather than a total. Summing it would produce a heart rate in the
          // thousands, which is the kind of bug that looks like data.
          restingHr.putIfAbsent(key, () => []).add(n);
        default:
          break;
      }
    }

    final result = <HealthDay>[];
    for (var i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      final key = _dayIndex(date);
      final hr = restingHr[key];

      final day = HealthDay(
        date: date,
        steps: steps[key]?.round(),
        sleepMinutes: sleep[key]?.round(),
        restingHeartRate: hr == null || hr.isEmpty
            ? null
            : (hr.reduce((a, b) => a + b) / hr.length).round(),
        activeKcal: active[key]?.round(),
        distanceM: distance[key]?.round(),
        workoutMinutes: workout[key]?.round(),
      );

      // Omitted, not zeroed. A day the phone was off is not a day of no
      // steps, and drawing zeros for it is a chart that lies.
      if (!day.isEmpty) result.add(day);
    }
    return result;
  }

  /// Days since the epoch in LOCAL time, so a sample at 00:30 belongs to the
  /// day you were awake for rather than to UTC's idea of it.
  static int _dayIndex(DateTime t) =>
      DateTime(t.year, t.month, t.day).millisecondsSinceEpoch ~/ 86400000;
}
