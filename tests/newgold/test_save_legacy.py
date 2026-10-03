#!/usr/bin/env python3
"""A save made in an older layout still loads.

Three changes have grown the region's first slot since this port's saves
began: hg-engine's expansion of the misc block (storedMons, isMonStored, for
the DNA Splicers), the Berries pocket holding every Berry, and the Dex's
record of the forms. Each moves the blocks after it and changes the first
slot's size in its footer, and the second has a footer magic of its own,
which the third keeps: read the new way, an older save would be refused as
corrupt. Save_GetSaveFilesStatus tries the older layouts,
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
# now, before the Dex's record of the forms, before the Berries pocket held
# every Berry, before the DNA Splicers.
LAYOUTS = {0: [65456, 124156], 1: [65232, 124156], 2: [65088, 124156], 3: [64140, 124156]}

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
@BLOCKS@
@ENUM@
@STRUCTS@
typedef struct { struct SaveArrayHeader arrayHeaders[4]; struct SaveSlotSpec saveSlotSpecs[2]; } SaveData;

@NATIVE@

static u8 region[0x4000];

// Four blocks in the first slot, as a save in `layout` wrote them: 100
// bytes, the bag (its Berries pocket 6 slots before the change, 10 after),
// the Dex (200 bytes before its record of the forms, 240 more after), the
// misc block (0x20 before the DNA Splicers, 0x18 more after), each with its
// check word, then the footer.
static void old_region(u32 layout) {
    u32 berries = 4 * (layout >= SAVE_LAYOUT_BEFORE_BERRY_POCKET ? NUM_BAG_BERRIES_LEGACY : NUM_BAG_BERRIES);
    u32 dex = layout >= SAVE_LAYOUT_BEFORE_DEX_FORMS ? offsetof(Pokedex, formsSeen) : sizeof(Pokedex);
    u32 misc = layout >= SAVE_LAYOUT_BEFORE_DNA_SPLICERS ? 0x24 : 0x3C;
    u8 *at = region;

    memset(region, 0xEE, sizeof(region));
    memset(at, 0x11, 104), at += 104;
    memset(at, 0xB1, 16), at += 16;       // the pockets before the Berries
    memset(at, 0xB2, berries), at += berries;
    memset(at, 0xB3, 12), at += 12;       // the balls
    memset(at, 0xB4, 4), at += 4;         // the bag's check word
    memset(at, 0x33, dex), at += dex;
    memset(at, 0x34, 4), at += 4;         // the Dex's check word
    memset(at, 0x44, misc), at += misc;
    memset(at, 0x55, 16);
}

int main(void) {
    u32 bag = sizeof(Bag) + 4, dex = sizeof(Pokedex) + 4, misc = 0x38 + 4;
    u32 grownBag = 4 * (NUM_BAG_BERRIES - NUM_BAG_BERRIES_LEGACY), grownDex = sizeof(Pokedex) - offsetof(Pokedex, formsSeen);
    SaveData save = { { { 0, 104, 0 }, { SAVE_BAG, bag, 104 }, { SAVE_POKEDEX, dex, 104 + bag }, { SAVE_MISC, misc, 104 + bag + dex } } };
    struct SaveSlotSpec specs[2];
    u32 i, layout, size = 104 + bag + dex + misc + 16;

    save.saveSlotSpecs[0].size = size;
    save.saveSlotSpecs[1].offset = (size + 0xFF) & ~0xFF;
    save.saveSlotSpecs[1].size = 0x1000;
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_NOW, specs);
    assert(specs[0].size == size && specs[1].offset == save.saveSlotSpecs[1].offset);
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_BEFORE_DEX_FORMS, specs);
    assert(specs[0].offset == 0 && specs[0].size == size - grownDex);
    assert(specs[1].offset == ((specs[0].size + 0xFF) & ~0xFF) && specs[1].size == 0x1000);
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_BEFORE_BERRY_POCKET, specs);
    assert(specs[0].size == size - grownDex - grownBag);
    Save_GetLayoutSlotSpecs(&save, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, specs);
    assert(specs[0].size == size - grownDex - grownBag - (misc - 0x24));

    for (layout = SAVE_LAYOUT_BEFORE_DEX_FORMS; layout < SAVE_LAYOUT_COUNT; layout++) {
        u8 *at = region;

        Save_GetLayoutSlotSpecs(&save, layout, specs);
        old_region(layout);
        Save_ConvertFirstSlot(&save, region, layout, specs[0].size);
        for (i = 0; i < 104; i++) assert(*at++ == 0x11);
        for (i = 0; i < 16; i++) assert(*at++ == 0xB1);
        for (i = 0; i < 4 * NUM_BAG_BERRIES_LEGACY; i++) assert(*at++ == 0xB2);
        for (i = 0; i < grownBag; i++) assert(*at++ == (layout >= SAVE_LAYOUT_BEFORE_BERRY_POCKET ? 0 : 0xB2));  // new: empty
        for (i = 0; i < 12; i++) assert(*at++ == 0xB3);
        for (i = 0; i < 4; i++) assert(*at++ == 0xB4);
        for (i = 0; i < offsetof(Pokedex, formsSeen); i++) assert(*at++ == 0x33);
        for (i = 0; i < grownDex; i++) assert(*at++ == 0);           // the record of the forms, empty
        for (i = 0; i < 4; i++) assert(*at++ == 0x34);
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


# Save_GetSaveFilesStatus over a made-up flash: the same four blocks, a PC
# slot of 0x100 bytes after the first slot's next 0x100, and slots written
# the way each layout wrote them.
STATUS = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT(x) assert(x)
#define SAVE_PAGE_MAX 6
#define SAVE_SECTOR_SIZE 0x100
#define HEAP_ID_3 3
@BLOCKS@
@DEFINES@
@ENUM@
@STRUCTS@
typedef struct {
    u32 saveCounter;
    struct SaveArrayHeader arrayHeaders[4];
    struct SaveSlotSpec saveSlotSpecs[2];
    u8 sectorCleanFlag[2];
    u16 lastGoodSector;
    u32 saveLayout;
} SaveData;
static u8 sFlash[2][SAVE_PAGE_MAX * SAVE_SECTOR_SIZE];
static void *Heap_AllocAtEnd(int heapId, u32 size) { (void)heapId; return malloc(size); }
static void Heap_Free(void *p) { free(p); }
static BOOL FlashLoadChunk(u32 offset, void *dest, u32 size) { memcpy(dest, sFlash[offset / 0x40000] + offset % 0x40000, size); return TRUE; }
static u16 GF_CalcCRC16(const void *data, u32 size) {
    u16 crc = 0;
    for (u32 i = 0; i < size; i++) crc = crc * 31 + ((const u8 *)data)[i];
    return crc;
}
static void SaveFooterDebugPrn(struct SaveChunkFooter *footer) { (void)footer; }
static void DebugPrn_MirrorValid(BOOL valid) { (void)valid; }
@NATIVE@

static SaveData sSave;

// Slot idx of a save in `layout`, counter `count`, into half h, where that
// layout put it and with its magic.
static void put(int h, u32 layout, int idx, u32 count) {
    struct SaveSlotSpec specs[2];
    struct SaveChunkFooter *footer;

    Save_GetLayoutSlotSpecs(&sSave, layout, specs);
    memset(sFlash[h] + specs[idx].offset, 0x40 + count, specs[idx].size);
    footer = (struct SaveChunkFooter *)(sFlash[h] + specs[idx].offset + specs[idx].size - sizeof(*footer));
    footer->count = count;
    footer->size = specs[idx].size;
    footer->magic = layout <= SAVE_LAYOUT_BEFORE_DEX_FORMS ? SAVE_CHUNK_MAGIC_BERRY_POCKET : SAVE_CHUNK_MAGIC;
    footer->slot = idx;
    footer->crc = SaveArray_CalcCRC16MinusFooter(&sSave, sFlash[h] + specs[idx].offset, specs[idx].size);
}

static int status(void) {
    sSave.saveCounter = 0;
    sSave.lastGoodSector = 7;
    return Save_GetSaveFilesStatus(&sSave);
}

int main(void) {
    // The first block 184 bytes, so that as in the game the PC slot is
    // 0x100 lower than now before the Dex's record of the forms, where it
    // still is before the Berries pocket (the magic tells those two apart),
    // and 0x100 lower again before the DNA Splicers.
    u32 bag = sizeof(Bag) + 4, dex = sizeof(Pokedex) + 4, misc = 0x38 + 4, size = 184 + bag + dex + misc + 16;
    int got;
    SaveData save = { 0, { { 0, 184, 0 }, { SAVE_BAG, bag, 184 }, { SAVE_POKEDEX, dex, 184 + bag }, { SAVE_MISC, misc, 184 + bag + dex } } };

    sSave = save;
    sSave.saveSlotSpecs[0].size = size;
    sSave.saveSlotSpecs[1].offset = (size + 0xFF) & ~0xFF;
    sSave.saveSlotSpecs[1].size = 0x100;
    {
        struct SaveSlotSpec older[2];
        assert(sSave.saveSlotSpecs[1].offset == 0x400);
        Save_GetLayoutSlotSpecs(&sSave, SAVE_LAYOUT_BEFORE_DEX_FORMS, older);
        assert(older[1].offset == 0x300);
        Save_GetLayoutSlotSpecs(&sSave, SAVE_LAYOUT_BEFORE_BERRY_POCKET, older);
        assert(older[1].offset == 0x300);
        Save_GetLayoutSlotSpecs(&sSave, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, older);
        assert(older[1].offset == 0x200);
    }

    // A whole save of each older layout, alone in the flash, is read as its
    // own; the two whose PC slots share a place by their magic.
    for (u32 layout = SAVE_LAYOUT_BEFORE_DEX_FORMS; layout < SAVE_LAYOUT_COUNT; layout++) {
        memset(sFlash, 0xFF, sizeof(sFlash));
        put(0, layout, 0, 3);
        put(0, layout, 1, 3);
        got = status();
        assert(got == LOAD_STATUS_IS_GOOD && sSave.saveLayout == layout && sSave.lastGoodSector == 0);
    }

    // Nothing: a new game.
    memset(sFlash, 0xFF, sizeof(sFlash));
    assert(status() == LOAD_STATUS_NOT_EXIST);
    // A whole save before the DNA Splicers in the first half: loaded as it is.
    put(0, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, 0, 5);
    put(0, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, 1, 5);
    got = status();
    assert(got == LOAD_STATUS_IS_GOOD && sSave.saveLayout == SAVE_LAYOUT_BEFORE_DNA_SPLICERS && sSave.lastGoodSector == 0);
    // Its first save after the conversion, stopped between the main slot's
    // footer and the PC's: the second half has a main slot of now and no PC
    // slot. The first half's older save is loaded as the previous save file;
    // before, the flash was called corrupt and erased.
    put(1, SAVE_LAYOUT_NOW, 0, 6);
    got = status();
    printf("interrupted first save: status %d, layout %u, half %u\n", got, sSave.saveLayout, sSave.lastGoodSector);
    assert(got == LOAD_STATUS_SLOT_FAIL && sSave.saveLayout == SAVE_LAYOUT_BEFORE_DNA_SPLICERS && sSave.lastGoodSector == 0);
    assert(sSave.saveCounter == 5);
    // The same with the second half's PC slot the save before that one's.
    put(1, SAVE_LAYOUT_BEFORE_DNA_SPLICERS, 1, 4);
    put(1, SAVE_LAYOUT_NOW, 0, 6);
    got = status();
    assert(got == LOAD_STATUS_SLOT_FAIL && sSave.saveLayout == SAVE_LAYOUT_BEFORE_DNA_SPLICERS && sSave.lastGoodSector == 0);
    // The save finished: the second half is a whole save of now, loaded.
    put(1, SAVE_LAYOUT_NOW, 1, 6);
    got = status();
    assert(got == LOAD_STATUS_IS_GOOD && sSave.saveLayout == SAVE_LAYOUT_NOW && sSave.lastGoodSector == 1);
    // A main slot of now and nothing else anywhere is judged as before.
    memset(sFlash, 0xFF, sizeof(sFlash));
    put(1, SAVE_LAYOUT_NOW, 0, 6);
    got = status();
    assert(got == LOAD_STATUS_TOTAL_FAIL && sSave.saveLayout == SAVE_LAYOUT_NOW);
    puts("PASS: a first save after a conversion cut short loads the older save it came from.");
    return 0;
}
"""


