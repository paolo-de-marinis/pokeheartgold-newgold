#!/usr/bin/env python3
"""hg-engine's hidden-ability script flags, 2600 and 2601.

UpdateMonAbility, UpdateBoxMonAbility and Mon_TakeHiddenAbilityFlag are
extracted from src/pokemon.c and run on the host against stand-ins for the
save and the Pokemon; the call sites are checked in the source.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PROGRAM = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/flags.h"
#include "constants/pokemon.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef struct { int species, pid, form, ability, bits; } BoxPokemon;
typedef struct { BoxPokemon box; } Pokemon;
typedef struct { int flags[0x1000]; } SaveVarsFlags;
typedef struct { SaveVarsFlags vars; } SaveData;

static SaveData save;
static SaveData *SaveData_Get(void) { return &save; }
static SaveVarsFlags *Save_VarsFlags_Get(SaveData *s) { return &s->vars; }
static BOOL Save_VarsFlags_CheckFlagInArray(SaveVarsFlags *v, u16 f) { return v->flags[f]; }
static void Save_VarsFlags_ClearFlagInArray(SaveVarsFlags *v, u16 f) { v->flags[f] = 0; }
static BOOL AcquireBoxMonLock(BoxPokemon *b) { (void)b; return 0; }
static void ReleaseBoxMonLock(BoxPokemon *b, BOOL d) { (void)b, (void)d; }

static u32 GetBoxMonData(BoxPokemon *b, int field, void *unused) {
    (void)unused;
    switch (field) {
    case MON_DATA_SPECIES: return b->species;
    case MON_DATA_PERSONALITY: return b->pid;
    case MON_DATA_FORM: return b->form;
    case MON_DATA_ABILITY: return b->ability;
    case MON_DATA_UNUSED_113: return b->bits;
    case MON_DATA_UNUSED_114: return 0; // no Ability Capsule swap
    }
    assert(0);
    return 0;
}
static void SetBoxMonData(BoxPokemon *b, int field, void *value) {
    if (field == MON_DATA_ABILITY) b->ability = *(int *)value;
    else if (field == MON_DATA_UNUSED_113) b->bits = *(u8 *)value & 3;
    else assert(0);
}
static u32 GetMonData(Pokemon *m, int field, void *v) { return GetBoxMonData(&m->box, field, v); }
static void SetMonData(Pokemon *m, int field, void *v) { SetBoxMonData(&m->box, field, v); }

// Species 1 has two abilities and a hidden one; species 2 has no hidden one.
static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    (void)form;
    if (stat == BASE_ABILITY_1) return 10;
    if (stat == BASE_ABILITY_2) return 11;
    if (stat == BASE_HIDDEN_ABILITY) return species == 1 ? 12 : ABILITY_NONE;
    assert(0);
    return 0;
}

void UpdateMonAbility(Pokemon *mon);
void UpdateBoxMonAbility(BoxPokemon *boxMon);

@FUNCTIONS@

int main(void) {
    Pokemon mon = { { 1, 1, 0, 0, 0 } };

    // No flag: the personality picks, and nothing is marked.
    Mon_TakeHiddenAbilityFlag(&mon, FLAG_HIDDEN_ABILITIES);
    UpdateMonAbility(&mon);
    assert(mon.box.ability == 11 && mon.box.bits == 0);

    // The flag gives the hidden ability, marks the Pokemon and is spent.
    save.vars.flags[FLAG_HIDDEN_ABILITIES] = 1;
    Mon_TakeHiddenAbilityFlag(&mon, FLAG_HIDDEN_ABILITIES);
    assert(mon.box.ability == 12 && mon.box.bits == MON_HIDDEN_ABILITY_BIT);
    assert(!save.vars.flags[FLAG_HIDDEN_ABILITIES]);

    // The mark survives the ability being worked out again (a form change).
    mon.box.ability = 0;
    UpdateMonAbility(&mon);
    assert(mon.box.ability == 12);

    // The next Pokemon does not get it.
    Pokemon next = { { 1, 0, 0, 0, 0 } };
    Mon_TakeHiddenAbilityFlag(&next, FLAG_HIDDEN_ABILITIES);
    UpdateMonAbility(&next);
    assert(next.box.ability == 10 && next.box.bits == 0);

    // A species with no hidden ability keeps its own, marked or not.
    Pokemon plain = { { 2, 0, 0, 0, MON_HIDDEN_ABILITY_BIT } };
    UpdateMonAbility(&plain);
    assert(plain.box.ability == 10);

    // The starters' flag stays set for all three.
    save.vars.flags[FLAG_HIDDEN_ABILITIES_STARTERS] = 1;
    for (int i = 0; i < 3; i++) {
        Pokemon starter = { { 1, i, 0, 0, 0 } };
        Mon_TakeHiddenAbilityFlag(&starter, FLAG_HIDDEN_ABILITIES_STARTERS);
        assert(starter.box.ability == 12);
    }
    assert(save.vars.flags[FLAG_HIDDEN_ABILITIES_STARTERS]);
    return 0;
}
"""


def body(path, name):
    return function((ROOT / path).read_text(), name)


class HiddenAbilityFlagTests(unittest.TestCase):
    def test_the_flag_the_bit_and_the_ability(self):
        functions = "\n\n".join(body("src/pokemon.c", name) for name in
                                ("UpdateMonAbility", "UpdateBoxMonAbility", "Mon_TakeHiddenAbilityFlag"))
        with tempfile.TemporaryDirectory(prefix="newgold-hidden-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(PROGRAM.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_every_maker_the_reference_hooks_takes_the_flag(self):
        for path, name, flag in [
            ("src/script_pokemon_util.c", "GiveMon", "FLAG_HIDDEN_ABILITIES"),
            ("src/scrcmd_party.c", "ScrCmd_GiveEgg", "FLAG_HIDDEN_ABILITIES"),
            ("src/field/scrcmd_pokemon_misc.c", "ScrCmd_GiveTogepiEgg", "FLAG_HIDDEN_ABILITIES"),
            ("src/field/encounter_check.c", "addGeneratedMonToBattleSetupParty", "FLAG_HIDDEN_ABILITIES"),
            ("src/choose_starter.c", "CreateStarter", "FLAG_HIDDEN_ABILITIES_STARTERS"),
        ]:
            self.assertRegex(body(path, name), rf"Mon_TakeHiddenAbilityFlag\(\w+, {flag}\);", name)

    def test_hatching_keeps_the_bit(self):
        hatch = body("src/get_egg.c", "sub_0206D328")
        self.assertRegex(hatch, r"= GetMonData\(mon, MON_DATA_UNUSED_113, NULL\);\s*sub_0206D038\(mon, heapID\);\s*"
                                r"SetMonData\(mon, MON_DATA_UNUSED_113, &\w+\);\s*UpdateMonAbility\(mon\);")


if __name__ == "__main__":
    unittest.main()
