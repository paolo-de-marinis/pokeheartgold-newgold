#!/usr/bin/env python3
"""The machines past HM08: which species can be taught them.

New Gold has 156 machines, HeartGold's TM01 to HM08 first and then TM93 to
TM148 (sTMHMMoves in src/item.c), and keeps one bit per machine per species.
The personal record held 128 bits, of which HeartGold used 100; it carries
seven more words (hg-engine's 340 machines needed them), and the reader takes
a machine's place to its word and bit.

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

NUM_MACHINES = 156
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

    def test_the_machines_past_hm08_pikachu_learns(self):
        """TM93 Wild Charge, place 100, and TM115 Volt Switch, place 122, are
        Pikachu's; TM108 Scald, place 115, is not."""
        pikachu = next(row for row in self.rows if row["species"] == "PIKACHU")
        self.assertIn(100, pikachu["machines"])
        self.assertIn(122, pikachu["machines"])
        self.assertNotIn(115, pikachu["machines"])

    def test_trash_cloak_wormadam_has_machines(self):
        """The reference gives Trash Cloak Wormadam none (wotbl.REFERENCE_DEFECTS
        says why). Its own list, by the reference's rule, over the machine
        list src/item.c keeps."""
        import wotbl
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        machine_list = re.findall(r"(MOVE_[A-Z0-9_]+),", table[:table.index("};")])
        entry = wotbl.REFERENCE_DEFECTS[500]
        taught = set(entry["MachineMoves"]) | {step["Move"] for step in entry["LevelMoves"]}
        trash = next(row for row in self.rows if row["species"] == "WORMADAM_TRASH")
        self.assertEqual(trash["machines"], import_species.machines_past_hm08(taught, machine_list))
        # TM116 Bulldoze, place 123, is the Sandy Cloak's and not the Trash Cloak's.
        self.assertTrue(trash["machines"])
        self.assertNotIn(123, trash["machines"])
        sandy = next(row for row in self.rows if row["species"] == "WORMADAM_SANDY")
        self.assertIn(123, sandy["machines"])

    def test_the_alternate_forms_take_the_reference_s_machines(self):
        """HeartGold's own records for the forms after the bad egg left
        Deoxys's three forms without TM79 Dark Pulse, which base Deoxys and
        the reference give them, the Sandy Cloak without TM19 Giga Drain,
        TM22 Solar Beam and TM76 Stealth Rock, and the Trash Cloak without
        TM19, TM22 and TM28 Dig: the eighth generation's cloaks learn all of
        them by machine (Pokemon Central, Wormadam)."""
        tms = lambda name: next(row for row in self.rows if row["species"] == name)["tms"]  # noqa: E731
        for name in ("DEOXYS", "DEOXYS_ATK", "DEOXYS_DEF", "DEOXYS_SPD"):
            self.assertIn(79, tms(name), name)
        for tm in (19, 22, 76):
            self.assertIn(tm, tms("WORMADAM_SANDY"), tm)
        for tm in (19, 22, 28, 76):
            self.assertIn(tm, tms("WORMADAM_TRASH"), tm)

    def test_plant_cloak_wormadam_has_only_its_own_machines(self):
        """The reference gives Plant Cloak Wormadam the other two cloaks'
        machines (wotbl.REFERENCE_DEFECTS says why): no TM26 Earthquake, TM74
        Gyro Ball, TM76 Stealth Rock or TM91 Flash Cannon, nor the Sandy
        Cloak's TM116 Bulldoze past HM08; its own TM53 Energy Ball stays."""
        plant = next(row for row in self.rows if row["species"] == "WORMADAM")
        for tm in (26, 37, 39, 74, 76, 91):
            self.assertNotIn(tm, plant["tms"])
        self.assertIn(53, plant["tms"])
        self.assertNotIn(123, plant["machines"])


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
    printf("PASS: %d machines, each read from its own bit and no other.\n", NUM_MACHINES);
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
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include <stddef.h>
#include "constants/items.h"
#include "constants/moves.h"

