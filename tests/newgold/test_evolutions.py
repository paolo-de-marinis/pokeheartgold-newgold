#!/usr/bin/env python3
"""Check the evolution table.

An evolution naming a method, item, move or species the ROM does not define
would not compile; one that overflows the per-species limit would compile and
then be ignored at runtime, which is worse. Both are checked here, along with
Eevee keeping every branch it had.
"""

import json
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import import_species  # noqa: E402

VANILLA_EEVEE = {
    "SPECIES_VAPOREON", "SPECIES_JOLTEON", "SPECIES_FLAREON",
    "SPECIES_ESPEON", "SPECIES_UMBREON", "SPECIES_LEAFEON", "SPECIES_GLACEON",
}


def constants(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


class EvolutionTests(unittest.TestCase):
    def setUp(self):
        self.table = json.loads((ROOT / "files/poketool/personal/evo.json").read_text())["evoTable"]
        self.byBase = {entry["baseSpecies"]: entry["evos"] for entry in self.table}
        self.limit = int(re.search(r"#define MAX_EVOS_PER_POKE (\d+)",
                                   (ROOT / "include/pokemon_types_def.h").read_text()).group(1))

    def test_no_species_was_listed_twice_by_us(self):
        bases = [entry["baseSpecies"] for entry in self.table]
        duplicated = {base for base in bases if bases.count(base) > 1}
        # pret's own table lists Weepinbell twice, harmlessly: the template
        # emits a designated initialiser, so the second simply repeats the
        # first. Anything else would mean an import overwrote an existing line.
        self.assertEqual(duplicated, {"SPECIES_WEEPINBELL"})

    def test_nothing_overflows_the_limit(self):
        # The loader reads exactly this many, so an extra one is simply lost.
        for base, evos in self.byBase.items():
            self.assertLessEqual(len(evos), self.limit, base)

    def test_loops_read_the_whole_table(self):
        source = (ROOT / "src/pokemon.c").read_text()
        self.assertNotIn("for (i = 0; i < 7; i++)", source, "a loop still stops at seven")
        self.assertEqual(source.count("for (i = 0; i < MAX_EVOS_PER_POKE; i++)"), 3)

    def test_every_name_is_defined(self):
        known = (constants("include/constants/pokemon.h", "EVO_")
                 | constants("include/constants/pokemon.h", "TYPE_")
                 | constants("include/constants/species.h", "SPECIES_")
                 | constants("include/constants/moves.h", "MOVE_")
                 | constants("include/constants/items.h", "ITEM_"))
        for base, evos in self.byBase.items():
            self.assertIn(base, known)
            for evo in evos:
                self.assertIn(evo["method"], known, base)
                self.assertIn(evo["target"], known, base)
                if not str(evo["param"]).lstrip("-").isdigit():
                    self.assertIn(evo["param"], known, base)

    def test_eevee_keeps_its_branches_and_gains_sylveon(self):
        targets = {evo["target"] for evo in self.byBase["SPECIES_EEVEE"]}
        self.assertTrue(VANILLA_EEVEE <= targets)
        self.assertIn("SPECIES_SYLVEON", targets)
        sylveon = next(e for e in self.byBase["SPECIES_EEVEE"] if e["target"] == "SPECIES_SYLVEON")
        self.assertEqual(sylveon["method"], "EVO_HAS_MOVE_TYPE")
        self.assertEqual(sylveon["param"], "TYPE_FAIRY")

    def test_the_new_lines_are_connected(self):
        lines = [
            ("SPECIES_LILLIPUP", "SPECIES_HERDIER", "SPECIES_STOUTLAND"),
            ("SPECIES_TYMPOLE", "SPECIES_PALPITOAD", "SPECIES_SEISMITOAD"),
            ("SPECIES_SEWADDLE", "SPECIES_SWADLOON", "SPECIES_LEAVANNY"),
            ("SPECIES_LITWICK", "SPECIES_LAMPENT", "SPECIES_CHANDELURE"),
            ("SPECIES_KLINK", "SPECIES_KLANG", "SPECIES_KLINKLANG"),
            ("SPECIES_FLETCHLING", "SPECIES_FLETCHINDER", "SPECIES_TALONFLAME"),
            ("SPECIES_TRUBBISH", "SPECIES_GARBODOR"),
            ("SPECIES_NOIBAT", "SPECIES_NOIVERN"),
        ]
        for line in lines:
            for base, target in zip(line, line[1:]):
                targets = {evo["target"] for evo in self.byBase.get(base, [])}
                self.assertIn(target, targets, base)

    def test_species_without_an_evolution_are_absent(self):
        # Emolga, Bouffalant and Dedenne do not evolve; a stray entry for them
        # would mean the import misread a block.
        for name in ("EMOLGA", "BOUFFALANT", "DEDENNE"):
            self.assertNotIn("SPECIES_" + name, self.byBase, name)


if __name__ == "__main__":
    unittest.main()
