#!/usr/bin/env python3
"""Check the mechanics the reference's config chooses a version of.

PROTEAN_GENERATION, BATTLE_BOND_GENERATION, CORROSIVE_GAS_IMPLIED_BEHAVIOUR,
SNOW_WARNING_GENERATION, NATURAL_GIFT_POWER_GEN, UNSEEN_FIST_GENERATION and
VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR each name a mechanic that has two
versions and pick one. The settings are read out of the reference's own
config.h where the checkout is there, so a setting changing on konefr's side
fails here rather than going unnoticed; the values are pinned where it is not.

Natural Gift is not here: its setting only picks which power each berry's
record carries, and tests/newgold/test_items.py already holds every shared
item record to the reference's. Battle Bond is not here either: at generation
nine it boosts a Greninja whose form_no is 1, and this game has one entry per
species and no forms, so there is nothing for it to read. It is carried as an
unwritten ability by tests/newgold/test_ability_effects.py.
"""

import os
import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))

SUBSCRIPTS = ROOT / "files/battledata/script/subscript"

# What the reference's config.h says today, and what this port was written
# against. GEN_LATEST is 9 and GEN_CHAMPIONS is 99.
SETTINGS = {
    "PROTEAN_GENERATION": "GEN_LATEST",
    "BATTLE_BOND_GENERATION": "GEN_LATEST",
    "SNOW_WARNING_GENERATION": "GEN_LATEST",
    "NATURAL_GIFT_POWER_GEN": "GEN_LATEST",
    "UNSEEN_FIST_GENERATION": "GEN_CHAMPIONS",
    "CORROSIVE_GAS_IMPLIED_BEHAVIOUR": "TRUE",
}


def source(path):
    return (ROOT / path).read_text()


def subscript(name):
    matches = sorted(SUBSCRIPTS.glob(f"subscript_*_{name}.s"))
    assert len(matches) == 1, f"{name}: {matches}"
    return matches[0].read_text()


needs_reference = unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")


class SettingsTests(unittest.TestCase):
    @needs_reference
    def test_the_settings_are_still_the_ones_this_was_written_against(self):
        config = (REFERENCE / "include/config.h").read_text()
        for name, value in SETTINGS.items():
            found = re.search(rf"^#define {name}\s+(\S+)", config, re.M)
            self.assertIsNotNone(found, name)
            self.assertEqual(found.group(1), value, name)

    @needs_reference
    def test_the_four_dlc_paradox_forms_are_off_the_booster_energy_list(self):
        """VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR is what takes them off:
        with it defined, EXTRA_PARADOX_FORMS is nothing."""
        self.assertIsNotNone(re.search(r"^#define VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR\s*$",
                                       (REFERENCE / "include/config.h").read_text(), re.M))


class ProteanTests(unittest.TestCase):
    def test_protean_changes_type_once_per_appearance(self):
        """Generation nine: the flag is what makes it once, and the flag is
        cleared when a Pokemon comes in rather than when a turn ends."""
        text = source("src/battle/battle_controller_player.c")
        at = text.index("ABILITY_PROTEAN")
        self.assertIn("abilityActivatedFlag == FALSE", text[at:at + 600])
        self.assertIn("abilityActivatedFlag = TRUE", text[at:at + 900])
        self.assertIn("ctx->battleMons[battlerId].abilityActivatedFlag = 0",
                      source("src/battle/overlay_12_0224E4FC.c"))


