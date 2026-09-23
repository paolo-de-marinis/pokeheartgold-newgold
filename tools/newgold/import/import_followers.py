#!/usr/bin/env python3
"""Give every added species the overworld sprite it walks behind the player with.

Retail's following Pokemon are 566 textures in files/data/mmodel (members 297
to 862), one a species, female and form. A species' model number comes from
sModelIndexLUT in src/follow_mon.c, its sprite ID is Bulbasaur's plus that
number, the field's sprite table (src/field/object_graphics_info.c) turns the
sprite ID back into the mmodel member, and tsurepoke/tp_param holds four
bytes a model: whether it is too tall for a building and how it bounces.
Every species past Arceus had none of it and walked as Bulbasaur.

hg-engine draws one for each species at d0380a487: data/graphics/sprites/
<species>/overworld.png, its frames in overworld.json and its two palettes
(normal, shiny) in overworld-*.pal, built into a BTX0 by tools/source/btx.
Its size class is the MON_FOLLOWER_ENTRY in src/field/overworld_table.c, and
its too-tall and bounce bytes are data/FollowerProperties.c. This converts
each added species' sprite the way that tool does -- retail's own textures
come out byte for byte from the reference's pictures of them -- and appends
it after retail's: models from 566, mmodel members from 863, sprite IDs from
1050, the first number after retail's last sprite.

A species the reference has no MON_FOLLOWER_ENTRY for (the megas, the
Gigantamax and totem forms, the battle-only forms) is one hg-engine never
draws: it walks as its base species, which is what get_mon_ow_tag falls back
to. It takes its base's model here and adds none.

    import_followers.py [--reference PATH] [--write]
"""

import argparse
import io
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
COMMIT = "d0380a487"

MMODEL_DIR = ROOT / "files/data/mmodel/mmodel"
TP_PARAM = ROOT / "files/fielddata/tsurepoke/tp_param.csv"
FOLLOW_MON_C = ROOT / "src/follow_mon.c"
GRAPHICS_C = ROOT / "src/field/object_graphics_info.c"
SPECIES_H = ROOT / "include/constants/species.h"
IDX_H = ROOT / "include/constants/follow_mon_idx.h"
MMODEL_H = ROOT / "include/constants/mmodel.h"
SPRITES_H = ROOT / "include/constants/sprites.h"

FIRST_ADDED = 508               # SPECIES_LILLIPUP, after the egg and the alternate forms
RETAIL_MODELS = 566             # FOLLOWER_MON_BULBASAUR .. FOLLOWER_MON_ARCEUS_DARK
MMODEL_BASE = 297               # MMODEL_FOLLOWER_MON_BASE
FIRST_SPRITE = 1050             # after SPRITE_FOLLOWER_MON_STATIC_FERALIGATR

# The field sprite table's last field: the resource kind in the low ten bits and
# the size class above them, 19 for a 32x32 texture and 20 for a 64x64 one, as
# every one of retail's 566 followers has it.
SMALL = "0x227 | (19 << 10)"
SMALL_NO_SHADOW = "0x226 | (19 << 10)"
LARGE = "0x208 | (20 << 10)"


def show(path, reference=REFERENCE):
    return subprocess.run(["git", "-C", str(reference), "show", f"{COMMIT}:{path}"],
                          capture_output=True, check=True).stdout


