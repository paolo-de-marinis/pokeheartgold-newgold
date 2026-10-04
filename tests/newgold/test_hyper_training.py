#!/usr/bin/env python3
"""Hyper Training: a trained stat counts as 31 in the stats, and nowhere else.

The latest games' rule (Pokemon Central, Allenamento Pro): a Bottle Cap makes
one stat count as 31, a Gold Bottle Cap all six; the IV itself is not changed,
so Hidden Power's type and power and what breeding passes on still come from
the true one. The flags are hg-engine's DUMMY_P2_2_*_IV_OVERRIDE, bits 6 to 11
of MON_DATA_UNUSED_114, the field that already holds the Mint's nature and the
Ability Capsule's bit -- the save keeps its size and layout.

CalcMonStats and the field's Hidden Power reader are extracted from the tree
and compiled natively; the rest is read in the source: the battle's Hidden
Power and the egg's inheritance read MON_DATA_*_IV, and only the places that
should know about the flags read them.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NULL_HEAP 0
#define HEAP_ID_DEFAULT 0
#define SPECIES_SHEDINJA 292

typedef struct { int hp, atk, def, speed, spatk, spdef; } BASE_STATS;
typedef struct {
    int species, form, level, hp, maxHp, stats[NUM_STATS];
    int iv[NUM_STATS], ev[NUM_STATS];
    u16 flags;
} Pokemon;

static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    if (attr >= MON_DATA_HP_IV && attr <= MON_DATA_SPDEF_IV) return mon->iv[attr - MON_DATA_HP_IV];
    if (attr >= MON_DATA_HP_EV && attr <= MON_DATA_SPDEF_EV) return mon->ev[attr - MON_DATA_HP_EV];
    switch (attr) {
    case MON_DATA_LEVEL: return mon->level;
    case MON_DATA_HP: return mon->hp;
    case MON_DATA_MAX_HP: return mon->maxHp;
    case MON_DATA_FORM: return mon->form;
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_UNUSED_114: return mon->flags;
    }
    assert(0 && "unexpected attribute");
    return 0;
}

static void SetMonData(Pokemon *mon, int attr, const void *value) {
    int v = *(const int *)value;
    switch (attr) {
    case MON_DATA_HP: mon->hp = v; return;
    case MON_DATA_MAX_HP: mon->maxHp = v; return;
    case MON_DATA_ATK: mon->stats[STAT_ATK] = v; return;
    case MON_DATA_DEF: mon->stats[STAT_DEF] = v; return;
    case MON_DATA_SPEED: mon->stats[STAT_SPEED] = v; return;
    case MON_DATA_SP_ATK: mon->stats[STAT_SPATK] = v; return;
    case MON_DATA_SP_DEF: mon->stats[STAT_SPDEF] = v; return;
    }
    assert(0 && "CalcMonStats wrote something other than a stat");
}

static BOOL AcquireMonLock(Pokemon *mon) { (void)mon; return FALSE; }
static void ReleaseMonLock(Pokemon *mon, BOOL decry) { (void)mon; (void)decry; }
static u8 GetMonNatureAfterMint(Pokemon *mon) { (void)mon; return 0; }
static u16 ModifyStatByNature(u8 nature, u16 n, u8 stat) { (void)nature; (void)stat; return n; }
static void *Heap_Alloc(int heap, u32 size) { (void)heap; return malloc(size); }
static void Heap_Free(void *p) { free(p); }
static void LoadMonBaseStats_HandleAlternateForm(int species, int form, BASE_STATS *b) {
    (void)species; (void)form;
    b->hp = 60; b->atk = 85; b->def = 69; b->speed = 90; b->spatk = 65; b->spdef = 85;
}

@CALC@

@HIDDEN_POWER@

static int Expected(int stat, int base, int iv, int ev, int level) {
    int core = (2 * base + iv + ev / 4) * level / 100;
    return stat == STAT_HP ? core + level + 10 : core + 5;
}

static int Stat(Pokemon *mon, int stat) {
    return stat == STAT_HP ? mon->maxHp : mon->stats[stat];
}

int main(void) {
    static const int base[NUM_STATS] = { 60, 85, 69, 90, 65, 85 };
    for (int trained = 0; trained < NUM_STATS; trained++) {
        Pokemon mon = { .species = 1, .level = 50, .hp = 1 };
        for (int s = 0; s < NUM_STATS; s++) {
            mon.iv[s] = 3 + s;
            mon.ev[s] = 8 * s;
        }
        mon.flags = (u16)(MON_HYPER_TRAINED_BIT(trained) | 0x003F); // the Mint and Capsule bits stay out of it
        CalcMonStats(&mon);
        for (int s = 0; s < NUM_STATS; s++) {
            int iv = s == trained ? MAX_IV : mon.iv[s];
            assert(Stat(&mon, s) == Expected(s, base[s], iv, mon.ev[s], 50));
            // The IV is still the one the Pokemon was born with.
            assert(mon.iv[s] == 3 + s);
        }

        // Hidden Power reads the true IVs: the same answer with and without the flag.
        s32 power, type, power0, type0;
        GetHiddenPowerPowerType(&mon, &power, &type);
        mon.flags = 0;
        GetHiddenPowerPowerType(&mon, &power0, &type0);
        assert(power == power0 && type == type0);
    }

    // A Gold Bottle Cap: all six count as 31.
    Pokemon mon = { .species = 1, .level = 100, .hp = 1, .flags = MON_HYPER_TRAINED_ALL };
    CalcMonStats(&mon);
    for (int s = 0; s < NUM_STATS; s++) {
        assert(Stat(&mon, s) == Expected(s, base[s], MAX_IV, 0, 100));
    }
    return 0;
}
"""

