#!/usr/bin/env python3
"""The two field-use effects of konefr's six that this game can actually hold.

A Mint moves which nature a Pokemon's stats follow without touching the
personality value the born nature comes from, so the answer has to live
somewhere: blockB->unused2, MON_DATA_UNUSED_114, in the same five bits konefr
use. The packing is the part worth a check -- it has to survive all twenty-five
natures, read back as itself, and leave the rest of the halfword alone.

The Ability Capsule is a swap, and a swap that is wrong in one direction is a
Pokemon that quietly lost its ability. This game writes the ability onto the
Pokemon rather than deriving it from a slot bit, so the swap is the ability
itself -- and a Pokemon holding neither of its two personal abilities, which is
what a hidden ability looks like from here, has no slot to swap and must be
refused rather than overwritten.

The real functions are extracted from src/pokemon.c and compiled natively.
"""

import csv
import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "constants/pokemon.h"
#include "constants/abilities.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

// Only the fields the functions read. MON_DATA_UNUSED_113 and _114 are a u8
// and a u16 in block B; MON_DATA_ABILITY takes a u16 payload.
typedef struct {
    u16 unused2;
    u8 unused113;
    u16 ability;
    u16 species;
    u8 form;
    u32 personality;
} BoxPokemon;

typedef struct {
    BoxPokemon box;
} Pokemon;

static u16 sAbility1[2];
static u16 sAbility2[2];
static u16 sHidden;

static u32 GetBoxMonData(BoxPokemon *mon, int attr, void *ptr) {
    assert(ptr == NULL);
    switch (attr) {
    case MON_DATA_UNUSED_113: return mon->unused113;
    case MON_DATA_UNUSED_114: return mon->unused2;
    case MON_DATA_ABILITY:    return mon->ability;
    case MON_DATA_SPECIES:    return mon->species;
    case MON_DATA_FORM:       return mon->form;
    case MON_DATA_PERSONALITY: return mon->personality;
    }
    assert(0 && "Unexpected attribute");
    return 0;
}

static void SetBoxMonData(BoxPokemon *mon, int attr, const void *value) {
    switch (attr) {
    case MON_DATA_UNUSED_114: mon->unused2 = *(const u16 *)value; return;
    case MON_DATA_ABILITY:    mon->ability = *(const u16 *)value; return;
    }
    assert(0 && "Unexpected attribute");
}

static u32 GetMonData(Pokemon *mon, int attr, void *ptr) { return GetBoxMonData(&mon->box, attr, ptr); }
static void SetMonData(Pokemon *mon, int attr, const void *value) { SetBoxMonData(&mon->box, attr, value); }
static BOOL AcquireBoxMonLock(BoxPokemon *mon) { (void)mon; return FALSE; }
static void ReleaseBoxMonLock(BoxPokemon *mon, BOOL decry) { (void)mon; (void)decry; }

static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    assert(species == 1 && form < 2);
    switch (stat) {
    case BASE_ABILITY_1:      return sAbility1[form];
    case BASE_ABILITY_2:      return sAbility2[form];
    case BASE_HIDDEN_ABILITY: return sHidden;
    }
    assert(0 && "Unexpected stat");
    return 0;
}

static u8 GetNatureFromPersonality(u32 pid) { return (u8)(pid % 25); }
static u8 GetMonNature(Pokemon *mon) { return GetNatureFromPersonality(mon->box.personality); }

void UpdateMonAbility(Pokemon *mon);
@UPDATE_BOX@
@UPDATE@
@MASK@
@NATURE@
@SET@
@CAN_CAPSULE@
@SWAP@

static const u8 sMintNatures[] = {
@MINTS@
};

