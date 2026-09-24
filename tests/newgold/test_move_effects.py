#!/usr/bin/env python3
"""Check that an added move is a move and not just a name.

A move is four things that have to agree: a record in the table, a name and a
description in the message banks, a script the battle jumps to, and an
animation. Any one of them missing gives a move that exists on the summary
screen and then does nothing, or worse, runs whatever happens to sit at that
index. Those are the assertions below.

The last part is not structural. In the reference much of what makes an
added move special lives in C rather than in its script -- a list the move is
failed by, a check after it lands, a critical hit it cannot miss -- and a
script imported without that C looks finished. Every added effect the
reference's C reads by name is either read by the C here or named in
UNREAD_HERE with the reason, and that table only ever shrinks.
"""

import io
import re
import struct
import subprocess
import tarfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE, function

NEWGOLD = "1fa3c9366"  # konefr's tip, the engine under it included

MOVES_H = ROOT / "include/constants/moves.h"
EFFECTS_H = ROOT / "include/constants/move_effects.h"
IMPORTS_H = ROOT / "include/constants/battle_script_imports.h"
EFFECT_SCRIPTS = ROOT / "files/battledata/script/effect_script"
MOVE_SCRIPTS = ROOT / "files/battledata/script/move_script"
TABLE = ROOT / "files/poketool/waza/waza_tbl.narc"
RECORD = "<HBBBBBBHbBBBH"
RECORD_SIZE = 16

# The last effect this game had before the reference's were imported. Below
# it an effect is retail's, and whatever C it needs is retail's C, here.
LAST_BEFORE_IMPORT = 286


def moves():
    text = MOVES_H.read_text()
    return {name: int(number) for name, number in
            re.findall(r"#define MOVE_([A-Z0-9_]+)\s+(\d+)\s*$", text, re.M)}


def bounds():
    text = MOVES_H.read_text()
    names = moves()
    return (names[re.search(r"#define NUM_MOVES\s+MOVE_([A-Z0-9_]+)", text).group(1)],
            names[re.search(r"#define NUM_MOVES_TOTAL MOVE_([A-Z0-9_]+)", text).group(1)])


def records():
    data = TABLE.read_bytes()
    count = struct.unpack("<H", data[0x18:0x1A])[0]
    offsets = [struct.unpack("<II", data[0x1C + 8 * i:0x24 + 8 * i]) for i in range(count)]
    gmif = data.index(b"GMIF") + 8
    return [struct.unpack(RECORD, data[gmif + start:gmif + end]) for start, end in offsets]


def rows(bank):
    return {int(index) for index in re.findall(
        r'<row id="[^"]+" index="(\d+)">', (ROOT / f"files/msgdata/msg/{bank}.gmm").read_text())}


def by_number(directory):
    """The scripts in a directory, by the number that fetches them."""
    return {int(re.search(r"_(\d+)", path.name).group(1)): path
            for path in directory.glob("*.s")}


def script_numbers(directory):
    return sorted(by_number(directory))


class MoveTableTests(unittest.TestCase):
    def setUp(self):
        self.records = records()
        self.last_vanilla, self.last = bounds()

    def test_the_table_reaches_every_move(self):
        self.assertGreater(len(self.records), self.last)

    def test_no_move_is_a_hole(self):
        for name, number in moves().items():
            if 0 < number <= self.last:
                fields = self.records[number]
                self.assertTrue(fields[5], f"MOVE_{name} has no PP, which means no record")

    def test_every_move_has_a_name_and_a_description(self):
        for bank in ("msg_0749", "msg_0750", "msg_0751"):
            have = rows(bank)
            for name, number in moves().items():
                if 0 < number <= self.last:
                    self.assertIn(number, have, f"MOVE_{name} has no row in {bank}")

    def test_every_move_has_a_script_to_jump_to(self):
        have = set(script_numbers(MOVE_SCRIPTS))
        for name, number in moves().items():
            if 0 < number <= self.last:
                self.assertIn(number, have, f"MOVE_{name} has no move script")

    def test_every_added_move_borrows_an_animation(self):
        source = (ROOT / "src/battle/battle_command.c").read_text()
        borrowed = re.search(r"borrowed\[NUM_ADDED_MOVES\] = \{(.*?)\n    \};", source, re.S).group(1)
        self.assertEqual(len(re.findall(r"MOVE_[A-Z0-9_]+", borrowed)),
                         self.last - self.last_vanilla)


