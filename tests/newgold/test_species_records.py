#!/usr/bin/env python3
"""Check the personal records line up with the species identifiers.

The records are generated, so the risk is not a wrong number typed by hand but
the table and the constants drifting apart: an entry whose index is not the
identifier the header gives it would silently hand every reader the wrong
Pokemon. Where the behaviour reference is available the values are regenerated
and compared as well.
"""

import json
import os
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None:
    sibling = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    REFERENCE = sibling if (sibling / ".git").exists() else None


def constants():
    header = (ROOT / "include/constants/species.h").read_text()
    return {m[1]: int(m[2]) for m in re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


class SpeciesRecordTests(unittest.TestCase):
    def setUp(self):
        self.records = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        self.constants = constants()

    def test_every_record_sits_at_its_identifier(self):
        for index, entry in enumerate(self.records):
            name = entry["species"]
            if name in self.constants:
                self.assertEqual(self.constants[name], index, name)

    def test_the_table_covers_every_species(self):
        header = (ROOT / "include/constants/species.h").read_text()
        last = re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)
        self.assertEqual(self.records[-1]["species"], last)
        self.assertEqual(len(self.records), self.constants[last] + 1)

    def test_vanilla_identifiers_did_not_move(self):
        # The block the egg, the bad egg and the alternate forms occupy.
        self.assertEqual(self.constants["ARCEUS"], 493)
        self.assertEqual(self.constants["EGG"], 494)
        self.assertEqual(self.constants["BAD_EGG"], 495)
        self.assertEqual(self.constants["ROTOM_MOW"], 507)
        # New species start after it.
        self.assertEqual(self.constants[import_species.NEW_SPECIES[0]], 508)

    def test_new_species_are_complete(self):
        for name in import_species.NEW_SPECIES:
            self.assertIn(name, self.constants, name)
            entry = self.records[self.constants[name]]
            self.assertEqual(entry["species"], name)
            self.assertGreater(entry["hp"], 0, name)
            self.assertGreater(entry["catchRate"], 0, name)
            self.assertIn(entry["genderRatio"], (0.0, 0.125, 0.25, 0.5, 0.75, 0.875, 1.0, 2.0), name)
            self.assertLessEqual(entry["expYield"], 255, name)
            self.assertLessEqual(max(entry["tms"], default=0), 92, name)
            self.assertLessEqual(max(entry["hms"], default=0), 8, name)

    def test_the_fairy_retypes_landed(self):
        # The species the later generations moved to Fairy, plus the two konefr
        # retyped himself.
        expected = {
            "CLEFAIRY": ["TYPE_FAIRY", "TYPE_FAIRY"],
            "AZUMARILL": ["TYPE_WATER", "TYPE_FAIRY"],
            "GARDEVOIR": ["TYPE_PSYCHIC", "TYPE_FAIRY"],
            "TOGEKISS": ["TYPE_FAIRY", "TYPE_FLYING"],
            "MAWILE": ["TYPE_STEEL", "TYPE_FAIRY"],
            "MEGANIUM": ["TYPE_GRASS", "TYPE_FAIRY"],
            "TYPHLOSION": ["TYPE_FIRE", "TYPE_GROUND"],
        }
        for name, types in expected.items():
            self.assertEqual(self.records[self.constants[name]]["types"], types, name)

    def test_yields_past_the_old_ceiling_survive(self):
        # The byte keeps what fits; the full value is what the game reads.
        for name, yieldValue in (("BLISSEY", 635), ("CHANSEY", 395), ("DRAGONITE", 300)):
            record = self.records[self.constants[name]]
            self.assertEqual(record["expYieldFull"], yieldValue, name)
            self.assertEqual(record["expYield"], min(yieldValue, 255), name)

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_records_still_match_the_reference(self):
        reference = Path(REFERENCE)
        blocks = import_species.species_entries(reference)
        yields = import_species.base_exp_yields(reference)
        learnsets = import_species.machine_moves(reference)
        tms, hms = import_species.machine_numbers()
        # Every species whose record is generated: HGSS's own, and the added
        # ones. The egg, the bad egg and the alternate forms in between are
        # left as pret wrote them.
        managed = set(range(1, 494)) | {self.constants[n] for n in import_species.NEW_SPECIES}
        checked = 0
        for name, index in self.constants.items():
            if index not in managed or self.records[index]["species"] != name:
                continue
            if name not in blocks:
                continue
            regenerated = import_species.record(name, blocks[name], yields.get(name, 0),
                                                learnsets.get(name, set()), tms, hms)
            self.assertEqual(self.records[index], regenerated, name)
            checked += 1
        self.assertGreater(checked, 500)


if __name__ == "__main__":
    unittest.main()
