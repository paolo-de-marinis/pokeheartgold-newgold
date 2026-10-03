#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokemon.h"
#include "sprite_system.h"

void ov18_021F3CA8(PokedexAppData *pokedexApp, int idx, u8 *form, u8 *gender);
void ov18_021F1A7C(PokedexAppData *pokedexApp, u16 species, int form, int gender, int facing, int spriteIdx, int a6);
void ov18_021F1294(PokedexAppData *pokedexApp, int spriteIdx, int x, s16 y, int a4);

void ov18_021F6844(PokedexAppData *pokedexApp, int spriteIdx, int idx) {
    ov18_021F5FFC(pokedexApp, spriteIdx, idx);
}

// COMPARE's entry idx on the top screen, on the left (spriteIdx 1) or the
// right (2): its front, or its back while the page shows the backs, drawn
// into the sprite of that side not shown (1 or 3, 2 or 4), which then
// replaces the other. A form that is a species of its own is drawn as that
// species.
void ov18_021F684C(PokedexAppData *pokedexApp, int spriteIdx, int idx, int a3) {
    u8 gender;
    u8 form;
    s16 x;
    u8 y;
    int facing;
    int height;

    ov18_021F3CA8(pokedexApp, idx, &form, &gender);
    if (pokedexApp->unk_18C7_7 == 0) {
        facing = 2;
        height = 0;
    } else {
        facing = 0;
        height = GetMonPicHeightBySpeciesGenderForm(pokedexApp->seenFormSpecies[idx], gender, facing, form, 0);
    }
    if (spriteIdx == 1) {
        x = 64;
        y = height + 120;
        if (pokedexApp->unk_18C7_5 == 1) {
            spriteIdx = 3;
            ov18_021F11C0(pokedexApp, 1, 0);
            ov18_021F11C0(pokedexApp, spriteIdx, 1);
        } else {
            ov18_021F11C0(pokedexApp, 1, 1);
            ov18_021F11C0(pokedexApp, 3, 0);
        }
        pokedexApp->unk_18C7_5 ^= 1;
    } else if (spriteIdx == 2) {
        x = 192;
        y = height + 120;
        if (pokedexApp->unk_18C7_6 == 1) {
            spriteIdx = 4;
            ov18_021F11C0(pokedexApp, 2, 0);
            ov18_021F11C0(pokedexApp, spriteIdx, 1);
        } else {
            ov18_021F11C0(pokedexApp, 2, 1);
            ov18_021F11C0(pokedexApp, 4, 0);
        }
        pokedexApp->unk_18C7_6 ^= 1;
    }
    ov18_021F1A7C(pokedexApp, pokedexApp->seenFormSpecies[idx], form, gender, facing, spriteIdx, a3);
    ov18_021F1294(pokedexApp, spriteIdx, x, y, 1);
}
