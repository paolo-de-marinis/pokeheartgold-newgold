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
    "COMMANDER",
    "COMPETITIVE",
    "CONTRARY",
    "CORROSION",
    "COTTON_DOWN",
    "CURSED_BODY",
    "DARK_AURA",
    "DAUNTLESS_SHIELD",
    "DAZZLING",
    "DEFEATIST",
    "DEFIANT",
    "DRAGONIZE",
    "DRAGONS_MAW",
    "EARTH_EATER",
    "EELEVATE",
    "ELECTRIC_SURGE",
    "ELECTROMORPHOSIS",
    "EVAPORATE",
    "FAIRY_AURA",
    "FIRE_MANE",
    "FLARE_BOOST",
    "FLOWER_VEIL",
    "FLUFFY",
    "FRIEND_GUARD",
    "FULL_METAL_BODY",
    "FUR_COAT",
    "GALE_WINGS",
    "GALVANIZE",
    "GOOD_AS_GOLD",
    "GOOEY",
    "GORILLA_TACTICS",
    "GRASSY_SURGE",
    "GRASS_PELT",
    "GRIM_NEIGH",
    "GULP_MISSILE",
    "HADRON_ENGINE",
    "HARVEST",
    "HEALER",
    "HEAVY_METAL",
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
    "LIGHT_METAL",
    "LINGERING_AROMA",
    "LIQUID_VOICE",
    "LONG_REACH",
    "MAGICIAN",
    "MAGIC_BOUNCE",
    "MEGA_LAUNCHER",
    "MERCILESS",
    "MINDS_EYE",
    "MIRROR_ARMOR",
    "MISTY_SURGE",
    "MOODY",
    "MOXIE",
    "MULTISCALE",
    "MUMMY",
    "MYCELIUM_MIGHT",
    "NEUROFORCE",
    "NEUTRALIZING_GAS",
    "ORICHALCUM_PULSE",
    "OVERCOAT",
    "PASTEL_VEIL",
    "PERISH_BODY",
    "PICKPOCKET",
    "PIERCING_DRILL",
    "PIXILATE",
    "POISON_PUPPETEER",
    "POISON_TOUCH",
    "POWER_OF_ALCHEMY",
    "PRANKSTER",
    "PRISM_ARMOR",
    "PROPELLER_TAIL",
    "PROTEAN",
    "PROTOSYNTHESIS",
    "PSYCHIC_SURGE",
    "PUNK_ROCK",
    "PURIFYING_SALT",
    "QUARK_DRIVE",
    "QUEENLY_MAJESTY",
    "QUICK_DRAW",
    "RATTLED",
    "RECEIVER",
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
    "SEED_SOWER",
    "SHADOW_SHIELD",
    "SHARPNESS",
    "SHEER_FORCE",
    "SLUSH_RUSH",
    "SOUL_HEART",
    "SPICY_SPRAY",
    "STALWART",
    "STAMINA",
    "STEAM_ENGINE",
    "STEELWORKER",
    "STEELY_SPIRIT",
    "STRONG_JAW",
    "SUPERSWEET_SYRUP",
    "SURGE_SURFER",
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
    "UNSEEN_FIST",
    "VESSEL_OF_RUIN",
    "WANDERING_SPIRIT",
    "WATER_BUBBLE",
    "WATER_COMPACTION",
    "WEAK_ARMOR",
    "WELL_BAKED_BODY",
    "WIND_POWER",
    "WIND_RIDER",
    "WONDER_SKIN",
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
# Schooling and Power Construct were once counted done because their names
# are read here -- but only in the blocklists of Skill Swap, Role Play, Worry
# Seed, Gastro Acid and Simple Beam. The reference never reads either by name
# in C: its form changes key on SPECIES_WISHIWASHI and SPECIES_ZYGARDE
# (BattleFormChangeCheck.c), and this tree has no in-battle form change yet,
# so both do nothing here. They move out when that machinery comes in.
#
# They are listed rather than waved through because the danger is not that
# they are unfinished, it is finishing without noticing: a Pokemon whose
# ability does nothing looks right on the summary screen and loses battles
# quietly. This test fails the moment one is added and not accounted for.
PENDING = {
    "CUD_CHEW", "AROMA_VEIL", "BALL_FETCH", "BATTLE_BOND", "COSTAR", "CURIOUS_MEDICINE",
    "DANCER", "DELTA_STREAM", "DESOLATE_LAND", "DISGUISE", "EMBODY_ASPECT",
    "EMBODY_ASPECT_2", "EMBODY_ASPECT_3", "EMBODY_ASPECT_4", "EMERGENCY_EXIT",
    "GUARD_DOG", "HUNGER_SWITCH", "ICE_FACE", "ILLUSION", "MEGA_SOL", "MIMICRY",
    "OPPORTUNIST", "PARENTAL_BOND", "POWER_SPOT", "PRIMORDIAL_SEA", "SHIELDS_DOWN",
    "SCHOOLING", "POWER_CONSTRUCT",
    "STAKEOUT", "STANCE_CHANGE", "SUPREME_OVERLORD", "SYMBIOSIS", "TEMP4",
    "TERAFORM_ZERO", "TERA_SHELL", "TERA_SHIFT", "TOXIC_CHAIN", "VICTORY_STAR",
    "WIMP_OUT", "ZEN_MODE", "ZERO_TO_HERO"
}


