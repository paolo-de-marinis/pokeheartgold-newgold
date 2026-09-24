#include "battle/battle_controller_player.h"

#include "global.h"

#include "constants/abilities.h"
#include "constants/battle_menu.h"
#include "constants/battle_script_imports.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/message_tags.h"
#include "constants/move_effects.h"

#include "battle/battle_022378C0.h"
#include "battle/battle_command.h"
#include "battle/battle_controller.h"
#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "msgdata/msg/msg_0197.h"

#include "heap.h"
#include "screen_fade.h"
#include "sound.h"
#include "unk_02035900.h"

static void BattleControllerPlayer_GetBattleMon(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_StartEncounter(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_TrainerMessage(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_PokemonAppear(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SelectionScreenInit(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SelectionScreenInput(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_CalcExecutionOrder(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_BeforeTurn(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_02249460(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_UpdateFieldCondition(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_UpdateMonCondition(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_UpdateFieldConditionExtra(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_TurnEnd(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_FightInput(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_ItemInput(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_PokemonInput(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_RunInput(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SafariThrowBall(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SafariThrowMud(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SafariRun(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_SafariWatching(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_CatchingContestThrowBall(BattleSystem *battleSystem, BattleContext *ctx);
static u32 TryDisobedience(BattleSystem *battleSystem, BattleContext *ctx, int *script);
static BOOL ov12_0224B1FC(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224B398(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224B498(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224B528(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224BC2C(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224BCA4(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL BattleSystem_CheckMoveHit(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int move);
static BOOL BattleSystem_CheckMoveEffect(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int move);
static BOOL ov12_0224C204(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_RunScript(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224C38C(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224C4D8(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224C5C8(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224C5F8(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224C678(BattleSystem *battleSystem, BattleContext *ctx);
static void BattleControllerPlayer_HpCalc(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224CAA4(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224CC84(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224CC88(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224CF10(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224CF14(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D014(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D03C(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D1DC(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D224(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D238(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D23C(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D368(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D448(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D464(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D4F0(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D504(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224D53C(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224D540(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224D7EC(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224DB64(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u32 battleType, int *out, int movePos, u32 *a6);
static void ov12_0224DC0C(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL TryFaintMon(BattleContext *ctx, ControllerCommand a1, ControllerCommand a2, int a3);
static BOOL ov12_0224DD18(BattleContext *ctx, ControllerCommand a1, ControllerCommand a2);
static void ov12_0224DD74(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224DF7C(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224DF98(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL TryBuildRage(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL TryItemFlinch(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224E130(BattleSystem *battleSystem, BattleContext *ctx);
static BOOL ov12_0224E1BC(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224E384(BattleSystem *battleSystem, BattleContext *ctx);
static void ov12_0224E414(BattleSystem *battleSystem, BattleContext *ctx);

static const ControllerFunction sPlayerBattleCommands[CONTROLLER_COMMAND_MAX] = {
    [CONTROLLER_COMMAND_GET_BATTLE_MON] = BattleControllerPlayer_GetBattleMon,
    [CONTROLLER_COMMAND_START_ENCOUNTER] = BattleControllerPlayer_StartEncounter,
    [CONTROLLER_COMMAND_TRAINER_MESSAGE] = BattleControllerPlayer_TrainerMessage,
    [CONTROLLER_COMMAND_SEND_OUT] = BattleControllerPlayer_PokemonAppear,
    [CONTROLLER_COMMAND_SELECTION_SCREEN_INIT] = BattleControllerPlayer_SelectionScreenInit,
    [CONTROLLER_COMMAND_SELECTION_SCREEN_INPUT] = BattleControllerPlayer_SelectionScreenInput,
    [CONTROLLER_COMMAND_CALC_EXECUTION_ORDER] = BattleControllerPlayer_CalcExecutionOrder,
    [CONTROLLER_COMMAND_BEFORE_TURN] = BattleControllerPlayer_BeforeTurn,
    [CONTROLLER_COMMAND_8] = ov12_02249460,
    [CONTROLLER_COMMAND_UPDATE_FIELD_CONDITION] = BattleControllerPlayer_UpdateFieldCondition,
    [CONTROLLER_COMMAND_UPDATE_MON_CONDITION] = BattleControllerPlayer_UpdateMonCondition,
    [CONTROLLER_COMMAND_UPDATE_FIELD_CONDITION_EXTRA] = BattleControllerPlayer_UpdateFieldConditionExtra,
    [CONTROLLER_COMMAND_TURN_END] = BattleControllerPlayer_TurnEnd,
    [CONTROLLER_COMMAND_FIGHT_INPUT] = BattleControllerPlayer_FightInput,
    [CONTROLLER_COMMAND_ITEM_INPUT] = BattleControllerPlayer_ItemInput,
    [CONTROLLER_COMMAND_POKEMON_INPUT] = BattleControllerPlayer_PokemonInput,
    [CONTROLLER_COMMAND_RUN_INPUT] = BattleControllerPlayer_RunInput,
    [CONTROLLER_COMMAND_SAFARI_THROW_BALL] = BattleControllerPlayer_SafariThrowBall,
    [CONTROLLER_COMMAND_SAFARI_THROW_MUD] = BattleControllerPlayer_SafariThrowMud,
    [CONTROLLER_COMMAND_SAFARI_RUN] = BattleControllerPlayer_SafariRun,
    [CONTROLLER_COMMAND_SAFARI_WATCHING] = BattleControllerPlayer_SafariWatching,
    [CONTROLLER_COMMAND_CATCHING_CONSTEST_THROW_BALL] = BattleControllerPlayer_CatchingContestThrowBall,
    [CONTROLLER_COMMAND_RUN_SCRIPT] = BattleControllerPlayer_RunScript,
    [CONTROLLER_COMMAND_23] = ov12_0224C38C,
    [CONTROLLER_COMMAND_24] = ov12_0224C4D8,
    [CONTROLLER_COMMAND_25] = ov12_0224C5C8,
    [CONTROLLER_COMMAND_26] = ov12_0224C5F8,
    [CONTROLLER_COMMAND_27] = ov12_0224C678,
    [CONTROLLER_COMMAND_HP_CALC] = BattleControllerPlayer_HpCalc,
    [CONTROLLER_COMMAND_29] = ov12_0224CAA4,
    [CONTROLLER_COMMAND_30] = ov12_0224CC84,
    [CONTROLLER_COMMAND_31] = ov12_0224CC88,
    [CONTROLLER_COMMAND_32] = ov12_0224CF14,
    [CONTROLLER_COMMAND_33] = ov12_0224CF10,
    [CONTROLLER_COMMAND_34] = ov12_0224D014,
    [CONTROLLER_COMMAND_35] = ov12_0224D03C,
    [CONTROLLER_COMMAND_36] = ov12_0224D1DC,
    [CONTROLLER_COMMAND_37] = ov12_0224D224,
    [CONTROLLER_COMMAND_38] = ov12_0224D238,
    [CONTROLLER_COMMAND_39] = ov12_0224D23C,
    [CONTROLLER_COMMAND_40] = ov12_0224D368,
    [CONTROLLER_COMMAND_41] = ov12_0224D448,
    [CONTROLLER_COMMAND_42] = ov12_0224D464,
    [CONTROLLER_COMMAND_43] = ov12_0224D4F0,
    [CONTROLLER_COMMAND_44] = ov12_0224D504,
    [CONTROLLER_COMMAND_45] = ov12_0224D53C
};

// Ability expansion preserves the original battle-record and context prefixes.
typedef char BattleMonSizeCheck[sizeof(BattleMon) == 0xC0 ? 1 : -1];
typedef char BattleMonAbilityOffsetCheck[offsetof(BattleMon, ability) == 0x7A ? 1 : -1];
typedef char BattleMonPPOffsetCheck[offsetof(BattleMon, movePPCur) == 0x2C ? 1 : -1];
typedef char BattleMonItemOffsetCheck[offsetof(BattleMon, item) == 0x78 ? 1 : -1];
typedef char BattleMonEffectOffsetCheck[offsetof(BattleMon, moveEffectFlags) == 0x80 ? 1 : -1];
typedef char TrainerAIHeldItemsOffsetCheck[offsetof(TrainerAIData, heldItems) == 0x40 ? 1 : -1];
typedef char TrainerAIMoveDataOffsetCheck[offsetof(TrainerAIData, moveData) == 0x8A ? 1 : -1];
typedef char BattleContextMonsOffsetCheck[offsetof(BattleContext, battleMons) == 0x2D40 ? 1 : -1];
typedef char BattleContextAbilityCacheOffsetCheck[offsetof(BattleContext, trainerAIAbilities) == 0x3158 ? 1 : -1];
// The size is pinned so that growth is deliberate rather than noticed in a
// battle. Only the offsets matter to the assembly that still reads this
// structure, and everything it reads is below what has been appended. The
// added moves' records are the one part meant to grow -- importing more moves
// makes that table longer and moves nothing else -- so they are written out
// here rather than folded into the number. The number is not the sum of what
// has been appended: six bytes of terrain state grew it by four, because two
// of them went into padding the structure already carried. The four after
// those, for the Paradox abilities, grew it by four, and the twenty-four for
// Belch's eaten-a-Berry flags grew it by twenty-four. The four after those,
// for whose Paradox ability a Booster Energy switched on, grew it by four.
// The byte for which battlers saw hail or snow, for Ice Face, and the one
// for Relic Song, grew it by four; Cud Chew's Berry and turn by sixteen more,
// each battler's run of Protects by four, and Dancer's six bytes by four, two
// of them padding it carried already; Tera Shell's byte by four, since
// Dancer's had taken the padding it would have used, and the one for Delta
// Stream's line went into what Tera Shell's left; Supreme Overlord's count of
// the fallen by four, and Mimicry's terrain by four and Opportunist's stages
// by thirty-two and Symbiosis's marks by four. Ball Fetch's two-byte ball went
// into padding and grew it by nothing; the Gem's byte by four, the Eject
// Pack's byte into what the Gem's left, and the Mirror Herb's stages by
// thirty-two. The once-per-battle entry abilities, remembered by party rather
// than by side, grew it by twelve. The byte for which battlers had a stat
// raised, for Parting Shot, and the Binding Band's byte both went into the
// padding after the Mirror Herb's stages. What Parental Bond's first strike
// leaves to the second grew it by four. Echoed Voice's two bytes, after
// Parental Bond's four, grew it by four. Round's byte went into the padding
// after them. The two moves used last this turn, for Fusion Flare and Fusion
// Bolt, grew it by four. The Rooms' two bytes grew it by four. Rage Fist's
// count by party, two of its bytes in the padding the Rooms' left, grew it by
// twenty-four. Octolock's bit took each battler's move conditions to a second
// byte, four in all. Dragon Cheer's two took them to a third, four more. Fairy
// Lock's byte went into the padding after Rage Fist's count, and so did the
// byte that says the held items are back. The byte for the player's Pokemon
// another has taken an item from grew it by four, and the items taken from the
// wild ones by four more. Sky Drop's holder took the move conditions to a
// fourth byte, four more.
typedef char BattleContextSizeCheck[
    sizeof(BattleContext) == 0x326C + NUM_ADDED_MOVES * sizeof(MoveTbl) + BATTLE_SCRIPT_BUFFER_WORDS * 4 ? 1 : -1];

// A Focus Sash or a herb used in battle is gone for the rest of it, but not
// for good: what the party was holding is written down at the start and given
// back at the end. Berries are the exception — those are eaten.
//
// Written down from the first controller command, not from BattleContext_New:
// the battle system builds its context before it has copied the parties in, so
// at that point BattleSystem_GetPartySize reads a party pointer that is still
// NULL. On hardware, and in a melonDS that raises data aborts, that is a black
// screen with the music still playing; the libretro core the harness runs on
// reads address 4 as zero and carried on, which is how it went unnoticed.
static void RememberHeldItems(BattleSystem *battleSystem, BattleContext *ctx) {
    int count = BattleSystem_GetPartySize(battleSystem, BATTLER_PLAYER);

    for (int i = 0; i < count && i < PARTY_SIZE; i++) {
        ctx->itemsToRestore[i] = GetMonData(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i), MON_DATA_HELD_ITEM, NULL);
    }
}

// As the reference's RESTORE_ITEMS_AT_BATTLE_END: outside a trainer battle,
// any item the party holds more of than it started with was taken in battle
// and goes to the bag; then every Pokemon gets back what it started with,
// nothing included, unless that was a berry it ate.
//
// Once a battle: a battle won does it before Pickup and Honey Gather look for
// empty hands (BtlCmd_GenerateEndOfBattleItem), so what they find is the
// Pokemon's to hold (Pokemon Central, Raccolta), and every battle's end asks
// again. The reference does it at the end only, after them, and so writes
// over what they found: nothing after a trainer battle, the bag after a wild
// one.
void GiveBackHeldItems(BattleSystem *battleSystem, BattleContext *ctx) {
    int count = BattleSystem_GetPartySize(battleSystem, BATTLER_PLAYER);
    u16 held[PARTY_SIZE];
    int i, j;

    if (ctx->heldItemsGivenBack) {
        return;
    }
    ctx->heldItemsGivenBack = TRUE;
    if (count > PARTY_SIZE) {
        count = PARTY_SIZE;
    }
    for (i = 0; i < count; i++) {
        held[i] = GetMonData(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i), MON_DATA_HELD_ITEM, NULL);
    }

    if (!(BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_TRAINER | BATTLE_TYPE_NO_EXP))) {
        for (i = 0; i < count; i++) {
            int now = 0;
            int before = 0;

            if (held[i] == ITEM_NONE) {
                continue;
            }
            // Counted once, at its first holder. The reference meant this
            // too, but its `continue` leaves only the inner loop, so a second
            // holder of the same item adds it to the bag again.
            for (j = 0; j < i; j++) {
                if (held[j] == held[i]) {
                    break;
                }
            }
            if (j < i) {
                continue;
            }
            for (j = 0; j < count; j++) {
                now += held[j] == held[i];
                before += ctx->itemsToRestore[j] == held[i];
            }
            // What was taken from a wild Pokemon that was then caught is back
            // with it, and not the bag's (Pokemon Central, Arraffalesto; the
            // catch has left only its entry).
            if (BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_OUTCOME_MON_CAUGHT) {
                before += (ctx->itemsTakenFromWild[0] == held[i]) + (ctx->itemsTakenFromWild[1] == held[i]);
            }
            if (now > before) {
                Bag_AddItem(BattleSystem_GetBag(battleSystem), held[i], now - before, HEAP_ID_BATTLE);
            }
        }
    }

    // A Berry the Pokemon no longer holds was eaten, unless another took it
    // (NoteHeldItemTaken): then it comes back as anything taken does. One that
    // ate its Berry and took an item after ends with nothing, the item going
    // back to the trainer it came from, or into the bag above. The reference
    // leaves such a Pokemon holding whatever it has, so an item taken from a
    // trainer stayed taken, one taken from a wild Pokemon went to the bag and
    // stayed held too, and a Berry a foe's Magician took was lost.
    for (i = 0; i < count; i++) {
        u16 item = ctx->itemsToRestore[i];
        if (BattleItemIsBerry(item) && held[i] != item && !(ctx->heldItemsTaken & MaskOfFlagNo(i))) {
            item = ITEM_NONE;
        }
        SetMonData(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i), MON_DATA_HELD_ITEM, &item);
    }
}

// A wild Pokemon caught with an item one of the player's handed it (Trick,
// Switcheroo) or lost to it (Magician, Pickpocket) keeps it, and nobody gets a
// copy (Pokemon Central, Raggiro: from the ninth generation). The player's
// Pokemon keeps what it holds now, what the swap gave it: a swap with a wild
// Pokemon lasts (Rapidscambio). Asked at the catch, once the caught Pokemon
// has had back what was taken from it (Task_GetPokemon).
void CaughtMonKeepsItem(BattleSystem *battleSystem, BattleContext *ctx, Pokemon *mon) {
    u16 item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);

    for (int i = 0; item != ITEM_NONE && i < PARTY_SIZE; i++) {
        if ((ctx->heldItemsTaken & MaskOfFlagNo(i)) && ctx->itemsToRestore[i] == item) {
            ctx->itemsToRestore[i] = GetMonData(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i), MON_DATA_HELD_ITEM, NULL);
            return;
        }
    }
}

// A bad poisoning does not outlast the battle: the player's Pokemon leave it
// ordinarily poisoned, as hg-engine's RevertFormChange leaves them.
static void EaseBadPoison(BattleSystem *battleSystem) {
    int count = BattleSystem_GetPartySize(battleSystem, BATTLER_PLAYER);

    for (int i = 0; i < count && i < PARTY_SIZE; i++) {
        Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i);
        u32 status = GetMonData(mon, MON_DATA_STATUS, NULL);
        if (status & STATUS_BAD_POISON) {
            status = (status & ~STATUS_BAD_POISON) | STATUS_POISON;
            SetMonData(mon, MON_DATA_STATUS, &status);
        }
    }
}

// The rest of hg-engine's end-of-battle RevertFormChange: a form that lasts
// only as long as the battle goes back to the one it came from.
static void RevertBattleForms(BattleSystem *battleSystem) {
    int count = BattleSystem_GetPartySize(battleSystem, BATTLER_PLAYER);

    for (int i = 0; i < count && i < PARTY_SIZE; i++) {
        Mon_RevertFormChange(BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i));
    }
}

BattleContext *BattleContext_New(BattleSystem *battleSystem) {
    BattleContext *ctx = (BattleContext *)Heap_Alloc(HEAP_ID_BATTLE, sizeof(BattleContext));
    MI_CpuClearFast((u32 *)ctx, sizeof(BattleContext));

    BattleContext_Init(ctx);
    ov12_02251038(battleSystem, ctx);
    ov12_0224E384(battleSystem, ctx);
    LoadMoveTbl(ctx->trainerAIData.moveData);
    LoadAddedMoveTbl(ctx->addedMoveData);
    ctx->trainerAIData.itemData = LoadAllItemData(HEAP_ID_BATTLE);

    return ctx;
}

#ifdef NEWGOLD_DIAG
// The battlers, copied where a memory reader can find them without knowing
// the battle context's layout.
static void Diag_BattleView(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId, i;
    Party *party = BattleSystem_GetParty(battleSystem, BATTLER_PLAYER);
    int count = Party_GetCount(party);

    for (i = 0; i < 6; i++) {
        Pokemon *mon = i < count ? BattleSystem_GetPartyMon(battleSystem, BATTLER_PLAYER, i) : NULL;
        gDiagPartySpecies[i] = mon ? GetMonData(mon, MON_DATA_SPECIES, NULL) : 0;
        gDiagPartyHp[i] = mon ? GetMonData(mon, MON_DATA_HP, NULL) : 0;
    }

    for (battlerId = 0; battlerId < 4; battlerId++) {
        BattleMon *mon = &ctx->battleMons[battlerId];
        DiagBattler *view = &gDiagBattlers[battlerId];
        view->species = mon->species;
        view->hp = mon->hp;
        view->maxHp = mon->maxHp;
        view->level = mon->level;
        view->partySlot = ctx->selectedMonIndex[battlerId];
        view->status = mon->status;
        view->item = mon->item;
        for (i = 0; i < 4; i++) {
            view->moves[i] = mon->moves[i];
            view->pp[i] = mon->movePPCur[i];
        }
    }
    gDiagBattleCommand = ctx->command;
    gDiagBattleScript[0] = ctx->scriptNarcId;
    gDiagBattleScript[1] = ctx->scriptFileId;
    gDiagBattleScript[2] = ctx->scriptSeqNo;
    gDiagBattlePrompt = ctx->unk_0[BATTLER_PLAYER];
}
#endif

BOOL BattleContext_Main(BattleSystem *battleSystem, BattleContext *ctx) {
#ifdef NEWGOLD_DIAG
    Diag_BattleView(battleSystem, ctx);
#endif
    if (!ctx->battleEndFlag) {
        if (BattleSystem_GetBattleOutcomeFlags(battleSystem) && !(BattleSystem_GetBattleOutcomeFlags(battleSystem) & 0x40)) {
            ctx->command = CONTROLLER_COMMAND_42;
        }
    }

    sPlayerBattleCommands[ctx->command](battleSystem, ctx);
    if (ctx->command == CONTROLLER_COMMAND_45) {
        GiveBackHeldItems(battleSystem, ctx);
        EaseBadPoison(battleSystem);
        RevertBattleForms(battleSystem);
        return TRUE;
    }
    return FALSE;
}

void BattleContext_Delete(BattleContext *ctx) {
    Heap_Free(ctx->trainerAIData.itemData);
    Heap_Free(ctx);
}

void BattleSystem_CheckMoveHitEffect(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int moveNo) {
    BattleSystem_CheckMoveHit(battleSystem, ctx, battlerIdAttacker, battlerIdTarget, moveNo);
    BattleSystem_CheckMoveEffect(battleSystem, ctx, battlerIdAttacker, battlerIdTarget, moveNo);
}

static void BattleControllerPlayer_GetBattleMon(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    RememberHeldItems(battleSystem, ctx);
    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        BattleSystem_GetBattleMon(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);
    }

    ctx->hpTemp = ctx->battleMons[1].hp;
    ctx->command = CONTROLLER_COMMAND_START_ENCOUNTER;
}

static void BattleControllerPlayer_StartEncounter(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_START_ENCOUNTER);
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_TRAINER_MESSAGE;
}

static void BattleControllerPlayer_TrainerMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    if (CheckTrainerMessage(battleSystem, ctx)) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TRAINER_MESSAGE);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_SEND_OUT;
    } else {
        ctx->command = CONTROLLER_COMMAND_SEND_OUT;
    }

    SortMonsBySpeed(battleSystem, ctx);
}

static void BattleControllerPlayer_PokemonAppear(BattleSystem *battleSystem, BattleContext *ctx) {
    int script = TryAbilityOnEntry(battleSystem, ctx);

    if (script) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    } else {
        SortMonsBySpeed(battleSystem, ctx);
        ov12_0223C0C4(battleSystem);
        ctx->command = CONTROLLER_COMMAND_SELECTION_SCREEN_INIT;
    }
}

static void BattleControllerPlayer_SelectionScreenInit(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        ctx->unk_0[battlerId] = 0;
        ctx->battleMons[battlerId].moveEffectFlagsTemp = ctx->battleMons[battlerId].moveEffectFlags;
        ctx->unk_314C[battlerId] = 0;
        // A turn starts here, after the entry abilities of the Pokemon sent
        // out for it: what they lowered was lowered before it.
        ctx->moveConditions[battlerId].statLoweredThisTurn = FALSE;
    }

    ov12_0223BB64(battleSystem, 0);
    ov12_02237ED0(battleSystem, 1);

    ctx->command = CONTROLLER_COMMAND_SELECTION_SCREEN_INPUT;
}

typedef enum BattleSelectState {
    SSI_STATE_SELECT_COMMAND_INIT,
    SSI_STATE_1,
    SSI_STATE_2,
    SSI_STATE_3,
    SSI_STATE_4,
    SSI_STATE_5,
    SSI_STATE_6,
    SSI_STATE_7,
    SSI_STATE_8,
    SSI_STATE_9,
    SSI_STATE_10,
    SSI_STATE_11,
    SSI_STATE_12,
    SSI_STATE_13,
    SSI_STATE_14,
    SSI_STATE_15,
    SSI_STATE_NO_MOVES,
    SSI_STATE_END
} BattleSelectState;

static void BattleControllerPlayer_SelectionScreenInput(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax;
    int var;
    s32 battleType;
    BattleMessage msg;

    battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    battleType = BattleSystem_GetBattleType(battleSystem);

    var = 0;

    for (battlerId = 0; battlerId < battlersMax; battlerId++) {
        switch (ctx->unk_0[battlerId]) {
        case SSI_STATE_SELECT_COMMAND_INIT:
            if ((battleType & BATTLE_TYPE_DOUBLES) && !(battleType & BATTLE_TYPE_MULTI) && ((battlerId == BATTLER_PLAYER2) && (ctx->unk_0[0] != SSI_STATE_14) || (battlerId == BATTLER_ENEMY2) && (ctx->unk_0[1] != SSI_STATE_14))) {
                break;
            }
            // A Tatsugiri in its Dondozo's mouth chooses nothing, as one
            // switching in does not (Pokemon Central, Torre di Comando).
            if ((ctx->switchInFlag & MaskOfFlagNo(battlerId)) || ctx->moveConditions[battlerId].commanding) {
                ctx->unk_0[battlerId] = SSI_STATE_13;
                ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_40;
                break;
            } else if (Battler_CanSelectAction(ctx, battlerId) == 0) {
                ctx->turnData[battlerId].unk0_1 = 1;
                ctx->unk_0[battlerId] = SSI_STATE_13;
                ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_FIGHT_INPUT;
                break;
            }

            if ((ov12_02261264(BattleSystem_GetOpponentData(battleSystem, battlerId)) == 1) || (ctx->totalTurns)) {
                ov12_02262B80(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);
                ctx->unk_0[battlerId] = SSI_STATE_1;
            } else {
                ctx->unk_0[battlerId] = SSI_STATE_2;
            }
            break;
        case SSI_STATE_2: {
            int battlerIdCheck;

            for (battlerIdCheck = 0; battlerIdCheck < battlersMax; battlerIdCheck++) {
                if (battlerIdCheck == battlerId) {
                    continue;
                }

                if (ov12_02261264(BattleSystem_GetOpponentData(battleSystem, battlerIdCheck)) != 0x1) {
                    continue;
                }

                if (ctx->unk_0[battlerIdCheck] != SSI_STATE_14) {
                    break;
                }
            }

            if (battlerIdCheck == battlersMax) {
                ov12_02262B80(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);
                ctx->unk_0[battlerId] = SSI_STATE_1;
            } else {
                break;
            }
        }
        // fallthrough
        case SSI_STATE_1:
            if (BattleBuffer_GetNext(ctx, battlerId)) {
                ctx->playerActions[battlerId].inputSelection = ctx->battleBuffer[battlerId][0];

                if (battleType & BATTLE_TYPE_PAL_PARK) {
                    switch (BattleBuffer_GetNext(ctx, battlerId)) {
                    case 1:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_SAFARI_THROW_BALL;
                        break;
                    case 4:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_RUN_INPUT;
                        break;
                    }
                } else if (battleType & BATTLE_TYPE_SAFARI) {
                    switch (BattleBuffer_GetNext(ctx, battlerId)) {
                    case 1:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_SAFARI_THROW_BALL;
                        break;
                    case 2:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_SAFARI_THROW_MUD;
                        break;
                    case 3:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_SAFARI_RUN;
                        break;
                    case 4:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_4[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_RUN_INPUT;
                        break;
                    case 5:
                        ctx->unk_0[battlerId] = SSI_STATE_END;
                        ctx->unk_0[battlerId] = SSI_STATE_13;
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_SAFARI_WATCHING;
                        break;
                    }
                } else {
                    if (BattleBuffer_GetNext(ctx, battlerId) != 0xff) {
                        ctx->unk_314C[battlerId] |= 0x1;
                    }

                    switch (BattleBuffer_GetNext(ctx, battlerId)) {
                    case BATTLE_INPUT_FIGHT:
                        if (StruggleCheck(battleSystem, ctx, battlerId, 0, 0xffffffff) == 15) {
                            ctx->turnData[battlerId].struggleFlag = 1;

                            if (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) {
                                ctx->unk_0[battlerId] = SSI_STATE_13;
                            } else {
                                ctx->unk_0[battlerId] = SSI_STATE_END;
                                ctx->unk_4[battlerId] = SSI_STATE_NO_MOVES;
                            }
                        } else if (ctx->battleMons[battlerId].unk88.encoredMove) {
                            ctx->movePos[battlerId] = ctx->battleMons[battlerId].unk88.encoredMoveIndex;
                            ctx->unk_30B4[battlerId] = ctx->battleMons[battlerId].unk88.encoredMove;
                            ctx->playerActions[battlerId].unk8 = 0;

                            if (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) {
                                ctx->unk_0[battlerId] = SSI_STATE_13;
                            } else {
                                ctx->unk_0[battlerId] = SSI_STATE_END;
                                ctx->unk_4[battlerId] = SSI_STATE_13;
                            }
                        } else {
                            ctx->unk_0[battlerId] = SSI_STATE_3;
                        }

                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_FIGHT_INPUT;
                        break;
                    case BATTLE_INPUT_BAG:
                        if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_BUG_CONTEST) {
                            ctx->unk_0[battlerId] = SSI_STATE_END;
                            ctx->unk_4[battlerId] = SSI_STATE_13;
                            ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_CATCHING_CONSTEST_THROW_BALL;
                        } else if (BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_LINK | BATTLE_TYPE_FRONTIER)) {
                            msg.id = msg_0197_00593; // Items can't be used here
                            msg.tag = TAG_NONE;
                            ov12_022639B8(battleSystem, battlerId, msg);
                            ctx->unk_0[battlerId] = SSI_STATE_15;
                            ctx->unk_4[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
                        } else {
                            ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_ITEM_INPUT;
                            ctx->unk_0[battlerId] = 7;
                        }
                        break;
                    case BATTLE_INPUT_POKEMON:
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_POKEMON_INPUT;
                        ctx->unk_0[battlerId] = SSI_STATE_9;
                        break;
                    case BATTLE_INPUT_RUN:
                        ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_RUN_INPUT;
                        ctx->unk_0[battlerId] = SSI_STATE_11;
                        break;
                    case BATTLE_INPUT_CANCEL:
                        if (battleType & BATTLE_TYPE_LINK) {
                            ov12_02263CCC(battleSystem, battlerId);
                            ctx->unk_0[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
                            ctx->unk_0[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)] = 0;
                        } else if ((battleType & BATTLE_TYPE_DOUBLES) && (battlerId == BATTLER_PLAYER2)) {
                            ov12_02263CCC(battleSystem, battlerId);
                            ctx->unk_0[0] = SSI_STATE_SELECT_COMMAND_INIT;
                            ctx->unk_0[2] = SSI_STATE_SELECT_COMMAND_INIT;
                        }
                        break;
                    }
                }
            }
            break;
        case SSI_STATE_3:
            ov12_02262F40(battleSystem, ctx, battlerId);
            ctx->unk_0[battlerId] = SSI_STATE_4;
            // fallthrough
        case SSI_STATE_4:
            if (BattleBuffer_GetNext(ctx, battlerId) == 0xff) {
                ctx->unk_0[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
            } else if (BattleBuffer_GetNext(ctx, battlerId)) {
                if ((ctx->battleBuffer[battlerId][0] - 1) == BATTLE_INPUT_RUN) {
                    ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_RUN_INPUT;
                    ctx->unk_0[battlerId] = SSI_STATE_11;
                    break;
                } else if (ov12_02251A28(battleSystem, ctx, battlerId, ctx->battleBuffer[battlerId][0] - 1, &msg) == 0) {
                    if (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) {
                        ov12_0223BFFC(battleSystem, 1);
                        BattleController_TryEmitExitRecording(battleSystem, BattleSystem_GetBattleContext(battleSystem));
                    } else {
                        ov12_022639B8(battleSystem, battlerId, msg);
                        ctx->unk_0[battlerId] = SSI_STATE_15;
                        ctx->unk_4[battlerId] = SSI_STATE_3;
                    }
                } else {
                    ctx->playerActions[battlerId].unk8 = ctx->battleBuffer[battlerId][0];
                    ctx->movePos[battlerId] = ctx->battleBuffer[battlerId][0] - 1;
                    ctx->unk_30B4[battlerId] = ctx->battleMons[battlerId].moves[ctx->movePos[battlerId]];
                    ctx->unk_0[battlerId] = SSI_STATE_5;
                    ctx->unk_314C[battlerId] |= 0x2;
                }
            }
            break;
        case SSI_STATE_5: {
            int out;

            if (ov12_0224DB64(battleSystem, ctx, battlerId, battleType, &out, ctx->movePos[battlerId], &ctx->playerActions[battlerId].unk4)) {
                ov12_02262FFC(battleSystem, ctx, out, battlerId);
                ctx->unk_0[battlerId] = SSI_STATE_6;
            } else {
                ctx->unk_0[battlerId] = SSI_STATE_13;
            }
            break;
        }
        case SSI_STATE_6:
            if (BattleBuffer_GetNext(ctx, battlerId) == 0xff) {
                ctx->unk_0[battlerId] = SSI_STATE_3;
            } else if (BattleBuffer_GetNext(ctx, battlerId)) {
                ctx->playerActions[battlerId].unk4 = ctx->battleBuffer[battlerId][0] - 1;
                ctx->unk_0[battlerId] = SSI_STATE_13;

                ctx->unk_314C[battlerId] |= 0x4;
            }
            break;
        case SSI_STATE_7:
            ov12_02263138(battleSystem, ctx, battlerId);
            ctx->unk_0[battlerId] = SSI_STATE_8;
        case SSI_STATE_8:
            if (BattleBuffer_GetNext(ctx, battlerId) == 0xff) {
                ctx->unk_0[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
            } else if (BattleBuffer_GetNext(ctx, battlerId)) {
                u32 *unkPtr;

                unkPtr = (u32 *)&ctx->battleBuffer[battlerId][0];
                ctx->playerActions[battlerId].unk8 = unkPtr[0];
                ctx->unk_0[battlerId] = SSI_STATE_13;
            }
            break;
        case SSI_STATE_9: // switching..?
        {
            int v8;
            int v9 = 6;
            int partnerId;

            v8 = BattlerCanSwitch(battleSystem, ctx, battlerId);

            if (((ov12_0223AB0C(battleSystem, battlerId) == 4) || (ov12_0223AB0C(battleSystem, battlerId) == 5)) && ((battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES)) || (battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_LINK)) || (battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_FRONTIER)) || ((battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_TAG)) && (ov12_0223AB0C(battleSystem, battlerId) == 4)))) {
                partnerId = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);

                if (ctx->playerActions[partnerId].command == CONTROLLER_COMMAND_POKEMON_INPUT) {
                    v9 = ctx->playerActions[partnerId].unk8;
                }
            }

            BattleController_EmitShowMonList(battleSystem, ctx, battlerId, 0, v8, v9);
            ctx->unk_0[battlerId] = SSI_STATE_10;
        }
        // fallthrough
        case SSI_STATE_10:
            if (BattleBuffer_GetNext(ctx, battlerId) == 0xff) {
                ctx->unk_0[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
            } else if (BattleBuffer_GetNext(ctx, battlerId)) {
                ctx->playerActions[battlerId].unk8 = ctx->battleBuffer[battlerId][0] - 1;
                ctx->unk_21A0[battlerId] = ctx->battleBuffer[battlerId][0] - 1;
                ctx->unk_0[battlerId] = SSI_STATE_13;
            }
            break;
        case SSI_STATE_11: // Flee after a mon fainted..?
            if (battleType & BATTLE_TYPE_FRONTIER) {
                BattleController_EmitDrawYesNoBox(battleSystem, ctx, battlerId, 955, 0, 0, 0);
                ctx->unk_0[battlerId] = SSI_STATE_12;
            } else if ((battleType & BATTLE_TYPE_TRAINER) && !(battleType & BATTLE_TYPE_LINK)) {
                if (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) {
                    ov12_0223BFFC(battleSystem, 1);
                    BattleController_TryEmitExitRecording(battleSystem, BattleSystem_GetBattleContext(battleSystem));
                } else {
                    msg.tag = TAG_NONE;
                    msg.id = msg_0197_00793; // There's no running from a Trainer battle!
                    ov12_022639B8(battleSystem, battlerId, msg);
                    ctx->unk_0[battlerId] = SSI_STATE_15;
                    ctx->unk_4[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
                }
            } else if (CantEscape(battleSystem, ctx, battlerId, &msg)) {
                if (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) {
                    ov12_0223BFFC(battleSystem, 1);
                    BattleController_TryEmitExitRecording(battleSystem, BattleSystem_GetBattleContext(battleSystem));
                } else {
                    ov12_022639B8(battleSystem, battlerId, msg);
                    ctx->unk_0[battlerId] = SSI_STATE_15;
                    ctx->unk_4[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
                }
            } else {
                ctx->unk_0[battlerId] = SSI_STATE_12;
            }
            break;
        case SSI_STATE_12:
            if (battleType & BATTLE_TYPE_FRONTIER) {
                if (BattleBuffer_GetNext(ctx, battlerId)) {
                    if (BattleBuffer_GetNext(ctx, battlerId) == 0xff) {
                        ctx->unk_0[battlerId] = SSI_STATE_SELECT_COMMAND_INIT;
                    } else {
                        ctx->unk_0[battlerId] = SSI_STATE_13;
                    }
                }
            } else {
                ctx->unk_0[battlerId] = SSI_STATE_13;
            }

            if ((battleType & BATTLE_TYPE_DOUBLES) && !(battleType & BATTLE_TYPE_MULTI) && (ctx->unk_0[battlerId] == 13)) {
                ctx->unk_0[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)] = SSI_STATE_13;
            }
            break;
        case SSI_STATE_13: // WIFI wait for partner to make a move..?
            ov12_02263CCC(battleSystem, battlerId);

            if (battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_LINK)) {
                int partnerId;

                partnerId = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);

                if (ctx->unk_0[partnerId] == SSI_STATE_14) {
                    BattleController_EmitShowWaitMessage(battleSystem, battlerId);
                }
            } else {
                BattleController_EmitShowWaitMessage(battleSystem, battlerId);
            }

            ctx->unk_0[battlerId] = SSI_STATE_14;
        case SSI_STATE_14:
            var++; // this might be counting the number of players who have selected their final action?
            break;
        case SSI_STATE_15:
            if (BattleBuffer_GetNext(ctx, battlerId)) {
                BattleBuffer_Clear(ctx, battlerId);
                ctx->unk_0[battlerId] = ctx->unk_4[battlerId];
            }
            break;
        case SSI_STATE_NO_MOVES:
            msg.tag = TAG_NICKNAME;
            msg.id = msg_0197_00608; // Spheal has no moves left!
            msg.param[0] = CreateNicknameTag(ctx, battlerId);
            ov12_022639B8(battleSystem, battlerId, msg);
            ctx->unk_0[battlerId] = SSI_STATE_15;
            ctx->unk_4[battlerId] = SSI_STATE_13;
            break;
        case SSI_STATE_END:
            ov12_02263E18(battleSystem, battlerId);
            ctx->unk_0[battlerId] = ctx->unk_4[battlerId];
            break;
        }
    }

    if (var == battlersMax) {
        ov12_0224E414(battleSystem, ctx);
        ov12_02237ED0(battleSystem, 0);

        ctx->command = CONTROLLER_COMMAND_CALC_EXECUTION_ORDER;

        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            if (ctx->playerActions[battlerId].command == CONTROLLER_COMMAND_POKEMON_INPUT) {
                ov12_02256F78(battleSystem, ctx, battlerId, ctx->unk_21A0[battlerId]);
            }
        }
    }
}

static void BattleControllerPlayer_CalcExecutionOrder(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers;
    u32 battleType;
    int i, j;
    int turn;
    u32 flag;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    battleType = BattleSystem_GetBattleType(battleSystem);

    turn = 0;

    if (battleType & (BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK)) {
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            ctx->executionOrder[battlerId] = battlerId;
        }
    } else {
        if (battleType & BATTLE_TYPE_LINK) {
            for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
                if (ctx->playerActions[battlerId].inputSelection == BATTLE_INPUT_RUN) {
                    turn = 5;
                    break;
                }
            }
        } else {
            if (ctx->playerActions[BATTLER_PLAYER].inputSelection == BATTLE_INPUT_RUN) {
                battlerId = BATTLER_PLAYER;
                turn = 5;
            }
            if (ctx->playerActions[BATTLER_PLAYER2].inputSelection == BATTLE_INPUT_RUN) {
                battlerId = BATTLER_PLAYER2;
                turn = 5;
            }
        }
        if (turn == 5) {
            ctx->executionOrder[0] = battlerId;
            turn = 1;
            for (i = 0; i < maxBattlers; i++) {
                if (i != battlerId) {
                    ctx->executionOrder[turn] = i;
                    turn++;
                }
            }
        } else {
            for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
                if (ctx->playerActions[battlerId].inputSelection == BATTLE_INPUT_BAG || ctx->playerActions[battlerId].inputSelection == BATTLE_INPUT_POKEMON) {
                    ctx->executionOrder[turn] = battlerId;
                    turn++;
                }
            }

            for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
                if (ctx->playerActions[battlerId].inputSelection != BATTLE_INPUT_BAG && ctx->playerActions[battlerId].inputSelection != BATTLE_INPUT_POKEMON) {
                    ctx->executionOrder[turn] = battlerId;
                    turn++;
                }
            }

            for (i = 0; i < maxBattlers - 1; i++) {
                for (j = i + 1; j < maxBattlers; j++) {
                    int battlerId1 = ctx->executionOrder[i];
                    int battlerId2 = ctx->executionOrder[j];

                    if (ctx->playerActions[battlerId1].inputSelection == ctx->playerActions[battlerId2].inputSelection) {
                        if (ctx->playerActions[battlerId1].inputSelection == BATTLE_INPUT_FIGHT) {
                            flag = 0;
                        } else {
                            flag = 1;
                        }
                        if (CheckSortSpeed(battleSystem, ctx, battlerId1, battlerId2, flag)) {
                            ctx->executionOrder[i] = battlerId2;
                            ctx->executionOrder[j] = battlerId1;
                        }
                    }
                }
            }
        }
    }
    ctx->command = CONTROLLER_COMMAND_BEFORE_TURN;
}

typedef enum BeforeTurnState {
    BT_STATE_FOCUS_PUNCH,
    BT_STATE_RAGE,
    BT_STATE_QUICK_CLAW,
    BT_STATE_END
} BeforeTurnState;

static void BattleControllerPlayer_BeforeTurn(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag = 0;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    do {
        switch (ctx->stateBeforeTurn) {
        case BT_STATE_FOCUS_PUNCH:
            while (ctx->beforeTurnData < maxBattlers) {
                battlerId = ctx->executionOrder[ctx->beforeTurnData];
                if (ctx->switchInFlag & MaskOfFlagNo(battlerId)) {
                    ctx->beforeTurnData++;
                    continue;
                }
                ctx->beforeTurnData++;
                if (!(ctx->battleMons[battlerId].status & STATUS_SLEEP)
                    && (GetBattlerSelectedMove(ctx, battlerId) == MOVE_FOCUS_PUNCH)
                    && !CheckTruant(ctx, battlerId) && !ctx->turnData[battlerId].struggleFlag) {
                    BattleController_EmitBlankMessage(battleSystem);
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TIGHTEN_FOCUS);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    return;
                }
                // Beak Blast heats its user's beak as the turn begins, asleep,
                // frozen or confused as it may be, and until it moves what
                // touches it is burned (Pokemon Central, Cannonbecco;
                // CheckAbilityEffectOnHit).
                // Shell Trap is set the same way, and sprung in HpCalc.
                if ((GetBattlerSelectedMove(ctx, battlerId) == MOVE_SHELL_TRAP || GetBattlerSelectedMove(ctx, battlerId) == MOVE_BEAK_BLAST) && !ctx->turnData[battlerId].struggleFlag) {
                    BattleController_EmitBlankMessage(battleSystem);
                    if (GetBattlerSelectedMove(ctx, battlerId) == MOVE_SHELL_TRAP) {
                        ctx->turnData[battlerId].shellTrapSet = TRUE;
                        ctx->buffMsg.id = msg_0197_01888; // {0} set a shell trap!
                    } else {
                        ctx->turnData[battlerId].beakBlastCharging = TRUE;
                        ctx->buffMsg.id = msg_0197_01885; // {0} started heating up its beak!
                    }
                    ctx->buffMsg.tag = TAG_NICKNAME;
                    ctx->buffMsg.param[0] = CreateNicknameTag(ctx, battlerId);
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    return;
                }
            }
            ctx->beforeTurnData = 0;
            ctx->stateBeforeTurn++;
            break;
        case BT_STATE_RAGE:
            for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
                if ((ctx->battleMons[battlerId].status2 & STATUS2_RAGE) && GetBattlerSelectedMove(ctx, battlerId) != MOVE_RAGE) {
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_RAGE;
                }
            }
            ctx->stateBeforeTurn++;
            break;
        case BT_STATE_QUICK_CLAW:
            for (battlerId = 0; battlerId < 4; battlerId++) {
                ctx->unk_310C[battlerId] = BattleSystem_Random(battleSystem);
            }
            ctx->stateBeforeTurn++;
            break;
        case BT_STATE_END:
            ctx->stateBeforeTurn = BT_STATE_FOCUS_PUNCH;
            flag = 2;
            break;
        }
    } while (flag == 0);
    if (flag == 2) {
        ctx->command = CONTROLLER_COMMAND_8;
    }
}

static void ov12_02249460(BattleSystem *battleSystem, BattleContext *ctx) {
    int maxBattlers;
    int battlerId;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (BattleController_TryEmitExitRecording(battleSystem, ctx)) {
        return;
    }

    // What the Eject Pack answers is a stat lowered during the action about
    // to be taken, not one lowered on the way in before it or at the end of
    // the last turn.
    ctx->statLoweredBattlers = 0;
    ctx->statRaisedBattlers = 0;
    // Nothing has bounced the move about to be used; BtlCmd_MagicCoat says
    // who does.
    ctx->battlerIdMagicCoat = BATTLER_NONE;
    ctx->parentalBondDeferred = 0;
    // Before any action, and before the end of the turn: an Illusion whose
    // Pokemon no longer has the ability drops, whatever took it away.
    {
        int script;

        if (TryDropLostIllusion(battleSystem, ctx, &script) == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }

    ctx->battlersOnField = 0;
    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->playerActions[battlerId].command != CONTROLLER_COMMAND_40) {
            ctx->battlersOnField++;
        }
    }

    SortMonsBySpeed(battleSystem, ctx);

    if (ctx->executionIndex == maxBattlers) {
        ctx->executionIndex = 0;
        // What the turn's end takes -- the weather, a status, Leech Seed, a
        // curse, a bind, Future Sight -- can send an Emergency Exit or Wimp
        // Out Pokemon off (Pokemon Central, Passoindietro). Each holder above
        // half now is armed for it, and TurnEnd asks.
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            Battler_ArmRetreatOutsideMove(ctx, battlerId);
        }
        ctx->command = CONTROLLER_COMMAND_UPDATE_FIELD_CONDITION;
    } else {
        ctx->command = ctx->playerActions[ctx->executionOrder[ctx->executionIndex]].command;
    }
}

typedef enum UpdateFieldConditionState {
    UFC_STATE_REFLECT,
    UFC_STATE_LIGHT_SCREEN,
    UFC_STATE_MIST,
    UFC_STATE_SAFEGUARD,
    UFC_STATE_TAILWIND,
    UFC_STATE_LUCKY_CHANT,
    UFC_STATE_PLEDGES,
    UFC_STATE_WISH,
    UFC_STATE_RAIN,
    UFC_STATE_SANDSTORM,
    UFC_STATE_SUN,
    UFC_STATE_HAIL,
    UFC_STATE_SNOW,
    UFC_STATE_FOG,
    UFC_STATE_STRONG_WINDS,
    UFC_STATE_GRAVITY,
    UFC_STATE_END
} UpdateFieldConditionState;

// Opportunist and Symbiosis answer an end-of-turn effect as soon as it is over
// -- a Speed Boost or Moody raise copied, a Berry eaten replaced from the
// partner's hands -- rather than after the turn's end, where the entry
// abilities' check would otherwise first find them. Each of the turn's end
// steps asks this when it is entered again after an effect's script.
static BOOL TryEndOfTurnAnswers(BattleSystem *battleSystem, BattleContext *ctx) {
    int script = TryOpportunistOrSymbiosis(battleSystem, ctx);

    if (script == BATTLE_SUBSCRIPT_NONE) {
        return FALSE;
    }
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    return TRUE;
}

static void BattleControllerPlayer_UpdateFieldCondition(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag = 0;
    int side;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    do {
        if (TryFaintMon(ctx, ctx->command, ctx->command, 1) == TRUE) {
            return;
        }
        if (ov12_0224DD18(ctx, ctx->command, ctx->command) == TRUE) {
            return;
        }
        if (ov12_0224D7EC(battleSystem, ctx) == TRUE) {
            return;
        }
        if (TryEndOfTurnAnswers(battleSystem, ctx) == TRUE) {
            return;
        }

        switch (ctx->stateFieldConditionUpdate) {
        case UFC_STATE_REFLECT:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                // Aurora Veil is not a move this game has a name for, so it
                // runs out quietly rather than announcing itself.
                if ((ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_AURORA_VEIL) && --ctx->fieldSideConditionData[side].auroraVeilTurns == 0) {
                    ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_AURORA_VEIL;
                }
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_REFLECT) {
                    if (--ctx->fieldSideConditionData[side].reflectTurns == 0) {
                        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_REFLECT;
                        ctx->moveTemp = MOVE_REFLECT;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_EFFECT_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_LIGHT_SCREEN:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_LIGHT_SCREEN) {
                    if (--ctx->fieldSideConditionData[side].lightScreenTurns == 0) {
                        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_LIGHT_SCREEN;
                        ctx->moveTemp = MOVE_LIGHT_SCREEN;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_EFFECT_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_MIST:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_MIST) {
                    if (--ctx->fieldSideConditionData[side].mistTurns == 0) {
                        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_MIST;
                        ctx->moveTemp = MOVE_MIST;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_EFFECT_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_SAFEGUARD:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_SAFEGUARD) {
                    if (--ctx->fieldSideConditionData[side].safeguardTurns == 0) {
                        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_SAFEGUARD;
                        ctx->battlerIdTemp = ctx->fieldSideConditionData[side].safeguardBattler;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SAFEGUARD_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_TAILWIND:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_TAILWIND) {
                    ctx->fieldSideConditionFlags[side] -= 1 << SIDE_CONDITION_TAILWIND_SHIFT;
                    if ((ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_TAILWIND) == 0) {
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TAILWIND_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        // Wind Power charges once while a Tailwind blows, and
                        // the flag is what remembers that; the wind dropping
                        // is what lets it charge again next time.
                        for (int battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
                            if (BattleSystem_GetFieldSide(battleSystem, battlerId) == side && GetBattlerAbility(ctx, battlerId) == ABILITY_WIND_POWER) {
                                ctx->battleMons[battlerId].abilityActivatedFlag = FALSE;
                            }
                        }
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_LUCKY_CHANT:
            while (ctx->fieldConditionUpdateData < 2) {
                side = ctx->fieldConditionUpdateData;
                if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_LUCKY_CHANT) {
                    ctx->fieldSideConditionFlags[side] -= 1 << SIDE_CONDITION_LUCKY_CHANT_SHIFT;
                    if ((ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_LUCKY_CHANT) == 0) {
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_LUCKY_CHANT_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_PLEDGES:
            // The Pledges' rainbow, sea of fire and swamp run out, each side's
            // in turn, after the fourth turn's end counting the one they came
            // in (Pokemon Central, Acquapatto, Fiammapatto, Erbapatto). MSG_TEMP
            // says which for subscript 467.
            while (ctx->fieldConditionUpdateData < 6) {
                int shift = SIDE_CONDITION_RAINBOW_SHIFT + 3 * (ctx->fieldConditionUpdateData >> 1);

                side = ctx->fieldConditionUpdateData & 1;
                ctx->fieldConditionUpdateData++;
                if (ctx->fieldSideConditionFlags[side] & (7 << shift)) {
                    ctx->fieldSideConditionFlags[side] -= 1 << shift;
                    if ((ctx->fieldSideConditionFlags[side] & (7 << shift)) == 0) {
                        ctx->msgTemp = (shift - SIDE_CONDITION_RAINBOW_SHIFT) / 3;
                        ctx->battlerIdTemp = ov12_02257E98(battleSystem, ctx, side);
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_PLEDGE_CONDITION_END);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        flag = 1;
                        break;
                    }
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_WISH:
            while (ctx->fieldConditionUpdateData < maxBattlers) {
                side = ctx->turnOrder[ctx->fieldConditionUpdateData];
                if (ctx->fieldConditionData.wishTurns[side]) {
                    if (--ctx->fieldConditionData.wishTurns[side] == 0 && ctx->battleMons[side].hp != 0) {
                        ctx->battlerIdTemp = side;
                        ctx->buffMsg.tag = TAG_NICKNAME;
                        ctx->buffMsg.id = msg_0197_00533; // Spheal's wish came true!
                        ctx->buffMsg.param[0] = side | (ctx->fieldConditionData.wishTarget[side] << 8);
                        ctx->hpCalc = DamageDivide(ctx->battleMons[side].maxHp, 2);
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WISH_HEAL);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        flag = 1;
                    }
                }
                ctx->fieldConditionUpdateData++;
                if (flag) {
                    break;
                }
            }
            if (!flag) {
                ctx->stateFieldConditionUpdate++;
                ctx->fieldConditionUpdateData = 0;
            }
            break;
        case UFC_STATE_RAIN:
            if (ctx->fieldCondition & FIELD_CONDITION_RAIN_ALL) {
                // Heavy rain lasts as long as its Pokemon, with no turns to
                // count, and is announced the way the reference does, as rain.
                if (ctx->fieldCondition & (FIELD_CONDITION_RAIN_PERMANENT | FIELD_CONDITION_HEAVY_RAIN)) {
                    ctx->buffMsg.id = msg_0197_00801; // Rain continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else if (--ctx->fieldConditionData.weatherTurns == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_RAINING_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else {
                    ctx->buffMsg.id = msg_0197_00801; // Rain continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                }
                ctx->tempData = 19;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_SANDSTORM:
            if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) {
                if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_PERMANENT) {
                    ctx->buffMsg.id = msg_0197_00805; // The sandstorm rages.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else if (--ctx->fieldConditionData.weatherTurns == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SANDSTORM_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else {
                    ctx->buffMsg.id = msg_0197_00805; // The sandstorm rages.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                }
                ctx->tempData = 21;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_SUN:
            if (ctx->fieldCondition & FIELD_CONDITION_SUN_ALL) {
                // Extremely harsh sunlight likewise, as sun.
                if (ctx->fieldCondition & (FIELD_CONDITION_SUN_PERMANENT | FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT)) {
                    ctx->buffMsg.id = msg_0197_00808; // The sunlight is strong.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else if (--ctx->fieldConditionData.weatherTurns == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SUNNY_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else {
                    ctx->buffMsg.id = msg_0197_00808; // The sunlight is strong.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                }
                ctx->tempData = 22;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_HAIL:
            if (ctx->fieldCondition & FIELD_CONDITION_HAIL_ALL) {
                if (ctx->fieldCondition & FIELD_CONDITION_HAIL_PERMANENT) {
                    ctx->buffMsg.id = msg_0197_00811; // Hail continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else if (--ctx->fieldConditionData.weatherTurns == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HAILING_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else {
                    ctx->buffMsg.id = msg_0197_00811; // Hail continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                }
                ctx->tempData = 20;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_SNOW:
            // Hail's step again, with two things of its own. The line for the
            // snow continuing is this bank's -- the reference leaves that
            // branch without a message id at all, so its own game prints
            // whichever line was last in the buffer, and that is a thing to
            // copy only by accident. The animation is hail's, borrowed the way
            // an added move borrows one: snow is entry 54 of the table the
            // reference added to, and this game's stops earlier.
            //
            // Running WEATHER_CONTINUES is not only the message. It is the
            // script that walks the battlers and applies the weather to each,
            // which is where Ice Body feeds on the snow.
            if (ctx->fieldCondition & FIELD_CONDITION_SNOW_ALL) {
                if (ctx->fieldCondition & FIELD_CONDITION_SNOW_PERMANENT) {
                    ctx->buffMsg.id = msg_0197_01793; // The snow continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else if (--ctx->fieldConditionData.weatherTurns == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SNOW_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                } else {
                    ctx->buffMsg.id = msg_0197_01793; // The snow continues to fall.
                    ctx->buffMsg.tag = TAG_NONE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                }
                ctx->tempData = BATTLE_ANIMATION_WEATHER_HAIL;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_FOG:
            if (ctx->fieldCondition & FIELD_CONDITION_FOG) {
                ctx->buffMsg.id = msg_0197_00813; // The fog is deep...
                ctx->buffMsg.tag = TAG_NONE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WEATHER_CONTINUES);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->tempData = 18;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_STRONG_WINDS:
            // Delta Stream's winds have no turns to count and do nothing to
            // anybody at the end of one; they only blow on, which the
            // reference says (ServerFieldConditionCheck.c:272). Its Tailwind
            // animation is left out, as the snow's is.
            if (ctx->fieldCondition & FIELD_CONDITION_STRONG_WINDS) {
                ctx->buffMsg.id = msg_0197_01456; // The mysterious strong winds blow on!
                ctx->buffMsg.tag = TAG_NONE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_GRAVITY:
            if (ctx->fieldCondition & FIELD_CONDITION_GRAVITY) {
                ctx->fieldCondition -= (1 << FIELD_CONDITION_GRAVITY_SHIFT);
                if ((ctx->fieldCondition & FIELD_CONDITION_GRAVITY) == 0) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_GRAVITY_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateFieldConditionUpdate++;
            break;
        case UFC_STATE_END:
            flag = 2;
            break;
        }
    } while (!flag);

    if (flag == 1) {
        BattleController_EmitBlankMessage(battleSystem);
    }

    if (flag == 2) {
        ctx->stateFieldConditionUpdate = 0;
        ctx->command = CONTROLLER_COMMAND_UPDATE_MON_CONDITION;
    }
}

typedef enum UpdateMonConditionState {
    UMC_STATE_SEA_OF_FIRE,
    UMC_STATE_GRASSY_TERRAIN,
    UMC_STATE_INGRAIN,
    UMC_STATE_AQUA_RING,
    UMC_STATE_ABILITY,
    UMC_STATE_HELD_ITEM,
    UMC_STATE_LEFTOVERS_RECOVERY,
    UMC_STATE_LEECH_SEED,
    UMC_STATE_POISON,
    UMC_STATE_BAD_POISON,
    UMC_STATE_BURN,
    UMC_STATE_NIGHTMARE,
    UMC_STATE_CURSE,
    UMC_STATE_SALT_CURE,
    UMC_STATE_BINDING,
    UMC_STATE_OCTOLOCK,
    UMC_STATE_SYRUP_BOMB,
    UMC_STATE_BAD_DREAMS,
    UMC_STATE_UPROAR,
    UMC_STATE_RAMPAGE,
    UMC_STATE_DISABLE,
    UMC_STATE_ENCORE,
    UMC_STATE_LOCK_ON,
    UMC_STATE_CHARGE,
    UMC_STATE_TAUNT,
    UMC_STATE_MAGNET_RISE,
    UMC_STATE_TELEKINESIS,
    UMC_STATE_HEALBLOCK,
    UMC_STATE_EMBARGO,
    UMC_STATE_YAWN,
    UMC_STATE_HELD_ITEM_STATUS,
    UMC_STATE_HELD_ITEM_DAMAGE,
    UMC_STATE_END
} UpdateMonConditionState;

// Grassy Terrain gives a Pokemon standing on it a sixteenth of its maximum HP
// back at every turn's end, after a side's damage, as the reference's
// FIRST_EVENT_BLOCK_GRASSY_TERRAIN has it (ServerFieldConditionCheck.c at
// d0380a487). Not one in the air or out of reach mid-move, nor one under
// Heal Block (Pokemon Central, Campo Erboso), nor a Tatsugiri in its
// Dondozo's mouth (Torre di Comando), none of which the reference asks.
static BOOL GrassyTerrainHeals(BattleContext *ctx, int battlerId) {
    BattleMon *mon = &ctx->battleMons[battlerId];

    return ctx->terrainOverlayType == GRASSY_TERRAIN && mon->hp != 0 && mon->hp != mon->maxHp
        && !(mon->moveEffectFlags & MOVE_EFFECT_FLAG_SEMI_INVULNERABLE) && !mon->unk88.healBlockTurns
        && !ctx->moveConditions[battlerId].commanding && BattlerIsGrounded(ctx, battlerId);
}

// What a binding move takes at the end of each turn it holds on: an eighth of
// the bound Pokemon's maximum HP, as the reference has it
// (ServerFieldConditionCheck.c:870 at d0380a487). HeartGold took a sixteenth.
//
// A sixth when the Pokemon that bound it held a Binding Band as it did. The
// reference leaves the band unread, so this follows Pokemon Central
// (Legafascia): from the sixth generation on, the binding moves used by the
// band's holder take a sixth of the bound Pokemon's maximum HP instead of an
// eighth. The band is read as the bind begins (BtlCmd_SetBindingTurns), so
// a band knocked off, stolen or given afterwards changes nothing.
static int BindDamageDivisor(BattleContext *ctx, int battlerId) {
    if (ctx->bindingBandBinds & MaskOfFlagNo(battlerId)) {
        return 6;
    }
    return 8;
}

// A turn of a bind has gone by for the Pokemon held: TRUE while it is still
// held. A Grip Claw's eighth turn goes first, then the count in the status
// word (BtlCmd_SetBindingTurns).
static BOOL BindTurnPasses(BattleContext *ctx, int battlerId) {
    if (ctx->moveConditions[battlerId].bindEighthTurn) {
        ctx->moveConditions[battlerId].bindEighthTurn = FALSE;
    } else {
        ctx->battleMons[battlerId].status2 -= 1 << STATUS2_BINDING_SHIFT;
    }
    return (ctx->battleMons[battlerId].status2 & STATUS2_BIND) != 0;
}

static void BattleControllerPlayer_UpdateMonCondition(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    u8 flag = 0;
    int maxBattlers;
    int battlerId;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (TryFaintMon(ctx, ctx->command, ctx->command, 1) == TRUE) {
        return;
    }

    if (ov12_0224DD18(ctx, ctx->command, ctx->command) == TRUE) {
        return;
    }

    if (ov12_0224D7EC(battleSystem, ctx) == TRUE) {
        return;
    }

    if (TryEndOfTurnAnswers(battleSystem, ctx) == TRUE) {
        return;
    }

    while (ctx->updateMonConditionData < maxBattlers) {
        battlerId = ctx->turnOrder[ctx->updateMonConditionData];
        if (ctx->switchInFlag & MaskOfFlagNo(battlerId)) {
            ctx->updateMonConditionData++;
            continue;
        }
        // No move is being used at the end of the turn, but the scripts run
        // here still ask the attacker -- whether its Mold Breaker ignores an
        // ability, whether its Infiltrator or its sound move goes round a
        // substitute -- and the attacker was whoever moved last. The Pokemon
        // whose condition is running stands in, which answers every one of
        // those questions with no: none of them asks about a Pokemon's own.
        ctx->battlerIdAttacker = battlerId;
        switch (ctx->stateUpdateMonCondition) {
        case UMC_STATE_SEA_OF_FIRE:
            // A sea of fire around the Pokemon's side burns an eighth of its
            // maximum HP at every turn's end, but not a Fire type's, and Magic
            // Guard spares it (Pokemon Central, Fiammapatto, Erbapatto).
            if ((ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] & SIDE_CONDITION_SEA_OF_FIRE)
                && ctx->battleMons[battlerId].hp != 0 && GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD
                && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) != TYPE_FIRE && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) != TYPE_FIRE
                && ctx->battleMons[battlerId].type3 != TYPE_FIRE) {
                ctx->battlerIdTemp = battlerId;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SEA_OF_FIRE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_GRASSY_TERRAIN:
            if (GrassyTerrainHeals(ctx, battlerId)) {
                ctx->battlerIdTemp = battlerId;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_GRASSY_TERRAIN_HEAL);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_INGRAIN:
            if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN) && ctx->battleMons[battlerId].hp != ctx->battleMons[battlerId].maxHp && ctx->battleMons[battlerId].hp != 0) {
                if (ctx->battleMons[battlerId].unk88.healBlockTurns) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CANNOT_HEAL);
                } else {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_INGRAIN_HEAL);
                }
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_AQUA_RING:
            if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_AQUA_RING) && ctx->battleMons[battlerId].hp != ctx->battleMons[battlerId].maxHp && ctx->battleMons[battlerId].hp != 0) {
                if (ctx->battleMons[battlerId].unk88.healBlockTurns) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CANNOT_HEAL);
                } else {
                    ctx->battlerIdTemp = battlerId;
                    ctx->moveTemp = MOVE_AQUA_RING;
                    ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_AQUA_RING_HEAL);
                }
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_ABILITY:
            if (ov12_02253068(battleSystem, ctx, battlerId) == TRUE) {
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_HELD_ITEM:
            if (TryUseHeldItem(battleSystem, ctx, battlerId) == TRUE) {
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_LEFTOVERS_RECOVERY:
            if (CheckItemGradualHPRestore(battleSystem, ctx, battlerId) == TRUE) {
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_LEECH_SEED:
            if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_LEECH_SEED) && ctx->battleMons[ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_LEECH_SEED_BATTLER].hp != 0 && GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdLeechSeedRecv = ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_LEECH_SEED_BATTLER;
                ctx->battlerIdLeechSeeded = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_LEECH_SEED_EFFECT);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_POISON:
            if ((ctx->battleMons[battlerId].status & STATUS_POISON) && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdTemp = battlerId;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_POISON_DAMAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_BAD_POISON:
            if ((ctx->battleMons[battlerId].status & STATUS_BAD_POISON) && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdTemp = battlerId;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                if ((ctx->battleMons[battlerId].status & STATUS_POISON_COUNT) != STATUS_POISON_COUNT) {
                    ctx->battleMons[battlerId].status += 1 << STATUS_POISON_COUNT_SHIFT;
                }
                ctx->hpCalc *= ((ctx->battleMons[battlerId].status & STATUS_POISON_COUNT) >> STATUS_POISON_COUNT_SHIFT);
                ctx->hpCalc *= -1;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_POISON_DAMAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_BURN:
            if ((ctx->battleMons[battlerId].status & STATUS_BURN) && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BURN_DAMAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_NIGHTMARE:
            if ((ctx->battleMons[battlerId].status2 & STATUS2_NIGHTMARE) && ctx->battleMons[battlerId].hp != 0) {
                if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NIGHTMARE_EFFECT);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                } else {
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_NIGHTMARE;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_CURSE:
            if ((ctx->battleMons[battlerId].status2 & STATUS2_CURSE) && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CURSE_DAMAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_SALT_CURE:
            // Salt Cure takes an eighth of its target's maximum HP at the end
            // of every turn it stays in, a quarter from a Water- or Steel-type;
            // Magic Guard spares it (Pokemon Central, Sotto Sale).
            if (ctx->moveConditions[battlerId].saltCured && ctx->battleMons[battlerId].hp != 0 && GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD) {
                int divisor = 8;

                if (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_WATER || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_WATER
                    || ctx->battleMons[battlerId].type3 == TYPE_WATER
                    || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_STEEL || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_STEEL
                    || ctx->battleMons[battlerId].type3 == TYPE_STEEL) {
                    divisor = 4;
                }
                ctx->battlerIdTemp = battlerId;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, divisor);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SALT_CURE_DAMAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_BINDING:
            if ((ctx->battleMons[battlerId].status2 & STATUS2_BIND) && ctx->battleMons[battlerId].hp != 0) {
                if (BindTurnPasses(ctx, battlerId)) {
                    ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, BindDamageDivisor(ctx, battlerId));
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BIND_EFFECT);
                } else {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BIND_END);
                }
                ctx->moveTemp = ctx->battleMons[battlerId].unk88.bindingMove;
                ctx->battlerIdTemp = battlerId;
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_OCTOLOCK:
            // An Octolock wears its target's Defense and Sp. Def down a stage
            // each at the end of every turn its user stays in (Pokemon
            // Central, Tentacolock): the drop Close Combat's user takes, but
            // made by the Octolock's user, so Clear Body, Mist and their kind
            // stand against it as against any foe's.
            if (ctx->moveConditions[battlerId].octolocked && (ctx->battleMons[battlerId].status2 & STATUS2_MEAN_LOOK) && ctx->battleMons[battlerId].hp != 0) {
                ctx->battlerIdStatChange = battlerId;
                ctx->battlerIdAttacker = ctx->battleMons[battlerId].unk88.battlerIdMeanLook;
                ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_DOWN_1_STAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_SYRUP_BOMB:
            // Syrup Bomb takes a stage of Speed at each of the next three
            // turns' ends, the thrower's drop as Clear Body and Mist see it,
            // with nothing said once the Speed is at the bottom (Pokemon
            // Central, Bomba Sciroppata).
            if (ctx->moveConditions[battlerId].syrupBombTurns && ctx->battleMons[battlerId].hp != 0) {
                ctx->moveConditions[battlerId].syrupBombTurns--;
                ctx->battlerIdStatChange = battlerId;
                ctx->battlerIdAttacker = ctx->moveConditions[battlerId].syrupBombUser;
                ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
                ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_BAD_DREAMS:
            ctx->tempData = CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP_RET, battlerId, ABILITY_BAD_DREAMS);
            if ((ctx->battleMons[battlerId].status & STATUS_SLEEP) && GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD && ctx->battleMons[battlerId].hp != 0 && ctx->tempData) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BAD_DREAMS);
                ctx->battleStatus |= BATTLE_STATUS_NO_BLINK;
                ctx->battlerIdTemp = battlerId;
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_UPROAR:
            if (ctx->battleMons[battlerId].status2 & STATUS2_UPROAR) {
                // Throat Chop silences an uproar in progress.
                if (ctx->moveConditions[battlerId].throatChopTimer) {
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_UPROAR;
                    ctx->fieldCondition &= (MaskOfFlagNo(battlerId) << 8) ^ 0xFFFFFFFF;
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPROAR_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                    ctx->stateUpdateMonCondition++;
                    break;
                }
                u8 battlerIdSleep;
                for (battlerIdSleep = 0; battlerIdSleep < maxBattlers; battlerIdSleep++) {
                    if ((ctx->battleMons[battlerIdSleep].status & STATUS_SLEEP) && ctx->battleMons[battlerIdSleep].hp != 0 && GetBattlerAbility(ctx, battlerIdSleep) != ABILITY_SOUNDPROOF) {
                        ctx->battlerIdTemp = battlerIdSleep;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WAKE_UP);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        break;
                    }
                }
                if (battlerIdSleep != maxBattlers) {
                    flag = 2;
                    break;
                }
                ctx->battleMons[battlerId].status2 -= 1 << STATUS2_UPROAR_SHIFT;
                if (ov12_02252218(ctx, battlerId)) {
                    i = BATTLE_SUBSCRIPT_UPROAR_END;
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_UPROAR;
                    ctx->fieldCondition &= (MaskOfFlagNo(battlerId) << 8) ^ 0xFFFFFFFF;
                } else if (ctx->battleMons[battlerId].status2 & STATUS2_UPROAR) {
                    i = BATTLE_SUBSCRIPT_UPROAR_CONTINUES;
                } else {
                    i = BATTLE_SUBSCRIPT_UPROAR_END;
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_UPROAR;
                    ctx->fieldCondition &= (MaskOfFlagNo(battlerId) << 8) ^ 0xFFFFFFFF;
                }
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, i);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            if (flag != 2) {
                ctx->stateUpdateMonCondition++;
            }
            break;
        case UMC_STATE_RAMPAGE:
            if (ctx->battleMons[battlerId].status2 & STATUS2_RAMPAGE) {
                ctx->battleMons[battlerId].status2 -= 1 << STATUS2_RAMPAGE_SHIFT;
                if (ov12_02252218(ctx, battlerId)) {
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_RAMPAGE;
                } else if (!(ctx->battleMons[battlerId].status2 & STATUS2_RAMPAGE) && !(ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION)) {
                    ctx->battlerIdStatChange = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_THRASH_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_DISABLE:
            if (ctx->battleMons[battlerId].unk88.disabledMove) {
                for (i = 0; i < MAX_MON_MOVES; i++) {
                    if (ctx->battleMons[battlerId].unk88.disabledMove == ctx->battleMons[battlerId].moves[i]) {
                        break;
                    }
                }
                if (i == MAX_MON_MOVES) {
                    ctx->battleMons[battlerId].unk88.disabledTurns = 0;
                }
                if (ctx->battleMons[battlerId].unk88.disabledTurns) {
                    ctx->battleMons[battlerId].unk88.disabledTurns--;
                } else {
                    ctx->battleMons[battlerId].unk88.disabledMove = 0;
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_DISABLE_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_ENCORE:
            if (ctx->battleMons[battlerId].unk88.encoredMove) {
                for (i = 0; i < MAX_MON_MOVES; i++) {
                    if (ctx->battleMons[battlerId].unk88.encoredMove == ctx->battleMons[battlerId].moves[i]) {
                        break;
                    }
                }
                if (i == MAX_MON_MOVES || (i != MAX_MON_MOVES && !ctx->battleMons[battlerId].movePPCur[i])) {
                    ctx->battleMons[battlerId].unk88.encoredTurns = 0;
                }
                if (ctx->battleMons[battlerId].unk88.encoredTurns) {
                    ctx->battleMons[battlerId].unk88.encoredTurns--;
                } else {
                    ctx->battleMons[battlerId].unk88.encoredMove = 0;
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_ENCORE_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_LOCK_ON:
            if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON) {
                ctx->battleMons[battlerId].moveEffectFlags -= 1 << MOVE_EFFECT_FLAG_LOCK_ON_SHIFT;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_CHARGE:
            if (ctx->battleMons[battlerId].unk88.isCharged) {
                if (--ctx->battleMons[battlerId].unk88.isCharged == 0) {
                    ctx->battleMons[battlerId].moveEffectFlags &= ~MOVE_EFFECT_FLAG_CHARGE;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_TAUNT:
            if (ctx->battleMons[battlerId].unk88.tauntTurns != 0) {
                ctx->battleMons[battlerId].unk88.tauntTurns--;
                if (ctx->battleMons[battlerId].unk88.tauntTurns == 0) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TAUNT_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_MAGNET_RISE:
            if (ctx->battleMons[battlerId].unk88.magnetRiseTurns) {
                if (--ctx->battleMons[battlerId].unk88.magnetRiseTurns == 0) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MAGNET_RISE_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_TELEKINESIS:
            // Telekinesis lets its Pokemon down after three turns' ends, with
            // the later games' line.
            if (ctx->moveConditions[battlerId].telekinesisTurns && --ctx->moveConditions[battlerId].telekinesisTurns == 0) {
                ctx->buffMsg.id = msg_0197_01882; // {0} was freed from the telekinesis!
                ctx->buffMsg.tag = TAG_NICKNAME;
                ctx->buffMsg.param[0] = CreateNicknameTag(ctx, battlerId);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_HEALBLOCK:
            if (ctx->battleMons[battlerId].unk88.healBlockTurns) {
                if (--ctx->battleMons[battlerId].unk88.healBlockTurns == 0) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HEAL_BLOCK_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_EMBARGO:
            if (ctx->battleMons[battlerId].unk88.embargoFlag) {
                if (--ctx->battleMons[battlerId].unk88.embargoFlag == 0) {
                    ctx->battlerIdTemp = battlerId;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_EMBARGO_END);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_YAWN:
            if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_YAWN) {
                ctx->battleMons[battlerId].moveEffectFlags -= 1 << MOVE_EFFECT_FLAG_YAWN_SHIFT;
                if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_YAWN) == 0) {
                    ctx->battlerIdStatChange = battlerId;
                    ctx->statChangeType = 4;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FALL_ASLEEP);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    flag = 1;
                }
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_HELD_ITEM_STATUS: {
            int script;

            if (CheckUseHeldItem(battleSystem, ctx, battlerId, (u32 *)&script) == TRUE) {
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        }
        case UMC_STATE_HELD_ITEM_DAMAGE:
            if (TryHeldItemNegativeEffect(battleSystem, ctx, battlerId) == TRUE) {
                flag = 1;
            }
            ctx->stateUpdateMonCondition++;
            break;
        case UMC_STATE_END:
            ctx->stateUpdateMonCondition = 0;
            ctx->updateMonConditionData++;
            break;
        }
        if (flag) {
            BattleController_EmitBlankMessage(battleSystem);
            return;
        }
    }
    ctx->stateUpdateMonCondition = 0;
    ctx->updateMonConditionData = 0;
    ctx->command = CONTROLLER_COMMAND_UPDATE_FIELD_CONDITION_EXTRA;
}

typedef enum UpdateFieldConditionExtraState {
    UFCE_STATE_FUTURE_SIGHT,
    UFCE_STATE_PERISH_SONG,
    UFCE_STATE_TRICK_ROOM,
    UFCE_STATE_WONDER_ROOM,
    UFCE_STATE_MAGIC_ROOM,
    UFCE_STATE_TERRAIN,
    UFCE_STATE_HUNGER_SWITCH,
    UFCE_STATE_END
} UpdateFieldConditionExtraState;

// Hunger Switch (ServerFieldConditionCheck.c:1841): at the end of every turn a
// Morpeko goes from its Full Belly Mode to its Hangry Mode or back. The
// species to become, or SPECIES_NONE; not for a transformed battler.
static u16 Battler_HungerSwitchForm(BattleContext *ctx, int battlerId) {
    if (!ctx->battleMons[battlerId].hp || GetBattlerAbility(ctx, battlerId) != ABILITY_HUNGER_SWITCH || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_NONE;
    }
    switch (ctx->battleMons[battlerId].species) {
    case SPECIES_MORPEKO:
        return SPECIES_MORPEKO_HANGRY;
    case SPECIES_MORPEKO_HANGRY:
        return SPECIES_MORPEKO;
    }
    return SPECIES_NONE;
}

// Future sight and doom desire are here due to mons being able to faint simulataneously, which means exp shouldn't be awarded like when a mon faints due to burn
// Trick room is here due to every other update function being reliant on turn order, meaning it must be updated last
static void BattleControllerPlayer_UpdateFieldConditionExtra(BattleSystem *battleSystem, BattleContext *ctx) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int battlerId;

    if (TryFaintMon(ctx, ctx->command, ctx->command, 1) == TRUE) {
        return;
    }

    if (TryEndOfTurnAnswers(battleSystem, ctx) == TRUE) {
        return;
    }

    BattleController_EmitBlankMessage(battleSystem);

    switch (ctx->stateUpdateFieldConditionExtra) {
    case UFCE_STATE_FUTURE_SIGHT:
        while (ctx->updateFieldConditionExtraData < maxBattlers) {
            battlerId = ctx->turnOrder[ctx->updateFieldConditionExtraData];
            if (ctx->switchInFlag & MaskOfFlagNo(battlerId)) {
                ctx->updateFieldConditionExtraData++;
                continue;
            }
            ctx->updateFieldConditionExtraData++;
            if (ctx->fieldConditionData.futureSightTurns[battlerId]) {
                if (!(--ctx->fieldConditionData.futureSightTurns[battlerId]) && ctx->battleMons[battlerId].hp != 0) {
                    ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] &= ~SIDE_CONDITION_FUTURE_SIGHT;
                    ctx->buffMsg.id = msg_0197_00475; // Seadra took the Doom Desire attack!
                    ctx->buffMsg.tag = TAG_NICKNAME_MOVE;
                    ctx->buffMsg.param[0] = CreateNicknameTag(ctx, battlerId);
                    ctx->buffMsg.param[1] = ctx->fieldConditionData.futureSightMoveNo[battlerId];
                    ctx->battlerIdTemp = battlerId;
                    ctx->moveTemp = ctx->fieldConditionData.futureSightMoveNo[battlerId];
                    BattleContext_LandFutureSight(battleSystem, ctx, battlerId);
                    ctx->battlerIdLeechSeedRecv = ctx->battlerIdAttacker;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FUTURE_SIGHT_DAMAGE);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    return;
                }
            }
        }
        ctx->stateUpdateFieldConditionExtra++;
        ctx->updateFieldConditionExtraData = 0;
    case UFCE_STATE_PERISH_SONG:
        while (ctx->updateFieldConditionExtraData < maxBattlers) {
            battlerId = ctx->turnOrder[ctx->updateFieldConditionExtraData];
            if (ctx->switchInFlag & MaskOfFlagNo(battlerId)) {
                ctx->updateFieldConditionExtraData++;
                continue;
            }
            ctx->updateFieldConditionExtraData++;
            if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_PERISH_SONG) {
                if (ctx->battleMons[battlerId].unk88.perishSongTurns == 0) {
                    ctx->battleMons[battlerId].moveEffectFlags &= ~MOVE_EFFECT_FLAG_PERISH_SONG;
                    ctx->msgTemp = ctx->battleMons[battlerId].unk88.perishSongTurns;
                    ctx->hpCalc = ctx->battleMons[battlerId].hp * -1;
                    ctx->battleStatus |= BATTLE_STATUS_NO_BLINK;
                } else {
                    ctx->msgTemp = ctx->battleMons[battlerId].unk88.perishSongTurns;
                    ctx->battleMons[battlerId].unk88.perishSongTurns--;
                }
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 102);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
        ctx->stateUpdateFieldConditionExtra++;
        ctx->updateFieldConditionExtraData = 0;
    case UFCE_STATE_TRICK_ROOM:
        if (ctx->fieldCondition & FIELD_CONDITION_TRICK_ROOM) {
            ctx->fieldCondition -= 1 << FIELD_CONDITION_TRICK_ROOM_SHIFT;
            if (!(ctx->fieldCondition & FIELD_CONDITION_TRICK_ROOM)) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 251);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
        ctx->stateUpdateFieldConditionExtra++;
        ctx->updateFieldConditionExtraData = 0;
        // fallthrough
    case UFCE_STATE_WONDER_ROOM:
        // Wonder Room and Magic Room come down after Trick Room, with the
        // line the move says when it takes them down itself.
        if (ctx->wonderRoomTurns && --ctx->wonderRoomTurns == 0) {
            ctx->buffMsg.id = msg_0197_01828; // Wonder Room wore off...
            ctx->buffMsg.tag = TAG_NONE;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
        ctx->stateUpdateFieldConditionExtra++;
        // fallthrough
    case UFCE_STATE_MAGIC_ROOM:
        if (ctx->magicRoomTurns && --ctx->magicRoomTurns == 0) {
            ctx->buffMsg.id = msg_0197_01830; // Magic Room wore off...
            ctx->buffMsg.tag = TAG_NONE;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
        ctx->stateUpdateFieldConditionExtra++;
        // fallthrough
    case UFCE_STATE_TERRAIN:
        // A terrain runs out after the rooms, past every Pokemon's own
        // conditions, as the reference's ENDTURN_TERRAIN_DISSIPATING has it
        // (ServerFieldConditionCheck.c at d0380a487): so Grassy Terrain still
        // heals on its last turn (Pokemon Central, Campo Erboso). The script
        // says which terrain ended and clears it. The count stops at the
        // floor rather than wrapping, which is what the reference's own guard
        // is for.
        if (ctx->terrainOverlayType != TERRAIN_NONE) {
            if (ctx->terrainOverlayTurns > 0) {
                ctx->terrainOverlayTurns--;
            }
            if (ctx->terrainOverlayTurns == 0) {
                ctx->stateUpdateFieldConditionExtra++;
                ctx->updateFieldConditionExtraData = 0;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
        ctx->stateUpdateFieldConditionExtra++;
        ctx->updateFieldConditionExtraData = 0;
        // fallthrough
    case UFCE_STATE_HUNGER_SWITCH:
        // The last thing at the end of a turn, as it is in hg-engine's.
        while (ctx->updateFieldConditionExtraData < maxBattlers) {
            u16 form;

            battlerId = ctx->turnOrder[ctx->updateFieldConditionExtraData];
            ctx->updateFieldConditionExtraData++;
            // Shields Down's end-of-turn check is here too: a Minior has one
            // ability and Hunger Switch is Morpeko's.
            form = Battler_HungerSwitchForm(ctx, battlerId);
            if (form == SPECIES_NONE) {
                form = Battler_ShieldsDownForm(ctx, battlerId);
            }
            if (form != SPECIES_NONE) {
                ctx->battlerIdTemp = battlerId;
                BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerId, form, FALSE);
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FORM_CHANGE);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
        ctx->stateUpdateFieldConditionExtra++;
        ctx->updateFieldConditionExtraData = 0;
        break;
    default:
        break;
    }
    // Ion Deluge charges the air for the turn and no longer, and it has no
    // message to go out on, so there is no state of its own to sit in and no
    // script to run: it is just cleared here, past the last thing that could
    // still have asked a move its type. Clearing a bit that is already clear
    // costs nothing, which is as well, because this line is passed twice on a
    // turn that ended Trick Room. The reference ends it last for the same
    // reason and says so in the same words.
    ctx->fieldCondition &= ~FIELD_CONDITION_ION_DELUGE;
    ctx->stateUpdateFieldConditionExtra = 0;
    ctx->updateFieldConditionExtraData = 0;
    ctx->command = CONTROLLER_COMMAND_TURN_END;
}

static void BattleControllerPlayer_TurnEnd(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ov12_0224DD18(ctx, ctx->command, ctx->command) == TRUE) {
        return;
    }

    if (ov12_0224D7EC(battleSystem, ctx) == TRUE) {
        return;
    }

    if (ov12_0224D540(battleSystem, ctx) == TRUE) {
        return;
    }

    // What the turn's end did, and the entry hazards to what replaced the
    // fallen, can send an Emergency Exit or Wimp Out Pokemon off, before the
    // marks are cleared with the rest of the turn.
    {
        int script;

        if (TryRetreatAbilityOutsideMove(battleSystem, ctx, &script) == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }

    // Echoed Voice's run: a turn it was used in adds to it, one it was not
    // ends it.
    if (!ctx->echoedVoiceUsed) {
        ctx->echoedVoiceTurns = 0;
    } else if (ctx->echoedVoiceTurns < 4) {
        ctx->echoedVoiceTurns++;
    }
    ctx->echoedVoiceUsed = FALSE;
    ctx->roundUsers = 0;
    if (ctx->fairyLockTurns) {
        ctx->fairyLockTurns--;
    }
    ctx->moveUsedLast = MOVE_NONE;
    ctx->moveUsedBefore = MOVE_NONE;

    ctx->totalTurns++;
    ctx->meFirstTotal++;

    BattleContext_Init(ctx);
    ov12_02251710(battleSystem, ctx);
    ctx->command = CONTROLLER_COMMAND_TRAINER_MESSAGE;
}

static void BattleControllerPlayer_FightInput(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag = 0;

    ctx->battlerIdAttacker = ctx->executionOrder[ctx->executionIndex];

    // A Pokemon Sky Drop holds in the air does nothing while it is held --
    // its sleep, its confusion and Truant waiting as it does -- and acts, if
    // it has not, once it has been let down (Pokemon Central, Cadutalibera).
    if (Battler_HeldBySkyDrop(ctx, ctx->battlerIdAttacker)) {
        ctx->command = CONTROLLER_COMMAND_40;
        return;
    }
    if (ctx->turnData[ctx->battlerIdAttacker].struggleFlag) {
        ctx->moveNoTemp = MOVE_STRUGGLE;
        flag = 1;
    } else if (ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove && ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove == ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMoveIndex]) {
        ctx->moveNoTemp = ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove;
        flag = 1;
    } else if (ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove && ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove != ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMoveIndex]) {
        ctx->moveNoTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMoveIndex];
        ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMove = 0;
        ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredMoveIndex = 0;
        ctx->battleMons[ctx->battlerIdAttacker].unk88.encoredTurns = 0;
        flag = 1;
    } else if (!Battler_CanSelectAction(ctx, ctx->battlerIdAttacker)) {
        ctx->moveNoTemp = ctx->moveNoLockedInto[ctx->battlerIdAttacker];
    } else if (ctx->unk_30B4[ctx->battlerIdAttacker] != ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->movePos[ctx->battlerIdAttacker]]) {
        ctx->moveNoTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->movePos[ctx->battlerIdAttacker]];
        flag = 1;
    } else {
        ctx->moveNoTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->movePos[ctx->battlerIdAttacker]];
    }
    ctx->moveNoCur = ctx->moveNoTemp;
    ctx->command = CONTROLLER_COMMAND_23;
    ctx->battlerIdTarget = ov12_022506D4(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoTemp, flag, 0);
    // Sky Drop's second turn comes down on the Pokemon it lifted, whatever
    // else would draw the move, or on nobody once that one is gone.
    if ((ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE) && ctx->moveNoTemp == MOVE_SKY_DROP) {
        int battlerId;

        ctx->battlerIdTarget = BATTLER_NONE;
        for (battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
            if (ctx->moveConditions[battlerId].skyDropHolder == ctx->battlerIdAttacker + 1 && ctx->battleMons[battlerId].hp) {
                ctx->battlerIdTarget = battlerId;
            }
        }
    }
    BattleController_EmitBlankMessage(battleSystem);
}

static void BattleControllerPlayer_ItemInput(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleItem *item;
    int script;
    ctx->battlerIdAttacker = ctx->executionOrder[ctx->executionIndex];
    ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
    item = (BattleItem *)&ctx->playerActions[ctx->battlerIdAttacker].unk8;

    if (BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker)) {
        switch (ctx->trainerAIData.useItem[ctx->battlerIdAttacker >> 1]) {
        case 0:
            script = BATTLE_SUBSCRIPT_USE_FULL_RESTORE;
            break;
        case 1:
            script = BATTLE_SUBSCRIPT_USE_POTION;
            break;
        case 2:
            if ((ctx->trainerAIData.unk9F[ctx->battlerIdAttacker >> 1] & 1) && (ctx->trainerAIData.unk9F[ctx->battlerIdAttacker >> 1] & 0x3e)) {
                ctx->msgTemp = 6;
            } else {
                ctx->msgTemp = LowestFlagNo(ctx->trainerAIData.unk9F[ctx->battlerIdAttacker >> 1]);
            }
            script = BATTLE_SUBSCRIPT_USE_STATUS_RECOVERY;
            break;
        case 3:
            ctx->msgTemp = ctx->trainerAIData.unk9F[ctx->battlerIdAttacker >> 1];
            script = BATTLE_SUBSCRIPT_USE_STAT_BOOSTER;
            break;
        case 4:
            script = BATTLE_SUBSCRIPT_USE_GUARD_SPEC;
            break;
        }
        ctx->itemTemp = ctx->trainerAIData.unkA0[ctx->battlerIdAttacker >> 1];
#ifdef NEWGOLD_DIAG
        gDiagAiItemCount++;
        gDiagAiItemLast = ctx->itemTemp;
#endif
    } else {
        switch (item->page) {
        case BTLPOCKETLIST_HP_PP_RESTORE:
        case BTLPOCKETLIST_STATUS_RESTORE:
        case BTLPOCKETLIST_BATTLE_ITEMS:
            if (item->id == ITEM_POKE_DOLL || item->id == ITEM_FLUFFY_TAIL) {
                script = BATTLE_SUBSCRIPT_ESCAPE_ITEM;
            } else {
                script = BATTLE_SUBSCRIPT_BATTLE_ITEM;
            }
            break;
        case BTLPOCKETLIST_BALLS:
            script = BATTLE_SUBSCRIPT_THROW_POKEBALL;
            if (!(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TRAINER) && !(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TUTORIAL)) {
                Bag_TakeItem(BattleSystem_GetBag(battleSystem), item->id, 1, HEAP_ID_BATTLE);
                BagCursor_Battle_SetLastUsedItem(BattleSystem_GetBagCursor(battleSystem), item->id, item->page);
            }
            break;
        }
        ctx->itemTemp = item->id;
    }

    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
    ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
}

static void BattleControllerPlayer_PokemonInput(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 9);
    ctx->battlerIdAttacker = ctx->executionOrder[ctx->executionIndex];
    ctx->battlerIdSwitch = ctx->battlerIdAttacker;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_41;
    ctx->tempData = 0;
    ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
}

static void BattleControllerPlayer_RunInput(BattleSystem *battleSystem, BattleContext *ctx) {
    ctx->battlerIdAttacker = ctx->executionOrder[ctx->executionIndex];

    if (BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) && !(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_LINK)) {
        // A wild Ghost-type flees whatever holds it (Battler_HasGhostType),
        // but for Sky Drop, whose hold nothing flees (CantEscape).
        if (Battler_HeldBySkyDrop(ctx, ctx->battlerIdAttacker)
            || ((ctx->battleMons[ctx->battlerIdAttacker].status2 & (STATUS2_BIND | STATUS2_MEAN_LOOK)) && !Battler_HasGhostType(ctx, ctx->battlerIdAttacker))) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 286);
            ctx->scriptSeqNo = 0;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_40;
        } else {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 230);
            ctx->scriptSeqNo = 0;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_44;
        }
    } else {
        if (BattleTryRun(battleSystem, ctx, ctx->battlerIdAttacker)) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 3);
            ctx->scriptSeqNo = 0;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_44;
        } else {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 8);
            ctx->scriptSeqNo = 0;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_40;
        }
    }
}

static void BattleControllerPlayer_SafariThrowBall(BattleSystem *battleSystem, BattleContext *ctx) {
    int cnt;

    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 275);
    ctx->battlerIdAttacker = BATTLER_PLAYER;
    ctx->battlerIdTarget = BATTLER_ENEMY;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
    ctx->itemTemp = ITEM_SAFARI_BALL;
    cnt = BattleSystem_GetSafariBallCount(battleSystem) - 1;
    BattleSystem_SetSafariBallCount(battleSystem, cnt);
    ov12_02263A1C(battleSystem, ctx, BATTLER_PLAYER);
}

static void BattleControllerPlayer_SafariThrowMud(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 227);
    ctx->battlerIdAttacker = 0;
    ctx->battlerIdTarget = 1;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
    ctx->tempData = BattleSystem_Random(battleSystem) % 10;
    if (ctx->safariRunAttempts > 0) {
        ctx->safariRunAttempts--;
    }
    if (ctx->tempData != 0) {
        ctx->msgTemp = 1;
        if (ctx->safariCatchRateStage > 0) {
            ctx->safariCatchRateStage--;
        }
    }
}

static void BattleControllerPlayer_SafariRun(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 228);
    ctx->battlerIdAttacker = 0;
    ctx->battlerIdTarget = 1;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
    ctx->tempData = BattleSystem_Random(battleSystem) % 10;
    if (ctx->safariCatchRateStage < 12) {
        ctx->safariCatchRateStage++;
    }
    if (ctx->tempData != 0 && ctx->safariRunAttempts < 12) {
        ctx->safariRunAttempts++;
    }
}

static void BattleControllerPlayer_SafariWatching(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SAFARI_ESCAPE);
    ctx->battlerIdAttacker = 0;
    ctx->battlerIdTarget = 1;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
}

static void BattleControllerPlayer_CatchingContestThrowBall(BattleSystem *battleSystem, BattleContext *ctx) {
    int cnt;

    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_THROW_POKEBALL);
    ctx->battlerIdAttacker = BATTLER_PLAYER;
    ctx->battlerIdTarget = BATTLER_ENEMY;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_40;
    ctx->itemTemp = ITEM_SPORT_BALL;
    cnt = BattleSystem_GetSafariBallCount(battleSystem) - 1;
    BattleSystem_SetSafariBallCount(battleSystem, cnt);
    ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
}

static u32 TryDisobedience(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int rnd, struggleRnd;
    u32 battleType;
    u8 level;
    PlayerProfile *profile;

    battleType = BattleSystem_GetBattleType(battleSystem);
    profile = BattleSystem_GetPlayerProfile(battleSystem, 0);

    if (battleType & (BATTLE_TYPE_LINK | BATTLE_TYPE_FRONTIER)) {
        return 0;
    }

    if (BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker)) {
        return 0;
    }

    if ((battleType & BATTLE_TYPE_AI) && ov12_0223AB0C(battleSystem, ctx->battlerIdAttacker) == 4) {
        return 0;
    }

    if (ov12_02256854(battleSystem, ctx) == TRUE) {
        return 0;
    }

    if (!Battler_CanSelectAction(ctx, ctx->battlerIdAttacker)) {
        return 0;
    }

    if (ctx->moveNoCur == MOVE_BIDE && (ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT)) {
        return 0;
    }

    if (PlayerProfile_CountBadges(profile) >= 8) {
        return 0;
    }

    level = 10;

    if (PlayerProfile_CountBadges(profile) >= 1) {
        level = 20;
    }

    if (PlayerProfile_CountBadges(profile) >= 2) {
        level = 30;
    }

    if (PlayerProfile_TestBadgeFlag(profile, 3)) {
        level = 50;
    }

    if (PlayerProfile_TestBadgeFlag(profile, 5)) {
        level = 70;
    }

    if (ctx->battleMons[ctx->battlerIdAttacker].level <= level) {
        return 0;
    }

    rnd = ((BattleSystem_Random(battleSystem) & 0xff) * (ctx->battleMons[ctx->battlerIdAttacker].level + level)) >> 8;

    if (rnd < level) {
        return 0;
    }

    if (ctx->moveNoCur == MOVE_RAGE) {
        ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_RAGE;
    }

    if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP && (ctx->moveNoCur == MOVE_SNORE || ctx->moveNoCur == MOVE_SLEEP_TALK)) {
        *script = BATTLE_SUBSCRIPT_DISOBEY_WHILE_ASLEEP;
        return 1;
    }

    rnd = ((BattleSystem_Random(battleSystem) & 0xff) * (ctx->battleMons[ctx->battlerIdAttacker].level + level)) >> 8;

    // use a random (useable) move
    if (rnd < level) {
        rnd = StruggleCheck(battleSystem, ctx, ctx->battlerIdAttacker, MaskOfFlagNo(ctx->movePos[ctx->battlerIdAttacker]), -1);

        if (rnd == 0xF) {
            *script = BATTLE_SUBSCRIPT_DISOBEY_DO_NOTHING;
            return 1;
        }
        do {
            struggleRnd = BattleSystem_Random(battleSystem) & 3;
        } while (MaskOfFlagNo(struggleRnd) & rnd);

        ctx->movePos[ctx->battlerIdAttacker] = struggleRnd;
        ctx->moveNoTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[ctx->movePos[ctx->battlerIdAttacker]];
        ctx->moveNoCur = ctx->moveNoTemp;
        ctx->battlerIdTarget = ov12_022506D4(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoTemp, 1, 0);

        if (ctx->battlerIdTarget == BATTLER_NONE) {
            ctx->playerActions[ctx->battlerIdAttacker].unk4 = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
        } else {
            ctx->playerActions[ctx->battlerIdAttacker].unk4 = ctx->battlerIdTarget;
        }

        *script = BATTLE_SUBSCRIPT_DISOBEY_ORDERS;
        ctx->unk_2184 |= 1;

        return 2;
    }

    level = ctx->battleMons[ctx->battlerIdAttacker].level - level;
    rnd = BattleSystem_Random(battleSystem) & 0xFF;

    // take a nap
    if (rnd < level && !(ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_ALL) && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_VITAL_SPIRIT && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_INSOMNIA && !(ctx->fieldCondition & FIELD_CONDITION_UPROAR)) {
        *script = BATTLE_SUBSCRIPT_DISOBEY_SLEEP;
        return 1;
    }

    rnd -= level;

    // hitting itself
    if (rnd < level) {
        ctx->battlerIdTarget = ctx->battlerIdAttacker;
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        ctx->hpCalc = CalcMoveDamage(battleSystem, ctx, MOVE_POUND, 0, 0, 40, 0, ctx->battlerIdAttacker, ctx->battlerIdAttacker, 1);
        ctx->hpCalc = ApplyDamageRange(battleSystem, ctx, ctx->hpCalc);
        ctx->hpCalc *= -1;
        *script = BATTLE_SUBSCRIPT_DISOBEY_HIT_SELF;
        ctx->battleStatus |= 2;
        return 3;
    }

    *script = BATTLE_SUBSCRIPT_DISOBEY_DO_NOTHING;

    return 1;
}

BOOL ov12_0224B1FC(BattleSystem *battleSystem, BattleContext *ctx) {
    int decreasePP = 1;
    int index;

    if (!ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure && ctx->battlerIdTarget != BATTLER_NONE) {
        if (ctx->moveNoTemp == MOVE_IMPRISON) {
            decreasePP += CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, ctx->battlerIdAttacker, ABILITY_PRESSURE);
        } else {
            switch (BattleMoveTbl(ctx, ctx->moveNoTemp)->range) {
            case RANGE_ALL_ADJACENT:
            case RANGE_FIELD:
                decreasePP += CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP_NOT_USER, ctx->battlerIdAttacker, ABILITY_PRESSURE);
                break;
            case RANGE_ADJACENT_OPPONENTS:
            case RANGE_OPPONENT_SIDE:
                decreasePP += CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, ctx->battlerIdAttacker, ABILITY_PRESSURE);
                break;
            case RANGE_USER_SIDE:
            case RANGE_USER:
            case RANGE_SINGLE_TARGET_USER_SIDE:
            case RANGE_ALLY:
                break;
            default:
                if (ctx->battlerIdAttacker != ctx->battlerIdTarget && GetBattlerAbility(ctx, ctx->battlerIdTarget) == ABILITY_PRESSURE) {
                    decreasePP++;
                }
                break;
            }
        }
    }

    index = BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdAttacker], ctx->moveNoTemp);

    if (!ctx->turnData[ctx->battlerIdAttacker].unk0_1 && !ctx->turnData[ctx->battlerIdAttacker].struggleFlag) {
        ctx->turnData[ctx->battlerIdAttacker].unk0_1 = 1;
        if (ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index] && index < 4) {
            if (ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index] > decreasePP) {
                ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index] -= decreasePP;
            } else {
                ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index] = 0;
            }
            CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdAttacker);
            // A move used, for the evolutions that count one: the player's own
            // Pokemon, asked by its party record, so a Transform is not it.
            if (BattleSystem_GetParty(battleSystem, ctx->battlerIdAttacker) == BattleSystem_GetParty(battleSystem, BATTLER_PLAYER)) {
                Mon_CountEvolutionMove(BattleSystem_GetPartyMon(battleSystem, ctx->battlerIdAttacker, ctx->selectedMonIndex[ctx->battlerIdAttacker]), ctx->moveNoTemp);
            }
        } else {
            ctx->moveStatusFlag |= MOVE_STATUS_NO_PP;
        }
    } else if (!ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index]
        && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT)
        && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)
        && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_RAMPAGE)
        && !(ctx->fieldCondition & (MaskOfFlagNo(ctx->battlerIdAttacker) << FIELD_CONDITION_UPROAR_SHIFT))
        && index < 4) {
        ctx->moveStatusFlag |= MOVE_STATUS_NO_PP;
    }

    return FALSE;
}

static BOOL ov12_0224B398(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;
    BOOL quickChargeFlag = FALSE; // only for solar beam this gen

    if ((ctx->battlerIdTarget == BATTLER_NONE && !BattleCtx_IsIdenticalToCurrentMove(ctx, ctx->moveNoCur))
        || (ctx->battlerIdTarget == BATTLER_NONE && BattleCtx_IsIdenticalToCurrentMove(ctx, ctx->moveNoCur) == TRUE && (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE || ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT))) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NO_TARGET);
        ctx->commandNext = CONTROLLER_COMMAND_39;
        // An explosion with nothing left to hit still fells its user, from
        // the fifth generation (Pokemon Central, Esplosione): TrySelfDestruct
        // has put it at 0 HP, and ov12_0224D1DC faints it. The line before is
        // HeartGold's "But there was no target...", which every move with
        // nothing left to hit prints here; the latest games have no such
        // line (Scarlet and Violet's English text, the sv-text dump) and say
        // "But it failed!" for every move alike, an explosion's too, its user
        // fainting after (Showdown's gen-9 useMoveInner: the faint, then
        // '-fail' for no target from the fifth generation). Natural Gift with
        // nothing left to hit still spends its Berry (Pokemon Central,
        // Dononaturale), once the move is over (NaturalGiftSpendsBerry).
        if ((ctx->battleStatus & BATTLE_STATUS_SELFDESTRUCTED) || BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_NATURAL_GIFT) {
            ctx->commandNext = CONTROLLER_COMMAND_36;
        }
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ret = TRUE;
    }

    // Under Mega Sol the user's Solar Beam needs no charge, whatever the
    // field; a Utility Umbrella holder charges it in the sun (Superombrello).
    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_151
        && (BattlerMoveWeatherAt(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker) & FIELD_CONDITION_SUN_ALL)) {
        quickChargeFlag = TRUE;
    }

    if (ctx->battlerIdTarget == BATTLER_NONE && BattleCtx_IsIdenticalToCurrentMove(ctx, ctx->moveNoCur) == TRUE && ret == FALSE && quickChargeFlag == FALSE && GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) != HOLD_EFFECT_CHARGE_SKIP && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
        ctx->battlerIdTarget = ctx->battlerIdAttacker;
    }

    return ret;
}

static BOOL ov12_0224B498(BattleSystem *battleSystem, BattleContext *ctx) {
    if ((BattleMoveTbl(ctx, ctx->moveNoCur)->range != RANGE_USER && BattleMoveTbl(ctx, ctx->moveNoCur)->range != RANGE_USER_SIDE && BattleMoveTbl(ctx, ctx->moveNoCur)->power != 0 && !(ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_IMMUNITY) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN)) || ctx->moveNoCur == MOVE_THUNDER_WAVE) {
        // The flags alone, as in the reference's BeforeMove: the damage is
        // final already, CalcDamage having taken the type chart into it.
        ov12_02251D28(battleSystem, ctx, ctx->moveNoCur, ctx->moveType, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->damage, &ctx->moveStatusFlag);
        // Delta Stream's winds say so where they shelter the target, before
        // the damage and once a move; the check comes round again and finds
        // it said.
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->strongWindsWeakened & MaskOfFlagNo(ctx->battlerIdTarget))
            && StrongWindsWeakenMove(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur, ctx->moveType) == TRUE) {
            ctx->strongWindsWeakened |= MaskOfFlagNo(ctx->battlerIdTarget);
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_STRONG_WINDS_WEAKEN);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return TRUE;
        }
        // Tera Shell says so on the first hit it takes, before the damage; the
        // check comes round again once the line is out, and finds it said.
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->teraShellResisting & MaskOfFlagNo(ctx->battlerIdTarget))
            && TeraShellResists(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur) == TRUE) {
            ctx->teraShellResisting |= MaskOfFlagNo(ctx->battlerIdTarget);
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TERA_SHELL);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return TRUE;
        }
        // A Disguise or an Ice Face takes the whole hit, and nothing is said
        // about how well it landed (battle_calc_damage.c:254).
        if (Battler_BrokenFaceForm(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur) != SPECIES_NONE) {
            ctx->damage = 0;
            ctx->moveStatusFlag &= ~MOVE_STATUS_ANY_EFFECTIVE;
        }
        if (ctx->moveStatusFlag & MOVE_STATUS_NO_EFFECT) {
            ctx->moveFail[ctx->battlerIdAttacker].noEffect = TRUE;
        }
    }
    return FALSE;
}

// Heal Block's other half, on the one a move would heal
// (BattleController_CheckHealBlock at d0380a487): Heal Pulse is refused on a
// Pokemon under it, and Pollen Puff on an ally under it, where the move heals
// rather than hits. The user is told it cannot use the move, as for its own.
static BOOL TargetIsHealBlocked(BattleContext *ctx) {
    int target = ctx->battlerIdTarget;

    if (target == BATTLER_NONE || !ctx->battleMons[target].unk88.healBlockTurns) {
        return FALSE;
    }
    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_HEAL_TARGET) {
        return TRUE;
    }
    return ctx->moveNoCur == MOVE_POLLEN_PUFF && target == (ctx->battlerIdAttacker ^ 2);
}

// A Dancer locked into a move other than the dance -- by a Choice item, an
// Encore or a rampage -- takes the dance up and fails it (Pokemon Central,
// Sincrodanza), after whatever else stops a move.
static BOOL Battler_DanceLocked(BattleContext *ctx, int battlerId) {
    BattleMon *mon = &ctx->battleMons[battlerId];

    return (mon->unk88.moveNoChoice && mon->unk88.moveNoChoice != ctx->danceMove)
        || (mon->unk88.encoredMove && mon->unk88.encoredMove != ctx->danceMove)
        || ((mon->status2 & (STATUS2_LOCKED_INTO_MOVE | STATUS2_RAMPAGE)) && ctx->moveNoLockedInto[battlerId] != ctx->danceMove);
}


// The moves that thaw their frozen user as it uses them (Pokemon Central,
// Congelamento): Flame Wheel, Sacred Fire, Flare Blitz, Scald, Steam Eruption
// and Matcha Gotcha by their side effect, as the reference's
// BattleController_CheckThawOut asks; Fusion Flare (Incrofiamma), Pyro Ball
// and Scorching Sands, which have no side effect of their own to ask by;
// Burn Up for a user that is at least part Fire (Ultima Fiamma: an added
// type is Grass or Ghost, never Fire); and Hydro
// Steam, which Pokemon Central does not name and Showdown's gen-9 data gives
// the same defrost flag.
static BOOL MoveThawsUser(BattleContext *ctx, int effect) {
    u16 move = ctx->moveNoCur;
    int attacker = ctx->battlerIdAttacker;

    if (move == MOVE_BURN_UP) {
        return GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_1, NULL) == TYPE_FIRE || GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_2, NULL) == TYPE_FIRE;
    }
    return effect == MOVE_EFFECT_THAW_AND_BURN_HIT || effect == MOVE_EFFECT_RECOIL_BURN_HIT || effect == MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT
        || move == MOVE_FUSION_FLARE || move == MOVE_PYRO_BALL || move == MOVE_SCORCHING_SANDS || move == MOVE_HYDRO_STEAM;
}
static BOOL ov12_0224B528(BattleSystem *battleSystem, BattleContext *ctx) {
    int effect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;
    int ret = 0;
    u16 form;

    do {
        switch (ctx->unk_50) {
        case 0:
            ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_DESTINY_BOND;
            ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags &= ~MOVE_EFFECT_FLAG_GRUDGE;
            ctx->unk_50++;
            break;
        case 1:
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) {
                if (ctx->fieldCondition & FIELD_CONDITION_UPROAR && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_SOUNDPROOF) {
                    ctx->battlerIdTemp = ctx->battlerIdAttacker;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WAKE_UP);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ret = 2;
                } else if ((ctx->moveNoCur != MOVE_SLEEP_TALK && ctx->moveNoTemp == MOVE_SLEEP_TALK) == 0) {
                    int sleepCounterDecrease;

                    if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_EARLY_BIRD) {
                        sleepCounterDecrease = 2;
                    } else {
                        sleepCounterDecrease = 1;
                    }
                    if ((ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) < sleepCounterDecrease) {
                        ctx->battleMons[ctx->battlerIdAttacker].status &= ~STATUS_SLEEP;
                    } else {
                        ctx->battleMons[ctx->battlerIdAttacker].status -= sleepCounterDecrease;
                    }

                    if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) {
                        if (ctx->moveNoCur != MOVE_SNORE && ctx->moveNoTemp != MOVE_SLEEP_TALK) {
                            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SLEEPING);
                            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                            ctx->commandNext = CONTROLLER_COMMAND_39;
                            ret = 2;
                        }
                    } else {
                        ctx->battlerIdTemp = ctx->battlerIdAttacker;
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WAKE_UP);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ret = 2;
                    }
                }
            }
            ctx->unk_50++;
            break;
        case 2:
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_FREEZE) {
                if (BattleSystem_Random(battleSystem) % 5 != 0) {
                    if (MoveThawsUser(ctx, effect) == FALSE) {
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FROZEN);
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->commandNext = CONTROLLER_COMMAND_39;
                        ret = 1;
                    }
                } else {
                    ctx->battlerIdTemp = ctx->battlerIdAttacker;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_THAW_OUT);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ret = 2;
                }
            }
            ctx->unk_50++;
            break;
        case 3:
            if (CheckTruant(ctx, ctx->battlerIdAttacker) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_LOAFING_AROUND);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 4:
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_RECHARGE) {
                ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_RECHARGE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_RECHARGING);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 5:
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_FLINCH) {
                ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_FLINCH;
                ctx->moveFail[ctx->battlerIdAttacker].flinch = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FLINCHED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 6:
            if (ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledMove == ctx->moveNoTemp) {
                ctx->moveFail[ctx->battlerIdAttacker].disabled = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_IS_DISABLED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 7:
            if (ctx->battleMons[ctx->battlerIdAttacker].unk88.tauntTurns && BattleMoveTbl(ctx, ctx->moveNoCur)->power == 0) {
                ctx->moveFail[ctx->battlerIdAttacker].unk0_5 = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_FAIL_TAUNTED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 8:
            if (BattleContext_CheckMoveImprisoned(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur)) {
                ctx->moveFail[ctx->battlerIdAttacker].imprison = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_IS_IMPRISONED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 9:
            if (BattleContext_CheckMoveUnuseableInGravity(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur)) {
                ctx->moveFail[ctx->battlerIdAttacker].gravity = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_FAIL_GRAVITY);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 10:
            if (BattleContext_CheckMoveHealBlocked(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur) || TargetIsHealBlocked(ctx)) {
                ctx->moveFail[ctx->battlerIdAttacker].healBlock = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_IS_HEAL_BLOCKED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 11:
            ctx->unk_50++;
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION) {
                ctx->battleMons[ctx->battlerIdAttacker].status2 -= 1;
                if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION) {
                    if (BattleSystem_Random(battleSystem) & 1) {
                        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CONFUSED);
                        ctx->commandNext = ctx->command;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ret = 2;
                    } else {
                        ctx->moveFail[ctx->battlerIdAttacker].confusion = TRUE;
                        ctx->battlerIdTarget = ctx->battlerIdAttacker;
                        ctx->battlerIdTemp = ctx->battlerIdTarget;
                        ctx->hpCalc = CalcMoveDamage(battleSystem, ctx, MOVE_STRUGGLE, 0, 0, 40, 0, ctx->battlerIdAttacker, ctx->battlerIdAttacker, 1);
                        ctx->hpCalc = ApplyDamageRange(battleSystem, ctx, ctx->hpCalc);
                        ctx->hpCalc *= -1;
                        // A Disguise or an Ice Face takes this blow too, and
                        // breaks (btl_scr_cmd_FE_calcconfusiondamage).
                        form = Battler_BrokenFaceForm(ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker, MOVE_STRUGGLE);
                        if (form != SPECIES_NONE) {
                            ctx->hpCalc = 0;
                            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdAttacker, form, TRUE);
                            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HURT_SELF_DISGUISED);
                        } else {
                            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HURT_SELF_IN_CONFUSION);
                        }
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->commandNext = CONTROLLER_COMMAND_34;
                        ret = 1;
                    }
                } else {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SNAP_OUT_OF_CONFUSION);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ret = 2;
                }
            }
            break;
        case 12:
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_PARALYSIS && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD) {
                if (BattleSystem_Random(battleSystem) % 4 == 0) {
                    ctx->moveFail[ctx->battlerIdAttacker].paralysis = TRUE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FULLY_PARALYZED);
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ctx->commandNext = CONTROLLER_COMMAND_39;
                    ret = 1;
                }
            }
            ctx->unk_50++;
            break;
        case 13:
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_ATTRACT) {
                ctx->battlerIdTemp = LowestFlagNo((ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_ATTRACT) >> STATUS2_ATTRACT_SHIFT);
                if (BattleSystem_Random(battleSystem) & 1) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_INFATUATED);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ret = 2;
                } else {
                    ctx->moveFail[ctx->battlerIdAttacker].infatuation = TRUE;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_IMMOBILIZED_BY_LOVE);
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ctx->commandNext = CONTROLLER_COMMAND_39;
                    ret = 1;
                }
            }
            ctx->unk_50++;
            break;
        case 14:
            ctx->unk_50++;
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_BIDE) {
                ctx->battleMons[ctx->battlerIdAttacker].status2 -= (1 << STATUS2_BIDE_SHIFT);
                if (!(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_BIDE) && ctx->unk_30E4[ctx->battlerIdAttacker]) {
                    ctx->damage = ctx->unk_30E4[ctx->battlerIdAttacker] * 2;
                    if (ctx->battleMons[ctx->unk_30F4[ctx->battlerIdAttacker]].hp != 0) {
                        ctx->battlerIdTarget = ctx->unk_30F4[ctx->battlerIdAttacker];
                    } else {
                        ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
                        if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
                            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BIDE_NO_TARGET);
                            ctx->commandNext = CONTROLLER_COMMAND_39;
                            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                            ret = 2;
                            break;
                        }
                    }
                }
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BIDE_END);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ret = 2;
            }
            break;
        case 15:
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_FREEZE) {
                if (MoveThawsUser(ctx, effect) == TRUE) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_DEFROSTED_BY_MOVE);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ret = 2;
                }
            }
            ctx->unk_50++;
            break;
        case 16:
            // Throat Chop refuses a sound move for the turn it landed and the
            // next. The selection screen refuses it too; this catches a move
            // chosen before the chop, or picked by something else.
            if (ctx->moveConditions[ctx->battlerIdAttacker].throatChopTimer && BattleMoveIsSoundBased(ctx->moveNoCur)) {
                ctx->moveFail[ctx->battlerIdAttacker].throatChop = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_FAIL_THROAT_CHOP);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 17:
            if (ctx->dancing && Battler_DanceLocked(ctx, ctx->battlerIdAttacker)) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_DANCE_FAILED);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_39;
                ret = 1;
            }
            ctx->unk_50++;
            break;
        case 18:
            ctx->unk_50 = 0;
            ret = 3;
            break;
        }
    } while (ret == 0);

    CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdAttacker);

    if (ret == 1) {
        ctx->battleStatus |= BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE;
        ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
    }

    return ret != 3;
}

