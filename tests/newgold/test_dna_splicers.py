#!/usr/bin/env python3
"""The DNA Splicers fuse Kyurem with Reshiram or Zekrom, and separate them.

hg-engine gives them field-use routine 31: the party menu opens on the item,
and on a Kyurem it fuses it with the first Reshiram or Zekrom in the party
into White or Black Kyurem, keeping the partner in the save (SAVE_MISC_DATA's
storedMons, ALLOW_SAVE_CHANGES) until they are used on the fused Kyurem again
and it comes back. Glaciate and Scary Face become Ice Burn or Freeze Shock and
Fusion Flare or Fusion Bolt, and back.

The routine and its entry are read from the data and the table; which species
the Kyurem becomes is compiled natively; what happens to the partner is read
from the source.
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
#define PARTY_SIZE 6 /* include/constants/global.h */
#include "constants/pokemon.h"
#include "constants/species.h"
#define STORED_MONS_DNA_SPLICERS 0
typedef struct { u16 species; } Pokemon;
typedef struct { int count; Pokemon mons[PARTY_SIZE]; } Party;
typedef struct { u8 isMonStored[4]; } SAVE_MISC_DATA;
static Pokemon *Party_GetMonByIndex(Party *party, int i) { return &party->mons[i]; }
static int Party_GetCount(const Party *party) { return party->count; }
static u32 GetMonData(Pokemon *mon, int attr, void *dest) {
    (void)dest;
    assert(attr == MON_DATA_SPECIES_OR_EGG);
    return mon->species;
}

@NATIVE@

static Party party(int count, u16 a, u16 b, u16 c) {
    Party p = { count, { { a }, { b }, { c } } };
    return p;
}

int main(void) {
    SAVE_MISC_DATA empty = { { 0 } }, kept = { { 1 } };
    Party p;
    p = party(2, SPECIES_KYUREM, SPECIES_RESHIRAM, 0);
    assert(DNASplicersSpecies(&p, 0, &empty) == SPECIES_KYUREM_WHITE);
    assert(DNASplicersSpecies(&p, 1, &empty) == SPECIES_NONE);
    assert(DNASplicersSpecies(&p, 0, &kept) == SPECIES_NONE);
    p = party(3, SPECIES_ZEKROM, SPECIES_KYUREM, SPECIES_RESHIRAM);
    assert(DNASplicersSpecies(&p, 1, &empty) == SPECIES_KYUREM_BLACK);
    p = party(2, SPECIES_KYUREM, SPECIES_EGG, 0);
    assert(DNASplicersSpecies(&p, 0, &empty) == SPECIES_NONE);
    p = party(1, SPECIES_KYUREM, 0, 0);
    assert(DNASplicersSpecies(&p, 0, &empty) == SPECIES_NONE);
    p = party(1, SPECIES_KYUREM_WHITE, 0, 0);
    assert(DNASplicersSpecies(&p, 0, &kept) == SPECIES_KYUREM);
    assert(DNASplicersSpecies(&p, 0, &empty) == SPECIES_NONE);
    p = party(PARTY_SIZE, SPECIES_KYUREM_BLACK, 0, 0);
    assert(DNASplicersSpecies(&p, 0, &kept) == SPECIES_NONE);
    puts("PASS: Kyurem fuses with the first Reshiram or Zekrom, and separates while the party has room.");
    return 0;
}
"""


# PartyMenu_FinishDNASplicers over a party of species: which panels it has
# drawn again, and where the cursor ends up.
FINISH = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define PARTY_SIZE 6
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/moves.h"
#define STORED_MONS_DNA_SPLICERS 0
#define MI_CpuClear8(p, n) memset((p), 0, (n))
typedef struct { u16 species; } Pokemon;
typedef struct { int count; Pokemon mons[PARTY_SIZE]; } Party;
typedef struct { Pokemon storedMons[4]; u8 isMonStored[4]; } SAVE_MISC_DATA;
typedef struct { Party *party; void *fieldSystem; } PartyMenuArgs;
typedef struct { PartyMenuArgs *args; u8 partyMonIndex; } PartyMenu;
static SAVE_MISC_DATA sMisc;
static int sRedrawnFrom, sCursorMoves;
static void *FieldSystem_GetSaveData(void *fieldSystem) { return fieldSystem; }
static SAVE_MISC_DATA *Save_Misc_Get(void *save) { (void)save; return &sMisc; }
static Pokemon *Party_GetMonByIndex(Party *party, int i) { return &party->mons[i]; }
static int Party_GetCount(const Party *party) { return party->count; }
static u32 GetMonData(Pokemon *mon, int attr, void *dest) { (void)attr; (void)dest; return mon->species; }
static void Mon_SwapMove(Pokemon *mon, u16 from, u16 to) { (void)mon; (void)from; (void)to; }
static void Party_AddMon(Party *party, Pokemon *mon) { party->mons[party->count++] = *mon; }
static void Party_RemoveMon(Party *party, int i) {
    memmove(&party->mons[i], &party->mons[i + 1], (party->count - i - 1) * sizeof(Pokemon));
    memset(&party->mons[--party->count], 0, sizeof(Pokemon));
}
static void sub_0207A89C(PartyMenu *partyMenu) { (void)partyMenu; sCursorMoves++; }
static void PartyMenu_RedrawPanelsFrom(PartyMenu *partyMenu, u8 partySlot) { (void)partyMenu; sRedrawnFrom = partySlot; }

