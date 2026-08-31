#!/usr/bin/env python3
"""Make the exercise demonstrations move like film instead of like a flipbook.

Two separate problems live in the source files:

1. They are authored at 250ms per frame — four frames a second, a three-second
   rep. Slowing anything further is impossible; it is already a slideshow.
2. They only contain 12 distinct frames for a whole repetition. Playing those
   12 faster does not fix it: the eye still resolves each individual drawing.
   Twelve pictures is twelve pictures.

So this does both things that actually matter: it INSERTS intermediate frames
by cross-fading each consecutive pair, and then plays the result fast. Blending
is what a film camera's shutter does for free — the smear between positions is
exactly what the eye reads as continuous motion, and it is why 24fps film looks
smooth while a 24fps slideshow does not.

Frames are also downscaled, because the app draws them at about 234 physical
pixels and 360 is wasted bytes and wasted decode time.

Needs Pillow. Without it the fetch script skips this step and the animations
still work, just slowly.
"""
import sys
from pathlib import Path

try:
    from PIL import Image, ImageSequence
except ImportError:
    print("retime: Pillow not installed, leaving the GIFs at source tempo")
    print("        pip install Pillow   (then re-run tool/retime_gifs.py)")
    sys.exit(0)

# Milliseconds per frame after interpolation. 40ms is 25fps — film rate.
TARGET_DELAY_MS = 40

# Blended frames inserted between each pair of real ones. 2 turns 12 frames
# into 36, which at 25fps is a 1.44s repetition: a believable tempo AND
# genuinely continuous motion.
INTERPOLATED = 2

# The card draws these at 78dp; 240 covers it on a 3x screen with room to
# spare, and cuts the pixels per frame by more than half.
TARGET_SIZE = 240


def smooth(path: Path) -> bool:
    image = Image.open(path)

    # Already processed — the script is safe to re-run after a re-fetch.
    if image.info.get("duration") == TARGET_DELAY_MS and image.size[0] == TARGET_SIZE:
        return False

    frames = []
    for frame in ImageSequence.Iterator(image):
        rgb = frame.convert("RGB")
        if rgb.size != (TARGET_SIZE, TARGET_SIZE):
            rgb = rgb.resize((TARGET_SIZE, TARGET_SIZE), Image.LANCZOS)
        frames.append(rgb)

    if len(frames) < 2:
        return False

    # Cross-fade between each pair, wrapping the last back to the first so the
    # loop point is as smooth as the rest of the cycle.
    blended = []
    for i, current in enumerate(frames):
        nxt = frames[(i + 1) % len(frames)]
        blended.append(current)
        for step in range(1, INTERPOLATED + 1):
            alpha = step / (INTERPOLATED + 1)
            blended.append(Image.blend(current, nxt, alpha))

    # One shared palette for every frame: without it each blended frame
    # invents its own and the file roughly doubles.
    #
    # 64 colours and NO dithering, both measured rather than guessed. These are
    # grey anatomical drawings with one orange highlight, so 64 is ample, and
    # dithering sprays noise that GIF's run-length compression cannot pack —
    # it cost 20% of the file size for no visible gain.
    palette = blended[0].quantize(colors=64, method=Image.MEDIANCUT)
    quantised = [f.quantize(palette=palette, dither=Image.NONE) for f in blended]

    quantised[0].save(
        path,
        save_all=True,
        append_images=quantised[1:],
        duration=TARGET_DELAY_MS,
        loop=0,
        optimize=True,
        disposal=2,
    )
    return True


def main() -> int:
    folder = Path(__file__).resolve().parent.parent / "assets" / "exercises"
    gifs = sorted(folder.glob("*.gif"))
    if not gifs:
        print("retime: nothing to do — run tool/fetch_exercise_gifs.sh first")
        return 0

    changed = 0
    total_before = total_after = 0
    for gif in gifs:
        before = gif.stat().st_size
        total_before += before
        if smooth(gif):
            changed += 1
            after = gif.stat().st_size
            total_after += after
            frames = sum(1 for _ in ImageSequence.Iterator(Image.open(gif)))
            print(f"  ~ {gif.name:<24} {before // 1024:>4}KB -> {after // 1024:>4}KB"
                  f"  {frames} frames @ {TARGET_DELAY_MS}ms")
        else:
            total_after += before

    fps = round(1000 / TARGET_DELAY_MS)
    print(f"retime: {changed} of {len(gifs)} smoothed to {fps}fps "
          f"({total_before // 1024}KB -> {total_after // 1024}KB)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
