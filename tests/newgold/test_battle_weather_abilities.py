#!/usr/bin/env python3
"""The abilities that are a weather of their own.

Mega Sol makes its holder's moves behave as in harsh sunlight. What a move
sees is one question, BattlerMoveWeather (hg-engine's GetWeather), and every
place a move of the holder's reads the weather has to ask it.

Desolate Land, Primordial Sea and Delta Stream raise a strong weather that
lasts while a Pokemon with the ability is out and that nothing but another of
them replaces. The rules are compiled natively; the places are read from the
source.
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
typedef struct { int hp; } BattleMon;
typedef struct { u32 fieldCondition; u16 ability[4]; BOOL cloudNine; BattleMon battleMons[4]; } BattleContext;
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->ability[battlerId]; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 4; }
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
        self.assertIn("weather = BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget);", function(commands, "DamageCalcDefault"))
        self.assertIn("WeatherBallWeather(BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker),",
                      function(commands, "BtlCmd_CalcWeatherBallParams"))
        self.assertIn("u32 weather = BattlerMoveWeatherAt(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker);",
                      function(commands, "BtlCmd_WeatherHPRecovery"))
        overlay = OVERLAY.read_text()
        self.assertIn("weather = fieldCondition ? BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker) : 0;",
                      function(overlay, "CalcMoveDamage"))
        self.assertIn("WeatherBallWeather(BattlerMoveWeather(battleSystem, ctx, battlerId),", function(overlay, "GetDynamicMoveType"))
        controller = CONTROLLER.read_text()
        self.assertIn("weather = BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget);", function(controller, "BattleSystem_CheckMoveHit"))
        effect = function(controller, "BattleSystem_CheckMoveEffect")
        self.assertEqual(effect.count("BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker)"), 1)
        self.assertEqual(effect.count("BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget)"), 1)
        # Solar Beam and Solar Blade fire at once, Mega Sol's sun being the
        # user's move's weather, which no umbrella keeps off
        # (BattlerMoveWeatherAt); Electro Shot's rain is the field's, as in
        # hg-engine, and Growth is not asked.
        self.assertIn("(BattlerMoveWeatherAt(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker) & FIELD_CONDITION_SUN_ALL)",
                      function(controller, "SolarBeamFiresAtOnce"))
        for asker in ("ov12_0224B398", "TryChargeTurn"):
            self.assertIn("SolarBeamFiresAtOnce(battleSystem, ctx)", function(controller, asker))
        self.assertNotIn("MEGA_SOL", (EFFECTS / "effect_script_0330.s").read_text())


SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def subscript(name):
    return next(SUBSCRIPTS.glob(f"subscript_*_{name}.s")).read_text()


class StrongWeatherTests(unittest.TestCase):
    def test_the_weather_lasts_while_its_pokemon_does(self):
        print(run(["PrimalWeatherOf", "BattleContext_PrimalWeatherHasEnded"], r"""
    assert(PrimalWeatherOf(ABILITY_DESOLATE_LAND) == FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT);
    assert(PrimalWeatherOf(ABILITY_PRIMORDIAL_SEA) == FIELD_CONDITION_HEAVY_RAIN);
    assert(PrimalWeatherOf(ABILITY_DELTA_STREAM) == FIELD_CONDITION_STRONG_WINDS);
    assert(PrimalWeatherOf(ABILITY_DROUGHT) == 0);
    // Nothing strong up, nothing to end.
    ctx.fieldCondition = FIELD_CONDITION_RAIN;
    assert(!BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    ctx.fieldCondition = FIELD_CONDITION_HEAVY_RAIN;
    ctx.ability[1] = ABILITY_PRIMORDIAL_SEA;
    ctx.battleMons[1].hp = 1;
    assert(!BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    // Fainted, or its ability gone or suppressed: over, unless another has it.
    ctx.battleMons[1].hp = 0;
    assert(BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    ctx.ability[3] = ABILITY_PRIMORDIAL_SEA;
    ctx.battleMons[3].hp = 5;
    assert(!BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    ctx.ability[3] = ABILITY_NONE;
    assert(BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    // A Groudon does not keep the heavy rain up.
    ctx.ability[3] = ABILITY_DESOLATE_LAND;
    assert(BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    ctx.fieldCondition = FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT;
    assert(!BattleContext_PrimalWeatherHasEnded(&bs, &ctx));
    puts("PASS: a strong weather lasts while a Pokemon with its ability is out.");"""))

    def test_rain_and_sun_include_them_and_the_winds_are_weather(self):
        battle = (ROOT / "include/constants/battle.h").read_text()
        for mask, bit in (("RAIN_ALL", "HEAVY_RAIN"), ("SUN_ALL", "EXTREMELY_HARSH_SUNLIGHT"), ("WEATHER", "STRONG_WINDS")):
            line = next(l for l in battle.splitlines() if l.startswith(f"#define FIELD_CONDITION_{mask} "))
            self.assertIn(f"FIELD_CONDITION_{bit}", line, mask)
        for mask in ("WEATHER_NO_SUN", "WEATHER_CASTFORM"):
            line = next(l for l in battle.splitlines() if l.startswith(f"#define FIELD_CONDITION_{mask} "))
            self.assertNotIn("STRONG_WINDS", line, mask)

    def test_they_come_in_over_any_weather_and_nothing_else_replaces_them(self):
        body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        first = body[body.index("case 0:"):body.index("case 1: // Trace")]
        self.assertLess(first.index("NEUTRALIZING_GAS_END"), first.index("BattleContext_PrimalWeatherHasEnded(battleSystem, ctx)"))
        self.assertLess(first.index("script = BATTLE_SUBSCRIPT_PRIMAL_WEATHER_END;"), first.index("Battler_TeraShiftForm"))
        weather = body[body.index("case 2: // Weather from abilities"):body.index("case 3: // Intimidate")]
        self.assertLess(weather.index("script = BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS;"), weather.index("switch (j) {"))
        self.assertIn("ctx->fieldCondition = (ctx->fieldCondition & ~FIELD_CONDITION_WEATHER) | PrimalWeatherOf(j);", weather)
        self.assertIn("if (!(ctx->fieldCondition & PrimalWeatherOf(j))) {", weather)
        for ability in ("DESOLATE_LAND", "PRIMORDIAL_SEA", "DELTA_STREAM"):
            self.assertIn(f"case ABILITY_{ability}:", weather)
        hit = function(OVERLAY.read_text(), "CheckAbilityEffectOnHit")
        self.assertIn("(ctx->fieldCondition & FIELD_CONDITION_PRIMAL_WEATHER) ? BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS : BATTLE_SUBSCRIPT_SAND_SPIT", hit)
        for number in ("0115", "0136", "0137", "0164", "0324"):
            script = (EFFECTS / f"effect_script_{number}.s").read_text()
            self.assertIn("FIELD_CONDITION_PRIMAL_WEATHER, _PrimalWeather", script, number)
            self.assertIn("Call BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS", script, number)

    def test_the_lines(self):
        for name, rows in (("PrimalWeatherStart", ("01441", "01445", "01449")),
                           ("PrimalWeatherHolds", ("01442", "01446", "01450")),
                           ("PrimalWeatherEnd", ("01444", "01448", "01452")),
                           ("TeraformZero", ("01444", "01448", "01452"))):
            script = subscript(name)
            for row in rows:
                self.assertIn(f"PrintMessage msg_0197_{row}, TAG_NONE", script, name)
        self.assertIn("UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER", subscript("PrimalWeatherEnd"))
        zero = subscript("TeraformZero")
        self.assertLess(zero.index("FIELD_CONDITION_HEAVY_RAIN, _HeavyRain"), zero.index("FIELD_CONDITION_RAIN_ALL, _Rain"))

    def test_no_turns_are_counted_and_the_winds_blow_on(self):
        controller = function(CONTROLLER.read_text(), "BattleControllerPlayer_UpdateFieldCondition")
        self.assertIn("(FIELD_CONDITION_RAIN_PERMANENT | FIELD_CONDITION_HEAVY_RAIN)", controller)
        self.assertIn("(FIELD_CONDITION_SUN_PERMANENT | FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT)", controller)
        winds = controller[controller.index("case UFC_STATE_STRONG_WINDS:"):controller.index("case UFC_STATE_GRAVITY:")]
        self.assertIn("ctx->buffMsg.id = msg_0197_01456;", winds)

    def test_the_winds_leave_weather_ball_and_the_heals_alone(self):
        commands = COMMANDS.read_text()
        self.assertIn("if (weather & FIELD_CONDITION_STRONG_WINDS) {\n        return 0;", function(OVERLAY.read_text(), "WeatherBallWeather"))
        self.assertIn("u32 weather = WeatherBallWeather(", function(commands, "BtlCmd_CalcWeatherBallParams"))
        self.assertIn("if (!weather || (weather & FIELD_CONDITION_STRONG_WINDS)) {", function(commands, "BtlCmd_WeatherHPRecovery"))


class StrongWeatherMoveTests(unittest.TestCase):
    PREFIX = r"""
#include <assert.h>
#include <stdio.h>
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef unsigned int u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
"""

    def test_fire_goes_out_in_the_heavy_rain_and_water_in_the_harsh_sun(self):
        source = CONTROLLER.read_text()
        program = self.PREFIX + function(source, "PrimalWeatherStopsMove") + r"""
int main(void) {
    assert(PrimalWeatherStopsMove(FIELD_CONDITION_HEAVY_RAIN, CATEGORY_SPECIAL, TYPE_FIRE));
    assert(PrimalWeatherStopsMove(FIELD_CONDITION_HEAVY_RAIN, CATEGORY_PHYSICAL, TYPE_FIRE));
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_HEAVY_RAIN, CATEGORY_STATUS, TYPE_FIRE));
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_HEAVY_RAIN, CATEGORY_SPECIAL, TYPE_WATER));
    assert(PrimalWeatherStopsMove(FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT, CATEGORY_SPECIAL, TYPE_WATER));
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT, CATEGORY_SPECIAL, TYPE_FIRE));
    // Ordinary rain and sun, the winds, and nothing -- Cloud Nine -- stop nothing.
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_RAIN, CATEGORY_SPECIAL, TYPE_FIRE));
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_SUN, CATEGORY_SPECIAL, TYPE_WATER));
    assert(!PrimalWeatherStopsMove(FIELD_CONDITION_STRONG_WINDS, CATEGORY_SPECIAL, TYPE_FIRE));
    assert(!PrimalWeatherStopsMove(0, CATEGORY_SPECIAL, TYPE_FIRE));
    puts("PASS: heavy rain puts out Fire, harsh sunlight dries up Water.");
    return 0;
}
"""
        with tempfile.TemporaryDirectory(prefix="newgold-primal-move-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            print(subprocess.run([str(path / "test")], check=True, capture_output=True, text=True).stdout.strip())
        # After the PP is spent, before Protean, with the weather the user's
        # move sees.
        before = function(source, "ov12_0224C38C")
        self.assertLess(before.index("ov12_0224B1FC(battleSystem, ctx)"), before.index("PrimalWeatherStopsMove(BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker)"))
        self.assertLess(before.index("PrimalWeatherStopsMove("), before.index("ABILITY_PROTEAN"))
        self.assertIn("BATTLE_SUBSCRIPT_PRIMAL_WEATHER_STOPS_MOVE", before)
        script = subscript("PrimalWeatherStopsMove")
        self.assertIn("PrintMessage msg_0197_01443, TAG_NONE", script)
        self.assertIn("PrintMessage msg_0197_01447, TAG_NONE", script)


class WeatherAbilityTests(unittest.TestCase):
    """Drizzle, Sand Stream and Drought (Pokemon Central: Piovischio,
    Sabbiafiume, Siccita): five turns, eight with the rock their own Pokemon
    holds, nothing while the weather is up, and not over the map's weather."""

    ABILITIES = (("Drizzle", "DRIZZLE", "RAIN", "RAIN"),
                 ("SandStream", "SAND_STREAM", "SANDSTORM", "SANDSTORM"),
                 ("Drought", "DROUGHT", "SUN", "SUN"))

    def test_the_weather_they_lay_ends(self):
        entry = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        for name, ability, bit, rock in self.ABILITIES:
            script = subscript(name)
            self.assertIn(f"UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_{bit}\n", script, name)
            self.assertIn("UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5", script, name)
            self.assertIn(f"CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, HOLD_EFFECT_EXTEND_{rock}", script, name)
            self.assertLess(script.index("FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _MapWeather"), script.index("PrintMessage"), name)
            self.assertIn("PrintMessage msg_0197_00796, TAG_NONE", script[script.index("\n_MapWeather:"):], name)
            case = entry[entry.index(f"case ABILITY_{ability}:"):]
            self.assertIn(f"(ctx->fieldCondition & FIELD_CONDITION_{bit}_ALL)", case[:case.index("break;")], name)

    def test_sand_spit_reads_the_smooth_rock_of_the_pokemon_hit(self):
        # Pokemon Central (Sputasabbia, Roccialiscia): five turns, eight with
        # the rock the Pokemon with the ability holds -- the one that was hit.
        script = subscript("SandSpit")
        self.assertIn("UpdateVar OPCODE_SET, BSCRIPT_VAR_WEATHER_TURNS, 5", script)
        self.assertIn("CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_DEFENDER, HOLD_EFFECT_EXTEND_SANDSTORM", script)
        self.assertIn("GetItemEffectParam BATTLER_CATEGORY_DEFENDER, BSCRIPT_VAR_CALC_TEMP", script)

    def test_sand_spit_puts_out_a_protosynthesis_the_sun_lit(self):
        # Pokemon Central (Paleosintesi): the boost the sun gave ends with the
        # sun; Sand Stream's subscript and the reference's
        # HANDLE_SANDSTORM_TEMPORARY say so, and Sand Spit's sand ends it too.
        script = subscript("SandSpit")
        self.assertLess(script.index("FIELD_CONDITION_SANDSTORM\n"), script.index("ResetParadoxAbility ABILITY_PROTOSYNTHESIS"))

    def test_snow_warning_and_orichalcum_pulse_leave_the_map_s_weather(self):
        # Pokemon Central (Scendineve, Ritmo d'Oricalco), and the reference's
        # subscripts 252 and 487. Orichalcum Pulse basks in the map's sun.
        # Sand Spit too: from the ninth generation nothing overwrites the
        # map's weather (Terrempesta, Sabbiafiume), and the reference sends it
        # through Sand Stream's refusal.
        for name in ("SnowWarning", "OrichalcumPulse", "SandSpit"):
            script = subscript(name)
            self.assertLess(script.index("FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _MapWeather"), script.index("PrintMessage"), name)
            self.assertIn("PrintMessage msg_0197_00796, TAG_NONE", script[script.index("\n_MapWeather:"):], name)
        pulse = subscript("OrichalcumPulse")
        self.assertLess(pulse.index("FIELD_CONDITION_SUN_ALL, _AlreadySunny"), pulse.index("_MapWeather"))
        spit = subscript("SandSpit")
        self.assertLess(spit.index("_MapWeather"), spit.index("FIELD_CONDITION_SANDSTORM\n"))

    def test_the_weather_moves_leave_the_map_s_weather(self):
        # Pokemon Central (Terrempesta, Pioggiadanza): from the ninth
        # generation a move no longer writes over the weather the map brought;
        # the move fails. Chilly Reception leaves it as it leaves a snow
        # already falling, and its user still goes back. The reference refuses
        # neither.
        for effect in (115, 136, 137, 164):
            script = (EFFECTS / f"effect_script_{effect:04d}.s").read_text()
            self.assertLess(script.index("FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _036"),
                            script.index("UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER"), effect)
            self.assertIn("UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED",
                          script[script.index("\n_036:"):], effect)
        snow = subscript("HandleSnowTemporary")
        self.assertLess(snow.index("FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _035"), snow.index("PrintMessage"))
        chilly = (EFFECTS / "effect_script_0436.s").read_text()
        self.assertLess(chilly.index("FIELD_CONDITION_OVERWORLD_WEATHER_ANY, _SWITCH"),
                        chilly.index("Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY"))

    def test_only_the_map_lays_a_weather_for_good(self):
        setters = sorted(path.name for path in (ROOT / "files/battledata/script").rglob("*.s")
                         if re.search(r"FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_\w+_PERMANENT", path.read_text()))
        self.assertEqual(setters, ["subscript_0271_OverworldRain.s", "subscript_0272_OverworldHail.s",
                                   "subscript_0273_OverworldSand.s", "subscript_0294_OverworldSun.s"])


