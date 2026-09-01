@Tags(['live'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/config/app_config.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/memory/gemini.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/models/models.dart';

void main() {
  test('the real embedder resolves, embeds and improves recall', () async {
    HttpOverrides.global = null;
    await AppConfig.load();
    if (!AppConfig.hasGeminiKey) return;

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final local = MemoryRepository(db);
    for (final (title, body) in [
      ('Monday', 'Easy run 14 minutes, finished strong. Legs felt fresh.'),
      ('Tuesday', 'Hill strides, six efforts. Calves tight afterwards.'),
      ('Wednesday', 'Plank 45 seconds and dead bugs. Trunk work only.'),
      ('Thursday', 'Skipped the session entirely. Slept badly.'),
    ]) {
      await local.ingest(
        kind: MemoryKind.workoutSession,
        title: title,
        body: body,
        externalId: 'live:$title',
      );
    }

    final embedder = GeminiEmbedder();
    final model = await embedder.resolveModel();
    // ignore: avoid_print
    print('LIVE embedding model: $model');
    expect(model, isNotNull);

    final repo = MemoryRepository(db, embedder: embedder);
    final converted = await repo.reembedAll();
    // ignore: avoid_print
    print('LIVE converted $converted chunks to ${embedder.name}');
    expect(converted, greaterThan(0));
    expect((await repo.stats()).staleChunks, 0);

    // The point of the upgrade: matching on MEANING, not shared words. The
    // query shares no vocabulary with the session it should find.
    final hits = await repo.recall('did I miss any training?', limit: 2);
    // ignore: avoid_print
    print('LIVE top hit: ${hits.first.passage}');
    expect(hits, isNotEmpty);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
