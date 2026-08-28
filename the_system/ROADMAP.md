# The System — Build Roadmap

CLAUDE.md holds always-on context; ARCHITECTURE.md holds the screen map, component list and
database schema; this file holds the ordered step-by-step. One phase at a time.
Ship after Phase 6 — but Phase 4 is already a usable app, so shipping early is allowed.

## Requirements (what "done" means for me)
- Tracks my FULL transformation plan: fitness + diet + skincare + sleep/wake — not just workouts.
- Feels like the "System" from Solo Leveling: dark sci-fi HUD, glowing panels, stat windows,
  XP, levels, ranks, level-up moments. The look is a real requirement — it's what makes me
  open it daily.
- Local-first, offline, single-user, free (no subscriptions). Android (Moto G35 primary).
- A morning wake alarm + reminders. Daily quests I complete for XP.
- Later: auto-sync health data; progress photos; camera rep-counting.

## Phase 1 — Data foundation  [DONE]
Task-catalog model (templates + schedules), daily generator, plain Today screen with checkboxes
and in-memory XP. Deliberately unstyled — the skeleton test.

## Phase 2 — Design system + the "System" look  [DONE]
Dark HUD theme (colours, bundled fonts, glowing chamfered panels). Reusable widgets:
SystemPanel, StatBar, QuestTile, HudBackdrop, ChamferBorder. Today restyled into a
"DAILY QUESTS" window with a status header, task-complete pulse and floating "+XP".
Note: fonts are bundled as assets — google_fonts was removed, see CLAUDE.md.

## Phase 3 — Persistence (Drift/SQLite)  [NEXT]
Schema + repository layer per ARCHITECTURE.md §5. Templates, daily quests, day rollups,
player state, activity log. Completions survive restarts. XP snapshotted onto the quest row;
days stored as integer day-numbers. JSON export as manual backup.
Screens must go through repositories, never touch Drift directly.

## Phase 4 — Game engine
XP thresholds -> levels, rank tiers, four stats, streaks, miss penalties, perfect days.
Level/rank DERIVED from XP; `acknowledged_level` stored so a level-up fires exactly once.
`recomputeAll()` can rebuild every cached total from daily_quests alone.
>>> MINIMUM SHIP LINE: with P3+P4 the app is already usable every morning. Everything
    below is the part that makes me *want* to open it — but I can ship before it. <

## Phase 5 — Navigation shell + STATUS
HudOverlayScaffold (full-screen overlays + circular X), fade/scale routes, OPS radial menu.
The STATUS character sheet: level, rank badge, four stat bars, streaks, lifetime stat panels
in Ingress's Combat/Defense/Health style, scope tabs.

## Phase 6 — Reward moments
Level-up and rank-up modals, the daily/weekly report (FITREP pattern), quest countdown timer,
toasts, achievements hex grid. The motivation payoff.
>>> SHIP v1 HERE: a System I use every morning. <

## Phase 7 — Alarm + notifications  (needs real phone)
Exact-alarm wake buzzer; timed reminders (sunscreen, lip balm, dinner cutoff, sleep). Handle
Xiaomi battery whitelisting if run on the POCO.

## Phase 8 — The System AI (Gemini Flash, free tier)
One call each morning: select/sequence/narrate the day's quests in the System's voice, adapting
to yesterday's adherence. Cached, rule-based offline fallback. Key gitignored, never committed.
Lands in the LOG screen's SYSTEM tab as a morning briefing.

## Phase 9 — LOG + PLAN screens  (post-ship polish)
LOG: activity feed / alerts / system briefing, COMM-style with date dividers.
PLAN: in-app catalog editor — add/edit/archive templates, change XP and schedule. This is what
finally makes "the plan is DATA" literally true.

## Later versions
v2 Health Connect sync (steps/sleep/HR/workouts) · v3 progress photos (files on disk, path in
DB) · v4 camera pose-estimation rep counting.