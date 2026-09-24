#ifndef POKEHEARTGOLD_BATTLE_PARTY_MENU_H
#define POKEHEARTGOLD_BATTLE_PARTY_MENU_H

#include "battle/battle_system.h"

#include "message_format.h"
#include "msgdata.h"
#include "palette.h"
#include "party.h"
#include "pm_string.h"
#include "pokemon.h"

// The parts of the battle party menu's arguments (0x38 bytes, filled in by
// ov12_0225F4E0) and state that the decompiled routines read. The rest of
// overlay 8 addresses both by offset; nothing may allocate or copy these by
// size.
typedef struct BattlePartyMenuArgs {
    Party *party;
    u8 unk04[4];
    BattleSystem *battleSystem; // 0x08
    enum HeapID heapID;         // 0x0C
    u8 unk10;
    u8 selectedPos;  // 0x11: the list position picked, 6 for Cancel
    u8 partnerPick;  // 0x12: the party slot the ally has already chosen to send in, 6 for none
    u8 unk13;
    u8 activeSlots[2]; // 0x14: the party slots the battler and its ally have on the field
    u8 unk16[0x24 - 0x16];
    u16 cannotSwitch; // 0x24: the battler is trapped (BattlerCanSwitch)
    u8 unk26[2];
    int battlerId;   // 0x28
    u8 partySlots[6]; // 0x2C: the party slot each list position shows
    u8 unk32[3];
    u8 mode;         // 0x35: 1 a switch that cannot be declined, 2 an item to use on the Pokemon picked
    u8 done;         // 0x36
} BattlePartyMenuArgs;

typedef struct BattlePartyMenuMon {
    Pokemon *mon;
    u8 unk04[0xC];
    u16 hp; // 0x10
    u8 unk12[5];
    u8 unk17_0 : 7;
    u8 isEgg : 1; // 0x17
    u8 unk18[0x50 - 0x18];
} BattlePartyMenuMon;

typedef struct BattlePartyMenu {
    BattlePartyMenuArgs *args;
    BattlePartyMenuMon mons[6]; // 0x04
    u8 unk1E4[4];
    PaletteData *paletteData; // 0x1E8
    u8 unk1EC[0x1FA8 - 0x1EC];
    MsgData *msgData;         // 0x1FA8, bank 6
    MessageFormat *msgFormat; // 0x1FAC
    String *msgBuffer;        // 0x1FB0
    u8 unk1FB4[0x2076 - 0x1FB4];
    u8 unk2076;   // 0x2076: the list position of the battler's own Pokemon
    u8 unk2077;
    u8 unk2078;
    u8 nextState; // 0x2079
} BattlePartyMenu;

#endif // POKEHEARTGOLD_BATTLE_PARTY_MENU_H
