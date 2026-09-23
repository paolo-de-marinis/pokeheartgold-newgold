#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "font.h"
#include "text.h"

// The category of an entry's species ("Seed Pokemon"), centred in its
// window; drawn only for a species that has been caught.
void ov18_021EE984(PokedexAppData *pokedexApp, u16 species, u32 idx, int windowId) {
    String *string;
    u32 width;

    if (pokedexApp->unk_1030[idx].unk_2 == 2) {
        FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
        string = ov18_021E59A8(species, pokedexApp->unk_185C, 0, HEAP_ID_POKEDEX_APP);
        width = GetWindowWidth(&pokedexApp->windows[windowId]);
        width = (width * 8 - FontID_String_GetWidthMultiline(0, string, 0)) / 2;
        ov18_021F95FC(&pokedexApp->windows[windowId], string, width, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
        String_Delete(string);
        ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
    }
}
