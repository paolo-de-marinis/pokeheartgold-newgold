#!/usr/bin/env python3
"""The saves the scenes start from: whitney.sav (two badges, Goldenrod) with
the Dex complete, a bag with balls, candies and potions, full boxes, a party
with a Pokemon one Rare Candy from evolving, standing wherever a scene needs.

    saves.py OUTDIR [PLACE...]

The bases are ~/hgss-saves/gyms/whitney.sav (and bugsy.sav for the Azalea
twins), only read; the saves are written to OUTDIR/PLACE.sav.
"""
import random
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import lens  # noqa: E402,F401  (puts the tree's tools on the path)
import savedit  # noqa: E402

GYMS = Path.home() / "hgss-saves/gyms"
BASE = GYMS / "whitney.sav"
PLACES = {
    "violet_pc": (158, 11, 13, 0),          # facing Violet Pokemon Center's PC
    "violet_pc_down": (158, 11, 13, 1),     # the same tile, facing away
    "daycare": (331, 3, 6, 0),              # below the Day-Care lady, facing her
    "violet_b1f": (167, 12, 5, 0),          # Violet PC B1F, below the right counter
    "violet_b1f_mid": (167, 8, 5, 0),
    "violet_b1f_left": (167, 4, 5, 0),
    "contest_gate": (104, 5, 6, 0),         # Route 36 National Park gate, across its counter
    "contest_gate35": (102, 21, 5, 0),
    "violet_door": (73, 497, 272, 0),       # Violet City, below the Pokemon Center's door, facing it
    "azalea_twins": (180, 2, 8, 0),         # below Twins Amy & Mimi in Azalea Gym, facing them
}
BASES = {"azalea_twins": GYMS / "bugsy.sav"}


def one_short(save, slot=0):
    """The party Pokemon in this slot one experience point short of its next level."""
    block = save.block("SAVE_PARTY")
    at = savedit.PARTY_AT + slot * savedit.PARTY_MON
    mon = savedit.open_mon(block[at:at + savedit.PARTY_MON])
    a = mon["blocks"][0]
    species = struct.unpack_from("<H", a, 0)[0]
    growth = savedit.personal_records()[species]["growthRate"]
    exp = struct.unpack_from("<I", a, 8)[0] & savedit.EXP_BITS
    level = savedit.level_for(growth, exp)
    word = struct.unpack_from("<I", a, 8)[0]
    struct.pack_into("<I", a, 8, (word & ~savedit.EXP_BITS & 0xFFFFFFFF) | (savedit.experience_for(growth, level + 1) - 1))
    block[at:at + savedit.PARTY_MON] = savedit.seal_mon(mon)


def make(out, place, party=None):
    save = savedit.Save(BASES.get(place, BASE))
    savedit.set_dex(save, savedit.dex_species(), True, True)
    savedit.set_dex_switches(save, True, True)
    bag = save.block("SAVE_BAG")
    for item, n in ((2, 99), (4, 99), (50, 20), (17, 50), (450, 1)):
        pocket = next(p["name"] for p in savedit.pockets()
                      if p["const"] == savedit.pocket_const(savedit.item_table()[item]["pocket"]))
        savedit.put_in_pocket(bag, pocket, item, n)
    if party and place not in BASES:
        savedit.set_party(save, party)
        one_short(save, 0)
    # Every box full: 30 boxes x 30, national order from Bulbasaur on.
    me = savedit.owner(save)
    numbers = savedit.species_numbers()
    names = [k for k, v in sorted(numbers.items(), key=lambda kv: kv[1]) if 1 <= v <= 493]
    rng = random.Random(7)
    count = 0
    for box in range(savedit.NUM_BOXES - 1):   # the last box stays empty: a catch needs room
        for slot in range(savedit.MONS_PER_BOX):
            name = names[count % len(names)]
            raw = savedit.build_mon(name, 20, personality=rng.getrandbits(32), ot_codes=me["codes"],
                                    ot_id=me["id"], ot_gender=me["gender"])
            savedit.set_box_mon(save, box, slot, raw[:savedit.BOX_MON])
            count += 1
    savedit.set_position(save, *PLACES[place])
    path = Path(out) / f"{place}.sav"
    path.write_bytes(save.image())
    return path


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    out = Path(sys.argv[1])
    out.mkdir(parents=True, exist_ok=True)
    party = [("CHARMANDER", 15, None, None), ("LUCARIO", 30, None, None), ("MACHAMP", 30, None, None),
             ("HERACROSS", 30, None, None), ("BRELOOM", 30, None, None), ("UMBREON", 30, None, None)]
    for place in sys.argv[2:] or list(PLACES):
        print(make(out, place, party))