BOOL ItemIsTM(u16 itemId);
BOOL ItemIsHM(u16 itemId);
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
        assert(ItemIsTM(item) + ItemIsHM(item) == 1);
        u16 place = ItemToTMHMId(item);
        assert(place < NUM_MACHINES && itemAt[place] == ITEM_NONE);
        itemAt[place] = item;
        assert(TMHMGetMove(item) == sTMHMMoves[place] && sTMHMMoves[place] != MOVE_NONE);
        printf("%u\n", item);
        machines++;
    }
    assert(machines == NUM_MACHINES && sizeof(sTMHMMoves) / sizeof(*sTMHMMoves) == NUM_MACHINES);
    // HeartGold's own keep their places; TM93 to TM148 follow, on the item ids
    // hg-engine gave TM093 to TM100 and TM101 to TM148.
    assert(ItemToTMHMId(ITEM_TM01) == 0 && ItemToTMHMId(ITEM_HM08) == 99);
    assert(ItemToTMHMId(ITEM_TM093) == 100 && ItemToTMHMId(ITEM_TM096) == 103 && ItemToTMHMId(ITEM_TM148) == 155);
    assert(TMHMGetMove(ITEM_TM093) == MOVE_WILD_CHARGE && TMHMGetMove(ITEM_TM100) == MOVE_CONFIDE);
    assert(TMHMGetMove(ITEM_TM101) == MOVE_SMACK_DOWN && TMHMGetMove(ITEM_TM148) == MOVE_UPPER_HAND);
    // hg-engine's other machines are not machines here.
    assert(!ItemIsMachine(ITEM_TR00) && !ItemIsMachine(ITEM_TR99) && !ItemIsMachine(ITEM_TM00));
    assert(!ItemIsMachine(ITEM_HM07_ORAS) && !ItemIsMachine(ITEM_TM100_SV) && !ItemIsMachine(ITEM_TM149));
    return 0;
}
"""


def machine_code(source):
    """src/item.c's machine runs and every function that reads them, the
    conversion of hg-engine's machines in an older save last."""
    start = source.index("enum MachineKind {")
    return source[start:source.index("\n}\n", source.index("u16 LegacyMachineToItem(u16 itemId) {")) + 2]


def item_ids():
    header = (ROOT / "include/constants/items.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (ITEM_\w+)\s+(\d+)\b", header)}


class MachineItemTests(unittest.TestCase):
    """Every machine item teaches its move, from its own place."""

    def run_mapping(self):
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        table = table[:table.index("};") + 2]
        native = [table, machine_code(source), function(source, "TMHMGetMove")]
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
        """The items the game calls machines are the 156 the item data sends
        to the TM routine, each at its own place with its own move."""
        machines = self.run_mapping()
        ids = item_ids()
        with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
            routine = {ids[row["item"]] for row in csv.DictReader(stream) if row["fieldUseFunc"] == "6"}
        self.assertEqual(machines, routine)

    def test_the_table_is_heartgolds_then_new_golds(self):
        """TM01 to HM08 are HeartGold's (retail pokeheartgold, 43b084839);
        TM93 to TM148 are Paolo's (2026-10-04): Gen 7's TMs HeartGold lacks,
        Wild Charge, Snarl, Nature Power, Dazzling Gleam and Confide on their
        own numbers and the rest from TM94 in Gen 7's order, then the moves
        after Gen 7 that are TMs in Scarlet and Violet, in theirs."""
        source = (ROOT / "src/item.c").read_text()
        table = source[source.index("static const u16 sTMHMMoves[]"):]
        ours = re.findall(r"MOVE_([A-Z0-9_]+),", table[:table.index("};")])
        retail = subprocess.run(["git", "-C", str(ROOT), "show", "43b084839:src/item.c"],
                                capture_output=True, text=True).stdout
        if not retail:
            self.skipTest("retail's src/item.c is not in this clone")
        retail = retail[retail.index("static const u16 sTMHMMoves[]"):]
        self.assertEqual(ours[:100], re.findall(r"MOVE_([A-Z0-9_]+),", retail[:retail.index("};")]))
        self.assertEqual(ours[100:], NEW_GOLD_TMS)


