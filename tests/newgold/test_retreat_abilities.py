#!/usr/bin/env python3
"""Emergency Exit and Wimp Out: a Pokemon a move brings to half its health
leaves when the move is over (Activate_WimpOut_EmergencyExit,
ServerDoPostMoveEffects.c:2629 at d0380a487; Pokemon Central's Passoindietro
and Fuggifuggi)."""

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
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
typedef struct { u32 battleType; BOOL canSwitch[4]; } BattleSystem;
typedef struct { int hp; u32 maxHp; int ability; } Mon;
typedef struct { u32 retreatArmed : 1; u32 sheerForceTraded : 1; } SelfTurnData;
typedef struct {
    Mon battleMons[4];
    SelfTurnData selfTurnData[4];
    int battlerIdAttacker, battlerIdTemp, tempData, moveNoCur;
    int turnOrder[4];
} BattleContext;
static BOOL sheerForceBoost, moldBreaker;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static BOOL IsSuppressibleSecondaryEffect(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return sheerForceBoost; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) {
    (void)attacker;
    return !moldBreaker && ctx->battleMons[target].ability == ability;
}
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->battleType; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 2; }
static BOOL CanSwitchMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)ctx; return bs->canSwitch[battlerId]; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void setup(u32 battleType, int ability, int hp) {
    BattleContext blank = { 0 };
    ctx = blank;
    bs.battleType = battleType;
    bs.canSwitch[0] = bs.canSwitch[1] = TRUE;
    sheerForceBoost = moldBreaker = FALSE;
    ctx.turnOrder[0] = 0;
    ctx.turnOrder[1] = 1;
    ctx.battlerIdAttacker = 0;
    ctx.battleMons[0].hp = ctx.battleMons[0].maxHp = 100;
    ctx.battleMons[1].maxHp = 100;
    ctx.battleMons[1].hp = hp;
    ctx.battleMons[1].ability = ability;
}
static void hit(int battlerId, int damage) {
    Battler_ArmRetreat(&ctx, battlerId);
    ctx.battleMons[battlerId].hp -= damage;
}
static int leaves(void) {
    int script = -1;
    ctx.battlerIdTemp = -1;
    if (!TryRetreatAbility(&bs, &ctx, &script)) {
        return -1;
    }
    assert(script == BATTLE_SUBSCRIPT_EMERGENCY_EXIT);
    assert(ctx.battlerIdTemp == 1);
    return ctx.tempData;
}
int main(void) {
    // Past half by the move: switched out, and only once.
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    hit(1, 20);
    assert(leaves() == 0);
    assert(leaves() == -1);
    setup(BATTLE_TYPE_TRAINER, ABILITY_WIMP_OUT, 60);
    hit(1, 20);
    assert(leaves() == 0);
    // Exactly half counts; already at half does not.
    setup(BATTLE_TYPE_TRAINER, ABILITY_WIMP_OUT, 51);
    hit(1, 1);
    assert(leaves() == 0);
    setup(BATTLE_TYPE_TRAINER, ABILITY_WIMP_OUT, 50);
    hit(1, 20);
    assert(leaves() == -1);
    // A multi-strike move whose last hit did not cross half on its own.
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    hit(1, 12);
    hit(1, 8);
    assert(leaves() == 0);
    // Healed back above half before the move was over.
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    hit(1, 20);
    ctx.battleMons[1].hp = 65;
    assert(leaves() == -1);
    // Fainted, a move Sheer Force boosted, a Mold Breaker, nobody to send.
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    hit(1, 60);
    assert(leaves() == -1);
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    ctx.battleMons[0].ability = ABILITY_SHEER_FORCE;
    sheerForceBoost = TRUE;
    hit(1, 20);
    assert(leaves() == -1);
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    ctx.battleMons[0].ability = ABILITY_SHEER_FORCE;
    hit(1, 20);
    assert(leaves() == 0);
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    moldBreaker = TRUE;
    hit(1, 20);
    assert(leaves() == -1);
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    bs.canSwitch[1] = FALSE;
    hit(1, 20);
    assert(leaves() == -1);
    // Another ability, or the ability lost before the move was over.
    setup(BATTLE_TYPE_TRAINER, ABILITY_BERSERK, 60);
    hit(1, 20);
    assert(leaves() == -1);
    setup(BATTLE_TYPE_TRAINER, ABILITY_EMERGENCY_EXIT, 60);
    hit(1, 20);
    ctx.battleMons[1].ability = ABILITY_MUMMY;
    assert(leaves() == -1);
    // A wild Pokemon flees, with or without a party behind it.
    setup(0, ABILITY_WIMP_OUT, 60);
    bs.canSwitch[1] = FALSE;
    hit(1, 20);
    assert(leaves() == 1);
    return 0;
}
"""


class RetreatTests(unittest.TestCase):
    def test_the_pokemon_leaves_when_a_move_takes_it_to_half(self):
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in (
            "SheerForceTradedEffect", "Battler_ArmRetreat", "Battler_IsWild", "Battler_Retreats", "TryRetreatAbility"))
        with tempfile.TemporaryDirectory(prefix="newgold-retreat-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(FIXTURE.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_every_hit_arms_it_and_the_end_of_the_move_asks(self):
        controller = CONTROLLER.read_text()
        hp_calc = function(controller, "BattleControllerPlayer_HpCalc")
        # After the substitute's branch, before the bar moves.
        self.assertLess(hp_calc.index("BATTLE_SUBSCRIPT_HIT_SUBSTITUTE"), hp_calc.index("Battler_ArmRetreat(ctx, ctx->battlerIdTarget)"))
        self.assertLess(hp_calc.index("Battler_ArmRetreat"), hp_calc.index("BATTLE_SUBSCRIPT_UPDATE_HP"))
        # After the attacker's Throat Spray, the last of its own items.
        end = function(controller, "ov12_0224E1BC")
        self.assertLess(end.index("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE"), end.index("TryRetreatAbility(battleSystem, ctx, &script)"))
        # What comes in by a switch during the move was not hit.
        self.assertIn("ctx->selfTurnData[battlerId].retreatArmed = FALSE;", function(OVERLAY.read_text(), "InitSwitchWork"))

    def test_u_turn_leaves_its_user_in_when_the_target_retreats(self):
        # The switch is the step after the retreat, and a target that has
        # gone back is no longer the Pokemon that was hit.
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        self.assertLess(body.index("TryRetreatAbility(battleSystem, ctx, &script)"), body.index("TryPivotSwitch(ctx)"))
        self.assertIn("Battler_CameInAfterTheHit(ctx, target)", function(CONTROLLER.read_text(), "TryPivotSwitch"))

    def test_the_script_switches_or_flees(self):
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_EMERGENCY_EXIT\s+(\d+)", header).group(1))
        script = (SUBSCRIPTS / f"subscript_{number:04d}_EmergencyExit.s").read_text()
        flee = script.index("\n_FLEE:")
        switch = script[:flee]
        self.assertIn("TryReplaceFaintedMon BATTLER_CATEGORY_MSG_BATTLER_TEMP, TRUE, _END", switch)
        self.assertIn("DeletePokemon BATTLER_CATEGORY_MSG_BATTLER_TEMP", switch)
        self.assertIn("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST", switch)
        self.assertIn("UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_OUTCOME, BATTLE_RESULT_PLAYER_FLED", script[flee:])


if __name__ == "__main__":
    unittest.main()
