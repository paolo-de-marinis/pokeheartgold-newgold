#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex_util.h"

// The species of the grid entry under the cursor.
u16 ov18_021F8838(PokedexAppData *pokedexApp) {
    return pokedexApp->unk_1030[ov18_021F8824(pokedexApp)].unk_0;
}

// The species of the Dex list at 0x878 to show: the one asked for if the
// list holds it, else the list's first.
u32 ov18_021F8850(PokedexAppData_UnkSub0878 *list, u16 species) {
    u32 i;
    u16 first = SPECIES_NONE;

    for (i = 0; i < list->unk_7B4; i++) {
        if (first == SPECIES_NONE) {
            first = list->unk_000[i][0];
        }
        if (species == list->unk_000[i][0]) {
            return species;
        }
    }
    return first;
}

// Fills the grid list at 0x1030 from the Dex list at 0x878. Laid out by
// number (layout 1), each species goes to the slot of its Dex number, so the
// grid keeps the gaps; otherwise the list is copied in its order, from the
// second slot.
void ov18_021F8884(PokedexAppData *pokedexApp, int layout) {
    u32 i;

    MI_CpuClear32(pokedexApp->unk_1030, POKEDEX_GRID_LIST_LEN * sizeof(*pokedexApp->unk_1030));
    if (layout == 1) {
        for (i = 0; i < pokedexApp->unk_0878.unk_7B4; i++) {
            u32 idx = Pokedex_ConvertToCurrentDexNo(pokedexApp->unk_1858, pokedexApp->unk_0878.unk_000[i][0]) - 1;
            pokedexApp->unk_1030[idx].unk_0 = pokedexApp->unk_0878.unk_000[i][0];
            pokedexApp->unk_1030[idx].unk_2 = pokedexApp->unk_0878.unk_000[i][1];
        }
    } else {
        for (i = 0; i < pokedexApp->unk_0878.unk_7B4; i++) {
            pokedexApp->unk_1030[i + 1].unk_0 = pokedexApp->unk_0878.unk_000[i][0];
            pokedexApp->unk_1030[i + 1].unk_2 = pokedexApp->unk_0878.unk_000[i][1];
        }
    }
}

// The length of the Dex list: its count, or laid out by number, the Dex
// number of its last species.
u32 ov18_021F891C(PokedexAppData *pokedexApp, BOOL byNumber) {
    if (byNumber == FALSE) {
        return pokedexApp->unk_0878.unk_7B4;
    }
    return Pokedex_ConvertToCurrentDexNo(pokedexApp->unk_1858, pokedexApp->unk_0878.unk_000[pokedexApp->unk_0878.unk_7B4 - 1][0]);
}
