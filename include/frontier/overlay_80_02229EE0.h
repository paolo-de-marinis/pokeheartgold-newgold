#ifndef POKEHEARTGOLD_OVERLAY_80_02229EE0
#define POKEHEARTGOLD_OVERLAY_80_02229EE0

#include "global.h"

#include "pokemon.h"
#include "scrcmd_9.h"

typedef struct FrontierTrainerData {
    u8 unk0[0x18];
    u16 unk18[4];
    u8 unk1C[0xF0];
} FrontierTrainerData;

void ov80_02229EF4(FrontierMonNarcData *dest, u32 index, NarcId narcId);
u32 ov80_02229F6C(FrontierMon *frontierMon, u32 frontierMonIndex, u32 otId, u32 pid, u8 iv, u8 replacementItemIndex, BOOL replaceItem, enum HeapID heapID, NarcId narcId);
void ov80_0222A140(FrontierMon *frontierMon, Pokemon *mon, int level);
u32 ov80_02236734(FrontierFieldSystem *frontierFsys, FrontierMon *frontierMon, u16 frontierMonIndex, u32 otId, u32 pid, u8 iv, u8 replacementItemIndex, BOOL replaceItem, enum HeapID heapID);
void ov80_0222A474(FrontierTrainerData *a0, u16 a1, u32 a2, u32 a3);
void ov80_0222A52C(void *a0, u16 *a1, u8 *a2, u32 *a3, void *a4, u32 a5, u32 a6, u32 a7);

#endif
