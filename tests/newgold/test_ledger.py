#!/usr/bin/env python3
"""Check that the ledger, the README and the page still agree.

docs/newgold/LEDGER.md is the one source: the counters in it are read out of
the repository, the same block is copied into README.md, and docs/index.html
is rendered from the whole file. All three drifted apart within an hour of
being written by hand, which is why none of them is written by hand now.

This runs tools/newgold/ledger.py --check, which rewrites nothing and fails if
anything is behind.
"""

import re
import subprocess
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

LEDGER = ROOT / "docs/newgold/LEDGER.md"
PAGE = ROOT / "docs/index.html"
TOOL = ROOT / "tools/newgold/ledger.py"
STATES = ("✅", "\U0001f7e0", "\U0001f534", "⬜")


def rows():
    out, section = [], None
    for line in LEDGER.read_text().splitlines():
        if line.startswith("## "):
            section = line[3:].strip()
        match = re.match(r"^\| (.+?) \| (.+?) \| (.+?) \|$", line)
        if match and match.group(1) not in ("Feature", "Item") \
                and not set(match.group(1)) <= set("-: "):
            out.append((section, *match.groups()))
    return out


class LedgerTests(unittest.TestCase):
    def test_every_row_carries_a_state(self):
        for section, item, _, state in rows():
            self.assertTrue(state.startswith(STATES),
                            f"{section} / {item} has no state: {state!r}")

    def test_a_counted_state_is_a_fraction(self):
        for section, item, _, state in rows():
            rest = state[1:].strip()
            if "/" in rest:
                have, _, want = rest.partition("/")
                self.assertTrue(have.strip().isdigit() and want.strip().isdigit(),
                                f"{section} / {item}: {state!r}")

    def test_the_page_says_it_is_generated(self):
        self.assertIn("ledger.py", PAGE.read_text())

    def test_the_counters_and_the_page_are_current(self):
        """The check rewrites nothing; it fails when something is behind."""
        if not (ROOT / "build/heartgold.us/pokeheartgold.us.nds").exists():
            self.skipTest("the ROM is not built, so its figures cannot be read")
        result = subprocess.run([sys.executable, str(TOOL), "--check"],
                                cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0,
                         "run tools/newgold/ledger.py:\n" + result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
