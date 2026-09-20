#include "battle/battle_controller.h"
#include "battle/battle_system.h"

typedef struct BattleMonToPartyCommand {
    u8 command;
    u8 partySlot : 4;
    u8 mimicedMoveIndex : 4;
    s16 hp;
    u32 status;
    u32 knockedOffItems;
    u16 item;
    u16 moves[MAX_MON_MOVES];
    u8 movePP[MAX_MON_MOVES];
    u32 status2;
    u16 form;
    u32 ability;
    u16 recalcStats;
    u16 updateForm;
} BattleMonToPartyCommand;

// The opponent controller reads this existing packet, including a word ability.
typedef char BattleMonToPartyCommandSizeCheck[sizeof(BattleMonToPartyCommand) == 0x2C ? 1 : -1];
typedef char BattleMonToPartyCommandAbilityOffsetCheck[offsetof(BattleMonToPartyCommand, ability) == 0x24 ? 1 : -1];
typedef char BattleMonToPartyCommandStatus2OffsetCheck[offsetof(BattleMonToPartyCommand, status2) == 0x1C ? 1 : -1];

void BattleController_EmitBattleMonToPartyMonCopy(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BattleMonToPartyCommand data;
    int i;

    data.command = 39; // Battle-to-party copy entry in the opponent controller table.
    data.partySlot = ctx->selectedMonIndex[battlerId];
    data.mimicedMoveIndex = ctx->battleMons[battlerId].unk88.mimicedMoveIndex;
    data.hp = ctx->battleMons[battlerId].hp;
    data.item = ctx->battleMons[battlerId].item;
    data.knockedOffItems = ctx->fieldSideConditionData[BattleSystem_GetFieldSide(battleSystem, battlerId)].battlerBitKnockedOffItem;
    data.form = ctx->battleMons[battlerId].form;
    data.ability = ctx->battleMons[battlerId].ability;
    for (i = 0; i < MAX_MON_MOVES; i++) {
        data.moves[i] = ctx->battleMons[battlerId].moves[i];
        data.movePP[i] = ctx->battleMons[battlerId].movePPCur[i];
    }
    if (data.hp) {
        data.status = ctx->battleMons[battlerId].status & ~STATUS_POISON_COUNT;
        data.status2 = ctx->battleMons[battlerId].status2;
    } else {
        data.status = 0;
        data.status2 = ctx->battleMons[battlerId].status2;
    }
    if (ctx->battleStatus2 & BATTLE_STATUS2_FORM_CHANGE) {
        data.updateForm = TRUE;
        ctx->battleStatus2 &= ~BATTLE_STATUS2_FORM_CHANGE;
    } else {
        data.updateForm = FALSE;
    }
    if (ctx->battleStatus2 & BATTLE_STATUS2_RECALC_MON_STATS) {
        data.recalcStats = TRUE;
        data.updateForm = TRUE;
        ctx->battleStatus2 &= ~BATTLE_STATUS2_RECALC_MON_STATS;
    } else {
        data.recalcStats = FALSE;
    }
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(data));
}
