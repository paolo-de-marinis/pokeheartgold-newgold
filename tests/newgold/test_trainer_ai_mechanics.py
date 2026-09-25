#!/usr/bin/env python3
"""What the trainer AI's C knows of the mechanics the port added.

Each command or check is compiled natively from its source, with the few
calls it makes stubbed, and asked the cases the port changed.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

PREFIX = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/battle.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { int unk8; } TrainerAIData;
typedef struct {
    TrainerAIData trainerAIData;
    u8 types[4][3];
} BattleContext;
static BattleSystem bs;
static BattleContext ctx;
static void ov10_0221EF24(BattleContext *c, int offset) { (void)c; (void)offset; }
static u32 sArgs[2], sArg;
static u32 ov10_0221EEF0(BattleContext *c) { (void)c; return sArgs[sArg++]; }
static u8 ov10_0221EF34(BattleContext *c, u8 battler) { (void)c; return battler; }
static int GetBattlerVar(BattleContext *c, int battlerId, u32 varId, void *data) {
    (void)data;
    return c->types[battlerId][varId == BMON_DATA_TYPE_1 ? 0 : varId == BMON_DATA_TYPE_2 ? 1 : 2];
}
"""


def run(path, functions, body):
    source = (ROOT / path).read_text()
    program = PREFIX + "\n".join(function(source, name) for name in functions) + \
        "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
    with tempfile.TemporaryDirectory(prefix="newgold-ai-") as directory:
        where = Path(directory)
        (where / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-variable",
            "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"),
            str(where / "test.c"), "-o", str(where / "test")], check=True)
        result = subprocess.run([str(where / "test")], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
    if result.returncode:
        raise AssertionError(result.stdout + result.stderr)
    return result.stdout.strip()


class TypeCommandTests(unittest.TestCase):
    def test_a_third_type_counts(self):
        # Trick-or-Treat and Forest's Curse give a third type, which the
        # battle reads (Battler_HasGhostType); command 52 asks it too.
        print(run("src/battle/trainer_ai_0221CA9C.c", ["ov10_0221CCB4"], r"""
    ctx.types[1][0] = TYPE_NORMAL; ctx.types[1][1] = TYPE_NORMAL; ctx.types[1][2] = TYPE_GHOST;
    sArgs[0] = 1; sArgs[1] = TYPE_GHOST; sArg = 0;
    ov10_0221CCB4(&bs, &ctx);
    assert(ctx.trainerAIData.unk8 == 1);
    sArgs[1] = TYPE_FLYING; sArg = 0;
    ov10_0221CCB4(&bs, &ctx);
    assert(ctx.trainerAIData.unk8 == 0);
    puts("PASS: command 52 finds a third type.");"""))


if __name__ == "__main__":
    unittest.main()
