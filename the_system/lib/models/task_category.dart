/// The area of the routine a task belongs to. Used to group tasks on the
/// Today screen (e.g. all skincare tasks shown together).
enum TaskCategory {
  skincareAM,
  skincarePM,
  diet,
  workout,
  sleep,
  hydration,
  grooming,
}

// An `extension` lets us attach a computed getter to an enum without turning
// it into a class. This keeps the enum itself simple while still giving the
// UI a friendly label to display.
extension TaskCategoryLabel on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.skincareAM:
        return 'Skincare (AM)';
      case TaskCategory.skincarePM:
        return 'Skincare (PM)';
      case TaskCategory.diet:
        return 'Diet';
      case TaskCategory.workout:
        return 'Workout';
      case TaskCategory.sleep:
        return 'Sleep';
      case TaskCategory.hydration:
        return 'Hydration';
      case TaskCategory.grooming:
        return 'Grooming';
    }
  }
}
