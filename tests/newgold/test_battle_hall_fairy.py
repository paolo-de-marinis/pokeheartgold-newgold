#!/usr/bin/env python3
"""Check the Battle Hall's Fairy rank.

The Hall's type board has twenty cells, four to a row: retail's seventeen
types, the Pokemon's summary two cells wide, the Hall Matron's ???. Fairy is
the eighteenth category (its rank the eighteenth nibble the save already
kept), in the summary's first cell; the summary is one cell. The board's
routines (src/frontier/battle_hall_board_cursor.c), the cell types
(battle_hall_types.c) and the rank reset (battle_hall_ranks.c) run here on
the host; the board's tilemap and palettes (files/graphic/frontier_gra) and
the Fairy category's trainer classes are read as the game reads them.
"""

import re
import struct
import sys
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
from test_battle_hall_sets import asm_tables, u16s  # noqa: E402

HEADER = (ROOT / "include/frontier/battle_hall.h").read_text()
BOARD = ROOT / "src/frontier/battle_hall_board_cursor.c"

PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define PAD_BUTTON_A 0x0001
#define PAD_KEY_RIGHT 0x0010
#define PAD_KEY_LEFT 0x0020
#define PAD_KEY_UP 0x0040
#define PAD_KEY_DOWN 0x0080
#define SEQ_SE_DP_SELECT 1500
#define GF_BG_LYR_MAIN_3 3
@DEFINES@
typedef struct BgConfig BgConfig;
struct { int newKeys; u16 touchX, touchY, touchNew; } gSystem;
typedef struct { u8 mode, filler[0x703]; u8 ranks[4][9]; } BattleHallData_;
#define BattleHallData BattleHallData_
typedef struct {
    u8 cursor, touched, matronPrompted;
    void *cursorObj;
    u8 *ranks;
} BattleHallBoard;
static int sAnim = -1, sX = -1, sY = -1, sLook[24][32], sStrip[24][32];
static const u8 sTop[] = {0, 5, 9, 14, 18}, sStripTop[] = {2, 6, 11, 15, 20};
#define LOOK(cell) sLook[sTop[(cell) / 4]][(cell) % 4 * 8]
#define STRIP(cell) sStrip[sStripTop[(cell) / 4]][(cell) % 4 * 8]
static void PlaySE(u16 se) { (void)se; }
static void ov82_0223FCBC(void *obj, u16 x, u16 y) { (void)obj; sX = x; sY = y; }
static void ov82_0223FCFC(void *obj, int anim) { (void)obj; sAnim = anim; }
static BOOL ov82_0223F6E4(BattleHallBoard *board) { return board->matronPrompted; }
static void ScheduleBgTilemapBufferTransfer(BgConfig *bg, u8 layer) { (void)bg; (void)layer; }
static void BgTilemapRectChangePalette(BgConfig *bg, u8 layer, u8 x, u8 y, u8 w, u8 h, u8 palette) {
    (void)bg; (void)layer; (void)h;
    if (w == 1) {
        sStrip[y][x] = palette;
    } else {
        sLook[y][x] = palette;
    }
}
static u8 sub_02030BD0(u8 category, u8 *ranks) {
    return ranks[category / 2] >> (category % 2 * 4) & 0xF;
}
static void sub_02030BF4(u8 category, u8 *ranks, u8 rank) {
    u8 shift = category % 2 * 4;
    ranks[category / 2] = (ranks[category / 2] & ~(0xF << shift)) | rank << shift;
}
@TYPES@
@RANKS@
u16 ov82_0223F558(BattleHallBoard *board);
u16 ov82_0223F570(BattleHallBoard *board);
void ov82_0223F5E0(BgConfig *bgConfig, u8 cell, u8 look);
@BOARD@
static void Press(BattleHallBoard *board, int key) {
    gSystem.newKeys = key;
    ov82_0223F300(board);
    gSystem.newKeys = 0;
    assert(sAnim == 1); // one cursor for every cell, the summary's too
}

