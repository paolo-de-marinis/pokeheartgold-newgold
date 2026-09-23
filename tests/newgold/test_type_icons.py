#!/usr/bin/env python3
"""Check that every type has an icon, and that the contest block moved with it.

sub_02077678 is asked for an icon by an index that is a type for every caller
but one: the move relearner asks it for a contest condition, and does that by
adding the number of types to the condition. So the table is types first and
the five conditions after, and the two have to agree on where the boundary is
or a Fairy move shows the word COOL.

The Fairy icon itself is a member added to the end of the battle graphics
archive, which is why its file id is past every id the game shipped with.
"""

import re
import struct
import unittest

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

SOURCE = ROOT / "src/unk_02077678.c"
RELEARNER = ROOT / "src/overlay_68_021E7028.c"
TYPES = ROOT / "include/constants/pokemon.h"
ARCHIVE = ROOT / "files/a/0/0/8"
CONTEST_CONDITIONS = 5


def table(name, pattern=r"0x[0-9A-Fa-f]+|\d+"):
    body = re.search(rf"{name}\[\] = \{{(.*?)\n\}};", SOURCE.read_text(), re.S).group(1)
    body = re.sub(r"//[^\n]*", "", body)
    return [int(v, 0) for v in re.findall(pattern, body)]


def number_of_types():
    return int(re.search(r"#define NUMBER_OF_MON_TYPES\s+(\d+)", TYPES.read_text()).group(1))


def archive_members():
    data = ARCHIVE.read_bytes()
    assert data[:4] == b"NARC"
    # FATB follows the 16-byte NARC header: its own 8-byte header, then the count.
    return struct.unpack_from("<I", data, 0x18)[0]


SECOND_TYPE = r"""
#include <assert.h>
#include <stdio.h>
#include "constants/pokemon.h"
#include "constants/species.h"
typedef unsigned char u8; typedef unsigned short u16; typedef unsigned int u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } ManagedSprite, Pokedex;
static int drawn[64];
static int shown[64];
static void ManagedSprite_SetDrawFlag(ManagedSprite *sprite, int flag) { drawn[sprite->unused] = flag; }
/* the PC */
typedef struct { ManagedSprite *sprites[15]; } PCBoxAppGraphics;
typedef struct { u8 type1, type2; u8 isEgg; } PCBoxDisplayMon;
static void ov14_021F3D0C(PCBoxAppGraphics *g, int type, int idx, int unused) { shown[idx] = type; }
/* the Dex */
typedef struct { Pokedex *pokedex; } PokedexArgs;
typedef struct { u8 unk_0; u8 unk_2; } PokedexEntry;
typedef struct {
    int unk_185C; u8 unk_185F_4; PokedexEntry unk_1030[1];
    ManagedSprite *unk_0670[64]; PokedexArgs *args;
} PokedexAppData;
static u16 gTypes[2];
static int Pokedex_GetSeenFormByIdx(Pokedex *pokedex, u32 species, int idx) { return 0; }
static u16 GetMonBaseStat_HandleAlternateForm(u32 species, int form, int stat) { return gTypes[stat == BASE_TYPE2]; }
static void ov18_021F21FC(PokedexAppData *app, int spriteIdx, u16 type) { shown[spriteIdx] = type; }
@NATIVE@
int main(void) {
    static ManagedSprite pool[64];
    PCBoxAppGraphics graphics;
    for (int i = 0; i < 64; i++) {
        pool[i].unused = i;
    }
    for (int i = 0; i < 15; i++) {
        graphics.sprites[i] = &pool[i];
    }
    /* Litleo, Fire and Normal: two icons; Charmander, Fire alone: one */
    PCBoxDisplayMon litleo = { TYPE_FIRE, TYPE_NORMAL, 0 }, charmander = { TYPE_FIRE, TYPE_FIRE, 0 };
    ov14_021F3D70(&graphics, &litleo);
    assert(drawn[13] && drawn[14] && shown[14] == TYPE_NORMAL);
    ov14_021F3D70(&graphics, &charmander);
    assert(drawn[13] && !drawn[14]);

    Pokedex dex;
    PokedexArgs args = { &dex };
    PokedexAppData app = { .unk_185C = 2, .args = &args };
    for (int i = 0; i < 64; i++) {
        app.unk_0670[i] = &pool[i];
    }
    gTypes[0] = TYPE_FIRE, gTypes[1] = TYPE_NORMAL;
    ov18_021F209C(&app, SPECIES_LITLEO, 0, 14);   /* draws the pair at 16, hides 14 */
    assert(drawn[16] && drawn[17] && shown[17] == TYPE_NORMAL);
    gTypes[1] = TYPE_FIRE;
    ov18_021F209C(&app, SPECIES_LITLEO, 0, 14);   /* then the pair at 14 */
    assert(drawn[14] && !drawn[15]);
    printf("PASS: the PC and the Dex show Litleo's Normal second type, and one icon for a single type.\n");
    return 0;
}
"""


class TypeIconTests(unittest.TestCase):
    def test_the_table_holds_every_type_and_the_five_conditions(self):
        want = number_of_types() + CONTEST_CONDITIONS
        self.assertEqual(len(table("sTypeIconFiles")), want)
        self.assertEqual(len(table("sTypeIconPalettes")), want)

    def test_the_relearner_adds_the_same_boundary(self):
        self.assertIn("GetMoveAttr(move, MOVEATTR_CONTEST_TYPE) + NUMBER_OF_MON_TYPES", RELEARNER.read_text(),
                      "the move relearner does not start the contest icons at NUMBER_OF_MON_TYPES")

    def test_the_fairy_icon_is_in_the_archive(self):
        fairy = table("sTypeIconFiles")[int(re.search(r"#define TYPE_FAIRY\s+(\d+)",
                                                      TYPES.read_text()).group(1))]
        self.assertLess(fairy, archive_members(),
                        f"the Fairy icon is file {fairy} and the archive holds "
                        f"{archive_members()} members")

    def test_no_two_types_share_an_icon(self):
        files = table("sTypeIconFiles")[:number_of_types()]
        self.assertEqual(len(set(files)), len(files))


    def test_a_normal_second_type_has_its_icon(self):
        """Retail's Dex and PC showed no second icon for a Normal second type,
        which no species of theirs had; Litleo and Pyroar are Fire and
        Normal. The reference shows it (bytereplacement, "normal as a second
        type should show up in the dex/pc")."""
        pc = c_function((ROOT / "src/overlay_14_021F3D70.c").read_text(), "ov14_021F3D70")
        dex = c_function((ROOT / "src/application/pokedex/ov18_021F209C.c").read_text(), "ov18_021F209C")
        run_native(self, SECOND_TYPE.replace("@NATIVE@", pc + "\n" + dex), "newgold-second-type-")


if __name__ == "__main__":
    unittest.main()
