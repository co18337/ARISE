# The System — Project Context

## What this is
A personal Android app, "The System": a Solo Leveling–style daily routine tracker for a
full self-transformation plan covering fitness, diet, AND skincare (not just workouts).
Single user (me), local-first, works offline. I open it each morning; it issues the day's
tasks, I complete them, I earn XP and level up.

## Who I am (affects how you work)
Strong Python/ML engineer, but NEW to Flutter, Dart, and app development. When you make a
non-obvious Flutter/Dart choice, add a one-line comment explaining why. Favour readable,
conventional code over clever code. Make small, reviewable changes with clear commit messages.

## Tech stack
- Flutter (Dart), targeting Android. Primary test device: Motorola G35 (near-stock Android);
  secondary: POCO X7 Pro (HyperOS). During dev I run in Chrome: `flutter run -d chrome`.
- Local persistence: Drift (SQLite). [Not wired up yet — early tasks may use in-memory state.]
- Daily quest generation (LATER): Gemini Flash, free tier, ONE call per day, cached, with a
  rule-based offline fallback. The LLM only selects/sequences/narrates tasks — it NEVER
  changes the plan's actual numbers.
- No backend in v1. No paid services. Nothing requiring a subscription.

## Core principle: the plan is DATA
The transformation plan is a TASK CATALOG — reusable task templates, each with a schedule
(daily / specific weekdays / weekly / phase-week). Each day a generator instantiates that
day's tasks from the catalog, so the plan can change without rewriting the app.

## Game model
- Four stats: STR (gym/strength), STA (stamina/running), DIS (discipline: sleep & wake
  adherence), REC (recovery: diet, skincare, hydration).
- Completing a task grants XP to its stat. XP -> levels. Streaks reward consistency. Missing
  tasks triggers penalties / streak breaks.
- Monthly "boss fight" = real re-measurement (BCA scan, benchmark tests) — later.

## Version roadmap
- v1 (now): routine tracker — task catalog, daily quests, mark done/not-done, XP/stats/streaks,
  wake alarm + reminders. All local.
- v2: Health Connect sync (steps, sleep, heart rate, workouts auto-feed the System).
- v3: progress photos (stored as files on disk; only the path in the DB — never image blobs).
- v4: camera pose-estimation rep counting.

## Hard rules
- Never commit secrets. The Gemini API key lives in a gitignored file, never in the repo.
- Store images as files, never as blobs in the database.
- All reads/writes stay local and fast; the once-a-day LLM call is the only network dependency,
  and the app must fully work without it.

## Design language (the System look)
Reference apps: Solo Leveling's status windows for the *panel* look; **Ingress Prime** for the
*interaction* model and HUD discipline. See ARCHITECTURE.md for the full component list.

- Dark sci-fi HUD. Near-black background (deep charcoal/navy). Signature glow: electric
  blue/cyan. Angular CUT corners, never rounded — that single choice carries the whole look.
- Fonts are BUNDLED in assets/fonts/, not fetched (the app must work offline). Orbitron =
  headings, Rajdhani = HUD labels/readouts, Inter = body. Do not re-add the google_fonts
  package; it broke the build here.
- Panels = dark, semi-transparent, thin glowing border, corner brackets ("status window").
- Colour has FIXED meaning and must stay disciplined:
  cyan = normal/default · gold = reward, claim, countdown, level-up (rare on purpose) ·
  purple/magenta = energy & progress · red = misses, penalties, broken streaks ·
  lavender = secondary labels · per-stat colours reserved for STR/STA/DIS/REC.
- Uppercase + wide letter-spacing on labels does more for the HUD feel than the font does.
- Tasks are "QUESTS"; stats are glowing bars; completing a quest pulses and floats a "+XP";
  level-ups and rank-ups are gold-bordered modals that interrupt on purpose.
- Define this ONCE as a theme + reusable widgets so every screen inherits it.

## App shape
One persistent home surface (TODAY), everything else a full-screen overlay summoned from a
radial OPS menu and dismissed by a circular X — Ingress's model, no bottom tab bar. Reward
moments are modals. Full screen map, navigation and component list: ARCHITECTURE.md.

## Layering (enforced from Phase 3 on)
screens/ + widgets/  →  repositories/  →  data/db/ (Drift)
UI never touches SQL directly, so swapping in-memory state for SQLite only rewrites the
repository layer and leaves the widgets untouched.