int main(void) {
    // Every nature round-trips, and nothing outside the five bits moves.
    for (u32 nature = 0; nature < NATURE_NUM; ++nature) {
        for (u32 noise = 0; noise < 4; ++noise) {
            static const u16 others[4] = { 0x0000, 0xFFC1, 0x0001, 0x8000 };
            Pokemon mon = { .box = { .unused2 = others[noise], .personality = 7 } };
            Mon_SetMintNature(&mon, (u8)nature);
            assert(GetMonNatureAfterMint(&mon) == nature);
            assert((mon.box.unused2 & (u16)~0x003E) == others[noise]);
        }
    }

    // A Pokemon no Mint has touched still answers the nature it was born with.
    for (u32 pid = 0; pid < 100; ++pid) {
        Pokemon mon = { .box = { .unused2 = 0, .personality = pid } };
        assert(GetMonNatureAfterMint(&mon) == GetNatureFromPersonality(pid));
    }

    // Every Mint in the bag names a nature, and no two name the same one.
    unsigned seen[NATURE_NUM];
    memset(seen, 0, sizeof(seen));
    for (unsigned i = 0; i < sizeof(sMintNatures) / sizeof(sMintNatures[0]); ++i) {
        assert(sMintNatures[i] < NATURE_NUM);
        assert(seen[sMintNatures[i]]++ == 0);
    }

    // The Capsule swaps, for either slot the personality picks, and swapping
    // twice is where it started.
    sAbility1[0] = ABILITY_OVERGROW;
    sAbility2[0] = ABILITY_CHLOROPHYLL;
    sHidden = ABILITY_SOLAR_POWER;
    for (u32 pid = 0; pid < 2; ++pid) {
        Pokemon mon = { .box = { .species = 1, .form = 0, .personality = pid } };
        UpdateMonAbility(&mon);
        u16 born = mon.box.ability, other = born == ABILITY_OVERGROW ? ABILITY_CHLOROPHYLL : ABILITY_OVERGROW;
        assert(Mon_CanUseAbilityCapsule(&mon) == TRUE);
        Mon_SwapAbilitySlot(&mon);
        assert(mon.box.ability == other);
        // The swap outlives the next time the ability is worked out again,
        // as on an evolution or a form change.
        UpdateMonAbility(&mon);
        assert(mon.box.ability == other);
        // And the Mint's bits beside it are left alone.
        Mon_SetMintNature(&mon, 3);
        UpdateMonAbility(&mon);
        assert(mon.box.ability == other && GetMonNatureAfterMint(&mon) == 3);
        assert(Mon_CanUseAbilityCapsule(&mon) == TRUE);
        Mon_SwapAbilitySlot(&mon);
        assert(mon.box.ability == born);
        UpdateMonAbility(&mon);
        assert(mon.box.ability == born && GetMonNatureAfterMint(&mon) == 3);
    }

    // One ability, or the same one twice: nothing to swap.
    sAbility2[0] = ABILITY_NONE;
    {
        Pokemon mon = { .box = { .species = 1, .form = 0, .ability = ABILITY_OVERGROW } };
        assert(Mon_CanUseAbilityCapsule(&mon) == FALSE);
    }
    sAbility2[0] = ABILITY_OVERGROW;
    {
        Pokemon mon = { .box = { .species = 1, .form = 0, .ability = ABILITY_OVERGROW } };
        assert(Mon_CanUseAbilityCapsule(&mon) == FALSE);
    }

    // A hidden ability is neither slot, so the Capsule must not eat it, whether
    // its bit says so or only the ability does.
    sAbility1[0] = ABILITY_OVERGROW;
    sAbility2[0] = ABILITY_CHLOROPHYLL;
    {
        Pokemon mon = { .box = { .species = 1, .form = 0, .ability = ABILITY_SOLAR_POWER } };
        assert(Mon_CanUseAbilityCapsule(&mon) == FALSE);
        mon.box.unused113 = MON_HIDDEN_ABILITY_BIT;
        mon.box.ability = ABILITY_OVERGROW;
        assert(Mon_CanUseAbilityCapsule(&mon) == FALSE);
    }

    // The slots are read per form, not per species.
    sAbility1[1] = ABILITY_BLAZE;
    sAbility2[1] = ABILITY_SOLAR_POWER;
    {
        Pokemon mon = { .box = { .species = 1, .form = 1, .ability = ABILITY_BLAZE } };
        assert(Mon_CanUseAbilityCapsule(&mon) == TRUE);
        Mon_SwapAbilitySlot(&mon);
        assert(mon.box.ability == ABILITY_SOLAR_POWER);
    }

    puts("ok");
    return 0;
}
"""

# The records konefr give one of the six routines. Two of those routines open
# the party menu, which is routine 1 here. The other four change a form --
# Reveal Glass, DNA Splicers, the Nectars, the Rotom Catalog. All four are
# ported (test_form_change_items.py, test_dna_splicers.py); one still at
# routine 0 would be listed in STILL_INERT, which may only shrink.
PARTY_MENU_FIELD_USE = 1
GENERIC_FIELD_USE = 0
MINTS = [f"ITEM_{name}_MINT" for name in (
    "LONELY ADAMANT NAUGHTY BRAVE BOLD IMPISH LAX RELAXED MODEST MILD RASH "
    "QUIET CALM GENTLE CAREFUL SASSY TIMID HASTY JOLLY NAIVE SERIOUS").split()]
FORM_CHANGE_ITEMS = ["ITEM_REVEAL_GLASS", "ITEM_DNA_SPLICERS_FUSE", "ITEM_ROTOM_CATALOG",
                     "ITEM_RED_NECTAR", "ITEM_YELLOW_NECTAR", "ITEM_PINK_NECTAR", "ITEM_PURPLE_NECTAR"]
STILL_INERT = []


def records():
    with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as stream:
        return {row["item"]: row for row in csv.DictReader(stream)}


class ItemRecords(unittest.TestCase):
    def test_the_mints_and_the_capsule_open_the_party_menu(self):
        """Routine 1 is what every medicine uses to reach the party menu, and it
        is the routine konefr themselves give the Ability Patch, an item with
        exactly these needs. Without it the bag's USE does nothing."""
        rows = records()
        for item in MINTS + ["ITEM_ABILITY_CAPSULE"]:
            self.assertEqual(int(rows[item]["fieldUseFunc"]), PARTY_MENU_FIELD_USE, item)
            self.assertEqual(int(rows[item]["partyUse"]), 1, item)

    def test_the_inert_form_changers_are_the_ones_listed(self):
        """Reveal Glass, DNA Splicers, the Nectars and the Rotom Catalog: the
        ones still at routine 0 are exactly STILL_INERT, and that list only
        shrinks. A ported item leaves the list; one given a routine while it
        is still listed fails here, and so does the list growing."""
        rows = records()
        inert = [item for item in FORM_CHANGE_ITEMS
                 if int(rows[item]["fieldUseFunc"]) == GENERIC_FIELD_USE]
        self.assertEqual(inert, STILL_INERT)
        self.assertLessEqual(len(STILL_INERT), 1)

    def test_the_mint_ids_are_one_unbroken_run(self):
        """src/party_menu.c indexes sMintNatures by itemId - ITEM_LONELY_MINT."""
        header = (ROOT / "include/constants/items.h").read_text()
        ids = {name: int(value) for name, value
               in re.findall(r"^#define (ITEM_\w+)\s+(\d+)$", header, re.M)}
        numbers = [ids[name] for name in MINTS]
        self.assertEqual(numbers, list(range(numbers[0], numbers[0] + len(MINTS))))
        self.assertEqual(ids["ITEM_SERIOUS_MINT"] - ids["ITEM_LONELY_MINT"] + 1, len(MINTS))

    def test_the_party_menu_names_rows_msg_0300_holds(self):
        gmm = (ROOT / "files/msgdata/msg/msg_0300.gmm").read_text()
        rows = set(re.findall(r'<row id="(msg_0300_\d+)"', gmm))
        for name in re.findall(r"msg_0300_\d+", read("src/party_menu.c")):
            self.assertIn(name, rows)


