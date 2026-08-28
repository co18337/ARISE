# The System — Architecture

CLAUDE.md = always-on context. ROADMAP.md = what to build next. This file = how the app is
shaped: screens, navigation, the design-system components, and the database schema.

---

## 1. The interaction model (borrowed from Ingress Prime)

Ingress does **not** use a bottom tab bar. It has:

- **One persistent home surface** (the Scanner map) that you always return to.
- **A radial menu of circular buttons** (OPS) that summons everything else.
- **Full-screen overlays**, each dismissed by a single circular X at bottom-centre.
- **Modals for reward moments** — gold-bordered panels that interrupt you on purpose.
- **A persistent bottom status bar** of live counters, always visible on home.

The System copies this shape exactly. It suits a single-user app opened once a morning:
the home screen is the only thing you need daily, and everything else is a deliberate detour.

| Ingress                          | The System                                |
| -------------------------------- | ----------------------------------------- |
| Scanner map (home)               | **TODAY** — the day's quests              |
| OPS radial menu                  | **OPS** — same, opens everything          |
| Agent profile (level, AP, badges)| **STATUS** — level, rank, four stat bars  |
| COMM (Activities/Alerts/News)    | **LOG** — activity feed, misses, briefing |
| Daily Assignments + CLAIM ALL    | The quest list itself, with a countdown   |
| Weekly FITREP modal              | **Daily/Weekly Report** modal             |
| Achievements hex grid            | **ACHIEVEMENTS** — same, hex grid         |
| Portal detail                    | **Quest detail** — history, own streak    |
| Inventory                        | *(not in v1 — nothing to carry)*          |

---

## 2. Screen map

### TODAY — home (`screens/today_screen.dart`)
The only screen you need on a normal morning.

- Top strip: hunter name + level, XP arc gauge (Ingress puts the level arc top-left).
- Date, and `QUESTS REFRESH IN 12:23:39` countdown in gold — Ingress's daily-assignment
  timer is a strong nudge, and it costs one `Timer.periodic`.
- `DAILY XP` StatBar (already built).
- Quest cards grouped by category, each with its XP reward chip.
- Persistent bottom status bar: XP today · streak · quests cleared · OPS button.

### OPS — radial menu (overlay)
Circular icon buttons: **STATUS · LOG · ACHIEVEMENTS · PLAN · SETTINGS**, each with a label
below and a pink dot when something is unseen.

### STATUS — the character sheet (overlay)
- Header: hunter name, big level number, rank badge, segmented XP-to-next-level bar.
- Four stat panels (STR / STA / DIS / REC), each a glowing bar + level + XP.
- Streak panel: current, longest, perfect days.
- Lifetime stat panels in Ingress's `Combat / Defense / Health` style — a coloured left edge,
  label on the left, value right-aligned.
- Scope tabs: `ALL TIME | MONTH | WEEK | TODAY`.

### LOG — the feed (overlay)
Tabs: `ACTIVITY | ALERTS | SYSTEM`, date dividers with flanking rules, one row per event.
- Activity: `+10 XP · Morning skincare cleared`
- Alerts: `Streak broken`, `Sleep quest missed`
- System: the AI's morning briefing (Phase 8).

### ACHIEVEMENTS (overlay)
Hex badge grid in tiers (bronze → silver → gold → platinum), sectioned by
Consistency / Milestones / Stats, with flanking-rule section headers.

### PLAN — the catalog editor (overlay)
List of task templates: toggle active, edit XP and schedule, archive. This is what makes
"the plan is DATA" real rather than a slogan — the plan becomes editable in-app.

### Quest detail (overlay)
Big XP number, title, category, stat, this quest's own streak, and a 30-day completion grid.

### Modals (interrupt on purpose)
- **LEVEL UP** — gold, full-screen flash.
- **RANK UP** — rarer, purple/gold.
- **DAILY REPORT** — the FITREP pattern: gold-bordered panel, XP earned, quests cleared,
  streak, a `CLAIM` button.

---

## 3. Navigation implementation

- One `Navigator`. Overlays are full-screen routes, not `Dialog`s, so they get their own
  back-button handling.
- Custom `PageRouteBuilder` with a fade + slight scale. Material's default slide
  transition reads as "phone app"; a fade-up reads as "projected HUD".
- `HudOverlayScaffold` wraps every overlay and supplies the circular X close button, so
  the dismiss affordance is identical everywhere (this is a big part of why Ingress feels
  coherent).
- Modals via `showGeneralDialog` with a custom barrier and a scale/glow entrance.

---

## 4. Design-system components

Built (Phase 2): `SystemPanel` · `StatBar` · `QuestTile` · `HudBackdrop` · `ChamferBorder`

To build, each lifted from a specific Ingress pattern:

| Component            | Where Ingress uses it                                  |
| -------------------- | ------------------------------------------------------ |
| `HudCircleButton`    | OPS radial menu, portal actions (Hack/Link/Charge)     |
| `HudTabBar`          | COMM tabs, `ALL TIME / MONTH / WEEK`                   |
| `HudOverlayScaffold` | every full-screen overlay + its circular X             |
| `DateDivider`        | COMM alert list date separators                        |
| `StatListPanel`      | Combat / Defense / Health stat blocks                  |
| `RewardChip`         | the black `⊙ +10` boxes on daily assignments           |
| `NoticeBar`          | splash-screen tip: left accent bar + coloured text     |
| `HudToast`           | `Drone ready to move.` bordered message                |
| `CountdownText`      | `ASSIGNMENT REFRESHES IN 12:23:39`                     |
| `TieredBar`          | FITREP `8 km | 24 km | 56 km` milestone bar            |
| `HexBadge`           | achievements grid                                      |
| `LevelArc`           | segmented arc gauge, top-left of the Scanner           |
| `BracketFrame`       | `[ ]` corners around a featured item                   |
| `GradientButton`     | `CLAIM` / `OK` / `Manage` purple→blue buttons          |
| `BottomStatusBar`    | items / portal keys / XM counter row                   |

