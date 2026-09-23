#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"

// Writes the Dex list at 0x878: each species with its state, 2 caught and 1
// seen, and the counts of both.
void ov18_021F81D8(PokedexAppData_UnkSub0878 *list, Pokedex *pokedex, u16 *species, u32 count) {
    u32 i;

    list->unk_7B4 = count;
    list->unk_7B6 = 0;
    for (i = 0; i < count; i++) {
        list->unk_000[i][0] = species[i];
        if (Pokedex_CheckMonCaughtFlag(pokedex, species[i])) {
            list->unk_000[i][1] = 2;
            list->unk_7B6++;
        } else {
            list->unk_000[i][1] = 1;
        }
    }
}
