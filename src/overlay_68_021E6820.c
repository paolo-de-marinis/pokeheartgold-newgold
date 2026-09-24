#include "global.h"

#include "msgdata/msg.naix"

#include "list_menu_items.h"
#include "msgdata.h"
#include "overlay_68_021E6820.h"

extern u8 ov68_021E6678(MoveRelearnerApp *app);
extern void ov68_021E67E0(MoveRelearnerApp *app);

// The relearner's list: a row for each move the Pokemon can learn, named
// from the move names, and the relearner's own last row where the moves end.
// The move names are opened lazily, a line at a time: whole, the bank is a
// line per move (28,214 bytes, retail's 13,154), and heap 66 had 9,496 bytes
// left in one piece when the relearner asked for it.
void ov68_021E6820(MoveRelearnerApp *app) {
    u32 i;
    MsgData *moveNames;

    app->listCount = ov68_021E6678(app);
    app->listItems = ListMenuItems_New(app->listCount, HEAP_ID_66);
    moveNames = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0750_bin, HEAP_ID_66);
    for (i = 0; i < app->listCount; i++) {
        if (app->args->eligibleMoves[i] != 0xFFFF) {
            ListMenuItems_AppendFromMsgData(app->listItems, moveNames, app->args->eligibleMoves[i], app->args->eligibleMoves[i]);
        } else {
            ListMenuItems_AppendFromMsgData(app->listItems, app->msgData, 32, -2);
            break;
        }
    }
    DestroyMsgData(moveNames);
    app->unk_1BB = 0;
    app->unk_1BC = app->args->unk_14;
    ov68_021E67E0(app);
}
