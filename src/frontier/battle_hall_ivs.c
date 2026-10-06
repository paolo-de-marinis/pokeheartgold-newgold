#include "frontier/battle_hall.h"

#include "global.h"

int ov80_022379C0(int rank);

// The IVs of a rank's opponents.
u8 ov80_0223796C(int rank) {
    return gBattleHallRankIVs[ov80_022379C0(rank)].iv;
}
