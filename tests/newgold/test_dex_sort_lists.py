#!/usr/bin/env python3
"""Check zukan_data.narc holds, member for member, what zukan_data.json says.

The archive is the json through a template and the assembler, split into
members by o2narc at the template's symbols. The assembler puts each symbol
after a ".balign 4, 255"; o2narc once walked them as if packed, so every
member after the one-byte body styles (1,438 bytes) began two bytes early:
the national list read 0, 1, ..., 492 and the Johto list began with Arceus
and a padding word, which the Dex's list builder asserted on.

The members are compared with the json directly: the body styles, the first
table after them, and every sort list, as built for HeartGold and for the
Origin-forme copy.
"""

import json
import re
import struct
import unittest

from test_level_cap import ROOT

DIR = ROOT / "files/application/zukanlist/zkn_data"
SORT_LISTS_START = 11   # members 0..10 are the mon_stats tables


def members(path):
    data = path.read_bytes()
    count = struct.unpack_from("<H", data, 0x18)[0]
    spans = [struct.unpack_from("<II", data, 0x1C + 8 * i) for i in range(count)]
    base = data.index(b"GMIF") + 8
    return [data[base + start:base + end] for start, end in spans]


def species_ids():
    text = (ROOT / "include/constants/species.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (SPECIES_\w+)\s+(\d+)\b", text)}


class DexSortListTests(unittest.TestCase):
    def check(self, narc, forme):
        path = DIR / narc
        if not path.exists():
            self.skipTest(f"{narc} is not built")
        data = json.loads((DIR / "zukan_data.json").read_text())
        ids = species_ids()
        got = members(path)

        pick = lambda value: value if isinstance(value, (int, list)) else value[forme]  # noqa: E731
        styles = bytes(pick(mon["body_style"]) for mon in data["mon_stats"])
        self.assertEqual(got[2], styles, f"{narc}: body styles")
        scales = struct.pack(f"<{len(data['mon_stats'])}h", *(mon["scale_f"] for mon in data["mon_stats"]))
        self.assertEqual(got[3], scales, f"{narc}: the table after the body styles")

        index = SORT_LISTS_START
        for group in data["sorting"]:
            for option in group["options"]:
                names = pick(option["mons"])
                expected = struct.pack(f"<{len(names)}H", *(ids[name] for name in names))
                self.assertEqual(got[index], expected, f"{narc}: {group['type']} {option['id']}")
                index += 1
        self.assertEqual(index, len(got))

    def test_heartgold_archive(self):
        self.check("zukan_data.narc", "altered")

    def test_origin_forme_archive(self):
        self.check("zukan_data_gira.narc", "origin")


def national_numbers():
    """species -> National Dex number, as Pokedex_ConvertToCurrentDexNo
    answers: its own number up to Arceus, the table in src/pokedex.c after."""
    source = (ROOT / "src/pokedex.c").read_text()
    table = source[source.index("static const u16 sNationalDexNumbers["):]
    table = table[:table.index("};")]
    ids = species_ids()
    out = {species: species for species in range(1, ids["SPECIES_ARCEUS"] + 1)}
    for name, number in re.findall(r"\[(SPECIES_\w+) - LAST_DEX_GAP - 1\] = (\d+),", table):
        out[ids[name]] = int(number)
    return out


class DexSortListContentTests(unittest.TestCase):
    """The lists the Dex builds its list from hold every species it has an
    entry for, as the Dex numbers and shows them; they stopped at Arceus."""

    def setUp(self):
        self.data = json.loads((DIR / "zukan_data.json").read_text())
        self.ids = species_ids()
        self.lists = {(g["type"], o["id"]): o["mons"] for g in self.data["sorting"] for o in g["options"]}
        self.numbers = national_numbers()
        # the two Galarian forms kept as species share Slowpoke's and Slowbro's numbers
        self.dex = [s for s, n in self.numbers.items() if s <= self.ids["SPECIES_ARCEUS"] or n > self.ids["SPECIES_ARCEUS"]]

    def flat(self, key):
        value = self.lists[key]
        return value if isinstance(value, list) else value["altered"]

    def test_the_national_order_is_every_dex_species(self):
        national = [self.ids[name] for name in self.flat(("dex_order", "national"))]
        self.assertEqual(len(national), 1025)
        self.assertEqual(sorted(national), sorted(self.dex))
        self.assertEqual([self.numbers[s] for s in national], list(range(1, 1026)))
        header = (ROOT / "include/application/pokedex/pokedex_internal.h").read_text()
        self.assertIn("#define POKEDEX_LIST_LEN      NATIONAL_DEX_COUNT", header)
        self.assertLessEqual(len(national), self.ids["SPECIES_PECHARUNT"])

    def test_every_order_lists_the_same_species(self):
        dex = sorted(self.dex)
        for order in ("alphabetical", "heaviest", "lightest", "tallest", "shortest"):
            self.assertEqual(sorted(self.ids[name] for name in self.flat(("dex_order", order))), dex, order)

    def test_the_sizes_are_in_order(self):
        stats = self.data["mon_stats"]
        value = lambda name, field: (lambda v: v if isinstance(v, int) else v["altered"])(stats[self.ids[name]][field])  # noqa: E731
        for order, field, sign in (("heaviest", "weight", -1), ("lightest", "weight", 1),
                                   ("tallest", "height", -1), ("shortest", "height", 1)):
            got = [sign * value(name, field) for name in self.flat(("dex_order", order))]
            self.assertEqual(got, sorted(got), order)

    def test_the_area_flags_reach_the_last_dex_species(self):
        for path in sorted((DIR / "zukan_hw_data").glob("zukan_hw_data_1_*.bin")):
            flags = path.read_bytes()
            self.assertEqual(len(flags), self.ids["SPECIES_PECHARUNT"] + 1, path.name)
            # an added species has no area of its own: "unknown", and any
            self.assertEqual(flags[self.ids["SPECIES_LILLIPUP"]], 8 | 4, path.name)


if __name__ == "__main__":
    unittest.main()