class SnowTests(unittest.TestCase):
    """Snow Warning at generation nine summons snow, so this game needed snow.

    It is hail with the damage taken out: five turns, an Ice-type's Defence
    half again as much, Ice Body still fed, Blizzard still sure of itself.
    """

    def test_snow_is_a_field_condition_rather_than_a_name_a_script_sets(self):
        battle = source("include/constants/battle.h")
        self.assertIn("#define FIELD_CONDITION_SNOW_TEMP", battle)
        self.assertIn("#define FIELD_CONDITION_SNOW_PERMANENT", battle)
        self.assertIsNone(re.search(r"^#define FIELD_CONDITION_SNOW", re.sub(r"//.*", "",
                          source("include/constants/battle_script_imports.h")), re.M))

    def test_snow_is_weather_but_not_weather_castform_answers_to(self):
        battle = source("include/constants/battle.h")
        for mask in ("FIELD_CONDITION_WEATHER ", "FIELD_CONDITION_WEATHER_NO_SUN "):
            line = re.search(rf"#define {mask}\s*\((.*)\)", battle).group(1)
            self.assertIn("FIELD_CONDITION_SNOW_ALL", line, mask)
        line = re.search(r"#define FIELD_CONDITION_WEATHER_CASTFORM\s*\((.*)\)", battle).group(1)
        self.assertNotIn("SNOW", line)

    def test_the_battle_reads_the_snow(self):
        overlay = source("src/battle/overlay_12_0224E4FC.c")
        player = source("src/battle/battle_controller_player.c")
        command = source("src/battle/battle_command.c")
        # An Ice-type's Defence, the way a sandstorm does a Rock-type's Sp. Def.
        self.assertRegex(overlay, r"FIELD_CONDITION_SNOW_ALL\)\s*&&\s*\(calcTarget\.type1 == TYPE_ICE")
        # Slush Rush, twice: the ability is asked for on both sides.
        self.assertEqual(overlay.count("ABILITY_SLUSH_RUSH && ctx->fieldCondition & (FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL)"), 2)
        # Snow Cloak and Blizzard.
        self.assertIn("(FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL) && CheckBattlerAbilityIfNotIgnored", player)
        self.assertIn("(FIELD_CONDITION_HAIL_ALL | FIELD_CONDITION_SNOW_ALL) && BattleMoveTbl(ctx, move)->effect == MOVE_EFFECT_BLIZZARD", player)
        # Ice Body feeds on it; nothing else does, because nothing falls.
        self.assertIn("FIELD_CONDITION_SNOW_ALL", command)
        self.assertIn("ABILITY_ICE_BODY", command)
        # Weather Ball is not doubled by snow, and takes no type from it.
        self.assertIn("(ctx->fieldCondition & FIELD_CONDITION_SNOW_ALL) ? 1 : 2", command)

    def test_the_five_turns_are_counted_and_end_with_a_line(self):
        player = source("src/battle/battle_controller_player.c")
        self.assertIn("UFC_STATE_SNOW", player)
        self.assertIn("BATTLE_SUBSCRIPT_SNOW_END", player)
        self.assertIn("weatherTurns", player[player.index("case UFC_STATE_SNOW:"):][:1600])
        self.assertRegex(subscript("SnowEnd"), r"FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SNOW_TEMP")

    def test_snow_warning_lays_snow_rather_than_hail(self):
        text = subscript("SnowWarning")
        self.assertIn("BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY", text)
        self.assertNotIn("FIELD_CONDITION_HAIL_PERMANENT", text)
        # And the send-out check asks about hail the way the reference does.
        overlay = source("src/battle/overlay_12_0224E4FC.c")
        at = overlay.index("case ABILITY_SNOW_WARNING:")
        self.assertIn("FIELD_CONDITION_HAIL_ALL", overlay[at:at + 500])

    def test_the_weather_that_is_laid_lasts_five_turns(self):
        self.assertIn("BSCRIPT_VAR_WEATHER_TURNS, 5", subscript("HandleSnowTemporary"))


class UnseenFistTests(unittest.TestCase):
    def test_a_contact_move_goes_through_protect_for_a_quarter(self):
        """UNSEEN_FIST_GENERATION is GEN_CHAMPIONS, so the move lands weakened
        rather than ignoring the guard outright."""
        # After the final modifier, the reference's step 10.1.
        commands = source("src/battle/battle_command.c")
        at = commands.index("ABILITY_UNSEEN_FIST || GetBattlerAbility(ctx, battlerIdAttacker) == ABILITY_PIERCING_DRILL")
        self.assertIn("damage = QMul_RoundDown(damage, UQ412__0_25);", commands[at:at + 200])
        self.assertIn("ABILITY_UNSEEN_FIST", source("src/battle/battle_controller_player.c"))

    def test_the_guard_that_did_not_hold_is_announced(self):
        overlay = source("src/battle/overlay_12_0224E4FC.c")
        self.assertIn("BATTLE_SUBSCRIPT_UNSEEN_FIST", overlay)
        at = overlay.index("*script = BATTLE_SUBSCRIPT_UNSEEN_FIST;")
        block = overlay[overlay.rindex("if (", 0, at):at]
        for term in ("ABILITY_UNSEEN_FIST", "protectFlag", "BattleMoveMakesContact"):
            self.assertIn(term, block, term)
        # The reference names Unseen Fist in the sentence, so Piercing Drill,
        # which punches through the same way, does not print it.
        self.assertNotIn("PIERCING_DRILL", block)
        self.assertIn("AbilityPopup BATTLER_CATEGORY_ATTACKER", subscript("UnseenFist"))


