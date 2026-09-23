#!/usr/bin/env python3
"""Every species and form through the screens that load its pictures, its cry,
its name and its ability, in the headless harness, and a report of what failed.

    species.py OUT [--walk pc,dex,battle] [--jobs N] [--only SPECIES,...]

The ROM is the NEWGOLD_DIAG=1 HeartGold build. What each walk does:

  pc      The saves savedit makes put every variant in a box -- each species
          and form as a female where it can be one and as a male where it can
          be one, with its first, second and hidden ability -- in front of
          Violet's PC. The PC opens in Move mode, and for every box the thirty
          icons are compared with the icon PNGs, every slot is hovered (the
          front sprite against its PNG; the Dex number, the name, the types
          and the ability as text) and every slot's summary is opened on its
          Skills page (the sprite, the icon, the ability and its description
          again, and the cry the game asked for).
  dex     The Pokedex's list, the cursor on every Dex species in national
          order: the page on the top screen (the sprite against its PNG; the
          name, category, types and entry as text) and the cry X plays,
          which also says which species the cursor is on. A form species
          is seen as the form the Dex shows first.
  battle  A wild battle for every species and form, and one more for every
          ability none of those has: the variant leads the party, the wild
          one is its species (form 0, as the switch makes it), until both
          are out and the game asks for a command. The
          harness draws no battle, so a battle is its markers: the state,
          the battlers, the cries, asserts and failed allocations.

A picture passes when at least 90% of the PNG's opaque pixels are on the
screen in the PNG's colours, at the best of a few positions and both frames.
A text passes when every Pokemon that should print the same string printed
the same pixels and none that should print another did -- the Dex number,
the name, the types and the ability are not read, they are compared. Every
step also reads gDiagAssertCount, gDiagAllocFailCount and, with the cries,
gDiagCry*.

OUT gets report.txt (the failures, then a count), results.jsonl (every
record) and fail/, the screenshot of every failure; --report writes the
report again from results.jsonl. The jobs -- a box, a run of the Dex's
list, a battle -- run in parallel, one process each: --jobs is how many at
once. Each reads the ROM and the ELFs as it starts, so nothing may be built
while a run goes on.
"""
import argparse
import hashlib
import json
import multiprocessing
import os
import random
import re
import struct
import sys
import tempfile
from collections import defaultdict
from functools import cache
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent))
import savedit  # noqa: E402
from core import Core  # noqa: E402
from markers import STATES, Markers  # noqa: E402

BUILD = ROOT / "build/heartgold.us.diag"
BASE_SAVE = Path.home() / "hgss-saves/route29-official.sav"
PC_TILE = (158, 11, 13, 0)          # Violet's Pokemon Center, facing its PC (pc.py)
LEVEL = 50
PASS = 0.9
POKEGRA = ROOT / "files/poketool/pokegra"
ICONS = ROOT / "files/poketool/icongra/poke_icon"

# Where the PC and the summary draw things, in the pixels of their screen
# (the top one unless it says bottom), measured on Bulbasaur and Ivysaur.
PC_SPRITE, SUMMARY_SPRITE, SUMMARY_ICON = (100, 60), (168, 64), (199, 64)
PC_TEXT = {"dex number": (8, 40, 56, 56), "name": (60, 40, 124, 56),
           "types": (144, 40, 214, 56), "ability": (4, 136, 96, 152)}
SUMMARY_TEXT = {"summary name": (170, 30, 236, 46), "summary ability": (66, 136, 160, 152),
                "ability description": (0, 152, 160, 186)}
