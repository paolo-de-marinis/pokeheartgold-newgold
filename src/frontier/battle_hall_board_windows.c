#include "frontier/battle_hall_board.h"

#include "global.h"

#include "bg_window.h"

extern const WindowTemplate ov82_0223FF00[4];

// The board's windows (ov82_0223FF00's templates): the message, the cells'
// names and ranks, the top screen's message. The second template's, which
// printed the Pokemon's name in the summary cell, is never added: the cell
// shows the icon alone since Fairy took half of it.
void ov82_0223FD2C(BgConfig *bgConfig, Window *windows) {
    u8 i;

    for (i = 0; i < 4; i++) {
        if (i == BATTLE_HALL_BOARD_NO_WINDOW) {
            continue;
        }
        AddWindow(bgConfig, &windows[i], &ov82_0223FF00[i]);
        FillWindowPixelBuffer(&windows[i], 0);
    }
}

void ov82_0223FD5C(Window *windows) {
    u16 i;

    for (i = 0; i < 4; i++) {
        if (i == BATTLE_HALL_BOARD_NO_WINDOW) {
            continue;
        }
        RemoveWindow(&windows[i]);
    }
}
