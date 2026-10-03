#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokemon.h"
#include "sprite_system.h"

void ov18_021F3CA8(PokedexAppData *pokedexApp, int idx, u8 *form, u8 *gender);
void ov18_021F1A7C(PokedexAppData *pokedexApp, u16 species, int form, int gender, int facing, int spriteIdx, int a6);
void ov18_021F14FC(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);

// The FORMS page's entry idx, after the arrows or a touch moved to it.
void ov18_021F5EF0(PokedexAppData *pokedexApp, int idx) {
    ov18_021F5EFC(pokedexApp, idx, 0);
}

// The FORMS page's entry idx on the top screen, its front and its back:
// drawn into the pair of sprites not shown (1 and 2, or 3 and 4), which then
// replace the other pair.
void ov18_021F5EFC(PokedexAppData *pokedexApp, int idx, int a2) {
    u8 gender;
    u8 form;
    int front;
    int back;

    ov18_021F3CA8(pokedexApp, idx, &form, &gender);
    if (pokedexApp->unk_18C7_5 == 0) {
        front = 1;
        back = 2;
        ov18_021F11C0(pokedexApp, 3, 0);
        ov18_021F11C0(pokedexApp, 4, 0);
    } else {
        front = 3;
        back = 4;
        ov18_021F11C0(pokedexApp, 1, 0);
        ov18_021F11C0(pokedexApp, 2, 0);
    }
    pokedexApp->unk_18C7_5 ^= 1;
    ov18_021F1A7C(pokedexApp, pokedexApp->curSpecies, form, gender, 2, front, a2);
    ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[front], 64, 120, FX32_CONST(512));
    ov18_021F1A7C(pokedexApp, pokedexApp->curSpecies, form, gender, 0, back, a2);
    ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[back], 192, GetMonPicHeightBySpeciesGenderForm(pokedexApp->curSpecies, gender, 0, form, 0) + 120, FX32_CONST(512));
    ov18_021F11C0(pokedexApp, front, 1);
    ov18_021F11C0(pokedexApp, back, 1);
}

// The icon of the FORMS page's entry idx, in the sprite spriteIdx. Pichu's
// Spiky-eared form (2 in the Dex) is its icon's form 1.
void ov18_021F5FFC(PokedexAppData *pokedexApp, int spriteIdx, int idx) {
    u8 entry = pokedexApp->seenForms[idx];
    int form;

    if (entry & 0x80) {
        form = entry ^ 0x80;
        if (pokedexApp->curSpecies == SPECIES_PICHU) {
            if (form == 2) {
                form = 1;
            } else {
                form = 0;
            }
        }
    } else {
        form = 0;
    }
    ov18_021F14FC(pokedexApp, pokedexApp->curSpecies, form, spriteIdx);
}
