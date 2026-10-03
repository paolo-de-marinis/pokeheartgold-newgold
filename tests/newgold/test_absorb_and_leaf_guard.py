#!/usr/bin/env python3
"""Check the absorbing abilities' guards and Leaf Guard's sunshine.

Both are conditions on an ability rather than logic of their own, and both fail
quietly: a Water Absorb that heals off its own Surf and a Leaf Guard that lets
Rest through look exactly like a working battle until somebody counts the HP.
So this reads the conditions and, where the reference checkout is present,
compares them against konefr's own.

Run with HG_ENGINE_NEWGOLD_REFERENCE=PATH to point at that checkout.
"""

import re
import unittest

from test_level_cap import ROOT
from test_repels import REFERENCE, REFERENCE_COMMIT, function, revision

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"

# Every subscript that lets Leaf Guard turn a status away. Rest is the seventh:
# HGSS left it out and the reference does not.
LEAF_GUARD_SUBSCRIPTS = (
    "subscript_0018_FallAsleep.s",
    "subscript_0022_Poison.s",
    "subscript_0025_Burn.s",
    "subscript_0031_Paralyze.s",
    "subscript_0047_BadPoison.s",
    "subscript_0055_Rest.s",
    "subscript_0141_Yawn.s",
)


def ability_condition(source, ability):
    """The `if (...)` that guards one ability inside the immunity sweep."""
    body = function(source, "BattleContext_CheckMoveImmunityFromAbility")
    match = re.search(r"if \(([^\n]*\b" + ability + r"\b[^\n]*)\) \{", body)
    assert match, f"{ability} is not asked about in the immunity sweep"
    return match.group(1)


def reference_condition(source, ability):
    # The reference opens its braces on the next line, so read from the ability
    # to the assignment its conditions guard rather than parsing the function.
    start = source.index(f"{ability}) == TRUE")
    return source[start:source.index("scriptnum =", start)]


class WaterAbsorbTests(unittest.TestCase):
    def setUp(self):
        self.source = OVERLAY.read_text()

    def test_it_takes_a_status_move_aimed_at_it(self):
        # Soak too, but not the holder's own Aqua Ring (Pokemon Central,
        # Assorbacqua); konefr's power check is not copied.
        condition = ability_condition(self.source, "ABILITY_WATER_ABSORB")
        self.assertIn("battlerIdAttacker != battlerIdTarget", condition)
        self.assertNotIn("power", condition)

    def test_dry_skin_takes_a_status_move_but_not_its_own(self):
        # Soak too, but not the holder's own Rain Dance or Aqua Ring (Pokemon
        # Central, Pellearsa).
        condition = ability_condition(self.source, "ABILITY_DRY_SKIN")
        self.assertNotIn("power", condition)
        self.assertIn("battlerIdAttacker != battlerIdTarget", condition)

    def test_earth_eater_takes_a_status_move_but_not_spikes(self):
        # Sand Attack too, but not Spikes, whose target this game draws from
        # the other side (Pokemon Central, Mangiaterra).
        condition = ability_condition(self.source, "ABILITY_EARTH_EATER")
        self.assertNotIn("power", condition)
        self.assertIn("battlerIdAttacker != battlerIdTarget", condition)
        self.assertIn("BattleMoveTbl(ctx, ctx->moveNoCur)->range != RANGE_OPPONENT_SIDE", condition)

    def test_the_reference_asks_for_the_power(self):
        # What the port does not copy: the reference's Water Absorb, Dry Skin
        # and Earth Eater take only a move with power, and the last two their
        # holder's own.
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT, "src/battle/ability.c")
        water = reference_condition(source, "ABILITY_WATER_ABSORB")
        self.assertIn("attacker != defender", water)
        self.assertIn("power", water)
        for ability in ("ABILITY_DRY_SKIN", "ABILITY_EARTH_EATER"):
            condition = reference_condition(source, ability)
            self.assertIn("power", condition)
            self.assertNotIn("attacker != defender", condition)



