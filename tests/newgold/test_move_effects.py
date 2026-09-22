#!/usr/bin/env python3
"""Check that an added move is a move and not just a name.

A move is four things that have to agree: a record in the table, a name and a
description in the message banks, a script the battle jumps to, and an
animation. Any one of them missing gives a move that exists on the summary
screen and then does nothing, or worse, runs whatever happens to sit at that
index. Those are the assertions below.

The last part is not structural. Some of the imported effect scripts are a
plain hit and nothing else, because in the reference what makes the move
special lives in C rather than in the script -- Smack Down grounds the target,
Heavy Slam weighs it -- and that C is not here yet. Others reach for a terrain
or a Drive this game has no items or field conditions for. Both are listed,
and the count only ever comes down.
"""

import re
import struct
import unittest
from pathlib import Path

from test_level_cap import ROOT

MOVES_H = ROOT / "include/constants/moves.h"
EFFECTS_H = ROOT / "include/constants/move_effects.h"
IMPORTS_H = ROOT / "include/constants/battle_script_imports.h"
EFFECT_SCRIPTS = ROOT / "files/battledata/script/effect_script"
MOVE_SCRIPTS = ROOT / "files/battledata/script/move_script"
TABLE = ROOT / "files/poketool/waza/waza_tbl.narc"
RECORD = "<HBBBBBBHbBBBH"
RECORD_SIZE = 16

# The last effect this game had before the reference's were imported. Below
# it a plain-hit script is not a gap: it is a retail move whose special part
# is written in C that is here.
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


def plain_hit():
    """The effects whose script is the plain hit and nothing else.

    In the reference what makes these moves special is written in C, not in
    the script, so importing the script alone gives a move that hits for its
    damage and does none of the rest.
    """
    def body(path):
        text = re.sub(r"^\s*(\.include|//).*$", "", path.read_text(), flags=re.M)
        return re.sub(r"\s+", " ", text).strip()
    scripts = by_number(EFFECT_SCRIPTS)
    hit = body(scripts[0])
    return {number for number, path in scripts.items()
            if number > LAST_BEFORE_IMPORT and body(path) == hit}


def reaches_for_what_is_not_here():
    """The effects whose script mentions something only the imports header
    names -- a terrain, a Drive, a Memory -- so the branch never fires."""
    if not IMPORTS_H.exists():
        return set()
    names = set(re.findall(r"#define\s+([A-Z][A-Z0-9_]*)", IMPORTS_H.read_text()))
    return {number for number, path in by_number(EFFECT_SCRIPTS).items()
            if number > LAST_BEFORE_IMPORT
            and names & set(re.findall(r"\b[A-Z][A-Z0-9_]{3,}\b", path.read_text()))}


# Effects whose script is a bare hit in the reference too, and which need
# nothing here. They match plain_hit() by shape and would be counted as work
# for ever, so each one is named with the reason it is finished.
NOTHING_TO_WRITE = {
    # Mighty Cleave. This engine's only Protect gate reads the move record's
    # flag bit, and that move's record has it clear -- like Feint, Shadow
    # Force and Hyperspace Fury, which go through Protect the same way. The
    # reference's extra effect check is belt and braces over the same record.
    406,
}


class WhatIsStillMissingTests(unittest.TestCase):
    # A ratchet, not a target. Every added move has a record, a name, a script
    # and an animation; these are the ones whose script cannot do the whole
    # job on its own, because the reference does the rest in C this port has
    # not written yet. The number may only come down.
    STILL_TO_DO = 2

    def test_the_list_only_ever_shrinks(self):
        pending = (plain_hit() | reaches_for_what_is_not_here()) - NOTHING_TO_WRITE
        self.assertLessEqual(
            len(pending), self.STILL_TO_DO,
            f"{len(pending)} effects are scripted but not finished and the "
            f"ledger allows {self.STILL_TO_DO}; write the C the script is "
            f"missing, or say here why it has none")


if __name__ == "__main__":
    unittest.main()