def added():
    return {m.group(1) for m in re.finditer(r"#define ABILITY_([A-Z0-9_]+)\s+(\d+)", HEADER.read_text())
            if int(m.group(2)) > LAST_VANILLA}


def battle_source():
    """Everywhere the game can read an ability: the C, and the battle scripts.

    Some abilities are answered in a script rather than in C, and that is
    where the reference answers them too -- Corrosion in the poison
    subscripts, Soul-Heart in the one that faints a Pokemon, Mirror Armor in
    the hazards check, Good as Gold in Transform's, and five -- Commander,
    Gulp Missile, Poison Puppeteer, Power of Alchemy, Receiver -- whose every
    read in the reference is a blocklist saying they cannot be copied,
    swapped or suppressed. A script is source here as much as a .c is.

    A blocklist read is not always the whole of an ability, though: Schooling
    and Power Construct are blocklist-only by name in the reference too, and
    still do something there, because their form changes are keyed on the
    species. That is why they are pending and not counted by this."""
    paths = sorted((ROOT / "src").rglob("*.c"))
    paths += sorted((ROOT / "files/battledata").rglob("*.s"))
    return "\n".join(path.read_text(errors="replace") for path in paths)


def written_in_c():
    """Only the C.

    The two questions are not the same one. "Is it read" has to count the
    scripts, or ten finished abilities read as unfinished. "Did someone write
    an effect and forget to move the name" must not: an ability appears in a
    blocklist the moment somebody else's script imports one, and Zen Mode
    sitting in Simple Beam's list of abilities it may not overwrite says
    nothing about whether Zen Mode changes a form."""
    return "\n".join(path.read_text(errors="replace")
                     for path in sorted((ROOT / "src").rglob("*.c")))


class AbilityEffectTests(unittest.TestCase):
    def test_every_added_ability_is_accounted_for(self):
        self.assertEqual(added(), IMPLEMENTED | PENDING)
        self.assertFalse(IMPLEMENTED & PENDING)

    def test_an_implemented_ability_is_read_by_the_game(self):
        source = battle_source()
        for name in sorted(IMPLEMENTED):
            self.assertIn(f"ABILITY_{name}", source, f"ABILITY_{name} is listed as done but nothing reads it")

    def test_a_pending_ability_is_not_quietly_half_wired(self):
        source = written_in_c()
        for name in sorted(PENDING):
            self.assertNotIn(f"ABILITY_{name}", source, f"ABILITY_{name} works now; move it to IMPLEMENTED")

    # A ratchet, not a target. It was once "everything but Cud Chew is done",
    # which held while the rule was to implement only what the game reached.
    # The whole species range came in with a hundred and sixty-nine more
    # abilities, every one of them read somewhere in the reference, so the
    # number went up once and may only come down from here: lowering it is the
    # work, raising it needs a reason written next to it.
    #
    # 39 -> 41: Schooling and Power Construct had been counted done on their
    # blocklist reads alone; see the note above PENDING.
    STILL_TO_DO = 41

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
    """Several abilities go by a list of moves rather than by type, and a name
    missing from the list simply stops being blocked or boosted.

    Each list is the reference's own. They were written when the game reached
    only the moves HeartGold shipped with, and they stayed that length after
    the move range was imported -- Sharpness missed fifteen slicing moves the
    game now has, Iron Fist nine punches, Soundproof fourteen sounds. Where
    the reference checkout is present, the comparison against it is the test;
    where it is not, the length is still pinned here.
    """

    SOURCE = ROOT / "src/battle/overlay_12_0224E4FC.c"
    TABLES = ("sBallAndBombMoves", "sPunchingMoves", "sSlicingMoves",
              "sSoundMoves", "sWindMoves")
    # name here -> name in the reference, and the length both should have
    AGAINST_REFERENCE = {
        "sBallAndBombMoves": ("BallAndBombMoveList", 26),
        "sPunchingMoves": ("PunchingMoveTable", 24),
        "sSlicingMoves": ("SlicingMoveTable", 31),
        "sSoundMoves": ("SoundBasedMoveList", 33),
        "sWindMoves": ("WindMoveTable", 17),
    }

    def table(self, name):
        body = re.search(r"static (?:const )?u16 " + name + r"\[\] = \{(.*?)\};",
                         self.SOURCE.read_text(), re.S).group(1)
        return re.findall(r"MOVE_[A-Z0-9_]+", body)

    def test_each_list_is_as_long_as_the_reference_s(self):
        for table, (_, length) in self.AGAINST_REFERENCE.items():
            self.assertEqual(len(self.table(table)), length, table)

    def test_each_list_holds_what_the_reference_holds(self):
        reference = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
        if not reference.exists():
            self.skipTest("Pinned NewGold reference checkout not configured")
        defined = set(re.findall(r"#define (MOVE_[A-Z0-9_]+)\s",
                                 (ROOT / "include/constants/moves.h").read_text()))
        sources = "\n".join(p.read_text(errors="replace")
                            for p in sorted((reference / "src").rglob("*.c")))
        for table, (their_name, _) in self.AGAINST_REFERENCE.items():
            found = re.search(their_name + r"\[[^\]]*\]\s*=\s*\{(.*?)\};", sources, re.S)
            self.assertIsNotNone(found, f"{their_name} is not in the reference")
            want = {m for m in re.findall(r"MOVE_[A-Z0-9_]+", found.group(1))
                    if m in defined}
            self.assertEqual(set(self.table(table)), want, table)

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
