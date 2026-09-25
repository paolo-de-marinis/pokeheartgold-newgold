#!/usr/bin/env python3
"""A charge move's first turn is the controller's, as the engine asks it before
the move (BattleController_CheckChargeMoves and CheckPowerHerb at d0380a487):
every charge move says "X used Fly!" before its charge line, as Showdown's
gen-9 move line and the engine's charge subscripts do. Solar Beam in harsh
sunlight fires at once; Electro Shot's first turn, rain or not, is its own
script's, which reads the field's rain even for a Mega Sol user; Sky Drop
lifts its target in its own script."""

import re
import unittest

from test_ability_interactions import label_body, run_c
from test_level_cap import ROOT
from test_move_effects import moves, records
from test_repels import function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
SCRIPTS = ROOT / "files/battledata/script"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/move_effects.h"
enum { NARC_a_0_0_1 = 1 };
typedef struct { int unused; } BattleSystem;
typedef struct { int effect; } MoveTbl;
typedef struct { u32 status2; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdAttacker, script;
    u32 battleStatus, weather;
    u16 moveNoCur;
    MoveTbl move;
} BattleContext;
static MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) { (void)move; return &ctx->move; }
static u32 BattlerMoveWeatherAt(BattleSystem *bs, BattleContext *ctx, int battlerIdAttacker, int battlerId) {
    (void)bs; (void)battlerIdAttacker; (void)battlerId;
    return ctx->weather;
}
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int script) { assert(narc == NARC_a_0_0_1); ctx->script = script; }
@FUNCTIONS@
static int charge(int effect, u32 status2, u32 battleStatus, u32 weather) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    ctx.battlerIdAttacker = 1;
    ctx.move.effect = effect;
    ctx.battleMons[1].status2 = status2;
    ctx.battleStatus = battleStatus;
    ctx.weather = weather;
    ctx.script = -1;
    assert(TryChargeTurn(&bs, &ctx) == (ctx.script != -1));
    return ctx.script;
}
int main(void) {
    static const int charges[] = {
        MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT, MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH, MOVE_EFFECT_CHARGE_TURN_DEF_UP,
        MOVE_EFFECT_151, MOVE_EFFECT_FLY, MOVE_EFFECT_DIVE, MOVE_EFFECT_DIG, MOVE_EFFECT_BOUNCE,
        MOVE_EFFECT_SHADOW_FORCE, MOVE_EFFECT_CHARGE_TURN_ATK_SP_ATK_SPEED_UP_2, MOVE_EFFECT_CHARGE_TURN_SP_ATK_UP,
        MOVE_EFFECT_CHARGE_TURN_PARALYZE_HIT, MOVE_EFFECT_CHARGE_TURN_BURN_HIT,
    };
    for (unsigned i = 0; i < NELEMS(charges); i++) {
        assert(charge(charges[i], 0, 0, 0) == BATTLE_SUBSCRIPT_CHARGE_TURN);
        // Not on the second turn, nor for a spread move's later targets.
        assert(charge(charges[i], STATUS2_LOCKED_INTO_MOVE, 0, 0) == -1);
        assert(charge(charges[i], 0, BATTLE_STATUS_CHARGE_MOVE_HIT, 0) == -1);
    }
    // Solar Beam the sun fires at once; Electro Shot's script asks the rain,
    // Sky Drop's lifts its target; Bide is no charge.
    assert(charge(MOVE_EFFECT_151, 0, 0, FIELD_CONDITION_SUN) == -1);
    assert(charge(MOVE_EFFECT_FLY, 0, 0, FIELD_CONDITION_SUN) == BATTLE_SUBSCRIPT_CHARGE_TURN);
    assert(charge(MOVE_EFFECT_CHARGE_TURN_SP_ATK_UP_RAIN_SKIPS, 0, 0, 0) == -1);
    assert(charge(MOVE_EFFECT_SKY_DROP, 0, 0, 0) == -1);
    assert(charge(MOVE_EFFECT_BIDE, 0, 0, 0) == -1);
    return 0;
}
"""

# The charge line each charge effect says, and the mark a user that vanishes
# carries: retail's move scripts' lines, and the engine's charge subscripts'
# for the moves after retail's.
CHARGES = {
    39: ("00211", None), 75: ("00220", None), 145: ("00217", None), 151: ("00214", None),
    155: ("00223", "MOVE_EFFECT_FLAG_FLY"), 255: ("00229", "MOVE_EFFECT_FLAG_DIVE"),
    256: ("00226", "MOVE_EFFECT_FLAG_DIG"), 263: ("00232", "MOVE_EFFECT_FLAG_FLY"),
    272: ("01082", "MOVE_EFFECT_FLAG_PHANTOM_FORCE"), 323: ("01436", None), 329: ("01477", None),
    365: ("01533", None), 366: ("01536", None),
}


def script(kind, pattern):
    return next((SCRIPTS / kind).glob(pattern)).read_text()


def table(source, name):
    start = source.index(f"static const u16 {name}[]")
    return source[start:source.index("};", start) + 2]


def label_run(text, label):
    """A label's lines through its GoTo, or the fall into the next label."""
    lines = text[text.index(f"\n{label}:\n") + len(label) + 3:].splitlines()
    body = []
    for line in lines:
        if line.startswith("_CHARGE:"):
            break
        if not line.startswith("_"):
            body.append(line.strip())
        if line.strip().startswith("GoTo "):
            break
    return body


