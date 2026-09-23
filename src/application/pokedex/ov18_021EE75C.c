#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "msgdata/msg/msg_0802.h"

#include "bg_window.h"
#include "message_format.h"
#include "pokedex_util.h"
#include "string_util.h"
#include "text.h"

// The Dex number of a list entry, in the Dex in use; an empty entry clears
// its window.
void ov18_021EE75C(PokedexAppData *pokedexApp, u32 species, int windowId) {
    FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
    if (species != SPECIES_NONE) {
        BufferIntegerAsString(pokedexApp->msgFormat, 0, Pokedex_ConvertToCurrentDexNo(pokedexApp->unk_1858, species), 3, PRINTING_MODE_LEADING_ZEROS, TRUE);
        ov18_021EE3AC(pokedexApp, pokedexApp->msgData, windowId, msg_0802_00009, 1, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 0);
        ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
    } else {
        ClearWindowTilemapAndScheduleTransfer(&pokedexApp->windows[windowId]);
    }
}