class EffectScriptTests(unittest.TestCase):
    """The battle jumps into the archive by the effect's number, so the files
    have to be dense and the numbers have to stop where the files do."""

    def setUp(self):
        self.numbers = script_numbers(EFFECT_SCRIPTS)
        self.defines = {name: int(number) for name, number in re.findall(
            r"#define MOVE_EFFECT_([A-Z0-9_]+)\s+(\d+)\s*$", EFFECTS_H.read_text(), re.M)}

    def test_the_files_are_numbered_without_a_gap(self):
        self.assertEqual(self.numbers, list(range(len(self.numbers))))

    def test_no_effect_points_past_the_last_script(self):
        self.assertEqual(max(self.defines.values()), len(self.numbers) - 1)

    def test_every_move_names_an_effect_that_exists(self):
        last = bounds()[1]
        for number, fields in enumerate(records()):
            if 0 < number <= last:
                self.assertLess(fields[0], len(self.numbers),
                                f"move {number} wants effect script {fields[0]}")


def reaches_for_what_is_not_here():
    """The effects whose script mentions something only the imports header
    names -- a terrain, a Drive, a Memory -- so the branch never fires."""
    if not IMPORTS_H.exists():
        return set()
    names = set(re.findall(r"#define\s+([A-Z][A-Z0-9_]*)", IMPORTS_H.read_text()))
    return {number for number, path in by_number(EFFECT_SCRIPTS).items()
            if number > LAST_BEFORE_IMPORT
            and names & set(re.findall(r"\b[A-Z][A-Z0-9_]{3,}\b", path.read_text()))}


def without_comments(source):
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", source, flags=re.S)


def effects_read_in(sources):
    """Every MOVE_EFFECT_ name a body of C reads, comments left out."""
    return {name for source in sources
            for name in re.findall(r"\bMOVE_EFFECT_([A-Z0-9_]+)\b", without_comments(source))}


def added_effects():
    return {name for name, number in re.findall(
        r"#define MOVE_EFFECT_([A-Z0-9_]+)\s+(\d+)\s*$", EFFECTS_H.read_text(), re.M)
        if int(number) > LAST_BEFORE_IMPORT}


def read_here():
    return effects_read_in(path.read_text(errors="replace") for path in sorted((ROOT / "src").rglob("*.c")))


def read_in_the_reference():
    """The same question of konefr's tip, read with git rather than from the
    working checkout, so it does not move with whatever is checked out."""
    archive = subprocess.run(["git", "-C", str(REFERENCE), "archive", NEWGOLD, "src"],
                             capture_output=True, check=True).stdout
    with tarfile.open(fileobj=io.BytesIO(archive)) as tar:
        return effects_read_in(tar.extractfile(member).read().decode(errors="replace")
                               for member in tar.getmembers()
                               if member.isfile() and member.name.endswith(".c"))


