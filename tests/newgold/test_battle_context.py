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
typedef struct { u16 item; } BattleMon;
typedef struct { BattleMon battleMons[BATTLER_MAX]; u16 itemsToRestore[PARTY_SIZE]; u8 heldItemsGivenBack, heldItemsTaken, heldItemsCount; u16 itemsTakenFromWild[2]; u8 heldItemsGiven; } BattleContext;
static u32 MaskOfFlagNo(int flag) { return 1u << flag; }

static u16 sAdded[8][2];
static int sAdds;

// The party as it is now, which GiveBackHeldItems no longer counts by.
__attribute__((unused)) static int BattleSystem_GetPartySize(BattleSystem *bs, int side) { assert(side == BATTLER_PLAYER); return bs->count; }
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
    ctx.heldItemsGiven = 0;
    ctx.heldItemsCount = PARTY_SIZE;
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
    // A Berry handed over by Trick comes back after a trainer battle, the
    // Leftovers got for it going back to the trainer; one the trainer's
    // Pokemon then ate does not (NoteHeldItemUsedUp emptied its entry).
    const u16 tricked[PARTY_SIZE] = { ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_LEFTOVERS };
    for (int eaten = 0; eaten < 2; eaten++) {
        for (int i = 0; i < PARTY_SIZE; i++) {
            ctx.itemsToRestore[i] = before[i];
            bs.party[i].item = tricked[i];
        }
        if (eaten) {
            ctx.itemsToRestore[5] = ITEM_NONE;
        }
        ctx.heldItemsGivenBack = 0;
        ctx.heldItemsTaken = 0;
        ctx.heldItemsGiven = 1 << 5;
        bs.type = BATTLE_TYPE_TRAINER;
        sAdds = 0;
        GiveBackHeldItems(&bs, &ctx);
        assert(sAdds == 0 && bs.party[5].item == (eaten ? ITEM_NONE : ITEM_ORAN_BERRY));
    }
    ctx.heldItemsGiven = 0;

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

    // Tricked with a wild Pokemon that was then caught: it keeps the Focus
    // Sash it was handed, the player's Pokemon the Leftovers it got, and the
    // bag gets neither (Raggiro, Rapidscambio). Before, the Sash came back
    // too and the Leftovers went to the bag.
    const u16 swappedWild[PARTY_SIZE] = { ITEM_LEFTOVERS, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    Pokemon caught = { ITEM_FOCUS_SASH };
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = before[i];
        bs.party[i].item = swappedWild[i];
    }
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsGiven = 1 << 0;
    bs.type = BATTLE_TYPE_NONE;
    bs.outcome = BATTLE_OUTCOME_MON_CAUGHT;
    sAdds = 0;
    CaughtMonKeepsItem(&bs, &ctx, &caught);
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 0 && bs.party[0].item == ITEM_LEFTOVERS && caught.item == ITEM_FOCUS_SASH);
    // One caught with an item of its own, the Sash with the other wild
    // Pokemon of a double battle: the swap lasts all the same, and the Sash
    // goes to the bag.
    caught.item = ITEM_POTION;
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = before[i];
        bs.party[i].item = swappedWild[i];
    }
    ctx.battleMons[3].item = ITEM_FOCUS_SASH;
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsGiven = 1 << 0;
    sAdds = 0;
    CaughtMonKeepsItem(&bs, &ctx, &caught);
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_FOCUS_SASH && bs.party[0].item == ITEM_LEFTOVERS);
    ctx.battleMons[3].item = ITEM_NONE;
    // Two of the party Trick the wild one in turn and the second's item is
    // knocked off it, marked as lost, then the second Bestows the first's to
    // it, and it is caught with that: the first keeps the wild one's own
    // item, which it got, and only the second's, lost, goes to the bag.
    // Before, the first's entry, rewritten by the catch, was still marked as
    // handed over, and the item it now names was found among those lost: a
    // second copy bagged.
    const u16 started[PARTY_SIZE] = { ITEM_SILK_SCARF, ITEM_EVERSTONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    const u16 ended[PARTY_SIZE] = { ITEM_EVERSTONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = started[i];
        bs.party[i].item = ended[i];
    }
    caught.item = ITEM_SILK_SCARF;
    ctx.heldItemsTaken = 1 << 1;
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsGiven = (1 << 0) | (1 << 1);
    sAdds = 0;
    CaughtMonKeepsItem(&bs, &ctx, &caught);
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 1 && sAdded[0][0] == ITEM_EVERSTONE && sAdded[0][1] == 1);
    assert(bs.party[0].item == ITEM_EVERSTONE && bs.party[1].item == ITEM_NONE && caught.item == ITEM_SILK_SCARF);
    // The two items handed to the wild one both knocked off it, and it not
    // caught: both go to the bag, and each of the two keeps what it got,
    // nothing. Before, only the last item a battler lost was written down,
    // and the first was not bagged.
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = started[i];
        bs.party[i].item = ITEM_NONE;
    }
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsGiven = ctx.heldItemsTaken = (1 << 0) | (1 << 1);
    bs.outcome = BATTLE_OUTCOME_WIN;
    sAdds = 0;
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 2 && sAdded[0][0] == ITEM_SILK_SCARF && sAdded[1][0] == ITEM_EVERSTONE);
    assert(bs.party[0].item == ITEM_NONE && bs.party[1].item == ITEM_NONE);
    ctx.heldItemsTaken = 0;

    // Tricked with a wild Pokemon that then fainted or fled: the swap lasts
    // (Rapidscambio) -- the player's Pokemon keeps the Leftovers it got, and
    // the Focus Sash it handed over goes to the bag (Raggiro, from the ninth
    // generation: what was handed to a wild Pokemon goes back to the bag at
    // the battle's end), whether the wild one still holds it, or has used
    // it up or lost it to Knock Off, Corrosive Gas or Incinerate, which
    // marks it as lost (NoteHeldItemUsedUp, BtlCmd_TryKnockOff; the third
    // pass: before, it was gone). Before all this, the Sash came back to the
    // Pokemon and the Leftovers went to the bag. With none of the wild ones
    // and no mark (the fourth pass), it is back on the player's side, and no
    // copy.
    for (int used = 0; used < 4; used++) {
        for (int i = 0; i < PARTY_SIZE; i++) {
            ctx.itemsToRestore[i] = before[i];
            bs.party[i].item = swappedWild[i];
        }
        ctx.battleMons[1].item = used == 0 ? ITEM_FOCUS_SASH : ITEM_NONE;
        ctx.heldItemsGivenBack = 0;
        ctx.heldItemsTaken = used == 1 || used == 2 ? 1 << 0 : 0;
        ctx.heldItemsGiven = 1 << 0;
        bs.outcome = BATTLE_OUTCOME_WIN;
        sAdds = 0;
        GiveBackHeldItems(&bs, &ctx);
        assert(bs.party[0].item == ITEM_LEFTOVERS);
        assert(used == 3 ? sAdds == 0 : sAdds == 1 && sAdded[0][0] == ITEM_FOCUS_SASH && sAdded[0][1] == 1);
    }
    ctx.battleMons[1].item = ITEM_NONE;
    ctx.heldItemsGiven = ctx.heldItemsTaken = 0;

    // Swapped within the party is not gained.
    const u16 swapped[PARTY_SIZE] = { ITEM_NONE, ITEM_FOCUS_SASH, ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE };
    run(BATTLE_TYPE_NONE, before, swapped, &bs);
    assert(sAdds == 0 && bs.party[0].item == ITEM_FOCUS_SASH && bs.party[1].item == ITEM_NONE);

    // A wild Pokemon caught into the party, which the catch has grown from
    // five to six before the battle's end, keeps the item it holds: it is
    // not one of the five whose items were written down. Before, its Oval
    // Stone went to the bag and it was left holding nothing.
    const u16 grown[PARTY_SIZE] = { ITEM_FOCUS_SASH, ITEM_NONE, ITEM_NONE, ITEM_KEE_BERRY, ITEM_ROSELI_BERRY, ITEM_OVAL_STONE };
    for (int i = 0; i < PARTY_SIZE; i++) {
        ctx.itemsToRestore[i] = i < 5 ? before[i] : ITEM_NONE;
        bs.party[i].item = grown[i];
    }
    ctx.heldItemsGivenBack = 0;
    ctx.heldItemsTaken = 0;
    ctx.heldItemsCount = 5;
    bs.type = BATTLE_TYPE_NONE;
    bs.outcome = BATTLE_OUTCOME_MON_CAUGHT;
    sAdds = 0;
    GiveBackHeldItems(&bs, &ctx);
    assert(sAdds == 0 && bs.party[5].item == ITEM_OVAL_STONE && bs.party[0].item == ITEM_FOCUS_SASH);
    return 0;
}
"""


# The real NoteHeldItemTaken, NoteHeldItemGiven and NoteHeldItemUsedUp, with
# Battler_IsWild and Battler_PartySlot: who is marked for what, and whose item
# each Pokemon holds (heldItemOwner).
NOTE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/items.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define PARTY_SIZE 6
typedef struct { int unused; } Party;
typedef struct { u32 type; Party parties[4]; } BattleSystem;
typedef struct { u16 item; } BattleMon;
typedef struct {
    BattleMon battleMons[4]; u8 selectedMonIndex[4], heldItemsTaken, heldItemsGiven;
    u16 itemsTakenFromWild[2], itemsToRestore[PARTY_SIZE]; u8 heldItemOwner[BATTLER_MAX * PARTY_SIZE];
} BattleContext;
static BOOL BattleItemIsBerry(u16 item) { return item == ITEM_ORAN_BERRY || item == ITEM_SITRUS_BERRY; }
static u32 MaskOfFlagNo(int flag) { return 1u << flag; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->type; }
static u8 BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
// A double battle's two player battlers share the player's party, and the two
// foes theirs (BattleSystem_GetParty outside a multi battle).
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return &bs->parties[battlerId & 1]; }
@FUNCTIONS@
// The tag battler b's Pokemon carries.
static int tag(BattleSystem *bs, BattleContext *ctx, int b) { return ctx->heldItemOwner[Battler_PartySlot(bs, ctx, b)]; }
// A trainer's double battle: the player's slots 1 and 4 out (battlers 0 and
// 2), each holding the Oran Berry it started with, tagged as
// RememberHeldItems tags them; the trainer's battler 1 holds Leftovers, its
// battler 3 nothing.
static void reset(BattleSystem *bs, BattleContext *ctx) {
    const BattleContext start = { .battleMons = { { ITEM_ORAN_BERRY }, { ITEM_LEFTOVERS }, { ITEM_ORAN_BERRY }, { ITEM_NONE } },
                                  .selectedMonIndex = { 1, 0, 4, 2 }, .itemsToRestore = { [1] = ITEM_ORAN_BERRY, [4] = ITEM_ORAN_BERRY },
                                  .heldItemOwner = { [1] = 2, [4] = 5 } };
    bs->type = BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES;
    *ctx = start;
}
int main(void) {
    BattleSystem bs;
    BattleContext ctx;

    // Taken from the player's Pokemon: marked by party slot, the tag going
    // with the item. Taken from the trainer's: no mark. Taken back from the
    // trainer's: no mark either, the trainer's Pokemon not being its owner.
    reset(&bs, &ctx);
    NoteHeldItemTaken(&bs, &ctx, 3, 0);
    assert(ctx.heldItemsTaken == 1 << 1 && tag(&bs, &ctx, 3) == 2 && tag(&bs, &ctx, 0) == 0);
    NoteHeldItemTaken(&bs, &ctx, 0, 1);
    assert(ctx.heldItemsTaken == 1 << 1 && tag(&bs, &ctx, 0) == 0);
    NoteHeldItemTaken(&bs, &ctx, 1, 0);
    assert(ctx.heldItemsTaken == 1 << 1 && ctx.heldItemsGiven == 0);
    assert(ctx.itemsTakenFromWild[0] == ITEM_NONE && ctx.itemsTakenFromWild[1] == ITEM_NONE);
    // A Berry taken, not handed over, stays the player's even eaten.
    ctx.battleMons[3].item = ITEM_ORAN_BERRY;
    NoteHeldItemUsedUp(&bs, &ctx, 3);
    assert(ctx.itemsToRestore[1] == ITEM_ORAN_BERRY && ctx.heldItemsTaken == 1 << 1);

    // A wild one's item, by battler.
    reset(&bs, &ctx);
    bs.type = BATTLE_TYPE_DOUBLES;
    ctx.battleMons[0].item = ITEM_NONE;
    ctx.heldItemOwner[1] = 0;
    ctx.battleMons[3].item = ITEM_ESCAPE_ROPE;
    NoteHeldItemTaken(&bs, &ctx, 0, 3);
    NoteHeldItemTaken(&bs, &ctx, 2, 1);
    assert(ctx.itemsTakenFromWild[0] == ITEM_LEFTOVERS && ctx.itemsTakenFromWild[1] == ITEM_ESCAPE_ROPE);
    assert(ctx.heldItemsTaken == 0);

    // Trick and Switcheroo: the player's Pokemon handing over the Oran Berry
    // it started with is marked, and the two tags change places.
    reset(&bs, &ctx);
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    ctx.battleMons[0].item = ITEM_LEFTOVERS;
    ctx.battleMons[1].item = ITEM_ORAN_BERRY;
    assert(ctx.heldItemsGiven == 1 << 1 && ctx.heldItemsTaken == 0);
    assert(tag(&bs, &ctx, 0) == 0 && tag(&bs, &ctx, 1) == 2);
    // The other of the player's eats its own Oran Berry, and the trainer's
    // other Pokemon one of its own, while the handed one is still held: theirs,
    // not the handed one. Before, matched by kind, either emptied slot 1's
    // entry, and the Oran Berry it handed over was not had back.
    NoteHeldItemUsedUp(&bs, &ctx, 2);
    ctx.battleMons[3].item = ITEM_ORAN_BERRY;
    NoteHeldItemUsedUp(&bs, &ctx, 3);
    assert(ctx.itemsToRestore[1] == ITEM_ORAN_BERRY && ctx.heldItemsGiven == 1 << 1);
    // The trainer's Pokemon eats the handed one: gone for good (Raggiro).
    // The tag stays, for a Recycle or a Harvest to bring back the same Berry.
    NoteHeldItemUsedUp(&bs, &ctx, 1);
    assert(ctx.itemsToRestore[1] == ITEM_NONE && ctx.itemsToRestore[4] == ITEM_ORAN_BERRY && tag(&bs, &ctx, 1) == 2);
    // Handing over the Leftovers it got in the battle marks nothing.
    NoteHeldItemGiven(&bs, &ctx, 0, 3);
    assert(ctx.heldItemsGiven == 1 << 1);

    // An empty hand hands nothing over. The player's Pokemon eats its own
    // Oran Berry (the tag stays, for Recycle), then the trainer's Bestow
    // gives it the Leftovers, or its own Trick takes them: nobody is marked,
    // and the Berry stays eaten. Before, the tag left on the empty hand
    // marked the Berry as handed over, and it came back.
    reset(&bs, &ctx);
    NoteHeldItemUsedUp(&bs, &ctx, 0);
    ctx.battleMons[0].item = ITEM_NONE;
    NoteHeldItemGiven(&bs, &ctx, 1, 0);
    assert(ctx.heldItemsGiven == 0 && ctx.heldItemsTaken == 0 && tag(&bs, &ctx, 0) == 0 && tag(&bs, &ctx, 1) == 0);
    reset(&bs, &ctx);
    NoteHeldItemUsedUp(&bs, &ctx, 0);
    ctx.battleMons[0].item = ITEM_NONE;
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    assert(ctx.heldItemsGiven == 0 && ctx.heldItemsTaken == 0 && tag(&bs, &ctx, 0) == 0 && tag(&bs, &ctx, 1) == 0);
    // In a wild battle, a Focus Sash used up and then the wild Pokemon's
    // Leftovers Tricked off it: nothing marked, so the Sash is the
    // Pokemon's again and the Leftovers go to the bag (GiveBackHeldItems).
    // Before, the Sash was marked as handed over and lost.
    reset(&bs, &ctx);
    bs.type = BATTLE_TYPE_DOUBLES;
    ctx.battleMons[0].item = ctx.itemsToRestore[1] = ITEM_FOCUS_SASH;
    NoteHeldItemUsedUp(&bs, &ctx, 0);
    ctx.battleMons[0].item = ITEM_NONE;
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    assert(ctx.heldItemsGiven == 0 && ctx.heldItemsTaken == 0 && ctx.itemsToRestore[1] == ITEM_FOCUS_SASH);

    // Its own Oran Berry handed over by Trick, Tricked back, taken by Thief
    // and taken back, then eaten by itself: eaten, the marks gone, so it is
    // not had back again when the battle is over.
    reset(&bs, &ctx);
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    NoteHeldItemGiven(&bs, &ctx, 1, 0);
    assert(tag(&bs, &ctx, 0) == 2 && tag(&bs, &ctx, 1) == 0);
    NoteHeldItemTaken(&bs, &ctx, 1, 0);
    NoteHeldItemTaken(&bs, &ctx, 0, 1);
    assert(ctx.heldItemsTaken == 1 << 1 && ctx.heldItemsGiven == 1 << 1 && tag(&bs, &ctx, 0) == 2);
    NoteHeldItemUsedUp(&bs, &ctx, 0);
    assert(ctx.heldItemsTaken == 0 && ctx.heldItemsGiven == 0 && ctx.itemsToRestore[1] == ITEM_ORAN_BERRY && tag(&bs, &ctx, 0) == 2);

    // A White Herb handed over and used up by the Pokemon it went to is
    // marked as lost, as one knocked off is: it comes back, to the bag from a
    // wild Pokemon (Raggiro). Tricked back and used by its owner, it is the
    // owner's own item used, and the marks go, as for a Berry.
    reset(&bs, &ctx);
    ctx.battleMons[0].item = ctx.itemsToRestore[1] = ITEM_WHITE_HERB;
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    ctx.battleMons[1].item = ITEM_WHITE_HERB;
    NoteHeldItemUsedUp(&bs, &ctx, 1);
    assert(ctx.heldItemsTaken == 1 << 1 && ctx.heldItemsGiven == 1 << 1 && ctx.itemsToRestore[1] == ITEM_WHITE_HERB);
    reset(&bs, &ctx);
    ctx.battleMons[0].item = ctx.itemsToRestore[1] = ITEM_WHITE_HERB;
    NoteHeldItemGiven(&bs, &ctx, 0, 1);
    NoteHeldItemGiven(&bs, &ctx, 1, 0);
    NoteHeldItemUsedUp(&bs, &ctx, 0);
    assert(ctx.heldItemsTaken == 0 && ctx.heldItemsGiven == 0 && ctx.itemsToRestore[1] == ITEM_WHITE_HERB);
    return 0;
}
"""


