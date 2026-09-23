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


if __name__ == "__main__":
    unittest.main()
