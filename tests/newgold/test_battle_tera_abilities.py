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


if __name__ == "__main__":
    unittest.main()
