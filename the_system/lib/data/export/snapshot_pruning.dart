/// Which snapshot files to delete so that only the newest [keep] survive.
///
/// PURE, and name-based rather than modification-time based. The names carry
/// their own timestamp — `arise-backup-2026-09-11-2310.json` — so sorting them
/// lexicographically sorts them chronologically, and a file copied back onto
/// the phone keeps its true place in the order instead of jumping to the front
/// because copying refreshed its mtime.
///
/// Separated from the file system on purpose: deleting backups is the one
/// operation here that can destroy something irreplaceable, so the rule that
/// decides what dies is a function that can be tested without a disk.
List<String> staleSnapshots(List<String> names, {int keep = 7}) {
  if (keep < 0) keep = 0;
  final snapshots = names.where((n) => n.endsWith('.json')).toList()..sort();
  final excess = snapshots.length - keep;
  return excess <= 0 ? const [] : snapshots.take(excess).toList();
}
