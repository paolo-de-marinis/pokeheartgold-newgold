#!/usr/bin/env python3
"""Run the battle video's load check, playback move check and header getter.

A saved video is checked when it is loaded: sub_0203018C (src/unk_0203018C.c)
rejects it as corrupted when a recorded Pokemon's species, held item or move
is past the last one the game knows. During playback, ov12_0225E4EC
(src/battle/overlay_12_0225E4EC.c) ends the video when the move in the
recorded slot is past the last move. Both had retail's last species, item and
move, so a video with Lillipup, a Linking Cord or Baby-Doll Eyes in it did not
load. The video screens (overlay 40) read each recorded species through
sub_0203088C (src/unk_0203088C.c), which showed an empty slot for anything past
Arceus. They are extracted and run with the save and the battle stubbed.
"""

import re
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

COMMON = r'''
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MAX_MON_MOVES 4
@DEFINES@
'''

LOAD = COMMON + r'''
typedef struct SaveData SaveData;
u16 SaveArray_CalcCRC16(SaveData *save, const void *data, u32 size) { return 0; }
@MON@
@NATIVE@

static u8 video[0x1D50];

static RecordedParty *party(int i) {
    return (RecordedParty *)(video + 0xE8 + 0x1150 + i * sizeof(RecordedParty));
}

static BOOL check(u16 species, u16 item, u16 move) {
    party(3)->mons[5].species = species;
    party(3)->mons[5].heldItem = item;
    party(3)->mons[5].moves[3] = move;
    return sub_0203018C(NULL, video);
}

int main(void) {
    *(u16 *)(video + 0xE8 + 0x1C62) = 0xE281;
    *(u16 *)(video + 0x84 + 0x48) = 0xE281;
    assert(sizeof(RecordedParty) == 0x2A4);

    assert(check(SPECIES_LILLIPUP, ITEM_LINKING_CORD, MOVE_BABY_DOLL_EYES));
    assert(check(NUM_SPECIES, ITEM_MAX, NUM_MOVES_TOTAL));
    assert(!check(NUM_SPECIES + 1, ITEM_NONE, MOVE_NONE));
    assert(!check(SPECIES_NONE, ITEM_MAX + 1, MOVE_NONE));
    assert(!check(SPECIES_NONE, ITEM_NONE, NUM_MOVES_TOTAL + 1));
    return 0;
}
'''

PLAYBACK = COMMON + r'''
typedef struct BattleSystem { int unused; } BattleSystem;
typedef struct BattleContext BattleContext;
typedef struct SysTask SysTask;
#define BMON_DATA_MOVE1 @MOVE1@
static u8 sInput;
static u16 sMove;
static int sExits;
BOOL ov12_0223BE0C(BattleSystem *battleSystem, int battlerId, u8 *data) { *data = sInput; return FALSE; }
BattleContext *BattleSystem_GetBattleContext(BattleSystem *battleSystem) { return NULL; }
int GetBattlerVar(BattleContext *ctx, int battlerId, u32 varId, void *data) {
    assert(varId == BMON_DATA_MOVE1 + sInput - 1);
    return sMove;
}
void ov12_02261EB8(BattleSystem *battleSystem) { sExits++; }
void ov12_02261ED4(BattleSystem *battleSystem) { }
void ov12_02262FE0(BattleSystem *battleSystem, int battlerId, int input) { }
void ov12_0226430C(BattleSystem *battleSystem, int battlerId, int a2) { }
void Heap_Free(void *data) { free(data); }
void SysTask_Destroy(SysTask *task) { }
@INPUT@
@NATIVE@

static int play(u8 input, u16 move) {
    static BattleSystem battleSystem;
    RecordedMoveInput *data = calloc(1, sizeof(*data));
    data->battleSystem = &battleSystem;
    sInput = input;
    sMove = move;
    sExits = 0;
    ov12_0225E4EC(NULL, data);
    return sExits;
}

int main(void) {
    assert(play(1, MOVE_BABY_DOLL_EYES) == 0);
    assert(play(4, NUM_MOVES_TOTAL) == 0);
    assert(play(2, NUM_MOVES_TOTAL + 1) == 1);
    assert(play(2, MOVE_NONE) == 1);
    assert(play(5, MOVE_POUND) == 1);
    return 0;
}
'''


HEADER = COMMON + r'''
typedef uint64_t u64;
#define GF_ASSERT(x) assert(x)
@NATIVE@

int main(void) {
    static u8 header[0x64];
    u16 *species = (u16 *)header;

    species[0] = SPECIES_LILLIPUP;
    species[11] = NUM_SPECIES;
    species[5] = NUM_SPECIES + 1;
    assert(sub_0203088C(header, 0, 0) == SPECIES_LILLIPUP);
    assert(sub_0203088C(header, 0, 11) == NUM_SPECIES);
    assert(sub_0203088C(header, 0, 5) == 0);
    return 0;
}
'''


def between(text, start, end):
    text = text[text.index(start):]
    return text[:text.index(end) + len(end)]


def defines(source):
    return "\n".join(line for line in source.splitlines() if line.startswith("#define "))


class BattleVideoTests(unittest.TestCase):
    def test_a_video_with_added_content_loads(self):
        source = (ROOT / "src/unk_0203018C.c").read_text()
        mon = between((ROOT / "include/pokemon_types_def.h").read_text(),
                      "struct UnkPokemonStruct_02072A98 {", "};")
        global_h = (ROOT / "include/constants/global.h").read_text()
        names = "\n".join(re.findall(r"^#define (?:PARTY_SIZE|POKEMON_NAME_LENGTH|PLAYER_NAME_LENGTH) .*$", global_h, re.M))
        program = (LOAD.replace("@DEFINES@", names + "\n" + defines(source))
                   .replace("@MON@", mon + "\n" + between(source, "typedef struct RecordedParty {", "} RecordedParty;"))
                   .replace("@NATIVE@", function(source, "sub_0203018C")))
        run(program, "newgold-battle-video-")

    def test_playback_keeps_an_added_move(self):
        source = (ROOT / "src/battle/overlay_12_0225E4EC.c").read_text()
        move1 = re.search(r"#define BMON_DATA_MOVE1\s+(\d+)", (ROOT / "include/constants/battle.h").read_text()).group(1)
        program = (PLAYBACK.replace("@DEFINES@", defines(source)).replace("@MOVE1@", move1)
                   .replace("@INPUT@", between(source, "typedef struct RecordedMoveInput {", "} RecordedMoveInput;"))
                   .replace("@NATIVE@", function(source, "ov12_0225E4EC")))
        run(program, "newgold-battle-video-")

    def test_the_video_screens_see_an_added_species(self):
        source = (ROOT / "src/unk_0203088C.c").read_text()
        program = HEADER.replace("@DEFINES@", "").replace("@NATIVE@", function(source, "sub_0203088C"))
        run(program, "newgold-battle-video-")


if __name__ == "__main__":
    unittest.main()
