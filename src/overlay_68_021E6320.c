#include "global.h"

#include "constants/moves.h"
#include "constants/pokemon.h"

#include "msgdata/msg.naix"

#include "message_format.h"
#include "msgdata.h"
#include "overlay_68_021E6320.h"
#include "pokemon.h"
#include "sprite_system.h"
#include "text.h"

extern void ov68_021E6234(MoveRelearnerApp *app, u32 windowId, u32 fontId, u32 color, u32 alignment, u8 y);

// The relearner's fixed text: its headings, the Pokemon's name, its four
// moves with their PP, and its species and level. The move names are opened
// lazily, for the four lines, as ov68_021E6820 opens them for its list.
void ov68_021E6320(MoveRelearnerApp *app) {
    String *template;
    MsgData *moveNames;
    BoxPokemon *boxMon;
    u16 move;
    u32 i;

    ReadMsgDataIntoString(app->msgData, 36, app->string);
    ov68_021E6234(app, 7, 0, MAKE_TEXT_COLOR(1, 2, 0), 0, 4);
    ScheduleWindowCopyToVram(&app->windows[7]);
    ReadMsgDataIntoString(app->msgData, 35, app->string);
    ov68_021E6234(app, 8, 4, MAKE_TEXT_COLOR(15, 14, 0), 2, 4);
    ReadMsgDataIntoString(app->msgData, 34, app->string);
    ov68_021E6234(app, 9, 4, MAKE_TEXT_COLOR(15, 14, 0), 2, 4);
    ScheduleWindowCopyToVram(&app->windows[9]);
    ReadMsgDataIntoString(app->msgData, 22, app->string);
    ov68_021E6234(app, 0, 0, MAKE_TEXT_COLOR(15, 14, 0), 0, 0);
    ScheduleWindowCopyToVram(&app->windows[0]);
    ReadMsgDataIntoString(app->msgData, 23, app->string);
    ov68_021E6234(app, 1, 0, MAKE_TEXT_COLOR(15, 14, 0), 0, 0);
    ScheduleWindowCopyToVram(&app->windows[1]);
    ReadMsgDataIntoString(app->msgData, 24, app->string);
    ov68_021E6234(app, 2, 0, MAKE_TEXT_COLOR(15, 14, 0), 0, 0);
    ScheduleWindowCopyToVram(&app->windows[2]);

    template = String_New(256, HEAP_ID_66);
    ReadMsgDataIntoString(app->msgData, 39, template);
    BufferBoxMonNickname(app->msgFormat, 0, Mon_GetBoxMon(app->args->mon));
    StringExpandPlaceholders(app->msgFormat, app->string, template);
    ov68_021E6234(app, 12, 0, MAKE_TEXT_COLOR(1, 2, 0), 0, 4);
    ScheduleWindowCopyToVram(&app->windows[12]);

    moveNames = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0750_bin, HEAP_ID_66);
    boxMon = Mon_GetBoxMon(app->args->mon);
    for (i = 0; i < MAX_MON_MOVES; i++) {
        move = GetBoxMonData(boxMon, MON_DATA_MOVE1 + i, NULL);
        if (move == MOVE_NONE) {
            ManagedSprite_SetDrawFlag(app->sprites[8 + i], FALSE);
            continue;
        }
        ManagedSprite_SetDrawFlag(app->sprites[8 + i], TRUE);
        ov68_021E7028(app, move, i + 4);
        ReadMsgDataIntoString(moveNames, move, app->string);
        ov68_021E6234(app, 13, 0, MAKE_TEXT_COLOR(15, 14, 0), 0, i * 32);
        AddTextPrinterParameterizedWithColor(&app->windows[13], 0, app->ppLabel, 16, i * 32 + 16, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
        BufferIntegerAsString(app->msgFormat, 0, GetBoxMonData(boxMon, MON_DATA_MOVE1_PP + i, NULL), 2, PRINTING_MODE_RIGHT_ALIGN, TRUE);
        BufferIntegerAsString(app->msgFormat, 1, GetBoxMonData(boxMon, MON_DATA_MOVE1_MAX_PP + i, NULL), 2, PRINTING_MODE_LEFT_ALIGN, TRUE);
        StringExpandPlaceholders(app->msgFormat, app->string, app->ppTemplate);
        AddTextPrinterParameterizedWithColor(&app->windows[13], 0, app->string, 45, i * 32 + 16, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    }
    ScheduleWindowCopyToVram(&app->windows[13]);

    ReadMsgDataIntoString(app->msgData, 37, template);
    BufferBoxMonSpeciesName(app->msgFormat, 0, boxMon);
    StringExpandPlaceholders(app->msgFormat, app->string, template);
    AddTextPrinterParameterizedWithColor(&app->windows[14], 0, app->string, 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    ReadMsgDataIntoString(app->msgData, 38, template);
    BufferIntegerAsString(app->msgFormat, 0, GetBoxMonData(boxMon, MON_DATA_LEVEL, NULL), 3, PRINTING_MODE_RIGHT_ALIGN, TRUE);
    StringExpandPlaceholders(app->msgFormat, app->string, template);
    ov68_021E6234(app, 14, 0, MAKE_TEXT_COLOR(1, 2, 0), 1, 16);
    ScheduleWindowCopyToVram(&app->windows[14]);
    DestroyMsgData(moveNames);
    String_Delete(template);
}
