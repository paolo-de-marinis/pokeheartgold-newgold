#!/usr/bin/env python3
"""Run the Dex's area page set-up (ov18_021E8528) on the host for every species.

The area page reads a record of its encounter archive (zukan_enc) per method,
four at a time, and sizes the list it merges them into as one plus each
record's count less one: every record holds at least its terminator.
Retail's archive had 495 records a method, one a species up to the egg. A
species past the egg read no record at all (count 0), the size came to -3,
and the page wrote past a 4-byte block into the Dex heap's links: DETAILS on
Iron Crown, Pecharunt or Lokix left both screens black. Each method has a
record for every species now, every form its own, written by
tools/newgold/devkit/dex_areas.py; the page reads the one of the entry its
FORMS page was left on (seenFormSpecies), a form shown as itself.

The two functions are cut from ov18_021E5C40.c and compiled against a stand-in
archive of that layout in which every record is a terminator. The page's own
filling of the list (ov18_021E8714 and on) is left out, it reads the records'
counts.

The records themselves: dex_areas.py gives back retail's archive byte for byte
from retail's wild data (pret's), the json is what it gives from the tree's,
and every block has a record for each species. A form put in a wild table is
in its own records and not its base's, and the page reads them when FORMS
was left on it: no regional form is wild today (konefr may make some so), so
the tree's tables are given one here.
"""

import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile
import unittest

from test_level_cap import ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
import dex_areas  # noqa: E402

SOURCE = ROOT / "src/application/pokedex/ov18_021E5C40.c"

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define FALSE 0
enum { HEAP_ID_POKEDEX_APP = 37, NARC_application_zukanlist_zkn_data_zukan_enc = 1 };
@NAIX@
typedef struct { s32 *maps; s32 nMaps; } PokedexAppData_UnkSub18DC_0;
typedef struct {
    PokedexAppData_UnkSub18DC_0 unk_00, unk_08, unk_10, unk_18, unk_20;
    u32 *unk_28;
} PokedexAppData_UnkSub18DC;
typedef int8_t s8;
typedef struct { s8 unk_18C5; u16 seenFormSpecies[0x20]; PokedexAppData_UnkSub18DC unk_18DC; } PokedexAppData;

// The block each method reads (dex_areas.py: 0-2 dungeons by time, 3-5 the
// overworld by time, 6 and 7 the special ones), after the two drawing tables.
static const int sBlocks[] = { 0, 1, 2, 6, 3, 4, 5, 7 };
static int sMethod;

@RECORDS@

// A record of method sMethod's block, one a species: RecordOf's, else a
// terminator alone.
static void *GfGfxLoader_LoadFromNarc_GetSizeOut(int narc, int member, BOOL comp, int heapId, BOOL atEnd, u32 *size) {
    assert(narc == NARC_application_zukanlist_zkn_data_zukan_enc && heapId == HEAP_ID_POKEDEX_APP);
    int base = 2 + sBlocks[sMethod] * (NUM_SPECIES + 1);
    assert(member >= base && member <= base + NUM_SPECIES);
    u32 count;
    const s32 *held = RecordOf(sBlocks[sMethod], member - base, &count);
    s32 *record = calloc(count ? count : 1, sizeof(s32));
    if (count) {
        memcpy(record, held, count * sizeof(s32));
    }
    *size = (count ? count : 1) * sizeof(s32);
    return record;
}
static void *Heap_Alloc(int heapId, u32 size) {
    assert(heapId == HEAP_ID_POKEDEX_APP);
    assert(size >= sizeof(u32) && size < 0x10000);
    return malloc(size);
}
static void Heap_Free(void *p) {
    assert(p != NULL);
    free(p);
}
static void MI_CpuClear32(void *p, u32 size) { memset(p, 0, size); }
static void ov18_021E8714(PokedexAppData *app, PokedexAppData_UnkSub18DC_0 *a1, int a2, int a3) { }
static void ov18_021E8878(PokedexAppData *app, PokedexAppData_UnkSub18DC_0 *a1, int a2, u32 a3, int a4) { }
static void ov18_021E8A00(PokedexAppData *app) { }
'''

MAIN = r'''
int main(void) {
    PokedexAppData app;
    for (int species = 1; species <= NUM_SPECIES; species++) {
        for (int a1 = 0; a1 < 3; a1++) {
            memset(&app, 0, sizeof(app));
            app.seenFormSpecies[0] = species;
            ov18_021E8528(&app, a1, 0);
            assert(app.unk_18DC.unk_00.nMaps >= 1 && app.unk_18DC.unk_08.nMaps >= 1);
            assert(app.unk_18DC.unk_10.nMaps >= 1 && app.unk_18DC.unk_18.nMaps >= 1);
            assert(app.unk_18DC.unk_20.nMaps == 1 && app.unk_18DC.unk_20.maps[0] == -2);
            ov18_021E8648(&app);
        }
    }
    return 0;
}
'''


NO_RECORDS = r'''
static const s32 *RecordOf(int block, int species, u32 *count) { (void)block; (void)species; *count = 0; return NULL; }
'''

# The page set up for Slowpoke with its Galarian form on FORMS's second entry:
# the morning's overworld record (block 3) as the page reads it, left on each.
FORM_MAIN = r'''
static int Holds(const PokedexAppData_UnkSub18DC_0 *record, s32 area) {
    for (int i = 0; i < record->nMaps - 1; i++) {
        if (record->maps[i] == area) {
            return 1;
        }
    }
    return 0;
}

