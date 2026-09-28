#!/usr/bin/env python3
"""Run Metronome's roll and the calling moves' ban list with host sanitizers.

BtlCmd_Metronome, CheckLegalCalledMove, CheckLegalMimicMove and the list
they share are extracted from the port's C and driven with a scripted random
number: Metronome, Mimic, Copycat and Assist each refuse their run of it.
Where the reference checkout is present, Metronome's and Mimic's runs are
also compared by move name with the engine's list at d0380a487.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function
from test_repels import REFERENCE, revision

ENGINE_COMMIT = "d0380a487"
COMMAND = ROOT / "src/battle/battle_command.c"
OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { int unused; } BattleSystem;
typedef struct {
    struct { u16 moves[MAX_MON_MOVES]; } battleMons[4];
    int battlerIdAttacker;
    u16 moveTemp;
} BattleContext;

static u16 rolls[8];
static int rollCount;
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; assert(rollCount < 8); return rolls[rollCount++]; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
@NATIVE@

static BOOL metronomeCalls(u16 move) {
    return CheckLegalCalledMove(move, 0, CALLED_MOVE_BANS_COPYCAT);
}
static BOOL copycatCopies(u16 move) {
    return CheckLegalCalledMove(move, CALLED_MOVE_BANS_MIMIC, CALLED_MOVE_BANS_ASSIST);
}
static BOOL assistCalls(u16 move) {
    return CheckLegalCalledMove(move, CALLED_MOVE_BANS_MIMIC, CALLED_MOVE_BANS_END);
}

// The move Metronome calls when the first roll is `roll` and every later one
// lands on Pound.
static u16 metronome(u16 roll) {
    BattleSystem bs = {0};
    BattleContext ctx = {0};
    rolls[0] = roll;
    for (int i = 1; i < 8; i++) rolls[i] = MOVE_POUND - 1;
    rollCount = 0;
    BtlCmd_Metronome(&bs, &ctx);
    return ctx.moveTemp;
}

int main(void) {
    BattleSystem bs = {0};
    BattleContext ctx = {0};

    // Every move up to the last one can come out, and nothing past it.
    int reached = 0;
    for (u32 roll = 0; roll < NUM_MOVES_TOTAL; roll++) {
        u16 move = roll + 1;
        if (metronomeCalls(move)) {
            assert(metronome(roll) == move);
            reached++;
        }
    }
    // Scarlet and Violet's refusals: Revival Blessing, Population Bomb, Shed
    // Tail and the rest of Metronomo's column SV, Springtide Storm and the
    // torques by Showdown's gen-9 data; Dragon Hammer comes out.
    static const u16 scarletViolet[] = {
        MOVE_REVIVAL_BLESSING, MOVE_POPULATION_BOMB, MOVE_SHED_TAIL, MOVE_SALT_CURE, MOVE_DOODLE, MOVE_TWIN_BEAM,
        MOVE_SPRINGTIDE_STORM, MOVE_BLAZING_TORQUE, MOVE_TERA_STARSTORM, MOVE_COLLISION_COURSE,
    };
    for (unsigned i = 0; i < sizeof(scarletViolet) / sizeof(scarletViolet[0]); i++) {
        assert(!metronomeCalls(scarletViolet[i]));
    }
    assert(metronome(MOVE_REVIVAL_BLESSING - 1) == MOVE_POUND);
    assert(metronome(MOVE_DRAGON_HAMMER - 1) == MOVE_DRAGON_HAMMER);
    // Copycat copies Revival Blessing and Population Bomb all the same.
    assert(copycatCopies(MOVE_REVIVAL_BLESSING) && copycatCopies(MOVE_POPULATION_BOMB));
    // Sky Drop comes out, as it did in the games that had it.
    assert(metronome(MOVE_SKY_DROP - 1) == MOVE_SKY_DROP);
    assert(metronome(NUM_MOVES_TOTAL) == MOVE_POUND);
    assert(metronome(NUM_MOVES_TOTAL - 1) == MOVE_MALIGNANT_CHAIN);
    assert(metronome(MOVE_SOLAR_SEEDS - 1) == MOVE_SOLAR_SEEDS);
    assert(reached > NUM_MOVES);

    // Banned for both: retail's own, the engine's Z- and Max moves and
    // placeholders, and what Scarlet and Violet's Mimic refuses (Mimica,
    // Showdown's gen-9 failmimic).
    static const u16 both[] = {
        MOVE_METRONOME, MOVE_STRUGGLE, MOVE_SKETCH, MOVE_MIMIC, MOVE_CHATTER,
        MOVE_BEHEMOTH_BLADE, MOVE_BREAKNECK_BLITZ_PHYSICAL, MOVE_CATASTROPIKA,
        MOVE_MAX_GUARD, MOVE_MAX_STEELSPIKE, MOVE_468, MOVE_470,
        MOVE_SLEEP_TALK, MOVE_ASSIST, MOVE_COPYCAT, MOVE_ME_FIRST, MOVE_NATURE_POWER, MOVE_TRANSFORM,
        MOVE_BELCH, MOVE_CELEBRATE, MOVE_HOLD_HANDS, MOVE_TERA_STARSTORM, MOVE_BLAZING_TORQUE, MOVE_WICKED_TORQUE,
    };
    for (unsigned i = 0; i < sizeof(both) / sizeof(both[0]); i++) {
        assert(!metronomeCalls(both[i]) && !copycatCopies(both[i]) && !assistCalls(both[i]));
        assert(!CheckLegalMimicMove(both[i]));
    }

    // Banned for Metronome alone: Mimic can still copy them -- Mirror Move
    // among them (Mimica), and Double Iron Bash and the Let's Go moves, which
    // Copycat copies and Assist calls too.
    static const u16 metronomeOnly[] = {
        MOVE_PROTECT, MOVE_COUNTER, MOVE_SWITCHEROO, MOVE_MIRROR_MOVE,
        MOVE_AFTER_YOU, MOVE_COLLISION_COURSE, MOVE_WIDE_GUARD, MOVE_ASTRAL_BARRAGE,
        MOVE_DOUBLE_IRON_BASH, MOVE_ZIPPY_ZAP,
    };
    for (unsigned i = 0; i < sizeof(metronomeOnly) / sizeof(metronomeOnly[0]); i++) {
        assert(!metronomeCalls(metronomeOnly[i]));
        assert(CheckLegalMimicMove(metronomeOnly[i]));
    }

    // Copycat's and Assist's own: not Metronome's further bans, which both
    // call; the switching moves, which neither does; and the moves that take
    // their user out of sight, which Assist alone does not call, as Mirror
    // Coat (Copione, Assistente; Showdown's gen-9 failcopycat and noassist).
    static const u16 bothCall[] = {
        MOVE_AFTER_YOU, MOVE_V_CREATE, MOVE_SNARL, MOVE_FREEZE_SHOCK, MOVE_ASTRAL_BARRAGE, MOVE_DOUBLE_IRON_BASH, MOVE_VEEVEE_VOLLEY,
    };
    for (unsigned i = 0; i < sizeof(bothCall) / sizeof(bothCall[0]); i++) {
        assert(!metronomeCalls(bothCall[i]) && copycatCopies(bothCall[i]) && assistCalls(bothCall[i]));
    }
    static const u16 neitherCalls[] = {
        MOVE_ROAR, MOVE_WHIRLWIND, MOVE_DRAGON_TAIL, MOVE_CIRCLE_THROW, MOVE_BURNING_BULWARK, MOVE_TERA_STARSTORM,
        MOVE_BLAZING_TORQUE, MOVE_WICKED_TORQUE, MOVE_PROTECT, MOVE_KINGS_SHIELD, MOVE_TRANSFORM, MOVE_METRONOME,
        MOVE_CATASTROPIKA,
    };
    for (unsigned i = 0; i < sizeof(neitherCalls) / sizeof(neitherCalls[0]); i++) {
        assert(!copycatCopies(neitherCalls[i]) && !assistCalls(neitherCalls[i]));
    }
    static const u16 assistRefuses[] = {
        MOVE_FLY, MOVE_DIG, MOVE_DIVE, MOVE_BOUNCE, MOVE_SHADOW_FORCE, MOVE_PHANTOM_FORCE, MOVE_SKY_DROP, MOVE_MIRROR_COAT,
    };
    for (unsigned i = 0; i < sizeof(assistRefuses) / sizeof(assistRefuses[0]); i++) {
        assert(copycatCopies(assistRefuses[i]) && !assistCalls(assistRefuses[i]));
    }
    assert(metronomeCalls(MOVE_ROAR) && metronomeCalls(MOVE_FLY) && !metronomeCalls(MOVE_MIRROR_COAT));
    assert(!copycatCopies(MOVE_COLLISION_COURSE));

    // What Gravity or Heal Block would stop is called by all three, and fails
    // as it is used, from the fifth generation (Metronomo); retail refused it.
    static const u16 stopped[] = { MOVE_FLY, MOVE_SPLASH, MOVE_HIGH_JUMP_KICK, MOVE_RECOVER, MOVE_ROOST, MOVE_DRAIN_PUNCH };
    for (unsigned i = 0; i < sizeof(stopped) / sizeof(stopped[0]); i++) {
        assert(metronomeCalls(stopped[i]) && copycatCopies(stopped[i]));
    }
    assert(assistCalls(MOVE_SPLASH) && assistCalls(MOVE_RECOVER));

    // And the ordinary moves stay open to all.
    static const u16 open[] = { MOVE_POUND, MOVE_SURF, MOVE_ACROBATICS, MOVE_MOONBLAST, MOVE_MALIGNANT_CHAIN };
    for (unsigned i = 0; i < sizeof(open) / sizeof(open[0]); i++) {
        assert(metronomeCalls(open[i]) && copycatCopies(open[i]) && assistCalls(open[i]));
        assert(CheckLegalMimicMove(open[i]));
    }
    return 0;
}
'''


def ban_list(text, start):
    body = text[text.index(start):]
    body = body[:body.index("};")]
    names = re.findall(r"\bMOVE_\w+|0xFFF[EF]", body)
    split = names.index("0xFFFE")
    return set(names[:split]), set(names[split + 1:]) - {"0xFFFF"}


def port_ban_runs(text):
    """Mimic's block, and the rest of Metronome's run, of the port's list."""
    body = text[text.index("sMetronomeUnuseableMoves[]"):]
    body = body[:body.index("};")]
    names = re.findall(r"\bMOVE_\w+|CALLED_MOVE_BANS_\w+", body)
    mimic = names[names.index("CALLED_MOVE_BANS_MIMIC") + 1:names.index("CALLED_MOVE_BANS_SHARED")]
    metronome = [name for name in names[:names.index("CALLED_MOVE_BANS_COPYCAT")] if not name.startswith("CALLED_")]
    return set(mimic), set(metronome) - set(mimic)


