#include "frontier/battle_hall_board.h"

#include "global.h"

// The board's words: each cell's type and rank, and the Pokemon's name.
void ov82_0223E070(BattleHallBoard *board) {
    ov82_0223F040(board, &board->windows[2], 1, 2, 0, 0);
    ov82_0223F134(board, &board->windows[2]);
    ov82_0223EFCC(board, &board->windows[1], 0, 0, 1, 2, 0, 0);
}
