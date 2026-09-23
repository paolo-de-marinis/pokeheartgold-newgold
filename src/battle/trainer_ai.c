#include "battle/trainer_ai.h"

#include "battle/battle.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"

#include "system.h"

void ov10_0221BE20(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u8 a3) {
    int i;
    u8 struggleFlags;
    u8 *aiData = (u8 *)&ctx->trainerAIData;

    for (i = 0; i < OFFSET_OF(TrainerAIData *, moves); i++) {
        aiData[i] = 0;
    }

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (a3 & 1) {
            ctx->trainerAIData.movePoints[i] = 100;
        } else {
            ctx->trainerAIData.movePoints[i] = 0;
        }
        a3 >>= 1;
    }

    struggleFlags = StruggleCheck(battleSystem, ctx, battlerId, 0, -1);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (struggleFlags & MaskOfFlagNo(i)) {
            ctx->trainerAIData.movePoints[i] = 0;
        }
        ctx->trainerAIData.unk18[i] = 100 - (BattleSystem_Random(battleSystem) % 16);
    }

    ctx->trainerAIData.unk98 = 0;

    if (battleSystem->battleType & BATTLE_TYPE_ROAMER) {
        ctx->trainerAIData.aiFlags = AI_29;
    } else {
        ctx->trainerAIData.aiFlags = battleSystem->trainers[battlerId].data.aiFlags;
    }

    if (battleSystem->battleType & BATTLE_TYPE_DOUBLES) {
        ctx->trainerAIData.aiFlags |= AI_DOUBLES;
    }
}

u8 ov10_0221BEF4(BattleSystem *battleSystem, u8 battlerId) {
    u8 ret;
    BattleContext *ctx = battleSystem->ctx;

    if (!(ctx->trainerAIData.unk10 & 0x10)) {
        ctx->trainerAIData.battlerIdAttacker = battlerId;
        ctx->trainerAIData.battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerId);

        ov10_0221BE20(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, 15);
    }

    if ((battleSystem->battleType & BATTLE_TYPE_DOUBLES) == 0) {
        ret = ov10_0221BF44(battleSystem, ctx);
    } else {
        ret = ov10_0221C038(battleSystem, ctx);
    }

    return ret;
}

u8 ov10_0221BF44(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u8 maxScores[4];
    u8 maxScoreMoveSlots[4];
    u8 numMaxScoreMoves;
    u8 ret;

    ov10_0221EE88(battleSystem, ctx);

    while (ctx->trainerAIData.aiFlags) {
        if (ctx->trainerAIData.aiFlags & 1) {
            if (!(ctx->trainerAIData.unk10 & 0x10)) {
                ctx->trainerAIData.unk0 = 0;
            }
            ov10_0221C278(battleSystem, ctx);
        }
        ctx->trainerAIData.aiFlags >>= 1;
        ctx->trainerAIData.unk11++;
        ctx->trainerAIData.unk1 = 0;
    }

    if (ctx->trainerAIData.unk10 & 2) {
        ret = 4;
    } else if (ctx->trainerAIData.unk10 & 4) {
        ret = 5;
    } else {
        maxScores[0] = ctx->trainerAIData.movePoints[0];
        maxScoreMoveSlots[0] = 0;
        numMaxScoreMoves = 1;
        for (i = 1; i < MAX_MON_MOVES; i++) {
            if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i]) {
                if (maxScores[0] == ctx->trainerAIData.movePoints[i]) {
                    maxScores[numMaxScoreMoves] = ctx->trainerAIData.movePoints[i];
                    maxScoreMoveSlots[numMaxScoreMoves++] = i;
                }
                if (maxScores[0] < ctx->trainerAIData.movePoints[i]) {
                    maxScores[0] = ctx->trainerAIData.movePoints[i];
                    numMaxScoreMoves = 1;
                    maxScoreMoveSlots[0] = i;
                }
            }
        }
        ret = maxScoreMoveSlots[BattleSystem_Random(battleSystem) % numMaxScoreMoves];
    }

    ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker] = ctx->trainerAIData.battlerIdTarget;

    return ret;
}

