#!/usr/bin/env python3
"""Check the EV and IV viewer on the summary's stats page.

The page shows Sp. Atk and Sp. Def before Speed; the saved record keeps Speed
before them. Reading the six values in the page's order would put Speed's
effort value under Sp. Atk and nobody would see it from a build, so the table
that reorders them is checked against the real constants here.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

SOURCE = ROOT / "src/pokemon_summary_stats.c"
INPUT = ROOT / "src/pokemon_summary_input.c"
MESSAGES = ROOT / "files/msgdata/msg/msg_0302.gmm"

PROGRAM = r'''
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
#include "constants/pokemon.h"

@TABLE@

int main(void) {
    // The page's own order: HP, Attack, Defense, Sp. Atk, Sp. Def, Speed.
    const int evs[] = { MON_DATA_HP_EV, MON_DATA_ATK_EV, MON_DATA_DEF_EV,
                        MON_DATA_SPATK_EV, MON_DATA_SPDEF_EV, MON_DATA_SPEED_EV };
    const int ivs[] = { MON_DATA_HP_IV, MON_DATA_ATK_IV, MON_DATA_DEF_IV,
                        MON_DATA_SPATK_IV, MON_DATA_SPDEF_IV, MON_DATA_SPEED_IV };
    int seen = 0;

    assert(sizeof(sStatReadOrder) / sizeof(*sStatReadOrder) == 6);
    for (int i = 0; i < 6; i++) {
        assert(MON_DATA_HP_EV + sStatReadOrder[i] == evs[i]);
        assert(MON_DATA_HP_IV + sStatReadOrder[i] == ivs[i]);
        assert(sStatReadOrder[i] < 6);
        seen |= 1 << sStatReadOrder[i];
    }
    // Every stat is read exactly once.
    assert(seen == 0x3F);

    puts("PASS: six stats read in the page's order from the record's.");
    return 0;
}
'''


class SummaryViewerTests(unittest.TestCase):
    def test_the_page_order_maps_onto_the_record(self):
        match = re.search(r"static const u8 sStatReadOrder\[\] = \{[^}]*\};", SOURCE.read_text())
        self.assertIsNotNone(match, "sStatReadOrder is gone")
        program = PROGRAM.replace("@TABLE@", match.group(0))
        with tempfile.TemporaryDirectory(prefix="newgold-summary-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                 "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())

    def test_the_three_buttons_choose_the_three_modes(self):
        body = INPUT.read_text()
        start = body.index("if (summary->page == SUMMARY_PAGE_STATS) {")
        block = body[start:body.index("if (keys & PAD_KEY_LEFT)", start)]
        self.assertIn("PAD_BUTTON_L", block)
        self.assertIn("PAD_BUTTON_R", block)
        self.assertIn("PAD_BUTTON_SELECT", block)
        # L reads the effort values, R the individual ones, Select the stats.
        self.assertLess(block.index("PAD_BUTTON_L"), block.index("PAD_BUTTON_R"))
        self.assertIn("SUMMARY_STATS_EVS", block[block.index("PAD_BUTTON_L"):block.index("PAD_BUTTON_R")])
        self.assertIn("SUMMARY_STATS_IVS", block[block.index("PAD_BUTTON_R"):block.index("PAD_BUTTON_SELECT")])

    def test_it_only_answers_on_the_stats_page(self):
        """Elsewhere L and R are the summary's own page keys."""
        body = INPUT.read_text()
        self.assertLess(body.index("summary->page == SUMMARY_PAGE_STATS"), body.index("PAD_BUTTON_L"))

    def test_the_labels_exist(self):
        text = MESSAGES.read_text()
        for label in ("EVs", "IVs"):
            self.assertIn(f">{label}</language>", text, f"the {label} label is missing")

    def test_the_labels_are_the_ones_the_page_reads(self):
        source = SOURCE.read_text()
        text = MESSAGES.read_text()
        for name in re.findall(r"msg_0302_(\d{5})", source):
            self.assertIn(f'index="{int(name)}"', text, f"msg_0302_{name} has no row")


if __name__ == "__main__":
    unittest.main()
