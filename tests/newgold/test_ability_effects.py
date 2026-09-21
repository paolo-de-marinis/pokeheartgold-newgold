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
    "ARMOR_TAIL",
    "BIG_PECKS",
    "BULLETPROOF",
    "CHEEK_POUCH",
    "COMPETITIVE",
    "CURSED_BODY",
    "EARTH_EATER",
    "EVAPORATE",
    "INFILTRATOR",
    "IRON_BARBS",
    "IRRIGATION",
    "MUMMY",
    "NEUTRALIZING_GAS",
    "POISON_TOUCH",
    "REGENERATOR",
    "RIPEN",
    "SAND_RUSH",
    "SAP_SIPPER",
    "SHARPNESS",
    "SHEER_FORCE",
    "QUICK_DRAW",
    "SUPERSWEET_SYRUP",
    "TELEPATHY",
    "UNNERVE",
    "WEAK_ARMOR",
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

    "AERILATE", "ANALYTIC", "ANGER_SHELL", "AROMA_VEIL", "AS_ONE_GLASTRIER",
    "AS_ONE_SPECTRIER", "AURA_BREAK", "BALL_FETCH", "BATTERY",
    "BATTLE_BOND", "BEADS_OF_RUIN", "BEAST_BOOST", "BERSERK",
    "CHILLING_NEIGH", "COMATOSE", "COMMANDER", "CONTRARY", "CORROSION",
    "COSTAR", "COTTON_DOWN", "CURIOUS_MEDICINE", "DANCER", "DARK_AURA",
    "DAUNTLESS_SHIELD", "DAZZLING", "DEFEATIST", "DEFIANT", "DELTA_STREAM",
    "DESOLATE_LAND", "DISGUISE", "DRAGONIZE", "DRAGONS_MAW", "EELEVATE",
    "ELECTRIC_SURGE", "ELECTROMORPHOSIS", "EMBODY_ASPECT",
    "EMBODY_ASPECT_2", "EMBODY_ASPECT_3", "EMBODY_ASPECT_4",
    "EMERGENCY_EXIT", "FAIRY_AURA", "FIRE_MANE", "FLARE_BOOST",
    "FLOWER_VEIL", "FLUFFY", "FRIEND_GUARD", "FULL_METAL_BODY", "FUR_COAT",
    "GALE_WINGS", "GALVANIZE", "GOOD_AS_GOLD", "GOOEY", "GORILLA_TACTICS",
    "GRASSY_SURGE", "GRASS_PELT", "GRIM_NEIGH", "GUARD_DOG", "GULP_MISSILE",
    "HADRON_ENGINE", "HARVEST", "HEALER", "HEAVY_METAL", "HOSPITALITY",
    "HUNGER_SWITCH", "ICE_FACE", "ICE_SCALES", "ILLUSION", "IMPOSTER",
    "INNARDS_OUT", "INTREPID_SWORD", "JUSTIFIED", "LIBERO", "LIGHT_METAL",
    "LINGERING_AROMA", "LIQUID_VOICE", "LONG_REACH", "MAGICIAN",
    "MAGIC_BOUNCE", "MEGA_LAUNCHER", "MEGA_SOL", "MERCILESS", "MIMICRY",
    "MINDS_EYE", "MIRROR_ARMOR", "MISTY_SURGE", "MOODY", "MOXIE",
    "MULTISCALE", "MYCELIUM_MIGHT", "NEUROFORCE", "OPPORTUNIST",
    "ORICHALCUM_PULSE", "OVERCOAT", "PARENTAL_BOND", "PASTEL_VEIL",
    "PERISH_BODY", "PICKPOCKET", "PIERCING_DRILL", "PIXILATE",
    "POISON_PUPPETEER", "POWER_CONSTRUCT", "POWER_OF_ALCHEMY", "POWER_SPOT",
    "PRANKSTER", "PRIMORDIAL_SEA", "PRISM_ARMOR", "PROPELLER_TAIL",
    "PROTEAN", "PROTOSYNTHESIS", "PSYCHIC_SURGE", "PUNK_ROCK",
    "PURIFYING_SALT", "QUARK_DRIVE", "QUEENLY_MAJESTY", "RATTLED",
    "RECEIVER", "REFRIGERATE", "RKS_SYSTEM", "ROCKY_PAYLOAD", "SAND_FORCE",
    "SAND_SPIT", "SCHOOLING", "SCREEN_CLEANER", "SEED_SOWER",
    "SHADOW_SHIELD", "SHIELDS_DOWN", "SLUSH_RUSH", "SOUL_HEART",
    "SPICY_SPRAY", "STAKEOUT", "STALWART", "STAMINA", "STANCE_CHANGE",
    "STEAM_ENGINE", "STEELWORKER", "STEELY_SPIRIT", "STRONG_JAW",
    "SUPREME_OVERLORD", "SURGE_SURFER", "SWEET_VEIL", "SWORD_OF_RUIN",
    "SYMBIOSIS", "TABLETS_OF_RUIN", "TANGLING_HAIR", "TEMP4",
    "TERAFORM_ZERO", "TERAVOLT", "TERA_SHELL", "TERA_SHIFT",
    "THERMAL_EXCHANGE", "TOUGH_CLAWS", "TOXIC_BOOST", "TOXIC_CHAIN",
    "TOXIC_DEBRIS", "TRANSISTOR", "TRIAGE", "TURBOBLAZE", "UNSEEN_FIST",
    "VESSEL_OF_RUIN", "VICTORY_STAR", "WANDERING_SPIRIT", "WATER_BUBBLE",
    "WATER_COMPACTION", "WELL_BAKED_BODY", "WIMP_OUT", "WIND_POWER",
    "WONDER_SKIN", "ZEN_MODE", "ZERO_TO_HERO"
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
    STILL_TO_DO = 170

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
        self.assertEqual(source.count("IsSuppressibleSecondaryEffect(ctx,"), 2)
        self.assertEqual(source.count("static BOOL IsSuppressibleSecondaryEffect"), 1)

    def test_the_guaranteed_effects_are_left_alone(self):
        body = re.search(r"static BOOL IsSuppressibleSecondaryEffect.*?\n\}", self.SOURCE.read_text(), re.S).group(0)
        for flag in ("MOVE_SIDE_EFFECT_ON_HIT", "MOVE_SIDE_EFFECT_CHECK_SUBSTITUTE",
                     "MOVE_SIDE_EFFECT_CHECK_HP_AND_SUBSTITUTE", "MOVE_SIDE_EFFECT_CHECK_HP"):
            self.assertIn(flag, body)
        self.assertIn("effectChance != 0", body)
