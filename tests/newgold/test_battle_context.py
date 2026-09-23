#!/usr/bin/env python3
"""Check that nothing reads a party before the battle system has one.

ov12_02238A68 builds the battle context first and copies the parties in after,
so inside BattleContext_New every entry of trainerParty is still NULL. A call
there to BattleSystem_GetPartySize ends in Party_GetCount(NULL): on hardware,
and in a melonDS that raises data aborts, that is a black screen with the music
still playing. The libretro core the harness runs on reads address 4 as zero
and carries on, which is how nine battles in a row passed with the bug in.

The held items are written down from the first controller command instead,
which runs once the parties are in place, and given back at the last one --
which is also where a bad poisoning is eased.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
PARTY_READERS = ("BattleSystem_GetPartySize", "BattleSystem_GetPartyMon",
                 "RememberHeldItems", "Party_GetCount")


def body(name):
    text = CONTROLLER.read_text()
    match = re.search(r"\n[A-Za-z_][A-Za-z_0-9 *]*\b" + name + r"\([^)]*\) \{\n(.*?)\n\}\n",
                      text, re.S)
    assert match, f"{name} is not in {CONTROLLER}"
    return match.group(1)


class BattleContextTests(unittest.TestCase):
    def test_the_context_is_built_without_a_party(self):
        new = body("BattleContext_New")
        for reader in PARTY_READERS:
            self.assertNotIn(reader, new,
                             f"BattleContext_New calls {reader} before the parties are set")

    def test_held_items_are_remembered_once_the_parties_are_in(self):
        self.assertIn("RememberHeldItems(battleSystem, ctx);",
                      body("BattleControllerPlayer_GetBattleMon"))

    def test_held_items_are_given_back(self):
        self.assertIn("GiveBackHeldItems(battleSystem, ctx);", body("BattleContext_Main"))

    def test_a_bad_poisoning_ends_with_the_battle(self):
        """hg-engine's RevertFormChange turns each of the player's badly
        poisoned Pokemon ordinarily poisoned as the battle ends; the real
        EaseBadPoison, run on the host over a party of every status bit."""
        self.assertIn("EaseBadPoison(battleSystem);", body("BattleContext_Main"))
        program = POISON_FIXTURE.replace("@EASE@", function(CONTROLLER.read_text(), "EaseBadPoison"))
        with tempfile.TemporaryDirectory(prefix="newgold-poison-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)


POISON_FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/battle.h"
typedef uint32_t u32;
enum { PARTY_SIZE = 6, MON_DATA_STATUS = 1 };
typedef struct { u32 status; int writes; } Pokemon;
typedef struct { int count[2]; Pokemon mons[2][PARTY_SIZE]; } BattleSystem;
static int BattleSystem_GetPartySize(BattleSystem *bs, int side) { return bs->count[side]; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int side, int i) { return &bs->mons[side][i]; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) { assert(attr == MON_DATA_STATUS && !out); return mon->status; }
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr == MON_DATA_STATUS); mon->status = *(const u32 *)value; mon->writes++;
}
@EASE@
int main(void) {
    for (u32 bit = 0; bit < 32; bit++) {
        BattleSystem bs = { .count = { 5, 6 } };
        for (int i = 0; i < PARTY_SIZE; i++) {
            bs.mons[0][i].status = bs.mons[1][i].status = (1u << bit) | (i == 1 ? STATUS_BAD_POISON : 0);
        }
        EaseBadPoison(&bs);
        for (int i = 0; i < PARTY_SIZE; i++) {
            u32 before = (1u << bit) | (i == 1 ? STATUS_BAD_POISON : 0);
            u32 eased = (before & ~STATUS_BAD_POISON) | STATUS_POISON;
            int changes = i < 5 && (before & STATUS_BAD_POISON);
            assert(bs.mons[0][i].status == (changes ? eased : before));
            assert(bs.mons[0][i].writes == changes);
            assert(bs.mons[1][i].status == before && bs.mons[1][i].writes == 0);
        }
    }
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()
