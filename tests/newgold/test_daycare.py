#!/usr/bin/env python3
"""Check the Day-Care's tables reach every species."""

import os
import re
import shlex
import struct
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT


def species():
    header = (ROOT / "include/constants/species.h").read_text()
    numbers = {name: int(n) for name, n in re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}
    return numbers, numbers[re.search(r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)", header).group(1)]


class EggSpeciesTests(unittest.TestCase):
    """pms.narc, one halfword a species: what an egg from that mother is."""

    def setUp(self):
        data = (ROOT / "files/poketool/personal/pms.narc").read_bytes()
        self.table = struct.unpack(f"<{len(data) // 2}H", data)
        self.numbers, self.last = species()

    def egg(self, name):
        return self.table[self.numbers[name]]

    def test_every_species_has_an_egg_species(self):
        self.assertEqual(len(self.table), self.last + 1)
        self.assertEqual([n for n in range(1, self.last + 1) if not 0 < self.table[n] <= self.last], [])

    def test_added_species_and_forms_breed_true(self):
        self.assertEqual(self.egg("SERVINE"), self.numbers["SNIVY"])
        self.assertEqual(self.egg("SYLVEON"), self.numbers["EEVEE"])
        # The mother's form carries over, as the reference's form number does.
        self.assertEqual(self.egg("NINETALES_ALOLAN"), self.numbers["VULPIX_ALOLAN"])
        self.assertEqual(self.egg("MEGA_VENUSAUR"), self.numbers["BULBASAUR"])


class EggMoveTests(unittest.TestCase):
    """kowaza_list.narc: MAX_EGG_MOVES halfwords a species, read by
    LoadEggMoves at species * MAX_EGG_MOVES and ended by 0xFFFF."""

    def setUp(self):
        import sys
        sys.path.insert(0, str(ROOT / "tools/newgold/import"))
        import wotbl
        member, = wotbl.read_narc((ROOT / "files/fielddata/sodateya/kowaza_list.narc").read_bytes())[0]
        self.width = int(re.search(r"#define MAX_EGG_MOVES\s+(\d+)",
                                   (ROOT / "include/constants/daycare.h").read_text()).group(1))
        self.numbers, self.last = species()
        self.member = member
        self.moves = wotbl.move_names()

    def moves_of(self, name):
        record = struct.unpack_from(f"<{self.width}H", self.member, self.numbers[name] * self.width * 2)
        return list(record[:record.index(0xFFFF)] if 0xFFFF in record else record)

    def test_every_species_has_a_record(self):
        self.assertEqual(len(self.member), (self.last + 1) * self.width * 2)

    def test_the_reader_reads_the_species_record(self):
        """Retail's reader searched the first 2045 halfwords for a marker."""
        reader = re.search(r"\nu8 LoadEggMoves\([^;{]*\{.*?\n\}", (ROOT / "src/get_egg.c").read_text(), re.S).group(0)
        self.assertIn("species * MAX_EGG_MOVES * sizeof(u16), MAX_EGG_MOVES * sizeof(u16)", reader)

    def test_the_lists_are_hg_engines(self):
        # d0380a487's learnsets.json: Chikorita's modern list, one added
        # species and one form.
        self.assertEqual(self.moves_of("CHIKORITA"), [self.moves[m] for m in (
            "MOVE_VINE_WHIP", "MOVE_COUNTER", "MOVE_FLAIL", "MOVE_ANCIENT_POWER", "MOVE_INGRAIN", "MOVE_HEAL_PULSE")])
        self.assertIn(self.moves["MOVE_COPYCAT"], self.moves_of("SPRIGATITO"))
        self.assertIn(self.moves["MOVE_MOONBLAST"], self.moves_of("VULPIX_ALOLAN"))



SHARING = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include "constants/daycare.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef struct { u32 species, item, moves[MAX_MON_MOVES], pp[MAX_MON_MOVES]; } BoxPokemon;

static u32 GetBoxMonData(BoxPokemon *mon, int field, void *unused) {
    (void)unused;
    if (field == MON_DATA_SPECIES) return mon->species;
    if (field == MON_DATA_HELD_ITEM) return mon->item;
    if (field >= MON_DATA_MOVE1 && field < MON_DATA_MOVE1 + MAX_MON_MOVES) return mon->moves[field - MON_DATA_MOVE1];
    if (field >= MON_DATA_MOVE1_MAX_PP && field < MON_DATA_MOVE1_MAX_PP + MAX_MON_MOVES) return mon->moves[field - MON_DATA_MOVE1_MAX_PP] + 100;
    assert(0);
    return 0;
}

static void SetBoxMonData(BoxPokemon *mon, int field, void *value) {
    if (field >= MON_DATA_MOVE1 && field < MON_DATA_MOVE1 + MAX_MON_MOVES) mon->moves[field - MON_DATA_MOVE1] = *(u32 *)value;
    else if (field >= MON_DATA_MOVE1_PP && field < MON_DATA_MOVE1_PP + MAX_MON_MOVES) mon->pp[field - MON_DATA_MOVE1_PP] = *(u32 *)value;
    else assert(0);
}

// Every species' egg moves are Tackle, Growl and Pound; a form counts as its base.
static u8 LoadEggMoves(u16 species, u16 *dest) {
    (void)species;
    dest[0] = MOVE_TACKLE, dest[1] = MOVE_GROWL, dest[2] = MOVE_POUND, dest[3] = 0xFFFF;
    return 3;
}
static u16 SpeciesToDexSpecies(u16 species) { return species == SPECIES_VULPIX_ALOLAN ? SPECIES_VULPIX : species; }

@FUNCTIONS@

static BoxPokemon mon(u32 species, u32 item, u32 m0, u32 m1, u32 m2, u32 m3) {
    BoxPokemon b = { species, item, { m0, m1, m2, m3 }, { 0, 0, 0, 0 } };
    return b;
}

int main(void) {
    // Same species: each learns the other's egg moves it lacks, in order, at full PP.
    BoxPokemon party = mon(SPECIES_VULPIX_ALOLAN, 0, MOVE_EMBER, 0, 0, 0);
    BoxPokemon daycare = mon(SPECIES_VULPIX, 0, MOVE_GROWL, MOVE_EMBER, MOVE_TACKLE, 0);
    Daycare_ShareEggMoves(&party, &daycare);
    assert(party.moves[1] == MOVE_GROWL && party.moves[2] == MOVE_TACKLE && party.moves[3] == 0);
    assert(party.pp[1] == MOVE_GROWL + 100 && party.pp[2] == MOVE_TACKLE + 100);
    assert(daycare.moves[3] == 0);  // the party Pokemon knows nothing it lacks

    party = mon(SPECIES_EEVEE, 0, MOVE_POUND, 0, 0, 0);
    daycare = mon(SPECIES_EEVEE, 0, MOVE_EMBER, 0, 0, 0);
    Daycare_ShareEggMoves(&party, &daycare);
    assert(daycare.moves[1] == MOVE_POUND && party.moves[1] == 0);  // the one already left learns too

    // Different species: only the Mirror Herb's holder learns.
    party = mon(SPECIES_EEVEE, 0, MOVE_POUND, 0, 0, 0);
    daycare = mon(SPECIES_DITTO, ITEM_MIRROR_HERB, MOVE_TACKLE, 0, 0, 0);
    Daycare_ShareEggMoves(&party, &daycare);
    assert(daycare.moves[1] == MOVE_POUND && party.moves[1] == 0);
    party = mon(SPECIES_EEVEE, 0, MOVE_POUND, 0, 0, 0);
    daycare = mon(SPECIES_DITTO, 0, MOVE_TACKLE, 0, 0, 0);
    Daycare_ShareEggMoves(&party, &daycare);
    assert(daycare.moves[1] == 0 && party.moves[1] == 0);

    // A full move set learns nothing.
    party = mon(SPECIES_EEVEE, 0, MOVE_EMBER, MOVE_EMBER, MOVE_EMBER, MOVE_EMBER);
    daycare = mon(SPECIES_EEVEE, 0, MOVE_TACKLE, 0, 0, 0);
    Daycare_ShareEggMoves(&party, &daycare);
    assert(party.moves[3] == MOVE_EMBER);
    return 0;
}
"""


def static_function(source, name):
    match = re.search(r"^static void " + name + r"\([^;]*?\) \{", source, re.M)
    depth, end = 1, match.end()
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[match.start():end]


class EggMoveSharingTests(unittest.TestCase):
    """ScrCmd_DaycareSanitizeMon's egg-move sharing, the real C on the host."""

    def test_same_species_and_mirror_herb(self):
        source = (ROOT / "src/scrcmd_daycare.c").read_text()
        functions = "\n\n".join(static_function(source, name) for name in
                                  ("Daycare_LearnEggMovesFrom", "Daycare_ShareEggMoves"))
        with tempfile.TemporaryDirectory(prefix="newgold-daycare-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(SHARING.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], check=True)
            subprocess.run([str(path / "test")], check=True)


INHERIT = r"""
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "constants/daycare.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#define NULL ((void *)0)
#define HEAP_ID_FIELD1 0
#define LEVEL_UP_LEARNSET_SIZE 34
#define MOVE_APPEND_FULL 0xFFFFu
typedef struct { u32 species, moves[MAX_MON_MOVES]; } BoxPokemon;
typedef BoxPokemon Pokemon;

static void *Heap_Alloc(int heap, u32 size) { (void)heap; return malloc(size); }
static void Heap_Free(void *p) { free(p); }
static void MI_CpuClearFast(void *p, u32 size) { memset(p, 0, size); }
static u32 GetBoxMonData(BoxPokemon *mon, int field, void *unused) {
    (void)unused;
    if (field == MON_DATA_SPECIES) return mon->species;
    if (field == MON_DATA_FORM) return 0;
    assert(field >= MON_DATA_MOVE1 && field < MON_DATA_MOVE1 + MAX_MON_MOVES);
    return mon->moves[field - MON_DATA_MOVE1];
}
static u32 GetMonData(Pokemon *mon, int field, void *unused) { return GetBoxMonData(mon, field, unused); }
static u32 TryAppendMonMove(Pokemon *mon, u16 move) {
    for (int i = 0; i < MAX_MON_MOVES; i++) {
        if (mon->moves[i] == MOVE_NONE) { mon->moves[i] = move; return move; }
    }
    return MOVE_APPEND_FULL;
}
static void DeleteMonFirstMoveAndAppend(Pokemon *mon, u16 move) {
    memmove(mon->moves, mon->moves + 1, sizeof(mon->moves[0]) * (MAX_MON_MOVES - 1));
    mon->moves[MAX_MON_MOVES - 1] = move;
}
// The baby learns Tackle by level-up and Growl as an egg move; every machine
// is Thunderbolt's, and the baby can be taught it.
static u16 Species_LoadLearnsetTable(u16 species, u16 form, u16 *dest) { (void)species; (void)form; dest[0] = MOVE_TACKLE; return 1; }
static u8 LoadEggMoves(u16 species, u16 *dest) { (void)species; dest[0] = MOVE_GROWL; dest[1] = 0xFFFF; return 1; }
__attribute__((unused)) static u16 TMHMGetMove(u16 item) { (void)item; return MOVE_THUNDERBOLT; }
__attribute__((unused)) static int GetTMHMCompatBySpeciesAndForm(u16 species, u16 form, u8 machine) { (void)species; (void)form; (void)machine; return 1; }

@FUNCTIONS@

int main(void) {
    Pokemon egg = { SPECIES_PICHU, { 0 } };
    BoxPokemon father = { SPECIES_PIKACHU, { MOVE_THUNDERBOLT, MOVE_GROWL, MOVE_TACKLE, 0 } };
    BoxPokemon mother = { SPECIES_PIKACHU, { MOVE_TACKLE, 0, 0, 0 } };
    InheritMoves(&egg, &father, &mother);
    // The father's egg move, then the level-up move both parents know; not
    // the father's machine move.
    assert(egg.moves[0] == MOVE_GROWL && egg.moves[1] == MOVE_TACKLE && egg.moves[2] == MOVE_NONE);
    return 0;
}
"""


class InheritMovesTests(unittest.TestCase):
    """InheritMoves, the real C on the host: the moves an egg starts with."""

    def test_the_father_passes_no_machine_move(self):
        """From the sixth generation on an egg does not inherit the father's
        TM moves (Bulbapedia, Pokemon breeding)."""
        source = (ROOT / "src/get_egg.c").read_text()
        search = re.search(r"^struct EggMoveSearch \{.*?^\};", source, re.M | re.S).group(0)
        functions = search + "\n\n" + static_function(source, "InheritMoves")
        with tempfile.TemporaryDirectory(prefix="newgold-inherit-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(INHERIT.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=gnu99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], check=True)
            subprocess.run([str(path / "test")], check=True)


if __name__ == "__main__":
    unittest.main()