int main(void) {
    // The cells: the eighteen types once each, then the summary and ???.
    int seen[NUMBER_OF_MON_TYPES] = {0};
    for (int cell = 0; cell < BATTLE_HALL_TYPE_CATEGORIES; cell++) {
        u8 type = ov80_02237920(cell);
        assert(type < NUMBER_OF_MON_TYPES && type != TYPE_MYSTERY && !seen[type]);
        seen[type] = 1;
    }
    assert(ov80_02237920(17) == TYPE_FAIRY);
    assert(ov80_02237920(18) == BATTLE_HALL_CELL_SUMMARY);
    assert(ov80_02237920(BATTLE_HALL_CELL_MATRON) == TYPE_MYSTERY);

    // All eighteen ranks cleared go back to rank 10 together; seventeen do not.
    static BattleHallData data;
    for (int i = 0; i < 17; i++) {
        sub_02030BF4(i, data.ranks[0], 10);
    }
    sub_02030BF4(17, data.ranks[0], 3);
    ov80_022319B0(&data);
    assert(sub_02030BD0(0, data.ranks[0]) == 10 && sub_02030BD0(17, data.ranks[0]) == 3);
    sub_02030BF4(17, data.ranks[0], 10);
    ov80_022319B0(&data);
    for (int i = 0; i < BATTLE_HALL_TYPE_CATEGORIES; i++) {
        assert(sub_02030BD0(i, data.ranks[0]) == 9);
    }

    // The pad: the bottom row is four cells like the others.
    u8 ranks[9] = {0};
    BattleHallBoard board = { .cursor = 16, .ranks = ranks };
    Press(&board, PAD_KEY_RIGHT); assert(board.cursor == 17);
    Press(&board, PAD_KEY_RIGHT); assert(board.cursor == 18 && sX == 160 && sY == 160);
    Press(&board, PAD_KEY_RIGHT); assert(board.cursor == 19);
    Press(&board, PAD_KEY_RIGHT); assert(board.cursor == 16);
    Press(&board, PAD_KEY_LEFT); assert(board.cursor == 19);
    board.cursor = 13; Press(&board, PAD_KEY_DOWN); assert(board.cursor == 17 && sX == 96 && sY == 160);
    board.cursor = 18; Press(&board, PAD_KEY_UP); assert(board.cursor == 14);
    board.cursor = 1; Press(&board, PAD_KEY_UP); assert(board.cursor == 17);
    Press(&board, PAD_KEY_DOWN); assert(board.cursor == 1);

    // A touch: Fairy's cell, then the summary's, the same cursor on both.
    gSystem.touchNew = 1; gSystem.touchX = 100; gSystem.touchY = 165;
    sAnim = -1;
    assert(ov82_0223F488(&board) && board.cursor == 17 && sAnim == 1);
    gSystem.touchX = 170;
    sAnim = -1;
    assert(ov82_0223F488(&board) && board.cursor == 18 && sAnim == 1 && sX == 160);

    // Greyed: Fairy's cell once its rank is cleared, ??? always (but for
    // the Hall Matron's battle, when every type's cell is greyed, Fairy's too).
    memset(sLook, -1, sizeof(sLook));
    ov82_0223F580(&board, NULL);
    assert(LOOK(17) == -1 && LOOK(19) == 3);
    sub_02030BF4(17, ranks, 10);
    ov82_0223F580(&board, NULL);
    assert(LOOK(17) == 3 && LOOK(16) == -1 && LOOK(18) == -1);
    memset(sLook, -1, sizeof(sLook));
    board.matronPrompted = TRUE;
    ov82_0223F580(&board, NULL);
    assert(LOOK(0) == 3 && LOOK(17) == 3 && LOOK(18) == -1 && LOOK(19) == -1);
    // The strips: Fairy's colour is palette 2's, ???'s grey palette 0's.
    for (int cell = 0; cell < 20; cell++) {
        ov82_0223F5E0(NULL, cell, 0);
    }
    assert(STRIP(3) == 1 && STRIP(16) == 2 && STRIP(17) == 2 && STRIP(19) == 0);
    puts("ok");
    return 0;
}
'''


def program():
    defines = "\n".join(re.findall(r"^#define BATTLE_HALL_\w+ .*$", HEADER, re.M))
    types = (ROOT / "src/frontier/battle_hall_types.c").read_text()
    table = types[types.index("static const u8 sCellTypes[]"):types.index("};", types.index("sCellTypes")) + 2]
    board = BOARD.read_text()
    natives = "\n".join(function(board, name) for name in (
        "ov82_0223F300", "ov82_0223F488", "ov82_0223F558", "ov82_0223F570", "ov82_0223F580", "ov82_0223F5E0"))
    return (PROGRAM.replace("@DEFINES@", defines)
            .replace("@TYPES@", table + "\n" + function(types, "ov80_02237920"))
            .replace("@RANKS@", function((ROOT / "src/frontier/battle_hall_ranks.c").read_text(), "ov80_022319B0"))
            .replace("@BOARD@", natives))


def tilemap():
    data = (ROOT / "files/graphic/frontier_gra/frontier_gra_00024.NSCR").read_bytes()
    at = data.index(b"NRCS")
    width = struct.unpack_from("<H", data, at + 8)[0] // 8
    entries = data[at + 0x14:]
    return lambda x, y: struct.unpack_from("<H", entries, 2 * (y * width + x))[0]


# The board's windows added and removed (src/frontier/battle_hall_board_windows.c),
# each by its place and its template's.
WINDOWS = r'''
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16;
typedef struct BgConfig BgConfig;
typedef struct { int unused; } Window;
typedef struct { u8 bytes[8]; } WindowTemplate;
@DEFINES@
static const WindowTemplate ov82_0223FF00[4];
static Window *sWindows;
static void AddWindow(BgConfig *bgConfig, Window *window, const WindowTemplate *template) {
    (void)bgConfig;
    printf("add %d %d\n", (int)(window - sWindows), (int)(template - ov82_0223FF00));
}
static void FillWindowPixelBuffer(Window *window, u8 fill) { (void)window; (void)fill; }
static void RemoveWindow(Window *window) { printf("remove %d\n", (int)(window - sWindows)); }
@NATIVE@
int main(void) {
    Window windows[4];
    sWindows = windows;
    ov82_0223FD2C(NULL, windows);
    ov82_0223FD5C(windows);
    return 0;
}
'''


class BattleHallFairyTests(unittest.TestCase):
    def test_board_and_ranks_on_the_host(self):
        self.assertEqual(run(program(), "newgold-hall-fairy-"), "ok")

    def test_fairy_has_a_cell_and_the_summary_one(self):
        at = tilemap()
        for y in range(18, 23):
            # Fairy's cell is a type's folder (??? beside it is the pattern),
            # its strip the strip tile in palette 2; ???'s strip is palette 0's.
            for x in range(8):
                fairy, matron = at(8 + x, y), at(24 + x, y)
                if x == 0 and y in (20, 21):
                    self.assertEqual((fairy & 0x3FF, fairy >> 12), (0xE7, 2))
                    self.assertEqual((matron & 0x3FF, matron >> 12), (0xE7, 0))
                else:
                    self.assertEqual(fairy, matron)
            # The summary: one cell, the old button's edges round four of its middle.
            row = [at(16 + x, y) & 0x3FF for x in range(8)]
            self.assertEqual(row[2:6], [row[2]] * 4)
            self.assertNotEqual(row[0], row[2])

    def test_fairy_strip_colour(self):
        data = (ROOT / "files/graphic/frontier_gra/frontier_gra_00153.NCLR").read_bytes()
        at = data.index(b"TTLP")
        colours = data[at + 8 + struct.unpack_from("<I", data, at + 0x14)[0]:]
        colour = lambda row, index: struct.unpack_from("<H", colours, 2 * (16 * row + index))[0]  # noqa: E731
        # Fairy's pink in palette 2, where ??? had its grey; ??? keeps that
        # grey from palette 0's same slot.
        self.assertEqual(colour(2, 10), 29 | 19 << 5 | 21 << 10)
        self.assertEqual(colour(0, 10), 23 | 23 << 5 | 23 << 10)
        # Unlike every other strip colour of the board (Psychic's included).
        others = [colour(row, i) for row in (1, 2) for i in range(2, 11) if (row, i) != (2, 10)]
        self.assertNotIn(colour(2, 10), others)

    def test_fairy_trainer_classes_are_in_the_pool(self):
        source = (ROOT / "src/frontier/battle_hall_trainers.c").read_text()
        rows = re.findall(r"\{([^}]*)\}, // (\w+)", source)
        self.assertEqual(rows[17][1], "Fairy")
        classes = dict(re.findall(r"#define (TRAINERCLASS_\w+)\s+(\d+)",
                                  (ROOT / "include/constants/trainer_class.h").read_text()))
        pool = set(u16s(asm_tables((ROOT / "asm/overlay_80_0223C698.s",))["ov80_0223C738"])[:300])
        for name in re.findall(r"TRAINERCLASS_\w+", rows[17][0]):
            self.assertIn(int(classes[name]), pool, name)


    def test_the_board_has_no_name_window(self):
        # The summary cell shows the Pokemon's icon alone since it gave half
        # of itself to Fairy: the routine that printed the name in window 1
        # (ov82_0223EFCC) is gone, and the window is neither added nor removed.
        source = (ROOT / "src/frontier/battle_hall_board_windows.c").read_text()
        native = source[source.index("void ov82_0223FD2C"):]
        defines = "\n".join(re.findall(r"^#define BATTLE_HALL_BOARD_\w+ .*$",
                                       (ROOT / "include/frontier/battle_hall_board.h").read_text(), re.M))
        out = run(WINDOWS.replace("@DEFINES@", defines).replace("@NATIVE@", native), "newgold-hall-windows-")
        self.assertEqual(out.splitlines(), ["add 0 0", "add 2 2", "add 3 3", "remove 0", "remove 2", "remove 3"])
        for path in (ROOT / "asm").glob("overlay_82*.s"):
            self.assertNotIn("ov82_0223EFCC", path.read_text(), path.name)


if __name__ == "__main__":
    unittest.main()
