#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "party.h"
#include "pokemon.h"

// AI script commands: how effective the attacker's moves are on the target,
// whether a benched party member has a status, and the weather.

// The immunities that leave a move doing nothing at all.
#define AI_MOVE_STATUS_IMMUNE (MOVE_STATUS_NO_EFFECT | MOVE_STATUS_LEVITATE_IMMUNE | MOVE_STATUS_WONDER_GUARD_IMMUNE | MOVE_STATUS_MAGNET_RISE_IMMUNE)

// Loads the best effectiveness of the attacker's four moves on the target, as
// what a damage of 40 becomes: 160, 80, 40, 20, 10, or 0 for no effect. STAB
// is taken back out of the four scaled values, not out of a neutral hit (60).
void ov10_0221D260(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u32 effectiveness;
    int type;
    u16 move;
    u32 moveStatusFlag;

    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = 0;

    for (i = 0; i < MAX_MON_MOVES; i++) {
        moveStatusFlag = 0;
        move = ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].moves[i];
        type = ov10_0221F47C(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, move);

        if (move) {
            effectiveness = ov12_02251D28(battleSystem, ctx, move, type, ctx->trainerAIData.battlerIdAttacker, ctx->trainerAIData.battlerIdTarget, 40, &moveStatusFlag);

            if (effectiveness == 120) {
                effectiveness = 80;
            } else if (effectiveness == 240) {
                effectiveness = 160;
            } else if (effectiveness == 30) {
                effectiveness = 20;
            } else if (effectiveness == 15) {
                effectiveness = 10;
            }

            if (moveStatusFlag & AI_MOVE_STATUS_IMMUNE) {
                effectiveness = 0;
            }

            if (ctx->trainerAIData.unk8 < effectiveness) {
                ctx->trainerAIData.unk8 = effectiveness;
            }
        }
    }
}

// Jumps if the current move's effectiveness on the target, on the scale of
// the command above, is the one given.
void ov10_0221D314(BattleSystem *battleSystem, BattleContext *ctx) {
    int effectiveness;
    int type;
    u8 attacker;
    u32 value;
    u32 adrs;
    u32 moveStatusFlag;

    ov10_0221EF24(ctx, 1);
    value = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    moveStatusFlag = 0;

    attacker = ctx->trainerAIData.battlerIdAttacker;
    type = ov10_0221F47C(battleSystem, ctx, attacker, ctx->trainerAIData.unk2);
    effectiveness = ov12_02251D28(battleSystem, ctx, ctx->trainerAIData.unk2, type, attacker, ctx->trainerAIData.battlerIdTarget, 40, &moveStatusFlag);

    if (effectiveness == 120) {
        effectiveness = 80;
    } else if (effectiveness == 240) {
        effectiveness = 160;
    } else if (effectiveness == 30) {
        effectiveness = 20;
    } else if (effectiveness == 15) {
        effectiveness = 10;
    }

    if (moveStatusFlag & AI_MOVE_STATUS_IMMUNE) {
        effectiveness = 0;
    }

    if (effectiveness == value) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps if a party member of the battler's side that is not in battle, still
// standing and not an Egg, has any of the given status conditions.
void ov10_0221D3AC(BattleSystem *battleSystem, BattleContext *ctx) {
    Party *party;
    Pokemon *mon;
    int i;
    int battler;
    u8 slot1;
    u8 slot2;
    u32 status;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    status = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    if (battleSystem->battleType & BATTLE_TYPE_DOUBLES) {
        slot1 = ctx->selectedMonIndex[battler];
        slot2 = ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battler)];
    } else {
        slot1 = slot2 = ctx->selectedMonIndex[battler];
    }

    party = BattleSystem_GetParty(battleSystem, battler);

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battler); i++) {
        mon = Party_GetMonByIndex(party, i);

        if (i != slot1 && i != slot2
            && GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && (GetMonData(mon, MON_DATA_STATUS, NULL) & status)) {
            ov10_0221EF24(ctx, adrs);
            return;
        }
    }
}

// Jumps if a party member of the battler's side that is not in battle, still
// standing and not an Egg, has none of the given status conditions.
void ov10_0221D4A0(BattleSystem *battleSystem, BattleContext *ctx) {
    Party *party;
    Pokemon *mon;
    int i;
    int battler;
    u8 slot1;
    u8 slot2;
    u32 status;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    status = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    if (battleSystem->battleType & BATTLE_TYPE_DOUBLES) {
        slot1 = ctx->selectedMonIndex[battler];
        slot2 = ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battler)];
    } else {
        slot1 = slot2 = ctx->selectedMonIndex[battler];
    }

    party = BattleSystem_GetParty(battleSystem, battler);

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battler); i++) {
        mon = Party_GetMonByIndex(party, i);

        if (i != slot1 && i != slot2
            && GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && !(GetMonData(mon, MON_DATA_STATUS, NULL) & status)) {
            ov10_0221EF24(ctx, adrs);
            return;
        }
    }
}

// Loads the weather: 0 none, 1 sun, 2 rain, 3 sandstorm, 4 hail, 5 fog.
void ov10_0221D594(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = 0;

    if (ctx->fieldCondition & (FIELD_CONDITION_RAIN | FIELD_CONDITION_RAIN_PERMANENT)) {
        ctx->trainerAIData.unk8 = 2;
    }
    if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) {
        ctx->trainerAIData.unk8 = 3;
    }
    if (ctx->fieldCondition & (FIELD_CONDITION_SUN | FIELD_CONDITION_SUN_PERMANENT)) {
        ctx->trainerAIData.unk8 = 1;
    }
    if (ctx->fieldCondition & FIELD_CONDITION_HAIL_ALL) {
        ctx->trainerAIData.unk8 = 4;
    }
    if (ctx->fieldCondition & FIELD_CONDITION_FOG) {
        ctx->trainerAIData.unk8 = 5;
    }
}
