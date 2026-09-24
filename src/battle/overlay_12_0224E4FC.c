#include "battle/overlay_12_0224E4FC.h"

#include "global.h"

#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_script_imports.h"
#include "constants/battle_menu.h"
#include "constants/battle_subscript.h"
#include "constants/game_stats.h"
#include "constants/items.h"
#include "constants/message_tags.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
#include "constants/species.h"
#include "constants/trainers.h"

#include "battle/battle.h"
#include "battle/battle_command.h"
#include "battle/battle_controller.h"
#include "battle/battle_controller_opponent.h"
#include "battle/battle_system.h"
#include "msgdata/msg/msg_0197.h"

#include "dex_mon_measures.h"
#include "filesystem.h"
#include "item.h"
#include "party.h"
#include "pokedex.h"
#include "pokemon.h"
#include "unk_02037C94.h"
#include "unk_0208805C.h"

static const u8 sStatChangeTable[][2];

static BOOL CheckFlyingImmunity(BattleContext *ctx, int item, int index);
static void ApplyEffectivenessFlags(int effectiveness, u32 *moveStatusFlag);
static int GetMoveStatusChangeScript(BattleContext *ctx, int statChangeType, u32 flag);
static void ov12_022583B4(int typeEffectiveness, int moveDamage, u32 *flag);
static int ov12_02258440(BattleContext *ctx, int moveNo);
static u8 Battler_GetType(BattleContext *ctx, int battlerId, int var);
static void ov12_02258584(BattleContext *ctx, u8 battlerId);
static void ov12_0225859C(BattleContext *ctx, u8 battlerId);
static void ov12_022585A8(BattleContext *ctx, u8 battlerId);
static int ov12_022585B8(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdTarget1, int battlerIdTarget2);
static BOOL ov12_0225865C(BattleContext *ctx, int moveNo);
static BOOL MoveIsInList(u32 move, const u16 *list, int count);
// Declared up here because the contact check needs it and the list it reads
// sits down beside the damage calculation, which is the only thing that
// wanted it before the Punching Glove.
static BOOL BattleMoveIsPunching(u32 moveNo);
static int GetDynamicMoveType(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo);
static void CudChewKeepsBerry(BattleContext *ctx, int eater, u16 item);
static u8 BattleMoveTypeForAbility(BattleContext *ctx, int battlerId, int ability, u32 moveNo, int moveTypeDefault);
static BOOL AbilitiesAreNeutralized(BattleContext *ctx, int battlerId);

// Eviolite works for anything that has not finished growing up. The archive
// lists a species' evolutions whether or not it can reach them, and an empty
// list is what "fully evolved" means here.
static BOOL SpeciesHasEvolution(u16 species) {
    struct Evolution table[MAX_EVOS_PER_POKE];

    LoadMonEvolutionTable(species, table);
    for (int i = 0; i < MAX_EVOS_PER_POKE; i++) {
        if (table[i].method != EVO_NONE) {
            return TRUE;
        }
    }
    return FALSE;
}

// Illusion (Party_GetIllusionImitatedIndex and ClientPokemonAppear,
// battle_pokemon.c:250-420 at d0380a487; Pokemon Central, Illusione): a
// Pokemon with the ability comes out made up as the last Pokemon after it in
// its party that can still fight and is not an Egg -- its species, form,
// colours, sex, Poke Ball and name -- and not at all when there is none, or
// when Neutralizing Gas is already out. A party that feeds both battlers of a
// double battle needs a third Pokemon, as in the reference. The disguise is
// kept as the party slot plus one, or 0.
static int Battler_IllusionDisguise(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int selectedMon) {
    int count = BattleSystem_GetPartySize(battleSystem, battlerId);
    int disguise = 0;
    int i;
    Pokemon *mon;

    if (ctx->battleMons[battlerId].ability != ABILITY_ILLUSION || AbilitiesAreNeutralized(ctx, battlerId)) {
        return 0;
    }
    if ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES)
        && BattleSystem_GetParty(battleSystem, battlerId) == BattleSystem_GetParty(battleSystem, BattleSystem_GetBattlerIdPartner(battleSystem, battlerId))
        && count <= 2) {
        return 0;
    }
    for (i = selectedMon + 1; i < count; i++) {
        mon = BattleSystem_GetPartyMon(battleSystem, battlerId, i);
        if (GetMonData(mon, MON_DATA_SPECIES, NULL) != SPECIES_NONE && GetMonData(mon, MON_DATA_HP, NULL) && !GetMonData(mon, MON_DATA_IS_EGG, NULL)) {
            disguise = i + 1;
        }
    }
    return disguise;
}

// The Pokemon a battler's Illusion shows, or NULL when it shows itself.
Pokemon *Battler_IllusionMon(BattleSystem *battleSystem, int battlerId) {
    int disguise = battleSystem->ctx->battleMons[battlerId].illusionMon;

    return disguise ? BattleSystem_GetPartyMon(battleSystem, battlerId, disguise - 1) : NULL;
}

// The disguise drops when the Pokemon takes damage from a move -- not what a
// substitute takes -- even the blow that faints it, before anything else the
// hit sets off, and when it no longer has the ability, suppressed or
// replaced: Gastro Acid, Worry Seed, Simple Beam, Neutralizing Gas coming
// out. It does not come back.
static void Battler_DropIllusion(BattleContext *ctx, int battlerId, int *script) {
    ctx->battleMons[battlerId].illusionMon = 0;
    ctx->battlerIdTemp = battlerId;
    *script = BATTLE_SUBSCRIPT_ILLUSION_FADED;
}

BOOL TryDropLostIllusion(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    for (int i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        int battlerId = ctx->turnOrder[i];

        if (ctx->battleMons[battlerId].illusionMon && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) != ABILITY_ILLUSION) {
            Battler_DropIllusion(ctx, battlerId, script);
            return TRUE;
        }
    }
    return FALSE;
}

void BattleSystem_GetBattleMon(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u8 selectedMon) {
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, selectedMon);
    int i;
    int side;
    struct PokedexData *dexData;

    ctx->battleMons[battlerId].species = GetMonData(mon, MON_DATA_SPECIES, NULL);
    ctx->battleMons[battlerId].atk = GetMonData(mon, MON_DATA_ATK, NULL);
    ctx->battleMons[battlerId].def = GetMonData(mon, MON_DATA_DEF, NULL);
    ctx->battleMons[battlerId].speed = GetMonData(mon, MON_DATA_SPEED, NULL);
    ctx->battleMons[battlerId].spAtk = GetMonData(mon, MON_DATA_SP_ATK, NULL);
    ctx->battleMons[battlerId].spDef = GetMonData(mon, MON_DATA_SP_DEF, NULL);

    for (i = 0; i < 4; i++) {
        ctx->battleMons[battlerId].moves[i] = GetMonData(mon, MON_DATA_MOVE1 + i, NULL);
        ctx->battleMons[battlerId].movePPCur[i] = GetMonData(mon, MON_DATA_MOVE1_PP + i, NULL);
        ctx->battleMons[battlerId].movePP[i] = GetMonData(mon, MON_DATA_MOVE1_PP_UPS + i, NULL);
    }

    ctx->battleMons[battlerId].hpIV = GetMonData(mon, MON_DATA_HP_IV, NULL);
    ctx->battleMons[battlerId].atkIV = GetMonData(mon, MON_DATA_ATK_IV, NULL);
    ctx->battleMons[battlerId].defIV = GetMonData(mon, MON_DATA_DEF_IV, NULL);
    ctx->battleMons[battlerId].speedIV = GetMonData(mon, MON_DATA_SPEED_IV, NULL);
    ctx->battleMons[battlerId].spAtkIV = GetMonData(mon, MON_DATA_SPATK_IV, NULL);
    ctx->battleMons[battlerId].spDefIV = GetMonData(mon, MON_DATA_SPDEF_IV, NULL);

    ctx->battleMons[battlerId].isEgg = GetMonData(mon, MON_DATA_IS_EGG, NULL);
    ctx->battleMons[battlerId].hasNickname = GetMonData(mon, MON_DATA_HAS_NICKNAME, NULL);

    if (!(ctx->battleStatus & BATTLE_STATUS_BATON_PASS)) {
        for (i = 0; i < 8; i++) {
            ctx->battleMons[battlerId].statChanges[i] = 6; // 6 is the default for stat changes
        }
    }

    ctx->battleMons[battlerId].sendOutFlag = 0;
    ctx->battleMons[battlerId].intimidateFlag = 0;
    ctx->battleMons[battlerId].traceFlag = 0;
    ctx->battleMons[battlerId].downloadFlag = 0;
    ctx->battleMons[battlerId].anticipationFlag = 0;
    ctx->battleMons[battlerId].forewarnFlag = 0;
    ctx->battleMons[battlerId].slowStartFlag = 0;
    ctx->battleMons[battlerId].slowStartEnded = 0;
    ctx->battleMons[battlerId].friskFlag = 0;
    ctx->battleMons[battlerId].moldBreakerFlag = 0;
    ctx->battleMons[battlerId].pressureFlag = 0;
    // Protean's "once per appearance" is this flag, so a new appearance has to
    // start without it. The reference clears it here for the same reason.
    ctx->battleMons[battlerId].abilityActivatedFlag = 0;
    // An Air Balloon announces itself once per appearance, so the same goes
    // for its flag. The reference clears it alongside these.
    ctx->battleMons[battlerId].airBalloonFlag = 0;
    // And the critical hits: the engine counts them per appearance, and
    // clears the count with these.
    ctx->battleMons[battlerId].criticalHits = 0;
    // Unnerve, Screen Cleaner, Imposter and Hospitality act at every entry
    // too. The reference gates the first, second and fourth on the flag just
    // cleared above and Imposter on imposter_flag, and clears both in
    // ClearBattleMonFlags; left set, they spoke for the first Pokemon to
    // stand in this slot and never again.
    ctx->battleMons[battlerId].unnerveFlag = 0;
    ctx->battleMons[battlerId].screenCleanerFlag = 0;
    ctx->battleMons[battlerId].imposterFlag = 0;
    ctx->battleMons[battlerId].hospitalityFlag = 0;
    ctx->battleMons[battlerId].neutralizingGasFlag = 0;
    ctx->statLoweredBattlers &= ~MaskOfFlagNo(battlerId);
    ctx->statRaisedBattlers &= ~MaskOfFlagNo(battlerId);
    MI_CpuClear8(ctx->mirrorHerbStages[battlerId], sizeof(ctx->mirrorHerbStages[battlerId]));
    // Kept off the BattleMon because that structure's size is pinned; cleared
    // here, which is where the reference clears its copy.
    ctx->psychicTerrainMoveUsed[battlerId] = 0;
    ctx->protectSuccessTurns[battlerId] = 0;
    // A Paradox ability picks its stat again from scratch when its Pokemon
    // comes back out, so what it had picked before does not travel with it --
    // nor does the record of a Booster Energy having been what raised it.
    ctx->paradoxBoostedStat[battlerId] = 0;
    ctx->boosterEnergyActivated[battlerId] = FALSE;
    ctx->iceFaceWeatherSeen &= ~MaskOfFlagNo(battlerId);
    ctx->cudChewBerry[battlerId] = ITEM_NONE;
    ctx->supremeOverlordFallen[battlerId] = 0;
    ctx->mimicryTerrain[battlerId] = TERRAIN_NONE;
    MI_CpuClear8(ctx->opportunistStages[battlerId], NUM_BATTLE_STATS);
    ctx->symbiosisPending[battlerId] = FALSE;

    ctx->battleMons[battlerId].type1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
    ctx->battleMons[battlerId].type2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
    ctx->battleMons[battlerId].type3 = TYPE_NONE;
    ctx->battleMons[battlerId].canStillEvolve = SpeciesHasEvolution(ctx->battleMons[battlerId].species);

    ctx->battleMons[battlerId].gender = GetMonGender(mon);
    ctx->battleMons[battlerId].shiny = MonIsShiny(mon);

    if (BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK)) { // No abilities battle
        ctx->battleMons[battlerId].ability = 0;
        ctx->battleMons[battlerId].status = 0;
        ctx->battleMons[battlerId].item = 0;
    } else {
        ctx->battleMons[battlerId].ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
        ctx->battleMons[battlerId].status = GetMonData(mon, MON_DATA_STATUS, NULL);
        ctx->battleMons[battlerId].item = GetMonData(mon, MON_DATA_HELD_ITEM, NULL);
    }

    if ((BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_SAFARI | BATTLE_TYPE_PAL_PARK)) && !BattleSystem_GetFieldSide(battleSystem, battlerId)) {
        ctx->battleMons[battlerId].form = 0;
    } else {
        ctx->battleMons[battlerId].form = GetMonData(mon, MON_DATA_FORM, NULL);
    }

    ctx->battleMons[battlerId].level = GetMonData(mon, MON_DATA_LEVEL, NULL);
    ctx->battleMons[battlerId].friendship = GetMonData(mon, MON_DATA_FRIENDSHIP, NULL);

    ctx->battleMons[battlerId].hp = GetMonData(mon, MON_DATA_HP, NULL);
    ctx->battleMons[battlerId].maxHp = GetMonData(mon, MON_DATA_MAX_HP, NULL);

    ctx->battleMons[battlerId].exp = GetMonData(mon, MON_DATA_EXPERIENCE, NULL);
    ctx->battleMons[battlerId].personality = GetMonData(mon, MON_DATA_PERSONALITY, NULL);
    ctx->battleMons[battlerId].otid = GetMonData(mon, MON_DATA_OT_ID, NULL);
    ctx->battleMons[battlerId].otGender = GetMonData(mon, MON_DATA_OT_GENDER, NULL);

    ctx->battleMons[battlerId].ball = BattleSystem_GetMonBall(battleSystem, mon);

    SetDexBanksByGiratinaForm(ctx->battleMons[battlerId].form);
    dexData = PokedexData_Create(HEAP_ID_BATTLE);
    PokedexData_LoadAll(dexData, 0, HEAP_ID_BATTLE);

    ctx->battleMons[battlerId].weight = PokedexData_GetWeight(dexData, ctx->battleMons[battlerId].species);

    PokedexData_UnloadAll(dexData);
    PokedexData_Delete(dexData);

    GetMonData(mon, MON_DATA_NICKNAME, ctx->battleMons[battlerId].nickname);
    GetMonData(mon, MON_DATA_OT_NAME, ctx->battleMons[battlerId].otName);

    ctx->battleMons[battlerId].hitCount = 0;
    ctx->battleMons[battlerId].msgFlag = 0;

    side = BattleSystem_GetFieldSide(battleSystem, battlerId);

    if (ctx->fieldSideConditionData[side].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[battlerId])) {
        ctx->battleMons[battlerId].item = 0;
        ctx->battleMons[battlerId].unk88.knockOffFlag = FALSE;
    } else if (ctx->battleMons[battlerId].item) {
        ctx->battleMons[battlerId].unk88.knockOffFlag = TRUE;
    }

    ctx->battleMons[battlerId].illusionMon = Battler_IllusionDisguise(battleSystem, ctx, battlerId, selectedMon);
}

void BattleSystem_ReloadMonData(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int monIndex) {
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, monIndex);
    int i;

    ctx->battleMons[battlerId].atk = GetMonData(mon, MON_DATA_ATK, NULL);
    ctx->battleMons[battlerId].def = GetMonData(mon, MON_DATA_DEF, NULL);
    ctx->battleMons[battlerId].speed = GetMonData(mon, MON_DATA_SPEED, NULL);
    ctx->battleMons[battlerId].spAtk = GetMonData(mon, MON_DATA_SP_ATK, NULL);
    ctx->battleMons[battlerId].spDef = GetMonData(mon, MON_DATA_SP_DEF, NULL);
    ctx->battleMons[battlerId].level = GetMonData(mon, MON_DATA_LEVEL, NULL);
    ctx->battleMons[battlerId].friendship = GetMonData(mon, MON_DATA_FRIENDSHIP, NULL);
    ctx->battleMons[battlerId].hp = GetMonData(mon, MON_DATA_HP, NULL);
    ctx->battleMons[battlerId].maxHp = GetMonData(mon, MON_DATA_MAX_HP, NULL);

    if (!(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        for (i = 0; i < 4; i++) {
            if (!(ctx->battleMons[battlerId].unk88.mimicedMoveIndex & MaskOfFlagNo(i))) {
                ctx->battleMons[battlerId].moves[i] = GetMonData(mon, MON_DATA_MOVE1 + i, NULL);
                ctx->battleMons[battlerId].movePPCur[i] = GetMonData(mon, MON_DATA_MOVE1_PP + i, NULL);
                ctx->battleMons[battlerId].movePP[i] = GetMonData(mon, MON_DATA_MOVE1_PP_UPS + i, NULL);
            }
        }
        ctx->battleMons[battlerId].exp = GetMonData(mon, MON_DATA_EXPERIENCE, NULL);
    }
}

void ReadBattleScriptFromNarc(BattleContext *ctx, NarcId narcId, int fileId) {
    GF_ASSERT(GetNarcMemberSizeByIdPair(narcId, fileId) <= sizeof(ctx->battleScriptBuffer));
    ctx->scriptNarcId = narcId;
    ctx->scriptFileId = fileId;
    ctx->scriptSeqNo = 0;
    ReadWholeNarcMemberByIdPair(&ctx->battleScriptBuffer, narcId, fileId);
}

// PushBattleScriptFromNarc..?
void ov12_0224EBDC(BattleContext *ctx, NarcId narcId, int fileId) {
    GF_ASSERT(GetNarcMemberSizeByIdPair(narcId, fileId) <= sizeof(ctx->battleScriptBuffer));
    GF_ASSERT(ctx->unk_B8 < 4);
    ctx->unk_BC[ctx->unk_B8] = ctx->scriptNarcId;
    ctx->unk_CC[ctx->unk_B8] = ctx->scriptFileId;
    ctx->unk_DC[ctx->unk_B8] = ctx->scriptSeqNo;
    ctx->unk_B8++;
    ctx->scriptNarcId = narcId;
    ctx->scriptFileId = fileId;
    ctx->scriptSeqNo = 0;
    ReadWholeNarcMemberByIdPair(&ctx->battleScriptBuffer, narcId, fileId);
}

// BattleScript_Pop..?
BOOL ov12_0224EC74(BattleContext *ctx) {
    if (ctx->unk_B8) {
        ctx->unk_B8--;
        ReadBattleScriptFromNarc(ctx, ctx->unk_BC[ctx->unk_B8], ctx->unk_CC[ctx->unk_B8]);
        ctx->scriptSeqNo = ctx->unk_DC[ctx->unk_B8];
        return FALSE;
    }
    return TRUE;
}

// Link_QueueAdd..?
void ov12_0224ECC4(BattleContext *ctx, int id, int battlerId, int index) {
    int i;

    for (i = 0; i < 16; i++) {
        if (!ctx->linkBuffer[id][battlerId][i]) {
            ctx->linkBuffer[id][battlerId][i] = index;
            break;
        }
    }

    GF_ASSERT(i < 16);
}

// Link_QueueReset..?
void ov12_0224ED00(BattleContext *ctx, int id, int battlerId, int index) {
    int i;

    GF_ASSERT(index != 0);

    for (i = 0; i < 16; i++) {
        if (ctx->linkBuffer[id][battlerId][i] == index) {
            ctx->linkBuffer[id][battlerId][i] = 0;
            break;
        }
    }

    GF_ASSERT(i < 16);
}

BOOL Link_QueueNotEmpty(BattleContext *ctx) {
    int i;
    int battlerId;
    int j;
    int cnt = 0;

    for (i = 0; i < 4; i++) {
        for (battlerId = 0; battlerId < 4; battlerId++) {
            for (j = 0; j < 16; j++) {
                cnt += ctx->linkBuffer[i][battlerId][j];
            }
        }
    }

    if (cnt == 0) {
        ctx->queueTimeout = 0;
    }
    return cnt == 0;
}

void Link_CheckTimeout(BattleContext *ctx) {
    ctx->queueTimeout++;
    if (ctx->queueTimeout > 1800) {
        sub_02039AD8(1);
    }
}

void BattleBuffer_Clear(BattleContext *ctx, int battlerId) {
    for (int i = 0; i < 256; i++) {
        ctx->battleBuffer[battlerId][i] = 0;
    }
}

// The copying flags of the reference's data/AbilityFlags.c at d0380a487: the
// abilities Trace, Skill Swap, Wandering Spirit, Role Play, Entrainment and
// Receiver leave alone, and those nothing writes over. The reference reads
// them through GetAbilityFlags for Trace, Wandering Spirit, Entrainment and
// Skill Swap; here every copier asks this table, scripts through
// BMON_DATA_ABILITY_FLAGS. konefr's two abilities, Irrigation and Evaporate,
// carry none of these flags there. Pokemon Central's Saltamicizia adds three
// abilities Entrainment cannot pass on, which the reference lacks: Gulp
// Missile, Orichalcum Pulse and Hadron Engine.
static const u8 sAbilityFlags[] = {
    [ABILITY_WONDER_GUARD] = ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_TRACE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_FORECAST] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_MULTITYPE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_FLOWER_GIFT] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_ILLUSION] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_IMPOSTER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_ZEN_MODE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_STANCE_CHANGE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_SHIELDS_DOWN] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_SCHOOLING] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_DISGUISE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_BATTLE_BOND] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_POWER_CONSTRUCT] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_COMATOSE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_RECEIVER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_POWER_OF_ALCHEMY] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_RKS_SYSTEM] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_GULP_MISSILE] = ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_ENTRAINMENT,
    [ABILITY_ICE_FACE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_NEUTRALIZING_GAS] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_HUNGER_SWITCH] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_AS_ONE_GLASTRIER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_AS_ONE_SPECTRIER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_ZERO_TO_HERO] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_COMMANDER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_PROTOSYNTHESIS] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_QUARK_DRIVE] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_ORICHALCUM_PULSE] = ABILITY_FLAG_FAILS_ENTRAINMENT,
    [ABILITY_HADRON_ENGINE] = ABILITY_FLAG_FAILS_ENTRAINMENT,
    [ABILITY_EMBODY_ASPECT] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_EMBODY_ASPECT_2] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_EMBODY_ASPECT_3] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_EMBODY_ASPECT_4] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_TERA_SHIFT] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_SUPPRESS | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_TERA_SHELL] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_TERAFORM_ZERO] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
    [ABILITY_POISON_PUPPETEER] = ABILITY_FLAG_FAILS_TRACE | ABILITY_FLAG_FAILS_SWAP | ABILITY_FLAG_FAILS_RECEIVER | ABILITY_FLAG_FAILS_ENTRAINMENT | ABILITY_FLAG_FAILS_ROLE_PLAY,
};

static u8 AbilityFlags(u16 ability) {
    return ability < NELEMS(sAbilityFlags) ? sAbilityFlags[ability] : 0;
}

// What Pokemon Central's pages add for Mummy and Lingering Aroma (Mummia,
// Odore Tenace) to what the table keeps from being written over: neither
// wraps the other of the two, and Lingering Aroma leaves the four Paradox and
// legend abilities its page names. The reference asks the table alone.
// Mummia still lists Commander, which the two wrap from Scarlet and Violet
// 2.0.1 on (Torre di Comando), the latest version followed here.
static BOOL WrappingRefuses(u16 wrapper, u16 ability) {
    switch (ability) {
    case ABILITY_MUMMY:
    case ABILITY_LINGERING_AROMA:
        return TRUE;
    case ABILITY_ORICHALCUM_PULSE:
    case ABILITY_HADRON_ENGINE:
    case ABILITY_PROTOSYNTHESIS:
    case ABILITY_QUARK_DRIVE:
        return wrapper == ABILITY_LINGERING_AROMA;
    }
    return FALSE;
}

int GetBattlerVar(BattleContext *ctx, int battlerId, u32 id, void *data) {
    BattleMon *mon = &ctx->battleMons[battlerId];

    switch (id) {
    case BMON_DATA_SPECIES:
        return mon->species;
    case BMON_DATA_ATK:
        return mon->atk;
    case BMON_DATA_DEF:
        return mon->def;
    case BMON_DATA_SPEED:
        return mon->speed;
    case BMON_DATA_SPATK:
        return mon->spAtk;
    case BMON_DATA_SPDEF:
        return mon->spDef;
    case BMON_DATA_MOVE1:
    case BMON_DATA_MOVE2:
    case BMON_DATA_MOVE3:
    case BMON_DATA_MOVE4: {
        int index = id - BMON_DATA_MOVE1; // see below
        return mon->moves[index];
    }
    case BMON_DATA_HP_IV:
        return mon->hpIV;
    case BMON_DATA_ATK_IV:
        return mon->atkIV;
    case BMON_DATA_DEF_IV:
        return mon->defIV;
    case BMON_DATA_SPEED_IV:
        return mon->speedIV;
    case BMON_DATA_SPATK_IV:
        return mon->spAtkIV;
    case BMON_DATA_SPDEF_IV:
        return mon->spDefIV;
    case BMON_DATA_IS_EGG:
        return mon->isEgg;
    case BMON_DATA_HAS_NICKNAME:
        return mon->hasNickname;
    case BMON_DATA_STAT_CHANGE_HP:
    case BMON_DATA_STAT_CHANGE_ATK:
    case BMON_DATA_STAT_CHANGE_DEF:
    case BMON_DATA_STAT_CHANGE_SPEED:
    case BMON_DATA_STAT_CHANGE_SPATK:
    case BMON_DATA_STAT_CHANGE_SPDEF:
    case BMON_DATA_STAT_CHANGE_ACC:
    case BMON_DATA_STAT_CHANGE_EVASION: {
        int index = id - BMON_DATA_STAT_CHANGE_HP; // see below
        return mon->statChanges[index];
    }
    case BMON_DATA_ABILITY:
        return mon->ability;
    case BMON_DATA_TYPE_1:
    case BMON_DATA_TYPE_2:
    case BMON_DATA_TYPE_3:
        return Battler_GetType(ctx, battlerId, id);
    case BMON_DATA_BERRY_EATEN:
        // Not on the BattleMon: see the constant.
        return ctx->berryEaten[battlerId][ctx->selectedMonIndex[battlerId]];
    case BMON_DATA_SHIELDS_UP:
        return Battler_ShieldsUp(ctx, battlerId);
    case BMON_DATA_CHEEK_POUCH_PENDING:
        return mon->cheekPouchPending;
    case BMON_DATA_ABILITY_FLAGS:
        return AbilityFlags(mon->ability);
    case BMON_DATA_COMMANDER:
        return Battler_HeldByCommander(ctx, battlerId);
    case BMON_DATA_GENDER:
        return mon->gender;
    case BMON_DATA_IS_SHINY:
        return mon->shiny;
    case BMON_DATA_CUR_PP_1:
    case BMON_DATA_CUR_PP_2:
    case BMON_DATA_CUR_PP_3:
    case BMON_DATA_CUR_PP_4: {
        int index = id - BMON_DATA_CUR_PP_1; // annoying but required to match
        return mon->movePPCur[index];
    }
    case BMON_DATA_PP_UPS_1:
    case BMON_DATA_PP_UPS_2:
    case BMON_DATA_PP_UPS_3:
    case BMON_DATA_PP_UPS_4: {
        int index = id - BMON_DATA_PP_UPS_1; // see above
        return mon->movePP[index];
    }
    case BMON_DATA_MAX_PP_1:
    case BMON_DATA_MAX_PP_2:
    case BMON_DATA_MAX_PP_3:
    case BMON_DATA_MAX_PP_4: {
        int index = id - BMON_DATA_MAX_PP_1; // see above
        return GetMoveMaxPP(mon->moves[index], mon->movePP[index]);
    }
    case BMON_DATA_LEVEL:
        return mon->level;
    case BMON_DATA_FRIENDSHIP:
        return mon->friendship;
    case BMON_DATA_NICKNAME: {
        int i;
        u16 *buffer = data;

        for (i = 0; i < POKEMON_NAME_LENGTH + 1; i++) {
            buffer[i] = mon->nickname[i];
        }
    } break;
    case BMON_DATA_NICKNAME_STRBUF:
        CopyU16ArrayToString((String *)data, mon->nickname);
        break;
    case BMON_DATA_HP:
        return mon->hp;
    case BMON_DATA_MAXHP:
        return mon->maxHp;
    case BMON_DATA_OT_NAME: {
        int i;
        u16 *buffer = data;
        for (i = 0; i < POKEMON_NAME_LENGTH + 1; i++) {
            // BUG: this array doesn't have 11 elements, the reason for the bug is a typo in the original code
            //      where it used the length of a Pokemon's nickname rather than a trainer's nickname
            buffer[i] = mon->otName[i];
        }
    } break;
    case BMON_DATA_EXP:
        return mon->exp;
    case BMON_DATA_PERSONALITY:
        return mon->personality;
    case BMON_DATA_STATUS:
        return mon->status;
    case BMON_DATA_STATUS2:
        return mon->status2;
    case BMON_DATA_OT_ID:
        return mon->otid;
    case BMON_DATA_HELD_ITEM:
        return mon->item;
    case BMON_DATA_TIMES_DAMAGED:
        return mon->hitCount;
    case BMON_DATA_MSG_FLAG:
        return mon->msgFlag;
    case BMON_DATA_OT_GENDER:
        return mon->otGender;
    case BMON_DATA_MOVE_EFFECT:
        return mon->moveEffectFlags;
    case BMON_DATA_MOVE_EFFECT_TEMP:
        return mon->moveEffectFlagsTemp;
    case BMON_DATA_DISABLED_TURNS:
        return mon->unk88.disabledTurns;
    case BMON_DATA_ENCORED_TURNS:
        return mon->unk88.encoredTurns;
    case BMON_DATA_CHARGED_TURNS:
        return mon->unk88.isCharged;
    case BMON_DATA_TAUNTED_TURNS:
        return mon->unk88.tauntTurns;
    case BMON_DATA_PROTECT_SUCCESS_COUNT:
        return ctx->protectSuccessTurns[battlerId];
    case BMON_DATA_PERISH_SONG_TURNS:
        return mon->unk88.perishSongTurns;
    case BMON_DATA_ROLLOUT_TURNS:
        return mon->unk88.rolloutCount;
    case BMON_DATA_FURY_CUTTER_TURNS:
        return mon->unk88.furyCutterCount;
    case BMON_DATA_STOCKPILE_COUNT:
        return mon->unk88.stockpileCount;
    case BMON_DATA_STOCKPILE_DEF_BOOSTS:
        return mon->unk88.stockpileDefCount;
    case BMON_DATA_STOCKPILE_SPDEF_BOOSTS:
        return mon->unk88.stockpileSpDefCount;
    case BMON_DATA_TRUANT:
        return mon->unk88.truantFlag;
    case BMON_DATA_FLASH_FIRE:
        return mon->unk88.flashFire;
    case BMON_DATA_LOCK_ON_TARGET:
        return mon->unk88.battlerIdLockOn;
    case BMON_DATA_MIMICED_MOVE:
        return mon->unk88.mimicedMoveIndex;
    case BMON_DATA_BIND_TARGET:
        return mon->unk88.battlerIdBinding;
    case BMON_DATA_MEAN_LOOK_TARGET:
        return mon->unk88.battlerIdMeanLook;
    case BMON_DATA_LAST_RESORT_COUNT:
        return mon->unk88.lastResortCount;
    case BMON_DATA_MAGNET_RISE_TURNS:
        return mon->unk88.magnetRiseTurns;
    case BMON_DATA_HEAL_BLOCK_TURNS:
        return mon->unk88.healBlockTurns;
    case BMON_DATA_EMBARGO_TURNS:
        return mon->unk88.embargoFlag;
    case BMON_DATA_CAN_UNBURDEN:
        return mon->unk88.knockOffFlag;
    case BMON_DATA_METRONOME_TURNS: // refers to the actual item, not the move
        return mon->unk88.metronomeTurns;
    case BMON_DATA_MICLE_BERRY_FLAG:
        return mon->unk88.micleBerryFlag;
    case BMON_DATA_CUSTAP_FLAG:
        return mon->unk88.custapBerryFlag;
    case BMON_DATA_QUICK_CLAW_FLAG:
        return mon->unk88.quickClawFlag;
    case BMON_DATA_QUICK_DRAW_FLAG:
        return mon->unk88.quickDrawFlag;
    case BMON_DATA_ILLUSION_MON:
        return mon->illusionMon;
    case BMON_DATA_RECHARGE:
        return mon->unk88.rechargeCount;
    case BMON_DATA_FAKE_OUT:
        return mon->unk88.fakeOutCount;
    case BMON_DATA_SLOW_START_TURN_NUMBER:
        return mon->unk88.slowStartTurns;
    case BMON_DATA_SUBSTITUTE_HP:
        return mon->unk88.substituteHp;
    case BMON_DATA_TRANSFORMED_PERSONALITY:
        return mon->unk88.transformPersonality;
    case BMON_DATA_DISABLED_MOVE_NO:
        return mon->unk88.disabledMove;
    case BMON_DATA_ENCORED_MOVE_NO:
        return mon->unk88.encoredMove;
    case BMON_DATA_BINDING_MOVE_NO:
        return mon->unk88.bindingMove;
    case BMON_DATA_HELD_ITEM_RESTORE_HP:
        return mon->unk88.unk30;
    case BMON_DATA_SLOW_START_FLAG:
        return mon->slowStartFlag;
    case BMON_DATA_SLOW_START_END:
        return mon->slowStartEnded;
    case BMON_DATA_FORM:
        return mon->form;
    case BMON_DATA_TEMP:
        return GetBattlerVar(ctx, battlerId, ctx->tempData, data);
    default:
        GF_ASSERT(FALSE);
    }

    return 0;
}

void SetBattlerVar(BattleContext *ctx, int battlerId, u32 id, void *data) {
    u32 *data32 = (u32 *)data;
    u16 *data16 = (u16 *)data;
    s16 *datas16 = (s16 *)data;
    u8 *data8 = (u8 *)data;
    s8 *datas8 = (s8 *)data;
    BattleMon *mon = &ctx->battleMons[battlerId];

    switch (id) {
    case BMON_DATA_SPECIES:
        mon->species = *data16;
        break;
    case BMON_DATA_ATK:
        mon->atk = *data16;
        break;
    case BMON_DATA_DEF:
        mon->def = *data16;
        break;
    case BMON_DATA_SPEED:
        mon->speed = *data16;
        break;
    case BMON_DATA_SPATK:
        mon->spAtk = *data16;
        break;
    case BMON_DATA_SPDEF:
        mon->spDef = *data16;
        break;
    case BMON_DATA_MOVE1:
    case BMON_DATA_MOVE2:
    case BMON_DATA_MOVE3:
    case BMON_DATA_MOVE4: {
        int index = id - BMON_DATA_MOVE1;
        mon->moves[index] = *data16;
    } break;
    case BMON_DATA_HP_IV:
        mon->hpIV = *data8;
        break;
    case BMON_DATA_ATK_IV:
        mon->atkIV = *data8;
        break;
    case BMON_DATA_DEF_IV:
        mon->defIV = *data8;
        break;
    case BMON_DATA_SPEED_IV:
        mon->speedIV = *data8;
        break;
    case BMON_DATA_SPATK_IV:
        mon->spAtkIV = *data8;
        break;
    case BMON_DATA_SPDEF_IV:
        mon->spDefIV = *data8;
        break;
    case BMON_DATA_IS_EGG:
        mon->isEgg = *data8;
        break;
    case BMON_DATA_HAS_NICKNAME:
        mon->hasNickname = *data8;
        break;
    case BMON_DATA_STAT_CHANGE_HP:
    case BMON_DATA_STAT_CHANGE_ATK:
    case BMON_DATA_STAT_CHANGE_DEF:
    case BMON_DATA_STAT_CHANGE_SPEED:
    case BMON_DATA_STAT_CHANGE_SPATK:
    case BMON_DATA_STAT_CHANGE_SPDEF:
    case BMON_DATA_STAT_CHANGE_ACC:
    case BMON_DATA_STAT_CHANGE_EVASION: {
        int index = id - BMON_DATA_STAT_CHANGE_HP;
        mon->statChanges[index] = *datas8;
    } break;
    case BMON_DATA_ABILITY:
        mon->ability = *data16;
        break;
    case BMON_DATA_TYPE_1:
        mon->type1 = *data8;
        break;
    case BMON_DATA_TYPE_2:
        mon->type2 = *data8;
        break;
    case BMON_DATA_TYPE_3:
        mon->type3 = *data8;
        break;
    case BMON_DATA_GENDER:
        mon->gender = *data8;
        break;
    case BMON_DATA_IS_SHINY:
        mon->shiny = *data8;
        break;
    case BMON_DATA_CUR_PP_1:
    case BMON_DATA_CUR_PP_2:
    case BMON_DATA_CUR_PP_3:
    case BMON_DATA_CUR_PP_4: {
        int index = id - BMON_DATA_CUR_PP_1;
        mon->movePPCur[index] = *data8;
    } break;
    case BMON_DATA_PP_UPS_1:
    case BMON_DATA_PP_UPS_2:
    case BMON_DATA_PP_UPS_3:
    case BMON_DATA_PP_UPS_4: {
        int index = id - BMON_DATA_PP_UPS_1;
        mon->movePP[index] = *data8;
    } break;
    case BMON_DATA_MAX_PP_1:
    case BMON_DATA_MAX_PP_2:
    case BMON_DATA_MAX_PP_3:
    case BMON_DATA_MAX_PP_4:
        GF_ASSERT(FALSE);
        break;
    case BMON_DATA_LEVEL:
        mon->level = *data8;
        break;
    case BMON_DATA_FRIENDSHIP:
        mon->friendship = *data8;
        break;
    case BMON_DATA_NICKNAME:
        for (int i = 0; i < POKEMON_NAME_LENGTH + 1; i++) {
            mon->nickname[i] = data16[i];
        }
        break;
    case BMON_DATA_HP:
        mon->hp = *datas16;
        break;
    case BMON_DATA_MAXHP:
        mon->maxHp = *data16;
        break;
    case BMON_DATA_OT_NAME:
        for (int i = 0; i < POKEMON_NAME_LENGTH + 1; i++) {
            // BUG: this array doesn't have 11 elements, the reason for the bug is a typo in the original code
            //      where it used the length of a Pokemon's nickname rather than a trainer's nickname
            mon->otName[i] = data16[i];
            // Side note but since this will overwrite the space in memory where the pokemon's exp is stored, there could be some funny things to come of this
        }
        break;
    case BMON_DATA_EXP:
        mon->exp = *data32;
        break;
    case BMON_DATA_PERSONALITY:
        mon->personality = *data32;
        break;
    case BMON_DATA_STATUS:
        mon->status = *data32;
        break;
    case BMON_DATA_STATUS2:
        mon->status2 = *data32;
        break;
    case BMON_DATA_OT_ID:
        mon->otid = *data32;
        break;
    case BMON_DATA_HELD_ITEM:
        mon->item = *data16;
        break;
    case BMON_DATA_TIMES_DAMAGED:
        mon->hitCount = *data8;
        break;
    case BMON_DATA_MSG_FLAG:
        mon->msgFlag = *data8;
        break;
    case BMON_DATA_OT_GENDER:
        mon->otGender = *data8;
        break;
    case BMON_DATA_MOVE_EFFECT:
        mon->moveEffectFlags = *data32;
        break;
    case BMON_DATA_MOVE_EFFECT_TEMP:
        mon->moveEffectFlagsTemp = *data32;
        break;
    case BMON_DATA_DISABLED_TURNS:
        mon->unk88.disabledTurns = *data8;
        break;
    case BMON_DATA_ENCORED_TURNS:
        mon->unk88.encoredTurns = *data8;
        break;
    case BMON_DATA_CHARGED_TURNS:
        mon->unk88.isCharged = *data8;
        break;
    case BMON_DATA_TAUNTED_TURNS:
        mon->unk88.tauntTurns = *data8;
        break;
    case BMON_DATA_PROTECT_SUCCESS_COUNT:
        ctx->protectSuccessTurns[battlerId] = *data8;
        break;
    case BMON_DATA_PERISH_SONG_TURNS:
        mon->unk88.perishSongTurns = *data8;
        break;
    case BMON_DATA_ROLLOUT_TURNS:
        mon->unk88.rolloutCount = *data8;
        break;
    case BMON_DATA_FURY_CUTTER_TURNS:
        mon->unk88.furyCutterCount = *data8;
        break;
    case BMON_DATA_STOCKPILE_COUNT:
        mon->unk88.stockpileCount = *data8;
        break;
    case BMON_DATA_STOCKPILE_DEF_BOOSTS:
        mon->unk88.stockpileDefCount = *data8;
        break;
    case BMON_DATA_STOCKPILE_SPDEF_BOOSTS:
        mon->unk88.stockpileSpDefCount = *data8;
        break;
    case BMON_DATA_TRUANT:
        mon->unk88.truantFlag = *data8;
        break;
    case BMON_DATA_FLASH_FIRE:
        mon->unk88.flashFire = *data8;
        break;
    case BMON_DATA_LOCK_ON_TARGET:
        mon->unk88.battlerIdLockOn = *data8;
        break;
    case BMON_DATA_MIMICED_MOVE:
        mon->unk88.mimicedMoveIndex = *data8;
        break;
    case BMON_DATA_BIND_TARGET:
        mon->unk88.battlerIdBinding = *data8;
        break;
    case BMON_DATA_MEAN_LOOK_TARGET:
        mon->unk88.battlerIdMeanLook = *data8;
        break;
    case BMON_DATA_LAST_RESORT_COUNT:
        mon->unk88.lastResortCount = *data8;
        break;
    case BMON_DATA_MAGNET_RISE_TURNS:
        mon->unk88.magnetRiseTurns = *data8;
        break;
    case BMON_DATA_HEAL_BLOCK_TURNS:
        mon->unk88.healBlockTurns = *data8;
        break;
    case BMON_DATA_EMBARGO_TURNS:
        mon->unk88.embargoFlag = *data8;
        break;
    case BMON_DATA_CAN_UNBURDEN:
        mon->unk88.knockOffFlag = *data8;
        break;
    case BMON_DATA_METRONOME_TURNS: // refers to the actual item, not the move
        mon->unk88.metronomeTurns = *data8;
        break;
    case BMON_DATA_MICLE_BERRY_FLAG:
        mon->unk88.micleBerryFlag = *data8;
        break;
    case BMON_DATA_CUSTAP_FLAG:
        mon->unk88.custapBerryFlag = *data8;
        break;
    case BMON_DATA_QUICK_CLAW_FLAG:
        mon->unk88.quickClawFlag = *data8;
        break;
    case BMON_DATA_QUICK_DRAW_FLAG:
        mon->unk88.quickDrawFlag = *data8;
        break;
    case BMON_DATA_CHEEK_POUCH_PENDING:
        mon->cheekPouchPending = *data8;
        break;
    case BMON_DATA_RECHARGE:
        mon->unk88.rechargeCount = *data32;
        break;
    case BMON_DATA_FAKE_OUT:
        mon->unk88.fakeOutCount = *data32;
        break;
    case BMON_DATA_SLOW_START_TURN_NUMBER:
        mon->unk88.slowStartTurns = *data32;
        break;
    case BMON_DATA_SUBSTITUTE_HP:
        mon->unk88.substituteHp = *data32;
        break;
    case BMON_DATA_TRANSFORMED_PERSONALITY:
        mon->unk88.transformPersonality = *data32;
        break;
    case BMON_DATA_DISABLED_MOVE_NO:
        mon->unk88.disabledMove = *data16;
        break;
    case BMON_DATA_ENCORED_MOVE_NO:
        mon->unk88.encoredMove = *data16;
        break;
    case BMON_DATA_BINDING_MOVE_NO:
        mon->unk88.bindingMove = *data16;
        break;
    case BMON_DATA_HELD_ITEM_RESTORE_HP:
        mon->unk88.unk30 = *data32;
        break;
    case BMON_DATA_SLOW_START_FLAG:
        mon->slowStartFlag = *data8;
        break;
    case BMON_DATA_SLOW_START_END:
        mon->slowStartEnded = *data8;
        break;
    case BMON_DATA_FORM:
        mon->form = *data8;
        break;
    case BMON_DATA_TEMP:
        SetBattlerVar(ctx, battlerId, ctx->tempData, data);
        break;
    default:
        GF_ASSERT(FALSE);
    }
}

void AddBattlerVar(BattleContext *ctx, int battlerId, u32 varId, int data) {
    // The one count kept off the BattleMon, which BattleMon_AddVar cannot reach.
    if (varId == BMON_DATA_PROTECT_SUCCESS_COUNT) {
        ctx->protectSuccessTurns[battlerId] += data;
        return;
    }
    BattleMon_AddVar(&ctx->battleMons[battlerId], varId, data);
}

void BattleMon_AddVar(BattleMon *mon, u32 varId, int data) {
    switch (varId) {
    case BMON_DATA_ATK:
        mon->atk += data;
        break;
    case BMON_DATA_DEF:
        mon->def += data;
        break;
    case BMON_DATA_SPEED:
        mon->speed += data;
        break;
    case BMON_DATA_SPATK:
        mon->spAtk += data;
        break;
    case BMON_DATA_SPDEF:
        mon->spDef += data;
        break;
    case BMON_DATA_HP_IV:
        mon->hpIV += data;
        break;
    case BMON_DATA_ATK_IV:
        mon->atkIV += data;
        break;
    case BMON_DATA_DEF_IV:
        mon->defIV += data;
        break;
    case BMON_DATA_SPEED_IV:
        mon->speedIV += data;
        break;
    case BMON_DATA_SPATK_IV:
        mon->spAtkIV += data;
        break;
    case BMON_DATA_SPDEF_IV:
        mon->spDefIV += data;
        break;
    case BMON_DATA_STAT_CHANGE_HP:
    case BMON_DATA_STAT_CHANGE_ATK:
    case BMON_DATA_STAT_CHANGE_DEF:
    case BMON_DATA_STAT_CHANGE_SPEED:
    case BMON_DATA_STAT_CHANGE_SPATK:
    case BMON_DATA_STAT_CHANGE_SPDEF:
    case BMON_DATA_STAT_CHANGE_ACC:
    case BMON_DATA_STAT_CHANGE_EVASION: {
        int index = varId - BMON_DATA_STAT_CHANGE_HP;
        if (mon->statChanges[index] + data < 0) {
            mon->statChanges[index] = 0;
        } else if (mon->statChanges[index] + data > BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            mon->statChanges[index] = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
        } else {
            mon->statChanges[index] += data;
        }
    } break;
    case BMON_DATA_CUR_PP_1:
    case BMON_DATA_CUR_PP_2:
    case BMON_DATA_CUR_PP_3:
    case BMON_DATA_CUR_PP_4: {
        int index = varId - BMON_DATA_CUR_PP_1;
        int maxPP = GetMoveMaxPP(mon->moves[index], mon->movePP[index]);
        if (mon->movePPCur[index] + data > maxPP) {
            mon->movePPCur[index] = maxPP;
        } else {
            mon->movePPCur[index] += data;
        }
    } break;
    case BMON_DATA_PP_UPS_1:
    case BMON_DATA_PP_UPS_2:
    case BMON_DATA_PP_UPS_3:
    case BMON_DATA_PP_UPS_4: {
        int index = varId - BMON_DATA_PP_UPS_1;
        mon->movePP[index] += data;
    } break;
    case BMON_DATA_LEVEL:
        mon->level += data;
        break;
    case BMON_DATA_FRIENDSHIP: {
        int temp = mon->friendship;

        if (temp + data > 255) {
            temp = 255;
        } else if (temp + data < 0) {
            temp = 0;
        } else {
            temp += data;
        }

        mon->friendship = temp;
    } break;
    case BMON_DATA_HP: {
        if (mon->hp + data > mon->maxHp) {
            mon->hp = mon->maxHp;
        } else {
            mon->hp += data;
        }
    } break;
    case BMON_DATA_MAXHP:
        mon->maxHp += data;
        break;
    case BMON_DATA_EXP:
        mon->exp += data;
        break;
    case BMON_DATA_PERSONALITY:
        mon->personality += data;
        break;
    case BMON_DATA_DISABLED_TURNS:
        mon->unk88.disabledTurns += data;
        break;
    case BMON_DATA_ENCORED_TURNS:
        mon->unk88.encoredTurns += data;
        break;
    case BMON_DATA_CHARGED_TURNS:
        mon->unk88.isCharged += data;
        break;
    case BMON_DATA_TAUNTED_TURNS:
        mon->unk88.tauntTurns += data;
        break;
    case BMON_DATA_PERISH_SONG_TURNS:
        mon->unk88.perishSongTurns += data;
        break;
    case BMON_DATA_ROLLOUT_TURNS:
        mon->unk88.rolloutCount += data;
        break;
    case BMON_DATA_FURY_CUTTER_TURNS:
        mon->unk88.furyCutterCount += data;
        break;
    case BMON_DATA_STOCKPILE_COUNT:
        mon->unk88.stockpileCount += data;
        break;
    case BMON_DATA_STOCKPILE_DEF_BOOSTS:
        mon->unk88.stockpileDefCount += data;
        break;
    case BMON_DATA_STOCKPILE_SPDEF_BOOSTS:
        mon->unk88.stockpileSpDefCount += data;
        break;
    case BMON_DATA_LAST_RESORT_COUNT:
        mon->unk88.lastResortCount += data;
        break;
    case BMON_DATA_MAGNET_RISE_TURNS:
        mon->unk88.magnetRiseTurns += data;
        break;
    case BMON_DATA_HEAL_BLOCK_TURNS:
        mon->unk88.healBlockTurns += data;
        break;
    case BMON_DATA_RECHARGE:
        mon->unk88.rechargeCount += data;
        break;
    case BMON_DATA_FAKE_OUT:
        mon->unk88.fakeOutCount += data;
        break;
    case BMON_DATA_SLOW_START_TURN_NUMBER:
        mon->unk88.slowStartTurns += data;
        break;
    case BMON_DATA_SUBSTITUTE_HP:
        mon->unk88.substituteHp += data;
        break;
    case BMON_DATA_HELD_ITEM_RESTORE_HP:
        mon->unk88.unk30 += data;
        break;
    case BMON_DATA_SLOW_START_FLAG:
        mon->slowStartFlag += data;
        break;
    case BMON_DATA_SLOW_START_END:
        mon->slowStartEnded += data;
        break;
    case BMON_DATA_FORM:
        mon->form += data;
        break;
    default:
        GF_ASSERT(FALSE);
    }
}

static const u8 sSpeedHalvingItemEffects[] = {
    HOLD_EFFECT_EVS_UP_SPEED_DOWN,   // Macho Brace
    HOLD_EFFECT_SPEED_DOWN_GROUNDED, // Iron Ball
    HOLD_EFFECT_LVLUP_HP_EV_UP,      // Power Weight
    HOLD_EFFECT_LVLUP_ATK_EV_UP,     // Power Bracer
    HOLD_EFFECT_LVLUP_DEF_EV_UP,     // Power Belt
    HOLD_EFFECT_LVLUP_SPEED_EV_UP,   // Power Anklet
    HOLD_EFFECT_LVLUP_SPATK_EV_UP,   // Power Lens
    HOLD_EFFECT_LVLUP_SPDEF_EV_UP    // Power Band
};

// The moves Triage hurries. It is a list of moves and not a flag because the
// healing moves have no one move effect in common: draining, resting, wishing
// and the two fainting moves are all on it.
static const u16 sTriageMoves[] = {
    MOVE_ABSORB,
    MOVE_DRAIN_PUNCH,
    MOVE_DRAINING_KISS,
    MOVE_DREAM_EATER,
    MOVE_FLORAL_HEALING,
    MOVE_GIGA_DRAIN,
    MOVE_HEAL_ORDER,
    MOVE_HEAL_PULSE,
    MOVE_HEALING_WISH,
    MOVE_HORN_LEECH,
    MOVE_LEECH_LIFE,
    MOVE_LUNAR_DANCE,
    MOVE_MEGA_DRAIN,
    MOVE_MILK_DRINK,
    MOVE_MOONLIGHT,
    MOVE_MORNING_SUN,
    MOVE_OBLIVION_WING,
    MOVE_PARABOLIC_CHARGE,
    MOVE_PURIFY,
    MOVE_RECOVER,
    MOVE_REST,
    MOVE_ROOST,
    MOVE_SHORE_UP,
    MOVE_SLACK_OFF,
    MOVE_SOFT_BOILED,
    MOVE_STRENGTH_SAP,
    MOVE_SWALLOW,
    MOVE_SYNTHESIS,
    MOVE_WISH,
};

// Prankster, Gale Wings and Triage each get their holder ahead of the move it
// chose, so the priority the turn order compares is not the one in the move
// table. A battler that picked something other than a move has no move to
// hurry, and the table's own entry for MOVE_NONE answers for it as before.
//
// Gale Wings asks the move table's type, not the type the move will be thrown
// with, so a Normalize or an -ate ability does not take it away or grant it.
s8 BattlerMovePriority(BattleContext *ctx, int battlerId, u16 moveNo) {
    s8 priority = BattleMoveTbl(ctx, moveNo)->priority;

    if (moveNo == MOVE_NONE) {
        return priority;
    }

    // Grassy Glide is hurried by the grass rather than by an ability, so it is
    // outside the switch. The reference never asks whether the user is
    // standing on that grass, only whether the grass is there.
    if (moveNo == MOVE_GRASSY_GLIDE && ctx->terrainOverlayType == GRASSY_TERRAIN) {
        priority++;
    }

    switch (GetBattlerAbility(ctx, battlerId)) {
    case ABILITY_PRANKSTER:
        if (BattleMoveTbl(ctx, moveNo)->category == CATEGORY_STATUS) {
            priority++;
        }
        break;
    case ABILITY_GALE_WINGS:
        if (BattleMoveTbl(ctx, moveNo)->type == TYPE_FLYING && ctx->battleMons[battlerId].hp == (s32)ctx->battleMons[battlerId].maxHp) {
            priority++;
        }
        break;
    case ABILITY_TRIAGE:
        if (MoveIsInList(moveNo, sTriageMoves, NELEMS(sTriageMoves)) == TRUE) {
            priority += 3;
        }
        break;
    default:
        break;
    }

    return priority;
}

u8 CheckSortSpeed(BattleSystem *battleSystem, BattleContext *ctx, int battlerId1, int battlerId2, int flag) {
    u8 ret = 0; // 0 - don't sort, 1 - sort, 2 - sort (speed tie + won random check)
    u32 speed1, speed2;
    u16 moveNo1 = 0;
    u16 moveNo2 = 0;
    u8 heldItem1;
    u8 extra1;
    u8 heldItem2;
    u8 extra2;
    s8 movePriority1 = 0;
    s8 movePriority2 = 0;
    u8 boostedPriority1 = 0;
    u8 boostedPriority2 = 0;
    u8 loweredPriority1 = 0;
    u8 loweredPriority2 = 0;
    int action1;
    int action2;
    int movePos1;
    int movePos2;
    int ability1;
    int ability2;
    int speedStatChange1;
    int speedStatChange2;
    int i;

    if (ctx->battleMons[battlerId1].hp == 0 && ctx->battleMons[battlerId2].hp) {
        return 1;
    }
    if (ctx->battleMons[battlerId1].hp && ctx->battleMons[battlerId2].hp == 0) {
        return 0;
    }

    // After You puts a battler next and Quash puts it last, whatever its
    // speed. The pair only disagrees when one of them carries the mark.
    if (ctx->turnData[battlerId1].forceExecutionOrder != ctx->turnData[battlerId2].forceExecutionOrder) {
        if (ctx->turnData[battlerId1].forceExecutionOrder == EXECUTION_ORDER_AFTER_YOU || ctx->turnData[battlerId2].forceExecutionOrder == EXECUTION_ORDER_QUASH) {
            return 0;
        }
        if (ctx->turnData[battlerId1].forceExecutionOrder == EXECUTION_ORDER_QUASH || ctx->turnData[battlerId2].forceExecutionOrder == EXECUTION_ORDER_AFTER_YOU) {
            return 1;
        }
    }

    ability1 = GetBattlerAbility(ctx, battlerId1);
    ability2 = GetBattlerAbility(ctx, battlerId2);

    heldItem1 = GetBattlerHeldItemEffect(ctx, battlerId1);
    extra1 = GetHeldItemModifier(ctx, battlerId1, 0);
    heldItem2 = GetBattlerHeldItemEffect(ctx, battlerId2);
    extra2 = GetHeldItemModifier(ctx, battlerId2, 0);

    speedStatChange1 = ctx->battleMons[battlerId1].statChanges[3];
    speedStatChange2 = ctx->battleMons[battlerId2].statChanges[3];

    if (GetBattlerAbility(ctx, battlerId1) == ABILITY_SIMPLE) {
        speedStatChange1 = 6 + (speedStatChange1 - 6) * 2;

        if (speedStatChange1 > BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            speedStatChange1 = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
        }

        if (speedStatChange1 < 0) {
            speedStatChange1 = 0;
        }
    }
    if (GetBattlerAbility(ctx, battlerId2) == ABILITY_SIMPLE) {
        speedStatChange2 = 6 + (speedStatChange2 - 6) * 2;

        if (speedStatChange2 > BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            speedStatChange2 = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
        }

        if (speedStatChange2 < 0) {
            speedStatChange2 = 0;
        }
    }

    speed1 = ctx->battleMons[battlerId1].speed * sStatChangeTable[speedStatChange1][0] / sStatChangeTable[speedStatChange1][1];
    speed2 = ctx->battleMons[battlerId2].speed * sStatChangeTable[speedStatChange2][0] / sStatChangeTable[speedStatChange2][1];

    if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
        // Not under a Utility Umbrella (Superombrello).
        if ((ability1 == ABILITY_SWIFT_SWIM && WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId1) & FIELD_CONDITION_RAIN_ALL) || (ability1 == ABILITY_CHLOROPHYLL && WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId1) & FIELD_CONDITION_SUN_ALL) || (ability1 == ABILITY_SAND_RUSH && ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) || (ability1 == ABILITY_SLUSH_RUSH && ctx->fieldCondition & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL))) {
            speed1 *= 2;
        }
        if ((ability2 == ABILITY_SWIFT_SWIM && WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId2) & FIELD_CONDITION_RAIN_ALL) || (ability2 == ABILITY_CHLOROPHYLL && WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId2) & FIELD_CONDITION_SUN_ALL) || (ability2 == ABILITY_SAND_RUSH && ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) || (ability2 == ABILITY_SLUSH_RUSH && ctx->fieldCondition & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL))) {
            speed2 *= 2;
        }
    }

    // Surge Surfer is the terrain's answer to Swift Swim and reads the same
    // way, but outside the block above: Cloud Nine and Air Lock blot out the
    // weather and leave the ground alone.
    if (ctx->terrainOverlayType == ELECTRIC_TERRAIN) {
        if (ability1 == ABILITY_SURGE_SURFER) {
            speed1 *= 2;
        }
        if (ability2 == ABILITY_SURGE_SURFER) {
            speed2 *= 2;
        }
    }

    // Protosynthesis and Quark Drive raise whichever stat was highest when
    // they switched on, and Speed is the one they raise by half rather than by
    // three tenths. Which stat that is was settled once, in
    // BattleContext_ActivateParadoxAbility; here it is only read.
    if ((ability1 == ABILITY_PROTOSYNTHESIS || ability1 == ABILITY_QUARK_DRIVE) && ctx->paradoxBoostedStat[battlerId1] == STAT_SPEED) {
        speed1 = speed1 * 15 / 10;
    }
    if ((ability2 == ABILITY_PROTOSYNTHESIS || ability2 == ABILITY_QUARK_DRIVE) && ctx->paradoxBoostedStat[battlerId2] == STAT_SPEED) {
        speed2 = speed2 * 15 / 10;
    }

    for (i = 0; i < NELEMS(sSpeedHalvingItemEffects); i++) {
        if (GetItemVar(ctx, ctx->battleMons[battlerId1].item, ITEM_VAR_HOLD_EFFECT) == sSpeedHalvingItemEffects[i]) {
            speed1 /= 2;
            break;
        }
    }

    if (heldItem1 == HOLD_EFFECT_CHOICE_SPEED) {
        speed1 = speed1 * 15 / 10;
    }

    if (heldItem1 == HOLD_EFFECT_DITTO_SPEED_UP && ctx->battleMons[battlerId1].species == SPECIES_DITTO) {
        speed1 *= 2;
    }

    if (ability1 == ABILITY_QUICK_FEET && ctx->battleMons[battlerId1].status & 0xFF) {
        speed1 = speed1 * 15 / 10;
    } else if (ctx->battleMons[battlerId1].status & STATUS_PARALYSIS) {
        // Paralysis halves Speed, rounding a half up, as the reference's
        // QMul_RoundUp(speed, UQ412__0_5) does. HeartGold quartered it.
        speed1 = (speed1 + 1) / 2;
    }

    if (ability1 == ABILITY_SLOW_START && ctx->totalTurns - ctx->battleMons[battlerId1].unk88.slowStartTurns < 5) {
        speed1 /= 2;
    }

    if (ability1 == ABILITY_UNBURDEN && ctx->battleMons[battlerId1].unk88.knockOffFlag && ctx->battleMons[battlerId1].item == FALSE) {
        speed1 *= 2;
    }

    if (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId1)] & SIDE_CONDITION_TAILWIND) {
        speed1 *= 2;
    }

    // A swamp around the side quarters it (Pokemon Central, Erbapatto).
    if (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId1)] & SIDE_CONDITION_SWAMP) {
        speed1 /= 4;
    }

    if (heldItem1 == HOLD_EFFECT_SOMETIMES_PRIORITY) {
        if (ctx->unk_310C[battlerId1] % (100 / extra1) == 0) {
            boostedPriority1 = 1;

            if (!flag) {
                ctx->battleMons[battlerId1].unk88.quickClawFlag = TRUE;
            }
        }
    }

    if (heldItem1 == HOLD_EFFECT_PINCH_PRIORITY) {
        if (GetBattlerAbility(ctx, battlerId1) == ABILITY_GLUTTONY) {
            extra1 /= 2;
        }
        if (ctx->battleMons[battlerId1].hp <= ctx->battleMons[battlerId1].maxHp / extra1) {
            boostedPriority1 = 1;
            if (!flag) {
                ctx->battleMons[battlerId1].unk88.custapBerryFlag = TRUE;
            }
        }
    }

    if (heldItem1 == HOLD_EFFECT_SPEED_DOWN) {
        loweredPriority1 = 1;
    }

    for (i = 0; i < NELEMS(sSpeedHalvingItemEffects); i++) {
        if (GetItemVar(ctx, ctx->battleMons[battlerId2].item, ITEM_VAR_HOLD_EFFECT) == sSpeedHalvingItemEffects[i]) {
            speed2 /= 2;
            break;
        }
    }

    if (heldItem2 == HOLD_EFFECT_CHOICE_SPEED) {
        speed2 = speed2 * 15 / 10;
    }

    if (heldItem2 == HOLD_EFFECT_DITTO_SPEED_UP && ctx->battleMons[battlerId2].species == SPECIES_DITTO) {
        speed2 *= 2;
    }

    if (ability2 == ABILITY_QUICK_FEET && ctx->battleMons[battlerId2].status & 0xFF) {
        speed2 = speed2 * 15 / 10;
    } else if (ctx->battleMons[battlerId2].status & STATUS_PARALYSIS) {
        speed2 = (speed2 + 1) / 2;
    }

    if (ability2 == ABILITY_SLOW_START && ctx->totalTurns - ctx->battleMons[battlerId2].unk88.slowStartTurns < 5) {
        speed2 /= 2;
    }

    if (ability2 == ABILITY_UNBURDEN && ctx->battleMons[battlerId2].unk88.knockOffFlag && ctx->battleMons[battlerId2].item == FALSE) {
        speed2 *= 2;
    }

    if (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId2)] & SIDE_CONDITION_TAILWIND) {
        speed2 *= 2;
    }

    if (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId2)] & SIDE_CONDITION_SWAMP) {
        speed2 /= 4;
    }

    if (heldItem2 == HOLD_EFFECT_SOMETIMES_PRIORITY) {
        if (ctx->unk_310C[battlerId2] % (100 / extra2) == 0) {
            boostedPriority2 = 1;

            if (!flag) {
                ctx->battleMons[battlerId2].unk88.quickClawFlag = TRUE;
            }
        }
    }

    if (heldItem2 == HOLD_EFFECT_PINCH_PRIORITY) {
        if (GetBattlerAbility(ctx, battlerId2) == ABILITY_GLUTTONY) {
            extra2 /= 2;
        }
        if (ctx->battleMons[battlerId2].hp <= ctx->battleMons[battlerId2].maxHp / extra2) {
            boostedPriority2 = 1;
            if (!flag) {
                ctx->battleMons[battlerId2].unk88.custapBerryFlag = TRUE;
            }
        }
    }

    if (heldItem2 == HOLD_EFFECT_SPEED_DOWN) {
        loweredPriority2 = 1;
    }

    ctx->effectiveSpeed[battlerId1] = speed1;
    ctx->effectiveSpeed[battlerId2] = speed2;

    if (!flag) {
        action1 = ctx->playerActions[battlerId1].inputSelection;
        action2 = ctx->playerActions[battlerId2].inputSelection;
        movePos1 = ctx->movePos[battlerId1];
        movePos2 = ctx->movePos[battlerId2];
        if (action1 == 1) { // fight button
            if (ctx->turnData[battlerId1].struggleFlag) {
                moveNo1 = MOVE_STRUGGLE;
            } else {
                moveNo1 = GetBattlerVar(ctx, battlerId1, BMON_DATA_MOVE1 + movePos1, NULL);
            }
        }
        if (action2 == 1) { // fight button
            if (ctx->turnData[battlerId2].struggleFlag) {
                moveNo2 = MOVE_STRUGGLE;
            } else {
                moveNo2 = GetBattlerVar(ctx, battlerId2, BMON_DATA_MOVE1 + movePos2, NULL);
            }
        }
        movePriority1 = BattlerMovePriority(ctx, battlerId1, moveNo1);
        movePriority2 = BattlerMovePriority(ctx, battlerId2, moveNo2);

        // Quick Draw is a Quick Claw the Pokemon was born with, three chances
        // in ten and only for an attack, so it waits until the move is known.
        // It reads the high byte of the turn's roll: Quick Claw reads it modulo
        // five, which the high byte says nothing about, so a Pokemon with both
        // gets two separate chances rather than one.
        if (ability1 == ABILITY_QUICK_DRAW && moveNo1 && BattleMoveTbl(ctx, moveNo1)->category != CATEGORY_STATUS && (ctx->unk_310C[battlerId1] >> 8) % 10 < 3) {
            boostedPriority1 = 1;
            ctx->battleMons[battlerId1].unk88.quickDrawFlag = TRUE;
        }
        if (ability2 == ABILITY_QUICK_DRAW && moveNo2 && BattleMoveTbl(ctx, moveNo2)->category != CATEGORY_STATUS && (ctx->unk_310C[battlerId2] >> 8) % 10 < 3) {
            boostedPriority2 = 1;
            ctx->battleMons[battlerId2].unk88.quickDrawFlag = TRUE;
        }
    }

    if (movePriority1 == movePriority2) {
        if (boostedPriority1 && boostedPriority2) {
            if (speed1 < speed2) {
                ret = 1;
            } else if (speed1 == speed2 && BattleSystem_Random(battleSystem) & 1) {
                ret = 2;
            }
        } else if (!boostedPriority1 && boostedPriority2) {
            ret = 1;
        } else if (boostedPriority1 && !boostedPriority2) {
            ret = 0;
        } else if (loweredPriority1 && loweredPriority2) {
            if (speed1 > speed2) {
                ret = 1;
            } else if (speed1 == speed2 && BattleSystem_Random(battleSystem) & 1) {
                ret = 2;
            }
        } else if (loweredPriority1 && !loweredPriority2) {
            ret = 1;
        } else if (!loweredPriority1 && loweredPriority2) {
            ret = 0;
        } else if (ability1 == ABILITY_STALL && ability2 == ABILITY_STALL) {
            if (speed1 > speed2) {
                ret = 1;
            } else if (speed1 == speed2 && BattleSystem_Random(battleSystem) & 1) {
                ret = 2;
            }
        } else if (ability1 == ABILITY_STALL && ability2 != ABILITY_STALL) {
            ret = 1;
        } else if (ability1 != ABILITY_STALL && ability2 == ABILITY_STALL) {
            ret = 0;
        } else if (ctx->fieldCondition & FIELD_CONDITION_TRICK_ROOM) {
            if (speed1 > speed2) {
                ret = 1;
            }
            if (speed1 == speed2 && BattleSystem_Random(battleSystem) & 1) {
                ret = 2;
            }
        } else {
            if (speed1 < speed2) {
                ret = 1;
            }
            if (speed1 == speed2 && BattleSystem_Random(battleSystem) & 1) {
                ret = 2;
            }
        }
    } else if (movePriority1 < movePriority2) {
        ret = 1;
    }

    return ret;
}

// Function may be mislabeled
void BattleSystem_ClearExperienceEarnFlags(BattleContext *ctx, int battlerId) {
    ctx->unk_A4[(battlerId >> 1) & 1] = 0;
}

void BattleSystem_SetExperienceEarnFlags(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i = 0;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    while (i <= 2) {
        if (!(ctx->switchInFlag & MaskOfFlagNo(i)) && !(ctx->switchInFlag & MaskOfFlagNo(battlerId)) && ctx->battleMons[battlerId].hp) {
            ctx->unk_A4[(battlerId >> 1) & 1] |= MaskOfFlagNo(ctx->selectedMonIndex[i]);
        }
        i += 2;
        if (battleType == 0x4a || battleType == 0x4b) {
            break;
        }
    }
}

BOOL ov12_022503EC(BattleSystem *battleSystem, BattleContext *ctx, int *out) {
    BOOL ret = FALSE;

    if (ctx->unk_2170 & (1 << 29)) {
        *out = GetMoveStatusChangeScript(ctx, 1, ctx->unk_2170);
        ctx->unk_2170 = 0;
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
            ret = TRUE;
        }
    } else if (ctx->unk_2170) {
        *out = GetMoveStatusChangeScript(ctx, 1, ctx->unk_2170);
        if (ctx->battleMons[ctx->battlerIdStatChange].hp && (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) || ((ctx->unk_2170 & (1 << 23)) && (ctx->moveStatusFlag & 0x40008)) || ((ctx->unk_2170 & (1 << 28)) && (ctx->moveStatusFlag & 0x10001)))) {
            ret = TRUE;
        }
        ctx->unk_2170 = 0;
    }

    return ret;
}

// Sheer Force gives up whatever a move does on top of its damage in exchange
// for a third again the power. What it gives up is exactly the effects
// ov12_02250490 rolls against the move's effect chance: the branches above
// those happen come what may and are not secondary effects at all. The effect
// script sets this before it asks for the damage, so both halves of the
// ability can ask the same question.
//
// Two effects the reference lists by name are not rolled: Psychic Noise's
// Heal Block lands after the hit with no chance to roll, and the trap of
// Anchor Shot and Spirit Shackle once the move is over (TryHoldAfterHit,
// which asks this through SheerForceTradedEffect and the cloak itself).
// Thousand Waves shares the trap's effect, and the reference lists it, but
// its hold is no additional effect: Sheer Force does not power it and a
// Covert Cloak does not keep it off (Pokemon Central, Mille Onde). Stone
// Axe's stones, laid once the move is over, are one more that Sheer Force
// trades for power (Rocciascure: "Le rocce aguzze non vengono piazzate
// quando Rocciascure e usata da un Pokemon con l'abilita Forzabruta", and it
// is in Forzabruta's list of the moves it powers).
// The three Fangs come as a side effect on hit, and their subscript rolls the
// status and the flinch against the chance itself, one after the other; both
// are additional effects all the same (Pokemon Central, Forzabruta and
// Anonimanto), and the reference lists the three by name.
static BOOL IsSuppressibleSecondaryEffect(BattleContext *ctx, u32 moveNo) {
    switch (BattleMoveTbl(ctx, moveNo)->effect) {
    case MOVE_EFFECT_PREVENT_ESCAPE_HIT:
        return moveNo != MOVE_THOUSAND_WAVES;
    case MOVE_EFFECT_FLINCH_BURN_HIT:
    case MOVE_EFFECT_FLINCH_FREEZE_HIT:
    case MOVE_EFFECT_FLINCH_PARALYZE_HIT:
    case MOVE_EFFECT_PREVENT_HEALING_HIT:
    case MOVE_EFFECT_STEALTH_ROCK_HIT:
        return TRUE;
    }
    return ctx->unk_2174 != 0 && BattleMoveTbl(ctx, moveNo)->effectChance != 0 && !(ctx->unk_2174 & (MOVE_SIDE_EFFECT_ON_HIT | MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE | MOVE_SIDE_EFFECT_CHECK_HP_AND_SUBSTITUTE | MOVE_SIDE_EFFECT_CHECK_HP));
}

// Whether Sheer Force traded the attacker's move effect for power, for what
// answers the hit: Emergency Exit's arming, Berserk, Anger Shell, Pickpocket,
// the Red Card and the Eject Button, the user's Shell Bell and Life Orb, and
// Relic Song's change of form (Pokemon Central, Forzabruta), and Shell Trap,
// which a boosted move does not set off.
// From the effect roll on, the flags IsSuppressibleSecondaryEffect reads are
// gone -- ov12_02250490 clears them as it rolls or gives the effect up -- so
// what it found then is kept for the rest of the action.
BOOL SheerForceTradedEffect(BattleContext *ctx) {
    return GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SHEER_FORCE
        && (ctx->selfTurnData[ctx->battlerIdAttacker].sheerForceTraded || IsSuppressibleSecondaryEffect(ctx, ctx->moveNoCur) == TRUE);
}

// Emergency Exit and Wimp Out (Activate_WimpOut_EmergencyExit,
// ServerDoPostMoveEffects.c:2629 at d0380a487; Pokemon Central's Passoindietro
// and Fuggifuggi): a Pokemon a move takes from above half its health to half
// or below leaves once the move is over -- switched out, or fled if it is a
// wild Pokemon.
//
// Each hit about to land arms the Pokemon if it is above half, holds one of
// the two, and the move is not one Sheer Force has boosted. The reference asks
// instead whether the last hit alone crossed half, which misses a multi-strike
// move whose earlier hit carried it past; the games wait for the last hit and
// ask about the whole move. Only a move's hit arms it, so a confusion blow, a
// Belly Drum or a Substitute does not, as in the games. A wild Pokemon flees,
// as in the games; the reference keeps it in, having no Pokemon to send. Damage
// from outside a move arms it through Battler_ArmRetreatOutsideMove below; the
// reference has none of that.
void Battler_ArmRetreat(BattleContext *ctx, int battlerId) {
    int ability = GetBattlerAbility(ctx, battlerId);

    if ((ability == ABILITY_EMERGENCY_EXIT || ability == ABILITY_WIMP_OUT)
        && ctx->battleMons[battlerId].hp > (int)(ctx->battleMons[battlerId].maxHp / 2)
        && !SheerForceTradedEffect(ctx)) {
        ctx->selfTurnData[battlerId].retreatArmed = TRUE;
    }
}

// A wild Pokemon: one across the field outside a trainer battle. Its
// Emergency Exit and Wimp Out make it flee; its Magician and Pickpocket take
// nothing.
static BOOL Battler_IsWild(BattleSystem *battleSystem, int battlerId) {
    return !(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TRAINER) && BattleSystem_GetFieldSide(battleSystem, battlerId) != 0;
}

// Whether the Pokemon in this slot leaves now: still at half or below, still
// holding the ability (Mummy or Wandering Spirit taking it on contact comes
// first), which Mold Breaker does not pass (the reference's AbilityFlags
// leaves both unignorable), and with somewhere to go: not a Pokemon Commander
// holds on the field (Pokemon Central, Torre di Comando), which would only
// shut the Eject Packs of the move for a switch its script refuses.
static BOOL Battler_Retreats(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    if (!ctx->selfTurnData[battlerId].retreatArmed
        || ctx->battleMons[battlerId].hp == 0
        || ctx->battleMons[battlerId].hp > (int)(ctx->battleMons[battlerId].maxHp / 2)) {
        return FALSE;
    }
    if (GetBattlerAbility(ctx, battlerId) != ABILITY_EMERGENCY_EXIT
        && GetBattlerAbility(ctx, battlerId) != ABILITY_WIMP_OUT) {
        return FALSE;
    }
    return Battler_IsWild(battleSystem, battlerId) || (CanSwitchMon(battleSystem, ctx, battlerId) && !Battler_HeldByCommander(ctx, battlerId));
}

// Damage from outside a move sets the two off as well (Pokemon Central,
// Passoindietro: any damage that takes the Pokemon to half or below, but for
// a confusion blow and the HP a move of its own costs its user). The reference
// asks only a move's damage. Such damage arms the holder here, and
// TryRetreatAbilityOutsideMove asks once the action or the turn is over.
void Battler_ArmRetreatOutsideMove(BattleContext *ctx, int battlerId) {
    int ability = GetBattlerAbility(ctx, battlerId);

    if ((ability == ABILITY_EMERGENCY_EXIT || ability == ABILITY_WIMP_OUT)
        && ctx->battleMons[battlerId].hp > (int)(ctx->battleMons[battlerId].maxHp / 2)) {
        ctx->selfTurnData[battlerId].retreatArmedOutsideMove = TRUE;
    }
}

// Once an action is over (ov12_0224D368) and once the turn's end is (TurnEnd),
// in speed order. No move is under way, so no attacker's Mold Breaker is asked.
// A mark that does not send its Pokemon off is kept until the action ends, so
// a later ask in the same action still sees it.
BOOL TryRetreatAbilityOutsideMove(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (int i = 0; i < maxBattlers; i++) {
        int battlerId = ctx->turnOrder[i];
        int ability = GetBattlerAbility(ctx, battlerId);

        if (!ctx->selfTurnData[battlerId].retreatArmedOutsideMove
            || ctx->battleMons[battlerId].hp == 0
            || ctx->battleMons[battlerId].hp > (int)(ctx->battleMons[battlerId].maxHp / 2)
            || (ability != ABILITY_EMERGENCY_EXIT && ability != ABILITY_WIMP_OUT)
            || !(Battler_IsWild(battleSystem, battlerId) || CanSwitchMon(battleSystem, ctx, battlerId))) {
            continue;
        }
        ctx->selfTurnData[battlerId].retreatArmedOutsideMove = FALSE;
        ctx->battlerIdTemp = battlerId;
        ctx->tempData = Battler_IsWild(battleSystem, battlerId);
        *script = BATTLE_SUBSCRIPT_EMERGENCY_EXIT;
        return TRUE;
    }
    return FALSE;
}

// Once the move is over, after the attacker's Shell Bell and Life Orb, in
// speed order: the reference's step 22, after the items and before Parting
// Shot, U-turn, Pickpocket, the Throat Spray and the Eject Pack. TEMP_DATA
// tells the subscript to flee.
BOOL TryRetreatAbility(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (int i = 0; i < maxBattlers; i++) {
        int battlerId = ctx->turnOrder[i];
        BOOL retreats = Battler_Retreats(battleSystem, ctx, battlerId);

        ctx->selfTurnData[battlerId].retreatArmed = FALSE;
        if (retreats) {
            ctx->battlerIdTemp = battlerId;
            ctx->tempData = Battler_IsWild(battleSystem, battlerId);
            *script = BATTLE_SUBSCRIPT_EMERGENCY_EXIT;
            return TRUE;
        }
    }
    return FALSE;
}

// A flung item that lands, where the hit is known: TryFling, which runs
// before it, only chose what the item would do. It asks what subscript 220
// asks before it runs the item's script: a script to run, the target standing
// and no substitute in the way. A Leppa Berry restores the PP TryFling chose
// and a White Herb the lowered stats -- neither when the Fling misses or hits
// a substitute. A Berry flung at a Cud Chew Pokemon is kept for the turn
// after (Pokemon Central, Ruminante: Lancio); the Berry itself left the
// thrower's hand through RemoveItem, which kept it in recycleItem.
static void FlungItemLands(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId = ctx->battlerIdStatChange;
    int stat;

    if (!ctx->flingScript || !ctx->battleMons[battlerId].hp) {
        return;
    }
    if (((ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE) || (ctx->selfTurnData[battlerId].unk14 & SELF_TURN_FLAG_SUBSTITUTE_HIT))
        && !InfiltratorGoesRoundSubstitute(ctx, battlerId)) {
        return;
    }
    switch (ctx->flingScript) {
    case BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE:
        BattleMon_AddVar(&ctx->battleMons[battlerId], BMON_DATA_CUR_PP_1 + BattleMon_GetMoveIndex(&ctx->battleMons[battlerId], ctx->moveTemp), ctx->flingData);
        CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
        break;
    case BATTLE_SUBSCRIPT_HELD_ITEM_STATDOWN_RESTORE:
        for (stat = 0; stat < 8; stat++) {
            if (ctx->battleMons[battlerId].statChanges[stat] < 6) {
                ctx->battleMons[battlerId].statChanges[stat] = 6;
            }
        }
        break;
    }
    CudChewKeepsBerry(ctx, battlerId, ctx->recycleItem[ctx->battlerIdAttacker]);
    // A Berry that lands is eaten by the Pokemon it lands on, which Belch
    // counts (Pokemon Central, Rutto); not by the thrower (BtlCmd_RemoveItem).
    if (ItemIdIsBerry(ctx->recycleItem[ctx->battlerIdAttacker]) == TRUE) {
        RememberBerryEaten(battleSystem, ctx, battlerId);
    }
}

// What the flung item does, as it lands: the engine's first step for each
// Pokemon a move hits (MovePerformance_Step_9, ServerDoPostMoveEffects.c:2215
// at d0380a487), before the flinch and the move's other effects, where
// retail's effect script 233 set it as the move's side effect. Subscript 220
// asks for a script to run, the target standing and no substitute in the
// way; FlungItemLands does what the item's own script does not.
BOOL TryFlungItemEffect(BattleSystem *battleSystem, BattleContext *ctx) {
    if (BattleMoveTbl(ctx, ctx->moveNoCur)->effect != MOVE_EFFECT_FLING || ctx->battlerIdTarget == BATTLER_NONE
        || (ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
        return FALSE;
    }
    ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
    ctx->battlerIdStatChange = ctx->battlerIdTarget;
    FlungItemLands(battleSystem, ctx);
    ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_FLING);
    ctx->commandNext = ctx->command;
    ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    return TRUE;
}

// Burning Jealousy burns only a target whose stats rose during this turn, by
// whatever means (Pokemon Central, Fiamminvidia), and Alluring Voice confuses
// only such a target (Ammaliavoce); the rest they only hurt. The chance is
// the move's 100 once it applies, and Sheer Force still takes it away and pays
// the power for it either way, as the pages have it.
static BOOL SecondaryEffectMeetsItsTarget(BattleContext *ctx) {
    if (ctx->moveNoCur == MOVE_BURNING_JEALOUSY || ctx->moveNoCur == MOVE_ALLURING_VOICE) {
        return ctx->turnData[ctx->battlerIdTarget].statRaised;
    }
    return TRUE;
}

// The flinches among the added effects.
static const u16 sFlinchEffects[] = {
    MOVE_EFFECT_FLINCH_HIT,
    MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH,
    MOVE_EFFECT_FLINCH_DOUBLE_DAMAGE_FLY_OR_BOUNCE,
    MOVE_EFFECT_FLINCH_MINIMIZE_DOUBLE_HIT,
    MOVE_EFFECT_FLINCH_POISON_HIT,
    MOVE_EFFECT_FLINCH_BURN_HIT,
    MOVE_EFFECT_FLINCH_FREEZE_HIT,
    MOVE_EFFECT_FLINCH_PARALYZE_HIT,
    MOVE_EFFECT_HIT_TWICE_AND_FLINCH,
};

// The chance of the move's added effect: twice over with Serene Grace, and
// twice over again under a rainbow on the user's side -- not for Secret
// Power, and not on top of Serene Grace for a flinch (Pokemon Central,
// Acquapatto, Fiammapatto).
u16 MoveEffectChance(BattleSystem *battleSystem, BattleContext *ctx) {
    u16 chance = BattleMoveTbl(ctx, ctx->moveNoCur)->effectChance;
    BOOL sereneGrace = GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SERENE_GRACE;

    if (sereneGrace) {
        chance *= 2;
    }
    if ((ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker)] & SIDE_CONDITION_RAINBOW)
        && ctx->moveNoCur != MOVE_SECRET_POWER
        && !(sereneGrace && MoveIsInList(BattleMoveTbl(ctx, ctx->moveNoCur)->effect, sFlinchEffects, NELEMS(sFlinchEffects)))) {
        chance *= 2;
    }
    return chance;
}

BOOL ov12_02250490(BattleSystem *battleSystem, BattleContext *ctx, int *out) {
    BOOL ret = FALSE;
    u16 effectChance;
    u32 sideEffect = ctx->unk_2174;

    // A Covert Cloak on whoever was hit eats the same effects Sheer Force
    // gives up, and the reference asks the two in one condition here. What it
    // does not do is the other half of Sheer Force -- the cloak is the target's
    // item and buys the attacker nothing, so the power boost in CalcMoveDamage
    // stays the ability's alone.
    //
    // Nor does the cloak stop what the move does to its own user: it keeps its
    // holder from the additional effects of others' moves (Pokemon Central,
    // Anonimanto), and Power-Up Punch's boost, Flame Charge's or Rapid Spin's
    // rise lands on the attacker. The reference's cloak list is Sheer Force's,
    // self-targeting effects included, and swallows those too. Rapid Spin's
    // clearing, which the cloak does stop, asks for it in subscript 115.
    if (IsSuppressibleSecondaryEffect(ctx, ctx->moveNoCur) == TRUE && GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SHEER_FORCE) {
        ctx->selfTurnData[ctx->battlerIdAttacker].sheerForceTraded = TRUE;
    }
    if (IsSuppressibleSecondaryEffect(ctx, ctx->moveNoCur) == TRUE
        && (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SHEER_FORCE
            || (ctx->battlerIdTarget != BATTLER_NONE
                && !(ctx->unk_2174 & MOVE_SIDE_EFFECT_TO_ATTACKER)
                && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) == HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS))) {
        ctx->unk_2174 = 0;
        return FALSE;
    }

    if (ctx->unk_2174 & (1 << 29)) {
        *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
        ctx->unk_2174 = 0;
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
            ret = TRUE;
        }
    } else if (ctx->unk_2174 & (1 << 24)) {
        *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
        ctx->unk_2174 = 0;
        if (!BattlerCheckSubstitute(ctx, ctx->battlerIdStatChange) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
            ret = TRUE;
        }
    } else if (ctx->unk_2174 & (1 << 25)) {
        *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
        ctx->unk_2174 = 0;
        if (ctx->battleMons[ctx->battlerIdStatChange].hp && !BattlerCheckSubstitute(ctx, ctx->battlerIdStatChange) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
            ret = TRUE;
        }
    } else if (ctx->unk_2174 & (1 << 28)) {
        *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
        ctx->unk_2174 = 0;
        if (ctx->battleMons[ctx->battlerIdStatChange].hp) {
            ret = TRUE;
        }
    } else if (ctx->unk_2174 & (1 << 26)) {
        effectChance = MoveEffectChance(battleSystem, ctx);

        GF_ASSERT(effectChance);

        if ((BattleSystem_Random(battleSystem) % 100) < effectChance) {
            ctx->battleStatus |= BATTLE_STATUS_SECONDARY_EFFECT;
        }
        *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
        ctx->unk_2174 = 0;

        if (!ctx->battleMons[ctx->battlerIdStatChange].hp) {
            ctx->battleStatus &= ~BATTLE_STATUS_SECONDARY_EFFECT;
        }

        ret = TRUE;
    } else if (ctx->unk_2174 && !SecondaryEffectMeetsItsTarget(ctx)) {
        ctx->unk_2174 = 0;
    } else if (ctx->unk_2174) {
        effectChance = MoveEffectChance(battleSystem, ctx);

        GF_ASSERT(effectChance);

        if ((BattleSystem_Random(battleSystem) % 100) < effectChance) {
            *out = GetMoveStatusChangeScript(ctx, 2, ctx->unk_2174);
            ctx->unk_2174 = 0;

            if (ctx->battleMons[ctx->battlerIdStatChange].hp && !BattlerCheckSubstitute(ctx, ctx->battlerIdStatChange) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {
                ret = TRUE;
            }
        }
    } else if (ctx->unk_2178) {
        *out = GetMoveStatusChangeScript(ctx, 3, ctx->unk_2178);
        ctx->unk_2178 = 0;

        if (ctx->battleMons[ctx->battlerIdStatChange].hp) {
            ret = TRUE;
        }
    }

    // What these do waits for Parental Bond's second strike (Pokemon Central,
    // Amorefiliale): Dragon Tail's switch and Smack Down's fall, and the
    // terrain Steel Roller and Ice Spinner tear up, which Steel Roller needs
    // for its second strike. The reference does these after the move; here
    // they come with the hit, so the first strike leaves them to the second,
    // unless the first was the last. (The cure Smelling Salts and Wake-Up Slap
    // give, Knock Off's knocking, Thief's taking, Pluck's eating, and the
    // holds and hazards of the moves past retail's are post-move steps here
    // too, TryAdditionalMoveEffect and TryHoldAfterHit, and U-turn's switch is
    // TryPivotSwitch.)
    //
    // The first strike can still prove the last once these have been asked:
    // Effect Spore puts the user to sleep, and the move ends there (Pokemon
    // Central, Spargispora). What was left to the second strike is then done
    // after all, as after the last strike, by the multi-strike loop
    // (ov12_0224CF14), which parentalBondDeferred tells what it was. The
    // recoil is no side effect: it comes once the move is over (TryRecoil),
    // from the damage of the strikes there were.
    if (ret == TRUE && ParentalBond_StrikeToCome(ctx)) {
        switch (*out) {
        case BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE:
        case BATTLE_SUBSCRIPT_FELL_STRAIGHT_DOWN:
        case BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END:
            ctx->parentalBondDeferred = sideEffect;
            ret = FALSE;
            break;
        }
    }

    // Dragon Tail and Circle Throw drag their target out after it has
    // answered the hit -- its Rough Skin, Justified, Rocky Helmet or Berry --
    // as in the games, where the drag comes at the end of the move; here the
    // hit's side effect would drag it before those steps, which would then
    // find a Pokemon that took no hit. The target is marked instead, and
    // ov12_0224E1BC drags it once the hit's steps are over. Roar and
    // Whirlwind hit nothing and drag as they are used.
    if (ret == TRUE && *out == BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE
        && BattleMoveTbl(ctx, ctx->moveNoCur)->category != CATEGORY_STATUS) {
        ctx->selfTurnData[ctx->battlerIdStatChange].dragPending = TRUE;
        ret = FALSE;
    }

    return ret;
}

// Propeller Tail and Stalwart both aim where they were told. The reference
// never tells the two apart -- every read of one is the same condition as the
// read of the other -- so they are one question here.
static BOOL BattlerIgnoresRedirection(BattleContext *ctx, int battlerId) {
    int ability = GetBattlerAbility(ctx, battlerId);
    return ability == ABILITY_PROPELLER_TAIL || ability == ABILITY_STALWART;
}

int ov12_022506D4(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, u16 moveNo, int a4, int range) {
    int battlerIdTarget = BATTLER_NONE;
    int moveRange;

    if (moveNo) {
        moveRange = BattleMoveTbl(ctx, moveNo)->range;
    } else {
        moveRange = range;
    }

    if (moveRange == RANGE_ADJACENT_OPPONENTS) {
        int battlerId;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
        OpponentData *opponent = BattleSystem_GetOpponentData(battleSystem, battlerIdAttacker);
        u8 flag = ov12_02261258(opponent);

        for (ctx->unk_217E = 0; ctx->unk_217E < maxBattlers; ctx->unk_217E++) {
            battlerId = ctx->turnOrder[ctx->unk_217E];
            if (ctx->battleMons[battlerId].hp) {
                opponent = BattleSystem_GetOpponentData(battleSystem, battlerId);
                if (((flag & 1) && !(ov12_02261258(opponent) & 1)) || (!(flag & 1) && (ov12_02261258(opponent) & 1))) {
                    battlerIdTarget = battlerId;
                    break;
                }
            }
        }

        if (ctx->unk_217E != maxBattlers) {
            ctx->unk_217E++;
        }
    } else if (moveRange == RANGE_ALL_ADJACENT) {
        int battlerId;
        int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

        for (ctx->unk_217E = 0; ctx->unk_217E < maxBattlers; ctx->unk_217E++) {
            battlerId = ctx->turnOrder[ctx->unk_217E];
            if (ctx->battleMons[battlerId].hp) {
                if (battlerId != battlerIdAttacker) {
                    battlerIdTarget = battlerId;
                    break;
                }
            }
        }

        if (ctx->unk_217E != maxBattlers) {
            ctx->unk_217E++;
        }
    } else if (moveRange == RANGE_SINGLE_TARGET_USER_SIDE && (a4 == 1)) {
        int battleType = BattleSystem_GetBattleType(battleSystem);

        if ((battleType & BATTLE_TYPE_DOUBLES) && (BattleSystem_Random(battleSystem) % 2) == 0) {
            battlerIdTarget = BattleSystem_GetBattlerIdPartner(battleSystem, battlerIdAttacker);
            if (!ctx->battleMons[battlerIdTarget].hp) {
                battlerIdTarget = battlerIdAttacker;
            }
        } else {
            battlerIdTarget = battlerIdAttacker;
        }
    } else if (moveRange == RANGE_FRONT && (a4 == 1)) {
        battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerIdAttacker);
    } else if (moveRange == RANGE_OPPONENT_SIDE) {
        battlerIdTarget = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerIdAttacker);
    } else if (moveRange == RANGE_USER || moveRange == RANGE_USER_SIDE || moveRange == RANGE_SINGLE_TARGET_SPECIAL || moveRange == RANGE_FIELD) {
        battlerIdTarget = battlerIdAttacker;
    } else if (moveRange == RANGE_ALLY) {
        int battleType = BattleSystem_GetBattleType(battleSystem);

        if (battleType & BATTLE_TYPE_DOUBLES) {
            battlerIdTarget = BattleSystem_GetBattlerIdPartner(battleSystem, battlerIdAttacker);
        } else {
            battlerIdTarget = battlerIdAttacker;
        }
    } else if (moveRange == RANGE_SINGLE_TARGET_USER_SIDE) {
        int battleType = BattleSystem_GetBattleType(battleSystem);

        if (battleType & BATTLE_TYPE_DOUBLES) {
            battlerIdTarget = ctx->playerActions[battlerIdAttacker].unk4;
            if (!ctx->battleMons[battlerIdTarget].hp) {
                battlerIdTarget = battlerIdAttacker;
            }
        } else {
            battlerIdTarget = battlerIdAttacker;
        }
    } else if (moveRange == RANGE_RANDOM_OPPONENT || a4 == 1) {
        int battleType = BattleSystem_GetBattleType(battleSystem);
        int side = BattleSystem_GetFieldSide(battleSystem, battlerIdAttacker) ^ 1;
        int battlerIdOpponents[2];
        battlerIdOpponents[0] = ov12_0223ABB8(battleSystem, battlerIdAttacker, 0);
        battlerIdOpponents[1] = ov12_0223ABB8(battleSystem, battlerIdAttacker, 2);

        if (battleType & BATTLE_TYPE_DOUBLES) {
            if (!BattlerIgnoresRedirection(ctx, battlerIdAttacker) && ctx->fieldSideConditionData[side].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[side].battlerIdFollowMe].hp) {
                battlerIdTarget = ctx->fieldSideConditionData[side].battlerIdFollowMe;
            } else if (ctx->battleMons[battlerIdOpponents[0]].hp && ctx->battleMons[battlerIdOpponents[1]].hp) {
                // This looks like targeting for Outrage in double battles
                side = BattleSystem_Random(battleSystem) & 1;
                battlerIdTarget = battlerIdOpponents[side];
            } else if (ctx->battleMons[battlerIdOpponents[0]].hp) {
                battlerIdTarget = battlerIdOpponents[0];
            } else if (ctx->battleMons[battlerIdOpponents[1]].hp) {
                battlerIdTarget = battlerIdOpponents[1];
            }
        } else if (ctx->battleMons[battlerIdAttacker ^ 1].hp) {
            battlerIdTarget = battlerIdAttacker ^ 1;
        }
    } else {
        int side = BattleSystem_GetFieldSide(battleSystem, battlerIdAttacker) ^ 1;
        int battlerIdTargetTemp = ctx->playerActions[battlerIdAttacker].unk4;
        BattleSystem_GetMaxBattlers(battleSystem);

        if (battlerIdTargetTemp == battlerIdAttacker) {
            // Aimed at the place its ally stood, which Ally Switch has made
            // its own: the move fails (Pokemon Central, Cambiaposto).
        } else if (!BattlerIgnoresRedirection(ctx, battlerIdAttacker) && ctx->fieldSideConditionData[side].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[side].battlerIdFollowMe].hp) {
            // Follow Me and Rage Powder draw a move aimed at the user's own
            // ally too: "even if it was a friendly target, unless it is a
            // move that cannot target an opponent such as Acupressure or
            // Helping Hand" (Bulbapedia, Follow Me), which take the two
            // branches for the user's side above. As retail does.
            battlerIdTarget = ctx->fieldSideConditionData[side].battlerIdFollowMe;
        } else if (ctx->battleMons[battlerIdTargetTemp].hp) {
            battlerIdTarget = battlerIdTargetTemp;
        } else {
            battlerIdTargetTemp = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerIdAttacker);
            if (ctx->battleMons[battlerIdTargetTemp].hp) {
                battlerIdTarget = battlerIdTargetTemp;
            }
        }
    }

    return battlerIdTarget;
}

void ov12_02250A18(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, u16 moveNo) {
    int side;
    int battlerId;
    int battlerIdTarget;
    int moveType;
    int maxBattlers;

    if (ctx->battlerIdTarget == BATTLER_NONE) {
        return;
    }

    // Mold Breaker, Teravolt and Turboblaze -- and Mycelium Might, for a status
    // move -- pass a Lightning Rod or Storm Drain by, as the reference's
    // CLIENT_HAS_MOLD_BREAKER_VARIATION does: the holders below are asked
    // through CheckBattlerAbilityIfNotIgnored.
    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_NORMALIZE) {
        return;
    }

    // Redirection is the whole of what this function does, so Propeller Tail
    // and Stalwart leave by the same door Mold Breaker does. The reference
    // writes the pair out again at each of the two re-targets below; with
    // nothing else here to reach, one return says the same thing.
    if (BattlerIgnoresRedirection(ctx, battlerIdAttacker)) {
        return;
    }

    side = BattleSystem_GetFieldSide(battleSystem, battlerIdAttacker) ^ 1;

    if (ctx->fieldSideConditionData[side].followMeFlag && ctx->battleMons[ctx->fieldSideConditionData[side].battlerIdFollowMe].hp) {
        return;
    }

    moveType = GetDynamicMoveType(battleSystem, ctx, battlerIdAttacker, moveNo);
    if (!moveType) {
        moveType = BattleMoveTbl(ctx, moveNo)->type;
    }

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (moveType == TYPE_ELECTRIC && (BattleMoveTbl(ctx, moveNo)->range == RANGE_SINGLE_TARGET || BattleMoveTbl(ctx, moveNo)->range == RANGE_RANDOM_OPPONENT) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP_NOT_USER, battlerIdAttacker, ABILITY_LIGHTNINGROD)) {
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            battlerIdTarget = ctx->turnOrder[battlerId];
            if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_LIGHTNINGROD) == TRUE && ctx->battleMons[battlerIdTarget].hp && battlerIdAttacker != battlerIdTarget) {
                break;
            }
        }
        if (battlerId < maxBattlers && battlerIdTarget != ctx->battlerIdTarget) {
            ctx->selfTurnData[battlerIdTarget].lightningRodFlag = TRUE;
            ctx->battlerIdTarget = battlerIdTarget;
        }
    } else if (moveType == TYPE_WATER && (BattleMoveTbl(ctx, moveNo)->range == RANGE_SINGLE_TARGET || BattleMoveTbl(ctx, moveNo)->range == RANGE_RANDOM_OPPONENT) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP_NOT_USER, battlerIdAttacker, ABILITY_STORM_DRAIN)) {
        for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
            battlerIdTarget = ctx->turnOrder[battlerId];
            if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_STORM_DRAIN) == TRUE && ctx->battleMons[battlerIdTarget].hp && battlerIdAttacker != battlerIdTarget) {
                break;
            }
        }
        if (battlerId < maxBattlers && battlerIdTarget != ctx->battlerIdTarget) {
            ctx->selfTurnData[battlerIdTarget].stormDrainFlag = TRUE;
            ctx->battlerIdTarget = battlerIdTarget;
        }
    }
}

BOOL ov12_02250BBC(BattleSystem *battleSystem, BattleContext *ctx) {
    BOOL ret = FALSE;

    if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && ctx->selfTurnData[ctx->battlerIdTarget].lightningRodFlag) {
        ctx->selfTurnData[ctx->battlerIdTarget].lightningRodFlag = FALSE;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 180);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ret = TRUE;
    }

    if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && ctx->selfTurnData[ctx->battlerIdTarget].stormDrainFlag) {
        ctx->selfTurnData[ctx->battlerIdTarget].stormDrainFlag = FALSE;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 180);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        ret = TRUE;
    }

    return ret;
}

void CopyBattleMonToPartyMon(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {

    if (!ctx->battleMons[battlerId].item) {
        ov12_022585A8(ctx, battlerId);
    }

    BattleController_EmitBattleMonToPartyMonCopy(battleSystem, ctx, battlerId);
}

void LockBattlerIntoCurrentMove(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    ctx->battleMons[battlerId].status2 |= STATUS2_LOCKED_INTO_MOVE;
    ctx->moveNoLockedInto[battlerId] = ctx->moveNoCur;
}

void UnlockBattlerOutOfCurrentMove(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    ctx->battleMons[battlerId].status2 &= ~STATUS2_LOCKED_INTO_MOVE;
    ctx->battleMons[battlerId].status2 &= ~STATUS2_BIDE;
    ctx->battleMons[battlerId].moveEffectFlags &= 0xDFFBFF3F;
    ctx->battleMons[battlerId].unk88.rolloutCount = 0;
    ctx->battleMons[battlerId].unk88.furyCutterCount = 0;
}

int GetBattlerStatusCondition(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
        return CONDITION_SLEEP;
    } else if (ctx->battleMons[battlerId].status & STATUS_POISON) {
        return CONDITION_POISON;
    } else if (ctx->battleMons[battlerId].status & STATUS_BURN) {
        return CONDITION_BURN;
    } else if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
        return CONDITION_FREEZE;
    } else if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
        return CONDITION_PARALYSIS;
    } else if (ctx->battleMons[battlerId].status & STATUS_BAD_POISON) {
        return CONDITION_POISON;
    }

    return CONDITION_NONE;
}

BOOL CheckTrainerMessage(BattleSystem *battleSystem, BattleContext *ctx) {
    int state = BattleSystem_GetBattleType(battleSystem); // note: this should be battleType for the following three if statements, but it won't match if an additional variable is used
    int trainerIndex;

    if (state & (BATTLE_TYPE_FRONTIER | BATTLE_TYPE_LINK)) {
        return FALSE;
    }

    if (!(state & BATTLE_TYPE_TRAINER)) {
        return FALSE;
    }

    if (state & BATTLE_TYPE_DOUBLES) {
        return FALSE;
    }

    trainerIndex = BattleSystem_GetTrainerIndex(battleSystem, 1);
    state = 0;

    do {
        switch (state) {
        case 0:
            if (ctx->battleMons[1].hitCount == 1 && !(ctx->battleStatus2 & BATTLE_STATUS2_FIRST_DAMAGE_MESSAGE) && TrainerMessageWithIdPairExists(trainerIndex, TRMSG_HIT_POKE_FIRST_TIME, HEAP_ID_BATTLE)) {
                ctx->battleStatus2 |= BATTLE_STATUS2_FIRST_DAMAGE_MESSAGE;
                ctx->msgTemp = TRMSG_HIT_POKE_FIRST_TIME;
                return TRUE;
            }
            state++;
            break;
        case 1:
            if (!(ctx->battleMons[1].msgFlag & 2) && ctx->battleMons[1].hp <= ctx->battleMons[1].maxHp / 2 && TrainerMessageWithIdPairExists(trainerIndex, TRMSG_CURRENT_POKE_HALF, HEAP_ID_BATTLE)) {
                ctx->battleMons[1].msgFlag |= 2;
                ctx->msgTemp = TRMSG_CURRENT_POKE_HALF;
                return TRUE;
            }
            state++;
            break;
        case 2:
            if (!(ctx->battleMons[1].msgFlag & 3)) {
                int i;
                int aliveMons;
                Party *party;
                Pokemon *mon;

                party = BattleSystem_GetParty(battleSystem, 1);
                aliveMons = 0;

                for (i = 0; i < Party_GetCount(party); i++) {
                    mon = Party_GetMonByIndex(party, i);
                    if (GetMonData(mon, MON_DATA_HP, NULL)) {
                        aliveMons++;
                    }
                }
                if (aliveMons == 1 && TrainerMessageWithIdPairExists(trainerIndex, 15, HEAP_ID_BATTLE)) {
                    ctx->battleMons[1].msgFlag |= 3;
                    ctx->msgTemp = TRMSG_LAST_POKE;
                    return TRUE;
                }
            }
            state++;
            break;
        case 3:
            if (!(ctx->battleMons[1].msgFlag & 4)) {
                int i;
                int aliveMons;
                Party *party;
                Pokemon *mon;

                party = BattleSystem_GetParty(battleSystem, 1);
                aliveMons = 0;

                for (i = 0; i < Party_GetCount(party); i++) {
                    mon = Party_GetMonByIndex(party, i);
                    if (GetMonData(mon, MON_DATA_HP, NULL)) {
                        aliveMons++;
                    }
                }
                if (aliveMons == 1 && (ctx->battleMons[1].hp <= ctx->battleMons[1].maxHp / 2) && TrainerMessageWithIdPairExists(trainerIndex, 16, HEAP_ID_BATTLE)) {
                    ctx->battleMons[1].msgFlag |= 4;
                    ctx->msgTemp = TRMSG_LAST_POKE_HALF;
                    return TRUE;
                }
            }
            state++;
            break;
        case 4:
            break;
        }
    } while (state != 4);

    return FALSE;
}

// This is technically a correct function name but it doesn't account for the other battle context initilzation functions
// which init different parts of the struct, so this can be more descriptive once the variables are ID'd
void BattleContext_Init(BattleContext *ctx) {
    int battlerId;

    // related to damage calculation
    ctx->damage = 0;
    ctx->criticalMultiplier = 1;
    ctx->criticalCnt = 0;
    ctx->movePower = 0;
    ctx->unk_2158 = 10;
    ctx->moveType = 0;
    ctx->unk_2164 = 0;
    ctx->moveStatusFlag = 0;

    ctx->battlerIdFainted = 0xFF;

    // related to statusing a mon..?
    ctx->unk_2170 = 0;
    ctx->unk_2174 = 0;
    ctx->unk_2178 = 0;

    // related to stat changes
    ctx->statChangeType = 0;
    ctx->statChangeParam = 0;
    ctx->battlerIdStatChange = 0xFF;

    // related to multi hit moves
    ctx->multiHitCount = 0;
    ctx->multiHitCountTemp = 0;
    ctx->unk_217E = 0;
    ctx->unk_2180 = 0;
    ctx->unk_38 = 0;
    ctx->unk_2184 = 0;
    ctx->checkMultiHit = 0;

    // unidentified states for different state machines
    ctx->stateFieldConditionUpdate = 0;
    ctx->stateUpdateMonCondition = 0;
    ctx->stateUpdateFieldConditionExtra = 0;
    ctx->stateBeforeTurn = 0;
    ctx->unk_30 = 0;
    ctx->unk_3C = 0;
    ctx->unk_40 = 0;
    ctx->unk_48 = 0;
    ctx->unk_4C = 0;
    ctx->unk_50 = 0;
    ctx->unk_54 = 0;

    ctx->battleStatus &= 0xFF800000;
    ctx->battleStatus2 &= 0xFFFFFEA1;

    ctx->magnitude = 0;
    ctx->teraShellResisting = 0;
    ctx->strongWindsWeakened = 0;
    ctx->gemBoostingMove = FALSE;

    for (battlerId = 0; battlerId < 4; battlerId++) {
        MI_CpuClearFast((u32 *)&ctx->selfTurnData[battlerId], sizeof(SelfTurnData));
        ctx->unk_21A4[battlerId] = 6;
    }
}

void ov12_02251038(BattleSystem *battleSystem, BattleContext *ctx) {
    int battleType;

    for (int battlerId = 0; battlerId < 4; battlerId++) {
        ctx->moveNoHitBattler[battlerId] = 0xFF;
        ctx->unk_21A0[battlerId] = 6;
        ctx->unk_310C[battlerId] = BattleSystem_Random(battleSystem);
    }

    ctx->prizeMoneyValue = 1;

    ctx->meFirstTotal = 1;

    battleType = BattleSystem_GetBattleType(battleSystem);

    if (!(battleType & BATTLE_TYPE_DOUBLES)) {
        ctx->switchInFlag |= MaskOfFlagNo(2);
        ctx->switchInFlag |= MaskOfFlagNo(3);
    }

    ctx->safariCatchRateStage = 6;
    ctx->safariRunAttempts = 6;
}

void InitSwitchWork(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i;
    int maxBattlers;
    u8 *data;
    UnkBattlemonSub unkStruct = ctx->battleMons[battlerId].unk88;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    BattleSystem_GetBattleType(battleSystem);
    ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_40;
    // What comes in during a turn has no action left in it, and has not
    // acted either. The mark goes with the rest of the turn's data as the
    // next turn begins, so a Pokemon sent out between turns does not keep it.
    ctx->turnData[battlerId].switchedIn = TRUE;

    // An Octolock ends when its user leaves, Baton Pass or not: the hold
    // may pass, the wearing down does not (Pokemon Central, Tentacolock).
    for (i = 0; i < maxBattlers; i++) {
        if (ctx->moveConditions[i].octolocked && ctx->battleMons[i].unk88.battlerIdMeanLook == battlerId) {
            ctx->moveConditions[i].octolocked = FALSE;
        }
        // Syrup Bomb's syrup goes with the Pokemon that threw it (Pokemon
        // Central, Bomba Sciroppata).
        if (ctx->moveConditions[i].syrupBombTurns && ctx->moveConditions[i].syrupBombUser == battlerId) {
            ctx->moveConditions[i].syrupBombTurns = 0;
        }
    }

    if (!(ctx->battleStatus & BATTLE_STATUS_BATON_PASS)) {
        for (i = 0; i < maxBattlers; i++) {
            if ((ctx->battleMons[i].status2 & STATUS2_MEAN_LOOK) && (ctx->battleMons[i].unk88.battlerIdMeanLook == battlerId)) {
                ctx->battleMons[i].status2 &= ~STATUS2_MEAN_LOOK;
            }
            if ((ctx->battleMons[i].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON) && ctx->battleMons[i].unk88.battlerIdLockOn == battlerId) {
                ctx->battleMons[i].moveEffectFlags &= ~MOVE_EFFECT_FLAG_LOCK_ON;
                ctx->battleMons[i].unk88.battlerIdLockOn = 0;
            }
        }
        ctx->battleMons[battlerId].status2 = 0;
        ctx->battleMons[battlerId].moveEffectFlags = 0;
    } else { // baton pass
        ctx->battleMons[battlerId].status2 &= STATUS2_BATON_PASSABLE;
        ctx->battleMons[battlerId].moveEffectFlags &= MOVE_EFFECT_FLAG_BATON_PASSABLE;
        for (i = 0; i < maxBattlers; i++) {
            if ((ctx->battleMons[i].moveEffectFlags & MOVE_EFFECT_FLAG_LOCK_ON) && ctx->battleMons[i].unk88.battlerIdLockOn == battlerId) {
                ctx->battleMons[i].moveEffectFlags &= ~MOVE_EFFECT_FLAG_LOCK_ON;
                ctx->battleMons[i].moveEffectFlags |= MOVE_EFFECT_FLAG_LOCK_ON_SET;
            }
        }
    }

    for (i = 0; i < maxBattlers; i++) {
        if (ctx->battleMons[i].status2 & (MaskOfFlagNo(battlerId) << STATUS2_ATTRACT_SHIFT)) {
            ctx->battleMons[i].status2 &= (MaskOfFlagNo(battlerId) << STATUS2_ATTRACT_SHIFT) ^ 0xFFFFFFFF;
        }
        if ((ctx->battleMons[i].status2 & STATUS2_BIND) && ctx->battleMons[i].unk88.battlerIdBinding == battlerId) {
            ctx->battleMons[i].status2 &= ~STATUS2_BIND;
        }
    }

    data = (u8 *)&ctx->battleMons[battlerId].unk88;
    for (i = 0; i < sizeof(UnkBattlemonSub); i++) {
        data[i] = 0;
    }
    MI_CpuClear8(&ctx->moveConditions[battlerId], sizeof(MoveConditions));
    // A Pokemon forced out by Dragon Tail before the move is over takes its
    // Emergency Exit with it; what comes in was not hit, nor was it above half
    // when the turn's end began. Nor is it striking twice with Parental Bond,
    // whatever went out after its second strike.
    ctx->selfTurnData[battlerId].retreatArmed = FALSE;
    ctx->selfTurnData[battlerId].retreatArmedOutsideMove = FALSE;
    ctx->selfTurnData[battlerId].parentalBond = FALSE;

    if (ctx->battleStatus & BATTLE_STATUS_BATON_PASS) {
        ctx->battleMons[battlerId].unk88.substituteHp = unkStruct.substituteHp;
        ctx->battleMons[battlerId].unk88.battlerIdLockOn = unkStruct.battlerIdLockOn;
        ctx->battleMons[battlerId].unk88.perishSongTurns = unkStruct.perishSongTurns;
        ctx->battleMons[battlerId].unk88.battlerIdMeanLook = unkStruct.battlerIdMeanLook;
        ctx->battleMons[battlerId].unk88.magnetRiseTurns = unkStruct.magnetRiseTurns;
        ctx->battleMons[battlerId].unk88.embargoFlag = unkStruct.embargoFlag;
        ctx->battleMons[battlerId].unk88.healBlockTurns = unkStruct.healBlockTurns;
    }

    ctx->battleMons[battlerId].unk88.fakeOutCount = ctx->totalTurns + 1;
    ctx->battleMons[battlerId].unk88.slowStartTurns = ctx->totalTurns + 1;
    ctx->battleMons[battlerId].unk88.truantFlag = (ctx->totalTurns + 1) & 1;

    ctx->moveNoProtect[battlerId] = 0;
    ctx->moveNoHit[battlerId] = 0;
    ctx->moveNoHitBattler[battlerId] = 0xFF;
    ctx->moveNoHitType[battlerId] = 0;
    ctx->moveNoBattlerPrev[battlerId] = 0;
    ctx->moveNoCopied[battlerId] = 0;
    ctx->moveNoCopiedHit[battlerId][0] = 0;
    ctx->moveNoCopiedHit[battlerId][1] = 0;
    ctx->moveNoCopiedHit[battlerId][2] = 0;
    ctx->moveNoCopiedHit[battlerId][3] = 0;
    ctx->moveNoSketch[battlerId] = 0;
    ctx->conversion2Move[battlerId] = 0;
    ctx->conversion2BattlerId[battlerId] = 0;
    ctx->conversion2Type[battlerId] = 0;
    ctx->moveNoMetronome[battlerId] = 0;

    ctx->fieldCondition &= (MaskOfFlagNo(battlerId) << 8) ^ 0xFFFFFFFF; //??

    if (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_POWER_TRICK) {
        i = ctx->battleMons[battlerId].atk;
        ctx->battleMons[battlerId].atk = ctx->battleMons[battlerId].def;
        ctx->battleMons[battlerId].def = i;
    }

    for (i = 0; i < maxBattlers; i++) {
        if (i != battlerId && BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId)) {
            ctx->moveNoCopied[i] = 0;
        }
        ctx->moveNoCopiedHit[i][battlerId] = 0;
    }

    ov12_02258584(ctx, battlerId);
    ov12_0225859C(ctx, battlerId);
    ov12_022585A8(ctx, battlerId);
}

void InitFaintedWork(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i;
    int maxBattlers;
    u8 *data;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (int stat = 0; stat < 8; stat++) {
        ctx->battleMons[battlerId].statChanges[stat] = 6;
    }

    ctx->battleMons[battlerId].status2 = 0;
    ctx->battleMons[battlerId].moveEffectFlags = 0;

    for (i = 0; i < maxBattlers; i++) {
        if ((ctx->battleMons[i].status2 & STATUS2_MEAN_LOOK) && ctx->battleMons[i].unk88.battlerIdMeanLook == battlerId) {
            ctx->battleMons[i].status2 &= ~STATUS2_MEAN_LOOK;
            ctx->moveConditions[i].octolocked = FALSE;
        }
        if (ctx->moveConditions[i].syrupBombTurns && ctx->moveConditions[i].syrupBombUser == battlerId) {
            ctx->moveConditions[i].syrupBombTurns = 0;
        }
        if (ctx->battleMons[i].status2 & (MaskOfFlagNo(battlerId) << STATUS2_ATTRACT_SHIFT)) {
            ctx->battleMons[i].status2 &= (MaskOfFlagNo(battlerId) << STATUS2_ATTRACT_SHIFT) ^ 0xFFFFFFFF;
        }
        if ((ctx->battleMons[i].status2 & STATUS2_BIND) && ctx->battleMons[i].unk88.battlerIdBinding == battlerId) {
            ctx->battleMons[i].status2 &= STATUS2_BIND ^ 0xFFFFFFFF;
        }
    }

    data = (u8 *)&ctx->battleMons[battlerId].unk88;
    for (i = 0; i < sizeof(UnkBattlemonSub); i++) {
        data[i] = 0;
    }
    // A Dondozo that faints lets the Tatsugiri out of its mouth, back into
    // view and free to act again (Pokemon Central, Torre di Comando).
    if (ctx->moveConditions[battlerId].commanderForm) {
        i = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
        if (ctx->moveConditions[i].commanding) {
            ctx->moveConditions[i].commanding = FALSE;
            BattleController_EmitToggleVanish(battleSystem, i, FALSE);
        }
    }
    MI_CpuClear8(&ctx->moveConditions[battlerId], sizeof(MoveConditions));

    data = (u8 *)&ctx->turnData[battlerId];
    for (i = 0; i < sizeof(TurnData); i++) {
        data[i] = 0;
    }

    ctx->battleMons[battlerId].unk88.fakeOutCount = ctx->totalTurns + 1;
    ctx->battleMons[battlerId].unk88.slowStartTurns = ctx->totalTurns + 1;
    ctx->battleMons[battlerId].unk88.truantFlag = (ctx->totalTurns + 1) & 1;

    ctx->moveNoProtect[battlerId] = 0;
    ctx->moveNoHit[battlerId] = 0;
    ctx->moveNoHitBattler[battlerId] = 0xFF;
    ctx->moveNoHitType[battlerId] = 0;
    ctx->moveNoBattlerPrev[battlerId] = 0;
    ctx->moveNoCopied[battlerId] = 0;
    ctx->moveNoCopiedHit[battlerId][0] = 0;
    ctx->moveNoCopiedHit[battlerId][1] = 0;
    ctx->moveNoCopiedHit[battlerId][2] = 0;
    ctx->moveNoCopiedHit[battlerId][3] = 0;
    ctx->moveNoSketch[battlerId] = 0;
    ctx->conversion2Move[battlerId] = 0;
    ctx->conversion2BattlerId[battlerId] = 0;
    ctx->conversion2Type[battlerId] = 0;
    ctx->moveNoMetronome[battlerId] = 0;

    ctx->fieldCondition &= (MaskOfFlagNo(battlerId) << 8) ^ 0xFFFFFFFF; //??

    for (i = 0; i < maxBattlers; i++) {
        if (i != battlerId && BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId)) {
            ctx->moveNoCopied[i] = 0;
        }
        ctx->moveNoCopiedHit[i][battlerId] = 0;
    }

    ctx->unk_13C[battlerId] &= ~1;

    ov12_02258584(ctx, battlerId);
    ov12_0225859C(ctx, battlerId);
    ov12_022585A8(ctx, battlerId);
}

// BattleContext_InitTurnData..? BattleContext_InitStartTurn..?
void ov12_02251710(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;

    for (battlerId = 0; battlerId < 4; battlerId++) {
        MI_CpuClearFast((u32 *)&ctx->turnData[battlerId], sizeof(TurnData));
        MI_CpuClearFast((u32 *)&ctx->moveFail[battlerId], sizeof(MoveFailFlags));
        // A turn has gone by for what the last one left behind.
        ctx->moveConditions[battlerId].powderBlockingFireMove = FALSE;
        if (ctx->moveConditions[battlerId].laserFocusTimer) {
            ctx->moveConditions[battlerId].laserFocusTimer--;
        }
        if (ctx->moveConditions[battlerId].throatChopTimer) {
            ctx->moveConditions[battlerId].throatChopTimer--;
        }
        ctx->battleMons[battlerId].status2 &= ~STATUS2_FLINCH;
        if (ctx->battleMons[battlerId].unk88.rechargeCount + 1 < ctx->totalTurns) {
            ctx->battleMons[battlerId].status2 &= ~STATUS2_RECHARGE;
        }
        if ((ctx->battleMons[battlerId].status & STATUS_SLEEP) && (ctx->battleMons[battlerId].status2 & STATUS2_LOCKED_INTO_MOVE)) {
            UnlockBattlerOutOfCurrentMove(battleSystem, ctx, battlerId);
        }
        if ((ctx->battleMons[battlerId].status & STATUS_SLEEP) && (ctx->battleMons[battlerId].status2 & STATUS2_RAMPAGE)) {
            ctx->battleMons[battlerId].status2 &= ~STATUS2_RAMPAGE;
        }
    }

    ctx->fieldSideConditionData[0].followMeFlag = 0;
    ctx->fieldSideConditionData[1].followMeFlag = 0;
}

u32 StruggleCheck(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u32 nonSelectableMoves, u32 struggleCheckFlags) {
    int movePos;
    int item = GetBattlerHeldItemEffect(ctx, battlerId);

    for (movePos = 0; movePos < 4; movePos++) {
        if (!(ctx->battleMons[battlerId].moves[movePos]) && (struggleCheckFlags & STRUGGLE_CHECK_NO_MOVES)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (!(ctx->battleMons[battlerId].movePPCur[movePos]) && (struggleCheckFlags & STRUGGLE_CHECK_NO_PP)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if ((ctx->battleMons[battlerId].moves[movePos] == ctx->battleMons[battlerId].unk88.disabledMove) && (struggleCheckFlags & STRUGGLE_CHECK_DISABLED)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if ((ctx->battleMons[battlerId].moves[movePos] == ctx->moveNoBattlerPrev[battlerId]) && (struggleCheckFlags & STRUGGLE_CHECK_TORMENT) && (ctx->battleMons[battlerId].status2 & STATUS2_TORMENT)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (ctx->battleMons[battlerId].unk88.tauntTurns && (struggleCheckFlags & STRUGGLE_CHECK_TAUNT) && !(BattleMoveTbl(ctx, ctx->battleMons[battlerId].moves[movePos])->power)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (ctx->moveConditions[battlerId].throatChopTimer && (struggleCheckFlags & STRUGGLE_CHECK_THROAT_CHOP) && BattleMoveIsSoundBased(ctx->battleMons[battlerId].moves[movePos])) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (BattleContext_CheckMoveImprisoned(battleSystem, ctx, battlerId, ctx->battleMons[battlerId].moves[movePos]) && (struggleCheckFlags & STRUGGLE_CHECK_IMPRISON)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (BattleContext_CheckMoveUnuseableInGravity(battleSystem, ctx, battlerId, ctx->battleMons[battlerId].moves[movePos]) && (struggleCheckFlags & STRUGGLE_CHECK_GRAVITY)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if (BattleContext_CheckMoveHealBlocked(battleSystem, ctx, battlerId, ctx->battleMons[battlerId].moves[movePos]) && (struggleCheckFlags & STRUGGLE_CHECK_HEAL_BLOCK)) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if ((ctx->battleMons[battlerId].unk88.encoredMove) && (ctx->battleMons[battlerId].unk88.encoredMove != ctx->battleMons[battlerId].moves[movePos])) {
            // BUG: The flag check for encore is missing in this if statement, though it's unclear if this effects anything functionally
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        if ((item == HOLD_EFFECT_CHOICE_ATK || item == HOLD_EFFECT_CHOICE_SPEED || item == HOLD_EFFECT_CHOICE_SPATK) && (struggleCheckFlags & STRUGGLE_CHECK_CHOICED)) {
            if (BattleMon_GetMoveIndex(&ctx->battleMons[battlerId], ctx->battleMons[battlerId].unk88.moveNoChoice) == 4) {
                ctx->battleMons[battlerId].unk88.moveNoChoice = 0;
            } else if (ctx->battleMons[battlerId].unk88.moveNoChoice && ctx->battleMons[battlerId].unk88.moveNoChoice != ctx->battleMons[battlerId].moves[movePos]) {
                nonSelectableMoves |= MaskOfFlagNo(movePos);
            }
        }
        // Gorilla Tactics is a Choice Band the Pokemon was born with: it locks
        // the move but neither of the stats a Choice item would, and it reads
        // the lock back off the last move rather than trusting what it stored.
        // Nothing is locked until a move has actually gone out, so a move that
        // failed -- which clears moveNoBattlerPrev -- unlocks it for a turn.
        if ((struggleCheckFlags & STRUGGLE_CHECK_GORILLA_TACTICS) && GetBattlerAbility(ctx, battlerId) == ABILITY_GORILLA_TACTICS && ctx->moveNoBattlerPrev[battlerId]) {
            ctx->battleMons[battlerId].unk88.moveNoChoice = ctx->moveNoBattlerPrev[battlerId];
            if (ctx->moveNoBattlerPrev[battlerId] != ctx->battleMons[battlerId].moves[movePos]) {
                nonSelectableMoves |= MaskOfFlagNo(movePos);
            }
        }
        // Belch is not offered until the Pokemon has eaten a Berry. This is
        // the half of the refusal the reference's own build compiles; the
        // effect script carries the other half, for when the move is reached
        // without going through this menu.
        if ((struggleCheckFlags & STRUGGLE_CHECK_BELCH) && ctx->battleMons[battlerId].moves[movePos] == MOVE_BELCH
            && ctx->berryEaten[battlerId][ctx->selectedMonIndex[battlerId]] == FALSE) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
        // An Assault Vest will not let its wearer pick a status move. Me First
        // is the reference's one exception, and by name rather than by any
        // property of it: it is a status move that only ever goes out as
        // somebody else's attack.
        if ((struggleCheckFlags & STRUGGLE_CHECK_ASSAULT_VEST) && item == HOLD_EFFECT_SPDEF_BOOST_NO_STATUS_MOVES
            && BattleMoveTbl(ctx, ctx->battleMons[battlerId].moves[movePos])->category == CATEGORY_STATUS
            && ctx->battleMons[battlerId].moves[movePos] != MOVE_ME_FIRST) {
            nonSelectableMoves |= MaskOfFlagNo(movePos);
        }
    }
    return nonSelectableMoves;
}

// Buffer messages related to being unable to select moves?
BOOL ov12_02251A28(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int movePos, BattleMessage *msg) {
    BOOL ret = TRUE;

    if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_DISABLED) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME_MOVE;
        msg->id = msg_0197_00609;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = ctx->battleMons[battlerId].moves[movePos];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_TORMENT) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME;
        msg->id = msg_0197_00612;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_TAUNT) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME_MOVE;
        msg->id = msg_0197_00613;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = ctx->battleMons[battlerId].moves[movePos];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_IMPRISON) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME_MOVE;
        msg->id = msg_0197_00616;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = ctx->battleMons[battlerId].moves[movePos];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_GRAVITY) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME_MOVE;
        msg->id = msg_0197_01001;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = ctx->battleMons[battlerId].moves[movePos];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_HEAL_BLOCK) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME_MOVE_MOVE;
        msg->id = msg_0197_01057;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = MOVE_HEAL_BLOCK;
        msg->param[2] = ctx->battleMons[battlerId].moves[movePos];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_CHOICED) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_ITEM_MOVE;
        msg->id = msg_0197_00911;
        msg->param[0] = ctx->battleMons[battlerId].item;
        msg->param[1] = ctx->battleMons[battlerId].unk88.moveNoChoice;
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_GORILLA_TACTICS) & MaskOfFlagNo(movePos)) {
        // The Choice line names the item; Gorilla Tactics has none to name.
        msg->tag = TAG_NICKNAME_MOVE;
        msg->id = msg_0197_01457;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        msg->param[1] = ctx->moveNoBattlerPrev[battlerId];
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_BELCH) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NICKNAME;
        msg->id = msg_0197_01790;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_THROAT_CHOP) & MaskOfFlagNo(movePos)) {
        // The effects of Throat Chop prevent {0} from using certain moves!
        msg->tag = TAG_NICKNAME;
        msg->id = msg_0197_01619;
        msg->param[0] = CreateNicknameTag(ctx, battlerId);
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_ASSAULT_VEST) & MaskOfFlagNo(movePos)) {
        // Ahead of the no-PP line, where the reference has it: a vest refuses
        // the move whether or not there was PP for it.
        msg->tag = TAG_ITEM;
        msg->id = msg_0197_01459;
        msg->param[0] = ctx->battleMons[battlerId].item;
        ret = FALSE;
    } else if (StruggleCheck(battleSystem, ctx, battlerId, 0, STRUGGLE_CHECK_NO_PP) & MaskOfFlagNo(movePos)) {
        msg->tag = TAG_NONE;
        msg->id = msg_0197_00823;
        ret = FALSE;
    } else if (BattleMoveTbl(ctx, ctx->battleMons[battlerId].moves[movePos])->unkB & MOVE_FLAG_UNUSABLE_UNIMPLEMENTED) {
        // A move the engine never implemented, which a Pokemon can still know
        // from before the learnsets left it out. Last, as in the reference.
        // "You can't use this move!"
        msg->tag = TAG_NONE;
        msg->id = msg_0197_00620;
        ret = FALSE;
    }

    return ret;
}

int BattleMon_GetMoveIndex(BattleMon *mon, u16 moveNo) {
    int movePos;

    for (movePos = 0; movePos < 4; movePos++) {
        if (mon->moves[movePos] == moveNo) {
            break;
        }
    }

    return movePos;
}

enum {
    TYPETABLE_ATTACKER,
    TYPETABLE_DEFENDER,
    TYPETABLE_EFFECT,
};

static const u8 sTypeEffectiveness[][3] = {
    { TYPE_NORMAL,    TYPE_ROCK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_NORMAL,    TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIRE,      TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIRE,      TYPE_WATER,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIRE,      TYPE_GRASS,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIRE,      TYPE_ICE,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIRE,      TYPE_BUG,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIRE,      TYPE_ROCK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIRE,      TYPE_DRAGON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIRE,      TYPE_STEEL,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_WATER,     TYPE_FIRE,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_WATER,     TYPE_WATER,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_WATER,     TYPE_GRASS,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_WATER,     TYPE_GROUND,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_WATER,     TYPE_ROCK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_WATER,     TYPE_DRAGON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ELECTRIC,  TYPE_WATER,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ELECTRIC,  TYPE_ELECTRIC,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ELECTRIC,  TYPE_GRASS,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ELECTRIC,  TYPE_GROUND,    TYPE_MUL_NO_EFFECT       },
    { TYPE_ELECTRIC,  TYPE_FLYING,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ELECTRIC,  TYPE_DRAGON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_WATER,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GRASS,     TYPE_GRASS,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_POISON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_GROUND,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GRASS,     TYPE_FLYING,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_BUG,       TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_ROCK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GRASS,     TYPE_DRAGON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GRASS,     TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ICE,       TYPE_WATER,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ICE,       TYPE_GRASS,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ICE,       TYPE_ICE,       TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ICE,       TYPE_GROUND,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ICE,       TYPE_FLYING,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ICE,       TYPE_DRAGON,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ICE,       TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ICE,       TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIGHTING,  TYPE_NORMAL,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIGHTING,  TYPE_ICE,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIGHTING,  TYPE_POISON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIGHTING,  TYPE_FLYING,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIGHTING,  TYPE_PSYCHIC,   TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIGHTING,  TYPE_BUG,       TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FIGHTING,  TYPE_ROCK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIGHTING,  TYPE_DARK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIGHTING,  TYPE_STEEL,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_POISON,    TYPE_GRASS,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_POISON,    TYPE_POISON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_POISON,    TYPE_GROUND,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_POISON,    TYPE_ROCK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_POISON,    TYPE_GHOST,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_POISON,    TYPE_STEEL,     TYPE_MUL_NO_EFFECT       },
    { TYPE_GROUND,    TYPE_FIRE,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GROUND,    TYPE_ELECTRIC,  TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GROUND,    TYPE_GRASS,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GROUND,    TYPE_POISON,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GROUND,    TYPE_FLYING,    TYPE_MUL_NO_EFFECT       },
    { TYPE_GROUND,    TYPE_BUG,       TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GROUND,    TYPE_ROCK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GROUND,    TYPE_STEEL,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FLYING,    TYPE_ELECTRIC,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FLYING,    TYPE_GRASS,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FLYING,    TYPE_FIGHTING,  TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FLYING,    TYPE_BUG,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FLYING,    TYPE_ROCK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FLYING,    TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_PSYCHIC,   TYPE_FIGHTING,  TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_PSYCHIC,   TYPE_POISON,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_PSYCHIC,   TYPE_PSYCHIC,   TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_PSYCHIC,   TYPE_DARK,      TYPE_MUL_NO_EFFECT       },
    { TYPE_PSYCHIC,   TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_GRASS,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_BUG,       TYPE_FIGHTING,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_POISON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_FLYING,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_PSYCHIC,   TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_BUG,       TYPE_GHOST,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_BUG,       TYPE_DARK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_BUG,       TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ROCK,      TYPE_FIRE,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ROCK,      TYPE_ICE,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ROCK,      TYPE_FIGHTING,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ROCK,      TYPE_GROUND,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_ROCK,      TYPE_FLYING,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ROCK,      TYPE_BUG,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_ROCK,      TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GHOST,     TYPE_NORMAL,    TYPE_MUL_NO_EFFECT       },
    { TYPE_GHOST,     TYPE_PSYCHIC,   TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_GHOST,     TYPE_DARK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_GHOST,     TYPE_GHOST,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_DRAGON,    TYPE_DRAGON,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_DRAGON,    TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_DARK,      TYPE_FIGHTING,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_DARK,      TYPE_PSYCHIC,   TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_DARK,      TYPE_GHOST,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_DARK,      TYPE_DARK,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_STEEL,     TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_STEEL,     TYPE_WATER,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_STEEL,     TYPE_ELECTRIC,  TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_STEEL,     TYPE_ICE,       TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_STEEL,     TYPE_ROCK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_STEEL,     TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FAIRY,     TYPE_FIGHTING,  TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FAIRY,     TYPE_POISON,    TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FAIRY,     TYPE_STEEL,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FAIRY,     TYPE_FIRE,      TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FAIRY,     TYPE_DRAGON,    TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FAIRY,     TYPE_DARK,      TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_FIGHTING,  TYPE_FAIRY,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_POISON,    TYPE_FAIRY,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_BUG,       TYPE_FAIRY,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_STEEL,     TYPE_FAIRY,     TYPE_MUL_SUPER_EFFECTIVE },
    { TYPE_DRAGON,    TYPE_FAIRY,     TYPE_MUL_NO_EFFECT       },
    { TYPE_DARK,      TYPE_FAIRY,     TYPE_MUL_NOT_EFFECTIVE   },
    { TYPE_FORESIGHT, TYPE_FORESIGHT, TYPE_MUL_NO_EFFECT       },
    { TYPE_NORMAL,    TYPE_GHOST,     TYPE_MUL_NO_EFFECT       },
    { TYPE_FIGHTING,  TYPE_GHOST,     TYPE_MUL_NO_EFFECT       },
    { TYPE_ENDTABLE,  TYPE_ENDTABLE,  TYPE_MUL_NO_EFFECT       }
};

// static
BOOL ov12_02251C74(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int index) {
    int item = GetBattlerHeldItemEffect(ctx, battlerIdTarget);
    BOOL ret = TRUE;

    if (item == HOLD_EFFECT_SPEED_DOWN_GROUNDED || (ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)) {
        if (sTypeEffectiveness[index][1] == TYPE_FLYING && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
            ret = FALSE;
        }
    }

    if (ctx->turnData[battlerIdTarget].roostFlag && sTypeEffectiveness[index][1] == TYPE_FLYING) {
        ret = FALSE;
    }

    if (ctx->fieldCondition & FIELD_CONDITION_GRAVITY) {
        if (sTypeEffectiveness[index][1] == TYPE_FLYING && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
            ret = FALSE;
        }
    }

    if (ctx->battleMons[battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_MIRACLE_EYE) {
        if (sTypeEffectiveness[index][1] == TYPE_DARK && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
            ret = FALSE;
        }
    }

    // A Ring Target takes away every type immunity the holder has, which is
    // every row of this table that says "no effect" against it. The reference
    // does the same thing by moving all of those rows to the bottom of its own
    // table and stopping the walk at a marker row above them; the table here
    // is still retail's, with each immunity where it always sat, so the
    // question is asked of the row instead of once of the table. Same rows,
    // same answer. An Iron Ball and Gravity above are the same idea already,
    // narrowed to Flying.
    if (item == HOLD_EFFECT_LOSE_TYPE_IMMUNITIES && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
        ret = FALSE;
    }

    return ret;
}

// The weather a battler's move sees, hg-engine's GetWeather
// (other_battle_calculators.c:792). Mega Sol (Pokemon Central, Megasolar)
// makes its holder's moves behave as in harsh sunlight, whatever the field has
// and Cloud Nine or Air Lock on it too; otherwise those two leave no weather,
// and the field's is the rest. BATTLER_NONE asks for the field's alone, which
// is what everything that is not a move of one battler's reads.
u32 BattlerMoveWeather(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    if (battlerId != BATTLER_NONE && GetBattlerAbility(ctx, battlerId) == ABILITY_MEGA_SOL) {
        return FIELD_CONDITION_SUN;
    }
    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) || CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
        return 0;
    }
    return ctx->fieldCondition & FIELD_CONDITION_WEATHER;
}

// A Utility Umbrella keeps the rain and the sun off its holder (Pokemon
// Central, Superombrello): the holder's own moves and abilities act as if
// neither were up, and so does a Fire or Water move, or Thunder's accuracy,
// against it. The weather as it reaches the battler: the one given, less the
// rain and the sun for a holder. Protosynthesis is not held off
// (Paleoattivazione); Mega Sol's own sunlight, which no Pokemon in New Gold
// has, is not told apart.
u32 WeatherUnderUmbrella(BattleContext *ctx, u32 weather, int battlerId) {
    if (GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN) {
        weather &= ~(FIELD_CONDITION_RAIN_ALL | FIELD_CONDITION_SUN_ALL);
    }
    return weather;
}

// Weather Ball (Pokemon Central, Palla Clima): the weather that counts for it,
// from the one its user's moves see. None in the strong winds, which leave it
// Normal and undoubled (hg-engine's); no rain and no sun for a user holding a
// Utility Umbrella, which keeps the move's own type and power there -- the
// reference does not ask the umbrella. Whatever is left doubles its power.
u32 WeatherBallWeather(u32 weather, int holdEffect) {
    if (weather & FIELD_CONDITION_STRONG_WINDS) {
        return 0;
    }
    if (holdEffect == HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN) {
        weather &= ~(FIELD_CONDITION_RAIN_ALL | FIELD_CONDITION_SUN_ALL);
    }
    return weather;
}

// Its type in that weather: Normal in none, and in the fog; Ice in the snow as
// in the hail.
u8 WeatherBallType(u32 weather) {
    if (weather & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL)) {
        return TYPE_ICE;
    }
    if (weather & FIELD_CONDITION_SUN_ALL) {
        return TYPE_FIRE;
    }
    if (weather & FIELD_CONDITION_SANDSTORM_ALL) {
        return TYPE_ROCK;
    }
    if (weather & FIELD_CONDITION_RAIN_ALL) {
        return TYPE_WATER;
    }
    return TYPE_NORMAL;
}

// Tera Shell (Pokemon Central, Teraguscio): while the Pokemon has all its HP,
// a move that damages it is not very effective, whatever its type, unless the
// chart makes it no effect at all; a multi-hit move keeps what its first hit
// found, which is what teraShellResisting remembers. Moves that ignore the
// ability get past it. Struggle and the fixed-damage and one-hit KO moves are
// not reduced -- they do not read the chart -- though the shell still gleams.
// hg-engine (d0380a487) has a before-move step for it that is a TODO.
BOOL TeraShellResists(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, u32 moveNo) {
    if (BattleMoveTbl(ctx, moveNo)->category == CATEGORY_STATUS
        || CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_TERA_SHELL) != TRUE) {
        return FALSE;
    }
    return ctx->battleMons[battlerIdTarget].hp == (s32)ctx->battleMons[battlerIdTarget].maxHp
        || (ctx->teraShellResisting & MaskOfFlagNo(battlerIdTarget));
}

// Delta Stream's winds (Pokemon Central, Flusso Delta) take the Flying type's
// weaknesses out of a damaging move: the rows of the chart that make a move
// super effective on Flying are passed over for a Flying-type target, and the
// move's other matchups with it stand. Cloud Nine and Air Lock leave the chart
// alone (BattlerMoveWeather). hg-engine's StrongWindsShouldWeaken.
static BOOL StrongWindsShelterRow(u32 winds, int index) {
    return winds && sTypeEffectiveness[index][TYPETABLE_DEFENDER] == TYPE_FLYING
        && sTypeEffectiveness[index][TYPETABLE_EFFECT] == TYPE_MUL_SUPER_EFFECTIVE;
}

static u32 StrongWindsFor(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, u32 moveNo) {
    if (BattleMoveTbl(ctx, moveNo)->power == 0) {
        return 0;
    }
    return BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker) & FIELD_CONDITION_STRONG_WINDS;
}

// Whether the winds take something off this move against this target, which
// is when the later games say so: a Flying-type target, Roost not in the way,
// and a move whose type is super effective on Flying.
BOOL StrongWindsWeakenMove(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, u32 moveNo, int moveTypeDefault) {
    u32 winds = StrongWindsFor(battleSystem, ctx, battlerIdAttacker, moveNo);
    u8 moveType;
    int i;

    if (!winds || ctx->turnData[battlerIdTarget].roostFlag
        || (GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL) != TYPE_FLYING && GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL) != TYPE_FLYING
            && ctx->battleMons[battlerIdTarget].type3 != TYPE_FLYING)) {
        return FALSE;
    }
    moveType = BattleMoveTypeForAbility(ctx, battlerIdAttacker, GetBattlerAbility(ctx, battlerIdAttacker), moveNo, moveTypeDefault);
    for (i = 0; sTypeEffectiveness[i][TYPETABLE_ATTACKER] != TYPE_ENDTABLE; i++) {
        if (sTypeEffectiveness[i][TYPETABLE_ATTACKER] == moveType && StrongWindsShelterRow(winds, i) == TRUE) {
            return TRUE;
        }
    }
    return FALSE;
}

// The one walk over the type chart. It sets the flags the scripts and the AI
// read, as HeartGold's did, and scales the damage by STAB and then by the
// chart -- the chart once, by what its rows multiply to, the way the
// reference's GetTypeEffectiveness gives one verdict that CalcDamageOverall
// applies as a shift (battle_calc_damage.c, 6.6 and 6.7). HeartGold scaled and
// truncated row by row, so a Fire move into Water/Grass came out 44 from 45.
//
// *effectiveness is that verdict in eighths: 8 neutral, 16 super effective, 4
// not very effective, 0 no effect. It stays 8 while the chart is not being
// asked, which keeps the final modifier's Filter and Tinted Lens quiet then.
int CalcTypeEffectiveness(BattleSystem *battleSystem, BattleContext *ctx, int moveNo, int moveTypeDefault, int battlerIdAttacker, int battlerIdTarget, int damage, u32 *moveStatusFlag, int *effectiveness) {
    int i;
    int typeMul;
    u8 moveType;
    u32 movePower;
    u8 itemTarget;
    u32 winds;

    *effectiveness = 8;

    if (moveNo == MOVE_STRUGGLE) {
        return damage;
    }

    itemTarget = GetBattlerHeldItemEffect(ctx, battlerIdTarget);

    moveType = BattleMoveTypeForAbility(ctx, battlerIdAttacker, GetBattlerAbility(ctx, battlerIdAttacker), moveNo, moveTypeDefault);

    movePower = BattleMoveTbl(ctx, moveNo)->power;
    // Anticipation asks this chart too, with the winds taken off the field
    // for the question: they weaken the hit, not the danger it shudders at.
    winds = StrongWindsFor(battleSystem, ctx, battlerIdAttacker, moveNo);

    // STAB, which a combined Pledge always has (Pokemon Central, Acquapatto).
    if (!(ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS)
        && (GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_TYPE_1, NULL) == moveType || GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_TYPE_2, NULL) == moveType
            || (ctx->selfTurnData[battlerIdAttacker].combinedPledge && BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_PLEDGE))) {
        if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_ADAPTABILITY) {
            damage = QMul_RoundDown(damage, UQ412__2_0);
        } else {
            damage = QMul_RoundDown(damage, UQ412__1_5);
        }
    }

    typeMul = 8;

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_LEVITATE) == TRUE && moveType == TYPE_GROUND && itemTarget != HOLD_EFFECT_SPEED_DOWN_GROUNDED) {
        *moveStatusFlag |= MOVE_STATUS_LEVITATE_IMMUNE;
    } else if (ctx->moveConditions[battlerIdTarget].telekinesisTurns && moveType == TYPE_GROUND && BattlerIsGrounded(ctx, battlerIdTarget) == FALSE && moveNo != MOVE_THOUSAND_ARROWS) {
        // A Pokemon Telekinesis has lifted is out of the ground's reach, as
        // long as nothing has brought it down -- Gravity, an Iron Ball --
        // and Thousand Arrows aside (Pokemon Central, Telecinesi).
        *moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
    } else if ((ctx->battleMons[battlerIdTarget].unk88.magnetRiseTurns || itemTarget == HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT) && moveType == TYPE_GROUND && BattlerIsGrounded(ctx, battlerIdTarget) == FALSE) {
        // An Air Balloon rides out a Ground move the same way Magnet Rise
        // does, and the reference answers both from one place too -- unless
        // something has brought the Pokemon down: Gravity, Ingrain, an Iron
        // Ball, a Smack Down (BattlerIsGrounded; Pokemon Central,
        // Magnetascesa, Gravita). It leaves the same flag behind, so what
        // gets printed is the Magnet Rise line rather than one naming the
        // balloon -- which is the reference's own behaviour, with the
        // reference's own note saying the AI would need a second flag before
        // it could tell them apart.
        *moveStatusFlag |= MOVE_STATUS_MAGNET_RISE_IMMUNE;
    } else {
        i = 0;
        do {
            // &sTypeEffectiveness[i] -> spC
            if (sTypeEffectiveness[i][TYPETABLE_ATTACKER] == TYPE_FORESIGHT) {
                // Mind's Eye is a second Scrappy: Normal and Fighting reach a
                // Ghost, here and in the AI's copy of this loop below.
                if ((ctx->battleMons[battlerIdTarget].status2 & STATUS2_FORESIGHT) || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_SCRAPPY || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_MINDS_EYE) {
                    break;
                } else {
                    i++;
                    continue;
                }
            }
            if (sTypeEffectiveness[i][TYPETABLE_ATTACKER] == moveType) {
                // sTypeEffectiveness[i][TYPETABLE_DEFENDER] -> sp10
                if (sTypeEffectiveness[i][TYPETABLE_DEFENDER] == GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL)) {
                    if (ov12_02251C74(ctx, battlerIdAttacker, battlerIdTarget, i) == TRUE && StrongWindsShelterRow(winds, i) == FALSE) {
                        ov12_022583B4(sTypeEffectiveness[i][TYPETABLE_EFFECT], movePower, moveStatusFlag);
                        typeMul = typeMul * sTypeEffectiveness[i][TYPETABLE_EFFECT] / TYPE_MUL_NORMAL;
                    }
                }
                if (sTypeEffectiveness[i][TYPETABLE_DEFENDER] == GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL) && GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL) != GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL)) {
                    if (ov12_02251C74(ctx, battlerIdAttacker, battlerIdTarget, i) == TRUE && StrongWindsShelterRow(winds, i) == FALSE) {
                        ov12_022583B4(sTypeEffectiveness[i][TYPETABLE_EFFECT], movePower, moveStatusFlag);
                        typeMul = typeMul * sTypeEffectiveness[i][TYPETABLE_EFFECT] / TYPE_MUL_NORMAL;
                    }
                }
                // A third type, which only a battle script can have given.
                if (sTypeEffectiveness[i][TYPETABLE_DEFENDER] == ctx->battleMons[battlerIdTarget].type3 && ctx->battleMons[battlerIdTarget].type3 != GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL) && ctx->battleMons[battlerIdTarget].type3 != GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL)) {
                    if (ov12_02251C74(ctx, battlerIdAttacker, battlerIdTarget, i) == TRUE && StrongWindsShelterRow(winds, i) == FALSE) {
                        ov12_022583B4(sTypeEffectiveness[i][TYPETABLE_EFFECT], movePower, moveStatusFlag);
                        typeMul = typeMul * sTypeEffectiveness[i][TYPETABLE_EFFECT] / TYPE_MUL_NORMAL;
                    }
                }
            }
            i++;
        } while (sTypeEffectiveness[i][TYPETABLE_ATTACKER] != TYPE_ENDTABLE);
        // Whatever the chart said, short of no effect.
        if (typeMul != 0 && TeraShellResists(ctx, battlerIdAttacker, battlerIdTarget, moveNo) == TRUE) {
            typeMul = 4;
            *moveStatusFlag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
            *moveStatusFlag |= MOVE_STATUS_NOT_VERY_EFFECTIVE;
        }
        // Tar Shot doubles what a Fire move does to its target, short of no
        // effect; a resisted one hits normally, a Wonder Guard lets it through
        // (Pokemon Central, Colpocatrame). A super effective row more is what
        // the chart would say.
        if (typeMul != 0 && moveType == TYPE_FIRE && ctx->moveConditions[battlerIdTarget].tarShot) {
            ov12_022583B4(TYPE_MUL_SUPER_EFFECTIVE, movePower, moveStatusFlag);
            typeMul *= 2;
        }
    }

    if (!(ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS) && !(ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_IMMUNITY)) {
        *effectiveness = typeMul;
        damage = damage * typeMul / 8;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WONDER_GUARD) == TRUE && ov12_02258440(ctx, moveNo) && (!(*moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE) || ((*moveStatusFlag & MOVE_STATUS_ANY_EFFECTIVE) == MOVE_STATUS_ANY_EFFECTIVE)) && movePower) {
        *moveStatusFlag |= MOVE_STATUS_WONDER_GUARD_IMMUNE;
    } else if ((ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_EFFECTIVENESS) || (ctx->battleStatus & BATTLE_STATUS_IGNORE_TYPE_IMMUNITY)) {
        *moveStatusFlag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
        *moveStatusFlag &= ~MOVE_STATUS_NOT_VERY_EFFECTIVE;
    }

    return damage;
}

// What the AI and Anticipation ask, and what the controller asks for the
// flags alone: the damage of a hit is final by the time the controller gets
// here, CalcDamage having taken the chart into it already.
int ov12_02251D28(BattleSystem *battleSystem, BattleContext *ctx, int moveNo, int moveTypeDefault, int battlerIdAttacker, int battlerIdTarget, int damage, u32 *moveStatusFlag) {
    int effectiveness;

    return CalcTypeEffectiveness(battleSystem, ctx, moveNo, moveTypeDefault, battlerIdAttacker, battlerIdTarget, damage, moveStatusFlag, &effectiveness);
}

// The abilities that pass a target's ability by whatever the move: Teravolt
// and Turboblaze as Mold Breaker (the reference's
// CLIENT_HAS_MOLD_BREAKER_VARIATION), for the AI's question below, which has
// the abilities and not the battlers; there the target's Ability Shield, its
// held item, keeps its ability heard (Pokemon Central, Scudo abilita).
static BOOL AbilityBreaksMolds(int ability) {
    return ability == ABILITY_MOLD_BREAKER || ability == ABILITY_TERAVOLT || ability == ABILITY_TURBOBLAZE;
}

void ov12_02252054(BattleContext *ctx, int moveNo, int moveTypeDefault, int abilityAttacker, int abilityTarget, int item, int type1, int type2, u32 *moveStatusFlag) {
    int i;
    u8 moveType;

    if (moveNo == MOVE_STRUGGLE) {
        return;
    }

    moveType = BattleMoveTypeForAbility(ctx, BATTLER_NONE, abilityAttacker, moveNo, moveTypeDefault);

    if ((!AbilityBreaksMolds(abilityAttacker) || item == HOLD_EFFECT_PREVENT_ABILITY_CHANGES) && abilityTarget == ABILITY_LEVITATE && moveType == TYPE_GROUND && !(ctx->fieldCondition & FIELD_CONDITION_GRAVITY) && item != HOLD_EFFECT_SPEED_DOWN_GROUNDED) {
        *moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
    } else if (item == HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT && moveType == TYPE_GROUND && !(ctx->fieldCondition & FIELD_CONDITION_GRAVITY)) {
        // What the AI is told about an Air Balloon: a Ground move does
        // nothing. Its own clause rather than a term on the Levitate one,
        // because a balloon does not care about Mold Breaker.
        *moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
    } else {
        i = 0;
        do {
            if (sTypeEffectiveness[i][0] == TYPE_FORESIGHT) {
                if (abilityAttacker == ABILITY_SCRAPPY || abilityAttacker == ABILITY_MINDS_EYE) {
                    break;
                } else {
                    i++;
                    continue;
                }
            }
            if (sTypeEffectiveness[i][0] == moveType) {
                u8 monType = sTypeEffectiveness[i][1];
                if (type1 == monType && CheckFlyingImmunity(ctx, item, i) == TRUE) {
                    ApplyEffectivenessFlags(sTypeEffectiveness[i][2], moveStatusFlag);
                }
                if ((type2 == monType) && (type1 != type2) && CheckFlyingImmunity(ctx, item, i) == TRUE) {
                    ApplyEffectivenessFlags(sTypeEffectiveness[i][2], moveStatusFlag);
                }
            }
            i++;
        } while (sTypeEffectiveness[i][0] != TYPE_ENDTABLE);
    }

    if ((!AbilityBreaksMolds(abilityAttacker) || item == HOLD_EFFECT_PREVENT_ABILITY_CHANGES) && abilityTarget == ABILITY_WONDER_GUARD && ov12_02258440(ctx, moveNo) && (!(*moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE) || (*moveStatusFlag & MOVE_STATUS_ANY_EFFECTIVE) == MOVE_STATUS_ANY_EFFECTIVE)) {
        *moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
    }
}

static BOOL CheckFlyingImmunity(BattleContext *ctx, int item, int index) {
    BOOL ret = TRUE;

    if (item == HOLD_EFFECT_SPEED_DOWN_GROUNDED && sTypeEffectiveness[index][1] == TYPE_FLYING && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
        ret = FALSE;
    }

    if (ctx->fieldCondition & FIELD_CONDITION_GRAVITY && sTypeEffectiveness[index][1] == TYPE_FLYING && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
        ret = FALSE;
    }

    // What the AI is told about a Ring Target: the same no-effect rows the
    // damage calculation skips for one, skipped here too. The reference keeps
    // the two copies in step like this as well.
    if (item == HOLD_EFFECT_LOSE_TYPE_IMMUNITIES && sTypeEffectiveness[index][2] == TYPE_MUL_NO_EFFECT) {
        ret = FALSE;
    }

    return ret;
}

static void ApplyEffectivenessFlags(int effectiveness, u32 *moveStatusFlag) {
    switch (effectiveness) {
    case TYPE_MUL_NO_EFFECT:
        *moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
        *moveStatusFlag &= ~MOVE_STATUS_NOT_VERY_EFFECTIVE;
        *moveStatusFlag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
        break;
    case TYPE_MUL_NOT_EFFECTIVE:
        if (*moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE) {
            *moveStatusFlag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
        } else {
            *moveStatusFlag |= MOVE_STATUS_NOT_VERY_EFFECTIVE;
        }
        break;
    case TYPE_MUL_SUPER_EFFECTIVE:
        if (*moveStatusFlag & MOVE_STATUS_NOT_VERY_EFFECTIVE) {
            *moveStatusFlag &= ~MOVE_STATUS_NOT_VERY_EFFECTIVE;
        } else {
            *moveStatusFlag |= MOVE_STATUS_SUPER_EFFECTIVE;
        }
        break;
    }
}

BOOL ov12_02252218(BattleContext *ctx, int battlerId) {
    if (ctx->moveFail[battlerId].paralysis || ctx->moveFail[battlerId].noEffect || ctx->moveFail[battlerId].imprison || ctx->moveFail[battlerId].infatuation || ctx->moveFail[battlerId].disabled || ctx->moveFail[battlerId].unk0_5 || ctx->moveFail[battlerId].flinch || ctx->moveFail[battlerId].gravity || ctx->moveFail[battlerId].confusion) {
        return TRUE;
    }
    return FALSE;
}

u8 GetMonsHitCount(BattleSystem *battleSystem, BattleContext *ctx, u32 flag, int battlerId) {
    int i;
    u8 cnt = 0;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    switch (flag) {
    case 0:
        for (i = 0; i < maxBattlers; i++) {
            if (i != battlerId && ctx->battleMons[i].hp) {
                cnt++;
            }
        }
        break;
    case 1:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) == BattleSystem_GetFieldSide(battleSystem, battlerId) && ctx->battleMons[i].hp) {
                cnt++;
            }
        }
        break;
    }
    return cnt;
}

int CreateNicknameTag(BattleContext *ctx, int battlerId) {
    return battlerId | (ctx->selectedMonIndex[battlerId] << 8);
}

u16 GetBattlerSelectedMove(BattleContext *ctx, int battlerId) {
    u16 moveNo = 0;

    if (ctx->playerActions[battlerId].inputSelection == BATTLE_INPUT_FIGHT && ctx->playerActions[battlerId].unk8) {
        moveNo = ctx->battleMons[battlerId].moves[ctx->playerActions[battlerId].unk8 - 1];
    }

    return moveNo;
}

int CheckAbilityActive(BattleSystem *battleSystem, BattleContext *ctx, int flag, int battlerId, int ability) {
    int cnt = 0;
    int i;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    switch (flag) {
    case CHECK_ABILITY_SAME_SIDE:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) == BattleSystem_GetFieldSide(battleSystem, battlerId) && GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_SAME_SIDE_HP:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) == BattleSystem_GetFieldSide(battleSystem, battlerId) && ctx->battleMons[i].hp && GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_OPPOSING_SIDE:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId) && GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_OPPOSING_SIDE_HP:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId) && ctx->battleMons[i].hp && GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_OPPOSING_SIDE_HP_RET:
        for (i = 0; i < maxBattlers; i++) {
            if (BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId) && ctx->battleMons[i].hp && GetBattlerAbility(ctx, i) == ability) {
                cnt |= MaskOfFlagNo(i);
            }
        }
        break;
    case CHECK_ABILITY_ALL:
        for (i = 0; i < maxBattlers; i++) {
            if (GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_ALL_NOT_USER:
        for (i = 0; i < maxBattlers; i++) {
            if (i != battlerId && GetBattlerAbility(ctx, i) == ability) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_ALL_NOT_USER_RET:
        for (i = 0; i < maxBattlers; i++) {
            if (i != battlerId && GetBattlerAbility(ctx, i) == ability) {
                cnt = i + 1;
                break;
            }
        }
        break;
    case CHECK_ABILITY_ALL_HP:
        for (i = 0; i < maxBattlers; i++) {
            if (GetBattlerAbility(ctx, i) == ability && ctx->battleMons[i].hp) {
                cnt++;
            }
        }
        break;
    case CHECK_ABILITY_ALL_HP_NOT_USER:
        for (i = 0; i < maxBattlers; i++) {
            if (i != battlerId && GetBattlerAbility(ctx, i) == ability && ctx->battleMons[i].hp) {
                cnt++;
            }
        }
        break;
    }

    return cnt;
}

// FIXME: Function name is wrong
BOOL BattleCtx_IsIdenticalToCurrentMove(BattleContext *ctx, int moveNo) {
    switch (BattleMoveTbl(ctx, moveNo)->effect) {
    case MOVE_EFFECT_BIDE:
    case MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT:
    case MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH:
    case MOVE_EFFECT_CHARGE_TURN_DEF_UP:
    case MOVE_EFFECT_151:
    case MOVE_EFFECT_FLY:
    case MOVE_EFFECT_DIVE:
    case MOVE_EFFECT_DIG:
    case MOVE_EFFECT_BOUNCE:
    case MOVE_EFFECT_SHADOW_FORCE:
        return TRUE;
    }
    return FALSE;
}

BOOL GetTypeEffectivnessData(BattleSystem *battleSystem, int index, u8 *typeMove, u8 *typeMon, u8 *eff) {
    BOOL ret = TRUE;

    if (index >= NELEMS(sTypeEffectiveness)) {
        index = BattleSystem_Random(battleSystem) % NELEMS(sTypeEffectiveness);
        ret = FALSE;
    }

    *typeMove = sTypeEffectiveness[index][0];
    *typeMon = sTypeEffectiveness[index][1];
    *eff = sTypeEffectiveness[index][2];

    return ret;
}

int CalculateTypeEffectiveness(u8 typeMove, u8 typeMon1, u8 typeMon2) {
    int i = 0;
    int damage = 40;

    do {
        if (sTypeEffectiveness[i][0] == typeMove) {
            if (sTypeEffectiveness[i][1] == typeMon1) {
                damage = damage * sTypeEffectiveness[i][2] / 10;
            }
            if (sTypeEffectiveness[i][1] == typeMon2 && typeMon1 != typeMon2) {
                damage = damage * sTypeEffectiveness[i][2] / 10;
            }
        }
        i++;
    } while (sTypeEffectiveness[i][0] != TYPE_ENDTABLE);

    return damage;
}

BOOL CheckMoveCallsOtherMove(u16 moveNo) {
    if (moveNo == MOVE_NONE || moveNo == MOVE_SLEEP_TALK || moveNo == MOVE_COPYCAT || moveNo == MOVE_ASSIST || moveNo == MOVE_ME_FIRST || moveNo == MOVE_MIRROR_MOVE || moveNo == MOVE_METRONOME) {
        return TRUE;
    }
    return FALSE;
}

BOOL CurseUserIsGhost(BattleContext *ctx, u16 moveNo, int battlerId) {
    return moveNo == MOVE_CURSE && (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_GHOST || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_GHOST);
}

// The items a species keeps (the reference's CanItemBeRemovedFromSpecies,
// other_battle_calculators.c:4284 at d0380a487): nothing takes one from that
// species or hands one to it -- Thief, Covet, Trick, Switcheroo, Knock Off,
// Fling, Magician, Pickpocket, Symbiosis. Mail stays with whoever holds it.
// A form is a species of its own here, so it is asked as its base species.
//
// Pokemon Central's list (Furto, Raggiro, Privazione) is the reference's with
// two more: Dialga's Adamant Crystal and Palkia's Lustrous Globe, which the
// reference forgets. The Griseous Orb stays Giratina's, as it did up to the
// eighth generation: here it is still what gives Giratina its Origin Forme,
// the part the ninth generation handed to the Griseous Core before letting
// the Orb go. Mega Stones and Z-Crystals are left out with the mechanics they
// belong to, which this game does not have.
//
// Four Paradox species are deliberately not on the Booster Energy list. The
// reference defines VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR, and that define
// is exactly what takes Gouging Fire, Raging Bolt, Iron Boulder and Iron Crown
// off it -- in New Gold those four can be tricked out of a Booster Energy and
// the sixteen below cannot.
static BOOL SpeciesKeepsItem(u16 species, u16 item) {
    if (ItemIdIsMail(item)) {
        return TRUE;
    }

    switch (SpeciesToDexSpecies(species)) {
    case SPECIES_KYOGRE:
        return item == ITEM_BLUE_ORB;
    case SPECIES_GROUDON:
        return item == ITEM_RED_ORB;
    case SPECIES_DIALGA:
        return item == ITEM_ADAMANT_CRYSTAL;
    case SPECIES_PALKIA:
        return item == ITEM_LUSTROUS_GLOBE;
    case SPECIES_GIRATINA:
        return item == ITEM_GRISEOUS_ORB || item == ITEM_GRISEOUS_CORE;
    case SPECIES_ARCEUS:
        return (item >= ITEM_FLAME_PLATE && item <= ITEM_IRON_PLATE) || item == ITEM_PIXIE_PLATE || item == ITEM_BLANK_PLATE;
    case SPECIES_GENESECT:
        return item >= ITEM_DOUSE_DRIVE && item <= ITEM_CHILL_DRIVE;
    case SPECIES_SILVALLY:
        return item >= ITEM_FIGHTING_MEMORY && item <= ITEM_FAIRY_MEMORY;
    case SPECIES_ZACIAN:
        return item == ITEM_RUSTED_SWORD;
    case SPECIES_ZAMAZENTA:
        return item == ITEM_RUSTED_SHIELD;
    case SPECIES_OGERPON:
        return item >= ITEM_CORNERSTONE_MASK && item <= ITEM_HEARTHFLAME_MASK;
    case SPECIES_GREAT_TUSK:
    case SPECIES_SCREAM_TAIL:
    case SPECIES_BRUTE_BONNET:
    case SPECIES_FLUTTER_MANE:
    case SPECIES_SLITHER_WING:
    case SPECIES_SANDY_SHOCKS:
    case SPECIES_IRON_TREADS:
    case SPECIES_IRON_BUNDLE:
    case SPECIES_IRON_HANDS:
    case SPECIES_IRON_JUGULIS:
    case SPECIES_IRON_MOTH:
    case SPECIES_IRON_THORNS:
    case SPECIES_ROARING_MOON:
    case SPECIES_IRON_VALIANT:
    case SPECIES_WALKING_WAKE:
    case SPECIES_IRON_LEAVES:
        return item == ITEM_BOOSTER_ENERGY;
    }
    return FALSE;
}

// Whether an item can go from one of the two Pokemon to the other: neither
// species keeps it. The games ask it of both, "if the target or the user is
// Giratina", so an Arceus cannot take a plate either.
static BOOL ItemCanChangeHands(BattleContext *ctx, u16 item, int battlerIdA, int battlerIdB) {
    return !SpeciesKeepsItem(ctx->battleMons[battlerIdA].species, item) && !SpeciesKeepsItem(ctx->battleMons[battlerIdB].species, item);
}

// Whether battlerIdTaker can take battlerIdLoser's item: there is one, it was
// not knocked off, and it can change hands between the two.
BOOL CanStealHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdTaker, int battlerIdLoser) {
    BOOL ret = FALSE;
    int side = BattleSystem_GetFieldSide(battleSystem, battlerIdLoser);

    if (ctx->battleMons[battlerIdLoser].item && !(ctx->fieldSideConditionData[side].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[battlerIdLoser])) && ItemCanChangeHands(ctx, ctx->battleMons[battlerIdLoser].item, battlerIdTaker, battlerIdLoser)) {
        ret = TRUE;
    }

    return ret;
}

// Whether Knock Off would take the target's item: it holds one, and neither
// the target's species nor the user's keeps it -- the games' rule, where
// retail's subscript 142 refused any Multitype holder and any Griseous Orb.
// Sticky Hold and a substitute keep the item too, but not the move's power:
// the reference (CanKnockOffApply) leaves both out of this question.
BOOL KnockOffCanRemoveItem(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget) {
    return ctx->battleMons[battlerIdTarget].item != ITEM_NONE
        && ItemCanChangeHands(ctx, ctx->battleMons[battlerIdTarget].item, battlerIdAttacker, battlerIdTarget);
}

// Trick and Switcheroo: each item can change hands between the two (the
// reference's CanTrickHeldItem, which asks the four pairs).
BOOL CanTrickHeldItem(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget) {
    return ItemCanChangeHands(ctx, ctx->battleMons[battlerIdAttacker].item, battlerIdAttacker, battlerIdTarget)
        && ItemCanChangeHands(ctx, ctx->battleMons[battlerIdTarget].item, battlerIdAttacker, battlerIdTarget);
}

// Whirlwind and Roar against a wild Pokemon: they fail whenever the user's
// level is below the target's, from the fifth generation (Pokemon Central,
// Turbine and Ruggito). Retail's fourth generation gave a lower-level user a
// chance by a roll.
BOOL WhirlwindCheck(BattleSystem *battleSystem, BattleContext *ctx) {
#pragma unused(battleSystem)
    return ctx->battleMons[ctx->battlerIdAttacker].level >= ctx->battleMons[ctx->battlerIdTarget].level;
}

// Neutralizing Gas does not act, it stops everything else acting, so the only
// place it can live is where an ability is read. The gas itself is read raw
// rather than through this function, which would ask the question again.
//
// The abilities Neutralizing Gas does not touch: the gas itself, and the ones
// that are a Pokemon's form or its nature -- Stance Change, Schooling,
// Disguise, Ice Face, Gulp Missile, Battle Bond, Multitype, Power Construct,
// Shields Down, As One, RKS System, Comatose, Zen Mode, Zero to Hero and Tera
// Shift, the list the games give (Pokemon Central's Gas Reagente, which Paolo
// named as the spec, 2026-09-23). Commander is not among them.
static BOOL AbilityIsUnsuppressable(u16 ability) {
    switch (ability) {
    case ABILITY_NEUTRALIZING_GAS:
    case ABILITY_STANCE_CHANGE:
    case ABILITY_SCHOOLING:
    case ABILITY_DISGUISE:
    case ABILITY_ICE_FACE:
    case ABILITY_GULP_MISSILE:
    case ABILITY_BATTLE_BOND:
    case ABILITY_MULTITYPE:
    case ABILITY_POWER_CONSTRUCT:
    case ABILITY_SHIELDS_DOWN:
    case ABILITY_AS_ONE_GLASTRIER:
    case ABILITY_AS_ONE_SPECTRIER:
    case ABILITY_RKS_SYSTEM:
    case ABILITY_COMATOSE:
    case ABILITY_ZEN_MODE:
    case ABILITY_ZERO_TO_HERO:
    case ABILITY_TERA_SHIFT:
        return TRUE;
    }
    return FALSE;
}

// The gas acts only from a Pokemon that has it as its own, standing and not
// suppressed itself; gas worn by a Pokemon that only has it by transforming
// does not count.
static BOOL BattlerGivesOffGas(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].ability == ABILITY_NEUTRALIZING_GAS && ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED) && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM);
}

static BOOL AbilitiesAreNeutralized(BattleContext *ctx, int battlerId) {
    int i;

    if (AbilityIsUnsuppressable(ctx->battleMons[battlerId].ability)) {
        return FALSE;
    }
    // An Ability Shield keeps its holder's ability through the gas. Read from
    // the item itself: GetBattlerHeldItem asks for Klutz, which would ask this.
    if (GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT) == HOLD_EFFECT_PREVENT_ABILITY_CHANGES) {
        return FALSE;
    }
    for (i = 0; i < (int)NELEMS(ctx->battleMons); i++) {
        if (BattlerGivesOffGas(ctx, i) == TRUE) {
            return TRUE;
        }
    }
    return FALSE;
}

// An Ability Shield keeps its holder's ability from being changed, removed,
// ignored or made to do nothing by any effect (Pokemon Central, Scudo
// abilita), read from the item itself as the gas above reads it.
static BOOL BattlerHasAbilityShield(BattleContext *ctx, int battlerId) {
    return GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT) == HOLD_EFFECT_PREVENT_ABILITY_CHANGES;
}

u16 GetBattlerAbility(BattleContext *ctx, int battlerId) {
    if (AbilitiesAreNeutralized(ctx, battlerId) == TRUE) {
        return ABILITY_NONE;
    } else if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED) && (ctx->battleMons[battlerId].ability == ABILITY_NEUTRALIZING_GAS || !AbilityIsUnsuppressable(ctx->battleMons[battlerId].ability))) {
        // Gastro Acid's mark, which Baton Pass hands on, spares what the gas
        // spares -- all but the gas itself, which the acid does silence.
        return ABILITY_NONE;
    } else if ((ctx->fieldCondition & FIELD_CONDITION_GRAVITY) && ctx->battleMons[battlerId].ability == ABILITY_LEVITATE) {
        return ABILITY_NONE;
    } else if ((ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN) && ctx->battleMons[battlerId].ability == ABILITY_LEVITATE) {
        return ABILITY_NONE;
    } else {
        return ctx->battleMons[battlerId].ability;
    }
}

// Teravolt and Turboblaze ignore the target's ability exactly as Mold Breaker
// does; Mycelium Might does so only while what it is using is a status move.
// Sunsteel Strike, Moongeist Beam and Photon Geyser ignore it too, whoever
// uses them, but only used directly and not called by another move such as
// Metronome (Pokemon Central, Astrocarica, Raggio d'Ombra, Geyser Fotonico;
// the reference's MoldBreakerAbilityCheckInternal asks the three by number).
static BOOL BattlerIgnoresAbilities(BattleContext *ctx, int battlerId) {
    if (battlerId == ctx->battlerIdAttacker && ctx->moveNoCur == ctx->moveNoTemp
        && (ctx->moveNoCur == MOVE_SUNSTEEL_STRIKE || ctx->moveNoCur == MOVE_MOONGEIST_BEAM || ctx->moveNoCur == MOVE_PHOTON_GEYSER)) {
        return TRUE;
    }
    switch (GetBattlerAbility(ctx, battlerId)) {
    case ABILITY_MOLD_BREAKER:
    case ABILITY_TERAVOLT:
    case ABILITY_TURBOBLAZE:
        return TRUE;
    case ABILITY_MYCELIUM_MIGHT:
        return BattleMoveTbl(ctx, ctx->moveNoCur)->category == CATEGORY_STATUS;
    }

    return FALSE;
}

// An Ability Shield keeps its holder's ability from being ignored too (Pokemon
// Central, Scudo abilita): against it the attacker's Mold Breaker and its kind
// count for nothing. The reference does not ask the shield. Nor is the user's
// own ability ever ignored by its move, the reference's first guard
// (MoldBreakerAbilityCheckInternal, ability.c:518 at d0380a487); its second,
// that only an ability Mold Breaker can pass is passed, is the callers':
// those it cannot -- Comatose, Emergency Exit, Wimp Out, Scrappy -- are read
// with GetBattlerAbility, as test_mold_breaker checks against its table.
BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int ability) {
    BOOL ret = FALSE;

    if (battlerIdAttacker == battlerIdTarget || BattlerIgnoresAbilities(ctx, battlerIdAttacker) == FALSE || BattlerHasAbilityShield(ctx, battlerIdTarget)) {
        if (GetBattlerAbility(ctx, battlerIdTarget) == ability) {
            ret = TRUE;
        }
    } else if (GetBattlerAbility(ctx, battlerIdTarget) == ability && !ctx->selfTurnData[battlerIdAttacker].moldBreakerFlag) {
        ctx->selfTurnData[battlerIdAttacker].moldBreakerFlag = TRUE;
        ctx->battleStatus |= BATTLE_STATUS_MOLD_BREAKER;
    }

    return ret;
}

// Whether a standing Pokemon on the target's side has the ability, where the
// attacker's move does not ignore it (CheckBattlerAbilityIfNotIgnored).
static BOOL SideAbilityNotIgnored(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int ability) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (int i = 0; i < maxBattlers; i++) {
        if (BattleSystem_GetFieldSide(battleSystem, i) == BattleSystem_GetFieldSide(battleSystem, battlerIdTarget) && ctx->battleMons[i].hp && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, i, ability) == TRUE) {
            return TRUE;
        }
    }
    return FALSE;
}

BOOL CanSwitchMon(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret;
    Party *party;
    Pokemon *mon;
    int partySize;
    int cnt;
    int cntMax;
    int i;
    int start;
    int monIndex1;
    int monIndex2;
    u32 battleType;

    cnt = 0;
    ret = FALSE;
    battleType = BattleSystem_GetBattleType(battleSystem);
    party = BattleSystem_GetParty(battleSystem, battlerId);
    partySize = BattleSystem_GetPartySize(battleSystem, battlerId);

    if ((battleType & BATTLE_TYPE_MULTI) || ((battleType & BATTLE_TYPE_TAG) && (ov12_0223AB0C(battleSystem, battlerId) & 1))) {
        start = 0;
        cntMax = 1;
        monIndex1 = ctx->selectedMonIndex[battlerId];
        monIndex2 = ctx->selectedMonIndex[battlerId];
    } else if (battleType & BATTLE_TYPE_DOUBLES) {
        start = 0;
        cntMax = 1;
        monIndex1 = ctx->selectedMonIndex[battlerId];
        monIndex2 = ctx->selectedMonIndex[BattleSystem_GetBattlerIdPartner(battleSystem, battlerId)];
    } else {
        start = 0;
        cntMax = 1;
        monIndex1 = ctx->selectedMonIndex[battlerId];
        monIndex2 = ctx->selectedMonIndex[battlerId];
    }

    for (i = start; i < partySize; i++) {
        mon = Party_GetMonByIndex(party, i);
        if (GetMonData(mon, MON_DATA_SPECIES, NULL) != SPECIES_NONE
            && !GetMonData(mon, MON_DATA_IS_EGG, NULL)
            && GetMonData(mon, MON_DATA_HP, NULL) != 0
            && monIndex1 != i
            && monIndex2 != i) {
            cnt++;
        }
    }
    if (cnt >= cntMax) {
        ret = TRUE;
    }
    return ret;
}

// From the sixth generation nothing holds a Ghost-type on the field: "i
// Pokemon di tipo Spettro sono immuni agli effetti di imprigionamento e
// antifuga dovuto a mosse o abilita" (Pokemon Central, Spettro (tipo)) --
// Mean Look, Block, Spider Web, the binding moves (whose damage still comes),
// Jaw Lock, Anchor Shot, Spirit Shackle, Thousand Waves, Octolock, No
// Retreat, Ingrain, Fairy Lock, Shadow Tag, Arena Trap and Magnet Pull -- and
// it gets away from a wild battle whatever its Speed. HeartGold and the
// reference hold it as any other; the reference spares it Fairy Lock alone.
BOOL Battler_HasGhostType(BattleContext *ctx, int battlerId) {
    return GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_GHOST
        || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_GHOST
        || ctx->battleMons[battlerId].type3 == TYPE_GHOST;
}

BOOL CantEscape(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, BattleMessage *msg) {
    int battlerIdAbility;
    int maxBattlers;
    u8 side;
    int item;
    u32 battleType;

    battleType = BattleSystem_GetBattleType(battleSystem);
    item = GetBattlerHeldItemEffect(ctx, battlerId);

    if (item == HOLD_EFFECT_FLEE || (battleType & BATTLE_TYPE_NO_EXP) || GetBattlerAbility(ctx, battlerId) == ABILITY_RUN_AWAY
        || Battler_HasGhostType(ctx, battlerId)) {
        return FALSE;
    }

    side = BattleSystem_GetFieldSide(battleSystem, battlerId);
    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    battlerIdAbility = CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP_NOT_USER, battlerId, ABILITY_SHADOW_TAG);
    if (battlerIdAbility && GetBattlerAbility(ctx, battlerId) != ABILITY_SHADOW_TAG) {
        if (msg == NULL) {
            return TRUE;
        }
        msg->tag = TAG_NICKNAME_ABILITY;
        msg->id = msg_0197_00039;
        msg->param[0] = CreateNicknameTag(ctx, battlerIdAbility);
        msg->param[1] = ABILITY_SHADOW_TAG;
        return TRUE;
    }

    battlerIdAbility = CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, battlerId, ABILITY_ARENA_TRAP);
    if (battlerIdAbility) {
        if (!(ctx->fieldCondition & FIELD_CONDITION_GRAVITY) && item != HOLD_EFFECT_SPEED_DOWN_GROUNDED) {
            if (GetBattlerAbility(ctx, battlerId) != ABILITY_LEVITATE && !ctx->battleMons[battlerId].unk88.magnetRiseTurns && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) != TYPE_FLYING && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) != TYPE_FLYING) {
                if (msg == NULL) {
                    return TRUE;
                }
                msg->tag = TAG_NICKNAME_ABILITY;
                msg->id = msg_0197_00039;
                msg->param[0] = CreateNicknameTag(ctx, battlerIdAbility);
                msg->param[1] = ABILITY_ARENA_TRAP;
                return TRUE;
            }
        } else {
            if (msg == NULL) {
                return TRUE;
            }
            msg->tag = TAG_NICKNAME_ABILITY;
            msg->id = msg_0197_00039;
            msg->param[0] = CreateNicknameTag(ctx, battlerIdAbility);
            msg->param[1] = ABILITY_ARENA_TRAP;
            return TRUE;
        }
    }

    battlerIdAbility = CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, battlerId, ABILITY_MAGNET_PULL);
    if (battlerIdAbility && (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_STEEL || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_STEEL)) {
        if (msg == NULL) {
            return TRUE;
        }
        msg->tag = TAG_NICKNAME_ABILITY;
        msg->id = msg_0197_00039;
        msg->param[0] = CreateNicknameTag(ctx, battlerIdAbility);
        msg->param[1] = ABILITY_MAGNET_PULL;
        return TRUE;
    }

    // Fairy Lock holds every Pokemon on the field until the end of the turn
    // after the one it was used in (Pokemon Central, Blocco Fatato).
    if ((ctx->battleMons[battlerId].status2 & (STATUS2_BIND | STATUS2_MEAN_LOOK)) || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
        || ctx->fairyLockTurns) {
        if (msg == NULL) {
            return TRUE;
        }
        msg->tag = TAG_NONE;
        msg->id = msg_0197_00794;
        return TRUE;
    }

    return FALSE;
}

BOOL BattleTryRun(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret;
    u8 run;
    int item;
    u32 battleType;

    battleType = BattleSystem_GetBattleType(battleSystem);
    item = GetBattlerHeldItemEffect(ctx, battlerId);
    ret = FALSE;

    if (item == HOLD_EFFECT_FLEE) {
        ctx->turnData[battlerId].runFlag = 1;
        ret = TRUE;
    } else if (battleType & BATTLE_TYPE_NO_EXP) {
        ret = TRUE;
    } else if (GetBattlerAbility(ctx, battlerId) == ABILITY_RUN_AWAY) {
        ctx->turnData[battlerId].runFlag = 2;
        ret = TRUE;
    } else if (Battler_HasGhostType(ctx, battlerId)) {
        ret = TRUE;
    } else {
        if (ctx->battleMons[battlerId].speed < ctx->battleMons[battlerId ^ 1].speed) {
            run = ctx->battleMons[battlerId].speed * 128 / ctx->battleMons[battlerId ^ 1].speed + ctx->runAttempts * 30;
            if (run > (BattleSystem_Random(battleSystem) % 256)) {
                ret = TRUE;
            }
        } else {
            ret = TRUE;
        }
        if (!ret) {
            BattleController_EmitIncrementGameStat(battleSystem, battlerId, 0, GAME_STAT_RUN_FAILURES);
        }
        ctx->runAttempts++;
    }
    return ret;
}

BOOL CheckTruant(BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;

    if (GetBattlerAbility(ctx, battlerId) == ABILITY_TRUANT) {
        if (ctx->battleMons[battlerId].unk88.truantFlag != (ctx->totalTurns & 1)) {
            ret = TRUE;
        }
    }

    return ret;
}

BOOL BattleContext_CheckMoveImprisoned(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    int maxBattlers;
    int side;
    int battlerIdCur;
    BOOL ret;
    int i;

    ret = FALSE;
    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    side = BattleSystem_GetFieldSide(battleSystem, battlerId);

    for (battlerIdCur = 0; battlerIdCur < maxBattlers; battlerIdCur++) {
        if ((side != BattleSystem_GetFieldSide(battleSystem, battlerIdCur)) && (ctx->battleMons[battlerIdCur].moveEffectFlags & MOVE_EFFECT_FLAG_IMPRISON_USER)) {
            for (i = 0; i < MAX_MON_MOVES; i++) {
                if (moveNo == ctx->battleMons[battlerIdCur].moves[i]) {
                    break;
                }
            }
            if (i != MAX_MON_MOVES) {
                ret = TRUE;
            }
        }
    }

    return ret;
}

BOOL CheckMoveEffectOnField(BattleSystem *battleSystem, BattleContext *ctx, int moveEffect) {
    int battlerId;
    int maxBattlers;
    BOOL ret = FALSE;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (ctx->battleMons[battlerId].moveEffectFlags & moveEffect) {
            ret = TRUE;
            break;
        }
    }

    return ret;
}

void ov12_02252D14(BattleSystem *battleSystem, BattleContext *ctx) {
    ctx->moveStatusFlag = 0;
    ctx->criticalMultiplier = 1;
    ctx->battleStatus &= (0x100000 ^ 0xFFFFFFFF);
}

void SortMonsBySpeed(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int maxBattlers;
    int i, j;
    int temp1, temp2;

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        ctx->turnOrder[battlerId] = battlerId;
    }
    for (i = 0; i < maxBattlers - 1; i++) {
        for (j = i + 1; j < maxBattlers; j++) {
            temp1 = ctx->turnOrder[i];
            temp2 = ctx->turnOrder[j];
            if (CheckSortSpeed(battleSystem, ctx, temp1, temp2, 1)) {
                ctx->turnOrder[i] = temp2;
                ctx->turnOrder[j] = temp1;
            }
        }
    }
}

static const u16 sGravityUnusableMoves[] = {
    MOVE_FLY,
    MOVE_BOUNCE,
    MOVE_JUMP_KICK,
    MOVE_HI_JUMP_KICK,
    MOVE_SPLASH,
    MOVE_MAGNET_RISE
};

BOOL BattleContext_CheckMoveUnuseableInGravity(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    int i;
    BOOL ret = FALSE;

    if (ctx->fieldCondition & FIELD_CONDITION_GRAVITY) {
        for (i = 0; i < NELEMS(sGravityUnusableMoves); i++) {
            if (sGravityUnusableMoves[i] == moveNo) {
                ret = TRUE;
                break;
            }
        }
    }

    return ret;
}

// Heal Block goes by effect, as the reference's HealBlockUnusableMoveEffects
// does: every move that heals its user, the draining moves and Dream Eater
// included, and the two that heal another -- Heal Pulse and Life Dew. Floral
// Healing and Lunar Blessing have no effect of their own yet, so the reference
// names them as moves.
static const u16 sHealBlockUnusableMoves[] = {
    MOVE_FLORAL_HEALING,
    MOVE_LUNAR_BLESSING,
};

static const u16 sHealBlockUnusableMoveEffects[] = {
    MOVE_EFFECT_RECOVER_HALF_DAMAGE_DELT,
    MOVE_EFFECT_RECOVER_THREE_QUARTERS_DAMAGE_DEALT,
    MOVE_EFFECT_RECOVER_FULL_DAMAGE_DEALT,
    MOVE_EFFECT_RECOVER_DAMAGE_SLEEP,
    MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT,
    MOVE_EFFECT_RESTORE_HALF_HP,
    MOVE_EFFECT_HEAL_HALF_REMOVE_FLYING_TYPE,
    MOVE_EFFECT_HEAL_HALF_MORE_IN_SUN,
    MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP,
    MOVE_EFFECT_SWALLOW,
    MOVE_EFFECT_FAINT_FULL_RESTORE_NEXT_MON,
    MOVE_EFFECT_FAINT_AND_FULL_HEAL_NEXT_MON,
    MOVE_EFFECT_HEAL_IN_3_TURNS,
    MOVE_EFFECT_HEAL_TARGET,
    MOVE_EFFECT_LIFE_DEW,
};

BOOL BattleContext_CheckMoveHealBlocked(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    int i;
    int effect = BattleMoveTbl(ctx, moveNo)->effect;

    if (ctx->battleMons[battlerId].unk88.healBlockTurns) {
        for (i = 0; i < NELEMS(sHealBlockUnusableMoves); i++) {
            if (sHealBlockUnusableMoves[i] == moveNo) {
                return TRUE;
            }
        }
        for (i = 0; i < NELEMS(sHealBlockUnusableMoveEffects); i++) {
            if (sHealBlockUnusableMoveEffects[i] == effect) {
                return TRUE;
            }
        }
    }

    return FALSE;
}

void ov12_02252E30(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;

    if (ctx->moveNoTemp == MOVE_LAST_RESORT || ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount == MAX_MON_MOVES) {
        return;
    }

    for (i = 0; i < ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount; i++) {
        if (ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortMoves[i] == ctx->moveNoTemp) {
            return;
        }
    }

    ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortMoves[i] = ctx->moveNoTemp;
    ctx->battleMons[ctx->battlerIdAttacker].unk88.lastResortCount++;
}

int GetBattlerLearnedMoveCount(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int cnt;

    for (cnt = 0; cnt < MAX_MON_MOVES; cnt++) {
        if (ctx->battleMons[battlerId].moves[cnt] == MOVE_NONE) {
            break;
        }
    }

    return cnt;
}

// BUG: There isn't a reason why this shouldn't be const, but it's located in .data and not .rodata
static u16 sSoundMoves[] = {
    MOVE_ALLURING_VOICE,
    MOVE_BOOMBURST,
    MOVE_BUG_BUZZ,
    MOVE_CHATTER,
    MOVE_CLANGING_SCALES,
    MOVE_CLANGOROUS_SOUL,
    MOVE_CLANGOROUS_SOULBLAZE,
    MOVE_CONFIDE,
    MOVE_DISARMING_VOICE,
    MOVE_ECHOED_VOICE,
    MOVE_EERIE_SPELL,
    MOVE_GRASS_WHISTLE,
    MOVE_GROWL,
    MOVE_HEAL_BELL,
    MOVE_HOWL,
    MOVE_HYPER_VOICE,
    MOVE_METAL_SOUND,
    MOVE_NOBLE_ROAR,
    MOVE_OVERDRIVE,
    MOVE_PARTING_SHOT,
    MOVE_PERISH_SONG,
    MOVE_PSYCHIC_NOISE,
    MOVE_RELIC_SONG,
    MOVE_ROAR,
    MOVE_ROUND,
    MOVE_SCREECH,
    MOVE_SING,
    MOVE_SNARL,
    MOVE_SNORE,
    MOVE_SPARKLING_ARIA,
    MOVE_SUPERSONIC,
    MOVE_TORCH_SONG,
    MOVE_UPROAR,
};

// Several abilities go by which move it is rather than by its type, and this
// generation has no flag for any of them, so the moves are listed. Each list
// is the reference's own, in full: they were once cut to the moves the game
// reached, and the game reaches all 923 of them now.
static const u16 sSlicingMoves[] = {
    MOVE_AERIAL_ACE,
    MOVE_AIR_CUTTER,
    MOVE_AIR_SLASH,
    MOVE_AQUA_CUTTER,
    MOVE_BEHEMOTH_BLADE,
    MOVE_BITTER_BLADE,
    MOVE_CEASELESS_EDGE,
    MOVE_CROSS_POISON,
    MOVE_CRUSH_CLAW,
    MOVE_CUT,
    MOVE_DIRE_CLAW,
    MOVE_DRAGON_CLAW,
    MOVE_FURY_CUTTER,
    MOVE_KOWTOW_CLEAVE,
    MOVE_LEAF_BLADE,
    MOVE_METAL_CLAW,
    MOVE_MIGHTY_CLEAVE,
    MOVE_NIGHT_SLASH,
    MOVE_POPULATION_BOMB,
    MOVE_PSYBLADE,
    MOVE_PSYCHO_CUT,
    MOVE_RAZOR_LEAF,
    MOVE_RAZOR_SHELL,
    MOVE_SACRED_SWORD,
    MOVE_SECRET_SWORD,
    MOVE_SHADOW_CLAW,
    MOVE_SLASH,
    MOVE_SOLAR_BLADE,
    MOVE_STONE_AXE,
    MOVE_TACHYON_CUTTER,
    MOVE_X_SCISSOR,
};

static const u16 sBallAndBombMoves[] = {
    MOVE_ACID_SPRAY,
    MOVE_AURA_SPHERE,
    MOVE_BARRAGE,
    MOVE_BEAK_BLAST,
    MOVE_BULLET_SEED,
    MOVE_EGG_BOMB,
    MOVE_ELECTRO_BALL,
    MOVE_ENERGY_BALL,
    MOVE_FOCUS_BLAST,
    MOVE_GYRO_BALL,
    MOVE_ICE_BALL,
    MOVE_MAGNET_BOMB,
    MOVE_MIST_BALL,
    MOVE_MUD_BOMB,
    MOVE_OCTAZOOKA,
    MOVE_POLLEN_PUFF,
    MOVE_PYRO_BALL,
    MOVE_ROCK_BLAST,
    MOVE_ROCK_WRECKER,
    MOVE_SEARING_SHOT,
    MOVE_SEED_BOMB,
    MOVE_SHADOW_BALL,
    MOVE_SLUDGE_BOMB,
    MOVE_SYRUP_BOMB,
    MOVE_WEATHER_BALL,
    MOVE_ZAP_CANNON,
};

static const u16 sWindMoves[] = {
    MOVE_AEROBLAST,
    MOVE_AIR_CUTTER,
    MOVE_BLEAKWIND_STORM,
    MOVE_BLIZZARD,
    MOVE_FAIRY_WIND,
    MOVE_GUST,
    MOVE_HEAT_WAVE,
    MOVE_HURRICANE,
    MOVE_ICY_WIND,
    MOVE_PETAL_BLIZZARD,
    MOVE_SANDSEAR_STORM,
    MOVE_SANDSTORM,
    MOVE_SPRINGTIDE_STORM,
    MOVE_TAILWIND,
    MOVE_TWISTER,
    MOVE_WHIRLWIND,
    MOVE_WILDBOLT_STORM,
};

// The moves that stamp: against a Pokemon that has used Minimize they never
// miss and do double (the reference's MinimizeVulnerabilityMovesList).
static const u16 sMinimizeVulnerableMoves[] = {
    MOVE_BODY_SLAM,
    MOVE_STOMP,
    MOVE_DRAGON_RUSH,
    MOVE_STEAMROLLER,
    MOVE_HEAT_CRASH,
    MOVE_HEAVY_SLAM,
    MOVE_FLYING_PRESS,
    MOVE_MALICIOUS_MOONSAULT,
    MOVE_SUPERCELL_SLAM,
};

// What a pair of Safety Goggles keeps out. The reference's list, in its order,
// which is why Powder and Rage Powder are on it beside the four that put a
// status on: a powder is a powder whatever it does when it lands.
static const u16 sPowderMoves[] = {
    MOVE_COTTON_SPORE,
    MOVE_POISON_POWDER,
    MOVE_SLEEP_POWDER,
    MOVE_STUN_SPORE,
    MOVE_SPORE,
    MOVE_POWDER,
    MOVE_RAGE_POWDER,
    MOVE_MAGIC_POWDER,
};

static BOOL MoveIsInList(u32 move, const u16 *list, int count) {
    for (int i = 0; i < count; i++) {
        if (list[i] == move) {
            return TRUE;
        }
    }
    return FALSE;
}

// The dances Dancer copies: the reference's DanceMoveTable
// (other_battle_calculators.c:506 at d0380a487), sorted, which is Pokemon
// Central's list for Sincrodanza.
static const u16 sDanceMoves[] = {
    MOVE_AQUA_STEP,
    MOVE_CLANGOROUS_SOUL,
    MOVE_DRAGON_DANCE,
    MOVE_FEATHER_DANCE,
    MOVE_FIERY_DANCE,
    MOVE_LUNAR_DANCE,
    MOVE_PETAL_DANCE,
    MOVE_QUIVER_DANCE,
    MOVE_REVELATION_DANCE,
    MOVE_SWORDS_DANCE,
    MOVE_TEETER_DANCE,
    MOVE_VICTORY_DANCE,
};

BOOL BattleMoveIsDance(u32 moveNo) {
    return MoveIsInList(moveNo, sDanceMoves, NELEMS(sDanceMoves));
}

// Parental Bond (IsValidParentalBondMove, other_battle_calculators.c:2575 at
// d0380a487; Pokemon Central, Amorefiliale): the holder's damaging moves
// strike twice, the second strike a quarter of the first, and behave in all
// else as a multi-strike move does -- one accuracy check, one PP, "Hit 2
// times!". Not the moves that already strike more than once, nor these: the
// one-hit KO moves, the moves that faint their user or lock it in, Fling,
// Endeavor, Final Gambit, the moves with a charging turn, and the Z and Max
// moves, which this game never lets anyone use. Both lists are the
// reference's, sorted, and Tachyon Cutter, which strikes twice of itself and
// which the reference left off, so that the ability took its second strike's
// power away, and New Gold's Solar Seeds, which strikes two to five times.
// Present is on the second list because its own script strikes twice when it
// wounds and once when it heals. Future Sight and Doom Desire strike turns
// later and Misty Explosion faints its user as Explosion does; the reference
// leaves all three off, and the second pass of the first two failed.
static const u16 sMultiStrikeMoves[] = {
    MOVE_ARM_THRUST,
    MOVE_BARRAGE,
    MOVE_BEAT_UP,
    MOVE_BONEMERANG,
    MOVE_BONE_RUSH,
    MOVE_BULLET_SEED,
    MOVE_COMET_PUNCH,
    MOVE_DOUBLE_HIT,
    MOVE_DOUBLE_IRON_BASH,
    MOVE_DOUBLE_KICK,
    MOVE_DOUBLE_SLAP,
    MOVE_DRAGON_DARTS,
    MOVE_DUAL_CHOP,
    MOVE_DUAL_WINGBEAT,
    MOVE_FURY_ATTACK,
    MOVE_FURY_SWIPES,
    MOVE_GEAR_GRIND,
    MOVE_ICICLE_SPEAR,
    MOVE_PIN_MISSILE,
    MOVE_POPULATION_BOMB,
    MOVE_ROCK_BLAST,
    MOVE_SCALE_SHOT,
    MOVE_SOLAR_SEEDS,
    MOVE_SPIKE_CANNON,
    MOVE_SURGING_STRIKES,
    MOVE_TACHYON_CUTTER,
    MOVE_TAIL_SLAP,
    MOVE_TRIPLE_AXEL,
    MOVE_TRIPLE_DIVE,
    MOVE_TRIPLE_KICK,
    MOVE_TWINEEDLE,
    MOVE_TWIN_BEAM,
    MOVE_WATER_SHURIKEN,
};
static const u16 sParentalBondSingleStrikeMoves[] = {
    MOVE_10_000_000_VOLT_THUNDERBOLT,
    MOVE_ACID_DOWNPOUR_PHYSICAL,
    MOVE_ACID_DOWNPOUR_SPECIAL,
    MOVE_ALL_OUT_PUMMELING_PHYSICAL,
    MOVE_ALL_OUT_PUMMELING_SPECIAL,
    MOVE_BLACK_HOLE_ECLIPSE_PHYSICAL,
    MOVE_BLACK_HOLE_ECLIPSE_SPECIAL,
    MOVE_BLOOM_DOOM_PHYSICAL,
    MOVE_BLOOM_DOOM_SPECIAL,
    MOVE_BOUNCE,
    MOVE_BREAKNECK_BLITZ_PHYSICAL,
    MOVE_BREAKNECK_BLITZ_SPECIAL,
    MOVE_CATASTROPIKA,
    MOVE_CLANGOROUS_SOULBLAZE,
    MOVE_CONTINENTAL_CRUSH_PHYSICAL,
    MOVE_CONTINENTAL_CRUSH_SPECIAL,
    MOVE_CORKSCREW_CRASH_PHYSICAL,
    MOVE_CORKSCREW_CRASH_SPECIAL,
    MOVE_DEVASTATING_DRAKE_PHYSICAL,
    MOVE_DEVASTATING_DRAKE_SPECIAL,
    MOVE_DIG,
    MOVE_DIVE,
    MOVE_DOOM_DESIRE,
    MOVE_DYNAMAX_CANNON,
    MOVE_ELECTRO_SHOT,
    MOVE_ENDEAVOR,
    MOVE_EXPLOSION,
    MOVE_EXTREME_EVOBOOST,
    MOVE_FINAL_GAMBIT,
    MOVE_FISSURE,
    MOVE_FLING,
    MOVE_FLY,
    MOVE_FREEZE_SHOCK,
    MOVE_FUTURE_SIGHT,
    MOVE_GENESIS_SUPERNOVA,
    MOVE_GEOMANCY,
    MOVE_GIGAVOLT_HAVOC_PHYSICAL,
    MOVE_GIGAVOLT_HAVOC_SPECIAL,
    MOVE_GUARDIAN_OF_ALOLA,
    MOVE_GUILLOTINE,
    MOVE_HORN_DRILL,
    MOVE_HYDRO_VORTEX_PHYSICAL,
    MOVE_HYDRO_VORTEX_SPECIAL,
    MOVE_ICE_BALL,
    MOVE_ICE_BURN,
    MOVE_INFERNO_OVERDRIVE_PHYSICAL,
    MOVE_INFERNO_OVERDRIVE_SPECIAL,
    MOVE_LETS_SNUGGLE_FOREVER,
    MOVE_LIGHT_THAT_BURNS_THE_SKY,
    MOVE_MALICIOUS_MOONSAULT,
    MOVE_MAX_AIRSTREAM,
    MOVE_MAX_DARKNESS,
    MOVE_MAX_FLARE,
    MOVE_MAX_FLUTTERBY,
    MOVE_MAX_GEYSER,
    MOVE_MAX_GUARD,
    MOVE_MAX_HAILSTORM,
    MOVE_MAX_KNUCKLE,
    MOVE_MAX_LIGHTNING,
    MOVE_MAX_MINDSTORM,
    MOVE_MAX_OOZE,
    MOVE_MAX_OVERGROWTH,
    MOVE_MAX_PHANTASM,
    MOVE_MAX_QUAKE,
    MOVE_MAX_ROCKFALL,
    MOVE_MAX_STARFALL,
    MOVE_MAX_STEELSPIKE,
    MOVE_MAX_STRIKE,
    MOVE_MAX_WYRMWIND,
    MOVE_MENACING_MOONRAZE_MAELSTROM,
    MOVE_METEOR_BEAM,
    MOVE_MISTY_EXPLOSION,
    MOVE_NEVER_ENDING_NIGHTMARE_PHYSICAL,
    MOVE_NEVER_ENDING_NIGHTMARE_SPECIAL,
    MOVE_OCEANIC_OPERETTA,
    MOVE_PHANTOM_FORCE,
    MOVE_PRESENT,
    MOVE_PULVERIZING_PANCAKE,
    MOVE_RAZOR_WIND,
    MOVE_ROLLOUT,
    MOVE_SAVAGE_SPIN_OUT_PHYSICAL,
    MOVE_SAVAGE_SPIN_OUT_SPECIAL,
    MOVE_SEARING_SUNRAZE_SMASH,
    MOVE_SELF_DESTRUCT,
    MOVE_SHADOW_FORCE,
    MOVE_SHATTERED_PSYCHE_PHYSICAL,
    MOVE_SHATTERED_PSYCHE_SPECIAL,
    MOVE_SHEER_COLD,
    MOVE_SINISTER_ARROW_RAID,
    MOVE_SKULL_BASH,
    MOVE_SKY_ATTACK,
    MOVE_SKY_DROP,
    MOVE_SOLAR_BEAM,
    MOVE_SOLAR_BLADE,
    MOVE_SOUL_STEALING_7_STAR_STRIKE,
    MOVE_SPLINTERED_STORMSHARDS,
    MOVE_STOKED_SPARKSURFER,
    MOVE_SUBZERO_SLAMMER_PHYSICAL,
    MOVE_SUBZERO_SLAMMER_SPECIAL,
    MOVE_SUPERSONIC_SKYSTRIKE_PHYSICAL,
    MOVE_SUPERSONIC_SKYSTRIKE_SPECIAL,
    MOVE_TECTONIC_RAGE_PHYSICAL,
    MOVE_TECTONIC_RAGE_SPECIAL,
    MOVE_TWINKLE_TACKLE_PHYSICAL,
    MOVE_TWINKLE_TACKLE_SPECIAL,
    MOVE_UPROAR,
};

// A move that can hit more than one Pokemon strikes twice only when one is
// there to hit (Pokemon Central). The reference refuses those moves in any
// double battle, one target or two. Pollen Puff aimed at the user's ally heals
// it and deals no damage, and the ability doubles the moves that deal damage
// (Pokemon Central, Amorefiliale), so it heals once; the reference would run
// it twice.
BOOL ParentalBond_MoveApplies(BattleSystem *battleSystem, BattleContext *ctx, u32 moveNo) {
    int range = BattleMoveTbl(ctx, moveNo)->range;
    int targets = 0;

    if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_PARENTAL_BOND
        || BattleMoveTbl(ctx, moveNo)->category == CATEGORY_STATUS
        || (moveNo == MOVE_POLLEN_PUFF && ctx->battlerIdTarget == (ctx->battlerIdAttacker ^ 2))
        || MoveIsInList(moveNo, sMultiStrikeMoves, NELEMS(sMultiStrikeMoves))
        || MoveIsInList(moveNo, sParentalBondSingleStrikeMoves, NELEMS(sParentalBondSingleStrikeMoves))) {
        return FALSE;
    }
    if (range == RANGE_ADJACENT_OPPONENTS || range == RANGE_ALL_ADJACENT) {
        for (int battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
            if (battlerId != ctx->battlerIdAttacker && ctx->battleMons[battlerId].hp
                && (range == RANGE_ALL_ADJACENT || BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker))) {
                targets++;
            }
        }
    }
    return targets <= 1;
}

// Once, as the move begins, where the reference's before-move sequence ends:
// for the move chosen, and again for a move Metronome or its kind calls. Not
// for a spread move's later targets, which come round with PP already taken.
// Bide strikes twice only as it unleashes, both times for the energy it stored
// (Pokemon Central); the damage is already worked out by then, and nothing on
// its other turns.
void TryStartParentalBond(BattleSystem *battleSystem, BattleContext *ctx) {
    if (ctx->multiHitCountTemp == 0
        && !(ctx->unk_2184 & MULTIHIT_SKIP_PP_DECREMENT)
        && !(BattleMoveTbl(ctx, ctx->moveNoCur)->effect == MOVE_EFFECT_BIDE && ctx->damage == 0)
        && ParentalBond_MoveApplies(battleSystem, ctx, ctx->moveNoCur)) {
        ctx->multiHitCount = 2;
        ctx->multiHitCountTemp = 2;
        ctx->checkMultiHit = MULTIHIT_MULTI_HIT_MOVE;
        ctx->unk_38 = AFTER_MOVE_MESSAGE_MULTI_HIT;
        ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond = TRUE;
    }
}

BOOL ParentalBond_IsFirstStrike(BattleContext *ctx) {
    return ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond && ctx->multiHitCount == 2;
}

BOOL ParentalBond_IsSecondStrike(BattleContext *ctx) {
    return ctx->selfTurnData[ctx->battlerIdAttacker].parentalBond && ctx->multiHitCount == 1;
}

// A multi-strike move stops when its user falls asleep partway, to Effect
// Spore, but not one Sleep Talk called, whose user was asleep from the start
// (Pokemon Central, Mossa multicolpo). Parental Bond's second strike is one
// more of these. Retail stopped both after the first strike.
BOOL MultiHit_StoppedBySleep(BattleContext *ctx) {
    return (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) && ctx->moveNoTemp != MOVE_SLEEP_TALK;
}

// The first strike has landed and the second will follow: nothing the first
// did stopped the move, as the multi-strike loop (ov12_0224CF14) asks it.
BOOL ParentalBond_StrikeToCome(BattleContext *ctx) {
    return ParentalBond_IsFirstStrike(ctx)
        && ctx->battlerIdFainted == BATTLER_NONE
        && !MultiHit_StoppedBySleep(ctx)
        && !(ctx->moveStatusFlag & MOVE_STATUS_MULTI_HIT_DISRUPTED);
}

// A stat once its stage has been applied. The table this reads is the one the
// damage calculation uses, so a command asking for a boosted stat gets the
// same number the damage would have used.
u32 BattleStatWithStage(u32 stat, int stage) {
    return stat * sStatChangeTable[stage][0] / sStatChangeTable[stage][1];
}

// Whether the ground can reach a Pokemon. Levitate, Eelevate -- which is
// Levitate under another name -- a Flying type, Magnet Rise and an Air Balloon
// lift it; Gravity, Ingrain, an Iron Ball and a Smack Down bring it back down;
// and something in the air mid-move is not standing anywhere at all.
BOOL BattlerIsGrounded(BattleContext *ctx, int battlerId) {
    int holdEffect = GetBattlerHeldItemEffect(ctx, battlerId);
    BOOL lifted = GetBattlerAbility(ctx, battlerId) == ABILITY_LEVITATE
        || GetBattlerAbility(ctx, battlerId) == ABILITY_EELEVATE
        || ctx->battleMons[battlerId].type1 == TYPE_FLYING
        || ctx->battleMons[battlerId].type2 == TYPE_FLYING
        || ctx->battleMons[battlerId].unk88.magnetRiseTurns != 0
        || ctx->moveConditions[battlerId].telekinesisTurns != 0
        || holdEffect == HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT;
    BOOL pulledDown = holdEffect == HOLD_EFFECT_SPEED_DOWN_GROUNDED
        || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
        || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_SMACK_DOWN)
        || (ctx->fieldCondition & FIELD_CONDITION_GRAVITY);

    if (lifted && !pulledDown) {
        return FALSE;
    }
    if (ctx->battleMons[battlerId].moveEffectFlags & (MOVE_EFFECT_FLAG_FLY | MOVE_EFFECT_FLAG_DIG | MOVE_EFFECT_FLAG_DIVE)) {
        return FALSE;
    }
    return TRUE;
}

// Lay a terrain over the battle, or clear the one that is there. The turns are
// the five a weather gets, plus whatever a Terrain Extender adds -- which is
// the whole reason the battler laying the ground is passed in: the item is
// read off whoever laid it, not off whoever is standing on it, and a Terrain
// Extender that walks in afterwards lengthens nothing. The three the item's
// record carries is the three turns it is supposed to add.
//
// Setting the terrain that is already down does nothing at all, which is what
// makes the move fail rather than refresh it -- and so an Extender cannot be
// used to top up its own ground either.
// The type Mimicry takes from each terrain.
static u8 TerrainMimicryType(int terrainType) {
    switch (terrainType) {
    case ELECTRIC_TERRAIN:
        return TYPE_ELECTRIC;
    case GRASSY_TERRAIN:
        return TYPE_GRASS;
    case MISTY_TERRAIN:
        return TYPE_FAIRY;
    default:
        return TYPE_PSYCHIC;
    }
}

// A Mimicry holder going back to its own two types, which the reference
// reads from the Pokemon as it does here, without a word; the third type
// stays. Does nothing for a battler that has not taken a terrain's type.
void Battler_MimicryRestoreTypes(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    Pokemon *mon;

    if (ctx->mimicryTerrain[battlerId] == TERRAIN_NONE) {
        return;
    }
    ctx->mimicryTerrain[battlerId] = TERRAIN_NONE;
    mon = BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]);
    ctx->battleMons[battlerId].type1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
    ctx->battleMons[battlerId].type2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
}

void BattleContext_UpdateTerrainOverlay(BattleContext *ctx, int battlerId, int terrainType) {
    if (ctx->terrainOverlayType == terrainType) {
        return;
    }

    ctx->terrainOverlayType = terrainType;
    ctx->terrainOverlayTurns = terrainType != TERRAIN_NONE ? TERRAIN_TURNS : 0;

    if (terrainType != TERRAIN_NONE && GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_EXTEND_TERRAIN) {
        ctx->terrainOverlayTurns += GetHeldItemModifier(ctx, battlerId, 0);
    }
}

// Which stat the Seed a battler is holding would raise, or STAT_HP for "none
// of them" -- no Seed, or the wrong ground under it. The reference asks the
// item id here, through a macro over a run of four consecutive ids it happens
// to have; asking the hold effect is the same four items and is what the
// record on each of them is for. The turn count is asked as well as the type,
// the way the reference asks it, so a terrain that has run out is no terrain.
static int TerrainSeedStat(BattleContext *ctx, int battlerId) {
    if (ctx->terrainOverlayTurns == 0) {
        return STAT_HP;
    }
    switch (GetBattlerHeldItemEffect(ctx, battlerId)) {
    case HOLD_EFFECT_BOOST_DEF_ON_ELECRIC_TERRAIN:
        return ctx->terrainOverlayType == ELECTRIC_TERRAIN ? STAT_DEF : STAT_HP;
    case HOLD_EFFECT_BOOST_DEF_ON_GRASSY_TERRAIN:
        return ctx->terrainOverlayType == GRASSY_TERRAIN ? STAT_DEF : STAT_HP;
    case HOLD_EFFECT_BOOST_SPDEF_ON_MISTY_TERRAIN:
        return ctx->terrainOverlayType == MISTY_TERRAIN ? STAT_SPDEF : STAT_HP;
    case HOLD_EFFECT_BOOST_SPDEF_ON_PSYCHIC_TERRAIN:
        return ctx->terrainOverlayType == PSYCHIC_TERRAIN ? STAT_SPDEF : STAT_HP;
    default:
        return STAT_HP;
    }
}

// Which of a battler's five stats is highest right now, stat stages included.
// Attack wins a tie, then Defense, Sp. Atk, Sp. Def, and Speed last -- which is
// why Speed is left out of the loop and asked afterwards.
static u8 ParadoxGreatestStat(BattleContext *ctx, int battlerId) {
    BattleMon *mon = &ctx->battleMons[battlerId];
    u16 stats[] = { mon->atk, mon->def, mon->speed, mon->spAtk, mon->spDef };
    u8 highestStat = STAT_ATK;
    u32 highest = BattleStatWithStage(stats[STAT_ATK - 1], mon->statChanges[STAT_ATK]);
    u32 value;
    int stat;

    for (stat = STAT_DEF; stat < STAT_ACC; stat++) {
        if (stat == STAT_SPEED) {
            continue;
        }
        value = BattleStatWithStage(stats[stat - 1], mon->statChanges[stat]);
        if (value > highest) {
            highest = value;
            highestStat = stat;
        }
    }

    if (BattleStatWithStage(stats[STAT_SPEED - 1], mon->statChanges[STAT_SPEED]) > highest) {
        highestStat = STAT_SPEED;
    }

    return highestStat;
}

// Protosynthesis in the sun and Quark Drive on the Electric Terrain. Both pick
// out the holder's best stat once, keep it until the weather or the ground
// that switched them on has gone, and are announced by the same subscript.
//
// Returns the subscript to run, or BATTLE_SUBSCRIPT_NONE when there is nothing
// to switch on. Called from the send-out check and from the ActivateParadoxAbility
// script command, which is why it does all of its own asking.
//
// A Booster Energy stands in for whichever of the two is missing, and only
// when it is missing: the reference asks the weather or the ground first and
// spends the item only if the answer was no. An energy that has been spent is
// remembered, because the boost it bought does not end the way the weather's
// does and because the ability must not switch on again over the top of it.
int BattleContext_ActivateParadoxAbility(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int script = BATTLE_SUBSCRIPT_NONE;
    BOOL energy = GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_ACTIVATE_PARADOX_ABILITIES;

    // A Transformed Pokemon does not get to use a Paradox ability it copied.
    if (ctx->paradoxBoostedStat[battlerId] != 0 || ctx->boosterEnergyActivated[battlerId] || !ctx->battleMons[battlerId].hp || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return BATTLE_SUBSCRIPT_NONE;
    }

    switch (GetBattlerAbility(ctx, battlerId)) {
    case ABILITY_PROTOSYNTHESIS:
        // The sun is weather, so Cloud Nine and Air Lock blot it out.
        if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK) && (ctx->fieldCondition & FIELD_CONDITION_SUN_ALL)) {
            script = BATTLE_SUBSCRIPT_PARADOX_ABILITY_START;
        } else if (energy) {
            script = BATTLE_SUBSCRIPT_BOOSTER_ENERGY;
        }
        break;
    case ABILITY_QUARK_DRIVE:
        // The ground is not weather, so neither of those two touches it.
        if (ctx->terrainOverlayType == ELECTRIC_TERRAIN) {
            script = BATTLE_SUBSCRIPT_PARADOX_ABILITY_START;
        } else if (energy) {
            script = BATTLE_SUBSCRIPT_BOOSTER_ENERGY;
        }
        break;
    }

    if (script != BATTLE_SUBSCRIPT_NONE) {
        if (script == BATTLE_SUBSCRIPT_BOOSTER_ENERGY) {
            ctx->boosterEnergyActivated[battlerId] = TRUE;
        }
        ctx->paradoxBoostedStat[battlerId] = ParadoxGreatestStat(ctx, battlerId);
        ctx->battlerIdTemp = battlerId;
        // Which stat the subscript names.
        ctx->msgTemp = ctx->paradoxBoostedStat[battlerId];
    }

    return script;
}

// A battle keeps retail's move table where retail kept it, because the battle
// assembly still reads the structure around it by offset. The moves added
// since are kept past the end of that structure, and this is the only place
// that has to know which is which.
const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) {
    if (moveNo > NUM_MOVES) {
        return &ctx->addedMoveData[moveNo - NUM_MOVES - 1];
    }
    return &ctx->trainerAIData.moveData[moveNo];
}

// The sound moves, the contact flag and a move's type after Normalize are all
// read from more than one place now, so they are answered here, next to the
// tables they read.
BOOL BattleMoveIsSoundBased(u32 moveNo) {
    return MoveIsInList(moveNo, sSoundMoves, NELEMS(sSoundMoves));
}

BOOL BattleMoveStampsOnMinimize(u32 moveNo) {
    return MoveIsInList(moveNo, sMinimizeVulnerableMoves, NELEMS(sMinimizeVulnerableMoves));
}

// Long Reach ends the attacker's moves before they touch anything, so the
// question is not one the move table can answer on its own. It is asked of the
// move the attacker is using, everywhere it is asked, which is why the ability
// belongs in here rather than at each of the callers.
//
// Protective Pads goes in beside it for the same reason: the reference answers
// both from one function, IsContactBeingMade, and every read of contact over
// there goes through it -- Rough Skin, Static, Rocky Helmet, Sticky Barb, and
// Unseen Fist punching through a Protect, which the pads therefore also stop.
// Either side's pads end the contact, which is the reference's own reading:
// the attacker's keep it off what it hits, the target's keep the attacker off
// itself.
BOOL BattleMoveMakesContact(BattleContext *ctx, u32 moveNo) {
    if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_LONG_REACH) {
        return FALSE;
    }
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_PREVENT_CONTACT_EFFECTS) {
        return FALSE;
    }
    if (ctx->battlerIdTarget != BATTLER_NONE && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) == HOLD_EFFECT_PREVENT_CONTACT_EFFECTS) {
        return FALSE;
    }
    // A Punching Glove is a pair of pads for punches alone: the reference asks
    // it in the same function and only of the attacker, so a glove on what is
    // being punched changes nothing.
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_INCREASE_PUNCHING_MOVE_DMG && BattleMoveIsPunching(moveNo) == TRUE) {
        return FALSE;
    }
    // Shell Side Arm touches its target when it goes in physically (Pokemon
    // Central, Armaguscio).
    if (moveNo == MOVE_SHELL_SIDE_ARM) {
        return BattleMoveCategory(ctx, moveNo, ctx->battlerIdAttacker) == CATEGORY_PHYSICAL;
    }
    return (BattleMoveTbl(ctx, moveNo)->unkB & 1) != 0;
}

// The moves whose type is decided by something other than the move table --
// Hidden Power's IVs, Weather Ball's weather, Natural Gift's berry, Judgment's
// plate -- are the ones the -ate abilities leave alone.
static BOOL MoveTypeIsFixedByTheMove(u32 moveNo) {
    switch (moveNo) {
    case MOVE_HIDDEN_POWER:
    case MOVE_WEATHER_BALL:
    case MOVE_NATURAL_GIFT:
    case MOVE_JUDGMENT:
    case MOVE_TECHNO_BLAST:
    case MOVE_MULTI_ATTACK:
    case MOVE_TERRAIN_PULSE:
        return TRUE;
    default:
        return FALSE;
    }
}

// Normalize, the five -ate abilities and Liquid Voice all answer the same
// question, so it is answered once here. moveTypeDefault is the type something
// else has already decided on -- ctx->moveType for a caller that has a
// battler, an explicit argument for the two that do not.
static u8 BattleMoveTypeForAbility(BattleContext *ctx, int battlerId, int ability, u32 moveNo, int moveTypeDefault) {
    u8 moveType;

    if (ability == ABILITY_NORMALIZE) {
        moveType = TYPE_NORMAL;
    } else if (BattleMoveTbl(ctx, moveNo)->type == TYPE_NORMAL && MoveTypeIsFixedByTheMove(moveNo) == FALSE) {
        // The gate is on the move table's own type, so a move retyped into
        // Normal by something else is not caught, and one that is already the
        // -ate type gets nothing.
        switch (ability) {
        case ABILITY_AERILATE:
            moveType = TYPE_FLYING;
            break;
        case ABILITY_PIXILATE:
            moveType = TYPE_FAIRY;
            break;
        case ABILITY_REFRIGERATE:
            moveType = TYPE_ICE;
            break;
        case ABILITY_GALVANIZE:
            moveType = TYPE_ELECTRIC;
            break;
        case ABILITY_DRAGONIZE:
            moveType = TYPE_DRAGON;
            break;
        default:
            moveType = TYPE_NORMAL;
            break;
        }
    } else if (moveTypeDefault) {
        moveType = moveTypeDefault;
    } else {
        moveType = BattleMoveTbl(ctx, moveNo)->type;
    }

    // Liquid Voice sits after the rest on purpose: it overrides whatever the
    // move table, a dynamic type or Normalize said, and not only on a Normal
    // move. It pays no power for the change.
    if (ability == ABILITY_LIQUID_VOICE && BattleMoveIsSoundBased(moveNo) == TRUE) {
        moveType = TYPE_WATER;
    }

    // Ion Deluge gets the last word, after every ability above has had its
    // say: whatever is still Normal when the air is charged goes out as
    // Electric. Unlike the -ate abilities it asks what the move has ended up
    // as rather than what the move table says, so a move Normalize has just
    // turned Normal is caught too. The reference is explicit about the order.
    if (moveType == TYPE_NORMAL && (ctx->fieldCondition & FIELD_CONDITION_ION_DELUGE)) {
        moveType = TYPE_ELECTRIC;
    }

    // Electrify makes the move of the Pokemon it landed on Electric for the
    // rest of the turn, whatever the move was, a status move too; not
    // Struggle (Pokemon Central, Elettrocontagio). BATTLER_NONE is a move no
    // battler is using, as the AI's look at its party asks.
    if (battlerId < BATTLER_MAX && ctx->turnData[battlerId].electrified && moveNo != MOVE_STRUGGLE) {
        moveType = TYPE_ELECTRIC;
    }

    return moveType;
}

u8 BattleMoveAdjustedType(BattleContext *ctx, int battlerId, u32 moveNo) {
    return BattleMoveTypeForAbility(ctx, battlerId, GetBattlerAbility(ctx, battlerId), moveNo, ctx->moveType);
}

// Sweet Veil, and the three abilities that turn away a hurried move, cover
// their ally as much as themselves. This answers with the battler whose
// ability it is, so the message can name the right one, and BATTLER_NONE when
// neither of the pair has it. An empty slot in a single battle has no HP and
// so is never asked.
static int BattlerOrAllyWithAbility(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int ability) {
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ability) == TRUE) {
        return battlerIdTarget;
    }
    if (ctx->battleMons[battlerIdTarget ^ 2].hp != 0 && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget ^ 2, ability) == TRUE) {
        return battlerIdTarget ^ 2;
    }
    return BATTLER_NONE;
}

// Aroma Veil keeps off its holder and the holder's ally what limits the moves
// a Pokemon may use: Taunt, Torment, Encore, Disable, Heal Block and
// infatuation (Pokemon Central, Aromavelo). The reference declares the
// ability and nothing reads it. Here are the status moves that bring them,
// turned away before they land, as the reference turns away a status move
// Sweet Veil or Pastel Veil refuses; Mold Breaker gets through. The same
// effects arriving any other way -- Cursed Body's disabling, Cute Charm, a
// Destiny Knot, Psychic Noise's heal block -- are refused where they arrive.
static const u16 sMoveLimitingEffects[] = {
    MOVE_EFFECT_DISABLE,
    MOVE_EFFECT_ENCORE,
    MOVE_EFFECT_INFATUATE,
    MOVE_EFFECT_TORMENT,
    MOVE_EFFECT_TAUNT,
    MOVE_EFFECT_PREVENT_HEALING,
};

static BOOL MoveEffectLimitsMoves(int moveEffect) {
    return MoveIsInList(moveEffect, sMoveLimitingEffects, NELEMS(sMoveLimitingEffects));
}

// Whether Aroma Veil on battlerId's side, its own or a standing ally's,
// shelters it from something that is not a move aimed at it.
static BOOL AromaVeilShelters(BattleContext *ctx, int battlerId) {
    return GetBattlerAbility(ctx, battlerId) == ABILITY_AROMA_VEIL
        || (ctx->battleMons[battlerId ^ 2].hp && GetBattlerAbility(ctx, battlerId ^ 2) == ABILITY_AROMA_VEIL);
}

int BattleContext_CheckMoveImmunityFromAbility(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget) {
    int script;
    int moveType;

    script = BATTLE_SUBSCRIPT_NONE;

    // A Meloetta's move has reached a target, which is what Relic Song needs
    // before it changes the form (ability.c:47, relic_song_tracker).
    if ((ctx->battleMons[battlerIdAttacker].species == SPECIES_MELOETTA || ctx->battleMons[battlerIdAttacker].species == SPECIES_MELOETTA_PIROUETTE)
        && ctx->battleMons[battlerIdAttacker].hp && !(ctx->moveStatusFlag & MOVE_STATUS_FAILED)) {
        ctx->relicSongTracker |= MaskOfFlagNo(battlerIdAttacker);
    }

    moveType = BattleMoveAdjustedType(ctx, battlerIdAttacker, ctx->moveNoCur);

    // A Dark type on the other side is not fooled by a status move Prankster
    // hurried: it does not affect it. That is a type's immunity rather than an
    // ability's refusal, so it is answered the way the type chart answers one,
    // with the no-effect flag the miss script turns into "It doesn't affect
    // {0}...". The priority is the one the turn order compared, and it is asked
    // to be non-zero rather than positive because the reference reads it as a
    // u8: a Prankster Roar at -5 is refused there too, which is also the
    // canonical rule, since every status move Prankster touches is refused.
    if (GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_PRANKSTER
        && BattleMoveTbl(ctx, ctx->moveNoCur)->category == CATEGORY_STATUS
        && BattlerMovePriority(ctx, battlerIdAttacker, ctx->moveNoCur) != 0
        && (battlerIdAttacker & 1) != (battlerIdTarget & 1)
        && (GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL) == TYPE_DARK || GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL) == TYPE_DARK || GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_3, NULL) == TYPE_DARK)) {
        ctx->moveStatusFlag |= MOVE_STATUS_NO_EFFECT;
        ctx->moveFail[battlerIdAttacker].noEffect = TRUE;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_VOLT_ABSORB) == TRUE && moveType == TYPE_ELECTRIC && battlerIdAttacker != battlerIdTarget) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerIdTarget].maxHp, 4);
        script = BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP;
    }

    // Water Absorb wants a damaging Water move, and one it did not aim at
    // itself -- the reference asks both of it, as it does of Volt Absorb and
    // Irrigation. Dry Skin below asks only for the power, there as here.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WATER_ABSORB) == TRUE && moveType == TYPE_WATER && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && battlerIdAttacker != battlerIdTarget && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerIdTarget].maxHp, 4);
        script = BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP;
    }
    int moveNoCur = ctx->moveNoCur;
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLASH_FIRE) == TRUE && moveType == TYPE_FIRE && !(ctx->battleMons[battlerIdTarget].status & STATUS_FREEZE) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN)) {
        if (BattleMoveTbl(ctx, ctx->moveNoCur)->power || ctx->moveNoCur == MOVE_WILL_O_WISP) {
            script = BATTLE_SUBSCRIPT_ABSORB_AND_BOOST_FIRE_TYPE_MOVES;
        }
    }
    // Well Baked Body eats the Fire move and comes out harder for it. Like
    // Flash Fire it counts Will-O-Wisp, which has no power to swallow, but
    // unlike Flash Fire it will not feed on a Fire move the holder aimed at
    // itself.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WELL_BAKED_BODY) == TRUE && moveType == TYPE_FIRE && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && battlerIdAttacker != battlerIdTarget) {
        if (BattleMoveTbl(ctx, ctx->moveNoCur)->power || ctx->moveNoCur == MOVE_WILL_O_WISP) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = battlerIdTarget;
            script = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_DEFENSE;
        }
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SOUNDPROOF) == TRUE) {
        for (int i = 0; i < NELEMS(sSoundMoves); i++) {
            if (sSoundMoves[i] == ctx->moveNoCur) {
                script = BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF;
                break;
            }
        }
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_MOTOR_DRIVE) == TRUE && moveType == TYPE_ELECTRIC && battlerIdAttacker != battlerIdTarget) {
        script = BATTLE_SUBSCRIPT_ABSORB_AND_SPEED_UP_1_STAGE;
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_DRY_SKIN) == TRUE && moveType == TYPE_WATER && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerIdTarget].maxHp, 4);
        script = BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP;
    }
    // Sap Sipper swallows a Grass move and Irrigation a Water one; neither
    // restores HP, they raise the holder's Attack instead.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SAP_SIPPER) == TRUE && moveType == TYPE_GRASS && battlerIdAttacker != battlerIdTarget) {
        ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE;
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        ctx->battlerIdStatChange = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_ATTACK;
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_IRRIGATION) == TRUE && moveType == TYPE_WATER && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && battlerIdAttacker != battlerIdTarget) {
        ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES;
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        ctx->battlerIdStatChange = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_ATTACK;
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_EARTH_EATER) == TRUE && moveType == TYPE_GROUND && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[battlerIdTarget].maxHp, 4);
        script = BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP;
    }
    // Evaporate gains nothing from the Water move, it only refuses it. The
    // subscript Soundproof uses says exactly that and names the ability.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_EVAPORATE) == TRUE && moveType == TYPE_WATER && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF;
    }
    // Wind Rider takes the wind move and a stage of Attack with it.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WIND_RIDER) == TRUE && MoveIsInList(ctx->moveNoCur, sWindMoves, NELEMS(sWindMoves)) == TRUE && battlerIdAttacker != battlerIdTarget) {
        ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE;
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        ctx->battlerIdStatChange = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_ATTACK;
    }
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_BULLETPROOF) == TRUE && MoveIsInList(ctx->moveNoCur, sBallAndBombMoves, NELEMS(sBallAndBombMoves)) == TRUE) {
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF;
    }
    // Safety Goggles keep a powder move off whoever is wearing them. An item
    // rather than an ability, in a function that says abilities in its name --
    // but this is the one place this tree answers "the move does not touch
    // this target", and the reference asks its goggles in the same sweep as
    // Bulletproof above. A Pokemon powdering itself is let through, which is
    // the reference's condition and not an accident of this one.
    if (GetBattlerHeldItemEffect(ctx, battlerIdTarget) == HOLD_EFFECT_SPORE_POWDER_IMMUNITY && MoveIsInList(ctx->moveNoCur, sPowderMoves, NELEMS(sPowderMoves)) == TRUE && battlerIdAttacker != battlerIdTarget) {
        script = BATTLE_SUBSCRIPT_SAFETY_GOGGLES;
    }
    // A status move aimed at a Pokemon that cannot take the status is turned
    // away before it lands, as the reference's status-based ability failures
    // do; the status subscripts refuse the same abilities for everything that
    // arrives another way. Where two of these apply, the one the reference
    // asks first names itself: Flower Veil, then Sweet Veil, then these two.
    int moveEffect = BattleMoveTbl(ctx, ctx->moveNoCur)->effect;
    BOOL givesStatus = moveEffect == MOVE_EFFECT_STATUS_SLEEP || moveEffect == MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN || moveEffect == MOVE_EFFECT_STATUS_PARALYZE
        || moveEffect == MOVE_EFFECT_STATUS_POISON || moveEffect == MOVE_EFFECT_STATUS_BADLY_POISON || moveEffect == MOVE_EFFECT_STATUS_BURN;
    // Comatose is already asleep, and so takes none of them; Mold Breaker
    // does not pass it (the reference's AbilityFlags).
    if (givesStatus && GetBattlerAbility(ctx, battlerIdTarget) == ABILITY_COMATOSE) {
        ctx->battlerIdTemp = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
    }
    // Nor does a Minior with its shell on, nor can it Rest.
    if ((givesStatus || moveEffect == MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP) && Battler_ShieldsUp(ctx, battlerIdTarget) == TRUE) {
        ctx->battlerIdTemp = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
    }
    // Pastel Veil keeps poison off its side.
    if (moveEffect == MOVE_EFFECT_STATUS_POISON || moveEffect == MOVE_EFFECT_STATUS_BADLY_POISON) {
        int veiled = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_PASTEL_VEIL);
        if (veiled != BATTLER_NONE) {
            ctx->battlerIdTemp = veiled;
            script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
        }
    }
    // Aroma Veil keeps its side free of the moves that limit which moves a
    // Pokemon may use. See MoveEffectLimitsMoves.
    if (MoveEffectLimitsMoves(moveEffect) == TRUE) {
        int veiled = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_AROMA_VEIL);
        if (veiled != BATTLER_NONE) {
            ctx->battlerIdTemp = veiled;
            script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
        }
    }
    // Oblivious does not notice a taunt, from the sixth generation on (Pokemon
    // Central, Indifferenza); a Mold Breaker gets through. The reference asks
    // it nowhere, here or in the Taunt subscript.
    if (moveEffect == MOVE_EFFECT_TAUNT && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_OBLIVIOUS) == TRUE) {
        ctx->battlerIdTemp = battlerIdTarget;
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
    }
    // Sweet Veil keeps its side awake: the moves that put a Pokemon to sleep,
    // Yawn, and Rest. Rest aims at its user, so a Pokemon under Sweet Veil
    // cannot rest either, which is the reference's behaviour and reads as a
    // bug until you know that.
    if (moveEffect == MOVE_EFFECT_STATUS_SLEEP || moveEffect == MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN || moveEffect == MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP) {
        int veiled = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SWEET_VEIL);
        if (veiled != BATTLER_NONE) {
            ctx->battlerIdTemp = veiled;
            script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
        }
    }
    // Flower Veil keeps every one of them off a Grass type on its side.
    if (givesStatus
        && (GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL) == TYPE_GRASS || GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL) == TYPE_GRASS || GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_3, NULL) == TYPE_GRASS)) {
        int veiled = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLOWER_VEIL);
        if (veiled != BATTLER_NONE) {
            ctx->battlerIdTemp = veiled;
            script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
        }
    }
    // Armor Tail, Queenly Majesty and Dazzling are one ability wearing three
    // names: each turns away anything hurried coming from the other side, on
    // behalf of its ally as much as itself. Hurried means the priority the
    // turn order compared, as the reference reads clientPriority, so Prankster,
    // Gale Wings, Triage and Grassy Glide count as much as the move table. A
    // move aimed at its own user, at the field, or at a whole side is never
    // hurried past them -- that is the same exemption Psychic Terrain takes,
    // and it is by range alone.
    if (BattlerMovePriority(ctx, battlerIdAttacker, ctx->moveNoCur) > 0 && (battlerIdAttacker & 1) != (battlerIdTarget & 1) && !(BattleMoveTbl(ctx, ctx->moveNoCur)->range & (RANGE_USER | RANGE_USER_SIDE | RANGE_FIELD | RANGE_OPPONENT_SIDE))) {
        int blocker = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_ARMOR_TAIL);
        if (blocker == BATTLER_NONE) {
            blocker = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_QUEENLY_MAJESTY);
        }
        if (blocker == BATTLER_NONE) {
            blocker = BattlerOrAllyWithAbility(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_DAZZLING);
        }
        if (blocker != BATTLER_NONE) {
            ctx->battlerIdTemp = blocker;
            script = BATTLE_SUBSCRIPT_BLOCKED_BY_ABILITY;
        }
    }
    // The terrain refuses a move the way an ability does -- one script, one
    // line of text, no more work -- so its three refusals are answered here
    // rather than in a hook of their own. All three want the move's target
    // standing on the terrain; the reference reads that through Mold Breaker,
    // which this game has no grounded-with-Mold-Breaker question for.
    //
    // Psychic Terrain turns away anything hurried from the other side. It is
    // the priority the turn order compared, so an ability's extra step counts
    // as much as the move table's, and the exemption is the same one the three
    // abilities above take. Future Sight is the reference's fourth exemption
    // and is not here: its delayed hit never comes through this function.
    if (ctx->terrainOverlayType == PSYCHIC_TERRAIN
        && BattlerMovePriority(ctx, battlerIdAttacker, ctx->moveNoCur) > 0
        && (battlerIdAttacker & 1) != (battlerIdTarget & 1)
        && !(BattleMoveTbl(ctx, ctx->moveNoCur)->range & (RANGE_USER | RANGE_USER_SIDE | RANGE_FIELD | RANGE_OPPONENT_SIDE))
        && BattlerIsGrounded(ctx, battlerIdTarget) == TRUE) {
        script = BATTLE_SUBSCRIPT_PSYCHIC_TERRAIN_PROTECTION;
    }
    // Electric Terrain keeps the ground awake and Misty Terrain keeps it well.
    // Both count Rest, which is aimed at its own user, so a Pokemon standing on
    // either cannot rest -- the reference's behaviour, and the same shape as
    // Sweet Veil above.
    if (ctx->terrainOverlayType == ELECTRIC_TERRAIN
        && (moveEffect == MOVE_EFFECT_STATUS_SLEEP || moveEffect == MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN || moveEffect == MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP)
        && BattlerIsGrounded(ctx, battlerIdTarget) == TRUE) {
        script = BATTLE_SUBSCRIPT_ELECTRIC_TERRAIN_PROTECTION;
    }
    if (ctx->terrainOverlayType == MISTY_TERRAIN
        && (moveEffect == MOVE_EFFECT_STATUS_SLEEP || moveEffect == MOVE_EFFECT_STATUS_SLEEP_NEXT_TURN || moveEffect == MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP
            || moveEffect == MOVE_EFFECT_STATUS_PARALYZE || moveEffect == MOVE_EFFECT_STATUS_POISON || moveEffect == MOVE_EFFECT_STATUS_BADLY_POISON
            || moveEffect == MOVE_EFFECT_STATUS_BURN || moveEffect == MOVE_EFFECT_STATUS_CONFUSE)
        && BattlerIsGrounded(ctx, battlerIdTarget) == TRUE) {
        script = BATTLE_SUBSCRIPT_MISTY_TERRAIN_PROTECTION;
    }
    // Telepathy only sees what an ally aims at it, so it is the one immunity
    // here that asks which side the attacker is on rather than what it used.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_TELEPATHY) == TRUE && battlerIdAttacker != battlerIdTarget && (battlerIdAttacker & 1) == (battlerIdTarget & 1) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        script = BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF;
    }

    return script;
}

BOOL ov12_02253068(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;
    int script;

    switch (GetBattlerAbility(ctx, battlerId)) {
    case ABILITY_SPEED_BOOST:
        if (ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].statChanges[3] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE && ctx->battleMons[battlerId].unk88.fakeOutCount != ctx->totalTurns + 1) {
            ctx->statChangeParam = 17;
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = battlerId;
            script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
            ret = TRUE;
        }
        break;
    case ABILITY_SHED_SKIN:
        if ((ctx->battleMons[battlerId].status & STATUS_ALL) && ctx->battleMons[battlerId].hp && ((BattleSystem_Random(battleSystem) % 10) < 3)) {
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
            ctx->battlerIdTemp = battlerId;
            script = BATTLE_SUBSCRIPT_ABILITY_RESTORE_STATUS;
            ret = TRUE;
        }
        break;
    // Shed Skin's ladder again, read off the ally, because the ally is who
    // gets cured and the message names whatever it was suffering from. The
    // ability credited is the holder's, so the two of them go in two
    // different slots. In a single battle the ally slot is a BattleMon full
    // of zeroes, which has no HP and so would fail the test anyway; the
    // battler count is asked first so the question is never put to it.
    case ABILITY_HEALER: {
        int ally = battlerId ^ 2;

        if (BattleSystem_GetMaxBattlers(battleSystem) > 2 && ctx->battleMons[battlerId].hp && ctx->battleMons[ally].hp && (ctx->battleMons[ally].status & STATUS_ALL) && ((BattleSystem_Random(battleSystem) % 10) < 3)) {
            if (ctx->battleMons[ally].status & STATUS_SLEEP) {
                ctx->msgTemp = 0;
            } else if (ctx->battleMons[ally].status & STATUS_POISON_ALL) {
                ctx->msgTemp = 1;
            } else if (ctx->battleMons[ally].status & STATUS_BURN) {
                ctx->msgTemp = 2;
            } else if (ctx->battleMons[ally].status & STATUS_PARALYSIS) {
                ctx->msgTemp = 3;
            } else {
                ctx->msgTemp = 4;
            }
            ctx->battlerIdTemp = ally;
            ctx->battlerIdAbility = battlerId;
            script = BATTLE_SUBSCRIPT_HEALER;
            ret = TRUE;
        }
        break;
    }
    // The berry Harvest brings back is the one Recycle remembers, so the two
    // of them share a slot and whichever goes first leaves the other nothing.
    // Sun makes it certain, and Cloud Nine and Air Lock take that certainty
    // away again, the way they do at every other weather read here. The hand
    // is filled by the script, so the party copy is filled with it.
    case ABILITY_HARVEST:
        if (ctx->battleMons[battlerId].hp && ItemIdIsBerry(ctx->recycleItem[battlerId]) == TRUE
            && (((WeatherUnderUmbrella(ctx, ctx->fieldCondition, battlerId) & FIELD_CONDITION_SUN_ALL) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK))
                || (BattleSystem_Random(battleSystem) % 2) == 0)) {
            ctx->itemTemp = ctx->recycleItem[battlerId];
            ctx->recycleItem[battlerId] = 0;
            ctx->battlerIdTemp = battlerId;
            script = BATTLE_SUBSCRIPT_HARVEST;
            ret = TRUE;
        }
        break;
    // Cud Chew eats the Berry again, whatever the moment: the Berry is put
    // back in the mouth only long enough for Pluck's routine, which applies a
    // Berry whether or not it was called for, to read it, and the Pokemon is
    // made the attacker because that routine feeds the attacker. The second
    // meal is the last, so what that routine notes of it is wiped.
    case ABILITY_CUD_CHEW:
        if (ctx->battleMons[battlerId].hp && ctx->cudChewBerry[battlerId] && ctx->cudChewTurn[battlerId] == (u16)ctx->totalTurns) {
            u16 held = ctx->battleMons[battlerId].item;

            ctx->battleMons[battlerId].item = ctx->cudChewBerry[battlerId];
            ctx->battlerIdAttacker = battlerId;
            TryEatOpponentBerry(battleSystem, ctx, battlerId);
            ctx->battleMons[battlerId].item = held;
            ctx->cudChewBerry[battlerId] = ITEM_NONE;
            ctx->battlerIdTemp = battlerId;
            script = BATTLE_SUBSCRIPT_CUD_CHEW;
            ret = TRUE;
        }
        break;
    // One stat up two stages, a different one down one. Both are picked as
    // offsets from Attack, because that is how the script spends them -- it
    // adds each to the first pointer of its group. The stage each offset is
    // tested against is statChanges[offset], and slot 0 of that array is
    // HP's, fixed at 6 for the life of the battle, so every test is one stat
    // behind the stat it is deciding about: Attack is always eligible and
    // Sp. Defense is never asked. That is what New Gold does and it is kept.
    //
    // What is not kept is how it gets there. The reference re-rolls until
    // the roll is legal, which never ends once nothing is legal -- the "8"
    // it sets to say so is overwritten on the next line and the script's
    // test for it can never fire. Drawing from the stats that qualify is the
    // same distribution, ends, and gives that 8 something to mean.
    case ABILITY_MOODY:
        if (ctx->battleMons[battlerId].hp) {
            int eligible[5];
            int count = 0;
            int raise = 8;
            int lower = 8;

            for (int i = 0; i < 5; i++) {
                if (ctx->battleMons[battlerId].statChanges[i] != 12) {
                    eligible[count++] = i;
                }
            }
            if (count != 0) {
                raise = eligible[BattleSystem_Random(battleSystem) % count];
            }

            count = 0;
            for (int i = 0; i < 5; i++) {
                if (ctx->battleMons[battlerId].statChanges[i] != 0 && i != raise) {
                    eligible[count++] = i;
                }
            }
            if (count != 0) {
                lower = eligible[BattleSystem_Random(battleSystem) % count];
            }

            ctx->calcTemp = raise;
            ctx->abilityTemp = lower;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdTemp = battlerId;
            ctx->battlerIdStatChange = battlerId;
            script = BATTLE_SUBSCRIPT_MOODY;
            ret = TRUE;
        }
        break;
    default:
        break;
    }

    if (ret == TRUE) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
        ctx->commandNext = ctx->command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
    }

    return ret;
}

int DamageDivide(int num, int denom) {
    int sign;

    if (num == 0) {
        return num;
    }

    if (num < 0) {
        sign = -1;
    } else {
        sign = 1;
    }

    num /= denom;

    if (num == 0) {
        num = sign;
    }

    return num;
}

// The reference's asm/qmath.s. q is a fraction over 4096, and the two differ
// only in which way an exact half goes. A q of exactly 1.0 hands the value
// back untouched rather than multiplying, as there.
u32 QMul_RoundUp(u32 value, u32 q) {
    if (q == UQ412__1_0) {
        return value;
    }
    return (value * q + 0x800) >> 12;
}

u32 QMul_RoundDown(u32 value, u32 q) {
    if (q == UQ412__1_0) {
        return value;
    }
    return (value * q + 0x7FF) >> 12;
}

// Embody Aspect (Pokemon Central, Albergamemorie): the Terastal Ogerpon of
// each mask raises one stat a stage as it comes in -- Speed with the Teal
// Mask, Sp. Def with the Wellspring, Attack with the Hearthflame and Defense
// with the Cornerstone. The later games tie that to Terastallizing and to
// every entry after it; this one has no Terastallization and the Terastal
// forms are species of their own, so the Pokemon has it whenever it comes in.
// The STAT_* it raises, or STAT_HP for another ability.
static int EmbodyAspectStat(u16 ability) {
    switch (ability) {
    case ABILITY_EMBODY_ASPECT:
        return STAT_SPEED;
    case ABILITY_EMBODY_ASPECT_2:
        return STAT_SPDEF;
    case ABILITY_EMBODY_ASPECT_3:
        return STAT_ATK;
    case ABILITY_EMBODY_ASPECT_4:
        return STAT_DEF;
    }
    return STAT_HP;
}

// Tera Shift (Pokemon Central, Teramorfosi): a Terapagos coming in takes its
// Terastal Form, whose ability is Tera Shell, before anything else on the way
// in speaks, and nothing suppresses it, so the ability is read off the
// battler. It keeps the form when it is switched out or faints, and goes back
// at the end of the battle (sFormReversion), so this happens once. hg-engine
// (d0380a487, SwitchInAbilityCheck.c:107) names the ability there and does
// nothing with it. Not for a Pokemon Transformed into one, which keeps the
// form it copied.
static u16 Battler_TeraShiftForm(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].species == SPECIES_TERAPAGOS && ctx->battleMons[battlerId].ability == ABILITY_TERA_SHIFT
        && ctx->battleMons[battlerId].hp && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_TERAPAGOS_TERASTAL;
    }
    return SPECIES_NONE;
}

// Desolate Land, Primordial Sea and Delta Stream (Pokemon Central, Terra
// Estrema, Mare Primordiale, Flusso Delta) each raise a strong weather as their
// Pokemon comes in. The one each raises, or 0 for another ability.
static u32 PrimalWeatherOf(u16 ability) {
    switch (ability) {
    case ABILITY_DESOLATE_LAND:
        return FIELD_CONDITION_EXTREMELY_HARSH_SUNLIGHT;
    case ABILITY_PRIMORDIAL_SEA:
        return FIELD_CONDITION_HEAVY_RAIN;
    case ABILITY_DELTA_STREAM:
        return FIELD_CONDITION_STRONG_WINDS;
    }
    return 0;
}

// A strong weather ends when no Pokemon on the field keeps it up any more: the
// one that raised it has gone out, fainted, or lost its ability or had it
// suppressed, and nobody else there has the same one. The weather is not the
// Pokemon's alone, so a second Kyogre keeps the heavy rain after the first
// has gone. hg-engine (d0380a487) asks this only when a Pokemon switches out
// or faints (subscripts 368 and 369, btl_scr_cmd_F9_canclearprimalweather),
// so its weather outlasts Roar, Dragon Tail, Red Card, Eject Button, Gastro
// Acid, Skill Swap and Neutralizing Gas; asking it with the entry abilities,
// after every action, reaches all of those.
static BOOL BattleContext_PrimalWeatherHasEnded(BattleSystem *battleSystem, BattleContext *ctx) {
    u32 weather = ctx->fieldCondition & FIELD_CONDITION_PRIMAL_WEATHER;
    int i;

    if (weather == 0) {
        return FALSE;
    }
    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        if (ctx->battleMons[i].hp && PrimalWeatherOf(GetBattlerAbility(ctx, i)) == weather) {
            return FALSE;
        }
    }
    return TRUE;
}

// Shields Down (Pokemon Central, Scudosoglia): a Minior with more than half its
// HP wears its shell, the Meteor Form, and at half or less loses it, the Core
// Form of its colour. The form is checked when it comes in and at the end of
// each turn, not as the HP moves. The Meteor Forms are SPECIES_MINIOR (red)
// and the six after it from orange, the Core Forms seven more in the same
// order. The ability is read off the battler, as nothing suppresses it, and a
// Pokemon that has it through Transform does not change. hg-engine
// (d0380a487) leaves both of its switch-in and form steps for the ability
// empty. The species to become, or SPECIES_NONE.
u16 Battler_ShieldsDownForm(BattleContext *ctx, int battlerId) {
    u16 species = ctx->battleMons[battlerId].species;
    BOOL meteor;
    BOOL shell;
    int colour;

    if (!ctx->battleMons[battlerId].hp || ctx->battleMons[battlerId].ability != ABILITY_SHIELDS_DOWN
        || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_NONE;
    }
    if (species == SPECIES_MINIOR) {
        colour = 0;
        meteor = TRUE;
    } else if (species >= SPECIES_MINIOR_METEOR_ORANGE && species <= SPECIES_MINIOR_METEOR_VIOLET) {
        colour = species - SPECIES_MINIOR_METEOR_ORANGE + 1;
        meteor = TRUE;
    } else if (species >= SPECIES_MINIOR_CORE_RED && species <= SPECIES_MINIOR_CORE_VIOLET) {
        colour = species - SPECIES_MINIOR_CORE_RED;
        meteor = FALSE;
    } else {
        return SPECIES_NONE;
    }
    shell = ctx->battleMons[battlerId].hp > (s32)(ctx->battleMons[battlerId].maxHp / 2);
    if (shell == meteor) {
        return SPECIES_NONE;
    }
    if (!shell) {
        return SPECIES_MINIOR_CORE_RED + colour;
    }
    return colour == 0 ? SPECIES_MINIOR : SPECIES_MINIOR_METEOR_ORANGE + colour - 1;
}

// While its shell is on, a Minior takes no status and cannot be made drowsy or
// put to sleep by Rest; one Transformed into it is not protected. Mold Breaker
// does not get past it. BMON_DATA_SHIELDS_UP is this, for the scripts.
BOOL Battler_ShieldsUp(BattleContext *ctx, int battlerId) {
    u16 species = ctx->battleMons[battlerId].species;

    return ctx->battleMons[battlerId].ability == ABILITY_SHIELDS_DOWN && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)
        && (species == SPECIES_MINIOR || (species >= SPECIES_MINIOR_METEOR_ORANGE && species <= SPECIES_MINIOR_METEOR_VIOLET));
}

// Opportunist copies the stat raises of the other side (Pokemon Central,
// Scrocco). The reference declares the ability and nothing reads it. Every
// stage a foe of a standing holder actually gains -- what the cap let
// through -- is kept for the holder here, and the holder takes them all after
// the move or the entry that raised them, so a multi-stat or multi-hit raise
// is copied whole. The holder's own copying is not copied back, which would
// set two Opportunists copying each other for ever; Costar copies without
// raising anything, so nothing comes of it either.
void Battler_OpportunistNotesRaise(BattleSystem *battleSystem, BattleContext *ctx, int stat, int stages) {
    int battlerId;

    if (stages <= 0 || (ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_OPPORTUNIST)) {
        return;
    }
    for (battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdStatChange)
            && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_OPPORTUNIST) {
            ctx->opportunistStages[battlerId][stat] += stages;
            if (ctx->opportunistStages[battlerId][stat] > 12) {
                ctx->opportunistStages[battlerId][stat] = 12;
            }
        }
    }
}

// How many times a Pokemon of battlerId's own party has fainted since the
// battle began. The faints are kept per battler slot, and in a double battle
// both slots on a side draw from the one party, where in a multi battle each
// partner has its own.
static int BattlerPartyFaintCount(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int i;
    int count = 0;

    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        if (BattleSystem_GetParty(battleSystem, i) == BattleSystem_GetParty(battleSystem, battlerId)) {
            count += ctx->totalTimesFainted[i];
        }
    }

    return count;
}

// Puts every stat stage of battlerId back at zero, and says whether any was
// not there already.
static BOOL BattlerClearStatChanges(BattleContext *ctx, int battlerId) {
    BOOL cleared = FALSE;
    int stat;

    for (stat = STAT_ATK; stat < NUM_BATTLE_STATS; stat++) {
        if (ctx->battleMons[battlerId].statChanges[stat] != 6) {
            ctx->battleMons[battlerId].statChanges[stat] = 6;
            cleared = TRUE;
        }
    }

    return cleared;
}

// Costar: the ally's stat stages become the holder's, and so does what
// raises the ally's critical-hit odds -- Focus Energy and Laser Focus, this
// game having no Dragon Cheer -- the holder's own going first. Psych Up copies
// the same things, but adds a Focus Energy to one already there rather than
// taking its place.
static void CostarCopiesAlly(BattleContext *ctx, int battlerId, int ally) {
    int stat;

    for (stat = 0; stat < NUM_BATTLE_STATS; stat++) {
        ctx->battleMons[battlerId].statChanges[stat] = ctx->battleMons[ally].statChanges[stat];
    }
    ctx->battleMons[battlerId].status2 = (ctx->battleMons[battlerId].status2 & ~STATUS2_FOCUS_ENERGY) | (ctx->battleMons[ally].status2 & STATUS2_FOCUS_ENERGY);
    ctx->moveConditions[battlerId].laserFocusTimer = ctx->moveConditions[ally].laserFocusTimer;
}

// Where a once-per-battle entry ability is remembered for this battler's
// Pokemon: its slot in the party it was sent out from. A side one trainer
// fields shares one party between its two battlers, and a multi or tag
// battle gives each partner its own (BattleSystem_GetParty's choice), so
// the partner's first Pokemon is not the player's (the reference's
// SanitizeClientForTeamAccess).
static u8 *OnceOnlyEntryAbilityDone(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int party = BattleSystem_GetParty(battleSystem, battlerId) == BattleSystem_GetParty(battleSystem, battlerId & 1) ? (battlerId & 1) : battlerId;

    return &ctx->onceOnlyEntryAbilityDone[party][ctx->selectedMonIndex[battlerId]];
}

// Opportunist copies what the other side raised (Battler_OpportunistNotesRaise)
// a stat at a time and at most two stages a step, each with the ability's
// line. An Opportunist that has fainted or lost the ability since takes
// nothing. TRUE with the script to run.
static BOOL TryOpportunistCopy(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int i;
    int j;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (i = 0; i < maxBattlers; i++) {
        battlerId = ctx->turnOrder[i];
        for (j = STAT_ATK; j < NUM_BATTLE_STATS; j++) {
            if (ctx->opportunistStages[battlerId][j]) {
                break;
            }
        }
        if (j == NUM_BATTLE_STATS) {
            continue;
        }
        if (!ctx->battleMons[battlerId].hp || GetBattlerAbility(ctx, battlerId) != ABILITY_OPPORTUNIST) {
            MI_CpuClear8(ctx->opportunistStages[battlerId], NUM_BATTLE_STATS);
            continue;
        }
        if (ctx->opportunistStages[battlerId][j] >= 2) {
            ctx->opportunistStages[battlerId][j] -= 2;
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES + j - STAT_ATK;
        } else {
            ctx->opportunistStages[battlerId][j]--;
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + j - STAT_ATK;
        }
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        ctx->battlerIdStatChange = battlerId;
        *script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
        return TRUE;
    }
    return FALSE;
}

// A Pokemon that has used up its held item is handed its partner's by a
// partner with Symbiosis (Pokemon Central, Simbiosi). The reference declares
// the ability and nothing reads it. Used up is what BtlCmd_RemoveItem marks --
// eaten, drunk, flung, popped, a Berry plucked off it included -- and not an
// item knocked off, stolen, swapped or burnt. The partner's item has to be one
// that can change hands. TRUE with the script to run.
static BOOL TrySymbiosisHandOver(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int i;
    int j;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (i = 0; i < maxBattlers; i++) {
        battlerId = ctx->turnOrder[i];
        if (!ctx->symbiosisPending[battlerId]) {
            continue;
        }
        ctx->symbiosisPending[battlerId] = FALSE;
        j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
        if (j != battlerId && ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].item == ITEM_NONE
            && ctx->battleMons[j].hp && GetBattlerAbility(ctx, j) == ABILITY_SYMBIOSIS && CanStealHeldItem(battleSystem, ctx, battlerId, j) == TRUE) {
            ctx->itemTemp = ctx->battleMons[j].item;
            ctx->battleMons[battlerId].item = ctx->battleMons[j].item;
            ctx->battleMons[j].item = ITEM_NONE;
            CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
            CopyBattleMonToPartyMon(battleSystem, ctx, j);
            ctx->battlerIdTemp = j;
            *script = BATTLE_SUBSCRIPT_SYMBIOSIS;
            return TRUE;
        }
    }
    return FALSE;
}

// Opportunist and Symbiosis answer at once, among whatever set them off
// (Pokemon Central, Scrocco, Simbiosi): after a move or an entry the entry
// abilities' check below asks them, and between one end-of-turn effect and the
// next the turn's end does, so a Speed Boost or Moody raise is copied and a
// Berry eaten there replaced before the next effect. The script to run, or
// BATTLE_SUBSCRIPT_NONE.
int TryOpportunistOrSymbiosis(BattleSystem *battleSystem, BattleContext *ctx) {
    int script = BATTLE_SUBSCRIPT_NONE;

    if (TryOpportunistCopy(battleSystem, ctx, &script) == FALSE) {
        TrySymbiosisHandOver(battleSystem, ctx, &script);
    }
    return script;
}

// Where Rage Fist's count is kept for this battler's Pokemon: its slot in the
// party it was sent out from, as for the once-per-battle entry abilities
// above, so the count goes out and comes back in with it.
u8 *Battler_RageFistHits(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int party = BattleSystem_GetParty(battleSystem, battlerId) == BattleSystem_GetParty(battleSystem, battlerId & 1) ? (battlerId & 1) : battlerId;

    return &ctx->rageFistHits[party][ctx->selectedMonIndex[battlerId]];
}

// Commander holds its pair on the field (Pokemon Central, Torre di Comando):
// a Tatsugiri in its Dondozo's mouth, and that Dondozo, which stays held once
// the Tatsugiri has fainted. Neither switches nor is made to leave, by a
// move, an ability or an item, for as long as it stands.
BOOL Battler_HeldByCommander(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].hp && (ctx->moveConditions[battlerId].commanding || ctx->moveConditions[battlerId].commanderForm);
}

// Commander (Pokemon Central, Torre di Comando): in a double battle that is
// not a Multi Battle, a Tatsugiri with the ability -- any of its three forms,
// its own and not a copy -- beside a Dondozo of the same trainer goes into
// its mouth, a substitute on either no bar. From then on the Tatsugiri skips
// its turns and no move aimed at it lands, neither can leave the field nor be
// made to (Battler_HeldByCommander), and the Dondozo's Attack, Defense, Sp.
// Atk, Sp. Def and Speed rise by two. A Tatsugiri that goes in during a turn
// gives up what it had chosen for it. The Dondozo keeps it all while it stays
// in, and the Tatsugiri's form for Order Up, the Tatsugiri fainted or not; it
// takes in no other, and its own fainting lets the Tatsugiri out
// (InitFaintedWork). Neutralizing Gas keeps the ability from acting, through
// GetBattlerAbility; the step is asked at every entry, so it acts once the
// gas is gone. The reference declares the ability and reads it only in its
// lists of what cannot be copied.
static BOOL TryCommander(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);
    int tatsugiri;
    int dondozo;
    int form;
    int i;

    if (!(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) || (BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_MULTI | BATTLE_TYPE_TAG))) {
        return FALSE;
    }
    for (i = 0; i < maxBattlers; i++) {
        tatsugiri = ctx->turnOrder[i];
        dondozo = BattleSystem_GetBattlerIdPartner(battleSystem, tatsugiri);
        switch (ctx->battleMons[tatsugiri].species) {
        case SPECIES_TATSUGIRI:
            form = 1;
            break;
        case SPECIES_TATSUGIRI_DROOPY:
            form = 2;
            break;
        case SPECIES_TATSUGIRI_STRETCHY:
            form = 3;
            break;
        default:
            continue;
        }
        if (!ctx->battleMons[tatsugiri].hp || ctx->moveConditions[tatsugiri].commanding || GetBattlerAbility(ctx, tatsugiri) != ABILITY_COMMANDER
            || (ctx->battleMons[tatsugiri].status2 & STATUS2_TRANSFORM)
            || !ctx->battleMons[dondozo].hp || ctx->battleMons[dondozo].species != SPECIES_DONDOZO || (ctx->battleMons[dondozo].status2 & STATUS2_TRANSFORM)
            || ctx->moveConditions[dondozo].commanderForm
            || BattleSystem_GetParty(battleSystem, tatsugiri) != BattleSystem_GetParty(battleSystem, dondozo)) {
            continue;
        }
        ctx->moveConditions[tatsugiri].commanding = TRUE;
        ctx->moveConditions[dondozo].commanderForm = form;
        ctx->playerActions[tatsugiri].command = CONTROLLER_COMMAND_40;
        ctx->battlerIdTemp = tatsugiri;
        ctx->battlerIdStatChange = dondozo;
        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
        *script = BATTLE_SUBSCRIPT_COMMANDER;
        return TRUE;
    }
    return FALSE;
}

int TryAbilityOnEntry(BattleSystem *battleSystem, BattleContext *ctx) {
    int i;
    int j;
    int script;
    BOOL flag;
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    script = BATTLE_SUBSCRIPT_NONE;
    flag = FALSE;

    do {
        switch (ctx->sendOutState) {
        case 0: // Neutralizing Gas, a strong weather's end, Tera Shift, Shields Down, and then the field weather
            // The gas goes before every other entry ability, as it does in the
            // later games, and says when it has gone as well as when it came:
            // once it has, the abilities it held back find their flags unset
            // and speak further down this list. The reference gives the
            // ability no effect at all, so none of this is its.
            if (ctx->neutralizingGasOut) {
                for (i = 0; i < maxBattlers; i++) {
                    if (BattlerGivesOffGas(ctx, i) == TRUE) {
                        break;
                    }
                }
                if (i == maxBattlers) {
                    ctx->neutralizingGasOut = FALSE;
                    script = BATTLE_SUBSCRIPT_NEUTRALIZING_GAS_END;
                    flag = TRUE;
                    break;
                }
            }
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].neutralizingGasFlag && BattlerGivesOffGas(ctx, battlerId) == TRUE) {
                    ctx->battleMons[battlerId].neutralizingGasFlag = TRUE;
                    ctx->neutralizingGasOut = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_NEUTRALIZING_GAS;
                    flag = TRUE;
                    break;
                }
            }
            if (flag == TRUE) {
                break;
            }
            // A strong weather whose Pokemon is gone ends before anything new
            // speaks, the gas having had its say about who is suppressed.
            if (BattleContext_PrimalWeatherHasEnded(battleSystem, ctx) == TRUE) {
                script = BATTLE_SUBSCRIPT_PRIMAL_WEATHER_END;
                flag = TRUE;
                break;
            }
            // Tera Shift, in the reference's own step beside the gas. The
            // Terastal Form's HP is higher, and so is the Pokemon's, by as
            // much, as Power Construct's Complete Forme has it.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                j = Battler_TeraShiftForm(ctx, battlerId);
                if (j != SPECIES_NONE) {
                    u32 maxHp = ctx->battleMons[battlerId].maxHp;

                    BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerId, j, TRUE);
                    ctx->battleMons[battlerId].maxHp = GetMonData(BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]), MON_DATA_MAX_HP, NULL);
                    ctx->hpCalc = ctx->battleMons[battlerId].maxHp - maxHp;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_TERA_SHIFT;
                    flag = TRUE;
                    break;
                }
            }
            if (flag == TRUE) {
                break;
            }
            // Shields Down, once on the way in: after that its form waits for
            // the end of the turn, and the flag, which a form change clears,
            // is set again after the change.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (ctx->battleMons[battlerId].abilityActivatedFlag || ctx->battleMons[battlerId].ability != ABILITY_SHIELDS_DOWN) {
                    continue;
                }
                j = Battler_ShieldsDownForm(ctx, battlerId);
                if (j != SPECIES_NONE) {
                    BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerId, j, FALSE);
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    flag = TRUE;
                }
                ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;
                if (flag == TRUE) {
                    break;
                }
            }
            if (flag == TRUE) {
                break;
            }
            if (!ctx->weatherCheckFlag) {
                switch (BattleSystem_GetWeather(battleSystem)) {
                case 1:
                case 2:
                case 3:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_RAIN;
                    flag = TRUE;
                    break;
                case 4:
                case 5:
                case 6:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_HAIL;
                    flag = TRUE;
                    break;
                case 7:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_SAND;
                    flag = TRUE;
                    break;
                case 9:
                case 10:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_FOG;
                    flag = TRUE;
                    break;
                case 1001:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_SUN;
                    flag = TRUE;
                    break;
                case 1002:
                    script = BATTLE_SUBSCRIPT_OVERWORLD_TRICK_ROOM;
                    flag = TRUE;
                    break;
                default:
                    break;
                }
                if (flag == TRUE) {
                    ctx->weatherCheckFlag = TRUE;
                }
            }
            ctx->sendOutState++;
            break;
        case 1: // Trace
        {
            int battlerIdTargetR;
            int battlerIdTargetL;

            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                battlerIdTargetR = ov12_0223ABB8(battleSystem, battlerId, 0);
                battlerIdTargetL = ov12_0223ABB8(battleSystem, battlerId, 2);
                ctx->battlerIdLeechSeeded = ov12_022585B8(battleSystem, ctx, battlerIdTargetR, battlerIdTargetL);
                if (!ctx->battleMons[battlerId].traceFlag && ctx->battlerIdLeechSeeded != 0xFF && ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].item != ITEM_GRISEOUS_ORB && !BattlerHasAbilityShield(ctx, battlerId) && ctx->battleMons[ctx->battlerIdLeechSeeded].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_TRACE) {
                    ctx->battleMons[battlerId].traceFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_TRACE;
                    flag = TRUE;
                    break;
                }
            }
        }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 2: // Weather from abilities
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp) {
                    j = GetBattlerAbility(ctx, battlerId);
                    // Under a strong weather the other five weather abilities
                    // say that nothing changes, and change nothing.
                    if ((ctx->fieldCondition & FIELD_CONDITION_PRIMAL_WEATHER)
                        && (j == ABILITY_DRIZZLE || j == ABILITY_SAND_STREAM || j == ABILITY_DROUGHT || j == ABILITY_SNOW_WARNING || j == ABILITY_ORICHALCUM_PULSE)) {
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        script = BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS;
                        flag = TRUE;
                        j = ABILITY_NONE;
                    }
                    // Drizzle, Sand Stream and Drought do nothing while their
                    // weather is up, of whatever kind; their subscripts set it
                    // for five turns.
                    switch (j) {
                    case ABILITY_DRIZZLE:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        if (!(ctx->fieldCondition & FIELD_CONDITION_RAIN_ALL)) {
                            script = BATTLE_SUBSCRIPT_DRIZZLE;
                            flag = TRUE;
                        }
                        break;
                    case ABILITY_SAND_STREAM:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        if (!(ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL)) {
                            script = BATTLE_SUBSCRIPT_SAND_STREAM;
                            flag = TRUE;
                        }
                        break;
                    case ABILITY_DROUGHT:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        if (!(ctx->fieldCondition & FIELD_CONDITION_SUN_ALL)) {
                            script = BATTLE_SUBSCRIPT_DROUGHT;
                            flag = TRUE;
                        }
                        break;
                    // Orichalcum Pulse brings the sun in with it, and speaks
                    // even when the sun is already out, to bask in it; the
                    // reference's switch-in step (SwitchInAbilityCheck.c:773
                    // at d0380a487) asks nothing more than the ability.
                    case ABILITY_ORICHALCUM_PULSE:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        script = BATTLE_SUBSCRIPT_ORICHALCUM_PULSE;
                        flag = TRUE;
                        break;
                    case ABILITY_SNOW_WARNING:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        // The reference asks for hail of either kind here and
                        // leaves the rest to the subscript, which is the one
                        // that knows it is laying snow now.
                        if (!(ctx->fieldCondition & FIELD_CONDITION_HAIL_ALL)) {
                            script = BATTLE_SUBSCRIPT_SNOW_WARNING;
                            flag = TRUE;
                        }
                        break;
                    // A strong weather comes in over any other, the map's
                    // own included, but is not raised again over itself. The
                    // reference refuses it under the map's weather; no game
                    // with the ninth generation's rule for the map's weather
                    // has these three.
                    case ABILITY_DESOLATE_LAND:
                    case ABILITY_PRIMORDIAL_SEA:
                    case ABILITY_DELTA_STREAM:
                        ctx->battleMons[battlerId].sendOutFlag = TRUE;
                        if (!(ctx->fieldCondition & PrimalWeatherOf(j))) {
                            ctx->fieldCondition = (ctx->fieldCondition & ~FIELD_CONDITION_WEATHER) | PrimalWeatherOf(j);
                            script = BATTLE_SUBSCRIPT_PRIMAL_WEATHER_START;
                            flag = TRUE;
                        }
                        break;
                    }
                }
                if (flag == TRUE) {
                    ctx->battlerIdTemp = battlerId;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 3: // Intimidate
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].intimidateFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_INTIMIDATE) {
                    ctx->battleMons[battlerId].intimidateFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_INTIMIDATE;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 4: // Download
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].downloadFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_DOWNLOAD) {
                    int battlerIdCheck;
                    int def = 0;
                    int spdef = 0;

                    for (battlerIdCheck = 0; battlerIdCheck < maxBattlers; battlerIdCheck++) {
                        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, battlerIdCheck) && !(ctx->battleMons[battlerIdCheck].status2 & STATUS2_SUBSTITUTE) && ctx->battleMons[battlerIdCheck].hp) {
                            def += ctx->battleMons[battlerIdCheck].def * sStatChangeTable[ctx->battleMons[battlerIdCheck].statChanges[2]][0] / sStatChangeTable[ctx->battleMons[battlerIdCheck].statChanges[2]][1];
                            spdef += ctx->battleMons[battlerIdCheck].spDef * sStatChangeTable[ctx->battleMons[battlerIdCheck].statChanges[5]][0] / sStatChangeTable[ctx->battleMons[battlerIdCheck].statChanges[5]][1];
                        }
                    }
                    ctx->battleMons[battlerId].downloadFlag = TRUE;
                    if (def + spdef != 0) {
                        if (def >= spdef) {
                            ctx->statChangeParam = 0x12;
                        } else {
                            ctx->statChangeParam = 0xF;
                        }
                        ctx->statChangeType = 3;
                        ctx->battlerIdStatChange = battlerId;
                        script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 5: // Anticipation
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].anticipationFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_ANTICIPATION) {
                    ctx->battleMons[battlerId].anticipationFlag = TRUE;
                    int battlerIdCheck;
                    int index;
                    u16 moveNo;
                    u32 moveStatus;
                    u32 fieldCondition;
                    for (battlerIdCheck = 0; battlerIdCheck < maxBattlers; battlerIdCheck++) {
                        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, battlerIdCheck) && ctx->battleMons[battlerIdCheck].hp) {
                            for (index = 0; index < MAX_MON_MOVES; index++) {
                                moveNo = ctx->battleMons[battlerIdCheck].moves[index];
                                if (moveNo) {
                                    moveStatus = 0;
                                    // The later games still shudder at a move
                                    // super effective on a Flying type in the
                                    // strong winds, which shelter it from the
                                    // hit and not from the chart; the
                                    // reference asks the chart with the winds.
                                    fieldCondition = ctx->fieldCondition;
                                    ctx->fieldCondition &= ~FIELD_CONDITION_STRONG_WINDS;
                                    ctx->damage = ov12_02251D28(battleSystem, ctx, moveNo, 0, battlerIdCheck, battlerId, ctx->damage, &moveStatus);
                                    ctx->fieldCondition = fieldCondition;
                                    if (!(moveStatus & MOVE_STATUS_NO_EFFECT) && !ov12_0225865C(ctx, moveNo) && ((moveStatus & MOVE_STATUS_SUPER_EFFECTIVE) || (BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_ONE_HIT_KO && ctx->battleMons[battlerId].level <= ctx->battleMons[battlerIdCheck].level))) {
                                        flag = TRUE;
                                        break;
                                    }
                                }
                            }
                            if (flag == TRUE) {
                                break;
                            }
                        }
                    }
                    if (flag == TRUE) {
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_ANTICIPATION;
                    }
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 6: // forewarn
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].forewarnFlag && ctx->battleMons[battlerId].hp && (GetBattlerAbility(ctx, battlerId) == ABILITY_FOREWARN)) {
                    ctx->battleMons[battlerId].forewarnFlag = TRUE;
                    int battlerIdCheck;
                    int index;
                    u16 moveNo;
                    u32 power;
                    int hp;
                    u32 powerTemp;

                    powerTemp = 0;
                    hp = 0;

                    for (battlerIdCheck = 0; battlerIdCheck < maxBattlers; battlerIdCheck++) {
                        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, battlerIdCheck) && ctx->battleMons[battlerIdCheck].hp) {
                            hp += ctx->battleMons[battlerIdCheck].hp;
                            for (index = 0; index < MAX_MON_MOVES; index++) {
                                moveNo = ctx->battleMons[battlerIdCheck].moves[index];
                                power = BattleMoveTbl(ctx, moveNo)->power;
                                switch (power) {
                                case 1:
                                    switch (BattleMoveTbl(ctx, moveNo)->effect) {
                                    case MOVE_EFFECT_ONE_HIT_KO:
                                        if (powerTemp < 150 || (powerTemp == 150 && (BattleSystem_Random(battleSystem) & 1))) {
                                            powerTemp = 150;
                                            ctx->moveTemp = moveNo;
                                        }
                                        break;
                                    case MOVE_EFFECT_COUNTER:
                                    case MOVE_EFFECT_MIRROR_COAT:
                                    case MOVE_EFFECT_METAL_BURST:
                                        if (powerTemp < 120 || ((powerTemp == 120) && (BattleSystem_Random(battleSystem) & 1))) {
                                            powerTemp = 120;
                                            ctx->moveTemp = moveNo;
                                        }
                                        break;
                                    default:
                                        if (powerTemp < 80 || ((powerTemp == 80) && (BattleSystem_Random(battleSystem) & 1))) {
                                            powerTemp = 80;
                                            ctx->moveTemp = moveNo;
                                        }
                                        break;
                                    }
                                    break;
                                default:
                                    if (powerTemp < power || ((powerTemp == power) && (BattleSystem_Random(battleSystem) & 1))) {
                                        powerTemp = power;
                                        ctx->moveTemp = moveNo;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    if (powerTemp) {
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_FOREWARN;
                        flag = TRUE;
                    } else if (hp) {
                        j = Battler_GetRandomOpposingBattlerId(battleSystem, ctx, battlerId);
                        index = GetBattlerLearnedMoveCount(battleSystem, ctx, j);
                        ctx->moveTemp = ctx->battleMons[j].moves[BattleSystem_Random(battleSystem) % index];
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_FOREWARN;
                        flag = TRUE;
                    }
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 7: // Frisk
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].friskFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_FRISK) {
                    ctx->battleMons[battlerId].friskFlag = TRUE;
                    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
                        int battlerIdTargets[2];

                        battlerIdTargets[0] = ov12_0223ABB8(battleSystem, battlerId, 0);
                        battlerIdTargets[1] = ov12_0223ABB8(battleSystem, battlerId, 2);

                        if (ctx->battleMons[battlerIdTargets[0]].hp && ctx->battleMons[battlerIdTargets[0]].item && ctx->battleMons[battlerIdTargets[1]].hp && ctx->battleMons[battlerIdTargets[1]].item) {
                            ctx->itemTemp = ctx->battleMons[battlerIdTargets[BattleSystem_Random(battleSystem) & 1]].item;
                            flag = TRUE;
                        } else if (ctx->battleMons[battlerIdTargets[0]].hp && ctx->battleMons[battlerIdTargets[0]].item) {
                            ctx->itemTemp = ctx->battleMons[battlerIdTargets[0]].item;
                            flag = TRUE;
                        } else if (ctx->battleMons[battlerIdTargets[1]].hp && ctx->battleMons[battlerIdTargets[1]].item) {
                            ctx->itemTemp = ctx->battleMons[battlerIdTargets[1]].item;
                            flag = TRUE;
                        }
                    } else if (ctx->battleMons[battlerId ^ 1].hp && ctx->battleMons[battlerId ^ 1].item) {
                        ctx->itemTemp = ctx->battleMons[battlerId ^ 1].item;
                        flag = TRUE;
                    }
                }
                if (flag == TRUE) {
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_FRISK;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 8: // Slow Start
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].slowStartFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SLOW_START && ctx->totalTurns <= ctx->battleMons[battlerId].unk88.slowStartTurns) {
                    ctx->battleMons[battlerId].slowStartFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_SLOW_START;
                    flag = TRUE;
                    break;
                }
                if (!ctx->battleMons[battlerId].slowStartEnded && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SLOW_START && (ctx->totalTurns - ctx->battleMons[battlerId].unk88.slowStartTurns) == 5) {
                    ctx->battleMons[battlerId].slowStartEnded = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_SLOW_START_END;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 9: // Mold Breaker, Teravolt and Turboblaze
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].moldBreakerFlag && ctx->battleMons[battlerId].hp && (GetBattlerAbility(ctx, battlerId) == ABILITY_MOLD_BREAKER || GetBattlerAbility(ctx, battlerId) == ABILITY_TERAVOLT || GetBattlerAbility(ctx, battlerId) == ABILITY_TURBOBLAZE)) {
                    ctx->battleMons[battlerId].moldBreakerFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    // "{0} has {1}!" names whichever of the three it is.
                    script = BATTLE_SUBSCRIPT_MOLD_BREAKER;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 10: // Pressure
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].pressureFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_PRESSURE) {
                    ctx->battleMons[battlerId].pressureFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_PRESSURE;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 11: // Air Lock and Cloud Nine
            if (Battler_CheckWeatherFormChange(battleSystem, ctx, &script) == TRUE) {
                flag = TRUE;
            } else {
                ctx->sendOutState++;
            }
            break;
        case BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE: // Amulet coin
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT) == HOLD_EFFECT_MONEY_UP) {
                    ctx->prizeMoneyValue = 2;
                }
            }
            ctx->sendOutState++;
            break;
        case 13: // Status healed on entry
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (CheckStatusHealAbility(battleSystem, ctx, battlerId, 1) == TRUE) {
                    script = BATTLE_SUBSCRIPT_ABILITY_FORBIDS_STATUS;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 14: // Held item activated on entry
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (CheckUseHeldItem(battleSystem, ctx, battlerId, (u32 *)&script) == TRUE) {
                    ctx->battlerIdTemp = battlerId;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 15: // Supersweet Syrup
            // Once per Pokemon per battle, not once per send-out, so it is the
            // party slot that remembers, as for Intrepid Sword below.
            for (i = 0; i < maxBattlers; i++) {
                u8 *syrupDone;

                battlerId = ctx->turnOrder[i];
                syrupDone = OnceOnlyEntryAbilityDone(battleSystem, ctx, battlerId);
                if (!*syrupDone && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SUPERSWEET_SYRUP) {
                    *syrupDone = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_SUPERSWEET_SYRUP;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 16: // Unnerve, and the two halves of As One that carry it
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].unnerveFlag && ctx->battleMons[battlerId].hp && (GetBattlerAbility(ctx, battlerId) == ABILITY_AS_ONE_GLASTRIER || GetBattlerAbility(ctx, battlerId) == ABILITY_AS_ONE_SPECTRIER || GetBattlerAbility(ctx, battlerId) == ABILITY_UNNERVE)) {
                    ctx->battleMons[battlerId].unnerveFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    // An As One announces that it has two Abilities and then
                    // speaks as the one that has something to say here, so
                    // the name the message prints is Unnerve either way.
                    ctx->abilityTemp = ABILITY_UNNERVE;
                    script = BATTLE_SUBSCRIPT_UNNERVE;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 17: // Screen Cleaner
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].screenCleanerFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SCREEN_CLEANER) {
                    u32 screens = SIDE_CONDITION_REFLECT | SIDE_CONDITION_LIGHT_SCREEN | SIDE_CONDITION_AURORA_VEIL;

                    // Marked whether or not a screen was up, so that a
                    // Pokemon walking into a bare field stops looking.
                    ctx->battleMons[battlerId].screenCleanerFlag = TRUE;
                    if ((ctx->fieldSideConditionFlags[0] | ctx->fieldSideConditionFlags[1]) & screens) {
                        // Both sides lose them, the holder's own included.
                        // The counters go with the flags: the end-of-turn
                        // pass decrements as soon as it sees a flag, so one
                        // left set over a zero counter would wrap it.
                        for (j = 0; j < 2; j++) {
                            ctx->fieldSideConditionFlags[j] &= ~screens;
                            ctx->fieldSideConditionData[j].reflectTurns = 0;
                            ctx->fieldSideConditionData[j].lightScreenTurns = 0;
                            ctx->fieldSideConditionData[j].auroraVeilTurns = 0;
                        }
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_SCREEN_CLEANER;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 18: // Imposter
            for (i = 0; i < maxBattlers; i++) {
                int battlerIdCopied;

                battlerId = ctx->turnOrder[i];
                // The one standing visibly opposite, which in a double
                // battle is the far slot rather than the near one.
                battlerIdCopied = (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) ? (battlerId ^ 3) : (battlerId ^ 1);
                // A wild Pokemon only copies if it is a Ditto or a Mew; a
                // trainer's may be anything. The reference also refuses a
                // target hidden behind an Illusion, and this game has none.
                if (!ctx->battleMons[battlerId].imposterFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_IMPOSTER && ctx->battleMons[battlerIdCopied].hp && ctx->battleMons[battlerIdCopied].ability != ABILITY_IMPOSTER && !ctx->battleMons[battlerIdCopied].illusionMon && !(ctx->battleMons[battlerIdCopied].status2 & (STATUS2_SUBSTITUTE | STATUS2_TRANSFORM)) && ((BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TRAINER) || ctx->battleMons[battlerId].species == SPECIES_DITTO || ctx->battleMons[battlerId].species == SPECIES_MEW)) {
                    ctx->battleMons[battlerId].imposterFlag = TRUE;
                    // Transform copies from the attacker to the target, and
                    // this is not a move: what those two were is put aside
                    // here and given back at the end of the subscript,
                    // because the turn this runs in the middle of still
                    // wants them. The animation is asked for by name rather
                    // than through moveNoCur for the same reason.
                    ctx->battlerIdAttackerTemp = ctx->battlerIdAttacker;
                    ctx->battlerIdTargetTemp = ctx->battlerIdTarget;
                    ctx->battlerIdAttacker = battlerId;
                    ctx->battlerIdTarget = battlerIdCopied;
                    ctx->moveTemp = MOVE_TRANSFORM;
                    script = BATTLE_SUBSCRIPT_IMPOSTER;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 19: // Intrepid Sword, Dauntless Shield and Zero to Hero
            for (i = 0; i < maxBattlers; i++) {
                u8 *done;

                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].hp) {
                    continue;
                }
                // Once per Pokemon per battle, not once per send-out: the
                // slot it was drawn from is what remembers.
                done = OnceOnlyEntryAbilityDone(battleSystem, ctx, battlerId);
                if (*done) {
                    continue;
                }
                // A Palafin back in its Hero Form says so, once
                // (SwitchInAbilityCheck.c:965, zeroToHeroFlag).
                if (ctx->battleMons[battlerId].species == SPECIES_PALAFIN_HERO && ctx->battleMons[battlerId].ability == ABILITY_ZERO_TO_HERO
                    && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
                    *done = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_ZERO_TO_HERO;
                    flag = TRUE;
                    break;
                }
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_INTREPID_SWORD) {
                    ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE;
                } else if (GetBattlerAbility(ctx, battlerId) == ABILITY_DAUNTLESS_SHIELD) {
                    ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_DEFENSE_UP_1_STAGE;
                } else {
                    continue;
                }
                *done = TRUE;
                ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
                ctx->battlerIdStatChange = battlerId;
                script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
                flag = TRUE;
                break;
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 20: // Hospitality
            if (BattleSystem_GetBattleType(battleSystem) & (BATTLE_TYPE_DOUBLES | BATTLE_TYPE_MULTI)) {
                for (i = 0; i < maxBattlers; i++) {
                    battlerId = ctx->turnOrder[i];
                    j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
                    if (!ctx->battleMons[battlerId].hospitalityFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_HOSPITALITY && ctx->battleMons[j].hp && (u32)ctx->battleMons[j].hp != ctx->battleMons[j].maxHp) {
                        ctx->battleMons[battlerId].hospitalityFlag = TRUE;
                        ctx->hpCalc = DamageDivide(ctx->battleMons[j].maxHp, 4);
                        ctx->battlerIdTemp = battlerId;
                        // The one being poured for, which the subscript
                        // moves into the temporary slot before it heals.
                        ctx->battlerIdStatChange = j;
                        script = BATTLE_SUBSCRIPT_HOSPITALITY;
                        flag = TRUE;
                        break;
                    }
                }
                if (i == maxBattlers) {
                    ctx->sendOutState++;
                }
            } else {
                ctx->sendOutState++;
            }
            break;
        case 21: // Wind Power, when Tailwind is already blowing
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].abilityActivatedFlag && ctx->battleMons[battlerId].hp && (ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] & SIDE_CONDITION_TAILWIND) && GetBattlerAbility(ctx, battlerId) == ABILITY_WIND_POWER) {
                    // The flag is what stops it charging again every send-out
                    // while the same Tailwind blows; the field condition
                    // running out clears it.
                    ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_CHARGE_FROM_HIT;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 22: // The four Surges, and Hadron Engine, which is a fifth
            for (i = 0; i < maxBattlers; i++) {
                int terrainType = TERRAIN_NONE;

                battlerId = ctx->turnOrder[i];
                if (ctx->battleMons[battlerId].abilityActivatedFlag || !ctx->battleMons[battlerId].hp) {
                    continue;
                }
                switch (GetBattlerAbility(ctx, battlerId)) {
                case ABILITY_GRASSY_SURGE:
                    terrainType = GRASSY_TERRAIN;
                    break;
                case ABILITY_MISTY_SURGE:
                    terrainType = MISTY_TERRAIN;
                    break;
                case ABILITY_ELECTRIC_SURGE:
                case ABILITY_HADRON_ENGINE:
                    terrainType = ELECTRIC_TERRAIN;
                    break;
                case ABILITY_PSYCHIC_SURGE:
                    terrainType = PSYCHIC_TERRAIN;
                    break;
                default:
                    continue;
                }
                ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;
                // A Surge lays its terrain only if it was not down already
                // ("se non lo era in precedenza", Pokemon Central, Elettrogenesi,
                // Erbogenesi, Nebbiogenesi, Psicogenesi): walking onto its own
                // terrain, or coming in beside a Surge of the same kind, it
                // says nothing and the turns are not renewed. Two different
                // Surges both act, the slower last. The reference announces
                // the terrain again, which is not copied. Hadron Engine has a
                // line of its own for this case.
                if (ctx->terrainOverlayType == terrainType && GetBattlerAbility(ctx, battlerId) != ABILITY_HADRON_ENGINE) {
                    continue;
                }
                ctx->battlerIdTemp = battlerId;
                // What tells the subscript to put an Ability popup up before
                // it announces the ground.
                ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
                // Hadron Engine is the only one of the five that says so when
                // the ground it wants is already there, because what it
                // announces is its engine rather than the ground.
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_HADRON_ENGINE && ctx->terrainOverlayType == ELECTRIC_TERRAIN) {
                    script = BATTLE_SUBSCRIPT_HADRON_ENGINE_NO_TERRAIN_SETUP;
                } else {
                    BattleContext_UpdateTerrainOverlay(ctx, battlerId, terrainType);
                    script = BATTLE_SUBSCRIPT_CREATE_TERRAIN_OVERLAY;
                }
                flag = TRUE;
                break;
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 23: // Protosynthesis and Quark Drive
            // Last, because what switches them on is the sun or the ground,
            // and both of those can have been laid down by something further
            // up this same list.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                j = BattleContext_ActivateParadoxAbility(battleSystem, ctx, battlerId);
                if (j != BATTLE_SUBSCRIPT_NONE) {
                    script = j;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 24: // Air Balloon
            // The flag goes on whether or not the sentence is printed, so a
            // Pokemon that walked in already pinned to the ground -- Gravity,
            // an Iron Ball -- never announces the balloon afterwards. That is
            // the reference's reading of the mechanic, and its comment cites
            // where it comes from.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (ctx->battleMons[battlerId].airBalloonFlag || !ctx->battleMons[battlerId].hp) {
                    continue;
                }
                ctx->battleMons[battlerId].airBalloonFlag = TRUE;
                if (GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT && BattlerIsGrounded(ctx, battlerId) == FALSE) {
                    ctx->battlerIdTemp = battlerId;
                    ctx->itemTemp = ctx->battleMons[battlerId].item;
                    script = BATTLE_SUBSCRIPT_AIR_BALLOON_FLOAT;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 25: // Terrain Seeds
            // After the Surges, because the ground one of them lays is ground
            // a Seed answers to. The Seed is spent whether or not the stat had
            // room, which is the reference's script doing the raise and the
            // removal in one run either way.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                j = ctx->battleMons[battlerId].hp ? TerrainSeedStat(ctx, battlerId) : STAT_HP;
                if (j != STAT_HP) {
                    ctx->msgTemp = j;
                    ctx->battlerIdTemp = battlerId;
                    ctx->itemTemp = ctx->battleMons[battlerId].item;
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 26: // Room Service
            // A Pokemon that walks into a Trick Room already up gets the same
            // Speed drop as one that was standing in it when the dimensions
            // twisted. The script walks the whole field rather than the one
            // battler, so the one run here spends every Room Service there is
            // to spend and the next pass through this state finds none -- the
            // reference runs the same script from its own switch-in check for
            // the same reason.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (ctx->battleMons[battlerId].hp && (ctx->fieldCondition & FIELD_CONDITION_TRICK_ROOM) && GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_DROP_SPEED_IN_TRICK_ROOM) {
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_ROOM_SERVICE;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 27: // Embody Aspect
            // Each time it comes in, once: the flag is the battler's, and a
            // Pokemon brought back in is a new battler. Held back by the gas,
            // the ability finds the flag unset and speaks once the gas has
            // gone, but not again for having been held back after it spoke.
            // A Pokemon that Transformed into the mask has the ability and
            // not the memory, and at +6 there is nothing to raise.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                j = EmbodyAspectStat(GetBattlerAbility(ctx, battlerId));
                if (j == STAT_HP || ctx->battleMons[battlerId].abilityActivatedFlag || !ctx->battleMons[battlerId].hp
                    || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
                    continue;
                }
                ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;
                if (ctx->battleMons[battlerId].statChanges[j] >= 12) {
                    continue;
                }
                ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + j - STAT_ATK;
                ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
                ctx->battlerIdStatChange = battlerId;
                script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;
                flag = TRUE;
                break;
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 28: // Teraform Zero
            // Pokemon Central (Zeroformazione): the first time in a battle
            // that Terapagos takes its Stellar Form, the weather and the
            // ground are cleared. That form is Terastallizing, which this game
            // has not got; the Stellar Form is a species here, so it is the
            // first time the Pokemon comes in as one, remembered by party slot
            // for the rest of the battle. The moment is spent even if the gas
            // holds the ability back then, and not for a Pokemon Transformed
            // into one. hg-engine (d0380a487) gives the ability nothing to do.
            for (i = 0; i < maxBattlers; i++) {
                u8 *done;

                battlerId = ctx->turnOrder[i];
                done = OnceOnlyEntryAbilityDone(battleSystem, ctx, battlerId);
                if (*done || !ctx->battleMons[battlerId].hp || ctx->battleMons[battlerId].ability != ABILITY_TERAFORM_ZERO
                    || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
                    continue;
                }
                *done = TRUE;
                if (GetBattlerAbility(ctx, battlerId) == ABILITY_TERAFORM_ZERO
                    && ((ctx->fieldCondition & FIELD_CONDITION_WEATHER) || ctx->terrainOverlayType != TERRAIN_NONE)) {
                    ctx->battlerIdTemp = battlerId;
                    script = BATTLE_SUBSCRIPT_TERAFORM_ZERO;
                    flag = TRUE;
                    break;
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 29: // Supreme Overlord
            // The fallen are counted once, on the way in: every time a Pokemon
            // of the holder's own party has fainted since the battle began,
            // five at most (Pokemon Central, Generale Supremo). One revived
            // since still counts; one that falls while the holder is out
            // counts from its next entry. The send-out flag is the weather
            // abilities' own, which a Pokemon with this one never needs.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_SUPREME_OVERLORD) {
                    ctx->battleMons[battlerId].sendOutFlag = TRUE;
                    j = BattlerPartyFaintCount(battleSystem, ctx, battlerId);
                    ctx->supremeOverlordFallen[battlerId] = j < 5 ? j : 5;
                    if (ctx->supremeOverlordFallen[battlerId]) {
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_SUPREME_OVERLORD;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 30: // Curious Medicine
            // On the way in, the holder's ally loses every stat change it has,
            // raised or lowered, behind a substitute or a Clear Body all the
            // same (Pokemon Central, Stranofarmaco). The line is printed only
            // when there was something to clear. The send-out flag is the
            // weather abilities' again.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_CURIOUS_MEDICINE) {
                    ctx->battleMons[battlerId].sendOutFlag = TRUE;
                    j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
                    if (j != battlerId && ctx->battleMons[j].hp && BattlerClearStatChanges(ctx, j) == TRUE) {
                        ctx->battlerIdTemp = j;
                        script = BATTLE_SUBSCRIPT_CURIOUS_MEDICINE;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 31: // Costar
            // On the way in, the holder takes its ally's stat stages and what
            // raises its critical-hit odds for its own, over whatever it had
            // (Pokemon Central, Coprotagonismo). With no ally standing there
            // is nothing to copy and nothing is said.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].sendOutFlag && ctx->battleMons[battlerId].hp && GetBattlerAbility(ctx, battlerId) == ABILITY_COSTAR) {
                    ctx->battleMons[battlerId].sendOutFlag = TRUE;
                    j = BattleSystem_GetBattlerIdPartner(battleSystem, battlerId);
                    if (j != battlerId && ctx->battleMons[j].hp) {
                        CostarCopiesAlly(ctx, battlerId, j);
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_COSTAR;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 32: // Mimicry
            // The holder takes the type of the terrain under it: Electric,
            // Grass, Fairy or Psychic for the four, a third type from Forest's
            // Curse or Trick-or-Treat kept (Pokemon Central, Mimetismo). It
            // answers when it comes in and whenever the terrain has changed
            // since it last did, which is after the move or entry that changed
            // it. The reference answers whenever the types differ, which also
            // undid a Soak at once; the page says Soak prevails. Going back to
            // its own types when the terrain ends is done as the terrain goes.
            for (i = 0; i < maxBattlers; i++) {
                battlerId = ctx->turnOrder[i];
                if (!ctx->battleMons[battlerId].hp || GetBattlerAbility(ctx, battlerId) != ABILITY_MIMICRY || ctx->mimicryTerrain[battlerId] == ctx->terrainOverlayType) {
                    continue;
                }
                if (ctx->terrainOverlayType == TERRAIN_NONE) {
                    Battler_MimicryRestoreTypes(battleSystem, ctx, battlerId);
                    continue;
                }
                ctx->mimicryTerrain[battlerId] = ctx->terrainOverlayType;
                ctx->msgTemp = TerrainMimicryType(ctx->terrainOverlayType);
                ctx->battleMons[battlerId].type1 = ctx->msgTemp;
                ctx->battleMons[battlerId].type2 = ctx->msgTemp;
                ctx->battlerIdTemp = battlerId;
                script = BATTLE_SUBSCRIPT_MIMICRY;
                flag = TRUE;
                break;
            }
            if (i == maxBattlers) {
                ctx->sendOutState++;
            }
            break;
        case 33: // Opportunist
            flag = TryOpportunistCopy(battleSystem, ctx, &script);
            if (flag == FALSE) {
                ctx->sendOutState++;
            }
            break;
        case 34: // Symbiosis
            flag = TrySymbiosisHandOver(battleSystem, ctx, &script);
            if (flag == FALSE) {
                ctx->sendOutState++;
            }
            break;
        case 35: // Ball Fetch
            // In a wild battle a Pokemon of the player's with Ball Fetch and
            // nothing in its hands picks up the first ball that failed to
            // catch, once in the battle (Pokemon Central, Raccattapalle). The
            // reference declares the ability and nothing reads it; its note in
            // ServerBeforeAct means to look after the ball was used, which is
            // where the throw's subscript now asks.
            if (ctx->ballFetchBall != ITEM_NONE) {
                for (i = 0; i < maxBattlers; i++) {
                    battlerId = ctx->turnOrder[i];
                    if (BattleSystem_GetFieldSide(battleSystem, battlerId) == 0 && ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].item == ITEM_NONE && GetBattlerAbility(ctx, battlerId) == ABILITY_BALL_FETCH) {
                        ctx->battleMons[battlerId].item = ctx->ballFetchBall;
                        CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
                        ctx->itemTemp = ctx->ballFetchBall;
                        ctx->ballFetchBall = ITEM_NONE;
                        ctx->ballFetched = TRUE;
                        ctx->battlerIdTemp = battlerId;
                        script = BATTLE_SUBSCRIPT_BALL_FETCH;
                        flag = TRUE;
                        break;
                    }
                }
            }
            if (flag == FALSE) {
                ctx->sendOutState++;
            }
            break;
        case 36: // Commander
            flag = TryCommander(battleSystem, ctx, &script);
            if (flag == FALSE) {
                ctx->sendOutState++;
            }
            break;
        case 37: // end
            ctx->sendOutState = 0;
            flag = 2;
            break;
        }
    } while (!flag);

    return script;
}

int Battler_GetRandomOpposingBattlerId(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    u32 battleType;
    int battlerIdTarget;
    int battlerIdTargets[2];
    int i;

    battleType = BattleSystem_GetBattleType(battleSystem);

    if (battleType & BATTLE_TYPE_DOUBLES) {
        battlerIdTargets[0] = ov12_0223ABB8(battleSystem, battlerId, 0);
        battlerIdTargets[1] = ov12_0223ABB8(battleSystem, battlerId, 2);
        i = BattleSystem_Random(battleSystem) & 1;
        battlerIdTarget = battlerIdTargets[i];
        if (!ctx->battleMons[battlerIdTarget].hp) {
            battlerIdTarget = battlerIdTargets[i ^ 1];
        }
    } else {
        battlerIdTarget = battlerId ^ 1;
    }

    return battlerIdTarget;
}

// Beast Boost raises whichever stat is biggest before any stage change has
// touched it, ties going to the earliest. The order is the one the stat
// change scripts are numbered in, so the answer is the offset to add to
// MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE.
static int BattlerGreatestStat(BattleContext *ctx, int battlerId) {
    u16 stats[] = {
        ctx->battleMons[battlerId].atk,
        ctx->battleMons[battlerId].def,
        ctx->battleMons[battlerId].speed,
        ctx->battleMons[battlerId].spAtk,
        ctx->battleMons[battlerId].spDef,
    };
    int max = 0;
    int i;

    for (i = 1; i < (int)NELEMS(stats); i++) {
        if (stats[i] > stats[max]) {
            max = i;
        }
    }

    return max;
}

// Pickpocket and Magician both move one held item to a pair of empty hands.
// Whether the item itself will go is the question Thief asks, written out
// here because BtlCmd_TryStealItem asks it of the attacker and the target
// rather than of a taker and a loser.
static BOOL CanAbilityTakeHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdTaker, int battlerIdLoser) {
    if (ctx->battleMons[battlerIdTaker].item != ITEM_NONE) {
        return FALSE;
    }
    return CanStealHeldItem(battleSystem, ctx, battlerIdTaker, battlerIdLoser);
}

// battlerIdLoser's item is being taken, by Magician, Pickpocket, Thief or
// Covet. Taken from one of the player's own Pokemon, it is theirs again when
// the battle is over, a Berry too, and even one the taker has used up (Pokemon
// Central: Furto, items stolen from any trainer come back at the battle's end
// from the fifth generation; Prestigiatore, even consumed from the eighth).
// GiveBackHeldItems reads the mark; a Berry not marked that its holder no
// longer has was eaten, and stays so.
//
// Taken from a wild Pokemon, it goes to the bag when the battle is over,
// unless that Pokemon is caught: then it keeps its item and the bag gets no
// copy (Pokemon Central, Arraffalesto and Furto, from the ninth generation).
void NoteHeldItemTaken(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdLoser) {
    if (BattleSystem_GetParty(battleSystem, battlerIdLoser) == BattleSystem_GetParty(battleSystem, BATTLER_PLAYER)) {
        ctx->heldItemsTaken |= MaskOfFlagNo(ctx->selectedMonIndex[battlerIdLoser]);
    } else if (Battler_IsWild(battleSystem, battlerIdLoser)) {
        ctx->itemsTakenFromWild[battlerIdLoser >> 1] = ctx->battleMons[battlerIdLoser].item;
    }
}

// Disguise and Ice Face (battle_calc_damage.c:254): a Mimikyu in its disguise
// takes nothing from a move, and an Eiscue with its Ice Face nothing from a
// physical one -- physical as this attacker uses it, so a Photon Geyser or a
// Shell Side Arm gone physical too (BattleMoveCategory), where the reference
// reads the move table; Mold Breaker goes through. The form the face breaks into, or
// SPECIES_NONE if it takes nothing. A Mimikyu of the Large form busts into
// the Large busted form: hg-engine lets that one take the hit and never
// busts it. A transformed battler has no face of its own.
u16 Battler_BrokenFaceForm(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, u16 move) {
    if (ctx->battleMons[battlerIdTarget].status2 & STATUS2_TRANSFORM) {
        return SPECIES_NONE;
    }
    switch (ctx->battleMons[battlerIdTarget].species) {
    case SPECIES_MIMIKYU:
        return CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_DISGUISE) == TRUE ? SPECIES_MIMIKYU_BUSTED : SPECIES_NONE;
    case SPECIES_MIMIKYU_LARGE:
        return CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_DISGUISE) == TRUE ? SPECIES_MIMIKYU_BUSTED_LARGE : SPECIES_NONE;
    case SPECIES_EISCUE:
        if (BattleMoveCategory(ctx, move, battlerIdAttacker) == CATEGORY_PHYSICAL && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_ICE_FACE) == TRUE) {
            return SPECIES_EISCUE_NOICE_FACE;
        }
        break;
    }
    return SPECIES_NONE;
}

// Battle Bond (Pokemon Central, Morfosintonia), as the ninth generation has it:
// the first time in a battle that a Greninja in its Battle Bond form knocks a
// Pokemon out with a move, ally or not, its Attack, Sp. Atk and Speed rise a
// stage each, unless all three are at +6 already, in which case the chance is
// kept for later. It no longer turns the Greninja into Ash-Greninja. That is
// hg-engine's too (ServerDoPostMoveEffects.c:1713, BATTLE_BOND_GENERATION at
// GEN_LATEST), keyed on the Battle Bond form and remembered per party slot; a
// Pokemon that has the ability through Transform is left out, as the later
// games leave it.
static BOOL BattlerBattleBondBoosts(BattleContext *ctx, int battlerId, BOOL spent) {
    return !spent && GetBattlerAbility(ctx, battlerId) == ABILITY_BATTLE_BOND
        && ctx->battleMons[battlerId].species == SPECIES_GRENINJA_BATTLE_BOND
        && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)
        && (ctx->battleMons[battlerId].statChanges[STAT_ATK] < 12 || ctx->battleMons[battlerId].statChanges[STAT_SPATK] < 12
            || ctx->battleMons[battlerId].statChanges[STAT_SPEED] < 12);
}

// Toxic Chain: three in ten that any move of the holder's that deals damage,
// contact or not, leaves the target badly poisoned (Pokemon Central, Catena
// Tossica). The reference declares it and nothing reads it. It is not a
// move's own effect, but it is stopped by what stops one: a Covert Cloak
// here, and in the subscript Shield Dust, a substitute, Safeguard and
// whatever cannot be poisoned, all without a word, as a move's chance of
// poison is. The later games put the ability's popup above the line that
// says so, and this game has none. The roll is last, so it is only drawn for
// a hit that could poison.
static BOOL ToxicChainTakesHold(BattleSystem *battleSystem, BattleContext *ctx) {
    return GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) != HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS
        && GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_TOXIC_CHAIN
        && ctx->battleMons[ctx->battlerIdTarget].hp
        && !ctx->battleMons[ctx->battlerIdTarget].status
        && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)
        && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN)
        && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
        && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)
        && BattleSystem_Random(battleSystem) % 10 < 3;
}

// Whether the Pokemon in battlerId's slot came in after the hit on record
// there: hitCount is zeroed when a Pokemon is loaded into a slot and counts
// the hits it takes in it, so damage on record and no hit means Dragon Tail
// or Circle Throw dragged it in once the hit was answered, or a Red Card or
// an Eject Button brought it. The hit was its predecessor's, and so is all
// it would set off.
BOOL Battler_CameInAfterTheHit(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].hitCount == 0
        && (ctx->selfTurnData[battlerId].physicalDamage || ctx->selfTurnData[battlerId].specialDamage);
}

// Whether the Pokemon Dragon Tail or Circle Throw hit is dragged out once the
// move is over (ov12_02250490 marked it): not held by Ingrain -- Suction Cups
// and Guard Dog are a Pokemon's only ability, and none of those asking has
// them -- and with somewhere to go, a Pokemon to come in for it or, for a
// wild one, a user of its level or above (subscript 91's TryWhirlwind). Its
// Pickpocket, Color Change and Anger Shell do not answer the hit then
// (Pokemon Central, Codadrago); Emergency Exit and Wimp Out go with it
// (InitSwitchWork's clearing of the slot).
//
// Nor if the user will not stand to drag it (Codadrago: not when the user
// faints to a Rocky Helmet, Rough Skin, Iron Barbs or Gulp Missile). The
// three abilities asking this are the Pokemon's own, so the only thing left
// to fell the user is its held item, which answers the hit after them
// (CheckItemEffectOnHit): a Rocky Helmet on a contact move or a Jaboca Berry
// on a physical one, a share of the user's maximum HP that Magic Guard
// spares. What they would take is what they take there.
static BOOL Battler_WillBeDraggedOut(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int attacker = ctx->battlerIdAttacker;
    int item = GetBattlerHeldItemEffect(ctx, battlerId);

    if (!ctx->selfTurnData[battlerId].dragPending || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
        || Battler_HeldByCommander(ctx, battlerId)) {
        return FALSE;
    }
    if (((item == HOLD_EFFECT_DAMAGE_ON_CONTACT && BattleMoveMakesContact(ctx, ctx->moveNoCur))
            || (item == HOLD_EFFECT_RECOIL_PHYSICAL && ctx->selfTurnData[battlerId].physicalDamage))
        && GetBattlerAbility(ctx, attacker) != ABILITY_MAGIC_GUARD
        && ctx->battleMons[attacker].hp <= DamageDivide(ctx->battleMons[attacker].maxHp, GetHeldItemModifier(ctx, battlerId, 0))) {
        return FALSE;
    }
    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TRAINER) {
        return CanSwitchMon(battleSystem, ctx, battlerId);
    }
    return WhirlwindCheck(battleSystem, ctx);
}

BOOL CheckAbilityEffectOnHit(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    BOOL ret = FALSE;
    u16 form;

    if (ctx->battlerIdTarget == BATTLER_NONE) {
        return ret;
    }

    if (BattlerCheckSubstitute(ctx, ctx->battlerIdTarget) == TRUE) {
        return ret;
    }

    // Nothing on either side answers a hit on a Pokemon that was dragged in
    // after it: not its abilities, not the attacker's Poison Touch on it.
    if (Battler_CameInAfterTheHit(ctx, ctx->battlerIdTarget) == TRUE) {
        return ret;
    }

    // The face that took the hit gives way (Activate_Disguise_IceFace,
    // ServerDoPostMoveEffects.c:2030): for a move with power that did not
    // miss, before anything else the hit sets off.
    form = Battler_BrokenFaceForm(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur);
    if (form != SPECIES_NONE && ctx->battleMons[ctx->battlerIdTarget].hp && !(ctx->moveStatusFlag & MOVE_STATUS_MISSED) && BattleMoveTbl(ctx, ctx->moveNoCur)->power) {
        BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTarget, form, TRUE);
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        *script = BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE;
        return TRUE;
    }

    // An Illusion drops with the first damage a move deals it
    // (MoveHitDefenderAbilityCheck.c:391 at d0380a487), before anything else
    // the hit sets off -- the blow that faints it included.
    if (ctx->battleMons[ctx->battlerIdTarget].illusionMon && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
        Battler_DropIllusion(ctx, ctx->battlerIdTarget, script);
        return TRUE;
    }

    // A beak heating for Beak Blast burns what touches its Pokemon before that
    // Pokemon has moved (Pokemon Central, Cannonbecco); the contact test is
    // the one Long Reach, Protective Pads and a Punching Glove answer, and the
    // burn subscript the one every burn takes, immunities and all.
    if (ctx->turnData[ctx->battlerIdTarget].beakBlastCharging && ov12_0225561C(ctx, ctx->battlerIdTarget) == FALSE
        && ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL)
        && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
        && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)
        && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        *script = BATTLE_SUBSCRIPT_BURN;
        return TRUE;
    }

    // Every ability below belongs to the Pokemon that was hit. Poison Touch is
    // the attacker's, so it is checked on its own and poisons the other way
    // round: the target takes the status, the attacker is named for it. A
    // Covert Cloak on the target stops it -- the one ability on this list the
    // reference guards with the cloak, because it is the only one here that
    // does something to the Pokemon holding it.
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) != HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS && GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_POISON_TOUCH && ctx->battleMons[ctx->battlerIdTarget].hp && !ctx->battleMons[ctx->battlerIdTarget].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && (BattleSystem_Random(battleSystem) % 10 < 3)) {
        ctx->statChangeType = 3;
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        *script = BATTLE_SUBSCRIPT_POISON;
        return TRUE;
    }

    // Toxic Chain is the attacker's too, and badly poisons; see
    // ToxicChainTakesHold for when.
    if (ToxicChainTakesHold(battleSystem, ctx) == TRUE) {
        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        *script = BATTLE_SUBSCRIPT_BADLY_POISON;
        return TRUE;
    }

    // Another ability of the attacker's that is answered here rather than in
    // the switch. A contact move that went through a Protect says so, once the
    // quarter damage has been dealt. The reference asks only about Unseen
    // Fist, not about Piercing Drill, even though both punch through: the
    // sentence names an ability, and this is the ability it names.
    if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_UNSEEN_FIST && ctx->turnData[ctx->battlerIdTarget].protectFlag && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
        ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
        *script = BATTLE_SUBSCRIPT_UNSEEN_FIST;
        return TRUE;
    }

    switch (GetBattlerAbility(ctx, ctx->battlerIdTarget)) {
    case ABILITY_STATIC:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && (BattleSystem_Random(battleSystem) % 10 < 3)) {
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_PARALYZE;
            ret = TRUE;
        }
        break;
    case ABILITY_COLOR_CHANGE: {
        u8 moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

        // Not for a move Sheer Force powered (Pokemon Central, Forzabruta;
        // the reference's ServerDoPostMoveEffects.c:1962 at d0380a487).

        if (ctx->battleMons[ctx->battlerIdTarget].hp && !Battler_WillBeDraggedOut(battleSystem, ctx, ctx->battlerIdTarget) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && ctx->moveNoCur != MOVE_STRUGGLE && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && BattleMoveTbl(ctx, ctx->moveNoCur)->power && !SheerForceTradedEffect(ctx) && GetBattlerVar(ctx, ctx->battlerIdTarget, BMON_DATA_TYPE_1, NULL) != moveType && GetBattlerVar(ctx, ctx->battlerIdTarget, BMON_DATA_TYPE_2, NULL) != moveType) {
            *script = BATTLE_SUBSCRIPT_COLOR_CHANGE;
            ctx->msgTemp = moveType;
            ret = TRUE;
        }
        break;
    }
    case ABILITY_GULP_MISSILE:
        // A Cramorant with its prey spits it at whatever hits it with a
        // damaging move (Pokemon Central, Inghiottimissile): a quarter of the
        // attacker's maximum HP, Magic Guard or not, then its Defense down a
        // stage for an Arrokuda or paralysis for a Pikachu, and the Cramorant
        // is itself again. Not at a substitute (the hit is the substitute's),
        // nor from a transformed Cramorant; it need not survive the hit.
        if ((ctx->battleMons[ctx->battlerIdTarget].species == SPECIES_CRAMORANT_GULPING || ctx->battleMons[ctx->battlerIdTarget].species == SPECIES_CRAMORANT_GORGING)
            && !(ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_TRANSFORM) && ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            ctx->statChangeParam = ctx->battleMons[ctx->battlerIdTarget].species == SPECIES_CRAMORANT_GULPING ? MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE : 0;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTarget, SPECIES_CRAMORANT, FALSE);
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 4);
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_GULP_MISSILE;
            ret = TRUE;
        }
        break;
    case ABILITY_ROUGH_SKIN:
    case ABILITY_IRON_BARBS:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 8);
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_ROUGH_SKIN;
            ret = TRUE;
        }
        break;
    case ABILITY_EFFECT_SPORE:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && (BattleSystem_Random(battleSystem) % 10 < 3)) {
            switch (BattleSystem_Random(battleSystem) % 3) {
            case 0:
            default:
                *script = BATTLE_SUBSCRIPT_POISON;
                break;
            case 1:
                *script = BATTLE_SUBSCRIPT_PARALYZE;
                break;
            case 2:
                *script = BATTLE_SUBSCRIPT_FALL_ASLEEP;
                break;
            }
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ret = TRUE;
        }
        break;
    case ABILITY_POISON_POINT:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && (BattleSystem_Random(battleSystem) % 10 < 3)) {
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_POISON;
            ret = TRUE;
        }
        break;
    case ABILITY_FLAME_BODY:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && ((BattleSystem_Random(battleSystem) % 10) < 3)) {
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_BURN;
            ret = TRUE;
        }
        break;
    case ABILITY_SPICY_SPRAY:
        // Flame Body's wiring with the contact test and the roll taken out:
        // the reference burns on any hit that landed, every time.
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].status && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_BURN;
            ret = TRUE;
        }
        break;
    case ABILITY_CUTE_CHARM:
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_ATTRACT) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur) && ctx->battleMons[ctx->battlerIdTarget].hp && ((BattleSystem_Random(battleSystem) % 10) < 3)) {
            ctx->statChangeType = 3;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_INFATUATE;
            ret = TRUE;
        }
        break;
    case ABILITY_WEAK_ARMOR:
        // Nothing left to loosen and nowhere left to run: the reference does
        // not announce the ability at all in that case.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && (ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_DEF] > 0 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPEED] < 12) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage) {
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_WEAK_ARMOR;
            ret = TRUE;
        }
        break;
    case ABILITY_BERSERK:
        // Only the blow that carries the holder past half its health, and so
        // only once. The bar has already been updated by the time this pass
        // runs, so the damage just dealt is added back to see where the
        // holder came from; the two figures are negative, as the bar wants.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPATK] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && !SheerForceTradedEffect(ctx) && ctx->battleMons[ctx->battlerIdTarget].hp <= (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2) && (ctx->battleMons[ctx->battlerIdTarget].hp - ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage > (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2) || ctx->battleMons[ctx->battlerIdTarget].hp - ctx->selfTurnData[ctx->battlerIdTarget].specialDamage > (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2))) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    case ABILITY_ANGER_SHELL:
        // The same crossing Berserk waits for, but the payout is five stat
        // changes, so the whole of it is a subscript. Any one of the five
        // having room is enough.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && !Battler_WillBeDraggedOut(battleSystem, ctx, ctx->battlerIdTarget) && (ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] < 12 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPATK] < 12 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPEED] < 12 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_DEF] > 0 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPDEF] > 0) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && !SheerForceTradedEffect(ctx) && ctx->battleMons[ctx->battlerIdTarget].hp <= (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2) && (ctx->battleMons[ctx->battlerIdTarget].hp - ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage > (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2) || ctx->battleMons[ctx->battlerIdTarget].hp - ctx->selfTurnData[ctx->battlerIdTarget].specialDamage > (int)(ctx->battleMons[ctx->battlerIdTarget].maxHp / 2))) {
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ANGER_SHELL;
            ret = TRUE;
        }
        break;
    case ABILITY_TOXIC_DEBRIS: {
        // A physical blow only, and the spikes land under whoever threw it.
        // The layer is laid here rather than in the script for the reason
        // BtlCmd_TryToxicSpikes lays its own: the cap is a condition, not a
        // message.
        int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

        if (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && ctx->fieldSideConditionData[side].toxicSpikesLayers < 2) {
            ctx->fieldSideConditionFlags[side] |= SIDE_CONDITION_TOXIC_SPIKES;
            ctx->fieldSideConditionData[side].toxicSpikesLayers++;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_TOXIC_DEBRIS;
            ret = TRUE;
        }
        break;
    }
    case ABILITY_CURSED_BODY: {
        // Anything that damages will do, contact or not, but only a move the
        // attacker still has and has not already had taken away, and not
        // behind an Aroma Veil on the attacker's side.
        int moveIndex = BattleMon_GetMoveIndex(&ctx->battleMons[ctx->battlerIdAttacker], ctx->moveNoCur);

        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledMove && moveIndex != 4 && AromaVeilShelters(ctx, ctx->battlerIdAttacker) == FALSE && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && (BattleSystem_Random(battleSystem) % 10 < 3)) {
            ctx->moveTemp = ctx->moveNoCur;
            ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledMove = ctx->moveNoCur;
            ctx->battleMons[ctx->battlerIdAttacker].unk88.disabledTurns = BattleSystem_Random(battleSystem) % 4 + 3;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_CURSED_BODY;
            ret = TRUE;
        }
        break;
    }
    case ABILITY_MUMMY:
    case ABILITY_LINGERING_AROMA:
        // The wrapping does not take an ability nothing writes over -- the
        // table's, which the reference asks here (AbilityCantSupress,
        // MoveHitDefenderAbilityCheck.c:243 at d0380a487); the list here was
        // Multitype alone -- nor what Pokemon Central adds for the two (see
        // WrappingRefuses). The refusal is against the holder's own ability
        // rather than against Mummy by name, so Lingering Aroma shares the
        // branch and neither re-wraps its own. An Ability Shield on the attacker
        // keeps its ability; the reference asks it only for Wandering Spirit below.
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !BattlerHasAbilityShield(ctx, ctx->battlerIdAttacker) && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != GetBattlerAbility(ctx, ctx->battlerIdTarget) && !(AbilityFlags(ctx->battleMons[ctx->battlerIdAttacker].ability) & ABILITY_FLAG_FAILS_SUPPRESS) && WrappingRefuses(GetBattlerAbility(ctx, ctx->battlerIdTarget), ctx->battleMons[ctx->battlerIdAttacker].ability) == FALSE && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            ctx->abilityTemp = GetBattlerAbility(ctx, ctx->battlerIdTarget);
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_MUMMY;
            ret = TRUE;
        }
        break;
    case ABILITY_WANDERING_SPIRIT:
        // Mummy above takes; this one gives back in exchange, so it refuses
        // the same abilities Skill Swap refuses, the table's, as the
        // reference does (the list here was Multitype and Wonder Guard).
        //
        // An Ability Shield on either of the two stops the swap, and this is
        // the only thing in the reference that reads that item: it guards the
        // exchange, not the taking, so a Mummy above still wraps an ability
        // that is standing behind a shield. Odd, and the reference's.
        if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) != HOLD_EFFECT_PREVENT_ABILITY_CHANGES && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) != HOLD_EFFECT_PREVENT_ABILITY_CHANGES && ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_WANDERING_SPIRIT && !(AbilityFlags(ctx->battleMons[ctx->battlerIdAttacker].ability) & ABILITY_FLAG_FAILS_SWAP) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            *script = BATTLE_SUBSCRIPT_WANDERING_SPIRIT;
            ret = TRUE;
        }
        break;
    case ABILITY_AFTERMATH:
        if (ctx->battlerIdTarget == ctx->battlerIdFainted && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_DAMP) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 4);
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_AFTERMATH;
            ret = TRUE;
        }
        break;
    case ABILITY_INNARDS_OUT:
        // hitDamage is the blow that landed, already trimmed of overkill and
        // already negative. The reference reads its own running total, which
        // in this tree is only ever cleared when Bide starts.
        if (ctx->battlerIdTarget == ctx->battlerIdFainted && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)) {
            ctx->hpCalc = ctx->hitDamage;
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_ROUGH_SKIN;
            ret = TRUE;
        }
        break;
    case ABILITY_STAMINA:
        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_DEF] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_DEFENSE_UP_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    case ABILITY_RATTLED: {
        u8 moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPEED] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && (moveType == TYPE_DARK || moveType == TYPE_GHOST || moveType == TYPE_BUG)) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    }
    case ABILITY_JUSTIFIED:
        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur) == TYPE_DARK) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    case ABILITY_THERMAL_EXCHANGE:
        // The substitute test the reference makes here is already answered at
        // the top of this function. The burn half of the ability is not read
        // here: the status subscripts refuse a burn, and CheckStatusHealAbility
        // and CheckStatusHealSwitch cure one.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur) == TYPE_FIRE) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    case ABILITY_WATER_COMPACTION:
        // The reference refuses at +5 rather than settling for one stage, so
        // a Defense that close to the ceiling gets nothing at all.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_DEF] < 11 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur) == TYPE_WATER) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdTarget;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            ret = TRUE;
        }
        break;
    case ABILITY_STEAM_ENGINE: {
        u8 moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

        if (ctx->battleMons[ctx->battlerIdTarget].hp && ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPEED] < 12 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && (moveType == TYPE_FIRE || moveType == TYPE_WATER)) {
            *script = BATTLE_SUBSCRIPT_STEAM_ENGINE;
            ret = TRUE;
        }
        break;
    }
    case ABILITY_GOOEY:
    case ABILITY_TANGLING_HAIR:
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[STAT_SPEED] > 0 && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_ABILITY_CUTS_STAT;
            ret = TRUE;
        }
        break;
    case ABILITY_COTTON_DOWN:
        // Everything else on the field, allies included, and the holder does
        // not have to have survived to shed.
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            ctx->abilityLoopTracker = 0;
            *script = BATTLE_SUBSCRIPT_COTTON_DOWN;
            ret = TRUE;
        }
        break;
    case ABILITY_PERISH_BODY:
        // The holder does not have to survive the blow it answers.
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            *script = BATTLE_SUBSCRIPT_PERISH_BODY;
            ret = TRUE;
        }
        break;
    case ABILITY_ELECTROMORPHOSIS:
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            *script = BATTLE_SUBSCRIPT_CHARGE_FROM_HIT;
            ret = TRUE;
        }
        break;
    case ABILITY_WIND_POWER:
        // The holder need not survive: the reference comments out its own
        // hp test rather than deleting it, and says so.
        if (!(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && MoveIsInList(ctx->moveNoCur, sWindMoves, NELEMS(sWindMoves)) == TRUE) {
            *script = BATTLE_SUBSCRIPT_CHARGE_FROM_HIT;
            ret = TRUE;
        }
        break;
    case ABILITY_SAND_SPIT:
        if (!(ctx->fieldCondition & FIELD_CONDITION_SANDSTORM_ALL) && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            // Under a strong weather it says that nothing changes instead.
            *script = (ctx->fieldCondition & FIELD_CONDITION_PRIMAL_WEATHER) ? BATTLE_SUBSCRIPT_PRIMAL_WEATHER_HOLDS : BATTLE_SUBSCRIPT_SAND_SPIT;
            ret = TRUE;
        }
        break;
    case ABILITY_SEED_SOWER:
        // Sand Spit again with grass instead of sand. The terrain is laid here
        // rather than in the subscript, because the subscript's only job is to
        // read what is down and say so; the side-effect type is what tells it
        // to put an Ability popup up first.
        if (ctx->terrainOverlayType != GRASSY_TERRAIN && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            BattleContext_UpdateTerrainOverlay(ctx, ctx->battlerIdTarget, GRASSY_TERRAIN);
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            *script = BATTLE_SUBSCRIPT_CREATE_TERRAIN_OVERLAY;
            ret = TRUE;
        }
        break;
    default:
        break;
    }

    if (ret == TRUE) {
        return ret;
    }

    // The last one belongs to the attacker rather than to the Pokemon that was
    // hit, and it is asked after the switch because the reference answers it
    // in a later pass than the ones above. Only one script runs per hit, so
    // whichever is asked first is the one that happens.
    //
    // A knockout is answered by the attacker's ability rather than by the
    // fallen one's. Aftermath reads the same pair to know the target is down.
    if (ctx->battlerIdTarget == ctx->battlerIdFainted && ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->moveStatusFlag & MOVE_STATUS_FAIL) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (ctx->selfTurnData[ctx->battlerIdTarget].battlerIdPhysicalAttacker == ctx->battlerIdAttacker || ctx->selfTurnData[ctx->battlerIdTarget].battlerIdSpecialAttacker == ctx->battlerIdAttacker)) {
        int stat = -1;
        u8 *bondSpent = OnceOnlyEntryAbilityDone(battleSystem, ctx, ctx->battlerIdAttacker);

        if (BattlerBattleBondBoosts(ctx, ctx->battlerIdAttacker, *bondSpent) == TRUE) {
            *bondSpent = TRUE;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_BATTLE_BOND;
            return TRUE;
        }

        switch (GetBattlerAbility(ctx, ctx->battlerIdAttacker)) {
        case ABILITY_MOXIE:
        case ABILITY_CHILLING_NEIGH:
        case ABILITY_AS_ONE_GLASTRIER:
            stat = STAT_ATK - 1;
            break;
        case ABILITY_GRIM_NEIGH:
        case ABILITY_AS_ONE_SPECTRIER:
            stat = STAT_SPATK - 1;
            break;
        // E-Levitate is Levitate in the air and Beast Boost on the ground.
        // The half that answers a knockout is the same one either way. Both
        // sit out the turn they came in on, the way Speed Boost does.
        case ABILITY_BEAST_BOOST:
        case ABILITY_EELEVATE:
            if (ctx->battleMons[ctx->battlerIdAttacker].unk88.fakeOutCount != ctx->totalTurns + 1) {
                stat = BattlerGreatestStat(ctx, ctx->battlerIdAttacker);
            }
            break;
        default:
            break;
        }

        if (stat >= 0 && ctx->battleMons[ctx->battlerIdAttacker].statChanges[stat + 1] < 12) {
            ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + stat;
            ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
            ctx->battlerIdStatChange = ctx->battlerIdAttacker;
            ctx->battlerIdTemp = ctx->battlerIdAttacker;
            *script = BATTLE_SUBSCRIPT_ABILITY_STAT_CHANGE;
            return TRUE;
        }
    }

    return ret;
}

// Magician palms what its move has just hurt, if its own hands are empty:
// once the move is over, after what the move itself does -- Thief's, Covet's
// and Knock Off's taking go first -- and before a Red Card or an Eject Button
// answers the hit (Activate_Moxie_BeastBoost_Others, ServerDoPostMoveEffects.c:1556
// at d0380a487, a step of its own after the move's additional effects;
// Pokemon Central, Prestigiatore). Not from a Pokemon that a substitute kept
// the hit off, holds on with Sticky Hold, or was dragged in after it; not if
// the user has fainted or gone, nor with a move a Gem powered, nor by a wild
// Pokemon (Prestigiatore; the reference asks no such thing). Of several it
// hit, the fastest foe first and the ally last (Prestigiatore); the reference
// walks all of them in speed order. It asked once per hit before, where the
// target's own answer to the hit came first and left it none.
BOOL TryMagician(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int attacker = ctx->battlerIdAttacker;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    if (GetBattlerAbility(ctx, attacker) != ABILITY_MAGICIAN || ctx->gemBoostingMove || !ctx->battleMons[attacker].hp
        || Battler_IsWild(battleSystem, attacker)
        || BattleMoveTbl(ctx, ctx->moveNoCur)->category == CATEGORY_STATUS
        || (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) || (ctx->battleStatus2 & BATTLE_STATUS2_UTURN)) {
        return FALSE;
    }
    for (int ally = 0; ally < 2; ally++) {
        for (int i = 0; i < maxBattlers; i++) {
            int battlerId = ctx->turnOrder[i];

            if (battlerId == attacker
                || (BattleSystem_GetFieldSide(battleSystem, battlerId) == BattleSystem_GetFieldSide(battleSystem, attacker)) != ally
                || !(ctx->selfTurnData[battlerId].physicalDamage || ctx->selfTurnData[battlerId].specialDamage)
                || BattlerCheckSubstitute(ctx, battlerId)
                || Battler_CameInAfterTheHit(ctx, battlerId)
                || (GetBattlerAbility(ctx, battlerId) == ABILITY_STICKY_HOLD && ctx->battleMons[battlerId].hp)
                || !CanAbilityTakeHeldItem(battleSystem, ctx, attacker, battlerId)) {
                continue;
            }
            ctx->battlerIdStatChange = attacker;
            ctx->battlerIdTemp = battlerId;
            NoteHeldItemTaken(battleSystem, ctx, battlerId);
            *script = BATTLE_SUBSCRIPT_ABILITY_TAKES_ITEM;
            return TRUE;
        }
    }
    return FALSE;
}

// Pickpocket lifts whatever touched its holder, if its own hands are empty,
// once the move is over (Activate_Pickpocket, ServerDoPostMoveEffects.c:1993
// at d0380a487, the step after the user's switch is set pending, so still
// before a U-turn user leaves, as TryPivotSwitch comes after it here): after
// Thief, Covet, Knock Off, Pluck and Bug Bite have taken or eaten, after
// Magician, and after a Red Card (Pokemon Central, Arraffalesto) -- so a
// Pokemon whose item a Knock Off has just taken lifts the attacker's. Not by
// a holder the hit felled, one behind a substitute, or one sent away or
// dragged in since, nor by a wild one (Arraffalesto; the reference asks no
// such thing); not from a user that has gone, nor from a move Sheer Force
// boosted, nor from a user that holds on with Sticky Hold and still stands
// (Arraffalesto, as Magician's Prestigiatore; the reference asks nothing of
// it). The theft is the Thief guard already in this tree, asked of the
// attacker rather than of the target. It was one of the answers to each hit
// before.
//
// Whether battlerId's Pickpocket lifts the attacker's item, its own hands
// aside: TryPickpocket asks them to be empty, and a Red Card's holder is
// asked as the card empties them (CheckSwitchItemOnHit).
static BOOL PickpocketLifts(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int attacker = ctx->battlerIdAttacker;

    if (!BattleMoveMakesContact(ctx, ctx->moveNoCur) || !BattleMoveTbl(ctx, ctx->moveNoCur)->power
        || (ctx->battleStatus & BATTLE_STATUS_CHARGE_TURN) || (ctx->battleStatus2 & BATTLE_STATUS2_UTURN)
        || SheerForceTradedEffect(ctx)
        || battlerId == attacker
        || GetBattlerAbility(ctx, battlerId) != ABILITY_PICKPOCKET
        || !ctx->battleMons[battlerId].hp
        || Battler_IsWild(battleSystem, battlerId)
        || !(ctx->selfTurnData[battlerId].physicalDamage || ctx->selfTurnData[battlerId].specialDamage)
        || BattlerCheckSubstitute(ctx, battlerId)
        || Battler_CameInAfterTheHit(ctx, battlerId)
        || (GetBattlerAbility(ctx, attacker) == ABILITY_STICKY_HOLD && ctx->battleMons[attacker].hp)) {
        return FALSE;
    }
    return CanStealHeldItem(battleSystem, ctx, battlerId, attacker);
}

BOOL TryPickpocket(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (int i = 0; i < maxBattlers; i++) {
        int battlerId = ctx->turnOrder[i];

        if (ctx->battleMons[battlerId].item != ITEM_NONE || !PickpocketLifts(battleSystem, ctx, battlerId)) {
            continue;
        }
        ctx->battlerIdStatChange = battlerId;
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        NoteHeldItemTaken(battleSystem, ctx, ctx->battlerIdAttacker);
        *script = BATTLE_SUBSCRIPT_ABILITY_TAKES_ITEM;
        return TRUE;
    }
    return FALSE;
}

BOOL CheckStatusHealAbility(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int flag) {
    BOOL ret = FALSE;

    switch (GetBattlerAbility(ctx, battlerId)) {
    case ABILITY_IMMUNITY:
        if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
            ctx->msgTemp = 1;
            ret = TRUE;
        }
        break;
    case ABILITY_OWN_TEMPO:
        if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
            ctx->msgTemp = 5;
            ret = TRUE;
        }
        break;
    case ABILITY_LIMBER:
        if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
            ctx->msgTemp = 3;
            ret = TRUE;
        }
        break;
    case ABILITY_INSOMNIA:
    case ABILITY_VITAL_SPIRIT:
        if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
            ctx->msgTemp = 0;
            ret = TRUE;
        }
        break;
    // Water Bubble and Thermal Exchange cure a burn, and Pastel Veil poison,
    // as Water Veil and Immunity do; the reference's
    // Activate_AbilityHealingStatusCondition adds the three.
    case ABILITY_WATER_VEIL:
    case ABILITY_WATER_BUBBLE:
    case ABILITY_THERMAL_EXCHANGE:
        if (ctx->battleMons[battlerId].status & STATUS_BURN) {
            ctx->msgTemp = 2;
            ret = TRUE;
        }
        break;
    case ABILITY_PASTEL_VEIL:
        if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
            ctx->msgTemp = 1;
            ret = TRUE;
        }
        break;
    case ABILITY_MAGMA_ARMOR:
        if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
            ctx->msgTemp = 4;
            ret = TRUE;
        }
        break;
    case ABILITY_OBLIVIOUS:
        if (ctx->battleMons[battlerId].status2 & STATUS2_ATTRACT) {
            ctx->msgTemp = 6;
            ret = TRUE;
        }
        break;
    case ABILITY_UNBURDEN:
        // resets the item flag in the case where the Pokemon acquires an item via Thief or Trick
        if (ctx->battleMons[battlerId].item) {
            ctx->battleMons[battlerId].unk88.knockOffFlag = TRUE;
        }
        break;
    }
    if (ret == TRUE) {
        ctx->battlerIdTemp = battlerId;
        ctx->abilityTemp = GetBattlerAbility(ctx, battlerId);
        if (!flag) {
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, 221);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        }
    }

    return ret;
}

BOOL CheckStatusHealSwitch(BattleContext *ctx, int ability, int status) {
    BOOL ret = FALSE;

    switch (ability) {
    case ABILITY_IMMUNITY:
        if (status & STATUS_POISON_ALL) {
            ret = TRUE;
        }
        break;
    case ABILITY_LIMBER:
        if (status & STATUS_PARALYSIS) {
            ret = TRUE;
        }
        break;
    case ABILITY_INSOMNIA:
    case ABILITY_VITAL_SPIRIT:
        if (status & STATUS_SLEEP) {
            ret = TRUE;
        }
        break;
    case ABILITY_WATER_VEIL:
    case ABILITY_WATER_BUBBLE:
    case ABILITY_THERMAL_EXCHANGE:
        if (status & STATUS_BURN) {
            ret = TRUE;
        }
        break;
    case ABILITY_MAGMA_ARMOR:
        if (status & STATUS_FREEZE) {
            ret = TRUE;
        }
        break;
    // Pastel Veil comes off the bench clean. The ability here is the party
    // slot's own, so Gastro Acid and Skill Swap do not reach it.
    case ABILITY_PASTEL_VEIL:
        if (status & STATUS_POISON_ALL) {
            ret = TRUE;
        }
        break;
    }

    return ret;
}

BOOL TrySyncronizeStatus(BattleSystem *battleSystem, BattleContext *ctx, ControllerCommand command) {
    BOOL ret = FALSE;
    int script = BATTLE_SUBSCRIPT_NONE;

    if (ctx->battlerIdTarget != BATTLER_NONE && GetBattlerAbility(ctx, ctx->battlerIdTarget) == ABILITY_SYNCHRONIZE && ctx->battlerIdTarget == ctx->battlerIdStatChange && (ctx->battleStatus & BATTLE_STATUS_SYNCRONIZE)) {
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
        ret = TRUE;
    } else if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_SYNCHRONIZE && ctx->battlerIdAttacker == ctx->battlerIdStatChange && (ctx->battleStatus & BATTLE_STATUS_SYNCRONIZE)) {
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
        ret = TRUE;
    }

    if (ret == TRUE) {
        if (ctx->battleMons[ctx->battlerIdTemp].status & STATUS_POISON_ALL) {
            script = BATTLE_SUBSCRIPT_POISON;
        } else if (ctx->battleMons[ctx->battlerIdTemp].status & STATUS_BURN) {
            script = BATTLE_SUBSCRIPT_BURN;
        } else if (ctx->battleMons[ctx->battlerIdTemp].status & STATUS_PARALYSIS) {
            script = BATTLE_SUBSCRIPT_PARALYZE;
        }
        if (script) {
            ctx->statChangeType = 3;
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return ret;
        }
    }

    // Competitive and Defiant answer a stat the other side took away, the one
    // with Special Attack and the other with Attack. The drop itself marked the
    // Pokemon on its way through BtlCmd_ChangeStatStage; this is the first pass
    // after the move where a script can be run in reply.
    for (int i = 0; i < (int)NELEMS(ctx->battleMons); i++) {
        if (ctx->battleMons[i].competitivePending) {
            ctx->battleMons[i].competitivePending = FALSE;
            int statChangeParam = 0;
            if (ctx->battleMons[i].hp) {
                if (GetBattlerAbility(ctx, i) == ABILITY_COMPETITIVE) {
                    statChangeParam = MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_2_STAGES;
                } else if (GetBattlerAbility(ctx, i) == ABILITY_DEFIANT) {
                    statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES;
                }
            }
            if (statChangeParam != 0) {
                ctx->statChangeParam = statChangeParam;
                ctx->statChangeType = SIDE_EFFECT_TYPE_ABILITY;
                ctx->battlerIdStatChange = i;
                ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
                ctx->commandNext = command;
                ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
                return TRUE;
            }
        }
    }

    ret = Battler_CheckWeatherFormChange(battleSystem, ctx, &script);
    if (ret == TRUE) {
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
        ctx->commandNext = command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        return ret;
    }

    if (ctx->battlerIdTarget != BATTLER_NONE && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) == HOLD_EFFECT_RECIPROCATE_INFAT && ctx->battlerIdTarget == ctx->battlerIdStatChange && (ctx->selfTurnData[ctx->battlerIdTarget].unk14 & 4)) {
        ctx->battlerIdTemp = ctx->battlerIdTarget;
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
        ret = TRUE;
    } else if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_RECIPROCATE_INFAT && ctx->battlerIdAttacker == ctx->battlerIdStatChange && (ctx->selfTurnData[ctx->battlerIdAttacker].unk14 & 4)) {
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
        ret = TRUE;
    }

    if (ret == TRUE) {
        script = BATTLE_SUBSCRIPT_INFATUATE;
        ctx->statChangeType = 5;
        ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
        ctx->commandNext = command;
        ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        return ret;
    }

    return FALSE;
}

// Three of the added abilities are about berries, and all three have to agree
// on which items are berries, so they ask here rather than twice over in the
// two held-item checks below.
static BOOL BattlerHoldsBerry(BattleContext *ctx, int battlerId) {
    int item = ctx->battleMons[battlerId].item;
    return item >= FIRST_BERRY_IDX && item <= LAST_BERRY_IDX;
}

// Cud Chew keeps a Berry it has eaten, its own or one plucked off a foe, to
// eat again at the end of the next turn.
static void CudChewKeepsBerry(BattleContext *ctx, int eater, u16 item) {
    if (ItemIdIsBerry(item) == TRUE && GetBattlerAbility(ctx, eater) == ABILITY_CUD_CHEW) {
        ctx->cudChewBerry[eater] = item;
        ctx->cudChewTurn[eater] = ctx->totalTurns + 1;
    }
}

// Unnerve on the far side is enough to put a Pokemon off its food, and so is
// As One, which is Unnerve and a Rider's ability in one (Pokemon Central,
// Unisono); the reference asks only for Unnerve. Ripen on this side makes
// what it does eat go twice as far.
BOOL BerryCanBeEaten(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int *boost) {
    int i;
    int ability;

    if (BattlerHoldsBerry(ctx, battlerId) == FALSE) {
        return TRUE;
    }
    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        ability = GetBattlerAbility(ctx, i);
        if (BattleSystem_GetFieldSide(battleSystem, battlerId) != BattleSystem_GetFieldSide(battleSystem, i) && ctx->battleMons[i].hp
            && (ability == ABILITY_UNNERVE || ability == ABILITY_AS_ONE_GLASTRIER || ability == ABILITY_AS_ONE_SPECTRIER)) {
            return FALSE;
        }
    }
    if (GetBattlerAbility(ctx, battlerId) == ABILITY_RIPEN) {
        *boost *= 2;
    }
    return TRUE;
}

// Whether Cheek Pouch, owed for a Berry the Pokemon has eaten, heals it now: a
// third of its maximum HP if it still stands, is not at full HP and is not
// under Heal Block (Pokemon Central, Guancegonfie; the reference's subscript
// 458 asks the same three).
static BOOL CheekPouchHeals(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].hp && ctx->battleMons[battlerId].hp < (int)ctx->battleMons[battlerId].maxHp
        && !ctx->battleMons[battlerId].unk88.healBlockTurns;
}

BOOL TryUseHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;
    int script;
    int item;
    int boost;

    item = GetBattlerHeldItemEffect(ctx, battlerId);
    boost = GetHeldItemModifier(ctx, battlerId, 0);

    if (BerryCanBeEaten(battleSystem, ctx, battlerId, &boost) == FALSE) {
        return FALSE;
    }

    // Cheek Pouch empties after the berry has gone down rather than with it,
    // which is a second pass: the callers here keep asking until nothing more
    // wants to happen.
    if (ctx->battleMons[battlerId].cheekPouchPending) {
        ctx->battleMons[battlerId].cheekPouchPending = FALSE;
        if (CheekPouchHeals(ctx, battlerId)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 3);
            ctx->battlerIdTemp = battlerId;
            script = BATTLE_SUBSCRIPT_CHEEK_POUCH;
            ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
            return TRUE;
        }
    }

    if (ctx->battleMons[battlerId].hp) {
        switch (item) {
        case HOLD_EFFECT_HP_RESTORE: // oran berry, berry juice
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = boost;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_PCT_RESTORE: // sitrus berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * boost, 100);
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PRZ_RESTORE: // cheri berry
            if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_SLP_RESTORE: // chesto berry
            if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PSN_RESTORE: // pecha berry
            if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_BRN_RESTORE: // rawst berry
            if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_FRZ_RESTORE: // aspear berry
            if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PP_RESTORE: // leppa berry
        {
            int index;
            for (index = 0; index < MAX_MON_MOVES; index++) {
                if (ctx->battleMons[battlerId].moves[index] && !ctx->battleMons[battlerId].movePPCur[index]) {
                    break;
                }
            }
            if (index != MAX_MON_MOVES) {
                BattleMon_AddVar(&ctx->battleMons[battlerId], BMON_DATA_CUR_PP_1 + index, boost);
                CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
                ctx->moveTemp = ctx->battleMons[battlerId].moves[index];
                script = BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE;
                ret = TRUE;
            }
            break;
        }
        case HOLD_EFFECT_CONFUSE_RESTORE: // persim berry
            if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_STATUS_RESTORE: // lum berry
            if ((ctx->battleMons[battlerId].status & STATUS_ALL) || (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION)) {
                if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
                }
                if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
                }
                if ((ctx->battleMons[battlerId].status & STATUS_ALL) && (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION)) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_MULTI_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SPICY: // figy berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 0;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SPICY) == -1) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_DRY: // wiki berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 1;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_DRY) == -1) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SWEET: // mago berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 2;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SWEET) == -1) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_BITTER: // aguav berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 3;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_BITTER) == -1) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SOUR: // iappapa berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 4;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SOUR) == -1) {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_ATK_UP: // liechi berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[1] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 1;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_DEF_UP: // ganlon berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[2] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 2;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPEED_UP: // salac berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[3] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 3;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPATK_UP: // petaya berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[4] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 4;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPDEF_UP: // apicot berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[5] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 5;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_CRITRATE_UP: // apicot berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && !(ctx->battleMons[battlerId].status2 & STATUS2_FOCUS_ENERGY)) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_CRIT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_RANDOM_UP: // starf berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost) {
                int stat;
                for (stat = 0; stat < 5; stat++) {
                    if (ctx->battleMons[battlerId].statChanges[1 + stat] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                        break;
                    }
                }
                if (stat != 5) {
                    do {
                        stat = BattleSystem_Random(battleSystem) % 5;
                    } while (ctx->battleMons[battlerId].statChanges[1 + stat] == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
                    ctx->msgTemp = stat + 1;
                    script = BATTLE_SUBSCRIPT_HELD_ITEM_SHARPLY_RAISE_STAT;
                    ret = TRUE;
                }
            }
            break;
        case HOLD_EFFECT_STATDOWN_RESTORE: // white herb
        {
            int stat;
            for (stat = 0; stat < 8; stat++) {
                if (ctx->battleMons[battlerId].statChanges[stat] < 6) {
                    ctx->battleMons[battlerId].statChanges[stat] = 6;
                    ret = TRUE;
                }
            }
            if (ret == TRUE) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_STATDOWN_RESTORE;
            }
            break;
        }
        case HOLD_EFFECT_HEAL_INFATUATION: // mental herb
            if (ctx->battleMons[battlerId].status2 & STATUS2_ATTRACT) {
                ctx->msgTemp = 6;
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HEAL_INFATUATION;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_ACC_UP: // micle berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= (ctx->battleMons[battlerId].maxHp / boost)) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_TEMP_ACC_UP;
                ret = TRUE;
            }
            break;
        default:
            break;
        }
        if (ret == TRUE) {
            if (BattlerHoldsBerry(ctx, battlerId) == TRUE && GetBattlerAbility(ctx, battlerId) == ABILITY_CHEEK_POUCH) {
                ctx->battleMons[battlerId].cheekPouchPending = TRUE;
            }
            CudChewKeepsBerry(ctx, battlerId, ctx->battleMons[battlerId].item);
            ctx->battlerIdTemp = battlerId;
            ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        }
    }
    return ret;
}

BOOL CheckItemGradualHPRestore(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;
    int script;
    int item;

    item = GetBattlerHeldItemEffect(ctx, battlerId);
    GetHeldItemModifier(ctx, battlerId, 0);

    if (ctx->battleMons[battlerId].hp) {
        switch (item) {
        case HOLD_EFFECT_HP_RESTORE_GRADUAL: // leftovers
            if (ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                script = BATTLE_SUBSCRIPT_RESTORE_A_LITTLE_HP;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_PSN_TYPE: // black sludge
            if (GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_POISON || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_POISON) {
                if (ctx->battleMons[battlerId].hp < ctx->battleMons[battlerId].maxHp) {
                    ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 16);
                    script = BATTLE_SUBSCRIPT_RESTORE_A_LITTLE_HP;
                    ret = TRUE;
                }
            } else if (GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8);
                script = BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM_WITH_MESSAGE;
                ret = TRUE;
            }
            break;
        default:
            break;
        }
        if (ret == TRUE) {
            ctx->battlerIdTemp = battlerId;
            ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        }
    }
    return ret;
}

// The Mirror Herb. The reference has the case in its post-move items with a
// TODO and a break (ServerDoPostMoveEffects.c:1772 at d0380a487), so this is
// Pokemon Central's (Foglia carbone): when a Pokemon on the other side gains
// stat stages, the holder gains the same, all of them at once however many
// stats and Pokemon went up, spends the herb, and does nothing if every stat
// it would copy is already at +6. RecordMirrorHerbStages is told of every
// stage BtlCmd_ChangeStatStage actually adds, and of every one a script raises
// itself through BtlCmd_UpdateMonData -- Belly Drum, a Starf Berry, Anger
// Point -- or Rage builds; the stages wait there until the holder's items are
// next asked -- after the move that raised them, after the entry abilities, at
// the end of the turn -- and MirrorHerbCopiesStages applies them. The herb's
// own copy is written straight into the stages, so it is not told to
// anybody's herb in turn, and neither are Costar's and Opportunist's, which
// Pokemon Central leaves out as well.
void RecordMirrorHerbStages(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int stat, int stages) {
    int i;

    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        if (BattleSystem_GetFieldSide(battleSystem, i) != BattleSystem_GetFieldSide(battleSystem, battlerId)
            && ctx->battleMons[i].hp
            && GetBattlerHeldItemEffect(ctx, i) == HOLD_EFFECT_COPY_STAT_INCREASE) {
            ctx->mirrorHerbStages[i][stat] += stages;
        }
    }
}

// A holder with Contrary copies the gains as drops, down to -6, and nothing
// when every stat it would copy is already there (Pokemon Central, Foglia
// carbone: Contrary and Simple change the herb's effect as any other; Simple
// doubles stages as they are read here, so its copy is doubled already).
// tempData says which of the two animations subscript 433 plays.
static BOOL MirrorHerbCopiesStages(BattleContext *ctx, int battlerId) {
    BOOL copied = FALSE;
    BOOL contrary = GetBattlerAbility(ctx, battlerId) == ABILITY_CONTRARY;
    int stat;

    for (stat = STAT_ATK; stat < NUM_BATTLE_STATS; stat++) {
        int stages = contrary ? -ctx->mirrorHerbStages[battlerId][stat] : ctx->mirrorHerbStages[battlerId][stat];
        int stage = ctx->battleMons[battlerId].statChanges[stat] + stages;

        if (stages > 0 && ctx->battleMons[battlerId].statChanges[stat] < 12) {
            ctx->battleMons[battlerId].statChanges[stat] = stage > 12 ? 12 : stage;
            // Raised as Opportunist's copy is, through the stat command: a
            // rise for Burning Jealousy (Fiamminvidia leaves out only the
            // stages Psych Up, Transform and the swaps hand over whole).
            ctx->turnData[battlerId].statRaised = TRUE;
            copied = TRUE;
        } else if (stages < 0 && ctx->battleMons[battlerId].statChanges[stat] > 0) {
            ctx->battleMons[battlerId].statChanges[stat] = stage < 0 ? 0 : stage;
            copied = TRUE;
        }
        ctx->mirrorHerbStages[battlerId][stat] = 0;
    }
    ctx->tempData = contrary ? BATTLE_ANIMATION_STAT_DROP : BATTLE_ANIMATION_STAT_BOOST;
    return copied;
}

BOOL CheckUseHeldItem(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u32 *script) {
    BOOL ret = FALSE;
    int item;
    int boost;

    item = GetBattlerHeldItemEffect(ctx, battlerId);
    boost = GetHeldItemModifier(ctx, battlerId, 0);

    if (BerryCanBeEaten(battleSystem, ctx, battlerId, &boost) == FALSE) {
        return FALSE;
    }

    // Cheek Pouch empties after the berry has gone down rather than with it,
    // which is a second pass: the callers here keep asking until nothing more
    // wants to happen.
    if (ctx->battleMons[battlerId].cheekPouchPending) {
        ctx->battleMons[battlerId].cheekPouchPending = FALSE;
        if (CheekPouchHeals(ctx, battlerId)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, 3);
            ctx->battlerIdTemp = battlerId;
            *script = BATTLE_SUBSCRIPT_CHEEK_POUCH;
            return TRUE;
        }
    }

    if (ctx->battleMons[battlerId].hp) {
        switch (item) {
        case HOLD_EFFECT_HP_RESTORE: // oran berry, berry juice
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = boost;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_PCT_RESTORE: // sitrus berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * boost, 100);
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PRZ_RESTORE: // cheri berry
            if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_SLP_RESTORE: // chesto berry
            if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PSN_RESTORE: // pecha berry
            if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_BRN_RESTORE: // rawst berry
            if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_FRZ_RESTORE: // aspear berry
            if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PP_RESTORE: // leppa berry
        {
            int index;
            for (index = 0; index < MAX_MON_MOVES; index++) {
                if (ctx->battleMons[battlerId].moves[index] && !ctx->battleMons[battlerId].movePPCur[index]) {
                    break;
                }
            }
            if (index != MAX_MON_MOVES) {
                BattleMon_AddVar(&ctx->battleMons[battlerId], BMON_DATA_CUR_PP_1 + index, boost);
                CopyBattleMonToPartyMon(battleSystem, ctx, battlerId);
                ctx->moveTemp = ctx->battleMons[battlerId].moves[index];
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE;
                ret = TRUE;
            }
            break;
        }
        case HOLD_EFFECT_CONFUSE_RESTORE: // persim berry
            if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_STATUS_RESTORE: // lum berry
            if ((ctx->battleMons[battlerId].status & STATUS_ALL) || (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION)) {
                if (ctx->battleMons[battlerId].status & STATUS_PARALYSIS) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_SLEEP) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_POISON_ALL) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_BURN) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
                }
                if (ctx->battleMons[battlerId].status & STATUS_FREEZE) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
                }
                if (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
                }
                if ((ctx->battleMons[battlerId].status & STATUS_ALL) && (ctx->battleMons[battlerId].status2 & STATUS2_CONFUSION)) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_MULTI_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_STATDOWN_RESTORE: // white herb
        {
            int stat;
            for (stat = 0; stat < 8; stat++) {
                if (ctx->battleMons[battlerId].statChanges[stat] < 6) {
                    ctx->battleMons[battlerId].statChanges[stat] = 6;
                    ret = TRUE;
                }
            }
            if (ret == TRUE) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_STATDOWN_RESTORE;
            }
            break;
        }
        case HOLD_EFFECT_COPY_STAT_INCREASE: // mirror herb
            if (MirrorHerbCopiesStages(ctx, battlerId) == TRUE) {
                *script = BATTLE_SUBSCRIPT_MIRROR_HERB;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HEAL_INFATUATION: // mental herb
            if (ctx->battleMons[battlerId].status2 & STATUS2_ATTRACT) {
                ctx->msgTemp = 6;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_HEAL_INFATUATION;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_ACC_UP: // micle berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= (ctx->battleMons[battlerId].maxHp / boost)) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_TEMP_ACC_UP;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SPICY: // figy berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 0;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SPICY) == -1) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_DRY: // wiki berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 1;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_DRY) == -1) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SWEET: // mago berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 2;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SWEET) == -1) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_BITTER: // aguav berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 3;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_BITTER) == -1) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_HP_RESTORE_SOUR: // iappapa berry
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / 2) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp, boost);
                ctx->msgTemp = 4;
                if (GetFlavorPreferenceFromPID(ctx->battleMons[battlerId].personality, FLAVOR_SOUR) == -1) {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
                } else {
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
                }
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_ATK_UP: // liechi berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[1] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 1;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_DEF_UP: // ganlon berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[2] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 2;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPEED_UP: // salac berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[3] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 3;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPATK_UP: // petaya berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[4] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 4;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_SPDEF_UP: // apicot berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && ctx->battleMons[battlerId].statChanges[5] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                ctx->msgTemp = 5;
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_CRITRATE_UP: // apicot berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost && !(ctx->battleMons[battlerId].status2 & STATUS2_FOCUS_ENERGY)) {
                *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_CRIT;
                ret = TRUE;
            }
            break;
        case HOLD_EFFECT_PINCH_RANDOM_UP: // starf berry
            if (GetBattlerAbility(ctx, battlerId) == ABILITY_GLUTTONY) {
                boost /= 2;
            }
            if (ctx->battleMons[battlerId].hp <= ctx->battleMons[battlerId].maxHp / boost) {
                int stat;
                for (stat = 0; stat < 5; stat++) {
                    if (ctx->battleMons[battlerId].statChanges[1 + stat] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                        break;
                    }
                }
                if (stat != 5) {
                    do {
                        stat = BattleSystem_Random(battleSystem) % 5;
                    } while (ctx->battleMons[battlerId].statChanges[1 + stat] == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
                    ctx->msgTemp = stat + 1;
                    *script = BATTLE_SUBSCRIPT_HELD_ITEM_SHARPLY_RAISE_STAT;
                    ret = TRUE;
                }
            }
            break;
        default:
            break;
        }
        if (ret == TRUE) {
            if (BattlerHoldsBerry(ctx, battlerId) == TRUE && GetBattlerAbility(ctx, battlerId) == ABILITY_CHEEK_POUCH) {
                ctx->battleMons[battlerId].cheekPouchPending = TRUE;
            }
            CudChewKeepsBerry(ctx, battlerId, ctx->battleMons[battlerId].item);
            ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
        }
    }

    return ret;
}

BOOL TryHeldItemNegativeEffect(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;
    int script;
    int item = GetBattlerHeldItemEffect(ctx, battlerId);
    int boost = GetHeldItemModifier(ctx, battlerId, 0);

    if (ctx->battleMons[battlerId].hp) {
        switch (item) {
        case HOLD_EFFECT_PSN_USER: // toxic orb
            ctx->battlerIdStatChange = battlerId;
            ctx->statChangeType = 5;
            script = BATTLE_SUBSCRIPT_BADLY_POISON;
            ret = TRUE;
            break;
        case HOLD_EFFECT_BRN_USER: // flame orb
            ctx->battlerIdStatChange = battlerId;
            ctx->statChangeType = 5;
            script = BATTLE_SUBSCRIPT_BURN;
            ret = TRUE;
            break;
        case HOLD_EFFECT_DMG_USER_CONTACT_XFR: // sticky barb
            if (GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD) {
                ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, boost);
                script = BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM_WITH_MESSAGE;
                ret = TRUE;
            }
            break;
        default:
            break;
        }
        if (ret == TRUE) {
            ctx->battlerIdTemp = battlerId;
            ctx->itemTemp = GetBattlerHeldItem(ctx, battlerId);
            ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, script);
            ctx->commandNext = ctx->command;
            ctx->command = CONTROLLER_COMMAND_RUN_SCRIPT;
        }
    }
    return ret;
}

u16 GetBattlerHeldItem(BattleContext *ctx, int battlerId) {
    if (GetBattlerAbility(ctx, battlerId) == ABILITY_KLUTZ) {
        return ITEM_NONE;
    }
    if (ctx->battleMons[battlerId].unk88.embargoFlag) {
        return ITEM_NONE;
    }
    // Magic Room leaves every held item on the field without its effect.
    if (ctx->magicRoomTurns) {
        return ITEM_NONE;
    }
    return ctx->battleMons[battlerId].item;
}

BOOL ov12_0225561C(BattleContext *ctx, int battlerId) {
    return ctx->playerActions[battlerId].command == CONTROLLER_COMMAND_40;
}

// Absorb Bulb, Cell Battery, Snowball and Luminous Moss are one item four
// times over: a damaging hit of the named type raises one stat by a stage and
// the item goes with it. Kee Berry and Maranga Berry are that item again with
// the condition on the damage's class rather than on the move's type, so what
// woke the item up is passed in and only the ceiling is asked here. The
// ceiling is read the reference's way -- Contrary turns the raise into a drop,
// so what a Contrary holder needs is room below rather than above.
//
// BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT is the bank's own item-credited stat
// raise, the one the Liechi family of Berries runs: it plays the item's
// animation, moves the stage, prints "The {item} raised {mon}'s {stat}!" and
// eats the item. The reference writes a script per item to say "{mon}'s {item}
// raised its {stat}!" instead -- a row this bank has not got. The sentence here
// is this bank's, and it credits the item, which is the part that matters.
static BOOL ItemRaisesStatOnHit(BattleContext *ctx, BOOL triggered, int stat, int *script) {
    int target = ctx->battlerIdTarget;
    int stage = ctx->battleMons[target].statChanges[stat];
    BOOL contrary = CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, target, ABILITY_CONTRARY);

    if (triggered == FALSE
        || !ctx->battleMons[target].hp
        || (contrary == TRUE ? stage == 0 : stage == 12)) {
        return FALSE;
    }

    ctx->msgTemp = stat;
    ctx->battlerIdTemp = target;
    ctx->itemTemp = ctx->battleMons[target].item;
    *script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
    return TRUE;
}

BOOL CheckItemEffectOnHit(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    BOOL ret = FALSE;
    int item;
    int boost;
    int side;
    BOOL physical;
    BOOL special;
    int moveType;

    if (ctx->battlerIdTarget == BATTLER_NONE) {
        return ret;
    }

    if (BattlerCheckSubstitute(ctx, ctx->battlerIdTarget) == TRUE) {
        return ret;
    }

    // Nor its held item: an Air Balloon, a Rocky Helmet, a Jaboca Berry.
    if (Battler_CameInAfterTheHit(ctx, ctx->battlerIdTarget) == TRUE) {
        return ret;
    }

    item = GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget);
    boost = GetHeldItemModifier(ctx, ctx->battlerIdTarget, 0);
    side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);
    physical = ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage != 0;
    special = ctx->selfTurnData[ctx->battlerIdTarget].specialDamage != 0;
    moveType = BattleMoveAdjustedType(ctx, ctx->battlerIdAttacker, ctx->moveNoCur);

    switch (item) {
    case HOLD_EFFECT_DMG_USER_CONTACT_XFR: // sticky barb
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && !(ctx->battleMons[ctx->battlerIdAttacker].item) && !(ctx->fieldSideConditionData[side].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdAttacker])) && ctx->moveNoCur != MOVE_KNOCK_OFF && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            *script = BATTLE_SUBSCRIPT_TRANSFER_STICKY_BARB;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_RECOIL_PHYSICAL: // jacoba berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, boost);
            *script = BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_RECOIL_SPECIAL: // rowap berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, boost);
            *script = BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_HP_RESTORE_SE: // enigma berry
        if (ctx->battleMons[ctx->battlerIdTarget].hp && (ctx->moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, boost);
            *script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ctx->itemTemp = ctx->battleMons[ctx->battlerIdTarget].item;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_BOOST_SPECIAL_ATTACK_ON_WATER_HIT: // absorb bulb
        ret = ItemRaisesStatOnHit(ctx, (physical || special) && moveType == TYPE_WATER, STAT_SPATK, script);
        break;
    case HOLD_EFFECT_BOOST_ATK_ON_ELECTRIC_HIT: // cell battery
        ret = ItemRaisesStatOnHit(ctx, (physical || special) && moveType == TYPE_ELECTRIC, STAT_ATK, script);
        break;
    case HOLD_EFFECT_BOOST_ATK_ON_ICE_HIT: // snowball
        ret = ItemRaisesStatOnHit(ctx, (physical || special) && moveType == TYPE_ICE, STAT_ATK, script);
        break;
    case HOLD_EFFECT_BOOST_SPECIAL_DEFENSE_ON_WATER_HIT: // luminous moss
        ret = ItemRaisesStatOnHit(ctx, (physical || special) && moveType == TYPE_WATER, STAT_SPDEF, script);
        break;
    case HOLD_EFFECT_BOOST_DEF_ON_PHYSICAL_HIT: // kee berry
        // The class of the damage and nothing else: no type, and -- this being
        // the reference's condition rather than an omission -- no check that
        // the move touched, so a physical hit from across the field still
        // feeds it. Not a move Sheer Force powered, for either Berry
        // (Pokemon Central, Forzabruta), which the reference does not ask.
        ret = ItemRaisesStatOnHit(ctx, physical && !SheerForceTradedEffect(ctx), STAT_DEF, script);
        break;
    case HOLD_EFFECT_BOOST_SPDEF_ON_SPECIAL_HIT: // maranga berry
        ret = ItemRaisesStatOnHit(ctx, special && !SheerForceTradedEffect(ctx), STAT_SPDEF, script);
        break;
    case HOLD_EFFECT_BOOST_ATK_AND_SPATK_ON_SE: // weakness policy
        // A super effective hit, the holder still standing, and nothing else:
        // alone among the items in this switch the reference does not ask
        // whether any damage was actually dealt. Either stat having room is
        // enough for both to be tried, and the Contrary arm is the reference's
        // own shape -- an OR beside the plain test rather than the alternative
        // to it, so a Contrary holder at the ceiling still passes on the plain
        // one.
        if (ctx->battleMons[ctx->battlerIdTarget].hp
            && (ctx->moveStatusFlag & MOVE_STATUS_SUPER_EFFECTIVE)
            && ((ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] < 12 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPATK] < 12)
                || (CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_CONTRARY) == TRUE
                    && (ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_ATK] > 0 || ctx->battleMons[ctx->battlerIdTarget].statChanges[STAT_SPATK] > 0)))) {
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ctx->itemTemp = ctx->battleMons[ctx->battlerIdTarget].item;
            *script = BATTLE_SUBSCRIPT_WEAKNESS_POLICY;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_DAMAGE_ON_CONTACT: // rocky helmet
        // The reference asks for Protective Pads twice here, once on its own
        // and once inside IsContactBeingMade; the second is where it lives in
        // this tree, so BattleMoveMakesContact answers both.
        //
        // The U-turn test is this tree's, not the reference's: a pivot move
        // runs the pivot script's own held-item step and then comes back
        // through here, so the Jaboca Berry and the Sticky Barb below already
        // stand the second pass off this way and the helmet has to as well or
        // it hurts twice.
        if (ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && (physical || special) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, boost);
            *script = BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT;
            ret = TRUE;
        }
        break;
    case HOLD_EFFECT_UNGROUND_DESTROYED_ON_HIT: // air balloon
        // Any damaging hit, of any type, pops it. The reference checks nothing
        // but that damage was dealt and the holder is still standing.
        if (ctx->battleMons[ctx->battlerIdTarget].hp && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage)) {
            ctx->battlerIdTemp = ctx->battlerIdTarget;
            ctx->itemTemp = ctx->battleMons[ctx->battlerIdTarget].item;
            *script = BATTLE_SUBSCRIPT_AIR_BALLOON_POP;
            ret = TRUE;
        }
        break;
    default:
        break;
    }

    return ret;
}

// The two items that answer a hit by sending somebody away, asked once the
// move is over rather than after each hit, so a multi-hit move lands every
// hit first (the reference's Activate_KeeMarangaBerry_RedCard_EjectButton,
// ServerDoPostMoveEffects.c:1799 at d0380a487, run from its post-move steps).
// Whether battlerId's holdEffect -- one of the two -- answers the move: the
// holder is any battler but the user that the move damaged -- not through a
// substitute, which records no damage -- and that took the hit itself rather
// than being dragged into its slot afterwards, and it still stands. Nothing
// answers a move Sheer Force powered.
//
// Eject Button: the holder goes back and its trainer chooses who comes in.
// It answers after a Red Card has dragged the user out as well (Pokemon
// Central, Pulsantefuga: the card's Pokemon comes in first, then the
// button's). Not with nobody to come in -- a wild holder, or a trainer with
// no other Pokemon able to fight (Pulsantefuga) -- nor on a Pokemon Commander
// holds on the field (Pokemon Central, Torre di Comando): its button stays,
// and does not take another holder's turn or keep the Eject Packs shut.
//
// Red Card: the attacker is dragged out. The reference asks it only in a
// trainer battle, as Pokemon Central's Cartelrosso does for a wild Pokemon,
// and not once the user has gone of its own accord.
static BOOL SwitchItemAnswersHit(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int holdEffect) {
    int attacker = ctx->battlerIdAttacker;

    if (GetBattlerHeldItemEffect(ctx, battlerId) != holdEffect
        || battlerId == attacker
        || ctx->battleMons[battlerId].hp == 0
        || (ctx->selfTurnData[battlerId].physicalDamage == 0 && ctx->selfTurnData[battlerId].specialDamage == 0)
        || Battler_CameInAfterTheHit(ctx, battlerId)
        || SheerForceTradedEffect(ctx)) {
        return FALSE;
    }
    if (holdEffect == HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE) {
        return !(ctx->battleStatus2 & BATTLE_STATUS2_UTURN) && ctx->battleMons[attacker].hp
            && (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_TRAINER);
    }
    return !Battler_HeldByCommander(ctx, battlerId) && CanSwitchMon(battleSystem, ctx, battlerId);
}

// Suction Cups, Guard Dog, Ingrain and Commander keep a Pokemon in against a
// Red Card: the card is spent all the same (Pokemon Central, Cartelrosso;
// Cane da Guardia, which no item or move of another Pokemon makes leave the
// field; Torre di Comando; the reference keeps the card instead).
static BOOL BattlerIsAnchored(BattleContext *ctx, int battlerId) {
    return GetBattlerAbility(ctx, battlerId) == ABILITY_SUCTION_CUPS
        || GetBattlerAbility(ctx, battlerId) == ABILITY_GUARD_DOG
        || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
        || Battler_HeldByCommander(ctx, battlerId);
}

// Returns the subscript battlerId's holdEffect runs, with the holder in
// battlerIdTemp, or BATTLE_SUBSCRIPT_NONE. The Red Card's Pokemon to drag in
// is chosen here at random, as Whirlwind's is, and with nobody to bring in the
// card is not used; against an anchored attacker it is played and nobody is
// chosen.
//
// A card holder with Pickpocket lifts the attacker's item all the same, its
// hands emptied by the card, though the attacker is dragged out (Pokemon
// Central, Arraffalesto; Bulbapedia's Red Card: "even after that attacker is
// switched out"). Pickpocket's own step comes after the card, once the
// attacker has gone, so the card's subscript lifts the item as the card is
// spent, told by TEMP_DATA.
int CheckSwitchItemOnHit(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int holdEffect) {
    int i;

    if (!SwitchItemAnswersHit(battleSystem, ctx, battlerId, holdEffect)) {
        return BATTLE_SUBSCRIPT_NONE;
    }
    if (holdEffect == HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE) {
        if (!BattlerIsAnchored(ctx, ctx->battlerIdAttacker) && TryPickForcedSwitchIn(battleSystem, ctx, ctx->battlerIdAttacker) == FALSE) {
            return BATTLE_SUBSCRIPT_NONE;
        }
        // A card played, whatever it drags, keeps Emergency Exit and Wimp
        // Out from answering the move, whoever holds them (Pokemon Central,
        // Cartelrosso); the move's end asks them after it (TryRetreatAbility).
        for (i = 0; i < BATTLER_MAX; i++) {
            ctx->selfTurnData[i].retreatArmed = FALSE;
        }
        ctx->battlerIdTemp = battlerId;
        ctx->tempData = PickpocketLifts(battleSystem, ctx, battlerId);
        if (ctx->tempData) {
            NoteHeldItemTaken(battleSystem, ctx, ctx->battlerIdAttacker);
        }
        return BATTLE_SUBSCRIPT_RED_CARD;
    }
    ctx->battlerIdTemp = battlerId;
    return BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM;
}

// The Eject Pack, once the move is over: a holder that had a stat lowered
// during it goes back, its trainer choosing who comes in, whoever lowered the
// stat -- a foe's move, the holder's own Close Combat, Intimidate from a
// Pokemon a pivot move brought in, Sticky Web on the way in
// (ServerDoPostMoveEffects.c:1755 at d0380a487); and once the action is over,
// for what an entry lowered -- Intimidate, Sticky Web -- which the reference
// has commented out and Pokemon Central (Zainofuga) answers (ov12_0224D368).
// Its end-of-turn check is commented out there and is not here either. What
// only swaps or resets stages lowers nothing and does not count, nor does a
// holder Commander keeps on the field, whose Pack stays and lets the others
// act (Pokemon Central, Torre di Comando), nor one with nobody to come in, as
// for the Eject Button (Pulsantefuga), the Pack staying and the next holder
// acting. Returns the subscript, with the holder in battlerIdTemp, or
// BATTLE_SUBSCRIPT_NONE.
int CheckEjectPack(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    if (GetBattlerHeldItemEffect(ctx, battlerId) != HOLD_EFFECT_SWITCH_OUT_ON_STAT_DROP
        || ctx->battleMons[battlerId].hp == 0
        || !(ctx->statLoweredBattlers & MaskOfFlagNo(battlerId))
        || Battler_HeldByCommander(ctx, battlerId)
        || !CanSwitchMon(battleSystem, ctx, battlerId)) {
        return BATTLE_SUBSCRIPT_NONE;
    }
    ctx->battlerIdTemp = battlerId;
    return BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM;
}

int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) {
    u16 itemNo = GetBattlerHeldItem(ctx, battlerId);
    return GetItemVar(ctx, itemNo, ITEM_VAR_HOLD_EFFECT);
}

int GetHeldItemModifier(BattleContext *ctx, int battlerId, int flag) {
    u16 itemNo;

    switch (flag) {
    case 0:
        itemNo = GetBattlerHeldItem(ctx, battlerId);
        break;
    case 2:
        if (ctx->battleMons[battlerId].unk88.embargoFlag) {
            return 0;
        }
    case 1:
        itemNo = ctx->battleMons[battlerId].item;
        break;
    }

    return GetItemVar(ctx, itemNo, ITEM_VAR_MODIFIER);
}

int GetNaturalGiftPower(BattleContext *ctx, int battlerId) {
    u16 itemNo = GetBattlerHeldItem(ctx, battlerId);
    return GetItemVar(ctx, itemNo, ITEM_NATURAL_GIFT_POWER);
}

int GetNaturalGiftType(BattleContext *ctx, int battlerId) {
    u16 itemNo = GetBattlerHeldItem(ctx, battlerId);
    return GetItemVar(ctx, itemNo, ITEM_NATURAL_GIFT_TYPE);
}

int GetHeldItemStealBerryEffect(BattleContext *ctx, int battlerId) {
    u16 itemNo = ctx->battleMons[battlerId].item;
    return GetItemVar(ctx, itemNo, ITEM_VAR_8);
}

int GetHeldItemFlingEffect(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].unk88.embargoFlag) {
        return 0;
    }

    return GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_9);
}

// A Gem cannot be flung, though its record gives it 30 (Pokemon Central,
// Lancio; the reference refuses it before the move, IS_ITEM_GEM).
int GetHeldItemFlingPower(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].unk88.embargoFlag
        || GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT) == HOLD_EFFECT_POWERING_UP_MOVE_ONCE) {
        return 0;
    }

    return GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_10);
}

BOOL BattlerCanSwitch(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;

    // Commander holds its pair in whatever they hold: a Shed Shell does not
    // let them go (Pokemon Central, Torre di Comando).
    if (Battler_HeldByCommander(ctx, battlerId)) {
        return TRUE;
    }
    if (GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_SWITCH || Battler_HasGhostType(ctx, battlerId)) {
        return FALSE;
    }

    if ((ctx->battleMons[battlerId].status2 & (STATUS2_BIND | STATUS2_MEAN_LOOK)) || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_INGRAIN)
        || ctx->fairyLockTurns) {
        ret = TRUE;
    }

    if ((GetBattlerAbility(ctx, battlerId) != ABILITY_SHADOW_TAG && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, battlerId, ABILITY_SHADOW_TAG)) || ((GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) == TYPE_STEEL || GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) == TYPE_STEEL) && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, battlerId, ABILITY_MAGNET_PULL))) {
        ret = TRUE;
    }

    if (((GetBattlerAbility(ctx, battlerId) != ABILITY_LEVITATE && ctx->battleMons[battlerId].unk88.magnetRiseTurns == 0 && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_1, NULL) != TYPE_FLYING && GetBattlerVar(ctx, battlerId, BMON_DATA_TYPE_2, NULL) != TYPE_FLYING) || GetBattlerHeldItemEffect(ctx, battlerId) == HOLD_EFFECT_SPEED_DOWN_GROUNDED || (ctx->fieldCondition & FIELD_CONDITION_GRAVITY)) && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_OPPOSING_SIDE_HP, battlerId, ABILITY_ARENA_TRAP)) {
        ret = TRUE;
    }

    return ret;
}

BOOL TryEatOpponentBerry(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;
    int script = BATTLE_SUBSCRIPT_NONE;
    int item = GetHeldItemStealBerryEffect(ctx, battlerId);
    int mod = GetHeldItemModifier(ctx, battlerId, 1);

    switch (item) {
    case STEAL_EFFECT_RESTORE_HP: // oran berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = mod;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_HP_PRCT: // sitrus berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * mod, 100);
            script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_PARALYSIS: // cheri berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_PARALYSIS) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_SLEEP: // chesto berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_POISON: // pecha berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_POISON_ALL) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_BURN: // rawst berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_BURN) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_FREEZE: // aspear berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_FREEZE) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_PP: // leppa berry
    {
        int ppCalc;
        int index;
        int max = 0;
        int maxIndex;
        for (index = 0; index < MAX_MON_MOVES; index++) {
            if (ctx->battleMons[ctx->battlerIdAttacker].moves[index]) {
                ppCalc = GetMoveMaxPP(ctx->battleMons[ctx->battlerIdAttacker].moves[index], ctx->battleMons[ctx->battlerIdAttacker].movePP[index]) - ctx->battleMons[ctx->battlerIdAttacker].movePPCur[index];
                if (ppCalc > max) {
                    max = ppCalc;
                    maxIndex = index;
                }
            }
        }

        BattleMon_AddVar(&ctx->battleMons[ctx->battlerIdAttacker], BMON_DATA_CUR_PP_1 + maxIndex, mod);
        CopyBattleMonToPartyMon(battleSystem, ctx, ctx->battlerIdAttacker);
        ctx->moveTemp = ctx->battleMons[ctx->battlerIdAttacker].moves[maxIndex];
        script = BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE;
        ret = TRUE;
        break;
    }
    case STEAL_EFFECT_CURE_CONFUSION: // persim berry
        if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_CURE_ALL: // lum berry
        if ((ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_ALL) || (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION)) {
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_PARALYSIS) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_SLEEP) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_POISON_ALL) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_BURN) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_FREEZE) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE;
            }
            if (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE;
            }
            if ((ctx->battleMons[ctx->battlerIdAttacker].status & STATUS_ALL) && (ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_CONFUSION)) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_MULTI_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_SPICY: // figy berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, mod);
            ctx->msgTemp = 0;
            if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdAttacker].personality, FLAVOR_SPICY) == -1) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
            } else {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_DRY: // wiki berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, mod);
            ctx->msgTemp = 1;
            if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdAttacker].personality, FLAVOR_DRY) == -1) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
            } else {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_SWEET: // mago berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, mod);
            ctx->msgTemp = 2;
            if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdAttacker].personality, FLAVOR_SWEET) == -1) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
            } else {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_BITTER: // aguav berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, mod);
            ctx->msgTemp = 3;
            if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdAttacker].personality, FLAVOR_BITTER) == -1) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
            } else {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RESTORE_SOUR: // iappapa berry
        if (ctx->battleMons[ctx->battlerIdAttacker].hp != ctx->battleMons[ctx->battlerIdAttacker].maxHp) {
            ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp, mod);
            ctx->msgTemp = 4;
            if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdAttacker].personality, FLAVOR_SOUR) == -1) {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR;
            } else {
                script = BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE;
            }
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_ATK_UP: // liechi berry
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[1] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 1;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_DEF_UP: // ganlon berry
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[2] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 2;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_SPEED_UP: // salac berry
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[3] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 3;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_SPATK_UP: // petaya berry
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[4] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 4;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_SPDEF_UP: // apicot berry
        if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[5] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 5;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_RANDOM_UP: // starf berry
    {
        int stat;
        for (stat = 0; stat < 5; stat++) {
            if (ctx->battleMons[ctx->battlerIdAttacker].statChanges[1 + stat] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                break;
            }
        }
        if (stat != 5) {
            do {
                stat = BattleSystem_Random(battleSystem) % 5;
            } while (ctx->battleMons[ctx->battlerIdAttacker].statChanges[1 + stat] == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
            ctx->msgTemp = stat + 1;
            script = BATTLE_SUBSCRIPT_HELD_ITEM_SHARPLY_RAISE_STAT;
        }
        ret = TRUE;
        break;
    }
    case STEAL_EFFECT_CRITRATE_UP: // apicot berry
        if (!(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_FOCUS_ENERGY)) {
            script = BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_CRIT;
        }
        ret = TRUE;
        break;
    case STEAL_EFFECT_ACC_UP: // micle berry
        script = BATTLE_SUBSCRIPT_HELD_ITEM_TEMP_ACC_UP;
        ret = TRUE;
        break;
    default:
        if (ItemIdIsBerry(ctx->battleMons[battlerId].item) == TRUE) {
            ret = TRUE;
        }
        break;
    }
    if (ret == TRUE) {
        if (GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_KLUTZ || (ctx->battleMons[ctx->battlerIdAttacker].moveEffectFlags & MOVE_EFFECT_FLAG_EMBARGO)) {
            ctx->tempData = 0;
        } else {
            ctx->tempData = script;
        }
        ctx->itemTemp = ctx->battleMons[battlerId].item;
        ctx->selfTurnData[ctx->battlerIdAttacker].unk14 |= (1 << 1);
        CudChewKeepsBerry(ctx, ctx->battlerIdAttacker, ctx->battleMons[battlerId].item);
        // The attacker eats it, and Belch counts it for the attacker, not for
        // the Pokemon it was plucked from (BtlCmd_RemoveItem).
        RememberBerryEaten(battleSystem, ctx, ctx->battlerIdAttacker);
        if (battlerId != ctx->battlerIdAttacker) {
            ctx->selfTurnData[battlerId].berryNotEaten = TRUE;
        }
    }

    return ret;
}

BOOL TryFling(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    int item = GetHeldItemFlingEffect(ctx, battlerId);
    int mod = GetHeldItemModifier(ctx, battlerId, 2);

    ctx->movePower = GetHeldItemFlingPower(ctx, battlerId);
    ctx->flingScript = 0;
    ctx->statChangeType = 0;

    // Nothing its species keeps is thrown, and nothing by a Klutz holder (the
    // reference's Fling check, BattleController_BeforeMove.c:1954 at
    // d0380a487; Pokemon Central, Lancio: it fails under Klutz, Embargo or
    // Magic Room, and GetHeldItemFlingPower answers Embargo).
    if (!ctx->movePower || GetBattlerAbility(ctx, battlerId) == ABILITY_KLUTZ
        || SpeciesKeepsItem(ctx->battleMons[battlerId].species, ctx->battleMons[battlerId].item)) {
        return FALSE;
    }

    switch (item) {
    case STEAL_EFFECT_RESTORE_HP: // oran berry
        ctx->flingData = mod;
        ctx->flingScript = 198;
        break;
    case STEAL_EFFECT_RESTORE_HP_PRCT: // sitrus berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp * mod, 100);
        ctx->flingScript = 198;
        break;
    case STEAL_EFFECT_CURE_PARALYSIS: // cheri berry
        if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_PARALYSIS) {
            ctx->flingScript = 199;
        }
        break;
    case STEAL_EFFECT_CURE_SLEEP: // chesto berry
        if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_SLEEP) {
            ctx->flingScript = 200;
        }
        break;
    case STEAL_EFFECT_CURE_POISON: // pecha berry
        if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_POISON_ALL) {
            ctx->flingScript = 201;
        }
        break;
    case STEAL_EFFECT_CURE_BURN: // rawst berry
        if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_BURN) {
            ctx->flingScript = 202;
        }
        break;
    case STEAL_EFFECT_CURE_FREEZE: // aspear berry
        if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_FREEZE) {
            ctx->flingScript = 203;
        }
        break;
    case STEAL_EFFECT_RESTORE_PP: // leppa berry
    {
        int ppCalc;
        int index;
        int max = 0;
        int maxIndex;
        for (index = 0; index < MAX_MON_MOVES; index++) {
            if (ctx->battleMons[ctx->battlerIdTarget].moves[index]) {
                ppCalc = GetMoveMaxPP(ctx->battleMons[ctx->battlerIdTarget].moves[index], ctx->battleMons[ctx->battlerIdTarget].movePP[index]) - ctx->battleMons[ctx->battlerIdTarget].movePPCur[index];
                if (ppCalc > max) {
                    max = ppCalc;
                    maxIndex = index;
                }
            }
        }
        // The PP is restored when the Berry lands (FlungItemLands).
        if (max) {
            ctx->moveTemp = ctx->battleMons[ctx->battlerIdTarget].moves[maxIndex];
            ctx->flingData = mod;
            ctx->flingScript = 204;
        }
        break;
    }
    case STEAL_EFFECT_CURE_CONFUSION: // persim berry
        if (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_CONFUSION) {
            ctx->flingScript = 205;
        }
        break;
    case STEAL_EFFECT_CURE_ALL: // lum berry
        if ((ctx->battleMons[ctx->battlerIdTarget].status & STATUS_ALL) || (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_CONFUSION)) {
            if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_PARALYSIS) {
                ctx->flingScript = 199;
            }
            if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_SLEEP) {
                ctx->flingScript = 200;
            }
            if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_POISON_ALL) {
                ctx->flingScript = 201;
            }
            if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_BURN) {
                ctx->flingScript = 202;
            }
            if (ctx->battleMons[ctx->battlerIdTarget].status & STATUS_FREEZE) {
                ctx->flingScript = 203;
            }
            if (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_CONFUSION) {
                ctx->flingScript = 205;
            }
            if ((ctx->battleMons[ctx->battlerIdTarget].status & STATUS_ALL) && (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_CONFUSION)) {
                ctx->flingScript = 206;
            }
        }
        break;
    case STEAL_EFFECT_RESTORE_SPICY: // figy berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, mod);
        ctx->msgTemp = 0;
        if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdTarget].personality, FLAVOR_SPICY) == -1) {
            ctx->flingScript = 207;
        } else {
            ctx->flingScript = 198;
        }
        break;
    case STEAL_EFFECT_RESTORE_DRY: // wiki berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, mod);
        ctx->msgTemp = 1;
        if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdTarget].personality, FLAVOR_DRY) == -1) {
            ctx->flingScript = 207;
        } else {
            ctx->flingScript = 198;
        }
        break;
    case STEAL_EFFECT_RESTORE_SWEET: // mago berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, mod);
        ctx->msgTemp = 2;
        if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdTarget].personality, FLAVOR_SWEET) == -1) {
            ctx->flingScript = 207;
        } else {
            ctx->flingScript = 198;
        }
        break;
    case STEAL_EFFECT_RESTORE_BITTER: // aguav berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, mod);
        ctx->msgTemp = 3;
        if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdTarget].personality, FLAVOR_BITTER) == -1) {
            ctx->flingScript = 207;
        } else {
            ctx->flingScript = 198;
        }
        break;
    case STEAL_EFFECT_RESTORE_SOUR: // iappapa berry
        ctx->flingData = DamageDivide(ctx->battleMons[ctx->battlerIdTarget].maxHp, mod);
        ctx->msgTemp = 4;
        if (GetFlavorPreferenceFromPID(ctx->battleMons[ctx->battlerIdTarget].personality, FLAVOR_SOUR) == -1) {
            ctx->flingScript = 207;
        } else {
            ctx->flingScript = 198;
        }
        break;
    case STEAL_EFFECT_RESET_STATS: // white herb, whose stats are reset when it lands (FlungItemLands)
    {
        int stat;
        for (stat = 0; stat < 8; stat++) {
            if (ctx->battleMons[ctx->battlerIdTarget].statChanges[stat] < 6) {
                ctx->flingScript = 211;
            }
        }
    } break;
    case STEAL_EFFECT_CURE_INFATUATION: // mental herb
        if (ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_ATTRACT) {
            ctx->msgTemp = 6;
            ctx->flingScript = 212;
        }
        break;
    case STEAL_EFFECT_FLINCH: // kings rock, razor fang
        ctx->battlerIdStatChange = battlerId;
        ctx->statChangeType = 2;
        ctx->flingScript = 14;
        break;
    case STEAL_EFFECT_PARALYZE: // light ball
        ctx->battlerIdStatChange = battlerId;
        ctx->statChangeType = 2;
        ctx->flingScript = 31;
        break;
    case STEAL_EFFECT_POISON: // poison barb
        ctx->battlerIdStatChange = battlerId;
        ctx->statChangeType = 2;
        ctx->flingScript = 22;
        break;
    case STEAL_EFFECT_BAD_POISON: // toxic orb
        ctx->battlerIdStatChange = battlerId;
        ctx->statChangeType = 2;
        ctx->flingScript = 47;
        break;
    case STEAL_EFFECT_BURN: // flame orb
        ctx->battlerIdStatChange = battlerId;
        ctx->statChangeType = 2;
        ctx->flingScript = 25;
        break;
    case STEAL_EFFECT_ATK_UP: // liechi berry
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[1] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 1;
            ctx->flingScript = 208;
        }
        break;
    case STEAL_EFFECT_DEF_UP: // ganlon berry
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[2] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 2;
            ctx->flingScript = 208;
        }
        break;
    case STEAL_EFFECT_SPEED_UP: // salac berry
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[3] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 3;
            ctx->flingScript = 208;
        }
        break;
    case STEAL_EFFECT_SPATK_UP: // petaya berry
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[4] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 4;
            ctx->flingScript = 208;
        }
        break;
    case STEAL_EFFECT_SPDEF_UP: // apicot berry
        if (ctx->battleMons[ctx->battlerIdTarget].statChanges[5] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
            ctx->msgTemp = 5;
            ctx->flingScript = 208;
        }
        break;
    case STEAL_EFFECT_RANDOM_UP: // starf berry
    {
        int stat;
        for (stat = 0; stat < 5; stat++) {
            if (ctx->battleMons[ctx->battlerIdTarget].statChanges[1 + stat] < BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE) {
                break;
            }
        }
        if (stat != 5) {
            do {
                stat = BattleSystem_Random(battleSystem) % 5;
            } while (ctx->battleMons[ctx->battlerIdTarget].statChanges[1 + stat] == BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);
            ctx->msgTemp = stat + 1;
            ctx->flingScript = 210;
        }
        break;
    }
    case STEAL_EFFECT_CRITRATE_UP: // apicot berry
        if (!(ctx->battleMons[ctx->battlerIdTarget].status2 & STATUS2_FOCUS_ENERGY)) {
            ctx->flingScript = 209;
        }
        break;
    case STEAL_EFFECT_ACC_UP: // micle berry
        ctx->flingScript = 265;
        break;
    default:
        break;
    }

    if (ctx->battleMons[ctx->battlerIdTarget].moveEffectFlags & MOVE_EFFECT_FLAG_EMBARGO) {
        ctx->flingScript = 0;
    } else {
        ctx->itemTemp = ctx->battleMons[battlerId].item;
        if (!ctx->statChangeType && ctx->flingScript) {
            ctx->selfTurnData[ctx->battlerIdAttacker].unk14 |= (1 << 1);
        }
        ctx->battlerIdTemp = ctx->battlerIdTarget;
    }
    // Thrown, not eaten by the thrower (BtlCmd_RemoveItem).
    ctx->selfTurnData[battlerId].berryNotEaten = TRUE;

    return TRUE;
}

void ov12_022565E0(BattleSystem *battleSystem, BattleContext *ctx) {
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_BOOST_REPEATED) {
        if (!(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_RAMPAGE) && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_UPROAR) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT) && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
            if (ctx->moveNoMetronome[ctx->battlerIdAttacker] == ctx->moveNoTemp) {
                if (ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns < 10) {
                    ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns++;
                }
            } else {
                ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns = 0;
                ctx->moveNoMetronome[ctx->battlerIdAttacker] = ctx->moveNoTemp;
            }
        }
    } else {
        ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns = 0;
    }
}

void ov12_02256694(BattleSystem *battleSystem, BattleContext *ctx) {
    if (GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_BOOST_REPEATED) {
        if ((ctx->moveStatusFlag & MOVE_STATUS_FAIL) && ctx->moveNoMetronome[ctx->battlerIdAttacker] == ctx->moveNoTemp && ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns && !(ctx->selfTurnData[ctx->battlerIdAttacker].rolloutCount) && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_RAMPAGE) && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_UPROAR) && !(ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT) && !(ctx->battleMons[ctx->battlerIdAttacker].status2 & STATUS2_LOCKED_INTO_MOVE)) {
            ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns--;
        }
    } else {
        ctx->battleMons[ctx->battlerIdAttacker].unk88.metronomeTurns = 0;
    }
}

// Related to send out Pokemon crys..?
int ov12_02256748(BattleContext *ctx, int battlerId, int battlerType, BOOL encounter) {
    int ret;
    int color;
    BOOL half;

    if (encounter == TRUE && (battlerType == 2 || battlerType == 3)) {
        half = TRUE;
    } else {
        half = FALSE;
    }

    ret = 0;

    if (half == TRUE) {
        ret = 0;
    }

    color = CalculateHpBarColor(ctx->battleMons[battlerId].hp, ctx->battleMons[battlerId].maxHp, 48);

    if ((ctx->battleMons[battlerId].status & STATUS_ALL) || (color != 4 && color != 3)) {
        ret = 11;
    }

    return ret;
}

BOOL Battler_CanSelectAction(BattleContext *ctx, int battlerId) {
    BOOL ret = TRUE;

    if ((ctx->battleMons[battlerId].status2 & STATUS2_RECHARGE) || (ctx->battleMons[battlerId].status2 & STATUS2_RAMPAGE) || (ctx->battleMons[battlerId].status2 & STATUS2_UPROAR) || (ctx->battleMons[battlerId].status2 & STATUS2_LOCKED_INTO_MOVE)) {
        ret = FALSE;
    }

    return ret;
}

void ov12_022567D4(BattleSystem *battleSystem, BattleContext *ctx, Pokemon *mon) {
    PlayerProfile *profile = BattleSystem_GetPlayerProfile(battleSystem, BATTLER_PLAYER);
    int location = BattleSystem_GetLocation(battleSystem);
    int terrain = BattleSystem_GetTerrainId(battleSystem);
    int ballId;

    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_PAL_PARK) {
        ballId = BallToItemId(BattleSystem_GetMonBall(battleSystem, mon));
    } else {
        ballId = ctx->itemTemp;
    }

    sub_020720FC(mon, profile, ballId, location, terrain, HEAP_ID_BATTLE);
}

u8 BattleBuffer_GetNext(BattleContext *ctx, int battlerId) {
    return ctx->battleBuffer[battlerId][0];
}

// Infiltrator's moves go round another Pokemon's substitute, every one of them
// but Transform and Sky Drop, from Generation VI (Pokemon Central, Intrapasso;
// the reference's CheckSubstitute, battle_script_commands.c:3716). A
// Pokemon's own substitute it still has to answer for.
BOOL InfiltratorGoesRoundSubstitute(BattleContext *ctx, int battlerId) {
    return battlerId != ctx->battlerIdAttacker && GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_INFILTRATOR
        && ctx->moveNoCur != MOVE_TRANSFORM && ctx->moveNoCur != MOVE_SKY_DROP;
}

// Whether the move in use reaches past another Pokemon's substitute with its
// own effects: an Infiltrator's, as above, and from the sixth generation any
// sound move that can hit something other than its user (Pokemon Central,
// Proprieta delle mosse) -- Growl, Sing, Supersonic, Confide, Parting Shot and
// the added effects of the damaging ones, as well as their damage (below).
// Spectral Thief goes round a substitute as a sound move does, its theft and
// its damage both (Pokemon Central, Ombrafurto).
BOOL MoveGoesRoundSubstitute(BattleContext *ctx, int battlerId) {
    return InfiltratorGoesRoundSubstitute(ctx, battlerId)
        || (battlerId != ctx->battlerIdAttacker && (BattleMoveIsSoundBased(ctx->moveNoCur) || ctx->moveNoCur == MOVE_SPECTRAL_THIEF));
}

// Whether a substitute takes this hit for the Pokemon behind it: an
// Infiltrator's hit and a sound move's go round it (ServerHPCalc.c:42 at
// d0380a487).
BOOL SubstituteTakesHit(BattleContext *ctx, int battlerId) {
    return (ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE) && !InfiltratorGoesRoundSubstitute(ctx, battlerId) && !BattleMoveIsSoundBased(ctx->moveNoCur)
        && ctx->moveNoCur != MOVE_SPECTRAL_THIEF;
}

BOOL BattlerCheckSubstitute(BattleContext *ctx, int battlerId) {
    BOOL ret = FALSE;

    // Infiltrator goes round a substitute rather than into it. Its own it
    // still has to answer for, so the attacker is excepted.
    if (battlerId != ctx->battlerIdAttacker && GetBattlerAbility(ctx, ctx->battlerIdAttacker) == ABILITY_INFILTRATOR) {
        return FALSE;
    }

    if (ctx->selfTurnData[battlerId].unk14 & (1 << 3)) {
        ret = TRUE;
    }

    return ret;
}

BOOL ov12_02256854(BattleSystem *battleSystem, BattleContext *ctx) {
    PlayerProfile *profile = BattleSystem_GetPlayerProfile(battleSystem, BATTLER_PLAYER);
    u32 trainerId = PlayerProfile_GetTrainerID(profile);
    u32 gender = PlayerProfile_GetTrainerGender(profile);
    const u16 *name = PlayerProfile_GetNamePtr(profile);

    if (trainerId == ctx->battleMons[ctx->battlerIdAttacker].otid && gender == ctx->battleMons[ctx->battlerIdAttacker].otGender && !StringNotEqualN(name, &ctx->battleMons[ctx->battlerIdAttacker].otName[0], PLAYER_NAME_LENGTH)) {
        return TRUE;
    }

    return FALSE;
}

BOOL ov12_022568B0(BattleSystem *battleSystem, Pokemon *mon) {
    PlayerProfile *profile = BattleSystem_GetPlayerProfile(battleSystem, BATTLER_PLAYER);
    u32 trainerId = PlayerProfile_GetTrainerID(profile);
    u32 gender = PlayerProfile_GetTrainerGender(profile);
    const u16 *name = PlayerProfile_GetNamePtr(profile);
    u16 otName[8];

    GetMonData(mon, MON_DATA_OT_NAME, otName);

    if (trainerId == GetMonData(mon, MON_DATA_OT_ID, NULL) && gender == GetMonData(mon, MON_DATA_OT_GENDER, NULL) && !StringNotEqualN(name, otName, PLAYER_NAME_LENGTH)) {
        return TRUE;
    }

    return FALSE;
}

// hg-engine's BattleFormChange (battle_pokemon.c:968). A form is a species of
// its own here, so the battler and the Pokemon behind it become that species;
// the stats, the types and the weight follow, and the ability too when asked.
// Not for a transformed battler, whose stats are the Pokemon it copied: the
// callers leave one alone.
void BattleSystem_ChangeBattlerForm(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u16 species, BOOL switchAbility) {
    Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerId, ctx->selectedMonIndex[battlerId]);
    struct PokedexData *dexData;

    Mon_ChangeFormSpecies(mon, species);
    if (switchAbility) {
        ctx->battleMons[battlerId].ability = GetMonData(mon, MON_DATA_ABILITY, NULL);
    }
    ctx->battleMons[battlerId].species = species;
    ctx->battleMons[battlerId].atk = GetMonData(mon, MON_DATA_ATK, NULL);
    ctx->battleMons[battlerId].def = GetMonData(mon, MON_DATA_DEF, NULL);
    ctx->battleMons[battlerId].speed = GetMonData(mon, MON_DATA_SPEED, NULL);
    ctx->battleMons[battlerId].spAtk = GetMonData(mon, MON_DATA_SP_ATK, NULL);
    ctx->battleMons[battlerId].spDef = GetMonData(mon, MON_DATA_SP_DEF, NULL);
    ctx->battleMons[battlerId].type1 = GetMonData(mon, MON_DATA_TYPE_1, NULL);
    ctx->battleMons[battlerId].type2 = GetMonData(mon, MON_DATA_TYPE_2, NULL);
    ctx->battleMons[battlerId].type3 = TYPE_NONE;
    ctx->battleMons[battlerId].abilityActivatedFlag = FALSE;

    dexData = PokedexData_Create(HEAP_ID_BATTLE);
    PokedexData_LoadAll(dexData, 0, HEAP_ID_BATTLE);
    ctx->battleMons[battlerId].weight = PokedexData_GetWeight(dexData, species);
    PokedexData_UnloadAll(dexData);
    PokedexData_Delete(dexData);
}

// Zen Mode (BattleFormChangeCheck.c:208): at half its HP or less a Darmanitan
// goes into its Zen Mode, and out of it above half or without the ability.
// The species to become, or SPECIES_NONE. hg-engine does not leave a
// transformed battler out, and its BattleFormChange then gave the copy its
// own stats back; the caller here leaves it alone.
static u16 Battler_ZenModeForm(BattleContext *ctx, int battlerId) {
    BOOL zen = GetBattlerAbility(ctx, battlerId) == ABILITY_ZEN_MODE
        && ctx->battleMons[battlerId].hp <= (s32)(ctx->battleMons[battlerId].maxHp / 2);

    switch (ctx->battleMons[battlerId].species) {
    case SPECIES_DARMANITAN:
        return zen ? SPECIES_DARMANITAN_ZEN_MODE : SPECIES_NONE;
    case SPECIES_DARMANITAN_GALARIAN:
        return zen ? SPECIES_DARMANITAN_ZEN_MODE_GALARIAN : SPECIES_NONE;
    case SPECIES_DARMANITAN_ZEN_MODE:
        return zen ? SPECIES_NONE : SPECIES_DARMANITAN;
    case SPECIES_DARMANITAN_ZEN_MODE_GALARIAN:
        return zen ? SPECIES_NONE : SPECIES_DARMANITAN_GALARIAN;
    }
    return SPECIES_NONE;
}

// Schooling (BattleFormChangeCheck.c:290): a Wishiwashi schools while its HP
// is above a quarter and breaks up at a quarter or less. hg-engine asks neither
// for the ability nor for the level, so a Wishiwashi below 20, or one that has
// lost the ability, schooled all the same; the ability says it cannot.
static u16 Battler_SchoolingForm(BattleContext *ctx, int battlerId) {
    BOOL school = GetBattlerAbility(ctx, battlerId) == ABILITY_SCHOOLING
        && ctx->battleMons[battlerId].level >= 20
        && ctx->battleMons[battlerId].hp > (s32)(ctx->battleMons[battlerId].maxHp / 4);

    switch (ctx->battleMons[battlerId].species) {
    case SPECIES_WISHIWASHI:
        return school ? SPECIES_WISHIWASHI_SCHOOL : SPECIES_NONE;
    case SPECIES_WISHIWASHI_SCHOOL:
        return school ? SPECIES_NONE : SPECIES_WISHIWASHI;
    }
    return SPECIES_NONE;
}

// Ice Face comes back (SwitchInAbilityCheck.c:933) in hail or snow: when the
// weather begins, or as the Eiscue comes in while it lasts, not on every check
// it goes on. Each check writes down whether the battler saw it. The species
// to become, or SPECIES_NONE; not for a transformed battler.
static u16 Battler_RestoredFaceForm(BattleSystem *battleSystem, BattleContext *ctx, int battlerId) {
    BOOL snowing = (ctx->fieldCondition & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL))
        && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE)
        && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK);
    BOOL seen = (ctx->iceFaceWeatherSeen & MaskOfFlagNo(battlerId)) != 0;

    if (snowing) {
        ctx->iceFaceWeatherSeen |= MaskOfFlagNo(battlerId);
    } else {
        ctx->iceFaceWeatherSeen &= ~MaskOfFlagNo(battlerId);
    }
    if (snowing && !seen && ctx->battleMons[battlerId].species == SPECIES_EISCUE_NOICE_FACE && ctx->battleMons[battlerId].hp
        && GetBattlerAbility(ctx, battlerId) == ABILITY_ICE_FACE && !(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_EISCUE;
    }
    return SPECIES_NONE;
}

// Relic Song (BattleFormChangeCheck.c:232): a Meloetta that has used it on a
// target turns from its Aria Forme to its Pirouette Forme or back, once the
// last hit is in. Not a transformed battler, which keeps the form it copied,
// and not one whose Sheer Force traded the song's sleep for power (Pokemon
// Central, Forzabruta); the reference does not ask the ability.
static u16 Battler_RelicSongForm(BattleContext *ctx, int battlerId) {
    if (battlerId != ctx->battlerIdAttacker || ctx->moveNoCur != MOVE_RELIC_SONG || !ctx->battleMons[battlerId].hp
        || (ctx->moveStatusFlag & MOVE_STATUS_FAILED) || !(ctx->relicSongTracker & MaskOfFlagNo(battlerId)) || ctx->multiHitCount > 1
        || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM) || SheerForceTradedEffect(ctx) == TRUE) {
        return SPECIES_NONE;
    }
    switch (ctx->battleMons[battlerId].species) {
    case SPECIES_MELOETTA:
        return SPECIES_MELOETTA_PIROUETTE;
    case SPECIES_MELOETTA_PIROUETTE:
        return SPECIES_MELOETTA;
    }
    return SPECIES_NONE;
}

// Gulp Missile (Pokemon Central, Inghiottimissile): a Cramorant catches its
// prey when its Surf reaches a target -- not one a Protect or an ability turned
// the move away from -- or when it goes under with Dive, whether or not the
// dive then lands: an Arrokuda above half its HP, a Pikachu at half or below.
// The catch is noted as it happens and shown with the form changes once the
// action is over (Battler_GulpMissileForm). Not a transformed Cramorant: the
// ability does nothing for a Pokemon that took Cramorant's shape with
// Transform or Imposter, and one that copied a Cramorant already holding its
// prey cannot spit it (Inghiottimissile). The reference declares the ability
// and reads it only in its lists of what cannot be copied.
void Battler_GulpMissileCatch(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].species != SPECIES_CRAMORANT || !ctx->battleMons[battlerId].hp || ctx->selfTurnData[battlerId].gulpMissilePrey
        || GetBattlerAbility(ctx, battlerId) != ABILITY_GULP_MISSILE || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return;
    }
    ctx->selfTurnData[battlerId].gulpMissilePrey = ctx->battleMons[battlerId].hp > (s32)(ctx->battleMons[battlerId].maxHp / 2) ? GULP_MISSILE_ARROKUDA : GULP_MISSILE_PIKACHU;
}

// The form a Cramorant takes for the prey it caught during the action: the
// Gulping Form with an Arrokuda, the Gorging Form with a Pikachu.
static u16 Battler_GulpMissileForm(BattleContext *ctx, int battlerId) {
    if (ctx->battleMons[battlerId].species != SPECIES_CRAMORANT || !ctx->battleMons[battlerId].hp) {
        return SPECIES_NONE;
    }
    switch (ctx->selfTurnData[battlerId].gulpMissilePrey) {
    case GULP_MISSILE_ARROKUDA:
        return SPECIES_CRAMORANT_GULPING;
    case GULP_MISSILE_PIKACHU:
        return SPECIES_CRAMORANT_GORGING;
    }
    return SPECIES_NONE;
}

// Genesect (BattleFormChangeCheck.c:248): the Drive it holds decides its form.
// hg-engine changes the battler's form alone, not the Pokemon's, and the
// forms' stats are the same, so here it is the battler's species alone. Not a
// transformed battler.
static u16 Battler_GenesectForm(BattleContext *ctx, int battlerId) {
    u16 species = ctx->battleMons[battlerId].species;
    u16 form;

    if (!ctx->battleMons[battlerId].hp || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)
        || (species != SPECIES_GENESECT && (species < SPECIES_GENESECT_DOUSE_DRIVE || species > SPECIES_GENESECT_CHILL_DRIVE))) {
        return SPECIES_NONE;
    }
    switch (ctx->battleMons[battlerId].item) {
    case ITEM_DOUSE_DRIVE:
        form = SPECIES_GENESECT_DOUSE_DRIVE;
        break;
    case ITEM_SHOCK_DRIVE:
        form = SPECIES_GENESECT_SHOCK_DRIVE;
        break;
    case ITEM_BURN_DRIVE:
        form = SPECIES_GENESECT_BURN_DRIVE;
        break;
    case ITEM_CHILL_DRIVE:
        form = SPECIES_GENESECT_CHILL_DRIVE;
        break;
    default:
        form = SPECIES_GENESECT;
        break;
    }
    return form == species ? SPECIES_NONE : form;
}

// Power Construct (BattleFormChangeCheck.c:273): a Zygarde of the Power
// Construct forms at half its HP or less becomes its Complete Forme. hg-engine
// keys it on the form alone; the ability is asked here, read off the battler as
// nothing can suppress it. Not a transformed battler.
static u16 Battler_PowerConstructForm(BattleContext *ctx, int battlerId) {
    if (!ctx->battleMons[battlerId].hp || ctx->battleMons[battlerId].hp > (s32)(ctx->battleMons[battlerId].maxHp / 2)
        || ctx->battleMons[battlerId].ability != ABILITY_POWER_CONSTRUCT || (ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)) {
        return SPECIES_NONE;
    }
    switch (ctx->battleMons[battlerId].species) {
    case SPECIES_ZYGARDE_10_POWER_CONSTRUCT:
        return SPECIES_ZYGARDE_10_COMPLETE;
    case SPECIES_ZYGARDE_50_POWER_CONSTRUCT:
        return SPECIES_ZYGARDE_50_COMPLETE;
    }
    return SPECIES_NONE;
}

BOOL Battler_CheckWeatherFormChange(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    int i;
    int form;
    u32 weather;
    BOOL ret = FALSE;

    for (i = 0; i < BattleSystem_GetMaxBattlers(battleSystem); i++) {
        ctx->battlerIdTemp = ctx->turnOrder[i];
        // A Utility Umbrella keeps Castform and Cherrim in the form they take
        // with no weather, in the rain or the sun (Superombrello).
        weather = WeatherUnderUmbrella(ctx, ctx->fieldCondition, ctx->battlerIdTemp);
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_CASTFORM && ctx->battleMons[ctx->battlerIdTemp].hp && GetBattlerAbility(ctx, ctx->battlerIdTemp) == ABILITY_FORECAST) {
            if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
                if (!(weather & FIELD_CONDITION_WEATHER_CASTFORM) && ctx->battleMons[ctx->battlerIdTemp].type1 != TYPE_NORMAL && ctx->battleMons[ctx->battlerIdTemp].type2 != TYPE_NORMAL) {
                    ctx->battleMons[ctx->battlerIdTemp].type1 = TYPE_NORMAL;
                    ctx->battleMons[ctx->battlerIdTemp].type2 = TYPE_NORMAL;
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CASTFORM_NORMAL;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_SUN_ALL) && ctx->battleMons[ctx->battlerIdTemp].type1 != TYPE_FIRE && ctx->battleMons[ctx->battlerIdTemp].type2 != TYPE_FIRE) {
                    ctx->battleMons[ctx->battlerIdTemp].type1 = TYPE_FIRE;
                    ctx->battleMons[ctx->battlerIdTemp].type2 = TYPE_FIRE;
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CASTFORM_SUNNY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_RAIN_ALL) && ctx->battleMons[ctx->battlerIdTemp].type1 != TYPE_WATER && ctx->battleMons[ctx->battlerIdTemp].type2 != TYPE_WATER) {
                    ctx->battleMons[ctx->battlerIdTemp].type1 = TYPE_WATER;
                    ctx->battleMons[ctx->battlerIdTemp].type2 = TYPE_WATER;
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CASTFORM_RAINY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_HAIL_ALL) && ctx->battleMons[ctx->battlerIdTemp].type1 != TYPE_ICE && ctx->battleMons[ctx->battlerIdTemp].type2 != TYPE_ICE) {
                    ctx->battleMons[ctx->battlerIdTemp].type1 = TYPE_ICE;
                    ctx->battleMons[ctx->battlerIdTemp].type2 = TYPE_ICE;
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CASTFORM_SNOWY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                }
            } else if (ctx->battleMons[ctx->battlerIdTemp].type1 != TYPE_NORMAL && ctx->battleMons[ctx->battlerIdTemp].type2 != TYPE_NORMAL) {
                ctx->battleMons[ctx->battlerIdTemp].type1 = TYPE_NORMAL;
                ctx->battleMons[ctx->battlerIdTemp].type2 = TYPE_NORMAL;
                ctx->battleMons[ctx->battlerIdTemp].form = (u8)CASTFORM_NORMAL;
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_CHERRIM && ctx->battleMons[ctx->battlerIdTemp].hp) {
            if (!CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_CLOUD_NINE) && !CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AIR_LOCK)) {
                if (!(weather & FIELD_CONDITION_WEATHER_CASTFORM) && ctx->battleMons[ctx->battlerIdTemp].form == (u8)CHERRIM_SUNNY) {
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CHERRIM_CLOUDY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_SUN_ALL) && ctx->battleMons[ctx->battlerIdTemp].form == (u8)CHERRIM_CLOUDY) {
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CHERRIM_SUNNY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_RAIN_ALL) && ctx->battleMons[ctx->battlerIdTemp].form == (u8)CHERRIM_SUNNY) {
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CHERRIM_CLOUDY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else if ((weather & FIELD_CONDITION_HAIL_ALL) && ctx->battleMons[ctx->battlerIdTemp].form == (u8)CHERRIM_SUNNY) {
                    ctx->battleMons[ctx->battlerIdTemp].form = (u8)CHERRIM_CLOUDY;
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                }
            } else if (ctx->battleMons[ctx->battlerIdTemp].form == (u8)CHERRIM_SUNNY) {
                ctx->battleMons[ctx->battlerIdTemp].form = (u8)CHERRIM_CLOUDY;
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_ARCEUS && ctx->battleMons[ctx->battlerIdTemp].hp && GetBattlerAbility(ctx, ctx->battlerIdTemp) == ABILITY_MULTITYPE) {
            form = GetArceusTypeByHeldItemEffect(GetItemAttr(ctx->battleMons[ctx->battlerIdTemp].item, ITEMATTR_HOLD_EFFECT, HEAP_ID_BATTLE));
            if (ctx->battleMons[ctx->battlerIdTemp].form != form) {
                ctx->battleMons[ctx->battlerIdTemp].form = form;
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
        // Silvally follows its Memory the way Arceus follows its plate. The
        // reference copies the Arceus block for it verbatim, plates and all,
        // and says in its own comment that it means to read memories instead;
        // RKS System reads the Memory (Pokemon Central, Sistema Primevo).
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_SILVALLY && ctx->battleMons[ctx->battlerIdTemp].hp && GetBattlerAbility(ctx, ctx->battlerIdTemp) == ABILITY_RKS_SYSTEM) {
            form = GetSilvallyTypeByHeldItemEffect(GetItemAttr(ctx->battleMons[ctx->battlerIdTemp].item, ITEMATTR_HOLD_EFFECT, HEAP_ID_BATTLE));
            if (ctx->battleMons[ctx->battlerIdTemp].form != form) {
                ctx->battleMons[ctx->battlerIdTemp].form = form;
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_GIRATINA && ctx->battleMons[ctx->battlerIdTemp].hp && ctx->battleMons[ctx->battlerIdTemp].form == GIRATINA_ORIGIN) {
            if ((ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM) || (!(BattleSystem_GetBattleSpecial(battleSystem) & BATTLE_SPECIAL_DISTORTION_WORLD) && !ItemGivesGiratinaOriginForm(ctx->battleMons[ctx->battlerIdTemp].item))) {
                if (ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM) {
                    Pokemon *mon2;
                    int battlerIdTarget;
                    int dat;

                    mon2 = AllocMonZeroed(HEAP_ID_BATTLE);

                    if (BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_DOUBLES) {
                        battlerIdTarget = ctx->playerActions[ctx->battlerIdTemp].unk4;
                    } else {
                        battlerIdTarget = ctx->battlerIdTemp ^ 1;
                    }
                    CopyPokemonToPokemon(BattleSystem_GetPartyMon(battleSystem, battlerIdTarget, ctx->selectedMonIndex[battlerIdTarget]), mon2);
                    dat = 0;
                    SetMonData(mon2, MON_DATA_HELD_ITEM, &dat);
                    dat = (u8)GIRATINA_ALTERED;
                    SetMonData(mon2, MON_DATA_FORM, &dat);
                    Mon_UpdateGiratinaForm(mon2);
                    ctx->battleMons[ctx->battlerIdTemp].atk = GetMonData(mon2, MON_DATA_ATK, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].def = GetMonData(mon2, MON_DATA_DEF, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].speed = GetMonData(mon2, MON_DATA_SPEED, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].spAtk = GetMonData(mon2, MON_DATA_SP_ATK, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].spDef = GetMonData(mon2, MON_DATA_SP_DEF, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].ability = GetMonData(mon2, MON_DATA_ABILITY, NULL);
                    ctx->battleMons[ctx->battlerIdTemp].form = GIRATINA_ALTERED;
                    ctx->battleStatus2 |= BATTLE_STATUS2_FORM_CHANGE;
                    BattleController_EmitBattleMonToPartyMonCopy(battleSystem, ctx, ctx->battlerIdTemp);
                    Heap_Free(mon2);
                    *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                    ret = TRUE;
                    break;
                } else {
                    *script = BATTLE_SUBSCRIPT_GIRATINA_FORM_CHANGE;
                    ret = TRUE;
                    break;
                }
            }
        }
        if (ctx->battleMons[ctx->battlerIdTemp].hp && !(ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM)) {
            form = Battler_ZenModeForm(ctx, ctx->battlerIdTemp);
            if (form != SPECIES_NONE) {
                BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, TRUE);
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
        form = Battler_RelicSongForm(ctx, ctx->battlerIdTemp);
        if (form != SPECIES_NONE) {
            ctx->relicSongTracker &= ~MaskOfFlagNo(ctx->battlerIdTemp);
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, TRUE);
            *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
            ret = TRUE;
            break;
        }
        form = Battler_GulpMissileForm(ctx, ctx->battlerIdTemp);
        if (form != SPECIES_NONE) {
            ctx->selfTurnData[ctx->battlerIdTemp].gulpMissilePrey = 0;
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, FALSE);
            *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
            ret = TRUE;
            break;
        }
        form = Battler_GenesectForm(ctx, ctx->battlerIdTemp);
        if (form != SPECIES_NONE) {
            ctx->battleMons[ctx->battlerIdTemp].species = form;
            *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
            ret = TRUE;
            break;
        }
        // Xerneas is always in its Active Mode (BattleFormChangeCheck.c:258),
        // whichever way it came in: a wild battle does not change the player's
        // on the way in, and it leaves the field in its Neutral Mode.
        if (ctx->battleMons[ctx->battlerIdTemp].species == SPECIES_XERNEAS && ctx->battleMons[ctx->battlerIdTemp].hp
            && !(ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM)) {
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, SPECIES_XERNEAS_ACTIVE, FALSE);
            *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
            ret = TRUE;
            break;
        }
        // The Complete Forme's maximum HP is higher, and so is its HP, by as
        // much: the subscript gives the difference. hg-engine gives it the
        // attacker's missing HP instead.
        form = Battler_PowerConstructForm(ctx, ctx->battlerIdTemp);
        if (form != SPECIES_NONE) {
            u32 maxHp = ctx->battleMons[ctx->battlerIdTemp].maxHp;

            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, FALSE);
            ctx->battleMons[ctx->battlerIdTemp].maxHp = GetMonData(BattleSystem_GetPartyMon(battleSystem, ctx->battlerIdTemp, ctx->selectedMonIndex[ctx->battlerIdTemp]), MON_DATA_MAX_HP, NULL);
            ctx->hpCalc = ctx->battleMons[ctx->battlerIdTemp].maxHp - maxHp;
            *script = BATTLE_SUBSCRIPT_POWER_CONSTRUCT;
            ret = TRUE;
            break;
        }
        form = Battler_RestoredFaceForm(battleSystem, ctx, ctx->battlerIdTemp);
        if (form != SPECIES_NONE) {
            BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, TRUE);
            *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
            ret = TRUE;
            break;
        }
        if (ctx->battleMons[ctx->battlerIdTemp].hp && !(ctx->battleMons[ctx->battlerIdTemp].status2 & STATUS2_TRANSFORM)) {
            form = Battler_SchoolingForm(ctx, ctx->battlerIdTemp);
            if (form != SPECIES_NONE) {
                BattleSystem_ChangeBattlerForm(battleSystem, ctx, ctx->battlerIdTemp, form, FALSE);
                *script = BATTLE_SUBSCRIPT_FORM_CHANGE;
                ret = TRUE;
                break;
            }
        }
    }

    return ret;
}

void ov12_02256F28(BattleSystem *battleSystem, BattleContext *ctx) {
    int battlerId;
    int index;

    for (battlerId = 0; battlerId < BattleSystem_GetMaxBattlers(battleSystem); battlerId++) {
        for (index = 0; index < 6; index++) {
            ctx->unk_312C[battlerId][index] = index;
        }
        ov12_02256F78(battleSystem, ctx, battlerId, ctx->selectedMonIndex[battlerId]);
    }
}

void ov12_02256F78(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u8 selectedMonIndex) {
    int index;
    int dat;
    int flag;
    u32 battleType = BattleSystem_GetBattleType(battleSystem);

    if (((battleType & BATTLE_TYPE_DOUBLES) && !(battleType & (BATTLE_TYPE_MULTI | BATTLE_TYPE_TAG))) || ((battleType & BATTLE_TYPE_TAG) && !(ov12_0223AB0C(battleSystem, battlerId) & 1))) {
        if (ov12_0223AB0C(battleSystem, battlerId) == 4 || ov12_0223AB0C(battleSystem, battlerId) == 5) {
            flag = 1;
        } else {
            flag = 0;
        }
        battlerId &= 1;
    } else {
        flag = 0;
    }

    for (index = 0; index < 6; index++) {
        if (ctx->unk_312C[battlerId][index] == selectedMonIndex) {
            break;
        }
    }

    dat = ctx->unk_312C[battlerId][flag];
    ctx->unk_312C[battlerId][flag] = ctx->unk_312C[battlerId][index];
    ctx->unk_312C[battlerId][index] = dat;
}

typedef struct MoveDamageCalc {
    u16 species;
    s16 hp;
    u16 maxHp;
    u16 unused;
    int item;
    int mod;
    u32 status;
    u16 ability;
    u8 gender;
    u8 type1;
    u8 type2;
} MoveDamageCalc;

static const u8 sTypeEnhancingItems[][2] = {
    { HOLD_EFFECT_STRENGTHEN_BUG,      TYPE_BUG      },
    { HOLD_EFFECT_STRENGTHEN_STEEL,    TYPE_STEEL    },
    { HOLD_EFFECT_STRENGTHEN_GROUND,   TYPE_GROUND   },
    { HOLD_EFFECT_STRENGTHEN_ROCK,     TYPE_ROCK     },
    { HOLD_EFFECT_STRENGTHEN_GRASS,    TYPE_GRASS    },
    { HOLD_EFFECT_STRENGTHEN_DARK,     TYPE_DARK     },
    { HOLD_EFFECT_STRENGTHEN_FIGHT,    TYPE_FIGHTING },
    { HOLD_EFFECT_STRENGTHEN_ELECTRIC, TYPE_ELECTRIC },
    { HOLD_EFFECT_STRENGTHEN_WATER,    TYPE_WATER    },
    { HOLD_EFFECT_STRENGTHEN_FLYING,   TYPE_FLYING   },
    { HOLD_EFFECT_STRENGTHEN_POISON,   TYPE_POISON   },
    { HOLD_EFFECT_STRENGTHEN_ICE,      TYPE_ICE      },
    { HOLD_EFFECT_STRENGTHEN_GHOST,    TYPE_GHOST    },
    { HOLD_EFFECT_STRENGTHEN_PSYCHIC,  TYPE_PSYCHIC  },
    { HOLD_EFFECT_STRENGTHEN_FIRE,     TYPE_FIRE     },
    { HOLD_EFFECT_STRENGTHEN_DRAGON,   TYPE_DRAGON   },
    { HOLD_EFFECT_STRENGTHEN_NORMAL,   TYPE_NORMAL   },
    { HOLD_EFFECT_ARCEUS_FIRE,         TYPE_FIRE     },
    { HOLD_EFFECT_ARCEUS_WATER,        TYPE_WATER    },
    { HOLD_EFFECT_ARCEUS_ELECTRIC,     TYPE_ELECTRIC },
    { HOLD_EFFECT_ARCEUS_GRASS,        TYPE_GRASS    },
    { HOLD_EFFECT_ARCEUS_ICE,          TYPE_ICE      },
    { HOLD_EFFECT_ARCEUS_FIGHTING,     TYPE_FIGHTING },
    { HOLD_EFFECT_ARCEUS_POISON,       TYPE_POISON   },
    { HOLD_EFFECT_ARCEUS_GROUND,       TYPE_GROUND   },
    { HOLD_EFFECT_ARCEUS_FLYING,       TYPE_FLYING   },
    { HOLD_EFFECT_ARCEUS_PSYCHIC,      TYPE_PSYCHIC  },
    { HOLD_EFFECT_ARCEUS_BUG,          TYPE_BUG      },
    { HOLD_EFFECT_ARCEUS_ROCK,         TYPE_ROCK     },
    { HOLD_EFFECT_ARCEUS_GHOST,        TYPE_GHOST    },
    { HOLD_EFFECT_ARCEUS_DRAGON,       TYPE_DRAGON   },
    { HOLD_EFFECT_ARCEUS_DARK,         TYPE_DARK     },
    { HOLD_EFFECT_ARCEUS_STEEL,        TYPE_STEEL    },
    // The Blank Plate is the Normal plate: a fifth more on Normal moves, the
    // row the reference's HeldItemPowerUpTable ends its plates with
    // (other_battle_calculators.c:81 at d0380a487). Arceus's type and
    // Judgment's are Normal with it already, which is what no plate gives.
    { HOLD_EFFECT_ARCEUS_NORMAL,       TYPE_NORMAL   },
    // The Fairy pair. The reference keeps them behind the switch that says
    // whether the Fairy type exists at all, which is why they are last rather
    // than beside their own kind; this game has the type, so they are simply
    // two more rows. The Pixie Plate comes with the Feather because it is the
    // same missing pair in the reference's own table.
    { HOLD_EFFECT_STRENGTHEN_FAIRY,    TYPE_FAIRY    },
    { HOLD_EFFECT_ARCEUS_FAIRY,        TYPE_FAIRY    }
};

static const u8 sStatChangeTable[][2] = {
    { 10, 40 },
    { 10, 35 },
    { 10, 30 },
    { 10, 25 },
    { 10, 20 },
    { 10, 15 },
    { 10, 10 },
    { 15, 10 },
    { 20, 10 },
    { 25, 10 },
    { 30, 10 },
    { 35, 10 },
    { 40, 10 }
};

static const u16 sPunchingMoves[] = {
    MOVE_BULLET_PUNCH,
    MOVE_COMET_PUNCH,
    MOVE_DIZZY_PUNCH,
    MOVE_DOUBLE_IRON_BASH,
    MOVE_DRAIN_PUNCH,
    MOVE_DYNAMIC_PUNCH,
    MOVE_FIRE_PUNCH,
    MOVE_FOCUS_PUNCH,
    MOVE_HAMMER_ARM,
    MOVE_HEADLONG_RUSH,
    MOVE_ICE_HAMMER,
    MOVE_ICE_PUNCH,
    MOVE_JET_PUNCH,
    MOVE_MACH_PUNCH,
    MOVE_MEGA_PUNCH,
    MOVE_METEOR_MASH,
    MOVE_PLASMA_FISTS,
    MOVE_POWER_UP_PUNCH,
    MOVE_RAGE_FIST,
    MOVE_SHADOW_PUNCH,
    MOVE_SKY_UPPERCUT,
    MOVE_SURGING_STRIKES,
    MOVE_THUNDER_PUNCH,
    MOVE_WICKED_BLOW,
};

static BOOL BattleMoveIsPunching(u32 moveNo) {
    return MoveIsInList(moveNo, sPunchingMoves, NELEMS(sPunchingMoves));
}

static const u16 sBitingMoves[] = {
    MOVE_BITE,
    MOVE_CRUNCH,
    MOVE_FIRE_FANG,
    MOVE_FISHIOUS_REND,
    MOVE_HYPER_FANG,
    MOVE_ICE_FANG,
    MOVE_JAW_LOCK,
    MOVE_POISON_FANG,
    MOVE_PSYCHIC_FANGS,
    MOVE_THUNDER_FANG
};

// Heal Pulse is a status move and so never reaches a damage calculation, but
// it is in the reference's table and staying faithful costs nothing.
static const u16 sPulseMoves[] = {
    MOVE_AURA_SPHERE,
    MOVE_DARK_PULSE,
    MOVE_DRAGON_PULSE,
    MOVE_HEAL_PULSE,
    MOVE_ORIGIN_PULSE,
    MOVE_TERRAIN_PULSE,
    MOVE_WATER_PULSE
};

int CalcMoveDamage(BattleSystem *battleSystem, BattleContext *ctx, u32 moveNo, u32 sideCondition, u32 fieldCondition, u16 power, u8 type, u8 battlerIdAttacker, u8 battlerIdTarget, u8 crit) {
    u32 weather;
    u32 weatherOnTarget;
    int i;
    s32 dmg = 0;
    s32 dmg2 = 0;
    u8 moveType;
    u8 moveCategory;
    u16 monAtk;
    u16 monDef;
    u16 monSpAtk;
    u16 monSpDef;
    s8 statChangeAtk;
    s8 statChangeDef;
    s8 statChangeSpAtk;
    s8 statChangeSpDef;
    u8 level;
    u16 movePower;
    u16 item;
    int maxBattlers;
    MoveDamageCalc calcAttacker;
    MoveDamageCalc calcTarget;

    GF_ASSERT(crit == 1 || crit > 1);

    // Foul Play strikes with the target's Attack and its stages, Body Press
    // with the user's Defense and its stages; everything else that works on
    // an Attack -- the user's ability and item, a burn, the target's Unaware
    // -- works on them as on the user's own (Pokemon Central, Ripicca,
    // Schiacciacorpo). The reference's CalcBaseDamage swaps the stages in
    // after its Unaware step, where the target's Unaware would ignore them.
    monAtk = GetBattlerVar(ctx, moveNo == MOVE_FOUL_PLAY ? battlerIdTarget : battlerIdAttacker, moveNo == MOVE_BODY_PRESS ? BMON_DATA_DEF : BMON_DATA_ATK, NULL);
    monDef = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_DEF, NULL);
    monSpAtk = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_SPATK, NULL);
    monSpDef = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_SPDEF, NULL);
    // Wonder Room swaps the two defences, the stats and not their stages:
    // a physical hit meets the Sp. Def with the Defense's stage (Pokemon
    // Central, Mirabilzona).
    if (ctx->wonderRoomTurns) {
        u16 swap = monDef;

        monDef = monSpDef;
        monSpDef = swap;
    }
    statChangeAtk = GetBattlerVar(ctx, moveNo == MOVE_FOUL_PLAY ? battlerIdTarget : battlerIdAttacker, moveNo == MOVE_BODY_PRESS ? BMON_DATA_STAT_CHANGE_DEF : BMON_DATA_STAT_CHANGE_ATK, NULL) - 6;
    statChangeDef = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_STAT_CHANGE_DEF, NULL) - 6;
    statChangeSpAtk = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_STAT_CHANGE_SPATK, NULL) - 6;
    statChangeSpDef = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_STAT_CHANGE_SPDEF, NULL) - 6;
    level = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_LEVEL, NULL);
    calcAttacker.species = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_SPECIES, NULL);
    calcTarget.species = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_SPECIES, NULL);
    calcAttacker.hp = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_HP, NULL);
    calcTarget.hp = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_HP, NULL);
    calcAttacker.maxHp = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_MAXHP, NULL);
    calcTarget.maxHp = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_MAXHP, NULL);
    calcAttacker.status = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_STATUS, NULL);
    calcTarget.status = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_STATUS, NULL);
    calcAttacker.ability = GetBattlerAbility(ctx, battlerIdAttacker);
    calcTarget.ability = GetBattlerAbility(ctx, battlerIdTarget);
    calcAttacker.gender = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_GENDER, NULL);
    calcTarget.gender = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_GENDER, NULL);
    calcAttacker.type1 = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_TYPE_1, NULL);
    calcTarget.type1 = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_1, NULL);
    calcAttacker.type2 = GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_TYPE_2, NULL);
    calcTarget.type2 = GetBattlerVar(ctx, battlerIdTarget, BMON_DATA_TYPE_2, NULL);

    item = GetBattlerHeldItem(ctx, battlerIdAttacker);
    calcAttacker.item = GetItemVar(ctx, item, ITEM_VAR_HOLD_EFFECT);
    calcAttacker.mod = GetItemVar(ctx, item, ITEM_VAR_MODIFIER);

    item = GetBattlerHeldItem(ctx, battlerIdTarget);
    calcTarget.item = GetItemVar(ctx, item, ITEM_VAR_HOLD_EFFECT);
    calcTarget.mod = GetItemVar(ctx, item, ITEM_VAR_MODIFIER);

    maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    // Hidden Power is the table's 60 whatever the IVs. The battle command and
    // the AI both still work a power out of them, 30 to 70, and pass it in;
    // the reference overrules it in its damage calculation the same way.
    if (power == 0 || moveNo == MOVE_HIDDEN_POWER) {
        movePower = BattleMoveTbl(ctx, moveNo)->power;
    } else {
        movePower = power;
    }

    // Return and Frustration are worth what the Pokemon thinks of its
    // trainer, worked out here as the reference's CalcBaseDamage does rather
    // than in their effect scripts. Asked by effect, not by move as the
    // reference does: Pika Papow and Veevee Volley share Return's, with a
    // table power of 0 the reference then uses.
    if (BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_POWER_BASED_ON_FRIENDSHIP) {
        movePower = ctx->battleMons[battlerIdAttacker].friendship * 10 / 25;
    } else if (BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_POWER_BASED_ON_LOW_FRIENDSHIP) {
        movePower = (255 - ctx->battleMons[battlerIdAttacker].friendship) * 10 / 25;
    }

    // Triple Kick and Triple Axel strike harder each time, ten and twenty
    // times the strike it is, counted from the strikes left (the reference's
    // CalcBaseDamage) rather than added up in their effect scripts. Outside
    // the move the count is 0 and the table's first strike stands.
    if (ctx->multiHitCount != 0) {
        if (moveNo == MOVE_TRIPLE_KICK) {
            movePower = 10 * (4 - ctx->multiHitCount);
        } else if (moveNo == MOVE_TRIPLE_AXEL) {
            movePower = 20 * (4 - ctx->multiHitCount);
        }
    }

    // Assurance doubles against a Pokemon already hurt this turn, which
    // UPDATE_HP writes down for it (the reference's CalcBaseDamage).
    if (moveNo == MOVE_ASSURANCE && ctx->turnData[battlerIdTarget].unk3C) {
        movePower *= 2;
    }

    // Payback doubles against a Pokemon that has already acted this turn
    // (the reference's CalcBaseDamage, asking the same IsMovingAfterClient),
    // but not against one that came in during it: from the fifth generation a
    // switch is no longer an action it answers (Pokemon Central, Rivincita).
    // The reference's comment says as much, but the question it asks is
    // retail's, which a switch-in answers yes.
    if (moveNo == MOVE_PAYBACK && ov12_0225561C(ctx, battlerIdTarget) == TRUE && !ctx->turnData[battlerIdTarget].switchedIn) {
        movePower *= 2;
    }

    // Echoed Voice is 40 more for each turn in a row before this one that
    // someone used it, 200 at the most (Pokemon Central, Echeggiavoce).
    if (moveNo == MOVE_ECHOED_VOICE) {
        movePower = movePower * (1 + ctx->echoedVoiceTurns);
    }

    // Every Round in a turn but the first is 120 (Pokemon Central, Coro).
    if (moveNo == MOVE_ROUND && (ctx->roundUsers & ~MaskOfFlagNo(battlerIdAttacker))) {
        movePower *= 2;
    }

    // Rage Fist is 50 more for each hit its user has taken in this battle, 350
    // at most after six (Pokemon Central, Pugno Furibondo).
    if (moveNo == MOVE_RAGE_FIST) {
        movePower = movePower * (1 + *Battler_RageFistHits(battleSystem, ctx, battlerIdAttacker));
    }

    // Last Respects is 50 more for each time a Pokemon of the user's own party
    // has fainted in this battle, a revived one again each time, to 5050 after
    // a hundred; a multi battle partner's do not count (Pokemon Central,
    // Omaggio ai KO).
    if (moveNo == MOVE_LAST_RESPECTS) {
        int fallen = BattlerPartyFaintCount(battleSystem, ctx, battlerIdAttacker);

        movePower = movePower * (1 + (fallen > 100 ? 100 : fallen));
    }

    // Fusion Flare doubles when the last move anyone used this turn was
    // Fusion Bolt, and Fusion Bolt when it was Fusion Flare (Pokemon Central,
    // Incrofiamma, Incrotuono). The move being used is the last by now, so
    // the one before it is asked.
    if ((moveNo == MOVE_FUSION_FLARE && ctx->moveUsedBefore == MOVE_FUSION_BOLT)
        || (moveNo == MOVE_FUSION_BOLT && ctx->moveUsedBefore == MOVE_FUSION_FLARE)) {
        movePower *= 2;
    }

    moveType = BattleMoveTypeForAbility(ctx, battlerIdAttacker, calcAttacker.ability, moveNo, type & 0x3F);

    GF_ASSERT(ctx->unk_2158 >= 10);
    movePower = movePower * ctx->unk_2158 / 10;

    // Two moves whose own power is a question about the terrain rather than a
    // number in the table. They are decided here, with the rest of what the
    // move is worth before anything modifies it -- the reference settles them
    // in the same place, ahead of its base-power modifiers, which is why Rising
    // Voltage can be written out flat without eating a Helping Hand.
    //
    // Rising Voltage asks only whether the current is on, not whether anyone is
    // standing in it. That is the reference's version of the move.
    if (moveNo == MOVE_RISING_VOLTAGE && ctx->terrainOverlayType == ELECTRIC_TERRAIN) {
        movePower = 140;
    }
    if (moveNo == MOVE_TERRAIN_PULSE && ctx->terrainOverlayType != TERRAIN_NONE && BattlerIsGrounded(ctx, battlerIdAttacker) == TRUE) {
        movePower *= 2;
    }
    // Ash-Greninja's Water Shuriken is 20 a hit. The reference asks for
    // Greninja's form 1, the Battle Bond form in its numbering, not Ash.
    if (moveNo == MOVE_WATER_SHURIKEN && ctx->battleMons[battlerIdAttacker].species == SPECIES_GRENINJA_ASH) {
        movePower = 20;
    }

    // Smelling Salts doubles against a paralysed target and Wake-Up Slap
    // against a sleeping one, or one with Comatose, which the reference reads
    // against the target itself, so with no Mold Breaker gate; neither against
    // a substitute that takes the hit (CalcBaseDamage.c:294 and 305 at
    // d0380a487). The cure is a post-move step (TryAdditionalMoveEffect).
    if (!SubstituteTakesHit(ctx, battlerIdTarget) && !BattlerCheckSubstitute(ctx, battlerIdTarget)) {
        switch (BattleMoveTbl(ctx, moveNo)->effect) {
        case MOVE_EFFECT_DOUBLE_POWER_AND_CURE_PARALYSIS:
            if (calcTarget.status & STATUS_PARALYSIS) {
                movePower *= 2;
            }
            break;
        case MOVE_EFFECT_DOUBLE_POWER_HEAL_SLEEP:
            if ((calcTarget.status & STATUS_SLEEP) || calcTarget.ability == ABILITY_COMATOSE) {
                movePower *= 2;
            }
            break;
        }
    }

    // Lash Out doubles when a stat of the user's has been lowered this turn
    // (Pokemon Central, Sfogarabbia; CalcBaseDamage.c:498 at d0380a487). What
    // only swaps, copies or resets stages lowers nothing.
    if (moveNo == MOVE_LASH_OUT && ctx->moveConditions[battlerIdAttacker].statLoweredThisTurn) {
        movePower *= 2;
    }

    if ((ctx->battleMons[battlerIdAttacker].moveEffectFlags & MOVE_EFFECT_FLAG_CHARGE) && moveType == TYPE_ELECTRIC) {
        movePower *= 2;
    }

    // Me First's half again, on the power where the reference puts it. Whether
    // the copied move is still this turn's is kept up to date by
    // DamageCalcDefault; this only reads it, so the AI can ask too.
    if (ctx->battleMons[battlerIdAttacker].unk88.meFirstFlag && (ctx->meFirstTotal - ctx->battleMons[battlerIdAttacker].unk88.meFirstCount) < 2) {
        movePower = movePower * 15 / 10;
    }

    if (ctx->turnData[battlerIdAttacker].helpingHandFlag) {
        movePower = movePower * 15 / 10;
    }

    // Knock Off hits half again as hard when there is an item it could knock
    // off, from the sixth generation on: 65 becomes 97. The reference
    // multiplies it in with Helping Hand's among its base-power modifiers.
    if (moveNo == MOVE_KNOCK_OFF && KnockOffCanRemoveItem(ctx, battlerIdAttacker, battlerIdTarget)) {
        movePower = movePower * 15 / 10;
    }

    if (calcAttacker.ability == ABILITY_TECHNICIAN && moveNo != MOVE_STRUGGLE && movePower <= 60) {
        movePower = movePower * 15 / 10;
    }

    // Reckless: a fifth more power for a move that costs its user recoil
    // (Pokemon Central, Temerarieta), among the ability modifiers, where the
    // engine has it (CalcBaseDamage.c:691 at d0380a487). The engine's list
    // also names the moves that crash on a miss; their scripts still ask for
    // the fifth through POWER_MULTI, here as in the engine (whose
    // CalcBaseDamage no longer reads it), so they are left to the scripts.
    // The engine's list names Chloroblast's effect too; its recoil is Rock
    // Head's to stop but not Reckless's to pay for (Pokemon Central,
    // Clorofillaser: the ninth generation's move is not boosted by it).
    if (calcAttacker.ability == ABILITY_RECKLESS) {
        switch (BattleMoveTbl(ctx, moveNo)->effect) {
        case MOVE_EFFECT_RECOIL_QUARTER_DAMAGE_DELT:
        case MOVE_EFFECT_RECOIL_THIRD:
        case MOVE_EFFECT_RECOIL_BURN_HIT:
        case MOVE_EFFECT_RECOIL_PARALYZE_HIT:
        case MOVE_EFFECT_RECOIL_HALF:
            movePower = movePower * 12 / 10;
            break;
        }
    }

    // Order Up is always worth Sheer Force's boost, and gives nothing up for
    // it (Pokemon Central, Alta Cucina).
    if (calcAttacker.ability == ABILITY_SHEER_FORCE && (IsSuppressibleSecondaryEffect(ctx, moveNo) == TRUE || moveNo == MOVE_ORDER_UP)) {
        movePower = movePower * 13 / 10;
    }

    if (calcAttacker.ability == ABILITY_SHARPNESS && MoveIsInList(moveNo, sSlicingMoves, NELEMS(sSlicingMoves)) == TRUE) {
        movePower = movePower * 15 / 10;
    }

    // The -ate abilities pay 20% for the type they changed, and only for the
    // change: a natively Flying move an Aerilate holder already had gets
    // nothing, which is why the move table's own type is what is tested.
    if (BattleMoveTbl(ctx, moveNo)->type == TYPE_NORMAL
        && ((calcAttacker.ability == ABILITY_AERILATE && moveType == TYPE_FLYING)
            || (calcAttacker.ability == ABILITY_PIXILATE && moveType == TYPE_FAIRY)
            || (calcAttacker.ability == ABILITY_REFRIGERATE && moveType == TYPE_ICE)
            || (calcAttacker.ability == ABILITY_GALVANIZE && moveType == TYPE_ELECTRIC)
            || (calcAttacker.ability == ABILITY_DRAGONIZE && moveType == TYPE_DRAGON))) {
        movePower = movePower * 12 / 10;
    }

    // Analytic wants the attacker to be moving last, and the reference asks
    // that as a speed question rather than by remembering who has already
    // gone: no living battler may be slower than the attacker. These are the
    // speeds the turn order was sorted with. CheckSortSpeed must not be
    // called from in here to ask again -- it consumes a random number on a
    // tie, which would desync a link battle from inside the damage maths.
    if (calcAttacker.ability == ABILITY_ANALYTIC) {
        BOOL movingLast = TRUE;

        for (i = 0; i < maxBattlers; i++) {
            if (i != battlerIdAttacker && ctx->battleMons[i].hp && ctx->effectiveSpeed[i] < ctx->effectiveSpeed[battlerIdAttacker]) {
                movingLast = FALSE;
                break;
            }
        }

        if (movingLast == TRUE) {
            movePower = movePower * 13 / 10;
        }
    }

    // Tough Claws asks the move table's contact bit, which is as much as this
    // game knows about contact: nothing here can take contact away yet.
    if (calcAttacker.ability == ABILITY_TOUGH_CLAWS && BattleMoveMakesContact(ctx, moveNo) == TRUE) {
        movePower = movePower * 13 / 10;
    }

    // Flare Boost pays for the burn in base power rather than in Attack, so
    // it helps a special move and does not excuse the holder from the burn's
    // own halving, which DamageCalcDefault applies after the roll.
    if (calcAttacker.ability == ABILITY_FLARE_BOOST && (calcAttacker.status & STATUS_BURN)) {
        movePower = movePower * 15 / 10;
    }

    // Toxic Boost takes either kind of poison, named bit by bit rather than
    // through STATUS_POISON_ALL, which would fold in the badly-poisoned turn
    // counter and fire on a Pokemon that is not poisoned at all.
    if (calcAttacker.ability == ABILITY_TOXIC_BOOST && (calcAttacker.status & (STATUS_POISON | STATUS_BAD_POISON))) {
        movePower = movePower * 15 / 10;
    }

    if (calcAttacker.ability == ABILITY_STRONG_JAW && MoveIsInList(moveNo, sBitingMoves, NELEMS(sBitingMoves)) == TRUE) {
        movePower = movePower * 15 / 10;
    }

    if (calcAttacker.ability == ABILITY_MEGA_LAUNCHER && MoveIsInList(moveNo, sPulseMoves, NELEMS(sPulseMoves)) == TRUE) {
        movePower = movePower * 15 / 10;
    }

    // Punk Rock's other half, the halving of an incoming sound move, is in the
    // final modifier in battle_command.c. Both read the one sound move table
    // Soundproof reads, so the three cannot disagree about what a sound move is.
    if (calcAttacker.ability == ABILITY_PUNK_ROCK && BattleMoveIsSoundBased(moveNo) == TRUE) {
        movePower = movePower * 13 / 10;
    }

    if (moveType == TYPE_STEEL && calcAttacker.ability == ABILITY_STEELY_SPIRIT) {
        movePower = movePower * 15 / 10;
    }

    // Supreme Overlord: a tenth more power for each of the fallen it counted
    // on the way in, 4096 and 410 more each up to 6144 in the later games.
    if (calcAttacker.ability == ABILITY_SUPREME_OVERLORD) {
        movePower = movePower * (10 + ctx->supremeOverlordFallen[battlerIdAttacker]) / 10;
    }

    // The terrain laid over the battle, which the reference weighs here among
    // the field effects, after the abilities. A boost is for whoever is
    // standing on the terrain, so it asks about the attacker; Misty Terrain's
    // halving of a Dragon move asks about the target, because it is the mist
    // around the target that softens the blow. The three Ground moves the grass
    // muffles are named rather than typed -- it is the ground itself they
    // shake, which is why Earth Power is not among them.
    //
    // Expanding Force and Misty Explosion are here for the same reason the
    // weather's Solar Beam is: their half again is a modifier, not a power of
    // their own. Neither asks for anyone to be standing on the terrain.
    switch (ctx->terrainOverlayType) {
    case GRASSY_TERRAIN:
        if (moveType == TYPE_GRASS && BattlerIsGrounded(ctx, battlerIdAttacker) == TRUE) {
            movePower = movePower * 13 / 10;
        }
        if (moveNo == MOVE_EARTHQUAKE || moveNo == MOVE_MAGNITUDE || moveNo == MOVE_BULLDOZE) {
            movePower /= 2;
        }
        break;
    case ELECTRIC_TERRAIN:
        if (moveType == TYPE_ELECTRIC && BattlerIsGrounded(ctx, battlerIdAttacker) == TRUE) {
            movePower = movePower * 13 / 10;
        }
        break;
    case MISTY_TERRAIN:
        if (moveType == TYPE_DRAGON && BattlerIsGrounded(ctx, battlerIdTarget) == TRUE) {
            movePower /= 2;
        }
        if (moveNo == MOVE_MISTY_EXPLOSION) {
            movePower = movePower * 15 / 10;
        }
        break;
    case PSYCHIC_TERRAIN:
        if (moveType == TYPE_PSYCHIC && BattlerIsGrounded(ctx, battlerIdAttacker) == TRUE) {
            movePower = movePower * 13 / 10;
        }
        if (moveNo == MOVE_EXPANDING_FORCE) {
            movePower = movePower * 15 / 10;
        }
        break;
    }

    moveCategory = BattleMoveCategory(ctx, moveNo, battlerIdAttacker);

    // Three base-power abilities belong to the attacker's ALLY, so they exist
    // only in a double battle -- the slot two over is stale rather than empty
    // in a single one, which is what the maxBattlers guard is for. The ally's
    // Steely Spirit is a second boost and not an else: with the pair of them
    // out a Steel move is boosted twice, as the reference has it.
    {
        int ally = battlerIdAttacker ^ 2;

        if (ally < maxBattlers && ctx->battleMons[ally].hp) {
            if (moveCategory == CATEGORY_SPECIAL && GetBattlerAbility(ctx, ally) == ABILITY_BATTERY) {
                movePower = movePower * 4 / 3;
            }
            // Power Spot: three tenths on every move the ally uses, never on
            // the holder's own (Pokemon Central, Fonte Energetica: 5325/4096).
            // The reference reads the ally's ability without asking whether
            // it is still standing, so a fainted Stonjourner went on helping.
            if (GetBattlerAbility(ctx, ally) == ABILITY_POWER_SPOT) {
                movePower = movePower * 13 / 10;
            }
            if (moveType == TYPE_STEEL && GetBattlerAbility(ctx, ally) == ABILITY_STEELY_SPIRIT) {
                movePower = movePower * 15 / 10;
            }
        }
    }

    if (calcAttacker.ability == ABILITY_HUGE_POWER || calcAttacker.ability == ABILITY_PURE_POWER) {
        monAtk *= 2;
    }

    // Stakeout doubles the attacking stat against a target that came in this
    // turn, whether by its own switch, a U-turn or a Roar, but not against one
    // that has stood there since the battle began (Pokemon Central,
    // Sorveglianza). Loading a Pokemon into its slot sets its Fake Out turn
    // to the turn after the current one, so that is the test. The reference
    // doubles the move's power instead, and asks whether the target's action
    // this turn has been spent, which is also true after it used an item or
    // failed to run, and not after it was dragged in.
    if (calcAttacker.ability == ABILITY_STAKEOUT && ctx->battleMons[battlerIdTarget].unk88.fakeOutCount == ctx->totalTurns + 1) {
        monAtk *= 2;
        monSpAtk *= 2;
    }

    // Tablets of Ruin weakens every Attack but its own bearer's. The
    // reference lowers the attacker's Attack while reading the DEFENDER's
    // ability for the exemption -- a copy of the Sword of Ruin block below,
    // where the defender is the right side -- so there a Wo-Chien weakens
    // itself and is spared only by facing another one. That is a slip, not a
    // rule, and the exemption here is the attacker's, as the ability says.
    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_TABLETS_OF_RUIN) && calcAttacker.ability != ABILITY_TABLETS_OF_RUIN) {
        monAtk = monAtk * 3 / 4;
    }

    // Gorilla Tactics is a Choice Band the Pokemon was born with. The other
    // half of it, the move lock, is in StruggleCheck.
    if (calcAttacker.ability == ABILITY_GORILLA_TACTICS) {
        monAtk = monAtk * 150 / 100;
    }

    if (calcAttacker.ability == ABILITY_SLOW_START && (int)(ov12_022581D4(battleSystem, ctx, 3, 0) - GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_SLOW_START_TURN_NUMBER, NULL)) < 5) {
        monAtk /= 2;
    }

    // Defeatist gives up at half health, and gives up on both stats: the
    // reference halves the modifier that whichever stat the move reads is
    // about to be multiplied by, with no split or type condition at all.
    if (calcAttacker.ability == ABILITY_DEFEATIST && calcAttacker.hp <= calcAttacker.maxHp / 2) {
        monAtk /= 2;
        monSpAtk /= 2;
    }

    for (i = 0; i < NELEMS(sTypeEnhancingItems); i++) {
        if (calcAttacker.item == sTypeEnhancingItems[i][0] && moveType == sTypeEnhancingItems[i][1]) {
            movePower = movePower * (100 + calcAttacker.mod) / 100;
            break;
        }
    }

    if (calcAttacker.item == HOLD_EFFECT_CHOICE_ATK) {
        monAtk = monAtk * 150 / 100;
    }
    if (calcAttacker.item == HOLD_EFFECT_CHOICE_SPATK) {
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (calcTarget.item == HOLD_EFFECT_BOOST_IF_NOT_EVOLVED && ctx->battleMons[battlerIdTarget].canStillEvolve) {
        monDef = monDef * 150 / 100;
        monSpDef = monSpDef * 150 / 100;
    }

    // An Assault Vest is half an Eviolite: Sp. Def only, and for anything
    // wearing it. What it costs the wearer is the status moves, and that is
    // asked where the moves are offered rather than here.
    if (calcTarget.item == HOLD_EFFECT_SPDEF_BOOST_NO_STATUS_MOVES && moveCategory == CATEGORY_SPECIAL) {
        monSpDef = monSpDef * 150 / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_CLAMPERL_SPATK && calcAttacker.species == SPECIES_CLAMPERL) {
        monSpAtk *= 2;
    }

    if (calcTarget.item == HOLD_EFFECT_CLAMPERL_SPDEF && calcTarget.species == SPECIES_CLAMPERL) {
        monSpDef *= 2;
    }

    if (calcAttacker.item == HOLD_EFFECT_PIKA_SPATK_UP && calcAttacker.species == SPECIES_PIKACHU) {
        movePower *= 2;
    }

    if (calcTarget.item == HOLD_EFFECT_DITTO_DEF_UP && calcTarget.species == SPECIES_DITTO) {
        monDef *= 2;
    }

    // Sword of Ruin thins everyone's guard but its own bearer's. The
    // reference folds the quarter off after the stat stages; the flat
    // multipliers in this function all land before them, so this one does
    // too and can round a point differently.
    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_SWORD_OF_RUIN) && calcTarget.ability != ABILITY_SWORD_OF_RUIN) {
        monDef = monDef * 3 / 4;
    }

    if (calcAttacker.item == HOLD_EFFECT_CUBONE_ATK_UP && (calcAttacker.species == SPECIES_CUBONE || calcAttacker.species == SPECIES_MAROWAK)) {
        monAtk *= 2;
    }

    // The Soul Dew as the reference has it, the rule from Sun and Moon on: a
    // fifth more power on a Latios or Latias's Dragon and Psychic moves, and
    // nothing to either special stat, in the Frontier or out of it. Its
    // holdEffectParam is 0, so the fifth is written here rather than read from
    // calcAttacker.mod.
    if (calcAttacker.item == HOLD_EFFECT_LATI_SPECIAL && (moveType == TYPE_DRAGON || moveType == TYPE_PSYCHIC) && (calcAttacker.species == SPECIES_LATIOS || calcAttacker.species == SPECIES_LATIAS)) {
        movePower = movePower * 120 / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_DIALGA_BOOST && (moveType == TYPE_DRAGON || moveType == TYPE_STEEL) && calcAttacker.species == SPECIES_DIALGA) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_PALKIA_BOOST && (moveType == TYPE_DRAGON || moveType == TYPE_WATER) && calcAttacker.species == SPECIES_PALKIA) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_GIRATINA_BOOST && (moveType == TYPE_DRAGON || moveType == TYPE_GHOST) && !(GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_STATUS2, NULL) & STATUS2_TRANSFORM) && calcAttacker.species == SPECIES_GIRATINA) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    // The Adamant Crystal, the Lustrous Globe and the Griseous Core are the
    // three orbs again for the same types, and the reference writes them out
    // beside the orbs (CalcBaseDamage.c:879-900 at d0380a487). It asks for the
    // base species in any form; a form is a species here, so the Origin Forme
    // is named beside it -- Giratina's forms are still a form number on
    // SPECIES_GIRATINA, as in retail. Unlike the Griseous Orb above, the
    // reference does not exclude a transformed holder. holdEffectParam is 20.
    if (calcAttacker.item == HOLD_EFFECT_DIALGA_BOOST_AND_TRANSFORM && (moveType == TYPE_DRAGON || moveType == TYPE_STEEL) && (calcAttacker.species == SPECIES_DIALGA || calcAttacker.species == SPECIES_DIALGA_ORIGIN)) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_PALKIA_BOOST_AND_TRANSFORM && (moveType == TYPE_DRAGON || moveType == TYPE_WATER) && (calcAttacker.species == SPECIES_PALKIA || calcAttacker.species == SPECIES_PALKIA_ORIGIN)) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_GIRATINA_BOOST_AND_TRANSFORM && (moveType == TYPE_DRAGON || moveType == TYPE_GHOST) && calcAttacker.species == SPECIES_GIRATINA) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    // Ogerpon's three masks give a fifth more to every move, worn by the form
    // that goes with the mask (CalcBaseDamage.c:924-946: forms 1 and 5, 2 and
    // 6, 3 and 7 -- the mask's form and its Terastal one, each a species of
    // its own here). The Teal Mask has no hold effect, in either tree.
    if ((calcAttacker.item == HOLD_EFFECT_WELLSPRING_MASK && (calcAttacker.species == SPECIES_OGERPON_WELLSPRING_MASK || calcAttacker.species == SPECIES_OGERPON_WELLSPRING_MASK_TERASTAL))
        || (calcAttacker.item == HOLD_EFFECT_HEARTHFLAME_MASK && (calcAttacker.species == SPECIES_OGERPON_HEARTHFLAME_MASK || calcAttacker.species == SPECIES_OGERPON_HEARTHFLAME_MASK_TERASTAL))
        || (calcAttacker.item == HOLD_EFFECT_CORNERSTONE_MASK && (calcAttacker.species == SPECIES_OGERPON_CORNERSTONE_MASK || calcAttacker.species == SPECIES_OGERPON_CORNERSTONE_MASK_TERASTAL))) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    // A Gem's three tenths (CalcBaseDamage.c:913). The Gem has been decided
    // for this move by the time its damage is asked for, and may already be
    // spent, so the flag is the question, not the item; the AI's estimates
    // are made outside a move and never see it.
    if (ctx->gemBoostingMove && battlerIdAttacker == ctx->battlerIdAttacker) {
        movePower = movePower * 13 / 10;
    }

    if (calcAttacker.item == HOLD_EFFECT_POWER_UP_PHYS && moveCategory == CATEGORY_PHYSICAL) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (calcAttacker.item == HOLD_EFFECT_POWER_UP_SPEC && moveCategory == CATEGORY_SPECIAL) {
        movePower = movePower * (100 + calcAttacker.mod) / 100;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_THICK_FAT) == TRUE && (moveType == TYPE_FIRE || moveType == TYPE_ICE)) {
        movePower /= 2;
    }

    // Purifying Salt halves a Ghost move aimed at the holder. Its other half,
    // the status immunity, is answered in the status subscripts, where the
    // reference answers it too.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_PURIFYING_SALT) == TRUE && moveType == TYPE_GHOST) {
        movePower /= 2;
    }

    if (calcAttacker.ability == ABILITY_HUSTLE) {
        monAtk = monAtk * 150 / 100;
    }

    if (calcAttacker.ability == ABILITY_GUTS && calcAttacker.status) {
        monAtk = monAtk * 150 / 100;
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_MARVEL_SCALE) == TRUE && calcTarget.status) {
        monDef = monDef * 150 / 100;
    }

    // Fur Coat is a permanent Reflect worn on the body, so Mold Breaker gets
    // through it; a special move goes round it because only the physical
    // branch ever reads monDef, which is how Marvel Scale above says the
    // same thing.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FUR_COAT) == TRUE) {
        monDef *= 2;
    }

    // Grass Pelt is a Fur Coat that only grows in the grass, and half rather
    // than double. The physical-only half of it is again monDef being the
    // stat nothing else reads.
    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_GRASS_PELT) == TRUE && ctx->terrainOverlayType == GRASSY_TERRAIN) {
        monDef = monDef * 150 / 100;
    }

    // The defending half of Protosynthesis and Quark Drive. Its own ability,
    // so no Mold Breaker gate, and the split picks the stat for us: scaling
    // the one the ability raised leaves the other untouched either way.
    if (calcTarget.ability == ABILITY_PROTOSYNTHESIS || calcTarget.ability == ABILITY_QUARK_DRIVE) {
        if (ctx->paradoxBoostedStat[battlerIdTarget] == STAT_DEF) {
            monDef = monDef * 130 / 100;
        }
        if (ctx->paradoxBoostedStat[battlerIdTarget] == STAT_SPDEF) {
            monSpDef = monSpDef * 130 / 100;
        }
    }

    if (calcAttacker.ability == ABILITY_PLUS && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_SAME_SIDE_HP, battlerIdAttacker, ABILITY_MINUS)) {
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (calcAttacker.ability == ABILITY_MINUS && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_SAME_SIDE_HP, battlerIdAttacker, ABILITY_PLUS)) {
        monSpAtk = monSpAtk * 150 / 100;
    }

    // Vessel of Ruin is the Sp. Atk half, and spares its own bearer's special
    // attacks. The reference exempts the TARGET's ability here too, the same
    // slip as Tablets of Ruin above, and it is not copied for the same reason.
    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_VESSEL_OF_RUIN) && calcAttacker.ability != ABILITY_VESSEL_OF_RUIN) {
        monSpAtk = monSpAtk * 3 / 4;
    }

    // Beads of Ruin is the Sp. Def half of the pair, and here exempting the
    // mon being hit is the right side to be reading.
    if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_BEADS_OF_RUIN) && calcTarget.ability != ABILITY_BEADS_OF_RUIN) {
        monSpDef = monSpDef * 3 / 4;
    }

    if (moveType == TYPE_ELECTRIC && CheckMoveEffectOnField(battleSystem, ctx, MOVE_EFFECT_FLAG_MUD_SPORT)) {
        movePower /= 2;
    }

    if (moveType == TYPE_FIRE && CheckMoveEffectOnField(battleSystem, ctx, MOVE_EFFECT_FLAG_WATER_SPORT)) {
        movePower /= 2;
    }

    if (moveType == TYPE_GRASS && calcAttacker.ability == ABILITY_OVERGROW && calcAttacker.hp <= calcAttacker.maxHp / 3) {
        movePower = movePower * 150 / 100;
    }

    if (moveType == TYPE_FIRE && calcAttacker.ability == ABILITY_BLAZE && calcAttacker.hp <= calcAttacker.maxHp / 3) {
        movePower = movePower * 150 / 100;
    }

    if (moveType == TYPE_WATER && calcAttacker.ability == ABILITY_TORRENT && calcAttacker.hp <= calcAttacker.maxHp / 3) {
        movePower = movePower * 150 / 100;
    }

    if (moveType == TYPE_BUG && calcAttacker.ability == ABILITY_SWARM && calcAttacker.hp <= calcAttacker.maxHp / 3) {
        movePower = movePower * 150 / 100;
    }

    // Flash Fire, once lit, is half again on the attacking stat, where the
    // reference puts it; HeartGold multiplied the finished damage.
    if (GetBattlerVar(ctx, battlerIdAttacker, BMON_DATA_FLASH_FIRE, NULL) && moveType == TYPE_FIRE) {
        monAtk = monAtk * 150 / 100;
        monSpAtk = monSpAtk * 150 / 100;
    }

    // The type-keyed attack boosts: a same-type bonus for a Pokemon that is
    // not of the type. The reference scales the attack modifier, which the
    // move's split then picks one stat out of, so both stats are scaled here
    // and only the one the move reads is used. Transistor is the odd one in
    // the run -- three tenths where the rest take a half.
    if (moveType == TYPE_STEEL && calcAttacker.ability == ABILITY_STEELWORKER) {
        monAtk = monAtk * 150 / 100;
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (moveType == TYPE_DRAGON && calcAttacker.ability == ABILITY_DRAGONS_MAW) {
        monAtk = monAtk * 150 / 100;
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (moveType == TYPE_ROCK && calcAttacker.ability == ABILITY_ROCKY_PAYLOAD) {
        monAtk = monAtk * 150 / 100;
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (moveType == TYPE_FIRE && calcAttacker.ability == ABILITY_FIRE_MANE) {
        monAtk = monAtk * 150 / 100;
        monSpAtk = monSpAtk * 150 / 100;
    }

    if (moveType == TYPE_ELECTRIC && calcAttacker.ability == ABILITY_TRANSISTOR) {
        monAtk = monAtk * 130 / 100;
        monSpAtk = monSpAtk * 130 / 100;
    }

    // The attacking half of Protosynthesis and Quark Drive, three tenths on
    // the one stat the ability picked out when it switched on.
    if (calcAttacker.ability == ABILITY_PROTOSYNTHESIS || calcAttacker.ability == ABILITY_QUARK_DRIVE) {
        if (ctx->paradoxBoostedStat[battlerIdAttacker] == STAT_ATK) {
            monAtk = monAtk * 130 / 100;
        }
        if (ctx->paradoxBoostedStat[battlerIdAttacker] == STAT_SPATK) {
            monSpAtk = monSpAtk * 130 / 100;
        }
    }

    // Hadron Engine runs its Sp. Atk off the current it laid down, and takes a
    // third rather than the three tenths above. Nothing asks whether the
    // holder is standing in that current.
    if (calcAttacker.ability == ABILITY_HADRON_ENGINE && ctx->terrainOverlayType == ELECTRIC_TERRAIN) {
        monSpAtk = monSpAtk * 4 / 3;
    }

    // Water Bubble doubles the water it throws; the fire it takes is halved
    // further down. This half reads the attacker's own ability, so there is
    // no Mold Breaker gate on it.
    if (moveType == TYPE_WATER && calcAttacker.ability == ABILITY_WATER_BUBBLE) {
        monAtk *= 2;
        monSpAtk *= 2;
    }

    // Dark Aura powers up every Dark move on the field and Fairy Aura every
    // Fairy one, a third each however many holders are out; Aura Break turns
    // either round into a quarter off. The reference's Fairy Aura test reads
    // TYPE_DARK, a copy of the Dark Aura block it sits under, so there both
    // auras answer to a Dark move and neither to a Fairy one. That is a slip,
    // not a rule, and it is not copied.
    if ((moveType == TYPE_DARK && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_DARK_AURA))
        || (moveType == TYPE_FAIRY && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_FAIRY_AURA))) {
        if (CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_ALL_HP, 0, ABILITY_AURA_BREAK)) {
            movePower = movePower * 3 / 4;
        } else {
            movePower = movePower * 4 / 3;
        }
    }

    if (moveType == TYPE_FIRE && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_HEATPROOF) == TRUE) {
        movePower /= 2;
    }

    if (moveType == TYPE_FIRE && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_WATER_BUBBLE) == TRUE) {
        movePower /= 2;
    }

    if (moveType == TYPE_FIRE && CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_DRY_SKIN) == TRUE) {
        movePower = movePower * 125 / 100;
    }

    if (calcAttacker.ability == ABILITY_SIMPLE) {
        statChangeAtk *= 2;
        if (statChangeAtk < -6) {
            statChangeAtk = -6;
        }
        if (statChangeAtk > 6) {
            statChangeAtk = 6;
        }
        statChangeSpAtk *= 2;
        if (statChangeSpAtk < -6) {
            statChangeSpAtk = -6;
        }
        if (statChangeSpAtk > 6) {
            statChangeSpAtk = 6;
        }
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SIMPLE) == TRUE) {
        statChangeDef *= 2;
        if (statChangeDef < -6) {
            statChangeDef = -6;
        }
        if (statChangeDef > 6) {
            statChangeDef = 6;
        }
        statChangeSpDef *= 2;
        if (statChangeSpDef < -6) {
            statChangeSpDef = -6;
        }
        if (statChangeSpDef > 6) {
            statChangeSpDef = 6;
        }
    }

    if (CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_UNAWARE) == TRUE) {
        statChangeAtk = 0;
        statChangeSpAtk = 0;
    }
    if (calcAttacker.ability == ABILITY_UNAWARE) {
        statChangeDef = 0;
        statChangeSpDef = 0;
    }

    statChangeAtk += 6;
    statChangeDef += 6;
    statChangeSpAtk += 6;
    statChangeSpDef += 6;

    if (calcAttacker.ability == ABILITY_RIVALRY && calcAttacker.gender == calcTarget.gender && calcAttacker.gender != MON_GENDERLESS && calcTarget.gender != MON_GENDERLESS) {
        movePower = movePower * 125 / 100;
    }
    if (calcAttacker.ability == ABILITY_RIVALRY && calcAttacker.gender != calcTarget.gender && calcAttacker.gender != MON_GENDERLESS && calcTarget.gender != MON_GENDERLESS) {
        movePower = movePower * 75 / 100;
    }

    // A Punching Glove is a tenth where Iron Fist is two, off the same list of
    // moves, and the two stack. What it also does is take the contact off the
    // punch, which is asked in BattleMoveMakesContact rather than here.
    for (i = 0; i < NELEMS(sPunchingMoves); i++) {
        if (sPunchingMoves[i] == moveNo && calcAttacker.ability == ABILITY_IRON_FIST) {
            movePower = movePower * 12 / 10;
            break;
        }
    }
    if (calcAttacker.item == HOLD_EFFECT_INCREASE_PUNCHING_MOVE_DMG && BattleMoveIsPunching(moveNo) == TRUE) {
        movePower = movePower * 110 / 100;
    }

    // The weather as the attacker's move sees it (BattlerMoveWeather): Mega
    // Sol's sunlight halves no Solar Beam and leaves the target the sand's and
    // the snow's help. The confusion blow passes no field condition and asks
    // for no weather. Solar Blade gathers its light as Solar Beam does and is
    // halved in the same weathers (CalcBaseDamage.c:535 at d0380a487).
    weather = fieldCondition ? BattlerMoveWeather(battleSystem, ctx, battlerIdAttacker) : 0;
    // A Utility Umbrella keeps the rain and the sun off what its holder's
    // side of the sum reads (Superombrello): Solar Beam's halving in the rain,
    // Solar Power, Orichalcum Pulse and Flower Gift's Attack on the
    // attacker's; Flower Gift's Sp. Def on the target's.
    weatherOnTarget = calcTarget.item == HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN ? weather & ~(FIELD_CONDITION_RAIN_ALL | FIELD_CONDITION_SUN_ALL) : weather;
    if (calcAttacker.item == HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN) {
        weather &= ~(FIELD_CONDITION_RAIN_ALL | FIELD_CONDITION_SUN_ALL);
    }
    if ((weather & FIELD_CONDITION_WEATHER_NO_SUN) && (moveNo == MOVE_SOLAR_BEAM || moveNo == MOVE_SOLAR_BLADE)) {
        movePower /= 2;
    }
    if ((weather & FIELD_CONDITION_SUN_ALL) && calcAttacker.ability == ABILITY_SOLAR_POWER) {
        monSpAtk = monSpAtk * 15 / 10;
    }
    // Orichalcum Pulse works the sun harder than Solar Power does, and on
    // the physical side. A Utility Umbrella on the one with the ability
    // takes the Attack away (above) -- but not the sentence the ability
    // prints on its way in, which the reference has a note of its own about:
    // the pulse still announces itself from under the umbrella.
    if ((weather & FIELD_CONDITION_SUN_ALL) && calcAttacker.ability == ABILITY_ORICHALCUM_PULSE) {
        monAtk = monAtk * 4 / 3;
    }
    // Sand Force reads the same weather as everything here, so Cloud Nine
    // and Air Lock take it away.
    if ((weather & FIELD_CONDITION_SANDSTORM_ALL) && calcAttacker.ability == ABILITY_SAND_FORCE && (moveType == TYPE_GROUND || moveType == TYPE_ROCK || moveType == TYPE_STEEL)) {
        movePower = movePower * 13 / 10;
    }
    if ((weather & FIELD_CONDITION_SANDSTORM_ALL) && (calcTarget.type1 == TYPE_ROCK || calcTarget.type2 == TYPE_ROCK)) {
        monSpDef = monSpDef * 15 / 10;
    }
    // What the sandstorm does for a Rock-type's Sp. Def, the snow does for
    // an Ice-type's Defence. It is the whole of what snow is for.
    if ((weather & FIELD_CONDITION_SNOW_ALL) && (calcTarget.type1 == TYPE_ICE || calcTarget.type2 == TYPE_ICE)) {
        monDef = monDef * 15 / 10;
    }
    if ((weather & FIELD_CONDITION_SUN_ALL) && CheckAbilityActive(battleSystem, ctx, CHECK_ABILITY_SAME_SIDE_HP, battlerIdAttacker, ABILITY_FLOWER_GIFT)) {
        monAtk = monAtk * 15 / 10;
    }
    // The target's side's Flower Gift is lost on Mold Breaker, Teravolt and
    // Turboblaze alike, as the reference asks it (MoldBreakerAbilityCheck,
    // CalcBaseDamage.c:1435 at d0380a487).
    if ((weatherOnTarget & FIELD_CONDITION_SUN_ALL) && SideAbilityNotIgnored(battleSystem, ctx, battlerIdAttacker, battlerIdTarget, ABILITY_FLOWER_GIFT)) {
        monSpDef = monSpDef * 15 / 10;
    }

    if (moveCategory == CATEGORY_PHYSICAL) {
        if (crit > 1) {
            if (statChangeAtk > 6) {
                dmg = monAtk * sStatChangeTable[statChangeAtk][0] / sStatChangeTable[statChangeAtk][1];
            } else {
                dmg = monAtk;
            }
        } else {
            dmg = monAtk * sStatChangeTable[statChangeAtk][0] / sStatChangeTable[statChangeAtk][1];
        }

        dmg *= movePower;
        dmg *= ((level * 2 / 5) + 2);

        if (crit > 1) {
            if (statChangeDef < 6) {
                dmg2 = monDef * sStatChangeTable[statChangeDef][0] / sStatChangeTable[statChangeDef][1];
            } else {
                dmg2 = monDef;
            }
        } else {
            dmg2 = monDef * sStatChangeTable[statChangeDef][0] / sStatChangeTable[statChangeDef][1];
        }

        dmg /= dmg2;
        dmg /= 50;
    } else if (moveCategory == CATEGORY_SPECIAL) {
        // Psyshock, Psystrike and Secret Sword meet the target's Defense, its
        // stages and whatever raised or lowered it, where every other special
        // move meets its Sp. Def (Pokemon Central, Psicoshock). The reference
        // swaps the stat and keeps the Sp. Def's stage.
        if (moveNo == MOVE_PSYSHOCK || moveNo == MOVE_PSYSTRIKE || moveNo == MOVE_SECRET_SWORD) {
            monSpDef = monDef;
            statChangeSpDef = statChangeDef;
        }
        if (crit > 1) {
            if (statChangeSpAtk > 6) {
                dmg = monSpAtk * sStatChangeTable[statChangeSpAtk][0] / sStatChangeTable[statChangeSpAtk][1];
            } else {
                dmg = monSpAtk;
            }
        } else {
            dmg = monSpAtk * sStatChangeTable[statChangeSpAtk][0] / sStatChangeTable[statChangeSpAtk][1];
        }

        dmg *= movePower;
        dmg *= ((level * 2 / 5) + 2);

        if (crit > 1) {
            if (statChangeSpDef < 6) {
                dmg2 = monSpDef * sStatChangeTable[statChangeSpDef][0] / sStatChangeTable[statChangeSpDef][1];
            } else {
                dmg2 = monSpDef;
            }
        } else {
            dmg2 = monSpDef * sStatChangeTable[statChangeSpDef][0] / sStatChangeTable[statChangeSpDef][1];
        }

        dmg /= dmg2;
        dmg /= 50;
    }

    // The base damage, and nothing after it: the spread, the weather, Glaive
    // Rush, the burn, the screens and the rest are DamageCalcDefault's, in
    // the reference's order. The AI's two callers get the same base the
    // reference's AI does from its CalcBaseDamage.
    return dmg + 2;
}

// Shell Side Arm is physical when it would hurt the target more so, and
// special otherwise, a tie going either way at random (Pokemon Central,
// Armaguscio). The forecast is made once, as the move is used, from the stats
// and their stages alone -- no item or ability -- with Wonder Room swapping
// the target's two stages but not its two stats, as the page has it. Photon
// Geyser is physical when its user's Attack is higher than its Sp. Atk, their
// stages counted and nothing else (Pokemon Central, Geyser Fotonico). What
// either decides is kept for the rest of the action.
void ChooseMoveCategory(BattleSystem *battleSystem, BattleContext *ctx) {
    BattleMon *attacker = &ctx->battleMons[ctx->battlerIdAttacker];
    BattleMon *target;
    int defStage;
    int spDefStage;
    s32 base;
    s32 physical;
    s32 special;

    ctx->selfTurnData[ctx->battlerIdAttacker].physicalChosen = FALSE;
    if (ctx->moveNoCur == MOVE_PHOTON_GEYSER) {
        ctx->selfTurnData[ctx->battlerIdAttacker].physicalChosen = BattleStatWithStage(attacker->atk, attacker->statChanges[STAT_ATK])
            > BattleStatWithStage(attacker->spAtk, attacker->statChanges[STAT_SPATK]);
        return;
    }
    if (ctx->moveNoCur != MOVE_SHELL_SIDE_ARM || ctx->battlerIdTarget == BATTLER_NONE) {
        return;
    }
    target = &ctx->battleMons[ctx->battlerIdTarget];
    defStage = target->statChanges[ctx->wonderRoomTurns ? STAT_SPDEF : STAT_DEF];
    spDefStage = target->statChanges[ctx->wonderRoomTurns ? STAT_DEF : STAT_SPDEF];
    base = (attacker->level * 2 / 5 + 2) * BattleMoveTbl(ctx, MOVE_SHELL_SIDE_ARM)->power;
    physical = base * (s32)BattleStatWithStage(attacker->atk, attacker->statChanges[STAT_ATK]) / (s32)BattleStatWithStage(target->def, defStage) / 50;
    special = base * (s32)BattleStatWithStage(attacker->spAtk, attacker->statChanges[STAT_SPATK]) / (s32)BattleStatWithStage(target->spDef, spDefStage) / 50;
    ctx->selfTurnData[ctx->battlerIdAttacker].physicalChosen = physical > special || (physical == special && (BattleSystem_Random(battleSystem) & 1));
}

// The category a move has as this attacker uses it: the table's, but for a
// Shell Side Arm or a Photon Geyser ChooseMoveCategory made physical.
int BattleMoveCategory(BattleContext *ctx, u32 moveNo, int battlerIdAttacker) {
    if ((moveNo == MOVE_SHELL_SIDE_ARM || moveNo == MOVE_PHOTON_GEYSER) && battlerIdAttacker < BATTLER_MAX && ctx->selfTurnData[battlerIdAttacker].physicalChosen) {
        return CATEGORY_PHYSICAL;
    }
    return BattleMoveTbl(ctx, moveNo)->category;
}

int ApplyDamageRange(BattleSystem *battleSystem, BattleContext *ctx, int damage) {
    if (damage) {
        damage *= (100 - (BattleSystem_Random(battleSystem) % 16));
        damage /= 100;
        if (!damage) {
            damage = 1;
        }
    }
    return damage;
}

// One in this many at each critical stage: the reference's CriticalRateTable,
// the Generation VII odds. Stages 3 and 4 always land, since anything modulo 1
// is 0. HeartGold's were 16, 8, 4, 3 and 2.
static const u8 sCritChance[] = {
    24, 8, 2, 1, 1
};

u32 TryCriticalHit(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int critCnt, u32 sideCondition) {
    u16 critUp;
    int item;
    u16 species;
    u32 status2;
    u32 moveEffect;
    int ret = 1;
    int ability;

    item = GetItemVar(ctx, GetBattlerHeldItem(ctx, battlerIdAttacker), ITEM_VAR_HOLD_EFFECT);
    species = ctx->battleMons[battlerIdAttacker].species;
    status2 = ctx->battleMons[battlerIdAttacker].status2;
    moveEffect = ctx->battleMons[battlerIdTarget].moveEffectFlags;
    ability = ctx->battleMons[battlerIdAttacker].ability;

    // The reference's Leek is this game's Stick, the same item down to the row
    // of item data, and the reference gives its two stages to Sirfetch'd as
    // well as to Farfetch'd. That second species is the whole of the Leek here.
    critUp = (((status2 & STATUS2_FOCUS_ENERGY) != 0) * 2) + ctx->moveConditions[battlerIdAttacker].dragonCheer + (item == HOLD_EFFECT_CRITRATE_UP) + critCnt + (ability == ABILITY_SUPER_LUCK) + 2 * ((item == HOLD_EFFECT_CHANSEY_CRITRATE_UP) && (species == SPECIES_CHANSEY)) + 2 * ((item == HOLD_EFFECT_FARFETCHD_CRITRATE_UP) && (species == SPECIES_FARFETCHD)) + 2 * ((item == HOLD_EFFECT_FARFETCHD_CRITRATE_UP) && (species == SPECIES_SIRFETCHD));

    // Laser Focus makes the next hit certain, the way four stages would.
    if (critUp > 4 || ctx->moveConditions[battlerIdAttacker].laserFocusTimer) {
        critUp = 4;
    }

    // Merciless does not improve the odds, it skips the roll: a poisoned
    // target is a critical hit every time. The roll still happens first, so
    // the RNG is drawn either way, and the armours and Lucky Chant still
    // refuse it. The ability is read raw, as Super Luck is just above.
    //
    // An always-critical move -- Frost Breath and its kind -- skips the roll
    // the same way. The reference reads the move's effect here; this game's
    // effect scripts carry more, so the script says so by asking for a
    // critical stage the ladder above has no rung for. The stage is capped
    // before the roll, so the sentinel cannot walk off the table either.
    if ((BattleSystem_Random(battleSystem) % sCritChance[critUp]) == 0 || critCnt >= CRITICAL_STAGE_ALWAYS || (ability == ABILITY_MERCILESS && (ctx->battleMons[battlerIdTarget].status & STATUS_POISON_ALL))) {
        if (!CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_BATTLE_ARMOR) && !CheckBattlerAbilityIfNotIgnored(ctx, battlerIdAttacker, battlerIdTarget, ABILITY_SHELL_ARMOR) && !(sideCondition & SIDE_CONDITION_LUCKY_CHANT) && !(moveEffect & MOVE_EFFECT_FLAG_LUCKY_CHANT)) {
            ret = 2;
        }
    }

    if ((ret == 2) && GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_SNIPER) {
        ret = 3;
    }

    // hg-engine counts the critical hits a Pokemon lands while it is out and,
    // at the third, marks it in its party record, which is what Galarian
    // Farfetch'd evolves on. Only the player's own Pokemon: the engine marks
    // any, and a wild one caught after landing three on the player's side
    // would evolve for them. The games evolve it when that battle is over, not
    // at its next level, so the Pokemon is also put with the ones that levelled
    // up, which are the ones the check after the battle asks.
    //
    // Nor in a link or a Frontier battle (BATTLE_TYPE_NO_EXP; Safari and Pal
    // Park, its other two, see no move of the player's): the games evolve
    // nothing after either. A link battle ends without the check; a Frontier
    // one reaches it having levelled nobody up, and the mark alone would play
    // the scene on the Frontier's copy of the party and register Sirfetch'd
    // in the Pokedex copied back after it.
    if (ret > 1 && !(BattleSystem_GetBattleType(battleSystem) & BATTLE_TYPE_NO_EXP)
        && BattleSystem_GetParty(battleSystem, battlerIdAttacker) == BattleSystem_GetParty(battleSystem, BATTLER_PLAYER)) {
        ctx->battleMons[battlerIdAttacker].criticalHits++;
        if (ctx->battleMons[battlerIdAttacker].criticalHits == 3) {
            Pokemon *mon = BattleSystem_GetPartyMon(battleSystem, battlerIdAttacker, ctx->selectedMonIndex[battlerIdAttacker]);
            u8 bits = (u8)GetMonData(mon, MON_DATA_UNUSED_113, NULL);

            bits |= MON_CRITICAL_HITS_EVOLUTION_BIT;
            SetMonData(mon, MON_DATA_UNUSED_113, &bits);
            ctx->levelUpMons |= MaskOfFlagNo(ctx->selectedMonIndex[battlerIdAttacker]);
        }
    }

    return ret;
}

static const u16 sMetronomeUnuseableMoves[] = {
    MOVE_METRONOME,
    MOVE_STRUGGLE,
    MOVE_SKETCH,
    MOVE_MIMIC,
    MOVE_CHATTER,

    // Moves the engine added that neither Metronome nor Mimic may call: the
    // Z-moves, the Let's Go and Max moves, and the three placeholders.
    MOVE_BEHEMOTH_BLADE,
    MOVE_BEHEMOTH_BASH,
    MOVE_BREAKNECK_BLITZ_PHYSICAL,
    MOVE_BREAKNECK_BLITZ_SPECIAL,
    MOVE_ALL_OUT_PUMMELING_PHYSICAL,
    MOVE_ALL_OUT_PUMMELING_SPECIAL,
    MOVE_SUPERSONIC_SKYSTRIKE_PHYSICAL,
    MOVE_SUPERSONIC_SKYSTRIKE_SPECIAL,
    MOVE_ACID_DOWNPOUR_PHYSICAL,
    MOVE_ACID_DOWNPOUR_SPECIAL,
    MOVE_TECTONIC_RAGE_PHYSICAL,
    MOVE_TECTONIC_RAGE_SPECIAL,
    MOVE_CONTINENTAL_CRUSH_PHYSICAL,
    MOVE_CONTINENTAL_CRUSH_SPECIAL,
    MOVE_SAVAGE_SPIN_OUT_PHYSICAL,
    MOVE_SAVAGE_SPIN_OUT_SPECIAL,
    MOVE_NEVER_ENDING_NIGHTMARE_PHYSICAL,
    MOVE_NEVER_ENDING_NIGHTMARE_SPECIAL,
    MOVE_CORKSCREW_CRASH_PHYSICAL,
    MOVE_CORKSCREW_CRASH_SPECIAL,
    MOVE_INFERNO_OVERDRIVE_PHYSICAL,
    MOVE_INFERNO_OVERDRIVE_SPECIAL,
    MOVE_HYDRO_VORTEX_PHYSICAL,
    MOVE_HYDRO_VORTEX_SPECIAL,
    MOVE_BLOOM_DOOM_PHYSICAL,
    MOVE_BLOOM_DOOM_SPECIAL,
    MOVE_GIGAVOLT_HAVOC_PHYSICAL,
    MOVE_GIGAVOLT_HAVOC_SPECIAL,
    MOVE_SHATTERED_PSYCHE_PHYSICAL,
    MOVE_SHATTERED_PSYCHE_SPECIAL,
    MOVE_SUBZERO_SLAMMER_PHYSICAL,
    MOVE_SUBZERO_SLAMMER_SPECIAL,
    MOVE_DEVASTATING_DRAKE_PHYSICAL,
    MOVE_DEVASTATING_DRAKE_SPECIAL,
    MOVE_BLACK_HOLE_ECLIPSE_PHYSICAL,
    MOVE_BLACK_HOLE_ECLIPSE_SPECIAL,
    MOVE_TWINKLE_TACKLE_PHYSICAL,
    MOVE_TWINKLE_TACKLE_SPECIAL,
    MOVE_CATASTROPIKA,
    MOVE_10_000_000_VOLT_THUNDERBOLT,
    MOVE_STOKED_SPARKSURFER,
    MOVE_EXTREME_EVOBOOST,
    MOVE_PULVERIZING_PANCAKE,
    MOVE_GENESIS_SUPERNOVA,
    MOVE_SINISTER_ARROW_RAID,
    MOVE_MALICIOUS_MOONSAULT,
    MOVE_OCEANIC_OPERETTA,
    MOVE_SPLINTERED_STORMSHARDS,
    MOVE_LETS_SNUGGLE_FOREVER,
    MOVE_CLANGOROUS_SOULBLAZE,
    MOVE_GUARDIAN_OF_ALOLA,
    MOVE_SEARING_SUNRAZE_SMASH,
    MOVE_MENACING_MOONRAZE_MAELSTROM,
    MOVE_LIGHT_THAT_BURNS_THE_SKY,
    MOVE_SOUL_STEALING_7_STAR_STRIKE,
    MOVE_ZIPPY_ZAP,
    MOVE_SPLISHY_SPLASH,
    MOVE_FLOATY_FALL,
    MOVE_PIKA_PAPOW,
    MOVE_BOUNCY_BUBBLE,
    MOVE_BUZZY_BUZZ,
    MOVE_SIZZLY_SLIDE,
    MOVE_GLITZY_GLOW,
    MOVE_BADDY_BAD,
    MOVE_SAPPY_SEED,
    MOVE_FREEZY_FROST,
    MOVE_SPARKLY_SWIRL,
    MOVE_VEEVEE_VOLLEY,
    MOVE_DOUBLE_IRON_BASH,
    MOVE_MAX_GUARD,
    MOVE_DYNAMAX_CANNON,
    MOVE_MAX_FLARE,
    MOVE_MAX_FLUTTERBY,
    MOVE_MAX_LIGHTNING,
    MOVE_MAX_STRIKE,
    MOVE_MAX_KNUCKLE,
    MOVE_MAX_PHANTASM,
    MOVE_MAX_HAILSTORM,
    MOVE_MAX_OOZE,
    MOVE_MAX_GEYSER,
    MOVE_MAX_AIRSTREAM,
    MOVE_MAX_STARFALL,
    MOVE_MAX_WYRMWIND,
    MOVE_MAX_MINDSTORM,
    MOVE_MAX_ROCKFALL,
    MOVE_MAX_QUAKE,
    MOVE_MAX_DARKNESS,
    MOVE_MAX_OVERGROWTH,
    MOVE_MAX_STEELSPIKE,
    MOVE_468,
    MOVE_469,
    MOVE_470,

    0xFFFE,
    MOVE_SLEEP_TALK,
    MOVE_ASSIST,
    MOVE_MIRROR_MOVE,
    MOVE_COUNTER,
    MOVE_MIRROR_COAT,
    MOVE_PROTECT,
    MOVE_DETECT,
    MOVE_ENDURE,
    MOVE_DESTINY_BOND,
    MOVE_THIEF,
    MOVE_FOLLOW_ME,
    MOVE_SNATCH,
    MOVE_HELPING_HAND,
    MOVE_COVET,
    MOVE_TRICK,
    MOVE_FOCUS_PUNCH,
    MOVE_FEINT,
    MOVE_COPYCAT,
    MOVE_ME_FIRST,
    MOVE_SWITCHEROO,

    // The engine's further bans for Metronome alone.
    MOVE_AFTER_YOU,
    MOVE_APPLE_ACID,
    MOVE_ASTRAL_BARRAGE,
    MOVE_AURA_WHEEL,
    MOVE_BANEFUL_BUNKER,
    MOVE_BEAK_BLAST,
    MOVE_BELCH,
    MOVE_BESTOW,
    MOVE_BODY_PRESS,
    MOVE_BRANCH_POKE,
    MOVE_BREAKING_SWIPE,
    MOVE_CELEBRATE,
    MOVE_CLANGOROUS_SOUL,
    MOVE_CRAFTY_SHIELD,
    MOVE_DECORATE,
    MOVE_DIAMOND_STORM,
    MOVE_DRAGON_ASCENT,
    MOVE_DRAGON_ENERGY,
    MOVE_DRAGON_HAMMER,
    MOVE_DRUM_BEATING,
    MOVE_ETERNABEAM,
    MOVE_FALSE_SURRENDER,
    MOVE_FIERY_WRATH,
    MOVE_FLEUR_CANNON,
    MOVE_FREEZE_SHOCK,
    MOVE_FREEZING_GLARE,
    MOVE_GLACIAL_LANCE,
    MOVE_GRAV_APPLE,
    MOVE_HOLD_HANDS,
    MOVE_HYPERSPACE_FURY,
    MOVE_HYPERSPACE_HOLE,
    MOVE_ICE_BURN,
    MOVE_INSTRUCT,
    MOVE_JUNGLE_HEALING,
    MOVE_KINGS_SHIELD,
    MOVE_LIFE_DEW,
    MOVE_LIGHT_OF_RUIN,
    MOVE_MAT_BLOCK,
    MOVE_METEOR_ASSAULT,
    MOVE_MIND_BLOWN,
    MOVE_MOONGEIST_BEAM,
    MOVE_NATURE_POWER,
    MOVE_NATURES_MADNESS,
    MOVE_OBSTRUCT,
    MOVE_ORIGIN_PULSE,
    MOVE_OVERDRIVE,
    MOVE_PHOTON_GEYSER,
    MOVE_PLASMA_FISTS,
    MOVE_PRECIPICE_BLADES,
    MOVE_PYRO_BALL,
    MOVE_QUASH,
    MOVE_QUICK_GUARD,
    MOVE_RAGE_POWDER,
    MOVE_RELIC_SONG,
    MOVE_SECRET_SWORD,
    MOVE_SHELL_TRAP,
    MOVE_SNAP_TRAP,
    MOVE_SNARL,
    MOVE_SNORE,
    MOVE_SPECTRAL_THIEF,
    MOVE_SPIKY_SHIELD,
    MOVE_SPIRIT_BREAK,
    MOVE_SPOTLIGHT,
    MOVE_STEAM_ERUPTION,
    MOVE_STEEL_BEAM,
    MOVE_STRANGE_STEAM,
    MOVE_SUNSTEEL_STRIKE,
    MOVE_SURGING_STRIKES,
    MOVE_TECHNO_BLAST,
    MOVE_THOUSAND_ARROWS,
    MOVE_THOUSAND_WAVES,
    MOVE_THUNDER_CAGE,
    MOVE_THUNDEROUS_KICK,
    MOVE_TRANSFORM,
    MOVE_V_CREATE,
    MOVE_WICKED_BLOW,
    MOVE_WIDE_GUARD,
    0xFFFF
};

BOOL CheckLegalMimicMove(u16 moveNo) {
    int i = 0;

    do {
        if (sMetronomeUnuseableMoves[i] == moveNo) {
            break;
        }
        i++;
    } while (sMetronomeUnuseableMoves[i] != 0xFFFE);

    return sMetronomeUnuseableMoves[i] == 0xFFFE;
}

BOOL CheckLegalMetronomeMove(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, u16 moveNo) {
    int i = 0;

    if (BattleContext_CheckMoveUnuseableInGravity(battleSystem, ctx, battlerId, moveNo) == TRUE || BattleContext_CheckMoveHealBlocked(battleSystem, ctx, battlerId, moveNo) == TRUE) {
        return FALSE;
    }

    do {
        if (moveNo == sMetronomeUnuseableMoves[i]) {
            break;
        }
        i++;
    } while (sMetronomeUnuseableMoves[i] != 0xFFFF);

    return sMetronomeUnuseableMoves[i] == 0xFFFF;
}

static const u16 sEncoreFailMoves[] = {
    MOVE_TRANSFORM,
    MOVE_MIMIC,
    MOVE_SKETCH,
    MOVE_MIRROR_MOVE,
    MOVE_ENCORE,
    MOVE_STRUGGLE
};

BOOL IsMoveEncored(BattleContext *ctx, u16 moveNo) {
    int i = 0;

    do {
        if (BattleMoveTbl(ctx, sEncoreFailMoves[i])->effect == BattleMoveTbl(ctx, moveNo)->effect) {
            break;
        }
        i++;
    } while (i < NELEMS(sEncoreFailMoves));

    return i == NELEMS(sEncoreFailMoves);
}

static const u16 sMeFirstUnuseableMoves[] = {
    MOVE_COUNTER,
    MOVE_MIRROR_COAT,
    MOVE_THIEF,
    MOVE_COVET,
    MOVE_FOCUS_PUNCH,
    MOVE_CHATTER
};

BOOL CheckLegalMeFirstMove(BattleContext *ctx, u16 moveNo) {
    int i = 0;

    do {
        if (BattleMoveTbl(ctx, sMeFirstUnuseableMoves[i])->effect == BattleMoveTbl(ctx, moveNo)->effect) {
            break;
        }
        i++;
    } while (i < NELEMS(sMeFirstUnuseableMoves));

    return i == NELEMS(sMeFirstUnuseableMoves);
}

s32 GetItemVar(BattleContext *ctx, u16 itemNo, u16 var) {
    ItemData *itemData;
    u32 index = GetItemIndexMapping(itemNo, 0);
    itemData = GetItemDataPtrFromArray(ctx->trainerAIData.itemData, index);

    return GetItemAttr_PreloadedItemData(itemData, var);
}

int ov12_02257E98(BattleSystem *battleSystem, BattleContext *ctx, int side) {
    int battlerId;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (battlerId = 0; battlerId < maxBattlers; battlerId++) {
        if (BattleSystem_GetFieldSide(battleSystem, battlerId) == side) {
            break;
        }
    }

    return battlerId;
}

void SortExecutionOrderBySpeed(BattleSystem *battleSystem, BattleContext *ctx) {
    int i, j;
    int battlerId1;
    int battlerId2;
    int flag;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (i = 0; i < maxBattlers - 1; i++) {
        for (j = i + 1; j < maxBattlers; j++) {
            battlerId1 = ctx->executionOrder[i];
            battlerId2 = ctx->executionOrder[j];
            if (ctx->playerActions[battlerId1].inputSelection == ctx->playerActions[battlerId2].inputSelection) {
                if (ctx->playerActions[battlerId1].inputSelection != BATTLE_INPUT_FIGHT) {
                    flag = 1;
                } else {
                    flag = 0;
                }
                if (CheckSortSpeed(battleSystem, ctx, battlerId1, battlerId2, flag)) {
                    ctx->executionOrder[i] = battlerId2;
                    ctx->executionOrder[j] = battlerId1;
                }
            }
        }
    }
}

// The reference sorts whoever has not moved yet after every move, so a speed
// that changed this turn -- or an After You, or a Quash -- counts this turn.
// The ones who have moved keep their places.
void SortRemainingExecutionOrderBySpeed(BattleSystem *battleSystem, BattleContext *ctx) {
    int i, j;
    int battlerId1;
    int battlerId2;
    int flag;
    int maxBattlers = BattleSystem_GetMaxBattlers(battleSystem);

    for (i = ctx->executionIndex; i < maxBattlers - 1; i++) {
        for (j = i + 1; j < maxBattlers; j++) {
            battlerId1 = ctx->executionOrder[i];
            battlerId2 = ctx->executionOrder[j];
            if (ctx->playerActions[battlerId1].inputSelection == ctx->playerActions[battlerId2].inputSelection) {
                if (ctx->playerActions[battlerId1].inputSelection != BATTLE_INPUT_FIGHT) {
                    flag = 1;
                } else {
                    flag = 0;
                }
                if (CheckSortSpeed(battleSystem, ctx, battlerId1, battlerId2, flag)) {
                    ctx->executionOrder[i] = battlerId2;
                    ctx->executionOrder[j] = battlerId1;
                }
            }
        }
    }
}

static const int ov12_0226CBDC[] = {
    15, 16, 17, 18, 19, 20, 21, 22, 25, 26
};

BOOL CheckStatusEffectsSubstitute(BattleContext *ctx, int battlerId, int status) {
    int i;
    BOOL ret = FALSE;

    if ((ctx->battleMons[battlerId].status2 & STATUS2_SUBSTITUTE) || (ctx->battleMons[battlerId].moveEffectFlags & MOVE_EFFECT_FLAG_HIDE_SUBSTITUTE)) {
        for (i = 0; i < NELEMS(ov12_0226CBDC); i++) {
            if (ov12_0226CBDC[i] == status) {
                ret = TRUE;
                break;
            }
        }
    } else {
        ret = TRUE;
    }

    return ret;
}

BOOL CheckItemEffectOnUTurn(BattleSystem *battleSystem, BattleContext *ctx, int *script) {
    BOOL ret = FALSE;
    int itemAttacker = GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker);
    int modAttacker = GetHeldItemModifier(ctx, ctx->battlerIdAttacker, 0);
    int itemTarget = GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget);
    int modTarget = GetHeldItemModifier(ctx, ctx->battlerIdTarget, 0);
    int side = BattleSystem_GetFieldSide(battleSystem, ctx->battlerIdAttacker);

    if (itemAttacker == HOLD_EFFECT_HP_RESTORE_ON_DMG && (ctx->battleStatus & BATTLE_STATUS_MOVE_SUCCESSFUL) && (ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage) && (ctx->battlerIdAttacker != ctx->battlerIdTarget) && (ctx->battleMons[ctx->battlerIdAttacker].hp < ctx->battleMons[ctx->battlerIdAttacker].maxHp) && ctx->battleMons[ctx->battlerIdAttacker].hp) {
        ctx->hpCalc = DamageDivide(ctx->selfTurnData[ctx->battlerIdAttacker].shellBellDamage * -1, modAttacker);
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        *script = BATTLE_SUBSCRIPT_RESTORE_A_LITTLE_HP;
        ret = TRUE;
    }

    if (itemAttacker == HOLD_EFFECT_HP_DRAIN_ON_ATK && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && (ctx->battleStatus & BATTLE_STATUS_MOVE_SUCCESSFUL) && BattleMoveTbl(ctx, ctx->moveNoCur)->category != CATEGORY_STATUS && ctx->battleMons[ctx->battlerIdAttacker].hp) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, 10);
        ctx->battlerIdTemp = ctx->battlerIdAttacker;
        *script = BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM;
        ret = TRUE;
    }

    if (itemTarget == HOLD_EFFECT_RECOIL_PHYSICAL && ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, modTarget);
        *script = BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT;
        ret = TRUE;
    }

    // Rocky Helmet's other half. The reference keeps this set of four -- Shell
    // Bell, Life Orb, Jaboca and Sticky Barb -- in one function with the
    // helmet, and a pivot move that makes contact is a hit like any other.
    if (itemTarget == HOLD_EFFECT_DAMAGE_ON_CONTACT && ctx->battleMons[ctx->battlerIdAttacker].hp && GetBattlerAbility(ctx, ctx->battlerIdAttacker) != ABILITY_MAGIC_GUARD && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
        ctx->hpCalc = DamageDivide(ctx->battleMons[ctx->battlerIdAttacker].maxHp * -1, modTarget);
        *script = BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT;
        ret = TRUE;
    }

    if (itemTarget == HOLD_EFFECT_DMG_USER_CONTACT_XFR && ctx->battleMons[ctx->battlerIdAttacker].hp && !ctx->battleMons[ctx->battlerIdAttacker].item && !(ctx->fieldSideConditionData[side].battlerBitKnockedOffItem & MaskOfFlagNo(ctx->selectedMonIndex[ctx->battlerIdAttacker])) && (ctx->selfTurnData[ctx->battlerIdTarget].physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage) && BattleMoveMakesContact(ctx, ctx->moveNoCur)) {
        *script = BATTLE_SUBSCRIPT_TRANSFER_STICKY_BARB;
        ret = TRUE;
    }

    return ret;
}

void CheckIgnorePressure(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget) {
    if (battlerIdTarget != BATTLER_NONE && GetBattlerAbility(ctx, battlerIdTarget) == ABILITY_PRESSURE && ctx->battleMons[battlerIdAttacker].movePPCur[ctx->movePos[battlerIdAttacker]]) {
        ctx->battleMons[battlerIdAttacker].movePPCur[ctx->movePos[battlerIdAttacker]]--;
    }
}

BOOL BattleController_TryEmitExitRecording(BattleSystem *battleSystem, BattleContext *ctx) {
    if (BattleSystem_IsRecordingPaused(battleSystem)) {
        ctx->command = CONTROLLER_COMMAND_43;
        return TRUE;
    }
    return FALSE;
}

int ov12_022581D4(BattleSystem *battleSystem, BattleContext *ctx, int var, int battlerId) {
    switch (var) {
    case 0:
        return ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)];
    case 1:
        return ctx->fieldSideConditionData[BattleSystem_GetFieldSide(battleSystem, battlerId)].mistTurns;
    case 2:
        return ctx->selectedMonIndex[battlerId];
    case 3:
        return ctx->totalTurns;
    case 4:
        return ctx->levelUpMons;
    case 5:
        return ctx->safariRunAttempts;
    case 6:
        return ctx->totalTimesFainted[battlerId];
    case 7:
        return ctx->totalDamage[battlerId];
    case 8:
        return (int)ctx->playerActions[battlerId].command;
    case 9:
        return ctx->trainerAIData.battlerIdTarget;
    case 10:
        return ctx->switchInFlag;
    case 11:
        return ctx->trainerAIData.unkA4[battlerId];
    case BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE:
        return ctx->playerActions[battlerId].unk8;
    case 13:
        return (int)ctx->command;
    case 14:
        return (int)ctx->commandNext;
    }

    GF_ASSERT(FALSE);
    return 0;
}

void ov12_022582B8(BattleSystem *battleSystem, BattleContext *ctx, int var, int battlerId, int data) {
    switch (var) {
    case 0:
        ctx->fieldSideConditionFlags[BattleSystem_GetFieldSide(battleSystem, battlerId)] = data;
        break;
    case 1:
        ctx->fieldSideConditionData[BattleSystem_GetFieldSide(battleSystem, battlerId)].mistTurns = data;
        break;
    case 2:
        ctx->selectedMonIndex[battlerId] = data;
        break;
    case 3:
        ctx->totalTurns = data;
        break;
    case 9:
        ctx->trainerAIData.battlerIdTarget = data;
        break;
    case 11:
        ctx->trainerAIData.unkA4[battlerId] = data;
        break;
    default:
        GF_ASSERT(FALSE);
    }
}

static const int sMoveStatusChangeScripts[] = {
    BATTLE_SUBSCRIPT_NONE,
    BATTLE_SUBSCRIPT_FALL_ASLEEP,
    BATTLE_SUBSCRIPT_POISON,
    BATTLE_SUBSCRIPT_BURN,
    BATTLE_SUBSCRIPT_FREEZE,
    BATTLE_SUBSCRIPT_PARALYZE,
    BATTLE_SUBSCRIPT_BADLY_POISON,
    BATTLE_SUBSCRIPT_CONFUSE,
    BATTLE_SUBSCRIPT_FLINCH_MON,
    BATTLE_SUBSCRIPT_REST,
    BATTLE_SUBSCRIPT_UPROAR,
    BATTLE_SUBSCRIPT_PAY_DAY,
    BATTLE_SUBSCRIPT_VANISH_ON_CHARGE_TURN,
    BATTLE_SUBSCRIPT_BIND_START,
    BATTLE_SUBSCRIPT_RECOIL_1_4,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_RECHARGE_TURN,
    BATTLE_SUBSCRIPT_SET_RAGE_FLAG,
    BATTLE_SUBSCRIPT_STEAL_ITEM,
    BATTLE_SUBSCRIPT_MEAN_LOOK,
    BATTLE_SUBSCRIPT_NIGHTMARE_START,
    BATTLE_SUBSCRIPT_BOOST_ALL_STATS,
    BATTLE_SUBSCRIPT_RAPID_SPIN,
    BATTLE_SUBSCRIPT_HEAL_TARGET_PARALYSIS,
    BATTLE_SUBSCRIPT_USER_ATK_AND_DEF_DOWN_1_STAGE,
    BATTLE_SUBSCRIPT_RECOIL_1_3,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_THRASH,
    BATTLE_SUBSCRIPT_KNOCK_OFF,
    BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_UP_1_STAGE,
    BATTLE_SUBSCRIPT_USER_ATK_AND_DEF_UP_1_STAGE,
    BATTLE_SUBSCRIPT_TARGET_ATK_AND_DEF_DOWN_1_STAGE,
    BATTLE_SUBSCRIPT_USER_SPATK_AND_SPDEF_UP_1_STAGE,
    BATTLE_SUBSCRIPT_USER_ATK_AND_SPEED_UP_1_STAGE,
    BATTLE_SUBSCRIPT_DRAIN_HALF_DAMAGE_DEALT,
    BATTLE_SUBSCRIPT_DREAM_EATER,
    BATTLE_SUBSCRIPT_RESET_ALL_STAT_STAGES,
    BATTLE_SUBSCRIPT_BIDE_START,
    BATTLE_SUBSCRIPT_STRUGGLE,
    BATTLE_SUBSCRIPT_CONVERSION,
    BATTLE_SUBSCRIPT_RECOVER_HALF_MAX_HP,
    BATTLE_SUBSCRIPT_LIGHT_SCREEN,
    BATTLE_SUBSCRIPT_REFLECT,
    BATTLE_SUBSCRIPT_MIST,
    BATTLE_SUBSCRIPT_FOCUS_ENERGY,
    BATTLE_SUBSCRIPT_MIMIC,
    BATTLE_SUBSCRIPT_LEECH_SEED_START,
    BATTLE_SUBSCRIPT_DISABLE_START,
    BATTLE_SUBSCRIPT_ENCORE_START,
    BATTLE_SUBSCRIPT_PAIN_SPLIT,
    BATTLE_SUBSCRIPT_CONVERSION_2,
    BATTLE_SUBSCRIPT_LOCK_ON,
    BATTLE_SUBSCRIPT_SKETCH,
    BATTLE_SUBSCRIPT_FEINT,
    BATTLE_SUBSCRIPT_DESTINY_BOND,
    BATTLE_SUBSCRIPT_REDUCE_TARGET_PP,
    BATTLE_SUBSCRIPT_PROTECT,
    BATTLE_SUBSCRIPT_HEAL_BELL,
    BATTLE_SUBSCRIPT_TRY_SUBSTITUTE,
    BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE,
    BATTLE_SUBSCRIPT_TRANSFORM_INTO_TARGET,
    BATTLE_SUBSCRIPT_MINIMIZE,
    BATTLE_SUBSCRIPT_CURSE_NORMAL,
    BATTLE_SUBSCRIPT_CURSE_GHOST,
    BATTLE_SUBSCRIPT_PRINT_MESSAGE_AND_PLAY_ANIMATION,
    BATTLE_SUBSCRIPT_FORESIGHT,
    BATTLE_SUBSCRIPT_PERISH_SONG_START,
    BATTLE_SUBSCRIPT_WEATHER_START,
    BATTLE_SUBSCRIPT_SWAGGER,
    BATTLE_SUBSCRIPT_INFATUATE,
    BATTLE_SUBSCRIPT_SAFEGUARD_START,
    BATTLE_SUBSCRIPT_PRESENT_HEAL,
    BATTLE_SUBSCRIPT_MAGNITUDE,
    BATTLE_SUBSCRIPT_BATON_PASS,
    BATTLE_SUBSCRIPT_BELLY_DRUM,
    BATTLE_SUBSCRIPT_TELEPORT,
    BATTLE_SUBSCRIPT_FUTURE_SIGHT_START,
    BATTLE_SUBSCRIPT_STOCKPILE,
    BATTLE_SUBSCRIPT_SWALLOW,
    BATTLE_SUBSCRIPT_TORMENT_START,
    BATTLE_SUBSCRIPT_FLATTER,
    BATTLE_SUBSCRIPT_MEMENTO,
    BATTLE_SUBSCRIPT_CHARGE,
    BATTLE_SUBSCRIPT_TAUNT_START,
    BATTLE_SUBSCRIPT_EXCHANGE_ITEMS,
    BATTLE_SUBSCRIPT_COPY_ABILITY,
    BATTLE_SUBSCRIPT_BREAK_SCREENS,
    BATTLE_SUBSCRIPT_YAWN,
    BATTLE_SUBSCRIPT_EXCHANGE_ABILITIES,
    BATTLE_SUBSCRIPT_RECOVER_PSN_PRZ_BRN,
    BATTLE_SUBSCRIPT_ROOST,
    BATTLE_SUBSCRIPT_HEAL_TARGET_SLEEP,
    BATTLE_SUBSCRIPT_GRAVITY_START,
    BATTLE_SUBSCRIPT_MIRACLE_EYE,
    BATTLE_SUBSCRIPT_HEALING_WISH,
    BATTLE_SUBSCRIPT_TAILWIND_START,
    BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_DOWN_1_STAGE,
    BATTLE_SUBSCRIPT_USER_SWAP_ATK_AND_DEF,
    BATTLE_SUBSCRIPT_SUPPRESS_TARGET_ABILITY,
    BATTLE_SUBSCRIPT_LUCKY_CHANT_START,
    BATTLE_SUBSCRIPT_EXCHANGE_ATK_AND_SPATK_STAGES,
    BATTLE_SUBSCRIPT_EXCHANGE_DEF_AND_SPDEF_STAGES,
    BATTLE_SUBSCRIPT_GIVE_TARGET_INSOMNIA,
    BATTLE_SUBSCRIPT_EXCHANGE_ALL_STAT_STAGES,
    BATTLE_SUBSCRIPT_RECOIL_1_3_CHANCE_TO_BURN,
    BATTLE_SUBSCRIPT_DEFOG,
    BATTLE_SUBSCRIPT_HEAL_BLOCK_START,
    BATTLE_SUBSCRIPT_ATTACK_THEN_SWITCH_OUT,
    BATTLE_SUBSCRIPT_EMBARGO_START,
    BATTLE_SUBSCRIPT_PLUCK,
    BATTLE_SUBSCRIPT_FLING,
    BATTLE_SUBSCRIPT_RECOIL_1_3_CHANCE_TO_PARALYZE,
    BATTLE_SUBSCRIPT_RECOIL_1_2,
    BATTLE_SUBSCRIPT_BURN_OR_FLINCH,
    BATTLE_SUBSCRIPT_FREEZE_OR_FLINCH,
    BATTLE_SUBSCRIPT_PARALYZE_OR_FLINCH,
    BATTLE_SUBSCRIPT_CHATTER,
    BATTLE_SUBSCRIPT_LUNAR_DANCE,
    BATTLE_SUBSCRIPT_GIVE_TARGET_OWN_STATUS,
    BATTLE_SUBSCRIPT_USER_ATK_DEF_ACC_UP_1_STAGE,
    BATTLE_SUBSCRIPT_USER_SPATK_SPDEF_SPEED_UP_1_STAGE,
    BATTLE_SUBSCRIPT_TARGET_ATK_AND_SP_ATK_DOWN_1_STAGE,
    BATTLE_SUBSCRIPT_POISON_AND_SPEED_DOWN,
    BATTLE_SUBSCRIPT_ATTACK_UP_3_ON_FAINT,
    BATTLE_SUBSCRIPT_GIVE_HELD_ITEM,
    BATTLE_SUBSCRIPT_LASER_FOCUS,
    BATTLE_SUBSCRIPT_POWDER,
    BATTLE_SUBSCRIPT_STUFF_CHEEKS,
    BATTLE_SUBSCRIPT_ION_DELUGE,
    BATTLE_SUBSCRIPT_ATK_SP_ATK_DOWN,
    BATTLE_SUBSCRIPT_DECORATE,
    BATTLE_SUBSCRIPT_HOWL,
    BATTLE_SUBSCRIPT_ENTRAINMENT,
    BATTLE_SUBSCRIPT_LIFE_DEW,
    BATTLE_SUBSCRIPT_COACHING,
    BATTLE_SUBSCRIPT_POLLEN_PUFF_HEAL,
    BATTLE_SUBSCRIPT_HEAL_PULSE,
    BATTLE_SUBSCRIPT_STRENGTH_SAP,
    BATTLE_SUBSCRIPT_AURORA_VEIL,
    BATTLE_SUBSCRIPT_CHANGE_TARGET_TO_PSYCHIC_TYPE,
    BATTLE_SUBSCRIPT_ADD_TYPE_GHOST,
    BATTLE_SUBSCRIPT_ADD_TYPE_GRASS,
    BATTLE_SUBSCRIPT_TIDY_UP,
    BATTLE_SUBSCRIPT_TAKE_HEART,
    BATTLE_SUBSCRIPT_ATK_SP_ATK_SPEED_DOWN,
    BATTLE_SUBSCRIPT_MAKE_IT_RAIN,
    BATTLE_SUBSCRIPT_BURN_AND_DRAIN_HEALTH,
    BATTLE_SUBSCRIPT_DRAIN_THREE_QUARTERS,
    BATTLE_SUBSCRIPT_RAISE_ALL_STATS_LOSE_THIRD_MAX_HP,
    BATTLE_SUBSCRIPT_ATK_DEF_SPEED_UP,
    BATTLE_SUBSCRIPT_HYPERSPACE_FURY,
    BATTLE_SUBSCRIPT_USER_DEF_DOWN_HIT,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE,
    BATTLE_SUBSCRIPT_GIVE_TARGET_SIMPLE,
    BATTLE_SUBSCRIPT_DRAIN_FULL,
    BATTLE_SUBSCRIPT_HANDLE_QUASH,
    BATTLE_SUBSCRIPT_HANDLE_AFTER_YOU,
    BATTLE_SUBSCRIPT_HANDLE_SHED_TAIL,
    BATTLE_SUBSCRIPT_ATK_SP_ATK_SPEED_UP_2_LOSE_HALF_MAX_HP,
    BATTLE_SUBSCRIPT_SPICY_EXTRACT,
    BATTLE_SUBSCRIPT_ATK_SP_ATK_UP,
    BATTLE_SUBSCRIPT_USER_DEF_SP_DEF_SPEED_DOWN_HIT,
    BATTLE_SUBSCRIPT_ATK_SP_ATK_SPEED_UP_2_DEF_SP_DEF_DOWN,
    BATTLE_SUBSCRIPT_SHIFT_GEAR,
    BATTLE_SUBSCRIPT_CHANGE_TARGET_TO_WATER_TYPE,
    BATTLE_SUBSCRIPT_AUTOTOMIZE,
    BATTLE_SUBSCRIPT_POWER_SPLIT,
    BATTLE_SUBSCRIPT_GUARD_SPLIT,
    BATTLE_SUBSCRIPT_RAISE_ATTACK_AND_ACCURACY,
    BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END,
    BATTLE_SUBSCRIPT_JAW_LOCK,
    BATTLE_SUBSCRIPT_SET_STEALTH_ROCK,
    BATTLE_SUBSCRIPT_SET_SPIKES,
    BATTLE_SUBSCRIPT_FELL_STRAIGHT_DOWN,
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE, // sp. attack down three stages -- no room for it in the run above
    BATTLE_SUBSCRIPT_RECOIL_HALF_MAX_HP,
    BATTLE_SUBSCRIPT_CLEAR_SMOG,
    BATTLE_SUBSCRIPT_INCINERATE,
    BATTLE_SUBSCRIPT_MORTAL_SPIN,
    BATTLE_SUBSCRIPT_HANDLE_GROWTH,
    BATTLE_SUBSCRIPT_SPEED_SWAP,
    BATTLE_SUBSCRIPT_TOPSY_TURVY,
    BATTLE_SUBSCRIPT_REFLECT_TYPE,
    BATTLE_SUBSCRIPT_PURIFY,
    BATTLE_SUBSCRIPT_CORE_ENFORCER,
    BATTLE_SUBSCRIPT_ELECTRIFY,
    BATTLE_SUBSCRIPT_NO_RETREAT,
    BATTLE_SUBSCRIPT_OCTOLOCK,
    BATTLE_SUBSCRIPT_SALT_CURE,
    BATTLE_SUBSCRIPT_SYRUP_BOMB,
    BATTLE_SUBSCRIPT_TAR_SHOT,
    BATTLE_SUBSCRIPT_TRIPLE_ARROWS,
    BATTLE_SUBSCRIPT_EERIE_SPELL,
    BATTLE_SUBSCRIPT_DRAGON_CHEER,
    BATTLE_SUBSCRIPT_CORROSIVE_GAS,
    BATTLE_SUBSCRIPT_DOODLE,
    BATTLE_SUBSCRIPT_TELEKINESIS,
    BATTLE_SUBSCRIPT_INSTRUCT,
    BATTLE_SUBSCRIPT_THROAT_CHOP
};

static int GetMoveStatusChangeScript(BattleContext *ctx, int statChangeType, u32 flag) {
    ctx->statChangeType = statChangeType;
    ctx->statChangeParam = flag & (0x7FFFFF);
    ctx->statChangeFlag = flag & (0xFF800000);

    if (flag & (1 << 30)) {
        ctx->battlerIdStatChange = ctx->battlerIdAttacker;
    } else if (flag & (1 << 31)) {
        ctx->battlerIdStatChange = ctx->battlerIdTarget;
    } else if ((flag & (1 << 29)) || (flag & (1 << 28))) {
        ctx->battlerIdStatChange = BATTLER_PLAYER;
    }

    GF_ASSERT(NELEMS(sMoveStatusChangeScripts) > (flag & (0x7FFFFF)));

    return sMoveStatusChangeScripts[flag & (0x7FFFFF)];
}

// One row of the chart that applies, for the flags alone: a super-effective
// row and a not-very-effective one cancel, as in HeartGold. The damage is
// scaled by CalcTypeEffectiveness, once, from all the rows together.
static void ov12_022583B4(int typeEffectiveness, int moveDamage, u32 *flag) {
    switch (typeEffectiveness) {
    case TYPE_MUL_NO_EFFECT:
        *flag |= MOVE_STATUS_NO_EFFECT;
        *flag &= ~MOVE_STATUS_NOT_VERY_EFFECTIVE;
        *flag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
        break;
    case TYPE_MUL_NOT_EFFECTIVE:
        if (moveDamage) {
            if (*flag & MOVE_STATUS_SUPER_EFFECTIVE) {
                *flag &= ~MOVE_STATUS_SUPER_EFFECTIVE;
            } else {
                *flag |= MOVE_STATUS_NOT_VERY_EFFECTIVE;
            }
        }
        break;
    case TYPE_MUL_SUPER_EFFECTIVE:
        if (moveDamage) {
            if (*flag & MOVE_STATUS_NOT_VERY_EFFECTIVE) {
                *flag &= ~MOVE_STATUS_NOT_VERY_EFFECTIVE;
            } else {
                *flag |= MOVE_STATUS_SUPER_EFFECTIVE;
            }
        }
        break;
    }
}

static int ov12_02258440(BattleContext *ctx, int moveNo) {
    switch (BattleMoveTbl(ctx, moveNo)->effect) {
    case MOVE_EFFECT_BIDE:
    case MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT:
    case MOVE_EFFECT_CHARGE_TURN_HIGH_CRIT_FLINCH:
    case MOVE_EFFECT_CHARGE_TURN_DEF_UP:
    case MOVE_EFFECT_151:
    case MOVE_EFFECT_FLY:
    case MOVE_EFFECT_DIVE:
    case MOVE_EFFECT_DIG:
    case MOVE_EFFECT_BOUNCE:
    case MOVE_EFFECT_SHADOW_FORCE:
        return ctx->battleStatus & BATTLE_STATUS_CHARGE_MOVE_HIT;
    }

    return TRUE;
}

static u8 Battler_GetType(BattleContext *ctx, int battlerId, int var) {
    u8 type;

    if (var == BMON_DATA_TYPE_1) {
        type = ctx->battleMons[battlerId].type1;
    } else if (var == BMON_DATA_TYPE_2) {
        type = ctx->battleMons[battlerId].type2;
    } else if (var == BMON_DATA_TYPE_3) {
        // Nothing here gives a third type, so it is usually TYPE_NONE, and a
        // Pokemon with none of one is not an Arceus holding a plate either.
        return ctx->battleMons[battlerId].type3;
    } else {
        GF_ASSERT(FALSE);
    }

    if (ctx->battleMons[battlerId].species == SPECIES_ARCEUS && ctx->battleMons[battlerId].ability == ABILITY_MULTITYPE) {
        switch (GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT)) {
        case HOLD_EFFECT_ARCEUS_FIRE:
            type = TYPE_FIRE;
            break;
        case HOLD_EFFECT_ARCEUS_WATER:
            type = TYPE_WATER;
            break;
        case HOLD_EFFECT_ARCEUS_ELECTRIC:
            type = TYPE_ELECTRIC;
            break;
        case HOLD_EFFECT_ARCEUS_GRASS:
            type = TYPE_GRASS;
            break;
        case HOLD_EFFECT_ARCEUS_ICE:
            type = TYPE_ICE;
            break;
        case HOLD_EFFECT_ARCEUS_FIGHTING:
            type = TYPE_FIGHTING;
            break;
        case HOLD_EFFECT_ARCEUS_POISON:
            type = TYPE_POISON;
            break;
        case HOLD_EFFECT_ARCEUS_GROUND:
            type = TYPE_GROUND;
            break;
        case HOLD_EFFECT_ARCEUS_FLYING:
            type = TYPE_FLYING;
            break;
        case HOLD_EFFECT_ARCEUS_PSYCHIC:
            type = TYPE_PSYCHIC;
            break;
        case HOLD_EFFECT_ARCEUS_BUG:
            type = TYPE_BUG;
            break;
        case HOLD_EFFECT_ARCEUS_ROCK:
            type = TYPE_ROCK;
            break;
        case HOLD_EFFECT_ARCEUS_GHOST:
            type = TYPE_GHOST;
            break;
        case HOLD_EFFECT_ARCEUS_DRAGON:
            type = TYPE_DRAGON;
            break;
        case HOLD_EFFECT_ARCEUS_DARK:
            type = TYPE_DARK;
            break;
        case HOLD_EFFECT_ARCEUS_STEEL:
            type = TYPE_STEEL;
            break;
        // The Pixie Plate makes it Fairy, as hg-engine's hook here has it
        // (armips/asm/fairy.s, 0x022584FE).
        case HOLD_EFFECT_ARCEUS_FAIRY:
            type = TYPE_FAIRY;
            break;
        default:
            type = TYPE_NORMAL;
            break;
        }
    }
    // RKS System types Silvally by its Memory as Multitype does Arceus by its
    // plate, and the same way: the item as it is held.
    if (ctx->battleMons[battlerId].species == SPECIES_SILVALLY && ctx->battleMons[battlerId].ability == ABILITY_RKS_SYSTEM) {
        type = GetSilvallyTypeByHeldItemEffect(GetItemVar(ctx, ctx->battleMons[battlerId].item, ITEM_VAR_HOLD_EFFECT));
    }

    return type;
}

static void ov12_02258584(BattleContext *ctx, u8 battlerId) {
    for (int i = 0; i < MAX_MON_MOVES; i++) {
        ctx->trainerAIData.moves[battlerId][i] = MOVE_NONE;
    }
}

static void ov12_0225859C(BattleContext *ctx, u8 battlerId) {
    ctx->trainerAIAbilities[battlerId] = ABILITY_NONE;
}

static void ov12_022585A8(BattleContext *ctx, u8 battlerId) {
    ctx->trainerAIData.heldItems[battlerId] = ITEM_NONE;
}

// A foe Trace can copy from: standing, and with an ability the table does
// not keep from Trace (the reference's GetTraceClient). Retail's refused
// Forecast, Trace and Multitype.
static BOOL Battler_Traceable(BattleContext *ctx, int battlerId) {
    return ctx->battleMons[battlerId].hp && !(AbilityFlags(ctx->battleMons[battlerId].ability) & ABILITY_FLAG_FAILS_TRACE);
}

static int ov12_022585B8(BattleSystem *battleSystem, BattleContext *ctx, int battlerIdTarget1, int battlerIdTarget2) {
    int ret = BATTLER_NONE;

    if (Battler_Traceable(ctx, battlerIdTarget1) && Battler_Traceable(ctx, battlerIdTarget2)) {
        if (BattleSystem_Random(battleSystem) & 1) {
            ret = battlerIdTarget2;
        } else {
            ret = battlerIdTarget1;
        }
    } else if (Battler_Traceable(ctx, battlerIdTarget1)) {
        ret = battlerIdTarget1;
    } else if (Battler_Traceable(ctx, battlerIdTarget2)) {
        ret = battlerIdTarget2;
    }

    return ret;
}

static const u16 ov12_0226CB64[] = {
    MOVE_EFFECT_40_DAMAGE_FLAT,
    MOVE_EFFECT_LEVEL_DAMAGE_FLAT,
    MOVE_EFFECT_RANDOM_DAMAGE_1_TO_150_LEVEL,
    MOVE_EFFECT_COUNTER,
    MOVE_EFFECT_MIRROR_COAT,
    MOVE_EFFECT_METAL_BURST
};

static BOOL ov12_0225865C(BattleContext *ctx, int moveNo) {
    for (int i = 0; i < NELEMS(ov12_0226CB64); i++) {
        if (ov12_0226CB64[i] == BattleMoveTbl(ctx, moveNo)->effect) {
            return TRUE;
        }
    }

    return FALSE;
}

static int GetDynamicMoveType(BattleSystem *battleSystem, BattleContext *ctx, int battlerId, int moveNo) {
    int type;

    switch (moveNo) {
    case MOVE_NATURAL_GIFT:
        type = GetNaturalGiftType(ctx, battlerId);
        break;
    case MOVE_JUDGMENT:
        switch (GetBattlerHeldItemEffect(ctx, battlerId)) {
        case HOLD_EFFECT_ARCEUS_FIGHTING:
            type = TYPE_FIGHTING;
            break;
        case HOLD_EFFECT_ARCEUS_FLYING:
            type = TYPE_FLYING;
            break;
        case HOLD_EFFECT_ARCEUS_POISON:
            type = TYPE_POISON;
            break;
        case HOLD_EFFECT_ARCEUS_GROUND:
            type = TYPE_GROUND;
            break;
        case HOLD_EFFECT_ARCEUS_ROCK:
            type = TYPE_ROCK;
            break;
        case HOLD_EFFECT_ARCEUS_BUG:
            type = TYPE_BUG;
            break;
        case HOLD_EFFECT_ARCEUS_GHOST:
            type = TYPE_GHOST;
            break;
        case HOLD_EFFECT_ARCEUS_STEEL:
            type = TYPE_STEEL;
            break;
        case HOLD_EFFECT_ARCEUS_FIRE:
            type = TYPE_FIRE;
            break;
        case HOLD_EFFECT_ARCEUS_WATER:
            type = TYPE_WATER;
            break;
        case HOLD_EFFECT_ARCEUS_GRASS:
            type = TYPE_GRASS;
            break;
        case HOLD_EFFECT_ARCEUS_ELECTRIC:
            type = TYPE_ELECTRIC;
            break;
        case HOLD_EFFECT_ARCEUS_PSYCHIC:
            type = TYPE_PSYCHIC;
            break;
        case HOLD_EFFECT_ARCEUS_ICE:
            type = TYPE_ICE;
            break;
        case HOLD_EFFECT_ARCEUS_DRAGON:
            type = TYPE_DRAGON;
            break;
        case HOLD_EFFECT_ARCEUS_DARK:
            type = TYPE_DARK;
            break;
        // Judgment with the Pixie Plate is Fairy
        // (other_battle_calculators.c:3387).
        case HOLD_EFFECT_ARCEUS_FAIRY:
            type = TYPE_FAIRY;
            break;
        default:
            type = TYPE_NORMAL;
            break;
        }
        break;
    case MOVE_HIDDEN_POWER:
        type = (ctx->battleMons[battlerId].hpIV & 1) | ((ctx->battleMons[battlerId].atkIV & 1) << 1) | ((ctx->battleMons[battlerId].defIV & 1) << 2) | ((ctx->battleMons[battlerId].speedIV & 1) << 3) | ((ctx->battleMons[battlerId].spAtkIV & 1) << 4) | ((ctx->battleMons[battlerId].spDefIV & 1) << 5);

        type = (type * 15 / 63) + 1;

        if (type >= TYPE_MYSTERY) {
            type++;
        }
        break;
    case MOVE_WEATHER_BALL:
        // What the move will be, as BtlCmd_CalcWeatherBallParams decides it:
        // under Mega Sol, Fire. Normal where no weather makes it anything else
        // -- a clear sky, the fog, the strong winds, Cloud Nine or Air Lock,
        // the rain or the sun under a Utility Umbrella -- which retail left
        // unset for Lightning Rod to read (Pokemon Central, Palla Clima; the
        // reference's BUGFIX, other_battle_calculators.c:3326).
        type = WeatherBallType(WeatherBallWeather(BattlerMoveWeather(battleSystem, ctx, battlerId), GetBattlerHeldItemEffect(ctx, battlerId)));
        break;
    // Terrain Pulse takes the colour of whatever is underfoot, and only if the
    // user is standing on it. With nothing down it stays Normal, which is what
    // the default below would have said anyway.
    case MOVE_TERRAIN_PULSE:
        type = TYPE_NORMAL;
        if (BattlerIsGrounded(ctx, battlerId) == TRUE) {
            switch (ctx->terrainOverlayType) {
            case GRASSY_TERRAIN:
                type = TYPE_GRASS;
                break;
            case ELECTRIC_TERRAIN:
                type = TYPE_ELECTRIC;
                break;
            case MISTY_TERRAIN:
                type = TYPE_FAIRY;
                break;
            case PSYCHIC_TERRAIN:
                type = TYPE_PSYCHIC;
                break;
            }
        }
        break;
    // Techno Blast takes the Drive's type and Multi-Attack the Memory's, for
    // whoever holds one (GetDriveOrMemoryType). The damage already had them
    // from effect scripts 312 and 313; this is the type the redirecting
    // abilities are asked about, so a Shock Drive's Techno Blast goes to a
    // Lightning Rod and a Water Memory's Multi-Attack to Storm Drain.
    case MOVE_TECHNO_BLAST:
    case MOVE_MULTI_ATTACK:
        type = GetDriveOrMemoryType(moveNo, GetBattlerHeldItemEffect(ctx, battlerId));
        break;
    default:
        type = TYPE_NORMAL;
        break;
    }

    return type;
}

// The type of Techno Blast with the Drive its user holds and of Multi-Attack
// with the Memory, as the reference's GetDynamicMoveType has them
// (other_battle_calculators.c:3434 and 3466 at d0380a487); with anything else,
// Normal. GetDynamicMoveType and the trainer AI's own three type lookups all
// ask it.
int GetDriveOrMemoryType(int moveNo, int holdEffect) {
    int type = TYPE_NORMAL;

    if (moveNo == MOVE_TECHNO_BLAST) {
        switch (holdEffect) {
        case HOLD_EFFECT_BURN_DRIVE:
            type = TYPE_FIRE;
            break;
        case HOLD_EFFECT_DOUSE_DRIVE:
            type = TYPE_WATER;
            break;
        case HOLD_EFFECT_SHOCK_DRIVE:
            type = TYPE_ELECTRIC;
            break;
        case HOLD_EFFECT_CHILL_DRIVE:
            type = TYPE_ICE;
            break;
        }
    } else if (moveNo == MOVE_MULTI_ATTACK) {
        // The Memory's type is RKS System's own (GetSilvallyTypeByHeldItemEffect).
        type = GetSilvallyTypeByHeldItemEffect(holdEffect);
    }

    return type;
}
