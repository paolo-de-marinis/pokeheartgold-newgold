#!/usr/bin/env python3
"""Future Sight and Doom Desire, worked out when they land.

From the fifth generation the two moves take their damage when they hit, not
when they are used (Pokemon Central, Divinazione; the reference's
battle_calc_damage.c:28 at d0380a487): the user's stats, ability and item as
they stand if it is on the field, its party stats and its own types if it has
gone, the target's as they stand, the type chart and a critical hit. The two
questions the landing asks first -- where the user is, and what it is when it
is not there -- run on the host; the rest is checked where it is wired.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

COMMANDS = (ROOT / "src/battle/battle_command.c").read_text()
CONTROLLER = (ROOT / "src/battle/battle_controller_player.c").read_text()
SUBSCRIPT = (ROOT / "files/battledata/script/subscript/subscript_0121_FutureSightDamage.s").read_text()

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int8_t s8; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MI_CpuClear8(p, n) memset(p, 0, n)
typedef struct BattleSystem BattleSystem;
typedef struct { u16 species, atk, def, speed, spAtk, spDef; int hp, maxHp; u8 type1, type2, level, friendship, gender; u32 personality; } Pokemon;
typedef struct {
    u16 species, atk, def, speed, spAtk, spDef;
    s8 statChanges[NUM_BATTLE_STATS];
    u8 type1, type2;
    u32 type3 : 8;
    u8 level, friendship;
    s32 hp;
    u32 maxHp, personality, status, status2;
    u16 item, ability;
    u8 gender : 4;
    u32 moveEffectFlags;
} BattleMon;
typedef struct { BattleMon battleMons[4]; u8 selectedMonIndex[4]; } BattleContext;

// Two parties of six: battlers 0 and 2 share the first, as one trainer's
// double battle does, unless sMulti gives battler 2 the second.
static Pokemon sParties[2][6];
static int sMulti;
static int sMaxBattlers;
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return sMaxBattlers; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int index) {
    (void)bs;
    return &sParties[battlerId == 2 && sMulti][index];
}
static u32 GetMonData(Pokemon *mon, int id, void *data) {
    (void)data;
    switch (id) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_ATK: return mon->atk;
    case MON_DATA_DEF: return mon->def;
    case MON_DATA_SPEED: return mon->speed;
    case MON_DATA_SP_ATK: return mon->spAtk;
    case MON_DATA_SP_DEF: return mon->spDef;
    case MON_DATA_HP: return mon->hp;
    case MON_DATA_MAX_HP: return mon->maxHp;
    case MON_DATA_TYPE_1: return mon->type1;
    case MON_DATA_TYPE_2: return mon->type2;
    case MON_DATA_LEVEL: return mon->level;
    case MON_DATA_FRIENDSHIP: return mon->friendship;
    case MON_DATA_GENDER: return mon->gender;
    case MON_DATA_PERSONALITY: return mon->personality;
    }
    assert(0 && "unexpected attribute");
    return 0;
}
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;
    BattleMon mon;
    int i;

    // Singles: the user in its place, then gone, then fainted in it.
    sMaxBattlers = 2;
    ctx.battleMons[0].hp = 10;
    ctx.selectedMonIndex[0] = 3;
    assert(FutureSightUser(0, &ctx, 0, &sParties[0][3]) == 0);
    ctx.selectedMonIndex[0] = 1;
    assert(FutureSightUser(0, &ctx, 0, &sParties[0][3]) == BATTLER_NONE);
    ctx.selectedMonIndex[0] = 3;
    ctx.battleMons[0].hp = 0;
    assert(FutureSightUser(0, &ctx, 0, &sParties[0][3]) == BATTLER_NONE);

    // Doubles: in its partner's place, which one trainer's party shares and
    // a multi battle's partner does not.
    sMaxBattlers = 4;
    ctx.battleMons[0].hp = 10;
    ctx.selectedMonIndex[0] = 1;
    ctx.battleMons[2].hp = 10;
    ctx.selectedMonIndex[2] = 3;
    assert(FutureSightUser(0, &ctx, 0, &sParties[0][3]) == 2);
    sMulti = 1;
    assert(FutureSightUser(0, &ctx, 0, &sParties[0][3]) == BATTLER_NONE);

    // Gone: the party's stats and types, no stages, no ability, no item,
    // no status, whatever was in the structure before.
    sParties[0][3] = (Pokemon){ SPECIES_SLOWKING, 75, 80, 30, 100, 110, 50, 95, TYPE_WATER, TYPE_PSYCHIC, 36, 70, MON_FEMALE, 1234 };
    memset(&mon, 0xFF, sizeof(mon));
    BattleMon_LoadPartyStats(&mon, &sParties[0][3]);
    assert(mon.species == SPECIES_SLOWKING && mon.atk == 75 && mon.def == 80 && mon.speed == 30 && mon.spAtk == 100 && mon.spDef == 110);
    assert(mon.hp == 50 && mon.maxHp == 95 && mon.level == 36 && mon.friendship == 70 && mon.gender == MON_FEMALE && mon.personality == 1234);
    assert(mon.type1 == TYPE_WATER && mon.type2 == TYPE_PSYCHIC && mon.type3 == TYPE_NONE);
    for (i = 0; i < NUM_BATTLE_STATS; i++) {
        assert(mon.statChanges[i] == 6);
    }
    assert(mon.ability == 0 && mon.item == 0 && mon.status == 0 && mon.status2 == 0 && mon.moveEffectFlags == 0);
    return 0;
}
"""