# The moves Scarlet and Violet's Metronome does not call and the engine's list
# does not name: Metronomo's table, column SV, row by row, and Springtide
# Storm and the torques by Showdown's gen-9 data.
SCARLET_VIOLET = {"MOVE_" + name for name in (
    "ARMOR_CANNON CHILLING_WATER CHILLY_RECEPTION COLLISION_COURSE COMEUPPANCE DOODLE DOUBLE_SHOCK ELECTRO_DRIFT "
    "FILLET_AWAY HYPER_DRILL JET_PUNCH MAKE_IT_RAIN ORDER_UP POPULATION_BOMB POUNCE POWER_SHIFT RAGE_FIST RAGING_BULL "
    "RAGING_FURY REVIVAL_BLESSING RUINATION SALT_CURE SHED_TAIL SILK_TRAP SNOWSCAPE SPICY_EXTRACT TERA_STARSTORM "
    "TIDY_UP TRAILBLAZE TWIN_BEAM SPRINGTIDE_STORM BLAZING_TORQUE COMBAT_TORQUE MAGICAL_TORQUE NOXIOUS_TORQUE "
    "WICKED_TORQUE").split()}


# What Scarlet and Violet's Mimic refuses that the engine's Mimic copied, and
# what it copies that the engine's refused.
MIMIC_REFUSES = {"MOVE_" + name for name in (
    "SLEEP_TALK ASSIST COPYCAT ME_FIRST NATURE_POWER TRANSFORM BELCH CELEBRATE HOLD_HANDS TERA_STARSTORM "
    "BLAZING_TORQUE COMBAT_TORQUE MAGICAL_TORQUE NOXIOUS_TORQUE WICKED_TORQUE").split()}
