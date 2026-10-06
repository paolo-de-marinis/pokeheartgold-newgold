#!/usr/bin/env python3
"""Goldenrod's TM shop and the price of TM93 to TM148.

Paolo (2026-10-04, .rounds/round15/tm/PROPOSTA-NEGOZIO-MT.md and shop.json):
the Department Store's 5F TM clerk (special mart list 7) sells HeartGold's
twelve TMs, then the 56 TMs past TM92, unlocked seven at a time at 2, 4, ...
16 badges (Johto's and Kanto's both count), each step dearer than the one
before, as the Poke Mart adds wares as badges come in.
"""

import csv
import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function
from test_machines import machine_code

# (badges, price, TMs) for each step.
STEPS = [
    (2, 1500, [94, 104, 106, 107, 120, 121, 122]),
    (4, 2000, [95, 98, 100, 101, 105, 116, 119]),
    (6, 3000, [96, 109, 110, 112, 113, 118, 127]),
    (8, 4000, [99, 111, 115, 117, 129, 143, 148]),
    (10, 5000, [123, 128, 132, 135, 139, 141, 147]),
    (12, 6000, [97, 102, 108, 114, 125, 130, 146]),
    (14, 8000, [93, 103, 124, 133, 138, 140, 144]),
    (16, 10000, [126, 131, 134, 136, 137, 142, 145]),
]
RETAIL_LIST = [70, 17, 54, 83, 16, 33, 22, 52, 38, 25, 14, 15]


def item(tm):
    return f"ITEM_TM{tm:02d}" if tm <= 92 else f"ITEM_TM{tm:03d}"


class TMPriceTests(unittest.TestCase):
    def test_each_new_tm_costs_its_step(self):
        rows = {row["item"]: row for row in csv.DictReader((ROOT / "files/itemtool/itemdata/item_data.csv")
                                                           .read_text().splitlines())}
        self.assertEqual(sorted(tm for _, _, tms in STEPS for tm in tms), list(range(93, 149)))
        for _, price, tms in STEPS:
            for tm in tms:
                self.assertEqual((int(rows[item(tm)]["price"]), rows[item(tm)]["price_high"]), (price, "0"), tm)


