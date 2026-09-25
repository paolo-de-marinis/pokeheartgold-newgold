#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// AI script command: a benched party member missing PP.

// Jumps if a party member other than the one the battler's side has out has
// used PP of any of its moves. The jump is an int, as ov10_0221EF24 takes it:
// kept as a u32 it costs a stack slot of its own and the slots move.
void ov10_0221E018(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int j;
    int battlerArg;
    int adrs;
    u8 battler;
    Pokemon *mon;

    ov10_0221EF24(ctx, 1);
    battlerArg = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battlerArg);

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battler); i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battler, i);

        if (i != ctx->selectedMonIndex[battler]) {
            for (j = 0; j < MAX_MON_MOVES; j++) {
                if (GetMonData(mon, MON_DATA_MOVE1_PP + j, NULL) != GetMonData(mon, MON_DATA_MOVE1_MAX_PP + j, NULL)) {
                    ov10_0221EF24(ctx, adrs);
                    break;
                }
            }

            if (j != MAX_MON_MOVES) {
                break;
            }
        }
    }
}
