#include "global.h"

#include "msgdata/msg.naix"

#include "heap.h"
#include "overlay_40.h"
#include "pokedex.h"

extern u16 ov40_02245E44[];
extern u16 *ov40_0222DD68(enum HeapID heapID, int unused, int *count);

// ov40_02235E34 for the other search screen: a letter group's species in
// the Dex's alphabetical order, the ones the player has seen first, a row for
// each of those, and the species names.
void ov40_0223EC40(Overlay40App *app, int group) {
    u16 *all;
    Pokedex *pokedex;
    int start;
    Overlay40SearchScreen2 *screen = app->screen;
    int end = ov40_02245E44[group + 1];
    int i;

    start = ov40_02245E44[group];
    screen->list.species = ov40_0222DD68(HEAP_ID_109, 0, &screen->list.numSpecies);
    all = ov40_0222DD68(HEAP_ID_109, 0, &screen->list.numSpecies);
    pokedex = Save_Pokedex_Get(app->saveData);
    screen->list.numSeen = 0;
    for (i = start; i < end; i++) {
        if (!Pokedex_CheckMonSeenFlag(pokedex, all[i])) {
            all[i] = 0xFFFF;
        } else {
            screen->list.numSeen++;
        }
    }
    i = 0;
    for (; start < end; start++) {
        if (all[start] != 0xFFFF) {
            screen->list.species[i] = all[start];
            i++;
        }
    }
    for (; i < screen->list.numSpecies; i++) {
        screen->list.species[i] = all[i];
    }
    Heap_Free(all);
    screen->list.rows = Heap_Alloc(HEAP_ID_109, screen->list.numSeen * sizeof(Overlay40SpeciesRow));
    MI_CpuFill8(screen->list.rows, 0, screen->list.numSeen * sizeof(Overlay40SpeciesRow));
    for (i = 0; i < screen->list.numSeen; i++) {
        screen->list.rows[i].unk0 = screen->list.species[i];
        screen->list.rows[i].unk4 = screen->list.species[i];
    }
    screen->list.speciesNames = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0237_bin, HEAP_ID_109);
    screen->list.speciesNamesOpen = TRUE;
}