SHOP = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NULL ((void *)0)
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include "constants/items.h"
typedef struct { int unused; } TaskManager, SaveData, PlayerProfile;
typedef struct { SaveData *saveData; } FieldSystem;
typedef struct { TaskManager *taskman; FieldSystem *fieldSystem; } ScriptContext;
struct MartItem;
static u16 sWhich;
static s32 sBadges;
static u16 sSold[256];
static u16 ScriptGetVar(ScriptContext *ctx) { return sWhich; }
static PlayerProfile *Save_PlayerData_GetProfile(SaveData *save) { return NULL; }
static s32 PlayerProfile_CountBadges(PlayerProfile *profile) { return sBadges; }
static void Mart_Init(TaskManager *t, FieldSystem *f, const u16 *items, int kind, u8 buySell, int deco, const struct MartItem *prices) {
    int i = 0;
    do { sSold[i] = items[i]; } while (items[i++] != 0xFFFF);
}
@NATIVE@
static int sell(u16 which, s32 badges) {
    ScriptContext ctx = { NULL, NULL };
    FieldSystem field = { NULL };
    ctx.fieldSystem = &field;
    sWhich = which, sBadges = badges;
    ScrCmd_SpecialMartBuy(&ctx);
    int n = 0;
    while (sSold[n] != 0xFFFF) printf("%d ", sSold[n++]);
    printf("\n");
    return n;
}
int main(void) {
    for (int badges = 0; badges <= 16; badges++) sell(7, badges);
    sell(20, 16);       // Celadon's TM floor is as it was
    return 0;
}
"""


class TMShopTests(unittest.TestCase):
    def sold(self):
        source = (ROOT / "src/scrcmd_mart.c").read_text()
        tables = source[source.index("struct BadgeMartItems {"):source.index("const u16 _020FBA54[]")]
        lists = source[source.index("const u16 _020FBA54[]"):source.index("BOOL ScrCmd_SpecialMartBuy(")]
        native = tables[:tables.index("};") + 2] + "\n" + lists + function(source, "ScrCmd_SpecialMartBuy")
        with tempfile.TemporaryDirectory(prefix="newgold-tm-shop-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(SHOP.replace("@NATIVE@", native))
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-w", "-fsanitize=address,undefined",
                                    "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                                   capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stderr)
            return [[int(n) for n in line.split()] for line in run.stdout.splitlines()]

    def test_the_list_grows_a_step_every_two_badges(self):
        ids = {name: int(value) for name, value in
               re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", (ROOT / "include/constants/items.h").read_text())}
        *goldenrod, celadon = self.sold()
        retail = [ids[item(tm)] for tm in RETAIL_LIST]
        self.assertEqual([len(goldenrod[badges]) for badges in (0, 2, 3, 4, 16)], [12, 19, 19, 26, 68])
        for badges, sold in enumerate(goldenrod):
            wanted = retail + [ids[item(tm)] for need, _, tms in STEPS if badges >= need for tm in tms]
            self.assertEqual(sold, wanted, f"{badges} badges")
        self.assertEqual(len(celadon), 12)
        self.assertNotIn(ids["ITEM_TM094"], celadon)


ONE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NULL ((void *)0)
#include "constants/items.h"
enum { MART_TYPE_NORMAL, MART_TYPE_1, MART_TYPE_SEAL, MART_TYPE_3, MART_TYPE_4 };
enum { TASK_MART_START, TASK_MART_1, TASK_MART_2, TASK_MART_3, TASK_MART_4, TASK_MART_5, TASK_MART_6, TASK_MART_7,
       TASK_MART_8, TASK_MART_9, TASK_MART_10, TASK_MART_11, TASK_MART_12, TASK_MART_13, TASK_MART_14 };
#define HEAP_ID_FIELD2 11
typedef struct { void *sprites[19]; u16 spriteDrawn[2]; void *inventory; void *pokeathlonSave; void *apricornBox;
                 u8 unk271; u8 martType; u16 item; s16 quantity; u16 unk288; int cost; int unk290; u32 unk298; } MartData;
static u16 sHeld, sMoney = 2000;
static int sQuantityScreen;
#include <stddef.h>
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
@MACHINES@
static u16 Bag_GetQuantity(void *bag, u16 item, int heap) { return item == sHeld; }
static BOOL Bag_HasSpaceForItem(void *bag, u16 item, u16 quantity, int heap) { return !(ItemIsTM(item) && item == sHeld); }
static int SealCase_CheckSealQuantity(void *c, u16 item, s16 q) { return 0; }
static int ApricornBox_CountApricorn(void *box, int which) { return 0; }
static BOOL PokeathlonSave_GetUnkB7C_AtIndex(void *s, int i) { return FALSE; }
static BOOL PokeathlonSave_GetUnkB78_AtIndex(void *s, int i) { return FALSE; }
static BOOL Sprite_GetDrawFlag(void *s) { return TRUE; }
static void Sprite_SetDrawFlag(void *s, BOOL on) { }
static void ov03_022586BC(MartData *data, int flag) { }
static void ov03_022582C0(MartData *data, int which) { sQuantityScreen = which == 1; }
static u32 ov03_02258120(MartData *data, u16 item) { return item == ITEM_POTION ? 300 : 1500; }
static u32 ov03_022577F4(MartData *data, u32 martType) { return sMoney; }
@NATIVE@
static u8 pick(u16 item) {
    static MartData data;
    data.martType = MART_TYPE_NORMAL;
    data.unk298 = 0;
    sQuantityScreen = 0;
    u8 state = ov03_02257874(&data, item);
    printf("%u %u %u %d %d %d\n", item, state, data.unk298, data.quantity, sQuantityScreen, ov03_02257814(&data, sMoney));
    return state;
}
int main(void) {
    pick(ITEM_TM094);                  // not in the bag: straight to its price, one
    sHeld = ITEM_TM094; pick(ITEM_TM094);  // in the bag: "You already have this!"
    sHeld = 0; pick(ITEM_POTION);      // anything else: how many
    sMoney = 1000; pick(ITEM_TM094);   // too dear
    return 0;
}
"""