# Every added effect the reference's C reads by name and no C here does, with
# why. The shape of a script used to stand in for this -- an effect whose
# script was more than a bare hit counted as done -- and that is not a
# question about the effect: removing every line of C behind a script left
# the count at zero. So these are named, one by one, against the reference's
# own reads. What the reasons mean:
#   script      the effect script or its subscript does what that C does
#   data        the move record answers it in this engine
#   unused      no move here has the effect
#   not ported  it is not here; what the game does instead is said
# An effect whose C gets written here leaves the table; nothing may join it.
UNREAD_HERE = {
    "ATK_ACC_UP": "script: subscript 355 refuses when both stats are at +6, the reference's up-front check",
    "GUARD_SPLIT": "script: effect script 288 fails behind a substitute, as the reference's substitute list does",
    "POWER_SPLIT": "script: effect script 289 fails behind a substitute, as the reference's substitute list does",
    "ALWAYS_CRITICAL": "script: it asks for CRITICAL_STAGE_ALWAYS, which CalcCrit reads as a sure critical",
    "CHANGE_TO_WATER_TYPE": "script: subscript 351 fails behind a substitute, as the reference's substitute list does",
    "SPEED_UP_2_ATK_UP": "script: subscript 350 refuses when both stats are at +6, the reference's up-front check",
    "ATK_SP_ATK_SPEED_UP_2_DEF_SP_DEF_DOWN": "script: each stat change in subscript 349 refuses at the limit",
    "CONFUSE_HIT_CRASH_ON_MISS": "script: it sets the crash flag and Reckless's boost itself",
    "ATK_SP_ATK_UP": "script: subscript 346 refuses when both stats are at +6, the reference's up-front check",
    "ATK_SP_ATK_SPEED_UP_2": "unused",
    "SHED_TAIL": "script: subscript 343 makes the decoy and switches the user out through Baton Pass's switch",
    "QUASH": "script: subscript 341 fails behind a substitute, as the reference's substitute list does",
    "SET_ABILITY_TO_SIMPLE": "script: subscript 338 fails behind a substitute itself",
    "ATK_UP_3": "unused",
    "DEF_UP_3": "script: the stat-stage subscript refuses at +6",
    "SPEED_UP_3": "unused",
    "SP_ATK_UP_3": "script: the stat-stage subscript refuses at +6",
    "SP_DEF_UP_3": "unused",
    "ATK_DOWN_3": "unused",
    "DEF_DOWN_3": "unused",
    "SPEED_DOWN_3": "unused",
    "SP_ATK_DOWN_3": "unused",
    "SP_DEF_DOWN_3": "unused",
    "HIT_THREE_TIMES_ALWAYS_CRITICAL": "script: it asks for CRITICAL_STAGE_ALWAYS on every hit, which CalcCrit reads as a sure critical",
    "ADD_TYPE_GRASS": "script: subscript 325 fails behind a substitute, as the reference's substitute list does",
    "ADD_TYPE_GHOST": "script: subscript 324 fails behind a substitute, as the reference's substitute list does",
    "CHANGE_TO_PSYCHIC_TYPE": "script: subscript 323 fails behind a substitute, as the reference's substitute list does",
    "COACHING": "script: effect script 383 fails it in a single battle or with no partner standing",
    "DECORATE": "script: subscript 314 does not affect a target behind a substitute, the reference's stat-drop list",
    "FORCE_SWITCH_HIT": "script: a CHECK_HP_AND_SUBSTITUTE side effect runs Whirlwind's subscript after the damage",
    "STUFF_CHEEKS": "script: effect script 398 fails it without a berry and subscript 311 refuses it at +6 Defense",
    "IGNORE_PROTECT": "data: Mighty Cleave's record has the protect bit clear, which is what Protect reads here",
}


class WhatIsStillMissingTests(unittest.TestCase):
    # A ratchet, not a target: the table above may only shrink.
    STILL_UNREAD = 37

    def test_the_table_only_ever_shrinks(self):
        self.assertLessEqual(
            len(UNREAD_HERE), self.STILL_UNREAD,
            "an added effect joined UNREAD_HERE; write the C the reference has, "
            "or lower nothing and say here why the table grew")

    def test_every_entry_says_why(self):
        for name, reason in UNREAD_HERE.items():
            self.assertRegex(reason, r"^(script|data|unused|not ported)\b", name)
            self.assertIn(name, added_effects(), f"MOVE_EFFECT_{name} is not an added effect")

    def test_an_effect_read_here_leaves_the_table(self):
        here = read_here()
        for name in sorted(UNREAD_HERE):
            self.assertNotIn(name, here, f"MOVE_EFFECT_{name} is read by the C here now; take it out of UNREAD_HERE")

    def test_an_unused_effect_is_unused(self):
        used = {fields[0] for number, fields in enumerate(records()) if 0 < number <= bounds()[1]}
        numbers = {name: int(number) for name, number in re.findall(
            r"#define MOVE_EFFECT_([A-Z0-9_]+)\s+(\d+)\s*$", EFFECTS_H.read_text(), re.M)}
        for name, reason in UNREAD_HERE.items():
            if reason == "unused":
                self.assertNotIn(numbers[name], used, f"a move has MOVE_EFFECT_{name} now")

    @unittest.skipIf(REFERENCE is None, "behaviour reference not present")
    def test_every_effect_the_reference_reads_is_read_here_or_named(self):
        missing = (added_effects() & read_in_the_reference()) - read_here()
        self.assertEqual(missing, set(UNREAD_HERE),
                         "the reference's C reads these added effects and the C here does not")

    def test_no_script_reaches_for_a_placeholder(self):
        self.assertEqual(reaches_for_what_is_not_here(), set())


