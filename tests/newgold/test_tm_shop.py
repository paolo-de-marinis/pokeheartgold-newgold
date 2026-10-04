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


if __name__ == "__main__":
    unittest.main()
