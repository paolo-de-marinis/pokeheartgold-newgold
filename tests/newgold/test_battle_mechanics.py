#!/usr/bin/env python3
"""Pin the battle numbers this port takes from the reference's generation.

HeartGold's battle engine is Generation IV; hg-engine replaces its numbers with
later ones, and konefr's New Gold keeps those. Each class here pins one number
the port changed to match, so turning it back to HeartGold's fails here.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def subscript(name):
    matches = sorted(SUBSCRIPTS.glob(f"subscript_*_{name}.s"))
    assert len(matches) == 1, f"{name}: {matches}"
    return matches[0].read_text()


class BurnTests(unittest.TestCase):
    def test_a_burn_takes_a_sixteenth_and_heatproof_halves_that(self):
        # The reference's subscript_0026_BURN_DAMAGE.s divides by 16, and by 2
        # again for Heatproof. HeartGold divided by 8.
        divisions = re.findall(r"DivideVarByValue BSCRIPT_VAR_HP_CALC, (\d+)", subscript("BurnDamage"))
        self.assertEqual(divisions, ["16", "2"])


class ParalysisTests(unittest.TestCase):
    def test_paralysis_halves_speed_on_both_sides_of_the_comparison(self):
        # The reference's CalcSpeed takes QMul_RoundUp(speed, UQ412__0_5):
        # half, a half rounded up. HeartGold divided by 4.
        body = function(OVERLAY.read_text(), "CheckSortSpeed")
        halvings = re.findall(r"STATUS_PARALYSIS\) \{\n(?:\s*//[^\n]*\n)*\s*(speed\d) = \(\1 \+ 1\) / 2;", body)
        self.assertEqual(halvings, ["speed1", "speed2"])


class CriticalHitTests(unittest.TestCase):
    def test_the_odds_at_each_stage_are_the_reference_s(self):
        # other_battle_calculators.c's CriticalRateTable. HeartGold's was
        # 16, 8, 4, 3, 2.
        table = re.search(r"sCritChance\[\] = \{([^}]*)\}", OVERLAY.read_text()).group(1)
        self.assertEqual([int(n) for n in table.split(",")], [24, 8, 2, 1, 1])


    def test_a_critical_hit_is_half_again_and_sniper_half_again_on_that(self):
        # battle_calc_damage.c: 6.4 multiplies by 150/100, and 6.9.3 gives
        # Sniper another 1.5. HeartGold multiplied by 2, and by 3 for Sniper.
        program = "typedef struct { int damage, criticalMultiplier; } BattleContext;\n"
        program += function(COMMANDS.read_text(), "ApplyCriticalHit")
        program += """
#include <assert.h>
int main(void) {
    int expected[] = { 0, 100, 150, 225 };
    for (int crit = 1; crit <= 3; crit++) {
        BattleContext ctx = { 100, crit };
        ApplyCriticalHit(&ctx);
        assert(ctx.damage == expected[crit]);
    }
    return 0;
}
"""
        with tempfile.TemporaryDirectory(prefix="newgold-crit-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_both_damage_paths_take_it(self):
        # The ordinary calculation and Beat Up's own; neither multiplies by
        # the stored number any more.
        source = COMMANDS.read_text()
        self.assertNotIn("*= ctx->criticalMultiplier", source)
        for name in ("DamageCalcDefault", "BtlCmd_BeatUp"):
            self.assertIn("ApplyCriticalHit(ctx);", function(source, name), name)


class ExplosionTests(unittest.TestCase):
    def test_the_target_s_defense_is_not_halved(self):
        # HeartGold halved the target's Defense for effect 7 (Explosion and
        # Self-Destruct). The reference keeps the effect only for fainting the
        # user; its move records carry the later powers instead, and so do
        # this game's.
        self.assertNotIn("MOVE_EFFECT_HALVE_DEFENSE", function(OVERLAY.read_text(), "CalcMoveDamage"))


class SandstormTests(unittest.TestCase):
    def test_the_sand_abilities_are_spared_the_chip_damage(self):
        # battle_script_commands.c's BtlCmd_EndOfTurnWeatherEffect spares
        # Sand Veil, Sand Rush and Sand Force alike.
        body = function(COMMANDS.read_text(), "BtlCmd_EndOfTurnWeatherEffect")
        sand = re.search(r"FIELD_CONDITION_SANDSTORM_ALL\) \{\n\s*if \(([^\n]*)\) \{", body).group(1)
        for ability in ("SAND_VEIL", "SAND_RUSH", "SAND_FORCE"):
            self.assertIn(f"GetBattlerAbility(ctx, battlerId) != ABILITY_{ability}", sand)


if __name__ == "__main__":
    unittest.main()