int main(void) {
    PokedexAppData app;
    for (s8 entry = 0; entry < 2; entry++) {
        memset(&app, 0, sizeof(app));
        app.seenFormSpecies[0] = SPECIES_SLOWPOKE;
        app.seenFormSpecies[1] = SPECIES_SLOWPOKE_GALARIAN;
        app.unk_18C5 = entry;
        ov18_021E8528(&app, 0, 0);
        assert(Holds(&app.unk_18DC.unk_00, ROUTE_29) == (entry == 1));
        ov18_021E8648(&app);
    }
    puts("PASS: a Galarian Slowpoke put on Route 29 shows there on its own AREA page, not on Slowpoke's.");
    return 0;
}
'''


def run(program):
    with tempfile.TemporaryDirectory(prefix="newgold-dex-area-") as temp:
        c, exe = Path(temp) / "check.c", Path(temp) / "check"
        c.write_text(program)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
        assert result.returncode == 0, result.stderr
        result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=1", "UBSAN_OPTIONS": "halt_on_error=1"})
        assert result.returncode == 0, result.stdout + result.stderr
        return result.stdout.strip()


def page_program(main, records):
    """ov18_021E8698, ov18_021E8528 and ov18_021E8648 cut from the tree, over
    a stand-in archive whose records are `records` (RecordOf)."""
    source = SOURCE.read_text()
    record = re.search(r"#define ZUKAN_ENC_BLOCK.*", source).group(0) + "\n" + function(source, "ov18_021E8698")
    # the stand-in archive follows the method the record is read for
    record = record.replace("    switch (a2) {", "    sMethod = a2;\n    switch (a2) {", 1)
    naix = "\n".join(f"#define {name} {int(name[-8:])}" for name in sorted(set(re.findall(r"NARC_zukan_enc_zukan_enc_\d{8}", record))))
    return (PREFIX.replace("@NAIX@", naix).replace("@RECORDS@", records) + record + "\n"
            + function(source, "ov18_021E8528") + "\n" + function(source, "ov18_021E8648") + main)


class DexAreaTests(unittest.TestCase):
    def test_a_form_in_a_wild_table_shows_on_its_area_page(self):
        tree = dex_areas.Tree()
        enc = json.loads(dex_areas.read(dex_areas.ENC))["encounters"]
        headbutt = json.loads(dex_areas.read(dex_areas.HEADBUTT))["tables"]
        table = next(t for t in enc if t["map"] == "R29")      # Route 29's first grass slot, at every time
        table["land"]["mons"][0]["species"] = {time: "SPECIES_SLOWPOKE_GALARIAN" for time in ("morn", "day", "nite")}
        kind, route29 = tree.area("MAP_ROUTE_29")
        self.assertEqual(kind, "overworld")
        data = dex_areas.build(tree, enc, headbutt, json.loads(dex_areas.read(dex_areas.OUT)), tree.count + 1)
        galarian, slowpoke = tree.species["SPECIES_SLOWPOKE_GALARIAN"], tree.species["SPECIES_SLOWPOKE"]

        def record(block, species):
            recs = data["encounters"]["method_%d" % block]
            value = recs[next(k for k in recs if int(k.split("_")[1]) == species)]
            return value if isinstance(value, list) else value["GOLD"]
        for block in (3, 4, 5):     # the overworld's morning, day and night
            self.assertIn(route29, record(block, galarian)[:-1])
            self.assertNotIn(route29, record(block, slowpoke)[:-1])
        cases = "\n".join(f"    if (block == {b} && species == {s}) {{ static const s32 r[] = {{ {', '.join(map(str, record(b, s)))} }}; *count = {len(record(b, s))}; return r; }}"
                          for b in range(8) for s in (slowpoke, galarian))
        records = ("static const s32 *RecordOf(int block, int species, u32 *count) {\n" + cases
                   + "\n    *count = 0;\n    return NULL;\n}\n" + f"#define ROUTE_29 {route29}\n")
        print(run(page_program(FORM_MAIN, records)))

    def test_every_species_reads_a_record_with_its_terminator(self):
        program = page_program(MAIN, NO_RECORDS)
        with tempfile.TemporaryDirectory(prefix="newgold-dex-area-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=1", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)


    def test_every_dex_species_has_its_records(self):
        data = json.loads((ROOT / dex_areas.OUT).read_text())
        count = dex_areas.Tree().count
        self.assertEqual(sorted(data["encounters"]), ["method_%d" % m for m in range(8)])
        for method, records in data["encounters"].items():
            self.assertEqual(len(records), count + 1, method)
            # jsonproc sorts the keys: that has to be the species' order
            numbers = [int(key.split("_")[1]) for key in sorted(records)]
            self.assertEqual(numbers, list(range(count + 1)), method)

    def test_the_records_are_the_trees_wild_data(self):
        # New Gold's tables: Applin in Ilex Forest's grass, Klink and the
        # other added species where konefr put them.
        self.assertEqual(dex_areas.from_tree(), (ROOT / dex_areas.OUT).read_text(),
                         "zukan_enc.json is not what the wild data gives: run tools/newgold/devkit/dex_areas.py")

    def test_retails_records_come_from_retails_tables(self):
        def upstream(path):
            result = subprocess.run(["git", "show", f"upstream/master:{path}"], cwd=ROOT, capture_output=True, text=True)
            if result.returncode:
                self.skipTest("pret's upstream/master is not fetched")
            return result.stdout
        retail = upstream(dex_areas.OUT)
        enc = json.loads(upstream(dex_areas.ENC))["encounters"]
        headbutt = json.loads(upstream(dex_areas.HEADBUTT))["tables"]
        rebuilt = dex_areas.build(dex_areas.Tree(), enc, headbutt, json.loads(retail), 495)
        self.assertEqual(dex_areas.text(rebuilt), retail)


if __name__ == "__main__":
    unittest.main()
