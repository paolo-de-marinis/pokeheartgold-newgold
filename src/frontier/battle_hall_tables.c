#include "global.h"

#include "frontier/battle_hall.h"

// The Hall's sets in four strengths, the weakest first: the Hall Matron's
// battles pick from the strength of the player's species, or from the
// strongest (ov80_02237448).
const BattleHallSetRange gBattleHallStrengths[4] = {
    { 1,   165 },
    { 166, 287 },
    { 288, 403 },
    { 404, 522 },
};

// The IVs of each rank's opponents (ov80_0223796C; ov80_022379C0 gives a
// rank its row). The Hall Matron's are 31.
const BattleHallRankIVs gBattleHallRankIVs[10] = {
    { 0, 8,  { 0, 0 } },
    { 0, 10, { 0, 0 } },
    { 0, 12, { 0, 0 } },
    { 0, 14, { 0, 0 } },
    { 0, 16, { 0, 0 } },
    { 0, 18, { 0, 0 } },
    { 0, 20, { 0, 0 } },
    { 0, 22, { 0, 0 } },
    { 0, 24, { 0, 0 } },
    { 0, 26, { 0, 0 } },
};

// The stretch of the sets each rank picks its opponents from: the first
// strength, then the first two, the middle two and the last two.
const BattleHallSetRange gBattleHallRankStretches[10] = {
    { 1,   165 },
    { 1,   165 },
    { 1,   287 },
    { 1,   287 },
    { 1,   287 },
    { 166, 403 },
    { 166, 403 },
    { 166, 403 },
    { 288, 522 },
    { 288, 522 },
};
