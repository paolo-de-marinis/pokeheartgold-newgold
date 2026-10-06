#include "global.h"

#include "pokeathlon/pokeathlon_save.h"

#include "overlay_03.h"
#include "overlay_31_0225E12C.h"

// Whether the list shows a row's price: not for what the Pokeathlon Dome's
// counters will not sell again, today's buy at the one that sells once a day
// (MART_TYPE_3, "You can't buy any more today!") and a card the player has at
// the other (MART_TYPE_4, "You already have this!").
BOOL ov31_0225E12C(MartData *data, int index, int item) {
    if (data->martType == MART_TYPE_3) {
        if (PokeathlonSave_GetUnkB7C_AtIndex(data->pokeathlonSave, index)) {
            return FALSE;
        }
        return TRUE;
    }
    if (data->martType == MART_TYPE_4) {
        if (PokeathlonSave_GetUnkB78_AtIndex(data->pokeathlonSave, index + (item - 505) / 6 * 6)) {
            return FALSE;
        }
        return TRUE;
    }
    return TRUE;
}
