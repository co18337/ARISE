import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/exercise_catalog.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';
import 'package:the_system/widgets/badge_image.dart';
import 'package:the_system/widgets/game_icon.dart';

/// Guards the emblem artwork.
///
/// A missing or misnamed SVG renders as nothing at all — no crash, no error,
/// just a blank space where a rank crest should be. No widget test would catch
/// that, so the filenames are checked directly against the enums that build
/// them.
void main() {
  File assetFor(String stem) => File('assets/icons/$stem.svg');

  void expectUsableIcon(String stem, {required String reason}) {
    final file = assetFor(stem);
    expect(file.existsSync(), isTrue, reason: 'missing asset for $reason');

    final svg = file.readAsStringSync();
    expect(svg, contains('<svg'), reason: '$reason is not an SVG');
    // Transparent background: the downloaded default has an opaque black
    // square behind the glyph, which would show as a block on our dark panels.
    expect(
      svg,
      isNot(contains('M0 0h512v512H0z')),
      reason: '$reason still has the opaque background rectangle',
    );
    // Single white path is what lets one file recolour to any tier.
    expect(svg, contains('fill="#fff"'), reason: '$reason is not tintable');
  }

  test('every stat has an emblem', () {
    for (final stat in StatType.values) {
      expectUsableIcon(stat.iconAsset, reason: 'stat ${stat.name}');
    }
  });

  File badgeFor(String stem) => File('assets/badges/$stem.png');

  void expectUsableBadge(String stem, {required String reason}) {
    final file = badgeFor(stem);
    expect(file.existsSync(), isTrue, reason: 'missing badge for $reason');

    final bytes = file.readAsBytesSync();
    // PNG magic number, and RGBA (colour type 6) — the artwork was cut out of
    // a grey plate, and a badge that kept its background would show as a grey
    // square on every dark panel.
    expect(bytes.sublist(1, 4), equals('PNG'.codeUnits), reason: reason);
    expect(bytes[25], 6, reason: '$reason is not RGBA (has no transparency)');
  }

  test('every rank has a crest', () {
    for (final rank in Rank.values) {
      expectUsableBadge(rank.badgeAsset, reason: 'rank ${rank.label}');
    }
  });

  test('every achievement tier has a medal', () {
    for (final tier in AchievementTier.values) {
      expectUsableBadge(tier.badgeAsset, reason: 'tier ${tier.name}');
    }
  });

  test('the icons are declared as assets so they ship in the build', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('assets/icons/'));
    expect(pubspec, contains('assets/badges/'));
  });

  test('the licence credit ships alongside the stat emblems', () {
    // CC BY 3.0 makes attribution a condition of use, so losing this file is
    // a licensing problem, not a tidiness one.
    final credits = File('assets/icons/CREDITS.md');
    expect(credits.existsSync(), isTrue);

    final text = credits.readAsStringSync();
    expect(text, contains('CC BY 3.0'));
    for (final author in ['Lorc', 'Delapouite']) {
      expect(text, contains(author), reason: 'author $author uncredited');
    }
  });

  test('every declared demonstration has a file, once fetched', () {
    // The GIFs are gitignored — they are not ours to redistribute, so a fresh
    // clone has none until tool/fetch_exercise_gifs.sh runs. The check is
    // therefore CONSISTENCY, not presence: if any have been fetched, every
    // exercise that claims one must have it. A half-fetched folder shows as a
    // silent icon where an animation should be.
    final declared = [
      for (final e in ExerciseCatalog.all)
        if (e.demoAsset != null) e,
    ];
    expect(declared, isNotEmpty, reason: 'the catalog should declare demos');

    final present = declared
        .where((e) => File('assets/exercises/${e.demoAsset}.gif').existsSync())
        .toList();

    if (present.isEmpty) {
      // Fresh clone. Nothing to check, and nothing wrong.
      return;
    }

    for (final exercise in declared) {
      expect(
        File('assets/exercises/${exercise.demoAsset}.gif').existsSync(),
        isTrue,
        reason: '${exercise.id} declares a demo but the file is missing — '
            'run tool/fetch_exercise_gifs.sh',
      );
    }
  });

  test('the demonstrations play at a believable tempo', () {
    // The source files are authored at 250ms per frame — four frames a second,
    // a three-second rep. That reads as a slideshow, and no amount of Flutter
    // tuning fixes it because the delay is inside the file.
    // tool/retime_gifs.py rewrites it to 90ms. This checks it was actually run.
    final gifs = Directory('assets/exercises')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.gif'))
        .toList();
    if (gifs.isEmpty) return; // fresh clone, nothing fetched yet

    for (final gif in gifs) {
      final bytes = gif.readAsBytesSync();
      // Graphic Control Extension: 21 F9 04, then flags, then a 16-bit
      // little-endian delay in hundredths of a second.
      var found = false;
      for (var i = 0; i + 5 < bytes.length; i++) {
        if (bytes[i] == 0x21 && bytes[i + 1] == 0xF9 && bytes[i + 2] == 0x04) {
          final delayCs = bytes[i + 4] | (bytes[i + 5] << 8);
          expect(
            delayCs,
            lessThanOrEqualTo(12),
            reason: '${gif.path.split('/').last} plays at ${delayCs * 10}ms '
                'per frame — run tool/retime_gifs.py',
          );
          found = true;
          break;
        }
      }
      expect(found, isTrue, reason: '${gif.path} has no frame timing');
    }
  });

  test('the fetch script covers every declared demonstration', () {
    // The script is the only record of which dataset id each demo came from,
    // so a demo wired in the catalog but absent from the script cannot be
    // re-fetched on another machine.
    final script = File('tool/fetch_exercise_gifs.sh').readAsStringSync();
    for (final exercise in ExerciseCatalog.all) {
      if (exercise.demoAsset == null) continue;
      expect(
        script,
        contains('${exercise.id}:'),
        reason: '${exercise.id} has no line in the fetch script',
      );
    }
  });

  test('the badge artwork records where it came from', () {
    // Provenance for artwork that was cut out of a supplied set, including the
    // unverified-licence note — the thing most likely to matter later.
    final credits = File('assets/badges/CREDITS.md');
    expect(credits.existsSync(), isTrue);
    expect(credits.readAsStringSync(), contains('cropped_badges'));
  });
}
