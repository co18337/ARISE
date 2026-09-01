#!/usr/bin/env bash
# Fetch the exercise demonstration GIFs into assets/exercises/.
#
# The GIFs are NOT in git — see the .gitignore rule and the note in
# assets/exercises/README.md. This script re-fetches them on a fresh clone.
#
# Source: https://github.com/omercotkd/exercises-gifs  (assets/<id>.gif)
# Names for each id: that repo's exercises.csv, and the MIT-licensed
# exercises.json in hasaneyldrm/exercises-dataset. Both are the same id space.
set -euo pipefail

cd "$(dirname "$0")/.."
DEST="assets/exercises"
BASE="https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets"

mkdir -p "$DEST"

# our exercise id : dataset gif id : what the dataset calls it
MAP="
steady_run:0685:run
sprint_interval:0685:run
jumping_jacks:3224:jack jump
situps:0735:sit-up v. 2
leg_raises:0472:hanging leg raise
pushups:0662:push-up
incline_pushups:0493:incline push-up
bench_press:0025:barbell bench press
pullups:0652:pull-up
inverted_rows:0499:inverted row
bicep_curls:0294:dumbbell biceps curl
lunges:3470:forward lunge
cooldown_stretch:1511:hamstring stretch

# --- Gym movements. Added when the catalog was rebuilt for a gym; the same
# --- dataset already had them, so no second source and no static stand-ins.
lat_pulldown:2330:cable lat pulldown full range of motion
assisted_pullup:0017:assisted pull-up
seated_row:0861:cable seated row
face_pull:0233:cable standing rear delt row (with rope)
db_shoulder_press:0405:dumbbell seated shoulder press
lat_raise:0334:dumbbell lateral raise
tricep_pushdown:0201:cable pushdown
assisted_dips:0009:assisted chest dip (kneeling)
goblet_squat:1760:dumbbell goblet squat
leg_press:0739:sled 45 degree leg press
romanian_deadlift:0085:barbell romanian deadlift
leg_curl:0599:lever seated leg curl
calf_raise:0605:lever standing calf raise
cable_woodchop:0243:cable twist
farmer_carry:2133:farmers walk
dead_bug:0276:dead bug
side_plank:3544:bodyweight incline side plank
"

# NOT FETCHED, deliberately. The dataset has nothing honest for these, and the
# rule from the first pass still stands: showing a plank-with-twist for a plank
# teaches the wrong movement, so they keep the written cue instead.
#   plank          - only 'front plank with twist', 'plank tap shoulder',
#                    'power point plank'. Every one adds a second action.
#   hip_thrust     - only 'resistance band hip thrusts on knees', which is
#                    neither the equipment nor the position.
#   dead_hang      - nothing. 'arm slingers hanging' is a different exercise.
#   chin_tucks     - every 'chin' hit is a chin-UP.
#   neck_extension - only side stretches, which is a different direction.
#   dynamic_warmup - only single stretches, not a warm-up sequence.
#
# A variation that changes DIFFICULTY or ANGLE is fine (assisted, incline,
# seated). One that adds a MOVEMENT is not.

echo "Fetching exercise demonstrations into $DEST"
count=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  # Comments are allowed inside the map, so skip them rather than trying to
  # fetch a GIF called "# --- Gym movements".
  case "$line" in \#*) continue ;; esac
  ours="${line%%:*}"
  rest="${line#*:}"
  gif="${rest%%:*}"
  name="${rest#*:}"

  if [ -f "$DEST/$ours.gif" ]; then
    echo "  = $ours.gif (have it)"
  else
    if curl -sSLf --max-time 60 -o "$DEST/$ours.gif" "$BASE/$gif.gif"; then
      echo "  + $ours.gif  <- $gif  ($name)"
    else
      echo "  ! $ours.gif  FAILED ($gif)" >&2
      rm -f "$DEST/$ours.gif"
      continue
    fi
  fi
  count=$((count + 1))
done <<< "$MAP"

echo "Done: $count demonstrations in $DEST"

# The source files play at 250ms/frame — four frames a second, which reads as a
# slideshow rather than a movement. This rewrites the frame delay only.
if command -v python3 >/dev/null 2>&1; then
  python3 "$(dirname "$0")/retime_gifs.py" || true
else
  echo "retime: python3 not found, GIFs left at source tempo" >&2
fi

du -sh "$DEST"
