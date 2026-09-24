#!/usr/bin/env python3
"""Write the Dex's area records (zukan_enc.json) from the tree's wild data.

    dex_areas.py            rewrite the json from the tree
    dex_areas.py --check    exit 1 if the json is not what the tree gives

The area page reads, for the species shown, four records of the archive:
the dungeons it lives in at the time of day chosen and those it lives in
through something special, and the same for the overworld. Each record is
a list of indices into the page's two area lists (sOverworldMapIDs and
sDungeonMapIDs in ov18_021E5C40.c) ending in 0. The archive is the
dungeons' and the overworld's drawing tables, then eight blocks with one
record for each species up to the last Dex species:

    0 1 2   dungeons, morning / day / night
    3 4 5   overworld, morning / day / night
    6       dungeons, special
    7       overworld, special

Retail's records are what this gives from retail's tables, byte for byte
(tests/newgold/test_dex_area.py rebuilds them from pret's):

  - a time's block holds the table's land species of that time, its Surf
    and Rock Smash species and its three rods' -- at night the Good Rod's
    fourth slot and the Super Rod's second are the table's night fish,
    as EncSlotArray_Update_NightFishing makes them; a section whose rate
    is 0 cannot be met and is left out;
  - the special block holds the Hoenn and Sinnoh Sound species the table
    does not already have in its grass (the Ruins' chambers fill their
    radio slots with their Unown), then the headbutt species of every map
    with trees, area by area;
  - a table goes to the area of its map: the area whose map it is, else
    the first whose map is in the same map section; the Safari Zone has
    none, and the Bug-Catching Contest's table is left out -- the contest
    draws from mushi_encount, which retail's records do not show either;
  - swarms are not shown;
  - an area is listed once, in the order met: the tables' order, and the
    headbutt maps' by area.

A form counts for its base species, as the Dex credits it
(SpeciesToDexSpecies). Species 0's records (every area) and the two
drawing tables are retail's, carried over.
"""

import argparse
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUT = "files/application/zukanlist/zkn_data/zukan_enc.json"
ENC = "files/fielddata/encountdata/gs_enc_data.json"
HEADBUTT = "files/arc/headbutt.json"
CONTEST_MAPS = {"MAP_NATIONAL_PARK_BUG_CATCHING_CONTEST"}
VERSIONS = (("GOLD", "HEARTGOLD", "gold"), ("SILVER", "SOULSILVER", "silver"))


def read(path):
    return (ROOT / path).read_text()


class Tree:
    """What the records are made from that is not the wild data itself."""

    def __init__(self):
        self.species = {}
        header = read("include/constants/species.h")
        for m in re.finditer(r"#define (SPECIES_\w+)\s+(\d+)", header):
            self.species.setdefault(m.group(1), int(m.group(2)))
        self.names = {}
        for name, value in self.species.items():
            self.names.setdefault(value, name)
        self.dex_count = self.species[re.search(r"#define LAST_DEX_SPECIES\s+(\w+)", header).group(1)]

        dex = read("src/pokedex.c")
        self.form_base = {self.species[f]: self.species[b] for f, b in re.findall(
            r"\[(SPECIES_\w+) - NATIONAL_DEX_COUNT - 1\] = (SPECIES_\w+)", dex)}
        body = re.search(r"u16 SpeciesToDexSpecies\(u16 species\) \{(.*?)\n\}", dex, re.S).group(1)
        for f, b in re.findall(r"species == (SPECIES_\w+)\) \{\s*return (SPECIES_\w+);", body):
            self.form_base[self.species[f]] = self.species[b]

        self.internal = {}  # MAP_R01 -> MAP_ROUTE_1
        for m in re.finditer(r"#define (MAP_\w+)\s+\d+\s+// (MAP_\w+)", read("include/constants/maps.h")):
            self.internal[m.group(2)] = m.group(1)

        self.headers = {}
        for m in re.finditer(r"\[(MAP_\w+)\] = \{(.*?)\n\s*\},", read("src/data/map_headers.h"), re.S):
            enc = re.search(r"\.wildEncounterBank = (\w+)", m.group(2)).group(1)
            sec = re.search(r"\.mapsec = (\w+)", m.group(2)).group(1)
            self.headers[m.group(1)] = (enc, sec)
        self.tables = defaultdict(list)  # ENCDATA_R29 -> the maps using it
        for name, (enc, _) in self.headers.items():
            self.tables[enc].append(name)

        page = read("src/application/pokedex/ov18_021E5C40.c")
        self.areas = {}
        for kind, array in (("overworld", "sOverworldMapIDs"), ("dungeon", "sDungeonMapIDs")):
            body = re.search(array + r"\[\w*\] = \{(.*?)\};", page, re.S).group(1)
            self.areas[kind] = [x.strip() for x in body.split(",") if x.strip()]

    def area(self, map_name):
        """(kind, index) of a map's area, or None."""
        for kind, maps in self.areas.items():
            if map_name in maps:
                return kind, maps.index(map_name)
        section = self.headers[map_name][1]
        for kind, maps in self.areas.items():
            for i, other in enumerate(maps):
                if other in self.headers and self.headers[other][1] == section:
                    return kind, i
        return None

    def dex_species(self, name):
        value = self.species[name]
        return self.form_base.get(value, value)


