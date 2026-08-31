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
"

echo "Fetching exercise demonstrations into $DEST"
count=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
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
