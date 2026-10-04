#ifndef POKEHEARTGOLD_EV_IV_TRAINER_H
#define POKEHEARTGOLD_EV_IV_TRAINER_H

#include "constants/pokemon.h"

#include "field_system.h"
#include "overlay_manager.h"

// The EV/IV trainer: an app in the summary screen's look where a party
// Pokemon's EVs are set by hand or from a set, and its stats Hyper trained.

// What adding EVs costs: EV_TRAINER_FEE_PER_STEP for every started
// EV_TRAINER_FEE_STEP of them in a stat, the price the latest games give the
// Mochi that add ten to one; taking EVs away is free.
#define EV_TRAINER_FEE_STEP     10
#define EV_TRAINER_FEE_PER_STEP 500

// The latest games' Judge (Sword and Shield, Scarlet and Violet).
enum JudgeRank {
    JUDGE_NO_GOOD,     // 0
    JUDGE_DECENT,      // 1 to 15
    JUDGE_PRETTY_GOOD, // 16 to 25
    JUDGE_VERY_GOOD,   // 26 to 29
    JUDGE_FANTASTIC,   // 30
    JUDGE_BEST,        // 31
};

// A set the Sets page offers: its name, a row of EV_IV_TRAINER_SETS_BANK, and
// the six EVs it gives, in MON_DATA_HP_EV order. The table ends with a row
// whose name is EV_IV_TRAINER_SETS_END.
#define EV_IV_TRAINER_SETS_END 0xFFFF
typedef struct EvIvTrainerSet {
    u16 name;
    u8 evs[NUM_STATS];
} EvIvTrainerSet;

typedef struct EvIvTrainerArgs {
    FieldSystem *fieldSystem;
    u16 *trained; // how many Pokemon were trained, for the script that opened it
} EvIvTrainerArgs;

// The rules, kept apart from the screens (src/ev_iv_trainer_rules.c).
int EvIvTrainer_EvRoom(const u8 *evs, int stat);
u32 EvIvTrainer_Fee(const u8 *before, const u8 *after);
int EvIvTrainer_JudgeRank(int iv);
BOOL EvIvTrainer_CanHyperTrain(int level, int iv, u32 trained, int stat);

BOOL EvIvTrainer_Init(OverlayManager *manager, int *state);
BOOL EvIvTrainer_Main(OverlayManager *manager, int *state);
BOOL EvIvTrainer_Exit(OverlayManager *manager, int *state);

#endif // POKEHEARTGOLD_EV_IV_TRAINER_H