NEW_GOLD_TMS = """
    WILD_CHARGE WORK_UP SNARL NATURE_POWER PSYSHOCK VENOSHOCK DAZZLING_GLEAM CONFIDE
    SMACK_DOWN LEECH_LIFE SLUDGE_WAVE FLAME_CHARGE LOW_SWEEP ROUND ECHOED_VOICE SCALD SKY_DROP
    BRUTAL_SWING QUASH ACROBATICS SMART_STRIKE AURORA_VEIL VOLT_SWITCH BULLDOZE FROST_BREATH
    DRAGON_TAIL INFESTATION
    TRAILBLAZE POUNCE CHILLING_WATER SNOWSCAPE BODY_PRESS ICE_SPINNER STEEL_BEAM GRASSY_GLIDE
    BURNING_JEALOUSY FLIP_TURN DUAL_WINGBEAT POLTERGEIST LASH_OUT SCALE_SHOT MISTY_EXPLOSION
    TEMPER_FLARE SUPERCELL_SLAM TRIPLE_AXEL COACHING SCORCHING_SANDS EXPANDING_FORCE SKITTER_SMACK
    METEOR_BEAM BREAKING_SWIPE HARD_PRESS DRAGON_CHEER ALLURING_VOICE PSYCHIC_NOISE UPPER_HAND
""".split()


CONVERSION = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include "constants/items.h"
#include "constants/moves.h"
typedef struct { u16 id, quantity; } ItemSlot;
typedef struct { ItemSlot TMsHMs[NUM_BAG_TMS_HMS]; } Bag;
static void SortTMHMPocket(ItemSlot *slots, u32 count);
@NATIVE@