class NatureOverrideAndAbilitySwap(unittest.TestCase):
    def test_actual_c_mint_packing_and_capsule_swap(self):
        pokemon = read("src/pokemon.c")
        mints = re.search(r"static const u8 sMintNatures\[[^\]]*\] = \{(.*?)\n\};",
                          read("src/party_menu.c"), re.S)
        self.assertIsNotNone(mints, "sMintNatures moved out of src/party_menu.c")
        # The mask lives beside the functions, not inside them.
        mask = re.search(r"^#define MON_MINT_NATURE_MASK .*$", pokemon, re.M)
        self.assertIsNotNone(mask, "MON_MINT_NATURE_MASK moved out of src/pokemon.c")
        source = FIXTURE
        for token, replacement in {
            "@MASK@": mask.group(0),
            "@NATURE@": function(pokemon, "GetMonNatureAfterMint"),
            "@SET@": function(pokemon, "Mon_SetMintNature"),
            "@CAN_CAPSULE@": function(pokemon, "Mon_CanUseAbilityCapsule"),
            "@SWAP@": function(pokemon, "Mon_SwapAbilitySlot"),
            "@UPDATE_BOX@": function(pokemon, "UpdateBoxMonAbility"),
            "@UPDATE@": function(pokemon, "UpdateMonAbility"),
            "@MINTS@": mints.group(1),
        }.items():
            source = source.replace(token, replacement)
        with tempfile.TemporaryDirectory(prefix="newgold-mints-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-O2",
                "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check"),
            ], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)


if __name__ == "__main__":
    unittest.main()
