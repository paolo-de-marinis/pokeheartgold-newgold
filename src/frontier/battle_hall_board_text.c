#include "frontier/battle_hall_board.h"

#include "global.h"

// The board's words: each cell's type and rank. The Pokemon's summary cell
// shows the Pokemon's icon, one cell wide, without its name, which needed
// the two cells the summary had before Fairy took one.
void ov82_0223E070(BattleHallBoard *board) {
    ov82_0223F040(board, &board->windows[2], 1, 2, 0, 0);
    ov82_0223F134(board, &board->windows[2]);
}
