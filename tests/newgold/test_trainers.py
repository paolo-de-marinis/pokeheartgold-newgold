#!/usr/bin/env python3
"""Check the trainer table.

Trainer data is read by index and its party is built from names, so what can go
wrong quietly is a party that names something the ROM does not define, a level
outside what the game accepts, or a party longer than a team can be.
"""

import json
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

TRAINERS = ROOT / "files/poketool/trainer/trainers.json"
PARTY_MAX = 6


def defined(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


class TrainerTests(unittest.TestCase):
    def setUp(self):
        self.trainers = json.loads(TRAINERS.read_text())["trainers"]
        self.species = defined("include/constants/species.h", "SPECIES_")
        self.items = defined("include/constants/items.h", "ITEM_")
        self.moves = defined("include/constants/moves.h", "MOVE_")
        self.classes = defined("include/constants/trainer_class.h", "TRAINERCLASS_")

    def test_every_name_is_defined(self):
        for index, trainer in enumerate(self.trainers):
            self.assertIn(trainer["class"], self.classes, index)
            for item in trainer["items"]:
                self.assertIn(item, self.items, index)
            for member in trainer["party"]:
                self.assertIn(member["species"], self.species, index)
                if "item" in member:
                    self.assertIn(member["item"], self.items, index)
                for move in member.get("moves", []):
                    self.assertIn(move, self.moves, index)

    def test_parties_are_legal(self):
        for index, trainer in enumerate(self.trainers):
            self.assertLessEqual(len(trainer["party"]), PARTY_MAX, index)
            for member in trainer["party"]:
                self.assertGreaterEqual(member["level"], 1, index)
                self.assertLessEqual(member["level"], 100, index)
                self.assertLessEqual(len(member.get("moves", [])), 4, index)

    def test_declared_type_matches_the_party(self):
        for index, trainer in enumerate(self.trainers):
            carriesMoves = "MOVES" in trainer["type"]
            carriesItem = "ITEM" in trainer["type"]
            for member in trainer["party"]:
                self.assertEqual("moves" in member, carriesMoves, index)
                self.assertEqual("item" in member, carriesItem, index)

    def test_the_rebalance_landed(self):
        """Falkner is the first gym New Gold reworks, and his team shows it:
        five Pokemon, every one of them holding something, where HeartGold gave
        him two and nothing."""
        falkner = next(t for t in self.trainers if t["name"].endswith("Falkner"))
        self.assertEqual([m["level"] for m in falkner["party"]], [12, 12, 12, 13, 13])
        self.assertEqual(falkner["type"], "TRTYPE_MON_ITEM_MOVES")
        for member in falkner["party"]:
            self.assertNotEqual(member["item"], "ITEM_NONE", member["species"])
        # The Leek, which this game calls the Stick, and an Eviolite: both are
        # items the port had to add before this trainer could be read at all.
        held = {member["item"] for member in falkner["party"]}
        self.assertIn("ITEM_STICK", held)
        self.assertIn("ITEM_EVIOLITE", held)

    def test_added_species_reach_trainers(self):
        named = {member["species"] for trainer in self.trainers for member in trainer["party"]}
        added = {f"SPECIES_{name}" for name in import_species.added_species()}
        self.assertTrue(added & named, "the rebalance should hand added species to trainers")


if __name__ == "__main__":
    unittest.main()
