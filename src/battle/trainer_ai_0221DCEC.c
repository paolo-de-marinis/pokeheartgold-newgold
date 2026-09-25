#include "constants/items.h"

#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "battle/trainer_ai.h"

#include "pokemon.h"

// AI script commands: Disable and Encore, fleeing, held items, the field's
// conditions and the party's missing HP.

// Jumps if the battler is under Disable (0) or Encore (1).
void ov10_0221DCEC(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    u32 kind;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    kind = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    switch (kind) {
    case 0:
        if (ctx->battleMons[battler].unk88.disabledTurns) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case 1:
        if (ctx->battleMons[battler].unk88.encoredTurns) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

// Jumps if the current move is the attacker's disabled move (0) or its
// encored move (1).
void ov10_0221DD5C(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 kind;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    kind = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    switch (kind) {
    case 0:
        if (ctx->trainerAIData.unk2 == ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.disabledMove) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    case 1:
        if (ctx->trainerAIData.unk2 == ctx->battleMons[ctx->trainerAIData.battlerIdAttacker].unk88.encoredMove) {
            ov10_0221EF24(ctx, adrs);
        }
        break;
    }
}

// Stops the scripts and has the attacker flee instead of choosing a move.
void ov10_0221DDCC(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk10 |= 0xB;
}

// Does nothing, and does not even step past its opcode.
void ov10_0221DDE8(BattleSystem *battleSystem, BattleContext *ctx) {
}

// Does nothing, and does not even step past its opcode.
void ov10_0221DDEC(BattleSystem *battleSystem, BattleContext *ctx) {
}

// Loads the battler's held item.
void ov10_0221DDF0(BattleSystem *battleSystem, BattleContext *ctx) {
    ov10_0221EF24(ctx, 1);
    ctx->trainerAIData.unk8 = ctx->battleMons[ov10_0221EF34(ctx, ov10_0221EEF0(ctx))].item;
}

// Loads the hold effect of the battler's item: the attacker's own, or for
// any other battler the item the AI has seen it hold.
void ov10_0221DE24(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 battler;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EF34(ctx, ov10_0221EEF0(ctx));

    if (ctx->trainerAIData.battlerIdAttacker != battler) {
        ctx->trainerAIData.unk8 = GetItemVar(ctx, ctx->trainerAIData.heldItems[battler], ITEMATTR_HOLD_EFFECT);
    } else {
        ctx->trainerAIData.unk8 = GetItemVar(ctx, ctx->battleMons[battler].item, ITEMATTR_HOLD_EFFECT);
    }
}

// Jumps if the battler holds the given item: for a battler on the attacker's
// side its real item, for a foe the item the AI has seen it hold.
void ov10_0221DE88(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    u16 heldItem;
    u32 item;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    item = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    if ((battler & 1) == (ctx->trainerAIData.battlerIdAttacker & 1)) {
        heldItem = ctx->battleMons[battler].item;
    } else {
        heldItem = ctx->trainerAIData.heldItems[battler];
    }

    if (heldItem == item) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Jumps if any of the given field conditions is in effect.
void ov10_0221DEF0(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 condition;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    condition = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);

    if (ctx->fieldCondition & condition) {
        ov10_0221EF24(ctx, adrs);
    }
}

// Loads the layers of Spikes or Toxic Spikes on the battler's side.
void ov10_0221DF20(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    u32 condition;
    u8 side;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    condition = ov10_0221EEF0(ctx);
    side = BattleSystem_GetFieldSide(battleSystem, ov10_0221EF34(ctx, battler));

    switch (condition) {
    case SIDE_CONDITION_SPIKES:
        ctx->trainerAIData.unk8 = ctx->fieldSideConditionData[side].spikesLayers;
        break;
    case SIDE_CONDITION_TOXIC_SPIKES:
        ctx->trainerAIData.unk8 = ctx->fieldSideConditionData[side].toxicSpikesLayers;
        break;
    }
}

// Jumps if a party member of the battler's that is not in battle is missing
// some of its HP.
void ov10_0221DF88(BattleSystem *battleSystem, BattleContext *ctx) {
    Pokemon *mon;
    int i;
    int battler;
    u32 adrs;

    ov10_0221EF24(ctx, 1);
    battler = ov10_0221EEF0(ctx);
    adrs = ov10_0221EEF0(ctx);
    battler = ov10_0221EF34(ctx, battler);

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battler); i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battler, i);

        if (i != ctx->selectedMonIndex[battler]
            && GetMonData(mon, MON_DATA_HP, NULL) != GetMonData(mon, MON_DATA_MAX_HP, NULL)) {
            ov10_0221EF24(ctx, adrs);
            return;
        }
    }
}
