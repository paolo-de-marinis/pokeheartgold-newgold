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
from test_repels import REFERENCE

NEWGOLD = "ccf2c9f5"  # konefr's tip, the engine under it included

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
    "CHARGE_TURN_ATK_SP_ATK_SPEED_UP_2": "script: the charge turn, Power Herb and the +6 refusal are effect script 323's",
    "SET_ABILITY_TO_SIMPLE": "script: subscript 338 fails behind a substitute itself",
    "CHARGE_TURN_SP_ATK_UP": "script: the charge turn and Power Herb are effect script 329's",
    "CHARGE_TURN_SP_ATK_UP_RAIN_SKIPS": "script: the charge turn, Power Herb and the rain are effect script 330's",
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
    "PREVENT_ESCAPE_BOTH_HIT": "script: the side effect runs Jaw Lock's subscript after the damage",
    "STEALTH_ROCK_HIT": "script: an ON_HIT side effect lays the stones after the damage",
    "SET_SPIKES_HIT": "script: an ON_HIT side effect lays the spikes after the damage",
    "CHARGE_TURN_PARALYZE_HIT": "script: the charge turn, Power Herb and the paralysis are effect script 365's",
    "CHARGE_TURN_BURN_HIT": "script: the charge turn, Power Herb and the burn are effect script 366's",
    "HIT_THREE_TIMES_ALWAYS_CRITICAL": "script: it asks for CRITICAL_STAGE_ALWAYS on every hit, which CalcCrit reads as a sure critical",
    "MORTAL_SPIN": "script: an ON_HIT side effect runs subscript 403, the poison and then Rapid Spin's clearing",
    "ADD_TYPE_GRASS": "script: subscript 325 fails behind a substitute, as the reference's substitute list does",
    "ADD_TYPE_GHOST": "script: subscript 324 fails behind a substitute, as the reference's substitute list does",
    "CHANGE_TO_PSYCHIC_TYPE": "script: subscript 323 fails behind a substitute, as the reference's substitute list does",
    "COACHING": "script: effect script 383 fails it in a single battle or with no partner standing",
    "DECORATE": "script: subscript 314 does not affect a target behind a substitute, the reference's stat-drop list",
    "PARTING_SHOT": "not ported: it lowers the two stats but the user never switches out",
    "FORCE_SWITCH_HIT": "script: a CHECK_HP_AND_SUBSTITUTE side effect runs Whirlwind's subscript after the damage",
    "STUFF_CHEEKS": "script: effect script 398 fails it without a berry and subscript 311 refuses it at +6 Defense",
    "RECOIL_HALF_MAX_HP": "script: Reckless's boost and the half-HP recoil are effect script 404's",
    "IGNORE_PROTECT": "data: Mighty Cleave's record has the protect bit clear, which is what Protect reads here",
}


class WhatIsStillMissingTests(unittest.TestCase):
    # A ratchet, not a target: the table above may only shrink.
    STILL_UNREAD = 44

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


if __name__ == "__main__":
    unittest.main()
