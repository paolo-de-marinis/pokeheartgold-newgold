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
import struct
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

# Rows by a method hg-engine added, one entry a row, as data/Evolutions.c
# writes them at d0380a487.
ENGINE_METHOD_ROWS = [
    ("SPECIES_MAGNETON", ("EVO_MAGNETIC_FIELD", 0, "SPECIES_MAGNEZONE")),
    ("SPECIES_NOSEPASS", ("EVO_MAGNETIC_FIELD", 0, "SPECIES_PROBOPASS")),
    ("SPECIES_CHARJABUG", ("EVO_MAGNETIC_FIELD", 0, "SPECIES_VIKAVOLT")),
    ("SPECIES_TYRUNT", ("EVO_LEVEL_DAY", 39, "SPECIES_TYRANTRUM")),
    ("SPECIES_YUNGOOS", ("EVO_LEVEL_DAY", 20, "SPECIES_GUMSHOOS")),
    ("SPECIES_ROCKRUFF", ("EVO_LEVEL_DAY", 25, "SPECIES_LYCANROC")),
    ("SPECIES_ROCKRUFF", ("EVO_LEVEL_NIGHT", 25, "SPECIES_LYCANROC_MIDNIGHT")),
    ("SPECIES_ROCKRUFF_OWN_TEMPO", ("EVO_LEVEL_DUSK", 25, "SPECIES_LYCANROC_DUSK")),
    ("SPECIES_FOMANTIS", ("EVO_LEVEL_DAY", 34, "SPECIES_LURANTIS")),
    ("SPECIES_COSMOEM", ("EVO_LEVEL_DAY", 53, "SPECIES_SOLGALEO")),
    ("SPECIES_COSMOEM", ("EVO_LEVEL_NIGHT", 53, "SPECIES_LUNALA")),
    ("SPECIES_GREAVARD", ("EVO_LEVEL_NIGHT", 30, "SPECIES_HOUNDSTONE")),
    ("SPECIES_RATTATA_ALOLAN", ("EVO_LEVEL_NIGHT", 20, "SPECIES_RATICATE_ALOLAN")),
    ("SPECIES_SLIGGOO", ("EVO_LEVEL_RAIN", 50, "SPECIES_GOODRA")),
    ("SPECIES_SLIGGOO_HISUIAN", ("EVO_LEVEL_RAIN", 50, "SPECIES_GOODRA_HISUIAN")),
    ("SPECIES_PANCHAM", ("EVO_LEVEL_DARK_TYPE_MON_IN_PARTY", 32, "SPECIES_PANGORO")),
    ("SPECIES_TOXEL", ("EVO_LEVEL_NATURE_AMPED", 30, "SPECIES_TOXTRICITY")),
    ("SPECIES_TOXEL", ("EVO_LEVEL_NATURE_LOW_KEY", 30, "SPECIES_TOXTRICITY_LOW_KEY")),
    ("SPECIES_YAMASK_GALARIAN", ("EVO_HURT_IN_BATTLE_AMOUNT", 49, "SPECIES_RUNERIGUS")),
    ("SPECIES_FARFETCHD_GALARIAN", ("EVO_AMOUNT_OF_CRITICAL_HITS", 3, "SPECIES_SIRFETCHD")),
    ("SPECIES_PRIMEAPE", ("EVO_FORM_ARGUMENT", 20, "SPECIES_ANNIHILAPE")),
    ("SPECIES_STANTLER", ("EVO_FORM_ARGUMENT", 20, "SPECIES_WYRDEER")),
    ("SPECIES_PAWMO", ("EVO_LETS_GO", 0, "SPECIES_PAWMOT")),
    ("SPECIES_BRAMBLIN", ("EVO_LETS_GO", 0, "SPECIES_BRAMBLEGHAST")),
    ("SPECIES_RELLOR", ("EVO_LETS_GO", 0, "SPECIES_RABSCA")),
    # GIMMIGHOUL_EVOLUTION_COINS, which the evolution spends.
    ("SPECIES_GIMMIGHOUL", ("EVO_FORM_ARGUMENT", 999, "SPECIES_GHOLDENGO")),
    ("SPECIES_BISHARP", ("EVO_FORM_ARGUMENT", 3, "SPECIES_KINGAMBIT")),
    ("SPECIES_KARRABLAST", ("EVO_TRADE_SPECIFIC_MON", "SPECIES_SHELMET", "SPECIES_ESCAVALIER")),
    ("SPECIES_SHELMET", ("EVO_TRADE_SPECIFIC_MON", "SPECIES_KARRABLAST", "SPECIES_ACCELGOR")),
]

