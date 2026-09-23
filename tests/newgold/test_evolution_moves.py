#!/usr/bin/env python3
"""A Pokemon learns its evolution moves when it evolves.

A learnset entry at level 0 is a move learned on evolution: the reference's
MonTryLearnMoveOnLevelUp offers those first when the evolution scene calls it,
and passes over a later entry that repeats one (src/pokemon.c:1979-2017 at
d0380a487). Here the scene calls MonTryLearnMoveOnEvolution; this compiles that
function out of src/pokemon.c on the host and walks it the way the scene's
learn state does, and checks that the scene is the one calling it.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "constants/heap.h"
#include "constants/pokemon.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
@MACROS@

typedef struct { u16 species; u8 level; u16 moves[4]; } Pokemon;
static u32 table[LEVEL_UP_LEARNSET_SIZE];
static int allocations;

static u32 GetMonData(Pokemon *mon, int field, void *dest) {
    assert(dest == NULL);
    switch (field) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_FORM: return 0;
    case MON_DATA_LEVEL: return mon->level;
    default: assert(0); return 0;
    }
}
static void *Heap_Alloc(enum HeapID heap, u32 size) {
    assert(heap == HEAP_ID_DEFAULT && size == sizeof(table));
    allocations++;
    return malloc(size);
}
static void Heap_Free(void *p) { allocations--; free(p); }
static void LoadLevelUpLearnset_HandleAlternateForm(int species, int form, u32 *dest) {
    (void)species; (void)form;
    memcpy(dest, table, sizeof(table));
}
static u32 TryAppendMonMove(Pokemon *mon, u16 move) {
    for (int i = 0; i < 4; i++) {
        if (mon->moves[i] == move) return MOVE_APPEND_KNOWN;
        if (mon->moves[i] == 0) { mon->moves[i] = move; return move; }
    }
    return MOVE_APPEND_FULL;
}

@FUNCTION@

#define E(level, move) (((u32)(level) << LEVEL_UP_LEARNSET_LEVEL_SHIFT) | (move))

// The scene's learn state: call until it returns 0, recording what it offers.
static int walk(Pokemon *mon, u16 *offered) {
    int index = 0, count = 0;
    u16 move;
    u32 result;
    while ((result = MonTryLearnMoveOnEvolution(mon, &index, &move)) != 0) {
        assert(result == move || result == MOVE_APPEND_FULL || result == MOVE_APPEND_KNOWN);
        offered[count++] = move;
        assert(count < LEVEL_UP_LEARNSET_SIZE);
    }
    assert(allocations == 0);
    return count;
}

int main(void) {
    u16 offered[LEVEL_UP_LEARNSET_SIZE];

    // Evolution moves first, then the level's; the level's repeat of an
    // evolution move is not offered again, the other level's moves never.
    u32 learnset[] = { E(0, 10), E(0, 11), E(1, 12), E(5, 13), E(7, 10), E(7, 14), E(9, 15) };
    memset(table, 0xFF, sizeof(table));
    memcpy(table, learnset, sizeof(learnset));
    table[7] = LEVEL_UP_LEARNSET_END;
    table[8] = E(7, 16); // past the end: never read
    Pokemon mon = { 1, 7, { 0 } };
    assert(walk(&mon, offered) == 3);
    assert(offered[0] == 10 && offered[1] == 11 && offered[2] == 14);
    assert(mon.moves[0] == 10 && mon.moves[1] == 11 && mon.moves[2] == 14);

    // A move declined for a full moveset is still not offered a second time.
    Pokemon full = { 1, 7, { 1, 2, 3, 4 } };
    assert(walk(&full, offered) == 3);
    assert(offered[0] == 10 && offered[1] == 11 && offered[2] == 14);

    // No evolution moves: the level's, as on a level-up.
    u32 plain[] = { E(1, 12), E(7, 13), E(7, 14), LEVEL_UP_LEARNSET_END };
    memcpy(table, plain, sizeof(plain));
    Pokemon other = { 1, 7, { 0 } };
    assert(walk(&other, offered) == 2);
    assert(offered[0] == 13 && offered[1] == 14);

    // A repeat right after the evolution moves is passed over too, and one
    // just before the end does not carry the search past it.
    u32 last[] = { E(0, 10), E(7, 10), E(5, 11), E(7, 10), LEVEL_UP_LEARNSET_END, E(7, 16) };
    memcpy(table, last, sizeof(last));
    Pokemon again = { 1, 7, { 1, 2, 3, 4 } };
    assert(walk(&again, offered) == 1 && offered[0] == 10);
    return 0;
}
"""


def run_check(source):
    header = read("include/pokemon.h")
    macros = "\n".join(re.findall(r"^#define (?:LEVEL_UP_LEARNSET_\w+|MOVE_APPEND_\w+)\b.*$", header, re.M))
    program = FIXTURE.replace("@MACROS@", macros).replace(
        "@FUNCTION@", function(source, "MonTryLearnMoveOnEvolution"))
    with tempfile.TemporaryDirectory(prefix="newgold-evolution-moves-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test"),
        ], check=True)
        return subprocess.run([str(path / "test")], cwd=directory, capture_output=True, text=True)


class EvolutionMoves(unittest.TestCase):
    def test_evolution_moves_first_and_not_offered_twice(self):
        result = run_check(read("src/pokemon.c"))
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_scene_learns_through_it(self):
        scene = function(read("src/unk_02075E14.c"), "sub_02075E14")
        self.assertIn("MonTryLearnMoveOnEvolution(data->mon, &data->learnsetIndex, &move)", scene)
        self.assertNotIn("MonTryLearnMoveOnLevelUp", scene)


if __name__ == "__main__":
    unittest.main()