class UtilityUmbrellaTests(unittest.TestCase):
    """A Utility Umbrella keeps the rain and the sun off its holder (Pokemon
    Central, Superombrello): its own moves and abilities, and what a Fire or
    Water move and Thunder's accuracy do to it. The reference reaches only
    Weather Ball, Hydro Steam and Orichalcum Pulse. The damage's worked
    examples are test_damage_formula's."""

    UMBRELLA = "HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN"

    def test_the_rain_and_the_sun_go_and_nothing_else(self):
        from test_hold_effects import run_c
        run_c(r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/items.h"
typedef uint32_t u32;
typedef struct { int item[4]; } BattleContext;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->item[battlerId]; }
""" + function(OVERLAY.read_text(), "WeatherUnderUmbrella") + r"""
int main(void) {
    BattleContext ctx = { { 0, HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN, 0, 0 } };
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_RAIN, 0) == FIELD_CONDITION_RAIN);
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_RAIN, 1) == 0);
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_HEAVY_RAIN, 1) == 0);
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_SUN_PERMANENT, 1) == 0);
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_SANDSTORM, 1) == FIELD_CONDITION_SANDSTORM);
    assert(WeatherUnderUmbrella(&ctx, FIELD_CONDITION_SNOW_TEMP | FIELD_CONDITION_GRAVITY, 1) == (FIELD_CONDITION_SNOW_TEMP | FIELD_CONDITION_GRAVITY));
    return 0;
}
""")

    def test_mega_sol_s_sun_is_not_held_off(self):
        """A Mega Sol user's move meets the sun at the user and the target,
        umbrella or not: Pokemon Showdown's Pokemon.effectiveWeather answers
        it before it asks for the umbrella; Pokemon Central is silent."""
        from test_hold_effects import run_c
        run_c(r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
typedef uint32_t u32; typedef uint16_t u16;
typedef struct { int unused; } BattleSystem;
typedef struct { int item[4]; int ability[4]; u32 fieldCondition; } BattleContext;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->item[battlerId]; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->ability[battlerId]; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) {
    (void)bs; return ctx->ability[battlerId] == ABILITY_MEGA_SOL ? FIELD_CONDITION_SUN : ctx->fieldCondition;
}
""" + function(OVERLAY.read_text(), "WeatherUnderUmbrella") + function(OVERLAY.read_text(), "BattlerMoveWeatherAt") + r"""
int main(void) {
    BattleSystem bs;
    BattleContext ctx = { { HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN, HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN, 0, 0 }, { 0 }, FIELD_CONDITION_RAIN };
    assert(BattlerMoveWeatherAt(&bs, &ctx, 0, 1) == 0);
    assert(BattlerMoveWeatherAt(&bs, &ctx, 2, 3) == FIELD_CONDITION_RAIN);
    ctx.ability[0] = ABILITY_MEGA_SOL;
    assert(BattlerMoveWeatherAt(&bs, &ctx, 0, 0) == FIELD_CONDITION_SUN);
    assert(BattlerMoveWeatherAt(&bs, &ctx, 0, 1) == FIELD_CONDITION_SUN);
    return 0;
}
""")

    def test_every_place_asks_it(self):
        commands = COMMANDS.read_text()
        self.assertIn("weather = BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget);", function(commands, "DamageCalcDefault"))
        self.assertIn("BattlerMoveWeatherAt(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker)",
                      function(commands, "BtlCmd_WeatherHPRecovery"))
        turn = function(commands, "BtlCmd_EndOfTurnWeatherEffect")
        self.assertIn("u32 weather = WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId);", turn)
        self.assertNotIn("ctx->fieldCondition & FIELD_CONDITION_SUN_ALL", turn)
        self.assertNotIn("ctx->fieldCondition & FIELD_CONDITION_RAIN_ALL", turn)
        controller = CONTROLLER.read_text()
        hit = function(controller, "BattleSystem_CheckMoveEffect")
        self.assertIn("BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget) & FIELD_CONDITION_RAIN_ALL", hit)
        overlay = OVERLAY.read_text()
        calc = function(overlay, "CalcMoveDamage")
        self.assertLess(calc.index(f"if (calcAttacker.item == {self.UMBRELLA})"), calc.index("MOVE_SOLAR_BEAM || moveNo == MOVE_SOLAR_BLADE"))
        self.assertIn(f"weatherOnTarget = calcTarget.item == {self.UMBRELLA}", calc)
        speed = function(overlay, "CheckSortSpeed")
        for battler in ("battlerId1", "battlerId2"):
            self.assertEqual(speed.count(f"WeatherUnderUmbrella(ctx, ctx->fieldCondition, {battler})"), 2, battler)
        self.assertIn("(WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId) & FIELD_CONDITION_SUN_ALL)", function(overlay, "ov12_02253068"))
        forms = function(overlay, "Battler_CheckWeatherFormChange")
        self.assertIn("weather = WeatherUnderUmbrella(ctx, ctx->fieldCondition, ctx->battlerIdTemp);", forms)
        self.assertNotIn("ctx->fieldCondition & FIELD_CONDITION_", forms)

    def test_the_scripts_ask_it(self):
        leaf = 0
        for name in ("FallAsleep", "Poison", "Burn", "Paralyze", "BadPoison", "Rest", "Yawn"):
            lines = subscript(name).splitlines()
            for i, line in enumerate(lines):
                if "FIELD_CONDITION_SUN_ALL" in line and "OPCODE_FLAG_NOT" in line:
                    label = line.rsplit(", ", 1)[1]
                    self.assertRegex(lines[i + 1], rf"CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_\w+, {self.UMBRELLA}, {label}$", name)
                    self.assertIn("ABILITY_LEAF_GUARD", lines[i + 2], name)
                    leaf += 1
        self.assertEqual(leaf, 12)
        freeze = subscript("Freeze")
        self.assertLess(freeze.index(f"{self.UMBRELLA}, _011"), freeze.index("FIELD_CONDITION_SUN_ALL, _095"))
        # Solar Beam's is SolarBeamFiresAtOnce's WeatherUnderUmbrella.
        script = (EFFECTS / "effect_script_0330.s").read_text()
        self.assertLess(script.index(f"BATTLER_CATEGORY_ATTACKER, {self.UMBRELLA}, _006"),
                        script.index("FIELD_CONDITION_RAIN_ALL, _028"))