@NATIVE@

static void use(Party *party, u8 slot, u16 kyurem) {
    PartyMenuArgs args = { party, NULL };
    PartyMenu menu = { &args, slot };
    party->mons[slot].species = kyurem; // the scene has changed it
    sRedrawnFrom = -1;
    sCursorMoves = 0;
    PartyMenu_FinishDNASplicers(&menu);
    assert(party->mons[menu.partyMonIndex].species == kyurem);
}

int main(void) {
    Party party = { 5, { { SPECIES_PIDGEY }, { SPECIES_RESHIRAM }, { SPECIES_KYUREM }, { SPECIES_ZEKROM }, { SPECIES_RATTATA } } };

    // Fused, Reshiram before the Kyurem: it goes, the panels from its slot on
    // are drawn again, and the cursor follows the Kyurem up one.
    use(&party, 2, SPECIES_KYUREM_WHITE);
    assert(party.count == 4 && sMisc.isMonStored[0] && sMisc.storedMons[0].species == SPECIES_RESHIRAM);
    assert(sRedrawnFrom == 1 && sCursorMoves == 1);
    // Separated: Reshiram comes back last, and only its panel is new.
    use(&party, 1, SPECIES_KYUREM);
    assert(party.count == 5 && party.mons[4].species == SPECIES_RESHIRAM && !sMisc.isMonStored[0]);
    assert(sRedrawnFrom == 4 && sCursorMoves == 0);
    // Fused, Zekrom after the Kyurem: the cursor stays where it is.
    party.mons[4].species = SPECIES_RATTATA;
    use(&party, 1, SPECIES_KYUREM_BLACK);
    assert(party.count == 4 && sMisc.storedMons[0].species == SPECIES_ZEKROM);
    assert(sRedrawnFrom == 2 && sCursorMoves == 0);
    puts("PASS: after the DNA Splicers the panels from the partner's slot are drawn again, the cursor on the Kyurem.");
    return 0;
}
"""


def run_native(test, program):
    with tempfile.TemporaryDirectory(prefix="newgold-dna-") as temp:
        c, exe = Path(temp) / "check.c", Path(temp) / "check"
        c.write_text(program)
        build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) +
                               ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined",
                                "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)],
                               capture_output=True, text=True)
        test.assertEqual(build.returncode, 0, build.stderr)
        run = subprocess.run([str(exe)], capture_output=True, text=True,
                             env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
        test.assertEqual(run.returncode, 0, run.stdout + run.stderr)
        print(run.stdout.strip())


class DNASplicersTests(unittest.TestCase):
    def test_the_item_opens_the_party_menu_and_can_be_registered(self):
        with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
            row = next(r for r in csv.DictReader(stream) if r["item"] == "ITEM_DNA_SPLICERS_FUSE")
        self.assertEqual(int(row["fieldUseFunc"]), 31)
        table = (ROOT / "src/field_use_item.c").read_text()
        table = table[table.index("sItemFieldUseFuncs[] = {"):]
        entries = [line for line in table[:table.index("\n};")].split("\n") if line.strip().startswith("{ ")]
        self.assertRegex(entries[31], r"\{\s*ItemMenuUseFunc_FormChange,\s*ItemFieldUseFunc_DNASplicers,")

    def test_kyurem_becomes_the_right_species(self):
        source = (ROOT / "src/party_menu.c").read_text()
        run_native(self, NATIVE.replace("@NATIVE@", function(source, "DNASplicersSpecies")))

    def test_the_menu_shows_the_party_it_leaves(self):
        """The partner left the party or came back after the menu had drawn
        its panels, which showed the party from before until it closed."""
        source = (ROOT / "src/party_menu.c").read_text()
        run_native(self, FINISH.replace("@NATIVE@", function(source, "PartyMenu_FinishDNASplicers")))

    def test_the_partner_is_kept_in_the_save_and_given_back(self):
        source = (ROOT / "src/party_menu.c").read_text()
        finish = function(source, "PartyMenu_FinishDNASplicers")
        for line in ("misc->storedMons[STORED_MONS_DNA_SPLICERS] = *Party_GetMonByIndex(party, i);",
                     "Party_RemoveMon(party, i);",
                     "Party_AddMon(party, &misc->storedMons[STORED_MONS_DNA_SPLICERS]);",
                     "misc->isMonStored[STORED_MONS_DNA_SPLICERS] = FALSE;",
                     "Mon_SwapMove(kyurem, MOVE_GLACIATE, white ? MOVE_ICE_BURN : MOVE_FREEZE_SHOCK);",
                     "Mon_SwapMove(kyurem, MOVE_SCARY_FACE, white ? MOVE_FUSION_FLARE : MOVE_FUSION_BOLT);"):
            self.assertIn(line, finish)
        self.assertIn("PartyMenu_FinishDNASplicers(partyMenu);", source)
        header = (ROOT / "include/save_misc_data.h").read_text()
        self.assertIn("Pokemon storedMons[NUM_OF_STORED_MONS];", header)


if __name__ == "__main__":
    unittest.main()
