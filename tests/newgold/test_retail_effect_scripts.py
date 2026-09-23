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

WEATHER = ("the engine sets the weather through its HANDLE_*_TEMPORARY subscripts where this script and "
           "WEATHER_START do the same; under a strong weather its script adds \"But it failed!\" after the "
           "strong weather's own line (MOVE_STATUS_FAILED), where this ends the move on the line "
           "(NO_MORE_WORK), as Snowscape (effect 324) does here")

STILL_DIFFERENT = {
    7: IN_C.format("Damp and the user's fainting, BattleController_BeforeMove.c"),
    34: "Pay Day scatters its coins on the first strike or the only one; the engine's branch scatters "
         "them only on a first strike of Parental Bond, never without the ability (a6ee2c81c)",
    83: CALLED_MOVE + BACK_TO_BEFORE_MOVE + ", and prints the move the finger picked (message 1483), "
         "which retail's Metronome does not",
    97: CALLED_MOVE,
    115: WEATHER,
    122: "Present asks for Parental Bond with CheckAbility, which a suppressed ability fails, where the "
          "engine reads the raw ability (BMON_DATA_ABILITY)",
    129: "the engine raises Rapid Spin's Speed here and clears the field in "
         "ServerDoPostMoveEffects.c; here both are the move's additional effect, subscript 115",
    132: "Mega Sol's ability popup, which the engine shows off the raw ability, so a suppressed Mega Sol "
         "would show it where BattlerMoveWeather no longer gives it the sun",
    136: WEATHER,
    137: WEATHER,
    148: "the engine runs the landing back through its before-move sequence; here it is subscript 121's, "
         "worked out by BattleContext_LandFutureSight, and the use keeps retail's flags",
    150: "the doubling against Minimize is the damage chain's here, for every stamping move (BattleMoveStampsOnMinimize), as battle_calc_damage.c 6.9.14.1 does it",
    151: IN_C.format("the charge turn, BattleController_BeforeMove.c"),
    161: "Spit Up's power from the stockpile: the engine reads it in CalcBaseDamage.c, and on Parental "
         "Bond's second strike, the stockpile spent, falls back on damage_power, which its script never "
         "sets; the script here sets the power before the stockpile goes, for both strikes",
    164: WEATHER,
    173: CALLED_MOVE,
    178: "Role Play asks the ability table for the user, where the engine lists the abilities (test_ability_interactions)",
    180: CALLED_MOVE + BACK_TO_BEFORE_MOVE,
    222: IN_C.format("Natural Gift's type, power and berry, CalcBaseDamage.c"),
    241: CALLED_MOVE,
    242: CALLED_MOVE + BACK_TO_BEFORE_MOVE,
    259: "the engine waits for a button after only buffering the line that restores the dimensions, "
         "which waits on nothing, and calls its Room Service subscript by another name (395 here)",
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
                               r"CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_SHIELD_DUST, \1\s*"
                               r"CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS, \1\s*RapidSpin")

    def test_a_covert_cloak_leaves_the_user_s_own_effects_alone(self):
        # Pokemon Central (Anonimanto): the cloak keeps its holder from the
        # additional effects of others' moves; a rise on the attacker is not
        # one. Sheer Force still gives them all up.
        body = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "ov12_02250490")
        self.assertIn("&& !(ctx->unk_2174 & MOVE_SIDE_EFFECT_TO_ATTACKER)\n                && GetBattlerHeldItemEffect(ctx, ctx->battlerIdTarget) == HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS", body)

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

    def test_reckless_is_the_damage_calculations(self):
        # The engine pays Reckless's fifth in CalcBaseDamage, not in the
        # recoil moves' scripts; the AI's damage estimate sees it too.
        body = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CalcMoveDamage")
        reckless = body[body.index("if (calcAttacker.ability == ABILITY_RECKLESS)"):]
        reckless = reckless[:reckless.index("break;")]
        for effect in ("RECOIL_QUARTER_DAMAGE_DELT", "RECOIL_THIRD", "RECOIL_BURN_HIT", "RECOIL_PARALYZE_HIT",
                       "RECOIL_HALF", "RECOIL_HALF_MAX_HP"):
            self.assertIn(f"case MOVE_EFFECT_{effect}:", reckless)
        self.assertIn("movePower = movePower * 12 / 10;", reckless)
        for effect in (48, 198, 253, 262, 269, 404):
            self.assertNotIn("ABILITY_RECKLESS", script(effect), effect)

    def test_recoil_comes_once_the_move_is_over(self):
        # The engine's Activate_RecoilDamage: a post-move step, after the
        # fainting and before the Red Card, from all the damage dealt. Not a
        # side effect, so neither Sheer Force nor a Covert Cloak, which eat
        # side effects in ov12_02250490, takes it away (Pokemon Central,
        # Contraccolpo); retail's Flare Blitz and Volt Tackle lost it to both.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        recoil = function(controller, "TryRecoil")
        for effect, script_name in (("RECOIL_QUARTER_DAMAGE_DELT", "RECOIL_1_4"), ("RECOIL_PARALYZE_HIT", "RECOIL_1_3"),
                                    ("RECOIL_HALF", "RECOIL_1_2"), ("RECOIL_HALF_MAX_HP", "RECOIL_HALF_MAX_HP")):
            case = recoil[recoil.index(f"case MOVE_EFFECT_{effect}:"):]
            self.assertIn(f"script = BATTLE_SUBSCRIPT_{script_name};", case[:case.index("break;")], effect)
        self.assertIn("ctx->selfTurnData[attacker].shellBellDamage == 0", recoil)
        self.assertIn("ability == ABILITY_ROCK_HEAD || ability == ABILITY_MAGIC_GUARD", recoil)
        self.assertNotIn("SHEER_FORCE", recoil)
        body = function(controller, "ov12_0224E1BC")
        self.assertLess(body.index("TryFaintMon"), body.index("TryRecoil(ctx)"))
        self.assertLess(body.index("TryRecoil(ctx)"), body.index("CheckSwitchItemOnHit"))
        for effect in (48, 198, 269, 404):
            self.assertNotIn("SIDE_EFFECT", script(effect), effect)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_BURN\n", script(253))
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_PARALYZE\n", script(262))

    def test_smelling_salts_and_wake_up_slap_cure_once_the_move_is_over(self):
        # The engine's post-move step cures what they doubled against; the
        # doubling is the damage calculation's (test_move_power).
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryAdditionalMoveEffect")
        self.assertIn("(ctx->moveStatusFlag & MOVE_STATUS_FAIL)", step)
        for effect, status, script_name in (("DOUBLE_POWER_AND_CURE_PARALYSIS", "STATUS_PARALYSIS", "HEAL_TARGET_PARALYSIS"),
                                            ("DOUBLE_POWER_HEAL_SLEEP", "STATUS_SLEEP", "HEAL_TARGET_SLEEP")):
            case = step[step.index(f"case MOVE_EFFECT_{effect}:"):]
            case = case[:case.index("break;")]
            self.assertIn(f"!(ctx->battleMons[target].status & {status}) || BattlerCheckSubstitute(ctx, target)", case)
            self.assertIn(f"script = BATTLE_SUBSCRIPT_{script_name};", case)
        body = function(controller, "ov12_0224E1BC")
        self.assertLess(body.index("TryRecoil(ctx)"), body.index("TryAdditionalMoveEffect(ctx)"))
        self.assertLess(body.index("TryAdditionalMoveEffect(ctx)"), body.index("CheckSwitchItemOnHit"))
        for effect in (171, 217):
            self.assertNotIn("POWER_MULTI", script(effect), effect)
            self.assertNotIn("SIDE_EFFECT", script(effect), effect)

    def test_the_binding_comes_once_the_move_is_over(self):
        # The engine's post-move step binds the target, both still standing;
        # retail's scripts bound it with the hit, as a side effect.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryAdditionalMoveEffect")
        case = step[step.index("case MOVE_EFFECT_BIND_HIT:\n    case MOVE_EFFECT_WHIRLPOOL:"):]
        case = case[:case.index("break;")]
        self.assertIn("!ctx->battleMons[ctx->battlerIdAttacker].hp || !ctx->battleMons[target].hp", case)
        self.assertIn("ctx->battlerIdStatChange = target;", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_BIND_START;", case)
        self.assertIn("CheckSubstitute BATTLER_CATEGORY_SIDE_EFFECT_MON", subscript("BIND_START"))
        for effect in (42, 261):
            self.assertNotIn("SIDE_EFFECT", script(effect), effect)

    def test_knock_off_takes_once_the_move_is_over(self):
        # The engine's post-move step, the user still standing; Pokemon
        # Central, Privazione: not once Rough Skin or Aftermath has felled the
        # user, which answer the hit before the move is over.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryAdditionalMoveEffect")
        case = step[step.index("case MOVE_EFFECT_REMOVE_HELD_ITEM:"):]
        case = case[:case.index("break;")]
        self.assertIn("!ctx->battleMons[ctx->battlerIdAttacker].hp || BattlerCheckSubstitute(ctx, target)", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_KNOCK_OFF;", case)
        self.assertNotIn("SIDE_EFFECT", script(188))
        body = function(controller, "ov12_0224E1BC")
        self.assertLess(body.index("TryAdditionalMoveEffect(ctx)"), body.index("TryPickpocket(battleSystem, ctx, &script)"))

    def test_thief_takes_once_the_move_is_over(self):
        # The engine's post-move step; Pokemon Central, Furto: not once the
        # user has fainted to Rough Skin, recoil or Aftermath, and before
        # Magician and a Pickpocket that lifts the item back.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryAdditionalMoveEffect")
        case = step[step.index("case MOVE_EFFECT_STEAL_HELD_ITEM:"):]
        case = case[:case.index("break;")]
        self.assertIn("!ctx->battleMons[ctx->battlerIdAttacker].hp || BattlerCheckSubstitute(ctx, target)", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_STEAL_ITEM;", case)
        self.assertNotIn("SIDE_EFFECT", script(105))
        body = function(controller, "ov12_0224E1BC")
        self.assertLess(body.index("TryAdditionalMoveEffect(ctx)"), body.index("TryMagician(battleSystem, ctx, &script)"))

    def test_pluck_eats_once_the_move_is_over(self):
        # The engine's post-move step; Pokemon Central, Coleomorso: Rough Skin
        # and Aftermath come first, and a user they fell eats nothing.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryAdditionalMoveEffect")
        case = step[step.index("case MOVE_EFFECT_EAT_BERRY:"):]
        case = case[:case.index("break;")]
        self.assertIn("if (!ctx->battleMons[ctx->battlerIdAttacker].hp) {", case)
        self.assertIn("script = BATTLE_SUBSCRIPT_PLUCK;", case)
        self.assertNotIn("SIDE_EFFECT", script(224))

    def test_u_turn_switches_once_the_move_is_over(self):
        # The engine's Activate_Switch: the last step here, after Emergency
        # Exit and Wimp Out, for a user still standing that has not left and
        # a target that has not left either.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        step = function(controller, "TryPivotSwitch")
        for needed in ("!= MOVE_EFFECT_SWITCH_HIT", "(ctx->moveStatusFlag & MOVE_STATUS_FAIL)",
                       "!ctx->battleMons[ctx->battlerIdAttacker].hp || (ctx->battleStatus2 & BATTLE_STATUS2_UTURN)",
                       "Battler_CameInAfterTheHit(ctx, target)",
                       "RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_ATTACK_THEN_SWITCH_OUT);"):
            self.assertIn(needed, step)
        body = function(controller, "ov12_0224E1BC")
        pivot = body.index("TryPivotSwitch(ctx)")
        for before in ("TryMagician(battleSystem, ctx, &script)", "CheckSwitchItemOnHit", "HOLD_EFFECT_HP_DRAIN_ON_ATK",
                       "TryPickpocket(battleSystem, ctx, &script)", "TryRetreatAbility(battleSystem, ctx, &script)"):
            self.assertLess(body.index(before), pivot, before)
        self.assertNotIn("SIDE_EFFECT", script(228))
        # What the hit sets off is the hit's own business now, not the switch's.
        text = subscript("ATTACK_THEN_SWITCH_OUT")
        for gone in ("TriggerAbilityOnHit", "TriggerHeldItemOnPivotMove", "STATUS2_DESTINY_BOND", "TryGrudge"):
            self.assertNotIn(gone, text)
        self.assertIn("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST", text)

    def test_howl_raises_the_allies_too(self):
        # The reference raises Howl's user alone; from Generation VIII the
        # allies rise with it.
        text = subscript("HOWL")
        self.assertIn("IfSameSide BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_SIDE_EFFECT_MON", text)
        self.assertIn("CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_SOUNDPROOF", text)
        self.assertEqual(text.count("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"), 2)


if __name__ == "__main__":
    unittest.main()
