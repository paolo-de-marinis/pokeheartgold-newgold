#!/usr/bin/env python3
"""Knock Off, and the items a species keeps.

hg-engine (d0380a487, CalcBaseDamage.c) multiplies Knock Off's base power by
1.5 when CanKnockOffApply says the target's item can come off, and leaves
Sticky Hold and a substitute out of that question: they keep the item, not
the power.

What can come off is the reference's CanItemBeRemovedFromSpecies with
Pokemon Central's two more (Dialga's Adamant Crystal, Palkia's Lustrous
Globe), asked of both Pokemon: the games' rule for Thief, Trick, Knock Off,
Magician, Pickpocket and Fling, where retail refused any Multitype holder and
any Griseous Orb. The helpers are compiled here with the context they read.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function, read

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/items.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct { u16 species, item, ability; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;

static BOOL ItemIdIsMail(u16 item) { return item >= ITEM_GRASS_MAIL && item <= ITEM_BRICK_MAIL; }

@DEX@

@KEEPS@

@HANDS@

@CAN_REMOVE@

@TRICK@

static BattleContext ctx;

static void hold(int battler, u16 species, u16 item) {
    ctx.battleMons[battler].species = species;
    ctx.battleMons[battler].item = item;
}

int main(void) {
    hold(0, SPECIES_SNORLAX, ITEM_NONE);
    hold(1, SPECIES_SNORLAX, ITEM_NONE);
    assert(!KnockOffCanRemoveItem(&ctx, 0, 1));             // nothing to take
    ctx.battleMons[1].item = ITEM_LEFTOVERS;
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));
    ctx.battleMons[1].ability = ABILITY_STICKY_HOLD;        // keeps it, still hit harder
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));

    // Retail's refusals are gone: an Arceus's Leftovers come off, and so does
    // a Griseous Orb that no Giratina is part of.
    hold(1, SPECIES_ARCEUS, ITEM_LEFTOVERS);
    ctx.battleMons[1].ability = ABILITY_MULTITYPE;
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));
    hold(1, SPECIES_SNORLAX, ITEM_GRISEOUS_ORB);
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));

    // Each species keeps its own, and it is asked of the user as well.
    static const u16 kept[][2] = {
        { SPECIES_ARCEUS, ITEM_FLAME_PLATE }, { SPECIES_ARCEUS, ITEM_IRON_PLATE }, { SPECIES_ARCEUS, ITEM_PIXIE_PLATE },
        { SPECIES_ARCEUS, ITEM_BLANK_PLATE }, { SPECIES_GIRATINA, ITEM_GRISEOUS_ORB }, { SPECIES_GIRATINA, ITEM_GRISEOUS_CORE },
        { SPECIES_DIALGA, ITEM_ADAMANT_CRYSTAL }, { SPECIES_DIALGA_ORIGIN, ITEM_ADAMANT_CRYSTAL },
        { SPECIES_PALKIA, ITEM_LUSTROUS_GLOBE }, { SPECIES_PALKIA_ORIGIN, ITEM_LUSTROUS_GLOBE },
        { SPECIES_KYOGRE, ITEM_BLUE_ORB }, { SPECIES_GROUDON, ITEM_RED_ORB },
        { SPECIES_GENESECT, ITEM_DOUSE_DRIVE }, { SPECIES_GENESECT_CHILL_DRIVE, ITEM_CHILL_DRIVE },
        { SPECIES_SILVALLY, ITEM_FIGHTING_MEMORY }, { SPECIES_SILVALLY, ITEM_FAIRY_MEMORY },
        { SPECIES_ZACIAN, ITEM_RUSTED_SWORD }, { SPECIES_ZACIAN_CROWNED, ITEM_RUSTED_SWORD },
        { SPECIES_ZAMAZENTA, ITEM_RUSTED_SHIELD }, { SPECIES_OGERPON, ITEM_CORNERSTONE_MASK },
        { SPECIES_OGERPON_WELLSPRING_MASK, ITEM_WELLSPRING_MASK }, { SPECIES_OGERPON, ITEM_HEARTHFLAME_MASK },
        { SPECIES_IRON_VALIANT, ITEM_BOOSTER_ENERGY }, { SPECIES_GREAT_TUSK, ITEM_BOOSTER_ENERGY },
    };
    for (unsigned i = 0; i < sizeof(kept) / sizeof(kept[0]); i++) {
        hold(0, SPECIES_SNORLAX, ITEM_NONE);
        hold(1, kept[i][0], kept[i][1]);
        assert(!KnockOffCanRemoveItem(&ctx, 0, 1));
        assert(!CanTrickHeldItem(&ctx, 0, 1));
        hold(0, kept[i][0], ITEM_NONE);                     // the user is that species
        hold(1, SPECIES_SNORLAX, kept[i][1]);
        assert(!KnockOffCanRemoveItem(&ctx, 0, 1));
        assert(!CanTrickHeldItem(&ctx, 0, 1));
        assert(!ItemCanChangeHands(&ctx, kept[i][1], 0, 1));
    }

    // What the species does not keep goes freely.
    hold(0, SPECIES_SNORLAX, ITEM_NONE);
    hold(1, SPECIES_GENESECT, ITEM_FLAME_PLATE);
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));
    hold(1, SPECIES_OGERPON, ITEM_TEAL_MASK);
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));
    hold(1, SPECIES_GOUGING_FIRE, ITEM_BOOSTER_ENERGY);     // off the list in New Gold
    assert(KnockOffCanRemoveItem(&ctx, 0, 1));
    hold(1, SPECIES_SNORLAX, ITEM_GRASS_MAIL);              // mail stays with anyone
    assert(!KnockOffCanRemoveItem(&ctx, 0, 1));
    assert(!CanTrickHeldItem(&ctx, 0, 1));

    // Trick asks both items both ways.
    hold(0, SPECIES_SNORLAX, ITEM_LEFTOVERS);
    hold(1, SPECIES_PIKACHU, ITEM_LIGHT_BALL);
    assert(CanTrickHeldItem(&ctx, 0, 1));
    hold(1, SPECIES_ARCEUS, ITEM_NONE);
    assert(CanTrickHeldItem(&ctx, 0, 1));
    hold(0, SPECIES_SNORLAX, ITEM_SPLASH_PLATE);            // a plate cannot reach Arceus
    assert(!CanTrickHeldItem(&ctx, 0, 1));
    return 0;
}
"""


