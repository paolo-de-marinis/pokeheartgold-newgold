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

    def test_the_nature_colours_are_the_engine_s(self):
        """HeartGold only changed the shadow, which does not read."""
        source = (ROOT / "src/pokemon_summary_stat_name.c").read_text()
        for name, colour in (("STAT_NAME_LOWERED", (4, 3, 0)), ("STAT_NAME_RAISED", (6, 5, 0))):
            match = re.search(rf"#define {name}\s+MAKE_TEXT_COLOR\((\w+), (\w+), (\w+)\)", source)
            self.assertIsNotNone(match, name)
            self.assertEqual(tuple(int(v, 0) for v in match.groups()), colour, name)
        # The letter changes, not only the shadow: the two differ in the first
        # component, which HeartGold left at 0xE for both.
        self.assertNotIn("MAKE_TEXT_COLOR(0xE, 8, 0)", source)
        self.assertNotIn("MAKE_TEXT_COLOR(0xE, 7, 0)", source)

    def test_the_labels_exist(self):
        text = MESSAGES.read_text()
        for label in ("EV", "IV"):
            self.assertIn(f">{label}</language>", text, f"the {label} label is missing")

    def test_the_labels_are_the_ones_the_page_reads(self):
        source = SOURCE.read_text()
        text = MESSAGES.read_text()
        for name in re.findall(r"msg_0302_(\d{5})", source):
            self.assertIn(f'index="{int(name)}"', text, f"msg_0302_{name} has no row")


    def test_a_hyper_trained_iv_shows_as_31_with_a_star(self):
        """The IV page shows a Hyper trained stat as the 31 it counts as and
        marks it, its true IV never told (Pokemon Central, Allenamento Pro);
        the EV page and the true IVs of the others are left alone.
        ReadStatValues is compiled with the Pokemon read by stand-ins."""
        source = SOURCE.read_text()
        from test_repels import function
        program = HYPER_PROGRAM.replace("@READ@", "\n".join((
            re.search(r"static const u8 sStatReadOrder\[\] = \{[^}]*\};", source).group(0),
            re.search(r"#define STAT_VALUE_HYPER_TRAINED .*", source).group(0),
            function(source, "ReadStatValues"))))
        with tempfile.TemporaryDirectory(prefix="newgold-summary-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-Wall", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
        printer = function(source, "PrintStatValue")
        self.assertIn("(value & STAT_VALUE_HYPER_TRAINED) ? msg_0302_00208", printer)
        self.assertIn(">{STRVAR_1 52, 0, 0}★</language>", MESSAGES.read_text(encoding="utf-8"))


HYPER_PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#include "constants/pokemon.h"
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#define SUMMARY_STATS_EVS 1
#define SUMMARY_STATS_IVS 2
#define HEAP_ID_19 19
typedef struct { u8 unk11; } Args;
typedef struct { Args *args; } PokemonSummaryAppPrefix;
typedef struct { int iv[6], ev[6]; u32 flags; } Pokemon;
static Pokemon sMon;
static void *sub_0208A520(PokemonSummaryAppPrefix *summary) { (void)summary; return &sMon; }
static Pokemon *AllocMonZeroed(int heap) { (void)heap; assert(0); return NULL; }
static void CopyBoxPokemonToPokemon(void *a, Pokemon *b) { (void)a; (void)b; }
static void Heap_Free(void *p) { (void)p; }
static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    if (attr >= MON_DATA_HP_IV && attr <= MON_DATA_SPDEF_IV) return mon->iv[attr - MON_DATA_HP_IV];
    if (attr >= MON_DATA_HP_EV && attr <= MON_DATA_SPDEF_EV) return mon->ev[attr - MON_DATA_HP_EV];
    assert(attr == MON_DATA_UNUSED_114);
    return mon->flags;
}
@READ@
int main(void) {
    Args args = { 0 };
    PokemonSummaryAppPrefix summary = { &args };
    u16 values[6];
    // HP and Speed trained: the page's first and last.
    sMon = (Pokemon) { { 13, 4, 14, 19, 28, 30 }, { 1, 2, 3, 4, 5, 6 }, MON_HYPER_TRAINED_BIT(STAT_HP) | MON_HYPER_TRAINED_BIT(STAT_SPEED) };
    ReadStatValues(&summary, SUMMARY_STATS_IVS, values);
    assert(values[0] == (STAT_VALUE_HYPER_TRAINED | MAX_IV));
    assert(values[1] == 4 && values[2] == 14 && values[3] == 28 && values[4] == 30);
    assert(values[5] == (STAT_VALUE_HYPER_TRAINED | MAX_IV));
    ReadStatValues(&summary, SUMMARY_STATS_EVS, values);
    assert(values[0] == 1 && values[5] == 4);
    return 0;
}
'''


if __name__ == "__main__":
    unittest.main()
