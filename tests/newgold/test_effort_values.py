#!/usr/bin/env python3
"""Run the native battle effort-value gain with host sanitizers.

BattleScript_CalcEffortValues is extracted from src/battle/battle_command.c and
compiled against the repository's own limits. The party, personal data and
held items are controlled stand-ins, so this checks where the gain stops, not
which Pokemon the experience task hands it to. The Battle Tower generator in
src/unk_0204B538.c is only read: its clamp has to name the same limit.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/items.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int16_t s16; typedef int32_t s32;
#define HEAP_ID_BATTLE 0

struct BaseStats { int yield[6]; };
typedef struct { u8 evs[6]; u16 item; } Pokemon;
typedef struct { Pokemon mon; } Party;

static struct BaseStats personal;
static struct BaseStats *AllocAndLoadMonPersonal_HandleAlternateForm(u32 species, u32 form, int heap) { (void)species; (void)form; (void)heap; return &personal; }
static void FreeMonPersonal(struct BaseStats *p) { assert(p == &personal); }
static int GetPersonalAttr(struct BaseStats *p, int attr) {
    assert(attr >= BASE_HP_YIELD && attr <= BASE_SPDEF_YIELD);
    // BASE_*_YIELD follow HP, Atk, Def, Speed, SpAtk, SpDef; STAT_* put
    // Speed fourth too, so the index carries over.
    return p->yield[attr - BASE_HP_YIELD];
}
static Pokemon *Party_GetMonByIndex(Party *party, int slot) { assert(slot == 0); return &party->mon; }
static u32 MaskOfFlagNo(int n) { return 1u << n; }
static u8 Party_MaskMonsWithPokerus(Party *party, u8 mask) { (void)party; (void)mask; return 0; }
static s32 GetItemAttr(u16 item, int attr, int heap) { (void)item; (void)attr; (void)heap; return 0; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    (void)out;
    if (attr == MON_DATA_HELD_ITEM) return mon->item;
    assert(attr >= MON_DATA_HP_EV && attr <= MON_DATA_SPDEF_EV);
    return mon->evs[attr - MON_DATA_HP_EV];
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr >= MON_DATA_HP_EV && attr <= MON_DATA_SPDEF_EV);
    mon->evs[attr - MON_DATA_HP_EV] = *(const u8 *)value;
}
@NATIVE@
'''

MAIN = r'''
int main(void) {
    assert(MAX_EV_PER_STAT == 252);

    // Three Attack a win: 249 goes to 252 and stops there, as hg-engine's
    // battles stop; the stat does not creep on to 255.
    Party party = { { { 0, 249 }, ITEM_NONE } };
    personal = (struct BaseStats){ { 0, 3 } };
    BattleScript_CalcEffortValues(&party, 0, 1, 0);
    assert(party.mon.evs[STAT_ATK] == 252);
    BattleScript_CalcEffortValues(&party, 0, 1, 0);
    assert(party.mon.evs[STAT_ATK] == 252);

    // The 510 total still wins over the per-stat ceiling.
    party = (Party){ { { 250, 5, 252 }, ITEM_NONE } };
    BattleScript_CalcEffortValues(&party, 0, 1, 0);
    assert(party.mon.evs[STAT_ATK] == 8);

    puts("PASS: battle effort values stop at 252 a stat and 510 in all.");
}
'''


class EffortValueTests(unittest.TestCase):
    def test_native_battle_gain_stops_at_252(self):
        native = function((ROOT / "src/battle/battle_command.c").read_text(), "BattleScript_CalcEffortValues")
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-effort-values-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())

    def test_battle_tower_clamps_to_the_same_limit(self):
        tower = function((ROOT / "src/unk_0204B538.c").read_text(), "sub_0204B834")
        self.assertEqual(re.findall(r"if \(ev > (\w+)\)", tower), ["MAX_EV_PER_STAT"])


if __name__ == "__main__":
    unittest.main()
