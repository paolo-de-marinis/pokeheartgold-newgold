#include "frontier/battle_hall_board.h"

#include "global.h"

#include "bg_window.h"

// The board again, after the Pokemon's summary: the cursor back where it was,
// on the summary's cell as on any other.
void ov82_0223E974(BattleHallBoard *board) {
    ov82_0223E9B0();
    board->bgConfig = BgConfig_Alloc(HEAP_ID_105);
    ov82_0223E9E8(board);
}
