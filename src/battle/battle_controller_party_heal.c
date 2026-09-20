#include "battle/battle_controller.h"

typedef struct PartyStatusHealCommand {
    u8 command;
    u8 ability;
    u16 move;
} PartyStatusHealCommand;

// The remaining controller assembly reads the ability byte and move halfword.
typedef char PartyStatusHealCommandSizeCheck[sizeof(PartyStatusHealCommand) == 4 ? 1 : -1];
typedef char PartyStatusHealCommandAbilityOffsetCheck[offsetof(PartyStatusHealCommand, ability) == 1 ? 1 : -1];
typedef char PartyStatusHealCommandMoveOffsetCheck[offsetof(PartyStatusHealCommand, move) == 2 ? 1 : -1];

void BattleControl_EmitPartyStatusHeal(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    PartyStatusHealCommand data;

    data.command = 42; // Party-status-heal entry in the opponent controller table.
    data.move = (u16)moveNo;
    data.ability = (u8)ctx->battleMons[battlerId].ability;
    ov12_02262240(battleSystem, 1, battlerId, &data, sizeof(data));
}
