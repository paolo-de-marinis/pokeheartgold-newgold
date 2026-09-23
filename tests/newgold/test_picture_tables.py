#!/usr/bin/env python3
"""Check the species-indexed picture tables against the archives they read.

Retail's picture tables stop at Arceus, and the functions below index them
by species with no bound of their own, so each archive has to reach the last
species or the function has to send a species past it somewhere that does.

Goldenrod Tunnel's dress-up (overlay 41) draws the chosen Pokemon through
DP_GetMonSpriteCharAndPlttNarcIdsEx and sizes it with
GetMonPicHeightBySpeciesGenderForm_PBR. hg-engine serves the main picture
archive in pbr/pokegra's place; here the default case asks for that archive
by name, and a species past the PBR heights takes the main height table,
which is the one its picture matches. a/1/8/0 is carried whole from the
reference, and its six readers share one bound.
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
import import_sprite_offsets  # noqa: E402

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


RECORDS = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int8_t s8;
typedef struct NARC NARC;
typedef struct { u8 bytes[4]; } PokepicAnimScript;
struct UnkStruct_02072914_sub { u8 unk_0, unk_1, unk_2; PokepicAnimScript unk_3[10]; };
struct UnkStruct_02072914 { struct UnkStruct_02072914_sub unk0[2]; s8 unk_56; s8 unk_57; u8 unk_58; };
struct UnkStruct_0207294C { u16 unk_0; u16 unk_2; u8 unk_4; };
_Static_assert(sizeof(struct UnkStruct_02072914) == 89, "a/1/8/0 records are 89 bytes");

static u32 memberSize, lastPos;
static void NARC_ReadFromMember(NARC *narc, u32 file, u32 pos, u32 size, void *dest) {
    (void)narc;
    assert(file == 0 && pos + size <= memberSize);
    lastPos = pos;
    for (u32 i = 0; i < size; i++) ((u8 *)dest)[i] = 0;
}
static void MI_CpuCopy8(const void *src, void *dest, u32 size) { (void)src; (void)dest; (void)size; }
static void sub_02016F40(void *a, void *b, struct UnkStruct_0207294C *c, u8 d) { (void)a; (void)b; (void)c; (void)d; }
@NATIVE@

// Every reader, for one species, must read that species' record.
static void readAll(u16 species, u32 want) {
    PokepicAnimScript script[10];
    u8 u; s8 s;
    NARC_ReadPokepicAnimScript(0, script, species, 0); assert(lastPos == want);
    sub_0207294C(0, 0, 0, species, 2, 0, 0); assert(lastPos == want);
    sub_020729A4(0, &u, species, 1); assert(lastPos == want);
    sub_020729D8(0, &s, species, 0); assert(lastPos == want);
    sub_020729FC(0, &s, species, 0); assert(lastPos == want);
    sub_02072A20(0, &u, species, 0); assert(lastPos == want);
}

int main(void) {
    memberSize = @MEMBER@;
    for (u16 species = 0; species <= NUM_SPECIES; species++) {
        readAll(species, species * 89u);
    }
    // A number past the table takes the first record, as retail's clamp did.
    readAll(NUM_SPECIES + 1, 0);
    printf("PASS: the six readers take each of %d species' own record.\n", NUM_SPECIES + 1);
    return 0;
}
"""

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


    def test_the_picture_records_reach_every_species(self):
        """a/1/8/0 member 0 is an 89-byte record a species: cry delay,
        animation, Y offset and shadow. Retail's stopped at Arceus, and six
        readers index it by species, so every added species read its record
        out of whatever followed the member. Each record is now the
        reference's for that species."""
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        species = import_sprite_offsets.port_species()
        self.assertEqual(len(member), len(species) * import_sprite_offsets.RECORD)
        if not import_sprite_offsets.REFERENCE.exists():
            self.skipTest("no reference checkout")
        self.assertEqual(member, b"".join(import_sprite_offsets.records(import_sprite_offsets.REFERENCE)))

    def test_every_picture_record_reader_reads_its_species(self):
        """a/1/8/0 member 0 now has a record for every species; the six
        functions that read it by species all take that record."""
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        source = (ROOT / "src/pokemon.c").read_text()
        native = "\n".join(function(source, name) for name in (
            "PokepicAnimSpecies", "NARC_ReadPokepicAnimScript", "sub_0207294C", "sub_020729A4",
            "sub_020729D8", "sub_020729FC", "sub_02072A20"))
        run_native(self, RECORDS.replace("@MEMBER@", str(len(member))).replace("@NATIVE@", native), "newgold-records-")

if __name__ == "__main__":
    unittest.main()
