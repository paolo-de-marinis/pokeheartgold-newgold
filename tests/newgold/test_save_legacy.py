#!/usr/bin/env python3
"""A save made in an older layout still loads.

Two changes have grown the region's first slot since this port's saves
began: hg-engine's expansion of the misc block (storedMons, isMonStored, for
the DNA Splicers), and the Berries pocket holding every Berry. Each moves the
blocks after it and changes the first slot's size in its footer, and the
second has a footer magic of its own: read the new way, an older save would
be refused as corrupt. Save_GetSaveFilesStatus tries the older layouts,
newest first, when nothing reads as this one, and Save_LoadLegacySlots reads
the one found: the PC's slot from where it was in the flash, the first slot
as it was, then Save_ConvertFirstSlot makes it this layout's one change at a
time (docs/newgold/SAVE-LAYOUT.md).

The layout functions are compiled natively here over a made-up save of four
blocks; that a real one loads is checked in the emulator, with a save made
before the change (the commit that added each layout says how).
"""

import os
import re
import shlex
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness")]
import savedit  # noqa: E402

BUILD = ROOT / "build/heartgold.us"
# The first slot's size and the PC slot's, in each layout the game reads:
# now, before the Berries pocket held every Berry, before the DNA Splicers.
LAYOUTS = {0: [65232, 124156], 1: [65088, 124156], 2: [64140, 124156]}

NATIVE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#define MI_CpuClear8(p, n) memset((p), 0, (n))
#define SAVE_BAG 1
#define SAVE_MISC 3
#define SAVE_MISC_LEGACY_SIZE 0x20
#define NUM_BAG_BERRIES 10
#define NUM_BAG_BERRIES_LEGACY 6
typedef struct { u16 id, quantity; } ItemSlot;
typedef struct { ItemSlot items[4]; ItemSlot berries[NUM_BAG_BERRIES]; ItemSlot balls[3]; } Bag;
@ENUM@
@STRUCTS@
typedef struct { struct SaveArrayHeader arrayHeaders[4]; struct SaveSlotSpec saveSlotSpecs[2]; } SaveData;

@NATIVE@

static u8 region[0x4000];

// Four blocks in the first slot, as a save in `layout` wrote them: 100
// bytes, the bag (its Berries pocket 6 slots before the change, 10 after),
// 200 bytes, the misc block (0x20 before the DNA Splicers, 0x18 more after),
// each with its check word, then the footer.
static void old_region(u32 layout) {
    u32 berries = 4 * (layout >= SAVE_LAYOUT_BEFORE_BERRY_POCKET ? NUM_BAG_BERRIES_LEGACY : NUM_BAG_BERRIES);
    u32 misc = layout >= SAVE_LAYOUT_BEFORE_DNA_SPLICERS ? 0x24 : 0x3C;
    u8 *at = region;

    memset(region, 0xEE, sizeof(region));
    memset(at, 0x11, 104), at += 104;
    memset(at, 0xB1, 16), at += 16;       // the pockets before the Berries
    memset(at, 0xB2, berries), at += berries;
    memset(at, 0xB3, 12), at += 12;       // the balls
    memset(at, 0xB4, 4), at += 4;         // the bag's check word
    memset(at, 0x33, 204), at += 204;
    memset(at, 0x44, misc), at += misc;
    memset(at, 0x55, 16);
}

