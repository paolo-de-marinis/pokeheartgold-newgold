#!/usr/bin/env python3
"""A terrain's start plays an animation of its own (Paolo, 2026-10-02).

The latest games play one as a terrain is laid -- sparks, grass, mist,
psychic waves -- before the field stays covered. hg-engine (d0380a487) has
none: its BATTLE_ANIMATION_*_TERRAIN, 50 to 53, are the background change
alone, and its terrain moves' animations are borrowed from other moves.
Here they are battle animations of the game's own kind, members 50 to 53
of a/0/6/1 after the 50 the game shipped with, made of the game's own
effects and its background tint, in the script overlay 7 runs
(asm/macros/btlanim.inc).
"""

import re
import sys
import unittest

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
from narccheck import members  # noqa: E402

ANIM = ROOT / "files/battle/anim"
RETAIL = ANIM / "battle_anim/retail.narc"
BUILT = ANIM / "battle_anim.narc"
SHIPPED = 50
# BATTLE_ANIMATION_GRASSY_TERRAIN (50) and the three after it.
TERRAINS = ("grassy", "misty", "electric", "psychic")
PARTICLES = 486     # a/0/2/9's members: the effects the game has


class ArchiveTests(unittest.TestCase):
    def test_the_archive_is_built_from_the_shipped_one_and_the_scripts(self):
        rules = (ANIM / "battle_anim.mk").read_text()
        self.assertIn("BATTLE_ANIM_TERRAINS := " + " ".join(TERRAINS), rules)
        self.assertIn("arc_strip_name,files/battle/anim/battle_anim.narc,files/a/0/6/1",
                      (ROOT / "filesystem.mk").read_text())

    def test_the_shipped_members_are_untouched_and_the_terrains_follow(self):
        if not BUILT.exists():
            self.skipTest("the archive is not built")
        built, retail = members(BUILT), members(RETAIL)
        self.assertEqual(len(retail), SHIPPED)
        self.assertEqual(built[:SHIPPED], retail)
        self.assertEqual(len(built), SHIPPED + len(TERRAINS))
        for n, terrain in enumerate(TERRAINS):
            binary = ANIM / f"battle_anim/terrain_{terrain}.bin"
            self.assertEqual(built[SHIPPED + n], binary.read_bytes(), terrain)

    def test_each_animation_loads_only_the_games_effects_and_frees_them(self):
        for terrain in TERRAINS:
            text = (ANIM / f"battle_anim/terrain_{terrain}.s").read_text()
            for slot, effect in re.findall(r"^\s*LoadParticles (\d+), (\d+)", text, re.M):
                self.assertLess(int(effect), PARTICLES, terrain)
                self.assertRegex(text, rf"\n\s*UnloadParticles {slot}\n", terrain)
            self.assertRegex(text, r"\n\s*End\n$", terrain)


if __name__ == "__main__":
    unittest.main()
