#!/usr/bin/env python3
"""Check the TM badge the bag draws beside a machine.

It is the game's own HM badge with the first letter redrawn, so the two must
agree everywhere except that letter: a badge whose box or palette drifted would
sit wrong in the list, and nothing about that is visible from a build.
"""

import struct
import subprocess
import os
import shlex
import tempfile
import sys
import unittest
import zlib
from pathlib import Path

from test_level_cap import ROOT, function

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import make_tm_label  # noqa: E402

BAG = ROOT / "files/graphic/bag_gra"
LETTER_CELL = range(0, 11)


def grid(png):
    for kind, body in make_tm_label.chunks(png):
        if kind == b"IHDR":
            width, height, depth, colour = struct.unpack(">IIBB", body[:10])
        elif kind == b"IDAT":
            data = body
    assert (depth, colour) == (4, 3), (depth, colour)
    return width, height, make_tm_label.unfilter(zlib.decompress(data), width, height)


class BagLabelTests(unittest.TestCase):
    def setUp(self):
        self.tm = grid(make_tm_label.TM_BADGE.read_bytes())
        with tempfile.TemporaryDirectory(prefix="newgold-bag-label-") as temp:
            render = Path(temp) / "hm.png"
            rendered = subprocess.run(
                [make_tm_label.GFX, make_tm_label.HM_BADGE, render,
                 "-palette", make_tm_label.PALETTE], capture_output=True)
            self.assertEqual(rendered.returncode, 0, rendered.stderr)
            self.hm = grid(render.read_bytes())

    def test_the_badge_is_what_the_generator_draws(self):
        result = subprocess.run([sys.executable, ROOT / "tools/newgold/import/make_tm_label.py", "--check"],
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_only_the_first_letter_moved(self):
        (width, height, tm), (_, _, hm) = self.tm, self.hm
        self.assertEqual((width, height), (104, 16))
        for y in range(height):
            for x in range(width):
                if x in LETTER_CELL:
                    continue
                self.assertEqual(tm[y][x], hm[y][x], f"the badge changed at {x},{y}")

    def test_the_letter_uses_the_colours_the_box_already_has(self):
        """A colour the box does not already use would draw as something else."""
        _, _, tm = self.tm
        used = {row[x] for row in tm for x in LETTER_CELL}
        self.assertLessEqual(used, {0, make_tm_label.BOX, make_tm_label.LETTER, make_tm_label.SHADOW})

    def test_the_t_stands_on_its_bar(self):
        _, _, tm = self.tm
        self.assertEqual([tm[make_tm_label.TOP][x] for x in make_tm_label.BAR],
                         [make_tm_label.LETTER] * len(make_tm_label.BAR))
        for y in range(make_tm_label.TOP + 1, make_tm_label.BOTTOM + 1):
            self.assertEqual(tm[y][make_tm_label.STEM], make_tm_label.LETTER)


NATIVE = r"""
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#include "constants/items.h"
#include "graphic/bag_gra.naix"

typedef struct { u16 id, quantity; } ItemSlot;
typedef struct { int unused; } Window;
typedef struct { int unused; } BagAppStatePrefix;
typedef enum { PRINTING_MODE_LEFT_ALIGN, PRINTING_MODE_RIGHT_ALIGN, PRINTING_MODE_LEADING_ZEROS } PrintingMode;

#define BAG_HM_BADGE NARC_bag_gra_bag_gra_00000037_NCGR
#define BAG_TM_BADGE NARC_bag_gra_bag_gra_00000095_NCGR
#define HM_DIGITS 2
#define TM_DIGITS 3
#define NUMBER_X 24
#define NUMBER_Y 5

static struct { u32 number, digits, mode, x, y, badge, badgeY; } drawn;

#define msgPrinter unused
static void PrintUIntOnWindow(int printer, u32 num, u32 digits, PrintingMode mode, Window *window, u32 x, u32 y) {
    drawn.number = num; drawn.digits = digits; drawn.mode = mode; drawn.x = x; drawn.y = y;
}
static void ov15_021FE9B0(BagAppStatePrefix *state, Window *window, u32 badge, u32 y) {
    drawn.badge = badge; drawn.badgeY = y;
}

@NATIVE@

static void draw(u16 item) {
    BagAppStatePrefix state = { 0 };
    Window window;
    ItemSlot slot = { item, 1 };
    ov15_021FE914(&state, &window, &slot, 16);
}

int main(void) {
    // A TM gets the TM badge and three digits, numbered from one.
    draw(ITEM_TM01);
    assert(drawn.badge == BAG_TM_BADGE && drawn.digits == 3 && drawn.number == 1);
    draw(ITEM_TM92);
    assert(drawn.badge == BAG_TM_BADGE && drawn.number == 92);

    // An HM keeps its own badge and two digits.
    draw(ITEM_HM01);
    assert(drawn.badge == BAG_HM_BADGE && drawn.digits == 2 && drawn.number == 1);
    draw(ITEM_HM08);
    assert(drawn.badge == BAG_HM_BADGE && drawn.number == 8);

    // Every machine is numbered, none is skipped, and the two ranges never
    // collide: TM92 and HM01 are adjacent item ids with different badges.
    for (u16 item = ITEM_TM01; item <= ITEM_HM08; item++) {
        draw(item);
        assert(drawn.number >= 1);
        assert(drawn.badge == (item < ITEM_HM01 ? BAG_TM_BADGE : BAG_HM_BADGE));
        assert(drawn.mode == PRINTING_MODE_LEADING_ZEROS);
        assert(drawn.x == 24 && drawn.y == 21 && drawn.badgeY == 16);
    }

    puts("PASS: 100 machine labels, badge choice, digits and placement.");
    return 0;
}
"""


class NativeLabelTests(unittest.TestCase):
    def test_native_machine_label(self):
        source = (ROOT / "src/bag_machine_label.c").read_text()
        program = NATIVE.replace("@NATIVE@", function(source, "ov15_021FE914"))
        with tempfile.TemporaryDirectory(prefix="newgold-bag-label-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                 "-iquote", str(ROOT / "include"), "-iquote", str(ROOT / "files"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())


if __name__ == "__main__":
    unittest.main()