class PartingShotTests(unittest.TestCase):
    """Parting Shot lowers its target's Attack and Sp. Atk and then its user
    goes back, as U-turn's does (Pokemon Central, Monito); since the seventh
    generation only when a stat was changed. The reference runs the switch
    from its post-move steps (Activate_Switch and subscript 469 at
    d0380a487); here the stats fell and the user stayed."""

    def test_the_user_goes_back_once_the_move_is_over(self):
        from test_hold_effects import CONTROLLER
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        step = body[body.index("MOVE_EFFECT_PARTING_SHOT"):]
        step = step[:step.index("break;")]
        self.assertIn("((ctx->statLoweredBattlers | ctx->statRaisedBattlers) & MaskOfFlagNo(lowered))", step)
        self.assertIn("!(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)", step)
        self.assertIn("ReadBattleScriptFromNarc(ctx, NARC_a_0_0_1, BATTLE_SUBSCRIPT_HANDLE_PARTING_SHOT);", step)
        # A user that left with its move does not spray its throat, and a
        # Parting Shot is not answered by the target's Eject Pack.
        self.assertIn("ctx->unk_34 = SWITCH_ITEM_USED;", step)
        self.assertLess(body.index("MOVE_EFFECT_PARTING_SHOT"), body.index("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE"))
        self.assertLess(body.index("MOVE_EFFECT_PARTING_SHOT"), body.index("CheckEjectPack"))

    def test_a_bounced_parting_shot_sends_the_bouncer_back(self):
        # Pokemon Central (Monito) and the reference's own battle test
        # (parting_shot/magic_bounce.c): Magic Coat or Magic Bounce turns the
        # drops on the user and switches the bouncer out. Who goes is passed
        # to the script, which switches that Pokemon rather than the attacker.
        from test_hold_effects import CONTROLLER
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        step = body[body.index("MOVE_EFFECT_PARTING_SHOT"):]
        step = step[:step.index("break;")]
        self.assertRegex(step, r"if \(ctx->battlerIdMagicCoat != BATTLER_NONE\) \{\s*leaver = ctx->battlerIdTarget;\s*lowered = ctx->battlerIdAttacker;")
        self.assertIn("ctx->battleMons[leaver].hp != 0", step)
        self.assertIn("ctx->battlerIdTemp = leaver;", step)
        self.assertIn("ctx->battlerIdMagicCoat = BATTLER_NONE;", function(CONTROLLER.read_text(), "ov12_02249460"))
        self.assertIn("ctx->battlerIdMagicCoat = battlerId;", function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_MagicCoat"))

    def test_a_contrary_target_s_rise_counts_as_a_change(self):
        # Pokemon Central (Monito): the user stays only when the move changed
        # neither stat -- a Contrary target at +6 in both among the cases -- so
        # a rise the ability turned the drops into sends it out. The rises are
        # written down as the drops are, for the action being taken.
        from test_hold_effects import CONTROLLER, COMMANDS, OVERLAY
        change = function(COMMANDS.read_text(), "BtlCmd_ChangeStatStage")
        increase = change[change.index("if (change > 0) { // Stat Increase"):change.index("} else { // Stat Decrease")]
        self.assertIn("ctx->statRaisedBattlers |= MaskOfFlagNo(ctx->battlerIdStatChange);", increase)
        self.assertIn("ctx->statRaisedBattlers = 0;", function(CONTROLLER.read_text(), "ov12_02249460"))
        self.assertIn("ctx->statRaisedBattlers &= ~MaskOfFlagNo(battlerId);",
                      function(OVERLAY.read_text(), "BattleSystem_GetBattleMon"))

    def test_the_script_switches_the_user_out(self):
        from test_hold_effects import subscript_named, walk
        script = subscript_named("BATTLE_SUBSCRIPT_HANDLE_PARTING_SHOT")
        self.assertEqual(walk(script, {}.get), [])
        self.assertEqual(walk(script, {"REPLACEMENT": True}.get),
                         ["BATTLE_SUBSCRIPT_PURSUIT", "BATTLE_SUBSCRIPT_SHOW_PARTY_LIST"])
        self.assertEqual(walk(script, {"REPLACEMENT": True, "BMON_DATA_HP": 0}.get), ["BATTLE_SUBSCRIPT_PURSUIT"])
        # Who goes is passed in MSG_BATTLER_TEMP and named as the switched
        # Pokemon before anything else, Pursuit's hit taking the temp over.
        self.assertTrue(script.split("_000:")[1].lstrip().startswith(
            "UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_MSG_BATTLER_TEMP"))
        self.assertNotIn("BATTLER_CATEGORY_ATTACKER", script)
        self.assertNotIn("BATTLER_CATEGORY_MSG_BATTLER_TEMP", script)
        gone = script[script.index("DeletePokemon BATTLER_CATEGORY_SWITCHED_MON"):script.index("GoToSubscript")]
        self.assertIn("BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN", gone)
        # Only the attacker leaving is U-turn's case.
        self.assertLess(gone.index("CompareVarToVar OPCODE_NEQ, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_BATTLER_ATTACKER, _NOT_THE_ATTACKER"),
                        gone.index("BATTLE_STATUS2_UTURN"))


class PriorityTests(unittest.TestCase):
    """The move importer once read a priority's digits and dropped its sign:
    Circle Throw and Dragon Tail went last in every other game and first here."""

    def test_negative_priorities_keep_their_sign(self):
        import struct
        data = (ROOT / "files/poketool/waza/waza_tbl.narc").read_bytes()
        count = struct.unpack_from("<H", data, 0x18)[0]
        spans = [struct.unpack_from("<II", data, 0x1C + 8 * i) for i in range(count)]
        body = data.index(b"GMIF") + 8
        moves = {m.group(1): int(m.group(2)) for m in re.finditer(r"#define (MOVE_[A-Z0-9_]+)\s+(\d+)\s*$",
                 (ROOT / "include/constants/moves.h").read_text(), re.M)}
        for name, want in (("MOVE_CIRCLE_THROW", -6), ("MOVE_DRAGON_TAIL", -6), ("MOVE_ROAR", -6),
                           ("MOVE_BEAK_BLAST", -3), ("MOVE_SHELL_TRAP", -3), ("MOVE_QUICK_ATTACK", 1)):
            start, _ = spans[moves[name]]
            priority = struct.unpack_from("<b", data, body + start + 10)[0]
            self.assertEqual(priority, want, name)


HOLD_AFTER_HIT = r"""
#include <assert.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/moves.h"
typedef struct { u16 effect; } MoveTbl;
typedef struct { int physicalDamage, specialDamage; } SelfTurnData;
typedef struct { int hp; u32 status2; int holdEffect, cameIn, ability; } Mon;
typedef struct {
    Mon battleMons[4]; SelfTurnData selfTurnData[4]; u8 turnOrder[4];
    int battlerIdAttacker, battlerIdStatChange;
    u32 moveNoCur;
} BattleContext;
static MoveTbl move;
static BOOL sheerForce;
static int ran;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &move; }
static BOOL Battler_CameInAfterTheHit(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].cameIn; }
static BOOL SheerForceTradedEffect(BattleContext *ctx) { (void)ctx; return sheerForce; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].holdEffect; }
static BOOL moldBreaker;
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int battlerId, int ability) {
    (void)attacker;
    return !moldBreaker && ctx->battleMons[battlerId].ability == ability;
}
static void RunPostMoveScript(BattleContext *ctx, int script) { (void)ctx; ran = script; }
@FUNCTIONS@
static BattleContext ctx;
static void reset(void) {
    // A double battle: the user 0 hit both foes, 1 and 3.
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i] = (Mon){ 100, 0, 0, FALSE, 0 };
        ctx.selfTurnData[i] = (SelfTurnData){ i & 1 ? 10 : 0, 0 };
    }
    ctx.battlerIdAttacker = 0; ctx.battlerIdStatChange = 0xFF;
    move.effect = MOVE_EFFECT_PREVENT_ESCAPE_HIT; sheerForce = FALSE; moldBreaker = FALSE; ran = 0;
    ctx.moveNoCur = MOVE_ANCHOR_SHOT;
}
static BOOL holds(int battlerId) {
    ran = 0;
    if (TryHoldAfterHit(&ctx, battlerId) == FALSE) {
        assert(ran == 0);
        return FALSE;
    }
    assert(ran == BATTLE_SUBSCRIPT_HOLD_AFTER_HIT && ctx.battlerIdStatChange == battlerId);
    return TRUE;
}
int main(void) {
    // Both foes it hit, not the user nor the ally it did not hit.
    reset(); assert(holds(1) && holds(3) && !holds(0) && !holds(2));
    reset(); ctx.selfTurnData[3].physicalDamage = 0; ctx.selfTurnData[3].specialDamage = 10; assert(holds(3));
    // Not a Pokemon fainted, come in after the hit, or held already; not once
    // the user has fainted; not with Sheer Force or through a Covert Cloak.
    reset(); ctx.battleMons[1].hp = 0; assert(!holds(1) && holds(3));
    reset(); ctx.battleMons[1].cameIn = TRUE; assert(!holds(1));
    reset(); ctx.battleMons[1].status2 = STATUS2_MEAN_LOOK; assert(!holds(1));
    reset(); ctx.battleMons[0].hp = 0; assert(!holds(1) && !holds(3));
    reset(); sheerForce = TRUE; assert(!holds(1));
    reset(); ctx.battleMons[1].holdEffect = HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS; assert(!holds(1) && holds(3));
    // Nor through Shield Dust, unless Mold Breaker ignores it (Pokemon
    // Central, Colpo d'Ancora).
    reset(); ctx.battleMons[1].ability = ABILITY_SHIELD_DUST; assert(!holds(1) && holds(3));
    reset(); ctx.battleMons[1].ability = ABILITY_SHIELD_DUST; moldBreaker = TRUE; assert(holds(1));
    // Thousand Waves' hold is no additional effect: neither keeps it off
    // (Pokemon Central, Mille Onde).
    reset(); ctx.moveNoCur = MOVE_THOUSAND_WAVES; ctx.battleMons[1].holdEffect = HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS;
    ctx.battleMons[3].ability = ABILITY_SHIELD_DUST; assert(holds(1) && holds(3));
    // Only the moves that hold.
    reset(); move.effect = MOVE_EFFECT_HIT; assert(!holds(1));
    return 0;
}
"""


class PostMoveEffectsTests(unittest.TestCase):
    """What the moves past retail's effects do once the move is over, as the
    engine's Activate_AdditionalMoveEffects does it
    (ServerDoPostMoveEffects.c:1095 at d0380a487), where the scripts here
    did it with the hit."""

    @staticmethod
    def case(label):
        from test_hold_effects import CONTROLLER
        step = function(CONTROLLER.read_text(), "TryAdditionalMoveEffect")
        case = step[step.index(label):]
        return case[:case.index("break;")]

    @staticmethod
    def effect_script(name):
        number = int(re.search(rf"#define MOVE_EFFECT_{name}\s+(\d+)", EFFECTS_H.read_text()).group(1))
        return next((ROOT / "files/battledata/script/effect_script").glob(f"effect_script_{number:04d}*.s")).read_text()

    def test_stone_axe_and_ceaseless_edge_lay_them_if_the_user_stands(self):
        # Pokemon Central, Rocciascure and Lama Milleflutti.
        case = self.case("case MOVE_EFFECT_STEALTH_ROCK_HIT:\n    case MOVE_EFFECT_SET_SPIKES_HIT:")
        self.assertIn("if (!ctx->battleMons[ctx->battlerIdAttacker].hp || SheerForceTradedEffect(ctx)) {\n            return FALSE;", case)
        # Sheer Force powers Stone Axe and gives the stones up (Rocciascure).
        body = re.search(r"static BOOL IsSuppressibleSecondaryEffect.*?\n\}", (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), re.S).group(0)
        self.assertIn("case MOVE_EFFECT_STEALTH_ROCK_HIT:\n        return TRUE;", body)
        self.assertNotIn("SET_SPIKES_HIT", body)
        self.assertIn("BATTLE_SUBSCRIPT_SET_STEALTH_ROCK : BATTLE_SUBSCRIPT_SET_SPIKES;", case)
        for name in ("STEALTH_ROCK_HIT", "SET_SPIKES_HIT"):
            self.assertNotIn("SIDE_EFFECT", self.effect_script(name), name)

    def test_jaw_lock_holds_both_if_both_stand(self):
        case = self.case("case MOVE_EFFECT_PREVENT_ESCAPE_BOTH_HIT:")
        self.assertIn("if (!ctx->battleMons[ctx->battlerIdAttacker].hp || !ctx->battleMons[target].hp) {", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_JAW_LOCK;", case)
        self.assertNotIn("SIDE_EFFECT", self.effect_script("PREVENT_ESCAPE_BOTH_HIT"))

    def test_the_hold_of_every_pokemon_thousand_waves_or_anchor_shot_hit(self):
        # Pokemon Central, Colpo d'Ancora and Mille Onde; asked once the move
        # is over, for each battler in turn.
        from test_ability_interactions import run_c
        from test_hold_effects import CONTROLLER
        run_c(HOLD_AFTER_HIT.replace("@FUNCTIONS@", function(CONTROLLER.read_text(), "TryHoldAfterHit")))
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        self.assertLess(body.index("TryAdditionalMoveEffect(ctx)"), body.index("TryHoldAfterHit(ctx, ctx->turnOrder[ctx->unk_34++])"))
        self.assertLess(body.index("TryHoldAfterHit("), body.index("TryMagician("))
        self.assertNotIn("SIDE_EFFECT", self.effect_script("PREVENT_ESCAPE_HIT"))

    def test_fell_stinger_raises_attack_three_for_a_felled_target(self):
        # Pokemon Central, Pungiglione: three stages from the seventh generation.
        case = self.case("case MOVE_EFFECT_FELL_STINGER:")
        self.assertIn("if (ctx->battleMons[target].hp || !ctx->battleMons[ctx->battlerIdAttacker].hp) {", case)
        self.assertIn("RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_ATTACK_UP_3_ON_FAINT);\n        ctx->statChangeType = SIDE_EFFECT_TYPE_INDIRECT;", case)
        from test_retail_effect_scripts import subscript
        self.assertIn("MOVE_SUBSCRIPT_PTR_ATTACK_UP_3_STAGES\n", subscript("ATTACK_UP_3_ON_FAINT"))
        self.assertNotIn("SIDE_EFFECT", self.effect_script("FELL_STINGER"))

    def test_scale_shot_lowers_defense_and_raises_speed_after_its_strikes(self):
        # Pokemon Central, Squamacolpo: each whatever the other's stage.
        case = self.case("case MOVE_EFFECT_MULTI_HIT:")
        self.assertIn("if (ctx->moveNoCur != MOVE_SCALE_SHOT || !ctx->battleMons[ctx->battlerIdAttacker].hp) {", case)
        self.assertIn("ctx->battlerIdStatChange = ctx->battlerIdAttacker;\n        RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_SCALE_SHOT);", case)
        self.assertNotIn("statChanges", case)
        from test_retail_effect_scripts import subscript
        script = subscript("SCALE_SHOT")
        self.assertLess(script.index("MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE"), script.index("MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE"))
        self.assertEqual(script.count("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"), 2)


if __name__ == "__main__":
    unittest.main()
