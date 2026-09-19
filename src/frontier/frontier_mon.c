#include "constants/abilities.h"
#include "constants/moves.h"

#include "frontier/overlay_80_02229EE0.h"
#include "msgdata/msg.naix"

#include "math_util.h"
#include "msgdata.h"
#include "pm_version.h"

extern const u16 _0223B620[4];

typedef char FrontierMonSizeCheck[sizeof(FrontierMon) == 0x38 ? 1 : -1];
typedef char FrontierMonAbilityOffsetCheck[offsetof(FrontierMon, ability) == 0x20 ? 1 : -1];
typedef char FrontierMonNarcSizeCheck[sizeof(FrontierMonNarcData) == 0x10 ? 1 : -1];

u32 ov80_02229F6C(FrontierMon *frontierMon, u32 frontierMonIndex, u32 otId, u32 pid, u8 iv, u8 replacementItemIndex, BOOL replaceItem, enum HeapID heapID, NarcId narcId) {
    s32 i;
    FrontierMonNarcData frontierMonNarcData;
    MI_CpuClear8(frontierMon, sizeof(FrontierMon));
    ov80_02229EF4(&frontierMonNarcData, frontierMonIndex, narcId);
    frontierMon->species = frontierMonNarcData.species;
    frontierMon->form = frontierMonNarcData.form;
    if (replaceItem) {
        if (replacementItemIndex >= 4) {
            replacementItemIndex &= 3;
        }
        frontierMon->item = _0223B620[replacementItemIndex];
    } else {
        frontierMon->item = frontierMonNarcData.item;
    }
    u32 friendship = FRIENDSHIP_MAX;
    for (i = 0; i < MAX_MON_MOVES; i++) {
        frontierMon->moves[i] = frontierMonNarcData.moves[i];
        if (frontierMonNarcData.moves[i] == MOVE_FRUSTRATION) {
            friendship = 0;
        }
    }
    frontierMon->otId = otId;
    u32 pidGen;
    if (pid == 0) {
        do {
            pidGen = LCRandom() | LCRandom() << 16;
        } while (frontierMonNarcData.nature != GetNatureFromPersonality(pidGen)
            || CalcShininessByOtIdAndPersonality(otId, pidGen) == TRUE);
        frontierMon->pid = pidGen;
    } else {
        frontierMon->pid = pid;
        pidGen = pid;
    }
    frontierMon->hpIv = iv;
    frontierMon->atkIv = iv;
    frontierMon->defIv = iv;
    frontierMon->spdIv = iv;
    frontierMon->spAtkIv = iv;
    frontierMon->spDefIv = iv;
    s32 ev = 0;
    for (i = 0; i < NUM_STATS; i++) {
        if (frontierMonNarcData.evs & MaskOfFlagNo(i)) {
            ev++;
        }
    }
    ev = MAX_EV_SUM / ev;
    if (ev > 255) {
        ev = 255;
    }
    for (i = 0; i < NUM_STATS; i++) {
        if (frontierMonNarcData.evs & MaskOfFlagNo(i)) {
            frontierMon->evs[i] = (u8)ev;
        }
    }
    frontierMon->ppUp = 0;
    frontierMon->language = gGameLanguage;
    u32 ability = GetMonBaseStat(frontierMon->species, BASE_ABILITY_2);
    if (ability != ABILITY_NONE) {
        if (frontierMon->pid % 2) {
            frontierMon->ability = ability;
        } else {
            frontierMon->ability = GetMonBaseStat(frontierMon->species, BASE_ABILITY_1);
        }
    } else {
        frontierMon->ability = GetMonBaseStat(frontierMon->species, BASE_ABILITY_1);
    }
    frontierMon->friendship = friendship;
    GetSpeciesNameIntoArray(frontierMon->species, heapID, frontierMon->nickname);
    return pidGen;
}

void ov80_0222A140(FrontierMon *frontierMon, Pokemon *mon, int level) {
    u32 ivs;
    u32 otId;
    u16 move;
    u8 value;
    u8 pp;
    int i;

    ZeroMonData(mon);
    if (level == 120) {
        level = 50;
    } else if (level == 121) {
        level = 100;
    }
    ivs = frontierMon->ivsWord & 0x3FFFFFFF;
    CreateMon(mon, frontierMon->species, level, ivs, TRUE, frontierMon->pid, OT_ID_RANDOM_NO_SHINY, 0);
    SetMonData(mon, MON_DATA_COMBINED_IVS, &ivs);
    CalcMonLevelAndStats(mon);
    value = frontierMon->form;
    SetMonData(mon, MON_DATA_FORM, &value);
    SetMonData(mon, MON_DATA_HELD_ITEM, &frontierMon->item);
    for (i = 0; i < MAX_MON_MOVES; i++) {
        move = frontierMon->moves[i];
        SetMonData(mon, MON_DATA_MOVE1 + i, &move);
        value = (frontierMon->ppUp >> (i * 2)) & 3;
        SetMonData(mon, MON_DATA_MOVE1_PP_UPS + i, &value);
        pp = GetMonData(mon, MON_DATA_MOVE1_MAX_PP + i, NULL);
        SetMonData(mon, MON_DATA_MOVE1_PP + i, &pp);
    }
    otId = frontierMon->otId;
    SetMonData(mon, MON_DATA_OT_ID, &otId);
    value = frontierMon->evs[0];
    SetMonData(mon, MON_DATA_HP_EV, &value);
    value = frontierMon->evs[1];
    SetMonData(mon, MON_DATA_ATK_EV, &value);
    value = frontierMon->evs[2];
    SetMonData(mon, MON_DATA_DEF_EV, &value);
    value = frontierMon->evs[3];
    SetMonData(mon, MON_DATA_SPEED_EV, &value);
    value = frontierMon->evs[4];
    SetMonData(mon, MON_DATA_SPATK_EV, &value);
    value = frontierMon->evs[5];
    SetMonData(mon, MON_DATA_SPDEF_EV, &value);
    SetMonData(mon, MON_DATA_ABILITY, &frontierMon->ability);
    SetMonData(mon, MON_DATA_FRIENDSHIP, &frontierMon->friendship);
    if (frontierMon->useSpeciesName) {
        MsgData *msgData = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0237_bin, HEAP_ID_FIELD1);
        String *name = NewString_ReadMsgData(msgData, frontierMon->species);
        SetMonData(mon, MON_DATA_NICKNAME_STRING, name);
        String_Delete(name);
        DestroyMsgData(msgData);
    } else {
        SetMonData(mon, MON_DATA_NICKNAME, frontierMon->nickname);
    }
    SetMonData(mon, MON_DATA_LANGUAGE, &frontierMon->language);
    CalcMonLevelAndStats(mon);
}
