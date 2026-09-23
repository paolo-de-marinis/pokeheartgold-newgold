#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "application/pokedex/pokedex_internal_constants.h"

#include "bg_window.h"
#include "text.h"

extern const u16 ov18_021F9DC0[];

void ov18_021EF388(PokedexAppData *pokedexApp, int windowId, int a2);
void ov18_021F9648(Window *window, MsgData *msgData, int msgId, int x, int y, FontID fontId, u32 color, int alignment);
void ov18_021EF848(PokedexAppData *pokedexApp);

// The type search's page: its title, the names of its nineteen buttons (the
// eighteen types and "----", ov18_021F9DC0's, in windows 47 to 64, the last
// row's Fairy and "----" side by side in window 64, which is two buttons
// wide), OK and Cancel, and the two types chosen.
void ov18_021EF848(PokedexAppData *pokedexApp) {
    u32 i;

    ov18_021E613C(pokedexApp, 0);
    FillWindowPixelBuffer(&pokedexApp->windows[44], 0);
    ov18_021F9648(&pokedexApp->windows[44], pokedexApp->msgData, 28, 28, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
    for (i = 47; i <= 64; i++) {
        FillWindowPixelBuffer(&pokedexApp->windows[i], 0);
        ov18_021F9648(&pokedexApp->windows[i], pokedexApp->msgData, ov18_021F9DC0[i - 47], 32, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 2);
    }
    ov18_021F9648(&pokedexApp->windows[64], pokedexApp->msgData, ov18_021F9DC0[DEX_SEARCH_TYPE_ALL], 32 + 64, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 2);
    ov18_021EF388(pokedexApp, 17, 39);
    ov18_021EF388(pokedexApp, 19, 40);
    ov18_021EFC9C(pokedexApp, pokedexApp->dexSearchCriteria[DEX_SEARCH_CRITERIA_TYPE1], 45, 29);
    ov18_021EFC9C(pokedexApp, pokedexApp->dexSearchCriteria[DEX_SEARCH_CRITERIA_TYPE2], 46, 35);
    for (i = 44; i <= 64; i++) {
        ScheduleWindowCopyToVram(&pokedexApp->windows[i]);
    }
}
