#!/usr/bin/env python3
"""Check the wild encounter table.

Every species named here has to exist and be complete, because this is the
first place the added ones are reachable: a name the ROM does not define would
not build, and one without a sprite or a learnset would appear and misbehave.
"""

import json
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

ENCOUNTERS = ROOT / "files/fielddata/encountdata/gs_enc_data.json"
SPRITES = ROOT / "files/poketool/pokegra/pokegra"
LAND_SLOTS = 12


def species_ids():
    header = (ROOT / "include/constants/species.h").read_text()
    return {f"SPECIES_{m[1]}": int(m[2]) for m in
            re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


class EncounterTests(unittest.TestCase):
    def setUp(self):
        self.maps = json.loads(ENCOUNTERS.read_text())["encounters"]
        self.ids = species_ids()
        self.named = set()

        def collect(value):
            # A slot names one species, or one per game where they differ.
            if isinstance(value, dict):
                for inner in value.values():
                    collect(inner)
            elif isinstance(value, list):
                for inner in value:
                    collect(inner)
            elif isinstance(value, str) and value.startswith("SPECIES_"):
                self.named.add(value)

        for entry in self.maps:
            for slot in entry["land"]["mons"]:
                collect(slot["species"])
            for key in ("surf", "rock_smash"):
                collect([slot["species"] for slot in entry[key]["mons"]])
            for rod in entry["fishing"].values():
                collect([slot["species"] for slot in rod["mons"]])
            collect(entry["hoenn"])
            collect(entry["sinnoh"])
            collect(entry["landSwarm"])

    def test_every_species_named_exists(self):
        for name in self.named:
            self.assertIn(name, self.ids, name)

    def test_land_slots_are_complete(self):
        for entry in self.maps:
            mons = entry["land"]["mons"]
            self.assertIn(len(mons), (0, LAND_SLOTS), entry["map"])
            for slot in mons:
                self.assertEqual(set(slot["species"]), {"morn", "day", "nite"}, entry["map"])

    def test_rates_are_percentages(self):
        for entry in self.maps:
            for key in ("land", "surf", "rock_smash"):
                self.assertLessEqual(entry[key]["rate"], 100, entry["map"])
            for name, rod in entry["fishing"].items():
                self.assertLessEqual(rod["rate"], 100, f"{entry['map']} {name}")

    def test_the_added_species_reached_the_wild(self):
        added = {f"SPECIES_{name}" for name in import_species.NEW_SPECIES}
        wild = added & self.named
        self.assertGreater(len(wild), 10, "the rebalance should place added species")

    def test_soulsilver_keeps_its_own_wild_pokemon(self):
        """The reference is a HeartGold hack; it must not overwrite both games."""
        split = 0
        for entry in self.maps:
            for slot in entry["land"]["mons"]:
                for key in ("level", "species"):
                    value = slot[key]
                    if key == "species":
                        for time in value.values():
                            if isinstance(time, dict):
                                self.assertEqual(set(time), {"HEARTGOLD", "SOULSILVER"})
                                split += 1
                    elif isinstance(value, dict):
                        self.assertEqual(set(value), {"HEARTGOLD", "SOULSILVER"})
                        split += 1
        # pret's table names both games in hundreds of places.
        self.assertGreater(split, 500)

    def test_every_wild_species_can_appear(self):
        # A species in the table needs the data the game reads when it shows up.
        records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        for name in sorted(self.named):
            index = self.ids[name]
            if index == 0:
                continue
            self.assertLess(index, len(records), name)
            self.assertGreater(records[index]["hp"], 0, name)
            directory = SPRITES / f"{index:04d}"
            self.assertTrue((directory / "male/front.png").stat().st_size
                            or (directory / "female/front.png").stat().st_size, name)

    def test_no_land_table_is_partly_empty(self):
        """A table with species in it must have no empty slot.

        The reference's Route 30 names eleven of twelve for the day, and its
        compiler zero-fills the twelfth, so that route had a slot holding
        species zero which the game would still roll one time in a hundred.
        A table that is empty throughout is a map with no grass and is fine;
        one that is empty in places is the defect.
        """
        def named(value):
            return [value] if isinstance(value, str) else list(value.values())

        for entry in self.maps:
            for time in ("morn", "day", "nite"):
                slots = [name for slot in entry["land"]["mons"]
                         for name in named(slot["species"][time])]
                filled = [name for name in slots if name != "SPECIES_NONE"]
                if filled:
                    self.assertEqual(len(filled), len(slots),
                                     f"{entry['map']} {time} has "
                                     f"{len(slots) - len(filled)} empty slots")


if __name__ == "__main__":
    unittest.main()
