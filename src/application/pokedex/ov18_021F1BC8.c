#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"
#include "sprite_system.h"

void ov18_021F1A7C(PokedexAppData *pokedexApp, u16 species, u8 form, u8 gender, int facing, int spriteIdx, int a6);

// A species' front on the top screen, the grid's and its pages': drawn into
// the sprite of the pair at spriteIdx not shown (unk_185F_0 says which),
// which then replaces the other, in the gender and form the Dex saw first.
// No species shows the sprite emptyIdx instead. Pichu's Spiky-eared form (2
// in the Dex) is its picture's form 1, which is female only.
void ov18_021F1BC8(PokedexAppData *pokedexApp, u16 species, int spriteIdx, int emptyIdx) {
    int gender;
    int form;

    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + pokedexApp->unk_185F_0], FALSE);
    pokedexApp->unk_185F_0 ^= 1;
    spriteIdx += pokedexApp->unk_185F_0;
    if (species == SPECIES_NONE) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[emptyIdx], TRUE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
        return;
    }
    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[emptyIdx], FALSE);
    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
    gender = Pokedex_SpeciesGetLastSeenGender(pokedexApp->args->pokedex, species, 0);
    form = Pokedex_GetSeenFormByIdx(pokedexApp->args->pokedex, species, 0);
    if (species == SPECIES_PICHU) {
        if (form == 2) {
            form = 1;
            gender = form;
        } else {
            form = 0;
        }
    }
    ov18_021F1A7C(pokedexApp, species, form, gender, 2, spriteIdx, 0);
}

void ov18_021F1CAC(PokedexAppData *pokedexApp, u16 species, int spriteIdx, int emptyIdx) {
    ov18_021F1BC8(pokedexApp, species, spriteIdx, emptyIdx);
}