def _palette(text):
    """A JASC-PAL file's colours as BGR555, the way nitrogfx reads one."""
    words = text.decode().split()
    if words[0] != "JASC-PAL":
        raise ValueError("not a JASC palette")
    values = list(map(int, words[3:3 + 3 * int(words[2])]))
    return [(r // 8) | ((g // 8) << 5) | ((b // 8) << 10)
            for r, g, b in zip(values[0::3], values[1::3], values[2::3])]


def nsbtx(directory, reference=REFERENCE):
    """tools/source/btx's BTX0 for the reference's overworld.png in directory:
    one TEX0 block, a 4bpp texture a frame, one 16-colour palette a
    palette entry, and the frame and palette names the field looks up."""
    from PIL import Image

    meta = json.loads(show(f"{directory}/overworld.json", reference))
    frames = list(meta["frames"].items())
    palettes = list(meta["palettes"].items())
    width, height = frames[0][1]["width"], frames[0][1]["height"]
    picture = Image.open(io.BytesIO(show(f"{directory}/overworld.png", reference)))
    if picture.mode != "P":
        raise ValueError(f"{directory}: not an indexed picture")
    pixels = picture.tobytes()
    if max(pixels) > 15:
        raise ValueError(f"{directory}: more than sixteen colours")
    texture = bytes(pixels[i] | (pixels[i + 1] << 4) for i in range(0, len(pixels), 2))

    out = bytearray()

    def put(offset, value, size):
        if len(out) < offset + size:
            out.extend(bytes(offset + size - len(out)))
        out[offset:offset + size] = (value & ((1 << 8 * size) - 1)).to_bytes(size, "little")

    tex, props = 0x14, 0x50
    texture_units = (max(f["frame"] for _, f in frames) + 1) * height * width // 16
    palette_info = props + 0x10 + len(frames) * 0x1C
    texture_at = palette_info + 0x10 + 0x18 * len(palettes)
    palette_at = texture_at + 8 * texture_units

    n = len(palettes)
    put(palette_info + 1, n, 1)
    put(palette_info + 2, 0x10 + n * 0x18, 2)
    put(palette_info + 4, 8, 2)
    put(palette_info + 6, 0xC + n * 4, 2)
    put(palette_info + 8, 0x17F, 4)
    put(palette_info + 0xC + 4 * n, 4, 2)
    put(palette_info + 0xE + 4 * n, 4 + 4 * n, 2)
    for i, (name, palette) in enumerate(palettes):
        put(palette_info + 0xC + 4 * i, palette["unk0"], 2)
        put(palette_info + 0xE + 4 * i, palette["unk1"], 2)
        put(palette_info + 0x10 + 4 * n + 4 * i, palette["offset"] * 4, 4)
        for j, c in enumerate(name.encode()[:16]):
            put(palette_info + 0x10 + 8 * n + 16 * i + j, c, 1)

    put(tex, 0x30584554, 4)  # "TEX0"
    put(tex + 0xC, texture_units, 2)
    put(tex + 0xE, props - tex, 2)
    put(tex + 0x14, texture_at - tex, 4)
    put(tex + 0x1E, props - tex, 2)
    put(tex + 0x24, palette_at - tex, 4)
    put(tex + 0x28, palette_at - tex, 4)
    put(tex + 0x34, palette_info - tex, 4)
    put(tex + 0x38, palette_at - tex, 4)

    m = len(frames)
    put(props + 1, m, 1)
    put(props + 2, 0x10 + m * 0x1C, 2)
    put(props + 4, 8, 2)
    put(props + 6, 0xC + m * 4, 2)
    put(props + 8, 0x17F, 4)
    for i, (_, f) in enumerate(frames):
        put(props + 0xC + 4 * i, f["unkBlockUnk0"], 2)
        put(props + 0xE + 4 * i, f["unkBlockUnk1"], 2)
    base = props + 0xC + m * 4
    put(base, 8, 2)
    put(base + 2, 4 + m * 8, 2)
    for i, (_, f) in enumerate(frames):
        params = ((f["coordTrans"] & 0x14) | (f["color0"] & 1) << 13 | (f["format"] & 7) << 10
                  | (f["height"].bit_length() - 4 & 7) << 7 | (f["width"].bit_length() - 4 & 7) << 4
                  | (f["flipY"] & 1) << 3 | (f["flipX"] & 1) << 2 | (f["repeatY"] & 1) << 1 | f["repeatX"] & 1)
        put(base + 4 + 8 * i, f["frame"] * f["width"] * f["height"] // 16, 2)
        put(base + 6 + 8 * i, params, 2)
        put(base + 8 + 8 * i, f["width"], 1)
        put(base + 9 + 8 * i, f["unk0"], 1)
        put(base + 0xA + 8 * i, f["unk1"], 1)
        put(base + 0xB + 8 * i, f["unk2"], 1)
    base += 4 + 8 * m
    for i, (name, _) in enumerate(frames):
        for j, c in enumerate(name.encode()[:16]):
            put(base + 16 * i + j, c, 1)

    put(0, 0x30585442, 4)  # "BTX0"
    put(4, 0x0001FEFF, 4)
    put(0xC, 0x10, 2)
    put(0xE, 1, 2)
    put(0x10, tex, 4)
    out.extend(bytes(max(0, texture_at + len(texture) - len(out))))
    out[texture_at:texture_at + len(texture)] = texture
    for _, palette in palettes:
        for j, colour in enumerate(_palette(show(f"{directory}/overworld-{palette['fileName']}", reference))):
            put(palette_at + palette["offset"] * 0x20 + 2 * j, colour, 2)
    total = len(out)
    put(tex + 4, total - tex, 4)
    put(tex + 0x30, (total - palette_at) // 8, 4)
    put(8, total, 4)
    return bytes(out)


def texture_width(data):
    """A follower BTX0's frame width: the texture is eight frames, square."""
    units = int.from_bytes(data[0x20:0x22], "little")
    return {512: 32, 2048: 64}[units]


def port_species():
    """The added species, number and name, from the first to NUM_SPECIES."""
    header = SPECIES_H.read_text()
    numbers = {name: int(n) for name, n in re.findall(r"^#define SPECIES_(\w+)\s+(\d+)\s*$", header, re.M)}
    last = numbers[re.search(r"^#define NUM_SPECIES SPECIES_(\w+)", header, re.M).group(1)]
    by_number = {}
    for name, n in numbers.items():
        by_number.setdefault(n, name)
    return [(n, by_number[n]) for n in range(FIRST_ADDED, last + 1)]


def reference_tables(reference=REFERENCE):
    table = dict(re.findall(r"MON_FOLLOWER_ENTRY\(SPECIES_(\w+), *(\w+)\)",
                            show("src/field/overworld_table.c", reference).decode()))
    properties = {name: (size, bounce) for name, size, bounce in re.findall(
        r"\[SPECIES_(\w+)\]\s*=\s*\{\s*\.size = (\w+), \.bounce = (\w+)\}",
        show("data/FollowerProperties.c", reference).decode())}
    forms = show("data/FormToSpeciesMapping.c", reference).decode()
    bases = dict(re.findall(r"\[SPECIES_(\w+) - SPECIES_MEGA_START\]\s*=\s*SPECIES_(\w+)", forms))
    return table, properties, bases


def retail_models():
    """sModelIndexLUT's retail entries: the model constant a species number takes."""
    source = FOLLOW_MON_C.read_text()
    body = source[source.index("static const u16 sModelIndexLUT[] = {"):]
    body = body[:body.index("FOLLOWER_MON_ARCEUS_NORMAL,") + len("FOLLOWER_MON_ARCEUS_NORMAL,")]
    return re.findall(r"(FOLLOWER_MON_\w+),", body)


def plan(reference=REFERENCE):
    """(models, lut): the added models in order, as (name, directory, size,
    bounce, sprite parameter), and the model constant of every added species."""
    table, properties, bases = reference_tables(reference)
    retail = retail_models()
    species = port_species()
    number = {name: n for n, name in species}
    models, lut = [], {}
    for n, name in species:
        if name in table:
            size, bounce = properties.get(name, ("OVERWORLD_CAN_ENTER", "OVERWORLD_BOUNCE_FAST"))
            models.append((name, f"data/graphics/sprites/{name.lower()}", size, bounce, table[name]))
            lut[name] = f"FOLLOWER_MON_{name}"
    for n, name in species:
        if name in lut:
            continue
        root = name
        while root in bases:
            root = bases[root]
        if root in lut:
            lut[name] = lut[root]
        elif root in number:
            raise SystemExit(f"{name}: its base {root} has no model either")
        else:
            header = SPECIES_H.read_text()
            lut[name] = retail[int(re.search(rf"^#define SPECIES_{root}\s+(\d+)", header, re.M).group(1))]
    return models, lut


BOUNCE = {"OVERWORLD_BOUNCE_FAST": 0x00, "OVERWORLD_BOUNCE_MED": 0x10, "OVERWORLD_BOUNCE_SLOW": 0x11}


def sprite_parameter(name, width, reference_parameter):
    """The size class the texture has. Four of the reference's entries name the
    other one (Hydrapple and Garden Vivillon draw 64 wide and say small,
    Hatterene and Dondozo draw 32 and say large); the class decides how much
    texture memory the field gives the sprite, so it follows the texture."""
    if width == 64:
        return LARGE
    return SMALL_NO_SHADOW if reference_parameter == "OVERWORLD_SIZE_SMALL_NO_SHADOW" else SMALL


def replace_block(path, start, end, lines):
    """Rewrite what lies between the line holding start and the next line
    holding end, both kept."""
    text = path.read_text()
    a = text.index(start)
    a = text.index("\n", a) + 1
    b = text.index(end, a)
    b = text.rindex("\n", 0, b) + 1
    path.write_text(text[:a] + "".join(line + "\n" for line in lines) + text[b:])


def write(models, lut, textures):
    longest = max(len(name) for name, *_ in models)
    first_model, first_member = RETAIL_MODELS, MMODEL_BASE + RETAIL_MODELS

    for i, (name, *_rest) in enumerate(models):
        (MMODEL_DIR / f"mmodel_{first_member + i:08d}.NSBTX").write_bytes(textures[name])

    replace_block(IDX_H, "#define FOLLOWER_MON_ARCEUS_DARK ", "#endif",
                  ["", "// The species New Gold adds; tools/newgold/import/import_followers.py"]
                  + [f"#define {'FOLLOWER_MON_' + name:<{longest + 13}} {first_model + i}" for i, (name, *_r) in enumerate(models)]
                  + [""])
    replace_block(MMODEL_H, "#define MMODEL_FOLLOWER_MON_ARCEUS_DARK ", "#endif",
                  ["", "// The species New Gold adds; tools/newgold/import/import_followers.py"]
                  + [f"#define {'MMODEL_FOLLOWER_MON_' + name:<{longest + 20}} {first_member + i}" for i, (name, *_r) in enumerate(models)]
                  + [""])
    replace_block(SPRITES_H, "#define SPRITE_FOLLOWER_MON_STATIC_FERALIGATR ", "#define SPRITE_CAMERA_FOCUS",
                  ["", "// The species New Gold adds; tools/newgold/import/import_followers.py"]
                  + [f"#define {'SPRITE_FOLLOWER_MON_' + name:<{longest + 20}} {FIRST_SPRITE + i}" for i, (name, *_r) in enumerate(models)]
                  + [f"#define {'SPRITE_FOLLOWER_MON_ADDED_FIRST':<{longest + 20}} {FIRST_SPRITE}",
                     f"#define {'SPRITE_FOLLOWER_MON_ADDED_LAST':<{longest + 20}} {FIRST_SPRITE + len(models) - 1}", ""])

    rows = TP_PARAM.read_text().splitlines()[:1 + RETAIL_MODELS]
    for name, _directory, size, bounce, _parameter in models:
        value = BOUNCE[bounce] if bounce in BOUNCE else int(bounce, 0)
        rows.append(f"FOLLOWER_MON_{name},0,{'true' if size == 'OVERWORLD_NO_ENTRY' else 'false'},"
                    f"{'true' if value & 0x0F else 'false'},{'true' if value & 0xF0 else 'false'},0")
    TP_PARAM.write_text("\n".join(rows) + "\n")

    replace_block(FOLLOW_MON_C, "    FOLLOWER_MON_ARCEUS_NORMAL,", "};",
                  [f"    [SPECIES_{name}] = {lut[name]}," for _n, name in port_species()])

    replace_block(GRAPHICS_C, "{ SPRITE_FOLLOWER_MON_STATIC_FERALIGATR,", "{ 0xFFFF,",
                  [f"    {{ SPRITE_FOLLOWER_MON_{name}, MMODEL_FOLLOWER_MON_{name}, "
                   f"{sprite_parameter(name, texture_width(textures[name]), parameter)} }},"
                   for name, _directory, _size, _bounce, parameter in models])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--reference", type=Path, default=REFERENCE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    models, lut = plan(args.reference)
    textures = {name: nsbtx(directory, args.reference) for name, directory, *_ in models}
    fixed = [name for name, _d, _s, _b, parameter in models
             if (sprite_parameter(name, texture_width(textures[name]), parameter) == LARGE)
             != (parameter == "OVERWORLD_SIZE_LARGE")]
    shared = len(lut) - len(models)
    print(f"{len(models)} models for {len(lut)} added species; {shared} have none and take their base species'")
    print(f"size class taken from the texture, not the reference's entry: {', '.join(fixed)}")
    if not args.write:
        print("nothing written; pass --write")
        return
    write(models, lut, textures)


if __name__ == "__main__":
    main()
