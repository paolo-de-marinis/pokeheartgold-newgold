#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "text.h"

// The name of a list entry, right-aligned in its window: a species only
// seen shows no name. An empty entry clears the window.
void ov18_021EE834(PokedexAppData *pokedexApp, u16 species, u32 idx, int windowId) {
    String *string;
    u32 x;

    FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
    if (species != SPECIES_NONE) {
        if (pokedexApp->unk_1030[idx].unk_2 == 2) {
            string = ov18_021E595C(species, 2, HEAP_ID_POKEDEX_APP);
        } else {
            string = ov18_021E595C(SPECIES_NONE, 2, HEAP_ID_POKEDEX_APP);
        }
        x = GetWindowWidth(&pokedexApp->windows[windowId]) * 8 - 4;
        ov18_021F95FC(&pokedexApp->windows[windowId], string, x, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 1);
        String_Delete(string);
        ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
    } else {
        ClearWindowTilemapAndScheduleTransfer(&pokedexApp->windows[windowId]);
    }
}
