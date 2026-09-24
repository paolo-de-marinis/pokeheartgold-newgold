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

    def test_pickup_looks_once_the_items_are_back(self):
        # Pokemon Central (Raccolta): what Pickup and Honey Gather find is the
        # Pokemon's to hold, so the party has its items back before they look.
        pickup = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_GenerateEndOfBattleItem")
        self.assertLess(pickup.index("GiveBackHeldItems(battleSystem, ctx);"), pickup.index("ABILITY_PICKUP"))

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


# The real GiveBackHeldItems, run against a party of six.
RESTORE_FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#define PARTY_SIZE 6
#include "constants/battle.h"
#include "constants/heap.h"
#include "constants/items.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
typedef struct { u16 item; } Pokemon;
typedef struct { int unused; } Bag;
typedef struct { Pokemon party[PARTY_SIZE]; int count; u32 type; Bag bag; u8 outcome; } BattleSystem;
typedef struct { u16 itemsToRestore[PARTY_SIZE]; u8 heldItemsGivenBack, heldItemsTaken; u16 itemsTakenFromWild[2]; } BattleContext;
static u32 MaskOfFlagNo(int flag) { return 1u << flag; }

static u16 sAdded[8][2];
static int sAdds;

static int BattleSystem_GetPartySize(BattleSystem *bs, int side) { assert(side == BATTLER_PLAYER); return bs->count; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int side, int i) { assert(side == BATTLER_PLAYER); return &bs->party[i]; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->type; }
static u8 BattleSystem_GetBattleOutcomeFlags(BattleSystem *bs) { return bs->outcome; }
static Bag *BattleSystem_GetBag(BattleSystem *bs) { return &bs->bag; }
static u32 GetMonData(Pokemon *mon, int attr, void *ptr) { assert(attr == MON_DATA_HELD_ITEM && ptr == 0); return mon->item; }
static void SetMonData(Pokemon *mon, int attr, const void *value) { assert(attr == MON_DATA_HELD_ITEM); mon->item = *(const u16 *)value; }
static BOOL Bag_AddItem(Bag *bag, u16 item, u16 quantity, enum HeapID heapID) {
    (void)bag; assert(heapID == HEAP_ID_BATTLE);
    sAdded[sAdds][0] = item; sAdded[sAdds][1] = quantity; sAdds++;
    return 1;
}

@IS_BERRY@
@GIVE_BACK@

static BattleContext ctx;

static void run(u32 type, const u16 *before, const u16 *after, BattleSystem *bs) {
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsTaken = 0;
    bs->count = PARTY_SIZE;
    bs->outcome = BATTLE_OUTCOME_WIN;
    bs->type = type;
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = before[i];
        bs->party[i].item = after[i];
    }
    sAdds = 0;
    GiveBackHeldItems(bs, &ctx);
}