# The made-up save's blocks the layouts grew, as small as the native tests
# need: the bag's Berries pocket 6 slots then 10, the Dex 200 bytes then 240
# more (enough to move the PC slot as the game's does), the misc block 0x20
# then 0x18 more.
BLOCKS = r"""
#define SAVE_BAG 1
#define SAVE_POKEDEX 2
#define SAVE_MISC 3
#define SAVE_MISC_LEGACY_SIZE 0x20
#define NUM_BAG_BERRIES 10
#define NUM_BAG_BERRIES_LEGACY 6
typedef struct { u16 id, quantity; } ItemSlot;
typedef struct { ItemSlot items[4]; ItemSlot berries[NUM_BAG_BERRIES]; ItemSlot balls[3]; } Bag;
typedef struct { u8 retail[200]; u32 formsSeen[30]; u32 formsCaught[30]; } Pokedex;
"""


def any_function(source, name):
    """A function's definition, whatever it returns (a struct pointer too)."""
    match = re.search(rf"^[A-Za-z][^\n;(]*\b{name}\([^;{{]*\) \{{", source, re.M)
    depth, end = 1, match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


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
        program = (NATIVE.replace("@NATIVE@", native).replace("@STRUCTS@", structs).replace("@ENUM@", enum)
                   .replace("@BLOCKS@", BLOCKS))
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

    def test_an_interrupted_first_save_falls_back_to_the_older_one(self):
        """The first save after a conversion writes the main slot and its
        footer first and the PC's footer last, after every box, about 800
        frames later. Cut short between them, the flash has a main slot of
        now in one half and the whole older save in the other: the game
        loads that as the previous save file. savedit already opens only a
        half whose every slot reads (Save.valid)."""
        source = (ROOT / "src/save.c").read_text()
        header = (ROOT / "include/save.h").read_text()
        enum = re.search(r"enum SaveLayout \{.*?\};", header, re.S).group(0)
        defines = "\n".join(re.findall(r"^#define (?:LOAD_STATUS_|SAVE_CHUNK_MAGIC)\w* .*$", header, re.M))
        structs = "\n".join(struct_source("include/save.h", name)
                            for name in ("SaveArrayHeader", "SaveArrayFooter", "SaveChunkFooter", "SaveSlotSpec", "SaveSlotCheck"))
        native = "\n".join(any_function(source, name) for name in (
            "SaveSlotCheck_InitDummy", "SaveArray_CalcCRC16MinusFooter", "GetSaveSectorFooterPtr", "ValidateSaveSectorFooter",
            "SaveSlotCheck_InitFromSavedat", "SaveCounterCompare", "SaveSlotCheckCompare", "Save_RecordWhichLatestGoodSector",
            "Save_CheckSlotFooters", "Save_LayoutGrowth", "Save_GetLayoutSlotSpecs", "Save_GetSaveFilesStatus"))
        native = re.sub(r"^#pragma unused.*$", "", native, flags=re.M)
        program = (STATUS.replace("@NATIVE@", native).replace("@STRUCTS@", structs).replace("@ENUM@", enum)
                   .replace("@DEFINES@", defines).replace("@BLOCKS@", BLOCKS))
        with tempfile.TemporaryDirectory(prefix="newgold-save-status-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", str(c), "-o", str(exe)],
                                   capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip().splitlines()[-1])

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

    def test_the_layouts_since_the_berries_pocket_have_a_magic_of_their_own(self):
        # The PC's slot is the same in the layout before the Dex's record of
        # the forms and in the one before the Berries pocket grew: only the
        # magic tells them apart. The layout of now has its PC slot 0x100
        # further on, and keeps the magic (docs/newgold/SAVE-LAYOUT.md).
        magics = re.findall(r"#define (SAVE_CHUNK_MAGIC\w*) (0x[0-9A-F]+)", (ROOT / "include/save.h").read_text())
        self.assertEqual(len({value for _, value in magics}), 2, magics)
        source = (ROOT / "src/save.c").read_text()
        self.assertIn("saveData->saveLayout <= SAVE_LAYOUT_BEFORE_DEX_FORMS ? SAVE_CHUNK_MAGIC_BERRY_POCKET : SAVE_CHUNK_MAGIC",
                      function(source, "ValidateSaveSectorFooter"))
        self.assertIn("footer->magic = SAVE_CHUNK_MAGIC_BERRY_POCKET;", function(source, "SaveSlot_BuildFooter"))

    def test_the_expansions_start_where_heartgold_s_blocks_ended(self):
        header = (ROOT / "include/save_misc_data.h").read_text()
        self.assertIn("#define SAVE_MISC_LEGACY_SIZE 0x2E0", header)
        self.assertIn("offsetof(SAVE_MISC_DATA, storedMons) == SAVE_MISC_LEGACY_SIZE", (ROOT / "src/save_misc.c").read_text())
        self.assertIn("#define NUM_BAG_BERRIES_LEGACY 64", (ROOT / "include/constants/items.h").read_text())


if __name__ == "__main__":
    unittest.main()
