#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "party.h"
#include "pokemon.h"

// AI script commands, reached through the command table in the AI's
// read-only data. Each steps past its opcode, reads its arguments and either
// leaves a result in trainerAIData.unk8 or jumps.

void ov10_0221CA9C(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i] != MOVE_NONE
            && BattleMoveTbl(ctx, ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i])->power) {
            break;
        }
    }

    if (i < MAX_MON_MOVES) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CB00(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    adrs = ov10_0221EEF0(ctx);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        if (ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i] != MOVE_NONE
            && BattleMoveTbl(ctx, ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i])->power) {
            break;
        }
    }

    if (i == MAX_MON_MOVES) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CB64(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->totalTurns;
}

void ov10_0221CB80(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);

    switch (ov10_0221EEF0(ctx)) {
    case 1:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_TYPE_1, NULL);
        break;
    case 0:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdTarget, BMON_DATA_TYPE_1, NULL);
        break;
    case 3:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_TYPE_2, NULL);
        break;
    case 2:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdTarget, BMON_DATA_TYPE_2, NULL);
        break;
    case 4:
        ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->type;
        break;
    case 6:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, BattleSystem_GetBattlerIdPartner(battleSystem, ctx->trainerAIData.battlerIdAttacker), BMON_DATA_TYPE_1, NULL);
        break;
    case 5:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, BattleSystem_GetBattlerIdPartner(battleSystem, ctx->trainerAIData.battlerIdTarget), BMON_DATA_TYPE_1, NULL);
        break;
    case 8:
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, BattleSystem_GetBattlerIdPartner(battleSystem, ctx->trainerAIData.battlerIdAttacker), BMON_DATA_TYPE_2, NULL);
        break;
    case 7:
        // Retail asks for the first type here too, where the second is meant.
        ctx->trainerAIData.unk8 = GetBattlerVar(ctx, BattleSystem_GetBattlerIdPartner(battleSystem, ctx->trainerAIData.battlerIdTarget), BMON_DATA_TYPE_1, NULL);
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }
}

void ov10_0221CCB4(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int type;
    int battlerId;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    type = ov10_0221EEF0(ctx);
    battlerId = ov10_0221EF34(ctx, battler);

    if (type == GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) || type == GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL)) {
        ctx->trainerAIData.unk8 = 1;
    } else {
        ctx->trainerAIData.unk8 = 0;
    }
}

void ov10_0221CD10(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->power;
}

void ov10_0221CD34(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int riskyIdx;
    int altPowerIdx;
    u32 varyDamage;
    u8 ivs[NUM_STATS];
    s32 damages[MAX_MON_MOVES];

    ov10_0221EF24(ctx, 1);
    varyDamage = ov10_0221EEF0(ctx);

    riskyIdx = 0;
    do {
        if (BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->effect == ov10_0222B098[riskyIdx]) {
            break;
        }
        riskyIdx++;
    } while (ov10_0222B098[riskyIdx] != 0xFFFF);

    altPowerIdx = 0;
    do {
        if (BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->effect == ov10_0222B080[altPowerIdx]) {
            break;
        }
        altPowerIdx++;
    } while (ov10_0222B080[altPowerIdx] != 0xFFFF);

    if (ov10_0222B080[altPowerIdx] != 0xFFFF || (BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->power > 1 && ov10_0222B098[riskyIdx] == 0xFFFF)) {
        for (i = 0; i < NUM_STATS; i++) {
            ivs[i] = GetBattlerVar(ctx, ctx->trainerAIData.battlerIdAttacker, BMON_DATA_HP_IV + i, NULL);
        }

        ov10_0221EF7C(battleSystem,
            ctx,
            ctx->trainerAIData.battlerIdAttacker,
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves,
            damages,
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].item,
            ivs,
            GetBattlerAbility(ctx, ctx->trainerAIData.battlerIdAttacker),
            ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.embargoFlag,
            varyDamage);

        for (i = 0; i < MAX_MON_MOVES; i++) {
            if (damages[i] > damages[ctx->trainerAIData.unk1]) {
                break;
            }
        }

        if (i == MAX_MON_MOVES) {
            ctx->trainerAIData.unk8 = 2;
        } else {
            ctx->trainerAIData.unk8 = 1;
        }
    } else {
        ctx->trainerAIData.unk8 = 0;
    }
}

void ov10_0221CE70(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    ctx->trainerAIData.unk8 = ctx->moveNoBattlerPrev[ov10_0221EF34(ctx, battler)];
}

void ov10_0221CEA4(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value == ctx->trainerAIData.unk8) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CED4(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value != ctx->trainerAIData.unk8) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CF04(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value == CheckSortSpeed(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, ctx->trainerAIData.battlerIdTarget, 1)) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CF48(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 value;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (value != CheckSortSpeed(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, ctx->trainerAIData.battlerIdTarget, 1)) {
        ov10_0221EF24(ctx, adrs);
    }
}

void ov10_0221CF8C(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int i;
    u8 selectedMon1;
    u8 selectedMon2;
    u8 battlerId;
    Party *party;
    Pokemon *mon;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    ctx->trainerAIData.unk8 = 0;
    battlerId = ov10_0221EF34(ctx, battler);
    party = BattleSystem_GetParty(battleSystem, battlerId);

    if (battleSystem->battleType & BATTLE_TYPE_DOUBLES) {
        selectedMon1 = ctx->selectedMonIndex[battlerId];
        selectedMon2 = ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)];
    } else {
        selectedMon1 = selectedMon2 = ctx->selectedMonIndex[battlerId];
    }

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battlerId); i++) {
        mon = Party_GetMonByIndex(party, i);
        if (i != selectedMon1 && i != selectedMon2
            && GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
            ctx->trainerAIData.unk8++;
        }
    }
}

void ov10_0221D068(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->trainerAIData.unk2;
}

void ov10_0221D084(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = BattleMoveTbl(ctx, ctx->trainerAIData.unk2)->effect;
}
