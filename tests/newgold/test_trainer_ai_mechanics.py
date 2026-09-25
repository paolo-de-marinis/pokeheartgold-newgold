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
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { int unused; } Pokemon;
typedef struct { u16 power; u8 type; } MoveTbl;
typedef struct { int unk8; } TrainerAIData;
typedef struct {
    TrainerAIData trainerAIData;
    u8 types[4][3];
    u8 selectedMonIndex[4];
    u8 unk_21A4[4];
    u16 moveNoHit[4];
    u16 ability[4];
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
static u16 GetBattlerAbility(BattleContext *c, int battlerId) { return c->ability[battlerId]; }
static MoveTbl sMove;
static const MoveTbl *BattleMoveTbl(BattleContext *c, u32 moveNo) { (void)c; (void)moveNo; return &sMove; }
static BOOL ov10_0221FD34(BattleSystem *b, BattleContext *c, int battlerId, BOOL noRandom) {
    (void)b; (void)c; (void)battlerId; (void)noRandom;
    return FALSE;
}
static u32 BattleSystem_Random(BattleSystem *b) { (void)b; return 1; }
static u32 BattleSystem_GetBattleType(BattleSystem *b) { (void)b; return BATTLE_TYPE_TRAINER; }
static int BattleSystem_GetBattlerIdPartner(BattleSystem *b, int battlerId) { (void)b; return battlerId ^ 2; }
// A party of three: the battler out of the first place, nobody in the second
// with an absorbing ability, and whatever the case asks in the third.
static Pokemon sParty[3];
static u16 sPartyAbility[3];
static int BattleSystem_GetPartySize(BattleSystem *b, int battlerId) { (void)b; (void)battlerId; return 3; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *b, int battlerId, int index) { (void)b; (void)battlerId; return &sParty[index]; }
static u32 GetMonData(Pokemon *mon, int field, void *data) {
    (void)data;
    switch (field) {
    case MON_DATA_HP: return 10;
    case MON_DATA_SPECIES_OR_EGG: return SPECIES_PIKACHU;
    case MON_DATA_ABILITY: return sPartyAbility[mon - sParty];
    }
    return 0;
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


class AbsorbSwitchTests(unittest.TestCase):
    def test_every_absorbing_ability_is_sent_in(self):
        # Hit by a damaging move of the type, the battler is switched for a
        # party member whose ability swallows it (the random bit allowing),
        # and kept in when its own ability does, or when the move is of
        # another type or does no damage.
        print(run("src/battle/trainer_ai_switch_absorb.c", ["AbilityAbsorbsMoveType", "ov10_0221FE8C"], r"""
    static const u16 cases[][2] = {
        { ABILITY_FLASH_FIRE, TYPE_FIRE }, { ABILITY_WATER_ABSORB, TYPE_WATER }, { ABILITY_VOLT_ABSORB, TYPE_ELECTRIC },
        { ABILITY_LIGHTNINGROD, TYPE_ELECTRIC }, { ABILITY_STORM_DRAIN, TYPE_WATER }, { ABILITY_SAP_SIPPER, TYPE_GRASS },
        { ABILITY_EARTH_EATER, TYPE_GROUND }, { ABILITY_WELL_BAKED_BODY, TYPE_FIRE },
    };
    unsigned i;
    for (i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        ctx.moveNoHit[1] = 1;
        sMove.power = 90;
        sMove.type = cases[i][1];
        ctx.unk_21A4[1] = 6; ctx.unk_21A4[3] = 6;
        sPartyAbility[2] = cases[i][0];
        ctx.ability[1] = ABILITY_NONE;
        assert(ov10_0221FE8C(&bs, &ctx, 1) == TRUE && ctx.unk_21A4[1] == 2);
        ctx.unk_21A4[1] = 6;
        ctx.ability[1] = cases[i][0];
        assert(ov10_0221FE8C(&bs, &ctx, 1) == FALSE);
        ctx.ability[1] = ABILITY_NONE;
        sMove.type = TYPE_NORMAL;
        assert(ov10_0221FE8C(&bs, &ctx, 1) == FALSE);
        sMove.type = cases[i][1];
        sMove.power = 0;
        assert(ov10_0221FE8C(&bs, &ctx, 1) == FALSE);
    }
    puts("PASS: the switch knows every ability that swallows a move's type.");"""))


if __name__ == "__main__":
    unittest.main()