int main(void) {
    BattleSystem bs;
    // Started: Focus Sash, nothing, nothing, Kee, Roseli, Oran.
    // Now: nothing (used), Leftovers and Leftovers (stolen twice), nothing
    // (Kee eaten), nothing (Roseli eaten), nothing (Oran eaten).
    const u16 before[PARTY_SIZE] = { ITEM_FOCUS_SASH, ITEM_NONE, ITEM_NONE, ITEM_KEE_BERRY, ITEM_ROSELI_BERRY, ITEM_ORAN_BERRY };
    const u16 after[PARTY_SIZE] = { ITEM_NONE, ITEM_LEFTOVERS, ITEM_LEFTOVERS, ITEM_NONE, ITEM_NONE, ITEM_NONE };

    run(BATTLE_TYPE_NONE, before, after, &bs);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_LEFTOVERS && sAdded[0][1] == 2);
    assert(bs.party[0].item == ITEM_FOCUS_SASH);
    assert(bs.party[1].item == ITEM_NONE && bs.party[2].item == ITEM_NONE);
    assert(bs.party[3].item == ITEM_NONE && bs.party[4].item == ITEM_NONE && bs.party[5].item == ITEM_NONE);

    // A trainer's items are not the player's to keep.
    run(BATTLE_TYPE_TRAINER, before, after, &bs);
    assert(sAdds == 0);
    assert(bs.party[0].item == ITEM_FOCUS_SASH && bs.party[1].item == ITEM_NONE);

    // Once a battle: what Pickup finds after a battle won, with the items
    // already back, is not taken back at the battle's end.
    run(BATTLE_TYPE_NONE, before, after, &bs);
    bs.party[1].item = ITEM_POTION;
    sAdds = 0;
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 0 && bs.party[1].item == ITEM_POTION && bs.party[0].item == ITEM_FOCUS_SASH);

    // A Pokemon that ate its Berry and then took an item -- Magician, Thief --
    // ends with nothing: what it took goes back to the trainer, or to the bag
    // after a wild battle, not both.
    const u16 tookOne[PARTY_SIZE] = { ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_LEFTOVERS, ITEM_NONE, ITEM_NONE };
    run(BATTLE_TYPE_TRAINER, before, tookOne, &bs);
    assert(sAdds == 0 && bs.party[3].item == ITEM_NONE);
    run(BATTLE_TYPE_NONE, before, tookOne, &bs);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_LEFTOVERS && sAdded[0][1] == 1 && bs.party[3].item == ITEM_NONE);
    // A Berry a foe's Magician or Pickpocket took comes back, eaten or not;
    // an uneaten one stays.
    const u16 kept[PARTY_SIZE] = { ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_ROSELI_BERRY, ITEM_NONE };
    ctx.heldItemsGivenBack = 0;
    for (int i = 0; i < PARTY_SIZE; i++) {
        bs.party[i].item = kept[i];
    }
    ctx.heldItemsTaken = 1 << 5;
    GiveBackHeldItems(&bs, &ctx);
    assert(bs.party[5].item == ITEM_ORAN_BERRY && bs.party[4].item == ITEM_ROSELI_BERRY && bs.party[3].item == ITEM_NONE);

    // What was taken from a wild Pokemon that was then caught went back with
    // it: no copy for the bag. One that fainted or fled leaves it to the bag.
    const u16 tookWild[PARTY_SIZE] = { ITEM_FOCUS_SASH, ITEM_LEFTOVERS, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    run(BATTLE_TYPE_NONE, before, tookWild, &bs);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_LEFTOVERS);
    ctx.itemsTakenFromWild[1] = ITEM_LEFTOVERS;
    run(BATTLE_TYPE_NONE, before, tookWild, &bs);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_LEFTOVERS);
    ctx.heldItemsGivenBack = 0;
    bs.outcome = BATTLE_OUTCOME_MON_CAUGHT;
    for (int i = 0; i < PARTY_SIZE; i++) {
        bs.party[i].item = tookWild[i];
    }
    sAdds = 0;
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 0 && bs.party[1].item == ITEM_NONE);
    ctx.itemsTakenFromWild[1] = ITEM_NONE;

    // Swapped within the party is not gained.
    const u16 swapped[PARTY_SIZE] = { ITEM_NONE, ITEM_FOCUS_SASH, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    run(BATTLE_TYPE_NONE, before, swapped, &bs);
    assert(sAdds == 0 && bs.party[0].item == ITEM_FOCUS_SASH && bs.party[1].item == ITEM_NONE);
    return 0;
}
"""


# The real NoteHeldItemTaken and Battler_IsWild: who is marked for what.
NOTE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/items.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef struct { int unused; } Party;
typedef struct { u32 type; Party parties[4]; } BattleSystem;
typedef struct { u16 item; } BattleMon;
typedef struct { BattleMon battleMons[4]; u8 selectedMonIndex[4], heldItemsTaken; u16 itemsTakenFromWild[2]; } BattleContext;
static u32 MaskOfFlagNo(int flag) { return 1u << flag; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->type; }
static u8 BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
// A double battle's two player battlers share the player's party.
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return &bs->parties[battlerId == 2 ? 0 : battlerId]; }
@FUNCTIONS@
int main(void) {
    BattleSystem bs = { BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES };
    BattleContext ctx = { .battleMons = { { ITEM_ORAN_BERRY }, { ITEM_LEFTOVERS }, { ITEM_POTION }, { ITEM_ESCAPE_ROPE } },
                          .selectedMonIndex = { 1, 0, 4, 2 } };
    // The player's Pokemon, by party slot; a trainer's, not at all.
    NoteHeldItemTaken(&bs, &ctx, 0);
    NoteHeldItemTaken(&bs, &ctx, 2);
    NoteHeldItemTaken(&bs, &ctx, 1);
    assert(ctx.heldItemsTaken == ((1 << 1) | (1 << 4)));
    assert(ctx.itemsTakenFromWild[0] == ITEM_NONE && ctx.itemsTakenFromWild[1] == ITEM_NONE);
    // A wild one's item, by battler.
    bs.type = BATTLE_TYPE_DOUBLES;
    NoteHeldItemTaken(&bs, &ctx, 3);
    NoteHeldItemTaken(&bs, &ctx, 1);
    assert(ctx.itemsTakenFromWild[0] == ITEM_LEFTOVERS && ctx.itemsTakenFromWild[1] == ITEM_ESCAPE_ROPE);
    return 0;
}
"""


