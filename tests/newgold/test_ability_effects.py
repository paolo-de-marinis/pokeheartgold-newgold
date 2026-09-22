#!/usr/bin/env python3
"""Check that the added abilities do something.

An ability that exists only as a number and a name looks right on the summary
screen and then does nothing in battle, which is the kind of thing nobody
notices until they wonder why a Pokemon keeps fainting. Each one is listed here
as either done or still to do, and a done one has to be read somewhere the
battle actually runs.
"""

import re
import unittest
from pathlib import Path

from test_level_cap import ROOT

HEADER = ROOT / "include/constants/abilities.h"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"
LAST_VANILLA = 123

IMPLEMENTED = {
    "AERILATE",
    "ANALYTIC",
    "ANGER_SHELL",
    "ARMOR_TAIL",
    "AS_ONE_GLASTRIER",
    "AS_ONE_SPECTRIER",
    "AURA_BREAK",
    "BATTERY",
    "BEADS_OF_RUIN",
    "BEAST_BOOST",
    "BERSERK",
    "BIG_PECKS",
    "BULLETPROOF",
    "CHEEK_POUCH",
    "CHILLING_NEIGH",
    "COMATOSE",
    "COMPETITIVE",
    "COTTON_DOWN",
    "CURSED_BODY",
    "DARK_AURA",
    "DAUNTLESS_SHIELD",
    "DAZZLING",
    "DEFEATIST",
    "DRAGONIZE",
    "DRAGONS_MAW",
    "EARTH_EATER",
    "EELEVATE",
    "ELECTROMORPHOSIS",
    "EVAPORATE",
    "FAIRY_AURA",
    "FIRE_MANE",
    "FLARE_BOOST",
    "FLUFFY",
    "FRIEND_GUARD",
    "FUR_COAT",
    "GALE_WINGS",
    "GALVANIZE",
    "GOOEY",
    "GORILLA_TACTICS",
    "GRIM_NEIGH",
    "HARVEST",
    "HEALER",
    "HOSPITALITY",
    "ICE_SCALES",
    "IMPOSTER",
    "INFILTRATOR",
    "INNARDS_OUT",
    "INTREPID_SWORD",
    "IRON_BARBS",
    "IRRIGATION",
    "JUSTIFIED",
    "LIBERO",
    "LINGERING_AROMA",
    "LIQUID_VOICE",
    "LONG_REACH",
    "MAGICIAN",
    "MAGIC_BOUNCE",
    "MEGA_LAUNCHER",
    "MERCILESS",
    "MOODY",
    "MOXIE",
    "MULTISCALE",
    "MUMMY",
    "MYCELIUM_MIGHT",
    "NEUROFORCE",
    "NEUTRALIZING_GAS",
    "ORICHALCUM_PULSE",
    "PASTEL_VEIL",
    "PERISH_BODY",
    "PICKPOCKET",
    "PIXILATE",
    "POISON_TOUCH",
    "PRANKSTER",
    "PRISM_ARMOR",
    "PROPELLER_TAIL",
    "PROTEAN",
    "PUNK_ROCK",
    "PURIFYING_SALT",
    "QUEENLY_MAJESTY",
    "QUICK_DRAW",
    "RATTLED",
    "REFRIGERATE",
    "REGENERATOR",
    "RIPEN",
    "RKS_SYSTEM",
    "ROCKY_PAYLOAD",
    "SAND_FORCE",
    "SAND_RUSH",
    "SAND_SPIT",
    "SAP_SIPPER",
    "SCREEN_CLEANER",
    "SHADOW_SHIELD",
    "SHARPNESS",
    "SHEER_FORCE",
    "SLUSH_RUSH",
    "SPICY_SPRAY",
    "STALWART",
    "STAMINA",
    "STEAM_ENGINE",
    "STEELWORKER",
    "STEELY_SPIRIT",
    "STRONG_JAW",
    "SUPERSWEET_SYRUP",
    "SWEET_VEIL",
    "SWORD_OF_RUIN",
    "TABLETS_OF_RUIN",
    "TANGLING_HAIR",
    "TELEPATHY",
    "TERAVOLT",
    "THERMAL_EXCHANGE",
    "TOUGH_CLAWS",
    "TOXIC_BOOST",
    "TOXIC_DEBRIS",
    "TRANSISTOR",
    "TRIAGE",
    "TURBOBLAZE",
    "UNNERVE",
    "VESSEL_OF_RUIN",
    "WANDERING_SPIRIT",
    "WATER_BUBBLE",
    "WATER_COMPACTION",
    "WEAK_ARMOR",
    "WELL_BAKED_BODY",
    "WIND_RIDER",
}

