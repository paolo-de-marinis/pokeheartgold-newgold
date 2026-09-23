#!/usr/bin/env python3
"""Compare retail's effect scripts, 0 to 276, with hg-engine's.

import_moves.py matches an effect up to 276 by its number, on the premise
that both trees hold the same script there. They do not quite: at d0380a487
the engine rewrote about a hundred and twenty of them. Most of those
rewrites say the same thing in other words -- flags or'ed in another order, a
label renamed, a message given by number -- and assemble to the same bytes;
they are not differences, and the comparison below reads through them. The
rest are listed in STILL_DIFFERENT, each with what it waits on, and the list
may only shrink: a script brought over leaves it, and one that drifts from
the engine's without an entry fails.
"""

import re
import subprocess
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE, function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_moves  # noqa: E402

ENGINE = "d0380a487"
LAST_RETAIL_EFFECT = 276
EFFECT_SCRIPTS = ROOT / "files/battledata/script/effect_script"

# What the engine does elsewhere, in C, and this game still does in the script.
IN_C = "the engine moved it into C ({}); the script here still does it, to the same effect"
# A move another move calls starts its Parental Bond in C here (TryStartParentalBond,
# from GoToMoveScript) where the engine's script calls a subscript for it; the
# engine's script also sets a Psychic Terrain flag that nothing reads in either
# tree (SetPsychicTerrainMoveUsedFlag).
CALLED_MOVE = "the called move's Parental Bond, started in C here (TryStartParentalBond from GoToMoveScript)"
BACK_TO_BEFORE_MOVE = ("; the engine also sends the called move back through the before-move checks "
                       "(GoBackToBeforeMove), where here it starts at once, as in retail")

STILL_DIFFERENT = {
    7: IN_C.format("Damp and the user's fainting, BattleController_BeforeMove.c"),
    34: "Pay Day scatters its coins on the first strike or the only one; the engine's branch scatters "
         "them only on a first strike of Parental Bond, never without the ability (a6ee2c81c)",
    42: IN_C.format("the binding, ServerDoPostMoveEffects.c"),
    48: IN_C.format("the recoil and Reckless, ServerDoPostMoveEffects.c and CalcBaseDamage.c"),
    83: CALLED_MOVE + BACK_TO_BEFORE_MOVE + ", and prints the move the finger picked (message 1483), "
         "which retail's Metronome does not",
    97: CALLED_MOVE,
    105: IN_C.format("the theft, ServerDoPostMoveEffects.c"),
    115: "the primal weathers and the engine's weather subscripts",
    122: "Present asks for Parental Bond with CheckAbility, which a suppressed ability fails, where the "
          "engine reads the raw ability (BMON_DATA_ABILITY)",
    129: "the engine raises Rapid Spin's Speed here and clears the field in "
         "ServerDoPostMoveEffects.c; here both are the move's additional effect, subscript 115",
    132: "Mega Sol, which the recovery command here does not read",
    136: "the primal weathers and the engine's weather subscripts",
    137: "the primal weathers and the engine's weather subscripts",
    148: "the engine runs the landing back through its before-move sequence; here it is subscript 121's, "
         "worked out by BattleContext_LandFutureSight, and the use keeps retail's flags",
    150: "the doubling against Minimize is the damage chain's here, for every stamping move (BattleMoveStampsOnMinimize), as battle_calc_damage.c 6.9.14.1 does it",
    151: IN_C.format("the charge turn, BattleController_BeforeMove.c"),
    161: IN_C.format("Spit Up's power from the stockpile, CalcBaseDamage.c"),
    164: "the primal weathers and the engine's weather subscripts",
    171: IN_C.format("Smelling Salts' doubling and cure, CalcBaseDamage.c and ServerDoPostMoveEffects.c"),
    173: CALLED_MOVE,
    178: "Role Play asks the ability table for the user, where the engine lists the abilities (test_ability_interactions)",
    180: CALLED_MOVE + BACK_TO_BEFORE_MOVE,
    188: IN_C.format("the knocking off, ServerDoPostMoveEffects.c"),
    198: IN_C.format("the recoil and Reckless, ServerDoPostMoveEffects.c and CalcBaseDamage.c"),
    217: IN_C.format("Wake-Up Slap's doubling and cure, CalcBaseDamage.c and ServerDoPostMoveEffects.c"),
    222: IN_C.format("Natural Gift's type, power and berry, CalcBaseDamage.c"),
    224: IN_C.format("the berry eaten, ServerDoPostMoveEffects.c"),
    228: IN_C.format("the switch, ServerDoPostMoveEffects.c"),
    233: IN_C.format("the fling and the items that cannot be flung, BattleController_BeforeMove.c"),
    241: CALLED_MOVE,
    242: CALLED_MOVE + BACK_TO_BEFORE_MOVE,
    253: IN_C.format("the recoil and Reckless, ServerDoPostMoveEffects.c and CalcBaseDamage.c"),
    259: "the engine's Room Service subscript and its message wait",
    261: IN_C.format("the binding, ServerDoPostMoveEffects.c"),
    262: IN_C.format("the recoil and Reckless, ServerDoPostMoveEffects.c and CalcBaseDamage.c"),
    269: IN_C.format("the recoil and Reckless, ServerDoPostMoveEffects.c and CalcBaseDamage.c"),
    272: IN_C.format("the charge turn and the Power Herb, BattleController_BeforeMove.c"),
}