int main(void) {
    u32 bag = sizeof(Bag) + 4, misc = 0x38 + 4, grownBag = 4 * (NUM_BAG_BERRIES - NUM_BAG_BERRIES_LEGACY);
    SaveData save = { { { 0, 104, 0 }, { SAVE_BAG, bag, 104 }, { 2, 204, 104 + bag }, { SAVE_MISC, misc, 104 + bag + 204 } } };
    struct SaveSlotSpec specs[2];
    u32 i, layout, size = 104 + bag + 204 + misc + 16;

    save.saveSlotSpecs[0].size = size;
    save.saveSlotSpecs[1].offset = (size + 0xFF) & ~0xFF;
    save.saveSlotSpecs[1].size = 0x1000;
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_NOW, specs);
    assert(specs[0].size == size && specs[1].offset == save.saveSlotSpecs[1].offset);
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_BEFORE_BERRY_POCKET, specs);
    assert(specs[0].offset == 0 && specs[0].size == size - grownBag);
    assert(specs[1].offset == ((specs[0].size + 0xFF) & ~0xFF) && specs[1].size == 0x1000);
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, specs);
    assert(specs[0].size == size - grownBag - (misc - 0x24));

    for (layout = SAVE_LAYOUT_BEFORE_BERRY_POCKET; layout < SAVE_LAYOUT_COUNT; layout++) {
        u8 *at = region;

        Save_GetLayoutSlotSpecs(&save, layout, specs);
        old_region(layout);
        Save_ConvertFirstSlot(&save, region, layout, specs[0].size);
        for (i = 0; i < 104; i++) assert(*at++ == 0x11);
        for (i = 0; i < 16; i++) assert(*at++ == 0xB1);
        for (i = 0; i < 4 * NUM_BAG_BERRIES_LEGACY; i++) assert(*at++ == 0xB2);
        for (i = 0; i < grownBag; i++) assert(*at++ == 0);          // the new Berry slots, empty
        for (i = 0; i < 12; i++) assert(*at++ == 0xB3);
        for (i = 0; i < 4; i++) assert(*at++ == 0xB4);
        for (i = 0; i < 204; i++) assert(*at++ == 0x33);
        for (i = 0; i < SAVE_MISC_LEGACY_SIZE; i++) assert(*at++ == 0x44);
        for (i = 0; i < 0x18; i++) assert(*at++ == (layout >= SAVE_LAYOUT_BEFORE_DNA_SPLICERS ? 0 : 0x44));
        for (i = 0; i < 4; i++) assert(*at++ == 0x44);             // the misc block's check word
        for (i = 0; i < 16; i++) assert(*at++ == 0x55);
        assert(at == region + size);
    }
    puts("PASS: each older layout's slots are found, and its blocks moved to where they are now.");
    return 0;
}
"""


def struct_source(header, name):
    text = (ROOT / header).read_text()
    body = text[text.index(f"struct {name} {{"):]
    return body[:body.index("};") + 2]


class LegacySaveTests(unittest.TestCase):
    def test_the_old_layouts_are_read_into_the_new(self):
        source = (ROOT / "src/save.c").read_text()
        enum = re.search(r"enum SaveLayout \{.*?\};", (ROOT / "include/save.h").read_text(), re.S).group(0)
        structs = "\n".join(struct_source("include/save.h", name) for name in ("SaveArrayHeader", "SaveSlotSpec"))
        native = "\n".join(function(source, name) for name in ("Save_LayoutGrowth", "Save_GetLayoutSlotSpecs",
                                                                "Save_ConvertFirstSlot"))
        program = NATIVE.replace("@NATIVE@", native).replace("@STRUCTS@", structs).replace("@ENUM@", enum)
        with tempfile.TemporaryDirectory(prefix="newgold-legacy-save-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", str(c), "-o", str(exe)],
                                   capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())

    def test_the_layout_is_one_the_game_reads(self):
        """A layout is told by where the footers are, the sizes they give
        and their magic. A block that changes size makes another, which a
        save of the others would not load as; docs/newgold/SAVE-LAYOUT.md
        says what that change has to do."""
        if not (BUILD / "main.sbin").exists():
            self.skipTest("the ROM has not been built")
        for layout, sizes in LAYOUTS.items():
            got = [spec["size"] for spec in savedit.slot_specs(savedit.blocks(BUILD, layout))]
            self.assertEqual(got, sizes, f"layout {layout}: the save's layout changed, see docs/newgold/SAVE-LAYOUT.md")

    def test_the_layout_of_now_has_a_magic_of_its_own(self):
        # The PC's slot is the same in the layout of now and in the one
        # before the Berries pocket grew: only the magic tells them apart.
        magics = re.findall(r"#define (SAVE_CHUNK_MAGIC\w*) (0x[0-9A-F]+)", (ROOT / "include/save.h").read_text())
        self.assertEqual(len({value for _, value in magics}), 2, magics)
        source = (ROOT / "src/save.c").read_text()
        self.assertIn("saveData->saveLayout == SAVE_LAYOUT_NOW ? SAVE_CHUNK_MAGIC_BERRY_POCKET : SAVE_CHUNK_MAGIC",
                      function(source, "ValidateSaveSectorFooter"))
        self.assertIn("footer->magic = SAVE_CHUNK_MAGIC_BERRY_POCKET;", function(source, "SaveSlot_BuildFooter"))

    def test_the_expansions_start_where_heartgold_s_blocks_ended(self):
        header = (ROOT / "include/save_misc_data.h").read_text()
        self.assertIn("#define SAVE_MISC_LEGACY_SIZE 0x2E0", header)
        self.assertIn("offsetof(SAVE_MISC_DATA, storedMons) == SAVE_MISC_LEGACY_SIZE", (ROOT / "src/save_misc.c").read_text())
        self.assertIn("#define NUM_BAG_BERRIES_LEGACY 64", (ROOT / "include/constants/items.h").read_text())


if __name__ == "__main__":
    unittest.main()
