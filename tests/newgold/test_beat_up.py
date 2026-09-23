#!/usr/bin/env python3
"""Beat Up strikes once for each member fit to fight, at 5 + base Attack / 10.

hg-engine (d0380a487) counts the party's healthy members in its BeatUp
command, sets that many hits, and gives each hit the power of the member it
stands for; the damage itself is the move's ordinary damage, with the user's
Attack and the target's Defence. BtlCmd_BeatUp is compiled here against a
party it reads through stubs.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#pragma GCC diagnostic ignored "-Wunknown-pragmas"

typedef struct { int species, hp, status, attack; } Pokemon;
typedef struct BattleSystem BattleSystem;
typedef struct {
    int battlerIdAttacker;
    int movePower;
    u8 multiHitCount, multiHitCountTemp, beatUpCount;
    u32 checkMultiHit;
    u8 selectedMonIndex[4];
} BattleContext;

static Pokemon sParty[6];
static int sPartySize;

static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleSystem_GetPartySize(BattleSystem *bs, int battlerId) { (void)bs; (void)battlerId; return sPartySize; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int i) { (void)bs; (void)battlerId; return &sParty[i]; }
static u32 GetMonData(Pokemon *mon, int field, void *dest) {
    (void)dest;
    switch (field) {
    case MON_DATA_SPECIES: return mon->species == SPECIES_EGG ? SPECIES_PIKACHU : mon->species;
    case MON_DATA_SPECIES_OR_EGG: return mon->species;
    case MON_DATA_FORM: return 0;
    case MON_DATA_HP: return mon->hp;
    case MON_DATA_STATUS: return mon->status;
    default: assert(0); return 0;
    }
}
static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    assert(stat == BASE_ATK && form == 0);
    for (int i = 0; i < 6; i++) if (sParty[i].species == species) return sParty[i].attack;
    assert(0); return 0;
}

@BEAT_UP@

int main(void) {
    BattleContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlerIdAttacker = 0;
    ctx.selectedMonIndex[0] = 1;
    sPartySize = 6;
    sParty[0] = (Pokemon){ SPECIES_SNORLAX, 100, 0, 110 };
    sParty[1] = (Pokemon){ SPECIES_SNEASEL, 50, 8, 95 };   // the user: it strikes though poisoned
    sParty[2] = (Pokemon){ SPECIES_ONIX, 0, 0, 45 };       // fainted
    sParty[3] = (Pokemon){ SPECIES_EGG, 10, 0, 0 };        // an egg
    sParty[4] = (Pokemon){ SPECIES_MACHAMP, 90, 1, 130 };  // asleep
    sParty[5] = (Pokemon){ SPECIES_HOUNDOOM, 80, 0, 90 };

    int powers[6], hits = 0;
    do {
        BtlCmd_BeatUp(0, &ctx);
        powers[hits++] = ctx.movePower;
        assert(hits <= 6);
    } while (--ctx.multiHitCount);

    assert(ctx.multiHitCountTemp == 3 && ctx.checkMultiHit == MULTIHIT_MULTI_HIT_MOVE);
    assert(hits == 3);
    assert(powers[0] == 5 + 110 / 10 && powers[1] == 5 + 95 / 10 && powers[2] == 5 + 90 / 10);
    // What the trainer AI values it at: the three hits as one.
    assert(BeatUp_TotalPower(0, &ctx, 0) == powers[0] + powers[1] + powers[2]);
    return 0;
}
"""


class BeatUpTests(unittest.TestCase):
    def test_one_hit_per_healthy_member(self):
        commands = read("src/battle/battle_command.c")
        source = FIXTURE.replace("@BEAT_UP@", "\n".join(function(commands, name) for name in (
            "BeatUpMemberStrikes", "BeatUpMemberPower", "BeatUp_TotalPower", "BtlCmd_BeatUp")))
        with tempfile.TemporaryDirectory(prefix="newgold-beat-up-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_strongest_move_ai_values_it_by_its_hits(self):
        # Its table power is the engine's 1, and the AI compares by damage only
        # the moves above 1 or on its list of worked-out powers.
        listed = read("src/battle/trainer_ai_0222B080.c")
        listed = listed[listed.index("ov10_0222B080[] = {"):]
        self.assertIn("MOVE_EFFECT_BEAT_UP,", listed[:listed.index("};")])
        body = function(read("src/battle/trainer_ai_0221F084.c"), "ov10_0221F084")
        self.assertRegex(body, r"case MOVE_BEAT_UP:\s*power = BeatUp_TotalPower\(battleSystem, ctx, battlerId\);")

    def test_the_script_is_an_ordinary_hit(self):
        script = next((ROOT / "files/battledata/script/effect_script").glob("effect_script_0154*.s")).read_text()
        lines = [line.strip() for line in script.splitlines() if line.strip() and not line.strip().startswith((".", "_", "//"))]
        self.assertEqual(lines, ["BeatUp", "CalcCrit", "CalcDamage", "End"])


if __name__ == "__main__":
    unittest.main()
