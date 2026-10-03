#!/usr/bin/env python3
"""A terrain's start plays an animation of its own (Paolo, 2026-10-02).

The latest games play one as a terrain is laid -- sparks, grass, mist,
psychic waves -- before the field stays covered. hg-engine (d0380a487) has
none: its BATTLE_ANIMATION_*_TERRAIN, 50 to 53, are the background change
alone, and its terrain moves' animations are borrowed from other moves.
Here they are battle animations of the game's own kind, members 50 to 53
of a/0/6/1 after the 50 the game shipped with, made of the game's own
effects and its background tint, in the script overlay 7 runs
(asm/macros/btlanim.inc). Subscript 347, which every terrain's start goes
through -- the moves, the Surges and Hadron Engine, Seed Sower -- plays the
terrain's before its background is drawn and its line printed, and a
terrain move's animation is that one. In play: scenarios/terrain_animation.json.
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
SUBSCRIPT = next((ROOT / "files/battledata/script/subscript").glob("subscript_0347_*.s"))


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


class ScriptTests(unittest.TestCase):
    def test_each_terrain_plays_its_animation_before_its_background(self):
        text = SUBSCRIPT.read_text()
        backgrounds = re.findall(r"^\s*ChangePermanentBackground BATTLE_BG_(\w+)_TERRAIN", text, re.M)
        plays = re.findall(r"^\s*PlayBattleAnimationOnMons BATTLER_CATEGORY_PLAYER, BATTLER_CATEGORY_ENEMY, "
                           r"BATTLE_ANIMATION_(\w+)_TERRAIN\n\s*Wait\n\s*ChangePermanentBackground BATTLE_BG_(\w+)_TERRAIN",
                           text, re.M)
        self.assertEqual(len(backgrounds), 5)
        self.assertEqual(len(plays), 5)
        for animation, background in plays:
            self.assertEqual(animation, background)

    def test_a_substitute_does_not_stop_it(self):
        # The field's animations, the weathers', play over a Pokemon behind a
        # substitute (CheckStatusEffectsSubstitute's list); a terrain's too.
        source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        listed = re.search(r"static const int ov12_0226CBDC\[\] = \{(.*?)\};", source, re.S).group(1)
        for terrain in TERRAINS:
            self.assertIn(f"BATTLE_ANIMATION_{terrain.upper()}_TERRAIN", listed)

    def test_a_terrain_move_borrows_no_animation_after_its_line(self):
        # UseMove's subscript 76 plays the move's animation when it has not
        # played: the terrain's start is a terrain move's, so the subscript
        # marks it played where each terrain's branch ends.
        text = SUBSCRIPT.read_text()
        self.assertNotIn("OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF", text)
        self.assertRegex(text, r"\n_037:\n\s*UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, "
                               r"BATTLE_STATUS_MOVE_ANIMATIONS_OFF\n\s*End\n")


if __name__ == "__main__":
    unittest.main()
