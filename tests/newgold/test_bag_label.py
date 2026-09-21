#!/usr/bin/env python3
"""Check the TM badge the bag draws beside a machine.

It is the game's own HM badge with the first letter redrawn, so the two must
agree everywhere except that letter: a badge whose box or palette drifted would
sit wrong in the list, and nothing about that is visible from a build.
"""

import struct
import subprocess
import tempfile
import sys
import unittest
import zlib
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
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
        result = subprocess.run([sys.executable, ROOT / "tools/newgold/make_tm_label.py", "--check"],
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


if __name__ == "__main__":
    unittest.main()