static BOOL ov12_0224BC2C(BattleSystem *battleSystem, BattleContext *ctx) {
    int ret = 0;
    int script;

    do {
        switch (ctx->unk_54) {
        case 0:
            script = BattleContext_CheckMoveImmunityFromAbility(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);
            // A Surf that reaches this target lets a Cramorant catch its prey.
            if (script == BATTLE_SUBSCRIPT_NONE && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT) && ctx->moveNoCur == MOVE_SURF) {
                Battler_GulpMissileCatch(ctx, ctx->battlerIdAttacker);
            }
            // A refusal is still worth saying even when the move was going to
            // miss or do nothing anyway, which is why the two scripts that
            // only name an ability are let past the DID_NOT_HIT test.
            if ((script && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT)) || script == BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF || script == BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
                ret = 1;
            }
            ctx->unk_54++;
            break;
        case 1:
            ctx->unk_54 = 0;
            ret = 2;
            break;
        }
    } while (ret == 0);

    return ret != 2;
}

static BOOL ov12_0224BCA4(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CHECK_QUICK_CLAW);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    return TRUE;
}

static const u8 sHitChanceTable[13][2] = {
    { 33,  100 },
    { 36,  100 },
    { 43,  100 },
    { 50,  100 },
    { 60,  100 },
    { 75,  100 },
    { 1,   1   },
    { 133, 100 },
    { 166, 100 },
    { 2,   1   },
    { 233, 100 },
    { 133, 50  },
    { 3,   1   }
};

