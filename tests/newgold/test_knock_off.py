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
import re
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
        self.assertIn("} else if (KnockOffCanRemoveItem(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget)\n", body)

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

    def test_sticky_hold_keeps_nothing_for_a_fallen_holder(self):
        # Pokemon Central, Antifurto: from the fifth generation a holder the
        # move felled loses its item to Thief, Covet, Knock Off, Pluck and Bug
        # Bite all the same.
        commands = read("src/battle/battle_command.c")
        for name in ("BtlCmd_TryStealItem", "BtlCmd_TryKnockOff", "BtlCmd_TryPluck"):
            self.assertIn("ctx->battleMons[ctx->battlerIdTarget].item && ctx->battleMons[ctx->battlerIdTarget].hp && "
                          "CheckBattlerAbilityIfNotIgnored(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ABILITY_STICKY_HOLD)",
                          function(commands, name), name)

    def test_a_knocked_off_item_is_taken_off(self):
        # Pokemon Central (Privazione): from the fifth generation Knock Off
        # takes the item off, and the Pokemon can be given or take another --
        # Thief, Covet, Trick, a Sticky Barb -- where retail's fourth
        # generation only made it useless, kept it in the party and refused
        # every one of them. The engine no longer marks it either. One of the
        # player's own has its item back after the battle, a Berry too.
        for path in ("include/battle/battle.h", "src/battle/battle_command.c", "src/battle/overlay_12_0224E4FC.c",
                     "src/battle/battle_controller_mon_copy.c"):
            self.assertNotIn("battlerBitKnockedOffItem", read(path), path)
        knock = function(read("src/battle/battle_command.c"), "BtlCmd_TryKnockOff")
        # The mark is for the item the Pokemon started with, asked before
        # the hand is emptied (NoteHeldItemTaken asks the same).
        self.assertRegex(knock, r"\s*if \(BattleSystem_GetParty\(battleSystem, ctx->battlerIdTarget\) == BattleSystem_GetParty\(battleSystem, BATTLER_PLAYER\)\n"
                                r"\s*&& ctx->battleMons\[ctx->battlerIdTarget\]\.item == ctx->itemsToRestore\[ctx->selectedMonIndex\[ctx->battlerIdTarget\]\]\) \{\n"
                                r"\s*ctx->heldItemsTaken \|= MaskOfFlagNo\(ctx->selectedMonIndex\[ctx->battlerIdTarget\]\);\n\s*\}\n"
                                r"\s*ctx->battleMons\[ctx->battlerIdTarget\]\.item = 0;\n")
        # The party copy writes the empty hand, at once, so a Pokemon sent
        # back in has nothing, and a wild one caught nothing either.
        self.assertIn("data.knockedOffItems = 0;", read("src/battle/battle_controller_mon_copy.c"))
        self.assertRegex(knock, r"ctx->battleMons\[ctx->battlerIdTarget\]\.item = 0;\n(\s*//.*\n)*"
                                r"\s*CopyBattleMonToPartyMon\(battleSystem, ctx, ctx->battlerIdTarget\);\n\s*\} else \{")

    def test_what_a_battler_loses_is_written_down(self):
        # Pokemon Central (Raggiro): from the ninth generation what was
        # handed to a wild Pokemon goes back to the bag at the battle's end,
        # knocked off or corroded too. The item is written down by battler
        # before the hand is emptied, and GiveBackHeldItems asks it of the
        # wild ones as it asks what they hold and used up.
        knock = function(read("src/battle/battle_command.c"), "BtlCmd_TryKnockOff")
        self.assertLess(knock.index("ctx->itemsLost[ctx->battlerIdTarget] = ctx->battleMons[ctx->battlerIdTarget].item;"),
                        knock.index("ctx->battleMons[ctx->battlerIdTarget].item = 0;"))
        self.assertIn("ctx->battleMons[j].item == given || ctx->recycleItem[j] == given || ctx->itemsLost[j] == given",
                      function(read("src/battle/battle_controller_player.c"), "GiveBackHeldItems"))

    def test_a_wild_pokemon_knocks_off_nothing_of_the_players(self):
        # Pokemon Central (Privazione): from the fifth generation a wild
        # Pokemon's Knock Off does not take the player's Pokemon's item. The
        # power is left as it is; Corrosive Gas's page says nothing.
        knock = function(read("src/battle/battle_command.c"), "BtlCmd_TryKnockOff")
        self.assertRegex(knock, r"\} else if \(KnockOffCanRemoveItem\(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget\)\n(\s*//.*\n)*"
                                r"\s*&& !\(ctx->moveNoCur == MOVE_KNOCK_OFF && BattleSystem_GetFieldSide\(battleSystem, ctx->battlerIdAttacker\)\n"
                                r"\s*&& !BattleSystem_GetFieldSide\(battleSystem, ctx->battlerIdTarget\)\n"
                                r"\s*&& !\(BattleSystem_GetBattleType\(battleSystem\) & \(BATTLE_TYPE_TRAINER \| BATTLE_TYPE_LINK \| BATTLE_TYPE_FRONTIER\)\)\)\) \{")

    def test_bestow_fails_as_the_games_do(self):
        # Pokemon Central (Cediregalo), and the engine's before-move checks:
        # it fails with nothing to give, onto a target that holds an item,
        # and with Mail or an item either species keeps -- which Trick's
        # command asks. Sticky Hold does not stop it. All before the item
        # moves, so a target's own is never written over.
        from test_hold_effects import subscript_named
        script = subscript_named("BATTLE_SUBSCRIPT_GIVE_HELD_ITEM")
        checks = ["CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE, _MoveFailed",
                  "CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_NONE, _MoveFailed",
                  "TrySwapItems _MoveFailed, _Give\n\n_Give:"]
        at = [script.index(check) for check in checks]
        self.assertEqual(at, sorted(at))
        self.assertLess(at[-1], script.index("UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE"))
        self.assertIn("_MoveFailed:\n    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED", script)

    def test_klutz_does_not_stop_bestow(self):
        # Klutz keeps an item from working, not from changing hands
        # (Bulbapedia's Klutz; Showdown's bestow asks nothing of it).
        from test_hold_effects import subscript_named
        self.assertNotIn("ABILITY_KLUTZ", subscript_named("BATTLE_SUBSCRIPT_GIVE_HELD_ITEM"))

    def test_fling_throws_nothing_its_species_keeps(self):
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "TryFling")
        self.assertIn("SpeciesKeepsItem(ctx->battleMons[battlerId].species, ctx->battleMons[battlerId].item)", body)
        # Nor by a Klutz holder (Pokemon Central, Lancio).
        self.assertIn("|| GetBattlerAbility(ctx, battlerId) == ABILITY_KLUTZ", body)
        # And only that: retail's script refused any Multitype holder and any
        # Griseous Orb as well (Pokemon Central, Lancio: an Arceus with a
        # Plate, a Giratina with the Griseous Orb).
        script = read("files/battledata/script/effect_script/effect_script_0233.s")
        self.assertNotIn("ABILITY_MULTITYPE", script)
        self.assertNotIn("ITEM_GRISEOUS_ORB", script)

    def test_a_gem_cannot_be_flung(self):
        # Pokemon Central (Lancio): no bijou of any kind. Their records give
        # them a fling power of 30, so the power asked answers 0 for their
        # hold effect, which the eighteen Gems and nothing else have.
        body = function(read("src/battle/overlay_12_0224E4FC.c"), "GetHeldItemFlingPower")
        self.assertRegex(body, r"== HOLD_EFFECT_POWERING_UP_MOVE_ONCE\) \{\n\s*return 0;")
        rows = [line.split(",") for line in read("files/itemtool/itemdata/item_data.csv").splitlines()]
        gems = {row[0] for row in rows if row[2] == "HOLD_EFFECT_POWERING_UP_MOVE_ONCE"}
        types = re.findall(r"#define TYPE_([A-Z]+)\s+(\w+)", read("include/constants/pokemon.h"))
        self.assertEqual(gems, {f"ITEM_{name}_GEM" for name, value in types if int(value, 0) <= 18 and name != "MYSTERY"})


if __name__ == "__main__":
    unittest.main()
