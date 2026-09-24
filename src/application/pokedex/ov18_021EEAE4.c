#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "text.h"

// An entry's height: its real one once the grid list at 0x1030 has the
// species caught, "???" before.
void ov18_021EEAE4(PokedexAppData *pokedexApp, u32 species, u32 idx, int windowId) {
    FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
    ov18_021EEA84(pokedexApp, species, pokedexApp->unk_1030[idx].unk_2, windowId, 4, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
    ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
}
