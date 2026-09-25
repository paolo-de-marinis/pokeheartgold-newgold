#include "battle/battle_command.h"

#include "global.h"

#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_script.h"
#include "constants/battle_script_imports.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/message_tags.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/opcode.h"
#include "constants/balls.h"
#include "constants/pokemon.h"
#include "constants/sndseq.h"

#include "battle/battle_022378C0.h"
#include "battle/battle_02265E28.h"
#include "battle/battle_controller.h"
#include "battle/battle_controller_opponent.h"
#include "battle/battle_controller_player.h"
#include "battle/battle_system.h"
#include "battle/overlay_12_0224E4FC.h"
#include "msgdata/msg/msg_0197.h"

#include "assert.h"
#include "gf_gfx_loader.h"
#include "item.h"
#include "naming_screen.h"
#include "obj_char_transfer.h"
#include "overlay_07.h"
#include "overlay_18.h"
#include "overlay_manager.h"
#include "palette.h"
#include "party.h"
#include "pokedex_util.h"
#include "pokemon.h"
#include "pokemon_icon_idx.h"
#include "pokemon_mood.h"
#include "render_window.h"
#include "screen_fade.h"
#include "sound.h"
#include "sound_chatot.h"
#include "sprite_system.h"
#include "sys_task_api.h"
#include "system.h"
#include "text.h"
#include "touchscreen.h"
#include "unk_02005D10.h"
#include "unk_02013534.h"
#include "unk_020163E0.h"
#include "unk_0208805C.h"

int BattleScriptReadWord(BattleContext *ctx);
static void BattleScriptIncrementPointer(BattleContext *ctx, int adrs);
static void BattleScriptJump(BattleContext *ctx, NarcId narcId, int adrs);
static void BattleScriptGotoSubscript(BattleContext *ctx, NarcId narcId, int adrs);
static void *BattleScriptGetVarPointer(BattleSystem *battleSystem, BattleContext *ctx, int var);
static int BattleSystem_GetBattlerIDBySide(BattleSystem *battleSystem, BattleContext *ctx, int side);
static void BattlerSetAbility(BattleContext *ctx, u8 a1, u16 ability);
static void BattlerSetItem(BattleContext *ctx, u8 battlerId, u16 item);
static void BattleScript_CalcEffortValues(Party *party, int slot, u32 species, u32 form);
static u32 BattleSystem_CalculateBallShakes(BattleSystem *battleSystem, BattleContext *ctx);
static u32 BattleScript_ScaleExpToLevel(u32 exp, u32 faintedLevel, u32 gainerLevel);
static u32 BattleScript_GainerExp(u32 exp, u32 faintedLevel, u32 gainerLevel, int expMonsCnt, int expShareMonsCnt, BOOL participated, BOOL holdsExpShare);
static s32 GetMonWeight(u16 species);
static void InitBattleMsgData(BattleContext *ctx, BattleMessageData *msgdata);
static int ov12_022480C0(BattleSystem *battleSystem, BattleContext *ctx, int side);
static int GetMoveMessageNo(BattleContext *ctx, int move);
static int ov12_0224810C(BattleContext *ctx, int);
static int ov12_02248184(BattleContext *ctx, int);
static int ov12_02248190(BattleContext *ctx, int);
static int ov12_0224819C(BattleSystem *battleSystem, BattleContext *ctx, int side);
static int ov12_022481D0(BattleContext *ctx, int);
static int ov12_022481DC(BattleContext *ctx, int);
static int ov12_022481E8(BattleSystem *battleSystem, BattleContext *ctx, int side);
static int ov12_02248200(BattleContext *ctx, int);
static int ov12_0224820C(BattleContext *ctx, int);
static int ov12_02248218(BattleSystem *battleSystem, BattleContext *ctx, int side);
static int ov12_02248220(BattleSystem *battleSystem, BattleContext *ctx, int side);
static void InitBattleMsg(BattleSystem *battleSystem, BattleContext *ctx, BattleMessageData *msgdata, BattleMessage *msg);
static void UpdateFriendshipFainted(BattleSystem *battleSystem, BattleContext *ctx, int battlerId);
static void BattleSystem_LoadLevelUpNameplate(BattleSystem *battleSystem, GetterWork *data, Pokemon *mon);
static void BattleSystem_UnloadLevelUpNameplate(BattleSystem *battleSystem, GetterWork *data);

BOOL RunBattleScript(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret;

    do {
        ret = sBattleScriptCommandTable[ctx->battleScriptBuffer[ctx->scriptSeqNo]](battleSystem, ctx);
    } while (ctx->battleContinueFlag == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_LINK) == 0);

    ctx->battleContinueFlag = 0;

    return ret;
}

BOOL BtlCmd_PlayEncounterAnimation(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    BattleController_EmitPlayEncounterAnimation(battleSystem, FALSE);
    return FALSE;
}

BOOL BtlCmd_SetPokemonEncounter(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    BattleScriptIncrementPointer(ctx, 1);
    switch (BattleScriptReadWord(ctx)) {
    default:
    case BATTLER_CATEGORY_ALL:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitPokemonEncounter(battleSystem, battlerId);
            BattleSystem_SetPokedexSeen(battleSystem, battlerId);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        break;
    case BATTLER_CATEGORY_ENEMY: {
        OpponentData *opponentData;
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitPokemonEncounter(battleSystem, battlerId);
                BattleSystem_SetPokedexSeen(battleSystem, battlerId);
            }
        }
        break;
    }
    }

    return FALSE;
}

BOOL BtlCmd_PokemonSlideIn(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);

    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    switch (BattleScriptReadWord(ctx)) {
    default:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitPokemonSlideIn(battleSystem, battlerId);
            BattleSystem_SetPokedexSeen(battleSystem, battlerId);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitPokemonSlideIn(battleSystem, battlerId);
                BattleSystem_SetPokedexSeen(battleSystem, battlerId);
            }
        }
        BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
        BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleSystem_ClearExperienceEarnFlags(ctx, battlerId);
                BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, battlerId);
                BattleController_EmitPokemonSlideIn(battleSystem, battlerId);
                BattleSystem_SetPokedexSeen(battleSystem, battlerId);
            }
        }
        break;
    case BATTLER_CATEGORY_ATTACKER:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdAttacker);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdAttacker);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdAttacker);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdAttacker);
        BattleController_EmitPokemonSlideIn(battleSystem, ctx->battlerIdAttacker);
        break;
    case BATTLER_CATEGORY_DEFENDER:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdTarget);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdTarget);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdTarget);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdTarget);
        BattleController_EmitPokemonSlideIn(battleSystem, ctx->battlerIdTarget);
        break;
    case BATTLER_CATEGORY_SWITCHED_MON:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdSwitch);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdSwitch);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdSwitch);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdSwitch);
        BattleController_EmitPokemonSlideIn(battleSystem, ctx->battlerIdSwitch);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_PokemonSendOut(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);

    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    switch (BattleScriptReadWord(ctx)) {
    default:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitPokemonSendOut(battleSystem, battlerId, 0, 0);
            BattleSystem_SetPokedexSeen(battleSystem, battlerId);
        }
        break;
    case 3:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitPokemonSendOut(battleSystem, battlerId, 0, 0);
                BattleSystem_SetPokedexSeen(battleSystem, battlerId);
            }
        }
        BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
        BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        break;
    case 4:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleSystem_ClearExperienceEarnFlags(ctx, battlerId);
                BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, battlerId);
                BattleController_EmitPokemonSendOut(battleSystem, battlerId, 0, 0);
                BattleSystem_SetPokedexSeen(battleSystem, battlerId);
            }
        }
        break;
    case 1:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdAttacker);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdAttacker);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdAttacker);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdAttacker);
        BattleController_EmitPokemonSendOut(battleSystem, ctx->battlerIdAttacker, 0, 0);
        break;
    case 2:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdTarget);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdTarget);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdTarget);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdTarget);
        BattleController_EmitPokemonSendOut(battleSystem, ctx->battlerIdTarget, 0, 0);
        break;
    case 6:
        opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdSwitch);
        if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, BATTLER_ENEMY2);
        } else {
            BattleSystem_ClearExperienceEarnFlags(ctx, ctx->battlerIdSwitch);
            BattleSystem_SetExperienceEarnFlags(battleSystem, ctx, ctx->battlerIdSwitch);
        }
        BattleSystem_SetPokedexSeen(battleSystem, ctx->battlerIdSwitch);
        BattleController_EmitPokemonSendOut(battleSystem, ctx->battlerIdSwitch, 0, 0);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_RecallPokemon(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);
    int side = BattleScriptReadWord(ctx);

    switch (side) {
    case BATTLER_CATEGORY_ALL:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitRecallPokemon(battleSystem, ctx, battlerId);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if ((opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) == 0) {
                BattleController_EmitRecallPokemon(battleSystem, ctx, battlerId);
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY && !(ctx->switchInFlag & MaskOfFlagNo(battlerId))) {
                BattleController_EmitRecallPokemon(battleSystem, ctx, battlerId);
            }
        }
        break;
    default:
        BattleController_EmitRecallPokemon(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));
        break;
    }

    return FALSE;
}

BOOL BtlCmd_DeletePokemon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));
    BattleController_EmitDeletePokemon(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_SetTrainerEncounter(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    switch (BattleScriptReadWord(ctx)) {
    case 0:
    default:
        if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) {
            for (battlerId = 0; battlerId < battlersMax; battlerId++) {
                opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
                if (opponentData->battlerType != BATTLER_TYPE_PLAYER_SIDE_SLOT_2) {
                    BattleController_EmitTrainerEncounter(battleSystem, battlerId);
                }
            }
        } else {
            for (battlerId = 0; battlerId < battlersMax; battlerId++) {
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) && (battlerId > 1)) {
                    break;
                }
                BattleController_EmitTrainerEncounter(battleSystem, battlerId);
            }
        }
        break;
    case 3:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitTrainerEncounter(battleSystem, battlerId);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    case 4:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitTrainerEncounter(battleSystem, battlerId);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    }

    return FALSE;
}

BOOL BtlCmd_ThrowPokeball(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    u32 unkB = BattleScriptReadWord(ctx);
    u32 unkC = BattleScriptReadWord(ctx);

    switch (unkB) {
    case 0:
    default:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) && (battlerId > 1)) {
                break;
            }
            BattleController_EmitThrowPokeball(battleSystem, battlerId, unkC);
        }
        break;
    case 3:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitThrowPokeball(battleSystem, battlerId, unkC);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    case 4:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitThrowPokeball(battleSystem, battlerId, unkC);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

BOOL BtlCmd_TrainerSlideOut(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    u32 unkB = BattleScriptReadWord(ctx);

    switch (unkB) {
    case 0:
    default:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) && (battlerId > 1)) {
                break;
            }
            BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
        }
        break;
    case 3:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    case 4:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_MULTI) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TAG) == 0 && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)) {
                    break;
                }
            }
        }
        break;
    case 9:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_SOLO_PLAYER || opponentData->battlerType == BATTLER_TYPE_PLAYER_SIDE_SLOT_1) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                break;
            }
        }
        break;
    case 10:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_SOLO_ENEMY || opponentData->battlerType == BATTLER_TYPE_ENEMY_SIDE_SLOT_1) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                break;
            }
        }
        break;
    case 11:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_PLAYER_SIDE_SLOT_2) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                break;
            }
        }
        break;
    case 12:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_ENEMY_SIDE_SLOT_2) {
                BattleController_EmitTrainerSlideOut(battleSystem, battlerId);
                break;
            }
        }
        break;
    }

    return FALSE;
}

BOOL BtlCmd_TrainerSlideIn(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);

    u32 side = BattleScriptReadWord(ctx);
    u32 index = BattleScriptReadWord(ctx);

    switch (side) {
    case BATTLER_CATEGORY_ALL:
    default:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) && (battlerId > 1)) {
                break;
            }
            BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
                    break;
                }
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
                    break;
                }
            }
        }
        break;
    case BATTLER_CATEGORY_PLAYER_SLOT_1:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_SOLO_PLAYER || opponentData->battlerType == BATTLER_TYPE_PLAYER_SIDE_SLOT_1) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                break;
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY_SLOT_1:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_SOLO_ENEMY || opponentData->battlerType == BATTLER_TYPE_ENEMY_SIDE_SLOT_1) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                break;
            }
        }
        break;
    case BATTLER_CATEGORY_PLAYER_SLOT_2:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_PLAYER_SIDE_SLOT_2) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                break;
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY_SLOT_2:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType == BATTLER_TYPE_ENEMY_SIDE_SLOT_2) {
                BattleController_EmitTrainerSlideIn(battleSystem, battlerId, index);
                break;
            }
        }
        break;
    }

    return FALSE;
}

BOOL BtlCmd_BackgroundSlideIn(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    BattleScriptIncrementPointer(ctx, 1);

    for (battlerId = 0; battlerId < battlersMax; battlerId++) {
        BattleController_EmitBackgroundSlideIn(battleSystem, battlerId);
    }

    return FALSE;
}

BOOL BtlCmd_HealthbarSlideIn(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);
    int side = BattleScriptReadWord(ctx);

    switch (side) {
    case BATTLER_CATEGORY_ALL:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, 0);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if ((opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) == 0) {
                BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, 0);
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, 0);
            }
        }
        break;
    default:
        BattleController_EmitHealthbarSlideIn(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), 0);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_HealthbarSlideInDelay(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;
    u8 delay;

    BattleScriptIncrementPointer(ctx, 1);
    int side = BattleScriptReadWord(ctx);

    delay = 0;

    switch (side) {
    case BATTLER_CATEGORY_ALL:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, 0);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if ((opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) == 0) {
                BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, delay);
                delay += 4;
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitHealthbarSlideIn(battleSystem, ctx, battlerId, delay);
                delay += 4;
            }
        }
        break;
    default:
        BattleController_EmitHealthbarSlideIn(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), 0);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_HealthbarSlideOut(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);
    OpponentData *opponentData;

    BattleScriptIncrementPointer(ctx, 1);
    int side = BattleScriptReadWord(ctx);

    switch (side) {
    case BATTLER_CATEGORY_ALL:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            BattleController_EmitHealthbarSlideOut(battleSystem, battlerId);
        }
        break;
    case BATTLER_CATEGORY_PLAYER:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if ((opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) == 0 && (ctx->switchInFlag & MaskOfFlagNo(battlerId)) == 0) {
                BattleController_EmitHealthbarSlideOut(battleSystem, battlerId);
            }
        }
        break;
    case BATTLER_CATEGORY_ENEMY:
        for (battlerId = 0; battlerId < battlersMax; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                BattleController_EmitHealthbarSlideOut(battleSystem, battlerId);
            }
        }
        break;
    default:
        BattleController_EmitHealthbarSlideOut(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));
        break;
    }

    return FALSE;
}

BOOL BtlCmd_Wait(BattleSystem *battleSystem, BattleContext *ctx) {
    if (Link_QueueNotEmpty(ctx)) {
        BattleScriptIncrementPointer(ctx, 1);
    } else {
        Link_CheckTimeout(ctx);
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

// Reflect, Light Screen and Aurora Veil (battle_calc_damage.c, 6.9.1): a half
// in a single battle and 2732/4096 in any double one, however many are left
// standing on the side. HeartGold took the two thirds only while two stood
// there, and a half from a lone survivor. Future Sight asks too, for the
// damage it works out on the turn it is used.
static u32 ScreenModifier(BattleSystem *battleSystem, BattleContext *ctx, u32 moveNo, u32 sideCondition, int crit, int battlerIdAttacker) {
    u32 screen = BattleMoveCategory(ctx, moveNo, battlerIdAttacker) == CATEGORY_PHYSICAL ? SIDE_CONDITION_REFLECT : SIDE_CONDITION_LIGHT_SCREEN;

    if (!(sideCondition & (screen | SIDE_CONDITION_AURORA_VEIL)) || crit != 1 || BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_REMOVE_SCREENS || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_INFILTRATOR) {
        return UQ412__1_0;
    }
    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
        return UQ412__0_6666;
    }
    return UQ412__0_5;
}

// The type a type-resist Berry answers to, or -1 for any other item.
static int ResistBerryType(int holdEffect) {
    switch (holdEffect) {
    case HOLD_EFFECT_WEAKEN_NORMAL:
        return TYPE_NORMAL;
    case HOLD_EFFECT_WEAKEN_SE_FIRE:
        return TYPE_FIRE;
    case HOLD_EFFECT_WEAKEN_SE_WATER:
        return TYPE_WATER;
    case HOLD_EFFECT_WEAKEN_SE_ELECTRIC:
        return TYPE_ELECTRIC;
    case HOLD_EFFECT_WEAKEN_SE_GRASS:
        return TYPE_GRASS;
    case HOLD_EFFECT_WEAKEN_SE_ICE:
        return TYPE_ICE;
    case HOLD_EFFECT_WEAKEN_SE_FIGHT:
        return TYPE_FIGHTING;
    case HOLD_EFFECT_WEAKEN_SE_POISON:
        return TYPE_POISON;
    case HOLD_EFFECT_WEAKEN_SE_GROUND:
        return TYPE_GROUND;
    case HOLD_EFFECT_WEAKEN_SE_FLYING:
        return TYPE_FLYING;
    case HOLD_EFFECT_WEAKEN_SE_PSYCHIC:
        return TYPE_PSYCHIC;
    case HOLD_EFFECT_WEAKEN_SE_BUG:
        return TYPE_BUG;
    case HOLD_EFFECT_WEAKEN_SE_ROCK:
        return TYPE_ROCK;
    case HOLD_EFFECT_WEAKEN_SE_GHOST:
        return TYPE_GHOST;
    case HOLD_EFFECT_WEAKEN_SE_DRAGON:
        return TYPE_DRAGON;
    case HOLD_EFFECT_WEAKEN_SE_DARK:
        return TYPE_DARK;
    case HOLD_EFFECT_WEAKEN_SE_STEEL:
        return TYPE_STEEL;
    case HOLD_EFFECT_WEAKEN_SE_FAIRY:
        return TYPE_FAIRY;
    }
    return -1;
}

// The type-resist Berries (6.9.13, the reference's
// CanActivateDamageReductionBerry): a super-effective hit of the Berry's type,
// or any Normal hit for the Chilan Berry, is halved -- quartered with Ripen --
// inside the chain, so what Counter, Mirror Coat, Metal Burst, Shell Bell and
// the Endure and Focus Sash clamps see is the halved hit. The type is the
// move's as it lands, after Pixilate and the others, Liquid Voice or Ion
// Deluge. A substitute that takes the hit, a foe's Unnerve, Klutz and Embargo
// leave the Berry alone, and Struggle and the typeless hits never wake it.
// The mark left on the target has UpdateHp eat the Berry before the health
// bar moves (subscript 264).
static u32 ResistBerryModifier(BattleSystem *battleSystem, BattleContext *ctx, int moveType, int effectiveness) {
    int battlerIdTarget = ctx->battlerIdTarget;
    int berryType = ResistBerryType(GetBattlerHeldItemEffect(ctx, battlerIdTarget));
    int boost = 1;

    ctx->selfTurnData[battlerIdTarget].unk14 &= ~SELF_TURN_FLAG_RESIST_BERRY;
    if (berryType != moveType || effectiveness == 0 || (berryType != TYPE_NORMAL && effectiveness <= 8)) {
        return UQ412__1_0;
    }
    if (ctx->moveNoCur == MOVE_STRUGGLE || (ctx->battleStatus & (BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS | BATTLE_STATUS_IGNORE_TYPE_IMMUNITY))) {
        return UQ412__1_0;
    }
    if (SubstituteTakesHit(ctx, battlerIdTarget) == TRUE || BerryCanBeEaten(battleSystem, ctx, battlerIdTarget, &boost) == FALSE) {
        return UQ412__1_0;
    }
    ctx->selfTurnData[battlerIdTarget].unk14 |= SELF_TURN_FLAG_RESIST_BERRY;
    return boost > 1 ? UQ412__0_25 : UQ412__0_5;
}

// The order the final modifier visits the battlers in (the reference's
// SortRawSpeedNonRNGArray): by Speed as the summary shows it, with no stage,
// Tailwind or paralysis in it. A tie goes to the side of the host, which in a
// game against the machine is the player, and then to the left of the pair --
// the rule the reference's own comments give; its code puts the far side
// first and the player's right before its left. The reference would ask
// first which of the two has had its ability longer, but its counter moves
// for every battler at once and so never decides.
static BOOL RawSpeedGoesFirst(BattleSystem *battleSystem, const u32 *speed, int battlerIdA, int battlerIdB) {
    int sideA = BattleSystem_GetFieldSide(battleSystem, battlerIdA);
    int sideB = BattleSystem_GetFieldSide(battleSystem, battlerIdB);

    if (speed[battlerIdA] != speed[battlerIdB]) {
        return speed[battlerIdA] > speed[battlerIdB];
    }
    if (sideA != sideB) {
        return sideA == 0;
    }
    // The left one: 0 on the player's side, 3 facing it.
    return sideA == 0 ? battlerIdA < battlerIdB : battlerIdA > battlerIdB;
}

static int RawSpeedOrder(BattleSystem *battleSystem, BattleContext *ctx, int *order) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    u32 speed[BATTLER_MAX];
    int i, j;

    for (i = 0; i < maxBattlers; i++) {
        // A place left empty -- its Pokemon fainted and the party had none to
        // send in, so selectedMonIndex is 6 and the switch-in flag stays up --
        // has no Pokemon to read a Speed from, and comes last. It is kept in
        // the order for a Future Sight whose user stands in there with its
        // party stats (BattleContext_LandFutureSight), which bring no ability
        // and no item; the target is never an empty place, and its ally
        // counts only with HP.
        if (ctx->switchInFlag & MaskOfFlagNo(i)) {
            speed[i] = 0;
        } else {
            speed[i] = GetMonData(BattleSystem_GetPartyMon(battleSystem, i, ctx->selectedMonIndex[i]), MON_DATA_SPEED, NULL);
        }
        for (j = i; j > 0 && RawSpeedGoesFirst(battleSystem, speed, i, order[j - 1]); j--) {
            order[j] = order[j - 1];
        }
        order[j] = i;
    }
    return maxBattlers;
}

// The final modifier (6.9): every multiplier the reference chains into one
// Q4.12 number with QMul_RoundUp before it touches the damage, once. Past the
// moves' own doublings and the screens, the abilities and then the items are
// taken battler by battler in RawSpeedOrder, each battler's in the
// reference's order, since the rounding at each link makes the order show.
// effectiveness is the type chart's verdict in eighths, 8 neutral.
static u32 FinalDamageModifier(BattleSystem *battleSystem, BattleContext *ctx, int moveType, int effectiveness) {
    int battlerIdAttacker = ctx->battlerIdAttacker;
    int battlerIdTarget = ctx->battlerIdTarget;
    int ally = battlerIdTarget ^ 2;
    u32 moveNo = ctx->moveNoCur;
    int item = GetBattlerHeldItemEffect(ctx, battlerIdAttacker);
    u32 modifier = UQ412__1_0;
    int order[BATTLER_MAX];
    int count = RawSpeedOrder(battleSystem, ctx, order);
    int i;

    // Body Slam, Stomp and the other stamping moves do double against a
    // Pokemon that has used Minimize (6.9.14.1); HeartGold doubled Stomp's
    // power in its script and nothing else.
    if ((ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_MINIMIZE) && BattleMoveStampsOnMinimize(moveNo)) {
        modifier = QMul_RoundUp(modifier, UQ412__2_0);
    }
    // Earthquake against a Pokemon underground (6.9.14.2), Surf and Whirlpool
    // against one under the water (6.9.14.3); retail doubled their power in
    // the effect scripts instead.
    if ((ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_DIG) && moveNo == MOVE_EARTHQUAKE) {
        modifier = QMul_RoundUp(modifier, UQ412__2_0);
    }
    if ((ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_DIVE) && (moveNo == MOVE_SURF || moveNo == MOVE_WHIRLPOOL)) {
        modifier = QMul_RoundUp(modifier, UQ412__2_0);
    }
    // Collision Course and Electro Drift hit a third harder where they are
    // super effective (6.9.14.45), ahead of the screens.
    if (effectiveness > 8 && (moveNo == MOVE_COLLISION_COURSE || moveNo == MOVE_ELECTRO_DRIFT)) {
        modifier = QMul_RoundUp(modifier, UQ412__1_3333);
    }
    modifier = QMul_RoundUp(modifier, ScreenModifier(battleSystem, ctx, moveNo, ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerIdTarget)], ctx->criticalMultiplier, battlerIdAttacker));

    for (i = 0; i < count; i++) {
        int battlerId = order[i];

        if (battlerId == battlerIdAttacker && effectiveness != 0 && effectiveness < 8 && GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_TINTED_LENS) {
            modifier = QMul_RoundUp(modifier, UQ412__2_0);
        }
        if (battlerId == battlerIdAttacker && effectiveness > 8 && GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_NEUROFORCE) {
            modifier = QMul_RoundUp(modifier, UQ412__1_25);
        }
        // Prism Armor is the same 0.75 as Filter and Solid Rock and shares
        // their one if, so a mon reading as two of them still only takes it
        // once. It is read raw: Mold Breaker does not turn it off.
        if (battlerId == battlerIdTarget && effectiveness > 8 && (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FILTER) == TRUE || CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SOLID_ROCK) == TRUE || GetBattlerAbility(ctx, battlerIdTarget) == ABILITY_PRISM_ARMOR)) {
            modifier = QMul_RoundUp(modifier, UQ412__0_75);
        }
        // Sniper
        if (battlerId == battlerIdAttacker && ctx->criticalMultiplier == 3) {
            modifier = QMul_RoundUp(modifier, UQ412__1_5);
        }
        // Fluffy's two halves are siblings and not a chain: a contact Fire
        // move takes both and so comes out unchanged.
        if (battlerId == battlerIdTarget && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLUFFY) == TRUE) {
            if (BattleMoveMakesContact(ctx, moveNo) == TRUE) {
                modifier = QMul_RoundUp(modifier, UQ412__0_5);
            }
            if (moveType == TYPE_FIRE) {
                modifier = QMul_RoundUp(modifier, UQ412__2_0);
            }
        }
        // Multiscale and Shadow Shield are one condition and one halving.
        // Shadow Shield is read raw: Mold Breaker does not turn it off.
        if (battlerId == battlerIdTarget && (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_MULTISCALE) == TRUE || GetBattlerAbility(ctx, battlerIdTarget) == ABILITY_SHADOW_SHIELD) && ctx->battleMons[battlerIdTarget].hp == (s32)ctx->battleMons[battlerIdTarget].maxHp) {
            modifier = QMul_RoundUp(modifier, UQ412__0_5);
        }
        // Friend Guard belongs to the target's ALLY, so it exists only in a
        // double battle; the order holds only the battlers the battle has.
        if (battlerId == ally && ctx->battleMons[ally].hp && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, ally, ABILITY_FRIEND_GUARD) == TRUE) {
            modifier = QMul_RoundUp(modifier, UQ412__0_75);
        }
        // Punk Rock's other half; the base power boost is in CalcMoveDamage.
        if (battlerId == battlerIdTarget && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_PUNK_ROCK) == TRUE && BattleMoveIsSoundBased(moveNo) == TRUE) {
            modifier = QMul_RoundUp(modifier, UQ412__0_5);
        }
        // Ice Scales halves every special move, whether or not that move is
        // the kind that reads Sp. Def -- Psyshock is halved too. The
        // reference's loop applies it once for every battler on the field, a
        // quarter in a single battle and a sixteenth in a double, because
        // this one test lacks the "is this battler the target" the rest of
        // the loop has. Once, as its own comment and the published ability
        // say.
        if (battlerId == battlerIdTarget && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_ICE_SCALES) == TRUE && BattleMoveCategory(ctx, moveNo, battlerIdAttacker) == CATEGORY_SPECIAL) {
            modifier = QMul_RoundUp(modifier, UQ412__0_5);
        }
    }

    for (i = 0; i < count; i++) {
        int battlerId = order[i];

        // The Metronome item: a fifth more for each use of the move in a
        // row, up to double on the sixth, the reference's 1.2, 1.4, 1.6, 1.8
        // and 2.0. HeartGold's was a tenth, and double only on the eleventh.
        if (battlerId == battlerIdAttacker && item == HOLD_EFFECT_BOOST_REPEATED) {
            int turns = ctx->battleMons[battlerIdAttacker].unk88.metronomeTurns;

            modifier = QMul_RoundUp(modifier, UQ412__1_0 * (10 + 2 * (turns < 5 ? turns : 5)) / 10);
        }
        if (battlerId == battlerIdAttacker && effectiveness > 8 && item == HOLD_EFFECT_POWER_UP_SE) {
            modifier = QMul_RoundUp(modifier, UQ412__1_2);
        }
        if (battlerId == battlerIdTarget) {
            modifier = QMul_RoundUp(modifier, ResistBerryModifier(battleSystem, ctx, moveType, effectiveness));
        }
        if (battlerId == battlerIdAttacker && item == HOLD_EFFECT_HP_DRAIN_ON_ATK) {
            modifier = QMul_RoundUp(modifier, UQ412__1_3_BUT_LOWER);
        }
    }

    return modifier;
}

// An ordinary hit, in the order of the reference's CalcDamageOverall
// (battle_calc_damage.c, steps 6 to 11): the base damage, the spread, the
// weather, Glaive Rush, the critical hit, the roll, STAB and the type chart, a
// burn, the final modifier, Unseen Fist, and at least 1. HeartGold folded the
// burn, the screens, the spread and the weather into the base, and applied the
// type chart and what hangs off it after the roll, from the controller.
// CalcMaxDamage is the same without the roll; no script asks for it now that
// Spit Up rolls as the reference's does.
static void DamageCalcDefault(BattleSystem *battleSystem, BattleContext *ctx, BOOL roll) {
    int battlerIdAttacker = ctx->battlerIdAttacker;
    int battlerIdTarget = ctx->battlerIdTarget;
    u32 moveNo = ctx->moveNoCur;
    int type = BattleMoveAdjustedType(ctx, battlerIdAttacker, moveNo);
    int range = BattleMoveTbl(ctx, moveNo)->range;
    u32 moveStatusFlag = 0;
    int effectiveness;
    u32 damage;
    u32 weather;

    // Me First's copy is boosted only on the turn it was copied; the half
    // again itself is on the power, in CalcMoveDamage.
    if (ctx->battleMons[battlerIdAttacker].unk88.meFirstFlag) {
        if (ctx->meFirstTotal == ctx->battleMons[battlerIdAttacker].unk88.meFirstCount) {
            ctx->battleMons[battlerIdAttacker].unk88.meFirstCount--;
        }
        if ((ctx->meFirstTotal - ctx->battleMons[battlerIdAttacker].unk88.meFirstCount) >= 2) {
            ctx->battleMons[battlerIdAttacker].unk88.meFirstFlag = 0;
        }
    }

    damage = CalcMoveDamage(battleSystem, ctx, moveNo, ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerIdTarget)], ctx->fieldCondition, ctx->movePower, type, battlerIdAttacker, battlerIdTarget, ctx->criticalMultiplier);

    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)
        && ((range == RANGE_ADJACENT_OPPONENTS && GetMonsHitCount(battleSystem, ctx, 1, battlerIdTarget) == 2)
            || (range == RANGE_ALL_ADJACENT && GetMonsHitCount(battleSystem, ctx, 0, battlerIdTarget) >= 2))) {
        damage = QMul_RoundDown(damage, UQ412__0_75);
    }

    // Parental Bond's second strike takes a quarter (6.2), as from Sun and
    // Moon on; the moves that do fixed damage do not come through here, and
    // strike twice for the same.
    if (ParentalBond_IsSecondStrike(ctx)) {
        damage = QMul_RoundDown(damage, UQ412__0_25);
    }

    // The weather as the attacker's move sees it: under Mega Sol, the sun's.
    // Hydro Steam is the Water move the sun helps rather than hinders, and
    // a Utility Umbrella on the one using it takes that away, leaving the
    // halving every other Water move gets. Then a Utility Umbrella on the
    // target keeps the rain and the sun from changing a Fire or Water move
    // aimed at it (Pokemon Central, Superombrello, Idrovapore), which the
    // reference does not ask; Hydro Steam's help is its user's alone.
    weather = BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdTarget);
    if ((BattlerMoveWeatherAt(battleSystem, ctx, battlerIdAttacker, battlerIdAttacker) & FIELD_CONDITION_SUN_ALL) && type == TYPE_WATER && moveNo == MOVE_HYDRO_STEAM) {
        damage = QMul_RoundDown(damage, UQ412__1_5);
        weather = 0;
    }
    if (weather & FIELD_CONDITION_RAIN_ALL) {
        switch (type) {
        case TYPE_FIRE:
            damage = QMul_RoundDown(damage, UQ412__0_5);
            break;
        case TYPE_WATER:
            damage = QMul_RoundDown(damage, UQ412__1_5);
            break;
        }
    }
    if (weather & FIELD_CONDITION_SUN_ALL) {
        switch (type) {
        case TYPE_FIRE:
            damage = QMul_RoundDown(damage, UQ412__1_5);
            break;
        case TYPE_WATER:
            damage = QMul_RoundDown(damage, UQ412__0_5);
            break;
        }
    }

    // Glaive Rush: whoever used it last takes double until it moves again.
    if (ctx->moveConditions[battlerIdTarget].glaiveRush) {
        damage = damage * 200 / 100;
    }

    if (ctx->criticalMultiplier > 1) {
        damage = damage * 150 / 100;
    }

    if (roll) {
#ifdef NEWGOLD_DIAG
        Diag_RollNext(DIAG_ROLL_DAMAGE);
#endif
        damage = damage * (100 - BattleSystem_Random(battleSystem) % 16) / 100;
    }

    damage = CalcTypeEffectiveness(battleSystem, ctx, moveNo, ctx->moveType, battlerIdAttacker, battlerIdTarget, damage, &moveStatusFlag, &effectiveness);

    // A burn halves a physical move, unless Guts has made use of it or the
    // move is Facade, which the burn powers instead (the reference's 6.8, the
    // rule from X and Y on). HeartGold halved Facade too.
    if (BattleMoveCategory(ctx, moveNo, battlerIdAttacker) == CATEGORY_PHYSICAL && (ctx->battleMons[battlerIdAttacker].status & STATUS_BURN) && GetBattlerAbility(ctx, battlerIdAttacker) != ABILITY_GUTS && moveNo != MOVE_FACADE) {
        damage = QMul_RoundDown(damage, UQ412__0_5);
    }

    damage = QMul_RoundDown(damage, FinalDamageModifier(battleSystem, ctx, type, effectiveness));

    // Whatever Unseen Fist or Piercing Drill got through a Protect with, it
    // got through weakened. The reference asks only whether this target was
    // protecting, not whether the move touched -- the contact test already
    // happened where the move was let through, in BattleSystem_CheckMoveEffect.
    if ((GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_UNSEEN_FIST || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_PIERCING_DRILL) && ctx->turnData[battlerIdTarget].protectFlag) {
        damage = QMul_RoundDown(damage, UQ412__0_25);
    }

    if (damage == 0) {
        damage = 1;
    }
    // The reference's step 12: the damage is a 16-bit number.
    ctx->damage = damage % 65536;
}

// A Gem powers the first damaging move of its own type its holder uses, by
// three tenths, and is spent. The reference decides it before the move runs
// (BattleController_BeforeMove.c:1103 at d0380a487): not a status move, not
// Struggle, not one of the Pledges, and the Gem's type -- its holdEffectParam
// -- the move's type after everything that changes it. Here the damage is
// worked out in the move's script, before anyone knows whether the move hits,
// so it is decided here, where the type is final; the Gem is spent in
// ov12_0224C678 once the move connects, which is the reference's "only if it
// hits something". Once set the boost stays for the rest of the move, the
// other hits and targets included, with the Gem already gone.
static BOOL BattlerGemPowersMove(BattleContext *ctx, int battlerId, u32 moveNo, int type) {
    return GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_POWERING_UP_MOVE_ONCE
        && GetHeldItemModifier(ctx, battlerId, 0) == type
        && BattleMoveTbl(ctx, moveNo)->category != CATEGORY_STATUS
        && moveNo != MOVE_STRUGGLE
        && moveNo != MOVE_WATER_PLEDGE && moveNo != MOVE_FIRE_PLEDGE && moveNo != MOVE_GRASS_PLEDGE;
}

void TrySetGemBoost(BattleContext *ctx) {
    if (BattlerGemPowersMove(ctx, ctx->battlerIdAttacker, ctx->moveNoCur, BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur))) {
        ctx->gemBoostingMove = TRUE;
    }
}

BOOL BtlCmd_CalcDamage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    TrySetGemBoost(ctx);
    DamageCalcDefault(battleSystem, ctx, TRUE);
    ctx->damage *= -1;

    return FALSE;
}

BOOL BtlCmd_CalcDamageRaw(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    TrySetGemBoost(ctx);
    DamageCalcDefault(battleSystem, ctx, FALSE);
    ctx->damage *= -1;

    return FALSE;
}

BOOL BtlCmd_PrintAttackMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if (!(ctx->battleStatus & BATTLE_STATUS_NO_ATTACK_MESSAGE)) {
        BattleController_EmitPrintAttackMessage(battleSystem, ctx);
    }

    ctx->battleStatus |= BATTLE_STATUS_NO_ATTACK_MESSAGE;
    ctx->battleStatus2 |= BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE;

    return FALSE;
}

BOOL BtlCmd_PrintMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleMessageData msgdata;
    BattleMessage msg;

    BattleScriptIncrementPointer(ctx, 1);

    InitBattleMsgData(ctx, &msgdata);
    InitBattleMsg(battleSystem, ctx, &msgdata, &msg);
    BattleController_EmitPrintMessage(battleSystem, ctx, &msg);

    return FALSE;
}

BOOL BtlCmd_PrintGlobalMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleMessageData msgdata;
    BattleMessage msg;

    BattleScriptIncrementPointer(ctx, 1);

    InitBattleMsgData(ctx, &msgdata);
    InitBattleMsg(battleSystem, ctx, &msgdata, &msg);

    msg.tag |= 128;

    BattleController_EmitPrintMessage(battleSystem, ctx, &msg);

    return FALSE;
}

BOOL BtlCmd_PrintBufferedMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    BattleController_EmitPrintMessage(battleSystem, ctx, &ctx->buffMsg);
    return FALSE;
}

BOOL BtlCmd_BufferMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleMessageData msgdata;

    BattleScriptIncrementPointer(ctx, 1);

    InitBattleMsgData(ctx, &msgdata);
    InitBattleMsg(battleSystem, ctx, &msgdata, &ctx->buffMsg);

    return FALSE;
}

BOOL BtlCmd_BufferLocalMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleMessageData msgdata;
    BattleMessage msg;

    BattleScriptIncrementPointer(ctx, 1);

    u32 side = BattleScriptReadWord(ctx);

    InitBattleMsgData(ctx, &msgdata);
    InitBattleMsg(battleSystem, ctx, &msgdata, &msg);

    msg.tag |= 64;
    msg.battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitPrintMessage(battleSystem, ctx, &msg);

    return FALSE;
}

// The animation archive stops where retail's moves stopped, so an added move
// borrows one. Which one is a judgement about what the move looks like, kept
// here beside the only place that asks.
static u16 MoveAnimationFor(u16 move) {
    static const u16 borrowed[NUM_ADDED_MOVES] = {
        MOVE_AERIAL_ACE,   // Acrobatics
        MOVE_MAGNITUDE,    // Bulldoze
        MOVE_BULK_UP,      // Coil
        MOVE_SWIFT,        // Dazzling Gleam
        MOVE_HYPER_VOICE,  // Echoed Voice
        MOVE_SHADOW_BALL,  // Hex
        MOVE_FLASH_CANNON, // Moonblast
        MOVE_FLAMETHROWER, // Mystical Fire
        MOVE_PETAL_DANCE,  // Petal Blizzard
        MOVE_DRAGON_DANCE, // Quiver Dance
        MOVE_SHADOW_PUNCH, // Rage Fist
        MOVE_SPIDER_WEB,   // Sticky Web
        MOVE_BUG_BUZZ,     // Struggle Bug
        MOVE_BULLET_SEED,  // Solar Seeds, which is what the reference copies
        MOVE_PSYBEAM,      // Twin Beam
        MOVE_DRILL_PECK,   // Hyper Drill
        MOVE_HELPING_HAND, // Dragon Cheer
        MOVE_ZEN_HEADBUTT, // Psyshield Bash
        MOVE_TWINEEDLE,    // Fell Stinger
        MOVE_WHIRLPOOL,    // Infestation
        MOVE_STRING_SHOT,  // Toxic Thread
        MOVE_ICE_BEAM,     // Freeze-Dry
        MOVE_SWIFT,        // Fairy Wind
        MOVE_SURF,         // Scald
        MOVE_FLAME_WHEEL,  // Flame Charge
        MOVE_FIRE_BLAST,   // Inferno
        MOVE_FOLLOW_ME,    // Rage Powder
        MOVE_LEER,         // Tearful Look
        MOVE_JUDGMENT,          // 468
        MOVE_JUDGMENT,          // 469
        MOVE_JUDGMENT,          // 470
        MOVE_TORMENT,           // Hone Claws
        MOVE_SANDSTORM,         // Wide Guard
        MOVE_HYPNOSIS,          // Guard Split
        MOVE_HYPNOSIS,          // Power Split
        MOVE_HYPNOSIS,          // Wonder Room
        MOVE_FUTURE_SIGHT,      // Psyshock
        MOVE_SLUDGE,            // Venoshock
        MOVE_SWORDS_DANCE,      // Autotomize
        MOVE_HYPNOSIS,          // Telekinesis
        MOVE_HYPNOSIS,          // Magic Room
        MOVE_ROCK_THROW,        // Smack Down
        MOVE_ROLLING_KICK,      // Storm Throw
        MOVE_LAVA_PLUME,        // Flame Burst
        MOVE_SLUDGE_BOMB,       // Sludge Wave
        MOVE_GYRO_BALL,         // Heavy Slam
        MOVE_DREAM_EATER,       // Synchronoise
        MOVE_THUNDER_SHOCK,     // Electro Ball
        MOVE_WITHDRAW,          // Soak
        MOVE_ROLLING_KICK,      // Low Sweep
        MOVE_ACID,              // Acid Spray
        MOVE_CRUNCH,            // Foul Play
        MOVE_SWORDS_DANCE,      // Simple Beam
        MOVE_SWORDS_DANCE,      // Entrainment
        MOVE_SWORDS_DANCE,      // After You
        MOVE_SWIFT,             // Round
        MOVE_HEADBUTT,          // Chip Away
        MOVE_ACID,              // Clear Smog
        MOVE_PSYWAVE,           // Stored Power
        MOVE_DETECT,            // Quick Guard
        MOVE_HYPNOSIS,          // Ally Switch
        MOVE_SWORDS_DANCE,      // Shell Smash
        MOVE_HYPNOSIS,          // Heal Pulse
        MOVE_WING_ATTACK,       // Sky Drop
        MOVE_METAL_SOUND,       // Shift Gear
        MOVE_ROLLING_KICK,      // Circle Throw
        MOVE_EMBER,             // Incinerate
        MOVE_TORMENT,           // Quash
        MOVE_SWORDS_DANCE,      // Reflect Type
        MOVE_HEADBUTT,          // Retaliate
        MOVE_VACUUM_WAVE,       // Final Gambit
        MOVE_SWORDS_DANCE,      // Bestow
        MOVE_SURF,              // Water Pledge
        MOVE_LAVA_PLUME,        // Fire Pledge
        MOVE_ENERGY_BALL,       // Grass Pledge
        MOVE_SHOCK_WAVE,        // Volt Switch
        MOVE_AURORA_BEAM,       // Frost Breath
        MOVE_DRAGON_CLAW,       // Dragon Tail
        MOVE_SWORDS_DANCE,      // Work Up
        MOVE_SHOCK_WAVE,        // Electroweb
        MOVE_THUNDER_PUNCH,     // Wild Charge
        MOVE_DIG,               // Drill Run
        MOVE_DRAGON_CLAW,       // Dual Chop
        MOVE_PSYCHO_CUT,        // Heart Stamp
        MOVE_SEED_BOMB,         // Horn Leech
        MOVE_JUMP_KICK,         // Sacred Sword
        MOVE_WATERFALL,         // Razor Shell
        MOVE_FLAME_WHEEL,       // Heat Crash
        MOVE_GIGA_DRAIN,        // Leaf Tornado
        MOVE_U_TURN,            // Steamroller
        MOVE_LEECH_SEED,        // Cotton Guard
        MOVE_DARK_PULSE,        // Night Daze
        MOVE_DREAM_EATER,       // Psystrike
        MOVE_RAGE,              // Tail Slap
        MOVE_AEROBLAST,         // Hurricane
        MOVE_MEGA_KICK,         // Head Charge
        MOVE_MAGNET_BOMB,       // Gear Grind
        MOVE_HEAT_WAVE,         // Searing Shot
        MOVE_JUDGMENT,          // Techno Blast
        MOVE_RAZOR_WIND,        // Relic Song
        MOVE_AURA_SPHERE,       // Secret Sword
        MOVE_AURORA_BEAM,       // Glaciate
        MOVE_THUNDER,           // Bolt Strike
        MOVE_FIRE_BLAST,        // Blue Flare
        MOVE_LAVA_PLUME,        // Fiery Dance
        MOVE_BLIZZARD,          // Freeze Shock
        MOVE_BLIZZARD,          // Ice Burn
        MOVE_DARK_PULSE,        // Snarl
        MOVE_ICE_PUNCH,         // Icicle Crash
        MOVE_FLARE_BLITZ,       // V Create
        MOVE_HEAT_WAVE,         // Fusion Flare
        MOVE_THUNDERBOLT,       // Fusion Bolt
        MOVE_HI_JUMP_KICK,      // Flying Press
        MOVE_DETECT,            // Mat Block
        MOVE_SLUDGE_BOMB,       // Belch
        MOVE_SAND_ATTACK,       // Rototiller
        MOVE_SHADOW_CLAW,       // Phantom Force
        MOVE_CONFUSE_RAY,       // Trick Or Treat
        MOVE_SWORDS_DANCE,      // Noble Roar
        MOVE_THUNDER_WAVE,      // Ion Deluge
        MOVE_SHOCK_WAVE,        // Parabolic Charge
        MOVE_LEECH_SEED,        // Forests Curse
        MOVE_RAZOR_WIND,        // Disarming Voice
        MOVE_TORMENT,           // Parting Shot
        MOVE_TORMENT,           // Topsy Turvy
        MOVE_RAZOR_WIND,        // Draining Kiss
        MOVE_SWORDS_DANCE,      // Crafty Shield
        MOVE_SWORDS_DANCE,      // Flower Shield
        MOVE_LEECH_SEED,        // Grassy Terrain
        MOVE_SWORDS_DANCE,      // Misty Terrain
        MOVE_THUNDER_WAVE,      // Electrify
        MOVE_POUND,             // Play Rough
        MOVE_HYPER_BEAM,        // Boomburst
        MOVE_SWORDS_DANCE,      // Fairy Lock
        MOVE_METAL_SOUND,       // Kings Shield
        MOVE_SWORDS_DANCE,      // Play Nice
        MOVE_SWORDS_DANCE,      // Confide
        MOVE_STONE_EDGE,        // Diamond Storm
        MOVE_HYDRO_PUMP,        // Steam Eruption
        MOVE_FUTURE_SIGHT,      // Hyperspace Hole
        MOVE_WHIRLPOOL,         // Water Shuriken
        MOVE_LEECH_SEED,        // Spiky Shield
        MOVE_SWORDS_DANCE,      // Aromatic Mist
        MOVE_THUNDER_WAVE,      // Eerie Impulse
        MOVE_POISON_POWDER,     // Venom Drench
        MOVE_STRING_SHOT,       // Powder
        MOVE_SWORDS_DANCE,      // Geomancy
        MOVE_THUNDER_WAVE,      // Magnetic Flux
        MOVE_SWORDS_DANCE,      // Happy Hour
        MOVE_THUNDER_WAVE,      // Electric Terrain
        MOVE_SWORDS_DANCE,      // Celebrate
        MOVE_SWORDS_DANCE,      // Hold Hands
        MOVE_SWORDS_DANCE,      // Baby Doll Eyes
        MOVE_SPARK,             // Nuzzle
        MOVE_POUND,             // Hold Back
        MOVE_MACH_PUNCH,        // Power Up Punch
        MOVE_AIR_SLASH,         // Oblivion Wing
        MOVE_EARTHQUAKE,        // Thousand Arrows
        MOVE_EARTHQUAKE,        // Thousand Waves
        MOVE_EARTHQUAKE,        // Lands Wrath
        MOVE_RAZOR_WIND,        // Light Of Ruin
        MOVE_HYDRO_PUMP,        // Origin Pulse
        MOVE_EARTHQUAKE,        // Precipice Blades
        MOVE_BRAVE_BIRD,        // Dragon Ascent
        MOVE_CRUNCH,            // Hyperspace Fury
        MOVE_GUILLOTINE,        // Breakneck Blitz Physical
        MOVE_SONIC_BOOM,        // Breakneck Blitz Special
        MOVE_LOW_KICK,          // All Out Pummeling Physical
        MOVE_VACUUM_WAVE,       // All Out Pummeling Special
        MOVE_PECK,              // Supersonic Skystrike Physical
        MOVE_GUST,              // Supersonic Skystrike Special
        MOVE_POISON_STING,      // Acid Downpour Physical
        MOVE_SMOG,              // Acid Downpour Special
        MOVE_FISSURE,           // Tectonic Rage Physical
        MOVE_MUD_SLAP,          // Tectonic Rage Special
        MOVE_ROCK_BLAST,        // Continental Crush Physical
        MOVE_ANCIENT_POWER,     // Continental Crush Special
        MOVE_FURY_CUTTER,       // Savage Spin Out Physical
        MOVE_SILVER_WIND,       // Savage Spin Out Special
        MOVE_LICK,              // Never Ending Nightmare Physical
        MOVE_NIGHT_SHADE,       // Never Ending Nightmare Special
        MOVE_GYRO_BALL,         // Corkscrew Crash Physical
        MOVE_MIRROR_SHOT,       // Corkscrew Crash Special
        MOVE_FLAME_WHEEL,       // Inferno Overdrive Physical
        MOVE_FIRE_SPIN,         // Inferno Overdrive Special
        MOVE_CLAMP,             // Hydro Vortex Physical
        MOVE_WHIRLPOOL,         // Hydro Vortex Special
        MOVE_BULLET_SEED,       // Bloom Doom Physical
        MOVE_GRASS_KNOT,        // Bloom Doom Special
        MOVE_SPARK,             // Gigavolt Havoc Physical
        MOVE_THUNDER_SHOCK,     // Gigavolt Havoc Special
        MOVE_PSYCHO_CUT,        // Shattered Psyche Physical
        MOVE_PSYWAVE,           // Shattered Psyche Special
        MOVE_ICICLE_SPEAR,      // Subzero Slammer Physical
        MOVE_SHEER_COLD,        // Subzero Slammer Special
        MOVE_DRAGON_CLAW,       // Devastating Drake Physical
        MOVE_DRAGON_RAGE,       // Devastating Drake Special
        MOVE_FLING,             // Black Hole Eclipse Physical
        MOVE_DARK_PULSE,        // Black Hole Eclipse Special
        MOVE_POUND,             // Twinkle Tackle Physical
        MOVE_RAZOR_WIND,        // Twinkle Tackle Special
        MOVE_VOLT_TACKLE,       // Catastropika
        MOVE_SAND_ATTACK,       // Shore Up
        MOVE_ATTACK_ORDER,      // First Impression
        MOVE_POISON_POWDER,     // Baneful Bunker
        MOVE_SHADOW_CLAW,       // Spirit Shackle
        MOVE_CRUNCH,            // Darkest Lariat
        MOVE_SURF,              // Sparkling Aria
        MOVE_ICE_PUNCH,         // Ice Hammer
        MOVE_SWORDS_DANCE,      // Floral Healing
        MOVE_EARTHQUAKE,        // High Horsepower
        MOVE_LEECH_SEED,        // Strength Sap
        MOVE_POWER_WHIP,        // Solar Blade
        MOVE_VINE_WHIP,         // Leafage
        MOVE_SWORDS_DANCE,      // Spotlight
        MOVE_SWORDS_DANCE,      // Laser Focus
        MOVE_METAL_SOUND,       // Gear Up
        MOVE_CRUNCH,            // Throat Chop
        MOVE_BUG_BUZZ,          // Pollen Puff
        MOVE_IRON_TAIL,         // Anchor Shot
        MOVE_HYPNOSIS,          // Psychic Terrain
        MOVE_X_SCISSOR,         // Lunge
        MOVE_BLAZE_KICK,        // Fire Lash
        MOVE_KNOCK_OFF,         // Power Trip
        MOVE_FIRE_BLAST,        // Burn Up
        MOVE_HYPNOSIS,          // Speed Swap
        MOVE_STEEL_WING,        // Smart Strike
        MOVE_POISON_POWDER,     // Purify
        MOVE_JUDGMENT,          // Revelation Dance
        MOVE_SPACIAL_REND,      // Core Enforcer
        MOVE_LEAF_BLADE,        // Trop Kick
        MOVE_HYPNOSIS,          // Instruct
        MOVE_BRAVE_BIRD,        // Beak Blast
        MOVE_SPACIAL_REND,      // Clanging Scales
        MOVE_DRAGON_RUSH,       // Dragon Hammer
        MOVE_BITE,              // Brutal Swing
        MOVE_MIST,              // Aurora Veil
        MOVE_SHADOW_FORCE,      // Sinister Arrow Raid
        MOVE_CRUNCH,            // Malicious Moonsault
        MOVE_HYDRO_CANNON,      // Oceanic Operetta
        MOVE_RAZOR_WIND,        // Guardian Of Alola
        MOVE_SHADOW_FORCE,      // Soul Stealing 7 Star Strike
        MOVE_THUNDER,           // Stoked Sparksurfer
        MOVE_SELFDESTRUCT,      // Pulverizing Pancake
        MOVE_SWORDS_DANCE,      // Extreme Evoboost
        MOVE_PSYCHO_BOOST,      // Genesis Supernova
        MOVE_ERUPTION,          // Shell Trap
        MOVE_RAZOR_WIND,        // Fleur Cannon
        MOVE_ZEN_HEADBUTT,      // Psychic Fangs
        MOVE_DIG,               // Stomping Tantrum
        MOVE_SHADOW_CLAW,       // Shadow Bone
        MOVE_ROCK_THROW,        // Accelerock
        MOVE_WATERFALL,         // Liquidation
        MOVE_PSYCHO_BOOST,      // Prismatic Laser
        MOVE_SHADOW_CLAW,       // Spectral Thief
        MOVE_IRON_TAIL,         // Sunsteel Strike
        MOVE_SHADOW_BALL,       // Moongeist Beam
        MOVE_THUNDER_PUNCH,     // Zing Zap
        MOVE_RAZOR_WIND,        // Natures Madness
        MOVE_MEGA_KICK,         // Multi Attack
        MOVE_THUNDER,           // 10 000 000 Volt Thunderbolt
        MOVE_ERUPTION,          // Mind Blown
        MOVE_VOLT_TACKLE,       // Plasma Fists
        MOVE_DREAM_EATER,       // Photon Geyser
        MOVE_PSYCHO_BOOST,      // Light That Burns The Sky
        MOVE_IRON_TAIL,         // Searing Sunraze Smash
        MOVE_SHADOW_BALL,       // Menacing Moonraze Maelstrom
        MOVE_POUND,             // Lets Snuggle Forever
        MOVE_ROCK_WRECKER,      // Splintered Stormshards
        MOVE_ROAR_OF_TIME,      // Clangorous Soulblaze
        MOVE_THUNDER_PUNCH,     // Zippy Zap
        MOVE_SURF,              // Splishy Splash
        MOVE_FLY,               // Floaty Fall
        MOVE_THUNDER_SHOCK,     // Pika Papow
        MOVE_WATER_PULSE,       // Bouncy Bubble
        MOVE_SHOCK_WAVE,        // Buzzy Buzz
        MOVE_FLAME_WHEEL,       // Sizzly Slide
        MOVE_FUTURE_SIGHT,      // Glitzy Glow
        MOVE_DARK_PULSE,        // Baddy Bad
        MOVE_LEAF_BLADE,        // Sappy Seed
        MOVE_ICE_BEAM,          // Freezy Frost
        MOVE_RAZOR_WIND,        // Sparkly Swirl
        MOVE_GUILLOTINE,        // Veevee Volley
        MOVE_MAGNET_BOMB,       // Double Iron Bash
        MOVE_SWORDS_DANCE,      // Max Guard
        MOVE_SPACIAL_REND,      // Dynamax Cannon
        MOVE_SURF,              // Snipe Shot
        MOVE_CRUNCH,            // Jaw Lock
        MOVE_SWORDS_DANCE,      // Stuff Cheeks
        MOVE_DETECT,            // No Retreat
        MOVE_SANDSTORM,         // Tar Shot
        MOVE_HYPNOSIS,          // Magic Powder
        MOVE_DRAGON_CLAW,       // Dragon Darts
        MOVE_SWORDS_DANCE,      // Teatime
        MOVE_DETECT,            // Octolock
        MOVE_THUNDER_PUNCH,     // Bolt Beak
        MOVE_WATERFALL,         // Fishious Rend
        MOVE_SWORDS_DANCE,      // Court Change
        MOVE_SACRED_FIRE,       // Max Flare
        MOVE_FURY_CUTTER,       // Max Flutterby
        MOVE_SPARK,             // Max Lightning
        MOVE_CONSTRICT,         // Max Strike
        MOVE_TRIPLE_KICK,       // Max Knuckle
        MOVE_LICK,              // Max Phantasm
        MOVE_ICICLE_SPEAR,      // Max Hailstorm
        MOVE_POISON_STING,      // Max Ooze
        MOVE_CLAMP,             // Max Geyser
        MOVE_PECK,              // Max Airstream
        MOVE_POUND,             // Max Starfall
        MOVE_DRAGON_CLAW,       // Max Wyrmwind
        MOVE_PSYCHO_CUT,        // Max Mindstorm
        MOVE_ROCK_BLAST,        // Max Rockfall
        MOVE_SAND_TOMB,         // Max Quake
        MOVE_BEAT_UP,           // Max Darkness
        MOVE_BULLET_SEED,       // Max Overgrowth
        MOVE_GYRO_BALL,         // Max Steelspike
        MOVE_DRAGON_DANCE,      // Clangorous Soul
        MOVE_SUBMISSION,        // Body Press
        MOVE_SWORDS_DANCE,      // Decorate
        MOVE_SEED_BOMB,         // Drum Beating
        MOVE_BULLET_PUNCH,      // Snap Trap
        MOVE_FLARE_BLITZ,       // Pyro Ball
        MOVE_IRON_TAIL,         // Behemoth Blade
        MOVE_IRON_TAIL,         // Behemoth Bash
        MOVE_VOLT_TACKLE,       // Aura Wheel
        MOVE_DRAGON_CLAW,       // Breaking Swipe
        MOVE_VINE_WHIP,         // Branch Poke
        MOVE_DISCHARGE,         // Overdrive
        MOVE_PETAL_DANCE,       // Apple Acid
        MOVE_LEAF_BLADE,        // Grav Apple
        MOVE_POUND,             // Spirit Break
        MOVE_RAZOR_WIND,        // Strange Steam
        MOVE_WITHDRAW,          // Life Dew
        MOVE_TORMENT,           // Obstruct
        MOVE_CRUNCH,            // False Surrender
        MOVE_FOCUS_PUNCH,       // Meteor Assault
        MOVE_ROAR_OF_TIME,      // Eternabeam
        MOVE_DOOM_DESIRE,       // Steel Beam
        MOVE_FUTURE_SIGHT,      // Expanding Force
        MOVE_IRON_TAIL,         // Steel Roller
        MOVE_DRAGON_CLAW,       // Scale Shot
        MOVE_POWER_GEM,         // Meteor Beam
        MOVE_SLUDGE_BOMB,       // Shell Side Arm
        MOVE_RAZOR_WIND,        // Misty Explosion
        MOVE_RAZOR_LEAF,        // Grassy Glide
        MOVE_SHOCK_WAVE,        // Rising Voltage
        MOVE_UPROAR,            // Terrain Pulse
        MOVE_U_TURN,            // Skitter Smack
        MOVE_LAVA_PLUME,        // Burning Jealousy
        MOVE_CRUNCH,            // Lash Out
        MOVE_SHADOW_FORCE,      // Poltergeist
        MOVE_POISON_POWDER,     // Corrosive Gas
        MOVE_DETECT,            // Coaching
        MOVE_WATERFALL,         // Flip Turn
        MOVE_ICE_BALL,          // Triple Axel
        MOVE_PECK,              // Dual Wingbeat
        MOVE_MUD_BOMB,          // Scorching Sands
        MOVE_LEECH_SEED,        // Jungle Healing
        MOVE_CRUNCH,            // Wicked Blow
        MOVE_CLAMP,             // Surging Strikes
        MOVE_DISCHARGE,         // Thunder Cage
        MOVE_ROAR_OF_TIME,      // Dragon Energy
        MOVE_PSYCHIC,           // Freezing Glare
        MOVE_DARK_PULSE,        // Fiery Wrath
        MOVE_JUMP_KICK,         // Thunderous Kick
        MOVE_ICE_PUNCH,         // Glacial Lance
        MOVE_SHADOW_BALL,       // Astral Barrage
        MOVE_FUTURE_SIGHT,      // Eerie Spell
        MOVE_POISON_JAB,        // Dire Claw
        MOVE_SWORDS_DANCE,      // Power Shift
        MOVE_ROCK_SLIDE,        // Stone Axe
        MOVE_RAZOR_WIND,        // Springtide Storm
        MOVE_LUSTER_PURGE,      // Mystical Power
        MOVE_FLARE_BLITZ,       // Raging Fury
        MOVE_CRABHAMMER,        // Wave Crash
        MOVE_FRENZY_PLANT,      // Chloroblast
        MOVE_ICE_PUNCH,         // Mountain Gale
        MOVE_DETECT,            // Victory Dance
        MOVE_EARTHQUAKE,        // Headlong Rush
        MOVE_POISON_FANG,       // Barb Barrage
        MOVE_FUTURE_SIGHT,      // Esper Wing
        MOVE_SHADOW_BALL,       // Bitter Malice
        MOVE_METAL_SOUND,       // Shelter
        MOVE_JUMP_KICK,         // Triple Arrows
        MOVE_OMINOUS_WIND,      // Infernal Parade
        MOVE_BITE,              // Ceaseless Edge
        MOVE_AEROBLAST,         // Bleakwind Storm
        MOVE_THUNDERBOLT,       // Wildbolt Storm
        MOVE_EARTH_POWER,       // Sandsear Storm
        MOVE_HYPNOSIS,          // Lunar Blessing
        MOVE_HYPNOSIS,          // Take Heart
        MOVE_RAZOR_WIND,        // Tera Blast
        MOVE_STRING_SHOT,       // Silk Trap
        MOVE_SUPERPOWER,        // Axe Kick
        MOVE_SHADOW_PUNCH,      // Last Respects
        MOVE_FUTURE_SIGHT,      // Lumina Crash
        MOVE_DRAGON_CLAW,       // Order Up
        MOVE_WATERFALL,         // Jet Punch
        MOVE_LEECH_SEED,        // Spicy Extract
        MOVE_IRON_TAIL,         // Spin Out
        MOVE_RAGE,              // Population Bomb
        MOVE_ICE_PUNCH,         // Ice Spinner
        MOVE_OUTRAGE,           // Glaive Rush
        MOVE_SWORDS_DANCE,      // Revival Blessing
        MOVE_ROCK_THROW,        // Salt Cure
        MOVE_CLAMP,             // Triple Dive
        MOVE_POISON_STING,      // Mortal Spin
        MOVE_SWORDS_DANCE,      // Doodle
        MOVE_SWORDS_DANCE,      // Fillet Away
        MOVE_CRUNCH,            // Kowtow Cleave
        MOVE_NEEDLE_ARM,        // Flower Trick
        MOVE_LAVA_PLUME,        // Torch Song
        MOVE_WATERFALL,         // Aqua Step
        MOVE_TAKE_DOWN,         // Raging Bull
        MOVE_DOOM_DESIRE,       // Make It Rain
        MOVE_ZEN_HEADBUTT,      // Psyblade
        MOVE_SURF,              // Hydro Steam
        MOVE_DARK_PULSE,        // Ruination
        MOVE_HI_JUMP_KICK,      // Collision Course
        MOVE_THUNDERBOLT,       // Electro Drift
        MOVE_SWORDS_DANCE,      // Shed Tail
        MOVE_MIST,              // Chilly Reception
        MOVE_SWORDS_DANCE,      // Tidy Up
        MOVE_MIST,              // Snowscape
        MOVE_BUG_BITE,          // Pounce
        MOVE_RAZOR_LEAF,        // Trailblaze
        MOVE_WATER_GUN,         // Chilling Water
        MOVE_FIRE_BLAST,        // Armor Cannon
        MOVE_BLAZE_KICK,        // Bitter Blade
        MOVE_VOLT_TACKLE,       // Double Shock
        MOVE_IRON_TAIL,         // Gigaton Hammer
        MOVE_FLING,             // Comeuppance
        MOVE_WATERFALL,         // Aqua Cutter
        MOVE_FIRE_PUNCH,        // Blazing Torque
        MOVE_CRUNCH,            // Wicked Torque
        MOVE_POISON_JAB,        // Noxious Torque
        MOVE_HI_JUMP_KICK,      // Combat Torque
        MOVE_POUND,             // Magical Torque
        MOVE_HYPER_BEAM,        // Blood Moon
        MOVE_ENERGY_BALL,       // Matcha Gotcha
        MOVE_GIGA_DRAIN,        // Syrup Bomb
        MOVE_LEAF_BLADE,        // Ivy Cudgel
        MOVE_THUNDER,           // Electro Shot
        MOVE_JUDGMENT,          // Tera Starstorm
        MOVE_DRAGON_PULSE,      // Fickle Beam
        MOVE_SUNNY_DAY,         // Burning Bulwark
        MOVE_SHOCK_WAVE,        // Thunderclap
        MOVE_STONE_EDGE,        // Mighty Cleave
        MOVE_MIRROR_SHOT,       // Tachyon Cutter
        MOVE_GYRO_BALL,         // Hard Press
        MOVE_RAZOR_WIND,        // Alluring Voice
        MOVE_FIRE_PUNCH,        // Temper Flare
        MOVE_VOLT_TACKLE,       // Supercell Slam
        MOVE_FUTURE_SIGHT,      // Psychic Noise
        MOVE_ROLLING_KICK,      // Upper Hand
        MOVE_SLUDGE_BOMB,       // Malignant Chain
    };

    if (move > NUM_MOVES && move <= NUM_MOVES_TOTAL) {
        return borrowed[move - NUM_MOVES - 1];
    }
    return move;
}

BOOL BtlCmd_PlayMoveAnimation(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 move;

    BattleScriptIncrementPointer(ctx, 1);
    u32 battler = BattleScriptReadWord(ctx);

    if (battler == BATTLER_NONE) {
        move = ctx->moveTemp;
    } else {
        move = ctx->moveNoCur;
    }

    if ((!(ctx->battleStatus & BATTLE_STATUS_MOVE_ANIMATIONS_OFF) && BattleSystem_AreBattleAnimationsOn(battleSystem) == TRUE) || move == MOVE_TRANSFORM) {
        ctx->battleStatus |= BATTLE_STATUS_MOVE_ANIMATIONS_OFF;
        BattleController_SetMoveAnimation(battleSystem, ctx, MoveAnimationFor(move));
    }

    if (!BattleSystem_AreBattleAnimationsOn(battleSystem)) {
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WAIT_MOVE_ANIMATION);
    }

    return FALSE;
}

BOOL BtlCmd_PlayMoveAnimationOnMons(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 move;

    BattleScriptIncrementPointer(ctx, 1);
    u32 battler = BattleScriptReadWord(ctx);
    u32 attackerSide = BattleScriptReadWord(ctx);
    u32 defenderSide = BattleScriptReadWord(ctx);

    if (battler == BATTLER_NONE) {
        move = ctx->moveTemp;
    } else {
        move = ctx->moveNoCur;
    }

    u32 attacker = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, attackerSide);
    u32 defender = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, defenderSide);

    if ((!(ctx->battleStatus & BATTLE_STATUS_MOVE_ANIMATIONS_OFF) && BattleSystem_AreBattleAnimationsOn(battleSystem) == TRUE) || move == MOVE_TRANSFORM) {
        ctx->battleStatus |= BATTLE_STATUS_MOVE_ANIMATIONS_OFF;
        ov12_0226343C(battleSystem, ctx, move, attacker, defender);
    }

    if (!BattleSystem_AreBattleAnimationsOn(battleSystem)) {
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_WAIT_MOVE_ANIMATION);
    }

    return FALSE;
}

BOOL BtlCmd_FlickerMon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 side = BattleScriptReadWord(ctx);

    BattleController_EmitMonFlicker(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), ctx->moveStatusFlag);

    return FALSE;
}

BOOL BtlCmd_UpdateHealthbarValue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    if ((ctx->battleMons[battlerId].hp + ctx->hpCalc) <= 0) {
        ctx->hitDamage = ctx->battleMons[battlerId].hp * -1;
    } else {
        ctx->hitDamage = ctx->hpCalc;
    }

    if (ctx->hitDamage < 0) {
        ctx->totalDamage[battlerId] += (-1 * ctx->hitDamage);
    }

    ctx->battleMons[battlerId].hp += ctx->hpCalc;

    if (ctx->battleMons[battlerId].hp < 0) {
        ctx->battleMons[battlerId].hp = 0;
    } else if (ctx->battleMons[battlerId].hp > ctx->battleMons[battlerId].maxHp) {
        ctx->battleMons[battlerId].hp = ctx->battleMons[battlerId].maxHp;
    }

    CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_UpdateHealthbar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitHealthbarUpdate(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)));

    return FALSE;
}

BOOL BtlCmd_TryFaintMon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    if (ctx->battleMons[battlerId].hp == 0) {
        ctx->battlerIdFainted = battlerId;
        ctx->battleStatus |= MaskOfFlagNo(battlerId) << BATTLE_STATUS_FAINTED_SHIFT;
        ctx->totalTimesFainted[battlerId]++;
        UpdateFriendshipFainted(battleSystem, ctx, battlerId);
        // An opponent defeated by the player's own Pokemon, for the
        // evolutions that count them: the one whose move it was. Not from a
        // place left empty, which has no Pokemon to count it: a Future Sight
        // that lands after its user fell with nothing to follow it.
        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != 0 && ctx->battlerIdAttacker < BattleSystem_GetMaxBattlers(battleSystem)
            && !(ctx->switchInFlag & MaskOfFlagNo(ctx->battlerIdAttacker))
            && BattleSystem_GetParty(battleSystem, ctx->battlerIdAttacker) == BattleSystem_GetParty(battleSystem, BATTLER_PLAYER)) {
            Mon_CountDefeatedMon(BattleSystem_GetPartyMon(battleSystem, ctx->battlerIdAttacker, ctx->selectedMonIndex[ctx->battlerIdAttacker]), ctx->battleMons[battlerId].species, ctx->battleMons[battlerId].item);
        }
    }

    return FALSE;
}

BOOL BtlCmd_PlayFaintAnimation(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitPlayFaintAnimation(battleSystem, ctx, ctx->battlerIdFainted);

    ctx->battleStatus &= (MaskOfFlagNo(ctx->battlerIdFainted) << BATTLE_STATUS_FAINTED_SHIFT) ^ -1;
    ctx->battleStatus2 |= MaskOfFlagNo(ctx->battlerIdFainted) << BATTLE_STATUS2_EXP_GAIN_SHIFT;
    ctx->playerActions[ctx->battlerIdFainted].command = CONTROLLER_COMMAND_40;

    InitFaintedWork(battleSystem, ctx, ctx->battlerIdFainted);

    // A Pokemon that faints in a form that lasts only for a battle goes back
    // to its own form, so a Revive or a Revival Blessing brings it back in
    // that form. Pokemon Central says so for Mimikyu, Zygarde and Ash-Greninja
    // (Fantasmanto, Sciamefusione, Morfosintonia), and says Aegislash, Zen
    // Mode Darmanitan and Minior are never in the battle form outside a fight
    // (Accendilotta, Stato Zen, Scudosoglia). It says nothing of Wishiwashi,
    // Morpeko, Meloetta, Cramorant, Castform, Cherrim or Ogerpon's Terastal
    // forms, and Showdown puts all of them back on a faint. The party slot is read
    // now, while the place still has it; at the end of the turn a place with
    // nothing to send in is left empty (ov12_0224D540), and SwitchAndUpdateMon
    // cannot find this Pokemon any more. Not an Eiscue's Noice Face, which
    // lasts until the battle ends, through a switch (Bulbapedia, Ice Face) and
    // through a faint (Showdown). Nor the forms a Pokemon keeps from the start
    // of a battle to its end: a crowned Zacian or Zamazenta, an Active
    // Xerneas, a Hero Palafin. Nor a Terapagos in its Terastal Form, which
    // Tera Shift gives it for the rest of the battle: Showdown's Tera Shift
    // (data/abilities.ts) changes the form for good, formeChange(...,
    // isPermanent) with no formeRegression, so the faint keeps it
    // (Battler_TeraShiftForm). Pokemon Central says nothing (Teramorfosi).
    {
        Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, ctx->battlerIdFainted, ctx->selectedMonIndex[ctx->battlerIdFainted]);

        switch (GetMonData(mon, MON_DATA_SPECIES, NULL)) {
        case SPECIES_EISCUE_NOICE_FACE:
        case SPECIES_ZACIAN_CROWNED:
        case SPECIES_ZAMAZENTA_CROWNED:
        case SPECIES_XERNEAS_ACTIVE:
        case SPECIES_PALAFIN_HERO:
        case SPECIES_TERAPAGOS_TERASTAL:
            break;
        default:
            Mon_RevertFormChange(mon);
            break;
        }
    }

    return FALSE;
}

BOOL BtlCmd_WaitButtonABTime(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int waitFrames = BattleScriptReadWord(ctx);
    int waitIncrement;

    if (!(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_LINK)) {
        if (gSystem.newKeys & 0xC03 || System_GetTouchNew()) {
            // TODO: Rename variable in struct
            ctx->unk_F0 = waitFrames;
        }
    }

    if (battleSystem->battleType & BATTLE_TYPE_LINK && !(battleSystem->battleSpecial & BATTLE_SPECIAL_RECORDING)) {
        waitIncrement = 2;
    } else {
        waitIncrement = 1;
    }

    if (waitFrames > ctx->unk_F0) {
        BattleScriptIncrementPointer(ctx, -2);
        ctx->unk_F0 += waitIncrement;
    } else {
        ctx->unk_F0 = 0;
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

BOOL BtlCmd_PlaySound(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 side = BattleScriptReadWord(ctx);
    u32 sound = BattleScriptReadWord(ctx);

    BattleController_EmitPlaySE(battleSystem, ctx, sound, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));

    return FALSE;
}

BOOL BtlCmd_CompareVarToValue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 opcode = BattleScriptReadWord(ctx);
    u32 varId = BattleScriptReadWord(ctx);
    int cmp = BattleScriptReadWord(ctx);
    u32 adrs = BattleScriptReadWord(ctx);

    int *var = BattleScriptGetVarPointer(battleSystem, ctx, varId);

    switch (opcode) {
    case OPCODE_EQU:
        if (*var != cmp) {
            adrs = 0;
        }
        break;
    case OPCODE_NEQ:
        if (*var == cmp) {
            adrs = 0;
        }
        break;
    case OPCODE_GT:
        if (*var <= cmp) {
            adrs = 0;
        }
        break;
    case OPCODE_LTE:
        if (*var > cmp) {
            adrs = 0;
        }
        break;
    case OPCODE_FLAG_SET:
        if (!(*var & cmp)) {
            adrs = 0;
        }
        break;
    case OPCODE_FLAG_NOT:
        if (*var & cmp) {
            adrs = 0;
        }
        break;
    case OPCODE_AND:
        if ((*var & cmp) != cmp) {
            adrs = 0;
        }
        break;
    }

    if (adrs) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CompareMonDataToValue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 opcode = BattleScriptReadWord(ctx);
    u32 side = BattleScriptReadWord(ctx);
    u32 varId = BattleScriptReadWord(ctx);
    int cmp = BattleScriptReadWord(ctx);
    u32 adrs = BattleScriptReadWord(ctx);

    int var = GetBattlerVar(ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), varId, NULL);

    switch (opcode) {
    case 0:
        if (var != cmp) {
            adrs = 0;
        }
        break;
    case 1:
        if (var == cmp) {
            adrs = 0;
        }
        break;
    case 2:
        if (var <= cmp) {
            adrs = 0;
        }
        break;
    case 3:
        if (var > cmp) {
            adrs = 0;
        }
        break;
    case 4:
        if (!(var & cmp)) {
            adrs = 0;
        }
        break;
    case 5:
        if (var & cmp) {
            adrs = 0;
        }
        break;
    case 6:
        if ((var & cmp) != cmp) {
            adrs = 0;
        }
        break;
    }

    if (adrs) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_FadeOutBattle(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitFadeOutBattle(battleSystem, ctx);

    return FALSE;
}

BOOL BtlCmd_GoToSubscript(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptJump(ctx, NARC_a_0_0_1, BattleScriptReadWord(ctx));

    return FALSE;
}

BOOL BtlCmd_GoToEffectScript(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int effect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;

    // A Petal Dance Dancer copies does not lock its dancer into a rampage
    // (btl_scr_cmd_24_jumptocurmoveeffectscript at d0380a487).
    if (ctx->dancing && effect == MOVE_EFFECT_CONTINUE_AND_CONFUSE_SELF) {
        effect = MOVE_EFFECT_HIT;
    }
    BattleScriptJump(ctx, NARC_a_0_3_0, effect);

    return FALSE;
}

// A move another move calls -- Metronome, Sleep Talk, Nature Power, Assist,
// Me First and Copycat (GoToMoveScript), and Mirror Move -- is used from the
// steps before a move (ov12_0224C38C) as a chosen one is, as the engine sends
// it back to them (GoBackToBeforeMove, BattleController_BeforeMove.c at
// d0380a487). Stance Change, the primal weathers, Powder, a target to go at,
// Magic Coat, Magic Bounce and Snatch, Lightning Rod and Storm Drain, and
// Parental Bond's second strike answer the move called, not the one calling
// (Pokemon Central, Accendilotta: Sleep Talk's Aegislash takes the form of
// the move it calls). The engine's Sleep Talk, Nature Power and Me First
// scripts do not go back -- for Sleep Talk its steps would ask again whether
// the sleeping user can move. Here what stops a Pokemon acting, the
// disobedience roll and the PP were the caller's and are not asked again, so
// every calling move goes back. The caller's script ends here.
static BOOL CallMove(BattleContext *ctx) {
    ctx->unk_2184 |= MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_STATUS_CHECK | MULTIHIT_CALLED_MOVE;
    ctx->commandNext = CONTROLLER_COMMAND_23;
    ctx->battleContinueFlag = TRUE;
    return TRUE;
}

BOOL BtlCmd_GoToMoveScript(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 unkA = BattleScriptReadWord(ctx);

    ctx->battleStatus &= ~BATTLE_STATUS_NO_ATTACK_MESSAGE;
    ctx->battleStatus &= ~BATTLE_STATUS_MOVE_ANIMATIONS_OFF;

    ctx->moveNoCur = ctx->moveTemp;

    if (unkA == 0) {
        ctx->battlerIdTarget = ov12_022506D4(battleSystem, ctx, ctx->battlerIdAttacker, (u16)ctx->moveTemp, 1, 0);
        ov12_02250A18(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveTemp);
        ctx->playerActions[ctx->battlerIdAttacker].unk4 = ctx->battlerIdTarget;
    }

    return CallMove(ctx);
}

BOOL BtlCmd_CalcCrit(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TUTORIAL) || (BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_FIRST_RIVAL)) {
        ctx->criticalMultiplier = 1;
    } else {
        ctx->criticalMultiplier = TryCriticalHit(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->criticalCnt, ov12_022581D4(battleSystem, ctx, 0, ctx->battlerIdTarget));
    }

    return FALSE;
}

// Whether the fainted battler -- or the caught one -- gives experience, and
// to how many.
static BOOL CountExpGainers(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, ctx->battlerIdFainted);

    if ((opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) && !(battleType & (BATTLE_TYPE_LINK | BATTLE_TYPE_SAFARI | BATTLE_TYPE_FRONTIER | BATTLE_TYPE_PAL_PARK))) {
        u16 itemNo;
        Pokemon *mon;
        // Only the counts are taken here, while every participant still has
        // its bit: the experience is worked out for each gainer at its own
        // level in Task_GetExp, which clears the bits as it goes.
        ctx->expMonsCnt = 0;
        ctx->expShareMonsCnt = 0;
        for (int i = 0; i < Party_GetCount(BattleSystem_GetParty(battleSystem, 0)); i++) {
            mon = BattleSystem_GetPartyMon(battleSystem, 0, i);
            if (GetMonData(mon, MON_DATA_SPECIES, 0) && GetMonData(mon, MON_DATA_HP, 0)) {
                if (ctx->unk_A4[(ctx->battlerIdFainted >> 1) & 1] & MaskOfFlagNo(i)) {
                    ctx->expMonsCnt++;
                }
                itemNo = GetMonData(mon, MON_DATA_HELD_ITEM, 0);
                if (GetItemVar(ctx, itemNo, ITEM_VAR_HOLD_EFFECT) == HOLD_EFFECT_EXP_SHARE) {
                    ctx->expShareMonsCnt++;
                }
            }
        }
        return TRUE;
    }
    return FALSE;
}

BOOL BtlCmd_CalcExpGain(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!CountExpGainers(battleSystem, ctx)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

static void Task_GetExp(SysTask *task, void *data);

enum {
    DATA_GET_EXP_PRINTER_ID = 0,
    DATA_GET_EXP_FRAME_COUNTER,
    DATA_GET_EXP_LEARNSET_INDEX,
    DATA_GET_EXP_PREV_PROGRESS_TO_NEXT_LEVEL,
    DATA_GET_EXP_MOVE_TO_LEARN,
    DATA_GET_EXP_MOVE_SLOT_TO_FORGET,
    DATA_GET_EXP_PARTY_SLOT,
};

// Task_GetExp holds ctx->getterWork while it runs, and at its end hands it
// back to what held it before: nothing, for a script's WaitGetExpTask, or the
// catch, which pays a capture's experience from inside (Task_GetPokemon).
static void StartGetExpTask(BattleSystem *battleSystem, BattleContext *ctx) {
    GetterWork *caller = ctx->getterWork;

    ctx->getterWork = Heap_Alloc(HEAP_ID_BATTLE, sizeof(GetterWork));

    ctx->getterWork->battleSystem = battleSystem;
    ctx->getterWork->ctx = ctx;
    ctx->getterWork->state = 0;
    ctx->getterWork->tempData[DATA_GET_EXP_PARTY_SLOT] = 0;
    ctx->getterWork->caller = caller;

    SysTask_CreateOnMainQueue(Task_GetExp, ctx->getterWork, 0);
}

BOOL BtlCmd_StartGetExpTask(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    StartGetExpTask(battleSystem, ctx);

    return FALSE;
}

BOOL BtlCmd_WaitGetExpTask(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->getterWork == NULL) {
        BattleScriptIncrementPointer(ctx, 1);
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

BOOL BtlCmd_WaitGetExpTaskLoop(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);

    return FALSE;
}

BOOL BtlCmd_ShowParty(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId, unkA, unkB;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    unkB = 0;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->unk_13C[battlerId] & 1) {
            unkB |= MaskOfFlagNo(battlerId);
            // Revival Blessing opens the menu to a fainted Pokemon of the
            // user's own (RevivalBlessingStep); a switch is not declined.
            BattleController_EmitShowMonList(battleSystem, ctx, battlerId,
                ctx->selfTurnData[battlerId].revivalBlessing ? BATTLE_PARTY_MODE_REVIVE : BATTLE_PARTY_MODE_FORCED_SWITCH, 0, 6);
        }
    }

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (BattleSystem_GetBattleType(battleSystem) == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_LINK)) {
            unkA = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
            if (!(unkB & MaskOfFlagNo(battlerId)) && !(unkB & MaskOfFlagNo(unkA))) {
                unkB |= MaskOfFlagNo(battlerId);
                BattleController_EmitShowWaitMessage(battleSystem, battlerId);
            }
        } else {
            if (!(unkB & MaskOfFlagNo(battlerId))) {
                BattleController_EmitShowWaitMessage(battleSystem, battlerId);
            }
        }
    }

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->unk_13C[battlerId] & 1) {
            ctx->battlerIdSwitch = battlerId;
            break;
        }
    }

    return FALSE;
}

BOOL BtlCmd_WaitMonSelection(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;

    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int switchCnt = 0;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->unk_13C[battlerId] & 1) {
            switchCnt++;
        }
    }

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if ((ctx->unk_13C[battlerId] & 1) && BattleBuffer_GetNext(ctx, battlerId)) {
            ctx->unk_21A0[battlerId] = ctx->battleBuffer[battlerId][0] - 1;
            switchCnt--;
            if (!(ctx->battleStatus2 & (MaskOfFlagNo(battlerId) << BATTLE_STATUS_FAINTED_SHIFT))) {
                ctx->battleStatus2 |= (MaskOfFlagNo(battlerId) << BATTLE_STATUS_FAINTED_SHIFT);
                BattleController_EmitShowWaitMessage(battleSystem, battlerId);
            }
        }
    }

    if (switchCnt == 0) {
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            if ((ctx->unk_13C[battlerId] & 1) && BattleBuffer_GetNext(ctx, battlerId)) {
                ov12_0223BDDC(battleSystem, battlerId, ctx->battleBuffer[battlerId][0]);
            }
        }
        ctx->battleStatus2 &= 0xf0ffffff;
        BattleScriptIncrementPointer(ctx, 1);
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

// Whether a Palafin leaving the field turns into its Hero Form: one in its
// Zero Form with the ability, not fainted and not transformed. The ability is
// read as hg-engine reads it, off the battler.
static BOOL Battler_TurnsHero(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].species == SPECIES_PALAFIN
        && ctx->battleMons[battlerId].ability == ABILITY_ZERO_TO_HERO
        && ctx->battleMons[battlerId].hp
        && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM);
}

BOOL BtlCmd_SwitchAndUpdateMon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    int battlerId;

    switch (side) {
    case BATTLER_CATEGORY_ATTACKER:
        battlerId = ctx->battlerIdAttacker;
        break;
    case BATTLER_CATEGORY_SWITCHED_MON:
        battlerId = ctx->battlerIdSwitch;
        break;
    case BATTLER_CATEGORY_FORCED_OUT:
        battlerId = ctx->battlerIdTarget;
        break;
    }

    // Regenerator mends what it can on the way out, before the slot is handed
    // to whatever comes in. The party copy has to be told: what is left in
    // battleMons is about to be overwritten by the incoming Pokemon.
    if (ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].hp < (int)ctx->battleMons[battlerId].maxHp && GetBattlerAbility(ctx, battlerId) == ABILITY_REGENERATOR) {
        ctx->battleMons[battlerId].hp += ctx->battleMons[battlerId].maxHp / 3;
        if (ctx->battleMons[battlerId].hp > (int)ctx->battleMons[battlerId].maxHp) {
            ctx->battleMons[battlerId].hp = ctx->battleMons[battlerId].maxHp;
        }
        CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
    }

    // hg-engine's TryRevertFormChange (battle_pokemon.c:1010): a battler in a
    // form that lasts only for a battle leaves in the form it came from. Not a
    // crowned Zacian or Zamazenta: hg-engine crowns them when the battle starts
    // and nowhere else, so it took the crown for the rest of the battle. Nor a
    // Palafin in its Hero Form, which it took by leaving: hg-engine sent it
    // back to its Zero Form the second time it left. Nor a Terapagos in its
    // Terastal Form, which keeps it here as through a faint
    // (BtlCmd_PlayFaintAnimation): put back in its Normal Form, it took Tera
    // Shift a second time on its way back in. Nor a place left empty,
    // where what fainted last has no party slot to be found at any more: a
    // Revive from the bag, or a Revival Blessing, fills it at the end of the
    // turn, and battleMons still holds the fallen one's form, which went back
    // in the party when it fainted (BtlCmd_PlayFaintAnimation).
    if (!(ctx->switchInFlag & MaskOfFlagNo(battlerId))
        && Species_GetBattleFormReversion(ctx->battleMons[battlerId].species) != SPECIES_NONE
        && ctx->battleMons[battlerId].species != SPECIES_ZACIAN_CROWNED
        && ctx->battleMons[battlerId].species != SPECIES_ZAMAZENTA_CROWNED
        && ctx->battleMons[battlerId].species != SPECIES_PALAFIN_HERO
        && ctx->battleMons[battlerId].species != SPECIES_TERAPAGOS_TERASTAL) {
        Mon_RevertFormChange(BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]));
    }
    // Zero to Hero (btl_scr_cmd_125, run from hg-engine's switch and
    // attack-then-switch subscripts): a Palafin that leaves the field of its
    // own accord comes back in its Hero Form. The Pokemon changes, not the
    // battler, which is on its way out.
    if (side != BATTLER_CATEGORY_FORCED_OUT && Battler_TurnsHero(ctx, battlerId)) {
        Mon_ChangeFormSpecies(BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]), SPECIES_PALAFIN_HERO);
    }

    ctx->unk_13C[battlerId] &= ~1;
    ctx->switchInFlag &= (MaskOfFlagNo(battlerId) ^ ~0);
    ctx->selectedMonIndex[battlerId] = ctx->unk_21A0[battlerId];
    ctx->unk_21A0[battlerId] = 6;

    BattleSystem_GetBattleMon(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);
    ov12_02256F78(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);

    ctx->hpTemp = ctx->battleMons[1].hp;

    InitSwitchWork(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_GoToIfAnySwitches(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    u32 adrs = BattleScriptReadWord(ctx);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->unk_13C[battlerId] & 1) {
            ctx->battlerIdSwitch = battlerId;
            BattleScriptIncrementPointer(ctx, adrs);
            break;
        }
    }

    return FALSE;
}

static void Task_GetPokemon(SysTask *task, void *data);

BOOL BtlCmd_StartCatchMonTask(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int captureType = BattleScriptReadWord(ctx);

    ctx->getterWork = (GetterWork *)Heap_Alloc(HEAP_ID_BATTLE, sizeof(GetterWork));
    ctx->getterWork->battleSystem = battleSystem;
    ctx->getterWork->ctx = ctx;
    ctx->getterWork->state = 0;
    ctx->getterWork->captureType = captureType;
    ctx->getterWork->ballID = ItemToBallId(ctx->itemTemp);

    SysTask_CreateOnMainQueue(Task_GetPokemon, ctx->getterWork, 0);

    return FALSE;
}

BOOL BtlCmd_WaitCatchMonTask(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->getterWork == NULL) {
        BattleScriptIncrementPointer(ctx, 1);
    }

    ctx->battleContinueFlag = 1;

    return FALSE;
}

BOOL BtlCmd_SetMultiHit(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int cnt = BattleScriptReadWord(ctx);
    int checkMultiHit = BattleScriptReadWord(ctx);

    int loadedDice = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_INCREASE_MULTI_STRIKE_MINIMUM;

    if (ctx->multiHitCountTemp == 0) {
        if (cnt == 0) {
            // Two and three hits 35% each, four and five 15% each: the odds
            // from Black and White on, rolled the way the reference rolls them.
            if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SKILL_LINK) {
                cnt = 5;
            } else if (ctx->battleMons[ctx->battlerIdAttacker].species == SPECIES_GRENINJA_ASH && ctx->moveNoCur == MOVE_WATER_SHURIKEN) {
                // Ash-Greninja's Water Shuriken lands three times, and no
                // Loaded Dice changes that. The reference asks for Greninja's
                // form 1, which in its own numbering is the Battle Bond form
                // and not Ash, so the species is named here instead.
                cnt = 3;
            } else {
                cnt = BattleSystem_Random(battleSystem) % 100;
                cnt = cnt < 35 ? 2 : cnt < 70 ? 3 : cnt < 85 ? 4 : 5;
                // Loaded Dice rolls the two-to-five count again as four or
                // five, and leaves a roll that already came up four or five
                // alone.
                if (loadedDice && cnt != 4 && cnt != 5) {
                    cnt = 5 - (BattleSystem_Random(battleSystem) % 2);
                }
            }
        }
        // Population Bomb is the move that asks for ten, and is the reason the
        // count is read here rather than only where it was rolled: with the
        // dice it hits four to ten times instead.
        if (cnt == 10 && loadedDice) {
            cnt = 10 - (BattleSystem_Random(battleSystem) % 7);
        }
        ctx->multiHitCount = cnt;
        ctx->multiHitCountTemp = cnt;
        // The moves that check accuracy per hit -- Triple Kick, Triple Axel,
        // Population Bomb -- stop doing that while the dice are held: the
        // reference gives every one of them the plain multi-hit move's rules
        // instead, so the first roll decides how many times it lands.
        ctx->checkMultiHit = loadedDice ? MULTIHIT_MULTI_HIT_MOVE : checkMultiHit;
    }

    return FALSE;
}

BOOL BtlCmd_UpdateVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int val = BattleScriptReadWord(ctx);

    int *var = BattleScriptGetVarPointer(battleSystem, ctx, varId);

    switch (opcode) {
    case OPCODE_SET:
        *var = val;
        break;
    case OPCODE_ADD:
        *var += val;
        break;
    case OPCODE_SUB:
        *var -= val;
        break;
    case OPCODE_FLAG_ON:
        *var |= val;
        break;
    case OPCODE_FLAG_OFF:
        *var &= (val ^ ~0);
        break;
    case OPCODE_MUL:
        *var *= val;
        break;
    case OPCODE_DIV:
        *var /= val;
        break;
    case OPCODE_LEFT_SHIFT:
        *var <<= val;
        break;
    case OPCODE_RIGHT_SHIFT: {
        u32 uvar = *var;
        *var = uvar >> val;
        break;
    }
    case OPCODE_FLAG_INDEX:
        *var = MaskOfFlagNo(val);
        break;
    case OPCODE_GET:
        GF_ASSERT(FALSE);
        break;
    case OPCODE_SUB_TO_ZERO:
        *var -= val;
        if (*var < 0) {
            *var = 0;
        }
        break;
    case OPCODE_BITWISE_XOR:
        *var ^= val;
        break;
    case OPCODE_BITWISE_AND:
        *var &= val;
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }

    return FALSE;
}

// Whether what a script is doing is the move's own doing -- the move's script,
// its effect on a hit, its added effect -- rather than an ability's, a held
// item's or Toxic Spikes', which Infiltrator does not carry past a substitute.
static BOOL SideEffectIsTheMoves(int statChangeType) {
    switch (statChangeType) {
    case SIDE_EFFECT_TYPE_NONE:
    case SIDE_EFFECT_TYPE_DIRECT:
    case SIDE_EFFECT_TYPE_INDIRECT:
    case SIDE_EFFECT_TYPE_MOVE_EFFECT:
        return TRUE;
    }
    return FALSE;
}

// From the eighth generation Inner Focus, Oblivious, Own Tempo and Scrappy
// keep Intimidate off, as Hyper Cutter always has (Pokemon Central,
// Prepotenza); a Mold Breaker gets through. Intimidate is the one ability
// that lowers another Pokemon's Attack. The reference asks none of them, and
// its AbilityFlags leaves Scrappy one Mold Breaker does not pass.
static BOOL AbilityShrugsOffIntimidate(BattleContext *ctx) {
    return CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_INNER_FOCUS) == TRUE
        || CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_OBLIVIOUS) == TRUE
        || CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_OWN_TEMPO) == TRUE
        || GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_SCRAPPY;
}

BOOL BtlCmd_ChangeStatStage(BattleSystem *battleSystem, BattleContext *ctx) {
    int change, stat;
    BattleMon *mon = &ctx->battleMons[ctx->battlerIdStatChange];

    BattleScriptIncrementPointer(ctx, 1);

    int unkA = BattleScriptReadWord(ctx);
    int unkB = BattleScriptReadWord(ctx);
    int unkC = BattleScriptReadWord(ctx);

    int unkD = 0;

    ctx->battleStatus &= ~BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;

    // Three stages at a time. Retail has no such move, so the four runs below
    // stop at two and these were imported without the reading half. The
    // reference's runs go attack first and evasion last; they came over here
    // back to front, and the drops came over a stat short, so sp. attack sits
    // on its own past the end of the table and the rest of its run steps over
    // the gap where it should have been.
    if (ctx->statChangeParam == MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_3_STAGES) {
        stat = STAT_SPATK - 1;
        change = -3;
        ctx->tempData = 13;
    } else if (ctx->statChangeParam >= MOVE_SUBSCRIPT_PTR_EVASION_UP_3_STAGES) {
        stat = MOVE_SUBSCRIPT_PTR_ATTACK_UP_3_STAGES - ctx->statChangeParam;
        change = 3;
        ctx->tempData = 12;
    } else if (ctx->statChangeParam >= MOVE_SUBSCRIPT_PTR_EVASION_DOWN_3_STAGES) {
        stat = MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_3_STAGES - ctx->statChangeParam;
        if (stat >= STAT_SPATK - 1) {
            stat++;
        }
        change = -3;
        ctx->tempData = 13;
    } else if (ctx->statChangeParam >= 46) {
        stat = ctx->statChangeParam - 46;
        change = -2;
        ctx->tempData = 13;
    } else if (ctx->statChangeParam >= 39) {
        stat = ctx->statChangeParam - 39;
        change = 2;
        ctx->tempData = 12;
    } else if (ctx->statChangeParam >= 22) {
        stat = ctx->statChangeParam - 22;
        change = -1;
        ctx->tempData = 13;
    } else {
        stat = ctx->statChangeParam - 15;
        change = 1;
        ctx->tempData = 12;
    }

    // Contrary turns the change round before anything is decided on its sign,
    // so the cap checks, the messages and the animation all follow the flip.
    if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_CONTRARY) == TRUE) {
        change = -change;
        ctx->tempData = (ctx->tempData == 12) ? 13 : 12;
    }

    if (change > 0) { // Stat Increase
        if (mon->statChanges[stat + 1] == 12) {
            ctx->battleStatus |= BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
            if (ctx->statChangeType == 3 || ctx->statChangeType == 2) {
                BattleScriptIncrementPointer(ctx, unkB);
            } else {
                // "{0}'s {1} won't go any higher!"
                ctx->buffMsg.id = msg_0197_00142;
                ctx->buffMsg.tag = TAG_NICKNAME_STAT;
                ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                ctx->buffMsg.param[1] = stat + 1;
                BattleScriptIncrementPointer(ctx, unkA);
            }
        } else {
            if (ctx->statChangeType == 3) {
                // "{0}'s {1} raised its {2}!"
                ctx->buffMsg.id = msg_0197_00622;
                ctx->buffMsg.tag = TAG_NICKNAME_ABILITY_STAT;
                ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                ctx->buffMsg.param[1] = ctx->battleMons[ctx->battlerIdStatChange].ability;
                ctx->buffMsg.param[2] = stat + 1;
            } else if (ctx->statChangeType == 5) {
                // "The {1} (sharply) raised {0}'s {2}!" -- the same pair the
                // plain sentence below is written as. Every held-item raise in
                // the tree was one stage until the Weakness Policy, which is
                // two, and the reference prints this bank's own 759 for it.
                ctx->buffMsg.id = (change == 1) ? msg_0197_00756 : msg_0197_00759;
                ctx->buffMsg.tag = TAG_NICKNAME_ITEM_STAT;
                ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                ctx->buffMsg.param[1] = ctx->itemTemp;
                ctx->buffMsg.param[2] = stat + 1;
            } else {
                // "{0}'s {1} (sharply) rose!"
                ctx->buffMsg.id = (change == 1) ? msg_0197_00750 : msg_0197_00753;
                ctx->buffMsg.tag = TAG_NICKNAME_STAT;
                ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                ctx->buffMsg.param[1] = stat + 1;
            }
            int stagesBefore = mon->statChanges[stat + 1];
            mon->statChanges[stat + 1] += change;
            if (mon->statChanges[stat + 1] > 12) {
                mon->statChanges[stat + 1] = 12;
            }
            ctx->statRaisedBattlers |= MaskOfFlagNo(ctx->battlerIdStatChange);
            // What a Mirror Herb or an Opportunist on the other side is to
            // copy -- not an Opportunist's copy, which Pokemon Central
            // (Foglia carbone, Scrocco) leaves to both uncopied, as Costar's.
            if (!(ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_OPPORTUNIST)) {
                RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdStatChange, stat + 1, mon->statChanges[stat + 1] - stagesBefore);
            }
            // For Burning Jealousy, for the rest of the turn.
            ctx->turnData[ctx->battlerIdStatChange].statRaised = TRUE;
        }
    } else { // Stat Decrease
        if (!(ctx->statChangeFlag & (1 << 27))) {
            if (ctx->battlerIdAttacker != ctx->battlerIdStatChange) {
                // Flower Veil shelters the Grass types on its own side. Each
                // slot is asked separately rather than through CheckAbilityActive
                // so that Mold Breaker can put out one flower and not the other.
                // An ally shelters only while it stands: a fainted one keeps
                // its ability in battleMons, and in a place left empty the
                // line naming it would read party slot 6.
                int flowerVeilHolder = -1;
                if (GetBattlerVar(ctx, ctx->battlerIdStatChange, BMON_DATA_TYPE_1, NULL) == TYPE_GRASS || GetBattlerVar(ctx, ctx->battlerIdStatChange, BMON_DATA_TYPE_2, NULL) == TYPE_GRASS || GetBattlerVar(ctx, ctx->battlerIdStatChange, BMON_DATA_TYPE_3, NULL) == TYPE_GRASS) {
                    int ally = BattleSystem_GetBattlerIdPartner(battleSystem, ctx->battlerIdStatChange);
                    if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_FLOWER_VEIL) == TRUE) {
                        flowerVeilHolder = ctx->battlerIdStatChange;
                    } else if (ally != ctx->battlerIdStatChange && ctx->battleMons[ally].hp && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ally, ABILITY_FLOWER_VEIL) == TRUE) {
                        flowerVeilHolder = ally;
                    }
                }
                // Mist. Infiltrator gets past it with its own moves, but not
                // past an ability's drop such as Intimidate, where the
                // attacker is not who is lowering the stat -- the reference
                // asks it only for those.
                if (ctx->fieldSideConditionData[BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdStatChange)].mistTurns
                    && (ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY || GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_INFILTRATOR)) {
                    // "{0} is protected by Mist!"
                    ctx->buffMsg.id = msg_0197_00273;
                    ctx->buffMsg.tag = TAG_NICKNAME;
                    ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                    unkD = 1;
                } else if (flowerVeilHolder != -1 || CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_CLEAR_BODY) == TRUE || CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_WHITE_SMOKE) == TRUE || GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_FULL_METAL_BODY) {
                    // Full Metal Body is Clear Body that Mold Breaker cannot get
                    // at, so it is the one ability above read raw. The message
                    // names whoever refused the drop, which for a Flower Veil
                    // held by the partner is not the target.
                    int blocker = (flowerVeilHolder != -1) ? flowerVeilHolder : ctx->battlerIdStatChange;
                    if (ctx->statChangeType == 3) {
                        // "{0}'s {1} suppressed {2}'s {3}!"
                        ctx->buffMsg.id = msg_0197_00727;
                        ctx->buffMsg.tag = TAG_NICKNAME_ABILITY_NICKNAME_ABILITY;
                        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, blocker);
                        ctx->buffMsg.param[1] = ctx->battleMons[blocker].ability;
                        ctx->buffMsg.param[2] = CreateNicknameTag(ctx, ctx->battlerIdAttacker);
                        ctx->buffMsg.param[3] = ctx->battleMons[ctx->battlerIdAttacker].ability;
                    } else {
                        // "{0}'s {1} prevents stat loss!"
                        ctx->buffMsg.id = msg_0197_00669;
                        ctx->buffMsg.tag = TAG_NICKNAME_ABILITY;
                        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, blocker);
                        ctx->buffMsg.param[1] = ctx->battleMons[blocker].ability;
                    }
                    unkD = TRUE;
                } else if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdStatChange) == HOLD_EFFECT_PREVENT_STAT_DROPS) {
                    // A Clear Amulet, which is Clear Body worn rather than
                    // born: it goes here, below the abilities and above Hyper
                    // Cutter, because that is where the reference puts it, and
                    // it refuses every stat rather than one of them. Mold
                    // Breaker has nothing to say to an item, so it is asked
                    // raw. The sentence is the abilities' own, row 704, which
                    // the reference prints for it too (ITEM_PREVENTS_STAT_LOSS):
                    // the tag buffers the item into slot 1, and a placeholder
                    // is read by its slot, not by the kind it is written as.
                    // "{0}'s {1} prevents {2} loss!"
                    ctx->buffMsg.id = msg_0197_00704;
                    ctx->buffMsg.tag = TAG_NICKNAME_ITEM_STAT;
                    ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                    ctx->buffMsg.param[1] = GetBattlerHeldItem(ctx, ctx->battlerIdStatChange);
                    ctx->buffMsg.param[2] = stat + 1;
                    unkD = TRUE;
                } else if ((CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_KEEN_EYE) == TRUE && (1 + stat) == 6) || (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_HYPER_CUTTER) == TRUE && (1 + stat) == 1) || (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_BIG_PECKS) == TRUE && (1 + stat) == 2) || (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_MINDS_EYE) == TRUE && (1 + stat) == 6) || (ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && (1 + stat) == STAT_ATK && AbilityShrugsOffIntimidate(ctx) == TRUE)) {
                    if (ctx->statChangeType == 3) {
                        // "{0}'s {1} suppressed {2}'s {3}!"
                        ctx->buffMsg.id = msg_0197_00727;
                        ctx->buffMsg.tag = TAG_NICKNAME_ABILITY_NICKNAME_ABILITY;
                        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                        ctx->buffMsg.param[1] = ctx->battleMons[ctx->battlerIdStatChange].ability;
                        ctx->buffMsg.param[2] = CreateNicknameTag(ctx, ctx->battlerIdAttacker);
                        ctx->buffMsg.param[3] = ctx->battleMons[ctx->battlerIdAttacker].ability;
                    } else {
                        // "{0}'s {1} prvents {2} loss!"
                        ctx->buffMsg.id = msg_0197_00704;
                        ctx->buffMsg.tag = TAG_NICKNAME_ABILITY_STAT;
                        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                        ctx->buffMsg.param[1] = ctx->battleMons[ctx->battlerIdStatChange].ability;
                        ctx->buffMsg.param[2] = stat + 1;
                    }
                    unkD = TRUE;
                } else if (mon->statChanges[1 + stat] == 0) {
                    ctx->battleStatus |= BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
                    if (ctx->statChangeType == 2 || ctx->statChangeType == 3) {
                        BattleScriptIncrementPointer(ctx, unkB);
                        return FALSE;
                    } else {
                        // "{0}'s {1} won't go lower!"
                        ctx->buffMsg.id = msg_0197_00145;
                        ctx->buffMsg.tag = TAG_NICKNAME_STAT;
                        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                        ctx->buffMsg.param[1] = stat + 1;
                        BattleScriptIncrementPointer(ctx, unkA);
                        return FALSE;
                    }
                } else if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdStatChange, ABILITY_SHIELD_DUST) == TRUE && ctx->statChangeType == 2) {
                    unkD = 1;
                } else if ((ctx->battleMons[ctx->battlerIdStatChange].status2 & STATUS2_SUBSTITUTE)
                    && !(SideEffectIsTheMoves(ctx->statChangeType) && MoveGoesRoundSubstitute(ctx, ctx->battlerIdStatChange))) {
                    unkD = 2;
                }
            } else if (mon->statChanges[1 + stat] == 0) {
                ctx->battleStatus |= BATTLE_STATUS_FAIL_STAT_STAGE_CHANGE;
                if (ctx->statChangeType == 2 || ctx->statChangeType == 3) {
                    BattleScriptIncrementPointer(ctx, unkB);
                    return FALSE;
                } else {
                    // "{0}'s {1} won't go lower!"
                    ctx->buffMsg.id = msg_0197_00145;
                    ctx->buffMsg.tag = TAG_NICKNAME_STAT;
                    ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
                    ctx->buffMsg.param[1] = stat + 1;
                    BattleScriptIncrementPointer(ctx, unkA);
                    return FALSE;
                }
            }
            if (unkD == 2 && ctx->statChangeType == 1) {
                BattleScriptIncrementPointer(ctx, unkC);
                return FALSE;
            } else if (unkD && ctx->statChangeType == 2) {
                BattleScriptIncrementPointer(ctx, unkB);
                return FALSE;
            } else if (unkD) {
                BattleScriptIncrementPointer(ctx, unkA);
                return FALSE;
            }
        }
        // "{0}'s {1} [harshly] fell!" -- an ability's drop too. The reference
        // names the ability in a popup and says only what fell
        // (btl_scr_cmd_33_statbuffchange.c), and its rows 662 to 668, retail's
        // "{0}'s {1} cuts {2}'s {3}!", are "(Unused)".
        ctx->buffMsg.id = (change == -1) ? msg_0197_00762 : msg_0197_00765;
        ctx->buffMsg.tag = TAG_NICKNAME_STAT;
        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdStatChange);
        ctx->buffMsg.param[1] = stat + 1;
        // Competitive and Defiant do not answer here, where the drop is only
        // half applied; the mark is set now and read in the pass after the
        // move. One Pokemon has one ability, so the two share the bit.
        if (ctx->battlerIdAttacker != ctx->battlerIdStatChange && (ctx->battlerIdAttacker & 1) != (ctx->battlerIdStatChange & 1) && (GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_COMPETITIVE || GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_DEFIANT)) {
            ctx->battleMons[ctx->battlerIdStatChange].competitivePending = TRUE;
        }
        mon->statChanges[stat + 1] += change;
        if (mon->statChanges[stat + 1] < 0) {
            mon->statChanges[stat + 1] = 0;
        }
        // For an Eject Pack, asked once the move is over, and for Lash Out,
        // for the rest of the turn.
        ctx->statLoweredBattlers |= MaskOfFlagNo(ctx->battlerIdStatChange);
        ctx->moveConditions[ctx->battlerIdStatChange].statLoweredThisTurn = TRUE;
    }

    return FALSE;
}

BOOL BtlCmd_UpdateMonData(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int val = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int var = GetBattlerVar(ctx, battlerId, varId, NULL);
    int before = var;
    int stage = varId == BMON_DATA_TEMP ? ctx->tempData : varId;

    switch (opcode) {
    case 7:
        var = val;
        break;
    case 8:
        var += val;
        break;
    case 9:
        var -= val;
        break;
    case 10:
        var |= val;
        break;
    case 11:
        var &= (val ^ ~0);
        break;
    case 12:
        var *= val;
        break;
    case 13:
        var /= val;
        break;
    case 14:
        var <<= val;
        break;
    case 15: {
        u32 uvar = var;
        var = uvar >> val;
        break;
    }
    case 16:
        var = MaskOfFlagNo(val);
        break;
    case 17:
        GF_ASSERT(FALSE);
        break;
    case 18:
        var -= val;
        if (var < 0) {
            var = 0;
        }
        break;
    case 19:
        var ^= val;
        break;
    case 20:
        var &= val;
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }

    if (varId == BMON_DATA_ABILITY) {
        BattlerSetAbility(ctx, battlerId, var);
    }
    // A stat stage stays between -6 and +6 whatever a script adds to it:
    // Steam Engine adds six at once, and the stage it writes indexes the
    // stat ratio table.
    if (stage >= BMON_DATA_STAT_CHANGE_HP && stage <= BMON_DATA_STAT_CHANGE_EVASION) {
        var = var < 0 ? 0 : var > 12 ? 12 : var;
    }

    SetBattlerVar(ctx, battlerId, varId, &var);
    CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);

    // A stage a script raises itself rather than through the stat-change
    // command -- Belly Drum, Anger Point, Rage, Motor Drive, Steam Engine, a
    // Starf Berry -- is copied by a Mirror Herb or an Opportunist on the other
    // side too, as far as the stage really rose (Pokemon Central, Foglia
    // carbone: Belly Drum's copy is the stages actually gained; Scrocco
    // copies every rise of a foe's). A stage set back to neutral is
    // reset, not raised (Shed Tail), and the swaps write through another
    // command. It is a rise for Burning Jealousy and Alluring Voice as well,
    // which count every rise of the turn but a copy or a swap (Pokemon
    // Central, Fiamminvidia).
    if (stage >= BMON_DATA_STAT_CHANGE_ATK && stage <= BMON_DATA_STAT_CHANGE_EVASION && !(opcode == 7 && val == 6) && var > before) {
        RecordMirrorHerbStages(battleSystem, ctx, battlerId, stage - BMON_DATA_STAT_CHANGE_HP, var - before);
        ctx->turnData[battlerId].statRaised = TRUE;
    }

    return FALSE;
}

BOOL BtlCmd_ClearVolatileStatus(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int var = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    ctx->unk_218C[battlerId] |= var;

    return FALSE;
}

BOOL BtlCmd_ToggleVanish(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int unkA = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitToggleVanish(battleSystem, battlerId, unkA);

    return FALSE;
}

BOOL BtlCmd_CheckAbility(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;

    BattleScriptIncrementPointer(ctx, 1);

    int unkA = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int ability = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (side == BATTLER_CATEGORY_ALL) {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            if (unkA == 0) {
                if (GetBattlerAbility(ctx, battlerId) == ability) {
                    BattleScriptIncrementPointer(ctx, adrs);
                    ctx->battlerIdAbility = battlerId;
                    break;
                }
            } else if (GetBattlerAbility(ctx, battlerId) == ability) {
                break;
            }
        }
    } else {
        battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

        if (unkA == 0) {
            if (GetBattlerAbility(ctx, battlerId) == ability) {
                BattleScriptIncrementPointer(ctx, adrs);
                ctx->battlerIdAbility = battlerId;
            }
        } else if (GetBattlerAbility(ctx, battlerId) != ability) {
            BattleScriptIncrementPointer(ctx, adrs);
            ctx->battlerIdAbility = battlerId;
        }
    }

    return FALSE;
}

BOOL BtlCmd_Random(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int modulo = BattleScriptReadWord(ctx);
    modulo += 1;

    int x0 = BattleScriptReadWord(ctx);

    ctx->calcTemp = BattleSystem_Random(battleSystem) % modulo + x0;

    return FALSE;
}

BOOL BtlCmd_UpdateVar2(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int valId = BattleScriptReadWord(ctx);

    int *var = BattleScriptGetVarPointer(battleSystem, ctx, varId);
    int *val = BattleScriptGetVarPointer(battleSystem, ctx, valId);

    switch (opcode) {
    case 7:
        *var = *val;
        break;
    case 8:
        *var += *val;
        break;
    case 9:
        *var -= *val;
        break;
    case 10:
        *var |= *val;
        break;
    case 11:
        *var &= (*val ^ ~0);
        break;
    case 12:
        *var *= *val;
        break;
    case 13:
        *var /= *val;
        break;
    case 14:
        *var <<= *val;
        break;
    case 15: {
        u32 uvar = *var;
        *var = uvar >> *val;
        break;
    }
    case 16:
        *var = MaskOfFlagNo(*val);
        break;
    case 17:
        *val = *var;
        break;
    case 18:
        *var -= *val;
        if (*var < 0) {
            *var = 0;
        }
        break;
    case 19:
        *var ^= *val;
        break;
    case 20:
        *var &= *val;
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_UpdateMonDataFromVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int valId = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    int var = GetBattlerVar(ctx, battlerId, varId, NULL);
    int *val = BattleScriptGetVarPointer(battleSystem, ctx, valId);

    switch (opcode) {
    case 7:
        var = *val;
        break;
    case 8:
        var += *val;
        break;
    case 9:
        var -= *val;
        break;
    case 10:
        var |= *val;
        break;
    case 11:
        var &= (*val ^ ~0);
        break;
    case 12:
        var *= *val;
        break;
    case 13:
        var /= *val;
        break;
    case 14:
        var <<= *val;
        break;
    case 15: {
        u32 uvar = var;
        var = uvar >> *val;
        break;
    }
    case 16:
        var = MaskOfFlagNo(*val);
        break;
    case 17:
        *val = var;
        break;
    case 18:
        var -= *val;
        if (var < 0) {
            var = 0;
        }
        break;
    case 19:
        var ^= *val;
        break;
    case 20:
        var &= *val;
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }

    if (opcode != 17) {
        if (varId == BMON_DATA_ABILITY) {
            BattlerSetAbility(ctx, battlerId, var);
        }
        SetBattlerVar(ctx, battlerId, varId, &var);
        CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
    }

    return FALSE;
}

BOOL BtlCmd_Goto(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptIncrementPointer(ctx, BattleScriptReadWord(ctx));
    return FALSE;
}

BOOL BtlCmd_Call(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BattleScriptReadWord(ctx));
    return FALSE;
}

BOOL BtlCmd_CallFromVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    int *var = BattleScriptGetVarPointer(battleSystem, ctx, BattleScriptReadWord(ctx));
    BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, *var);
    return FALSE;
}

BOOL BtlCmd_SetMirrorMove(BattleSystem *battleSystem, BattleContext *ctx) {
    int move = 0;
    int battleType = BattleSystem_GetBattleType(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    if (ctx->moveNoCopied[ctx->battlerIdAttacker]) {
        move = ctx->moveNoCopied[ctx->battlerIdAttacker];
    } else if (battleType & BATTLE_TYPE_DOUBLES) {
        move = ctx->moveNoCopiedHit[ctx->battlerIdAttacker][0] + ctx->moveNoCopiedHit[ctx->battlerIdAttacker][1] + ctx->moveNoCopiedHit[ctx->battlerIdAttacker][2] + ctx->moveNoCopiedHit[ctx->battlerIdAttacker][3];
        if (move) {
            do {
                move = ctx->moveNoCopiedHit[ctx->battlerIdAttacker][BattleSystem_Random(battleSystem) % 4];
            } while (!move);
        }
    }
    if (move && IsMoveEncored(ctx, move) == TRUE) {
        ctx->battleStatus &= ~BATTLE_STATUS_NO_ATTACK_MESSAGE;
        ctx->battleStatus &= ~BATTLE_STATUS_MOVE_ANIMATIONS_OFF;
        ctx->moveNoCur = move;
        ctx->battlerIdTarget = ov12_022506D4(battleSystem, ctx, ctx->battlerIdAttacker, move, 1, 0);
        if (ctx->battlerIdTarget != BATTLER_NONE) {
            ctx->playerActions[ctx->battlerIdAttacker].unk4 = ctx->battlerIdTarget;
        }
        // Parental Bond strikes twice with the copy too, which the reference
        // leaves single.
        return CallMove(ctx);
    } else {
        ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure = 1;
    }

    return FALSE;
}

BOOL BtlCmd_ResetAllStatChanges(BattleSystem *battleSystem, BattleContext *ctx) {
    int stat, battlerId;

    BattleScriptIncrementPointer(ctx, 1);

    int battlersMax = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < battlersMax; battlerId++) {
        for (stat = 0; stat < 8; stat++) {
            ctx->battleMons[battlerId].statChanges[stat] = 6;
        }
        ctx->battleMons[battlerId].status2 &= ~STATUS2_FOCUS_ENERGY;
    }

    return FALSE;
}

BOOL BtlCmd_LockMoveChoice(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    LockBattlerIntoCurrentMove(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)));

    return FALSE;
}

BOOL BtlCmd_UnlockMoveChoice(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    UnlockBattlerOutOfCurrentMove(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)));

    return FALSE;
}

BOOL BtlCmd_SetHealthbarStatus(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int status = BattleScriptReadWord(ctx);

    BattleController_EmitHealthbarStatus(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), status);

    return FALSE;
}

BOOL BtlCmd_PrintTrainerMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int msg = BattleScriptReadWord(ctx);

    BattleController_EmitPrintTrainerMessage(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), msg);

    return FALSE;
}

u32 CalcPrizeMoney(BattleSystem *battleSystem, BattleContext *ctx, int trainerIndex) {
    int i;
    TRPOKE *trPoke;
    u32 prizeMoney;
    u8 level = 0;
    u8 trainerClass;
    Trainer trainer;

    trPoke = Heap_Alloc(HEAP_ID_BATTLE, sizeof(TRPOKE) * 6);

    TrainerData_ReadTrData(battleSystem->trainerId[trainerIndex], &trainer);
    TrainerData_ReadTrPoke(battleSystem->trainerId[trainerIndex], trPoke);

    switch (trainer.data.trainerType) {
    default:
    case 0: {
        TRPOKE_NOITEM_DFLTMOVES *pokeDef = (TRPOKE_NOITEM_DFLTMOVES *)trPoke;
        level = pokeDef[trainer.data.npoke - 1].level;
        break;
    }
    case 1: {
        TRPOKE_NOITEM_CUSTMOVES *pokeCust = (TRPOKE_NOITEM_CUSTMOVES *)trPoke;
        level = pokeCust[trainer.data.npoke - 1].level;
        break;
    }
    case 2: {
        TRPOKE_ITEM_DFLTMOVES *pokeItem = (TRPOKE_ITEM_DFLTMOVES *)trPoke;
        level = pokeItem[trainer.data.npoke - 1].level;
        break;
    }
    case 3: {
        TRPOKE_ITEM_CUSTMOVES *pokeCustItem = (TRPOKE_ITEM_CUSTMOVES *)trPoke;
        level = pokeCustItem[trainer.data.npoke - 1].level;
        break;
    }
    }

    i = 0;
    trainerClass = trainer.data.trainerClass;

    do {
        if (trainerClass != sPrizeMoneyTbl[i][0]) {
            i++;
            if (i < (int)NELEMS(sPrizeMoneyTbl)) {
                continue;
            }
        }

        if (i >= (int)NELEMS(sPrizeMoneyTbl)) {
            GF_ASSERT(FALSE);
        }
        if (i >= (int)NELEMS(sPrizeMoneyTbl)) {
            i = 2;
        }
        if (battleSystem->battleType & BATTLE_TYPE_TAG || battleSystem->battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI | BATTLE_TYPE_AI)) {
            prizeMoney = level * 4 * ctx->prizeMoneyValue * sPrizeMoneyTbl[i][1];
            break;
        } else if (battleSystem->battleType & BATTLE_TYPE_DOUBLES) {
            prizeMoney = level * 4 * ctx->prizeMoneyValue * 2 * sPrizeMoneyTbl[i][1];
            break;
        } else {
            prizeMoney = level * 4 * ctx->prizeMoneyValue * sPrizeMoneyTbl[i][1];
            break;
        }

    } while (TRUE);

    Heap_Free(trPoke);

    return prizeMoney;
}

BOOL BtlCmd_PayPrizeMoney(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 prizeMoney;

    BattleScriptIncrementPointer(ctx, 1);

    if (battleSystem->battleOutcomeFlag == 1) {
        prizeMoney = CalcPrizeMoney(battleSystem, ctx, 1);
        if (battleSystem->battleType & BATTLE_TYPE_TAG || battleSystem->battleType == (BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI | BATTLE_TYPE_AI)) {
            prizeMoney += CalcPrizeMoney(battleSystem, ctx, 3);
        }
        PlayerProfile_AddMoney(BattleSystem_GetPlayerProfile(battleSystem, 0), prizeMoney);
    } else {
        prizeMoney = CalcMoneyLoss(battleSystem->trainerParty[0], battleSystem->playerProfile[0]);
        PlayerProfile_SubMoney(BattleSystem_GetPlayerProfile(battleSystem, 0), prizeMoney);
    }

    if (prizeMoney) {
        ctx->msgTemp = prizeMoney;
    } else {
        ctx->msgTemp = 0;
    }

    ctx->tempData = battleSystem->unk2474_1;

    return FALSE;
}

BOOL BtlCmd_PlayBattleAnimation(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int status = BattleScriptReadWord(ctx);

    if (BattleSystem_AreBattleAnimationsOn(battleSystem) == TRUE || status == 15 || status == 16 || status == 25 || status == 26) {
        int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
        if (CheckStatusEffectsSubstitute(ctx, battlerId, status) == TRUE) {
            BattleController_EmitSetStatus2Effect(battleSystem, ctx, battlerId, status);
        }
    }

    return FALSE;
}

BOOL BtlCmd_PlayBattleAnimationOnMons(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int sideA = BattleScriptReadWord(ctx);
    int sideB = BattleScriptReadWord(ctx);
    int status = BattleScriptReadWord(ctx);

    if (BattleSystem_AreBattleAnimationsOn(battleSystem) == TRUE || status == 15 || status == 16 || status == 26 || status == 25) {
        int battlerIdA = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideA);
        int battlerIdB = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideB);
        if (CheckStatusEffectsSubstitute(ctx, battlerIdA, status) == TRUE && CheckStatusEffectsSubstitute(ctx, battlerIdB, status) == TRUE) {
            BattleController_EmitCopyStatus2Effect(battleSystem, ctx, battlerIdA, battlerIdB, status);
        }
    }

    return FALSE;
}

BOOL BtlCmd_PlayBattleAnimationFromVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int status = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int *data = BattleScriptGetVarPointer(battleSystem, ctx, status);

    if (BattleSystem_AreBattleAnimationsOn(battleSystem) == TRUE || status == 15 || status == 16 || *data == 25 || *data == 26) {
        if (CheckStatusEffectsSubstitute(ctx, battlerId, *data) == TRUE) {
            BattleController_EmitSetStatus2Effect(battleSystem, ctx, battlerId, *data);
        }
    }

    return FALSE;
}

BOOL BtlCmd_PrintRecallMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    BattleController_EmitPrintReturnMessage(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);

    return FALSE;
}

BOOL BtlCmd_PrintSendOutMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    BattleController_EmitPrintSendOutMessage(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);

    return FALSE;
}

BOOL BtlCmd_PrintEncounterMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitPrintEncounterMessage(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)));

    return FALSE;
}

BOOL BtlCmd_PrintFirstSendOutMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitPrintFirstSendOutMessage(battleSystem, ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)));

    return FALSE;
}

BOOL BtlCmd_PrintBufferedTrainerMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitPrintTrainerMessage(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx)), ctx->msgTemp);

    return FALSE;
}

// Arceus and Silvally are the type their Multitype and RKS System make them,
// and no move changes it (Pokemon Central, Sistema Primevo): Conversion,
// Conversion 2 and Camouflage fail for them. Retail knew only Multitype.
static BOOL BattlerTypeIsItsAbilitys(BattleContext *ctx, int battlerId) {
    int ability = GetBattlerAbility(ctx, battlerId);

    return ability == ABILITY_MULTITYPE || ability == ABILITY_RKS_SYSTEM;
}

// Conversion from the sixth generation (Pokemon Central, Conversione): the
// user takes the type of the move in its first slot, and the move fails when
// the user has that type already, one of its own or an added one -- the
// reference's before-move check (BattleController_BeforeMove.c at d0380a487,
// with HasType), which then runs retail's command all the same. Retail's is
// the fourth generation's: one of the user's other moves at random, of a type
// it did not have.
BOOL BtlCmd_TryConversion(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleMon *mon = &ctx->battleMons[ctx->battlerIdAttacker];
    int moveType;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    moveType = BattleMoveTbl(ctx, mon->moves[0])->type;
    if (BattlerTypeIsItsAbilitys(ctx, ctx->battlerIdAttacker)
        || GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_1, NULL) == moveType
        || GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_2, NULL) == moveType
        || mon->type3 == moveType) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }
    mon->type1 = moveType;
    mon->type2 = moveType;
    mon->type3 = TYPE_NONE;
    ctx->msgTemp = moveType;

    return FALSE;
}

BOOL BtlCmd_CompareVarToVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int varNo = BattleScriptReadWord(ctx);
    int cmpNo = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    u32 *var = BattleScriptGetVarPointer(battleSystem, ctx, varNo);
    u32 *cmp = BattleScriptGetVarPointer(battleSystem, ctx, cmpNo);

    switch (opcode) {
    case 0:
        if (*var != *cmp) {
            adrs = 0;
        }
        break;
    case 1:
        if (*var == *cmp) {
            adrs = 0;
        }
        break;
    case 2:
        if (*var <= *cmp) {
            adrs = 0;
        }
        break;
    case 3:
        if (*var > *cmp) {
            adrs = 0;
        }
        break;
    case 4:
        if ((*var & *cmp) == 0) {
            adrs = 0;
        }
        break;
    case 5:
        if (*var & *cmp) {
            adrs = 0;
        }
        break;
    case 6:
        if ((*var & *cmp) != *cmp) {
            adrs = 0;
        }
        break;
    }

    if (adrs) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CompareMonDataToVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int opcode = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int varNo = BattleScriptReadWord(ctx);
    int cmpNo = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    u32 var = GetBattlerVar(ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side), varNo, NULL);
    u32 *cmp = BattleScriptGetVarPointer(battleSystem, ctx, cmpNo);

    switch (opcode) {
    case 0:
        if (var != *cmp) {
            adrs = 0;
        }
        break;
    case 1:
        if (var == *cmp) {
            adrs = 0;
        }
        break;
    case 2:
        if (var <= *cmp) {
            adrs = 0;
        }
        break;
    case 3:
        if (var > *cmp) {
            adrs = 0;
        }
        break;
    case 4:
        if ((var & *cmp) == 0) {
            adrs = 0;
        }
        break;
    case 5:
        if (var & *cmp) {
            adrs = 0;
        }
        break;
    case 6:
        if ((var & *cmp) != *cmp) {
            adrs = 0;
        }
        break;
    }

    if (adrs) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_AddPayDayMoney(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ctx->msgTemp = ctx->unk_14C * ctx->prizeMoneyValue;

    if (ctx->msgTemp > 0xFFFF) {
        ctx->msgTemp = 0xFFFF;
    }

    PlayerProfile_AddMoney(BattleSystem_GetPlayerProfile(battleSystem, 0), ctx->msgTemp);

    return FALSE;
}

BOOL BtlCmd_TryLightScreen(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int unkA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    if (ctx->fieldSideConditionFlags[unkA] & SIDE_CONDITION_LIGHT_SCREEN) {
        BattleScriptIncrementPointer(ctx, adrs);
        ctx->moveStatusFlag |= 64;
    } else {
        ctx->fieldSideConditionFlags[unkA] |= SIDE_CONDITION_LIGHT_SCREEN;
        ctx->fieldSideConditionData[unkA].lightScreenTurns = 5;
        ctx->fieldSideConditionData[unkA].lightScreenBattler = ctx->battlerIdAttacker;
        if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_EXTEND_SCREENS) {
            ctx->fieldSideConditionData[unkA].lightScreenTurns += GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);
        }
        ctx->buffMsg.tag = TAG_MOVE_SIDE;
        ctx->buffMsg.param[0] = ctx->moveNoCur;
        ctx->buffMsg.param[1] = ctx->battlerIdAttacker;
        if (GetMonsHitCount(battleSystem, ctx, 1, ctx->battlerIdAttacker) == 2) {
            // "{0} raised your team's Special Defence slightly!"
            ctx->buffMsg.id = msg_0197_00192;
        } else {
            // "{0} raised your team's Special Defence!"
            ctx->buffMsg.id = msg_0197_00190;
        }
    }
    return FALSE;
}

BOOL BtlCmd_TryReflect(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int unkA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    if (ctx->fieldSideConditionFlags[unkA] & SIDE_CONDITION_REFLECT) {
        BattleScriptIncrementPointer(ctx, adrs);
        ctx->moveStatusFlag |= 64;
    } else {
        ctx->fieldSideConditionFlags[unkA] |= SIDE_CONDITION_REFLECT;
        ctx->fieldSideConditionData[unkA].reflectTurns = 5;
        ctx->fieldSideConditionData[unkA].reflectBattler = ctx->battlerIdAttacker;
        if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_EXTEND_SCREENS) {
            ctx->fieldSideConditionData[unkA].reflectTurns += GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);
        }
        ctx->buffMsg.tag = TAG_MOVE_SIDE;
        ctx->buffMsg.param[0] = ctx->moveNoCur;
        ctx->buffMsg.param[1] = ctx->battlerIdAttacker;
        if (GetMonsHitCount(battleSystem, ctx, 1, ctx->battlerIdAttacker) == 2) {
            // "{0} raised your team's Defence slightly!"
            ctx->buffMsg.id = msg_0197_00196;
        } else {
            // "{0} raised your team's Defence!"
            ctx->buffMsg.id = msg_0197_00194;
        }
    }
    return FALSE;
}

BOOL BtlCmd_TryMist(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int unkA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    if (ctx->fieldSideConditionFlags[unkA] & SIDE_CONDITION_MIST) {
        BattleScriptIncrementPointer(ctx, adrs);
        ctx->moveStatusFlag |= 64;
    } else {
        ctx->fieldSideConditionFlags[unkA] |= SIDE_CONDITION_MIST;
        ctx->fieldSideConditionData[unkA].mistTurns = 5;
        ctx->fieldSideConditionData[unkA].mistBattler = ctx->battlerIdAttacker;
    }
    return FALSE;
}

BOOL BtlCmd_TryOHKOMove(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 hitChance;

    BattleScriptIncrementPointer(ctx, 1);

    ctx->battleStatus |= BATTLE_STATUS_FLAT_HIT_RATE;

    if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STURDY) == TRUE) {
        ctx->moveStatusFlag |= MOVE_STATUS_STURDY;
    } else {
        if (!(ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON) && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_NO_GUARD && GetBattlerAbility(ctx, ctx->battlerIdTarget) != ABILITY_NO_GUARD) {
            hitChance = ctx->battleMons[ctx->battlerIdAttacker].level - ctx->battleMons[ctx->battlerIdTarget].level + BattleMoveTbl(ctx, ctx->moveNoCur)->accuracy;
#ifdef NEWGOLD_DIAG
            Diag_RollNext(DIAG_ROLL_HIT);
#endif
            if ((BattleSystem_Random(battleSystem) % 100) < hitChance && (ctx->battleMons[ctx->battlerIdAttacker].level >= ctx->battleMons[ctx->battlerIdTarget].level)) {
                hitChance = 1;
            } else {
                hitChance = 0;
            }
        } else {
            if ((((ctx->battleMons[ctx->battlerIdTarget].unk88.battlerIdLockOn == ctx->battlerIdAttacker) && (ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON)) || GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_NO_GUARD || GetBattlerAbility(ctx, ctx->battlerIdTarget) == ABILITY_NO_GUARD) && ctx->battleMons[ctx->battlerIdAttacker].level >= ctx->battleMons[ctx->battlerIdTarget].level) {
                hitChance = 1;
            } else {
                hitChance = ctx->battleMons[ctx->battlerIdAttacker].level - ctx->battleMons[ctx->battlerIdTarget].level + BattleMoveTbl(ctx, ctx->moveNoCur)->accuracy;
#ifdef NEWGOLD_DIAG
                Diag_RollNext(DIAG_ROLL_HIT);
#endif
                if ((BattleSystem_Random(battleSystem) % 100) < hitChance && ctx->battleMons[ctx->battlerIdAttacker].level >= ctx->battleMons[ctx->battlerIdTarget].level) {
                    hitChance = 1;
                } else {
                    hitChance = 0;
                }
            }
            ctx->moveStatusFlag |= 1 << 10;
        }

        if (hitChance) {
            ctx->damage = -ctx->battleMons[ctx->battlerIdTarget].hp;
            ctx->moveStatusFlag |= 1 << 5;
        } else if (ctx->battleMons[ctx->battlerIdAttacker].level >= ctx->battleMons[ctx->battlerIdTarget].level) {
            ctx->moveStatusFlag |= 1;
        } else {
            ctx->moveStatusFlag |= 1 << 12;
        }
    }

    return FALSE;
}

BOOL BtlCmd_DivideVarByValue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int varNo = BattleScriptReadWord(ctx);
    int denom = BattleScriptReadWord(ctx);

    int *data = BattleScriptGetVarPointer(battleSystem, ctx, varNo);

    *data = DamageDivide(*data, denom);

    return FALSE;
}

BOOL BtlCmd_DivideVarByVar(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int varNo = BattleScriptReadWord(ctx);
    int denomNo = BattleScriptReadWord(ctx);

    int *data = BattleScriptGetVarPointer(battleSystem, ctx, varNo);
    int *denom = BattleScriptGetVarPointer(battleSystem, ctx, denomNo);

    int sign;

    if (*data < 0) {
        sign = -1;
    } else {
        sign = 1;
    }

    *data /= *denom;

    if (*data == 0) {
        *data = sign;
    }

    return FALSE;
}

BOOL BtlCmd_TryMimic(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if ((!CheckLegalMimicMove(ctx->moveNoBattlerPrev[ctx->battlerIdTarget])) || (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_TRANSFORM) || (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_SUBSTITUTE) || ctx->moveNoBattlerPrev[ctx->battlerIdTarget] == 0) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        int moveIndex = 0;
        int mimicIndex = -1;

        for (moveIndex = 0; moveIndex < MAX_MON_MOVES; moveIndex++) {
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == ctx->moveNoBattlerPrev[ctx->battlerIdTarget]) {
                break;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == MOVE_MIMIC && mimicIndex == -1) {
                mimicIndex = moveIndex;
            }
        }

        if (moveIndex == MAX_MON_MOVES) {
            ctx->moveTemp = ctx->moveNoBattlerPrev[ctx->battlerIdTarget];
            ctx->battleMons[ctx->battlerIdAttacker].moves[mimicIndex] = ctx->moveTemp;
            if (BattleMoveTbl(ctx, ctx->moveTemp)->pp < 5) {
                ctx->battleMons[ctx->battlerIdAttacker].movePPCur[mimicIndex] = BattleMoveTbl(ctx, ctx->moveTemp)->pp;
            } else {
                ctx->battleMons[ctx->battlerIdAttacker].movePPCur[mimicIndex] = 5;
            }
            ctx->battleMons[ctx->battlerIdAttacker].unk88.mimicedMoveIndex |= MaskOfFlagNo(mimicIndex);

            if (ctx->moveTemp == MOVE_LAST_RESORT) {
                ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount = 0;
            }
        } else {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    }

    return FALSE;
}

BOOL BtlCmd_Metronome(BattleSystem *battleSystem, BattleContext *ctx) {
    int metronomeIndex;
    u16 moveNo;

    BattleScriptIncrementPointer(ctx, 1);

    while (TRUE) {
        moveNo = (BattleSystem_Random(battleSystem) % NUM_MOVES_TOTAL) + 1;

        for (metronomeIndex = 0; metronomeIndex < MAX_MON_MOVES; metronomeIndex++) {
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[metronomeIndex] == moveNo) {
                break;
            }
        }

        if (metronomeIndex != MAX_MON_MOVES) {
            continue;
        }

        // Revival Blessing is Metronome's alone to refuse: Showdown's gen-9
        // data gives it no metronome flag, and Pokemon Central's table
        // (Metronomo) marks it; Copycat copies it (no failcopycat), so the
        // shared list below does not name it. Sky Drop stays callable, as
        // in the fifth to seventh generations, the last it was in.
        if (moveNo == MOVE_REVIVAL_BLESSING || CheckLegalMetronomeMove(battleSystem, ctx, ctx->battlerIdAttacker, moveNo) == FALSE) {
            continue;
        }

        ctx->moveTemp = moveNo;

        break;
    }

    return FALSE;
}

BOOL BtlCmd_TryDisable(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int disabledMoveIndex = BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdTarget], ctx->moveNoBattlerPrev[ctx->battlerIdTarget]);

    if ((ctx->battleMons[ctx->battlerIdTarget].unk88.disabledMove == 0) && disabledMoveIndex != 4 && ctx->battleMons[ctx->battlerIdTarget].movePPCur[disabledMoveIndex] && ctx->moveNoBattlerPrev[ctx->battlerIdTarget]) {
        ctx->moveTemp = ctx->moveNoBattlerPrev[ctx->battlerIdTarget];
        ctx->battleMons[ctx->battlerIdTarget].unk88.disabledMove = ctx->moveTemp;
        ctx->battleMons[ctx->battlerIdTarget].unk88.disabledTurns = BattleSystem_Random(battleSystem) % 4 + 3;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_Counter(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int battlerId = ctx->turnData[ctx->battlerIdAttacker].battlerIdPhysicalDamage;

    int sideA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    int sideB = BattleSystem_GetFieldSide(battleSystem, battlerId);

    if (ctx->turnData[ctx->battlerIdAttacker].physicalDamage[battlerId] && sideA != sideB && ctx->battleMons[battlerId].hp) {
        ctx->damage = ctx->turnData[ctx->battlerIdAttacker].physicalDamage[battlerId] * 2;
        if (ctx->fieldSideConditionData[sideB].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[sideB].battlerIdFollowMe].hp) {
            ctx->battlerIdTarget = ctx->fieldSideConditionData[sideB].battlerIdFollowMe;
        } else {
            ctx->battlerIdTarget = battlerId;
        }
        if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
            ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
            if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
                ctx->commandNext = CONTROLLER_COMMAND_39;
                BattleScriptJump(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NO_TARGET);
            }
        }
        CheckIgnorePressure(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);
    } else {
        ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure = 1;
        ctx->moveStatusFlag |= MOVE_STATUS_FAILED;
    }

    return FALSE;
}

BOOL BtlCmd_MirrorCoat(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int battlerId = ctx->turnData[ctx->battlerIdAttacker].battlerIdSpecialDamage;

    int sideA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    int sideB = BattleSystem_GetFieldSide(battleSystem, battlerId);

    if (ctx->turnData[ctx->battlerIdAttacker].specialDamage[battlerId] && sideA != sideB && ctx->battleMons[battlerId].hp) {
        ctx->damage = ctx->turnData[ctx->battlerIdAttacker].specialDamage[battlerId] * 2;
        if (ctx->fieldSideConditionData[sideB].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[sideB].battlerIdFollowMe].hp) {
            ctx->battlerIdTarget = ctx->fieldSideConditionData[sideB].battlerIdFollowMe;
        } else {
            ctx->battlerIdTarget = battlerId;
        }
        if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
            ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
            if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
                ctx->commandNext = CONTROLLER_COMMAND_39;
                BattleScriptJump(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NO_TARGET);
            }
        }
        CheckIgnorePressure(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);
    } else {
        ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure = 1;
        ctx->moveStatusFlag |= MOVE_STATUS_FAILED;
    }

    return FALSE;
}

BOOL BtlCmd_TryEncore(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int encoredMoveIndex = BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdTarget], ctx->moveNoBattlerPrev[ctx->battlerIdTarget]);

    if (IsMoveEncored(ctx, ctx->moveNoBattlerPrev[ctx->battlerIdTarget]) == FALSE) {
        encoredMoveIndex = MAX_MON_MOVES;
    }

    if (ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove == 0 && encoredMoveIndex != MAX_MON_MOVES && ctx->battleMons[ctx->battlerIdTarget].movePPCur[encoredMoveIndex] && ctx->moveNoBattlerPrev[ctx->battlerIdTarget]) {
        ctx->moveTemp = ctx->moveNoBattlerPrev[ctx->battlerIdTarget];
        ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove = ctx->moveTemp;
        ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMoveIndex = encoredMoveIndex;
        ctx->battleMons[ctx->battlerIdTarget].unk88.encoredTurns = BattleSystem_Random(battleSystem) % 5 + 3;
    } else {
        ctx->moveStatusFlag |= 64;
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Conversion 2 from Generation V (Pokemon Central, Conversione2): the user
// takes, at random, a type that resists or is immune to the type of the move
// its target last used, and fails when the target has used none since it came
// in, when that move was Struggle, or when no type the user lacks resists it.
// Generation IV's read the move that last hit the user. The type is the
// move's as it was used (ov12_0224DD74 keeps it), and it replaces all the
// user's types, an added third one included.
static BOOL Conversion2TypeFits(BattleContext *ctx, u8 typeMove, u8 typeMon, u8 val, int moveType) {
    return typeMove == moveType && val <= 5
        && GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_1, NULL) != typeMon
        && GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_2, NULL) != typeMon;
}

// Retail's pick: a thousand random rows of the type chart, then the first row
// that fits.
static BOOL Conversion2PickType(BattleSystem *battleSystem, BattleContext *ctx, int moveType, u8 *type) {
    int i;
    u8 typeMove, val;

    for (i = 0; i < 1000; i++) {
        GetTypeEffectivnessData(battleSystem, 0xffff, &typeMove, type, &val);
        if (Conversion2TypeFits(ctx, typeMove, *type, val, moveType)) {
            return TRUE;
        }
    }
    for (i = 0; GetTypeEffectivnessData(battleSystem, i, &typeMove, type, &val) == TRUE; i++) {
        if (Conversion2TypeFits(ctx, typeMove, *type, val, moveType)) {
            return TRUE;
        }
    }
    return FALSE;
}

BOOL BtlCmd_TryConversion2(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 type;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int target = ctx->battlerIdTarget;

    if (BattlerTypeIsItsAbilitys(ctx, ctx->battlerIdAttacker) || target == BATTLER_NONE
        || ctx->conversion2Move[target] == MOVE_NONE || ctx->conversion2Move[target] == MOVE_STRUGGLE
        || !Conversion2PickType(battleSystem, ctx, ctx->conversion2Type[target], &type)) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }

    ctx->battleMons[ctx->battlerIdAttacker].type1 = type;
    ctx->battleMons[ctx->battlerIdAttacker].type2 = type;
    ctx->battleMons[ctx->battlerIdAttacker].type3 = TYPE_NONE;
    ctx->msgTemp = type;
    return FALSE;
}

BOOL BtlCmd_TrySketch(BattleSystem *battleSystem, BattleContext *ctx) {
    int moveIndex;
    int sketchIndex = -1;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    // Nor Revival Blessing (Pokemon Central, Preghiera Vitale).
    if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_TRANSFORM || ctx->moveNoSketch[ctx->battlerIdTarget] == MOVE_STRUGGLE || ctx->moveNoSketch[ctx->battlerIdTarget] == MOVE_SKETCH || ctx->moveNoSketch[ctx->battlerIdTarget] == MOVE_CHATTER || ctx->moveNoSketch[ctx->battlerIdTarget] == 0
        || ctx->moveNoSketch[ctx->battlerIdTarget] == MOVE_REVIVAL_BLESSING) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        for (moveIndex = 0; moveIndex < MAX_MON_MOVES; moveIndex++) {
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] != MOVE_SKETCH && ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == ctx->moveNoSketch[ctx->battlerIdTarget]) {
                break;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == MOVE_SKETCH && sketchIndex == -1) {
                sketchIndex = moveIndex;
            }
        }
        if (moveIndex == MAX_MON_MOVES) {
            ctx->battleMons[ctx->battlerIdAttacker].moves[sketchIndex] = ctx->moveNoSketch[ctx->battlerIdTarget];
            ctx->battleMons[ctx->battlerIdAttacker].movePPCur[sketchIndex] = BattleMoveTbl(ctx, ctx->moveNoSketch[ctx->battlerIdTarget])->pp;
            BattleController_EmitBattleMonToPartyMonCopy(battleSystem, ctx, ctx->battlerIdAttacker);
            ctx->moveTemp = ctx->moveNoSketch[ctx->battlerIdTarget];
            if (ctx->moveTemp == MOVE_LAST_RESORT) {
                ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount = 0;
            }
        } else {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    }

    return FALSE;
}

BOOL BtlCmd_TrySleepTalk(BattleSystem *battleSystem, BattleContext *ctx) {
    int moveIndex, nonSelectableMoves;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    nonSelectableMoves = 0;

    for (moveIndex = 0; moveIndex < MAX_MON_MOVES; moveIndex++) {
        if (CheckMoveCallsOtherMove(ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex]) || ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == MOVE_FOCUS_PUNCH || ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == MOVE_UPROAR || ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex] == MOVE_CHATTER || BattleCtx_IsIdenticalToCurrentMove(ctx, ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex])) {
            nonSelectableMoves |= MaskOfFlagNo(moveIndex);
        }
    }

    nonSelectableMoves = StruggleCheck(battleSystem, ctx, ctx->battlerIdAttacker, nonSelectableMoves, ~2);

    if (nonSelectableMoves == 15) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        do {
            moveIndex = BattleSystem_Random(battleSystem) % 4;
        } while (MaskOfFlagNo(moveIndex) & nonSelectableMoves);
        ctx->moveTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[moveIndex];
    }

    return FALSE;
}

BOOL BtlCmd_CalcFlailPower(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int hpBarPixels;

    BattleScriptIncrementPointer(ctx, 1);

    hpBarPixels = CalculateHpBarPixelsLength(ctx->battleMons[ctx->battlerIdAttacker].hp, ctx->battleMons[ctx->battlerIdAttacker].maxHp, 64);
    for (i = 0; i < sizeof(sFlailDamageTable) / sizeof(sFlailDamageTable[0]); i++) {
        if (hpBarPixels <= sFlailDamageTable[i][0]) {
            break;
        }
    }

    ctx->movePower = sFlailDamageTable[i][1];

    return FALSE;
}

BOOL BtlCmd_TrySpite(BattleSystem *battleSystem, BattleContext *ctx) {
    int moveIndex, ppLoss;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->moveNoBattlerPrev[ctx->battlerIdTarget]) {
        moveIndex = BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdTarget], ctx->moveNoBattlerPrev[ctx->battlerIdTarget]);
        if (moveIndex == MAX_MON_MOVES || ctx->battleMons[ctx->battlerIdTarget].movePPCur[moveIndex] == 0) {
            BattleScriptIncrementPointer(ctx, adrs);
        } else {
            // Eerie Spell's added effect takes three where Spite takes four
            // (Pokemon Central, Inquietantesimo).
            ppLoss = ctx->moveNoCur == MOVE_EERIE_SPELL ? 3 : 4;
            if (ctx->battleMons[ctx->battlerIdTarget].movePPCur[moveIndex] < ppLoss) {
                ppLoss = ctx->battleMons[ctx->battlerIdTarget].movePPCur[moveIndex];
            }
            ctx->moveTemp = ctx->moveNoBattlerPrev[ctx->battlerIdTarget];
            ctx->msgTemp = ppLoss;
            ctx->battleMons[ctx->battlerIdTarget].movePPCur[moveIndex] -= ppLoss;
            CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdTarget);
        }
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryPartyStatusRefresh(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    int battlerId;

    BattleScriptIncrementPointer(ctx, 1);

    ctx->calcTemp = 0;

    if (ctx->moveNoCur == MOVE_HEAL_BELL) {
        ctx->moveTemp = ctx->moveNoCur;
        if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_SOUNDPROOF) {
            ctx->battleMons[ctx->battlerIdAttacker].status = STATUS_NONE;
            ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_NIGHTMARE;
        } else {
            ctx->calcTemp |= 5;
        }

        if (battleType & BATTLE_TYPE_DOUBLES) {
            battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BATTLER_CATEGORY_ATTACKER_PARTNER);
            if (!(ctx->switchInFlag & MaskOfFlagNo(battlerId))) {
                if (!CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ABILITY_SOUNDPROOF)) {
                    ctx->battleMons[battlerId].status = STATUS_NONE;
                    ctx->battleMons[battlerId].status2 &= ~STATUS2_NIGHTMARE;
                } else {
                    ctx->battlerIdTemp = battlerId;
                    ctx->calcTemp |= 10;
                }
            }
        } else {
            ctx->calcTemp |= 8;
        }
    } else { // aromatherapy
        ctx->battleMons[ctx->battlerIdAttacker].status = STATUS_NONE;
        ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_NIGHTMARE;
        if (battleType & BATTLE_TYPE_DOUBLES) {
            battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BATTLER_CATEGORY_ATTACKER_PARTNER);
            if (!(ctx->switchInFlag & MaskOfFlagNo(battlerId))) {
                ctx->battleMons[battlerId].status = STATUS_NONE;
                ctx->battleMons[battlerId].status2 &= ~STATUS2_NIGHTMARE;
            }
        } else {
            ctx->calcTemp |= 8;
        }
    }

    BattleControl_EmitPartyStatusHeal(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

    return FALSE;
}

BOOL BtlCmd_TryStealItem(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs1 = BattleScriptReadWord(ctx);
    int adrs2 = BattleScriptReadWord(ctx);

    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    // A wild Pokemon takes nothing from the player's (Pokemon Central, Furto,
    // from the third generation). A trainer's does from the fifth, and the
    // item is the player's again at the battle's end (NoteHeldItemTaken,
    // GiveBackHeldItems): retail refused it, which kept the item from being
    // lost for good.
    if (BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) && !(battleType & (BATTLE_TYPE_TRAINER | BATTLE_TYPE_LINK | BATTLE_TYPE_FRONTIER))) {
        BattleScriptIncrementPointer(ctx, adrs1);
    } else if (ctx->fieldSideConditionData[fieldSide].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdAttacker])) {
        BattleScriptIncrementPointer(ctx, adrs1);
    } else if (ctx->battleMons[ctx->battlerIdTarget].unk88.custapBerryFlag || ctx->battleMons[ctx->battlerIdTarget].unk88.quickClawFlag) {
        BattleScriptIncrementPointer(ctx, adrs1);
    } else {
        // Sticky Hold keeps nothing for a holder the move has felled (Pokemon
        // Central, Antifurto, from the fifth generation).
        if (ctx->battleMons[ctx->battlerIdTarget].item && ctx->battleMons[ctx->battlerIdTarget].hp && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD) == TRUE) {
            BattleScriptIncrementPointer(ctx, adrs2);
        } else if (ctx->battleMons[ctx->battlerIdAttacker].item || CanStealHeldItem(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget) == FALSE) {
            BattleScriptIncrementPointer(ctx, adrs1);
        } else if (ctx->gemBoostingMove) {
            // A Thief or a Covet a Gem powered takes nothing, though the Gem
            // has left the hand empty (ServerDoPostMoveEffects.c:1242).
            BattleScriptIncrementPointer(ctx, adrs1);
        } else {
            NoteHeldItemTaken(battleSystem, ctx, ctx->battlerIdTarget);
        }
    }

    return FALSE;
}

// Wide Guard, Quick Guard, Mat Block and Crafty Shield: the four that guard
// the user's whole side (MOVE_EFFECT_PROTECT_USER_SIDE).
static BOOL IsTeamGuard(u16 move) {
    return move == MOVE_QUICK_GUARD || move == MOVE_WIDE_GUARD || move == MOVE_MAT_BLOCK || move == MOVE_CRAFTY_SHIELD;
}

// As the reference (battle_script_commands.c and BattleController_BeforeMove.c):
// one try in 3^n works after n in a row, and the count stops at six;
// any move of Protect's family used before this one keeps the count going,
// the four team guards never roll for it, and Mat Block and Crafty Shield do
// not add to it. A team guard covers the user and, unless it has raised a
// guard of its own already, the ally.
BOOL BtlCmd_TryProtection(BattleSystem *battleSystem, BattleContext *ctx) {
    int flag;
    int attacker = ctx->battlerIdAttacker;
    u16 lastEffect = BattleMoveTbl(ctx, ctx->moveNoProtect[attacker])->effect;
    u16 effect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (lastEffect != MOVE_EFFECT_PROTECT && lastEffect != MOVE_EFFECT_PROTECT_USER_SIDE && lastEffect != MOVE_EFFECT_SURVIVE_WITH_1_HP) {
        ctx->protectSuccessTurns[attacker] = 0;
    }

    if (ctx->battlersOnField == 1) {
        flag = FALSE;
    } else {
        flag = TRUE;
    }

    if ((IsTeamGuard(ctx->moveNoCur) || BattleSystem_Random(battleSystem) % sProtectSuccessChance[ctx->protectSuccessTurns[attacker]] == 0) && flag) {
        ctx->buffMsg.tag = TAG_NICKNAME;
        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, attacker);
        if (effect == MOVE_EFFECT_PROTECT) {
            ctx->turnData[attacker].protectFlag = TRUE;
            ctx->turnData[attacker].gainedProtectFlagFromAlly = FALSE;
            // "{0} protected itself!"
            ctx->buffMsg.id = msg_0197_00282;
        }
        if (effect == MOVE_EFFECT_PROTECT_USER_SIDE) {
            ctx->turnData[attacker].protectFlag = TRUE;
            if (!ctx->turnData[attacker ^ 2].protectFlag) {
                ctx->turnData[attacker ^ 2].protectFlag = TRUE;
                ctx->turnData[attacker ^ 2].gainedProtectFlagFromAlly = TRUE;
            }
            // "{0} protected your team!"
            ctx->buffMsg.id = msg_0197_01565;
            ctx->buffMsg.tag = TAG_MOVE_SIDE;
            ctx->buffMsg.param[0] = ctx->moveNoCur;
            ctx->buffMsg.param[1] = attacker;
        }
        if (effect == MOVE_EFFECT_SURVIVE_WITH_1_HP) {
            ctx->turnData[attacker].endureFlag = TRUE;
            // "{0} braced itself!"
            ctx->buffMsg.id = msg_0197_00442;
        }

        if (ctx->protectSuccessTurns[attacker] < NELEMS(sProtectSuccessChance) - 1
            && ctx->moveNoCur != MOVE_MAT_BLOCK && ctx->moveNoCur != MOVE_CRAFTY_SHIELD) {
            ctx->protectSuccessTurns[attacker]++;
        }

    } else {
        ctx->protectSuccessTurns[attacker] = 0;
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TrySubstitute(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int subHp = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, 4);

    if (ctx->battleMons[ctx->battlerIdAttacker].hp <= subHp) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->hpCalc = -subHp;
        ctx->battleMons[ctx->battlerIdAttacker].unk88.substituteHp = subHp;
        ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_BIND;
    }

    return FALSE;
}

// Whirlwind's, Roar's and a Red Card's choice of who is dragged out in a
// trainer battle, for battlerId: FALSE when the party has nobody to send in,
// otherwise a Pokemon at random, written where SwitchAndUpdateMon will take
// it. No level is asked: in a trainer battle the later games drag out any
// Pokemon, whatever the levels (Pokemon Central, Turbine and Ruggito, from the
// fifth generation).
BOOL TryPickForcedSwitchIn(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    u32 battleType = BattleSystem_GetBattleType(battleSystem);
    Party *party;
    Pokemon *mon;
    int partySize;
    int cnt = 0;
    int cntMax;
    int index0, indexEnd, monIndex, maxRand;
    int monIndexA, monIndexB;

    party = BattleSystem_GetParty(battleSystem, battlerId);
    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);

    if (battleType & BATTLE_TYPE_MULTI || battleType & BATTLE_TYPE_TAG && BattleSystem_GetFieldSide(battleSystem, battlerId)) {
        index0 = 0;
        indexEnd = partySize;
        maxRand = partySize;
        cntMax = 1;
        monIndexA = ctx->selectedMonIndex[battlerId];
        monIndexB = ctx->selectedMonIndex[battlerId];
    } else if (battleType & BATTLE_TYPE_DOUBLES) {
        index0 = 0;
        indexEnd = partySize;
        maxRand = partySize;
        cntMax = 2;
        monIndexA = ctx->selectedMonIndex[battlerId];
        monIndexB = ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)];
    } else {
        index0 = 0;
        indexEnd = partySize;
        maxRand = partySize;
        cntMax = 1;
        monIndexA = ctx->selectedMonIndex[battlerId];
        monIndexB = ctx->selectedMonIndex[battlerId];
    }

    for (monIndex = index0; monIndex < indexEnd; monIndex++) {
        mon = Party_GetMonByIndex(party, monIndex);
        if (GetMonData(mon, MON_DATA_SPECIES, 0) != SPECIES_NONE
            && !GetMonData(mon, MON_DATA_IS_EGG, 0)
            && GetMonData(mon, MON_DATA_HP, 0) != 0) {
            cnt++;
        }
    }

    if (cnt <= cntMax) {
        return FALSE;
    }
    do {
        do {
            monIndex = (BattleSystem_Random(battleSystem) % maxRand);
            monIndex += index0;
        } while (monIndex == monIndexA || monIndex == monIndexB);
        mon = Party_GetMonByIndex(party, monIndex);
    } while (GetMonData(mon, MON_DATA_SPECIES, 0) == SPECIES_NONE
        || GetMonData(mon, MON_DATA_IS_EGG, 0) == TRUE
        || GetMonData(mon, MON_DATA_HP, 0) == 0);
    ctx->unk_21A0[battlerId] = monIndex;
    return TRUE;
}

BOOL BtlCmd_TryWhirlwind(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (battleType & BATTLE_TYPE_TRAINER) {
        if (TryPickForcedSwitchIn(battleSystem, ctx, ctx->battlerIdTarget) == FALSE) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else if (WhirlwindCheck(battleSystem, ctx) == FALSE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_Transform(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 i;
    u8 *src, *dest;

    BattleScriptIncrementPointer(ctx, 1);

    ctx->battleMons[ctx->battlerIdAttacker].status2 |= STATUS2_TRANSFORM;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledMove = 0;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledTurns = 0;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.transformPersonality = ctx->battleMons[ctx->battlerIdTarget].personality;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.transformGender = ctx->battleMons[ctx->battlerIdTarget].gender;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.mimicedMoveIndex = 0;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount = 0;

    src = (u8 *)&ctx->battleMons[ctx->battlerIdAttacker];
    dest = (u8 *)&ctx->battleMons[ctx->battlerIdTarget];

    for (i = 0; i < 40; i++) {
        src[i] = dest[i];
    }

    ctx->battleMons[ctx->battlerIdAttacker].sendOutFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].intimidateFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].traceFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].downloadFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].anticipationFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].forewarnFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].friskFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].moldBreakerFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].pressureFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.truantFlag = ctx->totalTurns & 1;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.slowStartTurns = ctx->totalTurns + 1;
    ctx->battleMons[ctx->battlerIdAttacker].slowStartFlag = 0;
    ctx->battleMons[ctx->battlerIdAttacker].slowStartEnded = 0;

    for (i = 0; (int)i < MAX_MON_MOVES; i++) {
        if (BattleMoveTbl(ctx, ctx->battleMons[ctx->battlerIdAttacker].moves[i])->pp < 5) {
            ctx->battleMons[ctx->battlerIdAttacker].movePPCur[i] = BattleMoveTbl(ctx, ctx->battleMons[ctx->battlerIdAttacker].moves[i])->pp;
        } else {
            ctx->battleMons[ctx->battlerIdAttacker].movePPCur[i] = 5;
        }
    }

    return FALSE;
}

BOOL BtlCmd_TrySpikes(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) ^ 1;

    if (ctx->fieldSideConditionData[fieldSide].spikesLayers == 3) {
        ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure = 1;
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->fieldSideConditionFlags[fieldSide] |= SIDE_CONDITION_SPIKES;
        ctx->fieldSideConditionData[fieldSide].spikesLayers++;
    }

    return FALSE;
}

BOOL BtlCmd_CheckSpikes(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, battlerId);

    if (ctx->fieldSideConditionData[fieldSide].spikesLayers && ctx->battleMons[battlerId].hp) {
        ctx->hpCalc = (5 - ctx->fieldSideConditionData[fieldSide].spikesLayers) * 2;
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, ctx->hpCalc);
        // What the spikes take can send an Emergency Exit or Wimp Out
        // Pokemon straight back (Pokemon Central, Passoindietro).
        Battler_ArmRetreatOutsideMove(ctx, battlerId);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryPerishSong(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    ctx->calcTemp = maxBattlers;

    int cnt = 0;

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        // A Tatsugiri in its Dondozo's mouth does not hear it; one that heard
        // it first still counts down (Pokemon Central, Torre di Comando).
        if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_PERISH_SONG || ctx->battleMons[battlerId].hp == 0 || CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ABILITY_SOUNDPROOF) == TRUE
            || ctx->moveConditions[battlerId].commanding) {
            cnt++;
        } else {
            ctx->battleMons[battlerId].moveEffectFlags |= MOVE_EFFECT_FLAG_PERISH_SONG;
            ctx->battleMons[battlerId].unk88.perishSongTurns = 3;
        }
    }
    if (cnt == maxBattlers) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GetTurnOrderBySpeed(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 *unkPtr = BattleScriptGetVarPointer(battleSystem, ctx, BattleScriptReadWord(ctx));

    *unkPtr = ctx->turnOrder[ctx->unk_3104];

    return FALSE;
}

BOOL BtlCmd_GoToIfValidMon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 varId = BattleScriptReadWord(ctx);
    u32 adrs = BattleScriptReadWord(ctx);
    u32 *battlerId = BattleScriptGetVarPointer(battleSystem, ctx, varId);

    if (*battlerId < BattleSystem_GetMaxBattlers(battleSystem)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_EndOfTurnWeatherEffect(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    ctx->tempData = 0;
    ctx->hpCalc = 0;

    u32 type1 = GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL);
    u32 type2 = GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL);
    // A Utility Umbrella keeps the rain and the sun off its holder's Dry
    // Skin, Solar Power, Rain Dish and Hydration (Superombrello).
    u32 weather = WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId);

    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) == 0 && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK) == 0) {
        // Safety Goggles keep the sand and the hail off the same way Overcoat
        // does, and the reference writes it as one more term on each of those
        // two conditions. It is not on the sun or the rain below: nothing
        // there is weather falling on the Pokemon. Sand Rush and Sand Force
        // are spared the sand as Sand Veil is, as the reference has them.
        if (ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) {
            if (type1 != TYPE_ROCK && type2 != TYPE_ROCK && type1 != TYPE_STEEL && type2 != TYPE_STEEL && type1 != TYPE_GROUND && type2 != TYPE_GROUND && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) != ABILITY_SAND_VEIL && GetBattlerAbility(ctx, battlerId) != ABILITY_SAND_RUSH && GetBattlerAbility(ctx, battlerId) != ABILITY_SAND_FORCE && GetBattlerAbility(ctx, battlerId) != ABILITY_OVERCOAT && GetBattlerHeldItemEffect(ctx, battlerId) != HOLD_EFFECT_SPORE_POWDER_IMMUNITY && !(ctx->battleMons[battlerId].moveEffectFlags & 0x40080)) {
                ctx->moveTemp = MOVE_SANDSTORM;
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 16);
            }
        }
        if (weather & FIELD_CONDITION_SUN_ALL) {
            if (ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].moveEffectFlags & 0x40080)) {
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_DRY_SKIN || GetBattlerAbility(ctx, battlerId) == ABILITY_SOLAR_POWER) {
                    ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8);
                }
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_SOLAR_POWER) {
                    ctx->tempData = 2;
                }
            }
        }
        if (ctx->fieldCondition & FIELD_CONDITION_HAIL_ALL) {
            if (ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].moveEffectFlags & 0x40080)) {
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_ICE_BODY) {
                    if (ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp) {
                        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                    }
                } else if (type1 != TYPE_ICE && type2 != TYPE_ICE && GetBattlerAbility(ctx, battlerId) != ABILITY_SNOW_CLOAK && GetBattlerAbility(ctx, battlerId) != ABILITY_OVERCOAT && GetBattlerHeldItemEffect(ctx, battlerId) != HOLD_EFFECT_SPORE_POWDER_IMMUNITY) {
                    ctx->moveTemp = MOVE_HAIL;
                    ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 16);
                }
            }
        }
        // Snow is hail with nothing falling out of it: no damage, no types
        // or abilities to be spared from it, and Ice Body fed all the same.
        // The reference writes it as its own block beside the hail one.
        if (ctx->fieldCondition & FIELD_CONDITION_SNOW_ALL) {
            if (ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].moveEffectFlags & 0x40080) && GetBattlerAbility(ctx, battlerId) == ABILITY_ICE_BODY && ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
            }
        }
        if (weather & FIELD_CONDITION_RAIN_ALL) {
            if (ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp && GetBattlerAbility(ctx, battlerId) == ABILITY_RAIN_DISH) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
            }
            if (ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp && GetBattlerAbility(ctx, battlerId) == ABILITY_DRY_SKIN) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 8);
            }
            if (ctx->battleMons[battlerId].hp && (u8)ctx->battleMons[battlerId].status && GetBattlerAbility(ctx, battlerId) == ABILITY_HYDRATION) {
                if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                    ctx->msgTemp = 0;
                } else if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
                    ctx->msgTemp = 1;
                } else if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                    ctx->msgTemp = 2;
                } else if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                    ctx->msgTemp = 3;
                } else {
                    ctx->msgTemp = 4;
                }
                ctx->tempData = 1;
            }
        }
    }

    return FALSE;
}

BOOL BtlCmd_CalcRolloutPower(BattleSystem *battleSystem, BattleContext *ctx) {
    int i, j;
    BattleScriptIncrementPointer(ctx, 1);

    ctx->selfTurnData[ctx->battlerIdAttacker].rolloutCount = ctx->battleMons[ctx->battlerIdAttacker].unk88.rolloutCount;

    if (!(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
        LockBattlerIntoCurrentMove(battleSystem, ctx, ctx->battlerIdAttacker);
        ctx->battleMons[ctx->battlerIdAttacker].unk88.rolloutCount = 5;
    }

    if (--ctx->battleMons[ctx->battlerIdAttacker].unk88.rolloutCount == 0) {
        UnlockBattlerOutOfCurrentMove(battleSystem, ctx, ctx->battlerIdAttacker);
    }

    ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power;

    j = 5 - ctx->battleMons[ctx->battlerIdAttacker].unk88.rolloutCount;

    for (i = 1; i < j; i++) {
        ctx->movePower *= 2;
    }

    if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_DEFENSE_CURL) {
        ctx->movePower *= 2;
    }

    return FALSE;
}

BOOL BtlCmd_CalcFuryCutterPower(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;

    BattleScriptIncrementPointer(ctx, 1);

    // Three uses, as the engine counts them: its 40 doubles to 160 and stops,
    // where retail's 10 doubled four times to the same 160. Parental Bond's
    // second strike is the same use, and the reference does not count it.
    if (ctx->battleMons[ctx->battlerIdAttacker].unk88.furyCutterCount < 3 && !ParentalBond_IsSecondStrike(ctx)) {
        ctx->battleMons[ctx->battlerIdAttacker].unk88.furyCutterCount++;
    }

    ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power;

    for (i = 1; i < ctx->battleMons[ctx->battlerIdAttacker].unk88.furyCutterCount; i++) {
        ctx->movePower *= 2;
    }

    return FALSE;
}

BOOL BtlCmd_TryAttract(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdTemp].gender == ctx->battleMons[ctx->battlerIdStatChange].gender || ctx->battleMons[ctx->battlerIdStatChange].status2 & STATUS2_ATTRACT || ctx->battleMons[ctx->battlerIdTemp].gender == 2 || ctx->battleMons[ctx->battlerIdStatChange].gender == 2) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->battleMons[ctx->battlerIdStatChange].status2 |= MaskOfFlagNo(ctx->battlerIdTemp) << 16;
    }

    return FALSE;
}

BOOL BtlCmd_TrySafeguard(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    if (ctx->fieldSideConditionFlags[fieldSide] & SIDE_CONDITION_SAFEGUARD) {
        BattleScriptIncrementPointer(ctx, adrs);
        ctx->moveStatusFlag |= 64;
    } else {
        ctx->fieldSideConditionFlags[fieldSide] |= SIDE_CONDITION_SAFEGUARD;
        ctx->fieldSideConditionData[fieldSide].safeguardTurns = 5;
        ctx->fieldSideConditionData[fieldSide].safeguardBattler = ctx->battlerIdAttacker;
        ctx->buffMsg.tag = TAG_NONE_SIDE;
        ctx->buffMsg.param[0] = ctx->battlerIdAttacker;
        // "Your team became cloaked in a mystical veil!"
        ctx->buffMsg.id = msg_0197_00198;
    }

    return FALSE;
}

BOOL BtlCmd_Present(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    int adrs = BattleScriptReadWord(ctx);
    int rand = (u8)BattleSystem_Random(battleSystem);

    if (rand < 102) {
        ctx->movePower = 40;
    } else if (rand < 178) {
        ctx->movePower = 80;
    } else if (rand < 204) {
        ctx->movePower = 120;
    } else {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, 4);
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CalcMagnitudePower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if (ctx->magnitude == 0) {
        ctx->magnitude = BattleSystem_Random(battleSystem) % 100;
        if (ctx->magnitude < 5) {
            ctx->movePower = 10;
            ctx->magnitude = 4;
        } else if (ctx->magnitude < 15) {
            ctx->movePower = 30;
            ctx->magnitude = 5;
        } else if (ctx->magnitude < 35) {
            ctx->movePower = 50;
            ctx->magnitude = 6;
        } else if (ctx->magnitude < 65) {
            ctx->movePower = 70;
            ctx->magnitude = 7;
        } else if (ctx->magnitude < 85) {
            ctx->movePower = 90;
            ctx->magnitude = 8;
        } else if (ctx->magnitude < 95) {
            ctx->movePower = 110;
            ctx->magnitude = 9;
        } else {
            ctx->movePower = 150;
            ctx->magnitude = 10;
        }
    }

    ctx->msgTemp = ctx->magnitude;

    return FALSE;
}

BOOL BtlCmd_TryReplaceFaintedMon(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int flag = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (!CanSwitchMon(battleSystem, ctx, battlerId)) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else if (flag == 1) {
        ctx->unk_13C[battlerId] |= 1;
    }

    return FALSE;
}

static void EntryHazardQueueRemove(BattleContext *ctx, int side, int hazard);

BOOL BtlCmd_RapidSpin(BattleSystem *battleSystem, BattleContext *ctx) {
    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    // Binding Moves
    if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_BIND) {
        ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_BIND;
        ctx->battlerIdTemp = ctx->battleMons[ctx->battlerIdAttacker].unk88.battlerIdBinding;
        ctx->moveTemp = ctx->battleMons[ctx->battlerIdAttacker].unk88.bindingMove;
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BREAK_BIND_EFFECT);
        return FALSE;
    }

    // Leech Seed
    if (ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags & MOVE_EFFECT_FLAG_LEECH_SEED) {
        ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags &= ~MOVE_EFFECT_FLAG_LEECH_SEED;
        ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags &= ~3;
        ctx->moveTemp = 73;
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS);
        return FALSE;
    }

    // Spikes
    if (ctx->fieldSideConditionData[side].spikesLayers) {
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_SPIKES;
        ctx->fieldSideConditionData[side].spikesLayers = 0;
        ctx->moveTemp = MOVE_SPIKES;
        EntryHazardQueueRemove(ctx, side, HAZARD_IDX_SPIKES);
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS);
        return FALSE;
    }

    // Toxic Spikes
    if (ctx->fieldSideConditionData[side].toxicSpikesLayers) {
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_TOXIC_SPIKES;
        ctx->fieldSideConditionData[side].toxicSpikesLayers = 0;
        ctx->moveTemp = MOVE_TOXIC_SPIKES;
        EntryHazardQueueRemove(ctx, side, HAZARD_IDX_TOXIC_SPIKES);
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS);
        return FALSE;
    }

    // Stealth Rocks
    if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_STEALTH_ROCKS) {
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_STEALTH_ROCKS;
        ctx->moveTemp = MOVE_STEALTH_ROCK;
        EntryHazardQueueRemove(ctx, side, HAZARD_IDX_STEALTH_ROCK);
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS);
        return FALSE;
    }

    // Sticky Web, from the sixth generation on (the reference's
    // BtlCmd_RapidSpin).
    if (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_STICKY_WEB) {
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_STICKY_WEB;
        ctx->moveTemp = MOVE_STICKY_WEB;
        EntryHazardQueueRemove(ctx, side, HAZARD_IDX_STICKY_WEB);
        BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS);
        return FALSE;
    }

    BattleScriptIncrementPointer(ctx, 1);

    return FALSE;
}

BOOL BtlCmd_WeatherHPRecovery(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    // Under Mega Sol the user's always heals two thirds, as in the sun. Delta
    // Stream's winds leave it the half it heals in clear weather (hg-engine's
    // BtlCmd_WeatherHPRecovery).
    // A Utility Umbrella holder heals the half it heals in clear weather in
    // the rain or the sun too (Superombrello).
    u32 weather = BattlerMoveWeatherAt(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker);

    if (!weather || (weather & FIELD_CONDITION_STRONG_WINDS)) {
        ctx->hpCalc = ctx->battleMons[ctx->battlerIdAttacker].maxHp / 2;
    } else if (weather & FIELD_CONDITION_SUN_ALL) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * 20, 30);
    } else {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, 4);
    }

    return FALSE;
}

BOOL BtlCmd_CalcHiddenPowerParams(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ctx->movePower = ((ctx->battleMons[ctx->battlerIdAttacker].hpIV & 2) >> 1) | (ctx->battleMons[ctx->battlerIdAttacker].atkIV & 2) | ((ctx->battleMons[ctx->battlerIdAttacker].defIV & 2) << 1) | ((ctx->battleMons[ctx->battlerIdAttacker].speedIV & 2) << 2) | ((ctx->battleMons[ctx->battlerIdAttacker].spAtkIV & 2) << 3) | ((ctx->battleMons[ctx->battlerIdAttacker].spDefIV & 2) << 4);
    ctx->moveType = (ctx->battleMons[ctx->battlerIdAttacker].hpIV & 1) | ((ctx->battleMons[ctx->battlerIdAttacker].atkIV & 1) << 1) | ((ctx->battleMons[ctx->battlerIdAttacker].defIV & 1) << 2) | ((ctx->battleMons[ctx->battlerIdAttacker].speedIV & 1) << 3) | ((ctx->battleMons[ctx->battlerIdAttacker].spAtkIV & 1) << 4) | ((ctx->battleMons[ctx->battlerIdAttacker].spDefIV & 1) << 5);

    ctx->movePower = ctx->movePower * 40 / 63 + 30;
    ctx->moveType = ctx->moveType * 15 / 63 + 1;

    if (ctx->moveType >= TYPE_MYSTERY) {
        ctx->moveType++;
    }

    return FALSE;
}

BOOL BtlCmd_CopyStatStages(BattleSystem *battleSystem, BattleContext *ctx) {
    int stat;

    BattleScriptIncrementPointer(ctx, 1);

    for (stat = 0; stat < 8; stat++) {
        ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat] = ctx->battleMons[ctx->battlerIdTarget].statChanges[stat];
    }

    // From Generation VI Psych Up copies the target's critical-hit rise as it
    // copies its stages, so the user loses its own Focus Energy when the target
    // has none (Pokemon Central, Psicamisu). Retail and the reference OR it in.
    ctx->battleMons[ctx->battlerIdAttacker].status2 = (ctx->battleMons[ctx->battlerIdAttacker].status2 & ~STATUS2_FOCUS_ENERGY)
        | (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_FOCUS_ENERGY);
    ctx->moveConditions[ctx->battlerIdAttacker].laserFocusTimer = ctx->moveConditions[ctx->battlerIdTarget].laserFocusTimer;

    return FALSE;
}

BOOL BtlCmd_TryFutureSight(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->fieldConditionData.futureSightTurns[ctx->battlerIdTarget] == 0) {
        int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);
        ctx->fieldSideConditionFlags[side] |= SIDE_CONDITION_FUTURE_SIGHT;
        ctx->fieldConditionData.futureSightTurns[ctx->battlerIdTarget] = 3;
        ctx->fieldConditionData.futureSightMoveNo[ctx->battlerIdTarget] = ctx->moveNoCur;
        ctx->fieldConditionData.battlerIdFutureSight[ctx->battlerIdTarget] = ctx->battlerIdAttacker;
        // Nothing is worked out now: the hit is, when it lands, and for that
        // the user is remembered, by its place in its party
        // (BattleContext_LandFutureSight).
        ctx->fieldConditionData.futureSightMonIndex[ctx->battlerIdTarget] = ctx->selectedMonIndex[ctx->battlerIdAttacker];
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Where the Pokemon that used Future Sight or Doom Desire from slot is now:
// on the field in its own place or, in a double battle, its partner's, or
// BATTLER_NONE -- switched out, or fainted where it stood.
static int FutureSightUser(BattleSystem *battleSystem, BattleContext *ctx, int slot, Pokemon *user) {
    int battlerId = slot;
    int i;

    for (i = 0; i < 2; i++, battlerId ^= 2) {
        if (battlerId < BattleSystem_GetMaxBattlers(battleSystem) && ctx->battleMons[battlerId].hp
            && BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]) == user) {
            return battlerId;
        }
    }
    return BATTLER_NONE;
}

// A Pokemon that is not on the field, as the damage calculation is to see it:
// its party stats and its own types, no stat stages, no ability, no item and
// no status (Pokemon Central, Divinazione; the reference's CalcBaseDamage,
// battle_calc_damage.c:128 at d0380a487).
static void BattleMon_LoadPartyStats(BattleMon *mon, Pokemon *pokemon) {
    int i;

    MI_CpuClear8(mon, sizeof(BattleMon));
    mon->species = GetMonData(pokemon, MON_DATA_SPECIES, NULL);
    mon->atk = GetMonData(pokemon, MON_DATA_ATK, NULL);
    mon->def = GetMonData(pokemon, MON_DATA_DEF, NULL);
    mon->speed = GetMonData(pokemon, MON_DATA_SPEED, NULL);
    mon->spAtk = GetMonData(pokemon, MON_DATA_SP_ATK, NULL);
    mon->spDef = GetMonData(pokemon, MON_DATA_SP_DEF, NULL);
    for (i = 0; i < NUM_BATTLE_STATS; i++) {
        mon->statChanges[i] = 6;
    }
    mon->type1 = GetMonData(pokemon, MON_DATA_TYPE_1, NULL);
    mon->type2 = GetMonData(pokemon, MON_DATA_TYPE_2, NULL);
    mon->type3 = TYPE_NONE;
    mon->level = GetMonData(pokemon, MON_DATA_LEVEL, NULL);
    mon->friendship = GetMonData(pokemon, MON_DATA_FRIENDSHIP, NULL);
    mon->hp = GetMonData(pokemon, MON_DATA_HP, NULL);
    mon->maxHp = GetMonData(pokemon, MON_DATA_MAX_HP, NULL);
    mon->gender = GetMonData(pokemon, MON_DATA_GENDER, NULL);
    mon->personality = GetMonData(pokemon, MON_DATA_PERSONALITY, NULL);
}

// Future Sight or Doom Desire lands on battlerIdTarget, and is worked out now,
// as it is from the fifth generation (Pokemon Central, Divinazione; the
// reference's CalcBaseDamage, battle_calc_damage.c:28 at d0380a487): a critical
// hit, the weather, the screens, the type chart and everything else as they
// stand. The user strikes as it is if it is on the field, in its own place or
// its partner's; if it is not, it strikes from its own place with its party
// stats (BattleMon_LoadPartyStats), which stand in for whoever is there for as
// long as the sum takes -- the accuracy check too. The damage goes in hpCalc,
// the chart's verdict and whether it hit in moveStatusFlag, for subscript 121;
// attacker and target are left set for it.
void BattleContext_LandFutureSight(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdTarget) {
    int slot = ctx->fieldConditionData.battlerIdFutureSight[battlerIdTarget];
    Pokemon *user = BattleSystem_GetPartyMon(battleSystem, slot, ctx->fieldConditionData.futureSightMonIndex[battlerIdTarget]);
    int battlerIdAttacker = FutureSightUser(battleSystem, ctx, slot, user);
    BattleMon onField;

    ctx->battlerIdAttacker = battlerIdAttacker == BATTLER_NONE ? slot : battlerIdAttacker;
    ctx->battlerIdTarget = battlerIdTarget;
    ctx->moveNoCur = ctx->fieldConditionData.futureSightMoveNo[battlerIdTarget];
    ctx->moveStatusFlag = 0;
    if (battlerIdAttacker == BATTLER_NONE) {
        onField = ctx->battleMons[ctx->battlerIdAttacker];
        BattleMon_LoadPartyStats(&ctx->battleMons[ctx->battlerIdAttacker], user);
    }
    ctx->moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);
    ctx->criticalMultiplier = TryCriticalHit(battleSystem, ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->criticalCnt, ov12_022581D4(battleSystem, ctx, 0, battlerIdTarget));
    DamageCalcDefault(battleSystem, ctx, TRUE);
    ov12_02251D28(battleSystem, ctx, ctx->moveNoCur, ctx->moveType, ctx->battlerIdAttacker, battlerIdTarget, ctx->damage, &ctx->moveStatusFlag);
    BattleSystem_CheckMoveHitEffect(battleSystem, ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->moveNoCur);
    ctx->hpCalc = -ctx->damage;
    // What the hit meets that answers it as it lands, as a move's hit does
    // (ov12_0224B498, CheckAbilityEffectOnHit), asked while the user is still
    // standing in for itself: a Disguise takes the whole hit and breaks
    // (Pokemon Central, Fantasmanto: any damaging move, not through a
    // substitute), and Tera Shell at full HP says so before it lands, the
    // damage having been reduced already. Ice Face stops only physical moves,
    // and these two are special. Subscript 121 runs the one in tempData.
    ctx->tempData = 0;
    if (!(ctx->moveStatusFlag & MOVE_STATUS_DID_NOT_HIT)) {
        u16 form = Battler_BrokenFaceForm(ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->moveNoCur);

        if (form != SPECIES_NONE && !(ctx->battleMons[battlerIdTarget].status2 & STATUS2_SUBSTITUTE)) {
            ctx->hpCalc = 0;
            ctx->moveStatusFlag &= ~MOVE_STATUS_ANY_EFFECTIVE;
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerIdTarget, form, TRUE);
            ctx->tempData = BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE;
        } else if (TeraShellResists(ctx, ctx->battlerIdAttacker, battlerIdTarget, ctx->moveNoCur) == TRUE) {
            ctx->tempData = BATTLE_SUBSCRIPT_TERA_SHELL;
        }
    }
    if (battlerIdAttacker == BATTLER_NONE) {
        ctx->battleMons[ctx->battlerIdAttacker] = onField;
    }
}

BOOL BtlCmd_CheckMoveHit(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int sideAttacker = BattleScriptReadWord(ctx);
    int sideTarget = BattleScriptReadWord(ctx);
    int move = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerIdAttacker = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideAttacker);
    int battlerIdTarget = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideTarget);
    int moveMsgNo = GetMoveMessageNo(ctx, move);

    BattleSystem_CheckMoveHitEffect(battleSystem, ctx, battlerIdAttacker, battlerIdTarget, moveMsgNo);

    if (ctx->moveStatusFlag & 0x1fd849) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryTeleport(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u32 adrs = BattleScriptReadWord(ctx);

    if (CantEscape(battleSystem, ctx, ctx->battlerIdAttacker, NULL)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// A party member Beat Up strikes for: the user whatever its state, and
// everyone else who is not fainted, not an egg and has no status condition.
static BOOL BeatUpMemberStrikes(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int slot) {
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, slot);

    return slot == ctx->selectedMonIndex[battlerId]
        || (GetMonData(mon, MON_DATA_HP, NULL) != 0
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_NONE
            && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL) != SPECIES_EGG
            && GetMonData(mon, MON_DATA_STATUS, NULL) == STATUS_NONE);
}

// The power of the hit a member strikes: 5 + its base Attack / 10.
static int BeatUpMemberPower(BattleSystem *battleSystem, int battlerId, int slot) {
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, slot);

    return 5 + GetMonBaseStat_HandleAlternateForm(GetMonData(mon, MON_DATA_SPECIES, NULL), GetMonData(mon, MON_DATA_FORM, NULL), BASE_ATK) / 10;
}

// What the trainer AI values the battler's Beat Up at (ov10_0221F084): the
// powers of all its hits, summed into one.
// ponytail: one hit at the summed power, not one estimate per hit; it misses
// each hit's own rounding and critical roll, which the AI's comparison does not need.
int BeatUp_TotalPower(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i, power = 0;

    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, battlerId); i++) {
        if (BeatUpMemberStrikes(battleSystem, ctx, battlerId, i)) {
            power += BeatUpMemberPower(battleSystem, battlerId, i);
        }
    }
    return power;
}

// Beat Up from the fifth generation on, as the reference has it (its BeatUp
// command and CalcBaseDamage.c): one hit for each member that strikes, each an
// ordinary hit of the Dark-type move with the user's Attack against the
// target's Defence, at a power of 5 + that member's base Attack / 10. The
// first call counts the hits and sets the move up as a multi-hit one; every
// call gives the next member's power to the CalcDamage after it.
BOOL BtlCmd_BeatUp(BattleSystem *battleSystem, BattleContext *ctx) {
    int monCnt, i;

    BattleScriptIncrementPointer(ctx, 1);

    monCnt = BattleSystem_GetPartySize(battleSystem, ctx->battlerIdAttacker);

    if (ctx->multiHitCountTemp == 0) {
        ctx->multiHitCount = 0;
        for (i = 0; i < monCnt; i++) {
            if (BeatUpMemberStrikes(battleSystem, ctx, ctx->battlerIdAttacker, i)) {
                ctx->multiHitCount++;
            }
        }
        ctx->multiHitCountTemp = ctx->multiHitCount;
        ctx->checkMultiHit = MULTIHIT_MULTI_HIT_MOVE;
        ctx->beatUpCount = 0;
    }

    while (ctx->beatUpCount < monCnt && !BeatUpMemberStrikes(battleSystem, ctx, ctx->battlerIdAttacker, ctx->beatUpCount)) {
        ctx->beatUpCount++;
    }
    if (ctx->beatUpCount >= monCnt) {
        return FALSE;
    }

    ctx->movePower = BeatUpMemberPower(battleSystem, ctx->battlerIdAttacker, ctx->beatUpCount++);

    return FALSE;
}

BOOL BtlCmd_FollowMe(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    ctx->fieldSideConditionData[side].followMeFlag = TRUE;
    ctx->fieldSideConditionData[side].battlerIdFollowMe = ctx->battlerIdAttacker;

    return FALSE;
}

BOOL BtlCmd_TryHelpingHand(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (battleType & BATTLE_TYPE_DOUBLES) {
        battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, 16);
        if ((ctx->switchInFlag & MaskOfFlagNo(battlerId)) == 0 && ctx->playerActions[battlerId].command != CONTROLLER_COMMAND_40 && ctx->battleMons[battlerId].hp && !ctx->turnData[ctx->battlerIdAttacker].helpingHandFlag && !ctx->turnData[battlerId].helpingHandFlag) {
            ctx->battlerIdTemp = battlerId;
            ctx->turnData[battlerId].helpingHandFlag = TRUE;
        } else {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TrySwapItems(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrsA = BattleScriptReadWord(ctx);
    int adrsB = BattleScriptReadWord(ctx);

    int sideAttacker = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    int sideTarget = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    // HeartGold refuses the swap when the other side starts it outside a link
    // or Frontier battle, so the player can never lose a held item to the AI.
    // New Gold drops that refusal: whatever the player was holding is handed
    // back when the battle ends, a Berry too (NoteHeldItemGiven), so the item
    // is not gone for good.
    if ((ctx->fieldSideConditionData[sideAttacker].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdAttacker])) || (ctx->fieldSideConditionData[sideTarget].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdTarget]))) {
        BattleScriptIncrementPointer(ctx, adrsA);
    } else if ((ctx->battleMons[ctx->battlerIdAttacker].item == 0 && ctx->battleMons[ctx->battlerIdTarget].item == 0) || !CanTrickHeldItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)) {
        BattleScriptIncrementPointer(ctx, adrsA);
    } else if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrsB);
    } else {
        NoteHeldItemGiven(battleSystem, ctx, ctx->battlerIdAttacker);
        NoteHeldItemGiven(battleSystem, ctx, ctx->battlerIdTarget);
    }

    return FALSE;
}

BOOL BtlCmd_TryWish(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->fieldConditionData.wishTurns[ctx->battlerIdAttacker]) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->fieldConditionData.wishTurns[ctx->battlerIdAttacker] = 2;
        ctx->fieldConditionData.wishTarget[ctx->battlerIdAttacker] = ctx->selectedMonIndex[ctx->battlerIdAttacker];
    }

    return FALSE;
}

BOOL BtlCmd_TryAssist(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 unkA;
    u16 avaliableMoves[6 * 4];
    u16 move;
    int i, j, monCnt, moveCnt;
    Pokemon *mon;

    BattleScriptIncrementPointer(ctx, 1);

    unkA = BattleScriptReadWord(ctx);

    moveCnt = 0;
    monCnt = BattleSystem_GetPartySize(battleSystem, ctx->battlerIdAttacker);

    for (i = 0; i < monCnt; i++) {
        if (i != ctx->selectedMonIndex[ctx->battlerIdAttacker]) {
            mon = BattleSystem_GetPartyMon(battleSystem, ctx->battlerIdAttacker, i);
            if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_NONE
                && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_EGG) {
                for (j = 0; j < MAX_MON_MOVES; j++) {
                    move = GetMonData(mon, MON_DATA_MOVE1 + j, 0);
                    if (CheckMoveCallsOtherMove(move) == FALSE && CheckLegalMetronomeMove(battleSystem, ctx, ctx->battlerIdAttacker, move) == TRUE) {
                        avaliableMoves[moveCnt] = move;
                        moveCnt++;
                    }
                }
            }
        }
    }

    if (moveCnt) {
        ctx->moveTemp = avaliableMoves[BattleSystem_Random(battleSystem) % moveCnt];
    } else {
        BattleScriptIncrementPointer(ctx, unkA);
    }

    return FALSE;
}

BOOL BtlCmd_TrySetMagicCoat(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;

    BattleScriptIncrementPointer(ctx, 1);
    u32 unkA = BattleScriptReadWord(ctx);

    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {}

    if (ctx->battlersOnField == 1) {
        BattleScriptIncrementPointer(ctx, unkA);
    } else {
        ctx->turnData[ctx->battlerIdAttacker].magicCoatFlag = 1;
    }

    return FALSE;
}

BOOL BtlCmd_MagicCoat(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    int battlerId = ctx->battlerIdAttacker;
    ctx->battlerIdMagicCoat = battlerId;
    ctx->battlerIdAttacker = ctx->battlerIdTarget;

    if (ctx->fieldSideConditionData[side].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[side].battlerIdFollowMe].hp) {
        ctx->battlerIdTarget = ctx->fieldSideConditionData[side].battlerIdFollowMe;
    } else if (BattleMoveTbl(ctx, ctx->moveNoCur)->range == RANGE_ADJACENT_OPPONENTS || BattleMoveTbl(ctx, ctx->moveNoCur)->range == RANGE_ALL_ADJACENT) {
        ctx->battlerIdTarget = battlerId;
    } else {
        side = ov12_022506D4(battleSystem, ctx, ctx->battlerIdAttacker, (u16)ctx->moveNoCur, 1, 0);
        if (ctx->selfTurnData[side].lightningRodFlag || ctx->selfTurnData[side].stormDrainFlag) {
            ctx->battlerIdTarget = side;
        } else {
            ctx->battlerIdTarget = battlerId;
        }
    }

    ctx->battleStatus2 |= BATTLE_STATUS2_MAGIC_COAT;

    return FALSE;
}

BOOL BtlCmd_CalcRevengeDamageMul(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if ((ctx->turnData[ctx->battlerIdAttacker].physicalDamage[ctx->battlerIdTarget] && ctx->turnData[ctx->battlerIdAttacker].battlerBitPhysicalDamage & MaskOfFlagNo(ctx->battlerIdTarget)) || (ctx->turnData[ctx->battlerIdAttacker].specialDamage[ctx->battlerIdTarget] && ctx->turnData[ctx->battlerIdAttacker].battlerBitSpecialDamage & MaskOfFlagNo(ctx->battlerIdTarget))) {
        ctx->unk_2158 = 20;
    } else {
        ctx->unk_2158 = 10;
    }

    return FALSE;
}

BOOL BtlCmd_TryBreakScreens(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    if ((ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_REFLECT) || (ctx->fieldSideConditionFlags[side] & SIDE_CONDITION_LIGHT_SCREEN)) {
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_REFLECT;
        ctx->fieldSideConditionFlags[side] &= ~SIDE_CONDITION_LIGHT_SCREEN;
        ctx->fieldSideConditionData[side].reflectTurns = 0;
        ctx->fieldSideConditionData[side].lightScreenTurns = 0;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryYawn(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    u32 adrs = BattleScriptReadWord(ctx);
    if (ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_YAWN) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags |= (2 << MOVE_EFFECT_FLAG_YAWN_SHIFT);
    }

    return FALSE;
}

BOOL BtlCmd_TryKnockOff(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    // Sticky Hold keeps nothing for a holder the move has felled (Pokemon
    // Central, Antifurto, from the fifth generation).
    if (ctx->battleMons[ctx->battlerIdTarget].item && ctx->battleMons[ctx->battlerIdTarget].hp && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD) == TRUE) {
        // "{0}'s {1} made {2} ineffective!"
        ctx->buffMsg.id = msg_0197_00714;
        ctx->buffMsg.tag = TAG_NICKNAME_ABILITY_MOVE;
        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdTarget);
        ctx->buffMsg.param[1] = ctx->battleMons[ctx->battlerIdTarget].ability;
        ctx->buffMsg.param[2] = ctx->moveNoCur;
    } else if (KnockOffCanRemoveItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)) {
        // "{0} knocked off {1}'s {2}!", or Corrosive Gas's "{0} corroded
        // {1}'s {2}!": the item is gone for the rest of the battle either way,
        // out of Recycle's and Harvest's reach (Pokemon Central, Gas
        // Corrosivo).
        ctx->buffMsg.id = ctx->moveNoCur == MOVE_CORROSIVE_GAS ? msg_0197_01863 : msg_0197_00552;
        ctx->buffMsg.tag = TAG_NICKNAME_NICKNAME_ITEM;
        ctx->buffMsg.param[0] = CreateNicknameTag(ctx, ctx->battlerIdAttacker);
        ctx->buffMsg.param[1] = CreateNicknameTag(ctx, ctx->battlerIdTarget);
        ctx->buffMsg.param[2] = ctx->battleMons[ctx->battlerIdTarget].item;
        ctx->battleMons[ctx->battlerIdTarget].item = 0;
        ctx->fieldSideConditionData[side].battlerBitKnockedOffItem |= MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdTarget]);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CalcHPFalloffPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if (ctx->movePower == 0) {
        ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power * ctx->battleMons[ctx->battlerIdAttacker].hp / ctx->battleMons[ctx->battlerIdAttacker].maxHp;
        if (ctx->movePower == 0) {
            ctx->movePower = 1;
        }
    }

    return FALSE;
}

BOOL BtlCmd_TryImprison(BattleSystem *battleSystem, BattleContext *ctx) {
    int adrs, side, i, j, battlerId, maxBattlers, battlerIdA, battlerIdB;

    BattleScriptIncrementPointer(ctx, 1);

    adrs = BattleScriptReadWord(ctx);

    battlerIdA = ov12_0223ABB8(battleSystem, ctx->battlerIdAttacker, 0);
    battlerIdB = ov12_0223ABB8(battleSystem, ctx->battlerIdAttacker, 2);

    ctx->battleMons[battlerIdA].moveEffectFlags |= MOVE_EFFECT_FLAG_IMPRISON;
    ctx->battleMons[battlerIdB].moveEffectFlags |= MOVE_EFFECT_FLAG_IMPRISON;

    if (ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags & MOVE_EFFECT_FLAG_IMPRISON_USER) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
        maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            if (side != BattleSystem_GetFieldSide(battleSystem, battlerId)) {
                for (i = 0; i < MAX_MON_MOVES; i++) {
                    for (j = 0; j < MAX_MON_MOVES; j++) {
                        if ((ctx->battleMons[ctx->battlerIdAttacker].moves[i] == ctx->battleMons[battlerId].moves[j]) && ctx->battleMons[ctx->battlerIdAttacker].moves[i] && ctx->battleMons[battlerId].moves[j]) {
                            break;
                        }
                    }
                    if (j != MAX_MON_MOVES) {
                        break;
                    }
                }
                if (j != MAX_MON_MOVES) {
                    break;
                }
            }
        }
        if (battlerId == maxBattlers) {
            BattleScriptIncrementPointer(ctx, adrs);
        } else {
            ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags |= MOVE_EFFECT_FLAG_IMPRISON_USER;
        }
    }

    return FALSE;
}

BOOL BtlCmd_TryGrudge(BattleSystem *battleSystem, BattleContext *ctx) {
    int pos;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    if (ctx->battleMons[ctx->battlerIdFainted].moveEffectFlags & MOVE_EFFECT_FLAG_GRUDGE && BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) != BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdFainted) && ctx->battleMons[ctx->battlerIdAttacker].hp && ctx->moveNoTemp != MOVE_STRUGGLE) {
        pos = ctx->movePos[ctx->battlerIdAttacker];
        ctx->battleMons[ctx->battlerIdAttacker].movePPCur[pos] = 0;
        ctx->moveTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[pos];
        CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdAttacker);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TrySnatch(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    u32 maxBattlers;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    maxBattlers = 0;
    for (battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
        if (ctx->battleMons[battlerId].hp) {
            maxBattlers++;
        }
    }

    if (ctx->battlersOnField == 1) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->turnData[ctx->battlerIdAttacker].snatchFlag = TRUE;
    }

    return FALSE;
}

// Heavy Metal doubles the weight a move asks after and Light Metal halves it.
// Mold Breaker switches either off, except when the Pokemon asking is the one
// being weighed: there is no mold to break against yourself.
//
// A Float Stone halves it once more, after either ability and whichever it
// was. The reference collects its halvings into one divisor and applies it at
// the end, so Heavy Metal and a Float Stone cancel and Light Metal with one
// quarters the weight; dividing twice here reaches the same numbers, whole
// division included. The reference asks for the item by name, this asks the
// record the import gave it, which is the same one item.
static int BattlerWeight(BattleContext *ctx, int battlerIdAttacker, int battlerId) {
    int weight = ctx->battleMons[battlerId].weight;

    if (battlerIdAttacker == battlerId) {
        if (GetBattlerAbility(ctx, battlerId) == ABILITY_HEAVY_METAL) {
            weight *= 2;
        } else if (GetBattlerAbility(ctx, battlerId) == ABILITY_LIGHT_METAL) {
            weight /= 2;
        }
    } else if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerId, ABILITY_HEAVY_METAL) == TRUE) {
        weight *= 2;
    } else if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerId, ABILITY_LIGHT_METAL) == TRUE) {
        weight /= 2;
    }

    if (GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_HALVE_WEIGHT) {
        weight /= 2;
    }

    return weight;
}

BOOL BtlCmd_CalcWeightBasedPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int cnt = 0;
    int weight = BattlerWeight(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);

    do {
        if (sLowKickDamageTable[cnt][0] >= weight) {
            break;
        }
        cnt++;
    } while (sLowKickDamageTable[cnt][0] != 0xffff);

    if (sLowKickDamageTable[cnt][0] != 0xffff) {
        ctx->movePower = sLowKickDamageTable[cnt][1];
    } else {
        ctx->movePower = 120;
    }

    return FALSE;
}

BOOL BtlCmd_CalcWeatherBallParams(BattleSystem *battleSystem, BattleContext *ctx) {
    // Under Mega Sol the user's is a Fire move of double power, whatever the
    // weather. Under Cloud Nine or Air Lock there is none, and the power is
    // the move's own, which is what an unset power reads as anyway; Delta
    // Stream's winds leave it Normal and undoubled too (hg-engine's), and a
    // Utility Umbrella the rain and the sun (WeatherBallWeather).
    u32 weather = WeatherBallWeather(BattlerMoveWeather(battleSystem, ctx, ctx->battlerIdAttacker), GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker));

    BattleScriptIncrementPointer(ctx, 1);

    if (weather) {
        // Snow makes it an Ice move of double power, as hail did, from the
        // ninth generation (Pokemon Central, Palla Clima); the reference
        // leaves the move alone under it.
        ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power * 2;
        if (WeatherBallType(weather) != TYPE_NORMAL) {
            ctx->moveType = WeatherBallType(weather);
        }
    } else {
        ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power;
    }

    return FALSE;
}

BOOL BtlCmd_TryPursuit(BattleSystem *battleSystem, BattleContext *ctx) {
    int adrs, battlerId, maxBattlers, moveNo, moveIndex;

    BattleScriptIncrementPointer(ctx, 1);

    adrs = BattleScriptReadWord(ctx);
    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->playerActions[battlerId].command != CONTROLLER_COMMAND_40 && ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].status & 39) && !CheckTruant(ctx, battlerId) && BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdSwitch)) {
            if (ctx->battleMons[battlerId].unk88.encoredMove && ctx->battleMons[battlerId].unk88.encoredMove == ctx->battleMons[battlerId].moves[ctx->battleMons[battlerId].unk88.encoredMoveIndex]) {
                moveNo = ctx->battleMons[battlerId].unk88.encoredMove;
            } else {
                moveNo = GetBattlerSelectedMove(ctx, battlerId);
            }
            if (moveNo) {
                moveIndex = BattleMon_GetMoveIndex(&ctx->battleMons[battlerId], moveNo);
                if (BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_HIT_BEFORE_SWITCH && ctx->battleMons[battlerId].movePPCur[moveIndex]) {
                    ctx->battleMons[battlerId].movePPCur[moveIndex]--;
                    if (GetBattlerAbility(ctx, ctx->battlerIdSwitch) == ABILITY_PRESSURE && ctx->battleMons[battlerId].movePPCur[moveIndex]) {
                        ctx->battleMons[battlerId].movePPCur[moveIndex]--;
                    }
                    ov12_02252D14(battleSystem, ctx);
                    ctx->battlerIdAttacker = battlerId;
                    ctx->battlerIdTarget = ctx->battlerIdSwitch;
                    ctx->unk_2158 = 20;
                    ctx->moveNoCur = moveNo;
                    ctx->moveNoBattlerPrev[battlerId] = moveNo;
                    ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_40;
                    CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
                    break;
                }
            }
        }
    }

    if (battlerId == maxBattlers) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        int itemEffect = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker);
        GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);

        if (itemEffect == HOLD_EFFECT_CHOICE_ATK || itemEffect == HOLD_EFFECT_CHOICE_SPEED || itemEffect == HOLD_EFFECT_CHOICE_SPATK) {
            ctx->battleMons[ctx->battlerIdAttacker].unk88.moveNoChoice = moveNo;
        }
    }

    return FALSE;
}

// The flags alone: CalcDamage has already taken the type chart into the
// damage, as the reference's does, and Pursuit's is the only script that asks.
BOOL BtlCmd_ApplyTypeEffectiveness(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ov12_02251D28(battleSystem, ctx, ctx->moveNoCur, ctx->moveType, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->damage, &ctx->moveStatusFlag);

    return FALSE;
}

BOOL BtlCmd_IfTurnFlag(BattleSystem *battleSystem, BattleContext *ctx) {
    int ret = FALSE;

    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int flag = BattleScriptReadWord(ctx);
    int val = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    switch (flag) {
    case 0:
        if (ctx->turnData[battlerId].struggleFlag == val) {
            ret = TRUE;
        }
        break;
    case 1:
        if (ctx->turnData[battlerId].unk0_1 == val) {
            ret = TRUE;
        }
        break;
    case 2:
        if (ctx->turnData[battlerId].protectFlag == val) {
            ret = TRUE;
        }
        break;
    case 3:
        if (ctx->turnData[battlerId].helpingHandFlag == val) {
            ret = TRUE;
        }
        break;
    case 4:
        if (ctx->turnData[battlerId].magicCoatFlag == val) {
            ret = TRUE;
        }
        break;
    case 5:
        if (ctx->turnData[battlerId].snatchFlag == val) {
            ret = TRUE;
        }
        break;
    case 6:
        if (ctx->turnData[battlerId].roostFlag == val) {
            ret = TRUE;
        }
        break;
    }

    if (ret) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_SetTurnFlag(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int flag = BattleScriptReadWord(ctx);
    int val = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    switch (flag) {
    case 0:
        ctx->turnData[battlerId].struggleFlag = val;
        break;
    case 1:
        ctx->turnData[battlerId].unk0_1 = val;
        break;
    case 2:
        ctx->turnData[battlerId].protectFlag = val;
        break;
    case 3:
        ctx->turnData[battlerId].helpingHandFlag = val;
        break;
    case 4:
        ctx->turnData[battlerId].magicCoatFlag = val;
        break;
    case 5:
        ctx->turnData[battlerId].snatchFlag = val;
        break;
    case 6:
        ctx->turnData[battlerId].roostFlag = val;
        break;
    }

    return FALSE;
}

BOOL BtlCmd_CalcGyroBallPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ctx->movePower = 1 + 25 * ctx->effectiveSpeed[ctx->battlerIdTarget] / ctx->effectiveSpeed[ctx->battlerIdAttacker];

    if (ctx->movePower > 150) {
        ctx->movePower = 150;
    }

    return FALSE;
}

BOOL BtlCmd_TryMetalBurst(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int sideA = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    int sideB = BattleSystem_GetFieldSide(battleSystem, ctx->turnData[ctx->battlerIdAttacker].unk38);

    if (ctx->turnData[ctx->battlerIdAttacker].unk34 && sideA != sideB && ctx->battleMons[ctx->turnData[ctx->battlerIdAttacker].unk38].hp) {
        ctx->damage = ctx->turnData[ctx->battlerIdAttacker].unk34 * 15 / 10;
        if (ctx->fieldSideConditionData[sideB].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[sideB].battlerIdFollowMe].hp) {
            ctx->battlerIdTarget = ctx->fieldSideConditionData[sideB].battlerIdFollowMe;
        } else {
            ctx->battlerIdTarget = ctx->turnData[ctx->battlerIdAttacker].unk38;
        }
        if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
            ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, ctx->battlerIdAttacker);
            if (ctx->battleMons[ctx->battlerIdTarget].hp == 0) {
                ctx->commandNext = CONTROLLER_COMMAND_39;
                BattleScriptJump(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_NO_TARGET);
            }
        }
        CheckIgnorePressure(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CalcPaybackPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if (ctx->playerActions[ctx->battlerIdTarget].command == CONTROLLER_COMMAND_40) {
        ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power * 2;
    } else {
        ctx->movePower = BattleMoveTbl(ctx, ctx->moveNoCur)->power;
    }

    return FALSE;
}

BOOL BtlCmd_CalcTrumpCardPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u8 pp = ctx->battleMons[ctx->battlerIdAttacker].movePPCur[ctx->movePos[ctx->battlerIdAttacker]];

    if (pp > 4) {
        pp = 4;
    }

    ctx->movePower = sTrumpCardPowerTable[pp];

    return FALSE;
}

BOOL BtlCmd_CalcWringOutPower(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    // Hard Press shares the effect with a scale of its own: 100 times the
    // share of HP the target has left, and never less than 1 (Pokemon
    // Central, Pressa d'Acciaio).
    if (ctx->moveNoCur == MOVE_HARD_PRESS) {
        ctx->movePower = (100 * ctx->battleMons[ctx->battlerIdTarget].hp) / ctx->battleMons[ctx->battlerIdTarget].maxHp;
        if (ctx->movePower == 0) {
            ctx->movePower = 1;
        }
        return FALSE;
    }

    ctx->movePower = 1 + (120 * ctx->battleMons[ctx->battlerIdTarget].hp) / ctx->battleMons[ctx->battlerIdTarget].maxHp;

    return FALSE;
}

BOOL BtlCmd_TryMeFirst(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    u16 move;

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove && ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove == ctx->battleMons[ctx->battlerIdTarget].moves[ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMoveIndex]) {
        move = ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove;
    } else {
        move = GetBattlerSelectedMove(ctx, ctx->battlerIdTarget);
    }

    if (ctx->playerActions[ctx->battlerIdTarget].command != CONTROLLER_COMMAND_40 && ctx->turnData[ctx->battlerIdTarget].struggleFlag == 0 && CheckLegalMeFirstMove(ctx, move) == TRUE && BattleMoveTbl(ctx, move)->power) {
        ctx->battleMons[ctx->battlerIdAttacker].unk88.meFirstFlag = TRUE;
        ctx->battleMons[ctx->battlerIdAttacker].unk88.meFirstCount = ctx->meFirstTotal;
        ctx->moveTemp = move;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryCopycat(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (CheckMoveCallsOtherMove(ctx->moveNoPrev) == FALSE && ctx->moveNoPrev && CheckLegalMetronomeMove(battleSystem, ctx, ctx->battlerIdAttacker, ctx->moveNoPrev) == TRUE) {
        ctx->moveTemp = ctx->moveNoPrev;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CalcPunishmentPower(BattleSystem *battleSystem, BattleContext *ctx) {
    int stat, cnt;

    BattleScriptIncrementPointer(ctx, 1);

    cnt = 0;
    for (stat = 0; stat < 8; stat++) {
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[stat] > 6) {
            cnt += ctx->battleMons[ctx->battlerIdTarget].statChanges[stat] - 6;
        }
    }

    ctx->movePower = 60 + 20 * cnt;

    if (ctx->movePower > 200) {
        ctx->movePower = 200;
    }

    return FALSE;
}

BOOL BtlCmd_TrySuckerPunch(BattleSystem *battleSystem, BattleContext *ctx) {
    int move;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove && ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove == ctx->battleMons[ctx->battlerIdTarget].moves[ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMoveIndex]) {
        move = ctx->battleMons[ctx->battlerIdTarget].unk88.encoredMove;
    } else {
        move = GetBattlerSelectedMove(ctx, ctx->battlerIdTarget);
    }

    if (ctx->playerActions[ctx->battlerIdTarget].command == CONTROLLER_COMMAND_40 || (BattleMoveTbl(ctx, move)->power == 0 && !ctx->turnData[ctx->battlerIdTarget].struggleFlag)) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else if (ctx->moveNoCur == MOVE_UPPER_HAND
        && (BattlerMovePriority(ctx, ctx->battlerIdTarget, move) < 1 || BattlerMovePriority(ctx, ctx->battlerIdTarget, move) > 3)) {
        // Upper Hand asks the same and one thing more: the attack chosen has
        // to go at +1 to +3, as the turn order compared it, an ability's step
        // included (Pokemon Central, Colpo di Mano).
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckSideCondition(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int unkB = BattleScriptReadWord(ctx);
    int flag = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int fieldSide = BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));

    int var;

    switch (unkB) {
    case 0:
    case 1:
        switch (flag) {
        case 0:
            var = ctx->fieldSideConditionData[fieldSide].reflectTurns;
            break;
        case 1:
            var = ctx->fieldSideConditionData[fieldSide].lightScreenTurns;
            break;
        case 2:
            var = ctx->fieldSideConditionData[fieldSide].mistTurns;
            break;
        case 3:
            var = ctx->fieldSideConditionData[fieldSide].safeguardTurns;
            break;
        case 4:
            var = ctx->fieldSideConditionData[fieldSide].spikesLayers;
            break;
        case 5:
            var = ctx->fieldSideConditionData[fieldSide].toxicSpikesLayers;
            break;
        // The two hazards that are only a flag, for a script that names the
        // side by category (Tidy Up clears both sides').
        case SIDE_COND_STEALTH_ROCK:
            var = ctx->fieldSideConditionFlags[fieldSide] & SIDE_CONDITION_STEALTH_ROCKS;
            break;
        case SIDE_COND_STICKY_WEB:
            var = ctx->fieldSideConditionFlags[fieldSide] & SIDE_CONDITION_STICKY_WEB;
            break;
        }
        break;
    case 2:
        switch (flag) {
        case 0:
            ctx->fieldSideConditionData[fieldSide].reflectTurns = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~1;
            break;
        case 1:
            ctx->fieldSideConditionData[fieldSide].lightScreenTurns = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~2;
            break;
        case 2:
            ctx->fieldSideConditionData[fieldSide].mistTurns = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~64;
            break;
        case 3:
            ctx->fieldSideConditionData[fieldSide].safeguardTurns = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~8;
            break;
        case 4:
            ctx->fieldSideConditionData[fieldSide].spikesLayers = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~4;
            break;
        case 5:
            ctx->fieldSideConditionData[fieldSide].toxicSpikesLayers = 0;
            ctx->fieldSideConditionFlags[fieldSide] &= ~(1 << 10);
            break;
        case SIDE_COND_STEALTH_ROCK:
            ctx->fieldSideConditionFlags[fieldSide] &= ~SIDE_CONDITION_STEALTH_ROCKS;
            break;
        case SIDE_COND_STICKY_WEB:
            ctx->fieldSideConditionFlags[fieldSide] &= ~SIDE_CONDITION_STICKY_WEB;
            break;
        }
        break;
    }

    if (unkB == 0 && !var) {
        BattleScriptIncrementPointer(ctx, adrs);
    }
    if (unkB == 1 && var) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryFeint(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!ctx->turnData[ctx->battlerIdTarget].protectFlag) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        // As the reference: a Feint through a team guard lifts it from the
        // other battler it covers too.
        int ally = ctx->battlerIdTarget ^ 2;
        if (ctx->turnData[ctx->battlerIdTarget].gainedProtectFlagFromAlly) {
            ctx->turnData[ctx->battlerIdTarget].gainedProtectFlagFromAlly = FALSE;
            if (IsTeamGuard(ctx->moveNoProtect[ally])) {
                ctx->turnData[ally].protectFlag = FALSE;
            }
        }
        if (IsTeamGuard(ctx->moveNoProtect[ctx->battlerIdTarget]) && ctx->turnData[ally].gainedProtectFlagFromAlly) {
            ctx->turnData[ally].gainedProtectFlagFromAlly = FALSE;
            ctx->turnData[ally].protectFlag = FALSE;
        }
    }

    return FALSE;
}

BOOL BtlCmd_TryPyschoShift(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdTarget].status || ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_SUBSTITUTE || !ctx->battleMons[ctx->battlerIdAttacker].status) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryLastResort(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int cnt = GetBattlerLearnedMoveCount(battleSystem, ctx, ctx->battlerIdAttacker);

    if (ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount < cnt - 1 || cnt < 2) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryToxicSpikes(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker) ^ 1;

    if (ctx->fieldSideConditionData[side].toxicSpikesLayers == 2) {
        ctx->selfTurnData[ctx->battlerIdAttacker].ignorePressure = TRUE;
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->fieldSideConditionFlags[side] |= (1 << 10);
        ctx->fieldSideConditionData[side].toxicSpikesLayers++;
    }

    return FALSE;
}

BOOL BtlCmd_CheckToxicSpikes(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, battlerId);

    if (ctx->fieldSideConditionData[fieldSide].toxicSpikesLayers) {
        ctx->calcTemp = ctx->fieldSideConditionData[fieldSide].toxicSpikesLayers;
        ctx->statChangeType = 6;
        ctx->battlerIdStatChange = battlerId;
        if (GetBattlerVar(ctx, ctx->battlerIdSwitch, BMON_DATA_TYPE_1, NULL) == TYPE_POISON || GetBattlerVar(ctx, ctx->battlerIdSwitch, BMON_DATA_TYPE_2, NULL) == TYPE_POISON) {
            ctx->fieldSideConditionFlags[fieldSide] &= ~(1 << 10);
            ctx->fieldSideConditionData[fieldSide].toxicSpikesLayers = 0;
            ctx->calcTemp = 0;
        }
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckIgnorableAbility(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    BattleScriptIncrementPointer(ctx, 1);

    int flag = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int ability = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (side == 0) {
        int index;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

        for (index = 0; index < maxBattlers; index++) {
            battlerId = ctx->turnOrder[index];
            if (flag == 0) {
                if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ability) == TRUE && ctx->battleMons[battlerId].hp) {
                    BattleScriptIncrementPointer(ctx, adrs);
                    ctx->battlerIdAbility = battlerId;
                    break;
                }
            } else if (!CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ability) || !ctx->battleMons[battlerId].hp) {
                BattleScriptIncrementPointer(ctx, adrs);
                ctx->battlerIdAbility = battlerId;
                break;
            }
        }
    } else {
        battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
        if (flag == 0) {
            if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ability) == TRUE && ctx->battleMons[battlerId].hp) {
                BattleScriptIncrementPointer(ctx, adrs);
                ctx->battlerIdAbility = battlerId;
            }
        } else if (!CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, battlerId, ability) || !ctx->battleMons[battlerId].hp) {
            BattleScriptIncrementPointer(ctx, adrs);
            ctx->battlerIdAbility = battlerId;
        }
    }

    return FALSE;
}

BOOL BtlCmd_IfSameSide(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int sideA = BattleScriptReadWord(ctx);
    int sideB = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerIdA = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideA);
    int battlerIdB = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, sideB);

    if (BattleSystem_GetFieldSide(battleSystem, battlerIdA) == BattleSystem_GetFieldSide(battleSystem, battlerIdB)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}


BOOL BtlCmd_GenerateEndOfBattleItem(BattleSystem *battleSystem, BattleContext *ctx) {
    int rnd, i, j, k;
    u16 species, item;
    u16 ability;
    u8 lvl;
    Pokemon *mon;

    BattleScriptIncrementPointer(ctx, 1);

    // The party has its items back first: Pickup and Honey Gather look for
    // hands empty after the battle, and what they find stays held.
    GiveBackHeldItems(battleSystem, ctx);
    for (i = 0; i < BattleSystem_GetPartySize(battleSystem, 0); i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, 0, i);
        species = GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0);
        item = GetMonData(mon, MON_DATA_HELD_ITEM, 0);
        ability = GetMonData(mon, MON_DATA_ABILITY, 0);
        if (ability == ABILITY_PICKUP
            && species != SPECIES_NONE
            && species != SPECIES_EGG
            && item == ITEM_NONE
            && !(BattleSystem_Random(battleSystem) % 10)) {
            rnd = BattleSystem_Random(battleSystem) % 100;
            lvl = (GetMonData(mon, MON_DATA_LEVEL, 0) - 1) / 10;
            if (lvl >= 10) {
                lvl = 9;
            }
            for (j = 0; j < 9; j++) {
                if (sPickupWeightTable[j] > rnd) {
                    SetMonData(mon, MON_DATA_HELD_ITEM, &sPickupTable1[lvl + j]);
                    break;
                } else if (rnd >= 98 && rnd <= 99) {
                    SetMonData(mon, MON_DATA_HELD_ITEM, &sPickupTable2[lvl + (99 - rnd)]);
                    break;
                }
            }
        }
        if (ability == ABILITY_HONEY_GATHER
            && species != SPECIES_NONE
            && species != SPECIES_EGG
            && item == ITEM_NONE) {
            j = 0;
            k = 10;
            lvl = GetMonData(mon, MON_DATA_LEVEL, 0);
            while (lvl > k) {
                j++;
                k += 10;
            }

            GF_ASSERT(j < 10);

            if ((BattleSystem_Random(battleSystem) % 100) < sHoneyGatherChanceTable[j]) {
                j = ITEM_HONEY;
                SetMonData(mon, MON_DATA_HELD_ITEM, &j);
            }
        }
    }

    return FALSE;
}

BOOL BtlCmd_TrickRoom(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ctx->selfTurnData[ctx->battlerIdAttacker].trickRoomFlag = TRUE;

    return FALSE;
}

BOOL BtlCmd_IfMovedThisTurn(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (ov12_0225561C(ctx, battlerId) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckItemHoldEffect(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int flag = BattleScriptReadWord(ctx);
    int side = BattleScriptReadWord(ctx);
    int itemEffect = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (flag == 0) {
        if (GetBattlerHeldItemEffect(ctx, battlerId) == itemEffect) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else if (GetBattlerHeldItemEffect(ctx, battlerId) != itemEffect) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GetItemHoldEffect(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int *holdEffect = BattleScriptGetVarPointer(battleSystem, ctx, varId);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    u16 item = GetBattlerHeldItem(ctx, battlerId);
    *holdEffect = GetItemVar(ctx, item, ITEM_VAR_HOLD_EFFECT);

    return FALSE;
}

BOOL BtlCmd_GetItemEffectParam(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int varId = BattleScriptReadWord(ctx);
    int *var = BattleScriptGetVarPointer(battleSystem, ctx, varId);
    u16 item = GetBattlerHeldItem(ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));
    *var = GetItemVar(ctx, item, ITEM_VAR_MODIFIER);

    return FALSE;
}

BOOL BtlCmd_TryCamouflage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (BattlerTypeIsItsAbilitys(ctx, ctx->battlerIdAttacker)) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }

    Terrain terrain = BattleSystem_GetTerrainId(battleSystem);
    if (terrain > TERRAIN_OTHERS) {
        terrain = TERRAIN_OTHERS;
    }
    int type = sCamouflageTypeTable[terrain];

    // The user becomes that type and nothing else, an added third type
    // included, as with every move that sets a Pokemon's type.
    if (GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_1, NULL) != type && GetBattlerVar(ctx, ctx->battlerIdAttacker, BMON_DATA_TYPE_2, NULL) != type) {
        ctx->battleMons[ctx->battlerIdAttacker].type1 = type;
        ctx->battleMons[ctx->battlerIdAttacker].type2 = type;
        ctx->battleMons[ctx->battlerIdAttacker].type3 = TYPE_NONE;
        ctx->msgTemp = type;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GetTerrainMove(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int terrain = BattleSystem_GetTerrainId(battleSystem);
    if (terrain > 12) {
        terrain = 12;
    }
    ctx->moveTemp = sNaturePowerMoveTable[terrain];

    return FALSE;
}

BOOL BtlCmd_GetTerrainSecondaryEffect(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int terrain = BattleSystem_GetTerrainId(battleSystem);
    if (terrain > 12) {
        terrain = 12;
    }
    ctx->unk_2174 = sSecretPowerEffectTable[terrain];

    return FALSE;
}

// Retail's command 172, which no script calls since Natural Gift's power
// and type are worked out before the move (TryNaturalGift, 04caf40ee), as
// hg-engine's effect script 222 at d0380a487 has its CalcNaturalGiftParams
// commented out. Kept, as the engine keeps it: the command table goes by
// position, and dropping it would only trade it for a placeholder.
BOOL BtlCmd_CalcNaturalGiftParams(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int power = GetNaturalGiftPower(ctx, ctx->battlerIdAttacker);

    if (power) {
        ctx->movePower = power;
        ctx->moveType = GetNaturalGiftType(ctx, ctx->battlerIdAttacker);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_TryPluck(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs1 = BattleScriptReadWord(ctx);
    int adrs2 = BattleScriptReadWord(ctx);

    // Teatime has each Pokemon eat its own Berry, the one it is asking about
    // standing as the attacker too: nothing -- Sticky Hold, a substitute,
    // Unnerve -- keeps a Pokemon from its own (Pokemon Central, Ora del Te).
    if (ctx->moveNoCur == MOVE_TEATIME) {
        if (TryEatOpponentBerry(battleSystem, ctx, ctx->battlerIdTarget) != TRUE) {
            BattleScriptIncrementPointer(ctx, adrs2);
        }
        return FALSE;
    }

    // Sticky Hold keeps nothing for a holder the move has felled (Pokemon
    // Central, Antifurto, from the fifth generation).
    if (ctx->battleMons[ctx->battlerIdTarget].item && ctx->battleMons[ctx->battlerIdTarget].hp && CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrs1);
    } else if ((ctx->battleMons[ctx->battlerIdTarget].item && ctx->battleMons[ctx->battlerIdTarget].unk88.custapBerryFlag) || BattlerCheckSubstitute(ctx, ctx->battlerIdTarget) == TRUE || TryEatOpponentBerry(battleSystem, ctx, ctx->battlerIdTarget) != TRUE) {
        BattleScriptIncrementPointer(ctx, adrs2);
    }

    return FALSE;
}

BOOL BtlCmd_TryFling(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (TryFling(battleSystem, ctx, ctx->battlerIdAttacker) != TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_YesNoMenu(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitDrawYesNoBox(battleSystem, ctx, 0, 0, BattleScriptReadWord(ctx), 0, 0);

    return FALSE;
}

BOOL BtlCmd_WaitYesNoResult(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 selection = BattleBuffer_GetNext(ctx, 0);

    if (selection) {
        BattleScriptIncrementPointer(ctx, 1);

        int adrsYes = BattleScriptReadWord(ctx);
        int adrsNo = BattleScriptReadWord(ctx);

        if (selection == 255) {
            BattleScriptIncrementPointer(ctx, adrsNo);
        } else {
            BattleScriptIncrementPointer(ctx, adrsYes);
        }

        ov12_0223BDDC(battleSystem, 0, selection);
    }

    ctx->battleContinueFlag = TRUE;

    return FALSE;
}

BOOL BtlCmd_ChoosePokemonMenu(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleSystem_GetMaxBattlers(battleSystem);
    BattleScriptIncrementPointer(ctx, 1);
    BattleController_EmitShowMonList(battleSystem, ctx, 0, 0, 0, 6);
    ctx->battlerIdSwitch = 0;

    return FALSE;
}

BOOL BtlCmd_WaitPokemonMenuResult(BattleSystem *battleSystem, BattleContext *ctx) {
    u8 selection = BattleBuffer_GetNext(ctx, 0);

    if (selection) {
        BattleScriptIncrementPointer(ctx, 1);
        int adrs = BattleScriptReadWord(ctx);

        if (selection == 255) {
            BattleScriptIncrementPointer(ctx, adrs);
        } else {
            ctx->unk_21A0[0] = selection - 1;
        }
    }

    ctx->battleContinueFlag = TRUE;

    return FALSE;
}

BOOL BtlCmd_SetLinkBattleResult(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    if (BattleSystem_GetBattleType(battleSystem) & 4) {
        BattleController_EmitSetBattleResults(battleSystem);
    }

    return FALSE;
}

BOOL BtlCmd_CheckStealthRock(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, battlerId);
    int type1 = GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL);
    int type2 = GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL);

    if (ctx->fieldSideConditionFlags[fieldSide] & 128 && ctx->battleMons[battlerId].hp) {
        switch (CalculateTypeEffectiveness(TYPE_ROCK, type1, type2)) {
        case 160:
            ctx->hpCalc = 2;
            break;
        case 80:
            ctx->hpCalc = 4;
            break;
        case 40:
            ctx->hpCalc = 8;
            break;
        case 20:
            ctx->hpCalc = 16;
            break;
        case 10:
            ctx->hpCalc = 32;
            break;
        case 0:
            BattleScriptIncrementPointer(ctx, adrs);
            return FALSE;
        default:
            GF_ASSERT(FALSE);
            break;
        }
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, ctx->hpCalc);
        // As for the spikes.
        Battler_ArmRetreatOutsideMove(ctx, battlerId);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckEffectActivation(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 effectChance;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    effectChance = MoveEffectChance(battleSystem, ctx);

    GF_ASSERT(effectChance != 0);

#ifdef NEWGOLD_DIAG
    Diag_RollNext(DIAG_ROLL_EFFECT);
#endif
    if ((BattleSystem_Random(battleSystem) % 100) < effectChance && ctx->battleMons[ctx->battlerIdStatChange].hp) {
        return FALSE;
    }

    BattleScriptIncrementPointer(ctx, adrs);

    return FALSE;
}

BOOL BtlCmd_CheckChatterActivation(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 effectChance;

    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    int param;

    if (ctx->battleMons[ctx->battlerIdAttacker].species == SPECIES_CHATOT && ctx->battleMons[ctx->battlerIdTarget].hp && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & (1 << 21))) {
        if ((BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_RECORDING) == FALSE) {
            param = sub_02006EFC(BattleSystem_GetChatotVoice(battleSystem, ctx->battlerIdAttacker));
        } else {
            param = BattleSystem_GetChatotVoiceParam(battleSystem, ctx->battlerIdAttacker);
        }

        switch (param) {
        default:
        case 0:
            effectChance = 0;
            break;
        case 1:
            effectChance = 10;
            break;
        case 2:
            effectChance = 30;
            break;
        }
        if ((BattleSystem_Random(battleSystem) % 100) > effectChance) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GetCurrentMoveData(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    ctx->calcTemp = GetMoveTblAttr(BattleMoveTbl(ctx, ctx->moveNoCur), (MoveAttr)BattleScriptReadWord(ctx));

    return FALSE;
}

BOOL BtlCmd_SetMosaic(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int param = BattleScriptReadWord(ctx);
    int delay = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitPlayMosaicAnimation(battleSystem, battlerId, param, delay);

    return FALSE;
}

BOOL BtlCmd_ChangeForm(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    BattleController_EmitChangeForm(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_SetBattleBackground(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    BattleController_EmitSetBattleBackground(battleSystem, 0);
    return FALSE;
}

BOOL BtlCmd_UseBagItem(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleSystem_RecoverStatus(battleSystem, battlerId, ctx->selectedMonIndex[battlerId], 0, ctx->itemTemp);

    return FALSE;
}

BOOL BtlCmd_TryEscape(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (BattleTryRun(battleSystem, ctx, battlerId)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_ShowBattleStartPartyGauge(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitInitStartBallGauge(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_HideBattleStartPartyGauge(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitDeleteStartBallGauge(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_ShowPartyGauge(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitInitBallGauge(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_HidePartyGauge(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitDeleteBallGauge(battleSystem, battlerId);

    return FALSE;
}

BOOL BtlCmd_LoadPartyGaugeGraphics(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitLoadBallGfx(battleSystem);

    return FALSE;
}

BOOL BtlCmd_FreePartyGaugeGraphics(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitDeleteBallGfx(battleSystem);

    return FALSE;
}

BOOL BtlCmd_IncrementGameStat(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int flag = BattleScriptReadWord(ctx);
    int id = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitIncrementGameStat(battleSystem, battlerId, flag, id);

    return FALSE;
}

BOOL BtlCmd_RestoreSprite(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    BattleController_EmitRestoreSprite(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_TriggerAbilityOnHit(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    if (CheckAbilityEffectOnHit(battleSystem, ctx, &ctx->tempData) == FALSE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_SpriteToOAM(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    OpponentData *opponentData;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    switch (side) {
    case 3:
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                ov12_02264038(battleSystem, battlerId);
            }
        }
        break;
    case 4:
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                ov12_02264038(battleSystem, battlerId);
            }
        }
        break;
    default:
        battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
        ov12_02264038(battleSystem, battlerId);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_OAMToSprite(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    OpponentData *opponentData;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    switch (side) {
    case 3:
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                ov12_02264054(battleSystem, battlerId);
            }
        }
        break;
    case 4:
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            opponentData = BattleSystem_GetOpponentData(battleSystem, battlerId);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                ov12_02264054(battleSystem, battlerId);
            }
        }
        break;
    default:
        battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
        ov12_02264054(battleSystem, battlerId);
        break;
    }

    return FALSE;
}

BOOL BtlCmd_CheckWhiteout(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int adrs;
    int battlerId;
    int partyHp = 0;

    Pokemon *mon;

    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    adrs = BattleScriptReadWord(ctx);

    int battleType = BattleSystem_GetBattleType(battleSystem);
    battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (battleType & BATTLE_TYPE_MULTI || (battleType & BATTLE_TYPE_TAG && BattleSystem_GetFieldSide(battleSystem, battlerId))) {
        Party *party1 = BattleSystem_GetParty(battleSystem, battlerId);
        Party *party2 = BattleSystem_GetParty(battleSystem, BattleSystem_GetBattlerIdPartner(battleSystem, battlerId));

        BattleSystem_GetOpponentData(battleSystem, battlerId);

        for (i = 0; i < Party_GetCount(party1); i++) {
            mon = Party_GetMonByIndex(party1, i);
            if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_NONE
                && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_EGG) {
                partyHp += GetMonData(mon, MON_DATA_HP, 0);
            }
        }

        if ((battleType == 75 || battleType == 74) && BattleSystem_GetFieldSide(battleSystem, battlerId) == 0 && ov12_0223AB0C(battleSystem, battlerId) == 2) {

        } else {
            for (i = 0; i < Party_GetCount(party2); i++) {
                mon = Party_GetMonByIndex(party2, i);
                if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_NONE
                    && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_EGG) {
                    partyHp += GetMonData(mon, MON_DATA_HP, 0);
                }
            }
        }

        if (partyHp == 0) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else {
        Party *party = BattleSystem_GetParty(battleSystem, battlerId);

        BattleSystem_GetOpponentData(battleSystem, battlerId);

        for (i = 0; i < Party_GetCount(party); i++) {
            mon = Party_GetMonByIndex(party, i);
            if (GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_NONE
                && GetMonData(mon, MON_DATA_SPECIES_OR_EGG, 0) != SPECIES_EGG) {
                partyHp += GetMonData(mon, MON_DATA_HP, 0);
            }
        }

        if (partyHp == 0) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    }

    return FALSE;
}

BOOL BtlCmd_BoostRandomStatBy2(BattleSystem *battleSystem, BattleContext *ctx) {
    int i, cnt;
    int statChanges[8];
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    cnt = 0;
    for (i = 1; i < 8; i++) {
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[i] < 12) {
            statChanges[cnt++] = i - 1;
        }
    }

    if (cnt) {
        ctx->unk_2170 = 39 + statChanges[BattleSystem_Random(battleSystem) % cnt];
        ctx->unk_2170 |= (1 << 31);
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Belch's memory of a Berry the Pokemon in battlerId has eaten, kept by its
// party slot for each battler it could come back in. The two battlers a
// single trainer fields share one party, and a Pokemon that leaves one
// position can be sent back to the other, so both are told -- the key the
// once-per-battle entry abilities are remembered by (OnceOnlyEntryAbilityDone,
// the reference's SanitizeClientForTeamAccess); a multi or tag partner has a
// party of its own and is not.
void RememberBerryEaten(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int partner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);

    ctx->berryEaten[battlerId][ctx->selectedMonIndex[battlerId]] = TRUE;
    if (partner != battlerId && BattleSystem_GetParty(battleSystem, partner) == BattleSystem_GetParty(battleSystem, battlerId)) {
        ctx->berryEaten[partner][ctx->selectedMonIndex[battlerId]] = TRUE;
    }
}

BOOL BtlCmd_RemoveItem(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    ctx->recycleItem[battlerId] = ctx->battleMons[battlerId].item;

    // Every Berry a Pokemon eats from its own hand leaves through here -- the
    // held-item scripts all end by calling BATTLE_SUBSCRIPT_PLUCK_CHECK, which
    // is a RemoveItem and nothing else -- so this is where Belch is told of it.
    // The reference has no such choke point and writes the same flag at each
    // of the eight sites that eat one. A Berry plucked off its holder, flung,
    // or spent on Natural Gift leaves through here as well, uneaten by its
    // holder, and does not count for it (Pokemon Central, Rutto): the routines
    // that take it mark it so, and the Pokemon that does eat it -- the one that
    // plucked it, the one it lands on -- is told there (TryEatOpponentBerry,
    // FlungItemLands).
    if (BattleItemIsBerry(ctx->battleMons[battlerId].item) == TRUE
        && !ctx->selfTurnData[battlerId].berryNotEaten) {
        RememberBerryEaten(battleSystem, ctx, battlerId);
    }
    ctx->selfTurnData[battlerId].berryNotEaten = FALSE;

    ctx->battleMons[battlerId].item = 0;
    // An item used up, which is what hands a partner's Symbiosis item over;
    // the entry abilities' check does the handing.
    ctx->symbiosisPending[battlerId] = TRUE;

    CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_TryRecycle(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->recycleItem[ctx->battlerIdAttacker]) {
        ctx->itemTemp = ctx->recycleItem[ctx->battlerIdAttacker];
        ctx->recycleItem[ctx->battlerIdAttacker] = 0;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckItemHoldEffectOnHit(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    if (!CheckItemEffectOnHit(battleSystem, ctx, &ctx->tempData)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_PrintBattleResultMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitPrintResultMessage(battleSystem);

    return FALSE;
}

BOOL BtlCmd_PrintEscapeMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitRunAwayMessage(battleSystem, ctx);

    return FALSE;
}

BOOL BtlCmd_PrintForfeitMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleController_EmitForefitMessage(battleSystem);

    return FALSE;
}

BOOL BtlCmd_CheckHoldOnWith1HP(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL flag = FALSE;

    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    int itemEffect = GetBattlerHeldItemEffect(ctx, battlerId);
    int activationChance = GetHeldItemModifier(ctx, battlerId, 0);

    if (itemEffect == HOLD_EFFECT_MAYBE_ENDURE && (BattleSystem_Random(battleSystem) % 100) < activationChance) {
        flag = TRUE;
    }
    if (itemEffect == HOLD_EFFECT_ENDURE && ctx->battleMons[battlerId].hp == ctx->battleMons[battlerId].maxHp) {
        flag = TRUE;
    }

    if (flag && (ctx->battleMons[battlerId].hp + ctx->hpCalc) <= 0) {
        ctx->hpCalc = (ctx->battleMons[battlerId].hp - 1) * -1;
        ctx->moveStatusFlag |= 256;
    }

    return FALSE;
}

BOOL BtlCmd_TryRestoreStatusOnSwitch(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    if (ctx->battleMons[battlerId].hp && ctx->selectedMonIndex[battlerId] != 6) {
        Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]);
        int ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
        int status = GetMonData(mon, MON_DATA_STATUS, NULL);
        if (ctx->battleMons[battlerId].ability != ABILITY_NATURAL_CURE && !CheckStatusHealSwitch(ctx, ability, status)) {
            BattleScriptIncrementPointer(ctx, adrs);
        }
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckSubstitute(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    // Leech Seed, Gastro Acid, Nightmare, the status subscripts and the rest
    // reach past it for an Infiltrator, and for a sound move. The reference
    // lets through only its direct and move-effect types, and only for
    // Infiltrator; its chance effects and the move's own script are the
    // move's too, and the games let those past as well.
    if (SideEffectIsTheMoves(ctx->statChangeType) && MoveGoesRoundSubstitute(ctx, battlerId)) {
        return FALSE;
    }

    if (ctx->battleMons[battlerId].status2 & (1 << 24) || ctx->selfTurnData[battlerId].unk14 & 8) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_CheckIgnoreWeather(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {

    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_SetRandomTarget(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    ctx->battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_CheckItemHoldEffectOnUTurn(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!CheckItemEffectOnUTurn(battleSystem, ctx, &ctx->tempData)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_RefreshSprite(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitSwapToSubstituteSprite(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_PlayMoveHitSound(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitPlayMoveSE(battleSystem, ctx, battlerId);

    return FALSE;
}

BOOL BtlCmd_PlayBGM(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int song = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleController_EmitPlaySong(battleSystem, battlerId, song);

    return FALSE;
}

BOOL BtlCmd_CheckSafariGameDone(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!(BattleSystem_GetPartySize(battleSystem, 0) != 6 || PCStorage_FindFirstBoxWithEmptySlot(battleSystem->storage) != NUM_BOXES)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_WaitTime(BattleSystem *battleSystem, BattleContext *ctx) {
    int tSpeed;

    BattleScriptIncrementPointer(ctx, 1);

    int wait = BattleScriptReadWord(ctx);

    if ((battleSystem->battleType & BATTLE_TYPE_LINK) && !(battleSystem->battleSpecial & BATTLE_SPECIAL_RECORDING)) {
        tSpeed = 2;
    } else {
        tSpeed = 1;
    }

    if (wait > ctx->unk_F0) {
        BattleScriptIncrementPointer(ctx, -2);
        ctx->unk_F0 += tSpeed;
    } else {
        ctx->unk_F0 = 0;
    }

    ctx->battleContinueFlag = TRUE;

    return FALSE;
}

BOOL BtlCmd_CheckCurMoveIsType(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int type = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (BattleMoveTbl(ctx, ctx->moveNoCur)->type == type) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_LoadArchivedMonData(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int species = BattleScriptReadWord(ctx);
    int form = BattleScriptReadWord(ctx);
    int stat = BattleScriptReadWord(ctx);

    int *formPtr = BattleScriptGetVarPointer(battleSystem, ctx, form);

    ctx->calcTemp = GetMonBaseStat_HandleAlternateForm(species, *formPtr, stat);

    return FALSE;
}

BOOL BtlCmd_RefreshMonData(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    BattleSystem_ReloadMonData(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);

    return FALSE;
}

BOOL BtlCmd_222(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int msgIndex = BattleScriptReadWord(ctx);

    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);

    if (TrainerMessageWithIdPairExists(BattleSystem_GetTrainerIndex(battleSystem, battlerId), msgIndex, HEAP_ID_BATTLE)) {
        ctx->msgTemp = msgIndex;
    } else {
        ctx->msgTemp = 0;
    }

    return FALSE;
}

BOOL BtlCmd_223(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int a2 = BattleScriptReadWord(ctx);

    ov12_022645C8(battleSystem, ctx, a2 & 1);

    return FALSE;
}

BOOL BtlCmd_EndScript(BattleSystem *battleSystem, BattleContext *ctx) {
    ctx->battleContinueFlag = TRUE;

    return ov12_0224EC74(ctx);
}

int BattleScriptReadWord(BattleContext *ctx) {
    int data = ctx->battleScriptBuffer[ctx->scriptSeqNo];

    ctx->scriptSeqNo++;

    return data;
}

static void BattleScriptIncrementPointer(BattleContext *ctx, int adrs) {
    ctx->scriptSeqNo += adrs;
}

static void BattleScriptJump(BattleContext *ctx, NarcId narcId, int adrs) {
    ReadBattleScriptFromNarc(ctx, narcId, adrs);
}

static void BattleScriptGotoSubscript(BattleContext *ctx, NarcId narcId, int adrs) {
    ov12_0224EBDC(ctx, narcId, adrs);
}

static void *BattleScriptGetVarPointer(BattleSystem *battleSystem, BattleContext *ctx, int var) {
    switch (var) {
    case BSCRIPT_VAR_BATTLE_TYPE:
        return &battleSystem->battleType;
    case BSCRIPT_VAR_CRITICAL_BOOSTS:
        return &ctx->criticalCnt;
    case BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT:
        return &ctx->unk_2170;
    case BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT:
        return &ctx->unk_2174;
    case BSCRIPT_VAR_SIDE_EFFECT_FLAGS_ABILITY:
        return &ctx->unk_2178;
    case BSCRIPT_VAR_SIDE_EFFECT_TYPE:
        return &ctx->statChangeType;
    case BSCRIPT_VAR_BATTLE_STATUS:
        return &ctx->battleStatus;
    case BSCRIPT_VAR_FIELD_CONDITION:
        return &ctx->fieldCondition;
    case BSCRIPT_VAR_POWER_MULTI:
        return &ctx->unk_2158;
    case BSCRIPT_VAR_CALC_TEMP:
        return &ctx->calcTemp;
    case BSCRIPT_VAR_MOVE_STATUS_FLAGS:
        return &ctx->moveStatusFlag;
    case BSCRIPT_VAR_SIDE_CONDITION_ATTACKER:
        return &ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker)];
    case BSCRIPT_VAR_SIDE_CONDITION_TARGET:
        return &ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget)];
    case BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE:
        return &ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdStatChange)];
    case BSCRIPT_VAR_DAMAGE:
        return &ctx->damage;
    case BSCRIPT_VAR_BATTLER_ATTACKER:
        return &ctx->battlerIdAttacker;
    case BSCRIPT_VAR_BATTLER_TARGET:
        return &ctx->battlerIdTarget;
    case BSCRIPT_VAR_BATTLER_STAT_CHANGE:
        return &ctx->battlerIdStatChange;
    case BSCRIPT_VAR_BATTLER_FAINTED:
        return &ctx->battlerIdFainted;
    case BSCRIPT_VAR_BATTLER_SWITCH:
        return &ctx->battlerIdSwitch;
    case BSCRIPT_VAR_MSG_BATTLER_TEMP:
        return &ctx->battlerIdTemp;
    case BSCRIPT_VAR_ATTACKER_STORED_DAMAGE:
        return &ctx->unk_30E4[ctx->battlerIdAttacker];
    case BSCRIPT_VAR_MESSAGE:
        return &ctx->msgTemp;
    case BSCRIPT_VAR_PAY_DAY_COUNT:
        return &ctx->unk_14C;
    case BSCRIPT_VAR_MOVE_NO_CUR:
        return &ctx->moveNoCur;
    case BSCRIPT_VAR_TOTAL_TURNS:
        return &ctx->totalTurns;
    case BSCRIPT_VAR_MSG_ATTACKER:
        return &ctx->battlerIdLeechSeedRecv;
    case BSCRIPT_VAR_MSG_DEFENDER:
        return &ctx->battlerIdLeechSeeded;
    case BSCRIPT_VAR_MOVE_NO_TEMP:
        return &ctx->moveNoTemp;
    case BSCRIPT_VAR_LAST_BATTLER_ID:
        return &ctx->unk_98;
    case BSCRIPT_VAR_MOVE_POWER:
        return &ctx->movePower;
    case BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE:
        return &ctx->unk_38;
    case BSCRIPT_VAR_HP_CALC:
        return &ctx->hpCalc;
    case BSCRIPT_VAR_BATTLE_OUTCOME:
        return &battleSystem->battleOutcomeFlag;
    case BSCRIPT_VAR_SIDE_EFFECT_PARAM:
        return &ctx->statChangeParam;
    case BSCRIPT_VAR_MSG_MOVE_TEMP:
        return &ctx->moveTemp;
    case BSCRIPT_VAR_MSG_ITEM_TEMP:
        return &ctx->itemTemp;
    case BSCRIPT_VAR_MSG_ABILITY_TEMP:
        return &ctx->abilityTemp;
    case BSCRIPT_VAR_WEATHER_TURNS:
        return &ctx->fieldConditionData.weatherTurns;
    case BSCRIPT_VAR_BATTLER_SPEED_TEMP:
        return &ctx->unk_3104;
    case BSCRIPT_VAR_MULTI_HIT_LOOP:
        return &ctx->unk_2180;
    case BSCRIPT_VAR_PHYSICAL_DAMAGE:
        return &ctx->turnData[ctx->battlerIdAttacker].battlerBitPhysicalDamage;
    case BSCRIPT_VAR_SPECIAL_DAMAGE:
        return &ctx->turnData[ctx->battlerIdAttacker].battlerBitSpecialDamage;
    case BSCRIPT_VAR_TEMP_DATA:
        return &ctx->tempData;
    case BSCRIPT_VAR_CRIT_MULTIPLIER:
        return &ctx->criticalMultiplier;
    case BSCRIPT_VAR_ATTACKER_LAST_DAMAGE_TAKEN:
        return &ctx->turnData[ctx->battlerIdAttacker].unk34;
    case BSCRIPT_VAR_DEFENDER_LAST_DAMAGE_TAKEN:
        return &ctx->turnData[ctx->battlerIdTarget].unk34;
    case BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS:
        return &ctx->selfTurnData[ctx->battlerIdAttacker].unk14;
    case BSCRIPT_VAR_DEFENDER_SELF_TURN_STATUS_FLAGS:
        return &ctx->selfTurnData[ctx->battlerIdTarget].unk14;
    case BSCRIPT_VAR_SIDE_EFFECT_MON_SELF_TURN_STATUS_FLAGS:
        return &ctx->selfTurnData[ctx->battlerIdStatChange].unk14;
    case BSCRIPT_VAR_FLING_DATA:
        return &ctx->flingData;
    case BSCRIPT_VAR_FLING_SCRIPT:
        return &ctx->flingScript;
    case BSCRIPT_VAR_BATTLE_SYS_STATUS:
        return &battleSystem->battleSpecial;
    case BSCRIPT_VAR_ATTACKER_LOCKED_MOVE:
        return &ctx->moveNoLockedInto[ctx->battlerIdAttacker];
    case BSCRIPT_VAR_HIT_DAMAGE:
        return &ctx->hitDamage;
    case BSCRIPT_VAR_SAFARI_BALL_CNT:
        return &battleSystem->safariBallCnt;
    case BSCRIPT_VAR_SWITCHED_MON_TEMP:
        return &ctx->battlerIdSwitchTemp;
    case BSCRIPT_VAR_MOVE_TYPE:
        return &ctx->moveType;
    case BSCRIPT_VAR_MOVE_EFFECT_CHANCE:
        return &ctx->unk_2164;
    case BSCRIPT_VAR_REGULATION_FLAG:
        return &battleSystem->unk241C;
    case BSCRIPT_VAR_BATTLE_STATUS_2:
        return &ctx->battleStatus2;
    case BSCRIPT_VAR_TURN_ORDER_COUNTER:
        return &ctx->executionIndex;
    case BSCRIPT_VAR_MAX_BATTLERS:
        return &battleSystem->maxBattlers;
    case BSCRIPT_VAR_BATTLER_ATTACKER_TEMP:
        return &ctx->battlerIdAttackerTemp;
    case BSCRIPT_VAR_BATTLER_TARGET_TEMP:
        return &ctx->battlerIdTargetTemp;
    case BSCRIPT_VAR_PHYSICAL_DAMAGE_TAKEN:
        return &ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage;
    case BSCRIPT_VAR_MSG_BATTLER_TEMP_ASSURANCE_DAMAGE_MASK:
        return &ctx->turnData[ctx->battlerIdTemp].unk3C;
    case BSCRIPT_VAR_DEFENDER_ASSURANCE_DAMAGE_MASK:
        return &ctx->turnData[ctx->battlerIdTarget].unk3C;
    case BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT:
        return &ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage;
    case BSCRIPT_VAR_WAITING_BATTLERS:
        return &ctx->battlersOnField;
    case BSCRIPT_VAR_70:
        return &battleSystem->unk2478;
    }

    return NULL;
}

enum {
    STATE_GET_EXP_START = 0,
    STATE_GET_EXP_WAIT_MESSAGE_PRINT,
    STATE_GET_EXP_WAIT_MESSAGE_DELAY,
    STATE_GET_EXP_GAUGE,
    STATE_GET_EXP_WAIT_GAUGE,
    STATE_GET_EXP_CHECK_LEVEL_UP,
    STATE_GET_EXP_WAIT_LEVEL_UP_EFFECT,
    STATE_GET_EXP_WAIT_LEVEL_UP_MESSAGE_PRINT,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_LOAD_ICON,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_INIT,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF_WAIT,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_TRUE,
    STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_TRUE_WAIT,
    STATE_GET_EXP_LEVEL_UP_CLEAR,
    STATE_GET_EXP_CHECK_LEARN_MOVE,
    STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT,
    STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT_WAIT,
    STATE_GET_EXP_CANT_LEARN_MORE_MOVES_PRINT,
    STATE_GET_EXP_CANT_LEARN_MORE_MOVES_PRINT_WAIT,
    STATE_GET_EXP_MAKE_IT_FORGET_PROMPT,
    STATE_GET_EXP_MAKE_IT_FORGET_ANSWER,
    STATE_GET_EXP_MAKE_IT_FORGET_WAIT,
    STATE_GET_EXP_MAKE_IT_FORGET_INPUT_TAKEN,
    STATE_GET_EXP_ONE_TWO_POOF,
    STATE_GET_EXP_ONE_TWO_POOF_WAIT,
    STATE_GET_EXP_FORGOT_HOW_TO_USE,
    STATE_GET_EXP_FORGOT_HOW_TO_USE_WAIT,
    STATE_GET_EXP_AND_DOTDOTDOT,
    STATE_GET_EXP_AND_DOTDOTDOT_WAIT,
    STATE_GET_EXP_LEARNED_MOVE,
    STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED,
    STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED_WAIT,
    STATE_GET_EXP_GIVE_UP_LEARNING_PROMPT,
    STATE_GET_EXP_GIVE_UP_LEARNING_ANSWER,
    STATE_GET_EXP_GIVE_UP_LEARNING_WAIT,
    STATE_GET_EXP_LEARNED_MOVE_WAIT,
    STATE_GET_EXP_CHECK_DONE,
    STATE_GET_EXP_DONE,
};

static void Task_GetExp(SysTask *task, void *inData) {
    int i;
    int slot;
    GetterWork *data = inData;
    Pokemon *mon;
    BattleMessage msg;
    int side;
    int expBattler;
    MsgData *msgLoader;
    u32 battleType;
    u16 item;
    int itemEffect;

    msgLoader = BattleSystem_GetMessageLoader(data->battleSystem);
    battleType = BattleSystem_GetBattleType(data->battleSystem);
    side = (data->ctx->battlerIdFainted >> 1) & 1; // Get side of fainted mon (left or right)
    expBattler = 0;

    // Figure out which mon we're working on
    for (slot = data->tempData[DATA_GET_EXP_PARTY_SLOT]; slot < BattleSystem_GetPartySize(data->battleSystem, expBattler); slot++) {
        mon = BattleSystem_GetPartyMon(data->battleSystem, expBattler, slot);
        item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
        itemEffect = GetItemAttr(item, ITEM_VAR_HOLD_EFFECT, HEAP_ID_BATTLE);

        if (itemEffect == HOLD_EFFECT_EXP_SHARE || (data->ctx->unk_A4[side] & MaskOfFlagNo(slot))) {
            break;
        }
    }

    if (slot == BattleSystem_GetPartySize(data->battleSystem, expBattler)) {
        data->state = STATE_GET_EXP_DONE;
    } else if ((battleType & BATTLE_TYPE_DOUBLES)
        && !(battleType & BATTLE_TYPE_AI)
        && data->ctx->selectedMonIndex[BATTLER_PLAYER2] == slot) {
        expBattler = 2;
    }

    switch (data->state) {
    case STATE_GET_EXP_START:
        item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
        itemEffect = GetItemAttr(item, ITEM_VAR_HOLD_EFFECT, HEAP_ID_BATTLE);

        // Declare victory if all wild mons have been defeated
        if (!(battleType & BATTLE_TYPE_TRAINER)
            && data->ctx->battleMons[BATTLER_ENEMY].hp
                    + data->ctx->battleMons[BATTLER_ENEMY2].hp
                == 0
            && GetMonData(mon, MON_DATA_HP, NULL)
            && !data->ctx->unk_3144) {
            PlayBGM(SEQ_GS_WIN2);
            data->ctx->unk_3144 = TRUE;
            BattleSystem_SetCriticalHpMusicFlag(data->battleSystem, CRITICAL_MUSIC_OFF);
        }

        u32 totalExp = 0;
        u8 cap = GetLevelCap();
        // "{0} gained {1} Exp. Points!"
        msg.id = msg_0197_00001;

        // At the cap there is no experience to gain, so the bar does not
        // move; the effort values still come, as the reference hands them to
        // a Pokemon exactly at the cap in a step of its own. That step asks
        // nothing else: a fainted participant or Exp. Share holder gets them,
        // and so does level 100 once the cap is 100.
        if (GetMonData(mon, MON_DATA_LEVEL, NULL) == cap) {
            BattleScript_CalcEffortValues(BattleSystem_GetParty(data->battleSystem, expBattler),
                slot,
                data->ctx->battleMons[data->ctx->battlerIdFainted].species,
                data->ctx->battleMons[data->ctx->battlerIdFainted].form);
        } else if (GetMonData(mon, MON_DATA_HP, NULL) && GetMonData(mon, MON_DATA_LEVEL, NULL) != 100 && GetMonData(mon, MON_DATA_LEVEL, NULL) < cap) {
            u32 faintedLevel = data->ctx->battleMons[data->ctx->battlerIdFainted].level;
            totalExp = GetMonBaseStat(data->ctx->battleMons[data->ctx->battlerIdFainted].species, BASE_EXP_YIELD) * faintedLevel / 5;
            totalExp = BattleScript_GainerExp(totalExp,
                faintedLevel,
                GetMonData(mon, MON_DATA_LEVEL, NULL),
                data->ctx->expMonsCnt,
                data->ctx->expShareMonsCnt,
                (data->ctx->unk_A4[side] & MaskOfFlagNo(slot)) != 0,
                itemEffect == HOLD_EFFECT_EXP_SHARE);

            if (itemEffect == HOLD_EFFECT_EXP_UP) {
                totalExp = totalExp * 150 / 100;
            }

            if (battleType & BATTLE_TYPE_TRAINER) {
                totalExp = totalExp * 150 / 100;
            }

            if (!ov12_022568B0(data->battleSystem, mon)) {
                if (GetMonData(mon, MON_DATA_LANGUAGE, NULL) != gGameLanguage) {
                    totalExp = totalExp * 170 / 100;
                } else {
                    totalExp = totalExp * 150 / 100;
                }
                // "{0} gained a boosted {1} Exp. Points!"
                msg.id = msg_0197_00002;
            }

            u32 newExp = GetMonData(mon, MON_DATA_EXPERIENCE, NULL);
            data->tempData[DATA_GET_EXP_PREV_PROGRESS_TO_NEXT_LEVEL] = newExp - GetMonBaseExperienceAtCurrentLevel(mon);
            newExp += totalExp;

            if (slot == data->ctx->selectedMonIndex[expBattler]) {
                data->ctx->battleMons[expBattler].exp = newExp;
            }

            SetMonData(mon, MON_DATA_EXPERIENCE, &newExp);

            BattleScript_CalcEffortValues(BattleSystem_GetParty(data->battleSystem, expBattler),
                slot,
                data->ctx->battleMons[data->ctx->battlerIdFainted].species,
                data->ctx->battleMons[data->ctx->battlerIdFainted].form);
        }

        if (totalExp) {
            msg.tag = TAG_NICKNAME_NUM;
            msg.param[0] = expBattler | (slot << 8);
            msg.param[1] = totalExp;
            data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_EXP_FRAME_COUNTER] = 7;
            data->state++;
        } else {
            data->state = STATE_GET_EXP_CHECK_DONE;
        }

        break;

    case STATE_GET_EXP_WAIT_MESSAGE_PRINT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID])) {
            data->state++;
        }
        break;

    case STATE_GET_EXP_WAIT_MESSAGE_DELAY:
        if (--data->tempData[DATA_GET_EXP_FRAME_COUNTER] == 0) {
            data->state++;
        }
        break;

    case STATE_GET_EXP_GAUGE:
        // Only animate the gauge for an active battler.
        if (slot == data->ctx->selectedMonIndex[expBattler]) {
            ov12_02263564(data->battleSystem, data->ctx, expBattler, data->tempData[DATA_GET_EXP_PREV_PROGRESS_TO_NEXT_LEVEL]);
            data->tempData[DATA_GET_EXP_PREV_PROGRESS_TO_NEXT_LEVEL] = 0;
            data->state++;
        } else {
            data->state = STATE_GET_EXP_CHECK_LEVEL_UP;
        }
        break;

    case STATE_GET_EXP_WAIT_GAUGE:
        if (Link_QueueNotEmpty(data->ctx)) {
            data->state++;
        }
        break;

    case STATE_GET_EXP_CHECK_LEVEL_UP:
        if (Pokemon_TryLevelUp(mon)) {
            // Only play the special level-up animation for an active battler.
            if (data->ctx->selectedMonIndex[expBattler] == slot) {
                BattleController_EmitSetStatus2Effect(data->battleSystem, data->ctx, expBattler, 8);
                ov12_0226399C(data->battleSystem, expBattler);
            }

            data->state = STATE_GET_EXP_WAIT_LEVEL_UP_EFFECT;
        } else {
            data->state = STATE_GET_EXP_CHECK_DONE;
        }
        break;

    case STATE_GET_EXP_WAIT_LEVEL_UP_EFFECT:
        if (Link_QueueNotEmpty(data->ctx)) {
            TempStatsStruct stats = ov12_0226C354;
            int level = GetMonData(mon, MON_DATA_LEVEL, NULL);
            // Cache the stats from the previous level for later.
            data->ctx->prevLevelStats = Heap_Alloc(HEAP_ID_BATTLE, sizeof(PokemonStats));
            PokemonStats *oldStats = data->ctx->prevLevelStats;
            for (i = 0; i < NUM_STATS; i++) {
                oldStats->stats[i] = GetMonData(mon, stats.stats[i], NULL);
            }

            MonApplyFriendshipMod(mon, MON_MOOD_MODIFIER_LEVEL_UP_IN_BATTLE, BattleSystem_GetLocation(data->battleSystem));
            ApplyMonMoodModifier(mon, 0);
            CalcMonStats(mon);

            if (data->ctx->selectedMonIndex[expBattler] == slot) {
                BattleSystem_ReloadMonData(data->battleSystem, data->ctx, expBattler, data->ctx->selectedMonIndex[expBattler]);
            }

            data->ctx->levelUpMons |= MaskOfFlagNo(slot);
            ov12_02263A1C(data->battleSystem, data->ctx, expBattler);
            // "{0} grew to Lv. {1}!"
            msg.id = msg_0197_00003;
            msg.tag = TAG_NICKNAME_NUM;
            msg.param[0] = expBattler | (slot << 8);
            msg.param[1] = level;
            data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->state = STATE_GET_EXP_WAIT_LEVEL_UP_MESSAGE_PRINT;
        }
        break;

    case STATE_GET_EXP_WAIT_LEVEL_UP_MESSAGE_PRINT:
        if (TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID]) == 0) {
            data->state = STATE_GET_EXP_LEVEL_UP_SUMMARY_LOAD_ICON;
            data->tempData[DATA_GET_EXP_LEARNSET_INDEX] = 0;
        }
        break;

    case STATE_GET_EXP_LEVEL_UP_SUMMARY_LOAD_ICON:
        // Load the Pokemon's defining information on to a nameplate above the level up summary if they are not the active battler.
        if (data->ctx->selectedMonIndex[expBattler] != slot) {
            BattleSystem_LoadLevelUpNameplate(data->battleSystem, data, mon);
        }
        data->state = STATE_GET_EXP_LEVEL_UP_SUMMARY_INIT;
        break;

    case STATE_GET_EXP_LEVEL_UP_SUMMARY_INIT: {
        BgConfig *bgConfig = BattleSystem_GetBgConfig(data->battleSystem);
        Window *window = BattleSystem_GetWindow(data->battleSystem, 1);
        PaletteData *palette = BattleSystem_GetPaletteData(data->battleSystem);

        G2_SetBG0Priority(2);
        SetBgPriority(GF_BG_LYR_MAIN_1, 1);
        SetBgPriority(GF_BG_LYR_MAIN_2, 0);

        ov12_0223C224(data->battleSystem, 1);

        sub_0200E398(bgConfig, 2, 1, 0, HEAP_ID_BATTLE);
        PaletteData_LoadNarc(palette, NARC_a_0_3_8, sub_0200E3D8(), HEAP_ID_BATTLE, PLTTBUF_MAIN_BG, 0x20, 8 * 0x10);
        AddWindowParameterized(bgConfig, window, GF_BG_LYR_MAIN_2, 0x11, 0x7, 14, 12, 11, 9 + 1);
        FillWindowPixelBuffer(window, 0xFF);
        DrawFrameAndWindow1(window, FALSE, 1, 8);

        data->state = STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF;
        break;
    }
    case STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF: {
        TempStatsStruct stats = ov12_0226C36C;
        TempStatsStruct monData = ov12_0226C384;

        Window *window = BattleSystem_GetWindow(data->battleSystem, 1);
        PokemonStats *oldStats = data->ctx->prevLevelStats;

        for (i = 0; i < NUM_STATS; i++) {
            // Stat name.
            msg.id = msg_0197_00947;
            msg.tag = TAG_STAT;
            msg.param[0] = stats.stats[i];

            ov12_0223C4E8(data->battleSystem, window, msgLoader, &msg, 0, 16 * i, 0, 0, 0);
            // "+{0}"
            msg.id = msg_0197_00948;
            msg.tag = TAG_NUMBERS;
            msg.param[0] = GetMonData(mon, monData.stats[i], NULL) - oldStats->stats[i];
            msg.numDigits = 2;

            ov12_0223C4E8(data->battleSystem, window, msgLoader, &msg, 80, 16 * i, 0, 0, 0);
        }

        data->state = STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF_WAIT;
        break;
    }
    case STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_TRUE: {
        TempStatsStruct monData = ov12_0226C33C;
        Window *window = BattleSystem_GetWindow(data->battleSystem, 1);

        FillWindowPixelRect(window, 0xF, 80, 0, 36, 96); // clear out the diff section (keep the printed stat names)

        for (i = 0; i < NUM_STATS; i++) {
            // Just a number.
            msg.id = msg_0197_00949;
            msg.tag = TAG_NUMBERS;
            msg.param[0] = GetMonData(mon, monData.stats[i], NULL);
            msg.numDigits = 3;

            ov12_0223C4E8(data->battleSystem, window, msgLoader, &msg, 72, 16 * i, 0x2, 36, 0);
        }

        data->state = STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_TRUE_WAIT;
        break;
    }
    case STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_DIFF_WAIT:
    case STATE_GET_EXP_LEVEL_UP_SUMMARY_PRINT_TRUE_WAIT:
        if ((gSystem.newKeys & (PAD_BUTTON_A | PAD_BUTTON_B | PAD_BUTTON_X | PAD_BUTTON_Y)) || System_GetTouchNew()) {
            PlaySE(SEQ_SE_DP_SELECT);
            data->state++;
        }
        break;

    case STATE_GET_EXP_LEVEL_UP_CLEAR: {
        Window *window = BattleSystem_GetWindow(data->battleSystem, 1);

        sub_0200E5D4(window, 0);
        RemoveWindow(window);

        G2_SetBG0Priority(1);
        SetBgPriority(GF_BG_LYR_MAIN_1, 0);
        SetBgPriority(GF_BG_LYR_MAIN_2, 1);

        ov12_0223C224(data->battleSystem, 0);

        if (data->ctx->selectedMonIndex[expBattler] != slot) {
            BattleSystem_UnloadLevelUpNameplate(data->battleSystem, data);
        }

        Heap_Free(data->ctx->prevLevelStats);
        data->state = STATE_GET_EXP_CHECK_LEARN_MOVE;
        break;
    }

    case STATE_GET_EXP_CHECK_LEARN_MOVE: {
        u16 move;
        BgConfig *bgConfig = BattleSystem_GetBgConfig(data->battleSystem); // Unused, but must be kept to match.

        switch (MonTryLearnMoveOnLevelUp(mon, &data->tempData[DATA_GET_EXP_LEARNSET_INDEX], &move)) {
        case 0:
            data->state = STATE_GET_EXP_GAUGE;
            break;
        case 0xFFFE:
            break;
        case 0xFFFF:
            data->tempData[DATA_GET_EXP_MOVE_TO_LEARN] = move;
            data->state = STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT;
            break;
        default:
            if (data->ctx->selectedMonIndex[expBattler] == slot) {
                BattleSystem_ReloadMonData(data->battleSystem, data->ctx, expBattler, data->ctx->selectedMonIndex[expBattler]);
            }
            // "{0} learned {1}!"
            msg.id = msg_0197_00004;
            msg.tag = TAG_NICKNAME_MOVE;
            msg.param[0] = expBattler | (slot << 8);
            msg.param[1] = move;
            data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->state = STATE_GET_EXP_LEARNED_MOVE_WAIT;
            break;
        }
        break;
    }

    case STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT:
        // "{0} wants to learn the move {1}."
        msg.id = msg_0197_01178;
        msg.tag = TAG_NICKNAME_MOVE;
        msg.param[0] = expBattler | (slot << 8);
        msg.param[1] = data->tempData[DATA_GET_EXP_MOVE_TO_LEARN];
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_CANT_LEARN_MORE_MOVES_PRINT:
        // "But {0} can't learn more than four moves."
        msg.id = msg_0197_01179;
        msg.tag = TAG_NICKNAME;
        msg.param[0] = expBattler | (slot << 8);
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT_WAIT:
    case STATE_GET_EXP_CANT_LEARN_MORE_MOVES_PRINT_WAIT:
    case STATE_GET_EXP_ONE_TWO_POOF_WAIT:
    case STATE_GET_EXP_FORGOT_HOW_TO_USE_WAIT:
    case STATE_GET_EXP_AND_DOTDOTDOT_WAIT:
    case STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED_WAIT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID])) {
            data->state++;
        }
        break;

    case STATE_GET_EXP_MAKE_IT_FORGET_PROMPT:
        // "Make it forget another move?"
        BattleController_EmitDrawYesNoBox(data->battleSystem, data->ctx, expBattler, msg_0197_01180, 1, 0, 0);
        data->state++;
        break;

    case STATE_GET_EXP_MAKE_IT_FORGET_ANSWER:
        if (BattleBuffer_GetNext(data->ctx, expBattler)) {
            if (BattleBuffer_GetNext(data->ctx, expBattler) == 0xFF) { // TODO: could use a const
                data->state = STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED;
            } else {
                // "Which move should be forgotten?"
                msg.id = msg_0197_01183;
                msg.tag = TAG_NONE;
                data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
                data->state = STATE_GET_EXP_MAKE_IT_FORGET_WAIT;
            }
        }
        break;

    case STATE_GET_EXP_MAKE_IT_FORGET_WAIT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID])) {
            ov12_02263D14(data->battleSystem, expBattler, data->tempData[DATA_GET_EXP_MOVE_TO_LEARN], slot);
            data->state++;
        }
        break;

    case STATE_GET_EXP_MAKE_IT_FORGET_INPUT_TAKEN:
        if (BattleBuffer_GetNext(data->ctx, expBattler) == 0xFF) {
            data->state = STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED;
        } else if (BattleBuffer_GetNext(data->ctx, expBattler)) {
            data->tempData[DATA_GET_EXP_MOVE_SLOT_TO_FORGET] = data->ctx->battleBuffer[expBattler][0] - 1;
            data->state = STATE_GET_EXP_ONE_TWO_POOF;
        }
        break;

    case STATE_GET_EXP_MAKE_IT_FORGET_CANCELLED:
        // "Well, then..."
        msg.id = msg_0197_01184;
        msg.tag = TAG_NONE;
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_GIVE_UP_LEARNING_PROMPT:
        // "Should this Pokémon give up on learning this new move?"
        BattleController_EmitDrawYesNoBox(data->battleSystem, data->ctx, expBattler, msg_0197_01185, 2, data->tempData[DATA_GET_EXP_MOVE_TO_LEARN], 0);
        data->state++;
        break;

    case STATE_GET_EXP_GIVE_UP_LEARNING_ANSWER:
        if (BattleBuffer_GetNext(data->ctx, expBattler)) {
            if (BattleBuffer_GetNext(data->ctx, expBattler) == 0xFF) {
                data->state = STATE_GET_EXP_WANTS_TO_LEARN_MOVE_PRINT;
            } else {
                // "{0} did not learn {1}."
                msg.id = msg_0197_01188;
                msg.tag = TAG_NICKNAME_MOVE;
                msg.param[0] = expBattler | (slot << 8);
                msg.param[1] = data->tempData[DATA_GET_EXP_MOVE_TO_LEARN];
                data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
                data->state = 35;
            }
        }
        break;

    case STATE_GET_EXP_GIVE_UP_LEARNING_WAIT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID])) {
            // Check for another move to learn
            data->state = STATE_GET_EXP_CHECK_LEARN_MOVE;
        }
        break;

    case STATE_GET_EXP_ONE_TWO_POOF:
        // "1, 2, and... ... Poof!"
        msg.id = msg_0197_01189;
        msg.tag = 0;
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_FORGOT_HOW_TO_USE:
        // "{0} forgot how to use {1}."
        msg.id = msg_0197_01190;
        msg.tag = TAG_NICKNAME_MOVE;
        msg.param[0] = expBattler | (slot << 8);
        msg.param[1] = GetMonData(mon, MON_DATA_MOVE1 + data->tempData[DATA_GET_EXP_MOVE_SLOT_TO_FORGET], NULL);
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_AND_DOTDOTDOT:
        // "And..."
        msg.id = msg_0197_01191;
        msg.tag = TAG_NONE;
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
        data->state++;
        break;

    case STATE_GET_EXP_LEARNED_MOVE:
        // "{0} learned {1}!"
        msg.id = msg_0197_01192;
        msg.tag = TAG_NICKNAME_MOVE;
        msg.param[0] = expBattler | (slot << 8);
        msg.param[1] = data->tempData[DATA_GET_EXP_MOVE_TO_LEARN];
        data->tempData[DATA_GET_EXP_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgLoader, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));

        i = 0;
        SetMonData(mon, MON_DATA_MOVE1_PP_UPS + data->tempData[DATA_GET_EXP_MOVE_SLOT_TO_FORGET], &i);
        MonSetMoveInSlot(mon, data->tempData[DATA_GET_EXP_MOVE_TO_LEARN], data->tempData[DATA_GET_EXP_MOVE_SLOT_TO_FORGET]);

        if (data->ctx->selectedMonIndex[expBattler] == slot) {
            BattleSystem_ReloadMonData(data->battleSystem, data->ctx, expBattler, data->ctx->selectedMonIndex[expBattler]);
        }

        data->state = STATE_GET_EXP_LEARNED_MOVE_WAIT;
        break;

    case STATE_GET_EXP_LEARNED_MOVE_WAIT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_EXP_PRINTER_ID])) {
            // Check for another move to learn
            data->state = STATE_GET_EXP_CHECK_LEARN_MOVE;
        }
        break;

    case STATE_GET_EXP_CHECK_DONE:
        data->ctx->unk_A4[side] &= (MaskOfFlagNo(slot) ^ 0xFFFFFFFF); // this mon is done
        data->tempData[DATA_GET_EXP_PARTY_SLOT] = slot + 1;
        data->state = STATE_GET_EXP_START; // go back to the top and get the next mon
        break;

    case STATE_GET_EXP_DONE:
        data->ctx->getterWork = data->caller;
        Heap_Free(inData);
        SysTask_Destroy(task);
        break;
    }
}

static void BattleScript_CalcEffortValues(Party *party, int partySlot, u32 species, u32 form) {
    u8 stat_evs[6];
    s32 stat;
    u16 totalEVs;

    s16 gainedEVs = 0;
    struct BaseStats *baseStats = AllocAndLoadMonPersonal_HandleAlternateForm(species, form, HEAP_ID_BATTLE);
    Pokemon *mon = Party_GetMonByIndex(party, partySlot);
    u16 item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
    s32 holdEffect = GetItemAttr(item, ITEMATTR_HOLD_EFFECT, HEAP_ID_BATTLE);
    s32 holdEffectParam = GetItemAttr(item, ITEMATTR_HOLD_EFFECT_PARAM, HEAP_ID_BATTLE);

    totalEVs = 0;
    // Store any pre-existing EVs to use for comparison later.
    for (stat = STAT_HP; stat < STAT_ACC; stat++) {
        stat_evs[stat] = GetMonData(mon, stat + MON_DATA_HP_EV, NULL);
        totalEVs += stat_evs[stat];
    }

    for (stat = STAT_HP; stat < STAT_ACC; stat++) {
        // Don't bother running this loop if no more EVs can be gained.
        if (totalEVs >= MAX_EV_SUM) {
            break;
        }
        switch (stat) {
        case STAT_HP:
            gainedEVs = GetPersonalAttr(baseStats, BASE_HP_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_HP_EV_UP) { // Power Weight
                gainedEVs += holdEffectParam;
            }
            break;
        case STAT_ATK:
            gainedEVs = GetPersonalAttr(baseStats, BASE_ATK_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_ATK_EV_UP) { // Power Bracer
                gainedEVs += holdEffectParam;
            }
            break;
        case STAT_DEF:
            gainedEVs = GetPersonalAttr(baseStats, BASE_DEF_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_DEF_EV_UP) { // Power Belt
                gainedEVs += holdEffectParam;
            }
            break;
        case STAT_SPEED:
            gainedEVs = GetPersonalAttr(baseStats, BASE_SPEED_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_SPEED_EV_UP) { // Power Anklet
                gainedEVs += holdEffectParam;
            }
            break;
        case STAT_SPATK:
            gainedEVs = GetPersonalAttr(baseStats, BASE_SPATK_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_SPATK_EV_UP) { // Power Lens
                gainedEVs += holdEffectParam;
            }
            break;
        case STAT_SPDEF:
            gainedEVs = GetPersonalAttr(baseStats, BASE_SPDEF_YIELD);
            if (holdEffect == HOLD_EFFECT_LVLUP_SPDEF_EV_UP) { // Power Band
                gainedEVs += holdEffectParam;
            }
            break;
        }

        // Pokerus
        if (Party_MaskMonsWithPokerus(party, MaskOfFlagNo(partySlot))) {
            gainedEVs *= 2;
        }

        // Macho Brace
        if (holdEffect == HOLD_EFFECT_EVS_UP_SPEED_DOWN) {
            gainedEVs *= 2;
        }

        // If EVs added would cause the total of all EVs to exceed 510, reduce the gain to have the total at 510.
        // This has a very minor side effect of prioritizing EVs of a higher stat ID when reaching maximum total EVs, and discarding the remainder.
        s32 projectedTotalEVs = totalEVs + gainedEVs;
        if (projectedTotalEVs > MAX_EV_SUM) {
            gainedEVs -= projectedTotalEVs - MAX_EV_SUM;
        }

        // If EVs added to a specific stat would cause the total to exceed MAX_EV_PER_STAT, reduce the gain to have the total at it.
        s32 projectedStatEVs = stat_evs[stat] + gainedEVs;
        if (projectedStatEVs > MAX_EV_PER_STAT) {
            gainedEVs -= projectedStatEVs - MAX_EV_PER_STAT;
        }

        stat_evs[stat] += gainedEVs;
        totalEVs += gainedEVs;
        SetMonData(mon, stat + MON_DATA_HP_EV, &stat_evs[stat]);
    }
    FreeMonPersonal(baseStats);
}

enum {
    STATE_GET_POKEMON_START = 0,
    STATE_GET_POKEMON_CHECK_IF_TRAINER,
    STATE_GET_POKEMON_CALCULATE_SHAKES,
    STATE_GET_POKEMON_BALL_FALL,
    STATE_GET_POKEMON_WAIT_FOR_BALL_FALL,
    STATE_GET_POKEMON_BALL_SHAKE,
    STATE_GET_POKEMON_BALL_SHAKE_DECREMENT,
    STATE_GET_POKEMON_BALL_CLICK,
    STATE_GET_POKEMON_GOTCHA,
    STATE_GET_POKEMON_BALL_FADE,
    STATE_GET_POKEMON_CHECK_MON_DATA, // 10
    STATE_GET_POKEMON_FADE_TO_POKEDEX,
    STATE_GET_POKEMON_POKEDEX_ENTRY,
    STATE_GET_POKEMON_DISMISS_POKEDEX_ENTRY,
    STATE_GET_POKEMON_MOVE_POKEPIC_TO_CENTER,
    STATE_GET_POKEMON_15,
    STATE_GET_POKEMON_ALREADY_CAUGHT,
    STATE_GET_POKEMON_FADE_TO_NICKNAME_ASK,
    STATE_GET_POKEMON_ASK_FOR_NICKNAME,
    STATE_GET_POKEMON_WAIT_FOR_YESNO,
    STATE_GET_POKEMON_PREPARE_NAMING_SCREEN, // 20
    STATE_GET_POKEMON_WAIT_FOR_NAMING_SCREEN,
    STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN,
    STATE_GET_POKEMON_STORE_NEW_MON_BUG_CONTEST,
    STATE_GET_POKEMON_STORE_MON_AFTER_NAMING_SCREEN,
    STATE_GET_POKEMON_FADE_UNNAMED_BOXED_MON,
    STATE_GET_POKEMON_BALL_BLOCKED,
    STATE_GET_POKEMON_NO_STEALING,
    STATE_GET_POKEMON_DONE_NO_STEALING,
    STATE_GET_POKEMON_BREAK_OUT,
    STATE_GET_POKEMON_BREAK_OUT_CLEANUP, // 30
    STATE_GET_POKEMON_BREAK_OUT_MESSAGE,
    STATE_GET_POKEMON_DONE_BREAK_OUT,
    STATE_GET_POKEMON_DONE_CAUGHT,
    STATE_GET_POKEMON_WAIT_FOR_EXP,
};

enum {
    DATA_GET_POKEMON_PRINTER_ID = 0,
    DATA_GET_POKEMON_FRAME_COUNTER,
    DATA_GET_POKEMON_BALL_SHAKES_TOTAL,
    DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS,
    DATA_GET_POKEMON_NEEDS_EXTRA_DISPOSAL_CHECK, // TODO: Needs a more accurate name.
};

enum {
    POINTER_GET_POKEMON_OVERLAY_MANAGER = 0,
    POINTER_GET_POKEMON_TASK_MANAGER,
    POINTER_GET_POKEMON_NAMING_SCREEN_OVERLAY_MANAGER = 0,
    POINTER_GET_POKEMON_NAMING_SCREEN_ARGS,
};

enum {
    BALL_ANIM_THROW = 0,
    BALL_ANIM_OPEN,
    BALL_ANIM_DEFLECT,
    BALL_ANIM_FALL,
    BALL_ANIM_SHAKE,
    BALL_ANIM_5, // Seemingly unused, at least here. When forcibly implemented, does not seem to do much for regular Pokeballs.
    BALL_ANIM_CLICK,
    BALL_ANIM_FADE,
};

static void Task_GetPokemon(SysTask *task, void *inData) {
    GetterWork *data = inData;
    SysTask *sysTask = task;
    PokepicManager *pokepicManager;
    MsgData *msgData = BattleSystem_GetMessageLoader(data->battleSystem);
    PaletteData *paletteData = BattleSystem_GetPaletteData(data->battleSystem);
    pokepicManager = BattleSystem_GetPokepicManager(data->battleSystem);

    s32 battlerId = BATTLER_ENEMY;
    if (MaskOfFlagNo(1) & data->ctx->switchInFlag) {
        battlerId = BATTLER_ENEMY2;
    }

    switch (data->state) {
    case STATE_GET_POKEMON_START:
        if (data->captureType == CAPTURE_NORMAL) {
            UnkStruct_134 unkStruct;
            unkStruct.unk8 = 3;
            unkStruct.heapID = HEAP_ID_BATTLE;
            unkStruct.unkC = battlerId + 20000;
            unkStruct.ball = data->ballID;
            unkStruct.spriteSystem = BattleSystem_GetSpriteSystem(data->battleSystem);
            unkStruct.paletteData = BattleSystem_GetPaletteData(data->battleSystem);
            unkStruct.unk14 = 1;
            unkStruct.unk18 = 0;
            unkStruct.battleSystem = data->battleSystem;
            if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_DOUBLES) {
                if (battlerId == BATTLER_ENEMY) {
                    unkStruct.unk0 = 16;
                } else { // BATTLER_ENEMY2, assumedly.
                    unkStruct.unk0 = 17;
                }
            } else { // This is a single battle.
                unkStruct.unk0 = 15;
            }
            data->ballData = ov07_02233DB8(&unkStruct); // Initializes whatever this is and gets it all ready to go.
            data->state = STATE_GET_POKEMON_CHECK_IF_TRAINER;
            PlaySE(SEQ_SE_DP_THROW);
            data->battleSystem->unk2422++;
            UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_THROW);
        } else { // CAPTURE_SAFARI
            OpponentData *opponentData = BattleSystem_GetOpponentData(data->battleSystem, BATTLER_PLAYER);
            if (ov07_02233F20(opponentData->ballData) != 4) { // Checks ballData->unk90.unk8.
                data->ballData = opponentData->ballData;
                opponentData->ballData = NULL;
                data->state = STATE_GET_POKEMON_CHECK_IF_TRAINER;
                PlaySE(SEQ_SE_DP_THROW);
                data->battleSystem->unk2422++;
                UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_THROW);
            }
        }
        data->tempData[DATA_GET_POKEMON_NEEDS_EXTRA_DISPOSAL_CHECK] = FALSE;
        break;
    case STATE_GET_POKEMON_CHECK_IF_TRAINER:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_THROW)) { // Likely checking if the current ball animation is still active. The second parameter is unused, as the same data is contained in unk8.
            if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_TRAINER) {
                sub_0200602C(SEQ_SE_DP_KON, 0x75);
                UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_DEFLECT);
                data->state = STATE_GET_POKEMON_BALL_BLOCKED;
                break;
            }
            sub_0200602C(SEQ_SE_DP_BOWA4, 0x75);
            UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_OPEN);
            data->state = STATE_GET_POKEMON_CALCULATE_SHAKES;
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 23;
        }
        break;
    case STATE_GET_POKEMON_CALCULATE_SHAKES:
        data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
        if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 23 frames have passed...
            ov12_022628A0(data->battleSystem, battlerId, data->ballID);
            data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] = BattleSystem_CalculateBallShakes(data->battleSystem, data->ctx);
            // The first ball of the battle to fail is kept for Ball Fetch.
            // The contest's and the Safari Zone's balls are not the player's
            // to keep, and a trainer's Pokemon never gets this far.
            if (data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] < BALL_SHAKE_MAX && data->ctx->ballFetchBall == ITEM_NONE && !data->ctx->ballFetched
                && !(BattleSystem_GetBattleType(data->battleSystem) & (BATTLE_TYPE_BUG_CONTEST | BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK))) {
                data->ctx->ballFetchBall = data->ctx->itemTemp;
            }

            if (data->ctx->criticalCapture) {
                data->tempData[DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS] = 1; // A critical throw shakes once whatever it is going to do.
            } else if (data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] < BALL_SHAKE_MAX) {
                data->tempData[DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS] = data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL]; // Store the number of shake animations we actually need to do.
            } else {
                data->tempData[DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS] = 3; // Even if we should catch, there should still only be 3 shakes. The 4th is a different animation.
            }
            data->state = STATE_GET_POKEMON_BALL_FALL;
        }
        break;
    case STATE_GET_POKEMON_BALL_FALL:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_OPEN) && Link_QueueNotEmpty(data->ctx)) {
            UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_FALL);
            data->state = STATE_GET_POKEMON_WAIT_FOR_BALL_FALL;
        }
        break;
    case STATE_GET_POKEMON_WAIT_FOR_BALL_FALL:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_FALL)) {
            data->state = STATE_GET_POKEMON_BALL_SHAKE;
        }
        break;
    case STATE_GET_POKEMON_BALL_SHAKE:
        if (data->tempData[DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS] == 0) {              // If there are no more ball shake animations to do...
            if (data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] == BALL_SHAKE_MAX) { // If the Pokemon should be caught...
                data->state = STATE_GET_POKEMON_BALL_CLICK;
                data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 12;
                break;
            }
            data->state = STATE_GET_POKEMON_BREAK_OUT;
            break;
        }
        UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_SHAKE);
        data->state = STATE_GET_POKEMON_BALL_SHAKE_DECREMENT;
        data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 12;
        break;
    case STATE_GET_POKEMON_BALL_SHAKE_DECREMENT:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_SHAKE)) {
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
            if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 12 frames have passed...
                data->tempData[DATA_GET_POKEMON_BALL_SHAKE_ANIMATIONS]--;
                data->state = STATE_GET_POKEMON_BALL_SHAKE;
            }
        }
        break;
    case STATE_GET_POKEMON_BALL_CLICK:
        data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
        if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // Perform the next step when there are no more frames to wait.
            UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_CLICK);
            sub_0200602C(SEQ_SE_DP_GETTING, 0x75);
            data->state = STATE_GET_POKEMON_GOTCHA;
        }
        break;
    case STATE_GET_POKEMON_GOTCHA:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_CLICK)) {
            BattleMessage msg;
            // "Gotcha! {0} was caught!"
            msg.id = msg_0197_00867;
            msg.tag = TAG_NICKNAME | 0x80;
            msg.param[0] = battlerId;
            data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
            data->state = STATE_GET_POKEMON_BALL_FADE;
            PlayBGM(SEQ_GS_WIN2);
            BattleSystem_SetCriticalHpMusicFlag(data->battleSystem, 2);
        }
        break;
    case STATE_GET_POKEMON_BALL_FADE:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID])) { // Wait for the text box to finish printing.
            data->state = STATE_GET_POKEMON_WAIT_FOR_EXP;
            UnkBallData_SetBallAnimation(data->ballData, BALL_ANIM_FADE);
            // A capture pays experience as a knockout does, and, as in the
            // games since the sixth generation, straight after "Gotcha!",
            // before the Dex and the nickname: after them the naming screen
            // has taken the battle's windows down, and the messages went to
            // a window that was no more. Lyra's catching demonstration pays
            // none: her Marill is made for the scene and goes with it, and
            // the demonstration never showed experience.
            data->ctx->battlerIdFainted = battlerId;
            if (!(BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_TUTORIAL) && CountExpGainers(data->battleSystem, data->ctx)) {
                // The caught Pokemon is in the ball: its box leaves before
                // the others gain from it, as a fainted one's does.
                BattleController_EmitHealthbarSlideOut(data->battleSystem, battlerId);
                StartGetExpTask(data->battleSystem, data->ctx);
            }
        }
        break;
    case STATE_GET_POKEMON_WAIT_FOR_EXP:
        // Task_GetExp has handed the getter back, or never ran, and the box
        // is out.
        if (data->ctx->getterWork == data && Link_QueueNotEmpty(data->ctx)) {
            data->state = STATE_GET_POKEMON_CHECK_MON_DATA;
        }
        break;
    case STATE_GET_POKEMON_CHECK_MON_DATA:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_FADE) && !(data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--, data->tempData[DATA_GET_POKEMON_FRAME_COUNTER])) {
            ov12_0223BD8C(data->battleSystem, battlerId);
            Pokemon *mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]); // Get the data of the caught Pokemon.
            // The item the player's side took from it is its own again, and
            // the other wild Pokemon's, if any, still goes to the bag
            // (NoteHeldItemTaken, GiveBackHeldItems).
            u16 *taken = data->ctx->itemsTakenFromWild;
            if (taken[battlerId >> 1] != ITEM_NONE) {
                SetMonData(mon, MON_DATA_HELD_ITEM, &taken[battlerId >> 1]);
            }
            taken[(battlerId >> 1) ^ 1] = ITEM_NONE;
            CaughtMonKeepsItem(data->battleSystem, data->ctx, mon);
            if (BattleSystem_GetBattleType(data->battleSystem) & (BATTLE_TYPE_PAL_PARK | BATTLE_TYPE_TUTORIAL)) {           // If this was the Catching Demo or a Pal Park encounter...
                ov12_022567D4(data->battleSystem, data->ctx, BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]));
                sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                PaletteData_BeginPaletteFade(paletteData, 0xF, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
                Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
                data->state = STATE_GET_POKEMON_DONE_CAUGHT;
                data->tempData[DATA_GET_POKEMON_NEEDS_EXTRA_DISPOSAL_CHECK] = TRUE;
                break;
            }
            if (BattleSystem_CheckMonCaught(data->battleSystem, GetMonData(mon, MON_DATA_SPECIES, 0))) { // If this was already caught...
                if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_BUG_CONTEST) {          // If this was the Bug Catching Contest...
                    sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                    PaletteData_BeginPaletteFade(paletteData, 0xF, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
                    Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
                    data->state = STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN;
                    data->tempData[DATA_GET_POKEMON_NEEDS_EXTRA_DISPOSAL_CHECK] = TRUE;
                    break;
                }
                sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                PaletteData_BeginPaletteFade(paletteData, 5, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
                Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
                data->state = STATE_GET_POKEMON_ALREADY_CAUGHT;
                break;
            }
            BattleMessage msg;
            // "{0}’s data has been added to the Pokédex."
            msg.id = msg_0197_00871;
            msg.tag = TAG_NICKNAME | 0x80;
            msg.param[0] = battlerId;
            data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
            data->state = STATE_GET_POKEMON_FADE_TO_POKEDEX;
            ov12_0223BB44(data->battleSystem);
        }
        break;
    case STATE_GET_POKEMON_FADE_TO_POKEDEX:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID])) { // Wait for the text box to finish printing.
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
            if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 30 frames have passed...
                data->state = STATE_GET_POKEMON_POKEDEX_ENTRY;
                PaletteData_BeginPaletteFade(paletteData, 5, 0xFFFF, 1, 0, 16, RGB_BLACK);
                Pokepic_StartPaletteFadeAll(pokepicManager, 0, 16, 0, RGB_BLACK);
                sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
            }
        }
        break;
    case STATE_GET_POKEMON_POKEDEX_ENTRY:
        if (!PaletteData_GetSelectedBuffersBitmask(paletteData)) {
            ov07_02233ECC(data->ballData);
            PokepicManager_DeleteAllPics(pokepicManager);
            ov12_02237CC4(data->battleSystem);
            ov12_02265FC4(ov12_0223A8F4(data->battleSystem, 0), 0);
            ov12_02265FC4(ov12_0223A8F4(data->battleSystem, 1), 0);
            ov12_02261294(BattleSystem_GetOpponentData(data->battleSystem, BATTLER_PLAYER), 0);
            UnkStruct_50C unkStruct;
            unkStruct.bgConfig = BattleSystem_GetBgConfig(data->battleSystem);
            unkStruct.paletteData = BattleSystem_GetPaletteData(data->battleSystem);
            unkStruct.pokepicManager = pokepicManager;
            unkStruct.heapID = HEAP_ID_BATTLE;
            unkStruct.mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]);
            unkStruct.natDexEnabled = Pokedex_IsNatDexEnabled(BattleSystem_GetPokedex(data->battleSystem));
            data->tempPointers[POINTER_GET_POKEMON_TASK_MANAGER] = ObjCharTransfer_PopTaskManager();
            data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER] = ov18_021F8974(&unkStruct);
            data->state = STATE_GET_POKEMON_DISMISS_POKEDEX_ENTRY;
        }
        break;
    case STATE_GET_POKEMON_DISMISS_POKEDEX_ENTRY:
        if (ov18_021F89C8(data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER]) == 1) {
            if (PAD_BUTTON_A & gSystem.newKeys) { // If the A button is pressed...
                data->state = STATE_GET_POKEMON_MOVE_POKEPIC_TO_CENTER;
            } else if (System_GetTouchNew()) { // If the touch screen is pressed...
                PlaySE(SEQ_SE_DP_SELECT);      // For some reason, a sound effect only plays if the touch screen is used here.
                data->state = STATE_GET_POKEMON_MOVE_POKEPIC_TO_CENTER;
            }
            if (data->state == STATE_GET_POKEMON_MOVE_POKEPIC_TO_CENTER) {
                if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_BUG_CONTEST) {
                    PaletteData_BeginPaletteFade(paletteData, 15, 0xFFFF, 1, 0, 16, RGB_BLACK);
                    Pokepic_StartPaletteFadeAll(pokepicManager, 0, 16, 0, RGB_BLACK);
                    break;
                }
                PaletteData_BeginPaletteFade(paletteData, 5, 0xFFFF, 1, 0, 16, RGB_BLACK);
            }
        }
        break;
    case STATE_GET_POKEMON_MOVE_POKEPIC_TO_CENTER:
        if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_BUG_CONTEST) {
            data->state = STATE_GET_POKEMON_STORE_NEW_MON_BUG_CONTEST;
            break;
        }
        Pokepic *pic = ov18_021F95F8(data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER]);
        Pokepic_AddAttr(pic, POKEPIC_X, 4);           // Move the Pokepic 4 pixels to the right each frame.
        if (Pokepic_GetAttr(pic, POKEPIC_X) >= 128) { // Stop when the Pokepic has reached the center of the screen.
            Pokepic_SetAttr(pic, POKEPIC_X, 128);
            ov18_021F95AC(data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER]);
            data->state = STATE_GET_POKEMON_15;
        }
        break;
    case STATE_GET_POKEMON_15:
        ov18_021F89D0(data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER]);
        ObjCharTransfer_PushTaskManager(data->tempPointers[POINTER_GET_POKEMON_TASK_MANAGER]);
        ov12_02237D00(data->battleSystem);
        PaletteData_BeginPaletteFade(paletteData, 5, 0xFFFF, 1, 16, 0, RGB_BLACK);
        data->state = STATE_GET_POKEMON_FADE_TO_NICKNAME_ASK;
        break;
    case STATE_GET_POKEMON_ALREADY_CAUGHT:
        if (!PaletteData_GetSelectedBuffersBitmask(paletteData)) {
            Pokemon *mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]);
            ov07_02233ECC(data->ballData);
            PokepicManager_DeleteAllPics(pokepicManager);
            ov12_02261294(BattleSystem_GetOpponentData(data->battleSystem, BATTLER_PLAYER), 0);
            ov12_02237CC4(data->battleSystem);
            ov12_02237D00(data->battleSystem);
            PokepicTemplate picTemplate;
            GetPokemonSpriteCharAndPlttNarcIds(&picTemplate, mon, 2);
            PokepicManager_CreatePokepic(pokepicManager, &picTemplate, 128, 72, 0, 0, 0, 0);
            PaletteData_BeginPaletteFade(paletteData, 5, 0xFFFF, 1, 16, 0, RGB_BLACK);
            Pokepic_StartPaletteFadeAll(pokepicManager, 16, 0, 0, RGB_BLACK);
            data->state = STATE_GET_POKEMON_FADE_TO_NICKNAME_ASK;
        }
        break;
    case STATE_GET_POKEMON_FADE_TO_NICKNAME_ASK:
        if (!PaletteData_GetSelectedBuffersBitmask(paletteData)) {
            data->state = STATE_GET_POKEMON_ASK_FOR_NICKNAME;
            sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 0);
            PaletteData_SetAutoTransparent(paletteData, 1);
        }
        break;
    case STATE_GET_POKEMON_ASK_FOR_NICKNAME:
        BattleController_EmitDrawYesNoBox(data->battleSystem, data->ctx, 0, 0x364, 5, 0, data->ctx->selectedMonIndex[battlerId] | battlerId); // Would you like to give {0} a nickname?
        data->state++;
        break;
    case STATE_GET_POKEMON_WAIT_FOR_YESNO:
        if (BattleBuffer_GetNext(data->ctx, BATTLER_PLAYER)) {             // Wait for the player to prompt the game to continue.
            if (BattleBuffer_GetNext(data->ctx, BATTLER_PLAYER) == 0xFF) { // If the player said no...
                data->state = STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN;
                break;
            }
            sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
            PaletteData_BeginPaletteFade(paletteData, 0xF, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
            Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
            data->state = STATE_GET_POKEMON_PREPARE_NAMING_SCREEN;
        }
        break;
    case STATE_GET_POKEMON_PREPARE_NAMING_SCREEN:
        if (!PaletteData_GetSelectedBuffersBitmask(paletteData)) {
            sub_0200FBF4(PM_LCD_TOP, RGB_BLACK);
            sub_0200FBF4(PM_LCD_BOTTOM, RGB_BLACK);
            Pokemon *mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]);
            NamingScreenArgs *namingScreenArgs = NamingScreen_CreateArgs(HEAP_ID_BATTLE, NAME_SCREEN_POKEMON, GetMonData(mon, MON_DATA_SPECIES, 0), 10, BattleSystem_GetOptions(data->battleSystem), 0);
            data->tempPointers[POINTER_GET_POKEMON_NAMING_SCREEN_ARGS] = namingScreenArgs;
            if (BattleSystem_GetPartySize(data->battleSystem, 0) < PARTY_SIZE) {
                namingScreenArgs->battleMsgId = 0;
            } else {
                namingScreenArgs->battleMsgId = BattleSystem_MetBill(data->battleSystem) + 0x496; // {0} was transferred to {1} in someone’s/Bill's PC!
            }
            namingScreenArgs->monForm = GetMonData(mon, MON_DATA_FORM, 0);
            namingScreenArgs->pcStorage = BattleSystem_GetPcStorage(data->battleSystem);
            namingScreenArgs->monGender = GetMonData(mon, MON_DATA_GENDER, 0);
            data->tempPointers[POINTER_GET_POKEMON_NAMING_SCREEN_OVERLAY_MANAGER] = OverlayManager_New(&gOverlayTemplate_NamingScreen, namingScreenArgs, HEAP_ID_BATTLE);
            data->state = STATE_GET_POKEMON_WAIT_FOR_NAMING_SCREEN;
            BattleSystem_HpBar_Delete(data->battleSystem);

            for (int battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(data->battleSystem); battlerId++) {
                OpponentData *opponentData = BattleSystem_GetOpponentData(data->battleSystem, battlerId);
                if (opponentData->managedSprite) {
                    Sprite_DeleteAndFreeResources(opponentData->managedSprite);
                    opponentData->managedSprite = NULL;
                }
            }

            ov12_02237B6C(data->battleSystem);
            ov12_0223BBF0(data->battleSystem, 1);
        }
        break;
    case STATE_GET_POKEMON_WAIT_FOR_NAMING_SCREEN:
        if (OverlayManager_Run(data->tempPointers[POINTER_GET_POKEMON_NAMING_SCREEN_OVERLAY_MANAGER])) {
            NamingScreenArgs *namingScreenArgs = data->tempPointers[POINTER_GET_POKEMON_NAMING_SCREEN_ARGS];
            Pokemon *mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]);
            if (!namingScreenArgs->noInput) {
                SetMonData(mon, MON_DATA_NICKNAME_STRING_AND_FLAG, namingScreenArgs->nameInputString);
                BattleSystem_GameStatIncrement(data->battleSystem, GAME_STAT_NICKNAMES_GIVEN);
            }
            NamingScreen_DeleteArgs(namingScreenArgs);
            OverlayManager_Delete(data->tempPointers[POINTER_GET_POKEMON_NAMING_SCREEN_OVERLAY_MANAGER]);
            ov12_0223BBF0(data->battleSystem, 2);
            data->state = STATE_GET_POKEMON_STORE_MON_AFTER_NAMING_SCREEN;
        }
        break;
    case STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN:
    case STATE_GET_POKEMON_STORE_NEW_MON_BUG_CONTEST:
    case STATE_GET_POKEMON_STORE_MON_AFTER_NAMING_SCREEN:
        if (!PaletteData_GetSelectedBuffersBitmask(paletteData)) {
            Party *party = BattleSystem_GetParty(data->battleSystem, BATTLER_PLAYER);
            Pokemon *mon = BattleSystem_GetPartyMon(data->battleSystem, battlerId, data->ctx->selectedMonIndex[battlerId]);
            BattleSystem_SetPokedexCaught(data->battleSystem, battlerId);
            ov12_022567D4(data->battleSystem, data->ctx, mon);
            ov12_0223B870(data->battleSystem, mon);
            BattleController_EmitIncrementGameStat(data->battleSystem, BATTLER_PLAYER, 0, GAME_STAT_CAUGHT_MON);
            if (BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_BUG_CONTEST) {
                if (data->state == STATE_GET_POKEMON_STORE_NEW_MON_BUG_CONTEST) {
                    ov18_021F89D0(data->tempPointers[POINTER_GET_POKEMON_OVERLAY_MANAGER]);                // We have not overwritten our original OverlayManager if we arrive here through this state.
                    ObjCharTransfer_PushTaskManager(data->tempPointers[POINTER_GET_POKEMON_TASK_MANAGER]); // Nor our TaskManager.
                    ov12_02237D00(data->battleSystem);
                }
                CopyPokemonToPokemon(mon, BattleSystem_GetBugContestCaughtMon(data->battleSystem));
                if (data->state == STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN) {
                    sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                }
                data->state = STATE_GET_POKEMON_DONE_CAUGHT;
                break;
            }
            if (Party_AddMon(party, mon) == TRUE) {
                if (data->state == STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN) {
                    sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                    PaletteData_BeginPaletteFade(paletteData, 0xF, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
                    Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
                }
                data->state = STATE_GET_POKEMON_DONE_CAUGHT;
                break;
            }
            PCStorage *pcStorage = BattleSystem_GetPcStorage(data->battleSystem);
            int activeBox = PCStorage_GetActiveBox(pcStorage);
            int emptyBox = PCStorage_FindFirstBoxWithEmptySlot(pcStorage);
            PCStorage_SetActiveBox(pcStorage, emptyBox);

            for (s32 moveSlot = 0; moveSlot < 4; moveSlot++) {
                u32 maxPP = GetMonData(mon, MON_DATA_MOVE1_MAX_PP + moveSlot, 0);
                SetMonData(mon, MON_DATA_MOVE1_PP + moveSlot, &maxPP);
            }

            if (Mon_UpdateGiratinaForm(mon) != -1) {
                BattleSystem_SetPokedexCaught(data->battleSystem, battlerId);
            }
            PCStorage_PlaceMonInBoxFirstEmptySlot(pcStorage, emptyBox, Mon_GetBoxMon(mon));
            if (data->state == STATE_GET_POKEMON_STORE_MON_NO_NAMING_SCREEN) {
                BattleMessage msg;
                if (activeBox == emptyBox) {
                    // "{0} was transferred to {1} in [someone’s]/[Bill's] PC!"
                    msg.id = BattleSystem_MetBill(data->battleSystem) + msg_0197_01174;
                    msg.tag = TAG_NICKNAME_BOX | 0x80;
                    msg.param[0] = battlerId;
                    msg.param[1] = activeBox;
                } else {
                    // "{1} in [someone’s]/[Bill's] PC is full. {0} was transferred to {2} instead!"
                    msg.id = BattleSystem_MetBill(data->battleSystem) + msg_0197_01176;
                    msg.tag = TAG_NICKNAME_BOX_BOX | 0x80;
                    msg.param[0] = battlerId;
                    msg.param[1] = activeBox;
                    msg.param[2] = emptyBox;
                }
                data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
                data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
                data->state = STATE_GET_POKEMON_FADE_UNNAMED_BOXED_MON;
                break;
            }
            data->state = STATE_GET_POKEMON_DONE_CAUGHT;
        }
        break;
    case STATE_GET_POKEMON_FADE_UNNAMED_BOXED_MON:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID])) {
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
            if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 30 frames have passed...
                sub_0201649C(BattleSystem_GetMessageIcon(data->battleSystem), 1);
                PaletteData_BeginPaletteFade(paletteData, 0xF, 0xFFFF, 1, 0, 0x10, RGB_BLACK);
                Pokepic_StartPaletteFadeAll(pokepicManager, 0, 0x10, 0, RGB_BLACK);
                data->state = STATE_GET_POKEMON_DONE_CAUGHT;
            }
        }
        break;
    case STATE_GET_POKEMON_BALL_BLOCKED:
        if (!ov07_02232F60(data->ballData, BALL_ANIM_DEFLECT)) {
            ov07_02233ECC(data->ballData);
            BattleMessage msg;
            // "The Trainer blocked the Ball!"
            msg.id = msg_0197_00859;
            msg.tag = TAG_NONE;
            data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
            data->state = STATE_GET_POKEMON_NO_STEALING;
        }
        break;
    case STATE_GET_POKEMON_NO_STEALING:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID]) && !--data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]) {
            BattleMessage msg;
            // "Don’t be a thief!"
            msg.id = msg_0197_00860;
            msg.tag = TAG_NONE;
            data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
            data->state = STATE_GET_POKEMON_DONE_NO_STEALING;
        }
        break;
    case STATE_GET_POKEMON_DONE_NO_STEALING:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID])) {
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
            if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 30 frames have passed...
                data->ctx->getterWork = 0;
                Heap_Free(data);
                SysTask_Destroy(sysTask);
            }
        }
    default:
        break;
    case STATE_GET_POKEMON_BREAK_OUT:
        BattleController_EmitPokemonSendOut(data->battleSystem, battlerId, data->ballID, 1); // Breaking out hijacks the send out animation.
        data->state = STATE_GET_POKEMON_BREAK_OUT_CLEANUP;
        data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 2;
        break;
    case STATE_GET_POKEMON_BREAK_OUT_CLEANUP:
        data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
        if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 2 frames have passed...
            ov07_02233ECC(data->ballData);
            data->state = STATE_GET_POKEMON_BREAK_OUT_MESSAGE;
        }
        break;
    case STATE_GET_POKEMON_BREAK_OUT_MESSAGE:
        if (Link_QueueNotEmpty(data->ctx)) {
            BattleMessage msg;
            // Break-out messages, including ball shake offsets.
            msg.id = data->tempData[DATA_GET_POKEMON_BALL_SHAKES_TOTAL] + msg_0197_00863;
            msg.tag = TAG_NONE;
            data->tempData[DATA_GET_POKEMON_PRINTER_ID] = BattleSystem_PrintBattleMessage(data->battleSystem, msgData, &msg, BattleSystem_GetTextFrameDelay(data->battleSystem));
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] = 30;
            data->state = STATE_GET_POKEMON_DONE_BREAK_OUT;
        }
        break;
    case STATE_GET_POKEMON_DONE_BREAK_OUT:
        if (!TextPrinterCheckActive(data->tempData[DATA_GET_POKEMON_PRINTER_ID])) {
            data->tempData[DATA_GET_POKEMON_FRAME_COUNTER]--;
            if (data->tempData[DATA_GET_POKEMON_FRAME_COUNTER] == 0) { // After 30 frames have passed...
                data->ctx->getterWork = 0;
                Heap_Free(data);
                SysTask_Destroy(sysTask);
            }
        }
        break;
    case STATE_GET_POKEMON_DONE_CAUGHT:
        if (PaletteData_GetSelectedBuffersBitmask(paletteData) == 0) {
            if (data->tempData[DATA_GET_POKEMON_NEEDS_EXTRA_DISPOSAL_CHECK]) {
                ov07_02233ECC(data->ballData);
                PokepicManager_DeleteAllPics(pokepicManager);
            }
            data->battleSystem->battleOutcomeFlag = BATTLE_OUTCOME_MON_CAUGHT;
            data->ctx->getterWork = 0;
            Heap_Free(data);
            SysTask_Destroy(sysTask);
        }
        break;
    }
}

#define CP_SQRT_32BIT_MODE (0UL << REG_CP_SQRTCNT_MODE_SHIFT)

static inline void CP_SetSqrtImm32_NS_(u32 param) {
    *((REGType32 *)REG_SQRT_PARAM_ADDR) = param;
}

static inline void CP_SetSqrtImm32(u32 param) {
    *((REGType32 *)REG_SQRT_PARAM_ADDR) = param;
}

static inline void CP_SetSqrt32(u32 param) {
    reg_CP_SQRTCNT = CP_SQRT_32BIT_MODE;
    CP_SetSqrtImm32_NS_(param);
}

static inline s32 CP_IsSqrtBusy(void) {
    return reg_CP_SQRTCNT & REG_CP_SQRTCNT_BUSY_MASK;
}

static inline void CP_WaitSqrt(void) {
    while (CP_IsSqrtBusy()) {
    }
}

static inline u32 CP_GetSqrtResultImm32(void) {
    return (u32)(*((REGType32 *)REG_SQRT_RESULT_ADDR));
}

static inline u32 CP_GetSqrtResult32(void) {
    CP_WaitSqrt();
    return CP_GetSqrtResultImm32();
}

// Experience scales with how far the fainted Pokemon outranks the one being
// rewarded: beating something above your level pays more, grinding on weaker
// Pokemon pays less. The ratio is ((2L+10) / (L+Lp+10)) raised to 2.5, worked
// out the way hg-engine works it out (Task_DistributeExp_Extend): each side is
// t*t*sqrt(t) with the hardware's whole-numbered square root, all in 32 bits.
//
// exp * top passes 32 bits when a low-level Pokemon beats a high-level one
// with a large yield (at most 12160 * 617400, which wraps once). The engine
// then adds back what the wrap took off one bottom at a time, a close
// approximation of the true quotient, and so does this.
static u32 BattleScript_ScaleExpToLevel(u32 exp, u32 faintedLevel, u32 gainerLevel) {
    u32 top = 2 * faintedLevel + 10;
    u32 bottom = faintedLevel + gainerLevel + 10;

    CP_SetSqrt32(top);
    top = top * top * CP_GetSqrtResult32();
    CP_SetSqrt32(bottom);
    bottom = bottom * bottom * CP_GetSqrtResult32();

    u32 result = top * exp;
    if (result / top != exp) {
        return (result + 1) / bottom + 0xFFFFFFFF / bottom + 1;
    }
    return result / bottom;
}

// What one Pokemon wins from the fainted one, before the Lucky Egg, trainer
// and trade bonuses. As in hg-engine, the whole award is scaled to the
// gainer's level first and only then shared out: half among the participants
// and half among the Exp. Share holders when anyone holds one, each part at
// least 1. A participant that holds the Exp. Share takes both parts.
static u32 BattleScript_GainerExp(u32 exp, u32 faintedLevel, u32 gainerLevel, int expMonsCnt, int expShareMonsCnt, BOOL participated, BOOL holdsExpShare) {
    u32 participantExp;
    u32 expShareExp;

    exp = BattleScript_ScaleExpToLevel(exp, faintedLevel, gainerLevel);
    if (expShareMonsCnt) {
        participantExp = (exp / 2) / expMonsCnt;
        if (participantExp == 0) {
            participantExp = 1;
        }
        expShareExp = (exp / 2) / expShareMonsCnt;
        if (expShareExp == 0) {
            expShareExp = 1;
        }
    } else {
        participantExp = exp / expMonsCnt;
        if (participantExp == 0) {
            participantExp = 1;
        }
        expShareExp = 0;
    }
    return (participated ? participantExp : 0) + (holdsExpShare ? expShareExp : 0);
}

// A throw is sometimes a critical one: the ball shakes once, and a single
// shake check decides it rather than four, so it is likelier to catch. How
// often depends on how much of the Johto dex the player has filled in.
//
// The reference means the same and gets neither half: its rate multiplies an
// int by a u32 and wraps, so the roll never hits, and were it to hit, the flag
// its caller reads is never set, so the one passed check would come back as a
// plain single shake -- an escape. Neither is copied (Paolo, 2026-09-23).
static u32 CriticalCaptureRate(BattleSystem *bsys, u32 modifiedCatchRate) {
    u16 owned = BattleSystem_CountRegionalDexOwned(bsys);
    u32 tenths;

    if (owned > 600) {
        tenths = 25;
    } else if (owned > 450) {
        tenths = 20;
    } else if (owned > 300) {
        tenths = 15;
    } else if (owned > 150) {
        tenths = 10;
    } else if (owned > 30) {
        tenths = 5;
    } else {
        return 0;
    }
    return modifiedCatchRate * tenths / 10 / 6;
}

// The capture formula is hg-engine's (src/individual/CalculateBallShakes.c),
// Generation VIII and IX's worked in Q4.12 fixed point, where 0x1000 is 1:
// a ball's capture ratio, a penalty for Pokemon above the player's badges, a
// bonus for low levels, and a table for the chance of each shake.
#define CATCH_Q12_ONE 0x1000

static u32 CatchQMul_RoundDown(u32 value, u32 ratio) {
    return ratio == CATCH_Q12_ONE ? value : (value * ratio + 0x7FF) >> 12;
}

static u64 CatchQMul64_RoundUp(u64 value, u64 ratio) {
    return (value * ratio + 0x800) >> 12;
}

// The chance of one shake, out of 65536, for each whole modified catch rate.
static const u16 sShakeChances[255] = {
    0, 23186, 26405, 28490, 30070, 31355, 32447, 33395, 34243, 35007, 35705, 36348,
    36949, 37506, 38032, 38529, 38994, 39441, 39868, 40275, 40659, 41038, 41393, 41740,
    42074, 42400, 42710, 43018, 43310, 43598, 43876, 44143, 44406, 44664, 44918, 45160,
    45397, 45636, 45862, 46083, 46305, 46522, 46733, 46937, 47143, 47343, 47535, 47730,
    47917, 48098, 48288, 48462, 48638, 48815, 48984, 49155, 49317, 49490, 49645, 49802,
    49960, 50118, 50268, 50419, 50571, 50715, 50868, 51004, 51150, 51286, 51424, 51562,
    51701, 51831, 51972, 52103, 52224, 52357, 52480, 52613, 52737, 52852, 52977, 53102,
    53218, 53335, 53451, 53569, 53687, 53794, 53913, 54022, 54130, 54240, 54350, 54460,
    54571, 54671, 54782, 54883, 54984, 55086, 55188, 55290, 55393, 55496, 55588, 55692,
    55784, 55877, 55982, 56075, 56169, 56263, 56358, 56441, 56536, 56631, 56715, 56811,
    56896, 56992, 57077, 57162, 57247, 57333, 57419, 57505, 57591, 57678, 57765, 57840,
    57927, 58002, 58090, 58165, 58254, 58330, 58406, 58482, 58571, 58648, 58725, 58802,
    58880, 58957, 59035, 59100, 59178, 59257, 59335, 59401, 59480, 59546, 59625, 59692,
    59771, 59838, 59905, 59985, 60052, 60119, 60187, 60254, 60336, 60404, 60472, 60540,
    60608, 60677, 60732, 60800, 60869, 60938, 61008, 61063, 61133, 61202, 61258, 61328,
    61398, 61455, 61525, 61581, 61638, 61709, 61766, 61837, 61894, 61951, 62022, 62080,
    62137, 62195, 62267, 62325, 62383, 62441, 62499, 62557, 62616, 62674, 62733, 62791,
    62850, 62909, 62968, 63027, 63072, 63131, 63191, 63250, 63310, 63355, 63414, 63474,
    63519, 63580, 63640, 63685, 63746, 63806, 63852, 63913, 63958, 64019, 64065, 64126,
    64172, 64234, 64280, 64326, 64388, 64434, 64481, 64543, 64589, 64636, 64698, 64745,
    64792, 64839, 64902, 64949, 64996, 65043, 65091, 65138, 65185, 65249, 65296, 65344,
    65392, 65440, 65488,
};

// Each badge the player lacks for a Pokemon's level takes a fifth off: 0.8
// raised to the number missing, in Q4.12.
static const u8 sBadgeLevels[9] = { 20, 25, 30, 35, 40, 45, 50, 55, 100 };
static const u16 sMissingBadgePenalties[9] = { 4096, 3277, 2621, 2097, 1678, 1342, 1074, 859, 687 };

static BOOL IsUltraBeast(u16 species) {
    switch (species) {
    case SPECIES_NIHILEGO:
    case SPECIES_BUZZWOLE:
    case SPECIES_PHEROMOSA:
    case SPECIES_XURKITREE:
    case SPECIES_CELESTEELA:
    case SPECIES_KARTANA:
    case SPECIES_GUZZLORD:
    case SPECIES_POIPOLE:
    case SPECIES_NAGANADEL:
    case SPECIES_STAKATAKA:
    case SPECIES_BLACEPHALON:
        return TRUE;
    }
    return FALSE;
}

static u32 BattleSystem_CalculateBallShakes(BattleSystem *bsys, BattleContext *ctx) {
    BattleMon *target = &ctx->battleMons[ctx->battlerIdTarget];
    u32 catchRate;
    s32 heavyBallMod = 0;
    u32 ballRatio = CATCH_Q12_ONE;
    u32 i;

    if (BattleSystem_GetBattleType(bsys) & (BATTLE_TYPE_PAL_PARK | BATTLE_TYPE_TUTORIAL)) {
        return BALL_SHAKE_MAX;
    }
    catchRate = GetMonBaseStat(target->species, BASE_CATCH_RATE);
    if (ctx->itemTemp == ITEM_SAFARI_BALL) {
        // Adjust the catch rate in the safari zone by the pokemon's caution level.
        catchRate = (sSafariCatchRateStages[ctx->safariCatchRateStage][0] * catchRate) / sSafariCatchRateStages[ctx->safariCatchRateStage][1];
    }

    switch (ctx->itemTemp) {
    case ITEM_MASTER_BALL:
        // A species already registered is shown as a critical throw.
        ctx->criticalCapture = BattleSystem_CheckMonCaught(bsys, target->species) == TRUE;
        return BALL_SHAKE_MAX;
    case ITEM_ULTRA_BALL:
        ballRatio = 0x2000;
        break;
    case ITEM_GREAT_BALL:
        ballRatio = 0x1800;
        break;
    case ITEM_SAFARI_BALL:
        if (BattleSystem_GetBattleType(bsys) & BATTLE_TYPE_SAFARI) {
            ballRatio = 0x1800;
        }
        break;
    case ITEM_NET_BALL: {
        u32 type1 = GetBattlerVar(ctx, ctx->battlerIdTarget, BMON_DATA_TYPE_1, 0);
        u32 type2 = GetBattlerVar(ctx, ctx->battlerIdTarget, BMON_DATA_TYPE_2, 0);
        if (type1 == TYPE_WATER || type2 == TYPE_WATER || type1 == TYPE_BUG || type2 == TYPE_BUG) {
            ballRatio = 0x3800;
        }
        break;
    }
    case ITEM_DIVE_BALL:
        if (BattleSystem_GetTerrainId(bsys) == TERRAIN_WATER) {
            ballRatio = 0x3800;
        }
        break;
    case ITEM_NEST_BALL:
        // (41 - level) / 10, from 4x at level 1 down to 1.1x at level 30.
        if (target->level <= 30) {
            ballRatio = CatchQMul_RoundDown((41 - target->level) * CATCH_Q12_ONE + 0x800, 409);
        }
        break;
    case ITEM_REPEAT_BALL:
        if (BattleSystem_CheckMonCaught(bsys, target->species) == TRUE) {
            ballRatio = 0x3800;
        }
        break;
    case ITEM_TIMER_BALL:
        // Three tenths a turn, up to 4x.
        ballRatio = 1229 * ctx->totalTurns + CATCH_Q12_ONE;
        if (ballRatio > 0x4000) {
            ballRatio = 0x4000;
        }
        break;
    case ITEM_DUSK_BALL:
        if (BattleSystem_GetTimezone(bsys) == 3 || BattleSystem_GetTimezone(bsys) == 4 || BattleSystem_GetTerrainId(bsys) == TERRAIN_CAVE) {
            ballRatio = 0x3000;
        }
        break;
    case ITEM_QUICK_BALL:
        if (ctx->totalTurns < 1) {
            ballRatio = 0x5000;
        }
        break;
    case ITEM_FAST_BALL:
        if (GetMonBaseStat(target->species, BASE_SPEED) >= 100) {
            ballRatio = 0x4000;
        }
        break;
    case ITEM_LEVEL_BALL: {
        u32 attackerLevel = ctx->battleMons[ctx->battlerIdAttacker].level;
        if (attackerLevel >= 4 * target->level) {
            ballRatio = 0x8000;
        } else if (attackerLevel >= 2 * target->level) {
            ballRatio = 0x4000;
        } else if (attackerLevel > target->level) {
            ballRatio = 0x2000;
        }
        break;
    }
    case ITEM_LURE_BALL:
        if (BattleSystem_IsFishing(bsys)) {
            ballRatio = 0x3000;
        }
        break;
    case ITEM_HEAVY_BALL: {
        // Weight is in tenths of a kilogram: a penalty under 100 kg, nothing
        // to 200, then a bonus in two steps.
        s32 weight = GetMonWeight(target->species);
        if (weight < 999) {
            heavyBallMod = -20;
        } else if (weight < 1999) {
            heavyBallMod = 0;
        } else if (weight < 2999) {
            heavyBallMod = 20;
        } else {
            heavyBallMod = 30;
        }
        break;
    }
    case ITEM_LOVE_BALL: {
        BattleMon *attacker = &ctx->battleMons[ctx->battlerIdAttacker];
        if (attacker->species == target->species && attacker->gender != target->gender && attacker->gender != MON_GENDERLESS && target->gender != MON_GENDERLESS) {
            ballRatio = 0x8000;
        }
        break;
    }
    case ITEM_MOON_BALL:
        for (i = 0; i < NELEMS(sMoonBallPokemon); i++) {
            if (sMoonBallPokemon[i] == target->species) {
                ballRatio = 0x4000;
                break;
            }
        }
        break;
    case ITEM_SPORT_BALL:
        // Only worth its extra half in the Bug-Catching Contest, which is the
        // only place it is handed out.
        if (BattleSystem_GetBattleType(bsys) & BATTLE_TYPE_BUG_CONTEST) {
            ballRatio = 0x1800;
        }
        break;
    case ITEM_DREAM_BALL:
        if ((target->status & STATUS_SLEEP) || GetBattlerAbility(ctx, ctx->battlerIdTarget) == ABILITY_COMATOSE) {
            ballRatio = 0x4000;
        }
        break;
    }
    // The Beast Ball is for Ultra Beasts, and anything else is a tenth as good
    // on them and with it.
    if (IsUltraBeast(target->species)) {
        ballRatio = ctx->itemTemp == ITEM_BEAST_BALL ? 0x5000 : 0x19A;
    } else if (ctx->itemTemp == ITEM_BEAST_BALL) {
        ballRatio = 0x19A;
    }

    // Steps 1 to 3: the catch rate times what is left of 3 * max HP - 2 * HP.
    // The reference adds the Heavy Ball's modifier to the catch rate as an
    // unsigned number, so a penalty larger than the rate wraps it to four
    // billion and the value that comes out is noise. A rate pushed below
    // nothing is 1 instead, as this function always had it.
    s32 heavyRate = (s32)catchRate + heavyBallMod;
    if (heavyRate < 0) {
        heavyRate = 1;
    }
    u32 maxHpTimes3 = target->maxHp * 3;
    u64 value = (u64)heavyRate * ((maxHpTimes3 - 2 * target->hp) * CATCH_Q12_ONE);

    // Step 4: the ball.
    value = CatchQMul64_RoundUp(value, ballRatio);

    // Step 5: the badges the player lacks for the Pokemon's level, and the
    // division by 3 * max HP. The reference sums the two badge bitmasks as if
    // they were counts, which calls a player with three badges one with seven;
    // the badges are counted here.
    s32 badges = PlayerProfile_CountBadges(BattleSystem_GetPlayerProfile(bsys, 0));
    if (badges > 8) {
        badges = 8;
    }
    u32 missingBadges = 0;
    if (target->level + 5 > sBadgeLevels[badges]) {
        for (i = badges; i <= 8; i++) {
            if (target->level > sBadgeLevels[i]) {
                missingBadges++;
            }
        }
    }
    value = value * sMissingBadgePenalties[missingBadges] / CATCH_Q12_ONE / maxHpTimes3;

    // Step 6: low-level Pokemon are easier, (36 - 2 * level) / 10 up to 13.
    if (target->level <= 13) {
        value = (36 - 2 * target->level) * value / 10;
    }

    // Step 7: 2.5x for sleep or freeze, 1.5x for any other status.
    if (target->status & (STATUS_SLEEP | STATUS_FREEZE)) {
        value = CatchQMul64_RoundUp(value, 0x2800);
    } else if (target->status) {
        value = CatchQMul64_RoundUp(value, 0x1800);
    }

    // Step 8: the modified catch rate, at most 255.
    u32 modifiedCatchRate = value > 255 * CATCH_Q12_ONE ? 255 * CATCH_Q12_ONE : (u32)value;

    ctx->criticalCapture = BattleSystem_Random(bsys) % 256 < CriticalCaptureRate(bsys, modifiedCatchRate / CATCH_Q12_ONE);

    // Step 11: four shake checks against the table's chance, or one for a
    // critical throw -- which that one catches, and whose failure breaks free
    // without a shake, as the reference's DealWithCriticalCaptureShakes has it.
    u32 shakeChance = modifiedCatchRate == 255 * CATCH_Q12_ONE ? 0x10000 : sShakeChances[modifiedCatchRate / CATCH_Q12_ONE];
    s32 shakeCount;
    if (catchRate > 255) {
        shakeCount = BALL_SHAKE_MAX;
    } else {
        s32 shakeChecks = ctx->criticalCapture ? 1 : BALL_SHAKE_MAX;
        for (shakeCount = 0; shakeCount < shakeChecks; shakeCount++) {
            if (BattleSystem_Random(bsys) >= shakeChance) {
                break;
            }
        }
        if (ctx->criticalCapture) {
            if (shakeCount == 1) {
                shakeCount = BALL_SHAKE_MAX;
            } else {
                ctx->criticalCapture = FALSE;
            }
        }
    }
    if (shakeCount < BALL_SHAKE_MAX) {
        return shakeCount;
    }
    // Catching something already in the dex is shown as a critical throw.
    if (BattleSystem_CheckMonCaught(bsys, target->species) == TRUE) {
        ctx->criticalCapture = TRUE;
    }
    if (ctx->itemTemp == ITEM_FRIEND_BALL) {
        u8 friendship = FRIEND_BALL_FRIENDSHIP;
        SetMonData(BattleSystem_GetPartyMon(bsys, ctx->battlerIdTarget, 0), MON_DATA_FRIENDSHIP, &friendship);
    }
    return shakeCount;
}

static s32 GetMonWeight(u16 species) {
    s32 *weightList = GfGfxLoader_LoadFromNarc(NARC_application_zukanlist_zkn_data_zukan_data, 1, FALSE, HEAP_ID_3, TRUE);
    s32 weight = weightList[species];
    Heap_Free(weightList);
    return weight;
}

static int BattleSystem_GetBattlerIDBySide(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    int battlerID;
    BOOL ally = (side & BATTLER_RELATIVE_ALLY) != 0;

    side &= ~BATTLER_RELATIVE_ALLY;
    switch (side) {
    default:
    case BATTLER_CATEGORY_ATTACKER:
        battlerID = ctx->battlerIdAttacker;
        break;
    case BATTLER_CATEGORY_DEFENDER:
        battlerID = ctx->battlerIdTarget;
        break;
    case BATTLER_CATEGORY_FAINTED_MON:
        battlerID = ctx->battlerIdFainted;
        break;
    case BATTLER_CATEGORY_SWITCHED_MON:
    case BATTLER_CATEGORY_SWITCHED_MON_AFTER:
        battlerID = ctx->battlerIdSwitch;
        break;
    case BATTLER_CATEGORY_SIDE_EFFECT_MON:
        battlerID = ctx->battlerIdStatChange;
        break;
    case BATTLER_CATEGORY_ABILITY_MON:
        battlerID = ctx->battlerIdAbility;
        break;
    case BATTLER_CATEGORY_ENEMY: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (opponentData->battlerType & BATTLER_TYPE_IS_ENEMY) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_ENEMY_SLOT_1: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (opponentData->battlerType == BATTLER_TYPE_ENEMY_SIDE_SLOT_1 || opponentData->battlerType == BATTLER_TYPE_SOLO_ENEMY) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_ENEMY_SLOT_2: {
        int battlerType = BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES ? BATTLER_TYPE_ENEMY_SIDE_SLOT_2 : BATTLER_TYPE_SOLO_ENEMY;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (opponentData->battlerType == battlerType) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_PLAYER: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (!(opponentData->battlerType & BATTLER_TYPE_IS_ENEMY)) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_PLAYER_SLOT_1: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (opponentData->battlerType == BATTLER_TYPE_PLAYER_SIDE_SLOT_1 || opponentData->battlerType == BATTLER_TYPE_SOLO_PLAYER) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_PLAYER_SLOT_2: {
        int battlerType = BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES ? BATTLER_TYPE_PLAYER_SIDE_SLOT_2 : BATTLER_TYPE_SOLO_PLAYER;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            OpponentData *opponentData = BattleSystem_GetOpponentData(battleSystem, battlerID);
            if (opponentData->battlerType == battlerType) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_MSG_ATTACKER:
        battlerID = ctx->battlerIdLeechSeedRecv; // TODO: Rename these as part of BattleContext cleanup.
        break;
    case BATTLER_CATEGORY_MSG_DEFENDER:
        battlerID = ctx->battlerIdLeechSeeded;
        break;
    case BATTLER_CATEGORY_ATTACKER_PARTNER: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            if (battlerID != ctx->battlerIdAttacker
                && (BattleSystem_GetFieldSide(battleSystem, battlerID) == BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker))) {
                break;
            }
        }
        if (battlerID == maxBattlers) {
            battlerID = BATTLER_PLAYER;
        }
    } break;
    case BATTLER_CATEGORY_DEFENDER_PARTNER: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            if (battlerID != ctx->battlerIdTarget
                && BattleSystem_GetFieldSide(battleSystem, battlerID) == BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget)) {
                break;
            }
        }
        if (battlerID == maxBattlers) {
            battlerID = 0;
        }
    } break;
    case BATTLER_CATEGORY_ATTACKER_ENEMY: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        int attackerFieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            if (attackerFieldSide != BattleSystem_GetFieldSide(battleSystem, battlerID)) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_DEFENDER_ENEMY: {
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        int targetFieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);
        for (battlerID = 0; battlerID < maxBattlers; battlerID++) {
            if (targetFieldSide != BattleSystem_GetFieldSide(battleSystem, battlerID)) {
                break;
            }
        }
    } break;
    case BATTLER_CATEGORY_MSG_TEMP:
    case BATTLER_CATEGORY_MSG_BATTLER_TEMP:
        battlerID = ctx->battlerIdTemp;
        break;
    }

    if (battlerID == BATTLER_NONE) {
        GF_AssertFail();
    }

    // The ally is the battler two over, as the reference's BATTLER_ALLY has it.
    return ally ? (battlerID ^ 2) : battlerID;
}

static void InitBattleMsgData(BattleContext *ctx, BattleMessageData *msgData) {
    int params = 0;
#ifdef NEWGOLD_DIAG
    gDiagLastScriptMessage[1] = ctx->scriptNarcId;
    gDiagLastScriptMessage[2] = ctx->scriptFileId;
    gDiagLastScriptMessage[3] = ctx->scriptSeqNo;
#endif
    msgData->id = BattleScriptReadWord(ctx);
#ifdef NEWGOLD_DIAG
    gDiagLastScriptMessage[0] = msgData->id;
#endif
    msgData->tag = BattleScriptReadWord(ctx);
    switch (msgData->tag) {
    case TAG_NONE:
        params = 0;
        break;
    case TAG_NONE_SIDE:
    case TAG_NICKNAME:
    case TAG_MOVE:
    case TAG_STAT:
    case TAG_ITEM:
    case TAG_NUMBER:
    case TAG_NUMBERS:
    case TAG_TRNAME:
        params = 1;
        break;
    case TAG_NICKNAME_NICKNAME:
    case TAG_NICKNAME_MOVE:
    case TAG_NICKNAME_ABILITY:
    case TAG_NICKNAME_STAT:
    case TAG_NICKNAME_TYPE:
    case TAG_NICKNAME_POKE:
    case TAG_NICKNAME_ITEM:
    case TAG_NICKNAME_POFFIN:
    case TAG_NICKNAME_NUM:
    case TAG_NICKNAME_TRNAME:
    case TAG_NICKNAME_BOX:
    case TAG_MOVE_SIDE:
    case TAG_MOVE_NICKNAME:
    case TAG_MOVE_MOVE:
    case TAG_ABILITY_NICKNAME:
    case TAG_ITEM_MOVE:
    case TAG_NUMBER_NUMBER:
    case TAG_TRNAME_TRNAME:
    case TAG_TRNAME_NICKNAME:
    case TAG_TRNAME_ITEM:
    case TAG_TRNAME_NUM:
    case TAG_TRCLASS_TRNAME:
        params = 2;
        break;
    case TAG_NICKNAME_NICKNAME_MOVE:
    case TAG_NICKNAME_NICKNAME_ABILITY:
    case TAG_NICKNAME_NICKNAME_ITEM:
    case TAG_NICKNAME_MOVE_MOVE:
    case TAG_NICKNAME_MOVE_NUMBER:
    case TAG_NICKNAME_ABILITY_NICKNAME:
    case TAG_NICKNAME_ABILITY_MOVE:
    case TAG_NICKNAME_ABILITY_ITEM:
    case TAG_NICKNAME_ABILITY_STAT:
    case TAG_NICKNAME_ABILITY_TYPE:
    case TAG_NICKNAME_ABILITY_STATUS:
    case TAG_NICKNAME_ABILITY_NUMBER:
    case TAG_NICKNAME_ITEM_NICKNAME:
    case TAG_NICKNAME_ITEM_MOVE:
    case TAG_NICKNAME_ITEM_STAT:
    case TAG_NICKNAME_ITEM_STATUS:
    case TAG_NICKNAME_BOX_BOX:
    case TAG_ITEM_NICKNAME_FLAVOR:
    case TAG_TRNAME_NICKNAME_NICKNAME:
    case TAG_TRCLASS_TRNAME_NICKNAME:
    case TAG_TRCLASS_TRNAME_ITEM:
        params = 3;
        break;
    case TAG_NICKNAME_ABILITY_NICKNAME_MOVE:
    case TAG_NICKNAME_ABILITY_NICKNAME_ABILITY:
    case TAG_NICKNAME_ABILITY_NICKNAME_STAT:
    case TAG_NICKNAME_ITEM_NICKNAME_ITEM:
    case TAG_TRNAME_NICKNAME_TRNAME_NICKNAME:
    case TAG_TRCLASS_TRNAME_NICKNAME_NICKNAME:
    case TAG_TRCLASS_TRNAME_NICKNAME_TRNAME:
    case TAG_TRCLASS_TRNAME_TRCLASS_TRNAME:
        params = 4;
        break;
    case TAG_TRCLASS_TRNAME_NICKNAME_TRCLASS_TRNAME_NICKNAME:
        params = 6;
        break;
    }

    for (int i = 0; i < params; i++) {
        msgData->params[i] = BattleScriptReadWord(ctx);
    }
}

static void InitBattleMsg(BattleSystem *battleSystem, BattleContext *ctx, BattleMessageData *msgData, BattleMessage *msg) {
    msg->id = msgData->id;
    msg->tag = msgData->tag;
    switch (msg->tag) {
    case TAG_NONE_SIDE:
        msg->param[0] = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, msgData->params[0]);
        return;
    case TAG_NICKNAME:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        return;
    case TAG_MOVE:
        msg->param[0] = GetMoveMessageNo(ctx, msgData->params[0]);
        return;
    case TAG_STAT:
        msg->param[0] = ov12_022481D0(ctx, msgData->params[0]);
        return;
    case TAG_ITEM:
        msg->param[0] = ov12_0224810C(ctx, msgData->params[0]);
        return;
    case TAG_NUMBER:
    case TAG_NUMBERS:
        msg->param[0] = ov12_02248184(ctx, msgData->params[0]);
        return;
    case TAG_TRNAME:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        return;
    case TAG_NICKNAME_NICKNAME:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = GetMoveMessageNo(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_ABILITY:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_STAT:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022481D0(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_TYPE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248190(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_POKE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022481E8(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_ITEM:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_POFFIN:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248200(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_NUM:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248184(ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_TRNAME:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_BOX:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = msgData->params[1];
        return;
    case TAG_MOVE_SIDE:
        msg->param[0] = GetMoveMessageNo(ctx, msgData->params[0]);
        msg->param[1] = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_MOVE_NICKNAME:
        msg->param[0] = GetMoveMessageNo(ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_MOVE_MOVE:
        msg->param[0] = GetMoveMessageNo(ctx, msgData->params[0]);
        msg->param[1] = GetMoveMessageNo(ctx, msgData->params[1]);
        return;
    case TAG_ABILITY_NICKNAME:
        msg->param[0] = ov12_0224819C(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_ITEM_MOVE:
        msg->param[0] = ov12_0224810C(ctx, msgData->params[0]);
        msg->param[1] = GetMoveMessageNo(ctx, msgData->params[1]);
        return;
    case TAG_NUMBER_NUMBER:
        msg->param[0] = ov12_02248184(ctx, msgData->params[0]);
        msg->param[1] = ov12_02248184(ctx, msgData->params[1]);
        return;
    case TAG_TRNAME_TRNAME:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_TRNAME_NICKNAME:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_TRNAME_ITEM:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        return;
    case TAG_TRNAME_NUM:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248184(ctx, msgData->params[1]);
        return;
    case TAG_TRCLASS_TRNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        return;
    case TAG_NICKNAME_NICKNAME_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = GetMoveMessageNo(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_NICKNAME_ABILITY:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_0224819C(battleSystem, ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_NICKNAME_ITEM:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_0224810C(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_MOVE_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = GetMoveMessageNo(ctx, msgData->params[1]);
        msg->param[2] = GetMoveMessageNo(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_MOVE_NUMBER:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = GetMoveMessageNo(ctx, msgData->params[1]);
        msg->param[2] = ov12_02248184(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_NICKNAME:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = GetMoveMessageNo(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_ITEM:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_0224810C(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_STAT:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022481D0(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_TYPE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_02248190(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_STATUS:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022481DC(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_NUMBER:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_02248184(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ITEM_NICKNAME:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ITEM_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        msg->param[2] = GetMoveMessageNo(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ITEM_STAT:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        msg->param[2] = ov12_022481D0(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ITEM_STATUS:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        msg->param[2] = ov12_022481DC(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_BOX_BOX:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = msgData->params[1];
        msg->param[2] = msgData->params[2];
        return;
    case TAG_ITEM_NICKNAME_FLAVOR:
        msg->param[0] = ov12_0224810C(ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_0224820C(ctx, msgData->params[2]);
        return;
    case TAG_TRNAME_NICKNAME_NICKNAME:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        return;
    case TAG_TRCLASS_TRNAME_NICKNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        return;
    case TAG_TRCLASS_TRNAME_ITEM:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_0224810C(ctx, msgData->params[2]);
        return;
    case TAG_NICKNAME_ABILITY_NICKNAME_MOVE:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = GetMoveMessageNo(ctx, msgData->params[3]);
        return;
    case TAG_NICKNAME_ABILITY_NICKNAME_ABILITY:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_0224819C(battleSystem, ctx, msgData->params[3]);
        return;
    case TAG_NICKNAME_ABILITY_NICKNAME_STAT:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224819C(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_022481D0(ctx, msgData->params[3]);
        return;
    case TAG_NICKNAME_ITEM_NICKNAME_ITEM:
        msg->param[0] = ov12_022480C0(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_0224810C(ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_0224810C(ctx, msgData->params[3]);
        return;
    case TAG_TRNAME_NICKNAME_TRNAME_NICKNAME:
        msg->param[0] = ov12_02248220(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_022480C0(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_02248220(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_022480C0(battleSystem, ctx, msgData->params[3]);
        return;
    case TAG_TRCLASS_TRNAME_NICKNAME_NICKNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_022480C0(battleSystem, ctx, msgData->params[3]);
        return;
    case TAG_TRCLASS_TRNAME_NICKNAME_TRNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_02248220(battleSystem, ctx, msgData->params[3]);
        return;
    case TAG_TRCLASS_TRNAME_TRCLASS_TRNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_02248218(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_02248220(battleSystem, ctx, msgData->params[3]);
        return;
    case TAG_TRCLASS_TRNAME_NICKNAME_TRCLASS_TRNAME_NICKNAME:
        msg->param[0] = ov12_02248218(battleSystem, ctx, msgData->params[0]);
        msg->param[1] = ov12_02248220(battleSystem, ctx, msgData->params[1]);
        msg->param[2] = ov12_022480C0(battleSystem, ctx, msgData->params[2]);
        msg->param[3] = ov12_02248218(battleSystem, ctx, msgData->params[3]);
        msg->param[4] = ov12_02248220(battleSystem, ctx, msgData->params[4]);
        msg->param[5] = ov12_022480C0(battleSystem, ctx, msgData->params[5]);
        // fallthrough.
    }
}

static int ov12_022480C0(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    int battlerID = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    if (side == BATTLER_CATEGORY_SWITCHED_MON_AFTER) {
        return battlerID | (ctx->unk_21A0[battlerID] << 8);
    } else {
        return battlerID | (ctx->selectedMonIndex[battlerID] << 8);
    }
}

static int GetMoveMessageNo(BattleContext *ctx, int arg1) {
    switch (arg1) {
    case 1:
        return ctx->moveNoCur;
    case 255:
        return ctx->moveTemp;
    }
}

static int ov12_0224810C(BattleContext *ctx, int side) {
    int item;
    switch (side) {
    case BATTLER_CATEGORY_ATTACKER:
        item = ctx->battleMons[ctx->battlerIdAttacker].item;
        BattlerSetItem(ctx, ctx->battlerIdAttacker, item);
        break;
    case BATTLER_CATEGORY_DEFENDER:
        item = ctx->battleMons[ctx->battlerIdTarget].item;
        BattlerSetItem(ctx, ctx->battlerIdTarget, item);
        break;
    case BATTLER_CATEGORY_MSG_BATTLER_TEMP:
        item = ctx->battleMons[ctx->battlerIdTemp].item;
        BattlerSetItem(ctx, ctx->battlerIdTemp, item);
        break;
    case BATTLER_CATEGORY_MSG_TEMP:
        item = ctx->itemTemp;
        break;
    }
    return item;
}

static int ov12_02248184(BattleContext *ctx, int side) {
    if (side == 0xFF) {
        return ctx->msgTemp;
    }
}

static int ov12_02248190(BattleContext *ctx, int side) {
    if (side == 0xFF) {
        return ctx->msgTemp;
    }
}

static int ov12_0224819C(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    u32 ability;
    int battlerID;
    if (side == BATTLER_CATEGORY_MSG_TEMP) {
        ability = ctx->abilityTemp;
    } else {
        battlerID = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
        ability = ctx->battleMons[battlerID].ability;
        BattlerSetAbility(ctx, battlerID, ability);
    }
    return ability;
}

static int ov12_022481D0(BattleContext *ctx, int side) {
    if (side == BATTLER_CATEGORY_MSG_TEMP) {
        return ctx->msgTemp;
    }
}

static int ov12_022481DC(BattleContext *ctx, int side) {
    if (side == BATTLER_CATEGORY_MSG_TEMP) {
        return ctx->msgTemp;
    }
}

static int ov12_022481E8(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    u32 battlerID = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    return battlerID | ctx->selectedMonIndex[battlerID] << 8;
}

static int ov12_02248200(BattleContext *ctx, int side) {
    if (side == BATTLER_CATEGORY_MSG_TEMP) {
        return ctx->msgTemp;
    }
}

static int ov12_0224820C(BattleContext *ctx, int side) {
    if (side == BATTLER_CATEGORY_MSG_TEMP) {
        return ctx->msgTemp;
    }
}

static int ov12_02248218(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    return BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
}

static int ov12_02248220(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    return BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
}

enum {
    POINTER_LEVEL_UP_NAMEPLATE_FONT_SYSTEM = 0,
};

static void BattleSystem_LoadLevelUpNameplate(BattleSystem *battleSystem, GetterWork *data, Pokemon *mon) {
    Window window;
    UnkStruct_02021AC8 unkStruct;
    TextOBJTemplate textObjTemplate;
    MsgData *msgData;
    MessageFormat *messageFormat;
    String *messageBuffer;
    BgConfig *bgConfig;
    PaletteData *palData;
    SpriteManager *spriteManager;
    SpriteSystem *spriteSystem;
    String *string;

    msgData = BattleSystem_GetMessageLoader(battleSystem);
    messageBuffer = BattleSystem_GetMessageBuffer(battleSystem);
    messageFormat = BattleSystem_GetMessageFormat(battleSystem);
    bgConfig = BattleSystem_GetBgConfig(battleSystem);
    spriteSystem = BattleSystem_GetSpriteSystem(battleSystem);
    spriteManager = BattleSystem_GetSpriteManager(battleSystem);
    palData = BattleSystem_GetPaletteData(battleSystem);
    SpriteSystem_LoadCharResObj(spriteSystem, spriteManager, NARC_a_0_0_8, 256, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 20021);
    SpriteSystem_LoadPaletteBuffer(palData, PLTTBUF_MAIN_OBJ, spriteSystem, spriteManager, NARC_a_0_0_8, 82, 0, 2, NNS_G2D_VRAM_TYPE_2DMAIN, 20016);
    SpriteSystem_LoadCellResObj(spriteSystem, spriteManager, NARC_a_0_0_8, 257, 1, 20013);
    SpriteSystem_LoadAnimResObj(spriteSystem, spriteManager, NARC_a_0_0_8, 258, 1, 20013);
    data->unkC[0] = SpriteSystem_NewSprite(spriteSystem, spriteManager, &sLevelUpNameplateTemplate);
    ManagedSprite_TickFrame(data->unkC[0]);
    SpriteSystem_LoadCharResObjAtEndWithHardwareMappingType(spriteSystem, spriteManager, NARC_poketool_icongra_poke_icon, Pokemon_GetIconNaix(mon), 0, NNS_G2D_VRAM_TYPE_2DMAIN, 20022);
    SpriteSystem_LoadPaletteBuffer(palData, PLTTBUF_MAIN_OBJ, spriteSystem, spriteManager, NARC_poketool_icongra_poke_icon, sub_02074490(), 0, 3, NNS_G2D_VRAM_TYPE_2DMAIN, 20017);
    SpriteSystem_LoadCellResObj(spriteSystem, spriteManager, NARC_poketool_icongra_poke_icon, sub_0207449C(), 0, 20014);
    SpriteSystem_LoadAnimResObj(spriteSystem, spriteManager, NARC_poketool_icongra_poke_icon, sub_020744A8(), 0, 20014);
    data->unkC[1] = SpriteSystem_NewSprite(spriteSystem, spriteManager, &sPokeIconTemplate);
    Sprite_SetPalOffsetRespectVramOffset(data->unkC[1]->sprite, Pokemon_GetIconPalette(mon));
    ManagedSprite_TickFrame(data->unkC[1]);
    data->tempPointers[POINTER_LEVEL_UP_NAMEPLATE_FONT_SYSTEM] = FontSystem_NewInit(1, HEAP_ID_BATTLE);

    u32 gender;
    if (GetMonData(mon, MON_DATA_NO_PRINT_GENDER, NULL) == FALSE) { // Used for Nidoran.
        gender = MON_GENDERLESS;
    } else {
        gender = GetMonData(mon, MON_DATA_GENDER, NULL);
    }
    if (gender == MON_MALE) {
        string = NewString_ReadMsgData(msgData, msg_0197_00944); // {0} ♂ Lv. {1}
    } else if (gender == MON_FEMALE) {
        string = NewString_ReadMsgData(msgData, msg_0197_00945); // {0} ♀ Lv. {1}
    } else {
        string = NewString_ReadMsgData(msgData, msg_0197_00946); // {0} Lv. {1}
    }
    BufferBoxMonNickname(messageFormat, 0, Mon_GetBoxMon(mon));
    BufferIntegerAsString(messageFormat, 1, GetMonData(mon, MON_DATA_LEVEL, NULL), 3, PRINTING_MODE_LEFT_ALIGN, 1);
    StringExpandPlaceholders(messageFormat, messageBuffer, string);
    String_Delete(string);
    InitWindow(&window);
    AddTextWindowTopLeftCorner(bgConfig, &window, 12, 4, 0, 0);
    AddTextPrinterParameterizedWithColor(&window, 0, messageBuffer, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL); // Second param should be something like FONT_ID_0.
    sub_02021AC8(sub_02013688(&window, NNS_G2D_VRAM_TYPE_2DMAIN, 5), TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, &unkStruct);
    textObjTemplate.fontSystem = data->tempPointers[POINTER_LEVEL_UP_NAMEPLATE_FONT_SYSTEM];
    textObjTemplate.window = &window;
    textObjTemplate.spriteList = SpriteManager_GetSpriteList(spriteManager);
    textObjTemplate.plttResourceProxy = SpriteManager_FindPlttResourceProxy(spriteManager, 20016);
    textObjTemplate.offset = unkStruct.offset;
    textObjTemplate.sprite = NULL;
    textObjTemplate.x = 176;
    textObjTemplate.y = 8;
    textObjTemplate.unk_24 = 100;
    textObjTemplate.vram = 1;
    textObjTemplate.heapID = HEAP_ID_BATTLE;
    textObjTemplate.unk_20 = 0;
    data->unk14 = sub_020135D8(&textObjTemplate);
    data->unk18 = unkStruct;
    sub_020138E0(data->unk14, 1);
    RemoveWindow(&window);
}

static void BattleSystem_UnloadLevelUpNameplate(BattleSystem *battleSystem, GetterWork *data) {
    SpriteManager *spriteManager = BattleSystem_GetSpriteManager(battleSystem);
    Sprite_DeleteAndFreeResources(data->unkC[0]);
    Sprite_DeleteAndFreeResources(data->unkC[1]);
    FontOAM_Delete(data->unk14);
    sub_02021B5C(&data->unk18);
    SpriteManager_UnloadCharObjById(spriteManager, 0x4E35);
    SpriteManager_UnloadPlttObjById(spriteManager, 0x4E30);
    SpriteManager_UnloadCellObjById(spriteManager, 0x4E2D);
    SpriteManager_UnloadAnimObjById(spriteManager, 0x4E2D);
    SpriteManager_UnloadCharObjById(spriteManager, 0x4E36);
    SpriteManager_UnloadPlttObjById(spriteManager, 0x4E31);
    SpriteManager_UnloadCellObjById(spriteManager, 0x4E2E);
    SpriteManager_UnloadAnimObjById(spriteManager, 0x4E2E);
    sub_020135AC(data->tempPointers[POINTER_LEVEL_UP_NAMEPLATE_FONT_SYSTEM]);
}

static void UpdateFriendshipFainted(BattleSystem *battleSystem, BattleContext *ctx, int battlerID) {
    if (BattleSystem_GetFieldSide(battleSystem, battlerID) == 0) { // TODO: Side consts? Is this BATTLER_CATEGORY_ATTACKER?
        u8 enemyID;
        if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
            enemyID = BattleSystem_GetBattlerFromBattlerType(battleSystem, BATTLER_TYPE_ENEMY_SIDE_SLOT_1);
            u8 enemyID_slot2 = BattleSystem_GetBattlerFromBattlerType(battleSystem, BATTLER_TYPE_ENEMY_SIDE_SLOT_2);
            if (ctx->battleMons[enemyID_slot2].level > ctx->battleMons[enemyID].level) { // The penalty is incurred by the higher level opponent, regardless of which (if either) landed the finishing blow.
                enemyID = enemyID_slot2;
            }
        } else {
            enemyID = BattleSystem_GetBattlerFromBattlerType(battleSystem, BATTLER_TYPE_SOLO_ENEMY);
        }
        Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerID, ctx->selectedMonIndex[battlerID]);
        u8 playerLevel = ctx->battleMons[battlerID].level;
        u8 enemyLevel = ctx->battleMons[enemyID].level;
        if (enemyLevel > playerLevel) {
            if (enemyLevel - playerLevel >= 30) { // Incur a more severe friendship penalty if the enemy is 30+ levels higher.
                MonApplyFriendshipMod(mon, 8, BattleSystem_GetLocation(battleSystem));
                ApplyMonMoodModifier(mon, 6);
                return;
            }
            MonApplyFriendshipMod(mon, 6, BattleSystem_GetLocation(battleSystem));
            ApplyMonMoodModifier(mon, 4);
            return;
        }
        MonApplyFriendshipMod(mon, 6, BattleSystem_GetLocation(battleSystem));
        ApplyMonMoodModifier(mon, 4);
    }
}

// Retail's battle script commands end at 224. What follows carries the opcodes
// hg-engine gives the ones it adds, so that a script written against that
// engine assembles and runs here; each one is written from what the game needs
// rather than from how that engine writes it. A command whose turn has not
// come yet is BtlCmd_NotImplemented, which says so rather than running whatever
// happens to sit past the end of the table.

BOOL BtlCmd_NotImplemented(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    GF_ASSERT(FALSE);
    BattleScriptIncrementPointer(ctx, 1);
    return FALSE;
}

// Autotomize and the like. A Pokemon never weighs less than a tenth of a kilo.
BOOL BtlCmd_ReduceWeight(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int amount = BattleScriptReadWord(ctx);
    BattleMon *mon = &ctx->battleMons[ctx->battlerIdAttacker];

    if (amount >= mon->weight) {
        mon->weight = 1;
    } else {
        mon->weight -= amount;
    }

    return FALSE;
}

// Heavy Slam and Heat Crash: the lighter the target is against the attacker,
// the harder it lands. The ratio is kept to two decimal places so the bands
// fall where the later games put them.
BOOL BtlCmd_CalcHeavySlamPower(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int attacker = BattlerWeight(ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker);
    int target = BattlerWeight(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget);
    int ratio = attacker ? target * 10000 / attacker : 10000;

    if (ratio <= 2000) {
        ctx->movePower = 120;
    } else if (ratio <= 2500) {
        ctx->movePower = 100;
    } else if (ratio <= 3334) {
        ctx->movePower = 80;
    } else if (ratio <= 5000) {
        ctx->movePower = 60;
    } else {
        ctx->movePower = 40;
    }

    return FALSE;
}

BOOL BtlCmd_IsAttackerLevelLowerThanDefender(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdAttacker].level < ctx->battleMons[ctx->battlerIdTarget].level) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GotoIfMovePowerNotZero(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// The type the move will actually be used as, which is not always the type the
// table gives it.
BOOL BtlCmd_GotoIfCurrentAdjustedMoveIsType(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int type = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur) == type) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GotoIfContactMove(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (BattleMoveMakesContact(ctx, ctx->moveNoCur) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GotoIfSoundMove(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (BattleMoveIsSoundBased(ctx->moveNoCur) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Only in a double battle is there anyone to be the partner, and the message
// that follows names whoever is in battlerIdTemp.
BOOL BtlCmd_CheckTargetIsPartner(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battlerIdTarget == (ctx->battlerIdAttacker ^ 2)) {
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_DivideVarByValueRoundUp(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int varId = BattleScriptReadWord(ctx);
    int divisor = BattleScriptReadWord(ctx);
    int *data = BattleScriptGetVarPointer(battleSystem, ctx, varId);

    if (divisor != 0) {
        *data = (*data + divisor - 1) / divisor;
    }

    return FALSE;
}

// Tailwind is already a move this game has: the turns sit in the side's
// condition flags, the end-of-turn handler counts them down and announces the
// end, and the Speed is applied where Swift Swim's is. These two only have to
// read and write what is already there.
BOOL BtlCmd_SetTailwindCounter(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));

    ctx->fieldSideConditionFlags[fieldSide] |= SIDE_CONDITION_TAILWIND;

    return FALSE;
}

BOOL BtlCmd_GotoIfTailwindActive(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));

    if (ctx->fieldSideConditionFlags[fieldSide] & SIDE_CONDITION_TAILWIND) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

BOOL BtlCmd_GotoIfGrounded(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (BattlerIsGrounded(ctx, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side)) == TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Bind and the rest hold for four or five turns, seven with a Grip Claw
// (Pokemon Central, Legatutto; btl_scr_cmd_F7_setbindingcounter at d0380a487).
// The count lives in the target's status word and is counted down by the
// end-of-turn handler, which hurts the target while it has not reached 0 and
// lets it go when it does, so it is one more than the turns of damage: 5 or 6,
// or 8 -- one more than the word's three bits hold, which bindEighthTurn
// keeps. A target already held takes the branch instead.
BOOL BtlCmd_SetBindingTurns(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_BIND) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }

    int turns;
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_EXTEND_TRAPPING) {
        turns = 7;
        ctx->moveConditions[ctx->battlerIdTarget].bindEighthTurn = TRUE;
    } else {
        turns = 5 + (BattleSystem_Random(battleSystem) & 1);
        ctx->moveConditions[ctx->battlerIdTarget].bindEighthTurn = FALSE;
    }

    ctx->battleMons[ctx->battlerIdTarget].status2 |= turns << STATUS2_BINDING_SHIFT;
    ctx->battleMons[ctx->battlerIdTarget].unk88.battlerIdBinding = ctx->battlerIdAttacker;
    ctx->battleMons[ctx->battlerIdTarget].unk88.bindingMove = ctx->moveNoCur;
    // A Binding Band held as the bind begins makes every turn of it hurt more,
    // whatever becomes of the band afterwards (BindDamageDivisor).
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_TRAPPING_DAMAGE_UP) {
        ctx->bindingBandBinds |= MaskOfFlagNo(ctx->battlerIdTarget);
    } else {
        ctx->bindingBandBinds &= ~MaskOfFlagNo(ctx->battlerIdTarget);
    }

    return FALSE;
}

BOOL BtlCmd_ClearBindingTurns(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    ctx->battleMons[ctx->battlerIdAttacker].status2 &= ~STATUS2_BIND;

    return FALSE;
}

// Hitting yourself in confusion: forty power, physical, no type and no
// modifiers of any kind.
BOOL BtlCmd_CalcConfusionDamage(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);

    BattleMon *mon = &ctx->battleMons[ctx->battlerIdAttacker];
    u32 attack = BattleStatWithStage(mon->atk, mon->statChanges[1]);
    u32 defense = BattleStatWithStage(mon->def, mon->statChanges[2]);

    if (defense == 0) {
        defense = 1;
    }
    ctx->damage = ((2 * mon->level / 5 + 2) * 40 * attack / defense) / 50 + 2;

    return FALSE;
}

// Strength Sap takes as much as the target's Attack is worth.
BOOL BtlCmd_StrengthSapCalc(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleMon *mon = &ctx->battleMons[ctx->battlerIdTarget];
    ctx->hpCalc = -(int)BattleStatWithStage(mon->atk, mon->statChanges[1]);

    return FALSE;
}

// Clear Smog leaves the target as it came in.
BOOL BtlCmd_ClearSmog(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    for (int i = 0; i < NUM_BATTLE_STATS; i++) {
        ctx->battleMons[ctx->battlerIdTarget].statChanges[i] = 6;
    }

    return FALSE;
}

// A move that caught somebody on the way out. That is what this engine marks
// by giving the attacker the switch target and the pursuit action.
BOOL BtlCmd_IsPursuitActive(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (ctx->playerActions[ctx->battlerIdAttacker].command != CONTROLLER_COMMAND_40 || ctx->battlerIdTarget != ctx->battlerIdSwitch) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Put the turn back to just before the move was used, with nothing pending.
BOOL BtlCmd_GoBackToBeforeMove(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    ctx->unk_2170 = 0;
    ctx->unk_2174 = 0;
    ctx->command = CONTROLLER_COMMAND_23;
    ctx->commandNext = CONTROLLER_COMMAND_23;

    return FALSE;
}

// Roost puts a bird on the ground for the turn. This engine does that with a
// turn flag the type chart reads rather than by editing the Pokemon's types,
// so that is what this sets; the effect is the same and it undoes itself.
BOOL BtlCmd_HandleRoost(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    ctx->turnData[BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side)].roostFlag = TRUE;

    return FALSE;
}

// Soak and Magic Powder leave the target one type and nothing else: a type
// Forest's Curse or Trick-or-Treat added goes too (Pokemon Central,
// Inondazione, Magipolvere).
static void MakeBattlerPureType(BattleContext *ctx, int battlerId, u8 type) {
    ctx->battleMons[battlerId].type1 = type;
    ctx->battleMons[battlerId].type2 = type;
    ctx->battleMons[battlerId].type3 = TYPE_NONE;
}

// Burn Up and Double Shock spend a type to use the move. What is left of a
// Pokemon that was only that type is nothing: TYPE_MYSTERY, which the chart
// has no row for, so every move is neutral on it and none gets its STAB (the
// reference's RemoveType writes its TYPE_TYPELESS, the same type under its
// number; Pokemon Central, Ultima Fiamma, Doppiolampo). An added type is not
// theirs to take.
static void RemoveBattlerType(BattleContext *ctx, int battlerId, u8 type) {
    if (ctx->battleMons[battlerId].type1 == type && ctx->battleMons[battlerId].type2 == type) {
        ctx->battleMons[battlerId].type1 = TYPE_MYSTERY;
        ctx->battleMons[battlerId].type2 = TYPE_MYSTERY;
    } else if (ctx->battleMons[battlerId].type1 == type) {
        ctx->battleMons[battlerId].type1 = ctx->battleMons[battlerId].type2;
    } else if (ctx->battleMons[battlerId].type2 == type) {
        ctx->battleMons[battlerId].type2 = ctx->battleMons[battlerId].type1;
    }
}

// The reference's two also set soakFlag and magicPowderFlag, which only its
// end-of-turn Roost step reads (ENDTURN_ROOST_USERS_REGAINING_FLYING_TYPE):
// its Roost takes the Flying type out of type1 and type2, and at the turn's
// end writes the species' types back unless one of the two landed since. Here
// Roost changes no type (BtlCmd_HandleRoost), so there is nothing to write
// back and nothing for a flag to stop: the new type lasts as it is.
BOOL BtlCmd_HandleSoak(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    MakeBattlerPureType(ctx, ctx->battlerIdTarget, TYPE_WATER);

    return FALSE;
}

BOOL BtlCmd_HandleMagicPowder(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    MakeBattlerPureType(ctx, ctx->battlerIdTarget, TYPE_PSYCHIC);

    return FALSE;
}

BOOL BtlCmd_HandleBurnUp(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    RemoveBattlerType(ctx, ctx->battlerIdAttacker, TYPE_FIRE);

    return FALSE;
}

BOOL BtlCmd_HandleDoubleShock(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    RemoveBattlerType(ctx, ctx->battlerIdAttacker, TYPE_ELECTRIC);

    return FALSE;
}

// Incinerate burns the berry the target was holding. Sticky Hold keeps hold of
// it, and there is nothing to burn if the target was not holding one; either
// way the move has nothing to say and takes the branch.
BOOL BtlCmd_TryIncinerate(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int item = ctx->battleMons[ctx->battlerIdTarget].item;

    if (!BattleItemIsBerry(item)) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD) == TRUE && ctx->battleMons[ctx->battlerIdTarget].hp) {
        BattleScriptIncrementPointer(ctx, adrs);
        return FALSE;
    }

    ctx->itemTemp = item;
    ctx->battlerIdTemp = ctx->battlerIdTarget;
    // Burnt, not knocked off: there is nothing left for Recycle to find.
    ctx->battleMons[ctx->battlerIdTarget].item = ITEM_NONE;

    return FALSE;
}

// Competitive, and Defiant when it exists. The drop that provoked it marked
// the Pokemon on its way through BtlCmd_ChangeStatStage; this decides whether
// there is still anything to raise.
BOOL BtlCmd_CheckCanActivateDefiantOrCompetitive(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int failAdrs = BattleScriptReadWord(ctx);
    int defiantAdrs = BattleScriptReadWord(ctx);
    int competitiveAdrs = BattleScriptReadWord(ctx);
    BattleMon *mon = &ctx->battleMons[ctx->battlerIdStatChange];

    if (mon->hp && mon->competitivePending && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN)) {
        mon->competitivePending = FALSE;
        if (GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_COMPETITIVE && mon->statChanges[4] < 12) {
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            BattleScriptIncrementPointer(ctx, competitiveAdrs);
            return FALSE;
        }
        if (GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_DEFIANT && mon->statChanges[1] < 12) {
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            BattleScriptIncrementPointer(ctx, defiantAdrs);
            return FALSE;
        }
    }

    BattleScriptIncrementPointer(ctx, failAdrs);

    return FALSE;
}

// Sticky Web is laid over the far side and stays until something clears it.
// A second one fails, and the script says so.
BOOL BtlCmd_TryStickyWeb(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    if (ctx->fieldSideConditionFlags[fieldSide] & SIDE_CONDITION_STICKY_WEB) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->fieldSideConditionFlags[fieldSide] |= SIDE_CONDITION_STICKY_WEB;
    }

    return FALSE;
}

// Aurora Veil stands for five turns, eight with Light Clay, and is counted
// down beside Reflect and Light Screen.
BOOL BtlCmd_TryAuroraVeil(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    ctx->fieldSideConditionFlags[fieldSide] |= SIDE_CONDITION_AURORA_VEIL;
    ctx->fieldSideConditionData[fieldSide].auroraVeilBattler = ctx->battlerIdAttacker;
    ctx->fieldSideConditionData[fieldSide].auroraVeilTurns = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_EXTEND_SCREENS ? 8 : 5;

    return FALSE;
}

BOOL BtlCmd_ClearAuroraVeil(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int fieldSide = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdTarget);

    ctx->fieldSideConditionFlags[fieldSide] &= ~SIDE_CONDITION_AURORA_VEIL;
    ctx->fieldSideConditionData[fieldSide].auroraVeilTurns = 0;

    return FALSE;
}

// What a shield hands back to a move that touched it, as the reference's
// btl_scr_cmd_103_checkprotectcontactmoves (battle_script_commands.c): King's
// Shield lowers Attack a stage (two before generation eight, and the
// reference is nine), Spiky Shield takes an eighth of the attacker's HP,
// Baneful Bunker poisons, Obstruct lowers Defence two stages, Silk Trap Speed
// a stage, Burning Bulwark burns. Only when the move made contact, the
// attacker is still standing, the shield is the target's own rather than a
// team guard its ally lent, and the move is not on its charging turn.
//
// The reference sets attack_client to the Bunker's user before the poison, so
// that the poison subscript asks the Bunker's user for Corrosion, and never
// sets it back: the rest of the turn then runs with the defender as the
// attacker. That is not copied. The attacker stays the attacker, so the
// subscript would ask the attacker's own Corrosion; a Poison or Steel attacker
// is simply not poisoned here. Only Mareanie and Toxapex learn the move and
// neither can have Corrosion, so what that gives up is a Corrosion copied onto
// a Bunker user in battle.
BOOL BtlCmd_CheckProtectContactMoves(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    int attacker = ctx->battlerIdAttacker;
    int target = ctx->battlerIdTarget;

    BattleScriptIncrementPointer(ctx, 1);

    if (BattleMoveMakesContact(ctx, ctx->moveNoCur) != TRUE
        || ctx->battleMons[attacker].hp == 0
        || ctx->turnData[target].gainedProtectFlagFromAlly
        || (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN)) {
        return FALSE;
    }

    switch (ctx->moveNoProtect[target]) {
    case MOVE_KINGS_SHIELD:
        if (ctx->battleMons[attacker].statChanges[STAT_ATK] > 0) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
            ctx->battlerIdStatChange = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
        }
        break;
    case MOVE_SPIKY_SHIELD:
        if (GetBattlerAbility(ctx, attacker) != ABILITY_MAGIC_GUARD) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[attacker].maxHp * -1, 8);
            ctx->battlerIdTemp = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_SPIKY_SHIELD);
        }
        break;
    case MOVE_BANEFUL_BUNKER: {
        BOOL poisonProof = GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_1, NULL) == TYPE_POISON
            || GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_2, NULL) == TYPE_POISON
            || GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_1, NULL) == TYPE_STEEL
            || GetBattlerVar(ctx, attacker, BMON_DATA_TYPE_2, NULL) == TYPE_STEEL;
        if (ctx->battleMons[attacker].status == 0 && !poisonProof) {
            ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
            ctx->battlerIdStatChange = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_POISON);
        }
        break;
    }
    case MOVE_OBSTRUCT:
        if (ctx->battleMons[attacker].statChanges[STAT_DEF] > 0) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_2_STAGES;
            ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
            ctx->battlerIdStatChange = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
        }
        break;
    case MOVE_SILK_TRAP:
        if (ctx->battleMons[attacker].statChanges[STAT_SPEED] > 0) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
            ctx->battlerIdStatChange = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
        }
        break;
    case MOVE_BURNING_BULWARK:
        if (ctx->battleMons[attacker].status == 0) {
            ctx->statChangeType = SIDE_EFFECT_TYPE_MOVE_EFFECT;
            ctx->battlerIdStatChange = attacker;
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_BURN);
        }
        break;
    default:
        break;
    }

    return FALSE;
}

// Bookkeeping for the ability popup. This game has no popup to show, so the
// flag is kept and the showing of it is where the two engines part company.
BOOL BtlCmd_SetAbilityActivatedFlag(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);

    ctx->battleMons[BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side)].abilityActivatedFlag = TRUE;

    return FALSE;
}

// The later games put a banner on screen naming the ability. This one says so
// in the message the script goes on to print, so there is nothing to draw,
// and nothing else to do: the reference's command only draws. The battler's
// abilityActivatedFlag is not this command's to touch -- it is what makes a
// Surge, Wind Power or Protean act once an appearance, and clearing it here
// sent a Surge's entry round again after its own announcement, for ever.
BOOL BtlCmd_AbilityPopup(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);

    return FALSE;
}

// Powder, Laser Focus, Glaive Rush and Throat Chop are the moves this records
// something for, and this game has none of them, so there is never anything
// to record. The arguments are still read: the script has written them.
// The moves Instruct cannot have used again: itself, the ones that wait for
// something or call another, the ones that charge or must recharge, and
// those that copy (Pokemon Central, Imposizione).
static const u16 sMovesInstructCannotRepeat[] = {
    MOVE_INSTRUCT,
    MOVE_BIDE,
    MOVE_FOCUS_PUNCH,
    MOVE_BEAK_BLAST,
    MOVE_SHELL_TRAP,
    MOVE_SKETCH,
    MOVE_TRANSFORM,
    MOVE_MIMIC,
    MOVE_KINGS_SHIELD,
    MOVE_STRUGGLE,
};

static const u16 sEffectsInstructCannotRepeat[] = {
    MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT,
    MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH,
    MOVE_EFFECT_RECHARGE_AFTER,
    MOVE_EFFECT_CHARGE_TURN_DEF_UP,
    MOVE_EFFECT_151,
    MOVE_EFFECT_FLY,
    MOVE_EFFECT_DIVE,
    MOVE_EFFECT_DIG,
    MOVE_EFFECT_BOUNCE,
    MOVE_EFFECT_SHADOW_FORCE,
    MOVE_EFFECT_CHARGE_TURN_ATK_SP_ATK_SPEED_UP_2,
    MOVE_EFFECT_CHARGE_TURN_SP_ATK_UP,
    MOVE_EFFECT_CHARGE_TURN_SP_ATK_UP_RAIN_SKIPS,
    MOVE_EFFECT_CHARGE_TURN_PARALYZE_HIT,
    MOVE_EFFECT_CHARGE_TURN_BURN_HIT,
    MOVE_EFFECT_SKY_DROP,
};

static BOOL MoveCanBeInstructed(BattleContext *ctx, u16 move) {
    int i;

    if (move == MOVE_NONE || CheckMoveCallsOtherMove(move) == TRUE) {
        return FALSE;
    }
    for (i = 0; i < NELEMS(sMovesInstructCannotRepeat); i++) {
        if (move == sMovesInstructCannotRepeat[i]) {
            return FALSE;
        }
    }
    for (i = 0; i < NELEMS(sEffectsInstructCannotRepeat); i++) {
        if (BattleMoveTbl(ctx, move)->effect == sEffectsInstructCannotRepeat[i]) {
            return FALSE;
        }
    }
    return TRUE;
}

static void SwapBytes(void *x, void *y, u32 size) {
    u8 *p = x;
    u8 *q = y;
    u8 byte;

    while (size--) {
        byte = *p;
        *p++ = *q;
        *q++ = byte;
    }
}

// The one of a and b that battlerId is not, or battlerId if it is neither.
static int OtherOfPair(int battlerId, int a, int b) {
    return battlerId == a ? b : (battlerId == b ? a : battlerId);
}

// A battler mask with the bits of a and b exchanged.
static u32 SwapMaskBits(u32 mask, int a, int b) {
    u32 bits = mask & (MaskOfFlagNo(a) | MaskOfFlagNo(b));

    if (bits != 0 && bits != (MaskOfFlagNo(a) | MaskOfFlagNo(b))) {
        mask ^= MaskOfFlagNo(a) | MaskOfFlagNo(b);
    }
    return mask;
}

// A field of the context that Ally Switch has to see to: where it is, how
// wide one is (1, 2 or 4 bytes; for an array a Pokemon owns, one entry), and
// how far apart its four battlers' are (0 for one field about the battle).
typedef struct BattlerField {
    u16 offset;
    u8 width;
    u8 stride;
} BattlerField;

#define PER_BATTLER(field) { offsetof(BattleContext, field), sizeof(((BattleContext *)0)->field[0]), 0 }
#define IN_EACH(array, type, field) { offsetof(BattleContext, array) + offsetof(type, field), sizeof(((type *)0)->field), sizeof(type) }
#define IN_ARRAY(field) { offsetof(BattleContext, field), sizeof(((BattleContext *)0)->field[0]), sizeof(((BattleContext *)0)->field[0]) }
#define ONCE(field) { offsetof(BattleContext, field), sizeof(((BattleContext *)0)->field), 0 }

// The arrays kept by battler whose entries belong to the Pokemon.
static const BattlerField sPokemonArrays[] = {
    PER_BATTLER(battleMons),
    PER_BATTLER(turnData),
    PER_BATTLER(selfTurnData),
    PER_BATTLER(moveFail),
    PER_BATTLER(moveConditions),
    PER_BATTLER(playerActions),
    PER_BATTLER(selectedMonIndex),
    PER_BATTLER(unk_21A0),
    PER_BATTLER(unk_13C),
    PER_BATTLER(unk_218C),
    PER_BATTLER(movePos),
    PER_BATTLER(unk_30B4),
    PER_BATTLER(moveNoLockedInto),
    PER_BATTLER(moveNoProtect),
    PER_BATTLER(moveNoHit),
    PER_BATTLER(moveNoHitBattler),
    PER_BATTLER(moveNoHitType),
    PER_BATTLER(moveNoBattlerPrev),
    PER_BATTLER(moveNoCopied),
    PER_BATTLER(moveNoCopiedHit),
    PER_BATTLER(moveNoSketch),
    PER_BATTLER(conversion2Move),
    PER_BATTLER(conversion2BattlerId),
    PER_BATTLER(conversion2Type),
    PER_BATTLER(moveNoMetronome),
    PER_BATTLER(unk_30E4),
    PER_BATTLER(unk_30F4),
    PER_BATTLER(effectiveSpeed),
    PER_BATTLER(trainerAIAbilities),
    PER_BATTLER(trainerAIData.moves),
    PER_BATTLER(trainerAIData.heldItems),
    PER_BATTLER(protectSuccessTurns),
    PER_BATTLER(psychicTerrainMoveUsed),
    PER_BATTLER(paradoxBoostedStat),
    PER_BATTLER(boosterEnergyActivated),
    PER_BATTLER(cudChewBerry),
    PER_BATTLER(cudChewTurn),
    PER_BATTLER(supremeOverlordFallen),
    PER_BATTLER(mimicryTerrain),
    PER_BATTLER(opportunistStages),
    PER_BATTLER(symbiosisPending),
    PER_BATTLER(mirrorHerbStages),
};

// The fields that name a Pokemon by its battler.
static const BattlerField sBattlerIds[] = {
    IN_ARRAY(moveNoHitBattler),
    IN_ARRAY(conversion2BattlerId),
    IN_ARRAY(unk_30F4),
    IN_ARRAY(turnOrder),
    IN_ARRAY(executionOrder),
    IN_ARRAY(fieldConditionData.battlerIdFutureSight),
    IN_EACH(turnData, TurnData, battlerIdPhysicalDamage),
    IN_EACH(turnData, TurnData, battlerIdSpecialDamage),
    IN_EACH(selfTurnData, SelfTurnData, battlerIdPhysicalAttacker),
    IN_EACH(selfTurnData, SelfTurnData, battlerIdSpecialAttacker),
    ONCE(battlerIdAttacker),
    ONCE(battlerIdAttackerTemp),
    ONCE(battlerIdTarget),
    ONCE(battlerIdTargetTemp),
    ONCE(battlerIdStatChange),
    ONCE(battlerIdTemp),
    ONCE(battlerIdMagicCoat),
    ONCE(danceUser),
    ONCE(danceTarget),
};

// The masks with a bit for each battler's Pokemon.
static const BattlerField sBattlerMasks[] = {
    IN_EACH(turnData, TurnData, battlerBitPhysicalDamage),
    IN_EACH(turnData, TurnData, battlerBitSpecialDamage),
    ONCE(switchInFlag),
    ONCE(roundUsers),
    ONCE(statLoweredBattlers),
    ONCE(statRaisedBattlers),
    ONCE(teraShellResisting),
    ONCE(dancersPending),
    ONCE(bindingBandBinds),
    ONCE(strongWindsWeakened),
};

#undef PER_BATTLER
#undef IN_EACH
#undef IN_ARRAY
#undef ONCE

static u32 ReadBattlerField(const u8 *p, int width) {
    return width == 1 ? *p : (width == 2 ? *(const u16 *)p : *(const u32 *)p);
}

static void WriteBattlerField(u8 *p, int width, u32 value) {
    if (width == 1) {
        *p = value;
    } else if (width == 2) {
        *(u16 *)p = value;
    } else {
        *(u32 *)p = value;
    }
}

// The Pokemon of a and b change places (Ally Switch). What belongs to a
// Pokemon goes with it: its battle data and party slot, its stages and
// conditions, what it chose and did this turn, its place in the turn's
// order, what the AI has seen of it; and whatever names it by its battler --
// a bind, a Mean Look or an Octolock, a Lock-On, an infatuation, a Syrup
// Bomb, an Uproar, the last Pokemon to hit something, Follow Me -- is told
// its new one. What belongs to a place stays there: the target another
// Pokemon chose, a Wish, a Future Sight on its way, the Leech Seed that feeds
// the place's Pokemon (Pokemon Central, Cambiaposto). Stalwart, Propeller
// Tail and Snipe Shot aim at the Pokemon, not the place, and follow it.
static void Battlers_SwapPlaces(BattleContext *ctx, int a, int b) {
    u8 *base = (u8 *)ctx;
    const BattlerField *field;
    u8 slots[2];
    int i, j, count;

    slots[0] = ctx->selectedMonIndex[a];
    slots[1] = ctx->selectedMonIndex[b];
    for (field = sPokemonArrays; field < sPokemonArrays + NELEMS(sPokemonArrays); field++) {
        SwapBytes(base + field->offset + a * field->width, base + field->offset + b * field->width, field->width);
    }
    for (field = sBattlerIds; field < sBattlerIds + NELEMS(sBattlerIds); field++) {
        count = field->stride ? BATTLER_MAX : 1;
        for (i = 0; i < count; i++) {
            u8 *p = base + field->offset + i * field->stride;
            WriteBattlerField(p, field->width, OtherOfPair(ReadBattlerField(p, field->width), a, b));
        }
    }
    for (field = sBattlerMasks; field < sBattlerMasks + NELEMS(sBattlerMasks); field++) {
        count = field->stride ? BATTLER_MAX : 1;
        for (i = 0; i < count; i++) {
            u8 *p = base + field->offset + i * field->stride;
            WriteBattlerField(p, field->width, SwapMaskBits(ReadBattlerField(p, field->width), a, b));
        }
    }
    // Kept by battler and party slot: the two Pokemon's own entries move.
    for (j = 0; j < 2; j++) {
        SwapBytes(&ctx->onceOnlyEntryAbilityDone[a][slots[j]], &ctx->onceOnlyEntryAbilityDone[b][slots[j]], 1);
        SwapBytes(&ctx->berryEaten[a][slots[j]], &ctx->berryEaten[b][slots[j]], 1);
        SwapBytes(&ctx->rageFistHits[a][slots[j]], &ctx->rageFistHits[b][slots[j]], 1);
        ctx->fieldSideConditionData[j].battlerIdFollowMe = OtherOfPair(ctx->fieldSideConditionData[j].battlerIdFollowMe, a, b);
    }
    for (i = 0; i < BATTLER_MAX; i++) {
        BattleMon *mon = &ctx->battleMons[i];

        mon->unk88.battlerIdLockOn = OtherOfPair(mon->unk88.battlerIdLockOn, a, b);
        mon->unk88.battlerIdBinding = OtherOfPair(mon->unk88.battlerIdBinding, a, b);
        mon->unk88.battlerIdMeanLook = OtherOfPair(mon->unk88.battlerIdMeanLook, a, b);
        mon->status2 = (mon->status2 & ~STATUS2_ATTRACT)
            | (SwapMaskBits((mon->status2 & STATUS2_ATTRACT) >> STATUS2_ATTRACT_SHIFT, a, b) << STATUS2_ATTRACT_SHIFT);
        ctx->moveConditions[i].syrupBombUser = OtherOfPair(ctx->moveConditions[i].syrupBombUser, a, b);
        if (ctx->moveConditions[i].skyDropHolder) {
            ctx->moveConditions[i].skyDropHolder = OtherOfPair(ctx->moveConditions[i].skyDropHolder - 1, a, b) + 1;
        }
        SwapBytes(&ctx->moveNoCopiedHit[i][a], &ctx->moveNoCopiedHit[i][b], sizeof(u16));
        SwapBytes(&ctx->turnData[i].physicalDamage[a], &ctx->turnData[i].physicalDamage[b], sizeof(int));
        SwapBytes(&ctx->turnData[i].specialDamage[a], &ctx->turnData[i].specialDamage[b], sizeof(int));
        if (GetBattlerAbility(ctx, i) == ABILITY_STALWART || GetBattlerAbility(ctx, i) == ABILITY_PROPELLER_TAIL || ctx->unk_30B4[i] == MOVE_SNIPE_SHOT) {
            ctx->playerActions[i].unk4 = OtherOfPair(ctx->playerActions[i].unk4, a, b);
        }
    }
    ctx->fieldCondition = (ctx->fieldCondition & ~FIELD_CONDITION_UPROAR)
        | (SwapMaskBits((ctx->fieldCondition & FIELD_CONDITION_UPROAR) >> FIELD_CONDITION_UPROAR_SHIFT, a, b) << FIELD_CONDITION_UPROAR_SHIFT);
    // The party list shows the Pokemon in the order of their places.
    SwapBytes(&ctx->unk_312C[a & 1][0], &ctx->unk_312C[a & 1][1], 1);
}

// The Pledges' kinds, each beaten by the one before it on the type chart's
// round -- Water puts out Fire, Fire burns Grass, Grass drinks Water -- and
// the type of the move two of them make, the one that wins; 0 is no Pledge.
static int PledgeKind(u16 move) {
    switch (move) {
    case MOVE_WATER_PLEDGE:
        return 1;
    case MOVE_FIRE_PLEDGE:
        return 2;
    case MOVE_GRASS_PLEDGE:
        return 3;
    }
    return 0;
}

static const u8 sPledgeTypes[] = { TYPE_NORMAL, TYPE_WATER, TYPE_FIRE, TYPE_GRASS };

// What a Pledge does as it is used (Pokemon Central, Acquapatto, Fiammapatto,
// Erbapatto). 2: an ally's Pledge waited on this one, and this is the
// combined move, of 150 and the type of the Pledge that wins. 1: an ally
// still to move this turn has chosen another Pledge; it goes next, whatever
// its speed or item, and this one waits. 0: a Pledge alone.
static int TryPledgeCombination(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int ally = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    int kind = PledgeKind(ctx->moveNoCur);
    int allyKind = PledgeKind(GetBattlerSelectedMove(ctx, ally));

    // The mark is spent on the one Pledge it waited for, whether that hits
    // or not: a second Pledge in the same turn (Instruct) has no ally's
    // waiting on it, and is a Pledge alone.
    if (ctx->turnData[battlerId].pledgeCombination) {
        ctx->selfTurnData[battlerId].combinedPledge = ctx->turnData[battlerId].pledgeCombination;
        ctx->turnData[battlerId].pledgeCombination = 0;
        ctx->movePower = 150;
        ctx->moveType = sPledgeTypes[ctx->selfTurnData[battlerId].combinedPledge];
        return 2;
    }
    if (ally != battlerId && ctx->battleMons[ally].hp && ov12_0225561C(ctx, ally) == FALSE
        && !ctx->turnData[ally].struggleFlag && allyKind && allyKind != kind) {
        ctx->turnData[ally].pledgeCombination = allyKind == kind % 3 + 1 ? kind : allyKind;
        ctx->turnData[ally].forceExecutionOrder = EXECUTION_ORDER_AFTER_YOU;
        return 1;
    }
    return 0;
}

// A combined Pledge leaves its condition with the hit, for four turns' ends,
// this one's counted: the rainbow over the user's side, the sea of fire or
// the swamp around the target's; one already there stays as it is (Pokemon
// Central, Acquapatto, Fiammapatto, Erbapatto). With the hit, not once the
// move is over: the condition's line comes before a fainted target's, as
// Showdown's gen-9 moveHit lays a side condition. MSG_TEMP says which for
// subscript 465, and the return whether one was laid.
static BOOL LeavePledgeCondition(BattleContext *ctx, int battlerId) {
    int combination = ctx->selfTurnData[battlerId].combinedPledge;
    int shift = SIDE_CONDITION_RAINBOW_SHIFT + 3 * (combination - 1);
    int side;

    if (!combination) {
        return FALSE;
    }
    ctx->battlerIdTemp = combination == 1 ? battlerId : ctx->battlerIdTarget;
    side = ctx->battlerIdTemp & 1;
    if (ctx->fieldSideConditionFlags[side] & (7 << shift)) {
        return FALSE;
    }
    ctx->fieldSideConditionFlags[side] |= 4 << shift;
    ctx->msgTemp = combination - 1;
    return TRUE;
}

// Ally Switch works in a double battle that is not a multi battle, beside an
// ally that is standing, and not once that ally has switched places this
// turn; used in a row it works one try in 3^n, as Protect does, the count
// kept apart from Protect's (Pokemon Central, Cambiaposto).
static BOOL AllySwitchWorks(BattleSystem *battleSystem, BattleContext *ctx) {
    int user = ctx->battlerIdAttacker;
    int ally = BattleSystem_GetBattlerIdPartner(battleSystem, user);
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (ctx->moveNoProtect[user] != MOVE_ALLY_SWITCH) {
        ctx->protectSuccessTurns[user] = 0;
    }
    if (!(battleType & BATTLE_TYPE_DOUBLES) || (battleType & (BATTLE_TYPE_MULTI | BATTLE_TYPE_TAG)) || ally == user
        || !ctx->battleMons[ally].hp || ctx->turnData[ally].allySwitched
        || BattleSystem_Random(battleSystem) % sProtectSuccessChance[ctx->protectSuccessTurns[user]] != 0) {
        ctx->protectSuccessTurns[user] = 0;
        return FALSE;
    }
    if (ctx->protectSuccessTurns[user] < NELEMS(sProtectSuccessChance) - 1) {
        ctx->protectSuccessTurns[user]++;
    }
    ctx->turnData[user].allySwitched = TRUE;
    return TRUE;
}

// Revival Blessing (Pokemon Central, Preghiera Vitale), in two steps on its
// user. First, whether the user's party has a fainted Pokemon to revive, an
// Egg aside: if so the user is marked as picking one, for BtlCmd_ShowParty to
// open the party menu to and the AI's pick (ov12_0225F8AC) to take the first,
// and 1; the move fails without one. Then, the one picked (WaitMonSelection
// left it in unk_21A0) is revived with half its maximum HP, rounded down, and
// no status. In a double battle, a Pokemon whose own place stands empty goes
// back into it at once: 1, with the place in battlerIdSwitch for the script
// to send it out; 0 otherwise.
static int RevivalBlessingStep(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int slot;
    int partner;
    u32 value;
    Pokemon *mon;

    if (!ctx->selfTurnData[battlerId].revivalBlessing) {
        for (slot = 0; slot < BattleSystem_GetPartySize(battleSystem, battlerId); slot++) {
            mon = BattleSystem_GetPartyMon(battleSystem, battlerId, slot);
            value = GetMonData(mon, MON_DATA_SPECIES_OR_EGG, NULL);
            if (value != SPECIES_NONE && value != SPECIES_EGG && GetMonData(mon, MON_DATA_HP, NULL) == 0) {
                ctx->selfTurnData[battlerId].revivalBlessing = TRUE;
                ctx->unk_13C[battlerId] |= 1;
                return 1;
            }
        }
        return 0;
    }

    slot = ctx->unk_21A0[battlerId];
    ctx->selfTurnData[battlerId].revivalBlessing = FALSE;
    ctx->unk_13C[battlerId] &= ~1;
    ctx->unk_21A0[battlerId] = 6;
    if (slot >= BattleSystem_GetPartySize(battleSystem, battlerId)) {
        return 0;
    }
    mon = BattleSystem_GetPartyMon(battleSystem, battlerId, slot);
    value = GetMonData(mon, MON_DATA_MAX_HP, NULL) / 2;
    if (value == 0) {
        value = 1;
    }
    SetMonData(mon, MON_DATA_HP, &value);
    value = 0;
    SetMonData(mon, MON_DATA_STATUS, &value);

    partner = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
    if (partner != battlerId && BattleSystem_GetParty(battleSystem, partner) == BattleSystem_GetParty(battleSystem, battlerId)
        && ctx->selectedMonIndex[partner] == slot && ctx->battleMons[partner].hp == 0) {
        ctx->battlerIdSwitch = partner;
        ctx->unk_21A0[partner] = slot;
        return 1;
    }
    return 0;
}

// Sky Drop, on the battler it is aimed at, in the three steps of its two
// turns (Pokemon Central, Cadutalibera), told apart by where its user is:
//  - before the lift, from effect script 445, whether the target can be
//    lifted: 0 not an ally, not one behind a substitute or already in the
//    air or underground; 2 not one of 200 kg or more, Heavy Metal, Light
//    Metal and a Float Stone counted; 1 it can;
//  - the lift, from subscript 470 once the move has got through and the user
//    is locked into it: both go up out of reach, the target held
//    (Battler_HeldBySkyDrop) and marked as up there, so that its sprite comes
//    back when it is let go;
//  - the drop, from effect script 445 on the second turn: the target comes
//    down before the hit, so the accuracy of that turn is the only one the
//    move has.
static int SkyDropStep(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int attacker = ctx->battlerIdAttacker;

    if (!(ctx->battleMons[attacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
        if (BattleSystem_GetFieldSide(battleSystem, attacker) == BattleSystem_GetFieldSide(battleSystem, battlerId)
            || BattlerCheckSubstitute(ctx, battlerId)
            || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_SEMI_INVULNERABLE)) {
            return 0;
        }
        return BattlerWeight(ctx, attacker, battlerId) >= 2000 ? 2 : 1;
    }
    if (ctx->moveConditions[battlerId].skyDropHolder != attacker + 1) {
        ctx->battleMons[attacker].moveEffectFlags |= MOVE_EFFECT_FLAG_FLY;
        ctx->battleMons[battlerId].moveEffectFlags |= MOVE_EFFECT_FLAG_FLY;
        ctx->battleMons[battlerId].moveEffectFlagsTemp |= MOVE_EFFECT_FLAG_FLY;
        ctx->moveConditions[battlerId].skyDropHolder = attacker + 1;
    } else {
        ctx->battleMons[battlerId].moveEffectFlags &= ~MOVE_EFFECT_FLAG_FLY;
        ctx->moveConditions[battlerId].skyDropHolder = 0;
    }
    return 1;
}

BOOL BtlCmd_SetMoveConditionFlag(BattleSystem *battleSystem, BattleContext *ctx) {
    int move;
    int battlerId;

    BattleScriptIncrementPointer(ctx, 1);

    move = BattleScriptReadWord(ctx);
    battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));

    switch (move) {
    case MOVE_POWDER:
        ctx->moveConditions[battlerId].powderBlockingFireMove = TRUE;
        break;
    case MOVE_LASER_FOCUS:
        ctx->moveConditions[battlerId].laserFocusTimer = 2;
        break;
    case MOVE_GLAIVE_RUSH:
        ctx->moveConditions[battlerId].glaiveRush = TRUE;
        break;
    case MOVE_THROAT_CHOP:
        // A second chop does not restart the first; the reference tested it.
        if (ctx->moveConditions[battlerId].throatChopTimer == 0) {
            ctx->moveConditions[battlerId].throatChopTimer = 2;
        }
        break;
    // The Rooms are the field's: five turns, or none if one was up already
    // (Pokemon Central, Mirabilzona, Magicozona). What there is now goes in
    // CALC_TEMP for the script to say.
    case MOVE_WONDER_ROOM:
        ctx->wonderRoomTurns = ctx->wonderRoomTurns ? 0 : 5;
        ctx->calcTemp = ctx->wonderRoomTurns;
        break;
    case MOVE_MAGIC_ROOM:
        ctx->magicRoomTurns = ctx->magicRoomTurns ? 0 : 5;
        ctx->calcTemp = ctx->magicRoomTurns;
        break;
    // The battler's move is Electric for the rest of the turn.
    case MOVE_ELECTRIFY:
        ctx->turnData[battlerId].electrified = TRUE;
        break;
    // Held by the Octolock's user and worn down at each turn's end.
    case MOVE_OCTOLOCK:
        ctx->moveConditions[battlerId].octolocked = TRUE;
        break;
    // Hurt at each turn's end while it stays in; a second cure adds nothing,
    // and CALC_TEMP says whether this one took for the script to say so.
    case MOVE_SALT_CURE:
        ctx->calcTemp = !ctx->moveConditions[battlerId].saltCured;
        ctx->moveConditions[battlerId].saltCured = TRUE;
        break;
    // Three turns' ends of lost Speed while the attacker stays in; a second
    // bomb on a target still covered adds nothing (CALC_TEMP says which).
    case MOVE_SYRUP_BOMB:
        ctx->calcTemp = !ctx->moveConditions[battlerId].syrupBombTurns;
        if (ctx->calcTemp) {
            ctx->moveConditions[battlerId].syrupBombTurns = 3;
            ctx->moveConditions[battlerId].syrupBombUser = ctx->battlerIdAttacker;
        }
        break;
    // Weaker to Fire while it stays in; once is all there is (CALC_TEMP says
    // whether this was the once).
    case MOVE_TAR_SHOT:
        ctx->calcTemp = !ctx->moveConditions[battlerId].tarShot;
        ctx->moveConditions[battlerId].tarShot = TRUE;
        break;
    // Spectral Thief takes every raised stage of the battler for its user,
    // doubled by Simple and turned about by Contrary, and leaves the battler
    // at 0 in each; Clear Body has nothing to say (Pokemon Central,
    // Ombrafurto).
    case MOVE_SPECTRAL_THIEF: {
        int stat;
        int ability = GetBattlerAbility(ctx, ctx->battlerIdAttacker);

        for (stat = STAT_ATK; stat < NUM_BATTLE_STATS; stat++) {
            int raised = ctx->battleMons[battlerId].statChanges[stat] - 6;
            int stage;

            if (raised <= 0) {
                continue;
            }
            ctx->battleMons[battlerId].statChanges[stat] = 6;
            if (ability == ABILITY_SIMPLE) {
                raised *= 2;
            } else if (ability == ABILITY_CONTRARY) {
                raised = -raised;
            }
            stage = ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat] + raised;
            stage = stage > 12 ? 12 : (stage < 0 ? 0 : stage);
            // A rise Burning Jealousy counts (Fiamminvidia names Spectral
            // Thief), and a Mirror Herb on the other side copies as far as
            // the stage really rose (Foglia carbone: any rise of a foe's).
            if (stage > ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat]) {
                ctx->turnData[ctx->battlerIdAttacker].statRaised = TRUE;
                RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdAttacker, stat, stage - ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat]);
            }
            ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat] = stage;
        }
        break;
    }
    // Court Change swaps what lies on each side of the field: the screens,
    // Mist, Safeguard, Tailwind, the entry hazards and the Pledges' rainbow,
    // sea of fire and swamp, with their turns, their layers and the order a
    // Pokemon meets them in (Pokemon Central, Cambiocampo). What belongs to a
    // Pokemon rather than to the ground -- a Future Sight on its way, a Wish,
    // Lucky Chant, the items knocked off -- stays where it is.
    case MOVE_COURT_CHANGE: {
        u32 courtFlags = SIDE_CONDITION_REFLECT | SIDE_CONDITION_LIGHT_SCREEN | SIDE_CONDITION_AURORA_VEIL | SIDE_CONDITION_MIST | SIDE_CONDITION_SAFEGUARD
            | SIDE_CONDITION_TAILWIND | SIDE_CONDITION_SPIKES | SIDE_CONDITION_TOXIC_SPIKES | SIDE_CONDITION_STEALTH_ROCKS | SIDE_CONDITION_STICKY_WEB
            | SIDE_CONDITION_RAINBOW | SIDE_CONDITION_SEA_OF_FIRE | SIDE_CONDITION_SWAMP;
        u32 swapped = (ctx->fieldSideConditionFlags[0] ^ ctx->fieldSideConditionFlags[1]) & courtFlags;
        SideConditionData data0 = ctx->fieldSideConditionData[0];
        SideConditionData *data = ctx->fieldSideConditionData;
        u8 hazard;
        int i;

        ctx->fieldSideConditionFlags[0] ^= swapped;
        ctx->fieldSideConditionFlags[1] ^= swapped;
        // The sides' data change places whole, and then Follow Me and the
        // items knocked off go back to the side they belong to.
        data[0] = data[1];
        data[1] = data0;
        data[1].followMeFlag = data[0].followMeFlag;
        data[1].battlerIdFollowMe = data[0].battlerIdFollowMe;
        data[1].battlerBitKnockedOffItem = data[0].battlerBitKnockedOffItem;
        data[0].followMeFlag = data0.followMeFlag;
        data[0].battlerIdFollowMe = data0.battlerIdFollowMe;
        data[0].battlerBitKnockedOffItem = data0.battlerBitKnockedOffItem;
        for (i = 0; i < NUM_HAZARD_IDX; i++) {
            hazard = ctx->entryHazardQueue[0][i];
            ctx->entryHazardQueue[0][i] = ctx->entryHazardQueue[1][i];
            ctx->entryHazardQueue[1][i] = hazard;
        }
        break;
    }
    // Gravity brings down what Telekinesis holds up, and it ends (Pokemon
    // Central, Gravita), as subscript 156 ends Magnet Rise; CALC_TEMP says
    // whether it was running.
    case MOVE_GRAVITY:
        ctx->calcTemp = ctx->moveConditions[battlerId].telekinesisTurns;
        ctx->moveConditions[battlerId].telekinesisTurns = 0;
        break;
    // Three turns in the air; not twice over (CALC_TEMP says whether it
    // took).
    case MOVE_TELEKINESIS:
        ctx->calcTemp = !ctx->moveConditions[battlerId].telekinesisTurns;
        if (ctx->calcTemp) {
            ctx->moveConditions[battlerId].telekinesisTurns = 3;
        }
        break;
    // Whether any Pokemon on the field that Teatime can reach -- standing, not
    // in the air or underground -- holds a Berry.
    case MOVE_TEATIME: {
        int i;

        ctx->calcTemp = FALSE;
        for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
            if (ctx->battleMons[i].hp && !(ctx->battleMons[i].moveEffectFlags & MOVE_EFFECT_FLAG_SEMI_INVULNERABLE) && BattleItemIsBerry(ctx->battleMons[i].item) == TRUE) {
                ctx->calcTemp = TRUE;
            }
        }
        break;
    }
    // Instruct: the battler is to use its last move again, if that move can
    // be repeated and it still has it and its PP (CALC_TEMP says whether).
    case MOVE_INSTRUCT: {
        u16 move = ctx->moveNoBattlerPrev[battlerId];
        int index = BattleMon_GetMoveIndex(&ctx->battleMons[battlerId], move);

        ctx->calcTemp = MoveCanBeInstructed(ctx, move) && index < MAX_MON_MOVES && ctx->battleMons[battlerId].movePPCur[index]
            && !(ctx->battleMons[battlerId].status2 & (STATUS2_RECHARGE | STATUS2_LOCKED_INTO_MOVE | STATUS2_RAMPAGE | STATUS2_BIDE));
        if (ctx->calcTemp) {
            ctx->turnData[battlerId].instructed = TRUE;
        }
        break;
    }
    // Ally Switch: the user and its ally change places, if it works
    // (CALC_TEMP says whether); the user's battler is its new place's.
    case MOVE_ALLY_SWITCH:
        ctx->calcTemp = AllySwitchWorks(battleSystem, ctx);
        if (ctx->calcTemp) {
            Battlers_SwapPlaces(ctx, battlerId, BattleSystem_GetBattlerIdPartner(battleSystem, battlerId));
        }
        break;
    // The Pledges, whose script asks with Water Pledge's number for all three.
    case MOVE_WATER_PLEDGE:
        ctx->calcTemp = TryPledgeCombination(battleSystem, ctx, battlerId);
        break;
    // A combined Pledge's condition, asked with Fire Pledge's number by
    // subscript 465 as the move hits (LeavePledgeCondition).
    case MOVE_FIRE_PLEDGE:
        ctx->calcTemp = LeavePledgeCondition(ctx, battlerId);
        break;
    // Sky Drop's three steps, on the battler it is aimed at (SkyDropStep).
    case MOVE_SKY_DROP:
        ctx->calcTemp = SkyDropStep(battleSystem, ctx, battlerId);
        break;
    // Revival Blessing's two steps, on its user (RevivalBlessingStep).
    case MOVE_REVIVAL_BLESSING:
        ctx->calcTemp = RevivalBlessingStep(battleSystem, ctx, battlerId);
        break;
    // Whether the battler's Shell Trap was sprung, for its script to ask.
    case MOVE_SHELL_TRAP:
        ctx->calcTemp = ctx->turnData[battlerId].shellTrapSprung;
        break;
    // The field is locked till the next turn's end; not twice over (CALC_TEMP
    // says whether it took).
    case MOVE_FAIRY_LOCK:
        ctx->calcTemp = !ctx->fairyLockTurns;
        if (ctx->calcTemp) {
            ctx->fairyLockTurns = 2;
        }
        break;
    // A critical stage more, two for a Dragon-type as it is now; nothing for
    // a Pokemon already cheered or pumped by Focus Energy (CALC_TEMP says).
    case MOVE_DRAGON_CHEER:
        ctx->calcTemp = !ctx->moveConditions[battlerId].dragonCheer && !(ctx->battleMons[battlerId].status2 & STATUS2_FOCUS_ENERGY);
        if (ctx->calcTemp) {
            ctx->moveConditions[battlerId].dragonCheer = (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_DRAGON
                                                             || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_DRAGON
                                                             || ctx->battleMons[battlerId].type3 == TYPE_DRAGON)
                ? 2
                : 1;
            // What a Mirror Herb or an Opportunist on the other side is to
            // copy (Pokemon Central, Grido del Drago), in the HP slot.
            RecordMirrorHerbStages(battleSystem, ctx, battlerId, STAT_HP, ctx->moveConditions[battlerId].dragonCheer);
        }
        break;
    }

    return FALSE;
}

BOOL BtlCmd_SetCurrentMoveSwitchingStatus(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    ctx->currentMoveSwitchStatus = BattleScriptReadWord(ctx);

    return FALSE;
}

// Synchronize hands the status back to whoever inflicted it. The controller
// pass has already decided that is happening and left the status where it can
// be read; this only has to say which script to run for it.
BOOL BtlCmd_TrySynchronizeStatus(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    u32 status = ctx->battleMons[ctx->battlerIdTemp].status;
    int script = BATTLE_SUBSCRIPT_NONE;

    if (status & STATUS_POISON_ALL) {
        script = BATTLE_SUBSCRIPT_POISON;
    } else if (status & STATUS_BURN) {
        script = BATTLE_SUBSCRIPT_BURN;
    } else if (status & STATUS_PARALYSIS) {
        script = BATTLE_SUBSCRIPT_PARALYZE;
    }

    if (script == BATTLE_SUBSCRIPT_NONE) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        ctx->tempData = script;
    }

    return FALSE;
}

// A berry that cures what the Pokemon has. The held-item check already knows
// which berries those are and which script each one runs.
BOOL BtlCmd_TryCureStatusBerry(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side);
    u32 script;

    if (CheckUseHeldItem(battleSystem, ctx, battlerId, &script) == TRUE) {
        ctx->battlerIdTemp = battlerId;
        ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
        ctx->tempData = script;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// The four below batch work over everything a spread move hit at once. This
// engine walks its targets one at a time and does that work as it goes, so by
// the time a script asks there is nothing left over to do.
BOOL BtlCmd_BatchUpdateHealthBar(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    return FALSE;
}

BOOL BtlCmd_BatchUpdateHealthBarValue(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    return FALSE;
}

BOOL BtlCmd_BatchFollowupMessage(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);
    return FALSE;
}

BOOL BtlCmd_BatchEffectivenessMessage(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);
    return FALSE;
}

// The ground the battle is being fought on, which this game already knows
// about: it is what Camouflage and Nature Power read. A terrain laid over the
// battle covers that ground, so while one is down the answer is always no.
BOOL BtlCmd_GotoIfCurrentFieldIsType(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int terrain = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (BattleSystem_GetTerrainId(battleSystem) == terrain && ctx->terrainOverlayType == TERRAIN_NONE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Lay the terrain the move being used calls for, or -- when the script passes
// TRUE, which is Defog's and Ice Spinner's way in -- clear whatever is down.
//
// The jump is the reference's and is dead there too: laying the terrain that is
// already down takes it, and then UpdateTerrainOverlay finds nothing to change
// and the move goes on to announce a terrain it did not lay. Kept as the
// reference has it rather than made to fail the move.
BOOL BtlCmd_UpdateTerrainOverlay(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int endTerrain = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);
    int terrainType = TERRAIN_NONE;

    if (endTerrain == TRUE) {
        BattleContext_UpdateTerrainOverlay(ctx, ctx->battlerIdAttacker, TERRAIN_NONE);
        // Every Mimicry holder goes back to its own types as the ground goes,
        // not after the next move.
        for (int battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
            Battler_MimicryRestoreTypes(battleSystem, ctx, battlerId);
        }
        return FALSE;
    }

    switch (ctx->moveNoCur) {
    case MOVE_GRASSY_TERRAIN:
        terrainType = GRASSY_TERRAIN;
        break;
    case MOVE_MISTY_TERRAIN:
        terrainType = MISTY_TERRAIN;
        break;
    case MOVE_ELECTRIC_TERRAIN:
        terrainType = ELECTRIC_TERRAIN;
        break;
    case MOVE_PSYCHIC_TERRAIN:
        terrainType = PSYCHIC_TERRAIN;
        break;
    }

    if (terrainType == ctx->terrainOverlayType) {
        BattleScriptIncrementPointer(ctx, adrs);
    } else {
        BattleContext_UpdateTerrainOverlay(ctx, ctx->battlerIdAttacker, terrainType);
    }

    return FALSE;
}

BOOL BtlCmd_GotoIfTerrainOverlayIsType(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int terrainType = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (ctx->terrainOverlayType == terrainType) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Nothing asks about this flag, here or in the reference, which writes it in
// exactly one place and never reads it back. See BattleContext.
BOOL BtlCmd_SetPsychicTerrainMoveUsedFlag(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    ctx->psychicTerrainMoveUsed[ctx->battlerIdAttacker] = 1;

    return FALSE;
}

// Parental Bond's strikes, as the scripts ask about them: the reference's
// commands 0xEF to 0xF2 and 0xF4. The flag is set as the move begins
// (TryStartParentalBond), or by a script that strikes twice itself, as
// Present's does.
BOOL BtlCmd_GotoIfFirstHitOfParentalBond(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    int adrs = BattleScriptReadWord(ctx);
    if (ParentalBond_IsFirstStrike(ctx)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }
    return FALSE;
}

BOOL BtlCmd_GotoIfSecondHitOfParentalBond(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    int adrs = BattleScriptReadWord(ctx);
    if (ParentalBond_IsSecondStrike(ctx)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }
    return FALSE;
}

BOOL BtlCmd_SetParentalBondFlag(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond = TRUE;
    return FALSE;
}

// The move a calling move is about to use, not the one running.
BOOL BtlCmd_GotoIfCurrentMoveIsValidForParentalBond(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);
    int adrs = BattleScriptReadWord(ctx);
    if (ParentalBond_MoveApplies(battleSystem, ctx, ctx->moveTemp)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }
    return FALSE;
}

BOOL BtlCmd_GotoIfParentalBondIsActive(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    int adrs = BattleScriptReadWord(ctx);
    if (ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond) {
        BattleScriptIncrementPointer(ctx, adrs);
    }
    return FALSE;
}

// Knock Off hits harder for taking an item away from the sixth generation on;
// CalcMoveDamage applies it. Despite its name the command jumps when the boost
// does NOT apply, as the reference's canapplyknockoffdamageboost does.
BOOL BtlCmd_GotoIfCanApplyKnockOffBoost(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (!KnockOffCanRemoveItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// The reference's question, asked when a Pokemon switches out or faints, of
// whether its Desolate Land, Primordial Sea or Delta Stream takes the weather
// with it. Here BattleContext_PrimalWeatherHasEnded asks it with the entry
// abilities, after every action, and no script uses this command.
BOOL BtlCmd_CanClearPrimalWeather(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);
    BattleScriptIncrementPointer(ctx, BattleScriptReadWord(ctx));

    return FALSE;
}

// Neither Mega Evolution nor Ultra Burst reaches this game, so a Pokemon
// caught on the way out has nothing to become first.
BOOL BtlCmd_TryMegaOrUltraBurstDuringPursuit(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptIncrementPointer(ctx, BattleScriptReadWord(ctx));

    return FALSE;
}

BOOL BtlCmd_GoToIfTerastallized(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);

    return FALSE;
}

// The two commands below are how a weather or a terrain tells Protosynthesis
// and Quark Drive that something underfoot or overhead has changed. Both walk
// every battler with the named ability, and both hand off to a subscript and
// then rewind the script pointer onto themselves, so that the next battler is
// dealt with once that subscript has run: one message at a time, and the
// command only falls through when nobody is left.
//
// The order is the turn order rather than the reference's own raw-speed sort,
// which this game has not got. It decides which of two Pokemon is announced
// first and nothing else.
BOOL BtlCmd_ActivateParadoxAbility(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int ability = BattleScriptReadWord(ctx);
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int i;

    for (i = 0; i < maxBattlers; i++) {
        int battlerId = ctx->turnOrder[i];
        int script;

        if (GetBattlerAbility(ctx, battlerId) != ability) {
            continue;
        }
        // Whether the weather or the ground is actually right is asked there.
        script = BattleContext_ActivateParadoxAbility(battleSystem, ctx, battlerId);
        if (script != BATTLE_SUBSCRIPT_NONE) {
            BattleScriptIncrementPointer(ctx, -2);
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, script);
            break;
        }
    }

    return FALSE;
}

BOOL BtlCmd_ResetParadoxAbility(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int ability = BattleScriptReadWord(ctx);
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int i;

    for (i = 0; i < maxBattlers; i++) {
        int battlerId = ctx->turnOrder[i];

        // A boost a Booster Energy bought is not the weather's to take back:
        // it lasts as long as the Pokemon stays out, so the battler holding
        // that record is passed over here. So is one that has fainted, whose
        // boost went with it: the record stays until the next Pokemon comes
        // in, and the line would name a Pokemon that is not there -- in a
        // place left empty, party slot 6.
        if (ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ability && ctx->paradoxBoostedStat[battlerId] != 0 && !ctx->boosterEnergyActivated[battlerId]) {
            ctx->paradoxBoostedStat[battlerId] = 0;
            ctx->battlerIdTemp = battlerId;
            BattleScriptIncrementPointer(ctx, -2);
            BattleScriptGotoSubscript(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_PARADOX_ABILITY_END);
            break;
        }
    }

    return FALSE;
}

// Totem Pokemon are a feature of the Alola games and of no battle this one
// can start.
BOOL BtlCmd_MakeTotem(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);
    BattleScriptIncrementPointer(ctx, BattleScriptReadWord(ctx));

    return FALSE;
}

// Zero to Hero belongs to Palafin, which is not a Pokemon this game has.
BOOL BtlCmd_TryActivateZeroToHero(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);
    return FALSE;
}

// Forest's Curse and Trick-or-Treat give a Pokemon a type on top of what it
// already has. A Pokemon that already has that type gains nothing.
static void AddBattlerType(BattleContext *ctx, int battlerId, u8 type) {
    if (ctx->battleMons[battlerId].type1 == type || ctx->battleMons[battlerId].type2 == type) {
        return;
    }
    ctx->battleMons[battlerId].type3 = type;
}

BOOL BtlCmd_AddType(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    AddBattlerType(ctx, ctx->battlerIdTarget, BattleScriptReadWord(ctx));

    return FALSE;
}

BOOL BtlCmd_HandleForestsCurse(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    AddBattlerType(ctx, ctx->battlerIdTarget, TYPE_GRASS);

    return FALSE;
}

BOOL BtlCmd_HandleTrickOrTreat(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);
    BattleScriptReadWord(ctx);

    AddBattlerType(ctx, ctx->battlerIdTarget, TYPE_GHOST);

    return FALSE;
}

BOOL BtlCmd_GoToIfThirdType(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int type = BattleScriptReadWord(ctx);
    int adrs = BattleScriptReadWord(ctx);

    if (ctx->battleMons[BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side)].type3 == type) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// The hazards a side has, in the order something switching in meets them: the
// order they were laid in, from the fifth generation on, which is what decides
// whether a Pokemon is poisoned before or after the pointed stones have taken
// their share. Another layer of a hazard already down keeps its place (the
// reference's BattleContext_AddEntryHazardToQueue); a hazard is taken off the
// queue where it is cleared away -- Rapid Spin, Defog, Tidy Up, a Poison type
// soaking up toxic spikes -- so one laid again joins the back.
static void EntryHazardQueueRemove(BattleContext *ctx, int side, int hazard) {
    int read, write = 0;

    for (read = 0; read < NUM_HAZARD_IDX; read++) {
        if (ctx->entryHazardQueue[side][read] != hazard) {
            ctx->entryHazardQueue[side][write++] = ctx->entryHazardQueue[side][read];
        } else if (read < ctx->hazardQueueTracker) {
            // Taken away by the walk itself: what came after it has moved into
            // the place the walk has already passed.
            ctx->hazardQueueTracker--;
        }
    }
    while (write < NUM_HAZARD_IDX) {
        ctx->entryHazardQueue[side][write++] = HAZARD_IDX_NONE;
    }
}

BOOL BtlCmd_AddEntryHazardToQueue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int hazard = BattleScriptReadWord(ctx);
    int fieldSide = BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));

    for (int i = 0; i < NUM_HAZARD_IDX; i++) {
        if (ctx->entryHazardQueue[fieldSide][i] == hazard) {
            break;
        }
        if (ctx->entryHazardQueue[fieldSide][i] == HAZARD_IDX_NONE) {
            ctx->entryHazardQueue[fieldSide][i] = hazard;
            break;
        }
    }

    return FALSE;
}

BOOL BtlCmd_RemoveEntryHazardFromQueue(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int hazard = BattleScriptReadWord(ctx);

    EntryHazardQueueRemove(ctx, BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side)), hazard);

    return FALSE;
}

// Called round and round by the switch-in script until the queue runs out.
BOOL BtlCmd_JumpToCurrentEntryHazard(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int side = BattleScriptReadWord(ctx);
    int adrs[NUM_HAZARD_IDX];

    for (int i = 0; i < NUM_HAZARD_IDX; i++) {
        adrs[i] = BattleScriptReadWord(ctx);
    }

    int fieldSide = BattleSystem_GetFieldSide(battleSystem, BattleSystem_GetBattlerIDBySide(battleSystem, ctx, side));
    int hazard = ctx->entryHazardQueue[fieldSide][ctx->hazardQueueTracker];

    if (hazard == HAZARD_IDX_NONE) {
        ctx->hazardQueueTracker = 0;
    } else {
        ctx->hazardQueueTracker++;
        BattleScriptIncrementPointer(ctx, adrs[hazard - 1]);
    }

    return FALSE;
}

// Stuff Cheeks eats the user's Berry whether or not the moment called for it
// (Pokemon Central, Riempiguance), as Bug Bite eats a target's: the Berry's
// script, if it has anything to do, is left in TEMP_DATA and the Berry in
// itemTemp. CheckUseHeldItem, asked before, ate a pinch Berry only in a
// pinch.
BOOL BtlCmd_StuffCheeks(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);

    if (TryEatOpponentBerry(battleSystem, ctx, ctx->battlerIdAttacker) != TRUE) {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// Cotton Down lowers the Speed of everything else on the field, one at a time.
// The script calls this until it runs out of Pokemon to hand back.
BOOL BtlCmd_GetMonByCottonDownOrder(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    while (ctx->abilityLoopTracker < maxBattlers) {
        int battlerId = ctx->turnOrder[ctx->abilityLoopTracker++];
        if (battlerId != ctx->battlerIdTarget && ctx->battleMons[battlerId].hp && !BattlerCheckSubstitute(ctx, battlerId)) {
            ctx->battlerIdStatChange = battlerId;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            return FALSE;
        }
    }

    ctx->abilityLoopTracker = 0;
    BattleScriptIncrementPointer(ctx, adrs);

    return FALSE;
}

// Whatever the Pokemon that just came in has to say for itself.
BOOL BtlCmd_SwitchInAbilityCheck(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleScriptIncrementPointer(ctx, 1);

    int adrs = BattleScriptReadWord(ctx);
    int script = TryAbilityOnEntry(battleSystem, ctx);

    if (script) {
        ctx->tempData = script;
    } else {
        BattleScriptIncrementPointer(ctx, adrs);
    }

    return FALSE;
}

// After You and Quash reorder a turn that is already under way. This engine
// settles the order once, before the turn starts, and nothing in it asks to
// move again afterwards, so there is no order left to change.
BOOL BtlCmd_ChangeExecutionOrderPriority(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int order;
    int jump;
    int position;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    BattleScriptIncrementPointer(ctx, 1);

    battlerId = BattleSystem_GetBattlerIDBySide(battleSystem, ctx, BattleScriptReadWord(ctx));
    order = BattleScriptReadWord(ctx);
    jump = BattleScriptReadWord(ctx);

    for (position = 0; position < maxBattlers; position++) {
        if (ctx->executionOrder[position] == battlerId) {
            break;
        }
    }
    // Too late once the target has moved.
    if (ctx->executionIndex > position) {
        BattleScriptIncrementPointer(ctx, jump);
        return FALSE;
    }
    ctx->turnData[battlerId].forceExecutionOrder = order;

    return FALSE;
}

// The background a battle is fought against is chosen when the battle starts
// and there is no way to change it partway through, so this asks for something
// the game cannot do. It is cosmetic, and nothing else depends on it.
BOOL BtlCmd_ChangePermanentBackground(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    BattleScriptIncrementPointer(ctx, 1);

    BattleScriptReadWord(ctx);
    BattleScriptReadWord(ctx);

    return FALSE;
}

static void BattlerSetAbility(BattleContext *ctx, u8 battlerID, u16 ability) {
    ctx->trainerAIAbilities[battlerID] = ability;
    return;
}

static void BattlerSetItem(BattleContext *ctx, u8 battlerID, u16 item) {
    ctx->trainerAIData.heldItems[battlerID] = item;
}
