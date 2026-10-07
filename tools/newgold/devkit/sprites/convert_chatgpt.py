#!/usr/bin/env python3
"""Paolo's ChatGPT pictures of a species -> the game's formats, in this tree.

docs/newgold/DEVKIT-PROMPTS.md's flow, first run for Bramblin (2026-10-07).
The pictures have a flat magenta background (made transparent) and are
reduced by area average from the subject's own pixels. Each part is
converted when its pictures are given:

  battle    --front F --back B --shiny-front SF --shiny-back SB --width W
            files/poketool/pokegra/pokegra/NNNN/<gender>/{front,back}.png for
            each gender the species has a picture for: 160x80, two 80x80
            frames alike, the subject cropped to its pixels and scaled to W
            wide (the width of the species' community sprite), centred, its
            lowest row on row 78. Front and back share 15 colours, index 0
            transparent; the front's PNG carries the normal palette and the
            back's the shiny one on the same indices (the shiny pictures vote
            each index's colour). heights.py and import_sprite_offsets.py
            then write the height and the record that follow the pictures.
  icon      --icon I
            poke_icon_N.png, 32x64: the picture's two frames side by side,
            each scaled whole to 32x32, in the one of the three shared icon
            palettes nearest its colours, and that palette's number in
            sPokemonPalNoBySpeciesAndForm.
  follower  --follower F --shiny-follower SF [--rows down,up,left]
            the species' mmodel texture, built by import_followers.nsbtx:
            eight 32x32 frames up, up, down, down, left, left, right, right.
            The sheet's rows are named by --rows, two steps a row; a right
            row is not used: the right frames are the left ones mirrored, as
            HeartGold's are. One scale for every frame, the down frame as
            tall as HeartGold's 32x32 followers of about the species' Dex
            height are drawn (follower_height), each frame's feet on row 29,
            centred at x 16; two 16-colour palettes, normal and shiny.

The species has to be in tools/newgold/import/own_art.py first, or the next
import would put the reference's pictures back over these. --preview DIR
writes the pictures there magnified four times, to look at. Every PNG is
written with a 16-entry palette: one of 256 entries made the battle load 256
colours over every other sprite's.

    convert_chatgpt.py SPECIES [--front ...] [--icon ...] [--follower ...] [--preview DIR]

Bramblin, from Paolo's eight pictures (img1 shiny follower, 2 shiny icon,
3 follower, 4 icon, 5 back, 6 front, 7 shiny back, 8 shiny front):

    convert_chatgpt.py BRAMBLIN --front img6.png --back img5.png \\
        --shiny-front img8.png --shiny-back img7.png --width 42 --icon img4.png \\
        --follower img3.png --shiny-follower img1.png --rows down,up,left,right
"""
import argparse
import collections
import io
import json
import re
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageChops

ROOT = Path(__file__).resolve().parents[4]
IMPORT = ROOT / "tools/newgold/import"
sys.path.insert(0, str(IMPORT))
import import_followers  # noqa: E402
import import_icons  # noqa: E402
import import_species  # noqa: E402
import own_art  # noqa: E402

SPRITES = ROOT / "files/poketool/pokegra/pokegra"
MAGENTA = (255, 0, 255)
FRAME = 32          # a follower's frames; the largest Pokemon's 64 are not done here yet
FEET = 29           # a follower's lowest row
DOWN = 2            # the texture's first down-facing frame, the one followers are measured by


def number_of(name):
    found = re.search(rf"^#define SPECIES_{name}\s+(\d+)", (ROOT / "include/constants/species.h").read_text(), re.M)
    if not found:
        raise SystemExit(f"there is no SPECIES_{name}")
    return int(found.group(1))


def load(path):
    return Image.open(path).convert("RGB")


def mask_of(im):
    """255 where the picture is not its magenta background."""
    r, g, b = im.split()
    bg = ImageChops.multiply(ImageChops.multiply(r.point(lambda v: 255 if v > 190 else 0),
                                                 b.point(lambda v: 255 if v > 190 else 0)),
                             g.point(lambda v: 255 if v < 90 else 0))
    return ImageChops.invert(bg)