static BOOL BattleSystem_CheckMoveHit(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int move) {
    u16 hitChance;
    s8 var;
    s8 attackerAccuracy;
    s8 targetEvasion;
    int item;
    int itemMod;
    u8 moveType;
    u8 moveCategory;
    u32 weather;

    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TUTORIAL) {
        return FALSE;
    }

    moveType = BattleMoveAdjustedType(ctx, battlerIdAttacker, move);

    moveCategory = BattleMoveTbl(ctx, move)->category;
    attackerAccuracy = ctx->battleMons[battlerIdAttacker].statChanges[STAT_ACC] - 6;
    targetEvasion = 6 - ctx->battleMons[battlerIdTarget].statChanges[STAT_EVASION];

    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_SIMPLE) {
        attackerAccuracy *= 2;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SIMPLE) == TRUE) {
        targetEvasion *= 2;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_UNAWARE) == TRUE) {
        attackerAccuracy = 0;
    }

    // Mind's Eye sees past a raised guard the way Unaware does. Its other two
    // legs are elsewhere: the Ghost immunity in the type table, and the
    // accuracy it will not let anything lower.
    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_UNAWARE || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_MINDS_EYE) {
        targetEvasion = 0;
    }

    if (((ctx->battleMons[battlerIdTarget].status2 & STATUS2_FORESIGHT) || (ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_MIRACLE_EYE)) && targetEvasion < 0) {
        targetEvasion = 0;
    }

    var = 6 + targetEvasion + attackerAccuracy;

    if (var < 0) {
        var = 0;
    }
    if (var > 12) {
        var = 12;
    }

    hitChance = BattleMoveTbl(ctx, move)->accuracy;

    if (hitChance == 0) {
        return FALSE;
    }

    // Nothing misses a Pokemon Telekinesis holds up but a one-hit KO move
    // (Pokemon Central, Telecinesi).
    if (ctx->moveConditions[battlerIdTarget].telekinesisTurns && BattleMoveTbl(ctx, move)->effect != MOVE_EFFECT_ONE_HIT_KO) {
        return FALSE;
    }

    if (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) {
        return FALSE;
    }

    if (ctx->battleStatus & BATTLE_STATUS_FLAT_HIT_RATE) {
        return FALSE;
    }

    // Wonder Skin makes a status move a coin flip at best, and it does so to
    // the move's own accuracy, before the stage table or the weather are
    // allowed to move the number.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WONDER_SKIN) == TRUE && moveCategory == CATEGORY_STATUS && hitChance > 50) {
        hitChance = 50;
    }

    // The weather as the attacker's move sees it: under Mega Sol, the sun's,
    // whatever the field has, as hg-engine's CalcAccuracy reads it; the rain
    // and the sun leave Thunder's and Hurricane's accuracy against a Utility
    // Umbrella holder as it is (Superombrello).
    weather = BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget);

    // Hurricane is as bad in the sun as Thunder.
    if ((weather & FIELD_CONDITION_SUN_ALL)
        && (BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_THUNDER
            || BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_HURRICANE)) {
        hitChance = 50;
    }

    hitChance *= sHitChanceTable[var][0];
    hitChance /= sHitChanceTable[var][1];

    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_COMPOUNDEYES) {
        hitChance = hitChance * 130 / 100;
    }

    // Victory Star makes the moves of its holder and of the holder's ally a
    // tenth surer, 4506/4096 in the later games, and two holders stack
    // (Pokemon Central, Vittorstella). The reference asks only whether the
    // attacker's ally has it, so a Victini's own moves were never helped.
    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_VICTORY_STAR) {
        hitChance = hitChance * 110 / 100;
    }
    if ((battlerIdAttacker ^ 2) < BattleSystem_GetMaxBattlers(battleSystem) && ctx->battleMons[battlerIdAttacker ^ 2].hp && GetBattlerAbility(ctx, battlerIdAttacker ^ 2) == ABILITY_VICTORY_STAR) {
        hitChance = hitChance * 110 / 100;
    }

    if ((weather & FIELD_CONDITION_SANDSTORM_ALL) && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SAND_VEIL) == TRUE) {
        hitChance = hitChance * 80 / 100;
    }

    if (weather & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL) && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SNOW_CLOAK) == TRUE) {
        hitChance = hitChance * 80 / 100;
    }

    if (weather & FIELD_CONDITION_FOG) {
        hitChance = hitChance * 6 / 10;
    }

    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_HUSTLE && (moveCategory == CATEGORY_PHYSICAL)) {
        hitChance = hitChance * 80 / 100;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_TANGLED_FEET) == TRUE && ctx->battleMons[battlerIdTarget].status2 & STATUS2_CONFUSION) {
        hitChance = hitChance * 50 / 100;
    }

    item = GetBattlerHeldItemEffect(ctx, battlerIdTarget);
    itemMod = GetHeldItemModifier(ctx, battlerIdTarget, 0);

    if (item == HOLD_EFFECT_ACC_REDUCE) {
        hitChance = hitChance * (100 - itemMod) / 100;
    }

    item = GetBattlerHeldItemEffect(ctx, battlerIdAttacker);
    itemMod = GetHeldItemModifier(ctx, battlerIdAttacker, 0);

    if (item == HOLD_EFFECT_ACCURACY_UP) {
        hitChance = hitChance * (100 + itemMod) / 100;
    }

    if (item == HOLD_EFFECT_CRITRATE_UP_SLOWER && ov12_0225561C(ctx, battlerIdTarget) == TRUE) { // TODO: hold effect const is mislabeled
        hitChance = hitChance * (100 + itemMod) / 100;
    }

    if (ctx->battleMons[battlerIdAttacker].unk88.micleBerryFlag) {
        ctx->battleMons[battlerIdAttacker].unk88.micleBerryFlag = 0;
        hitChance = hitChance * 120 / 100;
    }

    if (ctx->fieldCondition & FIELD_CONDITION_GRAVITY) {
        hitChance = hitChance * 10 / 6;
    }

    // A Pokemon that likes the player as much as it can dodges a little more
    // than it otherwise would, which is one of the things friendship buys from
    // the sixth generation on. It only helps the player's own, and only where
    // it is not a battle where everyone is brought to the same footing.
    if (ctx->battleMons[battlerIdTarget].friendship == FRIENDSHIP_MAX && BattleSystem_GetFieldSide(battleSystem, battlerIdTarget) == 0 && !(BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_LINK | BATTLE_TYPE_FRONTIER))) {
        hitChance = hitChance < 10 ? 0 : hitChance - 10;
    }

