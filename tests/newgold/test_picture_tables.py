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

import json
import os
from pathlib import Path
import re
import statistics
import struct
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
            "sub_02070438", "sub_02070560", "DP_GetMonSpriteCharAndPlttNarcIdsEx", "PicSpecies_FemaleForm",
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

    def test_no_front_picture_sinks_deeper_than_retail_lets_one(self):
        """ov12 draws a front picture at its height (height.narc) less the Y
        offset of its record here, so its lowest row sits height - offset -
        clearance under the ground line. Retail's deepest is Metagross's, 12.
        The reference's offsets for the added species count the whole
        distance, from heights of 0; on this game's heights, the clearance
        under each picture, they counted it twice, and a Joltik sank 23 rows,
        behind the player's HP box."""
        import heights
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        table = read_narc(heights.ARCHIVE.read_bytes())[0]
        offset = lambda species: struct.unpack_from("<b", member, species * import_sprite_offsets.RECORD
                                                    + import_sprite_offsets.Y_OFFSET)[0]  # noqa: E731
        # 494..507, the eggs and retail's form rows, are drawn from otherpoke.
        others = range(import_sprite_offsets.RETAIL, heights.PRET_SPECIES)
        retail = max(-offset(species) for species in range(1, others.start))
        sunk = {}
        for index, entry in enumerate(table):
            species, slot = divmod(index, len(heights.SLOTS))
            gender, picture = heights.SLOTS[slot]
            if picture != "front.png" or not entry or species in others:
                continue
            depth = entry[0] - offset(species) - heights.height_of(heights.SPRITES / f"{species:04d}" / gender / picture)[0]
            if depth > retail:
                sunk[f"{species} {gender}"] = depth
        self.assertEqual(retail, 12)
        self.assertEqual(sunk, {})

    def test_added_fronts_stand_as_their_kind_does(self):
        """konefr, through Paolo: "trubbish offset sprite (forse tutti
        nuovi?)". A front's lowest row stands its Y offset over the ground
        line, retail's grounded fronts from 12 rows under it (Metagross) to
        3 over it (Pikachu, and Trubbish with the same small shadow).
        Trubbish had the reference's -20 until 6c562886d, under the player's
        HP box. The 120 added species that draw the reference's placeholder,
        Bulbasaur's front, floated 21 or 22 rows over the line; the reference
        drew some grounded species in the air (a Steenee 11 rows up), and
        gave forms their base's record for pictures drawn otherwise in their
        frames (a Sunny Castform 8 rows under Castform)."""
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        names = import_sprite_offsets.port_species()
        number = {name: n for n, name in enumerate(names)}
        tail = lambda n: member[n * import_sprite_offsets.RECORD + import_sprite_offsets.Y_OFFSET:  # noqa: E731
                                (n + 1) * import_sprite_offsets.RECORD]
        offset = lambda name: struct.unpack("<b", tail(number[f"SPECIES_{name}"])[:1])[0]  # noqa: E731
        bulbasaur = import_sprite_offsets.front_picture(number["SPECIES_BULBASAUR"])
        placeholders = [n for n in range(import_sprite_offsets.FIRST_ADDED, len(names))
                        if import_sprite_offsets.front_picture(n) == bulbasaur]
        self.assertTrue(placeholders)
        self.assertEqual({names[n]: tail(n) for n in placeholders if tail(n) != tail(number["SPECIES_BULBASAUR"])}, {})
        grounded = ("TRUBBISH", "TIRTOUGA", "CLAWITZER", "STEENEE", "EISCUE", "ARCTOVISH", "REVAVROOM", "ORTHWORM",
                    "IRON_TREADS", "ENAMORUS_THERIAN", "TERAPAGOS_TERASTAL", "TERAPAGOS_STELLAR", "TAUROS_COMBAT",
                    "GOURGEIST", "MIRAIDON", "MIRAIDON_LOW_POWER_MODE", "MIRAIDON_DRIVE_MODE", "LEAVANNY", "FERROSEED",
                    "FERROTHORN", "FLITTLE", "POLTCHAGEIST", "POLTCHAGEIST_MASTERPIECE")
        self.assertEqual({name: offset(name) for name in grounded if not -12 <= offset(name) <= 3}, {})
        self.assertEqual({offset(f"CASTFORM_{form}") for form in ("SUNNY", "RAINY", "SNOWY")}, {offset("CASTFORM")})

    def test_added_floaters_float_as_retail_s_do(self):
        """Paolo, 2026-10-08: the ones that float a little suspended, so they
        are seen, after checking which really float. The reference drew
        floaters as high as 29 rows (Woobat), Elgyem, Pumpkaboo and Milcery
        17 to 19; they float in the latest games' models, and Elgyem, Tympole
        and Cofagrigus in Black and White, so they stand where retail's
        middle floater does: the median offset of its fronts of species with
        Levitate, 12 (Bronzor 10, Gastly 21)."""
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        names = import_sprite_offsets.port_species()
        number = {name: n for n, name in enumerate(names)}
        offset = lambda n: struct.unpack_from("<b", member, n * import_sprite_offsets.RECORD  # noqa: E731
                                              + import_sprite_offsets.Y_OFFSET)[0]
        personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        levitate = sorted(offset(n) for n in range(1, import_sprite_offsets.RETAIL)
                          if "ABILITY_LEVITATE" in personal[n]["abilities"] + [personal[n]["hiddenAbility"]])
        self.assertEqual((len(levitate), statistics.median(levitate)), (26, import_sprite_offsets.FLOAT))
        floating = ("ELGYEM", "BEHEEYEM", "TYMPOLE", "COFAGRIGUS", "PUMPKABOO", "PUMPKABOO_SMALL", "PUMPKABOO_LARGE",
                    "PUMPKABOO_SUPER", "MILCERY", "VAROOM", "SOLOSIS", "SINISTEA", "SINISTEA_ANTIQUE", "WOOBAT")
        self.assertEqual({name for name in floating if offset(number[f"SPECIES_{name}"]) != 12}, set())

    def test_records_never_placed_take_their_picture_s_shadow(self):
        """The reference never placed the records of 46 added species with
        pictures of their own: each kept a medium shadow nobody chose. Each
        is sized by its picture now, as retail's are by size: Wishiwashi,
        Dreepy and Sinistea small, Kingambit, Obstagoon and Vivillon large,
        Vivillon's patterns and Flabebe's flowers as their species."""
        member = read_narc((ROOT / "files/a/1/8/0").read_bytes())[0][0]
        names = import_sprite_offsets.port_species()
        number = {name[len("SPECIES_"):]: n for n, name in enumerate(names)}
        shadow = lambda name: member[(number[name] + 1) * import_sprite_offsets.RECORD - 1]  # noqa: E731
        for name, size in (("WISHIWASHI", 1), ("DREEPY", 1), ("SINISTEA", 1), ("FLABEBE_BLUE_FLOWER", 1),
                           ("KINGAMBIT", 3), ("OBSTAGOON", 3), ("VIVILLON", 3), ("VIVILLON_FANCY", 3),
                           ("GOURGEIST", 2)):
            self.assertEqual(shadow(name), size, name)
        # The cuts give retail's own sizes for most of its fronts with a shadow.
        agree = [shadow(names[n][len("SPECIES_"):]) == import_sprite_offsets.shadow_size(
                 import_sprite_offsets.front_picture(n)) for n in range(1, import_sprite_offsets.RETAIL)
                 if shadow(names[n][len("SPECIES_"):])]
        self.assertGreater(sum(agree) / len(agree), 0.7)

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
