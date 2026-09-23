#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"
#include "sprite_system.h"

void ov18_021F111C(PokedexAppData *pokedexApp, int spriteIdx, void *charData, int size, int a4);
void *ov18_021F9694(u32 species, enum HeapID heapId);

// The footprint of an entry's species, in the sprite spriteIdx, on the
// entry's pages in the Dex's own language. A species only seen, and Origin
// Forme Giratina, show none.
void ov18_021F1DE4(PokedexAppData *pokedexApp, u32 species, int idx, int spriteIdx) {
    void *charData;

    if (pokedexApp->unk_185C != 2 || species == SPECIES_NONE || pokedexApp->unk_1030[idx].unk_2 == 1
        || (species == SPECIES_GIRATINA && Pokedex_GetSeenFormByIdx(pokedexApp->args->pokedex, species, 0) == 1)) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
        return;
    }
    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
    charData = ov18_021F9694(species, HEAP_ID_POKEDEX_APP);
    ov18_021F111C(pokedexApp, spriteIdx, charData, 0x80, 2);
    Heap_Free(charData);
}
