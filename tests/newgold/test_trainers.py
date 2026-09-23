#!/usr/bin/env python3
"""Check the trainer table.

Trainer data is read by index and its party is built from names, so what can go
wrong quietly is a party that names something the ROM does not define, a level
outside what the game accepts, or a party longer than a team can be.
"""

import json
import re
import struct
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import gmm  # noqa: E402
import import_species  # noqa: E402
import import_trainer_text  # noqa: E402
import wotbl  # noqa: E402

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

    def test_the_name_bank_is_remade_when_trainers_json_changes(self):
        """Bank 729 is made from trainers.json by files/msgdata/msg.mk. Its rule
        once had no prerequisites, so after the first build no edit to a name
        ever reached the ROM."""
        rule = re.search(r"^\$\(TRNAME_GMM\):(.*)$", (ROOT / "files/msgdata/msg.mk").read_text(), re.M)
        self.assertIsNotNone(rule, "no rule makes $(TRNAME_GMM)")
        self.assertLessEqual({"$(TRAINER_JSON)", "$(TRNAME_TEMPLATE)"}, set(rule.group(1).split()))

    def test_konefr_s_names_and_lines(self):
        """New Gold: Youngster Mikey and Bird Keeper Peter as konefr renamed
        them, their lines where his trtbl map puts them -- with the win line
        he gave Peter inserted as row 661 and everything after it one along.
        hg-engine's Mikey and Peter are the engine layer, the commit before
        his text."""
        self.assertEqual(self.trainers[47]["name"], "{TRNAME}Pippo Franco")
        self.assertEqual(self.trainers[383]["name"], "{TRNAME}Pietro Pacciani")
        lines = [row["text"] for row in gmm.read(728)]
        self.assertEqual(len(lines), 1718)
        self.assertEqual(lines[649], "Mi scappa la pipì, papà!\\r")
        self.assertEqual(lines[662], "I should train again at the Gym in\\nViolet City.\\n")
        trtbl = wotbl.read_narc((ROOT / "files/poketool/trmsg/trtbl.narc").read_bytes())[0][0]
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 649), (47, 0))     # TRMSG_INTRO
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 661), (383, 20))   # TRMSG_WIN, his
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 662), (383, 2))    # TRMSG_AFTER

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_text_is_what_the_generator_makes_at_new_gold(self):
        """import_trainer_text.py is trainerdatagen and msg_cat.py again; at
        ccf2c9f5 it reproduces every name, bank 728 and both map archives, and
        at d0380a487 it differs only in konefr's three trainers."""
        names, rows, trtbl, trtblofs = import_trainer_text.generate(gmm.NEWGOLD)
        self.assertEqual([trainer["name"] for trainer in self.trainers], ["{TRNAME}" + name for name in names])
        self.assertEqual([row["text"] for row in gmm.read(728)], [gmm.escape(text) for _, _, text in rows])
        self.assertEqual((ROOT / "files/poketool/trmsg/trtbl.narc").read_bytes(), wotbl.build_narc([trtbl], 4))
        self.assertEqual((ROOT / "files/poketool/trmsg/trtblofs.narc").read_bytes(), wotbl.build_narc([trtblofs], 4))
        engine_names = import_trainer_text.generate(gmm.ENGINE)[0]
        self.assertEqual({i for i, (a, b) in enumerate(zip(engine_names, names)) if a != b}, {47, 383})

if __name__ == "__main__":
    unittest.main()