JUDGE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define FALSE 0
#define msg_0096_D31R0201_00122 122
#define msg_0096_D31R0201_00123 123
#define msg_0096_D31R0201_00124 124
#define msg_0096_D31R0201_00125 125
#define msg_0096_D31R0201_00126 126
#define msg_0096_D31R0201_00127 127
typedef struct { u32 judgeStatPosition; void *saveData; } FieldSystem;
typedef struct { FieldSystem *fieldSystem; } ScriptContext;
typedef struct { u32 iv[6]; u32 flags; } Pokemon;
static Pokemon sMon;
static u16 sVars[4];
static int sNext;
static u16 ScriptGetVar(ScriptContext *ctx) { (void)ctx; return 0; }
static u16 *ScriptGetVarPointer(ScriptContext *ctx) { (void)ctx; return &sVars[sNext++]; }
static void *SaveArray_Party_Get(void *save) { return save; }
static Pokemon *Party_GetMonByIndex(void *party, u32 i) { (void)party; (void)i; return &sMon; }
static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    if (attr >= MON_DATA_HP_IV && attr <= MON_DATA_SPDEF_IV) return mon->iv[attr - MON_DATA_HP_IV];
    assert(attr == MON_DATA_UNUSED_114);
    return mon->flags;
}
@TABLE@
@JUDGE@
static void Judge(u32 flags, u16 *total, u16 *best, u16 *rating) {
    FieldSystem field = { 0, 0 };
    ScriptContext ctx = { &field };
    sMon.flags = flags;
    sNext = 0;
    ScrCmd_StatJudge(&ctx);
    *total = sVars[0];
    *best = sVars[1];
    *rating = sVars[2];
}
int main(void) {
    u16 total, best, rating;
    sMon = (Pokemon) { { 10, 30, 12, 8, 20, 5 }, 0 };
    // Untrained: retail's Judge, Attack the best at 30.
    Judge(0, &total, &best, &rating);
    assert(total == 85 && best == 123 && rating == 30);
    // Speed trained counts as 31: it is the best now, and named Hyper trained.
    Judge(MON_HYPER_TRAINED_BIT(STAT_SPEED), &total, &best, &rating);
    assert(total == 85 - 8 + 31 && best == 127 && rating == STAT_JUDGE_HYPER_TRAINED);
    // HP trained, 31, is above Attack's 30: the best now, and named Hyper trained.
    Judge(MON_HYPER_TRAINED_BIT(STAT_HP), &total, &best, &rating);
    assert(total == 85 - 10 + 31 && best == 122 && rating == STAT_JUDGE_HYPER_TRAINED);
    sMon.iv[STAT_HP] = 10;
    Judge(MON_HYPER_TRAINED_BIT(STAT_DEF), &total, &best, &rating);
    assert(best == 124 && rating == STAT_JUDGE_HYPER_TRAINED);
    return 0;
}
"""

# The places allowed to read the Hyper Training bits: the stats, the summary's
# IV view, the Frontier's Judge, the trainer app and the save editor.
READERS = {
    "src/pokemon.c",
    "src/pokemon_summary_stats.c",
    "src/field/scrcmd_pokemon_misc.c",
    "src/ev_iv_trainer_app.c",
    "src/ev_iv_trainer_rules.c",
}


class HyperTrainingTests(unittest.TestCase):
    def test_a_trained_stat_counts_as_31_and_hidden_power_does_not_see_it(self):
        pokemon = read("src/pokemon.c")
        misc = read("src/field/scrcmd_pokemon_misc.c")
        source = FIXTURE.replace("@CALC@", function(pokemon, "GetMonIvForStats") + "\n" + function(pokemon, "CalcMonStats"))
        source = source.replace("@HIDDEN_POWER@", function(misc, "GetHiddenPowerPowerType"))
        with tempfile.TemporaryDirectory(prefix="newgold-hyper-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-O2",
                "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check"),
            ], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)

    def test_the_judge_counts_a_trained_stat_as_31_and_names_it(self):
        misc = read("src/field/scrcmd_pokemon_misc.c")
        table = re.search(r"static const u16 sStatJudgeBestStatMsgIdxs\[6\] = \{.*?\};", misc, re.S).group(0)
        define = re.search(r"#define STAT_JUDGE_HYPER_TRAINED .*", misc).group(0)
        source = JUDGE.replace("@TABLE@", table).replace("@JUDGE@", define + "\n" + function(misc, "ScrCmd_StatJudge"))
        with tempfile.TemporaryDirectory(prefix="newgold-judge-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-variable", "-O2", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)
        # The script says so: a rating past 31 is the new line, read before the four retail ones.
        script = read("files/fielddata/script/scr_seq/scr_seq_0069_D31R0201.s")
        block = script[script.index("_15AF:"):]
        self.assertLess(block.index("Compare VAR_SPECIAL_x8003, 32"), block.index("Compare VAR_SPECIAL_x8003, 15"))
        self.assertIn("NPCMsg msg_0096_D31R0201_00133", script[script.index("_HyperTrained:"):])
        self.assertIn("Hyper trained", read("files/msgdata/msg/msg_0096_D31R0201.gmm"))

    def test_the_flags_are_hg_engines_bits(self):
        constants = read("include/constants/pokemon.h")
        self.assertIn("#define MON_HYPER_TRAINED_BIT(stat) (0x40 << (stat))", constants)
        # hg-engine's DUMMY_P2_2_HP_IV_OVERRIDE .. SP_DEFENSE: 0x40 .. 0x800, in
        # the order HP, Attack, Defense, Speed, Sp. Atk, Sp. Def -- STAT_* order.
        stats = dict(re.findall(r"#define (STAT_\w+)\s+(\d+)", constants))
        order = ["STAT_HP", "STAT_ATK", "STAT_DEF", "STAT_SPEED", "STAT_SPATK", "STAT_SPDEF"]
        self.assertEqual([int(stats[s]) for s in order], list(range(6)))

    def test_hidden_power_and_breeding_read_the_true_iv(self):
        battle = read("src/battle/overlay_12_0224E4FC.c")
        for i, name in enumerate(["hpIV", "atkIV", "defIV", "speedIV", "spAtkIV", "spDefIV"]):
            field = ["HP", "ATK", "DEF", "SPEED", "SPATK", "SPDEF"][i]
            self.assertRegex(battle, rf"battleMons\[battlerId\]\.{name} = GetMonData\(mon, MON_DATA_{field}_IV, NULL\);")
        hidden = function(read("src/battle/battle_command.c"), "BtlCmd_CalcHiddenPowerParams")
        self.assertIn("battleMons[ctx->battlerIdAttacker].hpIV", hidden)
        egg = read("src/get_egg.c")
        for field in ["HP", "ATK", "DEF", "SPEED", "SPATK", "SPDEF"]:
            self.assertIn(f"inheritedIV = GetBoxMonData(boxMon, MON_DATA_{field}_IV, NULL);", egg)

    def test_only_the_stats_and_the_screens_that_show_it_read_the_flags(self):
        readers = set()
        for path in (ROOT / "src").rglob("*.c"):
            if "MON_HYPER_TRAINED" in path.read_text(encoding="latin-1"):
                readers.add(str(path.relative_to(ROOT)))
        self.assertTrue(readers <= READERS, f"new readers of the Hyper Training bits: {sorted(readers - READERS)}")


if __name__ == "__main__":
    unittest.main()
