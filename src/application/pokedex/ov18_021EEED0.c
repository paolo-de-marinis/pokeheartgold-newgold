#include "global.h"

#include "application/pokedex/pokedex_internal.h"

#include "bg_window.h"
#include "message_format.h"
#include "pokedex_util.h"
#include "text.h"

void ov18_021F9648(Window *window, MsgData *msgData, int msgId, int x, int y, FontID fontId, u32 color, int alignment);

// The search's heading, two lines in window 0 for each of its pages: 1 is
// the results, with how many the list holds.
void ov18_021EEED0(PokedexAppData *pokedexApp, int page) {
    Window *window = &pokedexApp->windows[0];

    FillWindowPixelBuffer(window, 0);
    switch (page) {
    case 0:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 13, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 1:
        ov18_021F9648(window, pokedexApp->msgData, 14, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        // four digits, as the Dex prints its own counts: retail's three
        // printed a search that finds 1025 species as '?25'
        BufferIntegerAsString(pokedexApp->msgFormat, 0, pokedexApp->unk_0878.unk_7B4, DEX_NUMBER_DIGITS, PRINTING_MODE_LEADING_ZEROS, TRUE);
        ov18_021EE3AC(pokedexApp, pokedexApp->msgData, 0, 15, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 2:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 16, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 3:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 17, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 4:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 18, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 5:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 20, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 6:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 19, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 7:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 22, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 8:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 21, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 9:
        ov18_021F9648(window, pokedexApp->msgData, 12, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 25, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    case 10:
        ov18_021F9648(window, pokedexApp->msgData, 23, 112, 6, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        ov18_021F9648(window, pokedexApp->msgData, 24, 112, 22, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
        break;
    }
    ScheduleWindowCopyToVram(window);
}
