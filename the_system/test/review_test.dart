import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/review_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// The Sunday review, without a model.
///
/// Everything here runs on the figures alone, which is deliberately the FLOOR:
/// the review has to be written whether or not a provider answers, so the
/// no-key path is the one worth testing hardest.
void main() {
  late AppDatabase db;

  ReviewRepository repoAt(DateTime now) => ReviewRepository(
    db: db,
    progress: ProgressRepository(db, clock: FixedClock(now)),
    memory: MemoryRepository(db),
    clock: FixedClock(now),
  );

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  test('a week ends on its Sunday, whatever day you ask on', () {
    // Every day of one week resolves to the same Sunday, or two openings in a
    // week would write two reviews of it.
    for (var d = 31; d <= 36; d++) {
      final date = DateTime(2026, 8, d);
      expect(
        ReviewRepository.weekEndingFor(date),
        DateTime(2026, 9, 6),
        reason: '$date',
      );
    }
    // And Sunday itself resolves to itself.
    expect(
      ReviewRepository.weekEndingFor(DateTime(2026, 9, 6)),
      DateTime(2026, 9, 6),
    );
  });

  test('it is not due before Sunday evening', () async {
    // A review written at nine on Sunday morning describes a week that still
    // has a long run left in it.
    expect(await repoAt(DateTime(2026, 9, 4, 21, 0)).isDue(DateTime(2026, 9, 4)),
        isFalse, reason: 'Friday');
    expect(await repoAt(DateTime(2026, 9, 6, 9, 0)).isDue(DateTime(2026, 9, 6)),
        isFalse, reason: 'Sunday morning');
    expect(await repoAt(DateTime(2026, 9, 6, 20, 1)).isDue(DateTime(2026, 9, 6)),
        isTrue, reason: 'Sunday evening');
  });

  test('it writes once and is not written again', () async {
    // The whole point of a weekly call is that it happens once a week.
    final sunday = DateTime(2026, 9, 6, 20, 30);
    final repo = repoAt(sunday);

    final first = await repo.generateIfDue(sunday);
    expect(first, isNotNull);

    // Opening again the same evening reads it back rather than rewriting it.
    expect(await repo.generateIfDue(sunday), isNull);
    expect((await repo.read(sunday))!.summary, first!.summary);

    // Monday starts a NEW week, which is not due until its own Sunday — so
    // nothing is written and nothing is spent.
    final monday = DateTime(2026, 9, 7, 8, 0);
    expect(await repoAt(monday).generateIfDue(monday), isNull);
    expect(await repoAt(monday).read(monday), isNull, reason: 'a new week');

    // Last week's is still on file, which is what the screen falls back to.
    final all = await repoAt(monday).readAll();
    expect(all, hasLength(1));
    expect(all.single.summary, first.summary);
  });

  test('with no provider it is still written, from the figures', () async {
    final sunday = DateTime(2026, 9, 6, 20, 30);
    final review = await repoAt(sunday).generate(sunday);

    expect(review.source, 'figures');
    expect(review.fromModel, isFalse);
    expect(review.summary, isNotEmpty);
    expect(review.kept, isNotEmpty);
    expect(review.change, isNotEmpty);
  });

  test('an empty week is described honestly, not dressed up', () async {
    final sunday = DateTime(2026, 9, 6, 20, 30);
    final review = await repoAt(sunday).generate(sunday);

    expect(review.summary, contains('Nothing was recorded'));
    // And it says why, rather than implying failure.
    expect(review.summary, contains('nothing was logged'));
  });

  test('a week with real days reports the real figures', () async {
    final clock = FixedClock(DateTime(2026, 9, 6, 20, 30));
    final quests = QuestRepository(db, clock: clock);
    await quests.materialiseDay(clock.now());
    final today = await quests.readDay(clock.now());
    await quests.setStatus(today.first, QuestStatus.done);

    final review = await repoAt(clock.now()).generate(clock.now());

    expect(review.summary, contains('cleared 1'));
    expect(review.kept, contains('1 quests cleared'));
  });
}
