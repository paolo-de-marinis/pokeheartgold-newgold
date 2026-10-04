#!/usr/bin/env python3
"""Run the Battle Hall's opponent pick on the host, with the Hall's own sets.

ov80_02237448 (src/frontier/battle_hall_sets.c) picks the opponent of a type
board category from its rank's stretch of the Hall's sets (a/2/0/4, built
from files/arc/battle_hall.json).
Retail matched the type against two types baked for each set, Gen IV's, so a
Normal pick could bring a Clefairy, Fairy since Gen VI. The pick now reads the
set's species, or form, from the personal data. It runs here against the
sets, the tree's personal.json and the Hall's tables in C: every
pick of every type, rank and battle has to be a Pokemon of that type, and has
to end (a type with no set in a stretch would never stop looking).
"""

import json
import re
import sys
import unittest

from test_form_dex import run
from test_level_cap import ROOT

SOURCE = ROOT / "src/frontier/battle_hall_sets.c"
# The Hall's tables: the stretches of the sets by strength and by rank, and
# each set's species.
TABLES = (ROOT / "src/frontier/battle_hall_tables.c", ROOT / "src/frontier/battle_hall_set_species.c")
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
#include <unistd.h>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NARC_a_2_0_4 206
typedef struct { u16 species, moves[4]; u8 evs, nature; u16 item, form; } FrontierMonNarcData;
typedef struct { u8 filler[6]; u8 types[2]; } BASE_STATS;
@DATA@
static u32 sSeed = 1;
static int sStart = -1; // where in the stretch the search starts, or -1 at random
static u16 LCRandom(void) {
    if (sStart >= 0) {
        return sStart;
    }
    sSeed = sSeed * 1103515245 + 24691;
    return sSeed >> 16;
}
static int ov80_022379C0(int rank) { return rank < 10 ? rank : 9; }
static void ov80_02229EF4(FrontierMonNarcData *dest, u32 index, int narcId) {
    assert(narcId == NARC_a_2_0_4 && index >= 1 && index <= BATTLE_HALL_SET_COUNT);
    memset(dest, 0, sizeof(*dest));
    dest->species = sSetSpecies[index - 1];
    dest->form = sSetForm[index - 1];
}
static u8 sTypes[2048][4][2]; // by species and form, filled from the sets in main
static void LoadMonBaseStats_HandleAlternateForm(int species, int form, BASE_STATS *personal) {
    assert(species < 2048 && form < 4);
    personal->types[0] = sTypes[species][form][0];
    personal->types[1] = sTypes[species][form][1];
}
@NATIVE@

