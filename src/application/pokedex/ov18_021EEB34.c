#include "global.h"

#include "application/pokedex/pokedex_internal.h"
#include "msgdata/msg.naix"

#include "dex_mon_measures.h"
#include "msgdata.h"

// An entry's weight: the species' line of the weight bank once the entry is
// caught (state 2), the bank's first line, "???", before. The bank is opened
// lazily, for the one line: whole it is a line per species and form (46,020
// bytes, retail's 15,812), and the search results page has about 20 KB of the
// Dex heap left, as retail had.
void ov18_021EEB34(PokedexAppData *pokedexApp, u32 species, u32 state, int windowId, int x, int y, u32 color, int alignment) {
    MsgData *msgData = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, GetDexWeightMsgBank(), HEAP_ID_POKEDEX_APP);
    String *string;

    if (state == 2) {
        string = NewString_ReadMsgData(msgData, species);
    } else {
        string = NewString_ReadMsgData(msgData, 0);
    }
    ov18_021F95FC(&pokedexApp->windows[windowId], string, x, y, 0, color, alignment);
    String_Delete(string);
    DestroyMsgData(msgData);
}
