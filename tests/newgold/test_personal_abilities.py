#!/usr/bin/env python3
"""Check that a species' ability survives the personal record.

The record kept the two abilities and the hidden one as bytes, which was right
while abilities stopped at 123. The expansion numbers them to 319, and 89 of
the slots the reference fills are past 255: in a byte, Anger Shell became
nothing and Commander became something else, on 85 species, with no build
error and no assertion. The full values are written past the end of the record
the way the experience yield already was, and GetMonBaseStat reads those.

This compares what the archive holds against the JSON it is built from, for
every species, so a record that loses an ability fails here instead of in a
battle.
"""

import json
import re
import struct
import unittest
from pathlib import Path

from test_level_cap import ROOT

NARC = ROOT / "files/poketool/personal/personal.narc"
SOURCE = ROOT / "files/poketool/personal/personal.json"
WIDE_AT = 0x2E          # abilities[0], abilities[1], hiddenAbility, as halfwords
BYTES_AT = 0x16         # the same three as bytes, kept for anything reading by offset


def numbers():
    header = (ROOT / "include/constants/abilities.h").read_text()
    return {f"ABILITY_{name}": int(value) for name, value in
            re.findall(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)", header)}


def records():
    data = NARC.read_bytes()
    position = struct.unpack_from("<H", data, 12)[0]
    count = struct.unpack_from("<H", data, position + 8)[0]
    ranges = [struct.unpack_from("<II", data, position + 12 + 8 * i) for i in range(count)]
    body = data.index(b"GMIF") + 8
    return [data[body + start:body + end] for start, end in ranges]


class PersonalAbilityTests(unittest.TestCase):
    def setUp(self):
        if not NARC.exists():
            self.skipTest("the personal archive is not built")
        self.records = records()
        self.rows = json.loads(SOURCE.read_text())["baseStats"]
        self.numbers = numbers()

    def wanted(self, row):
        abilities = row.get("abilities", ["ABILITY_NONE", "ABILITY_NONE"])
        return (self.numbers[abilities[0]], self.numbers[abilities[1]],
                self.numbers[row.get("hiddenAbility", "ABILITY_NONE")])

    def test_every_record_carries_its_abilities_whole(self):
        for index, row in enumerate(self.rows):
            if index >= len(self.records):
                break
            got = struct.unpack_from("<HHH", self.records[index], WIDE_AT)
            self.assertEqual(got, self.wanted(row), f"species {index}")

    def test_the_wide_field_is_what_the_game_reads(self):
        source = (ROOT / "src/pokemon.c").read_text()
        for field in ("abilitiesFull[0]", "abilitiesFull[1]", "hiddenAbilityFull"):
            self.assertIn(field, source, f"GetMonBaseStat does not read {field}")

    def test_an_ability_past_a_byte_would_have_been_lost(self):
        """The point of the change: there really are such abilities."""
        past = sum(1 for row in self.rows for value in self.wanted(row) if value > 255)
        self.assertGreater(past, 0)
        for index, row in enumerate(self.rows):
            if index >= len(self.records):
                break
            bytes_ = struct.unpack_from("<BBB", self.records[index], BYTES_AT)[:2]
            wide = self.wanted(row)[:2]
            for narrow, whole in zip(bytes_, wide):
                self.assertEqual(narrow, whole & 0xFF, f"species {index}")


if __name__ == "__main__":
    unittest.main()
