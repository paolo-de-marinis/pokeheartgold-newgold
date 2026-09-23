#!/usr/bin/env python3
"""Run the Trainer House record writer and reader natively with host sanitizers.

TrainerHouseMon comes from include/save_trainer_house.h, the IR writer
ov112_021F33D8 from src/pokewalker_trainer_house.c and the battle reader
TrainerHouse_CopyToPokemon from src/overlay_25.c. The party and the Pokemon
they fill are stand-ins. A record sent for an ability past 255 must give the
same ability to the Pokemon the Trainer House battles with, and a vanilla
sender's record (which clears the padding byte) reads as before.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
@GLOBALS@
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(x) ((int)(sizeof(x) / sizeof((x)[0])))
#define MAX_TRAINER_HOUSE_LEVEL 50
@TYPES@
_Static_assert(sizeof(TrainerHouseMon) == 0x38, "TrainerHouseMon keeps its record size");
_Static_assert(offsetof(TrainerHouseMon, ability) == 0x20, "TrainerHouseMon keeps the ability byte");
_Static_assert(offsetof(TrainerHouseMon, nickname) == 0x24, "TrainerHouseMon keeps the nickname");

typedef struct { u32 fields[256]; } Pokemon;
typedef struct { int count; Pokemon mons[PARTY_SIZE]; } Party;

static int Party_GetCount(Party *party) { return party->count; }
static Pokemon *Party_GetMonByIndex(Party *party, int i) { assert(i < party->count); return &party->mons[i]; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    assert(attr >= 0 && attr < 256);
    if (attr == MON_DATA_NICKNAME) memset(out, 0xFF, (POKEMON_NAME_LENGTH + 1) * sizeof(u16));
    return mon->fields[attr];
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr >= 0 && attr < 256);
    if (attr == MON_DATA_ABILITY) mon->fields[attr] = *(const u16 *)value;
}
static void Mon_UpdateShayminForm(Pokemon *mon, int form) { (void)mon; (void)form; }
static void CopyU16StringArrayN(u16 *dest, const u16 *src, u32 n) { memcpy(dest, src, n * sizeof(u16)); }
static void StringFillEOS(u16 *s, u32 n) { memset(s, 0xFF, n * sizeof(u16)); }
static void ZeroMonData(Pokemon *mon) { memset(mon, 0, sizeof(*mon)); }
static void CreateMonWithFixedIVs(Pokemon *mon, u16 species, u8 level, u32 ivs, u32 pid) {
    (void)species; (void)level; (void)pid;
    assert(ivs <= 0x3FFFFFFF);
    // Whatever the game derives here, the record's ability must overwrite it.
    mon->fields[MON_DATA_ABILITY] = 0xDEAD;
}
static void CalcMonLevelAndStats(Pokemon *mon) { (void)mon; }
@NATIVE@
'''

MAIN = r'''
int main(void) {
    static Party party;
    TrainerHouseMon records[PARTY_SIZE];
    // Abilities go to 319; 320-511 confirm nothing narrows below nine bits.
    for (u32 ability = 0; ability < 512; ability++) {
        memset(&party, 0, sizeof(party));
        party.count = 1;
        party.mons[0].fields[MON_DATA_SPECIES] = SPECIES_SUDOWOODO;
        party.mons[0].fields[MON_DATA_LEVEL] = 50;
        party.mons[0].fields[MON_DATA_ABILITY] = ability;
        // The sender clears the whole set before filling it.
        memset(records, 0, sizeof(records));
        ov112_021F33D8(records, &party);
        assert(records[0].ability == (ability & 0xFF));
        Pokemon mon;
        TrainerHouse_CopyToPokemon(&records[0], &mon);
        assert(mon.fields[MON_DATA_ABILITY] == ability);

        // A vanilla sender only ever writes the low byte.
        TrainerHouseMon vanilla;
        memset(&vanilla, 0, sizeof(vanilla));
        vanilla.species = SPECIES_SUDOWOODO;
        vanilla.level = 50;
        vanilla.ability = ability & 0xFF;
        TrainerHouse_CopyToPokemon(&vanilla, &mon);
        assert(mon.fields[MON_DATA_ABILITY] == (ability & 0xFF));
    }
    puts("PASS: 512 abilities sent through the Trainer House record and read back.");
}
'''


class TrainerHouseAbilityTests(unittest.TestCase):
    def test_trainer_house_record_keeps_the_ability(self):
        header = (ROOT / "include/save_trainer_house.h").read_text()
        types = header[header.index("typedef struct TrainerHouseMon {"):header.index("} TrainerHouseMon;") + len("} TrainerHouseMon;")]
        native = [function((ROOT / "src/pokewalker_trainer_house.c").read_text(), "ov112_021F33D8"),
                  function((ROOT / "src/overlay_25.c").read_text(), "TrainerHouse_CopyToPokemon")]
        # constants/global.h pulls in the Nitro SDK; take only the two lengths.
        globals_ = "\n".join(re.findall(r"^#define (?:POKEMON_NAME_LENGTH|PARTY_SIZE) .*$", (ROOT / "include/constants/global.h").read_text(), re.M))
        source = PREFIX.replace("@GLOBALS@", globals_).replace("@TYPES@", types).replace("@NATIVE@", "\n".join(native)) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-trainer-house-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
