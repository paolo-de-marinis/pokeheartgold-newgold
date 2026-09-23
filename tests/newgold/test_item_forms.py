#!/usr/bin/env python3
"""The forms and types a held item gives.

RKS System makes Silvally the type of the Memory it holds (Pokemon Central,
Sistema RKS), in battle and out of it, as Multitype does Arceus with a plate;
the reference reads the plates for it, a defect its own comment admits.

Genesect's Drives, Ogerpon's masks and Dialga's and Palkia's origin items
give each its form, a species of its own here, when the item is given or
taken in the party and when a Pokemon holding one comes into battle.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

OVERLAY = "src/battle/overlay_12_0224E4FC.c"

GET_TYPE_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT(x) assert(x)
typedef struct { u16 species, ability, item; u8 type1, type2, type3; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
static int GetItemVar(BattleContext *ctx, u16 item, int var) {
    (void)ctx; assert(var == ITEM_VAR_HOLD_EFFECT);
    switch (item) {
    case ITEM_FIRE_MEMORY: return HOLD_EFFECT_FIRE_MEMORY;
    case ITEM_FAIRY_MEMORY: return HOLD_EFFECT_FAIRY_MEMORY;
    case ITEM_FLAME_PLATE: return HOLD_EFFECT_ARCEUS_FIRE;
    }
    return HOLD_EFFECT_NONE;
}
@MEMORY@
@GET_TYPE@
int main(void) {
    BattleContext ctx = { 0 };
    BattleMon *mon = &ctx.battleMons[0];
    mon->species = SPECIES_SILVALLY; mon->ability = ABILITY_RKS_SYSTEM;
    mon->type1 = mon->type2 = TYPE_NORMAL;
    mon->item = ITEM_FIRE_MEMORY;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_FIRE && Battler_GetType(&ctx, 0, BMON_DATA_TYPE_2) == TYPE_FIRE);
    mon->item = ITEM_FAIRY_MEMORY;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_FAIRY);
    mon->item = ITEM_FLAME_PLATE;                       // a plate is not a Memory
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_NORMAL);
    mon->item = ITEM_NONE;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_NORMAL);
    mon->item = ITEM_FIRE_MEMORY; mon->ability = ABILITY_NONE;   // not without RKS System
    mon->type1 = mon->type2 = TYPE_WATER;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_WATER);
    mon->species = SPECIES_ARCEUS; mon->ability = ABILITY_MULTITYPE;   // Arceus reads plates still
    mon->item = ITEM_FLAME_PLATE;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_FIRE);
    mon->item = ITEM_FIRE_MEMORY;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_NORMAL);
    return 0;
}
"""


def run_c(program):
    with tempfile.TemporaryDirectory(prefix="newgold-item-forms-") as directory:
        path = Path(directory)
        (path / "check.c").write_text(program)
        build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
        if build.returncode != 0:
            raise AssertionError(build.stderr)
        run = subprocess.run([str(path / "check")], capture_output=True, text=True)
        if run.returncode != 0:
            raise AssertionError(run.stdout + run.stderr)
        return run.stdout


class RksSystemTests(unittest.TestCase):
    def test_the_memory_types_silvally_in_battle(self):
        program = (GET_TYPE_FIXTURE.replace("@MEMORY@", function(read("src/pokemon.c"), "GetSilvallyTypeByHeldItemEffect"))
                   .replace("@GET_TYPE@", function(read(OVERLAY), "Battler_GetType")))
        run_c(program)

    def test_the_battle_form_follows_the_memory_not_the_plate(self):
        source = read(OVERLAY)
        at = source.index("species == SPECIES_SILVALLY && ctx->battleMons[ctx->battlerIdTemp].hp")
        block = source[at:source.index("\n        }\n", at)]
        self.assertIn("form = GetSilvallyTypeByHeldItemEffect(", block)
        self.assertNotIn("GetArceusTypeByHeldItemEffect", block)

    def test_the_memory_types_silvally_outside_battle(self):
        source = read("src/pokemon.c")
        self.assertIn("blockA->species == SPECIES_SILVALLY && blockA->abilityMSB == 0 && blockA->ability == ABILITY_RKS_SYSTEM",
                      source)
        at = source.index("blockA->species == SPECIES_SILVALLY && blockA->abilityMSB == 0")
        self.assertIn("ret = GetSilvallyTypeByHeldItemEffect(", source[at:at + 300])
        form = function(source, "BoxMon_UpdateArceusForm")
        self.assertIn("species == SPECIES_SILVALLY && ability == ABILITY_RKS_SYSTEM", form)
        self.assertIn("form = GetSilvallyTypeByHeldItemEffect(", form)

    def test_multi_attack_takes_the_same_type(self):
        body = function(read(OVERLAY), "GetDynamicMoveType")
        self.assertIn("type = GetSilvallyTypeByHeldItemEffect(GetBattlerHeldItemEffect(ctx, battlerId));", body)


