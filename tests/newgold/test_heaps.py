#!/usr/bin/env python3
"""Check that the heaps still fit what runs in them.

The general heap is where every application carves its own heap from, and a
battle carves the biggest. Heap_Create returns FALSE when the parent cannot
give it the room, Battle_Run does not look, and GF_ASSERT is gated on a flag
that is usually off: so a general heap made a little too small does not crash
anything. The battle starts, gets NULL from every allocation, draws nothing,
and hands back to the field a few seconds later. That is what thirty boxes
did: heap 1 grew by 0xD000 for the bigger save and heap 3 gave up the same,
and from then on every wild battle was a blank screen with the music playing.

Nothing at build time knows how much of heap 3 the field has in use when a
battle begins, so the check is against the margin retail shipped with: after
the field's own heaps and the battle's, retail had 0x4D000 left, and the
battle stopped rendering when that fell to 0x40000.
"""

import re
import unittest

from test_level_cap import ROOT

SYSTEM = ROOT / "src/system.c"
RETAIL_MARGIN = 0x4D000     # 0x11D000 - 0x1C000 - 0x4000 - 0xB0000

# What is alive inside heap 3 while a wild battle runs.
CHILDREN = {
    "HEAP_ID_FIELD2": ROOT / "src/field_system.c",
    "HEAP_ID_FIELD3": ROOT / "src/field_system.c",
    "HEAP_ID_BATTLE": ROOT / "src/battle/battle_022378C0.c",
}


def default_heaps():
    """The sizes sDefaultHeapSpec hands to Heap_InitSystem, in order."""
    text = SYSTEM.read_text()
    block = text[text.index("sDefaultHeapSpec[] = {"):]
    block = block[:block.index("};")]
    return [int(m, 16) for m in re.findall(r"\{\s*(0x[0-9A-Fa-f]+),", block)]


def child_size(name, path):
    match = re.search(rf"Heap_Create\(HEAP_ID_3,\s*{name},\s*(0x[0-9A-Fa-f]+)\)", path.read_text())
    if not match:
        raise AssertionError(f"{name} is no longer carved from heap 3 in {path.name}")
    return int(match.group(1), 16)


class HeapTests(unittest.TestCase):
    def setUp(self):
        self.heaps = default_heaps()
        self.assertEqual(len(self.heaps), 4, "sDefaultHeapSpec has changed shape")
        self.children = {name: child_size(name, path) for name, path in CHILDREN.items()}

    def test_a_wild_battle_fits_in_the_general_heap(self):
        general = self.heaps[3]
        used = sum(self.children.values())
        left = general - used
        self.assertGreaterEqual(
            left, RETAIL_MARGIN,
            f"heap 3 is {general:#x}; after the field's heaps and the battle's "
            f"({used:#x}) it has {left:#x} left, and retail had {RETAIL_MARGIN:#x}")
        print(f"PASS: heap 3 leaves {left:#x} after a wild battle's heaps; retail left {RETAIL_MARGIN:#x}.")

    def test_the_save_still_fits_its_heap(self):
        """Heap 1 holds SaveData, whose region is SAVE_PAGE_MAX sectors."""
        import sys
        sys.path.insert(0, str(ROOT / "tools/newgold"))
        import save_budget
        region = save_budget.REGION
        self.assertGreater(self.heaps[1], region,
                           f"heap 1 is {self.heaps[1]:#x} and the save region alone is {region:#x}")
        print(f"PASS: heap 1 is {self.heaps[1]:#x} for a save region of {region:#x}.")


if __name__ == "__main__":
    unittest.main()
