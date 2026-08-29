/// Converts between a [DateTime] and the integer "day number" used as the key
/// for a day everywhere in the database.
///
/// The whole app turns on the question "which day is this". Storing a full
/// timestamp invites the classic bug where a day boundary lands in the wrong
/// place because of the local timezone or a DST shift, and a day gets counted
/// twice or skipped. An integer count of days since 1970-01-01, computed from
/// the *local* calendar date with the time thrown away, is unambiguous, sorts
/// correctly and makes range queries trivial.
library;

/// The day number for the local calendar date that [dateTime] falls on.
int dayKeyOf(DateTime dateTime) {
  // Rebuilding the DateTime from just y/m/d gives local midnight, which is what
  // makes this a *calendar date* rather than an instant.
  final localMidnight = DateTime(dateTime.year, dateTime.month, dateTime.day);
  return localMidnight.difference(_epoch).inDays;
}

/// Local midnight of the day identified by [dayKey].
DateTime dateOfDayKey(int dayKey) => DateTime(1970, 1, 1 + dayKey);

/// Today's day number.
int todayKey() => dayKeyOf(DateTime.now());

final DateTime _epoch = DateTime(1970, 1, 1);