class BoosterEnergyTests(unittest.TestCase):
    PARADOX = {"GREAT_TUSK", "SCREAM_TAIL", "BRUTE_BONNET", "FLUTTER_MANE", "SLITHER_WING",
               "SANDY_SHOCKS", "IRON_TREADS", "IRON_BUNDLE", "IRON_HANDS", "IRON_JUGULIS",
               "IRON_MOTH", "IRON_THORNS", "ROARING_MOON", "IRON_VALIANT", "WALKING_WAKE",
               "IRON_LEAVES"}
    # The DLC four. VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR keeps them off the
    # list, so in New Gold their Booster Energy can be tricked away.
    DLC = {"GOUGING_FIRE", "RAGING_BOLT", "IRON_BOULDER", "IRON_CROWN"}

    def block(self):
        text = source("src/battle/overlay_12_0224E4FC.c")
        at = text.index("static BOOL ItemIsWeldedToTheSpecies(")
        return text[at:text.index("\n}", at)]

    def test_the_sixteen_paradox_species_keep_their_booster_energy(self):
        named = set(re.findall(r"SPECIES_(\w+)", self.block()))
        self.assertEqual(named, self.PARADOX)
        self.assertEqual(named & self.DLC, set())
        self.assertIn("ITEM_BOOSTER_ENERGY", self.block())

    def test_every_way_of_taking_an_item_asks(self):
        text = source("src/battle/overlay_12_0224E4FC.c")
        for function in ("CanStealHeldItem", "CanTrickHeldItem"):
            at = text.index(f"BOOL {function}(")
            self.assertIn("ItemIsWeldedToTheSpecies", text[at:text.index("\n}", at)], function)


class CorrosiveGasTests(unittest.TestCase):
    """CORROSIVE_GAS_IMPLIED_BEHAVIOUR is not port work.

    The setting guards which items Corrosive Gas may not melt, and the
    reference's own move record carries FLAG_UNUSABLE_UNIMPLEMENTED -- with
    DISALLOW_DEXIT_GEN undefined that flag is bit 5, the move is one of the
    ones BLOCK_LEARNING_UNIMPLEMENTED_MOVES keeps off a moveset, and its effect
    is a plain hit with no power. There is nothing there to melt an item.
    """

    @needs_reference
    def test_the_reference_ships_it_unimplemented(self):
        text = (REFERENCE / "data/Moves.c").read_text()
        at = text.index("[MOVE_CORROSIVE_GAS] = {")
        block = text[at:text.index("\n    },", at)]
        self.assertIn("FLAG_UNUSABLE_UNIMPLEMENTED", block)
        self.assertIn(".effect = MOVE_EFFECT_HIT", block)
        self.assertNotRegex((REFERENCE / "include/move_data.h").read_text(),
                            r"^#define DISALLOW_DEXIT_GEN")

    @needs_reference
    def test_this_game_carries_the_same_record(self):
        import struct
        import sys
        sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
        import import_moves  # noqa: E402

        import_moves.read_conditions(REFERENCE)
        block = import_moves.reference_records(REFERENCE)["CORROSIVE_GAS"]
        moves = {name: int(number) for name, number in re.findall(
            r"#define MOVE_([A-Z0-9_]+)\s+(\d+)\s*$",
            (ROOT / "include/constants/moves.h").read_text(), re.M)}
        types = import_moves.constants("include/constants/pokemon.h", "TYPE_")
        record = struct.unpack(import_moves.RECORD,
                               import_moves.read_table()[moves["CORROSIVE_GAS"]])
        self.assertEqual(record[2], import_moves.number(block, "power"))
        self.assertEqual(record[3], types[import_moves.field(block, "type")])
        self.assertEqual(record[4], import_moves.number(block, "accuracy"))
        self.assertEqual(record[5], import_moves.number(block, "pp"))


if __name__ == "__main__":
    unittest.main()
