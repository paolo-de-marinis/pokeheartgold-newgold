#include "msgdata/msg/msg_0302.h"

#include "pokemon.h"
#include "pokemon_summary_app.h"
#include "text.h"

void sub_0208C7F8(PokemonSummaryAppPrefix *summary, int windowID, int msgID, int statIndex, int alignment) {
    u32 color = MAKE_TEXT_COLOR(0xE, 0xF, 0);

    if (gNatureStatMods[summary->mon.nature][statIndex] < 0) {
        color = MAKE_TEXT_COLOR(0xE, 8, 0);
    } else if (gNatureStatMods[summary->mon.nature][statIndex] > 0) {
        color = MAKE_TEXT_COLOR(0xE, 7, 0);
    }

    ReadMsgDataIntoString(summary->msgData, msgID, summary->stringBuffer);
    sub_0208C778(summary, &summary->windows[windowID], color, alignment);
}