BOX_ICON = lambda slot: (8 + 24 * (slot % 6), 32 + 24 * (slot // 6))  # noqa: E731
# The Dex's list, measured on Bulbasaur: the page of the species under the
# cursor on the top screen.
DEX_SPRITE = (8, 32)
DEX_TEXT = {"dex name": (150, 24, 244, 40), "category": (106, 40, 246, 56),
            "dex types": (144, 64, 240, 80), "entry": (16, 134, 240, 186)}
DEX_CHUNK = 128
# sub_02006A0C: Sky Shaymin's cry is asked for under a number of its own.
SKY_SHAYMIN_CRY = 0x1EE
# ov18_021E595C and ov18_021E59A8: the category and the HeartGold entry,
# one row per species.
DEX_CATEGORIES, DEX_ENTRIES = 816, 803
ABILITY_TEXT = 722   # the descriptions sub_0208D178 prints
BATTLE_MAIN, EXIT = STATES.index("BATTLE_MAIN"), STATES.index("EXIT")
RUN = (128, 170)   # the bottom screen's RUN, under FIGHT (gym.py)


# ---------------------------------------------------------------------------
# What there is to see.

def form_species():
    """The retail species whose every form is drawn from otherpoke.narc
    (GetMonSpriteCharAndPlttNarcIdsEx), with the number of forms each has and
    each form's folder, in the order otherpoke.txt builds them."""
    counts = {m.group(1): int(m.group(2)) for m in
              re.finditer(r"(\w+)_FORM_MAX = (\d+)", (ROOT / "include/constants/pokemon.h").read_text())}
    counts["SHAYMIN"] = 2
    folders = defaultdict(list)
    for line in (POKEGRA / "otherpoke.txt").read_text().splitlines():
        m = re.match(r"files/poketool/pokegra/otherpoke/(\w+)/(\w+)/front\.png\s+\S+\.NCGR", line)
        if m and m.group(2) not in folders[m.group(1)]:
            folders[m.group(1)].append(m.group(2))
    return {name: (counts[name], folders[name.lower()]) for name in counts
            if name != "EGG" and name.lower() in folders}


@cache
def entries():
    """Every variant to look at, numbered in the order the boxes hold them."""
    numbers = savedit.species_numbers()
    records = savedit.personal_records()
    abilities = savedit.ability_numbers()
    battle_only = savedit.battle_forms()
    forms = form_species()
    out = []

    def add(species, form, kind):
        record = records[savedit.personal_row(species, form)]
        ratio = savedit.GENDER_RATIO(record["genderRatio"])
        genders = {255: [2], 0: [0], 254: [1]}.get(ratio, [1, 0])
        slots = [a for a in record["abilities"] if a != "ABILITY_NONE"]
        hidden = record.get("hiddenAbility", "ABILITY_NONE")
        wanted = [(genders[0], 0, False)]
        if len(genders) > 1:
            wanted.append((genders[1], 1 if len(slots) > 1 else 0, False))
        elif len(slots) > 1 and slots[0] != slots[1]:
            wanted.append((genders[0], 1, False))
        if hidden != "ABILITY_NONE" and hidden not in slots:
            wanted.append((genders[0], 0, True))
        for gender, slot, ha in wanted:
            out.append({"n": len(out), "species": species, "form": form, "gender": gender,
                        "slot": slot, "hidden": ha, "kind": kind,
                        "ability": abilities[(hidden if ha else slots[slot] if slots else "ABILITY_NONE")[8:]]})

    for row in savedit.species_table():
        species = row["id"]
        if row["egg"] or not row["pick"] and species not in battle_only:
            continue
        name = next((k for k, v in numbers.items() if v == species), "")
        if name in forms:
            for form in range(forms[name][0]):
                add(species, form, "form" if form else "species")
        else:
            add(species, 0, "battle form" if species in battle_only else "species")
    return out


def label(e):
    const = next((k for k, v in savedit.species_numbers().items() if v == e["species"]), str(e["species"]))
    forms = form_species()
    text = const + (f" ({forms[const][1][e['form']]})" if const in forms and e["form"] < len(forms[const][1]) else "")
    text += {0: " male", 1: " female", 2: ""}[e["gender"]]
    return text + (" hidden" if e["hidden"] else f" ability {e['slot'] + 1}")


def unown_personality(letter, rng):
    """A personality GetBoxMonUnownLetter reads as this letter."""
    while True:
        p = rng.getrandbits(32)
        if ((p & 0x3000000) >> 18 | (p & 0x30000) >> 12 | (p & 0x300) >> 6 | (p & 0x3)) % 28 == letter:
            return p


def make_mon(e, me, rng):
    """A box Pokemon of the player's own for one entry: its species and form,
    a personality that gives its gender and ability slot, never shiny."""
    species, form = e["species"], e["form"]
    record = savedit.personal_records()[savedit.personal_row(species, form)]
    ratio = savedit.GENDER_RATIO(record["genderRatio"])
    unown = species == savedit.species_numbers()["UNOWN"]
    two = len([a for a in record["abilities"] if a != "ABILITY_NONE"]) > 1
    while True:
        p = unown_personality(form, rng) if unown else rng.getrandbits(32)
        # The low bit picks the ability only where there are two to pick from;
        # an Unown's letter owns it otherwise.
        if savedit.is_shiny(p, me["id"]) or two and (p & 1) != e["slot"]:
            continue
        if ratio not in (0, 254, 255) and (1 if ratio > (p & 0xFF) else 0) != e["gender"]:
            continue
        break
    const = next(k for k, v in savedit.species_numbers().items() if v == species)
    raw = savedit.build_mon(const, LEVEL, personality=p, moves=savedit.moveset(species, LEVEL) or [1],
                            ot_codes=me["codes"], ot_id=me["id"], ot_gender=me["gender"])
    mon = savedit.open_mon(raw)
    a, b, c, _ = mon["blocks"]
    b[0x18] = (b[0x18] & 7) | (form << 3)
    if e["hidden"]:
        b[0x19] |= savedit.HIDDEN_ABILITY_BIT << 6
    savedit._set_ability(a, b, p, savedit.personal_row(species, form))
    codes = savedit.encode_text(savedit.species_name(species), savedit.POKEMON_NAME_LENGTH)
    c[0:2 * (savedit.POKEMON_NAME_LENGTH + 1)] = struct.pack(
        f"<{savedit.POKEMON_NAME_LENGTH + 1}H", *codes + [0] * (savedit.POKEMON_NAME_LENGTH + 1 - len(codes)))
    return savedit.seal_mon(mon)


def make_saves(out, wanted):
    """As many saves as it takes, 900 Pokemon each, standing at the PC with
    the Dex complete. Returns [(save path, [entry numbers by box])]."""
    rng = random.Random(1)
    saves = []
    for first in range(0, len(wanted), savedit.NUM_BOXES * savedit.MONS_PER_BOX):
        chunk = wanted[first:first + savedit.NUM_BOXES * savedit.MONS_PER_BOX]
        save = savedit.Save(BASE_SAVE)
        me = savedit.owner(save)
        for i, e in enumerate(chunk):
            savedit.set_box_mon(save, i // savedit.MONS_PER_BOX, i % savedit.MONS_PER_BOX,
                                make_mon(e, me, rng)[:savedit.BOX_MON])
        savedit.set_dex(save, savedit.dex_species(), True, True)
        savedit.set_dex_switches(save, True, True)
        savedit.set_position(save, *PC_TILE)
        path = out / f"boxes{len(saves) + 1}.sav"
        path.write_bytes(save.image())
        boxes = [[e["n"] for e in chunk[b:b + savedit.MONS_PER_BOX]] for b in range(0, len(chunk), savedit.MONS_PER_BOX)]
        saves.append((path, boxes))
    return saves


# ---------------------------------------------------------------------------
# The pictures the tree says there should be.

def _palette_of(png):
    from PIL import Image
    flat = Image.open(png).getpalette()
    return [tuple(flat[i:i + 3]) for i in range(0, 48, 3)]


@cache
def _frames(png, size, palette=None):
    """The opaque pixels of each frame of an indexed PNG: [(x, y, rgb)]."""
    from PIL import Image
    im = Image.open(png)
    colours = list(palette) if palette else _palette_of(png)
    px = im.load()
    frames = []
    for f in range(max(im.size) // size):
        ox, oy = (f * size, 0) if im.size[0] > im.size[1] else (0, f * size)
        frames.append([(x, y, colours[px[ox + x, oy + y]]) for y in range(size) for x in range(size)
                       if px[ox + x, oy + y]])
    return frames


def sprite_png(e):
    const = next(k for k, v in savedit.species_numbers().items() if v == e["species"])
    forms = form_species()
    if const in forms:
        return POKEGRA / "otherpoke" / const.lower() / forms[const][1][e["form"]] / "front.png"
    return POKEGRA / "pokegra" / f"{e['species']:04d}" / ("female" if e["gender"] == 1 else "male") / "front.png"


@cache
def _icon_tables():
    source = (ROOT / "src/pokemon_icon_idx.c").read_text()
    body = source[source.index("sPokemonPalNoBySpeciesAndForm[] = {"):]
    palettes = [int(n) for n in re.findall(r"^\s*(\d+)\s*,", body[:body.index("};")], re.M)]
    header = (ROOT / "include/pokemon_icon_idx.h").read_text()
    first = {n: int(re.search(rf"#define {n}\s+(\d+)", header).group(1)) for n in ("FIRST_ADDED_ICON", "FIRST_ADDED_PALETTE")}
    words = (ICONS / "poke_icon_00000000.pal").read_text().split()
    colours = [tuple(map(int, words[3 + 3 * i:6 + 3 * i])) for i in range(int(words[2]))]
    return palettes, first, colours


# GetMonIconNaixEx and GetMonIconPaletteEx, src/pokemon_icon_idx.c: the
# first form's icon and palette of each species with form icons.
ICON_FORMS = {"DEOXYS": (503, 496), "UNOWN": (507, 499), "BURMY": (534, 527), "WORMADAM": (536, 529),
              "SHELLOS": (538, 531), "GASTRODON": (539, 532), "GIRATINA": (540, 533),
              "SHAYMIN": (541, 534), "ROTOM": (542, 535)}


def icon_png(e):
    """The icon file and its palette, as GetMonIconNaixEx and
    GetMonIconPaletteEx choose them."""
    palettes, first, colours = _icon_tables()
    species, form = e["species"], e["form"]
    const = next(k for k, v in savedit.species_numbers().items() if v == species)
    numbers = savedit.species_numbers()
    if form and const in ICON_FORMS:
        icon, row = ICON_FORMS[const][0] + form - 1, ICON_FORMS[const][1] + form - 1
    elif species > numbers["ARCEUS"]:
        icon = species - numbers["LILLIPUP"] + first["FIRST_ADDED_ICON"]
        row = species - numbers["LILLIPUP"] + first["FIRST_ADDED_PALETTE"]
    else:
        icon, row = species + 7, species
    palette = tuple(colours[palettes[row] * 16:palettes[row] * 16 + 16])
    return ICONS / f"poke_icon_{icon:08d}.png", palette


def _close(a, b):
    return all(abs((p >> 3) - (q >> 3)) <= 1 for p, q in zip(a, b))


def _score(px, size, pixels, ox, oy, step=1):
    hit = n = 0
    for x, y, c in pixels[::step]:
        n += 1
        if 0 <= ox + x < size[0] and 0 <= oy + y < size[1] and _close(px[ox + x, oy + y], c):
            hit += 1
    return hit / n if n else 0.0


def match(screen, frames, at, spread):
    """How much of the picture is on the screen near `at`: the best of both
    frames over a small square of positions, a coarse pass and then a full one."""
    px, size = screen.load(), screen.size
    places = [(at[0] + dx, at[1] + dy) for dx in range(-spread, spread + 1) for dy in range(-spread, spread + 1)]
    coarse = sorted(((_score(px, size, f, x, y, 5), i, x, y) for i, f in enumerate(frames) for x, y in places),
                    reverse=True)[:3]
    return max(_score(px, size, frames[i], x, y) for _, i, x, y in coarse)


def region(image, box, keep=None):
    """A hash of what a box of the screen shows; the picture itself goes to
    `keep` the first time those pixels are seen, for the report to point at."""
    crop = image.crop(box)
    digest = hashlib.sha1(crop.tobytes()).hexdigest()[:16]
    if keep is not None and not (keep / f"{digest}.png").exists():
        keep.mkdir(parents=True, exist_ok=True)
        crop.save(keep / f"{digest}.png")
    return digest


def regions(image, boxes, out):
    return {k: region(image, v, out / "text" / k.replace(" ", "_")) for k, v in boxes.items()}


# ---------------------------------------------------------------------------
# Driving the game.

class Game:
    def __init__(self, save, build=BUILD):
        self.core = Core(build / "pokeheartgold.us.nds", save=save)
        self.markers = Markers(build / "main.elf")
        ignore = self.markers.address("gDiagIgnoreCommunicationError")
        self.hold = [lambda c: c.poke(ignore, 1)]

    def step(self, frames):
        self.core.step(frames, self.hold)

    def press(self, button, wait=0):
        self.core.press(button, 6, self.hold)
        self.step(wait)

    def touch(self, x, y, wait=0):
        self.core.touch(x, y, 6, self.hold)
        self.step(wait)

    def shot(self):
        return self.core.shot(self.hold)

    def still(self, score, looks=4, wait=60):
        """The screen and how well its sprite scores, looked at again while
        the score is low: a sprite in the middle of its animation (Pichu's
        hop, Mareep's sway) matches its PNG badly."""
        screen = self.shot()
        best = score(screen)
        for _ in range(looks):
            if best >= PASS:
                break
            self.step(wait)
            again = self.shot()
            if score(again) > best:
                screen, best = again, score(again)
        return screen, best

    def read(self, name):
        return self.markers.read(self.core.ram(), name)

    def counters(self):
        ram = self.core.ram()
        r = lambda n: self.markers.read(ram, n)  # noqa: E731
        return {"asserts": r("gDiagAssertCount"), "allocs": r("gDiagAllocFailCount"),
                "cries": r("gDiagCryCount"), "cry species": r("gDiagCrySpecies"),
                "cry bank": r("gDiagCryBank"), "cry started": r("gDiagCryStarted")}

    def failure(self):
        """The last assertion or failed allocation, in words."""
        text = self.markers.describe(self.core.ram())
        return " | ".join(p for p in text.split(" | ") if p.startswith(("asserts", "alloc")))

    def open_pc(self):
        """Continue, the PC, the storage system in Move mode. The first choice
        is Deposit, which opens as soon as A is pressed often enough; leaving it
        puts the cursor back on Deposit, and the one below is Move."""
        for _ in range(440):
            self.press("A", 40)
            if "HEAP_ID_10" in self.markers.heaps(self.core.ram()):
                break
        else:
            raise RuntimeError("the storage system never opened: " + self.markers.describe(self.core.ram()))
        self.step(400)
        for button, wait in (("B", 100), ("DOWN", 20), ("A", 250), ("DOWN", 20), ("A", 400)):
            self.press(button, wait)

    def close(self):
        self.core.close()


def quiet():
    """The core prints its own diagnostics to the process's stdout."""
    null = os.open(os.devnull, os.O_WRONLY)
    os.dup2(null, 1)
    os.dup2(null, 2)


SNAKE = [r * 6 + (c if r % 2 == 0 else 5 - c) for r in range(5) for c in range(6)]


def pc_box(job):
    """One box: its icons, a hover over every slot, then every summary."""
    save, box, numbers, out = job
    quiet()
    table = {e["n"]: e for e in entries()}
    game = Game(save)
    records, shots = [], {}
    try:
        game.open_pc()
        # The icons are looked at with the cursor on the box's name: over
        # the first slot, its hand hides part of that icon.
        game.press("UP", 20)
        for _ in range(box):
            game.press("RIGHT", 40)
        game.step(30)
        before = game.counters()
        screen = game.shot()
        bottom = screen.crop((0, 192, 256, 384))
        # The icons, all thirty at once.
        for slot, n in enumerate(numbers):
            png, palette = icon_png(table[n])
            score = match(bottom, _frames(png, 32, palette), BOX_ICON(slot), 3)
            records.append({"n": n, "walk": "pc icon", "score": score})
            if problems(records[-1], table[n]):
                shots[f"{n:04d}_pc_icon"] = screen
        # The hover: the cursor snakes through the rows.
        game.press("DOWN", 30)
        position = 0
        for slot in [s for s in SNAKE if s < len(numbers)]:
            while position != slot:
                if position // 6 < slot // 6:
                    game.press("DOWN")
                    position += 6
                else:
                    game.press("RIGHT" if slot > position else "LEFT")
                    position += 1 if slot > position else -1
            game.step(12)
            screen = game.shot()
            top = screen.crop((0, 0, 256, 192))
            now = game.counters()
            e = table[numbers[slot]]
            record = {"n": e["n"], "walk": "pc", "score": match(top, _frames(sprite_png(e), 80), PC_SPRITE, 3),
                      "asserts": now["asserts"] - before["asserts"], "allocs": now["allocs"] - before["allocs"],
                      "text": regions(top, PC_TEXT, out)}
            if record["asserts"] or record["allocs"]:
                record["failure"] = game.failure()
            before = now
            records.append(record)
            if problems(record, e):
                shots[f"{e['n']:04d}_pc"] = screen
        # Back to the first slot, and its summary on the Skills page.
        # A press while the cursor still glides is lost: each one waits.
        for _ in range(position // 6):
            game.press("UP", 10)
        for _ in range(position % 6):
            game.press("LEFT", 10)
        game.step(30)
        before = game.counters()
        game.press("A", 40)
        game.press("DOWN", 20)
        game.press("A", 250)
        game.press("RIGHT", 80)
        for i, n in enumerate(numbers):
            if i:
                game.press("DOWN")
            # The sprite plays its animation first: Unown and Deoxys only
            # hold still after about a hundred frames.
            game.step(140)
            e = table[n]
            screen, score = game.still(lambda image: match(image.crop((0, 0, 256, 192)),
                                                           _frames(sprite_png(e), 80), SUMMARY_SPRITE, 3))
            top, bottom = screen.crop((0, 0, 256, 192)), screen.crop((0, 192, 256, 384))
            now = game.counters()
            icon, palette = icon_png(e)
            record = {"n": n, "walk": "summary", "score": score,
                      "icon": match(bottom, _frames(icon, 32, palette), SUMMARY_ICON, 3),
                      "asserts": now["asserts"] - before["asserts"], "allocs": now["allocs"] - before["allocs"],
                      "cry": {"asked": now["cries"] - before["cries"], "species": now["cry species"],
                              "bank": now["cry bank"], "started": now["cry started"]},
                      "text": regions(top, SUMMARY_TEXT, out)}
            if record["asserts"] or record["allocs"]:
                record["failure"] = game.failure()
            before = now
            records.append(record)
            if problems(record, e):
                shots[f"{n:04d}_summary"] = screen
    except Exception as error:  # a box that stops is a result too
        records.append({"n": numbers[0], "walk": "pc box", "error": f"box {box + 1} of {save.name}: {error}"})
        shots[f"box{box + 1:02d}_{save.stem}_stopped"] = game.shot()
    finally:
        for name, image in shots.items():
            image.save(out / "fail" / f"{name}.png")
        game.close()
    return records


def field_up(game):
    """Whether Continue has reached the field (sFieldSysPtr has a map)."""
    import where
    return where.look(game.core.ram(), game.markers.address("sFieldSysPtr"),
                      game.markers.page, game.markers.sector) is not None


def continue_game(game):
    for _ in range(200):
        game.press("A", 30)
        if field_up(game):
            game.step(120)
            return
    raise RuntimeError("Continue never reached the field")


@cache
def national_order():
    """The species in the order the Dex lists them: the national sort list."""
    data = json.loads((ROOT / "files/application/zukanlist/zkn_data/zukan_data.json").read_text())
    mons = next(o for o in data["sorting"][0]["options"] if o["id"] == "national")["mons"]
    return [savedit.species_numbers()[m[len("SPECIES_"):]] for m in mons]


def dex_jobs(out, wanted):
    """A save with every Dex species seen and caught, standing in Violet's
    Pokemon Center, and the Dex's list cut into runs of DEX_CHUNK places."""
    save = savedit.Save(BASE_SAVE)
    savedit.set_dex(save, savedit.dex_species(), True, True)
    savedit.set_dex_switches(save, True, True)
    savedit.set_position(save, PC_TILE[0], PC_TILE[1], PC_TILE[2], 1)
    path = out / "dex.sav"
    path.write_bytes(save.image())
    species = {e["species"] for e in wanted}
    places = [i for i, s in enumerate(national_order()) if s in species]
    return [(path, places[i:i + DEX_CHUNK], out) for i in range(0, len(places), DEX_CHUNK)]


def dex_pages(job):
    """The Dex's list, from the start menu, the cursor moved onto every place
    of the run: the page it shows on the top screen, and the cry X plays. The
    cry says which species the cursor is on, so a press the list swallowed
    is seen and made up for."""
    save, places, out = job
    quiet()
    order = national_order()
    first = {}
    for e in entries():
        first.setdefault(e["species"], e)
    game = Game(save)
    records, shots, at = [], {}, 0
    try:
        continue_game(game)
        for button, wait in (("X", 30), ("A", 200), ("A", 200)):
            game.press(button, wait)
        for place in places:
            before = game.counters()
            # The list swallows a press now and then while it scrolls, one
            # in fifteen however slowly they come, so the walk goes by what
            # the cry says and closes the gap until there is none.
            for _ in range(12):
                while at != place:
                    game.press("RIGHT" if place > at else "LEFT", 6 if abs(place - at) > 1 else 10)
                    at += 1 if place > at else -1
                game.step(30)
                asked = game.counters()["cries"]
                game.press("X", 4)
                now = game.counters()
                if now["cries"] == asked:
                    continue
                shown = now["cry species"] & 0xFFFF
                if shown in order and order.index(shown) != place:
                    at = order.index(shown)
                    continue
                break
            e = first[order[place]]
            # The Dex draws the form its cry names, and the gender seen first;
            # a species of one gender has an empty file for the other.
            if label(e).split(" ")[0] in form_species():
                pictures = [sprite_png({**e, "form": now["cry species"] >> 16})]
            else:
                pictures = [png for g in ("male", "female")
                            if (png := POKEGRA / "pokegra" / f"{e['species']:04d}" / g / "front.png").stat().st_size]
            screen, score = game.still(lambda image: max(match(image.crop((0, 0, 256, 192)), _frames(png, 80),
                                                               DEX_SPRITE, 3) for png in pictures))
            top = screen.crop((0, 0, 256, 192))
            record = {"n": e["n"], "walk": "dex", "place": place + 1, "score": score,
                      "asserts": now["asserts"] - before["asserts"], "allocs": now["allocs"] - before["allocs"],
                      "cry": {"asked": now["cries"] - before["cries"], "species": now["cry species"],
                              "bank": now["cry bank"], "started": now["cry started"]},
                      "text": regions(top, DEX_TEXT, out)}
            if record["asserts"] or record["allocs"]:
                record["failure"] = game.failure()
            records.append(record)
            if problems(record, e):
                shots[f"{e['n']:04d}_dex"] = screen
            if record["asserts"]:
                break   # the game has gone to its error screen
    except Exception as error:
        records.append({"n": first[order[places[0]]]["n"], "walk": "dex",
                        "error": f"the Dex from place {places[0] + 1}: {error}"})
        shots[f"dex{places[0] + 1:04d}_stopped"] = game.shot()
    finally:
        for name, image in shots.items():
            image.save(out / "fail" / f"{name}.png")
        game.close()
    return records


def battle(job):
    """One species against itself: it leads the party and the wild battle
    is against it, until the game asks for a command."""
    n, out = job
    quiet()
    e = {x["n"]: x for x in entries()}[n]
    temp = Path(tempfile.mkdtemp(prefix="newgold-species-"))
    save = savedit.Save(BASE_SAVE)
    me = savedit.owner(save)
    raw = make_mon(e, me, random.Random(n))
    mon = savedit.open_mon(raw)
    mon["party"] = bytearray(savedit.PARTY_MON - savedit.BOX_MON)
    savedit._set_party_stats(mon, LEVEL)
    block = save.block("SAVE_PARTY")
    struct.pack_into("<ii", block, 0, savedit.PARTY_SIZE, 1)
    block[8:8 + savedit.PARTY_MON] = savedit.seal_mon(mon)
    savedit.set_position(save, PC_TILE[0], PC_TILE[1], PC_TILE[2], 1)   # facing away from the PC
    (temp / "battle.sav").write_bytes(save.image())
    game = Game(temp / "battle.sav")
    record = {"n": n, "walk": "battle"}
    try:
        continue_game(game)
        before = game.counters()
        game.core.poke(game.markers.address("gDiagForceBattleSpecies"), e["species"], 2)
        game.core.press("DOWN", 16, game.hold)
        prompt = None
        for _ in range(600):
            game.step(10)
            state, prompt = game.read("gDiagBattleState"), game.read("gDiagBattlePrompt")
            if state == BATTLE_MAIN and prompt in (1, 2) or state == EXIT:
                break
        now = game.counters()
        view = game.markers.battle(game.core.ram())
        record.update(state=STATES[state] if state < len(STATES) else state, prompt=prompt, battlers=view,
                      asserts=now["asserts"] - before["asserts"], allocs=now["allocs"] - before["allocs"],
                      cry={"asked": now["cries"] - before["cries"], "species": now["cry species"],
                           "bank": now["cry bank"], "started": now["cry started"]})
        if record["asserts"] or record["allocs"]:
            record["failure"] = game.failure()
    except Exception as error:
        record["error"] = str(error)
    finally:
        game.close()
    return [record]


# ---------------------------------------------------------------------------
# What the records say.

@cache
def _dex_tables():
    numbers = savedit.species_numbers()
    source = (ROOT / "src/pokedex.c").read_text()
    base = {numbers[a]: numbers[b] for a, b in
            re.findall(r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_(\w+)", source)}
    national = {numbers[a]: int(b) for a, b in re.findall(r"\[SPECIES_(\w+) - LAST_DEX_GAP - 1\] = (\d+)", source)}
    return base, national


def dex_species(species):
    """SpeciesToDexSpecies: a form past the last Dex species counts as its base."""
    return _dex_tables()[0].get(species, species)


def dex_number(species):
    """The number the game prints: SpeciesToNationalDexNo of the Dex species.
    A species past the Dex gap has a number of its own, and the two Galarian
    forms kept as species of their own print their base's."""
    return _dex_tables()[1].get(dex_species(species), dex_species(species))


def expected_text(e):
    """What each compared region should say, as a key: equal keys, equal pixels."""
    record = savedit.personal_records()[savedit.personal_row(e["species"], e["form"])]
    types = tuple(dict.fromkeys(record["types"]))
    name = savedit.species_name(e["species"])
    species = dex_species(e["species"])
    ability, description = savedit.bank(savedit.ABILITY_NAMES)[e["ability"]], savedit.bank(ABILITY_TEXT)[e["ability"]]
    return {"dex number": dex_number(e["species"]), "name": name, "types": types,
            "ability": ability, "summary name": name, "summary ability": ability,
            "ability description": description, "dex name": name, "dex types": types,
            "category": savedit.bank(DEX_CATEGORIES)[species], "entry": savedit.bank(DEX_ENTRIES)[species]}


def text_failures(records, table):
    """Every region whose pixels disagree with what it should say: one string
    drawn two ways, or two strings drawn the same way."""
    seen = defaultdict(lambda: defaultdict(set))    # region -> key -> pixels
    drawn = defaultdict(lambda: defaultdict(set))   # region -> pixels -> keys
    who = defaultdict(list)                         # (region, key, pixels) -> entries
    for r in records:
        for region_name, pixels in r.get("text", {}).items():
            key = expected_text(table[r["n"]])[region_name]
            seen[region_name][key].add(pixels)
            drawn[region_name][pixels].add(key)
            who[region_name, key, pixels].append(r["n"])
    out = []
    for region_name, keys in seen.items():
        for key, variants in keys.items():
            if len(variants) > 1:
                counts = sorted(variants, key=lambda p: -len(who[region_name, key, p]))
                for odd in counts[1:]:
                    out.append((region_name, who[region_name, key, odd],
                                f"{region_name}: {key!r} drawn another way than by its other "
                                f"{len(who[region_name, key, counts[0]])}", odd))
        for pixels, shared in drawn[region_name].items():
            if len(shared) > 1:
                names = sorted(shared, key=lambda k: -len(who[region_name, k, pixels]))
                for key in names[1:]:
                    out.append((region_name, who[region_name, key, pixels],
                                f"{region_name}: {key!r} drawn exactly like {names[0]!r}", pixels))
    return out


def problems(record, e):
    """What is wrong in one record, in words."""
    out = []
    if record.get("error"):
        out.append(record["error"])
    if record.get("asserts"):
        out.append(f"{record['asserts']} assertion(s): {record.get('failure', '')}")
    if record.get("allocs"):
        out.append(f"{record['allocs']} failed allocation(s): {record.get('failure', '')}")
    # Spinda's spots are drawn on its picture from the personality, and a
    # box's wide icons overlap: Ho-Oh's covers a tenth of a Lugia beside it.
    # The summary shows the icon alone, at the full PASS.
    floor = 0.8 if e["species"] == savedit.species_numbers()["SPINDA"] or record["walk"] == "pc icon" else PASS
    for key, what in (("score", "picture"), ("icon", "icon")):
        if key in record and record[key] < floor:
            out.append(f"{what} matches its PNG at {record[key]:.0%}")
    cry = record.get("cry")
    if cry is not None:
        # The form a cry is asked with only tells Sky Shaymin apart, and a
        # delayed cry (sub_02006920) drops it, so the species is compared.
        asked = e["species"]
        if (e["species"], e["form"]) == (savedit.species_numbers()["SHAYMIN"], 1):
            asked = SKY_SHAYMIN_CRY
        if not cry["asked"]:
            out.append("no cry asked for")
        elif not cry["started"]:
            out.append(f"the cry (bank {cry['bank']}) did not start")
        elif record["walk"] != "battle" and cry["species"] & 0xFFFF != asked:
            out.append(f"the cry asked for was species {cry['species'] & 0xFFFF}")
        elif cry["bank"] == 1 and dex_number(e["species"]) != 1:
            out.append("the cry fell back to bank 1 (Bulbasaur's)")
    if record["walk"] == "battle" and not record.get("error") and (record.get("state") != "BATTLE_MAIN"
                                                                   or record.get("prompt") not in (1, 2)):
        out.append(f"the battle stopped at {record.get('state')} prompt {record.get('prompt')}")
    return out


def report(out, records):
    table = {e["n"]: e for e in entries()}
    lines, failed = [], defaultdict(list)
    for r in records:
        for what in problems(r, table[r["n"]]):
            failed[r["n"]].append(f"{r['walk']}: {what}")
    for region_name, numbers, what, pixels in text_failures(records, table):
        for n in numbers:
            failed[n].append(f"text: {what} (text/{region_name.replace(' ', '_')}/{pixels}.png)")
    for n in sorted(failed):
        lines.append(f"{n:4d} {label(table[n])}")
        lines += [f"       {what}" for what in failed[n]]
    walks = defaultdict(int)
    for r in records:
        walks[r["walk"]] += 1
    species = {(table[r["n"]]["species"], table[r["n"]]["form"]) for r in records}
    lines.append("")
    lines.append(f"{len(species)} species and forms, {len({r['n'] for r in records})} variants; "
                 + ", ".join(f"{walk} {count}" for walk, count in sorted(walks.items()))
                 + f"; {len(failed)} variants with a failure")
    (out / "report.txt").write_text("\n".join(lines) + "\n")
    return lines


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("out", type=Path)
    parser.add_argument("--walk", default="pc,dex,battle")
    parser.add_argument("--jobs", type=int, default=max(1, (os.cpu_count() or 2) - 4))
    parser.add_argument("--only", help="species constants or numbers, comma separated")
    parser.add_argument("--report", action="store_true", help="only write the report from results.jsonl")
    args = parser.parse_args()
    out = args.out
    (out / "fail").mkdir(parents=True, exist_ok=True)
    results = out / "results.jsonl"
    if not args.report:
        wanted = entries()
        if args.only:
            numbers = savedit.species_numbers()
            pick = {int(s) if s.isdigit() else numbers[s.upper()] for s in args.only.split(",")}
            wanted = [e for e in wanted if e["species"] in pick]
        jobs = []
        walks = args.walk.split(",")
        if "pc" in walks:
            for save, boxes in make_saves(out, wanted):
                jobs += [(pc_box, (save, box, numbers, out)) for box, numbers in enumerate(boxes)]
        if "dex" in walks:
            jobs += [(dex_pages, job) for job in dex_jobs(out, wanted)]
        if "battle" in walks:
            # Every species and form once, and every ability once more on a
            # variant that has it: an ability that acts on entry is what can
            # hold up the start of a battle.
            firsts = {}
            for e in wanted:
                firsts.setdefault((e["species"], e["form"]), e["n"])
            covered = {e["ability"] for e in wanted if firsts[e["species"], e["form"]] == e["n"]}
            for e in wanted:
                if e["ability"] not in covered:
                    covered.add(e["ability"])
                    firsts[e["n"]] = e["n"]
            jobs += [(battle, (n, out)) for n in firsts.values()]
        results.write_text("")
        with multiprocessing.get_context("fork").Pool(args.jobs, maxtasksperchild=1) as pool:
            for done, records in enumerate(pool.imap_unordered(run, jobs), 1):
                with results.open("a") as f:
                    f.writelines(json.dumps(r) + "\n" for r in records)
                print(f"{done}/{len(jobs)}", file=sys.stderr, flush=True)
    records = [json.loads(line) for line in results.read_text().splitlines() if line]
    lines = report(out, records)
    print("\n".join(lines[-40:]))


def run(job):
    """One job; one that fails outright is a record too, not the end of the run."""
    function, argument = job
    try:
        return function(argument)
    except Exception as error:
        first = argument[0] if function is battle else argument[2][0] if function is pc_box else None
        return [{"n": first if first is not None else entries()[0]["n"], "walk": function.__name__,
                 "error": f"{function.__name__}: {error!r}"}]


if __name__ == "__main__":
    main()
