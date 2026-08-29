#!/usr/bin/env bash
# Run The System in Chrome with durable database storage.
#
# Use this instead of a bare `flutter run -d chrome`.
#
# Why: drift stores the database using sqlite3 compiled to WebAssembly. The
# reliable backend (OPFS) needs SharedArrayBuffer, which browsers only expose
# to cross-origin-isolated pages. Without these two headers Chrome falls back
# to an IndexedDB-emulated file system that can LOSE THE MOST RECENT WRITE on
# reload — you tick a quest, reload, and it's unticked, with no error anywhere.
#
# (`--web-header` works but is hidden from `flutter run --help`.)
#
# Android is unaffected: it uses a real SQLite file on disk.
set -euo pipefail

exec flutter run -d chrome \
  --web-header=Cross-Origin-Opener-Policy=same-origin \
  --web-header=Cross-Origin-Embedder-Policy=require-corp \
  "$@"
