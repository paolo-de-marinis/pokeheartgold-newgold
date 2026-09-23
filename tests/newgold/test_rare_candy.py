#!/usr/bin/env python3
"""Run the native Rare Candy item effect and party-menu step with host sanitizers.

UseItemOnPokemon is extracted from src/use_item_on_mon.c and
PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop from src/party_menu_items.c, and
compiled against the repository's own item and Pokemon constants. The item
data, the Pokemon, the bag, the message windows and the evolution lookup are
controlled stand-ins, so this checks what the candy does to the Pokemon and
which state the menu's last level-up step returns, not the drawing.
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
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
enum HeapID { HEAP_ID_DUMMY };

typedef struct { s32 attr[ITEMATTR_FRIENDSHIP_MOD_HI_PARAM + 1]; } ItemData;
typedef struct { u32 data[256]; } Pokemon;

static ItemData candy;
static unsigned friendshipMods, moodChanges, levelsGained;

static ItemData *LoadItemDataOrGfx(u16 item, int kind, enum HeapID heap) { (void)item; (void)kind; (void)heap; return &candy; }
static s32 GetItemAttr_PreloadedItemData(ItemData *d, int attr) { return d->attr[attr]; }
static void Heap_Free(void *p) { assert(p == &candy); }
static u32 GetMonData(Pokemon *mon, int attr, void *out) { (void)out; return mon->data[attr]; }
static void SetMonData(Pokemon *mon, int attr, const void *value) { mon->data[attr] = *(const u32 *)value; }
static u32 CalcMonExpToNextLevel(Pokemon *mon) { (void)mon; return 1; }
static void AddMonData(Pokemon *mon, int attr, u32 value) { mon->data[attr] += value; }
static void CalcMonLevelAndStats(Pokemon *mon) { if (mon->data[MON_DATA_EXPERIENCE]) { mon->data[MON_DATA_LEVEL]++; mon->data[MON_DATA_EXPERIENCE] = 0; levelsGained++; } }
static void RestoreMonHPBy(Pokemon *mon, u32 hp, u32 maxHp, u32 by) { (void)mon; (void)hp; (void)maxHp; (void)by; }
static BOOL BoostMonMovePpUpBy(Pokemon *mon, int move, int by) { (void)mon; (void)move; (void)by; return FALSE; }
static BOOL MonMoveCanRestorePP(Pokemon *mon, int move) { (void)mon; (void)move; return FALSE; }
static BOOL MonMoveRestorePP(Pokemon *mon, int move, int by) { (void)mon; (void)move; (void)by; return FALSE; }
static s32 TryModEV(s32 ev, s32 sum, s32 by) { (void)ev; (void)sum; (void)by; return -1; }
static u16 GetMonEvolution(void *party, Pokemon *mon, int context, u16 item, int *method) { (void)party; (void)mon; (void)context; (void)item; (void)method; return SPECIES_MEGANIUM; }
static void ApplyItemEffectOnMonMood(Pokemon *mon, u16 item) { (void)mon; (void)item; moodChanges++; }
static BOOL DoItemFriendshipMod(Pokemon *mon, s32 friendship, s32 by, u16 location, enum HeapID heap) { (void)location; (void)heap; mon->data[MON_DATA_FRIENDSHIP] = friendship + by; friendshipMods++; return TRUE; }
@NATIVE@
'''

MAIN = r'''
static Pokemon bayleef(u32 level) {
    Pokemon mon;
    memset(&mon, 0, sizeof(mon));
    mon.data[MON_DATA_SPECIES] = SPECIES_BAYLEEF;
    mon.data[MON_DATA_LEVEL] = level;
    mon.data[MON_DATA_HP] = mon.data[MON_DATA_MAX_HP] = 100;
    mon.data[MON_DATA_FRIENDSHIP] = 70;
    return mon;
}

int main(void) {
    candy.attr[ITEMATTR_PARTY_USE] = 1;
    candy.attr[ITEMATTR_LEVEL_UP] = 1;
    candy.attr[ITEMATTR_FRIENDSHIP_MOD_LO] = 1;
    candy.attr[ITEMATTR_FRIENDSHIP_MOD_LO_PARAM] = 5;

    // Below the top level the candy raises the level and the friendship.
    Pokemon mon = bayleef(50);
    assert(UseItemOnPokemon(&mon, ITEM_RARE_CANDY, 0, 0, HEAP_ID_DUMMY) == TRUE);
    assert(levelsGained == 1 && mon.data[MON_DATA_LEVEL] == 51);
    assert(friendshipMods == 1 && moodChanges == 1 && mon.data[MON_DATA_FRIENDSHIP] == 75);

    // At level 100 the party menu lets it through for an evolution still to
    // come, and the evolution is all it gives: no level, no friendship, no
    // mood, as retail's item effect -- which hg-engine keeps -- has it.
    friendshipMods = moodChanges = levelsGained = 0;
    mon = bayleef(MAX_LEVEL);
    assert(UseItemOnPokemon(&mon, ITEM_RARE_CANDY, 0, 0, HEAP_ID_DUMMY) == FALSE);
    assert(levelsGained == 0 && mon.data[MON_DATA_LEVEL] == MAX_LEVEL);
    assert(friendshipMods == 0 && moodChanges == 0 && mon.data[MON_DATA_FRIENDSHIP] == 70);

    puts("PASS: a candy below 100 levels and befriends; at 100 it changes nothing.");
}
'''


MENU_PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"
#include "msgdata/msg/msg_0300.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define HEAP_ID_PARTY_MENU 0
#define PAD_BUTTON_A 1
#define PAD_BUTTON_B 2
#define SEQ_SE_DP_SELECT 1
#define MOVE_NONE 0
#define MOVE_APPEND_FULL 0xFFFFu
#define MOVE_APPEND_KNOWN 0xFFFEu
enum { PARTY_MENU_STATE_USE_ITEM_SELECT_MON = 4, PARTY_MENU_STATE_ITEM_USE_CB, PARTY_MENU_STATE_WAIT_TEXT_PRINTER, PARTY_MENU_STATE_YES_NO_INIT, PARTY_MENU_STATE_BEGIN_EXIT };
enum { PARTY_MENU_ACTION_RETURN_0, PARTY_MENU_ACTION_RETURN_EVO_RARE_CANDY = 9 };
enum { PARTY_MENU_WINDOW_ID_32 = 32, PARTY_MENU_WINDOW_ID_34 = 34, PARTY_MENU_WINDOW_COUNT = 40 };

typedef struct { int unused; } Pokemon, Bag, Window, String, MsgData, MessageFormat, BoxPokemon;
typedef struct { u32 mapId; } Location;
typedef struct { Location *location; } FieldSystem;
typedef struct {
    void *party; Bag *bag; FieldSystem *fieldSystem;
    u16 itemId, moveId, species; int evoMethod, selectedAction, levelUpMoveSearchState, selectedMoveIdx;
} PartyMenuArgs;
typedef struct PartyMenu PartyMenu;
struct PartyMenu {
    PartyMenuArgs *args; int partyMonIndex, levelUpLearnMovesLoopState, textPrinterId, afterTextPrinterState;
    Window windows[PARTY_MENU_WINDOW_COUNT]; MsgData *msgData; MessageFormat *msgFormat; String *formattedStrBuf;
    int (*yesCallback)(PartyMenu *); int (*noCallback)(PartyMenu *);
};
static struct { u16 newKeys; } gSystem;

static Pokemon theMon;
static u16 evolvesInto;
static unsigned candiesLeft;
static Window *cleared;
static int printedOn32 = -1;

static Pokemon *Party_GetMonByIndex(void *party, int slot) { (void)party; (void)slot; return &theMon; }
static u32 MapHeader_GetMapEvolutionMethod(u32 mapId) { (void)mapId; return 0; }
static u16 GetMonEvolution(void *party, Pokemon *mon, int context, u16 method, int *ret) { (void)party; (void)mon; (void)method; assert(context == EVOCTX_LEVELUP); *ret = 0; return evolvesInto; }
static BOOL Bag_HasItem(Bag *bag, u16 item, u16 quantity, int heap) { (void)bag; (void)heap; assert(item == ITEM_RARE_CANDY && quantity == 1); return candiesLeft >= quantity; }
static void ClearFrameAndWindow2(Window *window, BOOL dontCopy) { (void)dontCopy; cleared = window; }
static void PartyMenu_PrintMessageOnWindow32(PartyMenu *menu, int msg, BOOL frame) { (void)menu; assert(frame); printedOn32 = msg; }
// The steps before the last one: not reached here.
static BOOL TextPrinterCheckActive(int id) { (void)id; assert(0); return FALSE; }
static BOOL System_GetTouchNew(void) { assert(0); return FALSE; }
static void PlaySE(int se) { (void)se; assert(0); }
static void PartyMenu_LevelUpPrintStatsChange(PartyMenu *m) { (void)m; assert(0); }
static void sub_0207DF98(PartyMenu *m) { (void)m; assert(0); }
static void sub_0207E04C(PartyMenu *m) { (void)m; assert(0); }
static u16 MonTryLearnMoveOnLevelUp(Pokemon *mon, int *state, u16 *move) { (void)mon; (void)state; (void)move; assert(0); return 0; }
static BoxPokemon *Mon_GetBoxMon(Pokemon *mon) { (void)mon; assert(0); return NULL; }
static void BufferBoxMonNickname(MessageFormat *f, int i, BoxPokemon *b) { (void)f; (void)i; (void)b; assert(0); }
static void BufferMoveName(MessageFormat *f, int i, u16 move) { (void)f; (void)i; (void)move; assert(0); }
static String *NewString_ReadMsgData(MsgData *d, int msg) { (void)d; (void)msg; assert(0); return NULL; }
static void StringExpandPlaceholders(MessageFormat *f, String *dst, String *src) { (void)f; (void)dst; (void)src; assert(0); }
static void String_Delete(String *s) { (void)s; assert(0); }
static void PartyMenu_PrintMessageOnWindow34(PartyMenu *m, int msg, BOOL frame) { (void)m; (void)msg; (void)frame; assert(0); }
static void PartyMenu_LearnMoveToSlot(PartyMenu *m, Pokemon *mon, int slot) { (void)m; (void)mon; (void)slot; assert(0); }
static int PartyMenu_ItemUseFunc_LevelUpPromptForgetMove(PartyMenu *m) { (void)m; assert(0); return 0; }
static int PartyMenu_ItemUseFunc_LevelUpAskStopTryingToLearn(PartyMenu *m) { (void)m; assert(0); return 0; }
@NATIVE@
'''

MENU_MAIN = r'''
static int lastStep(PartyMenu *menu) {
    cleared = NULL;
    printedOn32 = -1;
    menu->levelUpLearnMovesLoopState = 6;
    return PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop(menu);
}

int main(void) {
    Location location = { 0 };
    FieldSystem fieldSystem = { &location };
    PartyMenuArgs args = { .itemId = ITEM_RARE_CANDY, .fieldSystem = &fieldSystem };
    PartyMenu menu = { .args = &args };

    // More candies and no evolution: the menu stays on "Use on which
    // Pokemon?" for the next one, the level-up message cleared.
    evolvesInto = SPECIES_NONE;
    candiesLeft = 3;
    assert(lastStep(&menu) == PARTY_MENU_STATE_USE_ITEM_SELECT_MON);
    assert(args.selectedAction == PARTY_MENU_ACTION_RETURN_0);
    assert(cleared == &menu.windows[PARTY_MENU_WINDOW_ID_34]);
    assert(printedOn32 == msg_0300_00033);

    // The last candy goes back to the bag, as before.
    candiesLeft = 0;
    assert(lastStep(&menu) == PARTY_MENU_STATE_BEGIN_EXIT);
    assert(args.selectedAction == PARTY_MENU_ACTION_RETURN_0);
    assert(cleared == NULL && printedOn32 == -1);

    // An evolution always leaves to run it, candies or not.
    evolvesInto = SPECIES_MEGANIUM;
    candiesLeft = 3;
    assert(lastStep(&menu) == PARTY_MENU_STATE_BEGIN_EXIT);
    assert(args.selectedAction == PARTY_MENU_ACTION_RETURN_EVO_RARE_CANDY);
    assert(args.species == SPECIES_MEGANIUM);
    assert(cleared == NULL && printedOn32 == -1);

    puts("PASS: candies left keep the menu open, the last candy and an evolution leave it.");
}
'''


class RareCandyTests(unittest.TestCase):
    def test_native_candy_at_the_top_level(self):
        native = function((ROOT / "src/use_item_on_mon.c").read_text(), "UseItemOnPokemon")
        program = PREFIX.replace("@NATIVE@", native) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-rare-candy-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


    def test_native_candy_menu_stays_open(self):
        native = function((ROOT / "src/party_menu_items.c").read_text(), "PartyMenu_ItemUseFunc_LevelUpLearnMovesLoop")
        program = MENU_PREFIX.replace("@NATIVE@", native) + MENU_MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-rare-candy-menu-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), "-iquote", str(ROOT / "files"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
