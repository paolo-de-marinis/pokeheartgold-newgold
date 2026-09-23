#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "text.h"

// The name of an entry's species on its page, right-aligned in the Dex's
// language: none for a species only seen.
void ov18_021EED00(PokedexAppData *pokedexApp, u16 species, u32 idx, int windowId) {
    String *string;

    FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
    if (pokedexApp->unk_1030[idx].unk_2 == 2) {
        string = ov18_021E595C(species, pokedexApp->unk_185C, HEAP_ID_POKEDEX_APP);
    } else {
        string = ov18_021E595C(SPECIES_NONE, pokedexApp->unk_185C, HEAP_ID_POKEDEX_APP);
    }
    ov18_021F95FC(&pokedexApp->windows[windowId], string, 124, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 1);
    String_Delete(string);
    ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
}
