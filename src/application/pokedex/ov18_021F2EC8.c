#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "sprite_system.h"

// The caught mark of a grid entry, in the sprite spriteIdx: shown when the
// grid list at 0x1030 has the species caught.
void ov18_021F2EC8(PokedexAppData *pokedexApp, int idx, int spriteIdx) {
    if (pokedexApp->unk_1030[idx].unk_2 == 2) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
    } else {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
    }
}
