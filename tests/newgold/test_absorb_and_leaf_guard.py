#!/usr/bin/env python3
"""Check Water Absorb's two guards and Leaf Guard's sunshine.

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

    def test_it_wants_a_damaging_move_aimed_at_it(self):
        condition = ability_condition(self.source, "ABILITY_WATER_ABSORB")
        self.assertIn("battlerIdAttacker != battlerIdTarget", condition)
        self.assertIn("BattleMoveTbl(ctx, ctx->moveNoCur)->power", condition)

    def test_dry_skin_keeps_only_the_power(self):
        # The asymmetry is the reference's, not an oversight to tidy up: Dry
        # Skin drinks a Water move its holder aimed at itself.
        condition = ability_condition(self.source, "ABILITY_DRY_SKIN")
        self.assertIn("BattleMoveTbl(ctx, ctx->moveNoCur)->power", condition)
        self.assertNotIn("battlerIdAttacker != battlerIdTarget", condition)

    def test_the_guards_match_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, REFERENCE_COMMIT, "src/battle/ability.c")
        water = reference_condition(source, "ABILITY_WATER_ABSORB")
        self.assertIn("attacker != defender", water)
        self.assertIn("power", water)
        dry = reference_condition(source, "ABILITY_DRY_SKIN")
        self.assertIn("power", dry)
        self.assertNotIn("attacker != defender", dry)


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
