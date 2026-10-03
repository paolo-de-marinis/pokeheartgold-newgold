#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "pokemon.h"
#include "sound_chatot.h"
#include "sprite_system.h"

void ov18_021F3CA8(PokedexAppData *pokedexApp, int idx, u8 *form, u8 *gender);
void ov18_021F1A7C(PokedexAppData *pokedexApp, u16 species, int form, int gender, int facing, int spriteIdx, int a6);
void ov18_021F14FC(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);
void ov18_021F10E8(PokedexAppData *pokedexApp, int spriteIdx);
void ov18_021F1E70(PokedexAppData *pokedexApp);
void ov18_021F1F74(PokedexAppData *pokedexApp);
void ov18_021F1FDC(PokedexAppData *pokedexApp, int spriteIdx);
void ov18_021F21FC(PokedexAppData *pokedexApp, int spriteIdx, u16 type);

// The FORMS page's type icons: the four sprites the list's top screen draws
// a species' types with (ov18_021F1E70's resources, ov18_021F1FDC's sprites),
// two pairs used in turn as the front and back are, in the slots past the
// page's own, beneath the front and the back, a lone type between them.
#define FORMS_TYPE_SPRITE  20
#define FORMS_TYPE_Y       178
#define FORMS_TYPE_X_FIRST 104
#define FORMS_TYPE_X_LONE  128
#define FORMS_TYPE_X_SECOND 153

void PokedexApp_CreateFormTypeIcons(PokedexAppData *pokedexApp) {
    ov18_021F1E70(pokedexApp);
    ov18_021F1FDC(pokedexApp, FORMS_TYPE_SPRITE);
    PokedexApp_HideFormTypeIcons(pokedexApp);
}

void PokedexApp_HideFormTypeIcons(PokedexAppData *pokedexApp) {
    for (int i = 0; i < 4; i++) {
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[FORMS_TYPE_SPRITE + i], FALSE);
    }
}

void PokedexApp_FreeFormTypeIcons(PokedexAppData *pokedexApp) {
    for (int i = 0; i < 4; i++) {
        ov18_021F10E8(pokedexApp, FORMS_TYPE_SPRITE + i);
    }
    ov18_021F1F74(pokedexApp);
}

// The types of an entry, its own for a form that is a species of its own
// and for the forms retail tells apart by form (a Heat Rotom's Fire), into
// the pair `pair`, the other pair hidden.
static void PokedexApp_ShowFormTypes(PokedexAppData *pokedexApp, int pair, u16 species, int form) {
    int spriteIdx = FORMS_TYPE_SPRITE + 2 * pair;
    u16 type1 = GetMonBaseStat_HandleAlternateForm(species, form, BASE_TYPE1);
    u16 type2 = GetMonBaseStat_HandleAlternateForm(species, form, BASE_TYPE2);

    PokedexApp_HideFormTypeIcons(pokedexApp);
    ov18_021F21FC(pokedexApp, spriteIdx, type1);
    if (type1 == type2) {
        ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[spriteIdx], FORMS_TYPE_X_LONE, FORMS_TYPE_Y, FX32_CONST(512));
    } else {
        ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[spriteIdx], FORMS_TYPE_X_FIRST, FORMS_TYPE_Y, FX32_CONST(512));
        ov18_021F21FC(pokedexApp, spriteIdx + 1, type2);
        ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[spriteIdx + 1], FORMS_TYPE_X_SECOND, FORMS_TYPE_Y, FX32_CONST(512));
        ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx + 1], TRUE);
    }
    ManagedSprite_SetDrawFlag(pokedexApp->unk_0670[spriteIdx], TRUE);
}

// The FORMS page's entry idx, after the arrows or a touch moved to it, and
// its cry, as the list cries a species picked on it (ov18_021EDE04): a form
// that is a species of its own cries as itself.
void ov18_021F5EF0(PokedexAppData *pokedexApp, int idx) {
    u8 form;
    u8 gender;

    ov18_021F5EFC(pokedexApp, idx, 0);
    ov18_021F3CA8(pokedexApp, idx, &form, &gender);
    sub_02006E3C(1);
    PlayCry(pokedexApp->seenFormSpecies[idx], form);
    sub_02006E3C(0);
}

// The FORMS page's entry idx on the top screen, its front and its back:
// drawn into the pair of sprites not shown (1 and 2, or 3 and 4), which then
// replace the other pair, and its types beneath them. A form that is a
// species of its own is drawn as that species.
void ov18_021F5EFC(PokedexAppData *pokedexApp, int idx, int a2) {
    u8 gender;
    u8 form;
    int front;
    int back;
    u16 species = pokedexApp->seenFormSpecies[idx];

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
    PokedexApp_ShowFormTypes(pokedexApp, pokedexApp->unk_18C7_5, species, form);
    pokedexApp->unk_18C7_5 ^= 1;
    ov18_021F1A7C(pokedexApp, species, form, gender, 2, front, a2);
    ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[front], 64, 120, FX32_CONST(512));
    ov18_021F1A7C(pokedexApp, species, form, gender, 0, back, a2);
    ManagedSprite_SetPositionXYWithSubscreenOffset(pokedexApp->unk_0670[back], 192, GetMonPicHeightBySpeciesGenderForm(species, gender, 0, form, 0) + 120, FX32_CONST(512));
    ov18_021F11C0(pokedexApp, front, 1);
    ov18_021F11C0(pokedexApp, back, 1);
}

// The icon of the FORMS page's entry idx, in the sprite spriteIdx: a form
// that is a species of its own has that species' icon. Pichu's Spiky-eared
// form (2 in the Dex) is its icon's form 1.
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
    ov18_021F14FC(pokedexApp, pokedexApp->seenFormSpecies[idx], form, spriteIdx);
}