def defines():
    """Every constant the headers give a value, for reading a script's
    arguments as numbers rather than as spellings."""
    raw = {}
    for path in list((ROOT / "include/constants").rglob("*.h")) + [ROOT / "include/battle/battle.h"]:
        for name, value in re.findall(r"^\s*#define\s+([A-Z_][A-Z0-9_]*)\s+([^/\n]+)", path.read_text(errors="replace"), re.M):
            raw.setdefault(name, value.strip())
    values = {}

    def value(name, depth=0):
        if name in values:
            return values[name]
        text = raw.get(name)
        if text is None or depth > 20:
            return None
        expression = re.sub(r"\b[A-Z_][A-Z0-9_]*\b",
                            lambda m: str(value(m.group(0), depth + 1)), text)
        if not re.fullmatch(r"[0-9xXa-fA-F()<>|&~+\-* ]+", expression) or "None" in expression:
            return None
        try:
            values[name] = int(eval(expression))  # noqa: S307 -- digits and operators only
        except Exception:
            return None
        return values[name]

    return value


def normalised(text, value):
    """The script's commands, with labels numbered by where they appear,
    command names in either case, messages given by number and every argument
    that is a constant or an or of constants given as its value."""
    lines = []
    for line in text.splitlines():
        line = line.split("//")[0].strip()
        if line and not line.startswith("."):
            lines.append(re.sub(r"\s+", " ", line))
    labels = {m.group(1): f"L{i}" for i, m in
              enumerate(re.match(r"^(\w+):$", l) for l in lines if re.match(r"^(\w+):$", l))}
    out = []
    for line in lines:
        if line.endswith(":"):
            out.append(labels[line[:-1]] + ":")
            continue
        command, _, rest = line.partition(" ")
        command = command.lower()  # the engine writes Goto where this tree's macro is GoTo
        arguments = []
        for argument in (a.strip() for a in rest.split(",") if a.strip()):
            argument = labels.get(argument, argument)
            argument = re.sub(r"^msg_0197_0*(\d+)$", r"\1", argument)
            parts = [p.strip() for p in argument.split("|")]
            numbers = [int(p, 0) if re.fullmatch(r"-?(0x[0-9a-fA-F]+|\d+)", p) else value(p) for p in parts]
            if all(n is not None for n in numbers):
                total = 0
                for n in numbers:
                    total |= n
                argument = str(total)
            arguments.append(argument)
        out.append(" ".join([command] + [", ".join(arguments)]).strip())
    return out


@unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
class RetailEffectScriptTests(unittest.TestCase):
    def test_retail_effect_scripts_are_the_engine_s_or_listed(self):
        import_moves.read_macros(Path(REFERENCE))
        value = defines()
        listing = subprocess.run(["git", "-C", str(REFERENCE), "ls-tree", "--name-only", ENGINE,
                                  "data/battle_scripts/effects/"], capture_output=True, text=True, check=True)
        theirs = {int(re.search(r"effect_script_(\d+)_", path).group(1)): path
                  for path in listing.stdout.split()}
        differing = set()
        for effect in range(LAST_RETAIL_EFFECT + 1):
            ours = next(EFFECT_SCRIPTS.glob(f"effect_script_{effect:04d}*.s")).read_text()
            reference = subprocess.run(["git", "-C", str(REFERENCE), "show", f"{ENGINE}:{theirs[effect]}"],
                                       capture_output=True, text=True, errors="replace", check=True).stdout
            if normalised(ours, value) != normalised(import_moves.native(reference), value):
                differing.add(effect)
        self.assertEqual(sorted(differing - set(STILL_DIFFERENT)), [],
                         "effect scripts that differ from the engine's and are not listed")
        self.assertEqual(sorted(set(STILL_DIFFERENT) - differing), [],
                         "effect scripts that are the engine's now: take them off the list")


def constant(name):
    return int(re.search(rf"#define {name}\s+(\d+)", (ROOT / "include/constants/battle_subscript.h").read_text()).group(1))


def subscript(name):
    number = constant(f"BATTLE_SUBSCRIPT_{name}")
    return next((ROOT / "files/battledata/script/subscript").glob(f"subscript_{number:04d}*.s")).read_text()


def script(effect):
    return next(EFFECT_SCRIPTS.glob(f"effect_script_{effect:04d}*.s")).read_text()


