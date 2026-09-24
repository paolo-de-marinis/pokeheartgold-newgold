#include "global.h"

#include "application/zukanlist/zkn_data/zukan_data.naix"
#include "msgdata/msg.naix"

#include "filesystem.h"
#include "heap.h"
#include "overlay_40.h"
#include "pokedex.h"

extern u16 *ov40_0222DD68(enum HeapID heapID, int unused, int *count);

// The stretch of the Dex's alphabetical order (zukan data 13) that a letter
// group, ABC to YZ, takes. The zukan data keeps each group's own list too,
// in the same order, and the groups follow one another in the whole: a
// group starts where the ones before it end. Retail wrote the bounds in, a
// table for each search screen, for its 493 species: read against this
// Dex's 1025 they cut YZ at Linoone and left everything after it out.
void VsRecorder_GetLetterGroupBounds(int group, int *start, int *end) {
    int i;

    *start = 0;
    for (i = 0; i < group; i++) {
        *start += GetNarcMemberSizeByIdPair(NARC_application_zukanlist_zkn_data_zukan_data, NARC_zukan_data_sort_order_letter_groups_abc + i) / sizeof(u16);
    }
    *end = *start + GetNarcMemberSizeByIdPair(NARC_application_zukanlist_zkn_data_zukan_data, NARC_zukan_data_sort_order_letter_groups_abc + group) / sizeof(u16);
}

// Whether the player has seen any species of a letter group, which the
// search screen asks of each group before it offers it: the group's stretch
// of the Dex's alphabetical order with the unseen struck out, and whether
// any is left.
BOOL ov40_02235DAC(Overlay40App *app, int group) {
    int count;
    BOOL found = FALSE;
    u16 *all;
    Pokedex *pokedex;
    int start;
    int end;
    int i;

    VsRecorder_GetLetterGroupBounds(group, &start, &end);
    all = ov40_0222DD68(HEAP_ID_109, found, &count);
    pokedex = Save_Pokedex_Get(app->saveData);
    for (i = start; i < end; i++) {
        if (!Pokedex_CheckMonSeenFlag(pokedex, all[i])) {
            all[i] = 0xFFFF;
        }
    }
    for (; start < end; start++) {
        if (all[start] != 0xFFFF) {
            found = TRUE;
            break;
        }
    }
    Heap_Free(all);
    return found;
}

// A letter group's species for the search: the Dex's alphabetical order from
// the group's first to its last, the ones the player has seen first, a row
// for each of those, and the species names. The names are opened lazily, a
// line at a time: whole, the bank is a line per species and form (36,302
// bytes, retail's 12,180), and only the rows shown are named.
void ov40_02235E34(Overlay40App *app, int group) {
    u16 *all;
    Pokedex *pokedex;
    int start;
    Overlay40SearchScreen *screen = app->screen;
    int end;
    int i;

    VsRecorder_GetLetterGroupBounds(group, &start, &end);
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
    screen->list.speciesNames = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0237_bin, HEAP_ID_109);
    screen->list.speciesNamesOpen = TRUE;
}
