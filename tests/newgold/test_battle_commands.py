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
TABLE = ROOT / "src/battle/overlay_12_0226C3E8.c"
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
    start = body.index("const BtlCmdFunc sBattleScriptCommandTable[] = {")
    end = body.index("\n};", start)
    return re.findall(r"^    (BtlCmd_\w+),", body[start:end], re.M)


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

    # An added command that reads its operands and does nothing else is a
    # stub, and a script that runs one carries on as if the command worked.
    # No script here runs any of these, and each waits on what is named beside
    # it. The listing is exact -- a command written here leaves it -- and it
    # may only shrink.
    STUBS = {
        "AddType": "no script in the reference runs it either",
        "BatchEffectivenessMessage": "the batched messages of a spread move",
        "BatchFollowupMessage": "the batched messages of a spread move",
        "BatchUpdateHealthBar": "the batched messages of a spread move",
        "BatchUpdateHealthBarValue": "the batched messages of a spread move",
        "CanClearPrimalWeather": "primal weather",
        "ChangePermanentBackground": "the battle background Defog and a terrain's end redraw",
        "GoToIfTerastallized": "no script in the reference runs it either",
        "GotoIfCanApplyKnockOffBoost": "no script in the reference runs it either",
        "GotoIfCurrentMoveIsValidForParentalBond": "Parental Bond",
        "GotoIfFirstHitOfParentalBond": "Parental Bond",
        "GotoIfParentalBondIsActive": "no script in the reference runs it either",
        "GotoIfSecondHitOfParentalBond": "Parental Bond",
        "MakeTotem": "totems",
        # The reference's pending-switch ordering (subscripts 0009, 0091,
        # 0114, 0175, 0340, 0469, 0498, read in ServerDoPostMoveEffects.c):
        # nothing here switches a Pokemon out after a move that way yet.
        "SetCurrentMoveSwitchingStatus": "Parting Shot's switch, Eject Button and Eject Pack, "
                                         "Wimp Out and Emergency Exit, none of them written",
        "SetParentalBondFlag": "Parental Bond",
        "TryActivateZeroToHero": "Zero to Hero, Palafin's form change",
        "TryMegaOrUltraBurstDuringPursuit": "mega and ultra burst",
    }

    def test_no_added_command_is_a_stub_unless_listed(self):
        source = SOURCE.read_text()
        scripts = "\n".join(p.read_text(errors="replace") for p in sorted((ROOT / "files/battledata/script").rglob("*.s")))
        stubs = set()
        for opcode, name in enumerate(self.table):
            if opcode <= LAST_RETAIL:
                continue
            body = re.search(rf"^BOOL {name}\(BattleSystem \*battleSystem, BattleContext \*ctx\) \{{\n(.*?)^\}}", source, re.M | re.S)
            if body is None:
                continue
            lines = [l.strip() for l in body.group(1).splitlines() if l.strip() and not l.strip().startswith(("//", "/*", "*"))]
            work = [l for l in lines if not (l.startswith("#pragma") or "BattleScriptReadWord" in l or "BattleScriptIncrementPointer" in l
                                             or l in ("return FALSE;", "return TRUE;"))]
            if not work:
                stubs.add(name[len("BtlCmd_"):])
        self.assertEqual(stubs - set(self.STUBS), set(), "commands that only read their operands and are not listed above")
        self.assertEqual(set(self.STUBS) - stubs, set(), "commands listed as stubs that do something now; take them off")
        for name in sorted(stubs):
            macro = next((m for m, code in self.macros.items() if code == self.table.index("BtlCmd_" + name)), None)
            self.assertIsNotNone(macro, name)
            self.assertNotRegex(scripts, rf"^\s*{macro}\b", f"{macro} runs in a script and does nothing")

    def test_every_opcode_the_engine_has_is_spelled_the_same_way_here(self):
        """The macro names are what a translated script writes, so a command
        this port spells differently would not assemble."""
        if not REFERENCE_MACROS.exists():
            self.skipTest("reference checkout not present")
        theirs = opcodes(REFERENCE_MACROS.read_text(errors="replace"))
        self.assertEqual(set(theirs) - set(self.macros), set())


class ItemGrabTests(unittest.TestCase):
    """The engine turns AI_CAN_GRAB_ITEMS on.

    HeartGold refuses Trick and Switcheroo when the other side starts them
    outside a link or Frontier battle, so the player can never lose a held
    item to a trainer. New Gold lifts that, having the battle hand every item
    back when it ends. Thief and Covet keep the old rule: the engine's own
    note says so, and a stolen item is gone the moment the wild Pokemon flees.
    """

    def setUp(self):
        body = SOURCE.read_text()
        def command(name):
            start = body.index(f"BOOL {name}(")
            return body[start:body.index("\n}\n", start)]
        self.swap = command("BtlCmd_TrySwapItems")
        self.steal = command("BtlCmd_TryStealItem")

    def test_swapping_is_no_longer_refused_by_side(self):
        self.assertNotIn("BATTLE_TYPE_FRONTIER", self.swap)

    def test_stealing_still_is(self):
        self.assertIn("BATTLE_TYPE_FRONTIER", self.steal)

    def test_the_items_come_back(self):
        """Without the restore there would be nothing to make this safe."""
        self.assertIn("itemsToRestore", (ROOT / "include/battle/battle.h").read_text())



class ScriptBufferTests(unittest.TestCase):
    def test_every_built_script_fits_the_buffer(self):
        """A battle script is copied whole into BattleContext.battleScriptBuffer.
        Retail's was 1600 bytes, and four status subscripts grew past it once
        they learnt the later generations' immunities -- Bad Poison to 2104 --
        so every load wrote into the fields after the buffer. hg-engine grew
        its buffer to 650 words for the same scripts; so does this tree."""
        header = (ROOT / "include/battle/battle.h").read_text()
        words = int(re.search(r"#define BATTLE_SCRIPT_BUFFER_WORDS (\d+)", header).group(1))
        built = sorted((ROOT / "files/battledata/script").glob("*/*.bin"))
        if not built:
            self.skipTest("the battle scripts are not built")
        too_long = {path.name: path.stat().st_size for path in built if path.stat().st_size > 4 * words}
        self.assertEqual(too_long, {})
        self.assertGreater(max(path.stat().st_size for path in built), 1600,
                           "no script needs more than retail's buffer; the test would prove nothing")

if __name__ == "__main__":
    unittest.main()
