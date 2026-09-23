#!/usr/bin/env python3
"""Run the native New Gold level cap with host sanitizers.

GetLevelCap and Pokemon_TryLevelUp are extracted from src/pokemon.c and compiled
against the repository's own badge and flag constants. Save access, party data
and the experience tables are controlled stand-ins, so this checks the cap
progression and the level-up decision, not stat recalculation or the battle
experience task.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


def function(source, name):
    match = re.search(r"^(?:static )?\w+ \*?" + name + r"\([^;]*?\) \{", source, re.M)
    if match is None:
        raise ValueError(f"Function definition not found: {name}")
    depth, end = 1, match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/badge.h"
#include "constants/flags.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct SaveData SaveData;
typedef struct PlayerProfile PlayerProfile;
typedef struct SaveVarsFlags SaveVarsFlags;
typedef struct { u32 level, exp, species; } Pokemon;

static u8 badges;
static u16 setFlags[8];
static unsigned setFlagCount;
static u32 growthRate;

static SaveData *SaveData_Get(void) { return (SaveData *)1; }
static PlayerProfile *Save_PlayerData_GetProfile(SaveData *s) { assert(s); return (PlayerProfile *)1; }
static SaveVarsFlags *Save_VarsFlags_Get(SaveData *s) { assert(s); return (SaveVarsFlags *)1; }
static BOOL PlayerProfile_TestBadgeFlag(PlayerProfile *p, int badge) {
    assert(p);
    return (badges >> badge) & 1;
}
static BOOL Save_VarsFlags_CheckFlagInArray(SaveVarsFlags *v, u16 flag) {
    assert(v);
    for (unsigned i = 0; i < setFlagCount; i++) {
        if (setFlags[i] == flag) return TRUE;
    }
    return FALSE;
}
// A linear curve keeps the arithmetic obvious: level L needs L * 1000 points.
static u32 GetExpByGrowthRateAndLevel(int rate, int level) { (void)rate; return (u32)level * 1000; }
static u32 GetMonBaseStat(u16 species, int field) { (void)species; (void)field; return growthRate; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    (void)out;
    switch (attr) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_LEVEL: return mon->level;
    case MON_DATA_EXPERIENCE: return mon->exp;
    }
    assert(0);
    return 0;
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    switch (attr) {
    case MON_DATA_LEVEL: mon->level = *(const u8 *)value; return;
    case MON_DATA_EXPERIENCE: mon->exp = *(const u32 *)value; return;
    }
    assert(0);
}
@NATIVE@
'''

MAIN = r'''
static void stage(u8 badgeMask, u16 flag) {
    badges = badgeMask;
    setFlagCount = 0;
    if (flag) setFlags[setFlagCount++] = flag;
}

int main(void) {
    // The progression the hack gates its early routes with.
    stage(0, 0);                                        assert(GetLevelCap() == 10);
    stage(0, FLAG_UNK_076);                             assert(GetLevelCap() == 13);
    stage(1 << BADGE_ZEPHYR, 0);                        assert(GetLevelCap() == 19);
    stage(1 << BADGE_ZEPHYR, FLAG_BEAT_AZALEA_ROCKETS); assert(GetLevelCap() == 22);
    stage(1 << BADGE_HIVE, 0);                          assert(GetLevelCap() == 30);
    stage(1 << BADGE_PLAIN, 0);                         assert(GetLevelCap() == 34);
    stage(0, FLAG_HIDE_BURNED_TOWER_1F_RIVAL);          assert(GetLevelCap() == 36);
    stage(1 << BADGE_FOG, 0);                           assert(GetLevelCap() == MAX_LEVEL);

    // Later milestones win over earlier ones however the flags accumulate.
    badges = (1 << BADGE_ZEPHYR) | (1 << BADGE_HIVE) | (1 << BADGE_PLAIN);
    setFlagCount = 0;
    setFlags[setFlagCount++] = FLAG_UNK_076;
    setFlags[setFlagCount++] = FLAG_BEAT_AZALEA_ROCKETS;
    assert(GetLevelCap() == 34);
    setFlags[setFlagCount++] = FLAG_HIDE_BURNED_TOWER_1F_RIVAL;
    assert(GetLevelCap() == 36);
    badges |= 1 << BADGE_FOG;
    assert(GetLevelCap() == MAX_LEVEL);

    growthRate = 0;
    stage(1 << BADGE_ZEPHYR, 0);
    const u32 cap = 19;
    assert(GetLevelCap() == cap);

    // Below the cap a Pokemon levels exactly as it always did.
    for (u32 level = 5; level < cap; level++) {
        Pokemon mon = { level, (level + 1) * 1000, 1 };
        assert(Pokemon_TryLevelUp(&mon));
        assert(mon.level == level + 1);
        assert(mon.exp == (level + 1) * 1000);
    }

    // One point short of the next level is still not a level.
    {
        Pokemon mon = { 10, 11 * 1000 - 1, 1 };
        assert(!Pokemon_TryLevelUp(&mon));
        assert(mon.level == 10 && mon.exp == 11 * 1000 - 1);
    }

    // At the cap the level holds and experience is pinned to the cap, so
    // raising the cap later cannot hand over several levels at once.
    {
        Pokemon mon = { cap, cap * 1000 + 999999, 1 };
        assert(!Pokemon_TryLevelUp(&mon));
        assert(mon.level == cap);
        assert(mon.exp == cap * 1000);
    }

    // A Pokemon somehow past the cap keeps its level -- levels never come
    // off -- but its experience is cut back to the cap's threshold, as the
    // reference does it.
    {
        Pokemon mon = { cap + 6, (cap + 6) * 1000 + 500, 1 };
        assert(!Pokemon_TryLevelUp(&mon));
        assert(mon.level == cap + 6);
        assert(mon.exp == cap * 1000);
    }

    // Once the cap lifts, the held experience resumes levelling normally.
    stage(1 << BADGE_FOG, 0);
    {
        Pokemon mon = { cap, cap * 1000, 1 };
        assert(!Pokemon_TryLevelUp(&mon));
        mon.exp = (cap + 1) * 1000;
        assert(Pokemon_TryLevelUp(&mon));
        assert(mon.level == cap + 1);
    }

    // The uncapped game still stops at the maximum level.
    {
        Pokemon mon = { MAX_LEVEL, MAX_LEVEL * 1000 + 4242, 1 };
        assert(!Pokemon_TryLevelUp(&mon));
        assert(mon.level == MAX_LEVEL);
        assert(mon.exp == MAX_LEVEL * 1000);
    }

    puts("PASS: 8 level cap stages, ordering, capped hold, overshoot cut back and max level.");
}
'''


class LevelCapTests(unittest.TestCase):
    def test_native_level_cap(self):
        source = (ROOT / "src/pokemon.c").read_text()
        native = "\n".join(function(source, name) for name in ("GetLevelCap", "Pokemon_TryLevelUp"))
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-level-cap-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())

    def test_effort_values_at_the_cap_ask_only_the_level(self):
        # Task_GetExp is a battle task with a message printer and a gauge, so
        # this reads its at-cap branch rather than running it. The reference's
        # step (battle_script_commands.c, Task_DistributeExp_Extend) hands the
        # effort values to a Pokemon whose level equals GetLevelCap() and asks
        # nothing else -- not its HP, not whether the cap is 100.
        task = function((ROOT / "src/battle/battle_command.c").read_text(), "Task_GetExp")
        branch = re.search(r"if \((.*)\) \{\s*BattleScript_CalcEffortValues", task)
        self.assertIsNotNone(branch)
        self.assertEqual(branch.group(1), "GetMonData(mon, MON_DATA_LEVEL, NULL) == cap")


if __name__ == "__main__":
    unittest.main()