### Colour meaning (this is the part that must stay disciplined)
- **Cyan** — normal, default, informational. The bulk of the UI.
- **Gold/amber** — reward, claim, countdown, level-up. Rare on purpose.
- **Purple/magenta** — energy and progress (Ingress's XM).
- **Red** — misses, penalties, broken streaks.
- **Lavender** — secondary labels inside stat panels.
- Per-stat colours stay reserved for STR/STA/DIS/REC.

---

## 5. Database (Drift / SQLite) — Phase 3

### Tables

```
task_templates          the catalog — the plan itself
  id             TEXT PK
  title          TEXT
  category       TEXT        enum name
  stat           TEXT        enum name
  schedule       TEXT        enum name
  days_of_week   TEXT        "6" or "1,3,5"; empty for daily/weekdays
  xp             INTEGER
  is_active      BOOLEAN
  sort_order     INTEGER
  created_at     INTEGER
  archived_at    INTEGER NULL

daily_quests            one row per (template, day) actually issued
  id             INTEGER PK
  template_id    TEXT -> task_templates.id
  day            INTEGER     days since epoch, LOCAL date
  done           BOOLEAN
  completed_at   INTEGER NULL
  xp_awarded     INTEGER     SNAPSHOT of template.xp
  stat           TEXT        SNAPSHOT of template.stat
  UNIQUE(template_id, day)

day_rollups             one row per day, for fast history
  day            INTEGER PK
  xp_earned      INTEGER
  xp_available   INTEGER
  quests_cleared INTEGER
  quests_total   INTEGER
  is_perfect     BOOLEAN
  str_xp / sta_xp / dis_xp / rec_xp INTEGER

player_state            exactly one row
  hunter_name         TEXT
  total_xp            INTEGER
  str_xp / sta_xp / dis_xp / rec_xp INTEGER
  current_streak      INTEGER
  longest_streak      INTEGER
  last_active_day     INTEGER
  acknowledged_level  INTEGER
  acknowledged_rank   TEXT

activity_log            feeds the LOG screen
  id      INTEGER PK
  at      INTEGER
  kind    TEXT     questCleared | levelUp | rankUp | streakBroken | ...
  title   TEXT
  detail  TEXT NULL
  xp_delta INTEGER NULL

achievements
  id           TEXT PK
  progress     INTEGER
  target       INTEGER
  unlocked_at  INTEGER NULL

settings                key/value, for anything small
  key   TEXT PK
  value TEXT
```

### The five decisions that matter

**1. XP is snapshotted onto the quest row, not looked up.**
`daily_quests.xp_awarded` copies `template.xp` at generation time. If you later decide
"drink 3L water" is worth 15 XP instead of 10, your past days must not silently inflate.
Same reason an invoice stores the price it charged rather than pointing at today's price list.
`stat` is snapshotted for the same reason.

**2. Days are stored as an integer day-number, never a timestamp.**
The entire app turns on "which day is this". Storing a `DateTime` invites the classic
timezone/DST bug where "today" flips at 5pm or a day gets counted twice. An integer
days-since-epoch computed from the *local* date is unambiguous, sorts correctly, and makes
range queries trivial. Helpers: `dayKey(DateTime)` / `dateFromDayKey(int)`.
*(Alternative: `TEXT 'YYYY-MM-DD'` — easier to eyeball in a DB browser, slightly bigger.)*

**3. Level and rank are DERIVED, never stored as truth.**
```dart
int levelForXp(int xp)     // pure function over a threshold table in code
Rank rankForLevel(int lvl)
```
Storing level as a column means it can disagree with XP after a migration or a manual edit,
and then you're debugging which one is lying. Derive it every time — it's an array lookup.

**What *is* stored is `acknowledged_level`**: the last level you've actually been *shown the
animation for*. The level-up check becomes:
```dart
if (levelForXp(totalXp) > state.acknowledgedLevel) {
  showLevelUpModal();
  setAcknowledgedLevel(levelForXp(totalXp));
}
```
That fires exactly once, survives restarts and hot reloads, and can never double-fire.
Rank uses the same trick.

**4. `day_rollups` exists purely for speed.**
Streaks, the 90-day chart and the STATUS screen must not scan thousands of `daily_quests`
rows. One row per day, updated on each toggle. The per-stat running totals in
`player_state` are the same idea — a cache. Both must be rebuildable from `daily_quests`
alone by a `recomputeAll()` function, so a bug in the cache is never unrecoverable.

**5. Days are materialised lazily, and the future is never pre-generated.**
A day's quests are written to `daily_quests` the first time that day is opened. Generating
the future would freeze today's plan into tomorrow, defeating the point of an editable
catalog. On launch, any days between `last_active_day` and today are backfilled as missed,
so gaps in the streak are explicit rather than ambiguous.

### Layering
```
screens/ widgets/      UI only, no SQL
   ↑
repositories/          QuestRepository, PlayerRepository — plain Dart types in/out
   ↑
data/db/               Drift tables, DAOs, migrations
```
Screens never touch Drift directly. That way Phase 3 swapping in-memory → SQLite only
rewrites the repository layer, and the widgets built in Phase 2 keep working untouched.

### Backup
JSON export of every table to a file via the share sheet. No cloud, no account. Manual
restore. This is the whole backup story for v1 and it is deliberately boring.
