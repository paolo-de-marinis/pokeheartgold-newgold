#include "msgdata/msg/msg_0302.h"

#include "pokemon.h"
#include "pokemon_summary_app.h"
#include "text.h"

// HeartGold tints a nature-lowered or nature-raised stat name by changing
// only the shadow, which is nearly invisible against the plate behind it. New
// Gold changes the letter as well, so which stat the nature moved can be read
// at a glance rather than guessed.
#define STAT_NAME_PLAIN   MAKE_TEXT_COLOR(0xE, 0xF, 0)
#define STAT_NAME_LOWERED MAKE_TEXT_COLOR(4, 3, 0)
#define STAT_NAME_RAISED  MAKE_TEXT_COLOR(6, 5, 0)

void sub_0208C7F8(PokemonSummaryAppPrefix *summary, int windowID, int msgID, int statIndex, int alignment) {
    u32 color = STAT_NAME_PLAIN;

    if (gNatureStatMods[summary->mon.nature][statIndex] < 0) {
        color = STAT_NAME_LOWERED;
    } else if (gNatureStatMods[summary->mon.nature][statIndex] > 0) {
        color = STAT_NAME_RAISED;
    }

    ReadMsgDataIntoString(summary->msgData, msgID, summary->stringBuffer);
    sub_0208C778(summary, &summary->windows[windowID], color, alignment);
}
