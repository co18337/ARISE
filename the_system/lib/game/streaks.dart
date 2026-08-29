/// Current and best-ever run of qualifying days.
class StreakSummary {
  final int current;
  final int longest;

  const StreakSummary({required this.current, required this.longest});

  static const StreakSummary empty = StreakSummary(current: 0, longest: 0);
}

/// Works out the streaks from the set of days that met the daily bar.
///
/// [qualifyingDays] holds day-numbers (see lib/data/day_key.dart).
///
/// The one subtle rule: **today never breaks a streak.** A day only counts
/// against you once it's over, otherwise opening the app at 8am — before
/// doing anything — would show the streak already broken. So if today hasn't
/// qualified yet, the count is measured up to yesterday and today is still
/// in play.
StreakSummary computeStreaks({
  required Set<int> qualifyingDays,
  required int today,
}) {
  if (qualifyingDays.isEmpty) return StreakSummary.empty;

  // Current: walk backwards from today (or yesterday, if today is still open)
  // until a day is missing.
  var cursor = qualifyingDays.contains(today) ? today : today - 1;
  var current = 0;
  while (qualifyingDays.contains(cursor)) {
    current++;
    cursor--;
  }

  // Longest: a day starts a run only if the day before it is missing, so each
  // run is counted exactly once.
  var longest = 0;
  for (final day in qualifyingDays) {
    if (qualifyingDays.contains(day - 1)) continue;
    var length = 0;
    var next = day;
    while (qualifyingDays.contains(next)) {
      length++;
      next++;
    }
    if (length > longest) longest = length;
  }

  return StreakSummary(current: current, longest: longest);
}
