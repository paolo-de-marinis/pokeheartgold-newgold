#include "global.h"

#include "application/pokedex/pokedex_capture_page.h"
#include "msgdata/msg.naix"
#include "msgdata/msg/msg_0802.h"

#include "bg_window.h"
#include "dex_mon_measures.h"
#include "font.h"
#include "message_format.h"
#include "msgdata.h"
#include "pokedex_util.h"
#include "string_util.h"
#include "text.h"

extern const WindowTemplate ov18_021FBDB4[];

// ov18_021E590C.c defines these with a u16 species; this page hands them its
// 32-bit copy as it is, and the ROM shows no narrowing at these calls.
String *ov18_021E590C(u32 species, int language, enum HeapID heapId);
String *ov18_021E595C(u32 species, int language, enum HeapID heapId);
String *ov18_021E59A8(u32 species, int language, int a2, enum HeapID heapId);

void ov18_021F95FC(Window *window, String *string, int x, int y, FontID fontId, u32 color, int alignment);
void ov18_021F9648(Window *window, MsgData *msgData, int msgId, int x, int y, FontID fontId, u32 color, int alignment);

// The entry a newly caught species gets: its Dex number, name, category and
// flavour text, height and weight. The flavour text turns its pages in the
// page's task (ov18_021F89F8).
void ov18_021F8CCC(PokedexCapturePage *page) {
    u32 i;
    u32 x;
    String *string;
    String *buffer;
    MessageFormat *msgFormat;
    MsgData *msgData;

    for (i = 0; i < 9; i++) {
        AddWindow(page->bgConfig, &page->windows[i], &ov18_021FBDB4[i]);
        FillWindowPixelBuffer(&page->windows[i], 0);
    }

    msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0802_bin, page->heapId);
    msgFormat = MessageFormat_New(page->heapId);
    buffer = String_New(1024, page->heapId);

    ov18_021F9648(&page->windows[0], msgData, msg_0802_00144, 112, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 2);

    BufferIntegerAsString(msgFormat, 0, Pokedex_ConvertToCurrentDexNo(page->natDexEnabled, page->species), DEX_NUMBER_DIGITS, PRINTING_MODE_LEADING_ZEROS, TRUE);
    string = NewString_ReadMsgData(msgData, msg_0802_00009);
    StringExpandPlaceholders(msgFormat, buffer, string);
    ov18_021F95FC(&page->windows[1], buffer, 1, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 0);
    String_Delete(string);

    string = ov18_021E590C(page->species, 2, page->heapId);
    ov18_021F95FC(&page->windows[2], string, 0, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 0);
    String_Delete(string);

    string = ov18_021E595C(page->species, 2, page->heapId);
    x = GetWindowWidth(&page->windows[3]) * 8 - 4;
    ov18_021F95FC(&page->windows[3], string, x, 0, 4, MAKE_TEXT_COLOR(2, 1, 0), 1);
    String_Delete(string);

    DexEntryPages_Print(&page->entryPages, &page->windows[4], ov18_021E59A8(page->species, 2, 0, page->heapId), page->heapId);

    ov18_021F9648(&page->windows[5], msgData, msg_0802_00010, 20, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
    ov18_021F9648(&page->windows[7], msgData, msg_0802_00011, 20, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 2);
    MessageFormat_Delete(msgFormat);
    DestroyMsgData(msgData);

    msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, GetDexHeightMsgBank(), page->heapId);
    ov18_021F9648(&page->windows[6], msgData, page->species, 4, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
    DestroyMsgData(msgData);

    msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, GetDexWeightMsgBank(), page->heapId);
    ov18_021F9648(&page->windows[8], msgData, page->species, 4, 0, 0, MAKE_TEXT_COLOR(2, 1, 0), 0);
    DestroyMsgData(msgData);

    String_Delete(buffer);

    for (i = 0; i < 9; i++) {
        ScheduleWindowCopyToVram(&page->windows[i]);
    }
}
