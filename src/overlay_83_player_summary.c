#include "constants/moves.h"

#include "msgdata/msg/msg_0031.h"

#include "font.h"
#include "overlay_83.h"
#include "text.h"

typedef char Ov83PlayerWindowsOffsetCheck[offsetof(Ov83PlayerSummaryStatePrefix, windows) == 0x50 ? 1 : -1];
typedef char Ov83PlayerMessageFormatOffsetCheck[offsetof(Ov83PlayerSummaryStatePrefix, messageFormat) == 0x24 ? 1 : -1];

// NONMATCHING: one independent stack load is scheduled before argument stores.
// The complete instruction-equivalence audit is recorded in docs/newgold/VALIDATION.md.
void ov83_022421E0(Ov83PlayerSummaryStatePrefix *state, BOOL scheduleTransfer) {
    u32 i;

    FillWindowPixelBuffer(&state->windows[18], 0);
    FillWindowPixelBuffer(&state->windows[19], 0);
    FillWindowPixelBuffer(&state->windows[21], 0);
    FillWindowPixelBuffer(&state->windows[23], 0);
    FillWindowPixelBuffer(&state->windows[25], 0);
    FillWindowPixelBuffer(&state->windows[27], 0);
    FillWindowPixelBuffer(&state->windows[29], 0);
    FillWindowPixelBuffer(&state->windows[31], 0);
    FillWindowPixelBuffer(&state->windows[33], 0);
    FillWindowPixelBuffer(&state->windows[35], 0);
    FillWindowPixelBuffer(&state->windows[37], 0);
    FillWindowPixelBuffer(&state->windows[39], 0);
    FillWindowPixelBuffer(&state->windows[40], 0);
    FillWindowPixelBuffer(&state->windows[41], 0);
    FillWindowPixelBuffer(&state->windows[42], 0);
    FillWindowPixelBuffer(&state->windows[43], 0);
    FillWindowPixelBuffer(&state->windows[44], 0);
    FillWindowPixelBuffer(&state->windows[45], 0);
    FillWindowPixelBuffer(&state->windows[46], 0);
    FillWindowPixelBuffer(&state->windows[47], 0);

    BufferBoxMonNickname(state->messageFormat, 0, Mon_GetBoxMon(state->summary.mon));
    ov83_02241DD8(state, &state->windows[18], state->msgData, msg_0031_00091, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    if (!state->summary.hideGender) {
        if (state->summary.gender == MON_MALE) {
            ov83_022479E4(&state->windows[19], state->msgData, msg_0031_00086, 0, 0, 0, MAKE_TEXT_COLOR(5, 6, 0), 0);
        } else if (state->summary.gender == MON_FEMALE) {
            ov83_022479E4(&state->windows[19], state->msgData, msg_0031_00087, 0, 0, 0, MAKE_TEXT_COLOR(3, 4, 0), 0);
        }
    }
    ov83_02240C48(state, 0, state->summary.level, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[21], state->msgData, msg_0031_00094, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    BufferAbilityName(state->messageFormat, 0, GetMonData(state->summary.mon, MON_DATA_ABILITY, NULL));
    ov83_02241DD8(state, &state->windows[23], state->msgData, msg_0031_00075, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    BufferNatureName(state->messageFormat, 0, state->summary.nature);
    ov83_02241DD8(state, &state->windows[25], state->msgData, msg_0031_00073, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    BufferItemName(state->messageFormat, 0, state->summary.heldItem);
    ov83_02241DD8(state, &state->windows[27], state->msgData, msg_0031_00071, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
    ov83_02240C48(state, 0, state->summary.hp, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02240C48(state, 1, state->summary.maxHp, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[29], state->msgData, msg_0031_00095, GetWindowWidth(&state->windows[29]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    ov83_02240C48(state, 0, state->summary.attack, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[31], state->msgData, msg_0031_00077, GetWindowWidth(&state->windows[31]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    ov83_02240C48(state, 0, state->summary.spAttack, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[33], state->msgData, msg_0031_00081, GetWindowWidth(&state->windows[33]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    ov83_02240C48(state, 0, state->summary.defense, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[35], state->msgData, msg_0031_00079, GetWindowWidth(&state->windows[35]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    ov83_02240C48(state, 0, state->summary.spDefense, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[37], state->msgData, msg_0031_00083, GetWindowWidth(&state->windows[37]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);
    ov83_02240C48(state, 0, state->summary.speed, 3, PRINTING_MODE_LEFT_ALIGN);
    ov83_02241DD8(state, &state->windows[39], state->msgData, msg_0031_00085, GetWindowWidth(&state->windows[39]) * 8, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 1);

    for (i = 0; i < MAX_MON_MOVES; i++) {
        BufferMoveName(state->messageFormat, i, state->summary.moves[i]);
        ov83_02241DD8(state, &state->windows[40 + i], state->msgData, msg_0031_00096 + i, 0, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        if (state->summary.moves[i] == MOVE_NONE) {
            ov83_022479E4(&state->windows[44 + i], state->msgData, msg_0031_00102, GetWindowWidth(&state->windows[44 + i]) * 8 / 2, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 2);
        } else {
            u16 halfSlashWidth;
            u32 center;
            int width;
            String *slash;
            String *number;

            slash = NewString_ReadMsgData(state->msgData, msg_0031_00090);
            halfSlashWidth = FontID_String_GetWidth(0, slash, 0) / 2;
            center = (u16)(GetWindowWidth(&state->windows[44 + i]) * 8 / 2);
            ov83_02247998(&state->windows[44 + i], slash, center, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 2);
            String_Delete(slash);
            ov83_02240C48(state, 0, state->summary.pp[i], 2, PRINTING_MODE_LEFT_ALIGN);
            number = NewString_ReadMsgData(state->msgData, msg_0031_00101);
            StringExpandPlaceholders(state->messageFormat, state->messageBuffer, number);
            width = FontID_String_GetWidth(0, state->messageBuffer, 0);
            ov83_02247998(&state->windows[44 + i], state->messageBuffer, center - halfSlashWidth - width, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
            String_Delete(number);
            ov83_02240C48(state, 0, state->summary.maxPp[i], 2, PRINTING_MODE_LEFT_ALIGN);
            ov83_02241DD8(state, &state->windows[44 + i], state->msgData, msg_0031_00101, center + halfSlashWidth, 0, 0, MAKE_TEXT_COLOR(1, 2, 0), 0);
        }
    }

    if (scheduleTransfer == TRUE) {
        for (i = 18; i <= 47; i++) {
            ScheduleWindowCopyToVram(&state->windows[i]);
        }
    } else {
        CopyWindowPixelsToVram_TextMode(&state->windows[18]);
        CopyWindowPixelsToVram_TextMode(&state->windows[19]);
        CopyWindowPixelsToVram_TextMode(&state->windows[21]);
        CopyWindowPixelsToVram_TextMode(&state->windows[23]);
        CopyWindowPixelsToVram_TextMode(&state->windows[25]);
        CopyWindowPixelsToVram_TextMode(&state->windows[27]);
        CopyWindowPixelsToVram_TextMode(&state->windows[29]);
        CopyWindowPixelsToVram_TextMode(&state->windows[31]);
        CopyWindowPixelsToVram_TextMode(&state->windows[33]);
        CopyWindowPixelsToVram_TextMode(&state->windows[35]);
        CopyWindowPixelsToVram_TextMode(&state->windows[37]);
        CopyWindowPixelsToVram_TextMode(&state->windows[39]);
        CopyWindowPixelsToVram_TextMode(&state->windows[40]);
        CopyWindowPixelsToVram_TextMode(&state->windows[41]);
        CopyWindowPixelsToVram_TextMode(&state->windows[42]);
        CopyWindowPixelsToVram_TextMode(&state->windows[43]);
        CopyWindowPixelsToVram_TextMode(&state->windows[44]);
        CopyWindowPixelsToVram_TextMode(&state->windows[45]);
        CopyWindowPixelsToVram_TextMode(&state->windows[46]);
        CopyWindowPixelsToVram_TextMode(&state->windows[47]);
    }
}