def dex_mapping():
    """sFormBaseSpecies and SpeciesToDexSpecies, from src/pokedex.c."""
    source = read("src/pokedex.c")
    table = source[source.index("static const u16 sFormBaseSpecies["):]
    table = table[:table.index("};") + 2]
    return table + "\n" + function(source, "SpeciesToDexSpecies")


class KnockOffTests(unittest.TestCase):
    def test_what_can_change_hands(self):
        overlay = read("src/battle/overlay_12_0224E4FC.c")
        source = (FIXTURE.replace("@DEX@", dex_mapping())
                  .replace("@KEEPS@", function(overlay, "SpeciesKeepsItem"))
                  .replace("@HANDS@", function(overlay, "ItemCanChangeHands"))
                  .replace("@CAN_REMOVE@", function(overlay, "KnockOffCanRemoveItem"))
                  .replace("@TRICK@", function(overlay, "CanTrickHeldItem")))
        with tempfile.TemporaryDirectory(prefix="newgold-knock-off-") as directory:
            path = Path(directory)
            (path / "check.c").write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "check.c"), "-o", str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(path / "check")], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_the_damage_maths_boosts_it(self):
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "CalcMoveDamage")
        self.assertRegex(body, r"moveNo == MOVE_KNOCK_OFF && KnockOffCanRemoveItem\(ctx, battlerIdAttacker, battlerIdTarget\)\)"
                               r"\s*\{\s*movePower = movePower \* 15 / 10;")

    def test_knock_off_takes_what_it_boosts_for(self):
        body = function(read("src/battle/battle_command.c"), "BtlCmd_TryKnockOff")
        self.assertIn("} else if (KnockOffCanRemoveItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)) {", body)

    def test_the_script_command_asks_the_same_question(self):
        body = function(read("src/battle/battle_command.c"), "BtlCmd_GotoIfCanApplyKnockOffBoost")
        self.assertIn("KnockOffCanRemoveItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)", body)

    def test_retail_refusals_left_the_scripts_and_commands(self):
        # Retail's Multitype and Griseous Orb refusals, gone from Knock Off's
        # and Trick's subscripts as the reference's are, and from Thief,
        # Magician and Pickpocket.
        for name in ("subscript_0142_KnockOfff.s", "subscript_0134_ExchangeItems.s"):
            script = read(f"files/battledata/script/subscript/{name}")
            self.assertNotIn("ABILITY_MULTITYPE", script, name)
            self.assertNotIn("ITEM_GRISEOUS_ORB", script, name)
        thief = function(read("src/battle/battle_command.c"), "BtlCmd_TryStealItem")
        self.assertNotIn("ABILITY_MULTITYPE", thief)
        self.assertNotIn("ITEM_GRISEOUS_ORB", thief)
        self.assertIn("CanStealHeldItem(battleSystem, ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)", thief)
        overlay = read("src/battle/overlay_12_0224E4FC.c")
        ability = function(overlay, "CanAbilityTakeHeldItem")
        self.assertNotIn("ABILITY_MULTITYPE", ability)
        self.assertIn("CanStealHeldItem(battleSystem, ctx, battlerIdTaker, battlerIdLoser)", ability)
        self.assertIn("ItemCanChangeHands(ctx, ctx->battleMons[battlerIdLoser].item, battlerIdTaker, battlerIdLoser)",
                      function(overlay, "CanStealHeldItem"))

    def test_fling_throws_nothing_its_species_keeps(self):
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "TryFling")
        self.assertIn("SpeciesKeepsItem(ctx->battleMons[battlerId].species, ctx->battleMons[battlerId].item)", body)


if __name__ == "__main__":
    unittest.main()
