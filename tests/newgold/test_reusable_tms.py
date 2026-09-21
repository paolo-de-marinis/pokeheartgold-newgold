#!/usr/bin/env python3
"""Run the native reusable-machine decisions with host sanitizers.

ItemIsTM, Bag_GetItemSlotForAdd and PartyMenu_LearnMoveToSlot are extracted
from the repository and compiled against its own item constants. The bag
pockets, party data and friendship helpers are controlled stand-ins, so this
checks which item is consumed and how many copies the bag accepts, not the
bag interface or its rendering.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/items.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define HEAP_ID_PARTY_MENU 0
#define FRIENDSHIP_EVENT_LEARN_TMHM 4
#define MON_MOOD_MODIFIER_LEARN_TMHM 3
enum HeapID { HEAP_ID_DUMMY };

typedef struct { u16 id, quantity; } ItemSlot;
typedef struct Bag Bag;
typedef struct Pokemon Pokemon;
typedef struct { u16 moveId, itemId; Bag *bag; void *party; } PartyMenuArgs;
typedef struct PartyMenu { PartyMenuArgs *args; } PartyMenu;

static u16 requestedMax;
static ItemSlot slotStorage;
static u16 takenItem;
static unsigned takeCalls, friendshipCalls, moodCalls;
static u16 learnedMove;
static u32 learnedPPUps, learnedPP;

static u32 Bag_GetItemPocket(Bag *bag, u16 itemId, ItemSlot **slots, u32 *count, enum HeapID heapID) {
    (void)bag; (void)heapID;
    *slots = &slotStorage;
    *count = 1;
    return (itemId >= ITEM_TM01 && itemId <= ITEM_HM08) ? POCKET_TMHMS : POCKET_ITEMS;
}
static ItemSlot *Pocket_GetItemSlotForAdd(ItemSlot *slots, u32 count, u16 itemId, u16 quantity, u16 max) {
    (void)count; (void)itemId; (void)quantity;
    requestedMax = max;
    return slots;
}
static void Bag_TakeItem(Bag *bag, u16 itemId, u16 quantity, enum HeapID heapID) {
    (void)bag; (void)heapID;
    assert(quantity == 1);
    takenItem = itemId;
    takeCalls++;
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    (void)mon;
    if (attr == MON_DATA_MOVE1) learnedMove = (u16)*(const int *)value;
    else if (attr == MON_DATA_MOVE1_PP_UPS) learnedPPUps = (u32)*(const int *)value;
    else if (attr == MON_DATA_MOVE1_PP) learnedPP = (u32)*(const int *)value;
}
static u16 GetMoveMaxPP(u16 move, u8 ppUps) { (void)ppUps; return (u16)(move % 32 + 5); }
static void MonApplyFriendshipMod(Pokemon *mon, int event, u16 mapSec) { (void)mon; (void)mapSec; assert(event == FRIENDSHIP_EVENT_LEARN_TMHM); friendshipCalls++; }
static void ApplyMonMoodModifier(Pokemon *mon, int mod) { (void)mon; assert(mod == MON_MOOD_MODIFIER_LEARN_TMHM); moodCalls++; }
static u16 PartyMenu_GetCurrentMapSec(PartyMenu *partyMenu) { (void)partyMenu; return 1; }
// The HM moves, which New Gold lets a Pokemon forget: MoveIsHM answers no for
// all of them now, and what the machine costs is decided by the item instead.
static const u16 hmMoves[] = { 15, 19, 57, 70, 148, 249, 127, 291 };
@NATIVE@
'''

MAIN = r'''
static void teach(u16 itemId, u16 moveId) {
    PartyMenuArgs args = { moveId, itemId, NULL, NULL };
    PartyMenu menu = { &args };
    takeCalls = friendshipCalls = moodCalls = 0;
    takenItem = ITEM_NONE;
    PartyMenu_LearnMoveToSlot(&menu, NULL, 0);
    assert(learnedMove == moveId && learnedPPUps == 0);
    assert(learnedPP == GetMoveMaxPP(moveId, 0));
}

int main(void) {
    // Every TM is a TM and nothing else is.
    for (u16 item = 1; item < ITEM_TM01; item++) assert(!ItemIsTM(item));
    for (u16 item = ITEM_TM01; item <= ITEM_TM92; item++) assert(ItemIsTM(item));
    for (u16 item = ITEM_HM01; item <= ITEM_HM08; item++) assert(!ItemIsTM(item));

    // A machine is a TM or an HM, and nothing outside that range is one.
    for (u16 item = 1; item < ITEM_TM01; item++) assert(!ItemIsMachine(item));
    for (u16 item = ITEM_TM01; item <= ITEM_HM08; item++) assert(ItemIsMachine(item));

    // Every HM move can be forgotten now, which is what MoveIsHM is asked.
    for (unsigned i = 0; i < sizeof(hmMoves) / sizeof(*hmMoves); i++) {
        assert(!MoveIsHM(hmMoves[i]));
    }
    assert(ITEM_TM92 - ITEM_TM01 + 1 == NUM_TMS);
    assert(ITEM_HM08 - ITEM_HM01 + 1 == NUM_HMS);

    // The bag takes exactly one of each TM, and HMs keep the pocket's limit.
    for (u16 item = ITEM_TM01; item <= ITEM_TM92; item++) {
        requestedMax = 0;
        assert(Bag_GetItemSlotForAdd(NULL, item, 1, HEAP_ID_DUMMY) != NULL);
        assert(requestedMax == 1);
    }
    for (u16 item = ITEM_HM01; item <= ITEM_HM08; item++) {
        requestedMax = 0;
        assert(Bag_GetItemSlotForAdd(NULL, item, 1, HEAP_ID_DUMMY) != NULL);
        assert(requestedMax == BAG_TMHM_QUANTITY_MAX);
    }
    // Ordinary items are untouched.
    requestedMax = 0;
    assert(Bag_GetItemSlotForAdd(NULL, ITEM_POTION, 5, HEAP_ID_DUMMY) != NULL);
    assert(requestedMax == BAG_SLOT_QUANTITY_MAX);

    // Teaching from a TM keeps the TM, and still applies friendship and mood.
    teach(ITEM_TM01, 264);
    assert(takeCalls == 0 && friendshipCalls == 1 && moodCalls == 1);
    teach(ITEM_TM92, 433);
    assert(takeCalls == 0);

    // HMs were already kept, by move and now also by item.
    teach(ITEM_HM01, hmMoves[0]);
    assert(takeCalls == 0 && friendshipCalls == 1 && moodCalls == 1);

    // The move relearner passes no item and must not touch the bag.
    teach(ITEM_NONE, 264);
    assert(takeCalls == 0 && friendshipCalls == 0 && moodCalls == 0);

    puts("PASS: 92 TMs, 8 HMs, bag limits, machine teaching and the relearner path.");
}
'''


class ReusableTMTests(unittest.TestCase):
    def test_native_reusable_machines(self):
        native = [function((ROOT / "src/item.c").read_text(), name)
                  for name in ("ItemIsTM", "ItemIsMachine", "MoveIsHM")] + [
                  function((ROOT / "src/bag.c").read_text(), "Bag_GetItemSlotForAdd").replace("static ", "", 1),
                  function((ROOT / "src/party_menu_items.c").read_text(), "PartyMenu_LearnMoveToSlot")]
        program = PREFIX.replace("@NATIVE@", "\n".join(native)) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-reusable-tms-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


class BagDisplayTests(unittest.TestCase):
    """A TM that is never spent has no quantity worth showing.

    HeartGold prints a count beside every TM in the bag. With reusable TMs the
    number is whatever the player happened to buy and never changes, so it says
    nothing; HMs never had one for the same reason.
    """

    def test_the_machine_row_prints_no_quantity(self):
        row = (ROOT / "src/bag_item_row.c").read_text()
        start = row.index("case POCKET_TMHMS:")
        block = row[start:row.index("case POCKET_KEY_ITEMS:", start)]
        self.assertNotIn("ov15_021FF66C", block, "the TM row still prints a count")

    def test_every_other_pocket_still_does(self):
        row = (ROOT / "src/bag_item_row.c").read_text()
        self.assertIn("ov15_021FF66C", row[row.index("default:"):])


if __name__ == "__main__":
    unittest.main()
