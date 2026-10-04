#!/usr/bin/env python3
"""The battle animations' script asks overlay 7 for each command's handler
(ov07_0221F8B0, src/battle/battle_anim_script.c), from a table of 0x58.

The game's own check let 0x58 through, one past the table -- hg-engine's
changepermanentbg is 0x58 -- and a script carrying it ran the word after
the table; above it the interpreter was given NULL to call. A command the
table does not hold now ends the animation as End does.
No script reaches it, so there is nothing to see in play.
"""

import re
import unittest

from test_hold_effects import run_c
from test_level_cap import ROOT
from test_repels import function

SOURCE = ROOT / "src/battle/battle_anim_script.c"
TABLE = ROOT / "asm/overlay_07_0221F8C4.s"


def table_words():
    text = TABLE.read_text()
    body = text[text.index("\nov07_02234DE8:"):]
    body = body[:re.search(r"\n\S+:", body[1:]).start() + 1]
    return re.findall(r"\.word (\w+)", body)


class LookupTests(unittest.TestCase):
    def test_the_bound_is_the_table_s_length(self):
        bound = int(re.search(r"#define BATTLE_ANIM_SCRIPT_COMMANDS (0x\w+)", SOURCE.read_text()).group(1), 16)
        self.assertEqual(len(table_words()), bound)

    def test_a_command_past_the_table_ends_the_animation(self):
        source = SOURCE.read_text()
        defines = "\n".join(re.findall(r"^#define BATTLE_ANIM_SCRIPT_\w+ .*$", source, re.M))
        program = r"""
#include <stdint.h>
#include <stdio.h>
typedef uint32_t u32;
typedef const int *BattleAnimScriptCommand;
static int asserts; /* none now: a GF_ASSERT here would cost overlay 7 bytes */
#define GF_ASSERT(c) do { if (!(c)) asserts++; } while (0)
#define FALSE 0
""" + defines + r"""
static const int slots[0x100];
static BattleAnimScriptCommand ov07_02234DE8[0x100];
""" + function(source, "ov07_0221F8B0") + r"""
int main(void) {
    u32 commands[] = {0, 4, 0x57, 0x58, 0x59, 0xFFFFFFFF};
    for (int i = 0; i < 0x100; i++) {
        ov07_02234DE8[i] = &slots[i];
    }
    for (unsigned i = 0; i < sizeof(commands) / sizeof(*commands); i++) {
        asserts = 0;
        BattleAnimScriptCommand handler = ov07_0221F8B0(commands[i]);
        printf("%lu %ld %d\n", (unsigned long)commands[i], handler ? (long)(handler - slots) : -1L, asserts);
    }
    return 0;
}
"""
        got = {int(c): (int(h), int(a)) for c, h, a in (line.split() for line in run_c(program).splitlines())}
        self.assertEqual(got[0], (0, 0))
        self.assertEqual(got[0x57], (0x57, 0))
        # End's own handler, the table's fifth, for what the table does not hold.
        for command in (0x58, 0x59, 0xFFFFFFFF):
            self.assertEqual(got[command], (4, 0), hex(command))
        self.assertEqual(table_words()[4], "ov07_0221C9C0")


if __name__ == "__main__":
    unittest.main()