class BroughtOverTests(unittest.TestCase):
    """What the engine's scripts do that retail's did not, checked without the
    reference: each fails on the retail script it replaced."""

    def test_the_stubs_are_stat_drops(self):
        # Retail left 21, 22, 61, 63 and 64 as a bare damage calculation, so
        # Eerie Impulse (61) lowered nothing.
        for effect, pointer in ((20, "SPEED_DOWN_2_STAGES"), (21, "SP_ATTACK_DOWN_1_STAGE"),
                                (22, "SP_DEFENSE_DOWN_1_STAGE"), (61, "SP_ATTACK_DOWN_2_STAGES"),
                                (63, "ACCURACY_DOWN_2_STAGES"), (64, "EVASION_DOWN_2_STAGES")):
            text = script(effect)
            self.assertIn(f"MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_{pointer}", text, effect)
            self.assertNotIn("CalcDamage", text, effect)

    def test_the_two_stage_drops_are_named_for_their_scripts(self):
        # pret called 62 ACC_DOWN_2, 63 EVA_DOWN_2 and 64 SP_DEF_DOWN_2, each
        # the name of another one's script.
        header = (ROOT / "include/constants/move_effects.h").read_text()
        for name, pointer in (("SP_DEF", "SP_DEFENSE"), ("ACC", "ACCURACY"), ("EVA", "EVASION")):
            effect = int(re.search(rf"#define MOVE_EFFECT_{name}_DOWN_2\s+(\d+)", header).group(1))
            self.assertIn(f"MOVE_SUBSCRIPT_PTR_{pointer}_DOWN_2_STAGES", script(effect), name)

    def test_judgment_reads_the_pixie_plate(self):
        # Retail's Judgment knew sixteen plates, so with a Pixie Plate it
        # stayed Normal.
        text = script(268)
        label = re.search(r"CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, "
                          r"HOLD_EFFECT_ARCEUS_FAIRY, (\w+)", text)
        self.assertIsNotNone(label)
        self.assertRegex(text, label.group(1) + r":\s*UpdateVar OPCODE_SET, BSCRIPT_VAR_MOVE_TYPE, TYPE_FAIRY")

    def test_curse_asks_the_third_type(self):
        # A Pokemon given Ghost as a third type (Trick-or-Treat) curses the
        # Ghost way; retail looked at the first two types only.
        self.assertIn("GoToIfThirdType BATTLER_CATEGORY_ATTACKER, TYPE_GHOST", script(109))

    def test_feint_hits_a_target_that_is_not_protecting(self):
        # From Generation V Feint deals its damage whether or not there was a
        # protection to break; retail failed.
        text = script(223)
        failure = re.search(r"TryFeint (\w+)", text).group(1)
        self.assertRegex(text, failure + r":\s*CalcCrit\s*CalcDamage\s*End")

    def test_role_play_is_not_refused_to_a_griseous_orb(self):
        # Retail failed Role Play for any user holding a Griseous Orb.
        self.assertNotIn("ITEM_GRISEOUS_ORB", script(178))

    def test_magnet_rise_is_refused_to_an_eelevate_holder(self):
        # Eelevate lifts a Pokemon the way Levitate does (BattlerIsGrounded),
        # and Magnet Rise fails for either.
        self.assertIn("CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_EELEVATE", script(252))

    def test_teleport_switches_out_in_a_trainer_battle(self):
        # From Generation VIII Teleport switches its user out when there is no
        # running away; retail failed it in a trainer battle.
        text = script(153)
        trainer = re.search(r"BATTLE_TYPE_TRAINER, (\w+)", text).group(1)
        branch = text[text.index(trainer + ":"):]
        self.assertIn("TryReplaceFaintedMon BATTLER_CATEGORY_ATTACKER, TRUE", branch)
        self.assertIn("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST", branch)

    def test_toxic_from_a_poison_type_never_misses(self):
        # Generation VI: the script lets it reach a target that is flying,
        # digging, diving or vanished, and the hit check never lets it miss.
        text = script(33)
        for flag in ("BATTLE_STATUS_HIT_DIG", "BATTLE_STATUS_HIT_FLY", "BATTLE_STATUS_SHADOW_FORCE",
                     "BATTLE_STATUS_HIT_DIVE"):
            self.assertIn(flag, text)
        body = function((ROOT / "src/battle/battle_controller_player.c").read_text(),
                        "BattleSystem_CheckMoveEffect")
        self.assertRegex(body, r"move == MOVE_TOXIC\s*&& \(ctx->battleMons\[battlerIdAttacker\]\.type1 == TYPE_POISON"
                               r"[^{]*type3 == TYPE_POISON\)\) \{\s*ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;\s*return FALSE;")
        self.assertLess(body.index("MOVE_TOXIC"), body.index("ABILITY_NO_GUARD"))

    def test_rapid_spin_raises_speed_before_it_clears(self):
        # Generation VIII: the Speed rise, then the clearing, both only while
        # the user stands; retail's subscript 115 was the clearing alone.
        text = subscript("RAPID_SPIN")
        self.assertRegex(text, r"BMON_DATA_HP, 0, (\w+)[^:]*MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE\s*"
                               r"Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE\s*"
                               r"CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_SHIELD_DUST, \1\s*RapidSpin")

    def test_rapid_spin_is_an_additional_effect(self):
        # Pokemon Central, Rapigiro: the rise (Generation VIII) and the clearing
        # (IX) are additional effects, so the side effect is the rolled kind
        # IsSuppressibleSecondaryEffect answers for Sheer Force and the cloak.
        self.assertIn("BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_RAPID_SPIN\n",
                      script(129))

    def test_growth_raises_both_attacks_and_twice_in_the_sun(self):
        # Retail's Growth (13) raised Sp. Atk alone.
        self.assertIn("MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_HANDLE_GROWTH", script(13))
        text = subscript("HANDLE_GROWTH")
        for needed in ("CheckIgnoreWeather", "FIELD_CONDITION_SUN_ALL", "HOLD_EFFECT_UNAFFECTED_BY_RAIN_OR_SUN",
                       "MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES", "MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_2_STAGES",
                       "GoToSubscript BATTLE_SUBSCRIPT_ATK_SP_ATK_UP"):
            self.assertIn(needed, text)
        table = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        table = table[table.index("static const int sMoveStatusChangeScripts[] = {"):]
        table = table[:table.index("};")]
        entries = [line.strip().rstrip(",") for line in table.splitlines()[1:] if line.strip()]
        self.assertEqual(entries[constant("MOVE_SUBSCRIPT_PTR_HANDLE_GROWTH")], "BATTLE_SUBSCRIPT_HANDLE_GROWTH")

    def test_howl_raises_the_allies_too(self):
        # The reference raises Howl's user alone; from Generation VIII the
        # allies rise with it.
        text = subscript("HOWL")
        self.assertIn("IfSameSide BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_SIDE_EFFECT_MON", text)
        self.assertIn("CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_SOUNDPROOF", text)
        self.assertEqual(text.count("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"), 2)


if __name__ == "__main__":
    unittest.main()
