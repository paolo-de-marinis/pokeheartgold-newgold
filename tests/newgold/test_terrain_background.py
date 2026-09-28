#!/usr/bin/env python3
"""A terrain draws its own background, hg-engine's look (d0380a487).

Each of the four terrains has a background of its own, with no platforms,
from the moment the terrain is laid to the moment it goes, when the battle's
own comes back with its platforms. The four pictures are members of the
battle backgrounds' archive, a/0/0/7, after the 351 the game shipped with,
which come out of the shipped archive unchanged; the subscripts that lay a
terrain and end one run ChangePermanentBackground, which sends the display
SetBattleBackground's command with the two ids (BattleSystem_SetBackground).
In play: scenarios/terrain_background.json.
"""

import re
import struct
import sys
import unittest

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
from narccheck import members  # noqa: E402

GRAPHIC = ROOT / "files/battle/graphic"
RETAIL = GRAPHIC / "batt_bg/retail.narc"
BUILT = GRAPHIC / "batt_bg.narc"
SHIPPED = 351
# hg-engine's BATTLE_BG_*_TERRAIN order, 23 to 26.
TERRAINS = ("electric", "misty", "grassy", "psychic")
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def unlz(data):
    """The LZ77 the DS's BIOS reads (type 0x10)."""
    assert data[0] == 0x10, hex(data[0])
    size = int.from_bytes(data[1:4], "little")
    out, i = bytearray(), 4
    while len(out) < size:
        flags = data[i]
        i += 1
        for _ in range(8):
            if len(out) >= size:
                break
            if flags & 0x80:
                pair = data[i] << 8 | data[i + 1]
                i += 2
                for _ in range((pair >> 12) + 3):
                    out.append(out[-((pair & 0xFFF) + 1)])
            else:
                out.append(data[i])
                i += 1
            flags <<= 1
    return bytes(out)


def script(name):
    return next(SUBSCRIPTS.glob(f"subscript_{name}_*.s")).read_text()


class ArchiveTests(unittest.TestCase):
    def test_the_archive_is_built_from_the_shipped_one_and_the_pictures(self):
        rules = (GRAPHIC / "batt_bg.mk").read_text()
        self.assertIn("BATT_BG_TERRAINS := " + " ".join(TERRAINS), rules)
        self.assertIn("arc_strip_name,files/battle/graphic/batt_bg.narc,files/a/0/0/7",
                      (ROOT / "filesystem.mk").read_text())
        for terrain in TERRAINS:
            png = (GRAPHIC / f"batt_bg/terrain_{terrain}.png").read_bytes()
            self.assertEqual(struct.unpack(">II", png[16:24]), (256, 256), terrain)

    def test_the_shipped_members_are_untouched_and_the_terrains_follow(self):
        if not BUILT.exists():
            self.skipTest("the archive is not built")
        built, retail = members(BUILT), members(RETAIL)
        self.assertEqual(len(retail), SHIPPED)
        self.assertEqual(built[:SHIPPED], retail)
        self.assertEqual(len(built), SHIPPED + 2 * len(TERRAINS))
        for n, terrain in enumerate(TERRAINS):
            tiles, palette = unlz(built[SHIPPED + 2 * n]), built[SHIPPED + 2 * n + 1]
            # 256-colour tiles, 32 by 32, the whole of BG 3's 0x10000.
            self.assertEqual(tiles[:4], b"RGCN", terrain)
            self.assertEqual(struct.unpack_from("<HHI", tiles, 0x18), (32, 32, 4), terrain)
            self.assertEqual(struct.unpack_from("<I", tiles, 0x28)[0], 0x10000, terrain)
            # Sixteen colours, inside the 0x70 a background of the game's own
            # has: the platforms' row starts at 0x70.
            self.assertLess(max(tiles[0x30:0x30 + 0x10000]), 16, terrain)
            self.assertEqual(palette[:4], b"RLCN", terrain)
        index = (GRAPHIC / "batt_bg.naix").read_text()
        for n, terrain in enumerate(TERRAINS):
            self.assertIn(f"NARC_batt_bg_terrain_{terrain}_NCGR_lz {SHIPPED + 2 * n}\n", index)


class ScriptTests(unittest.TestCase):
    def test_each_terrain_draws_its_background_before_its_line(self):
        text = script("0347")
        branches = {"GRASSY": "Grass grew", "MISTY": "Mist swirled", "ELECTRIC": "An electric current",
                    "PSYCHIC": "got weird", "ELECTRIC_ENGINE": "turned the ground into Electric Terrain"}
        for terrain, line in branches.items():
            name = terrain.split("_")[0]
            before = text[:text.index(line)]
            label = before[before.rindex(":\n"):]
            self.assertRegex(label, rf"\n\s*ChangePermanentBackground BATTLE_BG_{name}_TERRAIN, "
                                    rf"TERRAIN_{name}_TERRAIN\n", terrain)

    def test_the_battles_own_comes_back_wherever_a_terrain_ends(self):
        for name in ("0378", "0171"):
            lines = [l.strip() for l in script(name).splitlines()]
            ends = [i for i, l in enumerate(lines) if l.startswith("UpdateTerrainOverlay TRUE")]
            self.assertEqual(len(ends), 4, name)
            for i in ends:
                self.assertEqual(lines[i + 1:i + 3], ["ChangePermanentBackground BATTLE_BG_CURRENT, TERRAIN_CURRENT", "Wait"], name)


if __name__ == "__main__":
    unittest.main()
