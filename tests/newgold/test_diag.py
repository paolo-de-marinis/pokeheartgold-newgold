#!/usr/bin/env python3
"""The diagnostics exist only in a NEWGOLD_DIAG=1 build.

The promise docs/newgold/DIAGNOSTICS.md makes is that the ordinary build is
byte for byte the build without them. That holds as long as every mention of
a diagnostic outside its own folder sits under #ifdef NEWGOLD_DIAG, which is
what this reads the sources for; the ROM itself was compared when the folder
came in, and this is what keeps the next hook honest.
"""

import re
import sys
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

    def test_gym_reads_the_hp_past_a_two_word_species(self):
        # markers.battle names a form in two words; gym.py once took the
        # fourth word for the HP, read "L30" and died without a word.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import battler_hp
        self.assertEqual(battler_hp("you Raichu Alolan L30 0/80 | 1:Thunderbolt 15"), 0)
        self.assertEqual(battler_hp("you Iron Crown L30 103/103 holding Leftovers | 1:Smart Strike 10"), 103)
        self.assertEqual(battler_hp("you Porygon2 L30 57/90 PSN | 1:Tackle 35"), 57)

    def test_nested_melonds_binds_every_button(self):
        # nested.py writes melonDS's key table before melonDS starts; a table
        # whose parent was implicit made melonDS's toml writer abort.
        import tomllib
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from nested import KEYS, bind
        for text in ("", "[Instance0]\n\n[Instance0.Keyboard]\nA = -1\nHK_Lid = -1\n"):
            config = bind(text)
            self.assertIn("[Instance0]\n", config)
            keyboard = tomllib.loads(config)["Instance0"]["Keyboard"]
            self.assertEqual({k: keyboard[k] for k in KEYS}, {k: code for k, (code, _) in KEYS.items()})

    def test_a_heap_margin_is_its_largest_free_block_at_its_fullest(self):
        """Diag_HeapUsed walks an expanded heap's free list as
        NNS_FndGetTotalFreeSizeForExpHeap does -- the list at +0x24 of the
        head, a block's size at +4 and the next at +0xC, 32-bit -- and keeps
        the largest block when it is the smallest seen. Compiled on the host
        with -m32, so the pointers are the game's four bytes."""
        from test_dex_range import c_function, run_native
        source = (ROOT / "src/newgold/diag/diag.c").read_text()
        program = HEAP_MARGIN.replace("@CREATED@", c_function(source, "Diag_HeapCreated")) \
                             .replace("@USED@", c_function(source, "Diag_HeapUsed"))
        run_native(self, program, "newgold-heap-margin-", flags=("-m32",))

    def test_a_forced_roll_is_the_one_its_check_reads_that_way(self):
        """Diag_Roll answers, for the check Diag_RollNext named, the value that
        check reads as the forced outcome -- a critical hit's remainder of 0
        or 1, the accuracy's 0 or 99, the damage's 0 (100%) or 15 (85%), an
        effect's 0 or 99 -- the RNG's own value with the switch off, and
        forgets the check either way, so the next roll is the RNG's."""
        from test_dex_range import c_function, run_native
        source = (ROOT / "src/newgold/diag/diag.c").read_text()
        table = re.search(r"static const u8 sDiagForcedRolls\[\]\[2\] = \{.*?\};", source, re.S).group(0)
        program = FORCED_ROLL.replace("@TABLE@", table).replace("@NEXT@", c_function(source, "Diag_RollNext")) \
                             .replace("@ROLL@", c_function(source, "Diag_Roll"))
        header = (ROOT / "include/newgold/diag.h").read_text()
        program = program.replace("@DEFINES@", "\n".join(re.findall(r"^#define DIAG_ROLL_\w+ \d+$", header, re.M)))
        run_native(self, program, "newgold-forced-roll-")


FORCED_ROLL = r"""
#include <assert.h>
#include <stdio.h>
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
@DEFINES@
u32 gDiagForceCritical, gDiagForceHit, gDiagForceDamageRoll, gDiagForceEffect, gDiagRollNext;
@TABLE@
@NEXT@
@ROLL@
static u16 roll(u32 kind, u32 *sw, u32 value, u16 natural) {
    *sw = value;
    Diag_RollNext(kind);
    return Diag_Roll(natural);
}
int main(void) {
    assert(roll(DIAG_ROLL_CRITICAL, &gDiagForceCritical, 1, 777) % 24 == 0);   /* lands at any stage */
    assert(roll(DIAG_ROLL_CRITICAL, &gDiagForceCritical, 2, 777) % 2 != 0);    /* fails at stage 2, 1 in 2 */
    assert(roll(DIAG_ROLL_HIT, &gDiagForceHit, 1, 777) % 100 + 1 <= 1);        /* hits anything accurate at all */
    assert(roll(DIAG_ROLL_HIT, &gDiagForceHit, 2, 777) % 100 + 1 > 99);        /* misses all under 100 */
    assert(100 - roll(DIAG_ROLL_DAMAGE, &gDiagForceDamageRoll, 1, 777) % 16 == 100);
    assert(100 - roll(DIAG_ROLL_DAMAGE, &gDiagForceDamageRoll, 2, 777) % 16 == 85);
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 1, 777) % 100 < 1);
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 2, 777) % 100 >= 99);
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 0, 777) == 777);        /* off: the RNG's */
    assert(gDiagRollNext == DIAG_ROLL_NONE);                                   /* forgotten */
    gDiagForceCritical = 1;
    assert(Diag_Roll(777) == 777);                                             /* no check named: the RNG's */
    Diag_RollNext(DIAG_ROLL_CRITICAL);
    Diag_Roll(777);
    assert(Diag_Roll(778) == 778);                                             /* one roll a check */
    printf("PASS: a forced roll is the one its check reads as that outcome, once.\n");
    return 0;
}
"""


HEAP_MARGIN = r"""
#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
typedef unsigned char u8;
typedef unsigned int u32;
#define DIAG_HEAPS 176
u32 gDiagHeapLowWater[DIAG_HEAPS];
@CREATED@
@USED@
static u8 head[0x40], blocks[3][0x10];
static void block(int i, u32 size, u8 *next) { memcpy(blocks[i] + 4, &size, 4); memcpy(blocks[i] + 0xC, &next, 4); }
int main(void) {
    u8 *first = blocks[0];
    memcpy(head + 0x24, &first, 4);
    block(0, 0x100, blocks[1]);
    block(1, 0x5000, blocks[2]);
    block(2, 0x40, NULL);
    Diag_HeapCreated(5);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x5000);   /* the largest block, not the sum */
    block(1, 0x6000, blocks[2]);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x5000);   /* a roomier moment does not raise it */
    block(1, 0x80, blocks[2]);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x100);    /* a fuller one lowers it */
    Diag_HeapCreated(5);
    assert(gDiagHeapLowWater[5] == 0xFFFFFFFF);
    Diag_HeapUsed(DIAG_HEAPS, head);          /* out of range: ignored */
    printf("PASS: a heap's margin is its largest free block at its fullest.\n");
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()