class OneTMAtATimeTests(unittest.TestCase):
    def test_a_tm_is_sold_once(self):
        source = (ROOT / "src/overlay_03/shop_menu.c").read_text()
        native = "\n".join(function(source, name) for name in
                           ("Mart_SellsOneAtATime", "Mart_HasAlready", "ov03_02257814", "ov03_02257CA0", "ov03_02257874"))
        with tempfile.TemporaryDirectory(prefix="newgold-tm-once-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            machines = machine_code((ROOT / "src/item.c").read_text())
            c.write_text(ONE.replace("@NATIVE@", native).replace("@MACHINES@", machines))
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-w", "-fsanitize=address,undefined",
                                    "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                                   capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stderr)
        ids = {name: int(value) for name, value in
               re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", (ROOT / "include/constants/items.h").read_text())}
        # item, the state it goes to, the message (unk298), the quantity, the
        # quantity screen, and ov03_02257814: 3 is "You already have this!"
        self.assertEqual([[int(n) for n in line.split()] for line in run.stdout.splitlines()], [
            [ids["ITEM_TM094"], 10, 3, 1, 0, 0],    # TASK_MART_10, "That'll be $1500", one
            [ids["ITEM_TM094"], 14, 10, 1, 0, 3],   # TASK_MART_14, refused
            [ids["ITEM_POTION"], 5, 2, 1, 1, 0],    # TASK_MART_5, "How many?"
            [ids["ITEM_TM094"], 14, 10, 1, 0, 1],   # too dear: "You don't have enough money."
        ])


LIST = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NULL ((void *)0)
#include "constants/items.h"
enum { MART_TYPE_NORMAL, MART_TYPE_1, MART_TYPE_SEAL, MART_TYPE_3, MART_TYPE_4 };
#define HEAP_ID_FIELD2 11
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
typedef struct { int unused; } Window;
typedef struct String String;
typedef struct { void *inventory; u16 *unk268; u8 unk270; u8 unk271; u8 martType; } MartData;
typedef struct { MartData *mart; Window rows[6]; void *msgFormat; void *msgData; void *itemNames; } MartBottomScreen;
static u16 sHeld[2];
@MACHINES@
static u16 Bag_GetQuantity(void *bag, u16 item, int heap) { return item == sHeld[0] || item == sHeld[1]; }
static void FillWindowPixelBuffer(Window *w, u8 fill) { }
static void ScheduleWindowCopyToVram(Window *w) { }
static String *NewString_ReadMsgData(void *msgData, u32 row) { return NULL; }
static void String_Delete(String *s) { }
static void ov31_0225DE00(MartBottomScreen *screen, Window *window, String *string, int row) { }
static BOOL ov31_0225E12C(MartData *data, int index, int item) { return TRUE; }
static u32 ov03_02258120(MartData *data, u16 item) { return 1500; }
static void ov31_0225E0E4(MartBottomScreen *screen, int count) { }
static MartBottomScreen sScreen;
static void ov31_0225DE24(void *fmt, void *msgData, Window *window, u32 price, int martType) {
    printf("%d price\n", (int)(window - sScreen.rows));
}
static void MartList_PrintOwned(void *msgData, Window *window) {
    printf("%d owned\n", (int)(window - sScreen.rows));
}
@NATIVE@
int main(void) {
    static u16 items[] = { ITEM_TM70, ITEM_TM17, ITEM_POTION, ITEM_TM094, ITEM_HM01, ITEM_TM54 };
    static MartData mart = { NULL, items, NELEMS(items), 0, MART_TYPE_NORMAL };
    sScreen.mart = &mart;
    sHeld[0] = ITEM_TM70;
    sHeld[1] = ITEM_TM094;
    ov31_0225DD14(&sScreen);
    return 0;
}
"""


class OwnedRowTests(unittest.TestCase):
    def test_a_tm_in_the_bag_shows_owned_on_the_list(self):
        """Paolo (2026-10-04): a TM the player has is not sold again, as from
        the fifth generation; the list's row says it is owned in place of its
        price. TM70 and TM094 in the bag, TM17 and TM54 not, a Potion: the
        painter, ov31_0225DD14, run on the host."""
        shop = (ROOT / "src/overlay_03/shop_menu.c").read_text()
        native = "\n".join(function(shop, name) for name in ("Mart_SellsOneAtATime", "Mart_HasAlready"))
        native += "\n" + function((ROOT / "src/overlay_31_0225DD14.c").read_text(), "ov31_0225DD14")
        with tempfile.TemporaryDirectory(prefix="newgold-tm-owned-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            machines = machine_code((ROOT / "src/item.c").read_text())
            c.write_text(LIST.replace("@NATIVE@", native).replace("@MACHINES@", machines))
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-w", "-fsanitize=address,undefined",
                                    "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                                   capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stderr)
        self.assertEqual(run.stdout.split("\n")[:-1],
                         ["0 owned", "1 price", "2 price", "3 owned", "4 price", "5 price"])


class PrizeCounterTests(unittest.TestCase):
    def test_a_prize_tm_held_is_said_so(self):
        """The Game Corners' prize counters (Goldenrod's six TMs, Celadon's
        six): a TM held already does not fit the bag, which takes one of
        each, and the clerk says it is held, as the mart does, not that the
        bag is full."""
        folder = ROOT / "files/fielddata/script/scr_seq"
        for script, bank in (("scr_seq_0910_T25SP0101.s", "msg_0603_T25SP0101"),
                             ("scr_seq_0804_T07R0501.s", "msg_0509_T07R0501")):
            source = (folder / script).read_text()
            rows = dict(re.findall(r'<row id="(\w+)".*?<language name="English">(.*?)</language>',
                                   (ROOT / f"files/msgdata/msg/{bank}.gmm").read_text(), re.S))
            refusals = re.findall(r"GoToIfNoItemSpace (ITEM_TM\d+), 1, (\w+)", source)
            self.assertEqual(len(refusals), 6, script)
            for tm, label in refusals:
                block = source[source.index(f"\n{label}:\n"):]
                block = block[:block.index("NPCMsg")]
                self.assertIn("ItemIsTMOrHM VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT", block, tm)
                held = re.search(r"Compare VAR_SPECIAL_RESULT, 1\n\tGoToIfEq (\w+)", block).group(1)
                said = re.search(rf"\n{held}:\n\tNPCMsg (\w+)", source).group(1)
                self.assertEqual(rows[said], "You already have this!\\r", tm)


if __name__ == "__main__":
    unittest.main()