def version_value(value, keys):
    if isinstance(value, dict):
        return value[keys[1]] if keys[1] in value else value[keys[2]]
    return value


def records(tree, enc, headbutt, keys):
    """block -> species -> area indices, for one version."""
    out = [defaultdict(list) for _ in range(8)]

    def add(block, name, index):
        species = tree.dex_species(version_value(name, keys))
        if species and index not in out[block][species]:
            out[block][species].append(index)

    for table in enc:
        maps = tree.tables.get("ENCDATA_" + table["map"], [])
        if not maps or set(maps) <= CONTEST_MAPS:
            continue
        where = tree.area(maps[0])
        if where is None:
            continue
        kind, index = where
        times = (0, 1, 2) if kind == "dungeon" else (3, 4, 5)
        land = [slot["species"] for slot in table["land"]["mons"]]
        for block, time in zip(times, ("morn", "day", "nite")):
            names = [slot[time] for slot in land]
            for section in ("surf", "rock_smash"):
                if table[section]["rate"]:
                    names += [slot["species"] for slot in table[section]["mons"]]
            for rod, night_slot in (("old_rod", None), ("good_rod", 3), ("super_rod", 1)):
                if table["fishing"][rod]["rate"]:
                    fish = [slot["species"] for slot in table["fishing"][rod]["mons"]]
                    if time == "nite" and night_slot is not None:
                        fish[night_slot] = table["nightFish"]
                    names += fish
            for name in names:
                add(block, name, index)
        grass = {tree.dex_species(version_value(slot[t], keys)) for slot in land for t in ("morn", "day", "nite")}
        for name in table["hoenn"] + table["sinnoh"]:
            if tree.dex_species(version_value(name, keys)) not in grass:
                add(6 if kind == "dungeon" else 7, name, index)

    trees = []
    for table in headbutt:
        map_name = tree.internal["MAP_" + table["Map"]]
        where = tree.area(map_name) if table["Trees"] else None
        if where is not None:
            trees.append((where[1], where, table))
    trees.sort(key=lambda t: t[0])  # stable: maps in number order within an area
    for _, (kind, index), table in trees:
        for slot in table["CommonMons"] + table["RareMons"] + table["SecretMons"]:
            add(6 if kind == "dungeon" else 7, slot["species"], index)
    return out


def build(tree, enc, headbutt, previous, count):
    """The json, from the wild data, `count` records a block and the drawing
    tables and species 0's records of `previous`."""
    per_version = [records(tree, enc, headbutt, keys) for keys in VERSIONS]
    # jsonproc reads the json into a sorted map, so the records become the
    # archive's members in the order of their keys: the numbers are padded
    # to the widest (retail's three digits; four past species 999).
    width = len(str(count - 1))
    encounters = {}
    for block in range(8):
        method = "method_%d" % block
        old = previous["encounters"][method]
        first = next(iter(old))
        recs = {"mon_%s_none" % ("0" * width): old[first]}
        for species in range(1, count):
            name = tree.names.get(species, "SPECIES_NONE")[len("SPECIES_"):].lower()
            gold, silver = (v[block].get(species, []) + [0] for v in per_version)
            recs["mon_%0*d_%s" % (width, species, name)] = gold if gold == silver else {"GOLD": gold, "SILVER": silver}
        encounters[method] = recs
    return {"dungeons": previous["dungeons"], "overworlds": previous["overworlds"], "encounters": encounters}


def text(data):
    return json.dumps(data, indent=4)


def from_tree():
    tree = Tree()
    enc = json.loads(read(ENC))["encounters"]
    headbutt = json.loads(read(HEADBUTT))["tables"]
    previous = json.loads(read(OUT))
    return text(build(tree, enc, headbutt, previous, tree.dex_count + 1))


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    new = from_tree()
    if args.check:
        sys.exit(0 if new == read(OUT) else 1)
    (ROOT / OUT).write_text(new)


if __name__ == "__main__":
    main()
