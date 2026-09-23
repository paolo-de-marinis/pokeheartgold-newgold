#include "global.h"

#include "bg_window.h"
#include "font.h"
#include "igt.h"
#include "message_format.h"
#include "msgdata.h"
#include "pm_string.h"
#include "pokedex_util.h"
#include "text.h"

// The part of the trainer card's data (TrainerCardAppArgs) the front's
// text reads, as sub_02068FC8 fills it.
typedef struct TrainerCardFront {
    u8 unk0[4];
    u8 unk4_0 : 1;
    u8 liveTime : 1; // the play time is read from the clock, not the copy below
    u8 gender : 1;
    u8 hasPokedex : 1;
    u8 unk4_4 : 4;
    u8 unk5[3];
    u16 name[8];
    IGT *igt;
    u32 money;
    u32 dexCount;
    u32 score;
    u16 trainerId;
    u16 playHours; // the play time when the card was made
    u8 unk2C[2];
    u8 playMinutes;
    u8 startYear;
    u8 startMonth;
    u8 startDay;
} TrainerCardFront;

void ov51_021E74F4(Window *window, u32 right, u32 margin, u32 y, String *string, int num, u8 digits, PrintingMode mode, u32 unused);
void ov51_021E7540(Window *window, u32 right, u32 margin, u32 y, String *string);
void ov51_021E6F18(u8 *app, Window *windows, TrainerCardFront *card);

// The front of the card: the seven labels, then the ID, the name, the money,
// the Dex count (with the Dex), the score, the time and the start date.
void ov51_021E6F18(u8 *app, Window *windows, TrainerCardFront *card) {
    MsgData *msgData = *(MsgData **)(app + 0x33C4);
    String *buf;
    String *string;
    MessageFormat *msgFmt;
    String *numString;
    u32 x;
    u8 i;

    for (i = 0; i < 7; i++) {
        FillWindowPixelBuffer(&windows[i], 0);
        if (i != 3 || (i == 3 && card->hasPokedex)) {
            AddTextPrinterParameterizedWithColor(&windows[i], 0, *(String **)(app + 0x33EC + i * 4), 0, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
        }
    }

    buf = String_New(32, (enum HeapID)25);
    string = *(String **)(app + 0x33D0);
    msgFmt = MessageFormat_New_Custom(6, 32, (enum HeapID)25);
    numString = *(String **)(app + 0x33D4);

    ov51_021E74F4(&windows[0], 96, 0, 0, numString, card->trainerId, 5, PRINTING_MODE_LEADING_ZEROS, 0xFF);
    CopyU16ArrayToString(*(String **)(app + 0x33D0), card->name);
    ov51_021E7540(&windows[1], 104, 0, 0, *(String **)(app + 0x33D0));

    BufferIntegerAsString(msgFmt, 5, card->money, 6, PRINTING_MODE_LEFT_ALIGN, TRUE);
    ReadMsgDataIntoString(msgData, 19, buf);
    StringExpandPlaceholders(msgFmt, string, buf);
    x = 136 - FontID_String_GetWidth(0, string, 0);
    AddTextPrinterParameterizedWithColor(&windows[2], 0, string, x, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);

    if (card->hasPokedex) {
        // four digits, where retail's three printed 1025 as '?25'
        BufferIntegerAsString(msgFmt, 5, card->dexCount, DEX_NUMBER_DIGITS, PRINTING_MODE_LEFT_ALIGN, TRUE);
        ReadMsgDataIntoString(msgData, 26, buf);
        StringExpandPlaceholders(msgFmt, string, buf);
        x = 136 - FontID_String_GetWidth(0, string, 0);
    AddTextPrinterParameterizedWithColor(&windows[3], 0, string, x, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);
    }

    ov51_021E74F4(&windows[4], 136, 0, 0, numString, card->score, 9, PRINTING_MODE_RIGHT_ALIGN, 0xFF);

    if (card->liveTime) {
        BufferIntegerAsString(msgFmt, 0, GetIGTHours(card->igt), 3, PRINTING_MODE_RIGHT_ALIGN, TRUE);
        BufferIntegerAsString(msgFmt, 1, GetIGTMinutes(card->igt), 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
        ReadMsgDataIntoString(msgData, 21, buf);
    } else {
        BufferIntegerAsString(msgFmt, 0, card->playHours, 3, PRINTING_MODE_RIGHT_ALIGN, TRUE);
        BufferIntegerAsString(msgFmt, 1, card->playMinutes, 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
        ReadMsgDataIntoString(msgData, 20, buf);
    }
    StringExpandPlaceholders(msgFmt, string, buf);
    x = 224 - FontID_String_GetWidth(0, string, 0);
    AddTextPrinterParameterizedWithColor(&windows[5], 0, string, x, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);

    BufferIntegerAsString(msgFmt, 2, card->startYear, 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
    BufferMonthNameAbbr(msgFmt, 3, card->startMonth);
    BufferIntegerAsString(msgFmt, 4, card->startDay, 2, PRINTING_MODE_LEADING_ZEROS, TRUE);
    ReadMsgDataIntoString(msgData, 22, buf);
    StringExpandPlaceholders(msgFmt, string, buf);
    x = 224 - FontID_String_GetWidth(0, string, 0);
    AddTextPrinterParameterizedWithColor(&windows[6], 0, string, x, 0, TEXT_SPEED_NOTRANSFER, MAKE_TEXT_COLOR(1, 2, 0), NULL);

    String_Delete(buf);
    MessageFormat_Delete(msgFmt);
}
