#!/usr/bin/env python3
"""The Safari Game ends when there is nowhere left to put a catch.

BtlCmd_CheckSafariGameDone ends it when the party is full and
PCStorage_FindFirstBoxWithEmptySlot answers "no box": that answer is
NUM_BOXES. The real function is extracted from src/battle and compiled
natively against the repository's constant.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include "constants/pokemon.h"
typedef int BOOL;
#define FALSE 0
typedef struct { void *storage; } BattleSystem;
typedef struct { int unused; } BattleContext;

static int sPartySize, sFirstBoxWithRoom, sJumped;
static int BattleSystem_GetPartySize(BattleSystem *bs, int battler) { (void)bs; (void)battler; return sPartySize; }
static int PCStorage_FindFirstBoxWithEmptySlot(void *storage) { (void)storage; return sFirstBoxWithRoom; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; sJumped |= n != 1; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 5; }

@CHECK@

static int done(int partySize, int firstBoxWithRoom) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { 0 };
    sPartySize = partySize;
    sFirstBoxWithRoom = firstBoxWithRoom;
    sJumped = 0;
    BtlCmd_CheckSafariGameDone(&bs, &ctx);
    return sJumped;
}

int main(void) {
    assert(done(6, NUM_BOXES));    // every box full
    assert(!done(6, 18));          // the nineteenth box has room
    assert(!done(6, 0));
    assert(!done(5, NUM_BOXES));   // room in the party
    return 0;
}
"""


class SafariBoxTests(unittest.TestCase):
    def test_the_game_ends_only_when_every_box_is_full(self):
        source = FIXTURE.replace("@CHECK@", function(read("src/battle/battle_command.c"), "BtlCmd_CheckSafariGameDone"))
        with tempfile.TemporaryDirectory(prefix="newgold-safari-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
