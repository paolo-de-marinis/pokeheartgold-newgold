#include "constants/moves.h"

#include "msgdata/msg/msg_0033.h"

#include "font.h"
#include "overlay_83.h"
#include "text.h"

typedef char Ov83OpponentWindowsOffsetCheck[offsetof(Ov83OpponentSummaryStatePrefix, windows) == 0x50 ? 1 : -1];
typedef char Ov83OpponentSaveOffsetCheck[offsetof(Ov83OpponentSummaryStatePrefix, saveData) == 0x2BC ? 1 : -1];
typedef char Ov83OpponentInfoFlagsOffsetCheck[offsetof(Ov83OpponentSummaryStatePrefix, basicInfoVisible) == 0x54C ? 1 : -1];

void ov83_02246114(Ov83OpponentSummaryStatePrefix *state, BOOL scheduleTransfer) {
    u8 informationRank;
    int monIndex;
    u8 i;
    u8 halfSlashWidth;
    u32 width;
    String *string;

    informationRank = ov83_0224777C(state->saveData, state->battleMode, 2);
    monIndex = ov83_02247768(state->unk14, state->selectedMon);
    FillWindowPixelBuffer(&state->windows[12], 0);
    FillWindowPixelBuffer(&state->windows[13], 0);
    FillWindowPixelBuffer(&state->windows[15], 0);
    FillWindowPixelBuffer(&state->windows[17], 0);
    FillWindowPixelBuffer(&state->windows[19], 0);
    FillWindowPixelBuffer(&state->windows[21], 0);
    FillWindowPixelBuffer(&state->windows[23], 0);
    FillWindowPixelBuffer(&state->windows[25], 0);
    FillWindowPixelBuffer(&state->windows[27], 0);
    FillWindowPixelBuffer(&state->windows[29], 0);
    FillWindowPixelBuffer(&state->windows[31], 0);
    FillWindowPixelBuffer(&state->windows[33], 0);
    FillWindowPixelBuffer(&state->windows[34], 0);

    if (!state->summary.hideGender) {
        if (state->summary.gender == MON_MALE) {
            ov83_022479E4(&state->windows[13], state->msgData, msg_0033_00064, 0, 0, 0, MAKE_TEXT_COLOR(5, 6, 0), 0);
        } else if (state->summary.gender == MON_FEMALE) {
            ov83_022479E4(&state->windows[13], state->msgData, msg_0033_00065, 0, 0, 0, MAKE_TEXT_COLOR(3, 4, 0), 0);
        }
    }
    ov83_02244A98(state, 0, state->summary.level, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02245D08(state, &state->windows[15], state->msgData, msg_0033_00072, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    if (state->basicInfoVisible[monIndex] != 0) {
        BufferBoxMonSpeciesName(state->messageFormat, 0, Mon_GetBoxMon(state->summary.mon));
        ov83_02245D08(state, &state->windows[12], state->msgData, msg_0033_00069, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_02244A98(state, 0, state->summary.hp, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02244A98(state, 1, state->summary.maxHp, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[23], state->msgData, msg_0033_00078, GetWindowWidth(&state->windows[23]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    } else {
        ov83_022479E4(&state->windows[12], state->msgData, msg_0033_00075, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_022479E4(&state->windows[23], state->msgData, msg_0033_00077, GetWindowWidth(&state->windows[23]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    }

    if (state->statsVisible[monIndex] != 0) {
        BufferAbilityName(state->messageFormat, 0, state->summary.ability);
        ov83_02245D08(state, &state->windows[17], state->msgData, msg_0033_00053, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        BufferNatureName(state->messageFormat, 0, state->summary.nature);
        ov83_02245D08(state, &state->windows[19], state->msgData, msg_0033_00051, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        BufferItemName(state->messageFormat, 0, state->summary.heldItem);
        ov83_02245D08(state, &state->windows[21], state->msgData, msg_0033_00049, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_02244A98(state, 0, state->summary.attack, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[25], state->msgData, msg_0033_00055, GetWindowWidth(&state->windows[25]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_02244A98(state, 0, state->summary.spAttack, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[27], state->msgData, msg_0033_00059, GetWindowWidth(&state->windows[27]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_02244A98(state, 0, state->summary.defense, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[29], state->msgData, msg_0033_00057, GetWindowWidth(&state->windows[29]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_02244A98(state, 0, state->summary.spDefense, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[31], state->msgData, msg_0033_00061, GetWindowWidth(&state->windows[31]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_02244A98(state, 0, state->summary.speed, 3, PRINTING_MODE_LEFT_ALIGN);
        ov83_02245D08(state, &state->windows[33], state->msgData, msg_0033_00063, GetWindowWidth(&state->windows[33]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    } else {
        ov83_022479E4(&state->windows[17], state->msgData, msg_0033_00075, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_022479E4(&state->windows[19], state->msgData, msg_0033_00075, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_022479E4(&state->windows[21], state->msgData, msg_0033_00075, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        ov83_022479E4(&state->windows[25], state->msgData, msg_0033_00074, GetWindowWidth(&state->windows[25]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_022479E4(&state->windows[27], state->msgData, msg_0033_00074, GetWindowWidth(&state->windows[27]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_022479E4(&state->windows[29], state->msgData, msg_0033_00074, GetWindowWidth(&state->windows[29]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_022479E4(&state->windows[31], state->msgData, msg_0033_00074, GetWindowWidth(&state->windows[31]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
        ov83_022479E4(&state->windows[33], state->msgData, msg_0033_00074, GetWindowWidth(&state->windows[33]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    }

    if (informationRank == 1) {
        ov83_022479E4(&state->windows[34], state->msgData, msg_0033_00076, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    } else if (state->movesVisible[monIndex] == 0) {
        for (i = 0; i < MAX_MON_MOVES; i++) {
            ov83_022479E4(&state->windows[34], state->msgData, msg_0033_00075, 0, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
            string = NewString_ReadMsgData(state->msgData, msg_0033_00068);
            halfSlashWidth = FontID_String_GetWidth(0, string, 0) / 2;
            ov83_02247998(&state->windows[34], string, 120, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 2);
            String_Delete(string);
            string = NewString_ReadMsgData(state->msgData, msg_0033_00073);
            width = FontID_String_GetWidth(0, string, 0);
            ov83_02247998(&state->windows[34], string, 120 - halfSlashWidth - width, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
            String_Delete(string);
            ov83_022479E4(&state->windows[34], state->msgData, msg_0033_00073, 120 + halfSlashWidth, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        }
    } else {
        for (i = 0; i < MAX_MON_MOVES; i++) {
            BufferMoveName(state->messageFormat, i, state->summary.moves[i]);
            ov83_02245D08(state, &state->windows[34], state->msgData, msg_0033_00084 + i, 0, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
            if (state->summary.moves[i] == MOVE_NONE) {
                ov83_022479E4(&state->windows[34], state->msgData, msg_0033_00090, 120, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 2);
            } else {
                string = NewString_ReadMsgData(state->msgData, msg_0033_00068);
                halfSlashWidth = FontID_String_GetWidth(0, string, 0) / 2;
                ov83_02247998(&state->windows[34], string, 120, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 2);
                String_Delete(string);
                ov83_02244A98(state, 0, state->summary.pp[i], 2, PRINTING_MODE_LEFT_ALIGN);
                string = NewString_ReadMsgData(state->msgData, msg_0033_00089);
                StringExpandPlaceholders(state->messageFormat, state->messageBuffer, string);
                width = FontID_String_GetWidth(0, state->messageBuffer, 0);
                ov83_02247998(&state->windows[34], state->messageBuffer, 120 - halfSlashWidth - width, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
                String_Delete(string);
                ov83_02244A98(state, 0, state->summary.maxPp[i], 2, PRINTING_MODE_LEFT_ALIGN);
                ov83_02245D08(state, &state->windows[34], state->msgData, msg_0033_00089, 120 + halfSlashWidth, i * 16, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
            }
        }
    }

    if (scheduleTransfer == TRUE) {
        for (i = 12; i <= 34; i++) {
            ScheduleWindowCopyToVram(&state->windows[i]);
        }
    } else {
        CopyWindowPixelsToVram_TextMode(&state->windows[12]);
        CopyWindowPixelsToVram_TextMode(&state->windows[13]);
        CopyWindowPixelsToVram_TextMode(&state->windows[15]);
        CopyWindowPixelsToVram_TextMode(&state->windows[17]);
        CopyWindowPixelsToVram_TextMode(&state->windows[19]);
        CopyWindowPixelsToVram_TextMode(&state->windows[21]);
        CopyWindowPixelsToVram_TextMode(&state->windows[23]);
        CopyWindowPixelsToVram_TextMode(&state->windows[25]);
        CopyWindowPixelsToVram_TextMode(&state->windows[27]);
        CopyWindowPixelsToVram_TextMode(&state->windows[29]);
        CopyWindowPixelsToVram_TextMode(&state->windows[31]);
        CopyWindowPixelsToVram_TextMode(&state->windows[33]);
        CopyWindowPixelsToVram_TextMode(&state->windows[34]);
    }
}