#ifdef NEWGOLD_DIAG
    Diag_RollNext(DIAG_ROLL_HIT);
#endif
    if ((BattleSystem_Random(battleSystem) % 100) + 1 > hitChance) {
        ctx->moveStatusFlag |= MOVE_STATUS_MISSED;
    }

    return FALSE;
}

static BOOL IsTeamGuardMove(u16 guard) {
    return guard == MOVE_QUICK_GUARD || guard == MOVE_WIDE_GUARD || guard == MOVE_MAT_BLOCK || guard == MOVE_CRAFTY_SHIELD;
}

// Whether a guard raised with the move `guard` stops `move`. ownGuard is the
// target's own; otherwise it is its ally's, and only a team guard reaches
// that far. As the reference (BattleController_BeforeMove.c): Protect,
// Detect, Spiky Shield, Baneful Bunker and Max Guard stop everything; King's
// Shield, Obstruct, Silk Trap, Burning Bulwark and Mat Block only a move that
// does damage; Crafty Shield only a status move; Quick Guard only a move with
// raised priority; Wide Guard only a move that hits every adjacent opponent
// or every adjacent battler.
static BOOL GuardStopsMove(BattleContext *ctx, int battlerIdAttacker, u32 move, u16 guard, BOOL ownGuard) {
    BOOL status = BattleMoveTbl(ctx, move)->category == CATEGORY_STATUS;
    u16 range = BattleMoveTbl(ctx, move)->range;

    switch (guard) {
    case MOVE_PROTECT:
    case MOVE_DETECT:
    case MOVE_SPIKY_SHIELD:
    case MOVE_BANEFUL_BUNKER:
    case MOVE_MAX_GUARD:
        return ownGuard;
    case MOVE_KINGS_SHIELD:
    case MOVE_OBSTRUCT:
    case MOVE_SILK_TRAP:
    case MOVE_BURNING_BULWARK:
        return ownGuard && !status;
    case MOVE_MAT_BLOCK:
        return !status;
    case MOVE_CRAFTY_SHIELD:
        return status;
    case MOVE_QUICK_GUARD:
        return BattlerMovePriority(ctx, battlerIdAttacker, move) > 0;
    case MOVE_WIDE_GUARD:
        return range == RANGE_ADJACENT_OPPONENTS || range == RANGE_ALL_ADJACENT;
    default:
        return FALSE;
    }
}

