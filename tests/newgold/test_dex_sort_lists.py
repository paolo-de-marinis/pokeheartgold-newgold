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
import sys
import unittest

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import gmm  # noqa: E402

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

    def test_every_dex_species_has_its_body_style(self):
        """The reference gives every species past Arceus the placeholder
        quadruped, so the body-style search listed only HeartGold's 493.
        Each Dex species is in one body-style list, an added one under the
        games' shape (body_shapes.csv), and the shapes' order maps onto
        retail's but for the nine the later games moved."""
        from body_shapes import styles
        shapes = styles()
        lists = [o["mons"] for g in self.data["sorting"] if g["type"] == "body_style" for o in g["options"]]
        self.assertEqual(len(lists), 14)
        for forme in ("altered", "origin"):
            listed = [self.ids[name] for mons in lists for name in (mons if isinstance(mons, list) else mons[forme])]
            self.assertEqual(sorted(listed), sorted(self.dex), forme)
        stats = self.data["mon_stats"]
        style = lambda s: (lambda v: v if isinstance(v, int) else v["origin"])(stats[s]["body_style"])  # noqa: E731
        for species in self.dex:
            if species > self.ids["SPECIES_ARCEUS"]:
                self.assertEqual(style(species), shapes[self.numbers[species]], species)
        moved = {n for n in range(1, self.ids["SPECIES_ARCEUS"] + 1) if style(n) != shapes[n]}
        self.assertEqual(moved, {10, 13, 265, 412, 413, 416, 422, 423, 488})
        self.assertEqual(style(self.ids["SPECIES_LILLIPUP"]), 0)     # quadruped
        self.assertEqual(style(self.ids["SPECIES_BAXCALIBUR"]), 2)   # bipedal, tailed
        self.assertEqual(style(self.ids["SPECIES_PECHARUNT"]), 12)   # a head only


class GiratinaFormeTests(unittest.TestCase):
    """The Dex shows each of Giratina's Formes its own height, weight and
    body style: retail's pair, which the reference replaced with the Altered
    Forme's figures alone (Origin: 6.9 m, 650 kg, serpentine)."""

    def test_each_forme_reads_its_own_figures(self):
        # SetDexBanksByGiratinaForm: the gira archive and banks 813/815 for
        # the Altered Forme, the others for the Origin Forme.
        source = (ROOT / "src/dex_mon_measures.c").read_text()
        self.assertRegex(source, r"if \(form == GIRATINA_ALTERED\) \{\s*sDataNarcId = NARC_application_zukanlist_zkn_data_zukan_data_gira;"
                                 r"\s*sWeightMsgBank = NARC_msg_msg_0813_bin;\s*sHeightMsgBank = NARC_msg_msg_0815_bin;")
        # the template builds a pair's "altered" into zukan_data and its "origin" into zukan_data_gira
        giratina = json.loads((DIR / "zukan_data.json").read_text())["mon_stats"][species_ids()["SPECIES_GIRATINA"]]
        self.assertEqual({field: giratina[field] for field in ("height", "weight", "body_style")},
                         {"height": {"altered": 69, "origin": 45}, "weight": {"altered": 6500, "origin": 7500},
                          "body_style": {"altered": 3, "origin": 10}})
        texts = {bank: gmm.read(bank)[species_ids()["SPECIES_GIRATINA"]]["text"] for bank in (812, 813, 814, 815)}
        self.assertEqual(texts, {812: "1433.0 lbs.", 813: "1653.5 lbs.", 814: " 22’08”", 815: " 14’09”"})


if __name__ == "__main__":
    unittest.main()