# Cud Chew is a name in New Gold too: the reference declares it and nothing
# reads it, so a Farigiraf there does not bring its berry back up either.
# Giving it an effect here would be a change to the game, not a port of it.
#
# The rest are the abilities that came in with the whole species range. Every
# one of them is read somewhere in the reference -- none is a name there --
# so every one is real work, and this list is the ledger of it. An ability
# moves out of here and into IMPLEMENTED when the battle actually reads it.
#
# They are listed rather than waved through because the danger is not that
# they are unfinished, it is finishing without noticing: a Pokemon whose
# ability does nothing looks right on the summary screen and loses battles
# quietly. This test fails the moment one is added and not accounted for.
PENDING = {
    "CUD_CHEW",
    "AROMA_VEIL", "BALL_FETCH", "BATTLE_BOND", "COMMANDER",
    "CONTRARY", "CORROSION", "COSTAR", "CURIOUS_MEDICINE", "DANCER", "DEFIANT",
    "DELTA_STREAM", "DESOLATE_LAND", "DISGUISE", "ELECTRIC_SURGE",
    "EMBODY_ASPECT", "EMBODY_ASPECT_2", "EMBODY_ASPECT_3", "EMBODY_ASPECT_4",
    "EMERGENCY_EXIT", "FLOWER_VEIL",
    "FULL_METAL_BODY", "GOOD_AS_GOLD",
    "GRASSY_SURGE", "GRASS_PELT", "GUARD_DOG", "GULP_MISSILE", "HADRON_ENGINE",
    "HEAVY_METAL", "HUNGER_SWITCH", "ICE_FACE",
    "ILLUSION", "LIGHT_METAL",
    "MEGA_SOL", "MIMICRY",
    "MINDS_EYE", "MIRROR_ARMOR", "MISTY_SURGE",
    "OPPORTUNIST", "OVERCOAT", "PARENTAL_BOND", "PIERCING_DRILL", "POISON_PUPPETEER",
    "POWER_CONSTRUCT", "POWER_OF_ALCHEMY", "POWER_SPOT",
    "PRIMORDIAL_SEA",
    "PROTOSYNTHESIS", "PSYCHIC_SURGE", "QUARK_DRIVE", "RECEIVER", "SCHOOLING", "SEED_SOWER",
    "SHIELDS_DOWN", "SOUL_HEART", "STAKEOUT",
    "STANCE_CHANGE", "SUPREME_OVERLORD", "SURGE_SURFER", "SYMBIOSIS", "TEMP4",
    "TERAFORM_ZERO", "TERA_SHELL", "TERA_SHIFT", "TOXIC_CHAIN",
    "UNSEEN_FIST", "VICTORY_STAR", "WIMP_OUT",
    "WIND_POWER", "WONDER_SKIN", "ZEN_MODE", "ZERO_TO_HERO"
}


def added():
    return {m.group(1) for m in re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)", HEADER.read_text())
            if int(m.group(2)) > LAST_VANILLA}


def battle_source():
    return "\n".join(path.read_text() for path in sorted((ROOT / "src").rglob("*.c")))


class AbilityEffectTests(unittest.TestCase):
    def test_every_added_ability_is_accounted_for(self):
        self.assertEqual(added(), IMPLEMENTED | PENDING)
        self.assertFalse(IMPLEMENTED & PENDING)

    def test_an_implemented_ability_is_read_by_the_game(self):
        source = battle_source()
        for name in sorted(IMPLEMENTED):
            self.assertIn(f"ABILITY_{name}", source, f"ABILITY_{name} is listed as done but nothing reads it")

    def test_a_pending_ability_is_not_quietly_half_wired(self):
        source = battle_source()
        for name in sorted(PENDING):
            self.assertNotIn(f"ABILITY_{name}", source, f"ABILITY_{name} works now; move it to IMPLEMENTED")

    # A ratchet, not a target. It was once "everything but Cud Chew is done",
    # which held while the rule was to implement only what the game reached.
    # The whole species range came in with a hundred and sixty-nine more
    # abilities, every one of them read somewhere in the reference, so the
    # number went up once and may only come down from here: lowering it is the
    # work, raising it needs a reason written next to it.
    STILL_TO_DO = 72

    def test_the_pending_list_only_ever_shrinks(self):
        self.assertLessEqual(
            len(PENDING), self.STILL_TO_DO,
            f"{len(PENDING)} abilities are pending and the ledger allows "
            f"{self.STILL_TO_DO}; an added ability needs its effect, or a "
            f"reason here for why it has none")
        self.assertIn("CUD_CHEW", PENDING)


