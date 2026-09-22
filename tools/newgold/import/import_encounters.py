#!/usr/bin/env python3
"""Bring New Gold's wild encounters into the native encounter table.

files/fielddata/encountdata/gs_enc_data.json is already a text source with the
same shape as the reference's table: twelve land slots with a level and a
morning, day and night species, then surf, rock smash and the three rods. The
entries are in the same order on both sides and are matched by map code, taken
from the reference's ENCDATA name.

A map naming a species this repository does not define is reported and left
untouched rather than half-written.

Usage: import_encounters.py REFERENCE_CHECKOUT [--write] [--map CODE]
"""

import argparse
import collections
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ENCOUNTERS = ROOT / "files/fielddata/encountdata/gs_enc_data.json"

RODS = (("oldRodSlots", "old_rod", "rateOldRod"),
        ("goodRodSlots", "good_rod", "rateGoodRod"),
        ("superRodSlots", "super_rod", "rateSuperRod"))


def keep_version_split(existing, wanted):
    """Write New Gold's value into HeartGold's side and leave SoulSilver's.

    The native table carries a HEARTGOLD and a SOULSILVER value wherever the two
    games differ, and the reference, which is a HeartGold hack, has only one. A
    plain overwrite would hand SoulSilver HeartGold's wild Pokemon.
    """
    if isinstance(existing, dict) and set(existing) == {"HEARTGOLD", "SOULSILVER"}:
        return {"HEARTGOLD": wanted, "SOULSILVER": existing["SOULSILVER"]}
    if isinstance(existing, dict) and isinstance(wanted, dict):
        return {key: keep_version_split(existing.get(key), value) for key, value in wanted.items()}
    if isinstance(existing, list) and isinstance(wanted, list):
        return [keep_version_split(existing[i] if i < len(existing) else None, value)
                for i, value in enumerate(wanted)]
    return wanted


def species_constants():
    return set(re.findall(r"#define (SPECIES_[A-Z0-9_]+)",
                          (ROOT / "include/constants/species.h").read_text()))


def map_code(name):
    """The map the native table calls this entry."""
    first, _, rest = name.partition("_")
    if first == "UNUSED":
        # The reference keeps the number in the name; the native table uses it
        # bare for one of them and spelled out for the others.
        number = rest.split("_")[0]
        return number if number == "090" else f"UNUSED_{number}"
    return first


def entries(reference):
    """Split the reference table into one text block per map code."""
    source = (reference / "data/Encounters.c").read_text(errors="replace")
    # Two entries are indented by three spaces rather than four.
    blocks = re.split(r"\n\s*\[ENCDATA_([A-Z0-9_]+)\] = \{", source)
    table = {}
    for i in range(1, len(blocks), 2):
        code = map_code(blocks[i])
        if code in table:
            raise SystemExit(f"two reference entries claim the map {code}")
        table[code] = blocks[i + 1]
    return table


def section(block, name):
    start = block.index("." + name + " = {")
    depth, end = 0, start + len("." + name + " = ")
    while True:
        depth += (block[end] == "{") - (block[end] == "}")
        end += 1
        if depth == 0:
            return block[start:end]


def numbers(text):
    return [int(value) for value in re.findall(r"-?\d+", text)]


def species_list(text):
    return re.findall(r"\bSPECIES_[A-Z0-9_]+", text)


def rate(block, name):
    return int(re.search(r"\." + name + r"\s*=\s*(\d+)", block).group(1))


def water_slots(block, name):
    """Slots carrying a level range and a species."""
    body = section(block, name)
    rows = re.findall(r"\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(SPECIES_[A-Z0-9_]+)\s*\}", body)
    if rows:
        return [{"level": {"min": int(a), "max": int(b)}, "species": s} for a, b, s in rows]
    # Some tables spell the range as two separate arrays.
    levels = numbers(section(body, "levels")) if ".levels" in body else []
    names = species_list(body)
    return [{"level": {"min": level, "max": level}, "species": name}
            for level, name in zip(levels, names)]


