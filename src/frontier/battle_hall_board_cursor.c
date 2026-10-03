#include "frontier/battle_hall_board.h"

#include "global.h"

#include "constants/sndseq.h"

#include "frontier/battle_hall.h"

#include "bg_window.h"
#include "system.h"
#include "unk_02005D10.h"

u8 sub_02030BD0(u8 category, u8 *ranks);

void ov82_0223F300(BattleHallBoard *board) {
    BOOL moved = FALSE;

    if (gSystem.newKeys & PAD_KEY_LEFT) {
        if (ov80_02237920(board->cursor) != BATTLE_HALL_CELL_SUMMARY) {
            board->lastCell = board->cursor;
        }
        if (board->cursor % 4 == 0) {
            board->cursor += 3;
        } else if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
            board->cursor = 16;
        } else {
            board->cursor--;
        }
        moved = TRUE;
    }
    if (gSystem.newKeys & PAD_KEY_RIGHT) {
        if (ov80_02237920(board->cursor) != BATTLE_HALL_CELL_SUMMARY) {
            board->lastCell = board->cursor;
        }
        if (board->cursor % 4 == 3) {
            board->cursor -= 3;
        } else if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
            board->cursor = 19;
        } else {
            board->cursor++;
        }
        moved = TRUE;
    }
    if (gSystem.newKeys & PAD_KEY_UP) {
        if (ov80_02237920(board->cursor) != BATTLE_HALL_CELL_SUMMARY) {
            board->lastCell = board->cursor;
        }
        if (board->cursor < 4) {
            board->cursor += 16;
        } else if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
            if (board->lastCell == 16) {
                board->cursor = 13;
            } else if (board->lastCell == 19) {
                board->cursor = 14;
            } else if (board->lastCell == 13 || board->lastCell == 1) {
                board->cursor = 13;
            } else if (board->lastCell == 14 || board->lastCell == 2) {
                board->cursor = 14;
            } else {
                board->cursor = 13;
            }
        } else {
            board->cursor -= 4;
        }
        moved = TRUE;
    }
    if (gSystem.newKeys & PAD_KEY_DOWN) {
        if (ov80_02237920(board->cursor) != BATTLE_HALL_CELL_SUMMARY) {
            board->lastCell = board->cursor;
        }
        if (board->cursor >= 16) {
            board->cursor -= 16;
        } else {
            board->cursor += 4;
        }
        moved = TRUE;
    }
    if (moved == TRUE) {
        PlaySE(SEQ_SE_DP_SELECT);
        ov82_0223FCBC(board->cursorObj, ov82_0223F558(board), ov82_0223F570(board));
    }
    if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
        ov82_0223FCFC(board->cursorObj, 2);
        ov82_0223FCBC(board->cursorObj, 128, 168);
    } else {
        ov82_0223FCFC(board->cursorObj, 1);
    }
}

BOOL ov82_0223F488(BattleHallBoard *board) {
    u16 x;
    int col;
    int top;
    int row;
    int left;
    u16 y;
    int bottom;
    int right;

    if (gSystem.touchNew != 0) {
        x = gSystem.touchX;
        y = gSystem.touchY;
        for (row = 0; row < 5; row++) {
            top = row * 36 + 3;
            bottom = top + 35;
            for (col = 0; col < 4; col++) {
                left = col * 64 + 1;
                right = left + 63;
                if (left <= x && x <= right && top <= y && y <= bottom) {
                    board->cursor = col + row * 4;
                    ov82_0223FCBC(board->cursorObj, ov82_0223F558(board), ov82_0223F570(board));
                    if (ov80_02237920(board->cursor) == BATTLE_HALL_CELL_SUMMARY) {
                        ov82_0223FCFC(board->cursorObj, 2);
                        ov82_0223FCBC(board->cursorObj, 128, 168);
                    } else {
                        ov82_0223FCFC(board->cursorObj, 1);
                    }
                    board->touched = TRUE;
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}

BOOL ov82_0223F53C(BattleHallBoard *board) {
    if (gSystem.newKeys & PAD_BUTTON_A) {
        board->touched = FALSE;
        return TRUE;
    }
    return FALSE;
}

u16 ov82_0223F558(BattleHallBoard *board) {
    return (board->cursor % 4) * 64 + 32;
}

u16 ov82_0223F570(BattleHallBoard *board) {
    return (board->cursor / 4) * 36 + 16;
}

void ov82_0223F580(BattleHallBoard *board, BgConfig *bgConfig) {
    int i;

    if (ov82_0223F6E4(board) == TRUE) {
        for (i = 0; i < 17; i++) {
            ov82_0223F5E0(bgConfig, i, 3);
        }
    } else {
        for (i = 0; i < 17; i++) {
            if (sub_02030BD0(i, board->ranks) >= 10) {
                ov82_0223F5E0(bgConfig, i, 3);
            }
        }
        ov82_0223F5E0(bgConfig, 19, 3);
    }
    ScheduleBgTilemapBufferTransfer(bgConfig, GF_BG_LYR_MAIN_3);
}

void ov82_0223F5E0(BgConfig *bgConfig, u8 cell, u8 look) {
    u8 x, y, height, palette;

    if (look == 0) {
        palette = 0;
    } else if (look == 1) {
        palette = 5;
    } else if (look == 2) {
        palette = 4;
    } else {
        palette = 3;
    }

    u8 width = 8;
    x = (cell % 4) * width;

    if (cell % 8 < 4) {
        height = 5;
    } else {
        height = 4;
    }

    if (cell < 4) {
        y = 0;
    } else if (cell < 8) {
        y = 5;
    } else if (cell < 12) {
        y = 9;
    } else if (cell < 16) {
        y = 14;
    } else {
        y = 18;
    }

    BgTilemapRectChangePalette(bgConfig, GF_BG_LYR_MAIN_3, x, y, width, height, palette);

    if (look == 0) {
        palette = 0;
        width = 1;
        x = (cell % 4) * 8;

        if (cell % 8 < 4) {
            height = 2;
        } else {
            height = 3;
        }

        if (cell < 4) {
            y = 2;
        } else if (cell < 8) {
            y = 6;
        } else if (cell < 12) {
            y = 11;
        } else if (cell < 16) {
            y = 15;
        } else {
            y = 20;
        }

        if (cell < 9) {
            BgTilemapRectChangePalette(bgConfig, GF_BG_LYR_MAIN_3, x, y, width, height, 1);
        } else {
            BgTilemapRectChangePalette(bgConfig, GF_BG_LYR_MAIN_3, x, y, width, height, 2);
        }
    }
}
