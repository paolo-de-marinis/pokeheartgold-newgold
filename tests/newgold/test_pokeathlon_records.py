#!/usr/bin/env python3
"""Check what a Pokeathlon course record keeps of the team that set it.

The record (Pokeathlon_CourseRecord, in the save) keeps each Pokemon's
species in nine bits, and the course-record screen asserts it is at most
493. ov96_021E786C, which writes it, is compiled on the host with the
structures as the headers and the file declare them.
"""

import re
import unittest

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

PROGRAM = r"""
#include <assert.h>
#include <stdio.h>
#include <string.h>
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
#define MAX_SPECIES 493
#define SPECIES_NONE 0
@RECORD@
typedef struct PokeathlonSave { Pokeathlon_CourseRecord courseRecords[5]; } PokeathlonSave;
typedef struct PokeathlonCourseArgs { u8 filler[0xC]; u8 course; } PokeathlonCourseArgs;
typedef struct PokeathlonCourseData { u8 filler[0x1F8]; PokeathlonCourseArgs *args; u8 rest[0xB00]; } PokeathlonCourseData;
@TYPES@
static u8 sEntrants[0x7C];
int ov96_021E5F24(PokeathlonCourseData *data) { (void)data; return 0; }
u8 *PokeathlonCourse_GetParticipantUnk04(PokeathlonCourseData *data, int index) { (void)data; (void)index; return sEntrants + 4; }
/* the form table's answer for the two species used below */
u16 SpeciesToDexSpecies(u16 species) { return species == 1042 ? 3 : species; }
@WRITER@
int main(void) {
    static PokeathlonCourseData data;
    static PokeathlonSave save;
    PokeathlonCourseArgs args = { { 0 }, 2 };
    data.args = &args;
    ((PokeathlonCourseResult *)&data)->total = 500;
    PokeathlonCourseMon *mons = (PokeathlonCourseMon *)(sEntrants + 4);
    mons[0].species = 386; mons[0].form = 2;   /* Deoxys Defense: kept, form and all */
    mons[1].species = 1042; mons[1].form = 1;  /* Mega Venusaur: Venusaur */
    mons[2].species = 700; mons[2].form = 3;   /* no retail base: none, not 188 */
    ov96_021E786C(&data, &save);
    Pokeathlon_CourseRecord *record = &save.courseRecords[2];
    assert(record->total == 500);
    assert(record->mons[0].species == 386 && record->mons[0].form == 2);
    assert(record->mons[1].species == 3 && record->mons[1].form == 0);
    assert(record->mons[2].species == 0 && record->mons[2].form == 0);
    for (int species = 494; species <= 1437; species++) {
        memset(&save, 0, sizeof(save));
        mons[0].species = species;
        ov96_021E786C(&data, &save);
        assert(save.courseRecords[2].mons[0].species <= MAX_SPECIES);
    }
    printf("PASS: a course record keeps retail species, a form's base, and none past them.\n");
    return 0;
}
"""


class PokeathlonRecordTests(unittest.TestCase):
    def test_a_record_keeps_only_species_its_screen_can_print(self):
        header = (ROOT / "include/pokeathlon/pokeathlon_save.h").read_text()
        record = "\n".join(re.search(rf"typedef struct {name} \{{.*?\}} {name};", header, re.S).group(0)
                           for name in ("Pokeathlon_CourseRecordMon", "Pokeathlon_CourseRecord"))
        source = (ROOT / "src/pokeathlon/overlay_96_021E786C.c").read_text()
        types = "\n".join(re.search(rf"typedef struct {name} \{{.*?\}} {name};", source, re.S).group(0)
                          for name in ("PokeathlonCourseMon", "PokeathlonCourseResult"))
        program = PROGRAM.replace("@RECORD@", record).replace("@TYPES@", types)
        run_native(self, program.replace("@WRITER@", c_function(source, "ov96_021E786C")), "newgold-course-record-")


if __name__ == "__main__":
    unittest.main()
