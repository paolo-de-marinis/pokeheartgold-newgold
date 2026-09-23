#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "msgdata/msg/msg_0802.h"

#include "bg_window.h"
#include "message_format.h"
#include "pokedex_util.h"
#include "string_util.h"
#include "text.h"

// The Dex number on an entry's page, in the Dex in use.
void ov18_021EEC34(PokedexAppData *pokedexApp, u32 species, int windowId, int charsetOption) {
    int charset;

    FillWindowPixelBuffer(&pokedexApp->windows[windowId], 0);
    switch (charsetOption) {
    case 1:
        charset = FALSE;
        break;
    default:
        charset = TRUE;
        break;
    }
    BufferIntegerAsString(pokedexApp->msgFormat, 0, Pokedex_ConvertToCurrentDexNo(pokedexApp->unk_1858, species), DEX_NUMBER_DIGITS, PRINTING_MODE_LEADING_ZEROS, charset);
    ov18_021EE3AC(pokedexApp, pokedexApp->msgData, windowId, msg_0802_00009, 0, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
    ScheduleWindowCopyToVram(&pokedexApp->windows[windowId]);
}