HELD_FORM_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/items.h"
#include "constants/species.h"
typedef uint16_t u16;
@FUNCTION@
int main(void) {
    static const u16 cases[][3] = {
        { SPECIES_GENESECT, ITEM_DOUSE_DRIVE, SPECIES_GENESECT_DOUSE_DRIVE },
        { SPECIES_GENESECT, ITEM_SHOCK_DRIVE, SPECIES_GENESECT_SHOCK_DRIVE },
        { SPECIES_GENESECT, ITEM_BURN_DRIVE, SPECIES_GENESECT_BURN_DRIVE },
        { SPECIES_GENESECT, ITEM_CHILL_DRIVE, SPECIES_GENESECT_CHILL_DRIVE },
        { SPECIES_GENESECT_BURN_DRIVE, ITEM_CHILL_DRIVE, SPECIES_GENESECT_CHILL_DRIVE },
        { SPECIES_GENESECT_BURN_DRIVE, ITEM_NONE, SPECIES_GENESECT },
        { SPECIES_GENESECT_DOUSE_DRIVE, ITEM_LEFTOVERS, SPECIES_GENESECT },
        { SPECIES_OGERPON, ITEM_WELLSPRING_MASK, SPECIES_OGERPON_WELLSPRING_MASK },
        { SPECIES_OGERPON, ITEM_HEARTHFLAME_MASK, SPECIES_OGERPON_HEARTHFLAME_MASK },
        { SPECIES_OGERPON, ITEM_CORNERSTONE_MASK, SPECIES_OGERPON_CORNERSTONE_MASK },
        { SPECIES_OGERPON_CORNERSTONE_MASK, ITEM_TEAL_MASK, SPECIES_OGERPON },
        { SPECIES_OGERPON_WELLSPRING_MASK, ITEM_NONE, SPECIES_OGERPON },
        { SPECIES_DIALGA, ITEM_ADAMANT_CRYSTAL, SPECIES_DIALGA_ORIGIN },
        { SPECIES_DIALGA_ORIGIN, ITEM_NONE, SPECIES_DIALGA },
        { SPECIES_DIALGA, ITEM_LUSTROUS_GLOBE, SPECIES_DIALGA },
        { SPECIES_PALKIA, ITEM_LUSTROUS_GLOBE, SPECIES_PALKIA_ORIGIN },
        { SPECIES_PALKIA_ORIGIN, ITEM_ADAMANT_CRYSTAL, SPECIES_PALKIA },
        { SPECIES_SNORLAX, ITEM_DOUSE_DRIVE, SPECIES_SNORLAX },
        { SPECIES_ZACIAN, ITEM_RUSTED_SWORD, SPECIES_ZACIAN },          // crowned in battle, not here
        { SPECIES_OGERPON_TEAL_MASK_TERASTAL, ITEM_NONE, SPECIES_OGERPON_TEAL_MASK_TERASTAL },
    };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        assert(Species_HeldItemForm(cases[i][0], cases[i][1]) == cases[i][2]);
    }
    return 0;
}
"""


class HeldItemFormTests(unittest.TestCase):
    def test_each_item_names_its_form(self):
        run_c(HELD_FORM_FIXTURE.replace("@FUNCTION@", function(read("src/pokemon.c"), "Species_HeldItemForm")))

    def test_the_form_is_put_on_as_a_species(self):
        body = function(read("src/pokemon.c"), "Mon_UpdateHeldItemForm")
        self.assertIn("Species_HeldItemForm(species, GetMonData(mon, MON_DATA_HELD_ITEM, NULL))", body)
        self.assertIn("Mon_ChangeFormSpecies(mon, form);", body)

    def test_a_pokemon_comes_into_battle_in_its_form(self):
        body = function(read("src/pokemon.c"), "Mon_ChangeToBattleForm")
        self.assertIn("Mon_UpdateHeldItemForm(mon);", body)

    def test_the_party_menu_changes_it_when_an_item_is_given_or_taken(self):
        helper = function(read("src/party_menu_sprites.c"), "PartyMenu_UpdateHeldItemForm")
        self.assertIn("if (Mon_UpdateHeldItemForm(mon) == TRUE) {", helper)
        self.assertIn("sub_0207ECE0(partyMenu, partyMenu->partyMonIndex);", helper)
        menu = read("src/party_menu.c")
        for name in ("PartyMenu_GiveItemToMon_HandleGriseousOrb", "PartyMenu_SwapMonHeldItem"):
            self.assertIn("PartyMenu_UpdateHeldItemForm(partyMenu, mon);", function(menu, name), name)
        take = function(read("src/party_menu_list_items.c"), "PartyMonContextMenuAction_Take")
        self.assertIn("PartyMenu_UpdateHeldItemForm(partyMenu, mon);", take)


if __name__ == "__main__":
    unittest.main()
