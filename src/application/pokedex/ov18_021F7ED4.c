#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"

u16 *ov18_021F8168(u32 member, u32 *count);
void ov18_021F8198(u16 *dest, u32 *destCount, Pokedex *pokedex, u16 *src, u32 srcCount);
void ov18_021F822C(u32 order, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F82CC(u32 letter, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F831C(u32 type, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F8468(u32 bodyType, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F8584(PokedexAppData *pokedexApp, u32 area, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F8640(PokedexAppData *pokedexApp, u16 min, u16 max, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);
void ov18_021F86D0(PokedexAppData *pokedexApp, u16 min, u16 max, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex);

// Builds the Dex list: the Dex's order (the Johto one before the National
// Dex) cut to the species seen, then put through the search's filters in
// turn -- order, first letter, the two types, body type, area, height and
// weight -- each keeping what the previous one let through; the list stops
// empty as soon as a filter leaves nothing. What is left becomes the list at
// 0x878, with its caught marks and counts. The two scratch lists hold
// retail's 493 species.
BOOL ov18_021F7ED4(PokedexAppData *pokedexApp, u8 natDex, u32 order, u32 letter, u32 type1, u32 type2, u32 heightMin, u32 heightMax, u32 weightMin, u32 weightMax, u32 area, u32 bodyType) {
    u16 *list;
    u16 *filtered;
    u16 *dexOrder;
    u32 dexOrderCount;
    u32 count;
    u32 filteredCount;

    MI_CpuClear32(&pokedexApp->unk_0878, sizeof(PokedexAppData_UnkSub0878));
    list = Heap_AllocAtEnd(HEAP_ID_POKEDEX_APP, MAX_SPECIES * sizeof(u16));
    GF_ASSERT(list != NULL);
    memset(list, 0, MAX_SPECIES * sizeof(u16));
    count = 0;
    filtered = Heap_AllocAtEnd(HEAP_ID_POKEDEX_APP, MAX_SPECIES * sizeof(u16));
    GF_ASSERT(filtered != NULL);
    memset(filtered, 0, MAX_SPECIES * sizeof(u16));
    filteredCount = 0;
    if (natDex == FALSE) {
        dexOrder = ov18_021F8168(1, &dexOrderCount);
    } else {
        dexOrder = ov18_021F8168(0, &dexOrderCount);
    }
    ov18_021F8198(list, &count, pokedexApp->args->pokedex, dexOrder, dexOrderCount);

    ov18_021F822C(order, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F82CC(letter, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    if (filteredCount == 0) {
        goto done;
    }
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F831C(type1, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    if (filteredCount == 0) {
        goto done;
    }
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F831C(type2, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    if (filteredCount == 0) {
        goto done;
    }
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F8468(bodyType, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    if (filteredCount == 0) {
        goto done;
    }
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    if (pokedexApp->unk_1860 == 0 && (area & 4)) {
        ov18_021F8584(pokedexApp, 6, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
        if (filteredCount != 0) {
            goto filter_size;
        }
        goto done;
    } else {
        ov18_021F8584(pokedexApp, area, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
        if (filteredCount == 0) {
            goto done;
        }
    }
filter_size:
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F8640(pokedexApp, heightMin, heightMax, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    memcpy(list, filtered, filteredCount * sizeof(u16));
    count = filteredCount;
    memset(filtered, 0, filteredCount * sizeof(u16));
    filteredCount = 0;

    ov18_021F86D0(pokedexApp, weightMin, weightMax, filtered, &filteredCount, list, count, pokedexApp->args->pokedex);
    ov18_021F81D8(&pokedexApp->unk_0878, pokedexApp->args->pokedex, filtered, filteredCount);

done:
    Heap_Free(dexOrder);
    Heap_Free(filtered);
    Heap_Free(list);
    return TRUE;
}
