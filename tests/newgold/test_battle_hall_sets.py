#!/usr/bin/env python3
"""Run the Battle Hall's opponent pick on the host, with the Hall's own sets.

ov80_02237448 (src/frontier/battle_hall_sets.c) picks the opponent of a type
board category from its rank's stretch of the Hall's 477 sets (a/2/0/4, built
from files/arc/battle_hall.json).
Retail matched the type against two types baked for each set, Gen IV's, so a
Normal pick could bring a Clefairy, Fairy since Gen VI. The pick now reads the
set's species, or form, from the personal data. It runs here against the
sets, the tree's personal.json and the Hall's tables in the assembly: every
pick of every type, rank and battle has to be a Pokemon of that type, and has
to end (a type with no set in a stretch would never stop looking).
"""

import json
import re
import unittest

from test_form_dex import run
from test_level_cap import ROOT

SOURCE = ROOT / "src/frontier/battle_hall_sets.c"
# The Hall's tables: the stretches, then the sets' species (and, before this
# fix, their baked types).
TABLES = (ROOT / "asm/overlay_80_0222BDF4.s", ROOT / "asm/overlay_80_0223C698.s")
TYPES = ["NORMAL", "FIGHTING", "FLYING", "POISON", "GROUND", "ROCK", "BUG", "GHOST", "STEEL", "MYSTERY",
         "FIRE", "WATER", "GRASS", "ELECTRIC", "PSYCHIC", "ICE", "DRAGON", "DARK", "FAIRY"]
# The types the board offers (TYPE_MYSTERY is the Hall Matron's cell).
BOARD = [t for t in range(len(TYPES)) if TYPES[t] != "MYSTERY"]


def asm_tables(paths):
    """The labelled .byte blocks of assembly files, as bytes."""
    tables, label = {}, None
    for line in "\n".join(path.read_text() for path in paths).splitlines():
        m = re.match(r"^(\w+):", line)
        if m:
            label = m.group(1)
            tables[label] = bytearray()
        elif label and line.strip().startswith(".byte"):
            tables[label] += bytes(int(b, 16) for b in re.findall(r"0x([0-9A-Fa-f]{2})", line))
        elif line.strip().startswith("."):
            label = None
    return tables


def u16s(data):
    return [data[i] | data[i + 1] << 8 for i in range(0, len(data) - 1, 2)]


def constants(header, prefix):
    """A header's #define PREFIX_NAME N, by name."""
    return {m[1]: int(m[2]) for m in re.finditer(rf"#define ({prefix}\w+)\s+(\d+)\s*$",
                                                 (ROOT / header).read_text(), re.M)}


def hall_sets():
    """Each set's (species, form), set 1 first, from files/arc/battle_hall.json,
    which a/2/0/4 is built from."""
    species = constants("include/constants/species.h", "SPECIES_")
    sets = json.loads((ROOT / "files/arc/battle_hall.json").read_text())["sets"]
    return [(species[s["species"]], s["form"]) for s in sets]


def set_types():
    """Each set's two types, by its species or form, from personal.json."""
    personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
    species = (ROOT / "include/constants/species.h").read_text()
    sandy = int(re.search(r"#define SPECIES_WORMADAM_SANDY\s+(\d+)", species)[1])
    wormadam = int(re.search(r"#define SPECIES_WORMADAM\s+(\d+)", species)[1])
    types = []
    for number, form in hall_sets():
        if form:
            # ResolveMonForm: only Wormadam's cloaks are among the Hall's sets.
            assert number == wormadam, (number, form)
            number = sandy + form - 1
        types.append([TYPES.index(t[len("TYPE_"):]) for t in personal[number]["types"]])
    return types


def c_array(name, values, ctype="u16"):
    return f"static const {ctype} {name}[] = {{{', '.join(map(str, values))}}};\n"


PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NARC_a_2_0_4 206
typedef struct { u16 species, moves[4]; u8 evs, nature; u16 item, form; } FrontierMonNarcData;
typedef struct { u8 filler[6]; u8 types[2]; } BASE_STATS;
@DATA@
static u32 sSeed = 1;
static u16 LCRandom(void) { sSeed = sSeed * 1103515245 + 24691; return sSeed >> 16; }
static int ov80_022379C0(int rank) { return rank < 10 ? rank : 9; }
static void ov80_02229EF4(FrontierMonNarcData *dest, u32 index, int narcId) {
    assert(narcId == NARC_a_2_0_4 && index >= 1 && index <= 477);
    memset(dest, 0, sizeof(*dest));
    dest->species = sSetSpecies[index - 1];
    dest->form = sSetForm[index - 1];
}
static u8 sTypes[1024][4][2]; // by species and form, filled from the sets in main
static void LoadMonBaseStats_HandleAlternateForm(int species, int form, BASE_STATS *personal) {
    assert(species < 1024 && form < 4);
    personal->types[0] = sTypes[species][form][0];
    personal->types[1] = sTypes[species][form][1];
}
@NATIVE@

