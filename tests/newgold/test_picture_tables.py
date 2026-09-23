#!/usr/bin/env python3
"""Check the species-indexed picture tables against the archives they read.

Goldenrod Tunnel's dress-up (overlay 41) draws the chosen Pokemon through
DP_GetMonSpriteCharAndPlttNarcIdsEx and sizes it with
GetMonPicHeightBySpeciesGenderForm_PBR. The other game's archives stop at
Arceus, so every added species read its picture and its height past their
ends. hg-engine serves the main picture archive in pbr/pokegra's place; here
the default case asks for that archive by name, and a species past the PBR
heights takes the main height table, which is the one its picture matches.
"""

import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest

from test_level_cap import ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
from wotbl import read_narc  # noqa: E402

ARCHIVES = {
    "NARC_pbr_pokegra": "files/pbr/pokegra.narc",
    "NARC_pbr_otherpoke": "files/pbr/otherpoke.narc",
    "NARC_pbr_dp_height": "files/pbr/dp_height.narc",
    "NARC_pbr_dp_height_o": "files/pbr/dp_height_o.narc",
    "NARC_poketool_pokegra_pokegra": "files/poketool/pokegra/pokegra.narc",
    "NARC_poketool_pokegra_otherpoke": "files/poketool/pokegra/otherpoke.narc",
    "NARC_poketool_pokegra_height": "files/poketool/pokegra/height.narc",
    "NARC_poketool_pokegra_height_o": "files/poketool/pokegra/height_o.narc",
}

DRESS_UP = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int NarcId;
#define FALSE 0
@ENUM@
typedef struct PokepicTemplate {
    u16 narcID, charDataID, palDataID, species;
    u8 isAnimated;
    u32 personality;
} PokepicTemplate;

static int members[256];
static NarcId lastNarc;
static s32 lastFile;
static void ReadWholeNarcMemberByIdPair(void *dest, NarcId narc, s32 file) {
    assert(file >= 0 && file < members[narc]);
    lastNarc = narc;
    lastFile = file;
    *(u8 *)dest = 0;
}
u8 GetMonPicHeightBySpeciesGenderForm(u16 species, u8 gender, u8 whichFacing, u8 form, u32 pid);
@NATIVE@

int main(void) {
@COUNTS@
    for (u16 species = SPECIES_BULBASAUR; species <= NUM_SPECIES; species++) {
        for (u8 gender = MON_MALE; gender <= MON_FEMALE; gender++) {
            for (u8 facing = MON_PIC_FACING_BACK; facing <= MON_PIC_FACING_FRONT; facing += 2) {
                for (u8 shiny = 0; shiny < 2; shiny++) {
                    PokepicTemplate pic;
                    DP_GetMonSpriteCharAndPlttNarcIdsEx(&pic, species, gender, facing, shiny, 0, 0);
                    assert(pic.charDataID < members[pic.narcID]);
                    assert(pic.palDataID < members[pic.narcID]);
                }
                GetMonPicHeightBySpeciesGenderForm_PBR(species, gender, facing, 0, 0);
            }
        }
    }
    // The eggs keep their own records in the other game's height archive.
    GetMonPicHeightBySpeciesGenderForm_PBR(SPECIES_EGG, MON_MALE, MON_PIC_FACING_FRONT, EGG_MANAPHY, 0);
    assert(lastNarc == NARC_pbr_dp_height_o && lastFile == 0x84 + EGG_MANAPHY);
    printf("PASS: every species' dress-up picture and height is inside its archive.\n");
    return 0;
}
"""


def run_native(test, program, prefix):
    with tempfile.TemporaryDirectory(prefix=prefix) as temp:
        c, exe = Path(temp) / "check.c", Path(temp) / "check"
        c.write_text(program)
        result = subprocess.run(["cc", "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-Wno-unknown-pragmas",
                                 "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(exe)], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
        test.assertEqual(result.returncode, 0, result.stderr)
        print(result.stdout.strip())


class PictureTableTests(unittest.TestCase):
    def test_the_dress_up_reads_inside_its_archives(self):
        """Every species' picture and height, both genders, both facings."""
        if not all((ROOT / path).exists() for path in ARCHIVES.values()):
            self.skipTest("the picture archives have not been built")
        ids = dict(re.findall(r"^\s+(NARC_\w+) = (\d+),", (ROOT / "include/filesystem_files_def.h").read_text(), re.M))
        enum = "enum { " + ", ".join(f"{name} = {ids[name]}" for name in ARCHIVES) + " };"
        counts = "\n".join(f"    members[{name}] = {len(read_narc((ROOT / path).read_bytes())[0])};"
                           for name, path in ARCHIVES.items())
        source = (ROOT / "src/pokemon.c").read_text()
        native = "\n".join(function(source, name) for name in (
            "sub_02070438", "sub_02070560", "DP_GetMonSpriteCharAndPlttNarcIdsEx",
            "GetMonPicHeightBySpeciesGenderForm", "GetMonPicHeightBySpeciesGenderForm_PBR"))
        run_native(self, DRESS_UP.replace("@ENUM@", enum).replace("@COUNTS@", counts).replace("@NATIVE@", native),
                   "newgold-dress-up-")


if __name__ == "__main__":
    unittest.main()