def shrink(im, size, crop=True):
    """{(x, y): colour} of the picture's opaque pixels scaled to size (w, h),
    each the average of the subject's own pixels it covers, in 15-bit colour;
    cropped to the subject first when crop, the height then following the
    width (size (w, 0))."""
    m = mask_of(im)
    if crop:
        box = m.getbbox()
        im, m = im.crop(box), m.crop(box)
        size = (size[0], round(im.height * size[0] / im.width))
    pre = ImageChops.multiply(im, Image.merge("RGB", (m,) * 3)).resize(size, Image.BOX)
    cov = m.resize(size, Image.BOX)
    pp, cv, out = pre.load(), cov.load(), {}
    for y in range(size[1]):
        for x in range(size[0]):
            if cv[x, y] >= 128:
                out[x, y] = tuple(min(255, v * 255 // cv[x, y]) & 0xF8 for v in pp[x, y])
    return out


def quantize(pictures, n=15):
    """The pictures' colours brought down to n shared ones: each picture as
    {(x, y): index 1..n}, and the n colours."""
    points = [c for d in pictures for c in d.values()]
    strip = Image.new("RGB", (len(points), 1))
    strip.putdata(points)
    q = strip.quantize(n, method=Image.Quantize.LIBIMAGEQUANT, dither=Image.Dither.NONE)
    palette = q.getpalette()[:3 * n]
    palette += [0] * (3 * n - len(palette))
    indices, out, k = list(q.tobytes()), [], 0
    for d in pictures:
        out.append({p: indices[k + i] + 1 for i, p in enumerate(d)})
        k += len(d)
    return out, [tuple(palette[3 * i:3 * i + 3]) for i in range(n)]


def shiny_palette(index_maps, shiny_pictures, normal):
    """Each index's colour in the shiny pictures, by the most pixels."""
    votes = collections.defaultdict(collections.Counter)
    for indices, shiny in zip(index_maps, shiny_pictures):
        for p, i in indices.items():
            if p in shiny:
                votes[i][shiny[p]] += 1
    return [votes[i + 1].most_common(1)[0][0] if votes[i + 1] else normal[i] for i in range(len(normal))]


def indexed(size, frames, palette):
    """A 16-colour indexed picture, index 0 the magenta of transparency;
    frames are ((x, y), {(x, y): index}), placed at their corner."""
    im = Image.new("P", size, 0)
    for (ox, oy), indices in frames:
        for (x, y), i in indices.items():
            im.putpixel((ox + x, oy + y), i)
    im.putpalette([v for c in [MAGENTA] + list(palette) for v in c])
    return im


def png(im, transparent=True):
    out = io.BytesIO()
    im.save(out, "PNG", bits=4, **({"transparency": 0} if transparent else {}))
    return out.getvalue()


def battle(front, back, shiny_front, shiny_back, width):
    """(front, back) sheets: the back's PNG carries the shiny palette."""
    fr, bk, sfr, sbk = (shrink(load(p), (width, 0)) for p in (front, back, shiny_front, shiny_back))
    (ifr, ibk), normal = quantize([fr, bk])
    shiny = shiny_palette([ifr, ibk], [sfr, sbk], normal)

    def sheet(indices, palette):
        w, h = max(x for x, _ in indices) + 1, max(y for _, y in indices) + 1
        at = ((80 - w) // 2, 79 - h)
        return indexed((160, 80), [(at, indices), ((at[0] + 80, at[1]), indices)], palette)
    return sheet(ifr, normal), sheet(ibk, shiny)


def icon(path):
    """The 32x64 icon and the shared palette it is drawn in."""
    im = load(path)
    cw = im.width // 2
    frames = [shrink(im.crop((k * cw, 0, k * cw + cw, im.height)), (32, 32), crop=False) for k in range(2)]
    shared = import_icons.shared_palettes()

    def err(c, p):
        return sum((a - b) ** 2 for a, b in zip(c, p))

    def nearest(c, palette):
        return min(range(1, 16), key=lambda i: err(c, palette[i]))
    best = min(range(len(shared)), key=lambda k: sum(err(c, shared[k][nearest(c, shared[k])])
                                                     for f in frames for c in f.values()))
    frames = [((0, 32 * k), {p: nearest(c, shared[best]) for p, c in f.items()}) for k, f in enumerate(frames)]
    picture = indexed((32, 64), frames, shared[best][1:])
    picture.putpalette([v for c in shared[best] for v in c])
    return picture, best


def texture_pixels(data):
    """A follower BTX0's texture as an indexed picture, its frames stacked."""
    tex = 0x14
    at = tex + int.from_bytes(data[tex + 0x14:tex + 0x18], "little")
    units = int.from_bytes(data[tex + 0xC:tex + 0xE], "little")
    pixels = [v for b in data[at:at + 8 * units] for v in (b & 15, b >> 4)]
    width = import_followers.texture_width(data)
    im = Image.new("P", (width, len(pixels) // width))
    im.putdata(pixels)
    return im


def drawn_box(data, frame=DOWN):
    """The box a follower texture's frame has anything drawn in."""
    im, width = texture_pixels(data), import_followers.texture_width(data)
    return im.crop((0, frame * width, width, frame * width + width)).point(lambda v: 255 if v else 0).getbbox()


def drawn_height(data, frame=DOWN):
    box = drawn_box(data, frame)
    return box[3] - box[1]


def retail_followers():
    """(Dex height in decimetres, drawn height) of each HeartGold species
    whose follower has 32x32 frames, measured on its first down frame."""
    header = import_followers.IDX_H.read_text()
    models = dict((name, int(n)) for name, n in re.findall(r"#define (FOLLOWER_MON_\w+)\s+(\d+)", header))
    dex = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json").read_text())["mon_stats"]
    out = []
    for species, model in enumerate(import_followers.retail_models()[1:], 1):
        data = (import_followers.MMODEL_DIR /
                f"mmodel_{import_followers.MMODEL_BASE + models[model]:08d}.NSBTX").read_bytes()
        if import_followers.texture_width(data) == FRAME:
            out.append((dex[species]["height"], drawn_height(data)))
    return out


def follower_height(decimetres):
    """HeartGold's rule, measured on its own followers: the median drawn
    height of its 32x32 followers whose Dex height is within 1 dm."""
    near = sorted(h for d, h in retail_followers() if abs(d - decimetres) <= 1)
    return near[len(near) // 2]


def follower_frames(path, rows, height):
    """The sheet's up, up, down, down, left, left frames as {(x, y): colour}
    in 32x32, at one scale: the first down frame drawn `height` tall."""
    im = load(path)
    cw, ch = im.width // 2, im.height // len(rows)
    cells = {row: [im.crop((c * cw, r * ch, c * cw + cw, r * ch + ch)) for c in range(2)]
             for r, row in enumerate(rows)}
    boxes = {row: [mask_of(cell).getbbox() for cell in cells[row]] for row in cells}
    scale = height / (boxes["down"][0][3] - boxes["down"][0][1])
    out = []
    for row in ("up", "down", "left"):
        for cell, box in zip(cells[row], boxes[row]):
            cell = cell.crop(box)
            w, h = max(1, round(cell.width * scale)), max(1, round(cell.height * scale))
            x0, y0 = FRAME // 2 - w // 2, FEET + 1 - h
            out.append({(x0 + x, y0 + y): c for (x, y), c in shrink(cell, (w, h), crop=False).items()
                        if 0 <= x0 + x < FRAME and 0 <= y0 + y < FRAME})
    return out


def jasc(palette):
    return ("JASC-PAL\r\n0100\r\n16\r\n" + "".join(f"{r} {g} {b}\r\n" for r, g, b in [MAGENTA] + list(palette))).encode()


def follower(normal, shiny, rows, height):
    """(the texture, the 32x256 picture it is built from with the normal
    palette, the same with the shiny one)."""
    if not {"down", "up", "left"} <= set(rows):
        raise SystemExit("--rows has to name the down, up and left rows")
    indices, palette = quantize(follower_frames(normal, rows, height))
    shiny_colours = shiny_palette(indices, follower_frames(shiny, rows, height), palette)
    indices += [{(FRAME - 1 - x, y): i for (x, y), i in left.items()} for left in indices[4:6]]
    frames = [((0, FRAME * k), m) for k, m in enumerate(indices)]
    picture = indexed((FRAME, 8 * FRAME), frames, palette)
    directory = "PAOLO"
    files = {f"{directory}/overworld.png": png(picture),
             f"{directory}/overworld-tsure_poke0.pal": jasc(palette),
             f"{directory}/overworld-tsure_poke1.pal": jasc(shiny_colours),
             f"{directory}/overworld.json": import_followers.show(
                 f"{import_followers.FRAME_LISTS[FRAME]}/overworld.json")}
    data = import_followers.nsbtx(directory, read=lambda p: files[p] if p in files else import_followers.show(p))
    return data, picture, indexed((FRAME, 8 * FRAME), frames, shiny_colours)


def set_palette_number(name, number):
    """The species' line in sPokemonPalNoBySpeciesAndForm (import_icons.py's block)."""
    source = import_icons.INDEX.read_text()
    line = re.compile(rf"^    \d+(, // {name},?)$", re.M)
    if len(line.findall(source)) != 1:
        raise SystemExit(f"{name}: not one line in {import_icons.INDEX.name}'s palette table")
    import_icons.INDEX.write_text(line.sub(rf"    {number}\1", source))


def preview(directory, name, im):
    directory.mkdir(parents=True, exist_ok=True)
    im.resize((im.width * 4, im.height * 4), Image.NEAREST).save(directory / f"{name}.png")


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("species", help="the SPECIES_ constant's name, BRAMBLIN")
    for part in ("front", "back", "shiny-front", "shiny-back", "icon", "follower", "shiny-follower"):
        parser.add_argument(f"--{part}", type=Path)
    parser.add_argument("--width", type=int, help="the battle picture's width")
    parser.add_argument("--rows", default="down,up,left", help="the follower sheet's rows, top to bottom")
    parser.add_argument("--preview", type=Path)
    args = parser.parse_args()
    name = args.species.upper().removeprefix("SPECIES_")
    number = number_of(name)
    if name not in own_art.SPECIES:
        raise SystemExit(f"{name} is not in tools/newgold/import/own_art.py: the next import would put "
                         "the reference's pictures back")

    battle_parts = (args.front, args.back, args.shiny_front, args.shiny_back)
    if any(battle_parts):
        if not all(battle_parts) or not args.width:
            raise SystemExit("the battle pictures need --front, --back, --shiny-front, --shiny-back and --width")
        front, back = battle(*battle_parts, args.width)
        folder = SPRITES / f"{number:04d}"
        genders = [g for g in ("male", "female") if (folder / g / "front.png").stat().st_size]
        for gender in genders:
            (folder / gender / "front.png").write_bytes(png(front))
            (folder / gender / "back.png").write_bytes(png(back))
        print(f"battle: {', '.join(genders)} front and back written")
        for script, word in (("heights.py", "write"), ("import_sprite_offsets.py", "--write")):
            subprocess.run([sys.executable, str(IMPORT / script), word], check=True)
        if args.preview:
            preview(args.preview, "front", front)
            preview(args.preview, "back", back)

    if args.icon:
        picture, palette = icon(args.icon)
        path = ROOT / "files/poketool/icongra/poke_icon" / (
            f"poke_icon_{import_icons.first_added_icon() + import_species.added_species().index(name):08d}.png")
        path.write_bytes(png(picture, transparent=False))
        if import_icons.drawn_in(path, import_icons.shared_palettes()) != palette:
            raise SystemExit(f"{path.name}: its colours fit more than one shared palette")
        set_palette_number(name, palette)
        print(f"icon: {path.name}, shared palette {palette}")
        if args.preview:
            preview(args.preview, "icon", picture)

    if args.follower or args.shiny_follower:
        if not (args.follower and args.shiny_follower):
            raise SystemExit("the follower needs --follower and --shiny-follower")
        dex = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json").read_text())["mon_stats"]
        height = follower_height(dex[number]["height"])
        data, picture, shiny = follower(args.follower, args.shiny_follower, args.rows.split(","), height)
        member = re.search(rf"^#define MMODEL_FOLLOWER_MON_{name}\s+(\d+)",
                           import_followers.MMODEL_H.read_text(), re.M)
        if not member:
            raise SystemExit(f"{name} has no follower model of its own (import_followers.py)")
        path = import_followers.MMODEL_DIR / f"mmodel_{int(member.group(1)):08d}.NSBTX"
        path.write_bytes(data)
        print(f"follower: {path.name}, drawn {drawn_height(data)} rows tall (HeartGold's rule: {height})")
        if args.preview:
            preview(args.preview, "follower", picture)
            preview(args.preview, "follower_shiny", shiny)


if __name__ == "__main__":
    main()
