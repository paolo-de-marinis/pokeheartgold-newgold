#!/usr/bin/env python3
"""The machines past HM08: which species can be taught them.

hg-engine numbers 340 machines, HeartGold's TM01 to HM08 first (sMachineMoves
in its src/item.c), and keeps one bit per machine per species. The personal
record here held 128 bits, of which HeartGold used 100; the other 240 machines
had nowhere to go, so no species could be taught Flash Cannon from TM093 or
anything from a TR. The record now carries seven more words, and the reader
takes a machine's place in that numbering to its word and bit.

The archive is compared bit for bit with the JSON it is built from, for every
species; the reader is compiled natively over a record with one bit set.
"""

import csv
import json
import os
import re
import shlex
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT, function
from test_personal_abilities import NARC, SOURCE, records

sys.path[:0] = [str(ROOT / "tools/newgold/import")]
import import_species  # noqa: E402

NUM_MACHINES = 340
WORDS_AT = [0x1C, 0x20, 0x24, 0x28] + [0x34 + 4 * i for i in range(7)]


def bits(record):
    words = [struct.unpack_from("<I", record, at)[0] for at in WORDS_AT]
    return {i for i in range(len(words) * 32) if words[i // 32] >> (i % 32) & 1}


def wanted(row):
    """TM n is bit n - 1, HM n bit 91 + n, the rest their own place."""
    return {n - 1 for n in row["tms"]} | {91 + n for n in row["hms"]} | set(row["machines"])


class MachineDataTests(unittest.TestCase):
    def setUp(self):
        self.rows = json.loads(SOURCE.read_text())["baseStats"]

    def test_every_record_has_its_machines_past_hm08(self):
        for row in self.rows:
            machines = row["machines"]
            self.assertEqual(machines, sorted(set(machines)), row["species"])
            self.assertTrue(all(import_species.RETAIL_MACHINES <= m < NUM_MACHINES for m in machines),
                            row["species"])

    def test_the_archive_holds_every_bit(self):
        if not NARC.exists():
            self.skipTest("the personal archive is not built")
        built = records()
        self.assertEqual(len(built), len(self.rows))
        for record, row in zip(built, self.rows):
            self.assertEqual(bits(record), wanted(row), row["species"])

    def test_the_machines_hg_engine_gives_pikachu(self):
        """TR08 is Thunderbolt, place 248; TM093 Flash Cannon is not Pikachu's."""
        pikachu = next(row for row in self.rows if row["species"] == "PIKACHU")
        self.assertIn(248, pikachu["machines"])
        self.assertNotIn(102, pikachu["machines"])

    def test_trash_cloak_wormadam_has_machines(self):
        """The reference gives Trash Cloak Wormadam none (wotbl.REFERENCE_DEFECTS
        says why). Its own list, by the reference's rule, over the machine
        list src/item.c keeps in the reference's order."""
        import wotbl
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        machine_list = re.findall(r"(MOVE_[A-Z0-9_]+),", table[:table.index("};")])
        entry = wotbl.REFERENCE_DEFECTS[500]
        taught = set(entry["MachineMoves"]) | {step["Move"] for step in entry["LevelMoves"]}
        trash = next(row for row in self.rows if row["species"] == "WORMADAM_TRASH")
        self.assertEqual(trash["machines"], import_species.machines_past_hm08(taught, machine_list))
        # TM093 Flash Cannon, the Steel cloak's, and not the Sandy Cloak's.
        self.assertIn(102, trash["machines"])
        sandy = next(row for row in self.rows if row["species"] == "WORMADAM_SANDY")
        self.assertNotIn(102, sandy["machines"])

    def test_plant_cloak_wormadam_has_only_its_own_machines(self):
        """The reference gives Plant Cloak Wormadam the other two cloaks'
        machines (wotbl.REFERENCE_DEFECTS says why): no TM26 Earthquake, TM74
        Gyro Ball, TM76 Stealth Rock or TM91 Flash Cannon, nor TM093 Flash
        Cannon past HM08; its own TM53 Energy Ball stays."""
        plant = next(row for row in self.rows if row["species"] == "WORMADAM")
        for tm in (26, 37, 39, 74, 76, 91):
            self.assertNotIn(tm, plant["tms"])
        self.assertIn(53, plant["tms"])
        self.assertNotIn(102, plant["machines"])


NATIVE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT(x) assert(x)
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/items.h"

@RECORD@

static BASE_STATS sRecord;

@ATTR@

static int GetMonBaseStat_HandleAlternateForm(int species, int form, int attr) {
    assert(species == SPECIES_PIKACHU && form == 0);
    return GetPersonalAttr(&sRecord, attr);
}

@COMPAT@

int main(void) {
    for (int machine = 0; machine < NUM_MACHINES; machine++) {
        u32 *words[] = { &sRecord.tmhm_1, &sRecord.tmhm_2, &sRecord.tmhm_3, &sRecord.tmhm_4,
                         &sRecord.tmhmMore[0], &sRecord.tmhmMore[1], &sRecord.tmhmMore[2], &sRecord.tmhmMore[3],
                         &sRecord.tmhmMore[4], &sRecord.tmhmMore[5], &sRecord.tmhmMore[6] };
        *words[machine / 32] = 1u << (machine % 32);
        for (int other = 0; other < NUM_MACHINES + 12; other++) {
            assert(GetTMHMCompatBySpeciesAndForm(SPECIES_PIKACHU, 0, other) == (other == machine));
        }
        *words[machine / 32] = 0;
    }
    assert(!GetTMHMCompatBySpeciesAndForm(SPECIES_EGG, 0, 0));
    puts("PASS: 340 machines, each read from its own bit and no other.");
    return 0;
}
"""


class MachineReaderTests(unittest.TestCase):
    def test_each_machine_reads_its_own_bit(self):
        source = (ROOT / "src/pokemon.c").read_text()
        header = (ROOT / "include/pokemon_types_def.h").read_text()
        record = header[header.index("typedef struct BaseStats {"):header.index("} BASE_STATS;") + len("} BASE_STATS;")]
        program = (NATIVE.replace("@RECORD@", record).replace("@ATTR@", function(source, "GetPersonalAttr"))
                   .replace("@COMPAT@", function(source, "GetTMHMCompatBySpeciesAndForm")))
        with tempfile.TemporaryDirectory(prefix="newgold-machines-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                 "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())


MAPPING = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#include "constants/items.h"
#include "constants/moves.h"

BOOL ItemIsTM(u16 itemId);
BOOL ItemIsHM(u16 itemId);
BOOL ItemIsTR(u16 itemId);
BOOL ItemIsMachine(u16 itemId);
u16 ItemToTMHMId(u16 itemId);

@NATIVE@

int main(void) {
    static u16 itemAt[NUM_MACHINES];
    int machines = 0;
    for (u32 item = ITEM_NONE; item < ITEMS_COUNT; item++) {
        if (!ItemIsMachine(item)) {
            assert(TMHMGetMove(item) == MOVE_NONE);
            continue;
        }
        assert(ItemIsTM(item) + ItemIsHM(item) + ItemIsTR(item) == 1);
        u16 place = ItemToTMHMId(item);
        assert(place < NUM_MACHINES && itemAt[place] == ITEM_NONE);
        itemAt[place] = item;
        assert(TMHMGetMove(item) == sTMHMMoves[place] && sTMHMMoves[place] != MOVE_NONE);
        printf("%u\n", item);
        machines++;
    }
    assert(machines == NUM_MACHINES && sizeof(sTMHMMoves) / sizeof(*sTMHMMoves) == NUM_MACHINES);
    // HeartGold's own keep their places.
    assert(ItemToTMHMId(ITEM_TM01) == 0 && ItemToTMHMId(ITEM_HM08) == 99);
    assert(TMHMGetMove(ITEM_TM093) == MOVE_FLASH_CANNON && TMHMGetMove(ITEM_TM100) == MOVE_CONFIDE);
    assert(TMHMGetMove(ITEM_TR00) == MOVE_SWORDS_DANCE && TMHMGetMove(ITEM_TR99) == MOVE_BODY_PRESS);
    return 0;
}
"""


def item_ids():
    header = (ROOT / "include/constants/items.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", header)}


class MachineItemTests(unittest.TestCase):
    """Every machine item teaches its move, from its own place."""

    def run_mapping(self):
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        table = table[:table.index("};") + 2]
        native = [table] + [function(source, name) for name in
                            ("TMHMGetMove", "ItemIsTM", "ItemIsHM", "ItemIsTR", "ItemIsMachine", "ItemToTMHMId")]
        with tempfile.TemporaryDirectory(prefix="newgold-machine-items-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(MAPPING.replace("@NATIVE@", "\n".join(native)))
            build = subprocess.run(
                shlex.split(os.environ.get("CC", "cc")) +
                ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer",
                 "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True,
                                 env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(run.returncode, 0, run.stderr)
            return {int(line) for line in run.stdout.split()}

    def test_every_machine_has_a_place_and_a_move(self):
        """The items the game calls machines are the 340 the item data sends
        to the TM routine, each at its own place with its own move."""
        machines = self.run_mapping()
        ids = item_ids()
        with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
            routine = {ids[row["item"]] for row in csv.DictReader(stream) if row["fieldUseFunc"] == "6"}
        self.assertEqual(machines, routine)

    def test_the_table_is_the_references(self):
        """The species' bits were written in the reference's order."""
        reference = Path(os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE",
                                        "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))
        if not (reference / "src/item.c").exists():
            self.skipTest("behaviour reference not present")
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        ours = re.findall(r"(MOVE_[A-Z0-9_]+),", table[:table.index("};")])
        self.assertEqual(ours, import_species.reference_machine_list(reference))


if __name__ == "__main__":
    unittest.main()