u8 ov10_0221C038(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int j;
    s16 maxScoreByTarget[BATTLER_MAX];
    u8 maxScoreTargets[BATTLER_MAX];
    s8 moveSlotByTarget[BATTLER_MAX];
    u8 maxScores[4];
    u8 maxScoreMoveSlots[4];
    int numMaxScoreMoves;
    int flags;
    s16 maxScore;
    s8 moveSlot;
    u16 move;

    for (i = 0; i < BATTLER_MAX; i++) {
        if (i == ctx->trainerAIData.battlerIdAttacker || ctx->battleMons[i].hp == 0) {
            moveSlotByTarget[i] = -1;
            maxScoreByTarget[i] = -1;
            continue;
        }

        ov10_0221BE20(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, 15);
        ctx->trainerAIData.battlerIdTarget = i;

        if ((i & 1) != (ctx->trainerAIData.battlerIdAttacker & 1)) {
            ov10_0221EE88(battleSystem, ctx);
        }

        ctx->trainerAIData.unk11 = 0;
        ctx->trainerAIData.unk1 = 0;
        flags = ctx->trainerAIData.aiFlags;

        while (flags) {
            if (flags & 1) {
                if (!(ctx->trainerAIData.unk10 & 0x10)) {
                    ctx->trainerAIData.unk0 = 0;
                }
                ov10_0221C278(battleSystem, ctx);
            }
            flags >>= 1;
            ctx->trainerAIData.unk11++;
            ctx->trainerAIData.unk1 = 0;
        }

        if (ctx->trainerAIData.unk10 & 2) {
            moveSlotByTarget[i] = 4;
        } else if (ctx->trainerAIData.unk10 & 4) {
            moveSlotByTarget[i] = 5;
        } else {
            maxScores[0] = ctx->trainerAIData.movePoints[0];
            maxScoreMoveSlots[0] = 0;
            numMaxScoreMoves = 1;
            for (j = 1; j < MAX_MON_MOVES; j++) {
                if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[j]) {
                    if (maxScores[0] == ctx->trainerAIData.movePoints[j]) {
                        maxScores[numMaxScoreMoves] = ctx->trainerAIData.movePoints[j];
                        maxScoreMoveSlots[numMaxScoreMoves++] = j;
                    }
                    if (maxScores[0] < ctx->trainerAIData.movePoints[j]) {
                        maxScores[0] = ctx->trainerAIData.movePoints[j];
                        maxScoreMoveSlots[0] = j;
                        numMaxScoreMoves = 1;
                    }
                }
            }
            moveSlotByTarget[i] = maxScoreMoveSlots[BattleSystem_Random(battleSystem) % numMaxScoreMoves];
            maxScoreByTarget[i] = maxScores[0];

            if (i == (ctx->trainerAIData.battlerIdAttacker ^ 2) && maxScoreByTarget[i] < 100) {
                maxScoreByTarget[i] = -1;
            }
        }
    }

    maxScore = maxScoreByTarget[0];
    maxScoreTargets[0] = 0;
    numMaxScoreMoves = 1;
    for (i = 1; i < BATTLER_MAX; i++) {
        if (maxScore == maxScoreByTarget[i]) {
            maxScoreTargets[numMaxScoreMoves++] = i;
        }
        if (maxScore < maxScoreByTarget[i]) {
            maxScore = maxScoreByTarget[i];
            maxScoreTargets[0] = i;
            numMaxScoreMoves = 1;
        }
    }

    ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker] = maxScoreTargets[BattleSystem_Random(battleSystem) % numMaxScoreMoves];
    moveSlot = moveSlotByTarget[ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker]];
    move = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[moveSlot];

    if (ctx->trainerAIData.moveData[move].range == RANGE_SINGLE_TARGET_USER_SIDE
        && BattleSystem_GetFieldSide(battleSystem, ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker]) == 0) {
        ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker] = ctx->trainerAIData.battlerIdAttacker;
    }

    if (move == MOVE_CURSE && !CurseUserIsGhost(ctx, move, ctx->trainerAIData.battlerIdAttacker)) {
        ctx->trainerAIData.unkA4[ctx->trainerAIData.battlerIdAttacker] = ctx->trainerAIData.battlerIdAttacker;
    }

    return moveSlot;
}
