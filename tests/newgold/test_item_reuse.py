#!/usr/bin/env python3
"""The party menu stays open for the next use of an item while more remain.

hg-engine hooks the end of PartyMenu_ItemUseFunc_WaitTextPrinterThenExit
(PartyMenu_ItemUseFunc_ReuseItem, src/party_menu.c at d0380a487): once the line
is printed, an item that does not evolve a Pokemon and has more in the bag
goes back to "Use on which Pokemon?" instead of to the bag. The real function
is extracted from src/party_menu_items.c and compiled natively.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT, function

PROGRAM = r'''
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/items.h"
#include "msgdata/msg/msg_0300.h"
typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
enum HeapID { HEAP_ID_PARTY_MENU };
enum { PARTY_MENU_STATE_USE_ITEM_SELECT_MON = 4, PARTY_MENU_STATE_ITEM_USE_CB, PARTY_MENU_STATE_BEGIN_EXIT = 32 };
enum { PARTY_MENU_ACTION_RETURN_0 };
enum { PARTY_MENU_WINDOW_ID_34 = 34, PARTY_MENU_WINDOW_COUNT = 40 };
typedef struct { int unused; } Bag, Window;
typedef struct { Bag *bag; u16 itemId; int selectedAction; } PartyMenuArgs;
typedef struct { PartyMenuArgs *args; int textPrinterId; Window windows[PARTY_MENU_WINDOW_COUNT]; } PartyMenu;

static BOOL printing, evolves;
static unsigned left;
static Window *cleared;
static int printedOn32 = -1;

static BOOL TextPrinterCheckActive(int id) { (void)id; return printing; }
static s32 GetItemAttr(u16 item, u16 attr, enum HeapID heap) { (void)item; (void)heap; assert(attr == ITEMATTR_EVOLVE); return evolves; }
static BOOL Bag_HasItem(Bag *bag, u16 item, u16 count, enum HeapID heap) { (void)bag; (void)item; (void)heap; return left >= count; }
static void ClearFrameAndWindow2(Window *window, BOOL copy) { (void)copy; cleared = window; }
static void PartyMenu_PrintMessageOnWindow32(PartyMenu *menu, int msg, BOOL copy) { (void)menu; (void)copy; printedOn32 = msg; }

@FUNCTION@

int main(void) {
    Bag bag;
    PartyMenuArgs args = { &bag, ITEM_POTION, 5 };
    PartyMenu menu = { &args, 0, { { 0 } } };

    // The line is still being printed.
    printing = TRUE;
    left = 3;
    assert(PartyMenu_ItemUseFunc_WaitTextPrinterThenExit(&menu) == PARTY_MENU_STATE_ITEM_USE_CB);
    printing = FALSE;

    // More Potions: pick the next Pokemon.
    assert(PartyMenu_ItemUseFunc_WaitTextPrinterThenExit(&menu) == PARTY_MENU_STATE_USE_ITEM_SELECT_MON);
    assert(args.selectedAction == PARTY_MENU_ACTION_RETURN_0);
    assert(cleared == &menu.windows[PARTY_MENU_WINDOW_ID_34] && printedOn32 == msg_0300_00033);

    // The last one: back to the bag.
    cleared = NULL;
    left = 0;
    assert(PartyMenu_ItemUseFunc_WaitTextPrinterThenExit(&menu) == PARTY_MENU_STATE_BEGIN_EXIT);
    assert(cleared == NULL);

    // An evolution item leaves whatever is left.
    left = 3;
    evolves = TRUE;
    assert(PartyMenu_ItemUseFunc_WaitTextPrinterThenExit(&menu) == PARTY_MENU_STATE_BEGIN_EXIT);
    return 0;
}
'''


class ItemReuse(unittest.TestCase):
    def test_the_menu_stays_open_while_more_remain(self):
        source = (ROOT / "src/party_menu_items.c").read_text()
        program = PROGRAM.replace("@FUNCTION@", function(source, "PartyMenu_ItemUseFunc_WaitTextPrinterThenExit"))
        with tempfile.TemporaryDirectory(prefix="newgold-reuse-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror",
                "-iquote", str(ROOT / "include"), "-iquote", str(ROOT / "files"),
                str(path / "check.c"), "-o", str(path / "check"),
            ], check=True)
            subprocess.run([str(path / "check")], check=True)


if __name__ == "__main__":
    unittest.main()
