#include "constants/species.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// AI script command: a benched party member out-damaging the attacker.

// Jumps if a living party member other than the one the attacker's side has
// out would do more damage to the target with its best move than the attacker
// does with its own. varyDamage is a BOOL, the int ov10_0221EF7C takes: kept
// as a u32 it costs a stack slot of its own and the slots move.
void ov10_0221E2CC(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int j;
    BOOL varyDamage;
    int adrs;
    int battler;
    s32 maxDamage;
    s32 damage;
    s32 damages[MAX_MON_MOVES];
    u16 moves[MAX_MON_MOVES];
    u8 ivs[NUM_STATS];
    Pokemon *mon;

    ov10_0221EF24(ctx, 1);
    varyDamage = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ctx->trainerAIData.battlerIdAttacker;

    for (i = 0; i < NUM_STATS; i++) {
        ivs[i] = GetBattlerVar(ctx, battler, BMON_DATA_HP_IV + i, NULL);
    }

    maxDamage = ov10_0221EF7C(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, ctx->battleMons[battler].moves, damages, ctx->battleMons[battler].item, ivs, GetBattlerAbility(ctx, battler), ctx->battleMons[battler].unk88.embargoFlag, varyDamage);

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battler); i++) {
        if (i != ctx->selectedMonIndex[battler]) {
            mon = BattleSystem_GetPartyMon(battleSystem, battler, i);

            if (GetMonData(mon, MON_DATA_HP, NULL) != 0
                && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
                && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                for (j = 0; j < MAX_MON_MOVES; j++) {
                    moves[j] = GetMonData(mon, MON_DATA_MOVE1 + j, NULL);
                }
                for (j = 0; j < NUM_STATS; j++) {
                    ivs[j] = GetMonData(mon, MON_DATA_HP_IV + j, NULL);
                }

                damage = ov10_0221EF7C(battleSystem, ctx, ctx->trainerAIData.battlerIdAttacker, moves, damages, GetMonData(mon, MON_DATA_HELD_ITEM, NULL), ivs, GetMonData(mon, MON_DATA_ABILITY, NULL), FALSE, varyDamage);
                if (damage > maxDamage) {
                    ov10_0221EF24(ctx, adrs);
                    return;
                }
            }
        }
    }
}
