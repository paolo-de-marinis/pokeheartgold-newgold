#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "error_handling.h"

// AI script commands: calls, jumps and returns, level and taunt checks, whether
// the target is the attacker's partner, Flash Fire and a battler's ability; and
// the script machine under them: reading the script, stepping through it, the
// call stack, the moves the AI has seen the target use, and which battler an
// AI script battler names.

static void AIScript_Call(BattleSystem *battleSystem, BattleContext *ctx, int adrs);
static BOOL AIScript_Return(BattleSystem *battleSystem, BattleContext *ctx);

// Calls the routine at the offset read: comes back here at its end.
void ov10_0221EC08(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    AIScript_Call(battleSystem, ctx, ov10_0221EEF0(ctx));
}

// Jumps to the offset read.
void ov10_0221EC28(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ov10_0221EF24(ctx, ov10_0221EEF0(ctx));
}

// Returns from a routine, or ends the script for this move when none was
// called.
void ov10_0221EC44(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    if (AIScript_Return(battleSystem, ctx) != TRUE) {
        ctx->trainerAIData.unk10 |= 1;
    }
}

// Jumps when the attacker's level is above (0), below (1) or equal to (2) the
// target's.
void ov10_0221EC6C(BattleSystem *battleSystem, BattleContext *ctx) {
    int op;
    int adrs;

    ov10_0221EF24(ctx, 1);
    op = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    switch (op) {
    case 0:
        if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].level > ctx->battleMons[ctx->trainerAIData.battlerIdTarget].level) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case 1:
        if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].level < ctx->battleMons[ctx->trainerAIData.battlerIdTarget].level) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case 2:
        if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].level == ctx->battleMons[ctx->trainerAIData.battlerIdTarget].level) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

// Jumps when the target is taunted.
void ov10_0221ED10(BattleSystem *battleSystem, BattleContext *ctx) {
    int adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);
    if (ctx->battleMons[ctx->trainerAIData.battlerIdTarget].unk88.tauntTurns) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the target is not taunted.
void ov10_0221ED48(BattleSystem *battleSystem, BattleContext *ctx) {
    int adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);
    if (ctx->battleMons[ctx->trainerAIData.battlerIdTarget].unk88.tauntTurns == 0) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the target is on the attacker's side: its partner.
void ov10_0221ED80(BattleSystem *battleSystem, BattleContext *ctx) {
    int adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);
    if ((ctx->trainerAIData.battlerIdAttacker & 1) == (ctx->trainerAIData.battlerIdTarget & 1)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler's Flash Fire has been set off.
void ov10_0221EDB4(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    if (ctx->battleMons[ov10_0221EF34(ctx, battler)].unk88.flashFire) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Loads the battler's ability.
void ov10_0221EDF8(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = GetBattlerAbility(ctx, ov10_0221EF34(ctx, ov10_0221EEF0(ctx)));
}

// Pushes where the script is and jumps to the offset; the stack holds eight.
// The assert calls GF_AssertFail itself, as the retail routine did: GF_ASSERT
// would call the diagnostics build's own assert there and change that build.
static void AIScript_Call(BattleSystem *battleSystem, BattleContext *ctx, int adrs) {
    ctx->trainerAIData.unk78[ctx->trainerAIData.unk98++] = ctx->unk_2138;
    ov10_0221EF24(ctx, adrs);
    if (ctx->trainerAIData.unk98 > 8) {
        GF_AssertFail();
    }
}

// Pops the place a call came from and goes back there: FALSE when nothing
// was called.
static BOOL AIScript_Return(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->trainerAIData.unk98) {
        ctx->trainerAIData.unk98--;
        ctx->unk_2138 = ctx->trainerAIData.unk78[ctx->trainerAIData.unk98];
        return TRUE;
    }
    return FALSE;
}

// Remembers the move the target used last among the ones the AI knows it has,
// in the first free slot, unless it is known already.
void ov10_0221EE88(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (ctx->moveNoBattlerPrev[ctx->trainerAIData.battlerIdTarget] == ctx->trainerAIData.moves[ctx->trainerAIData.battlerIdTarget][i]) {
            break;
        }
        if (ctx->trainerAIData.moves[ctx->trainerAIData.battlerIdTarget][i] == 0) {
            ctx->trainerAIData.moves[ctx->trainerAIData.battlerIdTarget][i] = ctx->moveNoBattlerPrev[ctx->trainerAIData.battlerIdTarget];
            break;
        }
    }
}

// Reads the script's next word and steps past it.
u32 ov10_0221EEF0(BattleContext *ctx) {
    u32 value = ctx->unk_2134[ctx->unk_2138];
    ctx->unk_2138++;
    return value;
}

// Reads the script's word the offset ahead, without stepping.
u32 ov10_0221EF10(BattleContext *ctx, int offset) {
    return ctx->unk_2134[ctx->unk_2138 + offset];
}

// Steps the script the offset on: past an opcode, or a jump.
void ov10_0221EF24(BattleContext *ctx, int offset) {
    ctx->unk_2138 += offset;
}

// The battler an AI script battler names: the target, the attacker, or either's
// partner.
u8 ov10_0221EF34(BattleContext *ctx, u8 battler) {
    switch (battler) {
    case AI_BATTLER_ATTACKER:
        return ctx->trainerAIData.battlerIdAttacker;
    case AI_BATTLER_TARGET:
    default:
        return ctx->trainerAIData.battlerIdTarget;
    case AI_BATTLER_ATTACKER_PARTNER:
        return ctx->trainerAIData.battlerIdAttacker ^ 2;
    case AI_BATTLER_TARGET_PARTNER:
        return ctx->trainerAIData.battlerIdTarget ^ 2;
    }
}