static BOOL BattleSystem_CheckMoveEffect(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int move) {
    // Sky Drop's lift is the one charge turn that touches its target, and a
    // guard stops it as it would the hit (Pokemon Showdown's Sky Drop, with
    // Pokemon Central silent on it): the lift itself waits for the move to
    // get through (subscript 470).
    if ((ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && move != MOVE_SKY_DROP) {
        return FALSE;
    }

    // Unseen Fist and Piercing Drill go through a guard rather than round it:
    // a move that touches still lands, and the damage calculation then takes
    // three quarters of it off. The reference keeps Unseen Fist behind
    // UNSEEN_FIST_GENERATION and Piercing Drill behind nothing, but its own
    // config sets that generation high enough that both arms are live, so
    // neither is gated here.
    int attackerAbility = GetBattlerAbility(ctx, battlerIdAttacker);
    BOOL punchesThroughProtect = (attackerAbility == ABILITY_UNSEEN_FIST || attackerAbility == ABILITY_PIERCING_DRILL)
        && BattleMoveMakesContact(ctx, move) == TRUE;

    if (ctx->turnData[battlerIdTarget].protectFlag
        && BattleMoveTbl(ctx, move)->unkB & (1 << 1)
        && punchesThroughProtect == FALSE
        && (move != MOVE_CURSE || CurseUserIsGhost(ctx, move, battlerIdAttacker) == TRUE)
        && (!BattleCtx_IsIdenticalToCurrentMove(ctx, move) || ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT)) {
        // What the guard stops depends on the move it was raised with, the
        // target's own or its ally's, as the reference's CheckProtectedBySelf
        // and CheckProtectedByAlly decide. A guard the ally lent does not
        // make the target's last move count as one of its own.
        BOOL byAlly = GuardStopsMove(ctx, battlerIdAttacker, move, ctx->moveNoProtect[battlerIdTarget ^ 2], FALSE);
        BOOL bySelf = !ctx->turnData[battlerIdTarget].gainedProtectFlagFromAlly
            && GuardStopsMove(ctx, battlerIdAttacker, move, ctx->moveNoProtect[battlerIdTarget], TRUE);

        if (byAlly || bySelf) {
            // The move named in the line subscript 7 prints: none for "{0}
            // protected itself!", the team guard's for "{1} protected {0}!".
            if (bySelf) {
                ctx->moveTemp = IsTeamGuardMove(ctx->moveNoProtect[battlerIdTarget]) ? ctx->moveNoProtect[battlerIdTarget] : 0;
            } else {
                ctx->moveTemp = ctx->moveNoProtect[battlerIdTarget ^ 2];
            }
            UnlockBattlerOutOfCurrentMove(battleSystem, ctx, battlerIdAttacker);
            ctx->moveStatusFlag |= MOVE_STATUS_PROTECTED;
            return FALSE;
        }
    }

    // A Tatsugiri in its Dondozo's mouth is out of every move's reach, No
    // Guard, Lock-On and a Poison type's Toxic included (Pokemon Central,
    // Torre di Comando); a move that aims at a side or the field, not at it,
    // is not turned away. The miss prints what any miss prints here,
    // HeartGold's lines (subscript 7): "{0}'s attack missed!", "{0} avoided
    // the attack!" for a move aimed at more than one. The latest games have
    // only the second, for every miss, this one included -- Showdown's gen-9
    // hitStepInvulnerabilityEvent sends a commanding target's miss as any
    // other ('-miss' with the target), and Scarlet and Violet's English text
    // (sv-text, common_eng.txt 6341 to 6344) has no other miss line.
    if (ctx->moveConditions[battlerIdTarget].commanding && battlerIdTarget != battlerIdAttacker
        && !(BattleMoveTbl(ctx, move)->range & (RANGE_USER | RANGE_USER_SIDE | RANGE_FIELD | RANGE_OPPONENT_SIDE))) {
        ctx->moveStatusFlag |= MOVE_STATUS_SEMI_INVULNERABLE;
        return FALSE;
    }

    // Toxic never misses when a Poison type uses it, from the sixth
    // generation on -- a target in the air or underground included, which is
    // why the return comes before the semi-invulnerability check below. The
    // reference asks this first of its sure hits (CalcAccuracy), and counts a
    // Poison type given as a third type.
    if (move == MOVE_TOXIC
        && (ctx->battleMons[battlerIdAttacker].type1 == TYPE_POISON
            || ctx->battleMons[battlerIdAttacker].type2 == TYPE_POISON
            || ctx->battleMons[battlerIdAttacker].type3 == TYPE_POISON)) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
        return FALSE;
    }

    if (!(ctx->battleStatus & BATTLE_STATUS_FLAT_HIT_RATE) // TODO: Is this flag a debug flag to ignore hit rates..?
        && ((ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON
                && ctx->battleMons[battlerIdTarget].unk88.battlerIdLockOn == battlerIdAttacker)
            || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_NO_GUARD
            || GetBattlerAbility(ctx, battlerIdTarget) == ABILITY_NO_GUARD
            || ctx->moveConditions[battlerIdTarget].glaiveRush)) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
        return FALSE;
    }

    // Hurricane and the three Storms never miss in the rain, as Thunder. The
    // weather is the one the attacker's move sees: a Mega Sol user's is sun;
    // not against a Utility Umbrella holder (Superombrello).
    if (BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget) & FIELD_CONDITION_RAIN_ALL
        && (BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_THUNDER
            || BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_HURRICANE
            || BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_BLEAKWIND_STORM
            || BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_WILDBOLT_STORM
            || BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_SANDSEAR_STORM)) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
    }
    if (BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker) & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL) && BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_BLIZZARD) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
    }

    // A stamping move never misses a Pokemon that has used Minimize
    // (other_battle_calculators.c:2892).
    if ((ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_MINIMIZE) && BattleMoveStampsOnMinimize(move)) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
    }

    // Earthquake and Fissure find a Pokemon underground, Surf and Whirlpool
    // one under the water, by the move (the reference's
    // BattleController_CheckSemiInvulnerability) rather than by a flag their
    // effect scripts set, as the other moves that reach them still do.
    // Fissure shares its script with the other one-hit moves, which do not
    // reach it (Pokemon Central, Abisso, from the second generation).
    BOOL reachesDig = (ctx->battleStatus & BATTLE_STATUS_HIT_DIG) || move == MOVE_EARTHQUAKE || move == MOVE_FISSURE;
    BOOL reachesDive = (ctx->battleStatus & BATTLE_STATUS_HIT_DIVE) || move == MOVE_SURF || move == MOVE_WHIRLPOOL;

    if (!(ctx->moveStatusFlag & MOVE_STATUS_BYPASSED_ACCURACY)
        && BattleMoveTbl(ctx, ctx->moveNoCur)->range != RANGE_OPPONENT_SIDE
        && ((!(ctx->battleStatus & BATTLE_STATUS_HIT_FLY) && ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_FLY)
            || (!(ctx->battleStatus & BATTLE_STATUS_SHADOW_FORCE) && ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_PHANTOM_FORCE)
            || (!reachesDig && ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_DIG)
            || (!reachesDive && ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_DIVE))) {
        ctx->moveStatusFlag |= MOVE_STATUS_SEMI_INVULNERABLE;
    }
    return FALSE;
}

static BOOL ov12_0224C204(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (ctx->battlerIdTarget == BATTLER_NONE) {
        return FALSE;
    }

    // Magic Bounce is Magic Coat the Pokemon was born with: the same move
    // flag, the same reflection, the same line of text -- the reference runs
    // its bounce through this very script. The ability stands down when the
    // coat is already up, and it cannot reach something halfway underground.
    // What is not here is the reference's doubles apparatus, where a
    // field-wide move can be bounced by both opponents in turn.
    BOOL bouncedByAbility = !ctx->turnData[ctx->battlerIdTarget].magicCoatFlag
        && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_MAGIC_BOUNCE) == TRUE
        && !(ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_SEMI_INVULNERABLE);

    if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && (ctx->turnData[ctx->battlerIdTarget].magicCoatFlag || bouncedByAbility) && (BattleMoveTbl(ctx, ctx->moveNoCur)->unkB & 4)) {
        ctx->turnData[ctx->battlerIdTarget].magicCoatFlag = 0;
        ctx->moveNoProtect[ctx->battlerIdAttacker] = 0;
        ctx->moveNoBattlerPrev[ctx->battlerIdAttacker] = ctx->moveNoTemp;
        ctx->moveNoPrev = ctx->moveNoTemp;
        ctx->battleStatus |= BATTLE_STATUS_NO_MOVE_SET;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MAGIC_COAT);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        CheckIgnorePressure(ctx, ctx->battlerIdTarget, ctx->battlerIdAttacker);
        return TRUE;
    }

    for (i = 0; i < maxBattlers; i++) {
        battlerId = ctx->turnOrder[i];
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && ctx->turnData[battlerId].snatchFlag && BattleMoveTbl(ctx, ctx->moveNoCur)->unkB & 8) {
            ctx->battlerIdTemp = battlerId;
            ctx->turnData[battlerId].snatchFlag = 0;
            if (!(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET)) {
                ctx->moveNoProtect[ctx->battlerIdAttacker] = 0;
                ctx->moveNoBattlerPrev[ctx->battlerIdAttacker] = ctx->moveNoTemp;
                ctx->moveNoPrev = ctx->moveNoTemp;
                ctx->battleStatus |= BATTLE_STATUS_NO_MOVE_SET;
            }
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SNATCH);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            CheckIgnorePressure(ctx, battlerId, ctx->battlerIdAttacker);
            return TRUE;
        }
    }

    return FALSE;
}

static void BattleControllerPlayer_RunScript(BattleSystem *battleSystem, BattleContext *ctx) {
    if (RunBattleScript(battleSystem, ctx) == TRUE) {
        ctx->scriptSeqNo = 0;
        ctx->command = ctx->commandNext;
    }
}

// Stance Change (BattleController_BeforeMove.c:1522): before an Aegislash
// uses a move, King's Shield puts it in its Shield Forme and any move with
// power in its Blade Forme. The species to become, or SPECIES_NONE. The
// ability is read as hg-engine reads it, not through GetBattlerAbility, since
// nothing suppresses it; a transformed battler keeps the form it copied.
static u16 Battler_StanceChangeForm(BattleContext *ctx, int battlerId, u16 move) {
    if (ctx->battleMons[battlerId].ability != ABILITY_STANCE_CHANGE || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_NONE;
    }
    if (move == MOVE_KINGS_SHIELD && ctx->battleMons[battlerId].species == SPECIES_AEGISLASH_BLADE) {
        return SPECIES_AEGISLASH;
    }
    if (BattleMoveTbl(ctx, move)->power != 0 && ctx->battleMons[battlerId].species == SPECIES_AEGISLASH) {
        return SPECIES_AEGISLASH_BLADE;
    }
    return SPECIES_NONE;
}

static BOOL TryStanceChange(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 form = Battler_StanceChangeForm(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

    if (form == SPECIES_NONE) {
        return FALSE;
    }
    ctx->battlerIdTemp = ctx->battlerIdAttacker;
    BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdAttacker, form, FALSE);
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FORM_CHANGE);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    return TRUE;
}

// Desolate Land's extremely harsh sunlight evaporates a damaging Water move,
// and Primordial Sea's heavy rain puts out a damaging Fire move, once it has
// been used and its PP spent (Pokemon Central, Terra Estrema, Mare
// Primordiale; hg-engine's BattleController_CheckPrimalWeather). The weather
// is the one the user's move sees: none under Cloud Nine or Air Lock, and a
// Mega Sol user's own sunlight whatever is up.
static BOOL PrimalWeatherStopsMove(u32 weather, int category, int type) {
    return category != CATEGORY_STATUS
        && (((weather & FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT) && type == TYPE_WATER)
            || ((weather & FIELD_CONDITION_HEAVY_RAIN) && type == TYPE_FIRE));
}

// Natural Gift takes its power and type from the user's Berry, and fails
// without one it can use -- none, or one Klutz, Embargo or Magic Room keeps
// from it -- once its PP is spent, as the engine asks it
// (BattleController_CheckMoveFailures1 at d0380a487; Pokemon Central,
// Dononaturale). The primal weathers and Powder below see the Berry's type,
// and stop the move with the Berry kept, and the damage has its power on
// both of Parental Bond's strikes. The Berry goes once the move is over
// (NaturalGiftSpendsBerry).
static void TryNaturalGift(BattleContext *ctx) {
    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect != MOVE_EFFECT_NATURAL_GIFT) {
        return;
    }
    ctx->movePower = GetNaturalGiftPower(ctx, ctx->battlerIdAttacker);
    if (ctx->movePower == 0) {
        ctx->moveStatusFlag |= MOVE_STATUS_FAILED;
    } else {
        ctx->moveType = GetNaturalGiftType(ctx, ctx->battlerIdAttacker);
    }
}

// Damp keeps anyone from blowing up while its holder stands: Self-Destruct,
// Explosion, Misty Explosion and Mind Blown fail with the holder's line once
// their PP is spent, where the engine asks it (its
// BattleController_CheckAbilityFailures1 at d0380a487: with a target to go
// at, after the move failures and before Protean). Mold Breaker gets past it. The line names the first
// holder in the order the battlers act, put in battlerIdAbility. A move with
// no PP left has failed already, and says so (ov12_0224B1FC's
// MOVE_STATUS_NO_PP, where the engine stops at its PP step).
static BOOL DampStopsMove(BattleSystem *battleSystem, BattleContext *ctx) {
    int i, battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (ctx->battlerIdTarget == BATTLER_NONE
        || (ctx->moveStatusFlag & MOVE_STATUS_FAIL)
        || (BattleMoveTbl(ctx, ctx->moveNoCur)->effect != MOVE_EFFECT_HALVE_DEFENSE && ctx->moveNoCur != MOVE_MIND_BLOWN)) {
        return FALSE;
    }
    for (i = 0; i < maxBattlers; i++) {
        battlerId = ctx->turnOrder[i];
        if (ctx->battleMons[battlerId].hp && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ABILITY_DAMP) == TRUE) {
            ctx->battlerIdAbility = battlerId;
            return TRUE;
        }
    }
    return FALSE;
}

// Self-Destruct, Explosion and Misty Explosion put their user at 0 HP as they
// are used, before a target is looked for (the engine's
// BEFORE_MOVE_STATE_SET_EXPLOSION_SELF_DESTRUCT_FLAG,
// BattleController_BeforeMove.c at d0380a487). Its bar stays full until the
// move has done its damage, when ov12_0224D1DC faints it (subscript 277). Not
// a move out of PP, which is not used at all (ov12_0224B1FC).
static void TrySelfDestruct(BattleSystem *battleSystem, BattleContext *ctx) {
    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_HALVE_DEFENSE && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
        ctx->battleStatus |= MaskOfFlagNo(ctx->battlerIdAttacker) << BATTLE_STATUS_SELFDESTRUCTED_SHIFT;
        ctx->battleMons[ctx->battlerIdAttacker].hp = 0;
        CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdAttacker);
    }
}

// What the moves that answer one another in a turn need to know of the move
// now being used: it has come through everything that can stop a Pokemon
// acting, and has spent its PP, whether or not it goes on to fail.
static void NoteMoveUsed(BattleSystem *battleSystem, BattleContext *ctx) {
    // A move that hits several comes back through here for each target after
    // the first, with unk_2184 at 13 to pass the checks it has been through
    // (ov12_0224D03C); it was used once, and noted with its first. A move
    // another move called was noted as the move that called it, but chooses
    // its own category: a called Photon Geyser or Shell Side Arm goes
    // physical as a chosen one does (Pokemon Central, Geyser Fotonico,
    // Armaguscio).
    if (ctx->unk_2184 & MULTIHIT_CALLED_MOVE) {
        ChooseMoveCategory(battleSystem, ctx);
        return;
    }
    if (ctx->unk_2184 == 13) {
        return;
    }
    ctx->moveUsedBefore = ctx->moveUsedLast;
    ctx->moveUsedLast = ctx->moveNoCur;
    ChooseMoveCategory(battleSystem, ctx);
    // Echoed Voice counts a turn a move of it was used in, failed or not;
    // one the user could not act in does not count (Pokemon Central,
    // Echeggiavoce).
    if (ctx->moveNoCur == MOVE_ECHOED_VOICE) {
        ctx->echoedVoiceUsed = TRUE;
    }
    // Round calls every other Pokemon that chose it and has yet to move to
    // use it next, the fastest of them first (Pokemon Central, Coro): After
    // You's mark, which the order of those still to move is sorted by after
    // every action.
    if (ctx->moveNoCur == MOVE_ROUND) {
        int battlerId;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

        ctx->roundUsers |= MaskOfFlagNo(ctx->battlerIdAttacker);
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            if (battlerId != ctx->battlerIdAttacker && ctx->battleMons[battlerId].hp && ov12_0225561C(ctx, battlerId) == FALSE
                && ctx->playerActions[battlerId].inputSelection == BATTLE_INPUT_FIGHT && !ctx->turnData[battlerId].struggleFlag
                && ctx->battleMons[battlerId].moves[ctx->movePos[battlerId]] == MOVE_ROUND) {
                ctx->turnData[battlerId].forceExecutionOrder = EXECUTION_ORDER_AFTER_YOU;
            }
        }
    }
}

static void ov12_0224C38C(BattleSystem *battleSystem, BattleContext *ctx) {
    switch (ctx->unk_48) {
    case 0:
        ov12_0224BCA4(battleSystem, ctx);
        ctx->unk_48++;
        return;
    case 1:
        if (!(ctx->unk_2184 & 4) && ov12_0224B528(battleSystem, ctx) == TRUE) {
            return;
        }
        ctx->unk_48++;
        // fallthrough
    case 2: {
        int ret;
        int script;
        if (!(ctx->unk_2184 & 1)) {
            ret = TryDisobedience(battleSystem, ctx, &script);
            if (ret) {
                switch (ret) {
                case 1:
                    ctx->commandNext = CONTROLLER_COMMAND_39;
                    break;
                case 2:
                    ctx->commandNext = ctx->command;
                    break;
                case 3:
                    ctx->commandNext = CONTROLLER_COMMAND_34;
                    break;
                }
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                return;
            }
        }
    }
        ctx->unk_48++;
        // fallthrough
    case 3:
        // Before the PP goes, where hg-engine's before-move sequence has it;
        // the check comes round again once the form has changed, and passes.
        if (TryStanceChange(battleSystem, ctx) == TRUE) {
            return;
        }
        // A called move's PP and Pressure were its caller's (CallMove).
        if (!(ctx->unk_2184 & (MULTIHIT_SKIP_PP_DECREMENT | MULTIHIT_CALLED_MOVE)) && ov12_0224B1FC(battleSystem, ctx) == TRUE) {
            return;
        }
        TryNaturalGift(ctx);
        if (PrimalWeatherStopsMove(BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker), BattleMoveTbl(ctx, ctx->moveNoCur)->category,
                BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur))
            == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_PRIMAL_WEATHER_STOPS_MOVE);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_25;
            // As a move the before-move checks stop, Powder's among them.
            ctx->battleStatus |= BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE;
            ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
            return;
        }
        // Powder: a Fire move by a Pokemon covered in it goes off in its face
        // instead, for a quarter of its HP unless it has Magic Guard. The move
        // is spent first: the reference asks this among its move failures,
        // after the PP and the primal weathers (BattleController_CheckMoveFailures1).
        if (ctx->moveConditions[ctx->battlerIdAttacker].powderBlockingFireMove && BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur) == TYPE_FIRE) {
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            ctx->hpCalc = 0;
            if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 4);
            }
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TAKE_POWDER_DAMAGE);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_25;
            ctx->battleStatus |= BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE;
            ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
            return;
        }
        if (DampStopsMove(battleSystem, ctx) == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_DAMP);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_25;
            ctx->battleStatus |= BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE;
            ctx->moveStatusFlag |= MOVE_STATUS_NO_MORE_WORK;
            return;
        }
        ctx->unk_48++;
        // fallthrough
    case 4: {
        // Protean and Libero make the user whatever it is about to throw, once
        // per appearance -- the flag that remembers it is cleared on switch-in.
        // The types are written here rather than in the script because there is
        // no third-type slot a script can reach. Nothing distinguishes the two
        // abilities anywhere in the reference.
        int ability = ctx->battleMons[ctx->battlerIdAttacker].ability;
        u8 moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

        if ((ability == ABILITY_PROTEAN || ability == ABILITY_LIBERO)
            && moveType != TYPE_MYSTERY
            && !(ctx->battleMons[ctx->battlerIdAttacker].type1 == moveType && ctx->battleMons[ctx->battlerIdAttacker].type2 == moveType && ctx->battleMons[ctx->battlerIdAttacker].type3 == TYPE_NONE)
            && ctx->battleMons[ctx->battlerIdAttacker].abilityActivatedFlag == FALSE) {
            ctx->battleMons[ctx->battlerIdAttacker].type1 = moveType;
            ctx->battleMons[ctx->battlerIdAttacker].type2 = moveType;
            ctx->battleMons[ctx->battlerIdAttacker].type3 = TYPE_NONE;
            ctx->battleMons[ctx->battlerIdAttacker].abilityActivatedFlag = TRUE;
            ctx->msgTemp = moveType;
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_PROTEAN);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }
        ctx->unk_48++;
        // fallthrough
    case 5:
        TrySelfDestruct(battleSystem, ctx);
        if (ov12_0224B398(battleSystem, ctx) == TRUE) {
            return;
        }
        ctx->unk_48++;
        // fallthrough
    case 6:
        if (!(ctx->unk_2184 & (1 << 7)) && ov12_0224C204(battleSystem, ctx) == TRUE) {
            return;
        }
        ctx->unk_48++;
        // fallthrough
    case 7:
        ov12_02250A18(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur);
        ctx->unk_48 = 0;
    }

    NoteMoveUsed(battleSystem, ctx);
    if (ctx->moveStatusFlag & MOVE_STATUS_FAIL) {
        ctx->command = CONTROLLER_COMMAND_26;
    } else {
        ctx->battleStatus2 |= BATTLE_STATUS2_MOVE_SUCCEEDED;
        // A Cramorant going under with Dive catches its prey on the dive's
        // first turn, whether or not the dive then lands.
        if (ctx->moveNoCur == MOVE_DIVE && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
            Battler_GulpMissileCatch(ctx, ctx->battlerIdAttacker);
        }
        TryStartParentalBond(battleSystem, ctx);
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_24;
        ov12_02252E30(battleSystem, ctx);
    }
    // The Metronome item counted the move that called this one, and counts a
    // move that hits several Pokemon once (Pokemon Central, Plessimetro): the
    // later targets come back here with unk_2184 at 13 (ov12_0224D03C).
    if (!(ctx->unk_2184 & MULTIHIT_CALLED_MOVE) && ctx->unk_2184 != MULTIHIT_HIT_MULTIPLE_TARGETS) {
        ov12_022565E0(battleSystem, ctx);
    }
}

static void ov12_0224C4D8(BattleSystem *battleSystem, BattleContext *ctx) {
    switch (ctx->unk_4C) {
    case 0:
        ctx->unk_4C++;
        if (ov12_0224B398(battleSystem, ctx) == TRUE) {
            return;
        }
        // fallthrough
    case 1:
        ctx->unk_4C++;
        if (ov12_02250BBC(battleSystem, ctx) == TRUE) {
            return;
        }
        // fallthrough
    case 2:
        if (!(ctx->unk_2184 & 0x20) && ctx->battlerIdTarget != BATTLER_NONE && BattleSystem_CheckMoveHit(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur) == TRUE) {
            return;
        }
        ctx->unk_4C++;
        // fallthrough
    case 3:
        if (!(ctx->unk_2184 & 0x40) && ctx->battlerIdTarget != BATTLER_NONE && BattleSystem_CheckMoveEffect(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur) == TRUE) {
            return;
        }
        ctx->unk_4C++;
        // fallthrough
    case 4:
        if (!(ctx->unk_2184 & 2) && ctx->battlerIdTarget != BATTLER_NONE && ov12_0224B498(battleSystem, ctx) == TRUE) {
            return;
        }
        ctx->unk_4C++;
        // fallthrough
    case 5:
        if (!(ctx->unk_2184 & 0x10) && ctx->battlerIdTarget != BATTLER_NONE && ov12_0224BC2C(battleSystem, ctx) == TRUE) {
            return;
        }
        ctx->unk_4C++;
        // fallthrough
    case 6:
        ctx->unk_4C = 0;
        break;
    }
    ctx->command = CONTROLLER_COMMAND_25;
}

static void ov12_0224C5C8(BattleSystem *battleSystem, BattleContext *ctx) {
    int script;

    if (ov12_022503EC(battleSystem, ctx, &script) == TRUE) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_26;
    } else {
        ctx->command = CONTROLLER_COMMAND_26;
    }
}

