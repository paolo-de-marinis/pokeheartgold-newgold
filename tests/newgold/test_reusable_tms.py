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
import re
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

BOOL ItemIsTM(u16 itemId);
BOOL ItemIsHM(u16 itemId);
BOOL ItemIsTR(u16 itemId);
BOOL ItemIsMachine(u16 itemId);

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
    return ItemIsMachine(itemId) ? POCKET_TMHMS : POCKET_ITEMS;
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

    // The machines past HM08: the later TMs are TMs, the TRs are not.
    assert(ItemIsTM(ITEM_TM00) && ItemIsTM(ITEM_TM093) && ItemIsTM(ITEM_TM100) && ItemIsTM(ITEM_TM229));
    assert(ItemIsHM(ITEM_HM07_ORAS) && !ItemIsTM(ITEM_HM07_ORAS));
    for (u16 item = ITEM_TR00; item <= ITEM_TR99; item++) assert(ItemIsMachine(item) && !ItemIsTM(item));

    // The bag takes exactly one of each TM, and HMs keep the pocket's limit.
    for (u16 item = ITEM_TM01; item <= ITEM_TM92; item++) {
        requestedMax = 0;
        assert(Bag_GetItemSlotForAdd(NULL, item, 1, HEAP_ID_DUMMY) != NULL);
        assert(requestedMax == 1);
    }
    for (u16 item = ITEM_TM100_SV; item <= ITEM_TM229; item++) {
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

    // A TR is spent, and still counts as learning from a machine.
    teach(ITEM_TR00, 14);
    assert(takeCalls == 1 && takenItem == ITEM_TR00 && friendshipCalls == 1 && moodCalls == 1);
    // A TM past HM08 is kept like the others.
    teach(ITEM_TM093, 430);
    assert(takeCalls == 0);

    // HMs were already kept, by move and now also by item.
    teach(ITEM_HM01, hmMoves[0]);
    assert(takeCalls == 0 && friendshipCalls == 1 && moodCalls == 1);

    // The move relearner passes no item and must not touch the bag.
    teach(ITEM_NONE, 264);
    assert(takeCalls == 0 && friendshipCalls == 0 && moodCalls == 0);

    puts("PASS: TMs, HMs and TRs, bag limits, machine teaching and the relearner path.");
}
'''


class ReusableTMTests(unittest.TestCase):
    def test_native_reusable_machines(self):
        native = [function((ROOT / "src/item.c").read_text(), name)
                  for name in ("ItemIsTM", "ItemIsHM", "ItemIsTR", "ItemIsMachine", "MoveIsHM")] + [
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


class PocketSizeTests(unittest.TestCase):
    """A pocket that fills up drops what will not fit.

    HeartGold sized its pockets for its own item list. New Gold widens three of
    them, and the counts are the engine's: thirty-two more general items, two
    more balls, forty-two more key items.
    """

    WIDENED = {"NUM_BAG_ITEMS": (165, 32), "NUM_BAG_BALLS": (24, 2), "NUM_BAG_KEY_ITEMS": (50, 42)}
    UNCHANGED = {"NUM_BAG_MEDICINE": 40, "NUM_BAG_TMS_HMS": 101, "NUM_BAG_BERRIES": 64,
                 "NUM_BAG_MAIL": 12, "NUM_BAG_BATTLE_ITEMS": 30}

    def setUp(self):
        self.header = (ROOT / "include/constants/items.h").read_text()

    def test_the_three_pockets_are_widened(self):
        for name, (base, added) in self.WIDENED.items():
            match = re.search(rf"#define {name}\s+\((\d+) \+ (\d+)\)", self.header)
            self.assertIsNotNone(match, f"{name} is no longer widened")
            self.assertEqual((int(match.group(1)), int(match.group(2))), (base, added), name)

    def test_the_rest_keep_their_size(self):
        for name, value in self.UNCHANGED.items():
            match = re.search(rf"#define {name}\s+(\d+)\s*$", self.header, re.M)
            self.assertIsNotNone(match, name)
            self.assertEqual(int(match.group(1)), value, name)


ROW = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int16_t s16;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#include "constants/items.h"
#define TEXT_SPEED_NOTRANSFER 0xFF
#define MAKE_TEXT_COLOR(a, b, c) (((a) << 16) | ((b) << 8) | (c))
typedef struct { u16 id, quantity; } ItemSlot;
typedef struct { int unused; } Window, String, MessageFormat, MsgData, Bag;
typedef struct { Bag *bag; MessageFormat *messageFormat; MsgData *msgData; } BagAppState;
typedef struct { ItemSlot *slots; u16 position; s16 scroll; u8 pocketId; u8 count; } BagViewPocket;
BOOL ItemIsTM(u16 itemId);
BOOL ItemIsHM(u16 itemId);
BOOL ItemIsTR(u16 itemId);
static int counted, labelled;
static void AddTextPrinterParameterizedWithColor(Window *w, int f, String *s, int x, int y, int speed, u32 c, void *cb) {}
static void ov15_021FE914(BagAppState *state, Window *window, ItemSlot *slot, u32 y) { labelled++; }
static void ov15_021FE9F0(BagAppState *state, Window *window, u32 y, u32 which) {}
static void ov15_021FF66C(MessageFormat *f, MsgData *m, Window *window, u32 quantity) { counted++; }
static u16 Bag_GetRegisteredItem1(Bag *bag) { return ITEM_NONE; }
static u16 Bag_GetRegisteredItem2(Bag *bag) { return ITEM_NONE; }
#define ROW_Y 0x10
@NATIVE@
static int row(u8 pocket, u16 item) {
    ItemSlot slot = { item, 5 };
    BagViewPocket list = { &slot, 0, 0, pocket };
    BagAppState state = { 0 };
    Window window;
    counted = labelled = 0;
    ov15_021FF570(&state, &window, NULL, &list, 0);
    return counted;
}
int main(void) {
    assert(row(POCKET_TMHMS, ITEM_TM01) == 0 && labelled == 1);
    assert(row(POCKET_TMHMS, ITEM_TM100_SV) == 0);
    assert(row(POCKET_TMHMS, ITEM_HM01) == 0);
    assert(row(POCKET_TMHMS, ITEM_TR00) == 1 && labelled == 1);
    assert(row(POCKET_TMHMS, ITEM_TR99) == 1);
    assert(row(POCKET_ITEMS, ITEM_POTION) == 1 && labelled == 0);
    puts("PASS: a TM or HM row has no count, a TR row and every other pocket have one.");
    return 0;
}
"""


class BagDisplayTests(unittest.TestCase):
    """A TM that is never spent has no quantity worth showing; a TR does.

    HeartGold prints a count beside every TM in the bag. With reusable TMs the
    number is whatever the player happened to buy and never changes, so it says
    nothing; HMs never had one for the same reason. A TR is used up, so its
    count is worth showing, as hg-engine shows it.
    """

    def test_the_machine_row_counts_only_trs(self):
        item = (ROOT / "src/item.c").read_text()
        native = [function(item, name) for name in ("ItemIsTM", "ItemIsHM", "ItemIsTR")]
        native.append(function((ROOT / "src/bag_item_row.c").read_text(), "ov15_021FF570"))
        with tempfile.TemporaryDirectory(prefix="newgold-bag-row-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(ROW.replace("@NATIVE@", "\n".join(native)))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-w", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


SORT = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#include "constants/items.h"
typedef struct { u16 id, quantity; } ItemSlot;
BOOL ItemIsTM(u16 itemId);
BOOL ItemIsHM(u16 itemId);
BOOL ItemIsTR(u16 itemId);
@NATIVE@
int main(void) {
    ItemSlot pocket[] = {
        { ITEM_HM01, 1 }, { ITEM_TR05, 3 }, { 0, 0 }, { ITEM_TM100_SV, 1 }, { ITEM_HM07_ORAS, 1 },
        { ITEM_TM093, 1 }, { ITEM_TR00, 1 }, { ITEM_TM01, 1 }, { ITEM_TM92, 1 }, { ITEM_HM08, 1 },
    };
    const u16 wanted[] = { ITEM_TM01, ITEM_TM92, ITEM_TM093, ITEM_TM100_SV, ITEM_TR00, ITEM_TR05,
                           ITEM_HM01, ITEM_HM08, ITEM_HM07_ORAS, 0 };
    SortTMHMPocket(pocket, 10);
    for (int i = 0; i < 10; i++) {
        assert(pocket[i].id == wanted[i]);
    }
    assert(pocket[5].quantity == 3);
    puts("PASS: the TM case sorts its TMs, then its TRs, then its HMs.");
    return 0;
}
"""


class MachineSortTests(unittest.TestCase):
    """hg-engine sorts the TM case in three groups; by id alone the HMs would
    sit between TM92 and TM093, and the TRs among the later TMs."""

    def test_the_tm_case_sorts_tms_trs_then_hms(self):
        item = (ROOT / "src/item.c").read_text()
        bag = (ROOT / "src/bag.c").read_text()
        native = [function(item, name) for name in ("ItemIsTM", "ItemIsHM", "ItemIsTR")]
        native += [function(bag, name) for name in ("SwapItemSlots", "MachineSortGroup", "SortTMHMPocket")]
        with tempfile.TemporaryDirectory(prefix="newgold-tm-sort-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(SORT.replace("@NATIVE@", "\n".join(native)))
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())

    def test_adding_a_machine_sorts_the_case_that_way(self):
        body = function((ROOT / "src/bag.c").read_text(), "Bag_AddItem")
        self.assertIn("SortTMHMPocket(slot, count)", body)


if __name__ == "__main__":
    unittest.main()
