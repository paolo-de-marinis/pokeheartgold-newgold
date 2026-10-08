#!/usr/bin/env python3
"""Paolo's ChatGPT pictures of a species -> the game's formats, in this tree.

docs/newgold/DEVKIT-PROMPTS.md's flow, first run for Bramblin (2026-10-07).
The pictures have a flat magenta background (made transparent) and are
reduced by area average from the subject's own pixels. Pixel art drawn at
PX screen pixels a pixel (--grid PX) is read back at its own pixels
instead: one pixel a cell, the colour most of the cell has (a cell's stray
pixels at its edges dropped), the cells placed where the colour edges are.
Each part is converted when its pictures are given:

  battle    --front F --back B --shiny-front SF --shiny-back SB (--width W | --grid PX)
            [--front2 F2 --back2 B2 --shiny-front2 SF2 --shiny-back2 SB2]
            files/poketool/pokegra/pokegra/NNNN/<gender>/{front,back}.png for
            each gender the species has a picture for: 160x80, two 80x80
            frames, the subject cropped to its pixels, centred, its
            lowest row on row 78: scaled to W wide (the width of the
            species' community sprite), or with --grid at its own size.
            Frame 2 is frame 1 again, or the second pose (--front2 ...,
            drawn on the same canvas): each picture and its second pose
            are cropped to the box the two fill together, so frame 2
            stands where it is drawn beside frame 1, the feet on one line,
            and both poses are in one palette.
            Front and back share 15 colours, index 0 transparent; the
            front's PNG carries the normal palette and the back's the shiny
            one on the same indices. The shiny pictures vote each index's
            colour; with --grid each pixel's (normal, shiny) pair is an
            index, and past 15 pairs the one cheapest to merge (its pixels
            times its distance, normal plus shiny) becomes its nearest,
            until 15 are left: each merge is printed, and the preview's
            merged.png draws the cells it moved green, a row a pose,
            and each pose's count is printed. heights.py and
            import_sprite_offsets.py then write the height and the record
            that follow the pictures.
  icon      --icon I [--grid PX]
            poke_icon_N.png, 32x64: the picture's two frames side by side,
            each scaled whole to 32x32, in the one of the three shared icon
            palettes nearest its colours, and that palette's number in
            sPokemonPalNoBySpeciesAndForm; a redraw at 32x32 pixels a frame
            given with --grid comes through pixel for pixel.
  follower  --follower F --shiny-follower SF [--rows down,up,left] [--paired]
            the species' mmodel texture, built by import_followers.nsbtx:
            eight 32x32 frames up, up, down, down, left, left, right, right.
            The sheet's rows are named by --rows, two steps a row; a right
            row is not used: the right frames are the left ones mirrored, as
            HeartGold's are. One scale for every frame, the down frame as
            tall as HeartGold's 32x32 followers of about the species' Dex
            height are drawn (follower_height), each frame's feet on row 29,
            centred at x 16; two 16-colour palettes, normal and shiny. The
            shiny sheet votes each index's colour; with --paired, for a
            shiny sheet drawn shape for shape as the normal one, each
            pixel's (normal, shiny) pair is an index, as --grid's battle
            pictures' are.

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

Baby Lugia, from Paolo's pixel art (.rounds/round18/babylugia/art) and the
follower sheets of round 17 (.rounds/round17/lugia):

    convert_chatgpt.py BABY_LUGIA --front front_normal.png --back back_normal.png \\
        --shiny-front front_shiny.png --shiny-back back_shiny.png --grid 14 \\
        --follower baby_lugia_sheet_normal_hq.png --shiny-follower baby_lugia_sheet_shiny_hq.png \\
        --rows down,up,left,right --paired

and its battle pictures in two poses, his final eight (art/final, 2026-10-08):

    convert_chatgpt.py BABY_LUGIA --front front1_normal.png --back back1_normal.png \\
        --shiny-front front1_shiny.png --shiny-back back1_shiny.png \\
        --front2 front2_normal.png --back2 back2_normal.png \\
        --shiny-front2 front2_shiny.png --shiny-back2 back2_shiny.png --grid 14

and its icon, his 50x50 frames redrawn at 32x32, at one pixel a pixel:

    convert_chatgpt.py BABY_LUGIA --icon icon_32x32_claude_from_paolo.png --grid 1
"""
import argparse
import cmath
import collections
import io
import json
import math
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


