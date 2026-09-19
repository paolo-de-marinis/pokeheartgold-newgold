#include "msgdata/msg.naix"
#include "msgdata/msg/msg_0302.h"

#include "pokemon_summary_app.h"
#include "text.h"

extern void sub_0208C778(PokemonSummaryAppPrefix *summary, Window *window, u32 color, int alignment);
extern void sub_0208C7F8(PokemonSummaryAppPrefix *summary, int windowID, int msgID, int stat, int alignment);
extern void sub_0208C87C(PokemonSummaryAppPrefix *summary, int msgID, s32 number, u32 digits, u8 printingMode);
extern void sub_0208C8C8(PokemonSummaryAppPrefix *summary, int windowID, int separatorMsgID, int firstNumberMsgID, int secondNumberMsgID, u16 firstNumber, u16 secondNumber, u8 digits, u8 centerX, u8 y);

void sub_0208D178(PokemonSummaryAppPrefix *summary) {
    sub_0208C7F8(summary, 16, msg_0302_00111, STAT_ATK - 1, 0);
    sub_0208C7F8(summary, 17, msg_0302_00112, STAT_DEF - 1, 0);
    sub_0208C7F8(summary, 18, msg_0302_00113, STAT_SPATK - 1, 0);
    sub_0208C7F8(summary, 19, msg_0302_00114, STAT_SPDEF - 1, 0);
    sub_0208C7F8(summary, 20, msg_0302_00115, STAT_SPEED - 1, 0);

    ScheduleWindowCopyToVram(&summary->windows[2]);
    ScheduleWindowCopyToVram(&summary->windows[15]);
    ScheduleWindowCopyToVram(&summary->windows[16]);
    ScheduleWindowCopyToVram(&summary->windows[17]);
    ScheduleWindowCopyToVram(&summary->windows[18]);
    ScheduleWindowCopyToVram(&summary->windows[19]);
    ScheduleWindowCopyToVram(&summary->windows[20]);
    ScheduleWindowCopyToVram(&summary->windows[21]);

    FillWindowPixelBuffer(&summary->pageWindows[0], 0);
    FillWindowPixelBuffer(&summary->pageWindows[1], 0);
    FillWindowPixelBuffer(&summary->pageWindows[2], 0);
    FillWindowPixelBuffer(&summary->pageWindows[3], 0);
    FillWindowPixelBuffer(&summary->pageWindows[4], 0);
    FillWindowPixelBuffer(&summary->pageWindows[5], 0);
    FillWindowPixelBuffer(&summary->pageWindows[6], 0);
    FillWindowPixelBuffer(&summary->pageWindows[7], 0);

    sub_0208C8C8(summary, 0, msg_0302_00117, msg_0302_00119, msg_0302_00118, summary->mon.hp, summary->mon.maxHp, 3, GetWindowWidth(&summary->pageWindows[0]) * 4, 0);
    sub_0208C87C(summary, msg_0302_00120, summary->mon.atk, 3, 0);
    sub_0208C778(summary, &summary->pageWindows[1], MAKE_TEXT_COLOR(1, 2, 0), 1);
    sub_0208C87C(summary, msg_0302_00121, summary->mon.def, 3, 0);
    sub_0208C778(summary, &summary->pageWindows[2], MAKE_TEXT_COLOR(1, 2, 0), 1);
    sub_0208C87C(summary, msg_0302_00122, summary->mon.spatk, 3, 0);
    sub_0208C778(summary, &summary->pageWindows[3], MAKE_TEXT_COLOR(1, 2, 0), 1);
    sub_0208C87C(summary, msg_0302_00123, summary->mon.spdef, 3, 0);
    sub_0208C778(summary, &summary->pageWindows[4], MAKE_TEXT_COLOR(1, 2, 0), 1);
    sub_0208C87C(summary, msg_0302_00124, summary->mon.speed, 3, 0);
    sub_0208C778(summary, &summary->pageWindows[5], MAKE_TEXT_COLOR(1, 2, 0), 1);

    BufferAbilityName(summary->messageFormat, 0, summary->mon.ability);
    String *abilityName = NewString_ReadMsgData(summary->msgData, msg_0302_00125);
    StringExpandPlaceholders(summary->messageFormat, summary->stringBuffer, abilityName);
    String_Delete(abilityName);
    sub_0208C778(summary, &summary->pageWindows[6], MAKE_TEXT_COLOR(1, 2, 0), 0);

    MsgData *abilityDescriptions = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0722_bin, HEAP_ID_19);
    ReadMsgDataIntoString(abilityDescriptions, summary->mon.ability, summary->stringBuffer);
    DestroyMsgData(abilityDescriptions);
    AddTextPrinterParameterizedWithColor(&summary->pageWindows[7], 0, summary->stringBuffer, 3, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);

    ScheduleWindowCopyToVram(&summary->pageWindows[0]);
    ScheduleWindowCopyToVram(&summary->pageWindows[1]);
    ScheduleWindowCopyToVram(&summary->pageWindows[2]);
    ScheduleWindowCopyToVram(&summary->pageWindows[3]);
    ScheduleWindowCopyToVram(&summary->pageWindows[4]);
    ScheduleWindowCopyToVram(&summary->pageWindows[5]);
    ScheduleWindowCopyToVram(&summary->pageWindows[6]);
    ScheduleWindowCopyToVram(&summary->pageWindows[7]);
}
