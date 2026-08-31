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

# The PORT is pinned on purpose. Browser storage — including the OPFS file
# drift keeps the database in — is scoped to the ORIGIN, and the origin
# includes the port. `flutter run` picks a random port each launch, so without
# this every run opens a different, empty database: you finish a session, stop
# the app, start it again, and the day looks untouched. Nothing was lost; you
# were simply looking at a different database.
exec flutter run -d chrome \
  --web-port=8080 \
  --web-header=Cross-Origin-Opener-Policy=same-origin \
  --web-header=Cross-Origin-Embedder-Policy=require-corp \
  "$@"
