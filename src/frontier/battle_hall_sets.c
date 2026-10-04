#include "frontier/battle_hall.h"

#include "global.h"

#include "frontier/overlay_80_02229EE0.h"

#include "filesystem.h"
#include "math_util.h"
#include "pokemon.h"

int ov80_022379C0(int rank);

// Whether set (counted from one) is a Pokemon of the type: its species' types,
// or its form's, as this game gives them.
static BOOL BattleHallSet_HasType(u16 set, u8 type) {
    FrontierMonNarcData data;
    BASE_STATS personal;

    ov80_02229EF4(&data, set, NARC_a_2_0_4);
    LoadMonBaseStats_HandleAlternateForm(data.species, data.form, &personal);
    return personal.types[0] == type || personal.types[1] == type;
}

// Picks count sets for battle battleNo, after the 2 * battleNo picked before
// it, which it does not repeat. Mode 0 picks from the rank's stretch a set of
// the type, by the Pokemon's own types (retail baked two types for each set,
// Gen IV's: a Clefairy was offered as Normal); the Hall Matron's battles
// (mode 1 and 2) any set from the strength of the player's species, or the
// strongest. The player's own species is never picked. The search starts at
// random in the stretch and goes round it, its last set too; past one round
// it no longer avoids the earlier picks. Retail turned back one set before
// the stretch's end: a search started on the last set never came back to its
// start, never knew it had been round, and once the type's other sets in the
// stretch had all been picked in the round it went on for ever.
void ov80_02237448(u8 count, u8 type, u8 rank, u8 battleNo, u16 species, u16 *sets, int mode) {
    u16 i;
    u16 j;
    u16 idx;
    u16 n;
    u16 pos;
    u8 rankIdx;
    const BattleHallSetRange *range;
    BOOL wrapped;
    u16 start;
    int found = 0;
    u8 numPrev = battleNo * 2;

    wrapped = FALSE;
    rankIdx = ov80_022379C0(rank);
    if (mode != 0) {
        for (idx = 0; idx < BATTLE_HALL_SET_COUNT; idx++) {
            if (species == gBattleHallSetSpecies[idx]) {
                pos = idx;
                break;
            }
        }
        if (idx == BATTLE_HALL_SET_COUNT) {
            pos = BATTLE_HALL_SET_COUNT - 101;
        }
        for (i = 0; i < 4; i++) {
            if (pos < gBattleHallStrengths[i].last) {
                break;
            }
        }
        if (i == 4) {
            i = 3;
        }
        if (mode == 2) {
            range = &gBattleHallStrengths[3];
        } else {
            range = &gBattleHallStrengths[i];
        }
    } else {
        range = &gBattleHallRankStretches[rankIdx];
    }
    n = range->last - range->first + 1;
    idx = (u16)(range->first + LCRandom() % n) - 1;
    start = idx;
    while (found < count) {
        if (!wrapped) {
            for (j = 0; j < numPrev; j++) {
                if (idx + 1 == sets[j]) {
                    break;
                }
            }
        } else if (idx + 1 == sets[numPrev - 2]) {
            j = 0;
        } else {
            j = numPrev;
        }
        if (j == numPrev) {
            if (mode != 0) {
                if (species != gBattleHallSetSpecies[idx]) {
                    sets[numPrev + found] = idx + 1;
                    found++;
                }
            } else if (BattleHallSet_HasType(idx + 1, type)) {
                if (species != gBattleHallSetSpecies[idx]) {
                    sets[numPrev + found] = idx + 1;
                    found++;
                }
            }
        }
        idx++;
        if (idx + 1 > range->last) {
            idx = range->first - 1;
        }
        if (idx == start) {
            wrapped = TRUE;
        }
    }
}
