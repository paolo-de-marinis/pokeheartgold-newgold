#!/usr/bin/env python3
"""Check the Dex's two lists hold every Dex species.

The Dex list (PokedexAppData.unk_0878) and the grid list (unk_1030) were
sized for 493 species inside PokedexAppData. They are on the Dex's heap now,
allocated by Pokedex_Init. The allocation, the list builder (ov18_021F7ED4,
with filters that let everything through), the list writer (ov18_021F81D8),
the grid filler (ov18_021F8884) and the list's length (ov18_021F891C) are
compiled on the host under AddressSanitizer and given every Dex species in
National Dex order, the most the Dex list can be handed.
"""

import re
import unittest

from test_dex_range import c_function, run_native
from test_level_cap import ROOT

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define HEAP_ID_POKEDEX_APP 0x25
typedef struct Pokedex Pokedex;
static void *Heap_Alloc(int heapId, u32 size) { (void)heapId; return malloc(size); }
static void MI_CpuClear8(void *dest, u32 size) { memset(dest, 0, size); }
static void MI_CpuClear32(void *dest, u32 size) { memset(dest, 0, size); }
static BOOL Pokedex_CheckMonCaughtFlag(const Pokedex *pokedex, u16 species) { (void)pokedex; return species % 2; }
u16 SpeciesToJohtoDexNo(u16 species) { return species; }
@DEFINES@
@TYPES@
typedef struct PokedexArgs { Pokedex *pokedex; } PokedexArgs;
typedef struct PokedexAppData {
    PokedexArgs *args;
    PokedexAppData_UnkSub0878 unk_0878;
    PokedexAppData_UnkSub1030 *unk_1030;
    u8 unk_1858;
    int unk_1860;
} PokedexAppData;
#define GF_ASSERT(expr) assert(expr)
static void *Heap_AllocAtEnd(int heapId, u32 size) { (void)heapId; return malloc(size); }
static void Heap_Free(void *ptr) { free(ptr); }
/* The Dex's order, as the national sort list gives it: every Dex species. */
static u16 sOrder[NATIONAL_DEX_COUNT];
static u32 sOrderCount;
static u16 *ov18_021F8168(u32 member, u32 *count) {
    (void)member;
    u16 *order = malloc(sOrderCount * sizeof(u16));
    memcpy(order, sOrder, sOrderCount * sizeof(u16));
    *count = sOrderCount;
    return order;
}
/* Everything is seen, and every filter lets everything through: the most the
   builder's scratch lists can be handed. */
