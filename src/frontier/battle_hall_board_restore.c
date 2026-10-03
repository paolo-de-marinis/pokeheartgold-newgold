#include "frontier/battle_hall_board.h"

#include "global.h"

#include "render_window.h"

// The board as it was before a question: the icon, no message.
void ov82_0223F90C(BattleHallBoard *board) {
    ov82_0223FCB0(board->iconObj, TRUE);
    ClearFrameAndWindow2(&board->windows[0], FALSE);
}
