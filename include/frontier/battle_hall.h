#ifndef POKEHEARTGOLD_FRONTIER_BATTLE_HALL_H
#define POKEHEARTGOLD_FRONTIER_BATTLE_HALL_H

#include "global.h"

// The Battle Hall's data (0xD98 bytes, allocated by ov80_022310C4), as far as
// the C reads it.
typedef struct BattleHallData {
    u8 filler0[4];
    u8 mode; // single, double, multi, link multi
    u8 filler5[0x6FF];
    u8 ranks[4][9]; // a rank a category, a nibble each (sub_02030BD0), per mode
} BattleHallData;

// The Hall's sets (a/2/0/4, files/arc/battle_hall.json), counted from one:
// from the weakest Pokemon to the strongest, in four strengths.
#define BATTLE_HALL_SET_COUNT 522

// A stretch of the sets, both ends counted.
typedef struct BattleHallSetRange {
    u16 first;
    u16 last;
} BattleHallSetRange;

// A rank's row of the IVs table: the opponents' IVs, in the second byte; the
// other three are zero in every row and nothing reads them.
typedef struct BattleHallRankIVs {
    u8 unk0;
    u8 iv;
    u8 unk2[2];
} BattleHallRankIVs;

extern const BattleHallSetRange gBattleHallStrengths[4];
extern const BattleHallSetRange gBattleHallRankStretches[10];
extern const u16 gBattleHallSetSpecies[BATTLE_HALL_SET_COUNT];
extern const BattleHallRankIVs gBattleHallRankIVs[10];

// The type board's twenty cells, four to a row: a category (its rank, its
// opponents) for each of the eighteen types, then the Pokemon's summary and
// the Hall Matron's cell. ov80_02237920 gives a cell's type.
#define BATTLE_HALL_TYPE_CATEGORIES 18
#define BATTLE_HALL_CELL_SUMMARY    0xFE
#define BATTLE_HALL_CELL_MATRON     19

void ov80_022319B0(BattleHallData *data);
void ov80_02237448(u8 count, u8 type, u8 rank, u8 battleNo, u16 species, u16 *sets, int mode);
u8 ov80_02237920(u8 cell);
u8 ov80_0223796C(int rank);

#endif // POKEHEARTGOLD_FRONTIER_BATTLE_HALL_H
