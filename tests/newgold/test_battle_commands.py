#!/usr/bin/env python3
"""Check the battle script command table.

A battle script is bytecode: the first word of a command is an index into
sBattleScriptCommandTable. A macro whose opcode has no slot reads past the end
of that table and calls whatever follows it, and an opcode that disagrees with
the one hg-engine uses would run the wrong command for a script written there.
Neither shows up as a build failure.
"""

import os
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

MACROS = ROOT / "asm/macros/btlcmd.inc"
TABLE = ROOT / "asm/overlay_12_battle_command.s"
HEADER = ROOT / "include/battle/battle_command.h"
SOURCE = ROOT / "src/battle/battle_command.c"
LAST_RETAIL = 224

REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))
REFERENCE_MACROS = REFERENCE / "asm/include/battle_commands.inc"


def opcodes(text):
    """Every macro that begins by writing its opcode, by name."""
    found = {}
    for match in re.finditer(r"\.macro\s+(\w+)[^\n]*\n\s*\.long\s+(\d+)", text):
        found[match.group(1)] = int(match.group(2))
    return found


def table():
    body = TABLE.read_text()
    start = body.index("sBattleScriptCommandTable:")
    end = body.index(".public", start)
    return re.findall(r"^\t\.word (BtlCmd_\w+)", body[start:end], re.M)


class BattleCommandTests(unittest.TestCase):
    def setUp(self):
        self.macros = opcodes(MACROS.read_text())
        self.table = table()

    def test_every_macro_has_a_slot(self):
        for name, opcode in sorted(self.macros.items(), key=lambda pair: pair[1]):
            self.assertLess(opcode, len(self.table), f"{name} has no command to run")

    def test_opcodes_are_unique(self):
        # The opcode is an index, so two macros sharing one would run the same
        # command, and the table is read positionally rather than by name.
        self.assertEqual(len(set(self.macros.values())), len(self.macros))

    def test_the_table_covers_every_opcode_a_translated_script_can_carry(self):
        """The table is sized to hg-engine's whole range, not to the macros
        written so far, so a script naming a command this port has not got to
        yet lands on the one that says so rather than past the end."""
        if not REFERENCE_MACROS.exists():
            self.skipTest("reference checkout not present")
        theirs = opcodes(REFERENCE_MACROS.read_text(errors="replace"))
        self.assertEqual(len(self.table), max(theirs.values()) + 1)

    def test_every_handler_is_declared_and_defined(self):
        header = HEADER.read_text()
        source = SOURCE.read_text()
        for name in sorted(set(self.table)):
            self.assertIn(f"BOOL {name}(BattleSystem *battleSystem, BattleContext *ctx);", header, name)
            self.assertIn(f"BOOL {name}(BattleSystem *battleSystem, BattleContext *ctx) {{", source, name)

    def test_retail_commands_are_untouched(self):
        self.assertNotIn("BtlCmd_NotImplemented", self.table[:LAST_RETAIL + 1])

    def test_the_added_commands_agree_with_the_engine_they_came_from(self):
        """A script written for hg-engine has to mean the same thing here."""
        if not REFERENCE_MACROS.exists():
            self.skipTest("reference checkout not present")
        theirs = opcodes(REFERENCE_MACROS.read_text(errors="replace"))
        shared = set(self.macros) & set(theirs)
        self.assertGreater(len(shared), 200)
        for name in sorted(shared):
            self.assertEqual(self.macros[name], theirs[name], name)

    def test_nothing_is_left_to_write(self):
        missing = [i for i, name in enumerate(self.table) if name == "BtlCmd_NotImplemented"]
        self.assertEqual(missing, [], "these opcodes still have no command")

    def test_every_opcode_the_engine_has_is_spelled_the_same_way_here(self):
        """The macro names are what a translated script writes, so a command
        this port spells differently would not assemble."""
        if not REFERENCE_MACROS.exists():
            self.skipTest("reference checkout not present")
        theirs = opcodes(REFERENCE_MACROS.read_text(errors="replace"))
        self.assertEqual(set(theirs) - set(self.macros), set())


if __name__ == "__main__":
    unittest.main()