int main(void) {
    static Bag bag;
    // A save from before TM93 to TM148, its pocket as hg-engine filled it.
    const u16 had[][2] = {
        { ITEM_HM05, 1 }, { ITEM_TR00, 5 }, { ITEM_TM51, 1 }, { ITEM_TM126, 1 }, { ITEM_TM24, 1 },
        { ITEM_TR01, 2 }, { ITEM_TM093, 1 }, { ITEM_HM07_ORAS, 1 }, { ITEM_TM00, 1 }, { ITEM_TM100, 1 },
        { ITEM_TM101, 1 }, { ITEM_TM170, 1 }, { ITEM_HM01, 1 }, { ITEM_TR08, 3 },
    };
    // Kept: TM51, TM24, HM01, HM05 and TM100 (Confide on the same item). Made
    // New Gold's: TR00 Swords Dance TM75, TM093 Flash Cannon TM91, TM170
    // Steel Beam the TM126 item, TM126 Thunderbolt TM24 (already there),
    // TR08 Thunderbolt TM24 again. Gone: TR01 Body Slam, the second HM07
    // (Dive), TM00 Mega Punch, TM101 Power Gem.
    const u16 now[][2] = {
        { ITEM_TM24, 1 }, { ITEM_TM51, 1 }, { ITEM_TM75, 1 }, { ITEM_TM91, 1 }, { ITEM_TM100, 1 },
        { ITEM_TM126, 1 }, { ITEM_HM01, 1 }, { ITEM_HM05, 1 },
    };
    for (u32 i = 0; i < NELEMS(had); i++) {
        bag.TMsHMs[i].id = had[i][0];
        bag.TMsHMs[i].quantity = had[i][1];
    }
    Bag_ConvertLegacyMachines(&bag);
    for (u32 i = 0; i < NUM_BAG_TMS_HMS; i++) {
        if (i < NELEMS(now)) {
            assert(bag.TMsHMs[i].id == now[i][0] && bag.TMsHMs[i].quantity == now[i][1]);
        } else {
            assert(bag.TMsHMs[i].id == ITEM_NONE && bag.TMsHMs[i].quantity == 0);
        }
    }
    // Every one of hg-engine's 240 machines past HM08 becomes the machine
    // with its move, or nothing; HeartGold's are themselves.
    for (u16 item = ITEM_TM01; item <= ITEM_HM08; item++) assert(LegacyMachineToItem(item) == item);
    assert(LegacyMachineToItem(ITEM_POTION) == ITEM_NONE && LegacyMachineToItem(ITEM_TR01) == ITEM_NONE);
    assert(LegacyMachineToItem(ITEM_TR99) == ITEM_TM124);   // Body Press
    puts("PASS: an older save's machines made New Gold's, one of each, sorted.");
    return 0;
}
"""


class MachineItemTextTests(unittest.TestCase):
    """TM93 to TM148 sit on hg-engine's TM items; each shows its own move's
    description and its type's disc, not the move hg-engine's taught."""

    def test_each_shows_its_own_move(self):
        result = subprocess.run([sys.executable, ROOT / "tools/newgold/import/machine_items.py", "--check"],
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        sys.path.insert(0, str(ROOT / "tools/newgold/import"))
        import gmm
        import machine_items
        ids = item_ids()
        rows = gmm.read(221)
        # TM101 was hg-engine's Power Gem; New Gold's is Smack Down.
        self.assertTrue(rows[ids["ITEM_TM101"]]["text"].startswith("A projectile is thrown at the opponent."),
                        rows[ids["ITEM_TM101"]]["text"])
        for item, _ in machine_items.machines_past_hm08():
            self.assertLessEqual(rows[item]["text"].count("\\n"), 2, item)     # three lines at most
        source = (ROOT / "src/item.c").read_text()
        start, end = machine_items.icon_table(source)
        icons = [int(n) for n in re.findall(r"\d+", source[start:end])]
        disc = lambda name: icons[ids[name] - machine_items.first_imported()]  # noqa: E731
        self.assertEqual((disc("ITEM_TM093"), disc("ITEM_TM101"), disc("ITEM_TM146"), disc("ITEM_TM094")),
                         tuple(machine_items.TYPE_DISC[t] for t in ("ELECTRIC", "ROCK", "FAIRY", "NORMAL")))

    def test_each_disc_has_its_type_s_retail_colours(self):
        """Each type's disc is coloured as retail's TM01 to HM08 of that type
        (Fairy has none): hg-engine's TM100 is Dragon Dance's disc, not Normal's."""
        sys.path.insert(0, str(ROOT / "tools/newgold/import"))
        import machine_items
        import savedit
        icons = ROOT / "files/itemtool/itemdata/item_icon"

        def nclr(member):
            data = (icons / f"item_icon_{member}.NCLR").read_bytes()
            at = data.index(b"TTLP")
            at += 8 + struct.unpack_from("<I", data, at + 0x14)[0]
            return [(c & 31, c >> 5 & 31, c >> 10 & 31) for c in struct.unpack_from("<16H", data, at)]

        def png(name):      # an imported disc: its PNG's palette, as the build makes it 5-bit
            data, at = (icons / f"{name}.png").read_bytes(), 8
            while at < len(data):
                size, kind = struct.unpack_from(">I4s", data, at)
                if kind == b"PLTE":
                    return [tuple(c >> 3 for c in data[at + 8 + i:at + 11 + i]) for i in range(0, 48, 3)]
                at += 12 + size

        made = dict(re.findall(r"ITEMICON_FROM_PNG,(\d+),\d+,(\w+)\)",
                               (ROOT / "files/itemtool/itemdata/item_data.mk").read_text()))
        names = {number: name for name, number in item_ids().items()}
        rows = dict(re.findall(r"\[(ITEM_\w+)\] = \{ \w+, \w+, NARC_item_icon_item_icon_(\d+)_NCLR",
                               (ROOT / "src/item.c").read_text()))
        types, kind = savedit.type_names(), savedit.move_attr("MOVEATTR_TYPE")
        retail = {}
        for move, item in savedit.machines()[:100]:
            retail.setdefault(types[kind[move]], []).append(nclr(rows[names[item]]))
        for type_, member in machine_items.TYPE_DISC.items():
            if type_ != "FAIRY":
                self.assertIn(png(made[str(member)]), retail[type_], type_)


