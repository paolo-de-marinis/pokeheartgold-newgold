#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "sprite_system.h"

extern const ManagedSpriteTemplate ov18_021FA610[8];

void ov18_021F3E24(PokedexAppData *pokedexApp);
ManagedSprite *ov18_021F11EC(PokedexAppData *pokedexApp, const ManagedSpriteTemplate *template);
void ov18_021F69C0(PokedexAppData *pokedexApp, int a1);
void ov18_021F3CA8(PokedexAppData *pokedexApp, int idx, u8 *form, u8 *gender);
void ov18_021F1534(PokedexAppData *pokedexApp, u16 species, int form, int spriteIdx);
void ov18_021F40E4(PokedexAppData *pokedexApp);
void ov18_021F4188(PokedexAppData *pokedexApp);

// The AREA page's sprites: its eight from ov18_021FA610 in sprites 1 to 8,
// and in sprite 1 the icon of the FORMS page's entry it shows the areas of,
// the one FORMS was left on (ov18_021E8528), a form of its own as itself.
void ov18_021F3D98(PokedexAppData *pokedexApp) {
    u32 i;
    u8 form;
    u8 gender;

    ov18_021F3E24(pokedexApp);
    for (i = 1; i <= 8; i++) {
        pokedexApp->unk_0670[i] = ov18_021F11EC(pokedexApp, &ov18_021FA610[i - 1]);
    }
    ov18_021F69C0(pokedexApp, 1);
    ov18_021F3CA8(pokedexApp, pokedexApp->unk_18C5, &form, &gender);
    ov18_021F1534(pokedexApp, pokedexApp->seenFormSpecies[pokedexApp->unk_18C5], form, 1);
    ov18_021F40E4(pokedexApp);
    ov18_021F40A0(pokedexApp);
    ov18_021F4188(pokedexApp);
}
