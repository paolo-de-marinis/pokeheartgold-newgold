#!/usr/bin/env python3
"""The moves the engine never implemented stay out of play.

The engine flags 79 moves FLAG_UNUSABLE_UNIMPLEMENTED, bit 5 of the flag byte
here (test_moves checks the table), and ships BLOCK_LEARNING_UNIMPLEMENTED_MOVES
on. They are dropped from level-up learnsets as those are read, a trainer's
Pokemon gets MOVE_NONE in their place, and a battle refuses one a Pokemon
still knows. The functions are extracted and run natively.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include "constants/moves.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define LEVEL_UP_LEARNSET_END 0xFFFF
#define LEVEL_UP_LEARNSET_MOVE(x) ((u16)((x) & 0xFFFF))
#define MOVE_FLAG_UNUSABLE_UNIMPLEMENTED (1 << 5)
typedef enum { MOVEATTR_UNK9 = 9 } MoveAttr;
enum { NARC_poketool_personal_wotbl = 33 };

static u32 GetMoveAttr(u16 move, MoveAttr attr) {
    assert(attr == MOVEATTR_UNK9);
    // Round and Rage Fist are two of the engine's seventy-nine; the other
    // bits are set on them to show only bit 5 is asked.
    return move == MOVE_ROUND || move == MOVE_RAGE_FIST ? 0xFF : 0xDF;
}
static int ResolveMonForm(int species, int form) { return species + form; }
static const u32 sLearnset[] = {
    1 << 16 | MOVE_TACKLE, 5 << 16 | MOVE_ROUND, 9 << 16 | MOVE_GROWL,
    12 << 16 | MOVE_RAGE_FIST, 20 << 16 | MOVE_RAGE_FIST, 30 << 16 | MOVE_EMBER, LEVEL_UP_LEARNSET_END,
};
static void ReadWholeNarcMemberByIdPair(void *dest, int narc, int member) {
    assert(narc == NARC_poketool_personal_wotbl && member == 7);
    for (unsigned i = 0; i < sizeof(sLearnset) / sizeof(sLearnset[0]); i++) ((u32 *)dest)[i] = sLearnset[i];
}
@NATIVE@

int main(void) {
    assert(IsMoveUnimplemented(MOVE_ROUND) && IsMoveUnimplemented(MOVE_RAGE_FIST));
    assert(!IsMoveUnimplemented(MOVE_TACKLE) && !IsMoveUnimplemented(MOVE_NONE));

    // The learnset keeps its order and its levels, without the two.
    u32 learnset[8];
    LoadLevelUpLearnset_HandleAlternateForm(6, 1, learnset);
    static const u32 wanted[] = { 1 << 16 | MOVE_TACKLE, 9 << 16 | MOVE_GROWL, 30 << 16 | MOVE_EMBER, LEVEL_UP_LEARNSET_END };
    for (unsigned i = 0; i < sizeof(wanted) / sizeof(wanted[0]); i++) assert(learnset[i] == wanted[i]);

    // A trainer's Pokemon gets nothing in that slot.
    assert(TrMon_UsableMove(MOVE_RAGE_FIST) == MOVE_NONE);
    assert(TrMon_UsableMove(MOVE_EMBER) == MOVE_EMBER);
    assert(TrMon_UsableMove(MOVE_NONE) == MOVE_NONE);
    return 0;
}
'''


class UnimplementedMoves(unittest.TestCase):
    def test_learnsets_and_trainers_leave_them_out(self):
        native = "\n".join([
            function((ROOT / "src/move.c").read_text(), "IsMoveUnimplemented"),
            function((ROOT / "src/pokemon.c").read_text(), "LoadLevelUpLearnset_HandleAlternateForm"),
            function((ROOT / "src/trainer_data.c").read_text(), "TrMon_UsableMove"),
        ])
        with tempfile.TemporaryDirectory(prefix="newgold-unimplemented-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(PREFIX.replace("@NATIVE@", native))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True,
                                    env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_both_trainer_move_paths_ask(self):
        source = (ROOT / "src/trainer_data.c").read_text()
        self.assertEqual(len(re.findall(r"MonSetMoveInSlot\(mon, TrMon_UsableMove\(", source)), 2)
        self.assertNotRegex(source, r"MonSetMoveInSlot\(mon, monSpecies\w*\[i\]\.moves\[j\]")

    def test_a_battle_refuses_one_still_known(self):
        """Last in ov12_02251A28, as in the reference's move check, with the
        line msg_0197_00620, "You can't use this move!"."""
        body = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "ov12_02251A28")
        refusal = re.search(r"\} else if \(BattleMoveTbl\(ctx, ctx->battleMons\[battlerId\]\.moves\[movePos\]\)->unkB "
                            r"& MOVE_FLAG_UNUSABLE_UNIMPLEMENTED\) \{(.*?)\n    \}\n\n    return ret;", body, re.S)
        self.assertIsNotNone(refusal)
        self.assertIn("msg->id = msg_0197_00620;", refusal.group(1))
        self.assertIn("ret = FALSE;", refusal.group(1))


if __name__ == "__main__":
    unittest.main()
