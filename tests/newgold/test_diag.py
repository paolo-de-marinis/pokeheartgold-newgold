#!/usr/bin/env python3
"""The diagnostics exist only in a NEWGOLD_DIAG=1 build.

The promise docs/newgold/DIAGNOSTICS.md makes is that the ordinary build is
byte for byte the build without them. That holds as long as every mention of
a diagnostic outside its own folder sits under #ifdef NEWGOLD_DIAG, which is
what this reads the sources for; the ROM itself was compared when the folder
came in, and this is what keeps the next hook honest.
"""

import re
import unittest

from test_level_cap import ROOT

OWN = {ROOT / "src/newgold/diag/diag.c", ROOT / "include/newgold/diag.h"}
MENTION = re.compile(r"\b(gDiag\w*|Diag_\w+)\b")


def unguarded(path):
    """Every diagnostic mentioned on a line no #ifdef NEWGOLD_DIAG covers."""
    stack, found = [], []
    for number, line in enumerate(path.read_text().splitlines(), 1):
        directive = line.strip()
        if directive.startswith("#"):
            words = directive[1:].split()
            if words[0] in ("if", "ifdef", "ifndef"):
                stack.append(words[0] == "ifdef" and words[1] == "NEWGOLD_DIAG")
            elif words[0] in ("else", "elif"):
                stack[-1] = False
            elif words[0] == "endif":
                stack.pop()
            continue
        if not any(stack):
            found += [f"{path.relative_to(ROOT)}:{number}: {name}" for name in MENTION.findall(line)]
    return found


class DiagnosticsTests(unittest.TestCase):
    def test_every_hook_is_under_the_define(self):
        loose = []
        for folder, suffix in (("src", "*.c"), ("include", "*.h")):
            for path in sorted((ROOT / folder).rglob(suffix)):
                if path not in OWN:
                    loose += unguarded(path)
        self.assertEqual(loose, [], "diagnostics outside #ifdef NEWGOLD_DIAG:\n" + "\n".join(loose))

    def test_the_build_gates_the_define(self):
        config = (ROOT / "config.mk").read_text()
        self.assertIn("ifeq ($(NEWGOLD_DIAG),1)", config)
        before, block = config.split("ifeq ($(NEWGOLD_DIAG),1)", 1)
        self.assertIn("-DNEWGOLD_DIAG", block.split("endif", 1)[0])
        self.assertNotIn("-DNEWGOLD_DIAG", before + block.split("endif", 1)[1])
        self.assertIn("Object src/newgold/diag/diag.o", (ROOT / "main.lsf").read_text())

    def test_the_readers_know_every_marker(self):
        # A global the readers never print is one nobody will notice going wrong.
        header = (ROOT / "include/newgold/diag.h").read_text()
        names = set(re.findall(r"extern unsigned (?:int|short) (gDiag\w+);", header))
        read = set()
        for script in (ROOT / "tools/newgold/devkit/diag").glob("*.py"):
            read |= set(re.findall(r"gDiag\w+", script.read_text()))
        self.assertEqual(names - read, set(), "in diag.h and read by nothing")


if __name__ == "__main__":
    unittest.main()
