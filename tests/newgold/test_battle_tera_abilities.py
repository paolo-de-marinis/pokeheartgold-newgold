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


def run(functions, body, prefix="", source=OVERLAY):
    text = source.read_text()
    program = PREFIX + prefix + "\n".join(function(text, name) for name in functions) + "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
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


SHELL_PREFIX = r"""
#include "constants/battle.h"
#include "constants/moves.h"
typedef uint8_t u8;
typedef int32_t s32;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u16 ability; s32 hp; u32 maxHp; } BattleMon;
typedef struct { BattleMon battleMons[4]; u8 teraShellResisting; BOOL moldBreaker; } BattleContext;
typedef struct { u8 category; } MoveTbl;
static MoveTbl sMoves[] = { [MOVE_TACKLE] = { CATEGORY_PHYSICAL }, [MOVE_EMBER] = { CATEGORY_SPECIAL },
                            [MOVE_THUNDER_WAVE] = { CATEGORY_STATUS } };
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) { (void)ctx; return &sMoves[move]; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) {
    (void)attacker;
    return !ctx->moldBreaker && ctx->battleMons[target].ability == ability;
}
static u32 MaskOfFlagNo(int flagNo) { return 1u << flagNo; }
static BattleContext ctx;
"""


class TeraShellTests(unittest.TestCase):
    def test_a_damaging_move_is_resisted_at_full_hp(self):
        print(run(["TeraShellResists"], prefix=SHELL_PREFIX, body=r"""
    ctx.battleMons[1] = (BattleMon){ ABILITY_TERA_SHELL, 100, 100 };
    assert(TeraShellResists(&ctx, 0, 1, MOVE_TACKLE));
    assert(TeraShellResists(&ctx, 0, 1, MOVE_EMBER));
    assert(!TeraShellResists(&ctx, 0, 1, MOVE_THUNDER_WAVE));
    ctx.moldBreaker = TRUE;
    assert(!TeraShellResists(&ctx, 0, 1, MOVE_TACKLE));
    ctx.moldBreaker = FALSE;
    ctx.battleMons[1].hp = 99;
    assert(!TeraShellResists(&ctx, 0, 1, MOVE_TACKLE));
    // The later hits of a move whose first hit it took.
    ctx.teraShellResisting = 1 << 1;
    assert(TeraShellResists(&ctx, 0, 1, MOVE_TACKLE));
    ctx.battleMons[1] = (BattleMon){ ABILITY_SHELL_ARMOR, 100, 100 };
    assert(!TeraShellResists(&ctx, 0, 1, MOVE_TACKLE));
    puts("PASS: Tera Shell at full HP, and for the rest of a move it took.");"""))

    def test_the_chart_and_the_line(self):
        source = OVERLAY.read_text()
        chart = function(source, "CalcTypeEffectiveness")
        shell = chart[chart.index("if (typeMul != 0 && TeraShellResists("):]
        self.assertIn("typeMul = 4;", shell[:shell.index("}")])
        self.assertLess(chart.index("TeraShellResists("), chart.index("*effectiveness = typeMul;"))
        self.assertIn("ctx->teraShellResisting = 0;", function(source, "BattleContext_Init"))
        flags = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224B498")
        self.assertIn("ctx->teraShellResisting |= MaskOfFlagNo(ctx->battlerIdTarget);", flags)
        self.assertIn("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_TERA_SHELL);", flags)


class TeraformZeroTests(unittest.TestCase):
    def test_the_first_entry_as_the_stellar_form_clears_the_field(self):
        state = entry_state("Teraform Zero")
        self.assertIn("done = &ctx->onceOnlyEntryAbilityDone[", state)
        self.assertIn("ctx->battleMons[battlerId].ability != ABILITY_TERAFORM_ZERO", state)
        self.assertIn("(ctx->battleMons[battlerId].status2 & STATUS2_TRANSFORM)", state)
        # Spent whether or not the gas lets it act.
        self.assertLess(state.index("*done = TRUE;"), state.index("GetBattlerAbility(ctx, battlerId) == ABILITY_TERAFORM_ZERO"))
        self.assertIn("(ctx->fieldCondition & FIELD_CONDITION_WEATHER) || ctx->terrainOverlayType != TERRAIN_NONE", state)
        self.assertIn("script = BATTLE_SUBSCRIPT_TERAFORM_ZERO;", state)

    def test_the_script_ends_each_weather_and_the_ground(self):
        script = (ROOT / "files/battledata/script/subscript/subscript_0415_TeraformZero.s").read_text()
        for weather, line in (("RAIN_ALL", "00803"), ("SANDSTORM_ALL", "00806"), ("SUN_ALL", "00809"),
                              ("HAIL_ALL", "00812"), ("SNOW_ALL", "01440"), ("FOG", "01470")):
            self.assertIn(f"FIELD_CONDITION_{weather}, _", script)
            self.assertIn(f"PrintMessage msg_0197_{line}, TAG_NONE", script)
        self.assertIn("UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER", script)
        self.assertIn("ResetParadoxAbility ABILITY_PROTOSYNTHESIS", script)
        self.assertIn("Call BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END", script)


if __name__ == "__main__":
    unittest.main()
