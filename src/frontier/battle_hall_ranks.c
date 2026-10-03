#include "frontier/battle_hall.h"

#include "global.h"

u8 sub_02030BD0(u8 category, u8 *ranks);
void sub_02030BF4(u8 category, u8 *ranks, u8 rank);

// Once every type's rank is cleared (10, past rank 10), they all go back to
// rank 10 and the board opens again. The multi challenge keeps them at rank
// 10 throughout.
void ov80_022319B0(BattleHallData *data) {
    int i;

    if (data->mode == 2) {
        return;
    }
    for (i = 0; i < 17; i++) {
        if (sub_02030BD0(i, data->ranks[data->mode]) < 10) {
            break;
        }
    }
    if (i == 17) {
        for (i = 0; i < 17; i++) {
            sub_02030BF4(i, data->ranks[data->mode], 9);
        }
    }
}