def translate(block):
    translate.short = getattr(translate, "short", [])
    land = section(block, "landSlots")
    levels = numbers(section(land, "levels"))
    morning = species_list(section(land, "speciesMorning"))
    day = species_list(section(land, "speciesDay"))
    night = species_list(section(land, "speciesNight"))
    slots = max(len(levels), len(morning), len(day), len(night))
    for name, values in (("levels", levels), ("morning", morning),
                         ("day", day), ("night", night)):
        if len(values) < slots:
            translate.short.append(f"{name} has {len(values)} of {slots}")
    # A list the reference leaves short is zero-filled by its own compiler, so
    # in its game those slots hold species zero. That is a defect rather than a
    # choice -- Route 30's speciesDay has eleven of twelve -- and a live slot
    # holding SPECIES_NONE is worse here than a repeat: the twelfth land slot
    # still comes up one time in a hundred. The tail is filled with the last
    # species the reference actually named, which is what its own tails do
    # anyway (Route 30's day ends MANKEY, MANKEY), so a regenerated Encounters.c
    # cannot put the hole back.
    for values in (morning, day, night):
        if values and len(values) < slots:
            values.extend([values[-1]] * (slots - len(values)))
        values.extend(["SPECIES_NONE"] * (slots - len(values)))
    levels.extend([0] * (slots - len(levels)))


    built = {
        "land": {"rate": rate(block, "rateWalk"),
                 "mons": [{"level": level, "species": {"morn": m, "day": d, "nite": n}}
                          for level, m, d, n in zip(levels, morning, day, night)]},
        "surf": {"rate": rate(block, "rateSurf"), "mons": water_slots(block, "surfSlots")},
        "rock_smash": {"rate": rate(block, "rateRockSmash"),
                       "mons": water_slots(block, "rockSmashSlots")},
        "fishing": {name: {"rate": rate(block, rateName), "mons": water_slots(block, slots)}
                    for slots, name, rateName in RODS},
        "hoenn": species_list(section(block, "hoennSoundSpecies")),
        "sinnoh": species_list(section(block, "sinnohSoundSpecies")),
        "landSwarm": re.search(r"\.landSwarm\s*=\s*(SPECIES_[A-Z0-9_]+)", block).group(1),
    }
    return built


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--map", help="show the difference for one map code")
    args = parser.parse_args()

    known = species_constants()
    table = entries(args.reference)
    data = json.loads(ENCOUNTERS.read_text())

    changed, unmatched, problems = [], [], []
    counts = collections.Counter()
    for entry in data["encounters"]:
        code = entry["map"]
        if code not in table:
            unmatched.append(code)
            continue
        try:
            wanted = translate(table[code])
        except ValueError as error:
            problems.append(f"{code}: {error}")
            continue
        missing = sorted({name for name in re.findall(r"SPECIES_[A-Z0-9_]+", json.dumps(wanted))
                          if name not in known})
        if missing:
            problems.append(f"{code}: undefined {', '.join(missing)}")
            continue
        wanted = {key: keep_version_split(entry.get(key), value) for key, value in wanted.items()}
        differing = [key for key in wanted if entry.get(key) != wanted[key]]
        if not differing:
            continue
        changed.append(code)
        counts.update(differing)
        if args.map == code:
            print(json.dumps({"before": {k: entry.get(k) for k in differing},
                              "after": {k: wanted[k] for k in differing}}, indent=1))
        if args.write:
            entry.update(wanted)

    print(f"{len(changed)} of {len(data['encounters'])} maps change"
          + (": " + ", ".join(changed) if changed else ""))
    for note in getattr(translate, "short", []):
        print(f"  a slot list the reference leaves short, tail filled with its last species: {note}")
    for key, count in counts.most_common():
        print(f"  {key}: {count}")
    if unmatched:
        print(f"no entry in the reference for: {', '.join(unmatched)}")
    for problem in problems:
        print(f"  left alone {problem}")

    if not args.write:
        print("nothing written; pass --write")
        return
    ENCOUNTERS.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {ENCOUNTERS.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
