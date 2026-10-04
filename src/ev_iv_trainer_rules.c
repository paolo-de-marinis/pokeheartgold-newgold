#include "ev_iv_trainer.h"

#include "global.h"

// How many more EVs a stat can take: up to MAX_EV_PER_STAT, and no more than
// the sum leaves of MAX_EV_SUM (Pokemon Central, Punti base).
int EvIvTrainer_EvRoom(const u8 *evs, int stat) {
    int total = 0;
    int i;
    int room;

    for (i = 0; i < NUM_STATS; i++) {
        total += evs[i];
    }
    room = MAX_EV_SUM - total;
    if (room > MAX_EV_PER_STAT - evs[stat]) {
        room = MAX_EV_PER_STAT - evs[stat];
    }
    return room < 0 ? 0 : room;
}

// The fee for going from one spread to the other, the Mochi's way: a Mochi
// adds ten EVs to one stat, so each stat that gains pays for its started tens
// (4 HP and 252 and 252 from nothing, 1 + 26 + 26 of them); the stats that
// lose cost nothing.
u32 EvIvTrainer_Fee(const u8 *before, const u8 *after) {
    u32 steps = 0;
    int i;

    for (i = 0; i < NUM_STATS; i++) {
        if (after[i] > before[i]) {
            steps += (after[i] - before[i] + EV_TRAINER_FEE_STEP - 1) / EV_TRAINER_FEE_STEP;
        }
    }
    return steps * EV_TRAINER_FEE_PER_STEP;
}

int EvIvTrainer_JudgeRank(int iv) {
    if (iv >= MAX_IV) {
        return JUDGE_BEST;
    }
    if (iv == MAX_IV - 1) {
        return JUDGE_FANTASTIC;
    }
    if (iv >= 26) {
        return JUDGE_VERY_GOOD;
    }
    if (iv >= 16) {
        return JUDGE_PRETTY_GOOD;
    }
    if (iv >= 1) {
        return JUDGE_DECENT;
    }
    return JUDGE_NO_GOOD;
}

// Hyper Training as Scarlet and Violet have it (Pokemon Central, Allenamento
// Pro): from level 50, and only a stat that is neither 31 already nor trained.
BOOL EvIvTrainer_CanHyperTrain(int level, int iv, u32 trained, int stat) {
    return level >= HYPER_TRAINING_MIN_LEVEL && iv < MAX_IV && !(trained & MON_HYPER_TRAINED_BIT(stat));
}