# Paolo's own designs (2026-09-23), beyond the reference and konefr's, which
# the importer writes from its DESIGNED_ROWS.
DESIGNED_ROWS = [
    ("SPECIES_BISHARP", ("EVO_HAS_MOVE", "MOVE_SWORDS_DANCE", "SPECIES_KINGAMBIT")),
    ("SPECIES_GIMMIGHOUL", ("EVO_HAS_MOVE", "MOVE_PAY_DAY", "SPECIES_GHOLDENGO")),
    ("SPECIES_GIMMIGHOUL_ROAMING", ("EVO_HAS_MOVE", "MOVE_PAY_DAY", "SPECIES_GHOLDENGO")),
] + [("SPECIES_MILCERY", ("EVO_ITEM_ICE_PATH", f"ITEM_{berry}_BERRY", target)) for berry, target in (
    ("CHERI", "SPECIES_ALCREMIE"), ("ORAN", "SPECIES_ALCREMIE_BERRY_SWEET"),
    ("PECHA", "SPECIES_ALCREMIE_LOVE_SWEET"), ("SITRUS", "SPECIES_ALCREMIE_STAR_SWEET"),
    ("LUM", "SPECIES_ALCREMIE_CLOVER_SWEET"), ("ASPEAR", "SPECIES_ALCREMIE_FLOWER_SWEET"),
    ("NANAB", "SPECIES_ALCREMIE_RIBBON_SWEET"),
)]

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
        # GetMonEvolution's three contexts, and Mon_CountLetsGoStep's.
        self.assertEqual(source.count("for (i = 0; i < MAX_EVOS_PER_POKE; i++)"), 4)

    def test_a_member_is_as_long_as_the_readers_buffer(self):
        """The whole member is read into MAX_EVOS_PER_POKE evolutions of six
        bytes (a heap block in GetMonEvolution, a stack array in
        SpeciesHasEvolution). A pad after them was written two bytes past
        both."""
        path = ROOT / "files/poketool/personal/evo.narc"
        if not path.exists():
            self.skipTest("evo.narc is build output")
        data = path.read_bytes()
        table = struct.unpack_from("<H", data, 12)[0]
        count = struct.unpack_from("<H", data, table + 8)[0]
        sizes = {end - start for start, end in
                 (struct.unpack_from("<II", data, table + 12 + 8 * i) for i in range(count))}
        self.assertEqual(sizes, {self.limit * 6})

    def test_a_linking_cord_stands_in_for_a_trade_with_an_item(self):
        """hg-engine at d0380a487: used on a Pokemon that evolves by trading
        while holding something, a Linking Cord evolves it -- if it holds it."""
        source = (ROOT / "src/pokemon.c").read_text()
        use = source[source.index("case EVOCTX_ITEM_USE:"):]
        use = use[:use.index("Heap_Free(evoTable);")]
        self.assertRegex(use, r"method == EVO_TRADE_ITEM && heldItem == evoTable\[i\]\.param"
                              r" && usedItem == ITEM_LINKING_CORD")

    def test_konefrs_linking_cord_stands_in_for_any_trade(self):
        """konefr's e26576dd1: a plain trade evolution, no item held, also
        evolves with a Linking Cord -- and ahead of the engine's held-item
        case, in his order."""
        source = (ROOT / "src/pokemon.c").read_text()
        use = source[source.index("case EVOCTX_ITEM_USE:"):]
        use = use[:use.index("Heap_Free(evoTable);")]
        plain = use.index("usedItem == ITEM_LINKING_CORD && evoTable[i].method == EVO_TRADE)")
        self.assertLess(plain, use.index("method == EVO_TRADE_ITEM && heldItem"))

    def test_the_engines_own_changes_to_retail_species(self):
        """hg-engine at d0380a487 reworks eight of HeartGold's species, and
        they are the engine's, not konefr's: a Linking Cord for four trades,
        a stone for three places Johto has not got, a Prism Scale trade."""
        rows = {(base, evo["method"], evo["param"], evo["target"])
                for base, evos in self.byBase.items() for evo in evos}
        for base, target in [("KADABRA", "ALAKAZAM"), ("MACHOKE", "MACHAMP"),
                             ("GRAVELER", "GOLEM"), ("HAUNTER", "GENGAR")]:
            self.assertIn((f"SPECIES_{base}", "EVO_STONE", "ITEM_LINKING_CORD", f"SPECIES_{target}"), rows)
        for base, item, target in [("MAGNETON", "THUNDERSTONE", "MAGNEZONE"), ("NOSEPASS", "THUNDERSTONE", "PROBOPASS"),
                                   ("EEVEE", "LEAF_STONE", "LEAFEON"), ("EEVEE", "ICE_STONE", "GLACEON")]:
            self.assertIn((f"SPECIES_{base}", "EVO_STONE", f"ITEM_{item}", f"SPECIES_{target}"), rows)
        self.assertIn(("SPECIES_FEEBAS", "EVO_TRADE_ITEM", "ITEM_PRISM_SCALE", "SPECIES_MILOTIC"), rows)
        # Beside the Thunder Stone, the engine's magnetic field: Route 43 and
        # Route 10 stand in for Mt. Coronet.
        for base, target in [("MAGNETON", "MAGNEZONE"), ("NOSEPASS", "PROBOPASS")]:
            self.assertIn((f"SPECIES_{base}", "EVO_MAGNETIC_FIELD", 0, f"SPECIES_{target}"), rows)
        # HeartGold's Eterna and Route 217 rows stay out: their numbers are
        # the engine's Moss and Ice Rocks now, which neither tree's data uses.
        self.assertFalse({row for row in rows if row[1] in ("EVO_MOSSY_ROCK", "EVO_ICY_ROCK")})

    def test_spritzee_and_swirlix_want_their_items_held(self):
        """hg-engine's Evolutions.c at d0380a487 evolves both by any trade; the
        games, and the Sachet's and the Whipped Dream's hold effects, want the
        item held. The importer writes the games' row over the engine's, so a
        re-import keeps it (Paolo, 2026-09-23: reference defects are fixed)."""
        self.assertEqual(self.byBase["SPECIES_SPRITZEE"],
                         [{"method": "EVO_TRADE_ITEM", "param": "ITEM_SACHET", "target": "SPECIES_AROMATISSE"}])
        self.assertEqual(self.byBase["SPECIES_SWIRLIX"],
                         [{"method": "EVO_TRADE_ITEM", "param": "ITEM_WHIPPED_DREAM", "target": "SPECIES_SLURPUFF"}])
        self.assertEqual(import_evolutions.CANONICAL_ROWS[("SPECIES_SWIRLIX", "EVO_TRADE", "0", "SPECIES_SLURPUFF")],
                         ("EVO_TRADE_ITEM", "ITEM_WHIPPED_DREAM", "SPECIES_SLURPUFF"))
        self.assertEqual(import_evolutions.CANONICAL_ROWS[("SPECIES_SPRITZEE", "EVO_TRADE", "0", "SPECIES_AROMATISSE")],
                         ("EVO_TRADE_ITEM", "ITEM_SACHET", "SPECIES_AROMATISSE"))

    def test_rows_by_the_engines_own_methods(self):
        """The rows by a method hg-engine added at d0380a487, which this
        engine has now; tests/newgold/test_evolution_methods.py runs each
        method on the host."""
        for base, row in ENGINE_METHOD_ROWS:
            self.assertIn(dict(zip(("method", "param", "target"), row)), self.byBase.get(base, []), base)

    def test_paolos_designs(self):
        """test_evolution_methods.py runs these rows, read from the table, on
        the host."""
        for base, row in DESIGNED_ROWS:
            self.assertIn(dict(zip(("method", "param", "target"), row)), self.byBase.get(base, []), base)
            self.assertIn(row, import_evolutions.DESIGNED_ROWS[base], base)
        # Milcery has those seven and no other: the reference's spins stay out.
        self.assertEqual(len(self.byBase["SPECIES_MILCERY"]), 7)

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
        # row counting twenty uses of the move. That is hg-engine's own row,
        # read with the engine's methods; the move row beside it is the whole
        # of what konefr changed.
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
