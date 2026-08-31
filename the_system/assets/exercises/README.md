# Exercise demonstrations and guides

## Guides — committed

`guides.json` — step-by-step instructions, target and secondary muscles, and
equipment for twelve movements, from the **MIT-licensed data half** of
<https://github.com/hasaneyldrm/exercises-dataset> (© 2026 Hasan Emir
Yıldırım). Only confident name matches were taken; a wrong set of instructions
is worse than none.

## Animations — local only, NEVER committed

`*.gif` is gitignored. Fetch them with:

```bash
./tool/fetch_exercise_gifs.sh
```

Source: <https://github.com/omercotkd/exercises-gifs> (`assets/<id>.gif`), which
mirrors the Kaggle "Fitness Exercises with Animations" set. That repo's README
states plainly: *"I do not own any of the content in this repository. All rights
belong to the original creators."* The same artwork appears in
hasaneyldrm/exercises-dataset at 180×180, where the notice is explicit that
cloning grants no licence to the media.

**So these files are used here for personal, local, non-commercial use in a
single private build, and are never redistributed** — not in git, not in a
published APK, not anywhere. That is the owner's decision and the reason for
the gitignore rule. Anyone else cloning this repo gets the script, not the
media, and should satisfy themselves about their own use.

## Tempo

The source files are authored at **250ms per frame** — 4fps, a three-second
rep — and contain only 12 distinct frames for a whole repetition. Playing 12
frames faster does not fix that; the eye still resolves each drawing.

`tool/retime_gifs.py` therefore does two things: it **inserts two cross-faded
frames between each pair** (12 -> 36) and plays the result at **40ms, 25fps**.
The blend is what a film shutter does for free — the smear between positions is
what the eye reads as continuous motion. It also downscales to 240x240, since
the card draws them at about 234 physical pixels.

It needs Pillow (`pip install Pillow`) and runs automatically at the end of the
fetch script. Without Pillow the animations still work, just slowly. A test
reads the GIF header and fails if any file is still slower than 120ms/frame.

## Which movements have one

Thirteen of eighteen. The five without — brisk walk, plank, bodyweight squats,
chin tucks, neck extensions — have **no honest match** in the dataset: there is
no plain walk, no plain plank, no plain squat, and nothing depicting a chin
tuck. Showing a front-plank-with-twist for a plank, or a jump squat for a
bodyweight squat, would teach the wrong movement. Those keep their written cue
and the movement-pattern icon.

## Adding more

1. add a `ours:datasetId:name` line to `tool/fetch_exercise_gifs.sh`;
2. set `demoAsset: '<our id>'` on that exercise in
   `lib/data/exercise_catalog.dart`;
3. run the script.

Anything the trainer reaches for that is NOT bundled is fetched once at
runtime and cached in the app's documents directory — see
`lib/data/media/exercise_media.dart`. Bundling all 1,324 would add ~370 MB to
the APK, which is why only the programme's own movements ship.