@MAIN@
'''

MAIN = r'''
int main(void) {
    static const u8 board[] = {@BOARD@};
    alarm(60); // a search that never ends
    for (int i = 0; i < BATTLE_HALL_SET_COUNT; i++) {
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

# A double challenge's first three battles all of one type at one rank, each
# search started on the same set of the stretch, for every set: the picks run
# out of sets of the type not yet picked, and the search has to notice it has
# been round the stretch to take one again.
ROUND = r'''
int main(void) {
    static const u8 board[] = {@BOARD@};
    alarm(60); // a search that never ends
    for (int i = 0; i < BATTLE_HALL_SET_COUNT; i++) {
        sTypes[sSetSpecies[i]][sSetForm[i]][0] = sSetType1[i];
        sTypes[sSetSpecies[i]][sSetForm[i]][1] = sSetType2[i];
    }
    for (unsigned b = 0; b < sizeof(board); b++) {
        for (int rank = 0; rank < 10; rank++) {
            const BattleHallSetRange *range = &gBattleHallRankStretches[rank];
            for (int start = 0; start <= range->last - range->first; start++) {
                u16 sets[16] = {0};
                sStart = start;
                for (u8 battle = 0; battle < 3; battle++) {
                    ov80_02237448(2, board[b], rank, battle, 0, sets, 0);
                    for (int k = 0; k < 2; k++) {
                        u16 set = sets[battle * 2 + k];
                        assert(sSetType1[set - 1] == board[b] || sSetType2[set - 1] == board[b]);
                    }
                }
            }
        }
    }
    puts("ok");
    return 0;
}
'''


def c_tables():
    """The Hall's tables as the C defines them, for the host: the files
    without their includes, the header's count and range type before them."""
    header = (ROOT / "include/frontier/battle_hall.h").read_text()
    out = re.search(r"#define BATTLE_HALL_SET_COUNT .*", header)[0] + "\n"
    out += re.search(r"typedef struct BattleHallSetRange \{.*?\} BattleHallSetRange;", header, re.S)[0] + "\n"
    for path in TABLES:
        out += re.sub(r"(?m)^#include .*$", "", path.read_text())
    return out


def ranges(name):
    """A table of stretches in battle_hall_tables.c, as (first, last)."""
    text = TABLES[0].read_text()
    body = text[text.index(f"BattleHallSetRange {name}["):]
    body = body[:body.index("};")]
    return [(int(a), int(b)) for a, b in re.findall(r"\{\s*(\d+),\s*(\d+)\s*\}", body)]


def program(main=MAIN):
    sets, types = hall_sets(), set_types()
    data = "".join([
        "#include \"constants/species.h\"\n",
        c_array("sSetSpecies", [s for s, _ in sets]), c_array("sSetForm", [f for _, f in sets]),
        c_array("sSetType1", [t[0] for t in types], "u8"), c_array("sSetType2", [t[1] for t in types], "u8"),
        c_tables(),
    ])
    source = SOURCE.read_text()
    native = source[source.index("int ov80_022379C0(int rank);") + len("int ov80_022379C0(int rank);"):]
    return PROGRAM.replace("@DATA@", data).replace("@NATIVE@", native).replace("@MAIN@", main).replace(
        "@BOARD@", ", ".join(map(str, BOARD)))


# The same pick, from every start in each rank's stretch in turn (LCRandom
# gives the start), for a Fairy-type board category: each pick's species.
STARTS = r'''
#include "constants/pokemon.h"
int main(void) {
    for (int i = 0; i < BATTLE_HALL_SET_COUNT; i++) {
        sTypes[sSetSpecies[i]][sSetForm[i]][0] = sSetType1[i];
        sTypes[sSetSpecies[i]][sSetForm[i]][1] = sSetType2[i];
    }
    for (int rank = 0; rank < 10; rank++) {
        const BattleHallSetRange *range = &gBattleHallRankStretches[rank];
        for (int start = 0; start <= range->last - range->first; start++) {
            u16 sets[16] = {0};
            sStart = start;
            ov80_02237448(1, TYPE_FAIRY, rank, 0, SPECIES_NONE, sets, 0);
            printf("%d %d\n", rank, sSetSpecies[sets[0] - 1]);
        }
    }
    return 0;
}
'''


def fairy_picks():
    """Each rank's Fairy-type picks, a species for every start."""
    picks = [[] for _ in range(10)]
    for line in run(program(STARTS), "newgold-hall-starts-").splitlines():
        rank, species = map(int, line.split())
        picks[rank].append(species)
    return picks


class BattleHallSetTests(unittest.TestCase):
    def test_every_pick_is_of_its_type(self):
        self.assertEqual(run(program(), "newgold-hall-sets-"), "ok")

    def test_a_search_started_on_a_stretch_s_last_set_ends(self):
        # Retail's search turned back one set before the stretch's end: one
        # started on the last set never came back to it, never knew it had
        # been round, and once the type's other sets were all picked in the
        # round it never ended (the game hung).
        self.assertEqual(run(program(ROUND), "newgold-hall-round-"), "ok")

    def test_every_type_has_two_sets_in_every_stretch(self):
        # Two, for the double battles' two picks; the search goes round the
        # stretch and would never end on a type with none.
        types = set_types()
        for rank, (first, last) in enumerate(ranges("gBattleHallRankStretches")):
            for t in BOARD:
                found = [s for s in range(first, last + 1) if t in types[s - 1]]
                self.assertGreaterEqual(len(found), 2, (TYPES[t], rank + 1))

    def test_the_ranks_pick_from_retail_s_strengths(self):
        # The sets go from the weakest to the strongest in four strengths,
        # one after the other; each rank picks from retail's ones: the first,
        # the first two, the middle two, the last two.
        strengths = ranges("gBattleHallStrengths")
        count = len(hall_sets())
        self.assertEqual([first for first, _ in strengths], [1] + [last + 1 for _, last in strengths[:3]])
        self.assertEqual(strengths[3][1], count)
        joined = [strengths[0]] * 2 + [(strengths[0][0], strengths[1][1])] * 3 + \
            [(strengths[1][0], strengths[2][1])] * 3 + [(strengths[2][0], strengths[3][1])] * 2
        self.assertEqual(ranges("gBattleHallRankStretches"), joined)

    def test_every_fairy_rank_fields_the_newer_fairy_pokemon(self):
        # Paolo (2026-10-02): the Hall's Fairy rank fields the Fairy Pokemon
        # of the later generations. The pick goes on from a random start to
        # the next set of the type, so a set is picked as often as the sets
        # before it since the last of its type: the new sets are spread
        # through their strengths, not bunched at one end, and at every rank
        # they are a third of the Fairy picks or more.
        arceus = constants("include/constants/species.h", "SPECIES_")["SPECIES_ARCEUS"]
        for rank, picks in enumerate(fairy_picks()):
            newer = [species for species in picks if species > arceus]
            self.assertGreaterEqual(3 * len(newer), len(picks), rank + 1)

    def test_the_newer_sets_are_ones_a_player_could_have(self):
        # The sets past retail's: moves the species learns in this game, no
        # move twice and none the game leaves unimplemented, a nature, an
        # item and the stats the EVs go to.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
        import savedit
        species = constants("include/constants/species.h", "SPECIES_")
        moves = constants("include/constants/moves.h", "MOVE_")
        items = constants("include/constants/items.h", "ITEM_")
        natures = constants("include/constants/pokemon.h", "NATURE_")
        newer = [s for s in json.loads((ROOT / "files/arc/battle_hall.json").read_text())["sets"]
                 if species[s["species"]] > species["SPECIES_ARCEUS"]]
        self.assertTrue(newer)
        for s in newer:
            number = species[s["species"]]
            learnt = savedit.learnable_moves(number, s["form"])
            known = [moves[m] for m in s["moves"]]
            self.assertEqual(len(set(known)), 4, s["species"])
            for move in known:
                self.assertIn(move, learnt, (s["species"], move))
                self.assertNotIn(move, savedit.unimplemented_moves(), (s["species"], move))
            self.assertIn(s["nature"], natures)
            self.assertGreater(items[s["item"]], 0, s["species"])
            self.assertTrue(s["evs"], s["species"])

    def test_the_species_table_is_the_sets(self):
        # The pick looks the player's species up in gBattleHallSetSpecies and
        # reads the sets from a/2/0/4: the two have to agree, set for set.
        text = TABLES[1].read_text()
        table = re.findall(r"\b(SPECIES_\w+),", text[text.index("gBattleHallSetSpecies["):])
        sets = json.loads((ROOT / "files/arc/battle_hall.json").read_text())["sets"]
        self.assertEqual(table, [s["species"] for s in sets])
        count = int(re.search(r"#define BATTLE_HALL_SET_COUNT (\d+)",
                              (ROOT / "include/frontier/battle_hall.h").read_text())[1])
        self.assertEqual(count, len(sets))


if __name__ == "__main__":
    unittest.main()
