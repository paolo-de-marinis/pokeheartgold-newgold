#include "application/pokedex/pokedex_internal.h"

#include "dex_mon_measures.h"
#include "overlay_18.h"
#include "sound_02004A44.h"

BOOL Pokedex_Init(OverlayManager *man, int *state) {
    PokedexAppData *appData;

    // Retail's 0x61000 held lists sized for 493 species. The Dex's lists and
    // the sort lists they are built from take every Dex species now, and the
    // heap is the reference's (armips/asm/pokedex.s, "give about 12 more
    // kb"): 24 KB more, which heap 3 has -- it gives the PC's storage system
    // 512 KB from the same field and keeps 100 KB after it.
    Heap_Create(HEAP_ID_3, HEAP_ID_POKEDEX_APP, 0x67000);
    appData = OverlayManager_CreateAndGetData(man, sizeof(PokedexAppData), HEAP_ID_POKEDEX_APP);
    MI_CpuClear8(appData, sizeof(PokedexAppData));
    appData->unk_0878.unk_000 = Heap_Alloc(HEAP_ID_POKEDEX_APP, POKEDEX_LIST_LEN * sizeof(*appData->unk_0878.unk_000));
    MI_CpuClear8(appData->unk_0878.unk_000, POKEDEX_LIST_LEN * sizeof(*appData->unk_0878.unk_000));
    appData->unk_1030 = Heap_Alloc(HEAP_ID_POKEDEX_APP, POKEDEX_GRID_LIST_LEN * sizeof(*appData->unk_1030));
    MI_CpuClear8(appData->unk_1030, POKEDEX_GRID_LIST_LEN * sizeof(*appData->unk_1030));
    appData->args = OverlayManager_GetArgs(man);
    appData->unk_085C = 5;
    appData->unk_1858 = UnkStruct_02092BB8_GetUnk2(appData->args->unk_08);
    if (Pokedex_GetNatDexFlag(appData->args->pokedex)) {
        appData->unk_1860 = TRUE;
        if (appData->unk_1858 == 2) {
            appData->unk_1858 = 1;
        }
    } else {
        appData->unk_1860 = FALSE;
        if (appData->unk_1858 == 2) {
            appData->unk_1858 = 0;
        }
    }
    if (Pokedex_CheckMonCaughtFlag(appData->args->pokedex, SPECIES_GIRATINA) == TRUE) {
        SetDexBanksByGiratinaForm(Pokedex_GetSeenFormByIdx(appData->args->pokedex, SPECIES_GIRATINA, 0));
    } else {
        SetDexBanksByGiratinaForm(GIRATINA_ALTERED);
    }
    GF_SndHandleSetPlayerVolume(1, 42);
    appData->unk_185C = 2;
    return TRUE;
}

BOOL Pokedex_Main(OverlayManager *man, int *state) {
    PokedexAppData *appData = OverlayManager_GetData(man);

    if (!PokedexApp_RunMainSeq(appData, state)) {
        return TRUE;
    } else {
        return FALSE;
    }
}

BOOL Pokedex_Exit(OverlayManager *man, int *state) {
    PokedexAppData *appData = OverlayManager_GetData(man);

    UnkStruct_02092BB8_Set(appData->args->unk_08, ov18_021F8838(appData), appData->unk_1858);
    Heap_Free(appData->unk_1030);
    Heap_Free(appData->unk_0878.unk_000);
    OverlayManager_FreeData(man);
    Heap_Destroy(HEAP_ID_POKEDEX_APP);
    GF_SndHandleSetPlayerVolume(1, 127);
    sub_02004B10();
    return TRUE;
}
