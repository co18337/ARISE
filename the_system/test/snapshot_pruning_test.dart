import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/export/snapshot_pruning.dart';

/// Deleting backups is the one operation in this app that can destroy
/// something irreplaceable, so the rule that decides what dies is tested
/// directly rather than inferred from what is left on a disk.
void main() {
  List<String> named(List<String> stamps) => [
    for (final s in stamps) 'arise-backup-$s.json',
  ];

  test('nothing is deleted while there is room', () {
    expect(staleSnapshots(named(['2026-09-01-0800']), keep: 7), isEmpty);
  });

  test('the oldest go first, and exactly the excess', () {
    final names = named([
      '2026-09-01-0800',
      '2026-09-02-0800',
      '2026-09-03-0800',
      '2026-09-04-0800',
    ]);
    expect(staleSnapshots(names, keep: 2), [
      'arise-backup-2026-09-01-0800.json',
      'arise-backup-2026-09-02-0800.json',
    ]);
  });

  test('order comes from the NAME, not the order listed', () {
    // A directory listing is not sorted, and a file copied back onto the phone
    // has a fresh mtime. The timestamp in the name is the only honest clock.
    final names = named([
      '2026-09-04-0800',
      '2026-09-01-0800',
      '2026-09-03-0800',
      '2026-09-02-0800',
    ]);
    expect(staleSnapshots(names, keep: 3), [
      'arise-backup-2026-09-01-0800.json',
    ]);
  });

  test('anything that is not a snapshot is left alone', () {
    final names = [...named(['2026-09-01-0800', '2026-09-02-0800']), 'notes.txt'];
    expect(staleSnapshots(names, keep: 1), [
      'arise-backup-2026-09-01-0800.json',
    ]);
  });

  test('keep: 0 clears them all, and a negative keep cannot ask for more', () {
    final names = named(['2026-09-01-0800', '2026-09-02-0800']);
    expect(staleSnapshots(names, keep: 0).length, 2);
    expect(staleSnapshots(names, keep: -5).length, 2);
  });
}
