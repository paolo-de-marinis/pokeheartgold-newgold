#!/usr/bin/env python3
"""Check that the save still fits its region.

Every block of the general save is sized by one sizeof, and the game adds them
up at boot and asserts the total fits in thirty-five sectors. Nothing checks it
when the ROM is built, so a struct that grows past the region — a wider Dex,
more boxes — would pass every test here and then assert on a real save.
"""

import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import save_budget  # noqa: E402

BUILD = ROOT / "build/heartgold.us"


class SaveBudgetTests(unittest.TestCase):
    def setUp(self):
        if not (BUILD / "main.sbin").exists():
            self.skipTest("the ROM has not been built")
        self.inside, self.outside = save_budget.measure(BUILD)

    def test_the_general_region_fits(self):
        total = sum(size for _, size in self.inside)
        self.assertLessEqual(total, save_budget.REGION,
                             f"the save is {total - save_budget.REGION} bytes over")
        print(f"PASS: save uses {total} of {save_budget.REGION} bytes, "
              f"{save_budget.REGION - total} free.")

    def test_every_block_has_a_size(self):
        for name, size in self.inside + self.outside:
            self.assertGreater(size, 0, name)

    def test_the_dex_is_one_of_them(self):
        """It is the block this port keeps widening."""
        self.assertIn("Save_Pokedex_sizeof", [name for name, _ in self.inside])


if __name__ == "__main__":
    unittest.main()
