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


if __name__ == "__main__":
    unittest.main()