MIMIC_COPIES = {"MOVE_" + name for name in (
    "ZIPPY_ZAP SPLISHY_SPLASH FLOATY_FALL PIKA_PAPOW BOUNCY_BUBBLE BUZZY_BUZZ SIZZLY_SLIDE GLITZY_GLOW BADDY_BAD "
    "SAPPY_SEED FREEZY_FROST SPARKLY_SWIRL VEEVEE_VOLLEY DOUBLE_IRON_BASH").split()}


class MetronomeTests(unittest.TestCase):
    def test_metronome_reaches_every_move_but_the_banned(self):
        overlay = OVERLAY.read_text()
        table = overlay[overlay.index("static const u16 sMetronomeUnuseableMoves[]"):]
        table = table[:table.index("};") + 2]
        native = "\n".join([
            table,
            function(overlay, "CheckLegalCalledMove"),
            function(overlay, "CheckLegalMimicMove"),
            function(COMMAND.read_text(), "BtlCmd_Metronome"),
        ])
        with tempfile.TemporaryDirectory(prefix="newgold-metronome-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_list_is_the_engines_by_name(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        engine = revision(REFERENCE, ENGINE_COMMIT, "src/battle/other_battle_calculators.c")
        both, metronome = ban_list(engine, "u16 sMetronomeMimicMoveBanList[]")
        port_both, port_metronome = port_ban_runs(OVERLAY.read_text())
        # Mimic's block is the engine's, less what Scarlet and Violet's Mimic
        # copies and more of what it refuses (Mimica, Showdown's gen-9
        # failmimic): moved from the rest of Metronome's run, not added to it.
        self.assertEqual(port_both, (both - MIMIC_COPIES) | MIMIC_REFUSES)
        self.assertLessEqual(MIMIC_REFUSES, metronome | SCARLET_VIOLET)
        # Metronome's whole run is the engine's with Scarlet and Violet's
        # refusals (Metronomo's table, Showdown's gen-9 data), and Dragon
        # Hammer, which the engine refuses, is called.
        self.assertEqual(port_both | port_metronome, (both | metronome | SCARLET_VIOLET) - {"MOVE_DRAGON_HAMMER"})


if __name__ == "__main__":
    unittest.main()
