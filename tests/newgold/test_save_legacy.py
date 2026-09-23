#!/usr/bin/env python3
"""A save made before SAVE_MISC_DATA kept Pokemon still loads.

hg-engine's expansion adds four Pokemon and their flags to the misc block
(storedMons, isMonStored), which moves every block after it and the PC's
slot, and changes the first slot's size in its footer: read the old way, a
save from before would be refused as corrupt. Save_GetSaveFilesStatus tries
that layout when nothing reads as this one, and Save_LoadLegacySlots reads it:
the PC's slot from where it was in the flash, the first slot as it was, then
Save_ConvertLegacyFirstSlot moves the blocks after the misc block up.

The two layout functions are compiled natively here over a made-up save of
three blocks; that a real one loads is checked in the emulator, with a save
made before the change (the commit that added this says how).
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function

NATIVE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#define MI_CpuClear8(p, n) memset((p), 0, (n))
#define SAVE_MISC @MISC@
#define SAVE_MISC_LEGACY_SIZE @LEGACY@
@STRUCTS@
typedef struct { struct SaveArrayHeader arrayHeaders[3]; struct SaveSlotSpec saveSlotSpecs[2]; } SaveData;

@NATIVE@

int main(void) {
    // Three blocks in the first slot: 100 bytes, the misc block, 500 bytes,
    // each with its check word, then the footer.
    u32 grown = (@SIZE@ + 3 & ~3) + 4, legacy = (SAVE_MISC_LEGACY_SIZE + 3 & ~3) + 4;
    SaveData save = { { { 0, 104, 0 }, { SAVE_MISC, grown, 104 }, { 2, 504, 104 + grown } } };
    struct SaveSlotSpec specs[2];
    static u8 region[0x4000];
    u32 i, size = 104 + grown + 504 + 16;

    save.saveSlotSpecs[0].size = size;
    save.saveSlotSpecs[1].offset = (size + 0xFF) & ~0xFF;
    save.saveSlotSpecs[1].size = 0x1000;
    Save_GetLegacySlotSpecs(&save, specs);
    assert(specs[0].offset == 0 && specs[0].size == size - (grown - legacy));
    assert(specs[1].offset == ((specs[0].size + 0xFF) & ~0xFF) && specs[1].size == 0x1000);

    memset(region, 0xEE, sizeof(region));
    memset(region, 0x11, 104);
    memset(region + 104, 0x22, legacy);
    memset(region + 104 + legacy, 0x33, 504);
    memset(region + 104 + legacy + 504, 0x44, 16);
    Save_ConvertLegacyFirstSlot(region, &save.arrayHeaders[1], specs[0].size);
    for (i = 0; i < 104; i++) assert(region[i] == 0x11);
    for (i = 0; i < SAVE_MISC_LEGACY_SIZE; i++) assert(region[104 + i] == 0x22);
    for (i = SAVE_MISC_LEGACY_SIZE; i < grown; i++) assert(region[104 + i] == 0);
    for (i = 0; i < 504; i++) assert(region[104 + grown + i] == 0x33);
    for (i = 0; i < 16; i++) assert(region[104 + grown + 504 + i] == 0x44);
    puts("PASS: the old layout's slots are found, and its blocks moved to where they are now.");
    return 0;
}
"""


def struct_source(header, name):
    text = (ROOT / header).read_text()
    body = text[text.index(f"struct {name} {{"):]
    return body[:body.index("};") + 2]


class LegacySaveTests(unittest.TestCase):
    def test_the_old_layout_is_read_into_the_new(self):
        source = (ROOT / "src/save.c").read_text()
        misc_header = (ROOT / "include/save_misc_data.h").read_text()
        legacy = re.search(r"#define SAVE_MISC_LEGACY_SIZE (\w+)", misc_header).group(1)
        # the misc block's size with its expansion: HeartGold's, four Pokemon, four flags
        size = f"({legacy} + 4 * 0xEC + 4)"
        structs = "\n".join(struct_source("include/save.h", name) for name in ("SaveArrayHeader", "SaveSlotSpec"))
        native = "\n".join(function(source, name) for name in ("Save_GetLegacySlotSpecs", "Save_ConvertLegacyFirstSlot"))
        program = (NATIVE.replace("@NATIVE@", native).replace("@STRUCTS@", structs).replace("@LEGACY@", legacy)
                   .replace("@SIZE@", size).replace("@MISC@", "1"))
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

    def test_the_expansion_starts_where_heartgold_s_block_ended(self):
        header = (ROOT / "include/save_misc_data.h").read_text()
        self.assertIn("#define SAVE_MISC_LEGACY_SIZE 0x2E0", header)
        self.assertIn("offsetof(SAVE_MISC_DATA, storedMons) == SAVE_MISC_LEGACY_SIZE", (ROOT / "src/save_misc.c").read_text())


if __name__ == "__main__":
    unittest.main()
