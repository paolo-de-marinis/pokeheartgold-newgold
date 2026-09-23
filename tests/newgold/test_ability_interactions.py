#!/usr/bin/env python3
"""How abilities meet the moves, items and field effects around them, where
the later games' rule differs from the reference's (Paolo, 2026-09-23: the
rule is Pokemon Central's page, latest generation)."""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_battle_mechanics import COMMANDS, OVERLAY, subscript
from test_level_cap import ROOT
from test_repels import function


def run_c(program):
    """Build a host program against the port's headers and run it."""
    with tempfile.TemporaryDirectory(prefix="newgold-abilities-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], check=True)
        subprocess.run([str(path / "test")], check=True)


def label_body(script, label):
    """The lines of a label up to the next label."""
    start = script.index(f"\n{label}:\n") + len(label) + 3
    end = re.search(r"\n_\w+:\n", script[start:])
    return script[start:start + end.start()] if end else script[start:]


class AbilityStatusSafeguardTests(unittest.TestCase):
    def test_safeguard_stops_what_an_ability_gives(self):
        # Pokemon Central, Salvaguardia: from the fifth generation Safeguard
        # stops Static, Flame Body, Poison Point and Effect Spore, and
        # Synchronize; Poison Touch is the same kind of contact ability.
        for name in ("FallAsleep", "Poison", "Burn", "Paralyze"):
            script = subscript(name)
            jump = re.search(r"SIDE_EFFECT_TYPE_ABILITY, (_\w+)\n    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_MOVE_STATUS_FLAGS", script)
            self.assertIsNotNone(jump, name)
            self.assertIn("SIDE_CONDITION_SAFEGUARD", label_body(script, jump.group(1)), name)


if __name__ == "__main__":
    unittest.main()
