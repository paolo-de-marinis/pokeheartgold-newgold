#include "global.h"

#include "application/pokedex/pokedex_internal.h"

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
