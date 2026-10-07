#!/usr/bin/env python3
"""A row of item icons drawn by ChatGPT -> the game's item icon PNGs.

docs/newgold/DEVKIT-PROMPTS.md's item prompt gives one picture with the icons
side by side on magenta. Each becomes files/itemtool/itemdata/item_icon/NAME.png,
which item_data.mk builds into the icon archive (ITEMICON_FROM_PNG):

- 32x32, the item scaled by area average from its own pixels (no magenta at
  its edges) to WIDTH pixels wide, and centred on (12, 12): HeartGold draws
  every item icon in the top-left 24x24 of the square (all 536 icons here are
  centred there), so one centred on the square sat 4 pixels off in the bag;
- at most 15 colours of its own, in 15-bit colour, index 0 transparent
  (magenta), and a palette of exactly 16 entries (DEVKIT-PROMPTS.md's trap).

First used for the seven Mochi (Paolo, 2026-10-08):
    convert_item_icons.py mochi_chatgpt.png health_mochi muscle_mochi \
        resist_mochi genius_mochi clever_mochi swift_mochi fresh_start_mochi
"""
import argparse
from pathlib import Path

from PIL import Image, ImageChops, ImageFilter

ICON_DIR = Path(__file__).resolve().parents[4] / "files/itemtool/itemdata/item_icon"
MAGENTA = (255, 0, 255)


def subject(im):
    """255 where the picture is not its magenta background."""
    r, g, b = im.split()
    bg = ImageChops.multiply(ImageChops.multiply(r.point(lambda v: 255 if v > 190 else 0),
                                                 b.point(lambda v: 255 if v > 190 else 0)),
                             g.point(lambda v: 255 if v < 90 else 0))
    return ImageChops.invert(bg)


def icons(picture):
    """Each icon's crop, left to right: the columns where something is drawn."""
    mask = subject(picture)
    drawn = [mask.crop((x, 0, x + 1, picture.height)).getbbox() is not None for x in range(picture.width)]
    out, start = [], None
    for x, d in enumerate(drawn + [False]):
        if d and start is None:
            start = x
        elif not d and start is not None:
            box = mask.crop((start, 0, x, picture.height)).getbbox()
            out.append((start + box[0], box[1], start + box[2], box[3]))
            start = None
    return out


def convert(picture, box, width):
    # The picture's own scaling left a 2-3 pixel blend of outline and magenta
    # round the item; taken in, it tinted the outline purple. Eroded away, the
    # 12-pixel outline keeps its black.
    im, mask = picture.crop(box), subject(picture).filter(ImageFilter.MinFilter(5)).crop(box)
    size = (width, round(im.height * width / im.width))
    pre = ImageChops.multiply(im, Image.merge("RGB", (mask,) * 3)).resize(size, Image.BOX)
    cover = mask.resize(size, Image.BOX)
    pixels = {(x, y): tuple(min(255, v * 255 // cover.getpixel((x, y))) & 0xF8 for v in pre.getpixel((x, y)))
              for y in range(size[1]) for x in range(size[0]) if cover.getpixel((x, y)) >= 128}
    strip = Image.new("RGB", (len(pixels), 1))
    strip.putdata(list(pixels.values()))
    q = strip.quantize(15, method=Image.Quantize.LIBIMAGEQUANT, dither=Image.Dither.NONE)
    palette = [v & 0xF8 for v in q.getpalette()[:45]]
    icon = Image.new("P", (32, 32), 0)
    x0, y0 = 12 - size[0] // 2, 12 - size[1] // 2
    for (x, y), index in zip(pixels, q.tobytes()):
        icon.putpixel((x0 + x, y0 + y), index + 1)
    icon.putpalette(list(MAGENTA) + palette + [0] * (45 - len(palette)), rawmode="RGB")
    return icon


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("picture", type=Path)
    parser.add_argument("names", nargs="+", help="the icons' PNG names, left to right")
    parser.add_argument("--width", type=int, default=22, help="the item's width in pixels")
    parser.add_argument("--out", type=Path, default=ICON_DIR)
    args = parser.parse_args()
    picture = Image.open(args.picture).convert("RGB")
    boxes = icons(picture)
    if len(boxes) != len(args.names):
        raise SystemExit(f"{len(boxes)} icons in the picture, {len(args.names)} names")
    for name, box in zip(args.names, boxes):
        icon = convert(picture, box, args.width)
        assert len(icon.getpalette()) == 48 and icon.getbbox()
        icon.save(args.out / f"{name}.png")
        print(name, icon.getbbox())


if __name__ == "__main__":
    main()
