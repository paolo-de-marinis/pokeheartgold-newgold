#ifndef POKEHEARTGOLD_OVERLAY_83_H
#define POKEHEARTGOLD_OVERLAY_83_H

#include "party.h"
#include "pokemon.h"

typedef struct Ov83MonSummary {
    Pokemon *mon;
    BoxPokemon *boxMon;
    u16 species;
    u8 gender : 7;
    u8 showGender : 1;
    u8 level;
    u8 ability;
    u8 nature;
    u16 heldItem;
    u32 personality;
    u16 hp;
    u16 maxHp;
    u16 attack;
    u16 spAttack;
    u16 defense;
    u16 spDefense;
    u16 speed;
    u8 form;
    u16 moves[MAX_MON_MOVES];
    u8 pp[MAX_MON_MOVES];
    u8 maxPp[MAX_MON_MOVES];
} Ov83MonSummary;

// Known prefixes of the existing overlay-83 allocations, not allocation sizes.
// The two menus use message banks 31 (player) and 33 (opponent).
typedef struct Ov83PlayerSummaryStatePrefix {
    u8 unk0[0xD];
    u8 selectedMon;
    u8 unkE[6];
    u8 unk14;
    u8 unk15[0x7A4 - 0x15];
    Party *party;
    u8 unk7A8[0x804 - 0x7A8];
    Ov83MonSummary summary;
} Ov83PlayerSummaryStatePrefix;

typedef struct Ov83OpponentSummaryStatePrefix {
    u8 unk0[0xD];
    u8 selectedMon;
    u8 unkE[6];
    u8 unk14;
    u8 unk15[0x55C - 0x15];
    Party *party;
    u8 unk560[0x5BC - 0x560];
    Ov83MonSummary summary;
} Ov83OpponentSummaryStatePrefix;

void ov83_02241E18(Ov83PlayerSummaryStatePrefix *state);
void ov83_02245D48(Ov83OpponentSummaryStatePrefix *state);
int ov83_02247768(u8 a0, u8 selectedMon);

#endif // POKEHEARTGOLD_OVERLAY_83_H