# The real BtlCmd_TryIncinerate: what it burns, and the party's copy after.
INCINERATE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/items.h"
typedef uint16_t u16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u16 item; int hp; } BattleMon;
typedef struct { BattleMon battleMons[4]; int battlerIdAttacker, battlerIdTarget, battlerIdTemp; u16 itemTemp; } BattleContext;
typedef struct BattleSystem BattleSystem;
static int sCopies, sCopied = -1, sHeldAtCopy = -1;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 1; }
static BOOL BattleItemIsBerry(u16 item) { return item == ITEM_ORAN_BERRY; }
// The Gems' records, and only theirs, have the hold effect that powers a move once.
static int GetItemVar(BattleContext *ctx, u16 item, u16 var) {
    (void)ctx; assert(var == ITEM_VAR_HOLD_EFFECT); return item == ITEM_FIRE_GEM ? HOLD_EFFECT_POWERING_UP_MOVE_ONCE : HOLD_EFFECT_NONE;
}
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int a, int b, int ability) { (void)ctx; (void)a; (void)b; (void)ability; return FALSE; }
static int sUsedUp = -1;
static void NoteHeldItemUsedUp(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; sUsedUp = battlerId; }
static void CopyBattleMonToPartyMon(BattleSystem *bs, BattleContext *ctx, int battlerId) {
    (void)bs; sCopies++; sCopied = battlerId; sHeldAtCopy = ctx->battleMons[battlerId].item;
}
@INCINERATE@
int main(void) {
    BattleContext ctx = { .battleMons = { [1] = { ITEM_ORAN_BERRY, 10 } }, .battlerIdAttacker = 0, .battlerIdTarget = 1 };
    BtlCmd_TryIncinerate(0, &ctx);
    assert(ctx.battleMons[1].item == ITEM_NONE && ctx.itemTemp == ITEM_ORAN_BERRY && ctx.battlerIdTemp == 1);
    assert(sCopies == 1 && sCopied == 1 && sHeldAtCopy == ITEM_NONE);
    // A Gem burns as well (Pokemon Central, Bruciatutto: from the sixth
    // generation), used up as a Berry is: one the player's Pokemon handed a
    // wild Pokemon is marked as lost, and goes to the bag at the battle's end
    // (NoteHeldItemUsedUp, GiveBackHeldItems).
    sUsedUp = -1;
    ctx.battleMons[1].item = ITEM_FIRE_GEM;
    BtlCmd_TryIncinerate(0, &ctx);
    assert(ctx.battleMons[1].item == ITEM_NONE && ctx.itemTemp == ITEM_FIRE_GEM && sCopies == 2 && sUsedUp == 1);
    // Nothing burnt, nothing copied, nothing used up.
    sUsedUp = -1;
    ctx.battleMons[1].item = ITEM_LEFTOVERS;
    BtlCmd_TryIncinerate(0, &ctx);
    assert(sCopies == 2 && ctx.battleMons[1].item == ITEM_LEFTOVERS && sUsedUp == -1);
    return 0;
}
"""


# The real BtlCmd_TrySwapItems: which branch Trick, Switcheroo and Bestow take,
# and who is marked for the battle's end.
SWAP_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/items.h"
#include "constants/moves.h"
typedef uint16_t u16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u16 item; } BattleMon;
typedef struct { BattleMon battleMons[4]; int battlerIdAttacker, battlerIdTarget; u16 moveNoCur; } BattleContext;
typedef struct BattleSystem BattleSystem;
// The second address is the script's Sticky Hold branch: Trick's goes to its
// own line, Bestow's is the next line, 0 (subscript 308).
static int sWords, sJump, sMarked, sStickyHold, sStickyBranch;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; if (n != 1) sJump = n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return ++sWords == 1 ? 100 : sStickyBranch; }
static BOOL CanTrickHeldItem(BattleContext *ctx, int a, int b) { (void)ctx; (void)a; (void)b; return TRUE; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int a, int b, int ability) {
    (void)ctx; (void)a; assert(b == 1 && ability == ABILITY_STICKY_HOLD); return sStickyHold;
}
static void NoteHeldItemGiven(BattleSystem *bs, BattleContext *ctx, int a, int b) { (void)bs; (void)ctx; sMarked |= 1 << a | 1 << b; }
@SWAP@
static void use(BattleContext *ctx, u16 move) {
    sWords = sJump = sMarked = 0;
    sStickyBranch = move == MOVE_BESTOW ? 0 : 200;
    ctx->moveNoCur = move;
    BtlCmd_TrySwapItems(0, ctx);
}
int main(void) {
    BattleContext ctx = { .battleMons = { { ITEM_CHERI_BERRY }, { ITEM_NONE } }, .battlerIdAttacker = 0, .battlerIdTarget = 1 };
    // No Sticky Hold: both handed over, both marked.
    use(&ctx, MOVE_TRICK);
    assert(sJump == 0 && sMarked == 3);
    // Sticky Hold turns Trick and Switcheroo away by the second branch.
    sStickyHold = TRUE;
    use(&ctx, MOVE_TRICK);
    assert(sJump == 200 && sMarked == 0);
    use(&ctx, MOVE_SWITCHEROO);
    assert(sJump == 200 && sMarked == 0);
    // Bestow takes nothing from the target: the gift goes on, marked.
    use(&ctx, MOVE_BESTOW);
    assert(sJump == 0 && sMarked == 3);
    return 0;
}
"""


