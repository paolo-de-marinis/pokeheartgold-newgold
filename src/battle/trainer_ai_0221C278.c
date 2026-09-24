#include "battle/battle_system.h"
#include "battle/trainer_ai.h"

// The AI script's runner and its first commands, the comparisons: each
// command steps past its opcode, reads its arguments and, when its test holds,
// jumps the script to the address it was given (ov10_0221EF24).

// Runs the current AI script over each of the attacker's four moves in turn:
// the move under judgement goes in trainerAIData.unk2 (none when it has no PP
// left, which scores it 0), and the script's commands run from the table
// ov10_0222B0B4 until one ends the move (flag 1); flag 8 stops before the
// remaining moves.
void ov10_0221C278(BattleSystem *battleSystem, BattleContext *ctx) {
    while (ctx->trainerAIData.unk0 != 2) {
        switch (ctx->trainerAIData.unk0) {
        case 0:
            ctx->unk_2138 = ctx->unk_2134[ctx->trainerAIData.unk11];
            if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].movePPCur[ctx->trainerAIData.unk1] == 0) {
                ctx->trainerAIData.unk2 = MOVE_NONE;
            } else {
                ctx->trainerAIData.unk2 = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[ctx->trainerAIData.unk1];
            }
            ctx->trainerAIData.unk0++;
            break;
        case 1:
            if (ctx->trainerAIData.unk2 != MOVE_NONE) {
                ov10_0222B0B4[ctx->unk_2134[ctx->unk_2138]](battleSystem, ctx);
            } else {
                ctx->trainerAIData.movePoints[ctx->trainerAIData.unk1] = 0;
                ctx->trainerAIData.unk10 |= 1;
            }
            if (ctx->trainerAIData.unk10 & 1) {
                ctx->trainerAIData.unk1++;
                if (ctx->trainerAIData.unk1 < MAX_MON_MOVES && !(ctx->trainerAIData.unk10 & 8)) {
                    ctx->trainerAIData.unk0 = 0;
                } else {
                    ctx->trainerAIData.unk0++;
                }
                ctx->trainerAIData.unk10 &= 0xFE;
            }
            break;
        case 2:
            break;
        }
    }
}

// Jumps when a random number from 0 to 255 is below the value.
void ov10_0221C384(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (BattleSystem_Random(battleSystem) % 256 < value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when a random number from 0 to 255 is above the value.
void ov10_0221C3C4(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (BattleSystem_Random(battleSystem) % 256 > value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when a random number from 0 to 255 is the value.
void ov10_0221C404(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value == BattleSystem_Random(battleSystem) % 256) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when a random number from 0 to 255 is not the value.
void ov10_0221C444(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value != BattleSystem_Random(battleSystem) % 256) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Adds the value, which may be negative, to the score of the move under
// judgement; a score never goes below 0.
void ov10_0221C484(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);

    ctx->trainerAIData.movePoints[ctx->trainerAIData.unk1] += ov10_0221EEF0(ctx);
    if (ctx->trainerAIData.movePoints[ctx->trainerAIData.unk1] < 0) {
        ctx->trainerAIData.movePoints[ctx->trainerAIData.unk1] = 0;
    }
}

// Jumps when the battler's HP, as a percentage of its maximum, is below the
// value.
void ov10_0221C4B8(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 value;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].hp * 100 / ctx->battleMons[battlerId].maxHp < value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler's HP, as a percentage of its maximum, is above the
// value.
void ov10_0221C510(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 value;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].hp * 100 / ctx->battleMons[battlerId].maxHp > value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler's HP, as a percentage of its maximum, is the value.
void ov10_0221C568(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 value;
    u32 adrs;
    u8 battlerId;
    u32 hpPercent;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);
    hpPercent = ctx->battleMons[battlerId].hp * 100 / ctx->battleMons[battlerId].maxHp;

    if (hpPercent == value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler's HP, as a percentage of its maximum, is not the
// value.
void ov10_0221C5C0(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 value;
    u32 adrs;
    u8 battlerId;
    u32 hpPercent;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);
    hpPercent = ctx->battleMons[battlerId].hp * 100 / ctx->battleMons[battlerId].maxHp;

    if (hpPercent != value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler has any of the given non-volatile status bits
// (sleep, poison, burn, freeze, paralysis).
void ov10_0221C618(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].status & mask) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler has none of the given non-volatile status bits.
void ov10_0221C664(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (!(ctx->battleMons[battlerId].status & mask)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler has any of the given volatile status bits
// (confusion, infatuation, a trap and the like, status2).
void ov10_0221C6B0(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].status2 & mask) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the battler has none of the given volatile status bits.
void ov10_0221C6FC(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (!(ctx->battleMons[battlerId].status2 & mask)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when any of the given move effects is on the battler (Leech Seed,
// Protect, a charging turn and the like, moveEffectFlags).
void ov10_0221C748(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->battleMons[battlerId].moveEffectFlags & mask) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when none of the given move effects is on the battler.
void ov10_0221C790(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (!(ctx->battleMons[battlerId].moveEffectFlags & mask)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when any of the given conditions (screens, Spikes, Tailwind and the
// like) is up on the battler's side of the field.
void ov10_0221C7D8(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] & mask) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when none of the given conditions is up on the battler's side.
void ov10_0221C828(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battler;
    u32 mask;
    u32 adrs;
    u8 battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (!(ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] & mask)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command is below the value.
void ov10_0221C878(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk8 < value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command is above the value.
void ov10_0221C8A8(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk8 > value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command is the value.
void ov10_0221C8D8(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk8 == value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command is not the value.
void ov10_0221C908(BattleSystem *battleSystem, BattleContext *ctx) {
    int value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk8 != value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command has any of the value's bits.
void ov10_0221C938(BattleSystem *battleSystem, BattleContext *ctx) {
    int mask;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk8 & mask) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command has none of the value's bits.
void ov10_0221C968(BattleSystem *battleSystem, BattleContext *ctx) {
    int mask;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    mask = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (!(ctx->trainerAIData.unk8 & mask)) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the move under judgement is the given move.
void ov10_0221C998(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 move;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    move = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk2 == move) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the move under judgement is not the given move.
void ov10_0221C9C8(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 move;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    move = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->trainerAIData.unk2 != move) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps when the result of the last command is in the list at the given
// script address, a list ended by 0xFFFFFFFF.
void ov10_0221C9F8(BattleSystem *battleSystem, BattleContext *ctx) {
    int tableOfs;
    u32 adrs;
    int value;

    ov10_0221EF24(ctx, 1);
    tableOfs = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    while ((value = ov10_0221EF10(ctx, tableOfs)) != -1) {
        if (ctx->trainerAIData.unk8 == value) {
            ov10_0221EF24(ctx, adrs);
            return;
        }
        tableOfs++;
    }
}

// Jumps when the result of the last command is not in the list at the given
// script address, a list ended by 0xFFFFFFFF.
void ov10_0221CA4C(BattleSystem *battleSystem, BattleContext *ctx) {
    int tableOfs;
    u32 adrs;
    int value;

    ov10_0221EF24(ctx, 1);
    tableOfs = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    while ((value = ov10_0221EF10(ctx, tableOfs)) != -1) {
        if (ctx->trainerAIData.unk8 == value) {
            return;
        }
        tableOfs++;
    }
    ov10_0221EF24(ctx, adrs);
}
