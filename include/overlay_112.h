#ifndef POKEHEARTGOLD_OVERLAY_112_H
#define POKEHEARTGOLD_OVERLAY_112_H

#include "bag.h"
#include "options.h"
#include "party.h"
#include "pokedex.h"
#include "pokewalker.h"
#include "save_trainer_house.h"

#define POKEWALKER_CAUGHT_MON_COUNT 3

typedef struct PokewalkerCaughtMon {
    u16 species;
    u16 item;
    u16 moves[MAX_MON_MOVES];
    u8 level;
    u8 form : 5;
    u8 gender : 2;
    u8 unkD_7 : 1;
    u8 unkE_0 : 1;
    u8 shiny : 1;
    u8 unkE_2 : 6;
    u8 unkF;
} PokewalkerCaughtMon;

typedef struct PokewalkerGiftMon {
    PokewalkerCaughtMon mon;
    u8 unk10[4];
    u32 otId;
    u8 unk18[2];
    u16 metLocation;
    u8 unk1C[2];
    u16 otName[PLAYER_NAME_LENGTH + 1];
    u8 otGender : 1;
    u8 unk2E_1 : 7;
    u8 ability;
    u8 pokeball;
} PokewalkerGiftMon;

// Only the fields used by the receive path are identified here.
typedef struct PokewalkerReceiveStatePrefix {
    u8 unk0000[0x20];
    SaveData *saveData;
    u8 unk0024[0x9D7C - 0x24];
    PokewalkerCaughtMon caughtMons[POKEWALKER_CAUGHT_MON_COUNT];
    u8 unk9DAC[0xAABC - 0x9DAC];
    u8 unkAABC_0 : 5;
    u8 hasGiftMon : 1;
    u8 unkAABC_6 : 2;
    u8 unkAABD[0xAD00 - 0xAABD];
    PokewalkerGiftMon giftMon;
    u8 unkAD34[0x1E430 - 0xAD34];
    BoxPokemon *receivedGiftMon;
    Bag *bag;
    PlayerProfile *profile;
    Options *options;
    POKEWALKER *pokewalker;
    Pokedex *pokedex;
} PokewalkerReceiveStatePrefix;

void ov112_021EE9A4(Pokemon *mon, PlayerProfile *profile, PokewalkerCaughtMon *data, u32 nature, BOOL shiny);
void ov112_021EE9E4(Pokemon *mon, u32 otId, PokewalkerCaughtMon *data, u32 nature, BOOL shiny);
void ov112_021EEAF0(PokewalkerReceiveStatePrefix *state, BOOL usePreviousBox);
void ov112_021F33D8(TrainerHouseMon *dest, Party *party);

#endif // POKEHEARTGOLD_OVERLAY_112_H