def load(path, grid=None):
    """The picture in RGB; pixel art drawn grid screen pixels a pixel at one
    pixel a cell, the colour most of the cell has, in 15-bit colour, and
    magenta where an indexed picture has magenta, at any index: Paolo's
    second poses have the outline at index 0."""
    im = Image.open(path)
    if not grid:
        return im.convert("RGB")
    if im.mode != "P":
        im = im.convert("RGB")
    palette = im.getpalette() if im.mode == "P" else None
    px, (x0, y0) = im.load(), phase(im, grid)
    out = Image.new("RGB", (int((im.width - x0) // grid), int((im.height - y0) // grid)))
    for row in range(out.height):
        for col in range(out.width):
            cell = collections.Counter(px[x, y] for y in range(round(y0 + row * grid), round(y0 + (row + 1) * grid))
                                       for x in range(round(x0 + col * grid), round(x0 + (col + 1) * grid)))
            v = cell.most_common(1)[0][0]
            colour = tuple(palette[3 * v:3 * v + 3]) if palette else v
            out.putpixel((col, row), MAGENTA if palette and colour == MAGENTA else tuple(c & 0xF8 for c in colour))
    return out


def phase(im, grid):
    """Where pixel art's cells start, across and down: its colour edges'
    positions modulo grid, averaged round the circle. Rounded first, so
    cells that start on the picture's edge start at 0, not a hair short of
    grid, which lost the first row and column."""
    px, out = im.load(), []
    for dx, dy in ((1, 0), (0, 1)):
        z = sum(cmath.exp(2j * math.pi * (x if dx else y) / grid)
                for y in range(dy, im.height) for x in range(dx, im.width) if px[x, y] != px[x - dx, y - dy])
        out.append(round(cmath.phase(z) / (2 * math.pi) * grid, 6) % grid)
    return out


def mask_of(im):
    """255 where the picture is not its magenta background."""
    r, g, b = im.split()
    bg = ImageChops.multiply(ImageChops.multiply(r.point(lambda v: 255 if v > 190 else 0),
                                                 b.point(lambda v: 255 if v > 190 else 0)),
                             g.point(lambda v: 255 if v < 90 else 0))
    return ImageChops.invert(bg)


def shrink(im, size, crop=True, box=None):
    """{(x, y): colour} of the picture's opaque pixels scaled to size (w, h),
    each the average of the subject's own pixels it covers, in 15-bit colour;
    cropped to the subject first when crop (to box when one is given), the
    height then following the width (size (w, 0)), and w None keeping the
    subject's own size."""
    m = mask_of(im)
    if crop:
        box = box or m.getbbox()
        im, m = im.crop(box), m.crop(box)
        width = size[0] or im.width
        size = (width, round(im.height * width / im.width))
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


def paired(normals, shinies, n=15):
    """One index map for pictures drawn twice, normal and shiny, from each
    pixel's (normal, shiny) colour pair: up to n pairs keep an index each;
    past n, the pair cheapest to merge (its pixels times its distance, normal
    plus shiny, to its nearest pair) becomes that one, until n are left.
    Each picture as {(x, y): index 1..n}, the normal and the shiny palette,
    and the merges as (pair, into, pixels)."""
    if any(normal.keys() != shiny.keys() for normal, shiny in zip(normals, shinies)):
        raise SystemExit("a shiny picture is not its normal one's shape")
    pairs = [{p: (normal[p], shiny[p]) for p in normal} for normal, shiny in zip(normals, shinies)]
    count = collections.Counter(pair for picture in pairs for pair in picture.values())
    into, merges = {pair: pair for pair in count}, []

    def distance(a, b):
        return sum(abs(u - v) for x, y in zip(a, b) for u, v in zip(x, y))
    while len(count) > n:
        _cost, pair, nearest = min((count[a] * distance(a, b), a, b) for a in count for b in count if a != b)
        merges.append((pair, nearest, count[pair]))
        count[nearest] += count.pop(pair)
        into = {k: nearest if v == pair else v for k, v in into.items()}
    order = sorted(count)
    index = {pair: i + 1 for i, pair in enumerate(order)}
    pad = [(0, 0, 0)] * (n - len(order))
    return ([{p: index[into[pair]] for p, pair in picture.items()} for picture in pairs],
            [a for a, _ in order] + pad, [b for _, b in order] + pad, merges)


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


def battle(front, back, shiny_front, shiny_back, width=None, grid=None, second=()):
    """(front, back, merged, marked, moved): the sheets, the back's PNG
    carrying the shiny palette; with grid, the merged pairs, the front's and
    the back's frames in the normal colours, a row a pose, the cells the
    merges moved green, and how many cells each pose has moved. Without
    width, each picture at its own size. second, the same four pictures in a
    second pose, is frame 2: each picture and its second pose are cropped to
    the box the two fill together, so frame 2 stands where it is drawn beside
    frame 1 (the feet on one line, nothing jumps), and one palette is made
    over both poses; without it frame 2 is frame 1 again."""
    poses = [(front, back, shiny_front, shiny_back)] + ([second] if second else [])
    views = []
    for paths in zip(*poses):
        pictures = [load(p, grid) for p in paths]
        boxes = [mask_of(im).getbbox() for im in pictures]
        box = tuple(pick(b[i] for b in boxes) for i, pick in enumerate((min, min, max, max)))
        views.append([shrink(im, (width, 0), box=box) for im in pictures])
    fr, bk, sfr, sbk = views
    normals = [p for pose in zip(fr, bk) for p in pose]
    shinies = [p for pose in zip(sfr, sbk) for p in pose]
    if grid:
        maps, normal, shiny, merged = paired(normals, shinies)
    else:
        maps, normal = quantize(normals)
        shiny, merged = shiny_palette(maps, shinies, normal), []
    ifr, ibk = maps[0::2], maps[1::2]

    def at(frames, across=0):
        w, h = max(x for f in frames for x, _ in f) + 1, max(y for f in frames for _, y in f) + 1
        return across + (80 - w) // 2, 79 - h

    def sheet(frames, palette):
        return indexed((160, 80), [(at(frames), frames[0]), (at(frames, 80), frames[-1])], palette)
    places = [at(ifr), at(ibk, 80)]
    rows = []
    for k, indices in enumerate(maps):
        x, y = places[k % 2]
        rows.append(((x, y + 80 * (k // 2)), indices))
    marked = indexed((160, 80 * len(poses)), rows, normal).convert("RGB")
    merged_pairs, moved = {pair for pair, _into, _pixels in merged}, [0] * len(poses)
    for k, (((ox, oy), _), colours, shiny_colours) in enumerate(zip(rows, normals, shinies)):
        for (x, y), colour in colours.items():
            if (colour, shiny_colours.get((x, y))) in merged_pairs:
                marked.putpixel((ox + x, oy + y), (0, 255, 0))
                moved[k // 2] += 1
    return sheet(ifr, normal), sheet(ibk, shiny), merged, marked, moved


def icon(path, grid=None):
    """The 32x64 icon and the shared palette it is drawn in."""
    im = load(path, grid)
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


def follower(normal, shiny, rows, height, pairs=False):
    """(the texture, the 32x256 picture it is built from with the normal
    palette, the same with the shiny one). With pairs, each sheet is brought
    to 15 colours of its own first and paired() makes the indices from the
    pairs; a pixel only the normal sheet draws takes the shiny colour its
    normal colour has most."""
    if not {"down", "up", "left"} <= set(rows):
        raise SystemExit("--rows has to name the down, up and left rows")
    normals, shinies = follower_frames(normal, rows, height), follower_frames(shiny, rows, height)
    if pairs:
        (qn, pn), (qs, ps) = quantize(normals), quantize(shinies)
        normals = [{p: pn[i - 1] for p, i in frame.items()} for frame in qn]
        shinies = [{p: ps[i - 1] for p, i in frame.items()} for frame in qs]
        votes = collections.defaultdict(collections.Counter)
        for n, s in zip(normals, shinies):
            for p in n.keys() & s.keys():
                votes[n[p]][s[p]] += 1
        shinies = [{p: s[p] if p in s else votes[c].most_common(1)[0][0] for p, c in n.items()}
                   for n, s in zip(normals, shinies)]
        indices, palette, shiny_colours, _merged = paired(normals, shinies)
    else:
        indices, palette = quantize(normals)
        shiny_colours = shiny_palette(indices, shinies, palette)
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
    for part in ("front", "back", "shiny-front", "shiny-back", "front2", "back2", "shiny-front2", "shiny-back2",
                 "icon", "follower", "shiny-follower"):
        parser.add_argument(f"--{part}", type=Path)
    parser.add_argument("--width", type=int, help="the battle picture's width")
    parser.add_argument("--grid", type=float, help="the pictures are pixel art, this many screen pixels a pixel")
    parser.add_argument("--rows", default="down,up,left", help="the follower sheet's rows, top to bottom")
    parser.add_argument("--paired", action="store_true",
                        help="the shiny follower sheet is the normal one's shape: colour pairs are the indices")
    parser.add_argument("--preview", type=Path)
    args = parser.parse_args()
    name = args.species.upper().removeprefix("SPECIES_")
    number = number_of(name)
    if name not in own_art.SPECIES:
        raise SystemExit(f"{name} is not in tools/newgold/import/own_art.py: the next import would put "
                         "the reference's pictures back")

    battle_parts = (args.front, args.back, args.shiny_front, args.shiny_back)
    second = (args.front2, args.back2, args.shiny_front2, args.shiny_back2)
    if any(second) and not (all(second) and all(battle_parts)):
        raise SystemExit("a second pose needs --front2, --back2, --shiny-front2 and --shiny-back2 "
                         "beside the first pose's four")
    if any(battle_parts):
        if not all(battle_parts) or not (args.width or args.grid):
            raise SystemExit("the battle pictures need --front, --back, --shiny-front, --shiny-back "
                             "and --width or --grid")
        front, back, merged, marked, moved = battle(*battle_parts, args.width, args.grid,
                                                    second if any(second) else ())
        for pair, into, pixels in merged:
            print(f"battle: the pair {pair} merged into {into}, {pixels} pixels")
        if merged:
            print("battle: " + ", ".join(f"pose {k} {n} pixels moved" for k, n in enumerate(moved, 1)))
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
            if merged:
                preview(args.preview, "merged", marked)

    if args.icon:
        picture, palette = icon(args.icon, args.grid)
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
        data, picture, shiny = follower(args.follower, args.shiny_follower, args.rows.split(","), height, args.paired)
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
