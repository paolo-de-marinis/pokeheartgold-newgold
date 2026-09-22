#!/usr/bin/env python3
"""Check the evolution table.

An evolution naming a method, item, move or species the ROM does not define
would not compile; one that overflows the per-species limit would compile and
then be ignored at runtime, which is worse. Both are checked here, along with
Eevee keeping every branch it had.
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
import import_evolutions  # noqa: E402

REFERENCE = os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE")
if REFERENCE is None:
    sibling = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
    REFERENCE = sibling if (sibling / ".git").exists() else None

# konefr's nine changes to species HeartGold already had: seven that move a
# level, two that add a way to reach a Hisui evolution by move. The levels are
# pinned here so they are checked with no reference to hand; with the checkout
# present the test below proves no vanilla level disagrees with
# data/Evolutions.c at all.
KONEFR_LEVELS = {
    ("SPECIES_BAYLEEF", "SPECIES_MEGANIUM"): 35,
    ("SPECIES_CYNDAQUIL", "SPECIES_QUILAVA"): 16,
    ("SPECIES_QUILAVA", "SPECIES_TYPHLOSION"): 35,
    ("SPECIES_TOTODILE", "SPECIES_CROCONAW"): 16,
    ("SPECIES_CROCONAW", "SPECIES_FERALIGATR"): 35,
    ("SPECIES_FLAAFFY", "SPECIES_AMPHAROS"): 35,
    ("SPECIES_MARILL", "SPECIES_AZUMARILL"): 22,
}

KONEFR_MOVES = {
    ("SPECIES_PRIMEAPE", "SPECIES_ANNIHILAPE"): "MOVE_RAGE_FIST",
    ("SPECIES_STANTLER", "SPECIES_WYRDEER"): "MOVE_PSYSHIELD_BASH",
}

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

    def test_a_linking_cord_stands_in_for_a_trade_with_an_item(self):
        """hg-engine at d0380a487: used on a Pokemon that evolves by trading
        while holding something, a Linking Cord evolves it -- if it holds it."""
        source = (ROOT / "src/pokemon.c").read_text()
        use = source[source.index("case EVOCTX_ITEM_USE:"):]
        use = use[:use.index("Heap_Free(evoTable);")]
        self.assertRegex(use, r"method == EVO_TRADE_ITEM && heldItem == evoTable\[i\]\.param"
                              r" && usedItem == ITEM_LINKING_CORD")

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

    def test_the_new_evolution_items_evolve_something(self):
        # An evolution item nothing names is an item that does nothing. These
        # are konefr's nine Gen 8/9 ones, as data/Evolutions.c spends them.
        for base, item, target in [
            ("SPECIES_CHARCADET", "ITEM_AUSPICIOUS_ARMOR", "SPECIES_ARMAROUGE"),
            ("SPECIES_CHARCADET", "ITEM_MALICIOUS_ARMOR", "SPECIES_CERULEDGE"),
            ("SPECIES_DURALUDON", "ITEM_METAL_ALLOY", "SPECIES_ARCHALUDON"),
            ("SPECIES_KUBFU", "ITEM_SCROLL_OF_DARKNESS", "SPECIES_URSHIFU"),
            ("SPECIES_SINISTEA", "ITEM_CRACKED_POT", "SPECIES_POLTEAGEIST"),
            ("SPECIES_POLTCHAGEIST", "ITEM_CRACKED_POT", "SPECIES_SINISTCHA"),
            ("SPECIES_SLOWPOKE_GALARIAN", "ITEM_GALARICA_CUFF", "SPECIES_SLOWBRO_GALARIAN"),
        ]:
            self.assertIn({"method": "EVO_STONE", "param": item, "target": target},
                          self.byBase.get(base, []), base)

        # The other three are spent on forms, which are species here since
        # the reference's forms came in: the Rapid Strike Urshifu, the
        # Galarian Slowking, and the Antique Sinistea and Masterpiece
        # Poltchageist that take the chipped pot rather than the cracked one.
        species = constants("include/constants/species.h", "SPECIES_")
        for base, item, target in [
            ("SPECIES_KUBFU", "ITEM_SCROLL_OF_WATERS", "SPECIES_URSHIFU_RAPID_STRIKE"),
            ("SPECIES_SLOWPOKE_GALARIAN", "ITEM_GALARICA_WREATH", "SPECIES_SLOWKING_GALARIAN"),
            ("SPECIES_SINISTEA_ANTIQUE", "ITEM_CHIPPED_POT", "SPECIES_POLTEAGEIST_ANTIQUE"),
            ("SPECIES_POLTCHAGEIST_MASTERPIECE", "ITEM_CHIPPED_POT", "SPECIES_SINISTCHA_MASTERPIECE"),
        ]:
            self.assertIn(target, species, target)
            self.assertIn({"method": "EVO_STONE", "param": item, "target": target},
                          self.byBase.get(base, []), base)

    def test_konefrs_nine_vanilla_changes(self):
        for (base, target), level in KONEFR_LEVELS.items():
            evo = next(e for e in self.byBase[base] if e["target"] == target)
            self.assertEqual(evo["method"], "EVO_LEVEL", base)
            self.assertEqual(evo["param"], level, base)
        for (base, target), move in KONEFR_MOVES.items():
            self.assertIn({"method": "EVO_HAS_MOVE", "param": move, "target": target},
                          self.byBase[base], base)

    def test_no_vanilla_level_disagrees_with_the_reference(self):
        # The reference also gives Annihilape and Wyrdeer an EVO_FORM_ARGUMENT
        # row counting twenty uses of the move. That is hg-engine's own method
        # and this tree has no EVO_FORM_ARGUMENT and no form argument on a
        # Pokemon to count into, so the move row is the whole of what konefr
        # changed and the whole of what is owed.
        if REFERENCE is None:
            self.skipTest("the reference checkout is not present")
        table = import_evolutions.reference_table(Path(REFERENCE))
        self.assertEqual(import_evolutions.relevelled(table, {"evoTable": self.table}), [])

    def test_species_without_an_evolution_are_absent(self):
        # Emolga, Bouffalant and Dedenne do not evolve; a stray entry for them
        # would mean the import misread a block.
        for name in ("EMOLGA", "BOUFFALANT", "DEDENNE"):
            self.assertNotIn("SPECIES_" + name, self.byBase, name)


if __name__ == "__main__":
    unittest.main()
