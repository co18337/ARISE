import '../models/models.dart';

/// The seed task catalog: the actual transformation plan, expressed as data.
///
/// This is the FIRST-RUN seed only. From the first launch onward the database
/// is the source of truth, so editing a template in-app won't be overwritten
/// on the next start.
///
/// The list is kept in **routine order** (earliest scheduled time first),
/// because the seeding code turns the list position into `sortOrder`, and the
/// routine screen walks the day in exactly that order. Times are minutes after
/// local midnight — see [TaskTemplate.scheduledMinutes].
class TaskCatalog {
  TaskCatalog._(); // not meant to be instantiated — just a namespace for `all`

  /// Handy shorthand so the timings below read as times, not arithmetic.
  static int _at(int hour, int minute) => hour * 60 + minute;

  static final List<TaskTemplate> all = [
    TaskTemplate(
      id: 'detox_drink',
      title: 'Detox drink',
      category: TaskCategory.diet,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 5,
      scheduledMinutes: _at(5, 35),
      // Short window on purpose: a detox drink at noon isn't the same habit.
      graceMinutes: 45,
    ),
    TaskTemplate(
      id: 'workout_of_the_day',
      title: 'Workout of the day',
      category: TaskCategory.workout,
      stat: StatType.str,
      schedule: ScheduleType.daily,
      xp: 20,
      scheduledMinutes: _at(5, 55),
      graceMinutes: 150,
    ),
    TaskTemplate(
      id: 'morning_skincare',
      title: 'Morning skincare',
      category: TaskCategory.skincareAM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
      scheduledMinutes: _at(7, 10),
      graceMinutes: 90,
    ),
    TaskTemplate(
      id: 'sunscreen',
      title: 'Sunscreen',
      category: TaskCategory.skincareAM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 5,
      scheduledMinutes: _at(7, 25),
      graceMinutes: 120,
    ),
    TaskTemplate(
      id: 'saturday_full_care_day',
      title: 'Saturday full care day',
      category: TaskCategory.grooming,
      stat: StatType.rec,
      schedule: ScheduleType.weekly,
      daysOfWeek: const [6], // 6 = Saturday (DateTime.weekday: 1=Mon..7=Sun)
      xp: 30,
      scheduledMinutes: _at(10, 0),
      // A whole-morning ritual, so the window is a whole morning.
      graceMinutes: 480,
    ),
    TaskTemplate(
      id: 'lip_balm_reminder',
      title: 'Lip balm reminder',
      category: TaskCategory.grooming,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 3,
      scheduledMinutes: _at(13, 0),
      graceMinutes: 300,
    ),
    TaskTemplate(
      id: 'drink_3l_water',
      title: 'Drink 3L water',
      category: TaskCategory.hydration,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
      // Scheduled late because it's a whole-day target you can only honestly
      // answer in the evening — an early slot would block the rest of the day
      // behind a question you can't yet answer.
      scheduledMinutes: _at(20, 0),
      graceMinutes: 180,
    ),
    TaskTemplate(
      id: 'finish_dinner_by_9pm',
      title: 'Finish dinner by 9pm',
      category: TaskCategory.diet,
      stat: StatType.dis,
      schedule: ScheduleType.daily,
      xp: 10,
      scheduledMinutes: _at(21, 0),
      graceMinutes: 60,
    ),
    TaskTemplate(
      id: 'night_skincare',
      title: 'Night skincare',
      category: TaskCategory.skincarePM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
      scheduledMinutes: _at(22, 30),
      graceMinutes: 60,
    ),
    TaskTemplate(
      id: 'sleep_by_11pm',
      title: 'Sleep by 11pm',
      category: TaskCategory.sleep,
      stat: StatType.dis,
      schedule: ScheduleType.daily,
      xp: 15,
      scheduledMinutes: _at(23, 0),
      // Stops five minutes before midnight: the window must shut inside the
      // day it belongs to, or the step outlives the day that issued it.
      graceMinutes: 55,
    ),
  ];

  /// Lookup by id, used by the schema migration to backfill timings onto rows
  /// that were seeded before the routine existed.
  static TaskTemplate? byId(String id) {
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }
}