class StrongWindsTests(unittest.TestCase):
    """The damage is test_damage_formula.py's worked example; this is where
    the chart passes the rows over, and the line."""

    def test_the_chart_passes_the_flying_weakness_over(self):
        chart = function(OVERLAY.read_text(), "CalcTypeEffectiveness")
        self.assertIn("winds = StrongWindsFor(battleSystem, ctx, battlerIdAttacker, moveNo);", chart)
        self.assertEqual(chart.count("ov12_02251C74(ctx, battlerIdAttacker, battlerIdTarget, i) == TRUE && StrongWindsShelterRow(winds, i) == FALSE"), 3)

    def test_they_say_so_once_a_move(self):
        flags = function(CONTROLLER.read_text(), "ov12_0224B498")
        self.assertIn("StrongWindsWeakenMove(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur, ctx->moveType) == TRUE", flags)
        self.assertIn("ctx->strongWindsWeakened |= MaskOfFlagNo(ctx->battlerIdTarget);", flags)
        self.assertIn("ctx->strongWindsWeakened = 0;", function(OVERLAY.read_text(), "BattleContext_Init"))
        self.assertIn("PrintMessage msg_0197_01451, TAG_NONE", subscript("StrongWindsWeaken"))


if __name__ == "__main__":
    unittest.main()
