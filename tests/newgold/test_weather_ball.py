#!/usr/bin/env python3
"""Weather Ball's type, run on the host at every place it is worked out.

GetDynamicMoveType (what Lightning Rod and Storm Drain are asked about) and
the trainer AI's two copies of it take test_fairy_type's stubbed battle, whose
weather is the field's; the stack is dirtied first, so that a type left unset
reads as rubbish rather than as the zero a fresh stack happens to hold.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_fairy_type import AI, ARCEUS
from test_level_cap import ROOT
from test_repels import function

OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
TRAINER_AI = (ROOT / "src/battle/trainer_ai_0221F084.c").read_text()
OPPONENT = (ROOT / "src/battle/overlay_12_02258800.c").read_text()

# Each weather and the type it makes the ball, for all three functions.
CHECKS = r"""
static int poison(void) {
    volatile int junk[256];
    for (int i = 0; i < 256; i++) {
        junk[i] = TYPE_DRAGON;
    }
    return junk[0];
}

int main(void) {
    static BattleContext ctx;
    static const struct { u32 weather; int type; } cases[] = {
        { 0, TYPE_NORMAL },
        { FIELD_CONDITION_FOG, TYPE_NORMAL },
        { FIELD_CONDITION_STRONG_WINDS, TYPE_NORMAL },
        { FIELD_CONDITION_RAIN, TYPE_WATER },
        { FIELD_CONDITION_SUN, TYPE_FIRE },
        { FIELD_CONDITION_SANDSTORM, TYPE_ROCK },
        { FIELD_CONDITION_HAIL, TYPE_ICE },
@SNOW@
    };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        int type;
        ctx.fieldCondition = cases[i].weather;
        poison();
        type = @CALL@;
        if (type != cases[i].type) {
            fprintf(stderr, "weather %#x: type %d, expected %d\n", (unsigned)cases[i].weather, type, cases[i].type);
            return 1;
        }
    }
    return 0;
}
"""


def run(test, prelude, functions, call, snow):
    program = (prelude[:prelude.index("int main(void)")].replace("@FUNCTIONS@", functions)
               + CHECKS.replace("@CALL@", call).replace("@SNOW@", snow))
    with tempfile.TemporaryDirectory(prefix="newgold-weather-ball-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-O0", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-const-variable", "-Wno-unused-variable",
            "-Wno-maybe-uninitialized", "-Wno-uninitialized",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
    test.assertEqual(result.returncode, 0, result.stderr)


# The Drive and Memory lookup every site asks for Techno Blast and Multi-Attack.
def drive_or_memory():
    return (function((ROOT / "src/pokemon.c").read_text(), "GetSilvallyTypeByHeldItemEffect") + "\n"
            + function(OVERLAY, "GetDriveOrMemoryType") + "\n")


# Weather Ball's own two, which the sites share.
def helpers():
    return function(OVERLAY, "WeatherBallWeather") + "\n" + function(OVERLAY, "WeatherBallType") + "\n"


SITES = (
    ("battle", ARCEUS, lambda: drive_or_memory() + helpers() + function(OVERLAY, "GetDynamicMoveType"), "GetDynamicMoveType(0, &ctx, 0, MOVE_WEATHER_BALL)"),
    ("battler, for the AI", AI, lambda: drive_or_memory() + function(TRAINER_AI, "ov10_0221F47C"), "ov10_0221F47C(0, &ctx, 0, MOVE_WEATHER_BALL)"),
    ("party, for the AI", AI, lambda: drive_or_memory() + function(OPPONENT, "ov12_02258BB4"), "ov12_02258BB4(0, &ctx, 0, MOVE_WEATHER_BALL)"),
)


class WeatherBallTypeTests(unittest.TestCase):
    def test_no_weather_that_changes_it_leaves_it_normal(self):
        """Clear skies, fog and the strong winds leave Weather Ball Normal
        (Pokemon Central, Palla Clima); retail returned whatever the stack
        held, which Lightning Rod's redirection then read."""
        for name, prelude, functions, call in SITES:
            with self.subTest(name):
                run(self, prelude, functions(), call, "")

    def test_the_umbrella_keeps_the_rain_and_the_sun_off(self):
        """A Utility Umbrella leaves its holder's Weather Ball Normal in the
        rain and the sun (Pokemon Central, Palla Clima)."""
        name, prelude, functions, call = SITES[0]
        prelude = prelude.replace("int main(void) {", "int main(void) {\n    ctx.battleMons[0].item = HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN;")
        umbrella = CHECKS.replace("{ FIELD_CONDITION_RAIN, TYPE_WATER }", "{ FIELD_CONDITION_RAIN, TYPE_NORMAL }").replace(
            "{ FIELD_CONDITION_SUN, TYPE_FIRE }", "{ FIELD_CONDITION_SUN, TYPE_NORMAL }").replace(
            "    for (unsigned i = 0;", "    ctx.battleMons[0].item = HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN;\n    for (unsigned i = 0;")
        program = (prelude[:prelude.index("int main(void)")].replace("@FUNCTIONS@", functions())
                   + umbrella.replace("@CALL@", call).replace("@SNOW@", ""))
        with tempfile.TemporaryDirectory(prefix="newgold-weather-ball-umbrella-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-O0", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-variable",
                "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_snow_makes_it_ice(self):
        """The ninth generation's snow makes Weather Ball an Ice move, as
        hail did (Pokemon Central, Palla Clima)."""
        for name, prelude, functions, call in SITES:
            with self.subTest(name):
                run(self, prelude, functions(), call, "        { FIELD_CONDITION_SNOW_TEMP, TYPE_ICE },")


# BtlCmd_CalcWeatherBallParams, which sets the move's power and type as it
# is used, with the weather the user's move sees and a 50-power move.
COMMAND = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define FALSE 0
typedef struct BattleSystem BattleSystem;
typedef struct { u32 weather; u32 moveNoCur; int battlerIdAttacker; u16 movePower; int moveType; } BattleContext;
typedef struct { u16 power; } MoveTbl;
static const MoveTbl sWeatherBall = { 50 };
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &sWeatherBall; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; return ctx->weather; }
static int sHoldEffect;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sHoldEffect; }
@FUNCTION@
int main(void) {
    BattleContext ctx = { FIELD_CONDITION_SNOW_TEMP, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 100 && ctx.moveType == TYPE_ICE);
    ctx = (BattleContext){ FIELD_CONDITION_SNOW_PERMANENT, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 100 && ctx.moveType == TYPE_ICE);
    ctx = (BattleContext){ FIELD_CONDITION_HAIL, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 100 && ctx.moveType == TYPE_ICE);
    ctx = (BattleContext){ 0, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 50 && ctx.moveType == TYPE_NORMAL);
    ctx = (BattleContext){ FIELD_CONDITION_STRONG_WINDS, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 50 && ctx.moveType == TYPE_NORMAL);
    // A Utility Umbrella keeps the rain and the sun off its holder's ball
    // (Pokemon Central, Palla Clima), and nothing else.
    sHoldEffect = HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN;
    ctx = (BattleContext){ FIELD_CONDITION_RAIN, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 50 && ctx.moveType == TYPE_NORMAL);
    ctx = (BattleContext){ FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 50 && ctx.moveType == TYPE_NORMAL);
    ctx = (BattleContext){ FIELD_CONDITION_SANDSTORM, 0, 0, 0, TYPE_NORMAL };
    BtlCmd_CalcWeatherBallParams(0, &ctx);
    assert(ctx.movePower == 100 && ctx.moveType == TYPE_ROCK);
    return 0;
}
"""


class WeatherBallCommandTests(unittest.TestCase):
    def test_snow_doubles_it_and_makes_it_ice_and_the_umbrella_keeps_the_rain_off(self):
        program = COMMAND.replace("@FUNCTION@", helpers() + function((ROOT / "src/battle/battle_command.c").read_text(),
                                                                     "BtlCmd_CalcWeatherBallParams"))
        with tempfile.TemporaryDirectory(prefix="newgold-weather-ball-command-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
