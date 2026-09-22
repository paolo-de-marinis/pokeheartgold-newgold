#!/usr/bin/env python3
"""Check that the save still fits.

Every block is sized by one sizeof, and the game adds them up at boot, pages
them, and asserts twice. Nothing checks any of it when the ROM is built, so a
struct that grows past the region — a wider Dex, more boxes — would pass every
other test here and then assert on a real save file.

The page count is the tight one: thirty-five of thirty-five are in use, so the
save proper has one part-empty page to grow into and no more.
"""

import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import save_budget  # noqa: E402

BUILD = ROOT / "build/heartgold.us"


class SaveBudgetTests(unittest.TestCase):
    def setUp(self):
        if not (BUILD / "main.sbin").exists():
            self.skipTest("the ROM has not been built")
        self.inside, self.outside = save_budget.measure(BUILD)

    def test_the_region_fits(self):
        region, pages, highest = save_budget.layout(self.inside, self.outside)
        self.assertLessEqual(region, save_budget.REGION,
                             f"the save is {region - save_budget.REGION} bytes over")
        print(f"PASS: save uses {region} of {save_budget.REGION} bytes, "
              f"{sum(c for c, _ in pages)} of {save_budget.SAVE_PAGE_MAX} pages, "
              f"highest page {highest} of {save_budget.PAGES_PER_HALF}.")

    def test_the_pages_fit(self):
        """SaveData_InitSlotSpecs asserts this one, and it is at the limit."""
        _, pages, _ = save_budget.layout(self.inside, self.outside)
        self.assertLessEqual(sum(count for count, _ in pages), save_budget.SAVE_PAGE_MAX)

    def test_the_flash_half_fits(self):
        """The chunks written past the region must stay inside the half the
        game erases, or saving would run off the end of it."""
        _, _, highest = save_budget.layout(self.inside, self.outside)
        self.assertLessEqual(highest, save_budget.PAGES_PER_HALF)

    def test_every_block_has_a_size(self):
        for name, size, _ in self.inside + self.outside:
            self.assertGreater(size, 0, name)

    def test_the_dex_is_one_of_them(self):
        """It is the block this port keeps widening."""
        self.assertIn("Save_Pokedex_sizeof", [name for name, _, _ in self.inside])

    def test_the_heap_that_holds_the_save_is_big_enough(self):
        """SaveData is the whole region plus its headers, and it is allocated
        from heap 1. The heap was sized to the region; it has to keep up."""
        import re
        spec = (ROOT / "src/system.c").read_text()
        heaps = re.findall(r"\{ (0x[0-9A-Fa-f]+),\s+OS_ARENA_MAIN \}", spec)
        self.assertGreaterEqual(len(heaps), 2)
        self.assertGreater(int(heaps[1], 16), save_budget.REGION,
                           "heap 1 no longer holds the save region")


if __name__ == "__main__":
    unittest.main()