class FutureSightTests(unittest.TestCase):
    def test_where_the_user_is_and_what_it_is_when_gone(self):
        functions = "\n".join(function(COMMANDS, name) for name in ("FutureSightUser", "BattleMon_LoadPartyStats"))
        with tempfile.TemporaryDirectory(prefix="newgold-future-sight-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(PROGRAM.replace("@FUNCTIONS@", functions))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_use_keeps_the_user_and_works_nothing_out(self):
        body = function(COMMANDS, "BtlCmd_TryFutureSight")
        self.assertNotIn("CalcMoveDamage", body)
        self.assertIn("ctx->fieldConditionData.futureSightMonIndex[ctx->battlerIdTarget] = ctx->selectedMonIndex[ctx->battlerIdAttacker];", body)

    def test_the_landing_works_it_out(self):
        body = function(COMMANDS, "BattleContext_LandFutureSight")
        # The user as it stands, or its party self in its place for the
        # length of the sum and no longer.
        self.assertLess(body.index("BattleMon_LoadPartyStats(&ctx->battleMons[ctx->battlerIdAttacker], user);"),
                        body.index("DamageCalcDefault(battleSystem, ctx, TRUE);"))
        self.assertLess(body.index("DamageCalcDefault(battleSystem, ctx, TRUE);"),
                        body.index("ctx->battleMons[ctx->battlerIdAttacker] = onField;"))
        self.assertLess(body.index("ctx->criticalMultiplier = TryCriticalHit("), body.index("DamageCalcDefault("))
        self.assertIn("ov12_02251D28(battleSystem, ctx, ctx->moveNoCur, ctx->moveType, ctx->battlerIdAttacker, battlerIdTarget, ctx->damage, &ctx->moveStatusFlag);", body)
        self.assertIn("ctx->hpCalc = -ctx->damage;", body)
        # Whether it hits is asked of the same attacker.
        self.assertLess(body.index("BattleSystem_CheckMoveHitEffect(battleSystem, ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->moveNoCur);"),
                        body.index("ctx->battleMons[ctx->battlerIdAttacker] = onField;"))
        landing = CONTROLLER[CONTROLLER.index("case UFCE_STATE_FUTURE_SIGHT:"):CONTROLLER.index("case UFCE_STATE_PERISH_SONG:")]
        self.assertIn("BattleContext_LandFutureSight(battleSystem, ctx, battlerId);", landing)
        self.assertNotIn("futureSightDamage", landing)

    def test_the_hit_answers_to_the_chart(self):
        """A Dark type takes no Future Sight, Wonder Guard stops one that is
        not super effective, and the hit says how well it landed and whether
        it was critical."""
        self.assertLess(SUBSCRIPT.index("MOVE_STATUS_NO_EFFECT, _NoEffect"), SUBSCRIPT.index("MOVE_STATUS_DID_NOT_HIT, _117"))
        self.assertLess(SUBSCRIPT.index("MOVE_STATUS_WONDER_GUARD_IMMUNE, _WonderGuard"), SUBSCRIPT.index("MOVE_STATUS_DID_NOT_HIT, _117"))
        self.assertNotIn("CheckMoveHit", SUBSCRIPT)
        self.assertIn("PrintMessage msg_0197_00027, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP", SUBSCRIPT)
        self.assertIn("PrintMessage msg_0197_00018, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP", SUBSCRIPT)
        self.assertEqual(SUBSCRIPT.count("Call BATTLE_SUBSCRIPT_CRITICAL_HIT"), 2)
        self.assertEqual(SUBSCRIPT.count("Call BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE"), 2)

    def test_a_disguise_or_a_tera_shell_answers_the_landing(self):
        """Pokemon Central (Fantasmanto): a Disguise takes any damaging move
        but through a substitute, and breaks; (Teraguscio) the shell says so
        before the hit. Asked while the user still stands in for itself."""
        body = function(COMMANDS, "BattleContext_LandFutureSight")
        answer = body[body.index("ctx->tempData = 0;"):]
        self.assertLess(body.index("ctx->tempData = 0;"), body.index("ctx->battleMons[ctx->battlerIdAttacker] = onField;"))
        self.assertIn("if (form != SPECIES_NONE && !(ctx->battleMons[battlerIdTarget].status2 & STATUS2_SUBSTITUTE)) {", answer)
        self.assertIn("BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerIdTarget, form, TRUE);\n"
                      "            ctx->tempData = BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE;", answer)
        self.assertIn("} else if (TeraShellResists(ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->moveNoCur) == TRUE) {\n"
                      "            ctx->tempData = BATTLE_SUBSCRIPT_TERA_SHELL;", answer)
        # The script breaks the face instead of the damage, or says the
        # shell's line before it.
        self.assertLess(SUBSCRIPT.index("BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE, _Disguise"), SUBSCRIPT.index("_Strike:"))
        self.assertLess(SUBSCRIPT.index("Call BATTLE_SUBSCRIPT_TERA_SHELL"), SUBSCRIPT.index("_Strike:"))
        self.assertIn("_Disguise:\n    Call BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE\n    End", SUBSCRIPT)


if __name__ == "__main__":
    unittest.main()
