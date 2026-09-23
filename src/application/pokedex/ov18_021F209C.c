#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokedex.h"
#include "pokemon.h"
#include "sprite_system.h"

void ov18_021F21FC(PokedexAppData *pokedexApp, int spriteIdx, u16 type);

// The type icons of an entry's species, on its pages in the Dex's own
// language, from the four sprites at spriteIdx: two pairs used in turn
// (unk_185F_4 says which), so the pair being replaced can be hidden while
// the other is drawn. A species only seen shows none; a second type that is
// the first shows no second icon. Retail hid a Normal second type too, as no
// species of its Dex had one; Litleo and Pyroar are Fire and Normal, and the
// reference shows it (bytereplacement, "normal as a second type should show
// up in the dex/pc").
void ov18_021F209C(PokedexAppData *pokedexApp, u32 species, int idx, u32 spriteIdx) {
    int form;
    u16 type1;
    u16 type2;

    if (pokedexApp->unk_185C != 2 || species == SPECIES_NONE || pokedexApp->unk_1030[idx].unk_2 == 1) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 1], FALSE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 2], FALSE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 3], FALSE);
        return;
    }
    if (pokedexApp->unk_185F_4 == 0) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], FALSE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 1], FALSE);
        spriteIdx += 2;
    } else {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 2], FALSE);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 3], FALSE);
    }
    pokedexApp->unk_185F_4 ^= 1;
    form = Pokedex_GetSeenFormByIdx(pokedexApp->args->pokedex, species, 0);
    if (species == SPECIES_PICHU) {
        if (form == 2) {
            form = 1;
        } else {
            form = 0;
        }
    }
    type1 = GetMonBaseStat_HandleAlternateForm(species, form, BASE_TYPE1);
    ov18_021F21FC(pokedexApp, spriteIdx, type1);
    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
    type2 = GetMonBaseStat_HandleAlternateForm(species, form, BASE_TYPE2);
    if (type1 == type2) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 1], FALSE);
    } else {
        ov18_021F21FC(pokedexApp, spriteIdx + 1, type2);
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 1], TRUE);
    }
}
