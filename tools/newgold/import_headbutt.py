#!/usr/bin/env python3
"""Bring New Gold's headbutt tables into the native one.

files/arc/headbutt.json already holds the same thing: per map, six common and
six rare Pokemon with a level range, and six more behind the rare trees. The
reference keeps them as named members of one structure, declared in the order
the archive reads them, so the two are matched by position.

The tree coordinates are map geometry rather than content and are left as pret
extracted them.

Usage: import_headbutt.py REFERENCE_CHECKOUT [--write] [--map NAME]
"""

import argparse
import collections
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TABLES = ROOT / "files/arc/headbutt.json"

COMMON, RARE, SECRET = 6, 6, 6


def species_constants():
    return set(re.findall(r"#define (SPECIES_[A-Z0-9_]+)",
                          (ROOT / "include/constants/species.h").read_text()))


def members(reference):
    """Each map's block, in the order the archive reads them."""
    source = (reference / "data/Headbutt.c").read_text(errors="replace")
    body = source[source.index("const HeadbuttArchiveData __data ="):]
    blocks, depth, start, name = [], 0, None, None
    for index, character in enumerate(body):
        if character == "{":
            if depth == 1:
                start = index
            depth += 1
        elif character == "}":
            depth -= 1
            if depth == 1:
                blocks.append((name, body[start:index + 1]))
        elif depth == 1 and character == ".":
            match = re.match(r"\.(\w+)\s*=", body[index:index + 40])
            if match:
                name = match.group(1)
    return blocks


def slots(block, name):
    """The whole array, not merely its first entry."""
    if "." + name not in block:
        return []
    start = block.index("{", block.index("." + name))
    depth, end = 0, start
    while True:
        depth += (block[end] == "{") - (block[end] == "}")
        end += 1
        if depth == 0:
            break
    return [{"species": species, "minLevel": int(low), "maxLevel": int(high)}
            for species, low, high in
            re.findall(r"\{\s*(SPECIES_[A-Z0-9_]+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\}",
                       block[start:end])]


def keep_version_split(existing, wanted):
    """Write New Gold's species into HeartGold's side, leaving SoulSilver's.

    The native table names both games wherever they differ, and the reference,
    a HeartGold hack, names one. Overwriting outright would give SoulSilver
    HeartGold's trees.
    """
    if not isinstance(existing, list):
        return wanted
    merged = []
    for index, slot in enumerate(wanted):
        old = existing[index] if index < len(existing) else None
        if isinstance(old, dict) and isinstance(old.get("species"), dict):
            slot = dict(slot)
            slot["species"] = {"gold": slot["species"], "silver": old["species"]["silver"]}
        merged.append(slot)
    return merged


def translate(block):
    normal = slots(block, "normalSlots")
    special = [slot for slot in slots(block, "specialSlots") if slot["species"] != "SPECIES_NONE"]
    return {"CommonMons": normal[:COMMON],
            "RareMons": normal[COMMON:COMMON + RARE],
            "SecretMons": special[:SECRET]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--map")
    args = parser.parse_args()

    known = species_constants()
    blocks = members(args.reference)
    data = json.loads(TABLES.read_text())
    tables = data["tables"]

    if len(blocks) != len(tables):
        raise SystemExit(f"the reference has {len(blocks)} maps, the table has {len(tables)}")

    counts = collections.Counter()
    changed, problems = 0, []
    for entry, (name, block) in zip(tables, blocks):
        wanted = translate(block)
        missing = sorted({s for s in re.findall(r"SPECIES_[A-Z0-9_]+", json.dumps(wanted))
                          if s not in known})
        if missing:
            problems.append(f"{entry['Map']}: undefined {', '.join(missing)}")
            continue
        wanted = {key: keep_version_split(entry.get(key), value) for key, value in wanted.items()}
        differing = [key for key in wanted if entry.get(key) != wanted[key]]
        if not differing:
            continue
        changed += 1
        counts.update(differing)
        if args.map == entry["Map"]:
            print(json.dumps({"before": {k: entry.get(k) for k in differing},
                              "after": {k: wanted[k] for k in differing}}, indent=1)[:1500])
        if args.write:
            entry.update(wanted)

    print(f"{changed} of {len(tables)} maps change")
    for key, count in counts.most_common():
        print(f"  {key}: {count}")
    for problem in problems:
        print(f"  left alone {problem}")

    if not args.write:
        print("nothing written; pass --write")
        return
    TABLES.write_text(json.dumps(data, indent=2) + "\n")
    print(f"wrote {TABLES.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