// A Blunder Policy answers a move of its holder's that missed on the accuracy
// roll alone: the Speed rises two stages and the policy is spent. The
// reference has the case and a TODO in its place
// (ServerDoPostMoveEffects.c:1475 at d0380a487), so this follows Pokemon
// Central (Fiascopolizza): not for a one-hit KO move, not for a target out of
// reach underground or in the air, not for the later hits of Triple Kick and
// its kind (those leave by the multi-hit branch before this is asked), and
// not with the Speed already at +6 -- or at -6 with Contrary, which turns the
// raise into a drop. A miss is only the roll's when nothing else stopped the
// move: a guard, an immunity or a failure is not the policy's business.
static BOOL BlunderPolicyAnswersMiss(BattleContext *ctx) {
    int attacker = ctx->battlerIdAttacker;
    int speed = ctx->battleMons[attacker].statChanges[STAT_SPEED];

    if (GetBattlerHeldItemEffect(ctx, attacker) != HOLD_EFFECT_BOOST_SPEED_ON_MISS
        || (ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT) != MOVE_STATUS_MISSED
        || BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_ONE_HIT_KO
        || ctx->battleMons[attacker].hp == 0) {
        return FALSE;
    }
    if (GetBattlerAbility(ctx, attacker) == ABILITY_CONTRARY) {
        return speed > 0;
    }
    return speed < 12;
}

static void ov12_0224C5F8(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->moveStatusFlag & MOVE_STATUS_NO_MORE_WORK) {
        ctx->command = CONTROLLER_COMMAND_35;
    } else if (ctx->moveStatusFlag & MOVE_STATUS_NO_PP) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NO_PP);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_39;
    } else if (ctx->unk_2180 && (ctx->moveStatusFlag & MOVE_STATUS_MISSED)) {
        ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;
        ctx->moveStatusFlag |= MOVE_STATUS_MULTI_HIT_DISRUPTED;
        ctx->command = CONTROLLER_COMMAND_29;
    } else if (ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BlunderPolicyAnswersMiss(ctx) == TRUE ? BATTLE_SUBSCRIPT_BLUNDER_POLICY : BATTLE_SUBSCRIPT_MISSED);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_34;
    } else {
        ctx->command = CONTROLLER_COMMAND_27;
    }
}

// Whether a battler has any stage above 0, for Spectral Thief to take.
static BOOL Battler_HasRaisedStage(BattleContext *ctx, int battlerId) {
    int stat;

    for (stat = STAT_ATK; stat < NUM_BATTLE_STATS; stat++) {
        if (ctx->battleMons[battlerId].statChanges[stat] > 6) {
            return TRUE;
        }
    }
    return FALSE;
}

static void ov12_0224C678(BattleSystem *battleSystem, BattleContext *ctx) {
    // Spectral Thief takes the target's raised stages as it is about to
    // connect and strikes with them (Pokemon Central, Ombrafurto): subscript
    // 458 comes back here with nothing left to take.
    if (ctx->moveNoCur == MOVE_SPECTRAL_THIEF && ctx->battlerIdTarget != BATTLER_NONE && Battler_HasRaisedStage(ctx, ctx->battlerIdTarget)) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SPECTRAL_THIEF);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_27;
        return;
    }
    // The move is about to connect, so a Gem that is powering it is spent
    // now, before the move's animation: "The Fire Gem strengthened Ember's
    // power!" after the attack message, as the reference's gem subscript has
    // it (BattleController_BeforeMove.c:1103 at d0380a487, which spends it
    // only when the move hits something). The command comes back here with
    // the Gem gone and goes on; a second target or hit finds no Gem to spend
    // and keeps the boost.
    //
    // A move whose damage CalcDamage does not work out -- a fixed amount,
    // Seismic Toss, Super Fang, Endeavor, a one-hit KO -- has not been asked
    // about the Gem yet, and is asked here: the reference decides the Gem
    // before any move and spends it on these too, with nothing to power.
    if (!ctx->gemBoostingMove) {
        TrySetGemBoost(ctx);
    }
    if (ctx->gemBoostingMove && GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_POWERING_UP_MOVE_ONCE) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_GEM);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_27;
        return;
    }
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_USE_MOVE);
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    ctx->commandNext = CONTROLLER_COMMAND_HP_CALC;
}

static void BattleControllerPlayer_HpCalc(BattleSystem *battleSystem, BattleContext *ctx) {
    int item;
    int itemMod;

    if (ctx->moveStatusFlag & MOVE_STATUS_ONE_HIT_KO) { // TODO: MOVE_STATUS_OHKO
        ctx->damage = ctx->battleMons[ctx->battlerIdTarget].maxHp * -1;
    }
    if (ctx->damage != 0) {
        item = GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget);
        itemMod = GetHeldItemModifier(ctx, ctx->battlerIdTarget, 0);

        GF_ASSERT(ctx->damage < 0);

        if (BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) == BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget)) {
            BattleController_EmitIncrementGameStat(battleSystem, ctx->battlerIdAttacker, 0, GAME_STAT_ALLIES_DAMAGED);
        }

        ctx->unk_30F4[ctx->battlerIdTarget] = ctx->battlerIdAttacker;

        if (SubstituteTakesHit(ctx, ctx->battlerIdTarget) && ctx->damage < 0) {
            if (ctx->battleMons[ctx->battlerIdTarget].unk88.substituteHp + ctx->damage <= 0) {
                ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage += ctx->battleMons[ctx->battlerIdTarget].unk88.substituteHp * -1;
                ctx->battleMons[ctx->battlerIdTarget].status2 &= ~STATUS2_SUBSTITUTE;
                ctx->hitDamage = ctx->battleMons[ctx->battlerIdTarget].unk88.substituteHp * -1;
                ctx->battleMons[ctx->battlerIdTarget].unk88.substituteHp = 0;
            } else {
                ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage += ctx->damage;
                ctx->battleMons[ctx->battlerIdTarget].unk88.substituteHp += ctx->damage;
                ctx->hitDamage = ctx->damage;
            }
            ctx->selfTurnData[ctx->battlerIdTarget].unk14 |= 8;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HIT_SUBSTITUTE);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_29;
        } else {
            // False Swipe
            if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_LEAVE_WITH_1_HP && ctx->battleMons[ctx->battlerIdTarget].hp + ctx->damage <= 0) {
                ctx->damage = (ctx->battleMons[ctx->battlerIdTarget].hp - 1) * -1;
            }

            if (!ctx->turnData[ctx->battlerIdTarget].endureFlag) {
                if (item == HOLD_EFFECT_MAYBE_ENDURE && (BattleSystem_Random(battleSystem) % 100) < itemMod) {
                    ctx->selfTurnData[ctx->battlerIdTarget].endureItemFlag = 1;
                }
                if (item == HOLD_EFFECT_ENDURE && ctx->battleMons[ctx->battlerIdTarget].hp == ctx->battleMons[ctx->battlerIdTarget].maxHp) {
                    ctx->selfTurnData[ctx->battlerIdTarget].endureItemFlag = 1;
                }
            }

            if (ctx->turnData[ctx->battlerIdTarget].endureFlag || ctx->selfTurnData[ctx->battlerIdTarget].endureItemFlag) {
                if (ctx->battleMons[ctx->battlerIdTarget].hp + ctx->damage <= 0) {
                    ctx->damage = (ctx->battleMons[ctx->battlerIdTarget].hp - 1) * -1;
                    if (ctx->turnData[ctx->battlerIdTarget].endureFlag) {
                        ctx->moveStatusFlag |= MOVE_STATUS_ENDURED;
                    } else {
                        ctx->moveStatusFlag |= MOVE_STATUS_ENDURED_ITEM;
                    }
                }
            }

            ctx->unk_30E4[ctx->battlerIdTarget] += ctx->damage;

            if (ctx->battleMons[ctx->battlerIdTarget].hitCount < 255) {
                ctx->battleMons[ctx->battlerIdTarget].hitCount++;
            }
            // Rage Fist counts every hit taken, each strike of a multi-hit
            // move one, whoever landed it; not a substitute's, and not what
            // confusion, recoil, the weather or a status costs, none of which
            // comes here (Pokemon Central, Pugno Furibondo).
            {
                u8 *hits = Battler_RageFistHits(battleSystem, ctx, ctx->battlerIdTarget);

                if (*hits < 6) {
                    (*hits)++;
                }
            }

            if (BattleMoveCategory(ctx, ctx->moveNoCur, ctx->battlerIdAttacker) == CATEGORY_PHYSICAL) {
                ctx->turnData[ctx->battlerIdTarget].physicalDamage[ctx->battlerIdAttacker] = ctx->damage;
                ctx->turnData[ctx->battlerIdTarget].battlerIdPhysicalDamage = ctx->battlerIdAttacker;
                ctx->turnData[ctx->battlerIdTarget].battlerBitPhysicalDamage |= MaskOfFlagNo(ctx->battlerIdAttacker);
                ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage = ctx->damage;
                ctx->selfTurnData[ctx->battlerIdTarget].battlerIdPhysicalAttacker = ctx->battlerIdAttacker;
            } else if (BattleMoveCategory(ctx, ctx->moveNoCur, ctx->battlerIdAttacker) == CATEGORY_SPECIAL) {
                ctx->turnData[ctx->battlerIdTarget].specialDamage[ctx->battlerIdAttacker] = ctx->damage;
                ctx->turnData[ctx->battlerIdTarget].battlerIdSpecialDamage = ctx->battlerIdAttacker;
                ctx->turnData[ctx->battlerIdTarget].battlerBitSpecialDamage |= MaskOfFlagNo(ctx->battlerIdAttacker);
                ctx->selfTurnData[ctx->battlerIdTarget].specialDamage = ctx->damage;
                ctx->selfTurnData[ctx->battlerIdTarget].battlerIdSpecialAttacker = ctx->battlerIdAttacker;
            }

            if (ctx->battleMons[ctx->battlerIdTarget].hp + ctx->damage <= 0) {
                ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage += ctx->battleMons[ctx->battlerIdTarget].hp * -1;
            } else {
                ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage += ctx->damage;
            }

            ctx->turnData[ctx->battlerIdTarget].unk34 = ctx->damage;
            ctx->turnData[ctx->battlerIdTarget].unk38 = ctx->battlerIdAttacker;
            // A foe's physical hit springs a Shell Trap set this turn before
            // its Pokemon has moved, which then goes straight after this move,
            // After You's way; not a hit Sheer Force boosted, nor one on a
            // substitute (Pokemon Central, Gusciotrappola).
            if (ctx->turnData[ctx->battlerIdTarget].shellTrapSet && ov12_0225561C(ctx, ctx->battlerIdTarget) == FALSE
                && BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) != BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget)
                && BattleMoveCategory(ctx, ctx->moveNoCur, ctx->battlerIdAttacker) == CATEGORY_PHYSICAL && !SheerForceTradedEffect(ctx)) {
                ctx->turnData[ctx->battlerIdTarget].shellTrapSprung = TRUE;
                ctx->turnData[ctx->battlerIdTarget].forceExecutionOrder = EXECUTION_ORDER_AFTER_YOU;
            }
            Battler_ArmRetreat(ctx, ctx->battlerIdTarget);
            // The user too, for what its own hit costs it -- recoil, a Life
            // Orb, a Rocky Helmet or Rough Skin on the other side (Pokemon
            // Central, Passoindietro); what a move of its own costs it
            // before any hit, Belly Drum's or Substitute's, does not come here.
            Battler_ArmRetreat(ctx, ctx->battlerIdAttacker);
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ctx->hpCalc = ctx->damage;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_HP);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_29;
            ctx->battleStatus |= BATTLE_STATUS_MOVE_SUCCESSFUL;
        }
    } else {
        ctx->command = CONTROLLER_COMMAND_29;
    }
}

static void ov12_0224CAA4(BattleSystem *battleSystem, BattleContext *ctx) {
    switch (ctx->unk_38) {
    case 0:
        switch (ctx->unk_3C) {
        case 0:
            ctx->unk_3C++;
            if (ov12_0224DF7C(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 1:
            ctx->unk_3C++;
            if (ov12_0224DF98(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 2:
            // What a flung item does, before the flinch and the move's other
            // effects (TryFlungItemEffect).
            ctx->unk_3C++;
            if (TryFlungItemEffect(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 3: {
            int script;

            ctx->unk_3C++;
            if (ov12_02250490(battleSystem, ctx, &script) == TRUE && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT)) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
            // fallthrough
        case 4:
            ctx->unk_3C++;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CHECK_SHAYMIN_FORM);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        case 5:
            ctx->unk_3C++;
            if (TryBuildRage(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 6: {
            int script;

            ctx->unk_3C++;
            if (CheckAbilityEffectOnHit(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
            // fallthrough
        case 7:
            ctx->unk_3C++;
            if (TryItemFlinch(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        default:
            break;
        }
        break;
    case 1:
        switch (ctx->unk_3C) {
        case 0:
            ctx->unk_3C++;
            if (ov12_0224DF7C(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 1:
            // What a flung item does, before the flinch and the move's other
            // effects (TryFlungItemEffect).
            ctx->unk_3C++;
            if (TryFlungItemEffect(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 2: {
            int script;

            ctx->unk_3C++;
            if (ov12_02250490(battleSystem, ctx, &script) == TRUE && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT)) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
            // fallthrough
        case 3:
            ctx->unk_3C++;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CHECK_SHAYMIN_FORM);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        case 4:
            ctx->unk_3C++;
            if (TryBuildRage(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 5: {
            int script;

            ctx->unk_3C++;
            if (CheckAbilityEffectOnHit(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
            // fallthrough
        case 6:
            ctx->unk_3C++;
            if (ov12_0224DF98(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        case 7:
            ctx->unk_3C++;
            if (TryItemFlinch(battleSystem, ctx) == TRUE) {
                return;
            }
            // fallthrough
        default:
            break;
        }
    }
    ctx->unk_3C = 0;
    ctx->command = CONTROLLER_COMMAND_31;
}

static void ov12_0224CC84(BattleSystem *battleSystem, BattleContext *ctx) {
}

// Besides a Fire move's, the hits that thaw a frozen target: Scald, Steam
// Eruption, Scorching Sands (Pokemon Central, Congelamento) and Matcha Gotcha
// (Spruzzate); and Hydro Steam, which Pokemon Central does not name and
// Showdown's gen-9 data marks thawsTarget, as it does the other four.
static BOOL MoveThawsTarget(u16 move) {
    return move == MOVE_SCALD || move == MOVE_STEAM_ERUPTION || move == MOVE_SCORCHING_SANDS
        || move == MOVE_MATCHA_GOTCHA || move == MOVE_HYDRO_STEAM;
}

// static
void ov12_0224CC88(BattleSystem *battleSystem, BattleContext *ctx) {
    switch (ctx->unk_40) {
    case 0: {
        int flag = 0;
        while (ctx->unk_44 < BattleSystem_GetMaxBattlers(battleSystem)) {
            if (!(ctx->battleMons[ctx->unk_44].moveEffectFlags & MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE) && (ctx->battleMons[ctx->unk_44].moveEffectFlagsTemp & MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE)) {
                ctx->battleMons[ctx->unk_44].moveEffectFlagsTemp &= ~MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_VANISH_OFF);
                ctx->battlerIdTemp = ctx->unk_44;
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->unk_44++;
            if (flag) {
                return;
            }
        }
    }
        ctx->unk_40++;
        ctx->unk_44 = 0;
        // fallthrough
    case 1:
        ctx->unk_40++;
        if (TrySyncronizeStatus(battleSystem, ctx, ctx->command) == TRUE) {
            return;
        }
        // fallthrough
    case 2: {
        int script = TryAbilityOnEntry(battleSystem, ctx);

        if (script) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }
        ctx->unk_40++;
        // fallthrough
    case 3:
        ctx->unk_40++;
        if (TryUseHeldItem(battleSystem, ctx, ctx->battlerIdAttacker) == TRUE) {
            return;
        }
        // fallthrough
    case 4:
        ctx->unk_40++;
        if (ctx->battlerIdTarget != BATTLER_NONE) {
            if (TryUseHeldItem(battleSystem, ctx, ctx->battlerIdTarget) == TRUE) {
                return;
            }
        }
        // fallthrough
    case 5: {
        int script;
        ctx->unk_40++;
        if (CheckItemEffectOnHit(battleSystem, ctx, &script) == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }
        // fallthrough
    case 6: {
        int moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

        ctx->unk_40++;

        // Check for unfreeze via move. Parental Bond's first strike leaves it
        // to the second (Pokemon Central, Amorefiliale), so a frozen target
        // cannot be burned by the strike that thawed it. The reference asks
        // for no Parental Bond at all, and so never thaws on its strikes.
        if (ctx->battlerIdTarget != BATTLER_NONE
            && (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_FREEZE)
            && !(ctx->moveStatusFlag & MOVE_STATUS_MULTI_HIT_DISRUPTED)
            && !ParentalBond_StrikeToCome(ctx)
            && ctx->battlerIdTarget != ctx->battlerIdAttacker
            && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage != 0 || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage != 0)
            && ctx->battleMons[ctx->battlerIdTarget].hp != 0
            && (moveType == TYPE_FIRE || MoveThawsTarget(ctx->moveNoCur))) {
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_THAW_OUT);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
    }
        // fallthrough
    case 7: {
        int battlerId;
        int flag = 0;
        int script;

        while (ctx->unk_44 < BattleSystem_GetMaxBattlers(battleSystem)) {
            battlerId = ctx->turnOrder[ctx->unk_44];
            if (ctx->switchInFlag & MaskOfFlagNo(battlerId)) {
                ctx->unk_44++;
                continue;
            }
            ctx->unk_44++;
            if (CheckUseHeldItem(battleSystem, ctx, battlerId, &script) == TRUE) {
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
                break;
            }
        }
        if (flag == 0) {
            ctx->unk_40++;
            ctx->unk_44 = 0;
        }
    }
        // fallthrough
    default:
        break;
    }

    ctx->unk_40 = 0;
    ctx->unk_44 = 0;
    ctx->command = CONTROLLER_COMMAND_32;
}

static void ov12_0224CF10(BattleSystem *battleSystem, BattleContext *ctx) {
}

static void ov12_0224CF14(BattleSystem *battleSystem, BattleContext *ctx) {
    // Parental Bond's first strike left its side effect to the second
    // (ov12_02250490), and Effect Spore has since put the user to sleep,
    // which ends the move here. What was left is done now, as after the last
    // strike: the move no longer strikes twice. When the second strike comes
    // -- a Chesto or Lum Berry woke the user straight away -- it does it
    // itself. The recoil is no side effect: it comes once the move is over
    // (TryRecoil), from the one strike's damage.
    //
    // A first strike after which the user fainted -- to Rough Skin, a Rocky
    // Helmet, a Jaboca Berry -- gives nothing back: Dragon Tail drags nothing
    // once its user has fainted (Pokemon Central, Codadrago). Smack Down's
    // fall and the terrain's end wait for no strike: they are post-move
    // steps (TryFallAfterHit, TerrainEnds).
    if (ctx->parentalBondDeferred != 0) {
        u32 deferred = ctx->parentalBondDeferred;
        int script;

        ctx->parentalBondDeferred = 0;
        if (ParentalBond_IsFirstStrike(ctx) && MultiHit_StoppedBySleep(ctx) && ctx->battleMons[ctx->battlerIdAttacker].hp != 0) {
            ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond = FALSE;
            ctx->unk_2174 = deferred;
            if (ov12_02250490(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
    }

    if (ctx->multiHitCountTemp != 0) {
        if (ctx->battlerIdFainted == BATTLER_NONE && !MultiHit_StoppedBySleep(ctx) && !(ctx->moveStatusFlag & MOVE_STATUS_MULTI_HIT_DISRUPTED)) {
            if (--ctx->multiHitCount) {
                ctx->unk_2180 = 1;
                ov12_02252D14(battleSystem, ctx);
                ctx->battleStatus &= ~BATTLE_STATUS_MOVE_ANIMATIONS_OFF;
                ctx->unk_2184 = ctx->checkMultiHit;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_0, ctx->moveNoCur);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_24;
            } else {
                ctx->msgTemp = ctx->multiHitCountTemp;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HIT_X_TIMES);
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->commandNext = CONTROLLER_COMMAND_34;
            }
        } else {
            if (ctx->battlerIdFainted != BATTLER_NONE || MultiHit_StoppedBySleep(ctx)) {
                ctx->msgTemp = ctx->multiHitCountTemp - ctx->multiHitCount + 1;
            } else {
                ctx->msgTemp = ctx->multiHitCountTemp - ctx->multiHitCount;
            }
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HIT_X_TIMES);
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ctx->commandNext = CONTROLLER_COMMAND_34;
        }
        BattleController_EmitBlankMessage(battleSystem);
    } else {
        ctx->command = CONTROLLER_COMMAND_34;
    }
}

static void ov12_0224D014(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->battleStatus & BATTLE_STATUS_FAINTED) {
        TryFaintMon(ctx, CONTROLLER_COMMAND_34, CONTROLLER_COMMAND_34, 0);
    } else {
        ctx->command = CONTROLLER_COMMAND_35;
    }
}

static void ov12_0224D03C(BattleSystem *battleSystem, BattleContext *ctx) {
    // The Metronome item counts a move that hits several Pokemon if it hit
    // one (Pokemon Central, Plessimetro), where ov12_02256694 sees only how
    // it did against the last.
    if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
        ctx->selfTurnData[ctx->battlerIdAttacker].metronomeLanded = TRUE;
    }
    if (ctx->battleStatus2 & BATTLE_STATUS2_MAGIC_COAT) {
        ctx->battleStatus2 &= ~BATTLE_STATUS2_MAGIC_COAT;
        ctx->battlerIdTarget = ctx->battlerIdAttacker;
        ctx->battlerIdAttacker = ctx->battlerIdMagicCoat;
    }

    ov12_0224DD74(battleSystem, ctx);

    if (BattleMoveTbl(ctx, ctx->moveNoCur)->range == RANGE_ADJACENT_OPPONENTS && !(ctx->battleStatus & BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE) && ctx->unk_217E < BattleSystem_GetMaxBattlers(battleSystem)) {
        ctx->unk_2184 = 13;
        int battlerId;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        OpponentData *opponent = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdAttacker);
        u8 flag = ov12_02261258(opponent);

        do {
            battlerId = ctx->turnOrder[ctx->unk_217E++];
            if (!(ctx->switchInFlag & MaskOfFlagNo(battlerId)) && ctx->battleMons[battlerId].hp != 0) {
                opponent = BattleSystem_GetOpponentData(battleSystem, battlerId);
                if (((flag & 1) && !(ov12_02261258(opponent) & 1)) || (!(flag & 1) && ov12_02261258(opponent) & 1)) {
                    ov12_02252D14(battleSystem, ctx);
                    ctx->battlerIdTarget = battlerId;
                    ctx->command = CONTROLLER_COMMAND_23;
                    break;
                }
            }
        } while (ctx->unk_217E < BattleSystem_GetMaxBattlers(battleSystem));

        BattleController_EmitBlankMessage(battleSystem);
    } else if (BattleMoveTbl(ctx, ctx->moveNoCur)->range == RANGE_ALL_ADJACENT && !(ctx->battleStatus & BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE) && ctx->unk_217E < BattleSystem_GetMaxBattlers(battleSystem)) {
        ctx->unk_2184 = 13;

        int battlerId;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

        do {
            battlerId = ctx->turnOrder[ctx->unk_217E++];
            if (!(ctx->switchInFlag & MaskOfFlagNo(battlerId)) && ctx->battleMons[battlerId].hp != 0) {
                if (battlerId != ctx->battlerIdAttacker) {
                    ov12_02252D14(battleSystem, ctx);
                    ctx->battlerIdTarget = battlerId;
                    ctx->command = CONTROLLER_COMMAND_23;
                    break;
                }
            }
        } while (ctx->unk_217E < BattleSystem_GetMaxBattlers(battleSystem));

        BattleController_EmitBlankMessage(battleSystem);
    } else {
        ctx->command = CONTROLLER_COMMAND_36;
    }
}

static void ov12_0224D1DC(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->battleStatus & BATTLE_STATUS_SELFDESTRUCTED) {
        ctx->battlerIdFainted = LowestFlagNo((ctx->battleStatus & BATTLE_STATUS_SELFDESTRUCTED) >> BATTLE_STATUS_SELFDESTRUCTED_SHIFT);
        ctx->battleStatus &= ~BATTLE_STATUS_SELFDESTRUCTED;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_AFTER_SELFDESTRUCT);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_37;
    } else {
        ctx->command = CONTROLLER_COMMAND_37;
    }
}

static void ov12_0224D224(BattleSystem *battleSystem, BattleContext *ctx) {
    if (!(ov12_0224E1BC(battleSystem, ctx) == TRUE)) {
        ctx->command = CONTROLLER_COMMAND_39;
    }
}

static void ov12_0224D238(BattleSystem *battleSystem, BattleContext *ctx) {
}

static void ov12_0224D23C(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 item = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker);
    // A dance Dancer copied locks a Choice item's holder only into a move it
    // knows and only if nothing locked it yet, and it is not the move the
    // dancer last used for Disable, Encore, Mimic, Spite or Sketch -- that
    // stays the last one it spent PP on (Pokemon Central, Sincrodanza).
    BOOL copied = ctx->dancing;
    BOOL copyLocks = !copied || (ctx->battleMons[ctx->battlerIdAttacker].unk88.moveNoChoice == 0
        && BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdAttacker], ctx->moveNoTemp) < MAX_MON_MOVES);
    // The user can have left in the middle of its move: U-turn and the other
    // pivot moves, Teleport, a Red Card, or its own Eject Pack or Emergency
    // Exit (U-turn's flag), Baton Pass or Shed Tail (the Baton Pass flag).
    // What stands in its slot now did not use the move, so it is neither
    // locked into it by a Choice item nor remembered as having used it last;
    // retail excused U-turn and Baton Pass from the lock alone.
    BOOL userGone = (ctx->battleStatus2 & BATTLE_STATUS2_UTURN) || (ctx->battleStatus & BATTLE_STATUS_BATON_PASS);

    if (!userGone && copyLocks && (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN || ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE)) {
        if (item == HOLD_EFFECT_CHOICE_ATK || item == HOLD_EFFECT_CHOICE_SPEED || item == HOLD_EFFECT_CHOICE_SPATK) {
            if (ctx->moveNoTemp != MOVE_STRUGGLE) {
                ctx->battleMons[ctx->battlerIdAttacker].unk88.moveNoChoice = ctx->moveNoTemp;
            }
        } else {
            ctx->battleMons[ctx->battlerIdAttacker].unk88.moveNoChoice = 0;
        }
    }

    if (!(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET)) {
        if (ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
            if (!userGone) {
                ctx->moveNoProtect[ctx->battlerIdAttacker] = ctx->moveNoCur;
            }
            ctx->moveNoPrev = ctx->moveNoTemp;
        } else {
            if (!userGone) {
                ctx->moveNoProtect[ctx->battlerIdAttacker] = 0;
            }
            ctx->moveNoPrev = 0;
        }
        if (!copied && !userGone) {
            if (ctx->battleStatus2 & BATTLE_STATUS2_MOVE_SUCCEEDED) {
                ctx->moveNoBattlerPrev[ctx->battlerIdAttacker] = ctx->moveNoTemp;
            } else {
                ctx->moveNoBattlerPrev[ctx->battlerIdAttacker] = 0;
            }
        }
    }

    if (!copied && !userGone && ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
        ctx->moveNoSketch[ctx->battlerIdAttacker] = ctx->moveNoTemp;
    }

    // Glaive Rush leaves its user open until it moves again.
    if (ctx->moveConditions[ctx->battlerIdAttacker].glaiveRush && ctx->moveNoCur != MOVE_GLAIVE_RUSH) {
        ctx->moveConditions[ctx->battlerIdAttacker].glaiveRush = FALSE;
    }

    ov12_0224DD74(battleSystem, ctx);
    ov12_02256694(battleSystem, ctx);
    ctx->command = CONTROLLER_COMMAND_40;
}

// Dancer (the reference's step 30 of ServerDoPostMoveEffects.c, 653 to 741 at
// d0380a487; Pokemon Central, Sincrodanza): when a Pokemon's dance move is
// over, every other Pokemon with the ability dances it too, in speed order,
// as a move of its own that takes no PP and does not count as the move it
// last used. It does not when the dance missed, did nothing to its target or
// changed no stat, or was snatched or reflected -- the reference copies
// whatever happened --
// nor from a copy, nor while
// the dancer is in the air or underground or fainted. Locked into another move
// by a Choice item, an Encore or a rampage, it dances and fails
// (Battler_DanceLocked). What stops any move still stops it: sleep, a freeze,
// paralysis, confusion, a flinch, a Taunt.
static BOOL Battler_CanDance(BattleContext *ctx, int battlerId) {
    BattleMon *mon = &ctx->battleMons[battlerId];

    return mon->hp != 0 && GetBattlerAbility(ctx, battlerId) == ABILITY_DANCER && !(mon->moveEffectFlags & MOVE_EFFECT_FLAG_SEMI_INVULNERABLE);
}

// A single-target dance goes back at the Pokemon that danced it, or, when
// that was the dancer's ally, at the ally's own target -- at the ally, if the
// dancer was that target. The rest aim as they would for anyone, a random
// one anew.
static int Dancer_Target(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int target = BATTLER_NONE;

    if (BattleMoveTbl(ctx, ctx->danceMove)->range == RANGE_SINGLE_TARGET) {
        if (BattleSystem_GetFieldSide(battleSystem, ctx->danceUser) != BattleSystem_GetFieldSide(battleSystem, battlerId)) {
            target = ctx->danceUser;
        } else {
            target = ctx->danceTarget == battlerId ? ctx->danceUser : ctx->danceTarget;
        }
        if (target != BATTLER_NONE && target != battlerId && ctx->battleMons[target].hp) {
            return target;
        }
    }
    return ov12_022506D4(battleSystem, ctx, battlerId, ctx->danceMove, 1, 0);
}

// A dance that changed nothing failed, and Dancer does not copy it (Pokemon
// Central, Sincrodanza: "la mossa non avrebbe effetto sull'utilizzatore",
// Swords Dance at the top). The dances that raise several stats say so with
// MOVE_STATUS_NO_MORE_WORK when every one is at the top; Swords Dance and
// Feather Dance change one stat, and the change's own failure flag is left
// from it.
static BOOL Dance_ChangedNothing(BattleContext *ctx) {
    int effect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;

    return (ctx->moveStatusFlag & MOVE_STATUS_NO_MORE_WORK)
        || ((effect == MOVE_EFFECT_ATK_UP_2 || effect == MOVE_EFFECT_ATK_DOWN_2) && (ctx->battleStatus & BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE));
}

static BOOL TryDancer(BattleSystem *battleSystem, BattleContext *ctx) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int i, battlerId;

    if (ctx->dancing) {
        ctx->dancing = FALSE;
    } else if ((ctx->battleStatus2 & BATTLE_STATUS2_MOVE_SUCCEEDED)
        && !(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT)
        && !(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET)
        && BattleMoveIsDance(ctx->moveNoCur)
        && !Dance_ChangedNothing(ctx)) {
        ctx->danceMove = ctx->moveNoCur;
        ctx->danceUser = ctx->battlerIdAttacker;
        ctx->danceTarget = ctx->battlerIdTarget;
        ctx->dancersPending = 0;
        for (i = 0; i < maxBattlers; i++) {
            if (i != ctx->battlerIdAttacker) {
                ctx->dancersPending |= MaskOfFlagNo(i);
            }
        }
    }

    for (i = 0; i < maxBattlers; i++) {
        battlerId = ctx->turnOrder[i];
        if (!(ctx->dancersPending & MaskOfFlagNo(battlerId))) {
            continue;
        }
        ctx->dancersPending &= ~MaskOfFlagNo(battlerId);
        if (!Battler_CanDance(ctx, battlerId)) {
            continue;
        }
        BattleContext_Init(ctx);
        ctx->dancing = TRUE;
        ctx->battlerIdAttacker = battlerId;
        ctx->moveNoTemp = ctx->danceMove;
        ctx->moveNoCur = ctx->danceMove;
        ctx->battlerIdTarget = Dancer_Target(battleSystem, ctx, battlerId);
        // Past the Quick Claw's line, the disobedience roll and the PP.
        ctx->unk_48 = 1;
        ctx->unk_2184 = MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_PP_DECREMENT;
        ctx->command = CONTROLLER_COMMAND_23;
        BattleController_EmitBlankMessage(battleSystem);
        return TRUE;
    }
    return FALSE;
}

// Instruct's target uses its last move again once the Instruct is over, at a
// target chosen afresh, with the move's PP spent -- Pressure aside -- and
// before anything else is asked (Pokemon Central, Imposizione). The move runs
// as a Dancer's copy does, as an action of its own in the Instruct's place.
static BOOL TryInstruct(BattleSystem *battleSystem, BattleContext *ctx) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int battlerId;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        u16 move;
        int index;

        if (!ctx->turnData[battlerId].instructed) {
            continue;
        }
        ctx->turnData[battlerId].instructed = FALSE;
        move = ctx->moveNoBattlerPrev[battlerId];
        index = BattleMon_GetMoveIndex(&ctx->battleMons[battlerId], move);
        if (ctx->battleMons[battlerId].hp == 0 || index >= MAX_MON_MOVES || ctx->battleMons[battlerId].movePPCur[index] == 0) {
            continue;
        }
        ctx->battleMons[battlerId].movePPCur[index]--;
        CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
        BattleContext_Init(ctx);
        ctx->battlerIdAttacker = battlerId;
        ctx->moveNoTemp = move;
        ctx->moveNoCur = move;
        ctx->battlerIdTarget = ov12_022506D4(battleSystem, ctx, battlerId, move, 1, 0);
        // Past the Quick Claw's line, the disobedience roll and the PP.
        ctx->unk_48 = 1;
        ctx->unk_2184 = MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_PP_DECREMENT;
        ctx->command = CONTROLLER_COMMAND_23;
        BattleController_EmitBlankMessage(battleSystem);
        return TRUE;
    }
    return FALSE;
}

// A Pokemon Sky Drop held is let go as soon as its user stops holding it
// (Pokemon Central, Cadutalibera). A user that faints or leaves lets go on
// the spot (ReleaseSkyDropTargetsOf); one brought down by Gravity or Smack
// Down, or stopped before the drop, does here, at the end of the action. The
// Pokemon comes down -- its sprite with it, ov12_0224E130 showing it once it
// is no longer in the air -- and acts, if it has not yet, when its turn
// comes. One Gravity has already brought down says nothing more.
static BOOL TrySkyDropRelease(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;

    for (battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
        if (ctx->moveConditions[battlerId].skyDropHolder && !Battler_HeldBySkyDrop(ctx, battlerId)) {
            ctx->moveConditions[battlerId].skyDropHolder = 0;
            if (ctx->battleMons[battlerId].hp && (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_FLY)) {
                ctx->battleMons[battlerId].moveEffectFlags &= ~MOVE_EFFECT_FLAG_FLY;
                ctx->battlerIdTemp = battlerId;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SKY_DROP_FREED);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return TRUE;
            }
        }
    }
    return FALSE;
}

static void ov12_0224D368(BattleSystem *battleSystem, BattleContext *ctx) {
    int script;
    int i;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (!(battleType & (BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK))) {
        if (CheckStatusHealAbility(battleSystem, ctx, ctx->battlerIdAttacker, 0) == TRUE) {
            return;
        }
        if (ctx->battlerIdTarget != BATTLER_NONE && CheckStatusHealAbility(battleSystem, ctx, ctx->battlerIdTarget, 0) == TRUE) {
            return;
        }
        if (ov12_0224DD18(ctx, ctx->command, ctx->command) == TRUE) {
            return;
        }
        if (ov12_0224D7EC(battleSystem, ctx) == TRUE) {
            return;
        }

        script = TryAbilityOnEntry(battleSystem, ctx);
        if (script) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
        // A Pokemon that came in during the action and was brought to half by
        // the entry hazards leaves again, once what it came in to is over.
        if (TryRetreatAbilityOutsideMove(battleSystem, ctx, &script) == TRUE) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return;
        }
        // An Eject Pack on a Pokemon an entry lowered a stat of during the
        // action -- Intimidate from what came in, Sticky Web on its way in,
        // a switch chosen for the turn included -- once the entries are over,
        // after Emergency Exit and Wimp Out (Pokemon Central, Zainofuga). Only
        // the fastest holder's acts, and what the move itself lowered was
        // answered once it was over or given up to the switch that came
        // first (ov12_0224E1BC), so the marks go with it.
        for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
            script = CheckEjectPack(battleSystem, ctx, ctx->turnOrder[i]);
            if (script != BATTLE_SUBSCRIPT_NONE) {
                ctx->statLoweredBattlers = 0;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return;
            }
        }
        if (TrySkyDropRelease(battleSystem, ctx) == TRUE) {
            return;
        }
        if (ov12_0224E130(battleSystem, ctx) == TRUE) {
            return;
        }
        ov12_0224DC0C(battleSystem, ctx);
        if (TryInstruct(battleSystem, ctx) == TRUE) {
            return;
        }
        if (TryDancer(battleSystem, ctx) == TRUE) {
            return;
        }
    }

    ctx->playerActions[ctx->executionOrder[ctx->executionIndex]].command = CONTROLLER_COMMAND_40;

    if (ctx->selfTurnData[ctx->battlerIdAttacker].trickRoomFlag) {
        SortExecutionOrderBySpeed(battleSystem, ctx);
        SortMonsBySpeed(battleSystem, ctx);
        ctx->executionIndex = 0;
    } else {
        ctx->executionIndex++;
        SortRemainingExecutionOrderBySpeed(battleSystem, ctx);
    }

    BattleContext_Init(ctx);

    ctx->command = CONTROLLER_COMMAND_8;
}

static void ov12_0224D448(BattleSystem *battleSystem, BattleContext *ctx) {
    if (TryFaintMon(ctx, ctx->command, ctx->command, 1) != TRUE) {
        ctx->command = CONTROLLER_COMMAND_40;
    }
}

static void ov12_0224D464(BattleSystem *battleSystem, BattleContext *ctx) {
    if (BattleSystem_GetBattleOutcomeFlags(battleSystem) & BATTLE_RESULT_TRY_FLEE) {
        ctx->command = CONTROLLER_COMMAND_44;
    } else if (BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_RESULT_LOSE || BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_RESULT_DRAW) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BATTLE_LOST);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_44;
    } else if (BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_OUTCOME_WIN) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BATTLE_WON);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_44;
    } else if (BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_RESULT_CAPTURED_MON) {
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = CONTROLLER_COMMAND_44;
    } else if (BattleSystem_GetBattleOutcomeFlags(battleSystem) == BATTLE_RESULT_PLAYER_FLED) {
        ctx->command = CONTROLLER_COMMAND_44;
    }
    ctx->battleEndFlag = TRUE;
}

static void ov12_0224D4F0(BattleSystem *battleSystem, BattleContext *ctx) {
    if (IsPaletteFadeFinished() == TRUE) {
        ctx->command = CONTROLLER_COMMAND_44;
    }
}

static void ov12_0224D504(BattleSystem *battleSystem, BattleContext *ctx) {
    Party *party;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (!(battleType & BATTLE_TYPE_LINK)) {
        party = BattleSystem_GetParty(battleSystem, BATTLER_PLAYER);
        Party_GivePokerusAtRandom(party);
        Party_SpreadPokerus(party);
    }

    if (battleType & BATTLE_TYPE_LINK) {
        sub_020376EC(22);
    }

    ctx->command = CONTROLLER_COMMAND_45;
}

static void ov12_0224D53C(BattleSystem *battleSystem, BattleContext *ctx) {
}

static BOOL ov12_0224D540(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 flag = FALSE;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    ControllerCommand cmd = ctx->command;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        ctx->unk_13C[battlerId] &= ~1;
        if (((battleType & BATTLE_TYPE_DOUBLES) && !(battleType & (BATTLE_TYPE_MULTI | BATTLE_TYPE_TAG))) || ((battleType & BATTLE_TYPE_TAG) && BattleSystem_GetFieldSide(battleSystem, battlerId) == 0)) {
            if (ctx->battleMons[battlerId].hp != 0 || ctx->battleMons[battlerId ^ 2].hp != 0 || !(battlerId & 2)) {
                if (ctx->battleMons[battlerId].hp == 0) {
                    int i;
                    int hp = 0;
                    Party *party = BattleSystem_GetParty(battleSystem, battlerId);
                    BattleSystem_GetOpponentData(battleSystem, battlerId); // called but unused

                    for (i = 0; i < Party_GetCount(party); i++) {
                        Pokemon *mon = Party_GetMonByIndex(party, i);
                        if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                            u32 hpTemp = GetMonData(mon, MON_DATA_HP, NULL);
                            if (hpTemp != 0 && ctx->selectedMonIndex[battlerId ^ 2] != i) {
                                hp += hpTemp;
                            }
                        }
                    }

                    if (hp == 0) {
                        ctx->switchInFlag |= MaskOfFlagNo(battlerId);
                        ctx->selectedMonIndex[battlerId] = 6;
                    } else {
                        ctx->commandNext = cmd;
                        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                        ctx->unk_13C[battlerId] |= 1;
                    }
                }
            }
        } else if (ctx->battleMons[battlerId].hp == 0) {
            int i;
            int hp = 0;
            Party *party = BattleSystem_GetParty(battleSystem, battlerId);
            BattleSystem_GetOpponentData(battleSystem, battlerId);

            for (i = 0; i < Party_GetCount(party); i++) {
                Pokemon *mon = Party_GetMonByIndex(party, i);
                if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_EGG) {
                    hp += GetMonData(mon, MON_DATA_HP, NULL);
                }
            }

            if (hp == 0) {
                ctx->switchInFlag |= MaskOfFlagNo(battlerId);
                ctx->selectedMonIndex[battlerId] = 6;
            } else {
                ctx->commandNext = cmd;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->unk_13C[battlerId] |= 1;
            }
        }
    }

    if (ctx->command == CONTROLLER_COMMAND_RUN_SCRIPT) {
        if ((!(battleType & (BATTLE_TYPE_FRONTIER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_LINK)) && BattleSystem_GetBattleStyle(battleSystem) == 0) && (!(ctx->unk_13C[0] & 1) || !(ctx->unk_13C[1] & 1)) && CanSwitchMon(battleSystem, ctx, 0)) {
            if (ctx->unk_13C[0] & 1) {
                ctx->tempData = 0;
            } else {
                ctx->tempData = 1;
            }
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_REPLACE_FAINTED);
        } else {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SHOW_PARTY_LIST);
        }

        flag = TRUE;
    }

    return flag;
}