class TakenItemTests(unittest.TestCase):
    """Pokemon Central: Furto and Arraffalesto. An item taken from the
    player's Pokemon comes back after the battle; one taken from a wild
    Pokemon goes to the bag, unless the Pokemon is caught, when it keeps it."""

    def test_who_is_marked(self):
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        program = NOTE_FIXTURE.replace("@FUNCTIONS@", function(overlay, "Battler_IsWild") + function(overlay, "Battler_PartySlot")
                                                + function(overlay, "NoteHeldItemTaken")
                                                + function(overlay, "NoteHeldItemGiven") + function(overlay, "NoteHeldItemUsedUp"))
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
        self.assertRegex(thief, r"\} else \{\n\s*NoteHeldItemTaken\(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget\);\n"
                                r"\s*\}\n\s*\}\n\n\s*return FALSE;")

    def test_trick_and_switcheroo_mark_what_the_player_hands_over(self):
        # Pokemon Central (Raggiro, Rapidscambio): from the fifth generation
        # a swap does not outlast a battle against a trainer, a Berry
        # included.
        swap = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TrySwapItems")
        self.assertRegex(swap, r"ABILITY_STICKY_HOLD\) == TRUE\) \{\n\s*BattleScriptIncrementPointer\(ctx, adrsB\);\n\s*\} else \{\n"
                               r"\s*NoteHeldItemGiven\(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget\);\n\s*\}")

    def test_bestow_marks_what_it_hands_to_a_sticky_hold_holder(self):
        # Pokemon Central (Cediregalo): an item given to a trainer's Pokemon
        # comes back at the battle's end, Sticky Hold or not -- it keeps its
        # own item from Trick, and Bestow takes none. Bestow's subscript
        # gives the ability no branch (test_knock_off pins its next line).
        program = SWAP_FIXTURE.replace("@SWAP@", function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TrySwapItems"))
        with tempfile.TemporaryDirectory(prefix="newgold-swap-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_a_berry_handed_over_and_used_up_is_gone(self):
        # Pokemon Central (Raggiro): the swapped item comes back unless it
        # was consumed. Every held item used up leaves through RemoveItem,
        # a burnt Berry through Incinerate's command.
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        self.assertIn("NoteHeldItemUsedUp(battleSystem, ctx, battlerId);", function(commands, "BtlCmd_RemoveItem"))
        burn = function(commands, "BtlCmd_TryIncinerate")
        self.assertLess(burn.index("NoteHeldItemUsedUp(battleSystem, ctx, ctx->battlerIdTarget);"),
                        burn.index("ctx->battleMons[ctx->battlerIdTarget].item = ITEM_NONE;"))

    def test_a_burnt_berry_leaves_the_party_s_hand_too(self):
        # The party holds what the battler holds at once, as after Knock Off:
        # a burnt Berry of the player's is not had back at the battle's end,
        # nor kept by a wild Pokemon caught before the next copy.
        program = INCINERATE_FIXTURE.replace("@INCINERATE@", function((ROOT / "src/battle/battle_command.c").read_text(),
                                                                      "BtlCmd_TryIncinerate"))
        with tempfile.TemporaryDirectory(prefix="newgold-incinerate-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_each_pokemon_starts_holding_its_own(self):
        # Whose item each holds (heldItemOwner): its own, if it has one.
        self.assertIn("ctx->heldItemOwner[i] = ctx->itemsToRestore[i] != ITEM_NONE ? i + 1 : 0;",
                      function(CONTROLLER.read_text(), "RememberHeldItems"))

    def test_symbiosis_hands_the_tag_over_with_the_item(self):
        # The partner's item goes with whose it is, unmarked: a Berry of the
        # player's handed on by Symbiosis and eaten is gone, as eaten.
        hand = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "TrySymbiosisHandOver")
        self.assertRegex(hand, r"ctx->battleMons\[j\]\.item = ITEM_NONE;\n(\s*//.*\n)*"
                               r"\s*k = Battler_PartySlot\(battleSystem, ctx, j\);\n"
                               r"\s*ctx->heldItemOwner\[Battler_PartySlot\(battleSystem, ctx, battlerId\)\] = ctx->heldItemOwner\[k\];\n"
                               r"\s*ctx->heldItemOwner\[k\] = 0;\n")

    def test_the_items_are_written_down_with_the_party_count(self):
        # GiveBackHeldItems gives back to the Pokemon the battle started with,
        # not to one caught into the party since.
        self.assertIn("ctx->heldItemsCount = count;", function(CONTROLLER.read_text(), "RememberHeldItems"))
        self.assertIn("int count = ctx->heldItemsCount;", function(CONTROLLER.read_text(), "GiveBackHeldItems"))

    def test_a_caught_pokemon_gets_its_item_back(self):
        # Before the Pokemon is stored, whichever way it is stored; the other
        # wild Pokemon's item is left to the bag.
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        state = commands[commands.index("case STATE_GET_POKEMON_CHECK_MON_DATA:"):commands.index("case STATE_GET_POKEMON_FADE_TO_POKEDEX:")]
        give = state.index("SetMonData(mon, MON_DATA_HELD_ITEM, &taken[battlerId >> 1]);")
        self.assertLess(state.index("Pokemon *mon = BattleSystem_GetPartyMon("), give)
        self.assertLess(give, state.index("BATTLE_TYPE_PAL_PARK | BATTLE_TYPE_TUTORIAL"))
        self.assertIn("taken[(battlerId >> 1) ^ 1] = ITEM_NONE;\n            CaughtMonKeepsItem(data->battleSystem, data->ctx, mon);", state)


class RestoreItemsTests(unittest.TestCase):
    """RESTORE_ITEMS_AT_BATTLE_END as the reference writes it
    (battle_pokemon.c): the Gen 6+ berries stay eaten, a Pokemon that held
    nothing holds nothing again, and what the party took in a wild battle
    goes to the bag, once."""

    def test_the_real_function_on_a_party(self):
        source = CONTROLLER.read_text()
        program = (RESTORE_FIXTURE.replace("@IS_BERRY@", function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "BattleItemIsBerry"))
                   .replace("@GIVE_BACK@", function(source, "GiveBackHeldItems") + function(source, "CaughtMonKeepsItem")))
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
