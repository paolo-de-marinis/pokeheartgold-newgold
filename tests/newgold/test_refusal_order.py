#!/usr/bin/env python3
"""When a refusal the ability sweep finds is said, by the step it acts at.

ov12_0224BC2C asks BattleContext_CheckMoveImmunityFromAbility for a refusal
once the accuracy roll, the guards, semi-invulnerability and the type chart
have each left their outcome in moveStatusFlag. The ninth generation runs
those steps in another order (Showdown's gen-9 trySpreadMoveHit:
semi-invulnerability, then TryHit -- Psychic Terrain at priority 4, Protect at
3, the abilities -- then type immunity, the move's own immunities, accuracy,
then the hit), so RefusalSilencedBy says which earlier outcomes silence each
refusal, and a refusal said before the roll clears what came after it. The
real function runs here with the sweep stubbed.
"""

import unittest

from test_ability_interactions import run_c
from test_level_cap import ROOT
from test_repels import function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/moves.h"
#define NARC_a_0_0_1 1
typedef struct { int unused; } BattleSystem;
typedef struct { struct { u8 micleBerryFlag; } unk88; int ability; } BattleMon;
typedef struct { u32 micleSpent : 1; } SelfTurnData;
typedef struct {
    int unk_54, battlerIdAttacker, battlerIdTarget, battlerIdTemp;
    u32 moveStatusFlag, moveNoCur;
    int command, commandNext;
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
static int sScript, sRead;
static int BattleContext_CheckMoveImmunityFromAbility(BattleContext *ctx, int a, int t) { (void)ctx; (void)a; (void)t; return sScript; }
static void ReadBattleScriptFromNarc(BattleContext *ctx, int narc, int script) { (void)ctx; (void)narc; sRead = script; }
static void Battler_GulpMissileCatch(BattleContext *ctx, int b) { (void)ctx; (void)b; }
static int GetBattlerAbility(BattleContext *ctx, int b) { return ctx->battleMons[b].ability; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
// Whether the refusal is said, with these outcomes of the earlier steps.
static BOOL said(int script, int blocker, u32 flags) {
    ctx = (BattleContext){ 0 };
    ctx.battlerIdTarget = 1; ctx.battlerIdTemp = 1; ctx.battleMons[1].ability = blocker;
    ctx.moveStatusFlag = flags; sScript = script; sRead = 0;
    ov12_0224BC2C(&bs, &ctx);
    return sRead == script;
}
int main(void) {
    // Soundproof's script (Soundproof, Bulletproof, Telepathy, Evaporate):
    // silenced by a guard and a target out of reach, said over a miss and a
    // type immunity, which it clears.
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF, ABILITY_SOUNDPROOF, 0));
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF, ABILITY_SOUNDPROOF, MOVE_STATUS_PROTECTED));
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF, ABILITY_SOUNDPROOF, MOVE_STATUS_SEMI_INVULNERABLE));
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF, ABILITY_SOUNDPROOF, MOVE_STATUS_MISSED | MOVE_STATUS_NO_EFFECT));
    assert(!(ctx.moveStatusFlag & (MOVE_STATUS_MISSED | MOVE_STATUS_NO_EFFECT)) && (ctx.moveStatusFlag & MOVE_STATUS_NO_MORE_WORK));
    // The status refusals act at the hit: anything that kept the move from
    // hitting silences them, a miss included, and a miss stays a miss.
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_COMATOSE, 0));
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_COMATOSE, MOVE_STATUS_MISSED));
    assert(ctx.moveStatusFlag == MOVE_STATUS_MISSED);
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_SWEET_VEIL, MOVE_STATUS_PROTECTED));
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_PASTEL_VEIL, MOVE_STATUS_SEMI_INVULNERABLE));
    // Oblivious against Taunt is TryHit's.
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_OBLIVIOUS, MOVE_STATUS_MISSED));
    assert(!said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_OBLIVIOUS, MOVE_STATUS_PROTECTED));
    // Armor Tail, Queenly Majesty and Dazzling turn the move away before it
    // reaches anyone, through everything.
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_ARMOR_TAIL, MOVE_STATUS_PROTECTED | MOVE_STATUS_MISSED));
    assert(!(ctx.moveStatusFlag & (MOVE_STATUS_PROTECTED | MOVE_STATUS_MISSED)));
    assert(said(BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY, ABILITY_DAZZLING, MOVE_STATUS_SEMI_INVULNERABLE));
    // An ability that swallows the move, as before: over a miss and an
    // immunity, not through a guard; the Micle Berry's boost is kept.
    assert(said(BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP, ABILITY_WATER_ABSORB, MOVE_STATUS_MISSED | MOVE_STATUS_MAGNET_RISE_IMMUNE));
    assert(!said(BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP, ABILITY_WATER_ABSORB, MOVE_STATUS_PROTECTED));
    ctx = (BattleContext){ 0 }; ctx.battlerIdTarget = 1; ctx.moveStatusFlag = MOVE_STATUS_MISSED;
    ctx.selfTurnData[0].micleSpent = TRUE; sScript = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_ATTACK;
    ov12_0224BC2C(&bs, &ctx);
    assert(!ctx.selfTurnData[0].micleSpent && ctx.battleMons[0].unk88.micleBerryFlag == 1);
    // The Electric and Misty Terrains' refusals act at the hit.
    assert(!said(BATTLE_SUBSCRIPT_ELECTRIC_TERRAIN_PROTECTION, 0, MOVE_STATUS_MISSED));
    assert(said(BATTLE_SUBSCRIPT_MISTY_TERRAIN_PROTECTION, 0, 0));
    return 0;
}
"""


class RefusalOrderTests(unittest.TestCase):
    def test_each_refusal_is_said_where_its_step_comes(self):
        controller = CONTROLLER.read_text()
        start = controller.index("#define MOVE_STATUS_AFTER_TRY_HIT")
        functions = controller[start:controller.index("\n", start) + 1] + "\n".join(
            function(controller, name) for name in ("ScriptAbsorbsMove", "RefusalSilencedBy", "ov12_0224BC2C"))
        run_c(PROGRAM.replace("@FUNCTIONS@", functions))


if __name__ == "__main__":
    unittest.main()
