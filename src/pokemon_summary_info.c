#include "msgdata/msg/msg_0302.h"

#include "font.h"
#include "pokedex_util.h"
#include "pokemon_summary_app.h"
#include "string_util.h"
#include "text.h"

extern void sub_0208C87C(PokemonSummaryAppPrefix *summary, int msgID, s32 number, u32 digits, u8 printingMode);

// The first page of the summary: the Dex number, the species, the original
// trainer and their ID, the experience and what is left to the next level.
// An egg shows none of it.
void sub_0208CC88(PokemonSummaryAppPrefix *summary) {
    ScheduleWindowCopyToVram(&summary->windows[23]);

    if (summary->mon.isEgg) {
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[0]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[7]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[8]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[9]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[10]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[11]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[12]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[13]);
        ClearWindowTilemapAndScheduleTransfer(&summary->windows[14]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[0]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[1]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[2]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[3]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[4]);
        ClearWindowTilemapAndScheduleTransfer(&summary->pageWindows[5]);
        return;
    }

    ScheduleWindowCopyToVram(&summary->windows[0]);
    ScheduleWindowCopyToVram(&summary->windows[7]);
    ScheduleWindowCopyToVram(&summary->windows[8]);
    ScheduleWindowCopyToVram(&summary->windows[9]);
    ScheduleWindowCopyToVram(&summary->windows[10]);
    ScheduleWindowCopyToVram(&summary->windows[11]);
    ScheduleWindowCopyToVram(&summary->windows[12]);
    ScheduleWindowCopyToVram(&summary->windows[13]);
    ScheduleWindowCopyToVram(&summary->windows[14]);
    FillWindowPixelBuffer(&summary->pageWindows[0], 0);
    FillWindowPixelBuffer(&summary->pageWindows[1], 0);
    FillWindowPixelBuffer(&summary->pageWindows[2], 0);
    FillWindowPixelBuffer(&summary->pageWindows[3], 0);
    FillWindowPixelBuffer(&summary->pageWindows[4], 0);
    FillWindowPixelBuffer(&summary->pageWindows[5], 0);

    u32 dexNo = Pokedex_ConvertToCurrentDexNo(summary->args->natDexEnabled, summary->mon.species);
    if (dexNo != 0) {
        sub_0208C87C(summary, msg_0302_00009, dexNo, 3, PRINTING_MODE_LEADING_ZEROS);
    } else {
        ReadMsgDataIntoString(summary->msgData, msg_0302_00022, summary->stringBuffer);
    }
    if (!summary->mon.isShiny) {
        sub_0208C778(summary, &summary->pageWindows[0], MAKE_TEXT_COLOR(1, 2, 0), 2);
    } else {
        sub_0208C778(summary, &summary->pageWindows[0], MAKE_TEXT_COLOR(5, 6, 0), 2);
    }

    AddTextPrinterParameterizedWithColor(&summary->pageWindows[1], 0, summary->mon.speciesName, FontID_String_GetCenterAlignmentX(0, summary->mon.speciesName, 0, 72), 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    if (summary->mon.otGender == 0) {
        AddTextPrinterParameterizedWithColor(&summary->pageWindows[2], 0, summary->mon.otName, FontID_String_GetCenterAlignmentX(0, summary->mon.otName, 0, 72), 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(3, 4, 0), NULL);
    } else {
        AddTextPrinterParameterizedWithColor(&summary->pageWindows[2], 0, summary->mon.otName, FontID_String_GetCenterAlignmentX(0, summary->mon.otName, 0, 72), 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(5, 6, 0), NULL);
    }

    sub_0208C87C(summary, msg_0302_00016, (u16)summary->mon.otID, 5, PRINTING_MODE_LEADING_ZEROS);
    sub_0208C778(summary, &summary->pageWindows[3], MAKE_TEXT_COLOR(1, 2, 0), 2);
    sub_0208C87C(summary, msg_0302_00018, summary->mon.exp, 7, PRINTING_MODE_LEFT_ALIGN);
    sub_0208C778(summary, &summary->pageWindows[4], MAKE_TEXT_COLOR(1, 2, 0), 1);
    if (summary->mon.level < MAX_LEVEL) {
        sub_0208C87C(summary, msg_0302_00021, summary->mon.nextLevelExp - summary->mon.exp, 7, PRINTING_MODE_LEFT_ALIGN);
    } else {
        sub_0208C87C(summary, msg_0302_00021, 0, 7, PRINTING_MODE_LEFT_ALIGN);
    }
    sub_0208C778(summary, &summary->pageWindows[5], MAKE_TEXT_COLOR(1, 2, 0), 1);

    ScheduleWindowCopyToVram(&summary->pageWindows[0]);
    ScheduleWindowCopyToVram(&summary->pageWindows[1]);
    ScheduleWindowCopyToVram(&summary->pageWindows[2]);
    ScheduleWindowCopyToVram(&summary->pageWindows[3]);
    ScheduleWindowCopyToVram(&summary->pageWindows[4]);
    ScheduleWindowCopyToVram(&summary->pageWindows[5]);
}
