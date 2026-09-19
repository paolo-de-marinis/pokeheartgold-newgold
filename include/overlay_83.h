#ifndef POKEHEARTGOLD_OVERLAY_83_H
#define POKEHEARTGOLD_OVERLAY_83_H

#include "bg_window.h"
#include "message_format.h"
#include "msgdata.h"
#include "party.h"
#include "pokemon.h"
#include "save.h"

typedef struct Ov83MonSummary {
    Pokemon *mon;
    BoxPokemon *boxMon;
    u16 species;
    u8 gender : 7;
    u8 hideGender : 1;
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
    u8 unk0[9];
    u8 battleMode;
    u8 unkA[3];
    u8 selectedMon;
    u8 unkE[6];
    u8 unk14;
    u8 unk15[0x20 - 0x15];
    MsgData *msgData;
    MessageFormat *messageFormat;
    String *messageBuffer;
    u8 unk2C[0x50 - 0x2C];
    // Window template table ov83_0224819C, entry 0: 70 windows.
    Window windows[70];
    u8 unk4B0[0x7A4 - 0x4B0];
    Party *party;
    u8 unk7A8[0x804 - 0x7A8];
    Ov83MonSummary summary;
} Ov83PlayerSummaryStatePrefix;

typedef struct Ov83OpponentSummaryStatePrefix {
    u8 unk0[9];
    u8 battleMode;
    u8 unkA[3];
    u8 selectedMon;
    u8 unkE[6];
    u8 unk14;
    u8 unk15[0x20 - 0x15];
    MsgData *msgData;
    MessageFormat *messageFormat;
    String *messageBuffer;
    u8 unk2C[0x50 - 0x2C];
    // Window template table ov83_0224819C, entry 1: 35 windows.
    Window windows[35];
    u8 unk280[0x2BC - 0x280];
    SaveData *saveData;
    u8 unk2C0[0x54C - 0x2C0];
    u8 *basicInfoVisible;
    u8 unk550[4];
    u8 *statsVisible;
    u8 *movesVisible;
    Party *party;
    u8 unk560[0x5BC - 0x560];
    Ov83MonSummary summary;
} Ov83OpponentSummaryStatePrefix;

void ov83_02241E18(Ov83PlayerSummaryStatePrefix *state);
void ov83_02245D48(Ov83OpponentSummaryStatePrefix *state);
int ov83_02247768(u8 a0, u8 selectedMon);

void ov83_022421E0(Ov83PlayerSummaryStatePrefix *state, BOOL scheduleTransfer);
void ov83_02246114(Ov83OpponentSummaryStatePrefix *state, BOOL scheduleTransfer);
void ov83_02240C48(Ov83PlayerSummaryStatePrefix *state, u32 index, s32 value, u32 digits, PrintingMode mode);
void ov83_02244A98(Ov83OpponentSummaryStatePrefix *state, u32 index, s32 value, u32 digits, PrintingMode mode);
void ov83_02241DD8(Ov83PlayerSummaryStatePrefix *state, Window *window, MsgData *msgData, u32 message, int x, int y, u32 fontId, u32 color, int alignment);
void ov83_02245D08(Ov83OpponentSummaryStatePrefix *state, Window *window, MsgData *msgData, u32 message, int x, int y, u32 fontId, u32 color, int alignment);
u8 ov83_0224777C(SaveData *saveData, u8 battleMode, int category);
// Alignment: 0 = left, 1 = right, 2 = centered.
void ov83_02247998(Window *window, String *string, int x, int y, u32 fontId, u32 color, int alignment);
void ov83_022479E4(Window *window, MsgData *msgData, u32 message, int x, int y, u32 fontId, u32 color, int alignment);

#endif // POKEHEARTGOLD_OVERLAY_83_H
