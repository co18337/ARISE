import '../models/models.dart';

/// The seed task catalog: the actual transformation plan, expressed as data.
///
/// This is v1's "database" — a hardcoded list. Later this moves into Drift
/// (SQLite) so the plan can be edited without shipping a new app build, but
/// the shape (a list of [TaskTemplate]) stays the same.
class TaskCatalog {
  TaskCatalog._(); // not meant to be instantiated — just a namespace for `all`

  static const List<TaskTemplate> all = [
    TaskTemplate(
      id: 'detox_drink',
      title: 'Detox drink',
      category: TaskCategory.diet,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 5,
    ),
    TaskTemplate(
      id: 'morning_skincare',
      title: 'Morning skincare',
      category: TaskCategory.skincareAM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
    ),
    TaskTemplate(
      id: 'sunscreen',
      title: 'Sunscreen',
      category: TaskCategory.skincareAM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 5,
    ),
    TaskTemplate(
      id: 'workout_of_the_day',
      title: 'Workout of the day',
      category: TaskCategory.workout,
      stat: StatType.str,
      schedule: ScheduleType.daily,
      xp: 20,
    ),
    TaskTemplate(
      id: 'lip_balm_reminder',
      title: 'Lip balm reminder',
      category: TaskCategory.grooming,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 3,
    ),
    TaskTemplate(
      id: 'drink_3l_water',
      title: 'Drink 3L water',
      category: TaskCategory.hydration,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
    ),
    TaskTemplate(
      id: 'finish_dinner_by_9pm',
      title: 'Finish dinner by 9pm',
      category: TaskCategory.diet,
      stat: StatType.dis,
      schedule: ScheduleType.daily,
      xp: 10,
    ),
    TaskTemplate(
      id: 'night_skincare',
      title: 'Night skincare',
      category: TaskCategory.skincarePM,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
    ),
    TaskTemplate(
      id: 'sleep_by_11pm',
      title: 'Sleep by 11pm',
      category: TaskCategory.sleep,
      stat: StatType.dis,
      schedule: ScheduleType.daily,
      xp: 15,
    ),
    TaskTemplate(
      id: 'saturday_full_care_day',
      title: 'Saturday full care day',
      category: TaskCategory.grooming,
      stat: StatType.rec,
      schedule: ScheduleType.weekly,
      daysOfWeek: [6], // 6 = Saturday (DateTime.weekday: 1=Mon..7=Sun)
      xp: 30,
    ),
  ];
}