static BOOL ov12_0224D7EC(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    u8 battleOutcome = 0;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if ((battleType == (BATTLE_TYPE_AI | BATTLE_TYPE_MULTI | BATTLE_TYPE_DOUBLES) || battleType == (BATTLE_TYPE_AI | BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI)) && BattleSystem_GetFieldSide(battleSystem, battlerId) == 0) {
            if (ov12_0223AB0C(battleSystem, battlerId) == 2 && ctx->battleMons[battlerId].hp == 0) {
                int hp = 0;
                Party *party = BattleSystem_GetParty(battleSystem, battlerId);
                BattleSystem_GetOpponentData(battleSystem, battlerId);

                for (int i = 0; i < Party_GetCount(party); i++) {
                    Pokemon *mon = Party_GetMonByIndex(party, i);
                    if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                        hp += GetMonData(mon, MON_DATA_HP, NULL);
                    }
                }

                if (hp == 0) {
                    battleOutcome |= 2;
                }
            }
        } else if ((battleType & BATTLE_TYPE_MULTI) || ((battleType & BATTLE_TYPE_TAG) && BattleSystem_GetFieldSide(battleSystem, battlerId))) {
            if (ctx->battleMons[battlerId].hp == 0) {
                int i;
                int hp = 0;
                Party *party = BattleSystem_GetParty(battleSystem, battlerId);
                Party *partnerParty = BattleSystem_GetParty(battleSystem, BattleSystem_GetBattlerIdPartner(battleSystem, battlerId));
                OpponentData *opponent = BattleSystem_GetOpponentData(battleSystem, battlerId);

                for (i = 0; i < Party_GetCount(party); i++) {
                    Pokemon *mon = Party_GetMonByIndex(party, i);
                    if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                        hp += GetMonData(mon, MON_DATA_HP, NULL);
                    }
                }

                for (i = 0; i < Party_GetCount(partnerParty); i++) {
                    Pokemon *mon = Party_GetMonByIndex(partnerParty, i);
                    if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                        hp += GetMonData(mon, MON_DATA_HP, NULL);
                    }
                }

                if (hp == 0) {
                    if (ov12_02261258(opponent) & 1) {
                        battleOutcome |= BATTLE_RESULT_WIN;
                    } else {
                        battleOutcome |= BATTLE_RESULT_LOSE;
                    }
                }
            }
        } else {
            if (ctx->battleMons[battlerId].hp == 0) {
                int hp = 0;
                Party *party = BattleSystem_GetParty(battleSystem, battlerId);
                OpponentData *opponent = BattleSystem_GetOpponentData(battleSystem, battlerId);

                for (int i = 0; i < Party_GetCount(party); i++) {
                    Pokemon *mon = Party_GetMonByIndex(party, i);
                    if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG) {
                        hp += GetMonData(mon, MON_DATA_HP, NULL);
                    }
                }

                if (hp == 0) {
                    if (ov12_02261258(opponent) & 1) {
                        battleOutcome |= BATTLE_RESULT_WIN;
                    } else {
                        battleOutcome |= BATTLE_RESULT_LOSE;
                    }
                }
            }
        }
    }

    if ((battleOutcome == BATTLE_OUTCOME_WIN && battleType & BATTLE_TYPE_TRAINER && !(battleType & BATTLE_TYPE_LINK)) || (battleOutcome == BATTLE_OUTCOME_WIN && battleType & BATTLE_TYPE_FRONTIER && !(battleType & BATTLE_TYPE_LINK))) {
        Trainer *trainer = BattleSystem_GetTrainer(battleSystem, BATTLER_ENEMY);

        switch (trainer->data.trainerClass) {
        case TRAINERCLASS_LEADER_FALKNER:
        case TRAINERCLASS_LEADER_BUGSY:
        case TRAINERCLASS_LEADER_WHITNEY:
        case TRAINERCLASS_LEADER_MORTY:
        case TRAINERCLASS_LEADER_PRYCE:
        case TRAINERCLASS_LEADER_JASMINE:
        case TRAINERCLASS_LEADER_CHUCK:
        case TRAINERCLASS_LEADER_CLAIR:
        case TRAINERCLASS_CHAMPION:
        case TRAINERCLASS_ELITE_FOUR_WILL:
        case TRAINERCLASS_ELITE_FOUR_KAREN:
        case TRAINERCLASS_ELITE_FOUR_KOGA:
        case TRAINERCLASS_ELITE_FOUR_BRUNO:
        case TRAINERCLASS_LEADER_BROCK:
        case TRAINERCLASS_LEADER_MISTY:
        case TRAINERCLASS_LEADER_LT_SURGE:
        case TRAINERCLASS_LEADER_ERIKA:
        case TRAINERCLASS_LEADER_JANINE:
        case TRAINERCLASS_LEADER_SABRINA:
        case TRAINERCLASS_LEADER_BLAINE:
        case TRAINERCLASS_LEADER_BLUE:
            PlayBGM(SEQ_GS_WIN3);
            break;
        case TRAINERCLASS_TOWER_TYCOON:
        case TRAINERCLASS_HALL_MATRON:
        case TRAINERCLASS_FACTORY_HEAD:
        case TRAINERCLASS_ARCADE_STAR:
        case TRAINERCLASS_CASTLE_VALET:
            PlayBGM(SEQ_GS_WINBRAIN);
            break;
        default:
            PlayBGM(SEQ_GS_WIN1);
            break;
        }

        BattleSystem_SetCriticalHpMusicFlag(battleSystem, 2);
    }

    if (battleOutcome) {
        BattleSystem_SetBattleOutcomeFlags(battleSystem, battleOutcome);
    }

    return battleOutcome != 0;
}

static BOOL ov12_0224DB64(BattleSystem *battleSystem, BattleContext *ctx, u8 battlerId, u32 battleType, int *out, int movePos, u32 *side) {
    if (ctx->battleMons[battlerId].moves[movePos] == MOVE_CURSE && CurseUserIsGhost(ctx, ctx->battleMons[battlerId].moves[movePos], battlerId) == FALSE) {
        *out = RANGE_USER;
    } else {
        *out = BattleMoveTbl(ctx, ctx->battleMons[battlerId].moves[movePos])->range;
    }

    if (battleType & BATTLE_TYPE_DOUBLES) {
        if (*out == RANGE_ALLY) {
            return (ctx->switchInFlag & MaskOfFlagNo(BattleSystem_GetBattlerIdPartner(battleSystem, battlerId))) == 0;
        } else {
            return TRUE;
        }
    } else {
        if (*out & 0x251) {
            *side = battlerId;
        } else {
            *side = battlerId ^ 1;
        }
        return FALSE;
    }
}

static void ov12_0224DC0C(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        ctx->battleMons[battlerId].status2 &= ctx->unk_218C[battlerId] ^ 0xFFFFFFFF;
        ctx->unk_218C[battlerId] = 0;
    }

    ctx->moveNoHit[ctx->battlerIdAttacker] = 0;
}

static BOOL TryFaintMon(BattleContext *ctx, ControllerCommand commandNext, ControllerCommand command, int flag) {
    int turn = 0;
    int faintedFlag = MaskOfFlagNo(ctx->turnOrder[turn]) << BATTLE_STATUS_FAINTED_SHIFT;

    if (ctx->battleStatus & BATTLE_STATUS_FAINTED) {
        while ((ctx->battleStatus & faintedFlag) == 0) {
            turn++;
            faintedFlag = MaskOfFlagNo(ctx->turnOrder[turn]) << BATTLE_STATUS_FAINTED_SHIFT;
        }
        ctx->battleStatus &= faintedFlag ^ 0xFFFFFFFF;
        ctx->battlerIdFainted = LowestFlagNo(faintedFlag >> BATTLE_STATUS_FAINTED_SHIFT);

        if (flag == 1) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FAINT_MON);
        } else {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FAINT_CHECK_DESTINY_BOND);
        }
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = commandNext;
        ctx->playerActions[ctx->battlerIdFainted].command = CONTROLLER_COMMAND_40;
        return TRUE;
    } else {
        ctx->command = command;
        return FALSE;
    }
}

static BOOL ov12_0224DD18(BattleContext *ctx, ControllerCommand commandNext, ControllerCommand command) {
    if (ctx->battleStatus2 & BATTLE_STATUS2_EXP_GAIN) {
        int flag = 1 << BATTLE_STATUS2_EXP_GAIN_SHIFT;

        while (!(ctx->battleStatus2 & flag)) {
            flag <<= 1;
        }

        ctx->battleStatus2 &= flag ^ 0xFFFFFFFF;
        ctx->battlerIdFainted = LowestFlagNo(flag >> BATTLE_STATUS2_EXP_GAIN_SHIFT);
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_GRANT_EXP);
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ctx->commandNext = commandNext;
        return TRUE;
    } else {
        ctx->command = command;
        return FALSE;
    }
}

static void ov12_0224DD74(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag;
    int moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);
    u8 item;

    flag = BattleMoveTbl(ctx, ctx->moveNoTemp)->unkB;

    if (flag & 0x10 && !(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET) && ctx->battlerIdTarget != BATTLER_NONE && ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
        ctx->moveNoCopied[ctx->battlerIdTarget] = ctx->moveNoTemp;
        ctx->moveNoCopiedHit[ctx->battlerIdTarget][ctx->battlerIdAttacker] = ctx->moveNoTemp;
    }

    if (ctx->battlerIdTarget != BATTLER_NONE) {
        item = GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget);
        if (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN || ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
            if (item != HOLD_EFFECT_CHOICE_ATK && item != HOLD_EFFECT_CHOICE_SPEED && item != HOLD_EFFECT_CHOICE_SPATK) {
                ctx->battleMons[ctx->battlerIdTarget].unk88.moveNoChoice = 0;
            }
        }

        if (!(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET)) {
            if (ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
                ctx->moveNoHit[ctx->battlerIdTarget] = ctx->moveNoCur;
                ctx->moveNoHitBattler[ctx->battlerIdTarget] = ctx->battlerIdAttacker;
                ctx->moveNoHitType[ctx->battlerIdTarget] = moveType;
                ctx->moveNoPrev = ctx->moveNoTemp;
            } else {
                ctx->moveNoHit[ctx->battlerIdTarget] = 0;
                ctx->moveNoHitBattler[ctx->battlerIdTarget] = BATTLER_NONE;
                ctx->moveNoHitType[ctx->battlerIdTarget] = 0;
                ctx->moveNoPrev = 0;
            }
        }
    }

    // The move the attacker used and its type as used, for a Conversion 2
    // aimed at it later (BtlCmd_TryConversion2). It stays until the attacker
    // uses another or leaves the field. Retail kept, on the target, the move
    // that last hit it.
    if (!(ctx->battleStatus & BATTLE_STATUS_NO_MOVE_SET) && ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {
        ctx->conversion2Move[ctx->battlerIdAttacker] = ctx->moveNoCur;
        ctx->conversion2Type[ctx->battlerIdAttacker] = moveType;
    }
}

static BOOL ov12_0224DF7C(BattleSystem *battleSystem, BattleContext *ctx) {
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_CRITICAL_HIT);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;

    return TRUE;
}

static BOOL ov12_0224DF98(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;

    if (ctx->moveStatusFlag) {
        if (ctx->multiHitCountTemp != 0) {
            if (ctx->battlerIdFainted != BATTLER_NONE || ctx->multiHitCount == 1 || ctx->moveStatusFlag & MOVE_STATUS_MULTI_HIT_DISRUPTED) {
                ret = TRUE;
            }
        } else {
            ret = TRUE;
        }
    }

    if (ret == TRUE) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    }
    return ret;
}

static BOOL TryBuildRage(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;

    if (ctx->battlerIdTarget == BATTLER_NONE) {
        return ret;
    }

    if ((ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_RAGE)
        && !(ctx->moveStatusFlag & MOVE_STATUS_MULTI_HIT_DISRUPTED)
        && ctx->battlerIdTarget != ctx->battlerIdAttacker
        && ctx->battleMons[ctx->battlerIdTarget].hp != 0
        && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage != 0 || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage != 0)
        && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] < 12) {
        ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK]++;
        // What a Mirror Herb on the other side is to copy (RecordMirrorHerbStages),
        // and a rise for a Burning Jealousy later in the turn (Fiamminvidia).
        RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdTarget, STAT_ATK, 1);
        ctx->turnData[ctx->battlerIdTarget].statRaised = TRUE;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_RAGE_IS_BUILDING);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ret = TRUE;
    }

    return ret;
}

// The moves a King's Rock, a Razor Fang or Stench can make flinch, by the
// reference's rule (IsMoveAffectedByKingsRock, ability.c): any move with power
// that does not flinch by itself already. Retail marked its own list with bit
// 5 of the flag byte instead, and the imported moves only ever guessed at it.
static BOOL MoveIsAffectedByKingsRock(BattleContext *ctx, u16 move) {
    if (BattleMoveTbl(ctx, move)->power == 0) {
        return FALSE;
    }
    switch (BattleMoveTbl(ctx, move)->effect) {
    case MOVE_EFFECT_FLINCH_HIT:
    case MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH:
    case MOVE_EFFECT_FLINCH_DOUBLE_DAMAGE_FLY_OR_BOUNCE:
    case MOVE_EFFECT_FLINCH_MINIMIZE_DOUBLE_HIT:
    case MOVE_EFFECT_ALWAYS_FLINCH_FIRST_TURN_ONLY:
    case MOVE_EFFECT_FLINCH_BURN_HIT:
    case MOVE_EFFECT_FLINCH_FREEZE_HIT:
    case MOVE_EFFECT_FLINCH_PARALYZE_HIT:
    case MOVE_EFFECT_HIT_TWICE_AND_FLINCH:
        return FALSE;
    default:
        return TRUE;
    }
}

static BOOL TryItemFlinch(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;
    int ability = GetBattlerAbility(ctx, ctx->battlerIdAttacker);
    int chance = 0;

    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_FLINCH_CHANCE) {
        chance = GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);
    }
    // Stench is a tenth more, with a King's Rock or without one. The reference
    // adds its ten to whatever parameter the held item has, so a Choice Band's
    // or a Charcoal's would count as a flinch chance too; only the King's
    // Rock's does here.
    if (ability == ABILITY_STENCH) {
        chance += 10;
    }
    // Serene Grace doubles the chance, as it doubles every added effect's. The
    // reference shifts the roll instead of the chance, which halves it.
    if (ability == ABILITY_SERENE_GRACE) {
        chance *= 2;
    }

    // A Covert Cloak is the first thing the reference's flinch check asks
    // about, before the King's Rock or Stench that would have caused one.
    if (ctx->battlerIdTarget != BATTLER_NONE
        && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) != HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS
        && chance != 0
        && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)
        && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage != 0 || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage != 0)
        && !Battler_CameInAfterTheHit(ctx, ctx->battlerIdTarget)
        && (BattleSystem_Random(battleSystem) % 100) < chance
        && MoveIsAffectedByKingsRock(ctx, ctx->moveNoCur)
        && ctx->battleMons[ctx->battlerIdTarget].hp != 0) {
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
        ctx->statChangeType = 2;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FLINCH_MON);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ret = TRUE;
    }

    return ret;
}

static BOOL ov12_0224E130(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;
    while (ctx->unk_5C < BattleSystem_GetMaxBattlers(battleSystem)) {
        if (!(ctx->battleMons[ctx->unk_5C].moveEffectFlags & MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE) && ctx->battleMons[ctx->unk_5C].moveEffectFlagsTemp & MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE) {
            ctx->battleMons[ctx->unk_5C].moveEffectFlagsTemp &= ~MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_VANISH_OFF);
            ctx->battlerIdTemp = ctx->unk_5C;
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            ret = TRUE;
        }
        ctx->unk_5C++;
        if (ret == TRUE) {
            break;
        }
    }
    if (ret == FALSE) {
        ctx->unk_5C = 0;
    }
    return ret;
}

// Or'd into ov12_0224E1BC's battler walk once an Eject Button or a Parting
// Shot has sent somebody away, so that no Eject Pack answers the same move; a
// Red Card leaves the Pack its turn.
#define SWITCH_ITEM_USED 0x100

static void RunPostMoveScript(BattleContext *ctx, int script) {
    ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
}

// The recoil a move costs its user: the engine's Activate_RecoilDamage
// (ServerDoPostMoveEffects.c:2075 at d0380a487), step 15 of its post-move
// steps, once the move is over and whatever it felled has fainted. It is a
// share of all the damage the move dealt, so Parental Bond's two strikes
// cost one recoil (Pokemon Central, Amorefiliale), and it is no additional
// effect: Sheer Force boosts the move and the recoil stays (Pokemon Central,
// Contraccolpo), as it stays against a Covert Cloak. A move that dealt
// nothing costs nothing; Rock Head and Magic Guard spare the user.
static BOOL TryRecoil(BattleContext *ctx) {
    int attacker = ctx->battlerIdAttacker;
    int ability = GetBattlerAbility(ctx, attacker);
    int script;

    if (ctx->battleMons[attacker].hp == 0 || ctx->selfTurnData[attacker].shellBellDamage == 0
        || ability == ABILITY_ROCK_HEAD || ability == ABILITY_MAGIC_GUARD) {
        return FALSE;
    }
    switch (BattleMoveTbl(ctx, ctx->moveNoCur)->effect) {
    case MOVE_EFFECT_RECOIL_QUARTER_DAMAGE_DELT:
        script = BATTLE_SUBSCRIPT_RECOIL_1_4;
        break;
    case MOVE_EFFECT_RECOIL_THIRD:
    case MOVE_EFFECT_RECOIL_BURN_HIT:
    case MOVE_EFFECT_RECOIL_PARALYZE_HIT:
        script = BATTLE_SUBSCRIPT_RECOIL_1_3;
        break;
    case MOVE_EFFECT_RECOIL_HALF:
        script = BATTLE_SUBSCRIPT_RECOIL_1_2;
        break;
    case MOVE_EFFECT_RECOIL_HALF_MAX_HP:
        script = BATTLE_SUBSCRIPT_RECOIL_HALF_MAX_HP;
        break;
    default:
        return FALSE;
    }
    RunPostMoveScript(ctx, script);
    return TRUE;
}

