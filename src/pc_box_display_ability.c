#include "msgdata/msg/msg_0024.h"

#include "message_printer.h"
#include "overlay_14.h"
#include "pc_box_display.h"
#include "pokedex_util.h"
#include "text.h"

// These fields and windows are shared with the remaining graphics assembly.
typedef char PCBoxGraphicsMsgDataCheck[offsetof(PCBoxGraphicsStatePrefix, msgData) == 0x20 ? 1 : -1];
typedef char PCBoxGraphicsMessageFormatCheck[offsetof(PCBoxGraphicsStatePrefix, messageFormat) == 0x24 ? 1 : -1];
typedef char PCBoxGraphicsMessageBufferCheck[offsetof(PCBoxGraphicsStatePrefix, messageBuffer) == 0x28 ? 1 : -1];
typedef char PCBoxGraphicsWindowsCheck[offsetof(PCBoxGraphicsStatePrefix, windows) == 0x30 ? 1 : -1];
typedef char PCBoxGraphicsPrefixSizeCheck[sizeof(PCBoxGraphicsStatePrefix) == 0x2F0 ? 1 : -1];

extern void ov14_021F4F84(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment);
extern void ov14_021F4FBC(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment);

// The Dex number of the Pokemon the cursor is on, after the "No." glyph;
// nothing for an egg, or for a species the Dex in use does not list.
void ov14_021F5190(PCBoxApp *app, PCBoxDisplayMon *mon, int windowID) {
    FillWindowPixelBuffer(&((PCBoxGraphicsStatePrefix *)app->graphics)->windows[windowID], 0);

    if (!mon->isEgg) {
        u32 dexNo = Pokedex_ConvertToCurrentDexNo(SaveArray_IsNatDexEnabled(app->args->saveData), mon->species);
        if (dexNo != 0) {
            sub_0200CDAC(((PCBoxGraphicsStatePrefix *)app->graphics)->messagePrinter, 2, &((PCBoxGraphicsStatePrefix *)app->graphics)->windows[windowID], 0, 5);
            BufferIntegerAsString(((PCBoxGraphicsStatePrefix *)app->graphics)->messageFormat, 0, dexNo, 3, PRINTING_MODE_LEADING_ZEROS, TRUE);
            ov14_021F4FBC((PCBoxGraphicsStatePrefix *)app->graphics, ((PCBoxGraphicsStatePrefix *)app->graphics)->msgData, windowID, msg_0024_00091, 16, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        }
    }

    ScheduleWindowCopyToVram(&((PCBoxGraphicsStatePrefix *)app->graphics)->windows[windowID]);
}

// The Pokemon's nature, or the line an egg shows instead.
void ov14_021F521C(PCBoxGraphicsStatePrefix *state, PCBoxDisplayMon *mon, int windowID) {
    FillWindowPixelBuffer(&state->windows[windowID], 0);

    if (!mon->isEgg) {
        BufferNatureName(state->messageFormat, 0, mon->nature);
        ov14_021F4FBC(state, state->msgData, windowID, msg_0024_00085, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    } else {
        ov14_021F4F84(state, state->msgData, windowID, msg_0024_00093, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    }

    ScheduleWindowCopyToVram(&state->windows[windowID]);
}

void ov14_021F528C(PCBoxGraphicsStatePrefix *state, PCBoxDisplayMon *mon, int windowID) {
    FillWindowPixelBuffer(&state->windows[windowID], 0);

    if (!mon->isEgg) {
        BufferAbilityName(state->messageFormat, 0, mon->ability);
        ov14_021F4FBC(state, state->msgData, windowID, msg_0024_00084, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    } else {
        ov14_021F4F84(state, state->msgData, windowID, msg_0024_00093, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    }

    ScheduleWindowCopyToVram(&state->windows[windowID]);
}
