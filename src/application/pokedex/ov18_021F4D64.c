#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "sprite_system.h"

void ov18_021F14FC(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);
void ov18_021F1534(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);
void ov18_021F3CA8(PokedexAppData *pokedexApp, int idx, u8 *form, u8 *gender);
void ov18_021F69E8(PokedexAppData *pokedexApp, u16 species, u8 form, u8 gender, int facing);
void ov18_021F6AB0(PokedexAppData *pokedexApp, s16 ypos, s16 scale);

// The SIZE page's icon of the species, in sprites 2 and 3, in the form of the
// FORMS page's first entry (seenForms): a retail form's, Pichu's
// Spiky-eared one (2 in the Dex) its icon's form 1; sprite 7 set upright.
void ov18_021F4D64(PokedexAppData *pokedexApp) {
    u8 form;

    if (pokedexApp->seenForms[0] & 0x80) {
        form = pokedexApp->seenForms[0] ^ 0x80;
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
    ov18_021F14FC(pokedexApp, pokedexApp->curSpecies, form, 2);
    ov18_021F1534(pokedexApp, pokedexApp->curSpecies, form, 3);
    ManagedSprite_SetAffineOverwriteMode(pokedexApp->unk_0670[7], 2);
    ManagedSprite_SetAffineZRotation(pokedexApp->unk_0670[7], 0);
    ManagedSprite_SetAffineTranslation(pokedexApp->unk_0670[7], 0, -4);
}

// The SIZE page's front of the species beside the trainer, in the form and
// gender of the FORMS page's first entry, placed and scaled by the species'
// row of the Dex's tables (unk_18CC: the player's gender's).
void ov18_021F4DDC(PokedexAppData *pokedexApp) {
    PokedexAppData_UnkSub18CC *sizes;
    u8 form;
    u8 gender;

    ov18_021F3CA8(pokedexApp, 0, &form, &gender);
    sizes = &pokedexApp->unk_18CC;
    ov18_021F69E8(pokedexApp, pokedexApp->curSpecies, form, gender, 2);
    ov18_021F6AB0(pokedexApp, sizes->mon_ypos[pokedexApp->curSpecies], sizes->mon_scale[pokedexApp->curSpecies]);
}