static void pass(u16 *dest, u32 *destCount, u16 *src, u32 srcCount) {
    for (u32 i = 0; i < srcCount; i++) {
        dest[(*destCount)++] = src[i];
    }
}
static void ov18_021F8198(u16 *dest, u32 *destCount, Pokedex *pokedex, u16 *src, u32 srcCount) { (void)pokedex; *destCount = 0; pass(dest, destCount, src, srcCount); }
static void ov18_021F822C(u32 order, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)order; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F82CC(u32 letter, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)letter; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F831C(u32 type, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)type; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F8468(u32 bodyType, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)bodyType; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F8584(PokedexAppData *app, u32 area, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)app; (void)area; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F8640(PokedexAppData *app, u16 min, u16 max, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)app; (void)min; (void)max; (void)pokedex; pass(dest, destCount, src, srcCount); }
static void ov18_021F86D0(PokedexAppData *app, u16 min, u16 max, u16 *dest, u32 *destCount, u16 *src, u32 srcCount, Pokedex *pokedex) { (void)app; (void)min; (void)max; (void)pokedex; pass(dest, destCount, src, srcCount); }
@NATIVE@
static void allocate(PokedexAppData *appData) {
@ALLOCATE@
}
int main(void) {
    static PokedexAppData app;
    static u16 species[NATIONAL_DEX_COUNT];
    u32 count = 0;
    allocate(&app);
    app.unk_1858 = TRUE;
    /* every Dex species by its National Dex number, as the national sort list has them */
    for (u32 number = 1; number <= 1025; number++) {
        for (u32 s = 1; s <= NATIONAL_DEX_COUNT; s++) {
            if (s == SPECIES_SLOWPOKE_GALARIAN || s == SPECIES_SLOWBRO_GALARIAN || (s >= FIRST_DEX_GAP && s <= LAST_DEX_GAP)) {
                continue;
            }
            if (SpeciesToNationalDexNo(s) == number) {
                species[count++] = s;
            }
        }
    }
    assert(count == 1025);
    memcpy(sOrder, species, sizeof(species));
    sOrderCount = count;
    static PokedexArgs args;
    app.args = &args;
    ov18_021F7ED4(&app, TRUE, 0, 0, 0, 0, 0, 152, 0, 152, 1 << 3, 14);
    assert(app.unk_0878.unk_7B4 == count);
    for (u32 i = 0; i < count; i++) {
        assert(app.unk_0878.unk_000[i][0] == species[i]);
    }
    ov18_021F81D8(&app.unk_0878, NULL, species, count);
    assert(app.unk_0878.unk_7B4 == count);
    assert(app.unk_0878.unk_7B6 == count / 2 + 1);
    ov18_021F8884(&app, 1);
    for (u32 i = 0; i < count; i++) {
        u32 slot = SpeciesToNationalDexNo(species[i]) - 1;
        assert(app.unk_1030[slot].unk_0 == species[i]);
        assert(app.unk_1030[slot].unk_2 == (species[i] % 2 ? 2 : 1));
    }
    assert(ov18_021F891C(&app, TRUE) == 1025);
    /* the grid draws ten rows of five from its page's first entry */
    for (u32 i = 1025; i < 1025 + 50; i++) {
        assert(app.unk_1030[i].unk_0 == SPECIES_NONE);
    }
    ov18_021F8884(&app, 0);
    assert(app.unk_1030[count].unk_0 == SPECIES_PECHARUNT);
    printf("PASS: the Dex list and its grid hold all %u Dex species, Pecharunt at No. %u.\n", count, ov18_021F891C(&app, TRUE));
    return 0;
}
"""


GRID_END = r"""
#include <assert.h>
#include <stdio.h>
typedef unsigned char u8;
typedef unsigned int u32;
typedef int BOOL;
#define TRUE 1
typedef struct { u8 unk_1859, unk_185A; } PokedexAppData;
static u32 ov18_021F891C(PokedexAppData *app, BOOL byNumber) { return 1025; }
@NATIVE@
int main(void) {
    PokedexAppData app = { 68, 12 };   /* the last page, a cell of its third row */
    PokedexApp_KeepGridCursorOnList(&app);
    assert(app.unk_1859 == 68 && app.unk_185A == 4);   /* No. 1025 */
    app.unk_185A = 3;
    PokedexApp_KeepGridCursorOnList(&app);
    assert(app.unk_185A == 3);
    app.unk_1859 = 67, app.unk_185A = 14;
    PokedexApp_KeepGridCursorOnList(&app);
    assert(app.unk_185A == 14);
    printf("PASS: the grid's cursor stays on No. 1025 at the most.\n");
    return 0;
}
"""


class DexListTests(unittest.TestCase):
    def test_the_lists_hold_every_dex_species(self):
        header = (ROOT / "include/application/pokedex/pokedex_internal.h").read_text()
        defines = "\n".join(re.findall(r"^#define POKEDEX_(?:GRID_)?LIST_LEN .*$", header, re.M))
        types = "\n".join(re.search(rf"typedef struct {name} \{{.*?\}} {name};", header, re.S).group(0)
                          for name in ("PokedexAppData_UnkSub0878", "PokedexAppData_UnkSub1030"))
        init = c_function((ROOT / "src/application/pokedex/ov18_021E5AA0.c").read_text(), "Pokedex_Init")
        allocate = "\n".join(line for line in init.splitlines()
                             if re.search(r"appData->(unk_0878\.unk_000|unk_1030)\b", line))
        self.assertEqual(allocate.count("Heap_Alloc("), 2, "Pokedex_Init allocates both lists")
        pokedex = (ROOT / "src/pokedex.c").read_text()
        numbers = pokedex[pokedex.index("static const u16 sFormBaseSpecies["):]
        numbers = numbers[:numbers.index("};") + 2]
        table = pokedex[pokedex.index("static const u16 sNationalDexNumbers["):]
        table = table[:table.index("};") + 2]
        lists = (ROOT / "src/application/pokedex/ov18_021F8838.c").read_text()
        native = "\n".join([
            numbers, table,
            c_function(pokedex, "SpeciesToDexSpecies"),
            c_function(pokedex, "SpeciesToNationalDexNo"),
            c_function((ROOT / "src/pokedex_util.c").read_text(), "Pokedex_ConvertToCurrentDexNo"),
            c_function((ROOT / "src/application/pokedex/ov18_021F81D8.c").read_text(), "ov18_021F81D8"),
            c_function((ROOT / "src/application/pokedex/ov18_021F7ED4.c").read_text(), "ov18_021F7ED4"),
            c_function(lists, "ov18_021F8884"),
            c_function(lists, "ov18_021F891C"),
        ])
        program = (PROGRAM.replace("@DEFINES@", defines).replace("@TYPES@", types)
                   .replace("@NATIVE@", native).replace("@ALLOCATE@", allocate))
        run_native(self, program, "newgold-dex-lists-")


    def test_the_grid_cursor_stays_on_the_list(self):
        """The grid by number pages three rows of five, so at 1025 its last
        page has two rows past the end, and the cursor could rest on them.
        Every move within a page and every page down keeps it on the list."""
        source = (ROOT / "src/application/pokedex/ov18_021E8BF4.c").read_text()
        run_native(self, GRID_END.replace("@NATIVE@", c_function(source, "PokedexApp_KeepGridCursorOnList")), "newgold-grid-end-")
        moved = c_function(source, "PokedexApp_MainSeq_11")
        self.assertRegex(moved, r"case 0:\s*PokedexApp_KeepGridCursorOnList\(pokedexApp\);")
        paged = c_function(source, "PokedexApp_MainSeq_14")
        self.assertRegex(paged, r"\+\+pokedexApp->unk_1859;\s*PokedexApp_KeepGridCursorOnList\(pokedexApp\);")


if __name__ == "__main__":
    unittest.main()
