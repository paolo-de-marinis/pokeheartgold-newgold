#include "msgdata/msg/msg_0024.h"

#include "pc_box_display.h"
#include "text.h"

// These fields and windows are shared with the remaining graphics assembly.
typedef char PCBoxGraphicsMsgDataCheck[offsetof(PCBoxGraphicsStatePrefix, msgData) == 0x20 ? 1 : -1];
typedef char PCBoxGraphicsMessageFormatCheck[offsetof(PCBoxGraphicsStatePrefix, messageFormat) == 0x24 ? 1 : -1];
typedef char PCBoxGraphicsMessageBufferCheck[offsetof(PCBoxGraphicsStatePrefix, messageBuffer) == 0x28 ? 1 : -1];
typedef char PCBoxGraphicsWindowsCheck[offsetof(PCBoxGraphicsStatePrefix, windows) == 0x30 ? 1 : -1];
typedef char PCBoxGraphicsPrefixSizeCheck[sizeof(PCBoxGraphicsStatePrefix) == 0x2F0 ? 1 : -1];

extern void ov14_021F4F84(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment);
extern void ov14_021F4FBC(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment);

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
