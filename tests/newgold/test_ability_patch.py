#!/usr/bin/env python3
"""The Ability Patch: to a species' hidden ability and back.

The reference toggles the hidden-ability bit and lets the ability be worked
out again (PartyMenu_HandleUseItemOnMon.c at d0380a487), so the change holds
through the next evolution or form change; this does the same, through the
real UpdateBoxMonAbility. The Patch works on any species that has a hidden
ability, as the reference's CanUseAbilityPatch has it.

The real functions are extracted from src/pokemon.c and compiled natively.
"""

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
#include "constants/pokemon.h"
#include "constants/abilities.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct {
    u8 unused113;
    u16 unused114;
    u16 ability;
    u16 species;
    u8 form;
    u32 personality;
} BoxPokemon;

typedef struct {
    BoxPokemon box;
} Pokemon;

static u16 sAbility1, sAbility2, sHidden;

static u32 GetBoxMonData(BoxPokemon *mon, int attr, void *ptr) {
    assert(ptr == NULL);
    switch (attr) {
    case MON_DATA_UNUSED_113:  return mon->unused113;
    case MON_DATA_UNUSED_114:  return mon->unused114;
    case MON_DATA_ABILITY:     return mon->ability;
    case MON_DATA_SPECIES:     return mon->species;
    case MON_DATA_FORM:        return mon->form;
    case MON_DATA_PERSONALITY: return mon->personality;
    }
    assert(0 && "Unexpected attribute");
    return 0;
}

static void SetBoxMonData(BoxPokemon *mon, int attr, const void *value) {
    switch (attr) {
    case MON_DATA_UNUSED_113: mon->unused113 = *(const u8 *)value; return;
    case MON_DATA_ABILITY:    mon->ability = *(const u16 *)value; return;
    }
    assert(0 && "Unexpected attribute");
}

static u32 GetMonData(Pokemon *mon, int attr, void *ptr) { return GetBoxMonData(&mon->box, attr, ptr); }
static void SetMonData(Pokemon *mon, int attr, const void *value) { SetBoxMonData(&mon->box, attr, value); }
static BOOL AcquireBoxMonLock(BoxPokemon *mon) { (void)mon; return FALSE; }
static void ReleaseBoxMonLock(BoxPokemon *mon, BOOL decry) { (void)mon; (void)decry; }

static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    assert(species == 1 && form == 0);
    switch (stat) {
    case BASE_ABILITY_1:      return sAbility1;
    case BASE_ABILITY_2:      return sAbility2;
    case BASE_HIDDEN_ABILITY: return sHidden;
    }
    assert(0 && "Unexpected stat");
    return 0;
}

void UpdateMonAbility(Pokemon *mon);
@UPDATE_BOX@
@UPDATE@
@CAN_PATCH@
@TOGGLE@

int main(void) {
    sAbility1 = ABILITY_OVERGROW;
    sAbility2 = ABILITY_CHLOROPHYLL;
    sHidden = ABILITY_SOLAR_POWER;

    // On and off again, back to the slot the personality names, and each
    // way it holds through the next time the ability is worked out again.
    for (u32 pid = 0; pid < 2; ++pid) {
        Pokemon mon = { .box = { .species = 1, .personality = pid } };
        UpdateMonAbility(&mon);
        u16 born = mon.box.ability;
        assert(Mon_CanUseAbilityPatch(&mon) == TRUE);
        Mon_ToggleHiddenAbility(&mon);
        assert(mon.box.ability == ABILITY_SOLAR_POWER);
        UpdateMonAbility(&mon);
        assert(mon.box.ability == ABILITY_SOLAR_POWER);
        assert(Mon_CanUseAbilityPatch(&mon) == TRUE);
        Mon_ToggleHiddenAbility(&mon);
        assert(mon.box.ability == born);
        UpdateMonAbility(&mon);
        assert(mon.box.ability == born);
    }

    // One met with its hidden ability, by the script flag's bit, can lose it.
    {
        Pokemon mon = { .box = { .species = 1, .personality = 1, .unused113 = MON_HIDDEN_ABILITY_BIT } };
        UpdateMonAbility(&mon);
        assert(mon.box.ability == ABILITY_SOLAR_POWER);
        Mon_ToggleHiddenAbility(&mon);
        assert(mon.box.ability == ABILITY_CHLOROPHYLL);
    }

    // A species with one ability comes back to it.
    sAbility2 = ABILITY_NONE;
    {
        Pokemon mon = { .box = { .species = 1, .personality = 1 } };
        Mon_ToggleHiddenAbility(&mon);
        assert(mon.box.ability == ABILITY_SOLAR_POWER);
        Mon_ToggleHiddenAbility(&mon);
        assert(mon.box.ability == ABILITY_OVERGROW);
    }

    // No hidden ability, nothing to patch.
    sHidden = ABILITY_NONE;
    {
        Pokemon mon = { .box = { .species = 1, .ability = ABILITY_OVERGROW } };
        assert(Mon_CanUseAbilityPatch(&mon) == FALSE);
    }

    puts("ok");
    return 0;
}
"""


class AbilityPatch(unittest.TestCase):
    def test_actual_c_toggles_the_hidden_ability(self):
        pokemon = read("src/pokemon.c")
        source = FIXTURE.replace("@CAN_PATCH@", function(pokemon, "Mon_CanUseAbilityPatch")) \
                        .replace("@TOGGLE@", function(pokemon, "Mon_ToggleHiddenAbility")) \
                        .replace("@UPDATE_BOX@", function(pokemon, "UpdateBoxMonAbility")) \
                        .replace("@UPDATE@", function(pokemon, "UpdateMonAbility"))
        with tempfile.TemporaryDirectory(prefix="newgold-patch-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-O2",
                "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check"),
            ], check=True)
            subprocess.run([str(path / "check")], cwd=directory, check=True)

    def test_the_party_menu_uses_it(self):
        """The Patch is answered beside the Capsule, ahead of
        CanUseItemOnMonInParty, which has no party-use bit to say yes to."""
        body = function(read("src/party_menu.c"), "PartyMenu_TryUseMintOrAbilityCapsule")
        self.assertRegex(body, r"itemId == ITEM_ABILITY_PATCH && Mon_CanUseAbilityPatch\(mon\) == TRUE\) \{\n\s*Mon_ToggleHiddenAbility\(mon\);")


if __name__ == "__main__":
    unittest.main()
