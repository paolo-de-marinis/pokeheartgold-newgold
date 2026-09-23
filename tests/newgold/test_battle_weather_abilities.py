#!/usr/bin/env python3
"""The abilities that are a weather of their own.

Mega Sol makes its holder's moves behave as in harsh sunlight. What a move
sees is one question, BattlerMoveWeather (hg-engine's GetWeather), and every
place a move of the holder's reads the weather has to ask it. The rules are
compiled natively; the places are read from the source.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
COMMANDS = ROOT / "src/battle/battle_command.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
EFFECTS = ROOT / "files/battledata/script/effect_script"

PREFIX = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { u32 fieldCondition; u16 ability[4]; BOOL cloudNine; } BattleContext;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->ability[battlerId]; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)flag; (void)battlerId;
    return ctx->cloudNine && ability == ABILITY_CLOUD_NINE;
}
static BattleSystem bs;
static BattleContext ctx;
"""


def run(functions, body):
    source = OVERLAY.read_text()
    program = PREFIX + "\n".join(function(source, name) for name in functions) + "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
    with tempfile.TemporaryDirectory(prefix="newgold-weather-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address,undefined",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
    if result.returncode:
        raise AssertionError(result.stdout + result.stderr)
    return result.stdout.strip()


class MegaSolTests(unittest.TestCase):
    def test_its_moves_see_harsh_sunlight(self):
        print(run(["BattlerMoveWeather"], r"""
    ctx.fieldCondition = FIELD_CONDITION_RAIN | FIELD_CONDITION_GRAVITY;
    assert(BattlerMoveWeather(&bs, &ctx, 0) == FIELD_CONDITION_RAIN);
    ctx.ability[0] = ABILITY_MEGA_SOL;
    assert(BattlerMoveWeather(&bs, &ctx, 0) == FIELD_CONDITION_SUN);
    assert(BattlerMoveWeather(&bs, &ctx, BATTLER_NONE) == FIELD_CONDITION_RAIN);
    ctx.cloudNine = TRUE;
    assert(BattlerMoveWeather(&bs, &ctx, 0) == FIELD_CONDITION_SUN);
    assert(BattlerMoveWeather(&bs, &ctx, 1) == 0);
    ctx.cloudNine = FALSE;
    ctx.fieldCondition = 0;
    assert(BattlerMoveWeather(&bs, &ctx, 0) == FIELD_CONDITION_SUN);
    assert(BattlerMoveWeather(&bs, &ctx, 1) == 0);
    puts("PASS: Mega Sol's moves see harsh sunlight, Cloud Nine or not.");"""))

    def test_every_move_of_its_asks(self):
        commands = COMMANDS.read_text()
        self.assertIn("weather = BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker);", function(commands, "DamageCalcDefault"))
        self.assertIn("u32 weather = BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker);",
                      function(commands, "BtlCmd_CalcWeatherBallParams"))
        self.assertIn("u32 weather = BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker);",
                      function(commands, "BtlCmd_WeatherHPRecovery"))
        overlay = OVERLAY.read_text()
        self.assertIn("weather = fieldCondition ? BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker) : 0;",
                      function(overlay, "CalcMoveDamage"))
        self.assertIn("u32 weather = BattlerMoveWeather(battleSystem, ctx, battlerId);", function(overlay, "GetDynamicMoveType"))
        controller = CONTROLLER.read_text()
        self.assertIn("weather = BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker);", function(controller, "BattleSystem_CheckMoveHit"))
        self.assertEqual(function(controller, "BattleSystem_CheckMoveEffect").count("BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker)"), 2)
        self.assertIn("(BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker) & FIELD_CONDITION_SUN_ALL)",
                      function(controller, "ov12_0224B398"))
        # Solar Beam and Solar Blade fire at once; Electro Shot's rain is the
        # field's, as in hg-engine, and Growth is not asked.
        solar = (EFFECTS / "effect_script_0151.s").read_text()
        self.assertLess(solar.index("CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MEGA_SOL, _028"),
                        solar.index("CheckIgnoreWeather"))
        self.assertNotIn("MEGA_SOL", (EFFECTS / "effect_script_0330.s").read_text())


if __name__ == "__main__":
    unittest.main()