class SubscriptNumberingTests(unittest.TestCase):
    """A subscript is fetched by index into the archive, which is the files in
    name order, so a gap or a stale number runs some other script entirely."""

    def setUp(self):
        self.files = sorted(SUBSCRIPTS.glob("subscript_*.s"))
        self.defines = {m.group(1): int(m.group(2)) for m in
                        re.finditer(r"#define BATTLE_SUBSCRIPT_([A-Z0-9_]+)\s+(\d+)\s*$",
                                    (ROOT / "include/constants/battle_subscript.h").read_text(), re.M)}

    def test_the_files_are_numbered_without_a_gap(self):
        numbers = [int(path.name.split("_")[1]) for path in self.files]
        self.assertEqual(numbers, list(range(len(self.files))))

    def test_no_define_points_past_the_last_script(self):
        self.assertEqual(max(self.defines.values()), len(self.files) - 1)

    def test_each_added_script_is_the_file_it_names(self):
        added = {
            "ABSORB_AND_RAISE_ATTACK": "subscript_0297_AbsorbAndRaiseAttack.s",
            "WEAK_ARMOR": "subscript_0298_WeakArmor.s",
            "CURSED_BODY": "subscript_0299_CursedBody.s",
            "MUMMY": "subscript_0300_Mummy.s",
            "SUPERSWEET_SYRUP": "subscript_0301_SupersweetSyrup.s",
            "CHEEK_POUCH": "subscript_0302_CheekPouch.s",
            "ABILITY_STAT_CHANGE": "subscript_0356_AbilityStatChange.s",
            "ABILITY_CUTS_STAT": "subscript_0357_AbilityCutsStat.s",
            "COTTON_DOWN": "subscript_0358_CottonDown.s",
            "ANGER_SHELL": "subscript_0359_AngerShell.s",
            "CHARGE_FROM_HIT": "subscript_0360_ChargeFromHit.s",
            "ABILITY_TAKES_ITEM": "subscript_0361_AbilityTakesItem.s",
            "TOXIC_DEBRIS": "subscript_0362_ToxicDebris.s",
            "PERISH_BODY": "subscript_0363_PerishBody.s",
            "SAND_SPIT": "subscript_0364_SandSpit.s",
            "STEAM_ENGINE": "subscript_0365_SteamEngine.s",
            "WANDERING_SPIRIT": "subscript_0366_WanderingSpirit.s",
            "UNNERVE": "subscript_0367_Unnerve.s",
            "SCREEN_CLEANER": "subscript_0368_ScreenCleaner.s",
            "HOSPITALITY": "subscript_0369_Hospitality.s",
            "IMPOSTER": "subscript_0370_Imposter.s",
        }
        for name, filename in added.items():
            self.assertEqual(self.files[self.defines[name]].name, filename)


if __name__ == "__main__":
    unittest.main()


class MoveListTests(unittest.TestCase):
    """Bulletproof and Wind Rider go by a list of moves rather than by type,
    and a name that drifts out of the list simply stops being blocked."""

    SOURCE = ROOT / "src/battle/overlay_12_0224E4FC.c"
    TABLES = ("sBallAndBombMoves", "sSlicingMoves", "sWindMoves")

    def table(self, name):
        body = re.search(r"static const u16 " + name + r"\[\] = \{(.*?)\};",
                         self.SOURCE.read_text(), re.S).group(1)
        return re.findall(r"MOVE_[A-Z0-9_]+", body)

    def test_every_move_named_exists(self):
        defined = set(re.findall(r"#define (MOVE_[A-Z0-9_]+) ",
                                 (ROOT / "include/constants/moves.h").read_text()))
        for table in self.TABLES:
            moves = self.table(table)
            self.assertTrue(moves, table)
            for move in moves:
                self.assertIn(move, defined, f"{table} names {move}")

    def test_the_lists_are_sorted_and_have_no_repeat(self):
        for table in self.TABLES:
            moves = self.table(table)
            self.assertEqual(moves, sorted(moves), table)
            self.assertEqual(len(moves), len(set(moves)), table)


class SheerForceTests(unittest.TestCase):
    """Sheer Force pays for its extra power by losing the effect, so the two
    halves have to agree on which moves that is or it gets the power free."""

    SOURCE = ROOT / "src/battle/overlay_12_0224E4FC.c"

    def test_both_halves_ask_the_same_question(self):
        source = self.SOURCE.read_text()
        self.assertEqual(source.count("IsSuppressibleSecondaryEffect(ctx,"), 5)
        self.assertEqual(source.count("static BOOL IsSuppressibleSecondaryEffect"), 1)

    def test_the_guaranteed_effects_are_left_alone(self):
        body = re.search(r"static BOOL IsSuppressibleSecondaryEffect.*?\n\}", self.SOURCE.read_text(), re.S).group(0)
        for flag in ("MOVE_SIDE_EFFECT_ON_HIT", "MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE",
                     "MOVE_SIDE_EFFECT_CHECK_HP_AND_SUBSTITUTE", "MOVE_SIDE_EFFECT_CHECK_HP"):
            self.assertIn(flag, body)
        self.assertIn("effectChance != 0", body)