// What a move does to its target once it is over, besides its damage: the
// engine's Activate_AdditionalMoveEffects (ServerDoPostMoveEffects.c:1095 at
// d0380a487), the step after the recoil. The engine runs these steps only for
// a move that hit, so they wait on that here, on its last strike when there
// were two: Parental Bond's strikes are both over by now (Pokemon Central,
// Amorefiliale, for what waits for the second).
static BOOL TryAdditionalMoveEffect(BattleContext *ctx) {
    int target = ctx->battlerIdTarget;
    int effect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;
    int script;

    // Dragon Tail and Circle Throw drag their target out now that it has
    // answered the hit (ov12_02250490 marked it), the engine's
    // MOVE_EFFECT_FORCE_SWITCH_HIT here (ServerDoPostMoveEffects.c:1213 at
    // d0380a487): after the recoil, before Magician and the Red Cards and
    // Eject Buttons; not if the user fainted to its Rough Skin, Iron Barbs,
    // Rocky Helmet or Gulp Missile (Pokemon Central, Codadrago).
    if (target != BATTLER_NONE && ctx->selfTurnData[target].dragPending) {
        ctx->selfTurnData[target].dragPending = FALSE;
        if (!ctx->battleMons[target].hp || !ctx->battleMons[ctx->battlerIdAttacker].hp) {
            return FALSE;
        }
        RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE);
        return TRUE;
    }
    if (target == BATTLER_NONE || (ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
        return FALSE;
    }
    // Order Up raises a stat of a user that holds a Tatsugiri in its mouth,
    // by the Tatsugiri's form -- the Curly's Attack, the Droopy's Defense, the
    // Stretchy's Speed -- the Tatsugiri fainted or not, once the move has hit
    // (Pokemon Central, Alta Cucina: before Scarlet and Violet 1.2.0 it rose
    // on a miss too). Sheer Force boosts the move and leaves the rise
    // (CalcMoveDamage). The engine leaves it a plain hit.
    if (ctx->moveNoCur == MOVE_ORDER_UP && ctx->moveConditions[ctx->battlerIdAttacker].commanderForm && ctx->battleMons[ctx->battlerIdAttacker].hp) {
        ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + ctx->moveConditions[ctx->battlerIdAttacker].commanderForm - 1;
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
        RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
        return TRUE;
    }
    switch (effect) {
    // Smelling Salts and Wake-Up Slap cure what they doubled against, if the
    // hit reached the Pokemon (Pokemon Central, Maniereforti: even for no
    // damage). A substitute that took it keeps the Pokemon behind it as it
    // was, as this game's scripts had it; the reference cures it anyway, and
    // asks as well that the user still stands, which the cure, part of the
    // hit, does not wait on here.
    case MOVE_EFFECT_DOUBLE_POWER_AND_CURE_PARALYSIS:
        if (!ctx->battleMons[target].hp || !(ctx->battleMons[target].status & STATUS_PARALYSIS) || BattlerCheckSubstitute(ctx, target)) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_HEAL_TARGET_PARALYSIS;
        break;
    case MOVE_EFFECT_DOUBLE_POWER_HEAL_SLEEP:
        if (!ctx->battleMons[target].hp || !(ctx->battleMons[target].status & STATUS_SLEEP) || BattlerCheckSubstitute(ctx, target)) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_HEAL_TARGET_SLEEP;
        break;
    // Wrap, Fire Spin, Whirlpool, Magma Storm and the rest hold the target
    // once the move is over, if both it and the user still stand. Subscript 58
    // asks the side-effect battler for a substitute that took the hit.
    case MOVE_EFFECT_BIND_HIT:
    case MOVE_EFFECT_WHIRLPOOL:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp || !ctx->battleMons[target].hp) {
            return FALSE;
        }
        ctx->battlerIdStatChange = target;
        script = BATTLE_SUBSCRIPT_BIND_START;
        break;
    // Jaw Lock holds its user and its target where Mean Look holds one, once
    // the move is over, if both still stand: a hold would end the moment
    // either left. Subscript 385 turns a substitute away and leaves one held
    // already as it is.
    case MOVE_EFFECT_PREVENT_ESCAPE_BOTH_HIT:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp || !ctx->battleMons[target].hp) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_JAW_LOCK;
        break;
    // Scale Shot lowers its user's Defense a stage and raises its Speed a
    // stage once its strikes are over, however many landed, if the user
    // still stands: each stat changes whatever the other's stage (Pokemon
    // Central, Squamacolpo), where the engine asks both to have room
    // (ServerDoPostMoveEffects.c:1270 at d0380a487). It is no additional
    // effect: neither Sheer Force nor a Covert Cloak has a say. A stage at its
    // limit stays as it is, unsaid.
    case MOVE_EFFECT_MULTI_HIT:
        if (ctx->moveNoCur != MOVE_SCALE_SHOT || !ctx->battleMons[ctx->battlerIdAttacker].hp) {
            return FALSE;
        }
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
        RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_SCALE_SHOT);
        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
        return TRUE;
    // Fell Stinger raises its user's Attack three stages once the move is
    // over, if it felled the target and the user still stands (Pokemon
    // Central, Pungiglione; the engine asks nothing of the user). At +6 the
    // rise is left unsaid, as the engine does not ask for it.
    case MOVE_EFFECT_FELL_STINGER:
        if (ctx->battleMons[target].hp || !ctx->battleMons[ctx->battlerIdAttacker].hp) {
            return FALSE;
        }
        RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_ATTACK_UP_3_ON_FAINT);
        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
        return TRUE;
    // Mortal Spin clears its user's side once the move is over, if the user
    // still stands (Pokemon Central, Glitturbine: not once Rough Skin, Iron
    // Barbs, a Rocky Helmet or Aftermath has felled it). The poison is each
    // target's additional effect.
    case MOVE_EFFECT_MORTAL_SPIN:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_MORTAL_SPIN;
        break;
    // Stone Axe and Ceaseless Edge lay pointed stones or a layer of Spikes on
    // the target's side once the move is over, if the user still stands
    // (Pokemon Central, Rocciascure and Lama Milleflutti: not once Iron
    // Barbs, Rough Skin or a Rocky Helmet has felled it); a substitute that
    // took the hit stops neither. Stone Axe lays nothing for power Sheer
    // Force traded the stones for (Rocciascure; IsSuppressibleSecondaryEffect).
    // Subscripts 386 and 387 leave the stones that are there and a fourth
    // layer unlaid.
    case MOVE_EFFECT_STEALTH_ROCK_HIT:
    case MOVE_EFFECT_SET_SPIKES_HIT:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp || SheerForceTradedEffect(ctx)) {
            return FALSE;
        }
        script = effect == MOVE_EFFECT_STEALTH_ROCK_HIT ? BATTLE_SUBSCRIPT_SET_STEALTH_ROCK : BATTLE_SUBSCRIPT_SET_SPIKES;
        break;
    // Knock Off takes the target's item once the move is over: not if the
    // user has fainted to Rough Skin, Aftermath or the like, and from a target
    // the move felled all the same (Pokemon Central, Privazione); not past a
    // substitute that took the hit. Subscript 142 asks the rest.
    case MOVE_EFFECT_REMOVE_HELD_ITEM:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp || BattlerCheckSubstitute(ctx, target)) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_KNOCK_OFF;
        break;
    // Thief and Covet take the target's item once the move is over, on the
    // same terms (Pokemon Central, Furto: not once the user has fainted to
    // Rough Skin, recoil or Aftermath). Subscript 85 asks the rest, the Gem
    // among it.
    case MOVE_EFFECT_STEAL_HELD_ITEM:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp || BattlerCheckSubstitute(ctx, target)) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_STEAL_ITEM;
        break;
    // Pluck and Bug Bite eat the target's Berry once the move is over, if the
    // user still stands: Rough Skin and Aftermath answer the hit first, and a
    // user they fell eats nothing (Pokemon Central, Coleomorso). Subscript 219
    // asks the rest, the substitute among it.
    case MOVE_EFFECT_EAT_BERRY:
        if (!ctx->battleMons[ctx->battlerIdAttacker].hp) {
            return FALSE;
        }
        script = BATTLE_SUBSCRIPT_PLUCK;
        break;
    // A combined Pledge that hit leaves its condition for four turns' ends,
    // this one's counted: the rainbow over the user's side, the sea of fire
    // or the swamp around the target's; one already there stays as it is
    // (Pokemon Central, Acquapatto, Fiammapatto, Erbapatto). MSG_TEMP says
    // which for subscript 465.
    case MOVE_EFFECT_PLEDGE: {
        int combination = ctx->selfTurnData[ctx->battlerIdAttacker].combinedPledge;
        int shift = SIDE_CONDITION_RAINBOW_SHIFT + 3 * (combination - 1);
        int side;

        if (!combination) {
            return FALSE;
        }
        ctx->battlerIdTemp = combination == 1 ? ctx->battlerIdAttacker : target;
        side = ctx->battlerIdTemp & 1;
        if (ctx->fieldSideConditionFlags[side] & (7 << shift)) {
            return FALSE;
        }
        ctx->fieldSideConditionFlags[side] |= 4 << shift;
        ctx->msgTemp = combination - 1;
        script = BATTLE_SUBSCRIPT_PLEDGE_CONDITION;
        break;
    }
    default:
        return FALSE;
    }
    RunPostMoveScript(ctx, script);
    return TRUE;
}

// Thousand Waves, Anchor Shot and Spirit Shackle hold each Pokemon they hit
// where Mean Look holds one, once the move is over: the engine's
// Activate_AdditionalMoveEffects (ServerDoPostMoveEffects.c:1189 at
// d0380a487, the PREVENT_ESCAPE_HIT case), which holds its one target. Here
// every Pokemon the move hit is asked, so Thousand Waves holds both foes of a
// double battle (Pokemon Central, Mille Onde: those it hits). Not one that
// has fainted or came in after the hit, one behind a substitute -- which
// records no damage -- or one held already; not once the user has fainted,
// as the hold lasts only while it stays in (Colpo d'Ancora); and, for Anchor
// Shot and Spirit Shackle, not when Sheer Force traded the hold for power or
// the Pokemon's Covert Cloak or Shield Dust keeps it off
// (IsSuppressibleSecondaryEffect; Colpo d'Ancora and Cucitura d'Ombra):
// Thousand Waves' hold is no additional effect (Mille Onde). The Pokemon is
// the side-effect battler of subscript 461.
static BOOL TryHoldAfterHit(BattleContext *ctx, int battlerId) {
    int attacker = ctx->battlerIdAttacker;

    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect != MOVE_EFFECT_PREVENT_ESCAPE_HIT
        || battlerId == attacker || !ctx->battleMons[attacker].hp || !ctx->battleMons[battlerId].hp
        || !(ctx->selfTurnData[battlerId].physicalDamage || ctx->selfTurnData[battlerId].specialDamage)
        || Battler_CameInAfterTheHit(ctx, battlerId)
        || (ctx->battleMons[battlerId].status2 & STATUS2_MEAN_LOOK)
        || SheerForceTradedEffect(ctx)
        || (ctx->moveNoCur != MOVE_THOUSAND_WAVES
            && (GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS
                || CheckBattlerAbilityIfNotIgnored(ctx, attacker, battlerId, ABILITY_SHIELD_DUST) == TRUE))) {
        return FALSE;
    }
    ctx->battlerIdStatChange = battlerId;
    RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_HOLD_AFTER_HIT);
    return TRUE;
}

// Smack Down and Thousand Arrows bring down each Pokemon they hit once the
// hit has been answered: the engine's step 15.4 (Activate_SmackDown,
// ServerDoPostMoveEffects.c:451 at d0380a487), after the move's additional
// effects and before Magician. ov12_02250490 marked the Pokemon as the hit
// landed, past a substitute. Not once the user has fainted -- to a Jaboca
// Berry, Rough Skin, Iron Barbs, a Rocky Helmet or Gulp Missile (Pokemon
// Central, Abbattimento) -- nor a Pokemon the hit felled.
static BOOL TryFallAfterHit(BattleContext *ctx, int battlerId) {
    if (!ctx->selfTurnData[battlerId].fallPending) {
        return FALSE;
    }
    ctx->selfTurnData[battlerId].fallPending = FALSE;
    if (!ctx->battleMons[ctx->battlerIdAttacker].hp || !ctx->battleMons[battlerId].hp) {
        return FALSE;
    }
    ctx->battlerIdStatChange = battlerId;
    RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_FELL_STRAIGHT_DOWN);
    return TRUE;
}

// U-turn, Volt Switch and Flip Turn take their user out once the move is
// over: the engine's Activate_Switch (ServerDoPostMoveEffects.c:2120 at
// d0380a487), the step after Emergency Exit and Wimp Out, for a user still
// standing with no switch pending. So the user goes after the hit's Rough
// Skin, Static or Rocky Helmet, its own Life Orb and Shell Bell, and Magician,
// and a user those felled stays. Nor does it go once it has left already --
// dragged out by a Red Card, gone with its own Emergency Exit (U-turn's flag)
// -- or once the Pokemon it hit has left, by its Eject Button, Emergency Exit
// or Wimp Out (Pokemon Central, Pulsantefuga, Cartelrosso and Passoindietro);
// a Berry that healed that Pokemon above half has kept it in by then. A move
// that failed switches nothing. Nor does a user holding a Red Card itself go
// (Pokemon Central, Cartelrosso; Bulbapedia's U-turn, Volt Switch and Flip
// Turn); the reference switches it. The card is the one it holds as it would
// go, not as the move hit: a card the target's Pickpocket lifted off it keeps
// it in no longer, and one its Magician took from the target does.
//
// The engine only marks the switch pending there and makes it at its step 29,
// after Pickpocket, the Throat Spray and the Eject Pack; subscript 175 here
// withdraws the user and sends the next one in at once, so it runs where the
// engine makes the switch, and the Eject Pack step asks this to stay shut as
// the engine's pending switch keeps it. A user Commander holds on the field
// has no switch pending: its script would refuse it (Pokemon Central, Torre
// di Comando), and the Packs are not to stay shut for it.
static BOOL PivotSwitchPending(BattleContext *ctx) {
    int target = ctx->battlerIdTarget;

    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect != MOVE_EFFECT_SWITCH_HIT
        || target == BATTLER_NONE || (ctx->moveStatusFlag & MOVE_STATUS_FAIL)
        || !ctx->battleMons[ctx->battlerIdAttacker].hp || (ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
        || Battler_CameInAfterTheHit(ctx, target)
        || Battler_HeldByCommander(ctx, ctx->battlerIdAttacker)
        || GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE) {
        return FALSE;
    }
    return TRUE;
}

static BOOL TryPivotSwitch(BattleContext *ctx) {
    if (!PivotSwitchPending(ctx)) {
        return FALSE;
    }
    RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_ATTACK_THEN_SWITCH_OUT);
    return TRUE;
}

// Natural Gift's Berry goes once the move is over, whether the move hit or
// not -- a miss, Protect, an immunity -- if its user is still there to spend
// it: not once a Red Card has sent it back (Pokemon Central, Dononaturale),
// nor once it has fainted or a Pickpocket has taken the Berry (the engine's
// Activate_SkillEffects, step 25.0 of ServerDoPostMoveEffects.c at
// d0380a487, after Pickpocket). Not a Berry the move could not use, which
// failed it. With no target left, the move did not go off, but it was used
// and the Berry goes (Dononaturale; ov12_0224B398 sends it here); stopped
// by a primal weather or Powder, it keeps it.
static BOOL NaturalGiftSpendsBerry(BattleContext *ctx) {
    return BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_NATURAL_GIFT
        && ((ctx->battleStatus2 & BATTLE_STATUS2_MOVE_SUCCEEDED)
            || (ctx->battlerIdTarget == BATTLER_NONE && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)))
        && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
        && ctx->battleMons[ctx->battlerIdAttacker].hp != 0
        && GetNaturalGiftPower(ctx, ctx->battlerIdAttacker) != 0;
}

// Steel Roller and Ice Spinner tear the terrain up once the move is over,
// with Natural Gift's Berry: the engine's Activate_SkillEffects, step 25.0
// of ServerDoPostMoveEffects.c at d0380a487. ov12_02250490 marked the user
// as the hit landed. Not once the user has fainted -- to its Life Orb, a
// Rocky Helmet, Rough Skin, Iron Barbs or Destiny Bond -- nor once a Red
// Card has sent it back (Pokemon Central, Vortighiaccio); Steel Roller asks
// the same, as the reference's effect script 389 does for both (Ferrorullo
// leaves the case open). A Static or a Flame Body the hit woke has acted by
// then, under the terrain still up (Vortighiaccio).
static BOOL TerrainEnds(BattleContext *ctx) {
    int attacker = ctx->battlerIdAttacker;
    BOOL pending = ctx->selfTurnData[attacker].terrainEndPending;

    ctx->selfTurnData[attacker].terrainEndPending = FALSE;
    return pending && ctx->battleMons[attacker].hp != 0 && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN);
}

static BOOL ov12_0224E1BC(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag = 0;

    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int item = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker);
    int itemMod = GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);

    if (TryFaintMon(ctx, ctx->command, ctx->command, 1) == TRUE) {
        return TRUE;
    }

    do {
        switch (ctx->unk_30) {
        case 0:
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_RAGE && ctx->moveNoCur != MOVE_RAGE) {
                ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_RAGE;
            }
            ctx->unk_30++;
            break;
        case 1:
            ctx->unk_30++;
            if (TryRecoil(ctx) == TRUE) {
                flag = 1;
            }
            break;
        case 2:
            ctx->unk_30++;
            if (TryAdditionalMoveEffect(ctx) == TRUE) {
                flag = 1;
            }
            break;
        case 3:
            // The hold Thousand Waves, Anchor Shot and Spirit Shackle put on
            // each Pokemon they hit, one at a time in the order the battlers
            // act; see TryHoldAfterHit.
            // Smack Down's and Thousand Arrows' fall come in the same walk; see
            // TryFallAfterHit.
            while (ctx->unk_34 < maxBattlers) {
                int battlerId = ctx->turnOrder[ctx->unk_34++];

                if (TryHoldAfterHit(ctx, battlerId) == TRUE || TryFallAfterHit(ctx, battlerId) == TRUE) {
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                ctx->unk_30++;
                ctx->unk_34 = 0;
            }
            break;
        case 4: {
            int script;

            ctx->unk_30++;
            if (TryMagician(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            break;
        }
        case 5:
            // A Red Card, then an Eject Button, on anything the move hurt,
            // once the move is over and before the user's own Shell Bell and
            // Life Orb, which is where the reference asks them. The card goes
            // first and both can act on one move -- the card's Pokemon comes
            // in before the button's -- but one of each at most, of several
            // buttons the fastest holder's (Pokemon Central, Pulsantefuga).
            // Dragon Tail and Circle Throw have dragged their target out by
            // now (TryAdditionalMoveEffect), so a card or a button it held is
            // not used (Pokemon Central, Cartelrosso: not by a holder the move
            // drags out).
            //
            // unk_34 walks the battlers in the order they act, once for the
            // cards and once for the buttons; SWITCH_ITEM_USED remembers that
            // a button sent somebody away. A card does not keep an Eject
            // Pack from acting after it (Pokemon Central, Zainofuga: the
            // card first, then the Pack, a second switch).
            while ((ctx->unk_34 & ~SWITCH_ITEM_USED) < 2 * maxBattlers) {
                int walk = ctx->unk_34 & ~SWITCH_ITEM_USED;
                int card = walk < maxBattlers;
                int script = CheckSwitchItemOnHit(battleSystem, ctx, ctx->turnOrder[walk % maxBattlers],
                    card ? HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE : HOLD_EFFECT_SWITCH_OUT_WHEN_HIT);

                ctx->unk_34++;
                if (script != BATTLE_SUBSCRIPT_NONE) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ctx->unk_34 = card ? maxBattlers : (2 * maxBattlers | SWITCH_ITEM_USED);
                    // With the button, the Eject Packs give up what the move
                    // lowered: of the two only the button acts, whichever
                    // holder is faster (Pokemon Central, Pulsantefuga, where
                    // Zainofuga has the faster holder's act; Showdown's gen-9
                    // Eject Pack refuses while the button's switch is
                    // pending and forgets the drop). What an entry lowers
                    // from here on is theirs.
                    if (!card) {
                        ctx->statLoweredBattlers = 0;
                    }
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                ctx->unk_30++;
            }
            break;
        case 6:
            // Neither the Shell Bell nor the Life Orb below answers a move
            // Sheer Force powered (Pokemon Central, Forzabruta; the
            // reference's ServerDoPostMoveEffects.c:1508 at d0380a487).
            if (ctx->battlerIdTarget != BATTLER_NONE
                && item == HOLD_EFFECT_HP_RESTORE_ON_DMG
                && !SheerForceTradedEffect(ctx)
                && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
                && ctx->battleStatus & BATTLE_STATUS_MOVE_SUCCESSFUL
                && ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage != 0
                && ctx->battlerIdAttacker != ctx->battlerIdTarget
                && ctx->battleMons[ctx->battlerIdAttacker].hp < ctx->battleMons[ctx->battlerIdAttacker].maxHp
                && ctx->battleMons[ctx->battlerIdAttacker].hp != 0) {

                ctx->hpCalc = DamageDivide(ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage * -1, itemMod);
                ctx->battlerIdTemp = ctx->battlerIdAttacker;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_RESTORE_A_LITTLE_HP);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->unk_30++;
            break;
        case 7:
            if (item == HOLD_EFFECT_HP_DRAIN_ON_ATK
                && !SheerForceTradedEffect(ctx)
                && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD
                && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
                && ctx->battleStatus & BATTLE_STATUS_MOVE_SUCCESSFUL
                && BattleMoveTbl(ctx, ctx->moveNoCur)->category != CATEGORY_STATUS
                && ctx->battleMons[ctx->battlerIdAttacker].hp != 0) {

                ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 10);
                ctx->battlerIdTemp = ctx->battlerIdAttacker;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->unk_30++;
            break;
        case 8:
            // Steel Beam and Mind Blown cost their user half its maximum HP,
            // rounded up, once the move is over, whether it hit or not; only
            // Magic Guard spares it (Pokemon Central, Raggio d'Acciaio,
            // Sbalorditesta). Effect script 420 marks the user when the move
            // goes off at a target, so one with none to go at costs nothing.
            if ((ctx->selfTurnData[ctx->battlerIdAttacker].unk14 & SELF_TURN_FLAG_LOSE_HALF_MAX_HP)
                && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD
                && ctx->battleMons[ctx->battlerIdAttacker].hp != 0) {
                ctx->selfTurnData[ctx->battlerIdAttacker].unk14 &= ~SELF_TURN_FLAG_LOSE_HALF_MAX_HP;
                ctx->battlerIdTemp = ctx->battlerIdAttacker;
                ctx->hpCalc = -(int)((ctx->battleMons[ctx->battlerIdAttacker].maxHp + 1) / 2);
                ctx->battleStatus |= BATTLE_STATUS_NO_BLINK;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_HP);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->unk_30++;
            break;
        case 9: {
            // Emergency Exit and Wimp Out, one Pokemon at a time: this step
            // comes round again after each, until none is left to go. They
            // come before Parting Shot, Pickpocket, the Throat Spray and the
            // Eject Pack, the reference's step 22; once one has sent somebody
            // away no Eject Pack answers the move (Pokemon Central, Zainofuga:
            // the two abilities take precedence over it), which unk_34 says
            // to the step that asks the Packs, as in the engine the pending
            // switch does.
            int script;

            if (TryRetreatAbility(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                ctx->unk_34 = SWITCH_ITEM_USED;
                flag = 1;
            } else {
                ctx->unk_30++;
            }
            break;
        }
        case 10:
            // Parting Shot's user goes back once the move is over, if the
            // move changed a stat of its target (Pokemon Central, Monito; the
            // reference's Activate_Switch, ServerDoPostMoveEffects.c:2149 at
            // d0380a487). Nothing changed -- a miss, Protect, Soundproof,
            // Clear Body, Mist, both stats at -6, or at +6 for a Contrary
            // target whose stats the move raises instead -- and it stays, as
            // it has since the seventh generation. It goes before the user's
            // Throat Spray, which a user that left with its move does not use,
            // and a target's Eject Pack does not answer a Parting Shot: unk_34
            // says so to the step that asks it.
            //
            // Bounced by Magic Coat or Magic Bounce, the move is the
            // bouncer's: the user takes the drops and the bouncer goes back
            // (Pokemon Central, Monito; the reference's own battle test,
            // data/battle_tests/moves/parting_shot/magic_bounce.c). By now the
            // attacker and the target are the user and the bouncer again
            // (ov12_0224D03C), so the two trade places here.
            if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_PARTING_SHOT
                && ctx->battlerIdTarget != BATTLER_NONE
                && ctx->battlerIdTarget != ctx->battlerIdAttacker) {
                int leaver = ctx->battlerIdAttacker;
                int lowered = ctx->battlerIdTarget;

                if (ctx->battlerIdMagicCoat != BATTLER_NONE) {
                    leaver = ctx->battlerIdTarget;
                    lowered = ctx->battlerIdAttacker;
                }
                if (((ctx->statLoweredBattlers | ctx->statRaisedBattlers) & MaskOfFlagNo(lowered))
                    && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
                    && ctx->battleMons[leaver].hp != 0) {
                    ctx->battlerIdTemp = leaver;
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HANDLE_PARTING_SHOT);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ctx->unk_34 = SWITCH_ITEM_USED;
                    ctx->statLoweredBattlers = 0;
                    flag = 1;
                }
            }
            ctx->unk_30++;
            break;
        case 11: {
            // Pickpocket, once the move is over and before U-turn's user
            // leaves; see TryPickpocket.
            int script;

            ctx->unk_30++;
            if (TryPickpocket(battleSystem, ctx, &script) == TRUE) {
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            break;
        }
        case 12:
            // Natural Gift's Berry, after Pickpocket; see NaturalGiftSpendsBerry.
            // It is not eaten (BtlCmd_RemoveItem): subscript PLUCK_CHECK is a
            // RemoveItem of battlerIdTemp's.
            ctx->unk_30++;
            if (NaturalGiftSpendsBerry(ctx) == TRUE) {
                ctx->battlerIdTemp = ctx->battlerIdAttacker;
                ctx->selfTurnData[ctx->battlerIdAttacker].berryNotEaten = TRUE;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_PLUCK_CHECK);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            } else if (TerrainEnds(ctx) == TRUE) {
                // Steel Roller and Ice Spinner, in the same step.
                RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END);
                flag = 1;
            }
            break;
        case 13:
            // A Throat Spray answers the attacker using a sound move, and that
            // is the whole of the reference's condition: not that the move hit,
            // not that there was anything to hit, and not that Sp. Atk had room
            // left -- a spray at +6 prints "won't go any higher" and is spent
            // all the same. It is asked after Pickpocket and before the Eject
            // Pack, the reference's step 26.
            //
            // Not once the user has gone: what stands in its place now holds
            // its own items, and did not use the move.
            if (item == HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE
                && BattleMoveIsSoundBased(ctx->moveNoCur) == TRUE
                && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
                && ctx->battleMons[ctx->battlerIdAttacker].hp != 0) {

                ctx->msgTemp = STAT_SPATK;
                ctx->battlerIdTemp = ctx->battlerIdAttacker;
                ctx->itemTemp = ctx->battleMons[ctx->battlerIdAttacker].item;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT);
                ctx->commandNext = ctx->command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                flag = 1;
            }
            ctx->unk_30++;
            if (!(ctx->unk_34 & SWITCH_ITEM_USED)) {
                ctx->unk_34 = 0;
            }
            break;
        case 14:
            // An Eject Pack on anyone who had a stat lowered during the move,
            // after the user's own items, where the reference asks it (step
            // 28); not once an Eject Button, Emergency Exit or Wimp Out has
            // sent somebody away, after a Parting Shot, or with U-turn's user
            // about to go (PivotSwitchPending): in the engine each of those
            // is a switch pending, which keeps the Packs shut. After a Red
            // Card it is asked, and answers the drops of the move and of the
            // entry of the Pokemon the card dragged in -- Sticky Web on its
            // way in.
            while (ctx->unk_34 < maxBattlers && !PivotSwitchPending(ctx)) {
                int script = CheckEjectPack(battleSystem, ctx, ctx->turnOrder[ctx->unk_34++]);

                if (script != BATTLE_SUBSCRIPT_NONE) {
                    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
                    ctx->commandNext = ctx->command;
                    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                    ctx->unk_34 = SWITCH_ITEM_USED;
                    ctx->statLoweredBattlers = 0;
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                ctx->unk_30++;
            }
            break;
        case 15:
            // U-turn's user goes last, where the engine makes its pending
            // switch; see PivotSwitchPending.
            ctx->unk_30++;
            if (TryPivotSwitch(ctx) == TRUE) {
                flag = 1;
            }
            break;
        case 16:
            ctx->unk_30 = 0;
            ctx->unk_34 = 0;
            flag = 2;
            break;
        }
    } while (flag == 0);

    return flag == 1;
}

extern u32 ov10_02220AAC[];

static void ov12_0224E384(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int battler;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    u16 item;

    MI_CpuClear32((u32 *)&ctx->trainerAIData, sizeof(TrainerAIData));
    MI_CpuClear32(ctx->trainerAIAbilities, sizeof(ctx->trainerAIAbilities));

    if ((battleType & BATTLE_TYPE_TRAINER) && !(battleType & (BATTLE_TYPE_NO_EXP | BATTLE_TYPE_AI))) {
        for (battler = 0; battler < 4; battler++) {
            if (battler & 1) {
                for (i = 0; i < 4; i++) {
                    item = BattleSystem_GetTrainerItem(battleSystem, battler, i);
                    if (item != 0) {
                        ctx->trainerAIData.unk68[battler >> 1][ctx->trainerAIData.unk99[battler >> 1]] = item;
                        ctx->trainerAIData.unk99[battler >> 1]++;
                    }
                }
            }
        }
    }

    ctx->unk_2134 = ov10_02220AAC;
}

static void ov12_0224E414(BattleSystem *battleSystem, BattleContext *ctx) {
    int battler;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    u32 data;

    for (battler = 0; battler < maxBattlers; battler++) {
        if (ctx->playerActions[battler].command != CONTROLLER_COMMAND_40) {
            if (ctx->unk_314C[battler] & 1) {
                data = ctx->playerActions[battler].command - CONTROLLER_COMMAND_FIGHT_INPUT + BATTLE_INPUT_FIGHT;
                ov12_0223BDDC(battleSystem, battler, data);
            }

            switch (ctx->playerActions[battler].command) {
            case CONTROLLER_COMMAND_FIGHT_INPUT:
                if (ctx->unk_314C[battler] & (1 << 1)) {
                    data = ctx->playerActions[battler].unk8;
                    ov12_0223BDDC(battleSystem, battler, data);
                }

                if (ctx->unk_314C[battler] & (1 << 2)) {
                    data = ctx->playerActions[battler].unk4 + 1;
                    ov12_0223BDDC(battleSystem, battler, data);
                }
                break;
            case CONTROLLER_COMMAND_ITEM_INPUT:
                data = ctx->playerActions[battler].unk8 & 0xFF;
                ov12_0223BDDC(battleSystem, battler, data);
                data = (ctx->playerActions[battler].unk8 & 0xFF00) >> 16;
                ov12_0223BDDC(battleSystem, battler, data);
                break;
            case CONTROLLER_COMMAND_POKEMON_INPUT:
                data = ctx->playerActions[battler].unk8 + 1;
                ov12_0223BDDC(battleSystem, battler, data);
                break;
            case CONTROLLER_COMMAND_RUN_INPUT:
                ov12_0223BDDC(battleSystem, battler, TRUE);
                break;
            default:
                break;
            }
        }
    }
}
