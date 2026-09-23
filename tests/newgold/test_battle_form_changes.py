#!/usr/bin/env python3
"""The forms a Pokemon changes into during a battle, and when.

hg-engine (d0380a487) changes a battler's form from its ability, its HP or the
move it uses: Zen Mode, Schooling, Stance Change and the rest, each keyed on
the species and switched through BattleFormChange. None of them was here. A
form is a species here, so each rule picks the species to become; the rules
are extracted from src/battle and compiled natively, and the places that act
on them are read from the source.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function

PREFIX = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
typedef int32_t s32;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct {
    u16 species;
    u16 ability;
    s32 hp;
    u32 maxHp;
    u32 status2;
    u8 level;
} BattleMon;
typedef struct {
    BattleMon battleMons[4];
} BattleContext;
typedef struct { u16 power; } MoveTbl;

static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static MoveTbl sMoves[] = { [MOVE_TACKLE] = { 40 }, [MOVE_SWORDS_DANCE] = { 0 }, [MOVE_KINGS_SHIELD] = { 0 } };
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) { (void)ctx; return &sMoves[move]; }

static BattleContext ctx;
static void set(u16 species, u16 ability, s32 hp, u32 maxHp) {
    ctx.battleMons[0] = (BattleMon){ species, ability, hp, maxHp, 0, 50 };
}
"""


def run(functions, body, prefix, path="src/battle/overlay_12_0224E4FC.c"):
    source = (ROOT / path).read_text()
    program = PREFIX + "\n".join(function(source, name) for name in functions) + "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
    with tempfile.TemporaryDirectory(prefix=prefix) as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address,undefined",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
    if result.returncode:
        raise AssertionError(result.stdout + result.stderr)
    return result.stdout.strip()


class FormChangeTests(unittest.TestCase):
    def setUp(self):
        self.check = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "Battler_CheckWeatherFormChange")

    def test_zen_mode(self):
        """At half its HP or less a Darmanitan is in its Zen Mode, above half
        or without the ability it is not; the Galarian one likewise."""
        print(run(["Battler_ZenModeForm"], r"""
    set(SPECIES_DARMANITAN, ABILITY_ZEN_MODE, 51, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN, ABILITY_ZEN_MODE, 50, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_ZEN_MODE);
    set(SPECIES_DARMANITAN, ABILITY_SHEER_FORCE, 10, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN_GALARIAN, ABILITY_ZEN_MODE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_ZEN_MODE_GALARIAN);
    set(SPECIES_DARMANITAN_ZEN_MODE, ABILITY_ZEN_MODE, 50, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN_ZEN_MODE, ABILITY_ZEN_MODE, 51, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN);
    set(SPECIES_DARMANITAN_ZEN_MODE_GALARIAN, ABILITY_NONE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_GALARIAN);
    set(SPECIES_SLOWPOKE, ABILITY_ZEN_MODE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Zen Mode comes at half HP and goes above it or without the ability.");""", "newgold-zen-"))
        self.assertIn("form = Battler_ZenModeForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_schooling(self):
        """A Wishiwashi of level 20 or more schools above a quarter of its HP
        and breaks up at a quarter; below 20, or without the ability, it does
        not school."""
        print(run(["Battler_SchoolingForm"], r"""
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 26, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_WISHIWASHI_SCHOOL);
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 25, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI_SCHOOL, ABILITY_SCHOOLING, 25, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_WISHIWASHI);
    set(SPECIES_WISHIWASHI_SCHOOL, ABILITY_SCHOOLING, 26, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 100, 100);
    ctx.battleMons[0].level = 19;
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI, ABILITY_NONE, 100, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Schooling above a quarter of the HP, from level 20.");""", "newgold-schooling-"))
        self.assertIn("form = Battler_SchoolingForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_stance_change(self):
        """Before an Aegislash moves, a move with power puts it in its Blade
        Forme and King's Shield in its Shield Forme; a status move changes
        nothing, nor does the move of a transformed battler."""
        print(run(["Battler_StanceChangeForm"], r"""
    set(SPECIES_AEGISLASH, ABILITY_STANCE_CHANGE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_AEGISLASH_BLADE);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_SWORDS_DANCE) == SPECIES_NONE);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_KINGS_SHIELD) == SPECIES_NONE);
    set(SPECIES_AEGISLASH_BLADE, ABILITY_STANCE_CHANGE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_KINGS_SHIELD) == SPECIES_AEGISLASH);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    set(SPECIES_AEGISLASH, ABILITY_STANCE_CHANGE, 1, 1);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    set(SPECIES_AEGISLASH, ABILITY_NONE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    puts("PASS: Stance Change to Blade for a move with power, to Shield for King's Shield.");""",
                  "newgold-stance-", "src/battle/battle_controller_player.c"))
        before = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224C38C")
        self.assertLess(before.index("TryStanceChange(battleSystem, ctx)"), before.index("ov12_0224B1FC(battleSystem, ctx)"))

    def test_hunger_switch(self):
        """At the end of every turn a Morpeko turns Hangry, or back; not a
        fainted one, a transformed one or one that has lost the ability. The
        change is the last thing at the end of the turn."""
        print(run(["Battler_HungerSwitchForm"], r"""
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_MORPEKO_HANGRY);
    set(SPECIES_MORPEKO_HANGRY, ABILITY_HUNGER_SWITCH, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_MORPEKO);
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 0, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_MORPEKO, ABILITY_NONE, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 1, 1);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Hunger Switch at the end of every turn.");""",
                  "newgold-hunger-", "src/battle/battle_controller_player.c"))
        extra = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateFieldConditionExtra")
        self.assertLess(extra.index("case UFCE_STATE_TRICK_ROOM:"), extra.index("case UFCE_STATE_HUNGER_SWITCH:"))
        self.assertIn("form = Battler_HungerSwitchForm(ctx, battlerId);", extra)


if __name__ == "__main__":
    unittest.main()
