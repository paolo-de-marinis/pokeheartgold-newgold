#!/usr/bin/env python3
"""The abilities of the Terastal forms, which are species here.

This game has no Terastallization, so the Terastal forms of Ogerpon and
Terapagos are species a Pokemon either is or is not. What the later games do
when one Terastallizes is done here when one comes into the battle as that
form. The rules are extracted from src/battle and compiled natively; the places
that act on them are read from the source.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_battle_form_changes import run as run_with_battlers
from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"

PREFIX = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/pokemon.h"
typedef uint16_t u16;
"""


def run(functions, body, source=OVERLAY):
    text = source.read_text()
    program = PREFIX + "\n".join(function(text, name) for name in functions) + "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
    with tempfile.TemporaryDirectory(prefix="newgold-tera-") as directory:
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


def entry_state(title):
    body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
    start = body.index(f"// {title}")
    return body[start:body.index("        case ", start)]


class EmbodyAspectTests(unittest.TestCase):
    def test_each_mask_raises_its_own_stat(self):
        print(run(["EmbodyAspectStat"], r"""
    assert(EmbodyAspectStat(ABILITY_EMBODY_ASPECT) == STAT_SPEED);
    assert(EmbodyAspectStat(ABILITY_EMBODY_ASPECT_2) == STAT_SPDEF);
    assert(EmbodyAspectStat(ABILITY_EMBODY_ASPECT_3) == STAT_ATK);
    assert(EmbodyAspectStat(ABILITY_EMBODY_ASPECT_4) == STAT_DEF);
    assert(EmbodyAspectStat(ABILITY_INTREPID_SWORD) == STAT_HP);
    puts("PASS: Teal Speed, Wellspring Sp. Def, Hearthflame Attack, Cornerstone Defense.");"""))

    def test_it_raises_the_stat_on_the_way_in(self):
        state = entry_state("Embody Aspect")
        self.assertIn("j = EmbodyAspectStat(GetBattlerAbility(ctx, battlerId));", state)
        self.assertIn("(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)", state)
        self.assertIn("ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;", state)
        self.assertIn("ctx->battleMons[battlerId].statChanges[j] >= 12", state)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + j - STAT_ATK;", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE;", state)


class TeraShiftTests(unittest.TestCase):
    def test_a_terapagos_takes_its_terastal_form(self):
        """Only a Terapagos that has the ability and has not Transformed, and
        only from its Normal Form."""
        print(run_with_battlers(["Battler_TeraShiftForm"], r"""
    set(SPECIES_TERAPAGOS, ABILITY_TERA_SHIFT, 100, 100);
    assert(Battler_TeraShiftForm(&ctx, 0) == SPECIES_TERAPAGOS_TERASTAL);
    set(SPECIES_TERAPAGOS_TERASTAL, ABILITY_TERA_SHELL, 100, 100);
    assert(Battler_TeraShiftForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_TERAPAGOS, ABILITY_NONE, 100, 100);
    assert(Battler_TeraShiftForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_TERAPAGOS, ABILITY_TERA_SHIFT, 100, 100);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_TeraShiftForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Tera Shift turns a Terapagos Terastal on the way in.");""", "newgold-terashift-"))

    def test_it_comes_first_with_its_hp(self):
        body = function(OVERLAY.read_text(), "TryAbilityOnEntry")
        first = body[body.index("case 0:"):body.index("case 1:")]
        self.assertIn("j = Battler_TeraShiftForm(ctx, battlerId);", first)
        self.assertLess(first.index("Battler_TeraShiftForm"), first.index("weatherCheckFlag"))
        self.assertIn("ctx->hpCalc = ctx->battleMons[battlerId].maxHp - maxHp;", first)
        self.assertIn("script = BATTLE_SUBSCRIPT_TERA_SHIFT;", first)
        script = (ROOT / "files/battledata/script/subscript/subscript_0413_TeraShift.s").read_text()
        self.assertLess(script.index("Call BATTLE_SUBSCRIPT_FORM_CHANGE"), script.index("Call BATTLE_SUBSCRIPT_UPDATE_HP"))


if __name__ == "__main__":
    unittest.main()
