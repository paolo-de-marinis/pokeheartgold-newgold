#!/usr/bin/env python3
"""Run the field's lead-ability and egg-cycle checks natively with host sanitizers.

EncounterGenState, EncounterGenState_Init and ApplyAbilityEffectToEncounterRate
come from src/field/encounter_check.c, GetEggCyclesToSubtract from
src/get_egg.c. The field system, save and party are controlled stand-ins. An
ability past 255 must not act as the retail ability that shares its low byte:
Cud Chew (291) is not Illuminate (35), Armor Tail (296) is not Magma Armor (40).
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, without_includes

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/maps.h"
#include "constants/pokemon.h"
#include "constants/weather.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define ALPH_PUZZLE_MAX 4
typedef struct Pokedex Pokedex;
typedef struct EncounterData EncounterData;
typedef struct SaveVarsFlags SaveVarsFlags;
typedef struct PlayerProfile PlayerProfile;
typedef struct { int mapId; } Location;
typedef struct { void *saveData; Location *location; } FieldSystem; // controlled stand-in
typedef struct { u32 ability, isEgg; } Pokemon;
typedef struct { int count; Pokemon mons[6]; } Party;
@TYPES@

static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    (void)out;
    if (attr == MON_DATA_ABILITY) return mon->ability;
    assert(attr == MON_DATA_IS_EGG || attr == MON_DATA_SANITY_IS_EGG);
    return mon->isEgg;
}
static int Party_GetCount(Party *party) { return party->count; }
static Pokemon *Party_GetMonByIndex(Party *party, int i) { assert(i < party->count); return &party->mons[i]; }
static SaveVarsFlags *Save_VarsFlags_Get(void *save) { (void)save; return NULL; }
static BOOL Save_VarsFlags_CheckAlphPuzzleFlag(SaveVarsFlags *f, int i) { (void)f; (void)i; return FALSE; }
static Pokedex *Save_Pokedex_Get(void *save) { (void)save; return NULL; }
static PlayerProfile *Save_PlayerData_GetProfile(void *save) { (void)save; return NULL; }
static u32 PlayerProfile_GetTrainerID(PlayerProfile *p) { (void)p; return 1; }
@NATIVE@
'''

MAIN = r'''
int main(void) {
    Location location = { 0 };
    FieldSystem fieldSystem = { NULL, &location };
    for (u32 ability = 0; ability < 512; ability++) {
        Pokemon lead = { ability, FALSE };
        EncounterGenState gen;
        memset(&gen, 0, sizeof(gen));
        EncounterGenState_Init(&fieldSystem, &lead, NULL, &gen);
        assert(gen.ability == ability);
        BOOL doubles = ability == ABILITY_ARENA_TRAP || ability == ABILITY_NO_GUARD || ability == ABILITY_ILLUMINATE;
        BOOL halves = ability == ABILITY_WHITE_SMOKE || ability == ABILITY_QUICK_FEET || ability == ABILITY_STENCH;
        assert(ApplyAbilityEffectToEncounterRate(FALSE, 20, &gen, 0, &lead) == (doubles ? 40 : halves ? 10 : 20));
        BOOL fishing = ability == ABILITY_STICKY_HOLD || ability == ABILITY_SUCTION_CUPS;
        assert(ApplyAbilityEffectToEncounterRate(TRUE, 20, &gen, 0, &lead) == (fishing ? 40 : 20));

        // An egg in the party never counts; a hatched Pokemon with the ability does.
        Party party = { 2, { { ability, TRUE }, { ABILITY_NONE, FALSE } } };
        assert(GetEggCyclesToSubtract(&party) == 1);
        party.mons[1].ability = ability;
        assert(GetEggCyclesToSubtract(&party) == (ability == ABILITY_MAGMA_ARMOR || ability == ABILITY_FLAME_BODY ? 2 : 1));
    }
    // An egg leading keeps the sentinel that matches no ability.
    Pokemon egg = { ABILITY_ILLUMINATE, TRUE };
    EncounterGenState gen;
    EncounterGenState_Init(&fieldSystem, &egg, NULL, &gen);
    assert(gen.isEgg && gen.ability == NUM_ABILITIES);
    assert(ApplyAbilityEffectToEncounterRate(FALSE, 20, &gen, 0, &egg) == 20);
    puts("PASS: 512 lead abilities through the encounter rate and the egg cycle check.");
}
'''


class FieldAbilityWidthTests(unittest.TestCase):
    def test_field_checks_see_the_whole_ability(self):
        encounter = (ROOT / "src/field/encounter_check.c").read_text()
        types = re.search(r"^typedef struct EncounterGenState \{.*?^\} EncounterGenState;", encounter, re.M | re.S).group(0)
        native = [function(encounter, "EncounterGenState_Init"),
                  function(encounter, "ApplyAbilityEffectToEncounterRate"),
                  function((ROOT / "src/get_egg.c").read_text(), "GetEggCyclesToSubtract")]
        source = PREFIX.replace("@TYPES@", without_includes(types)).replace("@NATIVE@", "\n".join(native)) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-field-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
