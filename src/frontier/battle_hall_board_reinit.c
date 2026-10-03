#include "frontier/battle_hall_board.h"

#include "global.h"

#include "frontier/battle_hall.h"

#include "bg_window.h"

// The board again, after the Pokemon's summary: the cursor back where it was.
void ov82_0223E974(BattleHallBoard *board) {
    ov82_0223E9B0();
    board->bgConfig = BgConfig_Alloc(HEAP_ID_105);
    ov82_0223E9E8(board);
    if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
        ov82_0223FCFC(board->cursorObj, 2);
        ov82_0223FCBC(board->cursorObj, 128, 168);
    }
}