int main(void) {
    static const u8 board[] = {@BOARD@};
    for (int i = 0; i < 477; i++) {
        sTypes[sSetSpecies[i]][sSetForm[i]][0] = sSetType1[i];
        sTypes[sSetSpecies[i]][sSetForm[i]][1] = sSetType2[i];
    }
    for (int seed = 1; seed <= 3; seed++) {
        for (unsigned b = 0; b < sizeof(board); b++) {
            for (int rank = 0; rank < 10; rank++) {
                for (u8 count = 1; count <= 2; count++) {
                    u16 sets[16] = {0};
                    sSeed = seed * 7919 + b * 31 + rank;
                    for (u8 battle = 0; battle < 7; battle++) {
                        ov80_02237448(count, board[b], rank, battle, 0, sets, 0);
                        for (int k = 0; k < count; k++) {
                            u16 set = sets[battle * 2 + k];
                            if (sSetType1[set - 1] != board[b] && sSetType2[set - 1] != board[b]) {
                                printf("type %d, rank %d: set %d (species %d) is not of the type\n",
                                       board[b], rank + 1, set, sSetSpecies[set - 1]);
                                return 1;
                            }
                        }
                    }
                }
            }
        }
    }
    puts("ok");
    return 0;
}
'''


def program():
    tables = asm_tables(TABLES)
    sets, types = hall_sets(), set_types()
    data = "".join([
        c_array("sSetSpecies", [s for s, _ in sets]), c_array("sSetForm", [f for _, f in sets]),
        c_array("sSetType1", [t[0] for t in types], "u8"), c_array("sSetType2", [t[1] for t in types], "u8"),
        "typedef struct { u16 first, last; } BattleHallSetRange;\n",
    ])
    # The Hall's tables, from the assembly, by their labels; a table the
    # source still names (the baked types, before this fix) comes along too.
    for label in ("ov80_0223C990", "ov80_0223CD4A"):
        if label in tables:
            data += c_array(label, u16s(tables[label]))
    if "ov80_0223CD4A" in tables:
        data += "#define ov80_0223CD4A ((const u16 (*)[2])ov80_0223CD4A)\n"
    ranges = u16s(tables["ov80_0223C5A8"]) + u16s(tables["ov80_0223C5B4"][:4])
    data += "static const BattleHallSetRange ov80_0223C5A8[4] = {" + ", ".join(
        f"{{{ranges[i]}, {ranges[i + 1]}}}" for i in range(0, 8, 2)) + "};\n"
    data += "#define ov80_0223C5B4 (ov80_0223C5A8[3])\n"
    ranks = u16s(tables["ov80_0223C5E0"])
    data += "static const BattleHallSetRange ov80_0223C5E0[10] = {" + ", ".join(
        f"{{{ranks[i]}, {ranks[i + 1]}}}" for i in range(0, 20, 2)) + "};\n"
    source = SOURCE.read_text()
    native = source[source.index("int ov80_022379C0(int rank);") + len("int ov80_022379C0(int rank);"):]
    native = re.sub(r"\nextern [^\n]*", "", native)
    return PROGRAM.replace("@DATA@", data).replace("@NATIVE@", native).replace(
        "@BOARD@", ", ".join(map(str, BOARD)))


class BattleHallSetTests(unittest.TestCase):
    def test_every_pick_is_of_its_type(self):
        self.assertEqual(run(program(), "newgold-hall-sets-"), "ok")

    def test_every_type_has_two_sets_in_every_stretch(self):
        # Two, for the double battles' two picks; the search goes round the
        # stretch and would never end on a type with none.
        tables, types = asm_tables(TABLES), set_types()
        ranks = u16s(tables["ov80_0223C5E0"])
        for rank in range(10):
            first, last = ranks[2 * rank], ranks[2 * rank + 1]
            for t in BOARD:
                found = [s for s in range(first, last) if t in types[s - 1]]
                self.assertGreaterEqual(len(found), 2, (TYPES[t], rank + 1))


if __name__ == "__main__":
    unittest.main()
