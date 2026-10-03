#ifndef POKEHEARTGOLD_FRONTIER_BATTLE_HALL_BOARD_H
#define POKEHEARTGOLD_FRONTIER_BATTLE_HALL_BOARD_H

#include "global.h"

#include "bg_window.h"

// The Battle Hall's type board (overlay 82): twenty cells, four to a row (see
// ov80_02237920), a cursor over them and the player's Pokemon's icon. As far
// as the C reads it.
typedef struct BattleHallBoard {
    u8 filler0[8];
    u8 state;
    u8 mode;
    u8 fillerA[2];
    u8 fillerC; // retail's last cell before the two-cell summary
    u8 cursor;
    u8 fillerE[0x10];
    u8 matronPrompted; // only the Hall Matron's cell can be picked
    u8 filler1F[0x29];
    BgConfig *bgConfig;
    Window windows[4]; // the message, the Pokemon's name, the cells' names and ranks, the top screen's message
    u8 filler8C[4];
    u8 touched;
    u8 filler91[0x173];
    void *cursorObj;
    void *iconObj;
    u8 filler20C[0xC];
    u8 *ranks; // the mode's, a nibble a category (sub_02030BD0)
} BattleHallBoard;

void ov82_0223E070(BattleHallBoard *board);
void ov82_0223E974(BattleHallBoard *board);
void ov82_0223F300(BattleHallBoard *board);
BOOL ov82_0223F488(BattleHallBoard *board);
BOOL ov82_0223F53C(BattleHallBoard *board);
u16 ov82_0223F558(BattleHallBoard *board);
u16 ov82_0223F570(BattleHallBoard *board);
void ov82_0223F580(BattleHallBoard *board, BgConfig *bgConfig);
void ov82_0223F5E0(BgConfig *bgConfig, u8 cell, u8 look);
void ov82_0223F90C(BattleHallBoard *board);

// Still assembly.
void ov82_0223E9B0(void);
void ov82_0223E9E8(BattleHallBoard *board);
void ov82_0223EFCC(BattleHallBoard *board, Window *window, u32 x, u32 y, u8 textColor, u8 shadowColor, u8 bgColor, u8 fontID);
void ov82_0223F040(BattleHallBoard *board, Window *window, u32 textColor, u32 shadowColor, u32 bgColor, u32 fontID);
void ov82_0223F134(BattleHallBoard *board, Window *window);
BOOL ov82_0223F6E4(BattleHallBoard *board);
void ov82_0223FCB0(void *obj, BOOL draw);
void ov82_0223FCBC(void *obj, u16 x, u16 y);
void ov82_0223FCFC(void *obj, int anim);

#endif // POKEHEARTGOLD_FRONTIER_BATTLE_HALL_BOARD_H
