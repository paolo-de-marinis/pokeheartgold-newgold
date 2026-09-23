#!/usr/bin/env python3
"""Check the Day-Care's tables reach every species."""

import re
import struct
import unittest

from test_level_cap import ROOT


def species():
    header = (ROOT / "include/constants/species.h").read_text()
    numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}
    return numbers, numbers[re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)]


class EggSpeciesTests(unittest.TestCase):
    """pms.narc, one halfword a species: what an egg from that mother is."""

    def setUp(self):
        data = (ROOT / "files/poketool/personal/pms.narc").read_bytes()
        self.table = struct.unpack(f"<{len(data) // 2}H", data)
        self.numbers, self.last = species()

    def egg(self, name):
        return self.table[self.numbers[name]]

    def test_every_species_has_an_egg_species(self):
        self.assertEqual(len(self.table), self.last + 1)
        self.assertEqual([n for n in range(1, self.last + 1) if not 0 < self.table[n] <= self.last], [])

    def test_added_species_and_forms_breed_true(self):
        self.assertEqual(self.egg("SERVINE"), self.numbers["SNIVY"])
        self.assertEqual(self.egg("SYLVEON"), self.numbers["EEVEE"])
        # The mother's form carries over, as the reference's form number does.
        self.assertEqual(self.egg("NINETALES_ALOLAN"), self.numbers["VULPIX_ALOLAN"])
        self.assertEqual(self.egg("MEGA_VENUSAUR"), self.numbers["BULBASAUR"])


class EggMoveTests(unittest.TestCase):
    """kowaza_list.narc: MAX_EGG_MOVES halfwords a species, read by
    LoadEggMoves at species * MAX_EGG_MOVES and ended by 0xFFFF."""

    def setUp(self):
        import sys
        sys.path.insert(0, str(ROOT / "tools/newgold/import"))
        import wotbl
        member, = wotbl.read_narc((ROOT / "files/fielddata/sodateya/kowaza_list.narc").read_bytes())[0]
        self.width = int(re.search(r"#define MAX_EGG_MOVES\s+(\d+)",
                                   (ROOT / "include/constants/daycare.h").read_text()).group(1))
        self.numbers, self.last = species()
        self.member = member
        self.moves = wotbl.move_names()

    def moves_of(self, name):
        record = struct.unpack_from(f"<{self.width}H", self.member, self.numbers[name] * self.width * 2)
        return list(record[:record.index(0xFFFF)] if 0xFFFF in record else record)

    def test_every_species_has_a_record(self):
        self.assertEqual(len(self.member), (self.last + 1) * self.width * 2)

    def test_the_reader_reads_the_species_record(self):
        """Retail's reader searched the first 2045 halfwords for a marker."""
        reader = re.search(r"static u8 LoadEggMoves\([^;{]*\{.*?\n\}", (ROOT / "src/get_egg.c").read_text(), re.S).group(0)
        self.assertIn("species * MAX_EGG_MOVES * sizeof(u16), MAX_EGG_MOVES * sizeof(u16)", reader)

    def test_the_lists_are_hg_engines(self):
        # d0380a487's learnsets.json: Chikorita's modern list, one added
        # species and one form.
        self.assertEqual(self.moves_of("CHIKORITA"), [self.moves[m] for m in (
            "MOVE_VINE_WHIP", "MOVE_COUNTER", "MOVE_FLAIL", "MOVE_ANCIENT_POWER", "MOVE_INGRAIN", "MOVE_HEAL_PULSE")])
        self.assertIn(self.moves["MOVE_COPYCAT"], self.moves_of("SPRIGATITO"))
        self.assertIn(self.moves["MOVE_MOONBLAST"], self.moves_of("VULPIX_ALOLAN"))


if __name__ == "__main__":
    unittest.main()
