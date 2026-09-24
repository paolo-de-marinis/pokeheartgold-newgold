#include "global.h"

#include "msgdata/msg.naix"

#include "message_format.h"
#include "message_printer.h"
#include "msgdata.h"
#include "pm_string.h"
#include "pokemon_summary_app.h"

// The summary opens its text: its own lines, the ribbons' (read a line at a
// time), the digits it prints, the placeholders, the Pokemon's three names,
// a line buffer, the move names and the player's name.
void sub_02088894(PokemonSummaryAppPrefix *summary) {
    summary->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0302_bin, HEAP_ID_19);
    summary->ribbonMsgData = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0424_bin, HEAP_ID_19);
    summary->messagePrinter = MessagePrinter_New(1, 2, 0, HEAP_ID_19);
    summary->messageFormat = MessageFormat_New(HEAP_ID_19);
    summary->mon.speciesName = String_New(12, HEAP_ID_19);
    summary->mon.nickname = String_New(12, HEAP_ID_19);
    summary->mon.otName = String_New(8, HEAP_ID_19);
    summary->stringBuffer = String_New(128, HEAP_ID_19);
    summary->moveNames = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0750_bin, HEAP_ID_19);
    summary->playerName = String_New(8, HEAP_ID_19);
    if (summary->args->playerName != NULL) {
        CopyU16ArrayToString(summary->playerName, summary->args->playerName);
    }
}