class AbsorbFirstTests(unittest.TestCase):
    def setUp(self):
        controller = CONTROLLER.read_text()
        self.check = function(controller, "ov12_0224BC2C")
        self.absorbs = function(controller, "ScriptAbsorbsMove")

    def test_they_come_before_the_type_chart_and_the_accuracy_roll(self):
        # Showdown's gen-9 TryHit step, before type immunity and accuracy: a
        # miss, an immunity, Magnet Rise's or an Air Balloon's lift and a
        # failed one-hit KO give way; a guard or a target out of reach do not.
        # test_refusal_order runs it.
        silenced = function(CONTROLLER.read_text(), "RefusalSilencedBy")
        self.assertIn("if (ScriptAbsorbsMove(script) == TRUE) {\n        return MOVE_STATUS_DID_NOT_HIT & ~MOVE_STATUS_AFTER_TRY_HIT;", silenced)
        self.assertIn("silencedBy = RefusalSilencedBy(ctx, script);", self.check)

    def test_a_swallowed_move_leaves_the_micle_berry_s_boost(self):
        # The roll it would have had spent the boost; the move never reaches
        # it in the later games (Showdown's gen-9 micleberry, onSourceAccuracy).
        roll = function(CONTROLLER.read_text(), "BattleSystem_CheckMoveHit")
        self.assertLess(roll.index("micleSpent = FALSE;"), roll.index("return"))
        self.assertRegex(roll, r"micleBerryFlag = 0;\n\s+ctx->selfTurnData\[battlerIdAttacker\]\.micleSpent = TRUE;")
        given = re.search(r"if \(silencedBy != MOVE_STATUS_DID_NOT_HIT\) \{(.*?)\n                \}\n", self.check, re.S).group(1)
        self.assertRegex(given, r"if \(ctx->selfTurnData\[ctx->battlerIdAttacker\]\.micleSpent\) \{\n"
                                r"\s+ctx->selfTurnData\[ctx->battlerIdAttacker\]\.micleSpent = FALSE;\n"
                                r"\s+ctx->battleMons\[ctx->battlerIdAttacker\]\.unk88\.micleBerryFlag = 1;")

    def test_every_absorbing_script_of_the_sweep_is_one(self):
        sweep = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")
        scripts = set(re.findall(r"script = (BATTLE_SUBSCRIPT_(?:ABSORB_AND_\w+|ABILITY_RESTORES_HP));", sweep))
        self.assertEqual(len(scripts), 6)
        self.assertEqual(scripts, set(re.findall(r"case (BATTLE_SUBSCRIPT_\w+):", self.absorbs)))


class LightningRodTests(unittest.TestCase):
    """From the fifth generation Lightning Rod and Storm Drain swallow an
    Electric or Water move aimed at the holder, status moves too, for a stage
    of Sp. Atk (Pokemon Central, Parafulmine and Acquascolo); Gen IV's only
    drew it and let it hit."""

    def test_the_holder_swallows_the_move(self):
        body = function(OVERLAY.read_text(), "BattleContext_CheckMoveImmunityFromAbility")
        start = body.index("ABILITY_LIGHTNINGROD")
        block = body[start:body.index("}", start)]
        self.assertIn("ABILITY_LIGHTNINGROD) == TRUE && moveType == TYPE_ELECTRIC", block)
        self.assertIn("ABILITY_STORM_DRAIN) == TRUE && moveType == TYPE_WATER", block)
        self.assertIn("battlerIdAttacker != battlerIdTarget", block)
        self.assertNotIn("power", block)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE;", block)
        self.assertIn("ctx->battlerIdStatChange = battlerIdTarget;", block)
        self.assertIn("script = BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_SP_ATTACK;", block)

    def test_the_script_raises_sp_atk_or_says_the_move_was_useless(self):
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_ABSORB_AND_RAISE_SP_ATTACK\s+(\d+)", header).group(1))
        (path,) = SUBSCRIPTS.glob(f"subscript_{number:04d}_*.s")
        script = path.read_text()
        self.assertIn("BMON_DATA_STAT_CHANGE_SPATK, 12, _MAXED", script)
        self.assertIn("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", script)
        self.assertIn("msg_0197_00638", script)


class LeafGuardTests(unittest.TestCase):
    def test_every_status_asks_for_sunshine_first(self):
        for name in LEAF_GUARD_SUBSCRIPTS:
            text = (SUBSCRIPTS / name).read_text()
            checks = [i for i, line in enumerate(text.splitlines())
                      if "ABILITY_LEAF_GUARD" in line]
            self.assertTrue(checks, f"{name} never asks about Leaf Guard")
            lines = text.splitlines()
            for i in checks:
                # The sun, unless Cloud Nine or a Utility Umbrella keeps it
                # off (Pokemon Central, Superombrello).
                window = "\n".join(lines[max(0, i - 3):i])
                self.assertIn("FIELD_CONDITION_SUN_ALL", window, name)
                self.assertIn("CheckIgnoreWeather", window, name)
                self.assertIn("HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN", lines[i - 1], name)

    def test_rest_is_refused_in_the_sun(self):
        text = (SUBSCRIPTS / "subscript_0055_Rest.s").read_text()
        # It stays awake for the same reason, and by the same sentence, as it
        # does under Insomnia.
        awake = re.search(r"ABILITY_INSOMNIA, (_\w+)", text).group(1)
        self.assertRegex(text, r"ABILITY_LEAF_GUARD, " + awake)

    def test_the_reference_refuses_rest_the_same_way(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT,
                          "src/individual/BattleController_BeforeMove.c")
        start = source.index("ABILITY_LEAF_GUARD")
        block = source[start:source.index("}", source.index("MOVE_EFFECT", start))]
        self.assertIn("FIELD_CONDITION_SUN_ALL", block)
        self.assertIn("MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP", block)


if __name__ == "__main__":
    unittest.main()
