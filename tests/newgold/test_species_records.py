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

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
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
        # The forms the reference numbers as species, each with its base.
        self.bases = import_species.base_species_of(Path(REFERENCE)) if REFERENCE else {}

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
        self.assertEqual(self.constants[import_species.added_species()[0]], 508)

    def test_new_species_are_complete(self):
        for name in import_species.added_species():
            self.assertIn(name, self.constants, name)
            entry = self.records[self.constants[name]]
            self.assertEqual(entry["species"], name)
            self.assertGreater(entry["hp"], 0, name)
            if name not in self.bases:
                self.assertGreater(entry["catchRate"], 0, name)  # a mega cannot be caught, so its rate is nought
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

    def test_a_move_learnt_by_level_up_can_be_taught_by_its_machine(self):
        """hg-engine's build_learnsets.py sets a species' machine bit when it
        learns the move by level-up, whatever its machine list says: Pansage
        can be taught Natural Gift (TM83) and Recycle (TM67), Blitzle Shock
        Wave (TM34). Checked against this game's own level-up archive."""
        import wotbl
        learnsets, _, _ = wotbl.read_narc(wotbl.ARCHIVE.read_bytes())
        numbers = wotbl.move_names()
        tms, hms = import_species.machine_numbers()
        machines = {numbers[move]: ("tms", n) for move, n in tms.items()}
        machines.update({numbers[move]: ("hms", n) for move, n in hms.items()})
        missing = []
        for name in import_species.added_species():
            index = self.constants[name]
            for entry in wotbl.decode(learnsets[index]):
                field, number = machines.get(entry["move"], (None, None))
                if field and number not in self.records[index][field]:
                    missing.append(f"{name} {field} {number}")
        self.assertEqual(missing, [])

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_records_still_match_the_reference(self):
        reference = Path(REFERENCE)
        blocks = import_species.species_entries(reference)
        yields = import_species.base_exp_yields(reference)
        for form, base in self.bases.items():
            yields.setdefault(form, yields.get(base, 0))  # as the import gives a form its base's yield
        learnsets = import_species.machine_moves(reference)
        retail = import_species.machine_moves(reference, level_up=False)  # as update_vanilla_species
        tms, hms = import_species.machine_numbers()
        # The hidden ability lives in a table of its own in the reference, and
        # an ability this game has not got leaves the species without one.
        known = set(re.findall(r"#define (ABILITY_[A-Z0-9_]+)",
                               (ROOT / "include/constants/abilities.h").read_text()))
        hidden = {species: ability for species, ability
                  in import_species.hidden_abilities(REFERENCE).items() if ability in known}
        for form, base in self.bases.items():
            hidden.setdefault("SPECIES_" + form, hidden.get("SPECIES_" + base, "ABILITY_NONE"))
        # Every species whose record is generated: HGSS's own, and the added
        # ones. The egg, the bad egg and the alternate forms in between are
        # left as pret wrote them.
        managed = set(range(1, 494)) | {self.constants[n] for n in import_species.added_species()}
        checked = 0
        for name, index in self.constants.items():
            if index not in managed or self.records[index]["species"] != name:
                continue
            if name not in blocks:
                continue
            taught = (retail if index <= 493 else learnsets).get(name, set())
            regenerated = import_species.record(name, blocks[name], yields.get(name, 0),
                                                taught, tms, hms,
                                                hidden.get("SPECIES_" + name, "ABILITY_NONE"))
            self.assertEqual(self.records[index], regenerated, name)
            checked += 1
        self.assertGreater(checked, 500)

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_updating_the_vanilla_species_changes_nothing(self):
        """A dry run of update_vanilla_species.py on the current table. It
        used to build each record with no hidden ability, so --write would
        have reset 451 of them."""
        import update_vanilla_species
        _, updates, _ = update_vanilla_species.pending(Path(REFERENCE))
        self.assertEqual([(wanted["species"], differing) for _, wanted, differing in updates], [])


if __name__ == "__main__":
    unittest.main()