FOUND = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#include "constants/items.h"
typedef struct { u16 item, result; } ScriptContext;
static u16 ScriptGetVar(ScriptContext *ctx) { return ctx->item; }
static u16 *ScriptGetVarPointer(ScriptContext *ctx) { return &ctx->result; }
@NATIVE@
static u16 found(u16 item) { ScriptContext ctx = { item, 2 }; ScrCmd_ItemIsTMOrHM(&ctx); return ctx.result; }
int main(void) {
    assert(found(ITEM_TM01) && found(ITEM_HM08) && found(ITEM_TM093) && found(ITEM_TM100) && found(ITEM_TM148));
    assert(!found(ITEM_POTION) && !found(ITEM_TR00) && !found(ITEM_TM149) && !found(ITEM_EXPLORER_KIT));
    puts("PASS: an item ball's TM93 to TM148 are found as machines, with their move named.");
    return 0;
}
"""


class FoundMachineTests(unittest.TestCase):
    def test_an_item_ball_knows_every_machine(self):
        item = (ROOT / "src/item.c").read_text()
        native = [machine_code(item), function((ROOT / "src/scrcmd_items.c").read_text(), "ScrCmd_ItemIsTMOrHM")]
        with tempfile.TemporaryDirectory(prefix="newgold-found-machine-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(FOUND.replace("@NATIVE@", "\n".join(native)))
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                                   ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-iquote", str(ROOT / "include"),
                                    str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(exe)], capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            print(run.stdout.strip())


class LegacyMachineTests(unittest.TestCase):
    """A save from before TM93 to TM148 holds hg-engine's machines; loading
    it makes each New Gold's machine with its move, or drops it."""

    def test_an_older_pocket_is_converted(self):
        item = (ROOT / "src/item.c").read_text()
        bag = (ROOT / "src/bag.c").read_text()
        table = item[item.index("static const u16 sTMHMMoves[]"):]
        native = [table[:table.index("};") + 2], machine_code(item)]
        native += [function(bag, name) for name in ("SwapItemSlots", "MachineSortGroup", "SortTMHMPocket",
                                                     "Bag_ConvertLegacyMachines")]
        with tempfile.TemporaryDirectory(prefix="newgold-legacy-machines-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(CONVERSION.replace("@NATIVE@", "\n".join(native)))
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

    def test_the_conversion_is_the_old_table_s_moves(self):
        """Each of hg-engine's machines past HM08 (its table as this tree had
        it before TM93 to TM148, 48ab75d65) maps to the place of the same
        move in the table now, or to none."""
        old = subprocess.run(["git", "-C", str(ROOT), "show", "48ab75d65:src/item.c"], capture_output=True, text=True).stdout
        if not old:
            self.skipTest("48ab75d65 is not in this clone")
        old = old[old.index("static const u16 sTMHMMoves[]"):]
        old = re.findall(r"MOVE_([A-Z0-9_]+),", old[:old.index("};")])
        source = (ROOT / "src/item.c").read_text()
        new = source[source.index("static const u16 sTMHMMoves[]"):]
        new = re.findall(r"MOVE_([A-Z0-9_]+),", new[:new.index("};")])
        places = source[source.index("sLegacyMachinePlaces[] = {"):]
        places = [255 if p == "MACHINE_GONE" else int(p)
                  for p in re.findall(r"MACHINE_GONE|\d+", places[places.index("{"):places.index("};")])]
        self.assertEqual(places, [new.index(m) if m in new else 255 for m in old[100:]])


if __name__ == "__main__":
    unittest.main()
