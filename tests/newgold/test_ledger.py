#!/usr/bin/env python3
"""Check that the ledger, the README and the page still agree.

The summary block used to be the one part written by hand, and it was the one
part that was wrong: "verified in play" had copied the line above it, and
"implementation" came from no rule at all. It is derived now like everything
else -- the judgement is which state a row carries, the arithmetic is not a
judgement -- and the three figures are recomputed here from the rows rather
than read back from the block that claims them.

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


def bucket(section, state):
    if state.startswith("\u2705"):
        return 0 if section == "Verification" else 1
    if state.startswith("\U0001f7e0"):
        return 2
    if state.startswith("\U0001f534"):
        return 3
    return 4


def rows_with_state():
    return rows()


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

    def test_the_three_figures_come_from_the_states(self):
        """Recomputed here from the table rows, not taken from the block."""
        rows = [(section, state) for section, _, _, state in
                [(r[0], r[1], r[2], r[3]) for r in rows_with_state()]]
        counted = [sum(1 for r in rows if bucket(*r) == i) for i in range(5)]

        def scored(subset):
            done = sum(1 for r in subset if bucket(*r) in (0, 1))
            part = sum(1 for r in subset if bucket(*r) == 2)
            todo = sum(1 for r in subset if bucket(*r) == 3)
            within = done + part + todo
            return round(100 * (done + part / 2) / within) if within else 0

        seen = counted[0] + counted[1]
        expected = {
            "Overall": scored(rows),
            "Implementation": scored([r for r in rows if r[0] != "Verification"]),
            "Verified in play": round(100 * counted[0] / seen) if seen else 0,
        }
        block = re.search(r"LEDGER:SUMMARY:START -->\n```\n(.*?)\n```",
                          LEDGER.read_text(), re.S).group(1)
        for label, value in expected.items():
            found = re.search(rf"^{re.escape(label)}\s+[\u2588\u2591]*\s*(\d+)%$",
                              block, re.M)
            self.assertIsNotNone(found, f"{label} is not in the summary block")
            self.assertEqual(int(found.group(1)), value,
                             f"{label} says {found.group(1)}% and the rows give {value}%")

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
