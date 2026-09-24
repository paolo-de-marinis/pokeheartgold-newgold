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
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"
RETAIL_MARGIN = 0x4D000     # 0x11D000 - 0x1C000 - 0x4000 - 0xB0000

# sizeof(ItemData) in include/item.h: thirty-four bytes of fields and two of
# padding. LoadAllItemData asks the battle heap for one of these per record.
ITEM_RECORD = 36
# The battle heap's share that the item table may take. It is the only
# allocation in the game the item range sizes, and the range is what this port
# keeps growing: the 541 records before it cost 0x4C14, the whole range costs
# 0x17778 of the 0xB0000 Battle_Run carves. An eighth of the battle heap is
# the line, which leaves room for about another nine hundred items, and heap 3
# has none to spare to widen the battle's share -- the margin above is already
# only what retail had. Crossing it is not a build error and not a crash: it
# is the same blank battle a heap too small always gives here, which is why
# the number is checked rather than discovered.
BATTLE_ITEM_TABLE_CEILING = 0x20000

# The default heap went from retail's 0xD200 to 0x8000 to give the main
# arena room. The most it was seen to hold (gDiagHeapLowWater, a diagnostics
# build through every scene the harness reaches) is the communication-error
# screen, 0x5950 wherever it is raised; the Pokeathlon, not reached, is
# estimated at 0x6000. The floor keeps 0x2000 over that estimate.
DEFAULT_HEAP_FLOOR = 0x6000 + 0x2000

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


def item_table_size():
    """What LoadAllItemData asks for: one record per row of item_data.csv.

    csv2bin makes one archive member per row in order, and the last item's
    mapping points at the last member, so the row count is the count the C
    works out at runtime from GetItemIndexMapping(ITEM_MAX) + 1.
    """
    return (len(ITEM_DATA.read_text().splitlines()) - 1) * ITEM_RECORD


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

    def test_the_item_table_still_fits_inside_the_battle_heap(self):
        """The whole item table is loaded into the battle heap for the AI."""
        size = item_table_size()
        battle = self.children["HEAP_ID_BATTLE"]
        self.assertLess(
            size, BATTLE_ITEM_TABLE_CEILING,
            f"LoadAllItemData asks the battle heap for {size:#x} of its "
            f"{battle:#x}, and the ceiling is {BATTLE_ITEM_TABLE_CEILING:#x}; "
            "the items have outgrown the battle heap's share of heap 3")
        print(f"PASS: the item table is {size:#x} of the battle heap's {battle:#x}.")

    def test_the_bag_fits_beside_the_pc(self):
        """The PC opens the bag with its own heap still up. The bag's heap is
        hg-engine's 0x65000 (retail 0x42000) since its list holds 255 names."""
        general = self.heaps[3]
        field = self.children["HEAP_ID_FIELD2"] + self.children["HEAP_ID_FIELD3"]
        pc = child_size("HEAP_ID_10", ROOT / "src/overlay_14_021EAFAC.c")
        bag = child_size("HEAP_ID_6", ROOT / "src/bag_init.c")
        left = general - field - pc - bag
        self.assertGreaterEqual(left, 0, f"heap 3 is {general:#x}; the field, the PC and the bag take {field + pc + bag:#x}")
        print(f"PASS: heap 3 leaves {left:#x} with the PC and the bag open.")

    def test_the_default_heap_holds_the_communication_error_screen(self):
        self.assertGreaterEqual(
            self.heaps[0], DEFAULT_HEAP_FLOOR,
            f"the default heap is {self.heaps[0]:#x}; the communication-error screen "
            f"alone takes 0x5950 of it, and the floor is {DEFAULT_HEAP_FLOOR:#x}")
        print(f"PASS: the default heap is {self.heaps[0]:#x}, floor {DEFAULT_HEAP_FLOOR:#x}.")

    def test_the_save_still_fits_its_heap(self):
        """Heap 1 holds SaveData, whose region is SAVE_PAGE_MAX sectors."""
        import sys
        sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
        import save_budget
        region = save_budget.REGION
        self.assertGreater(self.heaps[1], region,
                           f"heap 1 is {self.heaps[1]:#x} and the save region alone is {region:#x}")
        print(f"PASS: heap 1 is {self.heaps[1]:#x} for a save region of {region:#x}.")


if __name__ == "__main__":
    unittest.main()
