#include "constants/abilities.h"
#include "constants/moves.h"

#include "frontier/overlay_80_02229EE0.h"

#include "msgdata.h"
#include "pm_version.h"
#include "unk_0204A3F4.h"

extern const u16 ov80_0223C048[4];
NarcId ov80_02236AF0(u8 towerMode);

u32 ov80_02236734(FrontierFieldSystem *frontierFsys, FrontierMon *frontierMon, u16 frontierMonIndex, u32 otId, u32 pid, u8 iv, u8 replacementItemIndex, BOOL replaceItem, enum HeapID heapID) {
    s32 i;
    FrontierMonNarcData frontierMonNarcData;
    MI_CpuClear8(frontierMon, sizeof(FrontierMon));
    ov80_02229EF4(&frontierMonNarcData, frontierMonIndex, ov80_02236AF0(frontierFsys->towerMode));
    frontierMon->species = frontierMonNarcData.species;
    frontierMon->form = frontierMonNarcData.form;
    frontierMon->item = replaceItem ? ov80_0223C048[replacementItemIndex] : frontierMonNarcData.item;
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
            pidGen = FrontierFieldSystem_0204B510(frontierFsys) | FrontierFieldSystem_0204B510(frontierFsys) << 16;
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