class TakenItemTests(unittest.TestCase):
    """Pokemon Central: Furto and Arraffalesto. An item taken from the
    player's Pokemon comes back after the battle; one taken from a wild
    Pokemon goes to the bag, unless the Pokemon is caught, when it keeps it."""

    def test_who_is_marked(self):
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        program = NOTE_FIXTURE.replace("@FUNCTIONS@", function(overlay, "Battler_IsWild") + function(overlay, "NoteHeldItemTaken"))
        with tempfile.TemporaryDirectory(prefix="newgold-taken-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_thief_and_covet_mark_what_they_take(self):
        thief = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TryStealItem")
        self.assertRegex(thief, r"\} else \{\n\s*NoteHeldItemTaken\(battleSystem, ctx, ctx->battlerIdTarget\);\n\s*\}\n\s*\}\n\n\s*return FALSE;")

    def test_a_caught_pokemon_gets_its_item_back(self):
        # Before the Pokemon is stored, whichever way it is stored; the other
        # wild Pokemon's item is left to the bag.
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        state = commands[commands.index("case STATE_GET_POKEMON_CHECK_MON_DATA:"):commands.index("case STATE_GET_POKEMON_FADE_TO_POKEDEX:")]
        give = state.index("SetMonData(mon, MON_DATA_HELD_ITEM, &taken[battlerId >> 1]);")
        self.assertLess(state.index("Pokemon *mon = BattleSystem_GetPartyMon("), give)
        self.assertLess(give, state.index("BATTLE_TYPE_PAL_PARK | BATTLE_TYPE_TUTORIAL"))
        self.assertIn("taken[(battlerId >> 1) ^ 1] = ITEM_NONE;", state)


class RestoreItemsTests(unittest.TestCase):
    """RESTORE_ITEMS_AT_BATTLE_END as the reference writes it
    (battle_pokemon.c): the Gen 6+ berries stay eaten, a Pokemon that held
    nothing holds nothing again, and what the party took in a wild battle
    goes to the bag, once."""

    def test_the_real_function_on_a_party(self):
        source = CONTROLLER.read_text()
        program = (RESTORE_FIXTURE.replace("@IS_BERRY@", function(source, "IsBerry"))
                   .replace("@GIVE_BACK@", function(source, "GiveBackHeldItems")))
        with tempfile.TemporaryDirectory(prefix="newgold-restore-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
