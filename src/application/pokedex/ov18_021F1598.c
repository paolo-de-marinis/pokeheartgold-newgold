#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"
#include "sprite_system.h"

void ov18_021F1160(PokedexAppData *pokedexApp, int spriteIdx, BOOL a2);
void ov18_021F14FC(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);

// The icon of the species a grid entry holds, in the sprite spriteIdx: hidden
// for an empty entry, drawn in the seen-only style for a species not caught.
// Pichu's Spiky-eared form (2 in the Dex) is its icon's form 1.
void ov18_021F1598(PokedexAppData *pokedexApp, int idx, int spriteIdx) {
    int form;

    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
    if (pokedexApp->unk_1030[idx].unk_0 != SPECIES_NONE) {
        form = Pokedex_GetSeenFormByIdx(pokedexApp->args->pokedex, pokedexApp->unk_1030[idx].unk_0, 0);
        if (pokedexApp->unk_1030[idx].unk_0 == SPECIES_PICHU) {
            if (form == 2) {
                form = 1;
            } else {
                form = 0;
            }
        }
        ov18_021F14FC(pokedexApp, pokedexApp->unk_1030[idx].unk_0, form, spriteIdx);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
        if (pokedexApp->unk_1030[idx].unk_2 == 1) {
            ov18_021F1160(pokedexApp, spriteIdx, TRUE);
        } else {
            ov18_021F1160(pokedexApp, spriteIdx, FALSE);
        }
    }
}
