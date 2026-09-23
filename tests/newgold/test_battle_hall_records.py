#!/usr/bin/env python3
"""Run the Battle Hall's per-species streak records with host sanitizers.

The Hall's extra save chunk (struct UnkStruct_02030A98, include/unk_02030A98.h)
keeps, for each of its three modes, one streak per species, retail's 495 of
them. sub_020312E0 reads a record, sub_0203132C writes one and sub_02031378
keeps the better of the two (src/unk_020312E0.c). A species past the tables
went past them: in the first two modes into the next table, in the last past
the end of the chunk. The three are extracted and run on a chunk of exactly
the struct's size, so AddressSanitizer sees any write past it.
"""

import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "constants/species.h"
typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL;
#define FALSE 0
#define GF_ASSERT(x) assert(x)
typedef struct SaveData SaveData;
BOOL Save_CheckExtraChunksExist(SaveData *saveData) { return 1; }
@STRUCT@
@NATIVE@

int main(void) {
    struct UnkStruct_02030A98 *hall = malloc(sizeof(*hall));
    memset(hall, 0, sizeof(*hall));
    u32 *chunk = (u32 *)hall;

    // A retail species keeps its streak in each mode.
    for (u32 mode = 0; mode < 3; mode++) {
        sub_02031378(NULL, chunk, mode, SPECIES_ARCEUS, 7 + mode);
        assert(sub_020312E0(NULL, chunk, mode, SPECIES_ARCEUS) == 7 + mode);
    }

    // An added species has no record, and writing one touches nothing.
    struct UnkStruct_02030A98 before = *hall;
    for (u32 mode = 0; mode < 3; mode++) {
        sub_02031378(NULL, chunk, mode, SPECIES_LILLIPUP, 9);
        sub_0203132C(chunk, mode, NUM_SPECIES, 9);
        assert(sub_020312E0(NULL, chunk, mode, SPECIES_LILLIPUP) == 0);
    }
    assert(memcmp(&before, hall, sizeof(before)) == 0);
    free(hall);
    return 0;
}
'''


class BattleHallRecordTests(unittest.TestCase):
    def test_an_added_species_writes_no_record(self):
        header = (ROOT / "include/unk_02030A98.h").read_text()
        struct = header[header.index("#define BATTLE_HALL_SPECIES_RECORDS"):]
        struct = struct[:struct.index("}; // size = 0xBA0") + 2]
        source = (ROOT / "src/unk_020312E0.c").read_text()
        native = "\n".join(line for line in source.splitlines() if line.startswith("#define BATTLE_HALL_MAX_STREAK"))
        native += "\n" + "\n".join(function(source, name) for name in ("sub_020312E0", "sub_0203132C", "sub_02031378"))
        run(PROGRAM.replace("@STRUCT@", struct).replace("@NATIVE@", native), "newgold-battle-hall-")


if __name__ == "__main__":
    unittest.main()
