#include "global.h"

#include "constants/pokemon.h"

#include "heap.h"
#include "overlay_manager.h"
#include "party.h"
#include "pokemon.h"
#include "unk_020755E8.h"

// The Global Trade Station's shared data, as far as this reads it.
typedef struct GtsArgs {
    void *gtsSave; // the save's GTS block: the Pokemon on deposit
    u8 unk04[0xC];
    Pokedex *pokedex;
    u8 unk14[0x10];
    Options *options;
    GameStats *gameStats;
    Bag *bag;
    u8 unk30[0x8];
    u32 unk38;
} GtsArgs;

typedef struct GtsWork {
    GtsArgs *args;
    u8 unk004[0x20];
    int tradeType; // 9 trades for an offer found; 8 and 10 collect the deposit, or what it was traded for
    u8 unk028[0x4];
    int subState;
    u8 unk030[0x88];
    OverlayManager *tradeSequence;
    u8 unk0BC[0x54];
    EvolutionTaskData *evolutionTask;
    u8 unk114[0x10DC];
    Pokemon *given; // what the trade animation sends: the Pokemon given
} GtsWork;

Pokemon *ov70_02241868(GtsWork *work, int tradeType);
void ov70_022418A4(GtsWork *work);
void ov70_02238E50(GtsWork *work, int a1, int a2);
void sub_0202DB64(void *gtsSave, Pokemon *dest);
int ov70_02241648(GtsWork *work);

// A trade evolution that names the Pokemon it is traded for -- Karrablast for
// Shelmet, Shelmet for Karrablast -- asks the party it is given for it, so the
// Pokemon given goes in a party of one, as the wireless trade does it. The
// station passed none, and a Karrablast received here never evolved.
static int GetTradeEvolution(Pokemon *mon, Pokemon *given, int *evolutionCondition) {
    Party *partner = SaveArray_Party_Alloc(HEAP_ID_61);
    int species;

    Party_AddMon(partner, given);
    species = GetMonEvolution(partner, mon, EVOCTX_TRADE, GetMonData(mon, MON_DATA_HELD_ITEM, NULL), evolutionCondition);
    Heap_Free(partner);
    return species;
}

// After the trade animation: the Pokemon received evolves if its trade
// evolution allows, unless it is the one the player had on deposit coming
// back, then it takes the place of the one given.
int ov70_02241648(GtsWork *work) {
    int ret = 3;
    Pokemon *mon;
    Pokemon *deposit;
    int species;
    int evolutionCondition;
    int depositCondition;

    switch (work->subState) {
    case 0:
        if (!OverlayManager_Run(work->tradeSequence)) {
            break;
        }
        OverlayManager_Delete(work->tradeSequence);
        if (work->tradeType == 9) {
            mon = ov70_02241868(work, work->tradeType);
            species = GetTradeEvolution(mon, work->given, &evolutionCondition);
            if (species != SPECIES_NONE) {
                work->evolutionTask = sub_02075A7C(NULL, mon, species, work->args->options, work->args->unk38, work->args->pokedex, work->args->bag, work->args->gameStats, evolutionCondition, 4, HEAP_ID_61);
                work->subState = 1;
            } else {
                ov70_02238E50(work, 1, 0);
                ret = 4;
            }
        } else if (work->tradeType == 8 || work->tradeType == 10) {
            mon = ov70_02241868(work, work->tradeType);
            deposit = AllocMonZeroed(HEAP_ID_61);
            sub_0202DB64(work->args->gtsSave, deposit);
            if (GetMonData(mon, MON_DATA_SPECIES, NULL) != GetMonData(deposit, MON_DATA_SPECIES, NULL) || GetMonData(mon, MON_DATA_PERSONALITY, NULL) != GetMonData(deposit, MON_DATA_PERSONALITY, NULL)) {
                species = GetTradeEvolution(mon, deposit, &depositCondition);
                if (species != SPECIES_NONE) {
                    work->evolutionTask = sub_02075A7C(NULL, mon, species, work->args->options, work->args->unk38, work->args->pokedex, work->args->bag, work->args->gameStats, depositCondition, 4, HEAP_ID_61);
                    work->subState = 1;
                } else {
                    ov70_02238E50(work, 1, 0);
                    ret = 4;
                }
            } else {
                ov70_02238E50(work, 1, 0);
                ret = 4;
            }
            Heap_Free(deposit);
        } else {
            ov70_02238E50(work, 1, 0);
            ret = 4;
        }
        break;
    case 1:
        if (sub_02075D3C(work->evolutionTask)) {
            sub_02075D4C(work->evolutionTask);
            ov70_022418A4(work);
            GX_SetVisibleWnd(GX_WNDMASK_NONE);
            ov70_02238E50(work, 7, 12);
            ret = 4;
        }
        break;
    }
    return ret;
}