class ChargeTurnTests(unittest.TestCase):
    def test_the_controller_starts_the_charge(self):
        controller = CONTROLLER.read_text()
        code = (table(controller, "sChargeTurnEffects") + "\n" + function(controller, "SolarBeamFiresAtOnce")
                + "\n" + function(controller, "TryChargeTurn"))
        run_c(PROGRAM.replace("@FUNCTIONS@", code))
        # In place of the move script, which buffered the line and charged.
        self.assertIn("if (TryChargeTurn(battleSystem, ctx) == FALSE) {\n"
                      "            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);", function(controller, "ov12_0224C38C"))

    def test_every_charge_move_says_its_line_and_vanishes(self):
        charge = script("subscript", "subscript_0473_*.s")
        dispatch = charge[charge.index("_000:\n"):charge.index("\n_RAZOR_WIND:")]
        names = {number: name for name, number in moves().items()}
        users = [(number, record[0]) for number, record in enumerate(records()) if record[0] in CHARGES]
        self.assertEqual(len(users), 15)
        for number, effect in users:
            line, mark = CHARGES[effect]
            label = re.search(rf"BSCRIPT_VAR_MOVE_NO_CUR, MOVE_{names[number]}, (_\w+)\n", dispatch).group(1)
            run = label_run(charge, label)
            self.assertIn(f"BufferMessage msg_0197_{line}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", run, names[number])
            marks = [l for l in run if l.startswith("UpdateMonData")]
            self.assertEqual(marks, [f"UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MOVE_EFFECT, {mark}"]
                             if mark else [], names[number])
        self.assertEqual(dispatch.count("CompareVarToValue"), len(users))

    def test_the_charge_turn_says_the_attack_message_first(self):
        charge = script("subscript", "subscript_0473_*.s")
        turn = charge[charge.index("\n_CHARGE:\n"):]
        self.assertEqual(turn.split("_CHARGE:\n")[1].split("\n")[0].strip(), "PrintAttackMessage")
        # Then retail's charge -- subscript 13 as the side effect, the line and
        # the lock -- or the Power Herb and the hit.
        self.assertIn("MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_VANISH_CHARGE_TURN", turn)
        herb = charge[charge.index("\n_POWER_HERB:"):]
        self.assertIn("Call BATTLE_SUBSCRIPT_ITEM_SKIP_CHARGE_TURN", herb)
        self.assertIn("LockMoveChoice BATTLER_CATEGORY_ATTACKER\n    GoToEffectScript", herb)

    def test_the_charges_that_raise_a_stat_raise_it(self):
        # Skull Bash's Defense and Meteor Beam's Sp. Atk.: as the charge's side
        # effect, or with the herb's own subscript. Every move with those
        # effects is named, so one added with the effect is.
        charge = script("subscript", "subscript_0473_*.s")
        names = {number: name for name, number in moves().items()}
        effects = {145: ("_DEFENSE_UP", "_POWER_HERB_DEFENSE_UP"), 329: ("_SP_ATTACK_UP", "_POWER_HERB_SP_ATTACK_UP")}
        users = [(number, record[0]) for number, record in enumerate(records()) if record[0] in effects]
        self.assertEqual(len(users), 2)
        for number, effect in users:
            for label in effects[effect]:
                self.assertIn(f"BSCRIPT_VAR_MOVE_NO_CUR, MOVE_{names[number]}, {label}\n", charge)
        self.assertIn("\n_DEFENSE_UP:\n    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, "
                      "MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_DEFENSE_UP_1_STAGE", charge)
        self.assertIn("\n_SP_ATTACK_UP:\n    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, "
                      "MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE", charge)
        self.assertIn("\n_POWER_HERB_DEFENSE_UP:\n    Call BATTLE_SUBSCRIPT_POWER_HERB_SKULL_BASH", charge)
        self.assertIn("\n_POWER_HERB_SP_ATTACK_UP:\n    Call BATTLE_SUBSCRIPT_POWER_HERB_METEOR_BEAM", charge)

    def test_electro_shot_charges_in_its_own_script(self):
        # Its first turn is its script's, which asks the field's rain -- not
        # a Mega Sol user's sun: Showdown's Pokemon.effectiveWeather leaves
        # Electro Shot alone the field's weather, and the engine's
        # CheckChargeMoves asks GetWeather with no battler -- then says the
        # attack message and its line before charging, herb or not.
        shot = script("effect_script", "effect_script_0330.s")
        self.assertIn("CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_RAIN_ALL, _028", shot)
        first = label_body(shot, "_006")
        self.assertLess(first.index("PrintAttackMessage"), first.index("BufferMessage msg_0197_01480, TAG_NICKNAME"))
        self.assertLess(first.index("BufferMessage msg_0197_01480"), first.index("HOLD_EFFECT_CHARGE_SKIP, _026"))

    def test_solar_beam_in_the_sun_absorbs_light_before_its_hit(self):
        solar = script("effect_script", "effect_script_0151.s")
        unlocked = solar[solar.index("_033\n"):solar.index("\n_033:")]
        self.assertLess(unlocked.index("PrintAttackMessage"), unlocked.index("PrintMessage msg_0197_00214, TAG_NICKNAME"))
        # The hit plays the animation, once.
        self.assertNotIn("    PlayMoveAnimation", solar)
        self.assertNotIn("HOLD_EFFECT_CHARGE_SKIP", solar)
        self.assertNotRegex(script("effect_script", "effect_script_0272_*.s"), r"CHARGE_SKIP|LOCKED_INTO_MOVE")


if __name__ == "__main__":
    unittest.main()
