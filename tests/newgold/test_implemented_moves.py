#!/usr/bin/env python3
"""The added moves the engine leaves unimplemented, given their effect here.

hg-engine (d0380a487) flags seventy-nine moves FLAG_UNUSABLE_UNIMPLEMENTED
and gives them a bare hit; the flag keeps them out of learnsets, trainers and
battle. Paolo's rule is that nothing the reference leaves empty stays empty:
each move here is written as Pokemon Central has it, loses the flag, and is
named in import_moves.IMPLEMENTED_HERE with its effect so the importer writes
the same record on a rerun. Each test fails if its move is taken back.
"""

import re
import struct
import sys
import unittest

from test_level_cap import ROOT, function

sys.path[:0] = [str(ROOT / "tools/newgold/import")]
import import_moves  # noqa: E402

SCRIPTS = ROOT / "files/battledata/script"


def defines(path, prefix):
    return {name: int(value) for name, value in re.findall(
        r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\d+)\b", (ROOT / path).read_text())}


MOVES = defines("include/constants/moves.h", "MOVE_")
EFFECTS = defines("include/constants/move_effects.h", "MOVE_EFFECT_")


def record(move):
    return struct.unpack(import_moves.RECORD, import_moves.read_table()[MOVES[f"MOVE_{move}"]])


def side_effect_subscript(pointer):
    """The subscript sMoveStatusChangeScripts gives a MOVE_SUBSCRIPT_PTR_."""
    overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
    body = re.search(r"sMoveStatusChangeScripts\[\] = \{(.*?)\};", overlay, re.S).group(1)
    entries = re.findall(r"BATTLE_SUBSCRIPT_\w+", re.sub(r"//[^\n]*", "", body))
    return entries[defines("include/constants/battle_subscript.h", "MOVE_SUBSCRIPT_PTR_")[pointer]]


def effect_script(effect):
    return (SCRIPTS / f"effect_script/effect_script_{EFFECTS[effect]:04d}.s").read_text()


class ImplementedMoveTests(unittest.TestCase):
    def assertImplemented(self, move, effect):
        fields = record(move)
        self.assertEqual(fields[0], EFFECTS[effect], move)
        self.assertFalse(fields[9] & 1 << 5, f"{move} still carries the unimplemented flag")
        self.assertEqual(import_moves.IMPLEMENTED_HERE.get(move), effect, move)

    def test_tera_blast_is_a_plain_hit_without_terastallization(self):
        # Pokemon Central (Terascoppio): it changes type and split only when
        # the user is terastallized, which no Pokemon here can be.
        self.assertImplemented("TERA_BLAST", "MOVE_EFFECT_HIT")


    def test_confide_lowers_sp_atk_through_protect(self):
        # Pokemon Central (Confidenza): one stage, past Protect -- its record
        # has no protect bit -- and past a substitute, as a sound move.
        self.assertImplemented("CONFIDE", "MOVE_EFFECT_SP_ATK_DOWN")
        self.assertIn("MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_1_STAGE", effect_script("MOVE_EFFECT_SP_ATK_DOWN"))
        self.assertFalse(record("CONFIDE")[9] & 1 << 1)

    def test_aromatic_mist_raises_the_ally_s_sp_def(self):
        # Pokemon Central (Nebularoma): the ally's Sp. Def, a stage; with no
        # ally standing it fails, as Coaching does.
        self.assertImplemented("AROMATIC_MIST", "MOVE_EFFECT_RAISE_ALLY_SP_DEF")
        script = effect_script("MOVE_EFFECT_RAISE_ALLY_SP_DEF")
        self.assertIn("BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER", script)
        self.assertIn("BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER", script)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SP_DEFENSE_UP_1_STAGE", script)

    def test_an_effect_written_here_survives_a_rerun(self):
        # The importer rewrites move_effects.h from the base header and the
        # reference's block; the effects written here sit after that block
        # and must come through both.
        here = import_moves.effects_written_here()
        self.assertIn("MOVE_EFFECT_RAISE_ALLY_SP_DEF", here)
        self.assertEqual(min(here.values()), 409)
        kept = import_moves.original("include/constants/move_effects.h")
        self.assertIn("#define MOVE_EFFECT_RAISE_ALLY_SP_DEF", kept)
        self.assertNotIn("MOVE_EFFECT_HIT_THREE_TIMES_FLAT", kept)

    def test_hard_press_is_worth_the_share_of_hp_left(self):
        # Pokemon Central (Pressa d'Acciaio): 100 times the target's HP over
        # its maximum, 1 at the least; Wring Out's effect, asked for the move.
        self.assertImplemented("HARD_PRESS", "MOVE_EFFECT_INCREASE_POWER_WITH_MORE_HP")
        self.assertEqual(record("HARD_PRESS")[2], 1)
        body = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_CalcWringOutPower")
        hard = body[body.index("MOVE_HARD_PRESS"):body.index("return FALSE;")]
        self.assertIn("(100 * ctx->battleMons[ctx->battlerIdTarget].hp) / ctx->battleMons[ctx->battlerIdTarget].maxHp", hard)
        self.assertIn("if (ctx->movePower == 0) {\n            ctx->movePower = 1;", hard)

    def test_upper_hand_answers_only_a_priority_attack(self):
        # Pokemon Central (Colpo di Mano): it fails unless the target chose an
        # attack going at +1 to +3 and has not moved; it always flinches.
        self.assertImplemented("UPPER_HAND", "MOVE_EFFECT_UPPER_HAND")
        self.assertEqual(record("UPPER_HAND")[6], 100)
        script = effect_script("MOVE_EFFECT_UPPER_HAND")
        self.assertLess(script.index("TrySuckerPunch _FAILED"), script.index("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FLINCH"))
        body = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TrySuckerPunch")
        self.assertIn("ctx->moveNoCur == MOVE_UPPER_HAND", body)
        self.assertIn("BattlerMovePriority(ctx, ctx->battlerIdTarget, move) < 1 || BattlerMovePriority(ctx, ctx->battlerIdTarget, move) > 3", body)

    def test_burning_jealousy_burns_only_a_target_whose_stats_rose(self):
        # Pokemon Central (Fiamminvidia): the burn is only for a target whose
        # stats rose this turn; the rest it only hurts.
        self.assertImplemented("BURNING_JEALOUSY", "MOVE_EFFECT_BURN_HIT")
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        meets = function(overlay, "SecondaryEffectMeetsItsTarget")
        self.assertIn("ctx->moveNoCur == MOVE_BURNING_JEALOUSY", meets)
        self.assertIn("return ctx->turnData[ctx->battlerIdTarget].statRaised;", meets)
        self.assertIn("} else if (ctx->unk_2174 && !SecondaryEffectMeetsItsTarget(ctx)) {\n        ctx->unk_2174 = 0;",
                      function(overlay, "ov12_02250490"))
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        self.assertIn("ctx->turnData[ctx->battlerIdStatChange].statRaised = TRUE;",
                      function(commands, "BtlCmd_ChangeStatStage"))
        # Every rise of the turn, not only the stat command's: a stage a
        # script writes (Belly Drum, Anger Point, Steam Engine), Rage's, and
        # Spectral Thief's, which the page names. The Mirror Herb's is
        # test_hold_effects' MirrorHerbTests.
        update = function(commands, "BtlCmd_UpdateMonData")
        told = update[update.index("RecordMirrorHerbStages(battleSystem, ctx, battlerId, stage - BMON_DATA_STAT_CHANGE_HP, var - before);"):]
        self.assertIn("ctx->turnData[battlerId].statRaised = TRUE;", told[:told.index("}")])
        rage = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "TryBuildRage")
        self.assertIn("ctx->turnData[ctx->battlerIdTarget].statRaised = TRUE;", rage)
        flag = function(commands, "BtlCmd_SetMoveConditionFlag")
        thief = flag[flag.index("case MOVE_SPECTRAL_THIEF:"):]
        self.assertIn("ctx->turnData[ctx->battlerIdAttacker].statRaised = TRUE;", thief[:thief.index("break;")])
        # A rise before the first turn -- an entry ability as the battle
        # begins -- counts for the first, so the mark goes with TurnData at a
        # turn's end and not where the next is chosen.
        self.assertNotIn("statRaised", function((ROOT / "src/battle/battle_controller_player.c").read_text(),
                                                "BattleControllerPlayer_SelectionScreenInit"))

    def test_alluring_voice_confuses_only_a_target_whose_stats_rose(self):
        # Pokemon Central (Ammaliavoce): Burning Jealousy's condition, with
        # confusion; sure once it holds.
        self.assertImplemented("ALLURING_VOICE", "MOVE_EFFECT_CONFUSE_HIT")
        self.assertEqual(record("ALLURING_VOICE")[6], 100)
        meets = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "SecondaryEffectMeetsItsTarget")
        self.assertIn("ctx->moveNoCur == MOVE_ALLURING_VOICE", meets)

    def test_echoed_voice_grows_with_each_turn_in_a_row(self):
        # Pokemon Central (Echeggiavoce): 40 times the turns in a row someone
        # used it, 200 at most; a turn nobody did ends the run.
        self.assertImplemented("ECHOED_VOICE", "MOVE_EFFECT_HIT")
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("ctx->echoedVoiceUsed = TRUE;", function(controller, "NoteMoveUsed"))
        self.assertIn("NoteMoveUsed(battleSystem, ctx);\n    if (ctx->moveStatusFlag & MOVE_STATUS_FAIL) {",
                      function(controller, "ov12_0224C38C"))
        self.assertIn("if (!ctx->echoedVoiceUsed) {\n        ctx->echoedVoiceTurns = 0;\n"
                      "    } else if (ctx->echoedVoiceTurns < 4) {\n        ctx->echoedVoiceTurns++;\n    }\n"
                      "    ctx->echoedVoiceUsed = FALSE;",
                      function(controller, "BattleControllerPlayer_TurnEnd"))
        # The power itself is test_move_power's EchoedVoiceTests.

    def test_round_calls_the_others_that_chose_it(self):
        # Pokemon Central (Coro): whoever else chose Round and has yet to move
        # goes next; the power is test_move_power's RoundTests.
        self.assertImplemented("ROUND", "MOVE_EFFECT_HIT")
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        noted = function(controller, "NoteMoveUsed")
        self.assertIn("ctx->roundUsers |= MaskOfFlagNo(ctx->battlerIdAttacker);", noted)
        self.assertIn("ctx->battleMons[battlerId].moves[ctx->movePos[battlerId]] == MOVE_ROUND) {\n"
                      "                ctx->turnData[battlerId].forceExecutionOrder = EXECUTION_ORDER_AFTER_YOU;", noted)
        self.assertIn("ov12_0225561C(ctx, battlerId) == FALSE", noted)
        self.assertIn("ctx->roundUsers = 0;", function(controller, "BattleControllerPlayer_TurnEnd"))

    def test_fusion_flare_and_bolt_remember_the_move_before(self):
        # Pokemon Central (Incrofiamma, Incrotuono): the move used just before,
        # this turn, by anyone; the power is test_move_power's FusionTests.
        # Fusion Flare thaws its user as Flame Wheel does.
        self.assertImplemented("FUSION_FLARE", "MOVE_EFFECT_HIT")
        self.assertImplemented("FUSION_BOLT", "MOVE_EFFECT_HIT")
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        noted = function(controller, "NoteMoveUsed")
        self.assertIn("ctx->moveUsedBefore = ctx->moveUsedLast;\n    ctx->moveUsedLast = ctx->moveNoCur;", noted)
        # Once a move, not once a target: the spread loop comes back with 13.
        self.assertLess(noted.index("if (ctx->unk_2184 == 13) {\n        return;"), noted.index("ctx->moveUsedBefore"))
        self.assertIn("ctx->unk_2184 = 13;", function(controller, "ov12_0224D03C"))
        self.assertIn("ctx->moveUsedLast = MOVE_NONE;\n    ctx->moveUsedBefore = MOVE_NONE;",
                      function(controller, "BattleControllerPlayer_TurnEnd"))
        checks = function(controller, "ov12_0224B528")
        self.assertIn("effect != MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT && ctx->moveNoCur != MOVE_FUSION_FLARE", checks)
        self.assertIn("effect == MOVE_EFFECT_RECOVER_HALF_DAMAGE_DEALT_BURN_HIT || ctx->moveNoCur == MOVE_FUSION_FLARE", checks)

    def test_the_rooms_go_up_and_come_down(self):
        # Pokemon Central (Mirabilzona, Magicozona): five turns, ended early by
        # the move again, each with its line; Wonder Room's swap is
        # test_move_power's WonderRoomTests.
        import import_battle_messages
        self.assertImplemented("WONDER_ROOM", "MOVE_EFFECT_WONDER_ROOM")
        self.assertImplemented("MAGIC_ROOM", "MOVE_EFFECT_MAGIC_ROOM")
        flag = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag")
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        extra = function(controller, "BattleControllerPlayer_UpdateFieldConditionExtra")
        for move, room in (("WONDER_ROOM", "wonderRoomTurns"), ("MAGIC_ROOM", "magicRoomTurns")):
            name = move.lower().replace("_", " ")
            up, down = import_battle_messages.port_row(name), import_battle_messages.port_row(name + " ends")
            script = effect_script(f"MOVE_EFFECT_{move}")
            self.assertIn(f"SetMoveConditionFlag MOVE_{move}, BATTLER_CATEGORY_ATTACKER", script)
            self.assertIn(f"BufferMessage msg_0197_{up:05d}, TAG_NONE", script)
            self.assertIn(f"BufferMessage msg_0197_{down:05d}, TAG_NONE", script)
            self.assertIn(f"ctx->{room} = ctx->{room} ? 0 : 5;\n        ctx->calcTemp = ctx->{room};", flag)
            self.assertIn(f"if (ctx->{room} && --ctx->{room} == 0) {{\n            ctx->buffMsg.id = msg_0197_{down:05d};", extra)
        self.assertIn("if (ctx->magicRoomTurns) {\n        return ITEM_NONE;",
                      function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "GetBattlerHeldItem"))

    def test_magnetic_flux_and_gear_up_raise_the_plus_and_minus_side(self):
        # Pokemon Central (Controllo Polare, Marciainpiù): the user's side, the
        # user included, only those with Plus or Minus, both stats a stage;
        # with none it fails.
        for move, effect, stats in (
                ("MAGNETIC_FLUX", "MOVE_EFFECT_PLUS_MINUS_DEF_SP_DEF_UP", ("DEFENSE", "SP_DEFENSE")),
                ("GEAR_UP", "MOVE_EFFECT_PLUS_MINUS_ATK_SP_ATK_UP", ("ATTACK", "SP_ATTACK"))):
            self.assertImplemented(move, effect)
            script = effect_script(effect)
            found, raised = script.index("_FOUND:"), script.index("_RAISE:")
            self.assertLess(script.index("MOVE_STATUS_FAILED"), found)
            for ability in ("ABILITY_PLUS", "ABILITY_MINUS"):
                self.assertEqual(script.count(f"BATTLER_CATEGORY_SIDE_EFFECT_MON, {ability},"), 2)
            self.assertEqual(script.count("IfSameSide BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_SIDE_EFFECT_MON"), 2)
            for stat in stats:
                self.assertIn(f"MOVE_SUBSCRIPT_PTR_{stat}_UP_1_STAGE", script[raised:])

    def test_flower_shield_and_rototiller_raise_the_grass_types(self):
        # Pokemon Central (Fiordifesa, Aracampo): every Grass-type on the
        # field, on the ground for Rototiller; none there, and it fails; a
        # substitute stops it short of Infiltrator, the air or the ground
        # short of No Guard.
        for move, effect, stats, grounded in (
                ("FLOWER_SHIELD", "MOVE_EFFECT_GRASS_TYPES_DEF_UP", ("DEFENSE",), False),
                ("ROTOTILLER", "MOVE_EFFECT_GROUNDED_GRASS_TYPES_ATK_SP_ATK_UP", ("ATTACK", "SP_ATTACK"), True)):
            self.assertImplemented(move, effect)
            self.assertEqual(record(move)[7], 1 << 6, "RANGE_FIELD")
            script = effect_script(effect)
            found, raised = script.index("_FOUND:"), script.index("_RAISE:")
            self.assertLess(script.index("MOVE_STATUS_FAILED"), found)
            self.assertEqual(script.count("TYPE_GRASS"), 6)
            self.assertEqual(script.count("GotoIfGrounded BATTLER_CATEGORY_SIDE_EFFECT_MON"), 2 if grounded else 0)
            self.assertNotIn("IfSameSide", script)
            self.assertIn("ABILITY_INFILTRATOR, _RAISE\n    CheckSubstitute BATTLER_CATEGORY_SIDE_EFFECT_MON, _NEXT", script)
            self.assertIn("ABILITY_NO_GUARD", script)
            self.assertEqual(script[raised:].count("MOVE_SUBSCRIPT_PTR_"), len(stats))
            for stat in stats:
                self.assertIn(f"MOVE_SUBSCRIPT_PTR_{stat}_UP_1_STAGE", script[raised:])

    def test_speed_swap_trades_the_speeds(self):
        # Pokemon Central (Velociscambio): the stats, not the stages; through
        # a substitute, not through Protect, and not sent back by Magic Coat.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("SPEED_SWAP", "MOVE_EFFECT_SPEED_SWAP")
        self.assertFalse(record("SPEED_SWAP")[9] & 1 << 2, "FLAG_MAGIC_COAT")
        self.assertTrue(record("SPEED_SWAP")[9] & 1 << 1, "FLAG_PROTECT")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_SPEED_SWAP", effect_script("MOVE_EFFECT_SPEED_SWAP"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_SPEED_SWAP"), "BATTLE_SUBSCRIPT_SPEED_SWAP")
        script = subscript_named("BATTLE_SUBSCRIPT_SPEED_SWAP")
        self.assertIn("UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_SPEED, BSCRIPT_VAR_TEMP_DATA", script)
        self.assertIn("UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_SPEED, BSCRIPT_VAR_CALC_TEMP", script)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('speed swap'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", script)

    def test_topsy_turvy_turns_the_stages_about(self):
        # Pokemon Central (Sottosopra): each stage the other way, all seven;
        # it fails with none changed.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("TOPSY_TURVY", "MOVE_EFFECT_TOPSY_TURVY")
        script = effect_script("MOVE_EFFECT_TOPSY_TURVY")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_TOPSY_TURVY", script[script.index("_CHANGED:"):])
        self.assertLess(script.index("MOVE_STATUS_FAILED"), script.index("_CHANGED:"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_TOPSY_TURVY"), "BATTLE_SUBSCRIPT_TOPSY_TURVY")
        turning = subscript_named("BATTLE_SUBSCRIPT_TOPSY_TURVY")
        for stat in ("ATK", "DEF", "SPEED", "SPATK", "SPDEF", "ACC", "EVASION"):
            self.assertIn(f"BMON_DATA_STAT_CHANGE_{stat}, 6, _CHANGED", script)
            self.assertIn(f"UpdateVar OPCODE_SET, BSCRIPT_VAR_CALC_TEMP, 12\n"
                          f"    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_{stat}, BSCRIPT_VAR_TEMP_DATA\n"
                          f"    UpdateVarFromVar OPCODE_SUB, BSCRIPT_VAR_CALC_TEMP, BSCRIPT_VAR_TEMP_DATA\n"
                          f"    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_{stat}, BSCRIPT_VAR_CALC_TEMP", turning)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('topsy-turvy'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", turning)

    def test_reflect_type_copies_the_target_s_types(self):
        # Pokemon Central (Riflettipo): all three types; Protect stops it and
        # Snatch cannot take it; not for Multitype or RKS System, nor from a
        # target with no type.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("REFLECT_TYPE", "MOVE_EFFECT_REFLECT_TYPE")
        self.assertTrue(record("REFLECT_TYPE")[9] & 1 << 1, "FLAG_PROTECT")
        self.assertFalse(record("REFLECT_TYPE")[9] & 1 << 3, "FLAG_SNATCH")
        script = effect_script("MOVE_EFFECT_REFLECT_TYPE")
        for ability in ("ABILITY_MULTITYPE", "ABILITY_RKS_SYSTEM"):
            self.assertIn(f"BATTLER_CATEGORY_ATTACKER, {ability}, _FAILED", script)
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_REFLECT_TYPE", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_REFLECT_TYPE"), "BATTLE_SUBSCRIPT_REFLECT_TYPE")
        copying = subscript_named("BATTLE_SUBSCRIPT_REFLECT_TYPE")
        for slot in ("1", "2", "3"):
            self.assertIn(f"OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_TYPE_{slot}, BSCRIPT_VAR_CALC_TEMP\n"
                          f"    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_TYPE_{slot}, BSCRIPT_VAR_CALC_TEMP", copying)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('reflect type'):05d}, TAG_NICKNAME_NICKNAME, "
                      "BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER", copying)

    def test_sunsteel_strike_and_moongeist_beam_ignore_abilities(self):
        # Pokemon Central (Astrocarica, Raggio d'Ombra): the target's ability,
        # as Mold Breaker does, when the move is used and not called.
        self.assertImplemented("SUNSTEEL_STRIKE", "MOVE_EFFECT_HIT")
        self.assertImplemented("MOONGEIST_BEAM", "MOVE_EFFECT_HIT")
        ignores = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "BattlerIgnoresAbilities")
        self.assertIn("if (battlerId == ctx->battlerIdAttacker && ctx->moveNoCur == ctx->moveNoTemp\n"
                      "        && (ctx->moveNoCur == MOVE_SUNSTEEL_STRIKE || ctx->moveNoCur == MOVE_MOONGEIST_BEAM || ctx->moveNoCur == MOVE_PHOTON_GEYSER)) {\n"
                      "        return TRUE;", ignores)

    def test_steel_beam_and_mind_blown_cost_half_the_user_s_hp(self):
        # Pokemon Central (Raggio d'Acciaio, Sbalorditesta): half the maximum
        # HP, rounded up, once the move is over, hit or miss; Magic Guard
        # alone spares it; Damp stops Mind Blown.
        from test_hold_effects import CONTROLLER
        for move in ("STEEL_BEAM", "MIND_BLOWN"):
            self.assertImplemented(move, "MOVE_EFFECT_HIT_LOSE_HALF_MAX_HP")
        script = effect_script("MOVE_EFFECT_HIT_LOSE_HALF_MAX_HP")
        self.assertIn("MOVE_MIND_BLOWN, _MARK\n    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ALL, ABILITY_DAMP, _DAMP", script)
        self.assertIn("UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_LOSE_HALF_MAX_HP", script)
        self.assertNotIn("ABILITY_ROCK_HEAD", script)
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        step = body[body.index("& SELF_TURN_FLAG_LOSE_HALF_MAX_HP"):]
        step = step[:step.index("break;")]
        self.assertIn("!= ABILITY_MAGIC_GUARD", step)
        self.assertIn("ctx->hpCalc = -(int)((ctx->battleMons[ctx->battlerIdAttacker].maxHp + 1) / 2);", step)
        self.assertIn("BATTLE_SUBSCRIPT_UPDATE_HP", step)
        # Before Emergency Exit and Wimp Out are asked.
        self.assertLess(body.index("SELF_TURN_FLAG_LOSE_HALF_MAX_HP"), body.index("TryRetreatAbility(battleSystem, ctx, &script)"))

    def test_last_respects_counts_the_party_s_fallen(self):
        # Pokemon Central (Omaggio ai KO): the power is test_move_power's
        # LastRespectsTests; the count is the user's own party's.
        self.assertImplemented("LAST_RESPECTS", "MOVE_EFFECT_HIT")
        calc = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CalcMoveDamage")
        self.assertIn("int fallen = BattlerPartyFaintCount(battleSystem, ctx, battlerIdAttacker);", calc)

    def test_rage_fist_counts_the_hits_its_user_takes(self):
        # Pokemon Central (Pugno Furibondo): every hit that lands on the user,
        # not on its substitute, six at most, kept through a switch and a
        # faint by party slot; the power is test_move_power's RageFistTests.
        self.assertImplemented("RAGE_FIST", "MOVE_EFFECT_HIT")
        hp_calc = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_HpCalc")
        counting = "u8 *hits = Battler_RageFistHits(battleSystem, ctx, ctx->battlerIdTarget);"
        self.assertIn(counting, hp_calc)
        self.assertIn("if (*hits < 6) {\n                    (*hits)++;", hp_calc)
        self.assertLess(hp_calc.index("BATTLE_SUBSCRIPT_HIT_SUBSTITUTE"), hp_calc.index(counting))
        where = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "Battler_RageFistHits")
        self.assertIn("return &ctx->rageFistHits[party][ctx->selectedMonIndex[battlerId]];", where)

    def test_tera_starstorm_is_a_single_target_hit_without_the_stellar_form(self):
        # Pokemon Central (Teracluster): Normal, special, 120, one foe; the
        # Stellar Form's version needs a terastallized Terapagos.
        self.assertImplemented("TERA_STARSTORM", "MOVE_EFFECT_HIT")
        fields = record("TERA_STARSTORM")
        self.assertEqual((fields[1], fields[2], fields[7]), (1, 120, 0), "special, 120, RANGE_SINGLE_TARGET")

    def test_jungle_healing_and_lunar_blessing_heal_the_user_s_side(self):
        # Pokemon Central (Giunglacura, Invocaluna): a quarter of the maximum
        # HP and the status, the user first and then its allies; not under
        # Heal Block or out of reach; nothing to do, and it fails.
        for move in ("JUNGLE_HEALING", "LUNAR_BLESSING"):
            self.assertImplemented(move, "MOVE_EFFECT_HEAL_SIDE_QUARTER_CURE_STATUS")
            self.assertEqual(record(move)[7], 1 << 5, "RANGE_USER_SIDE")
        script = effect_script("MOVE_EFFECT_HEAL_SIDE_QUARTER_CURE_STATUS")
        found = script.index("_FOUND:")
        self.assertLess(script.index("MOVE_STATUS_FAILED"), found)
        self.assertEqual(script.count("BMON_DATA_HEAL_BLOCK_TURNS, 0, "), 2)
        self.assertEqual(script.count("MOVE_EFFECT_FLAG_SEMI_INVULNERABLE"), 2)
        self.assertIn("UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER", script[found:])
        self.assertIn("DivideVarByValueRoundUp BSCRIPT_VAR_HP_CALC, 4\n    Call BATTLE_SUBSCRIPT_UPDATE_HP", script)
        self.assertIn("UpdateMonData OPCODE_SET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STATUS, STATUS_NONE", script)
        # The HP is asked against the maximum read into a variable, not
        # against the variable numbered like BMON_DATA_MAXHP.
        self.assertNotIn("BMON_DATA_HP, BMON_DATA_MAXHP", script)

    def test_purify_cures_the_target_and_heals_the_user(self):
        # Pokemon Central (Purificazione): the target's status, then half the
        # user's HP, rounded down; no status, a substitute or Heal Block on
        # the user, and it fails.
        from test_hold_effects import subscript_named
        self.assertImplemented("PURIFY", "MOVE_EFFECT_PURIFY")
        script = effect_script("MOVE_EFFECT_PURIFY")
        for check in ("BATTLER_CATEGORY_ATTACKER, BMON_DATA_HEAL_BLOCK_TURNS, 0, _FAILED",
                      "BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_NONE, _FAILED",
                      "CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED"):
            self.assertIn(check, script)
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PURIFY", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_PURIFY"), "BATTLE_SUBSCRIPT_PURIFY")
        purifying = subscript_named("BATTLE_SUBSCRIPT_PURIFY")
        self.assertLess(purifying.index("BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_NONE"),
                        purifying.index("DivideVarByValue BSCRIPT_VAR_HP_CALC, 2\n    Call BATTLE_SUBSCRIPT_UPDATE_HP"))

    def test_core_enforcer_suppresses_a_target_that_has_acted(self):
        # Pokemon Central (Nucleocastigo): on the hit, not as a side effect;
        # only a target that has acted this turn; through a substitute; not
        # the abilities Gastro Acid cannot touch.
        from test_hold_effects import subscript_named
        self.assertImplemented("CORE_ENFORCER", "MOVE_EFFECT_CORE_ENFORCER")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_CORE_ENFORCER", effect_script("MOVE_EFFECT_CORE_ENFORCER"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_CORE_ENFORCER"), "BATTLE_SUBSCRIPT_CORE_ENFORCER")
        enforcing = subscript_named("BATTLE_SUBSCRIPT_CORE_ENFORCER")
        gastro = subscript_named("BATTLE_SUBSCRIPT_SUPPRESS_TARGET_ABILITY")
        self.assertIn("IfMovedThisTurn BATTLER_CATEGORY_DEFENDER, _ACTED", enforcing)
        self.assertNotIn("CheckSubstitute", enforcing)
        self.assertIn("BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS, _END", enforcing)
        self.assertIn("BMON_DATA_ABILITY_FLAGS, ABILITY_FLAG_FAILS_SUPPRESS,", gastro)
        self.assertEqual(set(re.findall(r"BMON_DATA_ABILITY, (ABILITY_\w+)", enforcing)),
                         set(re.findall(r"BMON_DATA_ABILITY, (ABILITY_\w+)", gastro)))
        self.assertIn("ITEM_ABILITY_SHIELD, _END", enforcing)
        self.assertIn("UpdateMonData OPCODE_FLAG_ON, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED", enforcing)

    def test_electrify_makes_the_target_s_move_electric(self):
        # Pokemon Central (Elettrocontagio): the target's move this turn, any
        # move but Struggle; it fails on one that has moved; not sent back.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("ELECTRIFY", "MOVE_EFFECT_ELECTRIFY")
        self.assertFalse(record("ELECTRIFY")[9] & 1 << 2, "FLAG_MAGIC_COAT")
        script = effect_script("MOVE_EFFECT_ELECTRIFY")
        self.assertIn("IfMovedThisTurn BATTLER_CATEGORY_DEFENDER, _FAILED", script)
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_ELECTRIFY", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_ELECTRIFY"), "BATTLE_SUBSCRIPT_ELECTRIFY")
        charging = subscript_named("BATTLE_SUBSCRIPT_ELECTRIFY")
        self.assertIn("SetMoveConditionFlag MOVE_ELECTRIFY, BATTLER_CATEGORY_DEFENDER", charging)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('electrify'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", charging)
        self.assertIn("case MOVE_ELECTRIFY:\n        ctx->turnData[battlerId].electrified = TRUE;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag"))
        typing = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "BattleMoveTypeForAbility")
        self.assertIn("if (battlerId < BATTLER_MAX && ctx->turnData[battlerId].electrified && moveNo != MOVE_STRUGGLE) {\n"
                      "        moveType = TYPE_ELECTRIC;", typing)
        self.assertGreater(typing.index("ctx->turnData[battlerId].electrified"), typing.index("FIELD_CONDITION_ION_DELUGE"))

    def test_no_retreat_raises_every_stat_and_holds_the_user_in(self):
        # Pokemon Central (Spalle al Muro): a stage of each of the five, and
        # no leaving; it fails for a user its own No Retreat holds, not for
        # one Mean Look holds.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("NO_RETREAT", "MOVE_EFFECT_NO_RETREAT")
        self.assertEqual(record("NO_RETREAT")[9] & 0x1F, 1 << 3, "FLAG_SNATCH alone of the five")
        script = effect_script("MOVE_EFFECT_NO_RETREAT")
        self.assertIn("CompareMonDataToVar OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER, _FAILED", script)
        self.assertIn("MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_NO_RETREAT", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_NO_RETREAT"), "BATTLE_SUBSCRIPT_NO_RETREAT")
        holding = subscript_named("BATTLE_SUBSCRIPT_NO_RETREAT")
        self.assertLess(holding.index("Call BATTLE_SUBSCRIPT_BOOST_ALL_STATS"), holding.index("STATUS2_MEAN_LOOK, _END"))
        self.assertIn("UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER", holding)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('no retreat'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", holding)

    def test_octolock_holds_the_target_and_wears_it_down(self):
        # Pokemon Central (Tentacolock): held while the user stays in, a stage
        # of Defense and Sp. Def at each turn's end; not a Ghost-type, not one
        # already held; the wearing down does not go with a Baton Pass.
        from test_hold_effects import subscript_named
        self.assertImplemented("OCTOLOCK", "MOVE_EFFECT_OCTOLOCK")
        script = effect_script("MOVE_EFFECT_OCTOLOCK")
        self.assertEqual(script.count("TYPE_GHOST, _FAILED"), 3)
        self.assertIn("BMON_DATA_STATUS2, STATUS2_MEAN_LOOK, _FAILED", script)
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_OCTOLOCK", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_OCTOLOCK"), "BATTLE_SUBSCRIPT_OCTOLOCK")
        holding = subscript_named("BATTLE_SUBSCRIPT_OCTOLOCK")
        self.assertIn("UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MEAN_LOOK_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER", holding)
        self.assertIn("SetMoveConditionFlag MOVE_OCTOLOCK, BATTLER_CATEGORY_DEFENDER", holding)
        self.assertIn("case MOVE_OCTOLOCK:\n        ctx->moveConditions[battlerId].octolocked = TRUE;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag"))
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        umc = function(controller, "BattleControllerPlayer_UpdateMonCondition")
        step = umc[umc.index("case UMC_STATE_OCTOLOCK:"):umc.index("case UMC_STATE_BAD_DREAMS:")]
        self.assertIn("ctx->battlerIdAttacker = ctx->battleMons[battlerId].unk88.battlerIdMeanLook;", step)
        self.assertIn("BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_DOWN_1_STAGE", step)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        switching = function(overlay, "InitSwitchWork")
        self.assertLess(switching.index("ctx->moveConditions[i].octolocked = FALSE;"), switching.index("BATTLE_STATUS_BATON_PASS"))
        self.assertIn("ctx->moveConditions[i].octolocked = FALSE;", function(overlay, "InitFaintedWork"))

    def test_salt_cure_salts_its_target(self):
        # Pokemon Central (Sotto Sale): an added effect -- Sheer Force and a
        # substitute keep it off -- then an eighth of the HP at each turn's
        # end, a quarter for Water and Steel; Magic Guard spares it.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("SALT_CURE", "MOVE_EFFECT_SALT_CURE")
        self.assertEqual(record("SALT_CURE")[6], 100)
        script = effect_script("MOVE_EFFECT_SALT_CURE")
        self.assertIn("BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SALT_CURE", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_SALT_CURE"), "BATTLE_SUBSCRIPT_SALT_CURE")
        salting = subscript_named("BATTLE_SUBSCRIPT_SALT_CURE")
        self.assertIn("SetMoveConditionFlag MOVE_SALT_CURE, BATTLER_CATEGORY_DEFENDER", salting)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('salt cure'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", salting)
        hurting = subscript_named("BATTLE_SUBSCRIPT_SALT_CURE_DAMAGE")
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('salt cure damage'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP", hurting)
        umc = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateMonCondition")
        step = umc[umc.index("case UMC_STATE_SALT_CURE:"):umc.index("case UMC_STATE_BINDING:")]
        self.assertIn("GetBattlerAbility(ctx, battlerId) != ABILITY_MAGIC_GUARD", step)
        self.assertEqual(step.count("TYPE_WATER"), 3)
        self.assertEqual(step.count("TYPE_STEEL"), 3)
        self.assertIn("ctx->hpCalc = DamageDivide(ctx->battleMons[battlerId].maxHp * -1, divisor);", step)

    def test_syrup_bomb_takes_speed_for_three_turns(self):
        # Pokemon Central (Bomba Sciroppata): an added effect; a stage of
        # Speed at each of three turns' ends; over when the thrower leaves;
        # not twice at once.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("SYRUP_BOMB", "MOVE_EFFECT_SYRUP_BOMB")
        self.assertEqual(record("SYRUP_BOMB")[6], 100)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SYRUP_BOMB", effect_script("MOVE_EFFECT_SYRUP_BOMB"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_SYRUP_BOMB"), "BATTLE_SUBSCRIPT_SYRUP_BOMB")
        covering = subscript_named("BATTLE_SUBSCRIPT_SYRUP_BOMB")
        self.assertIn("SetMoveConditionFlag MOVE_SYRUP_BOMB, BATTLER_CATEGORY_DEFENDER", covering)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('syrup bomb'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", covering)
        flag = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag")
        self.assertIn("ctx->moveConditions[battlerId].syrupBombTurns = 3;", flag)
        umc = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateMonCondition")
        step = umc[umc.index("case UMC_STATE_SYRUP_BOMB:"):umc.index("case UMC_STATE_BAD_DREAMS:")]
        self.assertIn("ctx->moveConditions[battlerId].syrupBombTurns--;", step)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE;", step)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        for name in ("InitSwitchWork", "InitFaintedWork"):
            self.assertIn("ctx->moveConditions[i].syrupBombUser == battlerId) {\n", function(overlay, name))

    def test_tar_shot_slows_and_tars(self):
        # Pokemon Central (Colpocatrame): a stage of Speed, and Fire moves
        # twice as effective from then on, the tar once only.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("TAR_SHOT", "MOVE_EFFECT_TAR_SHOT")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_TAR_SHOT", effect_script("MOVE_EFFECT_TAR_SHOT"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_TAR_SHOT"), "BATTLE_SUBSCRIPT_TAR_SHOT")
        tarring = subscript_named("BATTLE_SUBSCRIPT_TAR_SHOT")
        self.assertLess(tarring.index("MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE"), tarring.index("SetMoveConditionFlag MOVE_TAR_SHOT, BATTLER_CATEGORY_DEFENDER"))
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('tar shot'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", tarring)
        effectiveness = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CalcTypeEffectiveness")
        self.assertIn("if (typeMul != 0 && moveType == TYPE_FIRE && ctx->moveConditions[battlerIdTarget].tarShot) {\n"
                      "            ov12_022583B4(TYPE_MUL_SUPER_EFFECTIVE, movePower, moveStatusFlag);\n"
                      "            typeMul *= 2;", effectiveness)

    def test_triple_arrows_rolls_its_two_added_effects_apart(self):
        # Pokemon Central (Triplodardo): high critical-hit ratio, 50% Defense
        # down, 30% flinch, Serene Grace doubling each.
        from test_hold_effects import subscript_named
        self.assertImplemented("TRIPLE_ARROWS", "MOVE_EFFECT_TRIPLE_ARROWS")
        self.assertEqual(record("TRIPLE_ARROWS")[6], 100)
        script = effect_script("MOVE_EFFECT_TRIPLE_ARROWS")
        self.assertIn("UpdateVar OPCODE_ADD, BSCRIPT_VAR_CRITICAL_BOOSTS, 1", script)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_TRIPLE_ARROWS", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_TRIPLE_ARROWS"), "BATTLE_SUBSCRIPT_TRIPLE_ARROWS")
        rolling = subscript_named("BATTLE_SUBSCRIPT_TRIPLE_ARROWS")
        for threshold in (49, 99, 29, 59):
            self.assertIn(f"CompareVarToValue OPCODE_GT, BSCRIPT_VAR_CALC_TEMP, {threshold},", rolling)
        self.assertEqual(rolling.count("Random 99, 0"), 2)
        self.assertLess(rolling.index("MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE"), rolling.index("Call BATTLE_SUBSCRIPT_FLINCH_MON"))

    def test_eerie_spell_takes_three_pp(self):
        # Pokemon Central (Inquietantesimo): three PP off the target's last
        # move, an added effect, not from a fainted target.
        from test_hold_effects import subscript_named
        self.assertImplemented("EERIE_SPELL", "MOVE_EFFECT_EERIE_SPELL")
        self.assertEqual(record("EERIE_SPELL")[6], 100)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_EERIE_SPELL", effect_script("MOVE_EFFECT_EERIE_SPELL"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_EERIE_SPELL"), "BATTLE_SUBSCRIPT_EERIE_SPELL")
        self.assertIn("TrySpite _END", subscript_named("BATTLE_SUBSCRIPT_EERIE_SPELL"))
        self.assertIn("ppLoss = ctx->moveNoCur == MOVE_EERIE_SPELL ? 3 : 4;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TrySpite"))

    def test_shell_side_arm_goes_in_the_way_that_hurts_more(self):
        # Pokemon Central (Armaguscio): physical when Attack against Defense
        # beats Sp. Atk against Sp. Def, stages counted; a tie at random;
        # contact when physical; the poison is Poison Sting's effect.
        from test_ability_behaviour import HEADER, run_c
        self.assertImplemented("SHELL_SIDE_ARM", "MOVE_EFFECT_POISON_HIT")
        self.assertEqual(record("SHELL_SIDE_ARM")[6], 20)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        table = re.search(r"static const u8 sStatChangeTable\[\]\[2\] = \{.*?\};", overlay, re.S).group(0)
        program = HEADER + r"""
typedef struct { int unused; } BattleSystem;
typedef struct { u16 atk, def, spAtk, spDef; u8 level; s8 statChanges[8]; } BattleMon;
typedef struct { int physicalChosen; } SelfTurnData;
typedef struct {
    int battlerIdAttacker, battlerIdTarget; u32 moveNoCur; u8 wonderRoomTurns;
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
typedef struct { int power, category; } MoveTbl;
static MoveTbl sMove = { 90, CATEGORY_SPECIAL };
static int sRandom;
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &sMove; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return sRandom; }
""" + table + "\n" + function(overlay, "BattleStatWithStage") + "\n" + function(overlay, "ChooseMoveCategory") + "\n" + function(overlay, "BattleMoveCategory") + r"""
static BattleContext ctx;
static BattleSystem bs;
static void reset(void) {
    memset(&ctx, 0, sizeof(ctx));
    ctx.battlerIdAttacker = 0; ctx.battlerIdTarget = 1; ctx.moveNoCur = MOVE_SHELL_SIDE_ARM;
    for (int i = 0; i < 2; i++) {
        ctx.battleMons[i] = (BattleMon){ 100, 100, 100, 100, 50, { 6, 6, 6, 6, 6, 6, 6, 6 } };
    }
}
#define CATEGORY() BattleMoveCategory(&ctx, MOVE_SHELL_SIDE_ARM, 0)
int main(void) {
    // A tie: at random.
    reset(); sRandom = 0; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_SPECIAL);
    reset(); sRandom = 1; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_PHYSICAL);
    // The higher Attack, or the softer Defense, makes it physical.
    reset(); ctx.battleMons[0].atk = 120; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_PHYSICAL);
    reset(); ctx.battleMons[1].spDef = 60; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_SPECIAL);
    // Stages count: +2 Sp. Atk against a Defense 50 higher.
    reset(); ctx.battleMons[0].atk = 150; ctx.battleMons[0].statChanges[STAT_SPATK] = 8; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_SPECIAL);
    // Wonder Room swaps the stages it reads, not the stats: the target's -2
    // Defense stage counts against the Sp. Def.
    reset(); ctx.battleMons[1].statChanges[STAT_DEF] = 4; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_PHYSICAL);
    ctx.wonderRoomTurns = 3; ChooseMoveCategory(&bs, &ctx); EXPECT(CATEGORY(), CATEGORY_SPECIAL);
    // Another move keeps its table's category.
    EXPECT(BattleMoveCategory(&ctx, MOVE_SLUDGE_BOMB, 0), CATEGORY_SPECIAL);
    // Photon Geyser is physical on the higher Attack, stages counted and the
    // target not asked; a tie stays special (Pokemon Central, Geyser
    // Fotonico).
#define GEYSER() BattleMoveCategory(&ctx, MOVE_PHOTON_GEYSER, 0)
    reset(); ctx.moveNoCur = MOVE_PHOTON_GEYSER; sRandom = 1; ChooseMoveCategory(&bs, &ctx); EXPECT(GEYSER(), CATEGORY_SPECIAL);
    ctx.battleMons[0].atk = 101; ChooseMoveCategory(&bs, &ctx); EXPECT(GEYSER(), CATEGORY_PHYSICAL);
    ctx.battleMons[1].def = 1000; ChooseMoveCategory(&bs, &ctx); EXPECT(GEYSER(), CATEGORY_PHYSICAL);
    ctx.battleMons[0].statChanges[STAT_SPATK] = 7; ChooseMoveCategory(&bs, &ctx); EXPECT(GEYSER(), CATEGORY_SPECIAL);
    ctx.battlerIdTarget = BATTLER_NONE; ctx.battleMons[0].statChanges[STAT_ATK] = 8; ChooseMoveCategory(&bs, &ctx); EXPECT(GEYSER(), CATEGORY_PHYSICAL);
    return 0;
}
"""
        run_c(self, program)
        self.assertIn("if (moveNo == MOVE_SHELL_SIDE_ARM) {\n        return BattleMoveCategory(ctx, moveNo, ctx->battlerIdAttacker) == CATEGORY_PHYSICAL;",
                      function(overlay, "BattleMoveMakesContact"))
        self.assertIn("ChooseMoveCategory(battleSystem, ctx);",
                      function((ROOT / "src/battle/battle_controller_player.c").read_text(), "NoteMoveUsed"))

    def test_synchronoise_hurts_only_a_pokemon_that_shares_a_type(self):
        # Pokemon Central (Sincrumore): any of the user's types against any of
        # the target's; none shared, and it has no effect.
        self.assertImplemented("SYNCHRONOISE", "MOVE_EFFECT_HIT_SHARED_TYPE")
        script = effect_script("MOVE_EFFECT_HIT_SHARED_TYPE")
        self.assertEqual(script.count("BSCRIPT_VAR_CALC_TEMP, _HIT"), 9)
        self.assertIn("BSCRIPT_VAR_CALC_TEMP, TYPE_NONE, _NO_EFFECT", script)
        self.assertLess(script.index("MOVE_STATUS_NO_EFFECT"), script.index("_HIT:"))

    def test_dragon_cheer_raises_the_ally_s_critical_ratio(self):
        # Pokemon Central (Grido del Drago): a stage, two for a Dragon-type as
        # it is when cheered; not on top of Focus Energy or another cheer; no
        # ally, and it fails.
        from test_hold_effects import subscript_named
        self.assertImplemented("DRAGON_CHEER", "MOVE_EFFECT_DRAGON_CHEER")
        self.assertFalse(record("DRAGON_CHEER")[9] & (1 << 1 | 1 << 2), "FLAG_PROTECT, FLAG_MAGIC_COAT")
        script = effect_script("MOVE_EFFECT_DRAGON_CHEER")
        self.assertIn("BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER", script)
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_DRAGON_CHEER", script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_DRAGON_CHEER"), "BATTLE_SUBSCRIPT_DRAGON_CHEER")
        self.assertIn("SetMoveConditionFlag MOVE_DRAGON_CHEER, BATTLER_CATEGORY_SIDE_EFFECT_MON",
                      subscript_named("BATTLE_SUBSCRIPT_DRAGON_CHEER"))
        flag = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag")
        cheer = flag[flag.index("case MOVE_DRAGON_CHEER:"):]
        self.assertIn("!(ctx->battleMons[battlerId].status2 & STATUS2_FOCUS_ENERGY)", cheer)
        self.assertIn("TYPE_DRAGON)\n                ? 2\n                : 1;", cheer)
        self.assertIn("+ ctx->moveConditions[battlerIdAttacker].dragonCheer +",
                      function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "TryCriticalHit"))

    def test_fairy_lock_holds_the_field_till_the_next_turn_s_end(self):
        # Pokemon Central (Blocco Fatato): all but Ghost-types, this turn and
        # the next; not twice over.
        import import_battle_messages
        self.assertImplemented("FAIRY_LOCK", "MOVE_EFFECT_FAIRY_LOCK")
        script = effect_script("MOVE_EFFECT_FAIRY_LOCK")
        self.assertIn("SetMoveConditionFlag MOVE_FAIRY_LOCK, BATTLER_CATEGORY_ATTACKER", script)
        self.assertIn(f"BufferMessage msg_0197_{import_battle_messages.port_row('fairy lock'):05d}, TAG_NONE", script)
        self.assertIn("case MOVE_FAIRY_LOCK:\n        ctx->calcTemp = !ctx->fairyLockTurns;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag"))
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        # A Ghost-type is held by nothing, this included (test_battle_mechanics' GhostTypeTests).
        for name in ("CantEscape", "BattlerCanSwitch"):
            self.assertIn("|| ctx->fairyLockTurns) {", function(overlay, name))
            self.assertIn("Battler_HasGhostType(ctx, battlerId)", function(overlay, name))
        self.assertIn("if (ctx->fairyLockTurns) {\n        ctx->fairyLockTurns--;",
                      function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_TurnEnd"))

    def test_corrosive_gas_melts_the_items_next_to_it(self):
        # Pokemon Central (Gas Corrosivo): every adjacent Pokemon's item, gone
        # for the battle as Knock Off's; Sticky Hold and a substitute keep it.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("CORROSIVE_GAS", "MOVE_EFFECT_CORROSIVE_GAS")
        self.assertEqual(record("CORROSIVE_GAS")[7], 1 << 3, "RANGE_ALL_ADJACENT")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_CORROSIVE_GAS", effect_script("MOVE_EFFECT_CORROSIVE_GAS"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_CORROSIVE_GAS"), "BATTLE_SUBSCRIPT_CORROSIVE_GAS")
        melting = subscript_named("BATTLE_SUBSCRIPT_CORROSIVE_GAS")
        self.assertLess(melting.index("CheckSubstitute BATTLER_CATEGORY_DEFENDER, _END"), melting.index("TryKnockOff _END"))
        row = import_battle_messages.port_row("corrosive gas")
        self.assertIn(f"ctx->buffMsg.id = ctx->moveNoCur == MOVE_CORROSIVE_GAS ? msg_0197_{row:05d} : msg_0197_00552;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TryKnockOff"))

    def test_chilly_reception_brings_snow_and_goes_back(self):
        # Pokemon Central (Freddura): snow, then the user switches out, snow
        # or no snow; with nobody to come in, the snow alone.
        import import_battle_messages
        self.assertImplemented("CHILLY_RECEPTION", "MOVE_EFFECT_SNOW_AND_SWITCH")
        self.assertFalse(record("CHILLY_RECEPTION")[9] & (1 << 1 | 1 << 2), "FLAG_PROTECT, FLAG_MAGIC_COAT")
        script = effect_script("MOVE_EFFECT_SNOW_AND_SWITCH")
        self.assertIn(f"PrintMessage msg_0197_{import_battle_messages.port_row('chilly reception'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", script)
        self.assertIn("FIELD_CONDITION_SNOW_TEMP, _SWITCH\n    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY", script)
        self.assertLess(script.index("HANDLE_SNOW_TEMPORARY"), script.index("TryReplaceFaintedMon BATTLER_CATEGORY_ATTACKER, TRUE, _END"))
        self.assertIn("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST", script)

    def test_doodle_gives_the_user_and_its_ally_the_target_s_ability(self):
        # Pokemon Central (Ricalco): the user, then a standing ally; the page's
        # nineteen abilities on any of the three, or Receiver on the target,
        # and it fails.
        from test_hold_effects import subscript_named
        self.assertImplemented("DOODLE", "MOVE_EFFECT_DOODLE")
        self.assertFalse(record("DOODLE")[9] & (1 << 1 | 1 << 2 | 1 << 4), "FLAG_PROTECT, FLAG_MAGIC_COAT, FLAG_MIRROR_MOVE")
        self.assertIn("CheckSubstitute BATTLER_CATEGORY_DEFENDER, _FAILED", effect_script("MOVE_EFFECT_DOODLE"))
        self.assertIn("MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SIDE_EFFECT_CHECK_HP|MOVE_SUBSCRIPT_PTR_DOODLE", effect_script("MOVE_EFFECT_DOODLE"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_DOODLE"), "BATTLE_SUBSCRIPT_DOODLE")
        doodle = subscript_named("BATTLE_SUBSCRIPT_DOODLE")
        for who in ("BATTLER_CATEGORY_DEFENDER", "BATTLER_CATEGORY_ATTACKER", "BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER"):
            self.assertEqual(doodle.count(f"CompareMonDataToValue OPCODE_EQU, {who}, BMON_DATA_ABILITY, ABILITY_"),
                             21 if who == "BATTLER_CATEGORY_DEFENDER" else 19, who)
            if who != "BATTLER_CATEGORY_DEFENDER":
                self.assertIn(f"UpdateMonDataFromVar OPCODE_SET, {who}, BMON_DATA_ABILITY, BSCRIPT_VAR_TEMP_DATA", doodle)
        self.assertIn("BMON_DATA_ABILITY, ABILITY_RECEIVER, _FAILED", doodle)

    def test_order_up_is_a_hit_sheer_force_always_boosts(self):
        # Pokemon Central (Alta Cucina): the power is test_move_power's
        # OrderUpTests; the rise of a stat by the Tatsugiri in the mouth is
        # test_commander's.
        self.assertImplemented("ORDER_UP", "MOVE_EFFECT_HIT")

    def test_spectral_thief_takes_the_raised_stages_before_it_strikes(self):
        # Pokemon Central (Ombrafurto): every raised stage, to the user,
        # doubled by Simple and turned about by Contrary, before the damage,
        # round a substitute.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("SPECTRAL_THIEF", "MOVE_EFFECT_HIT")
        thief = subscript_named("BATTLE_SUBSCRIPT_SPECTRAL_THIEF")
        self.assertLess(thief.index("SetMoveConditionFlag MOVE_SPECTRAL_THIEF, BATTLER_CATEGORY_DEFENDER"), thief.index("CalcDamage"))
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('spectral thief'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", thief)
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        connecting = function(controller, "ov12_0224C678")
        self.assertLess(connecting.index("BATTLE_SUBSCRIPT_SPECTRAL_THIEF"), connecting.index("BATTLE_SUBSCRIPT_GEM"))
        flag = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag")
        stealing = flag[flag.index("case MOVE_SPECTRAL_THIEF:"):]
        for line in ("ctx->battleMons[battlerId].statChanges[stat] = 6;", "raised *= 2;", "raised = -raised;"):
            self.assertIn(line, stealing)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        self.assertIn("ctx->moveNoCur == MOVE_SPECTRAL_THIEF", function(overlay, "MoveGoesRoundSubstitute"))
        self.assertIn("ctx->moveNoCur != MOVE_SPECTRAL_THIEF", function(overlay, "SubstituteTakesHit"))

    def test_court_change_swaps_the_two_sides(self):
        # Pokemon Central (Cambiocampo): screens, Mist, Safeguard, Tailwind,
        # the hazards and their order; not a Pokemon's own Wish or Lucky Chant.
        import import_battle_messages
        self.assertImplemented("COURT_CHANGE", "MOVE_EFFECT_COURT_CHANGE")
        self.assertFalse(record("COURT_CHANGE")[9] & (1 << 1 | 1 << 2), "FLAG_PROTECT, FLAG_MAGIC_COAT")
        script = effect_script("MOVE_EFFECT_COURT_CHANGE")
        self.assertIn("SetMoveConditionFlag MOVE_COURT_CHANGE, BATTLER_CATEGORY_ATTACKER", script)
        self.assertIn(f"BufferMessage msg_0197_{import_battle_messages.port_row('court change'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", script)
        flag = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SetMoveConditionFlag")
        court = flag[flag.index("case MOVE_COURT_CHANGE:"):]
        court = court[:court.index("break;")]
        for condition in ("REFLECT", "LIGHT_SCREEN", "AURORA_VEIL", "MIST", "SAFEGUARD", "TAILWIND", "SPIKES", "TOXIC_SPIKES", "STEALTH_ROCKS", "STICKY_WEB"):
            self.assertIn(f"SIDE_CONDITION_{condition}", court)
        for condition in ("LUCKY_CHANT", "WISH", "FUTURE_SIGHT"):
            self.assertNotIn(f"SIDE_CONDITION_{condition}", court)
        # Run the case: the ground's conditions change sides, Follow Me and the
        # items knocked off stay where they were.
        from test_ability_behaviour import HEADER, run_c
        battle = (ROOT / "include/battle/battle.h").read_text()
        data = re.search(r"typedef struct SideConditionData \{.*?\} SideConditionData;", battle, re.S).group(0)
        body = flag[flag.index("case MOVE_COURT_CHANGE: {") + len("case MOVE_COURT_CHANGE:"):]
        body = body[:body.index("\n    }\n") + len("\n    }\n")].replace("break;", "")
        run_c(self, HEADER + data + r"""
typedef struct { u32 fieldSideConditionFlags[2]; SideConditionData fieldSideConditionData[2]; u8 entryHazardQueue[2][NUM_HAZARD_IDX]; } Ctx;
int main(void) {
    Ctx c = {0}, *ctx = &c;
    ctx->fieldSideConditionFlags[0] = SIDE_CONDITION_REFLECT | SIDE_CONDITION_LUCKY_CHANT;
    ctx->fieldSideConditionFlags[1] = SIDE_CONDITION_SPIKES | SIDE_CONDITION_WISH;
    ctx->fieldSideConditionData[0].reflectTurns = 4;
    ctx->fieldSideConditionData[0].reflectBattler = 2;
    ctx->fieldSideConditionData[0].followMeFlag = 1;
    ctx->fieldSideConditionData[0].battlerIdFollowMe = 2;
    ctx->fieldSideConditionData[1].spikesLayers = 3;
    ctx->fieldSideConditionData[1].battlerBitKnockedOffItem = 5;
    ctx->entryHazardQueue[1][0] = 7;
    """ + body + r"""
    assert(ctx->fieldSideConditionFlags[0] == (SIDE_CONDITION_SPIKES | SIDE_CONDITION_LUCKY_CHANT));
    assert(ctx->fieldSideConditionFlags[1] == (SIDE_CONDITION_REFLECT | SIDE_CONDITION_WISH));
    assert(ctx->fieldSideConditionData[1].reflectTurns == 4 && ctx->fieldSideConditionData[1].reflectBattler == 2);
    assert(ctx->fieldSideConditionData[0].reflectTurns == 0 && ctx->fieldSideConditionData[0].spikesLayers == 3);
    assert(ctx->fieldSideConditionData[1].spikesLayers == 0);
    assert(ctx->fieldSideConditionData[0].followMeFlag == 1 && ctx->fieldSideConditionData[0].battlerIdFollowMe == 2);
    assert(ctx->fieldSideConditionData[1].followMeFlag == 0 && ctx->fieldSideConditionData[1].battlerBitKnockedOffItem == 5);
    assert(ctx->fieldSideConditionData[0].battlerBitKnockedOffItem == 0);
    assert(ctx->entryHazardQueue[0][0] == 7 && ctx->entryHazardQueue[1][0] == 0);
    return 0;
}
""")

    def test_telekinesis_lifts_its_target_for_three_turns(self):
        # Pokemon Central (Telecinesi): out of the ground's reach, into every
        # move's but a one-hit KO's; not under Gravity, on the rooted, the
        # downed or the heavy, nor on the Pokemon the ground always holds.
        import import_battle_messages
        from test_hold_effects import subscript_named
        self.assertImplemented("TELEKINESIS", "MOVE_EFFECT_TELEKINESIS")
        script = effect_script("MOVE_EFFECT_TELEKINESIS")
        for check in ("FIELD_CONDITION_GRAVITY, _FAILED", "MOVE_EFFECT_FLAG_INGRAIN, _FAILED", "MOVE_EFFECT_FLAG_SMACK_DOWN, _FAILED",
                      "HOLD_EFFECT_SPEED_DOWN_GROUNDED, _FAILED", "SPECIES_DIGLETT_ALOLAN, _FAILED", "SPECIES_MEGA_GENGAR, _FAILED"):
            self.assertIn(check, script)
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_TELEKINESIS"), "BATTLE_SUBSCRIPT_TELEKINESIS")
        lifting = subscript_named("BATTLE_SUBSCRIPT_TELEKINESIS")
        self.assertIn("SetMoveConditionFlag MOVE_TELEKINESIS, BATTLER_CATEGORY_DEFENDER", lifting)
        self.assertIn(f"msg_0197_{import_battle_messages.port_row('telekinesis'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", lifting)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        self.assertIn("|| ctx->moveConditions[battlerId].telekinesisTurns != 0", function(overlay, "BattlerIsGrounded"))
        self.assertIn("ctx->moveConditions[battlerIdTarget].telekinesisTurns && moveType == TYPE_GROUND && BattlerIsGrounded(ctx, battlerIdTarget) == FALSE",
                      function(overlay, "CalcTypeEffectiveness"))
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        self.assertIn("if (ctx->moveConditions[battlerIdTarget].telekinesisTurns && BattleMoveTbl(ctx, move)->effect != MOVE_EFFECT_ONE_HIT_KO) {\n        return FALSE;",
                      function(controller, "BattleSystem_CheckMoveHit"))
        from test_ability_behaviour import accuracy_program, run_c
        run_c(self, accuracy_program(r"""
    // A 50% move lands on a Pokemon held up by Telekinesis whatever the roll,
    // a one-hit KO move does not.
    reset(4); ctx.moveConditions[1].telekinesisTurns = 3; EXPECT(lands(99), 1);
    S.move.effect = MOVE_EFFECT_ONE_HIT_KO; EXPECT(lands(50), 0);
"""))
        umc = function(controller, "BattleControllerPlayer_UpdateMonCondition")
        step = umc[umc.index("case UMC_STATE_TELEKINESIS:"):umc.index("case UMC_STATE_HEALBLOCK:")]
        self.assertIn(f"ctx->buffMsg.id = msg_0197_{import_battle_messages.port_row('telekinesis ends'):05d};", step)

    def test_beak_blast_burns_what_touches_its_heating_user(self):
        # Pokemon Central (Cannonbecco): the beak heats as the turn begins,
        # whatever the user's status, and a contact hit on it before it moves
        # burns the attacker.
        import import_battle_messages
        self.assertImplemented("BEAK_BLAST", "MOVE_EFFECT_HIT")
        before = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_BeforeTurn")
        heating = before[before.index("MOVE_BEAK_BLAST"):]
        self.assertIn("ctx->turnData[battlerId].beakBlastCharging = TRUE;", heating)
        self.assertIn(f"ctx->buffMsg.id = msg_0197_{import_battle_messages.port_row('beak blast'):05d};", heating)
        self.assertNotIn("STATUS_SLEEP", heating[:heating.index("{")])
        hit = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CheckAbilityEffectOnHit")
        burning = hit[hit.index("beakBlastCharging"):]
        burning = burning[:burning.index("return TRUE;")]
        self.assertIn("ov12_0225561C(ctx, ctx->battlerIdTarget) == FALSE", burning)
        self.assertIn("BattleMoveMakesContact(ctx, ctx->moveNoCur)", burning)
        self.assertIn("*script = BATTLE_SUBSCRIPT_BURN;", burning)

    def test_shell_trap_springs_on_a_foe_s_physical_hit(self):
        # Pokemon Central (Gusciotrappola): set as the turn begins; a foe's
        # physical hit, not Sheer Force's, springs it and it goes next;
        # unsprung, it fails when its turn comes.
        import import_battle_messages
        self.assertImplemented("SHELL_TRAP", "MOVE_EFFECT_SHELL_TRAP")
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        before = function(controller, "BattleControllerPlayer_BeforeTurn")
        setting = before[before.index("MOVE_SHELL_TRAP"):]
        self.assertIn("ctx->turnData[battlerId].shellTrapSet = TRUE;", setting)
        self.assertIn(f"ctx->buffMsg.id = msg_0197_{import_battle_messages.port_row('shell trap'):05d};", setting)
        hp = function(controller, "BattleControllerPlayer_HpCalc")
        springing = hp[hp.index("shellTrapSet"):]
        springing = springing[:springing.index("}")]
        for part in ("ov12_0225561C(ctx, ctx->battlerIdTarget) == FALSE", "BattleSystem_GetFieldSide", "CATEGORY_PHYSICAL",
                     "!SheerForceTradedEffect(ctx)", "shellTrapSprung = TRUE;", "forceExecutionOrder = EXECUTION_ORDER_AFTER_YOU;"):
            self.assertIn(part, springing)
        self.assertLess(hp.index("BATTLE_SUBSCRIPT_HIT_SUBSTITUTE"), hp.index("shellTrapSet"))
        script = effect_script("MOVE_EFFECT_SHELL_TRAP")
        self.assertIn("SetMoveConditionFlag MOVE_SHELL_TRAP, BATTLER_CATEGORY_ATTACKER", script)
        self.assertIn(f"PrintMessage msg_0197_{import_battle_messages.port_row('shell trap failed'):05d}, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER", script)

    def test_teatime_has_everyone_eat_their_berry(self):
        # Pokemon Central (Ora del Te): every Pokemon on the field but one in
        # the air or underground eats its own Berry, whatever would keep it
        # from another's; no Berry, and nothing happens.
        import import_battle_messages
        self.assertImplemented("TEATIME", "MOVE_EFFECT_TEATIME")
        self.assertEqual(record("TEATIME")[7], 1 << 6, "RANGE_FIELD")
        script = effect_script("MOVE_EFFECT_TEATIME")
        self.assertIn(f"PrintMessage msg_0197_{import_battle_messages.port_row('teatime'):05d}, TAG_NONE", script)
        self.assertIn("UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_STAT_CHANGE\n"
                      "    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_STAT_CHANGE\n"
                      "    TryPluck _NEXT, _NEXT", script)
        self.assertIn("UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_ATTACKER_TEMP", script)
        self.assertIn("msg_0197_00795", script[script.index("_NOTHING:"):])
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        pluck = function(commands, "BtlCmd_TryPluck")
        self.assertLess(pluck.index("MOVE_TEATIME"), pluck.index("ABILITY_STICKY_HOLD"))
        flag = function(commands, "BtlCmd_SetMoveConditionFlag")
        self.assertIn("ItemIdIsBerry(ctx->battleMons[i].item) == TRUE", flag[flag.index("case MOVE_TEATIME:"):])

    ALLY_SWITCH_PROGRAM = r"""
#include <stddef.h>
typedef struct { int unused; } BattleSystem;
typedef struct {
    u32 disabledTurns : 3, battlerIdLockOn : 2, battlerIdBinding : 2, battlerIdMeanLook : 2;
} UnkBattlemonSub;
typedef struct { u16 species; int hp; u16 ability; u32 status2; UnkBattlemonSub unk88; } BattleMon;
typedef struct {
    u32 protectFlag : 1, allySwitched : 1;
    int physicalDamage[4]; int battlerIdPhysicalDamage; int battlerBitPhysicalDamage;
    int specialDamage[4]; int battlerIdSpecialDamage; int battlerBitSpecialDamage;
} TurnData;
typedef struct { u32 moldBreakerFlag : 1; int battlerIdPhysicalAttacker; int battlerIdSpecialAttacker; } SelfTurnData;
typedef struct { u32 paralysis : 1; } MoveFailFlags;
typedef struct { u8 syrupBombTurns : 2; u8 syrupBombUser : 2; } MoveConditions;
typedef struct { int command; u32 unk4; u32 unk8; u32 inputSelection; } PlayerActions;
typedef struct { u16 moves[4][4]; u16 heldItems[4]; } TrainerAIData;
typedef struct { int battlerIdFutureSight[4]; } FieldConditionData;
typedef struct { u32 followMeFlag : 1; u32 battlerIdFollowMe : 2; } SideConditionData;
typedef struct {
    int battlerIdAttacker, battlerIdAttackerTemp, battlerIdTarget, battlerIdTargetTemp, battlerIdStatChange, battlerIdTemp, battlerIdMagicCoat;
    u32 fieldCondition; FieldConditionData fieldConditionData; SideConditionData fieldSideConditionData[2];
    BattleMon battleMons[4]; TurnData turnData[4]; SelfTurnData selfTurnData[4]; MoveFailFlags moveFail[4];
    MoveConditions moveConditions[4]; PlayerActions playerActions[4]; TrainerAIData trainerAIData;
    u8 selectedMonIndex[4]; u8 unk_21A0[4]; u32 unk_13C[4]; u32 unk_218C[4]; u16 movePos[4]; u16 unk_30B4[4];
    u32 moveNoLockedInto[4]; u16 moveNoProtect[4]; u16 moveNoHit[4]; u16 moveNoHitBattler[4]; u16 moveNoHitType[4];
    u16 moveNoBattlerPrev[4]; u16 moveNoCopied[4]; u16 moveNoCopiedHit[4][4]; u16 moveNoSketch[4]; u16 conversion2Move[4];
    u16 conversion2BattlerId[4]; u16 conversion2Type[4]; u16 moveNoMetronome[4]; int unk_30E4[4]; int unk_30F4[4];
    u32 effectiveSpeed[4]; u16 trainerAIAbilities[4]; u8 protectSuccessTurns[4]; u8 psychicTerrainMoveUsed[4];
    u8 paradoxBoostedStat[4]; u8 boosterEnergyActivated[4]; u16 cudChewBerry[4]; u16 cudChewTurn[4];
    u8 supremeOverlordFallen[4]; u8 mimicryTerrain[4]; u8 opportunistStages[4][8]; u8 symbiosisPending[4];
    u8 mirrorHerbStages[4][8]; u8 onceOnlyEntryAbilityDone[4][6]; u8 berryEaten[4][6]; u8 rageFistHits[4][6];
    u8 turnOrder[4]; u8 executionOrder[4]; u8 danceUser, danceTarget; u8 switchInFlag, roundUsers, statLoweredBattlers,
    statRaisedBattlers, teraShellResisting, dancersPending, bindingBandBinds, strongWindsWeakened; u8 unk_312C[2][6];
} BattleContext;
static u32 sBattleType; static u16 sRandom;
static const u16 sProtectSuccessChance[7] = { 1, 3, 9, 27, 81, 243, 729 };
static u32 MaskOfFlagNo(int flagNo) { return 1u << flagNo; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { (void)bs; return sBattleType; }
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return sBattleType & BATTLE_TYPE_DOUBLES ? battlerId ^ 2 : battlerId; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return sRandom; }
@FUNCTIONS@
static BattleContext ctx;
static BattleSystem bs;
static void reset(void) {
    memset(&ctx, 0, sizeof(ctx));
    sBattleType = BATTLE_TYPE_DOUBLES | BATTLE_TYPE_TRAINER; sRandom = 1;
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].species = 100 + i; ctx.battleMons[i].hp = 10; ctx.selectedMonIndex[i] = i >> 1;
        ctx.turnOrder[i] = i; ctx.playerActions[i].unk4 = 1;
    }
    ctx.battlerIdAttacker = 0; ctx.unk_312C[0][0] = 0; ctx.unk_312C[0][1] = 1;
}
int main(void) {
    // Works beside a standing ally in a double battle; the user's battler is
    // its new place's, the Pokemon change battlers with what is theirs.
    reset(); ctx.battleMons[1].unk88.battlerIdMeanLook = 0; ctx.battleMons[1].status2 = 1u << (STATUS2_ATTRACT_SHIFT + 0);
    ctx.rageFistHits[0][0] = 3; ctx.roundUsers = 1; ctx.fieldCondition = 1u << FIELD_CONDITION_UPROAR_SHIFT;
    ctx.battleMons[3].ability = ABILITY_STALWART; ctx.playerActions[3].unk4 = 0; ctx.playerActions[0].unk8 = 7;
    EXPECT(AllySwitchWorks(&bs, &ctx), TRUE);
    Battlers_SwapPlaces(&ctx, 0, 2);
    EXPECT(ctx.battleMons[0].species, 102); EXPECT(ctx.battleMons[2].species, 100);
    EXPECT(ctx.selectedMonIndex[0], 1); EXPECT(ctx.selectedMonIndex[2], 0);
    EXPECT(ctx.playerActions[2].unk8, 7); EXPECT(ctx.turnData[2].allySwitched, 1);
    EXPECT(ctx.battlerIdAttacker, 2); EXPECT(ctx.battleMons[1].unk88.battlerIdMeanLook, 2);
    EXPECT((int)ctx.battleMons[1].status2, (int)(1u << (STATUS2_ATTRACT_SHIFT + 2)));
    EXPECT(ctx.rageFistHits[2][0], 3); EXPECT(ctx.rageFistHits[0][0], 0); EXPECT(ctx.roundUsers, 4);
    EXPECT((int)ctx.fieldCondition, (int)(4u << FIELD_CONDITION_UPROAR_SHIFT));
    EXPECT(ctx.turnOrder[0] * 1000 + ctx.turnOrder[1] * 100 + ctx.turnOrder[2] * 10 + ctx.turnOrder[3], 2103);
    EXPECT(ctx.unk_312C[0][0], 1); EXPECT(ctx.unk_312C[0][1], 0);
    // A foe's move stays aimed at the place, Stalwart's at the Pokemon.
    EXPECT(ctx.playerActions[1].unk4, 1); EXPECT(ctx.playerActions[3].unk4, 2);
    // The ally, having moved, cannot move them back this turn.
    ctx.battlerIdAttacker = 0; ctx.moveNoProtect[0] = 0;
    EXPECT(AllySwitchWorks(&bs, &ctx), FALSE);
    // Not in a single or a multi battle, nor beside a fainted ally.
    reset(); sBattleType = BATTLE_TYPE_TRAINER; EXPECT(AllySwitchWorks(&bs, &ctx), FALSE);
    reset(); sBattleType |= BATTLE_TYPE_MULTI; EXPECT(AllySwitchWorks(&bs, &ctx), FALSE);
    reset(); ctx.battleMons[2].hp = 0; EXPECT(AllySwitchWorks(&bs, &ctx), FALSE);
    // In a row, one try in three, then nine; another move in between, sure.
    reset(); ctx.moveNoProtect[0] = MOVE_ALLY_SWITCH; ctx.protectSuccessTurns[0] = 1;
    sRandom = 1; EXPECT(AllySwitchWorks(&bs, &ctx), FALSE); EXPECT(ctx.protectSuccessTurns[0], 0);
    reset(); ctx.moveNoProtect[0] = MOVE_ALLY_SWITCH; ctx.protectSuccessTurns[0] = 1;
    sRandom = 3; EXPECT(AllySwitchWorks(&bs, &ctx), TRUE); EXPECT(ctx.protectSuccessTurns[0], 2);
    reset(); ctx.moveNoProtect[0] = MOVE_PROTECT; ctx.protectSuccessTurns[0] = 3;
    sRandom = 1; EXPECT(AllySwitchWorks(&bs, &ctx), TRUE);
    return 0;
}
"""

    def test_the_trainer_ai_leaves_ally_switch_with_no_ally(self):
        # The AI's scripts have no rule for the move, which fails with no
        # ally standing (AllySwitchWorks): it is scored as a move that
        # cannot be used is, as the Struggle check scores those.
        from test_hold_effects import run_c
        ai = (ROOT / "src/battle/trainer_ai.c").read_text()
        program = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
typedef int32_t s32; typedef uint32_t u32;
typedef int BOOL;
typedef struct { u32 battleType; } BattleSystem;
typedef struct { s32 hp; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) {
    return (bs->battleType & BATTLE_TYPE_DOUBLES) && !(bs->battleType & BATTLE_TYPE_MULTI) ? battlerId ^ 2 : battlerId;
}
""" + function(ai, "AllySwitchHasNoAlly") + r"""
int main(void) {
    BattleSystem bs = { 0 };
    BattleContext ctx = { { { 10 }, { 10 }, { 10 }, { 10 } } };
    assert(AllySwitchHasNoAlly(&bs, &ctx, 1));
    bs.battleType = BATTLE_TYPE_DOUBLES | BATTLE_TYPE_TRAINER;
    assert(!AllySwitchHasNoAlly(&bs, &ctx, 1));
    ctx.battleMons[3].hp = 0;
    assert(AllySwitchHasNoAlly(&bs, &ctx, 1));
    ctx.battleMons[3].hp = 10;
    bs.battleType |= BATTLE_TYPE_MULTI;
    assert(AllySwitchHasNoAlly(&bs, &ctx, 1));
    return 0;
}
"""
        run_c(program)
        self.assertIn("|| (ctx->battleMons[battlerId].moves[i] == MOVE_ALLY_SWITCH && AllySwitchHasNoAlly(battleSystem, ctx, battlerId))) {\n"
                      "            ctx->trainerAIData.movePoints[i] = 0;", function(ai, "ov10_0221BE20"))

    def test_ally_switch_has_the_two_change_places(self):
        # Pokemon Central (Cambiaposto): in a double battle the user and its
        # ally change places, attacks aimed at a place hitting whoever stands
        # there; fails otherwise, and in a row as Protect does.
        from test_ability_behaviour import HEADER, run_c
        import import_battle_messages
        self.assertImplemented("ALLY_SWITCH", "MOVE_EFFECT_ALLY_SWITCH")
        script = effect_script("MOVE_EFFECT_ALLY_SWITCH")
        self.assertLess(script.index("SetMoveConditionFlag MOVE_ALLY_SWITCH, BATTLER_CATEGORY_ATTACKER"),
                        script.index("CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED"))
        # The redraw is its animation: the borrowed one would play after the
        # message, from UseMove's subscript (seen in melonDS, round 9).
        self.assertLess(script.index("BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF"),
                        script.index("_FAILED:"))
        for part in ("ChangeForm BATTLER_CATEGORY_ATTACKER\n", "ChangeForm BATTLER_CATEGORY_ATTACKER_PARTNER",
                     "HealthbarSlideIn BATTLER_CATEGORY_ATTACKER\n", "HealthbarSlideIn BATTLER_CATEGORY_ATTACKER_PARTNER",
                     f"PrintMessage msg_0197_{import_battle_messages.port_row('ally switch'):05d}, TAG_NICKNAME_NICKNAME"):
            self.assertIn(part, script)
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        tables = "\n".join(re.search(r"typedef struct BattlerField \{.*?#undef ONCE\n", commands, re.S).group(0).splitlines())
        functions = "\n".join(function(commands, name) for name in (
            "SwapBytes", "OtherOfPair", "SwapMaskBits", "ReadBattlerField", "WriteBattlerField", "Battlers_SwapPlaces", "AllySwitchWorks"))
        run_c(self, HEADER + self.ALLY_SWITCH_PROGRAM.replace("@FUNCTIONS@", tables + "\n" + functions))
        flag = function(commands, "BtlCmd_SetMoveConditionFlag")
        self.assertIn("Battlers_SwapPlaces(ctx, battlerId, BattleSystem_GetBattlerIdPartner(battleSystem, battlerId));",
                      flag[flag.index("case MOVE_ALLY_SWITCH:"):])
        # A move the ally aimed at the user is now aimed at itself, and fails:
        # no target, before Follow Me or anything else is asked.
        target = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "ov12_022506D4")
        target = target[target.index("int battlerIdTargetTemp = ctx->playerActions[battlerIdAttacker].unk4;"):]
        self.assertLess(target.index("if (battlerIdTargetTemp == battlerIdAttacker) {"), target.index("followMeFlag"))

    PLEDGE_PROGRAM = r"""
typedef struct { int unused; } BattleSystem;
typedef struct { int hp; u16 ability; } BattleMon;
typedef struct { u32 struggleFlag : 1, forceExecutionOrder : 2, pledgeCombination : 2; } TurnData;
typedef struct { u32 combinedPledge : 1; } SelfTurnData;
typedef struct { int effect, effectChance; } MoveTbl;
typedef struct {
    int battlerIdAttacker; u32 moveNoCur; int movePower; int moveType; u32 fieldSideConditionFlags[2];
    BattleMon battleMons[4]; TurnData turnData[4]; SelfTurnData selfTurnData[4]; u16 selected[4]; int acted[4];
} BattleContext;
static u32 sBattleType; static MoveTbl sMove;
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return sBattleType ? battlerId ^ 2 : battlerId; }
static u8 BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static u16 GetBattlerSelectedMove(BattleContext *ctx, int battlerId) { return ctx->selected[battlerId]; }
static BOOL ov12_0225561C(BattleContext *ctx, int battlerId) { return ctx->acted[battlerId]; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &sMove; }
static BOOL MoveIsInList(u32 move, const u16 *list, int count) { for (int i = 0; i < count; i++) if (list[i] == move) return TRUE; return FALSE; }
@FUNCTIONS@
static BattleContext ctx;
static BattleSystem bs;
static void reset(void) {
    memset(&ctx, 0, sizeof(ctx)); sBattleType = 1;
    for (int i = 0; i < 4; i++) ctx.battleMons[i].hp = 10;
}
int main(void) {
    // Fire Pledge first, the ally's Grass Pledge still to come: the Fire one
    // waits and the Grass one goes next, as a Fire move that burns.
    reset(); ctx.moveNoCur = MOVE_FIRE_PLEDGE; ctx.selected[2] = MOVE_GRASS_PLEDGE;
    EXPECT(TryPledgeCombination(&bs, &ctx, 0), 1);
    EXPECT(ctx.turnData[2].pledgeCombination, 2); EXPECT(ctx.turnData[2].forceExecutionOrder, EXECUTION_ORDER_AFTER_YOU);
    ctx.moveNoCur = MOVE_GRASS_PLEDGE;
    EXPECT(TryPledgeCombination(&bs, &ctx, 2), 2);
    EXPECT(ctx.movePower, 150); EXPECT(ctx.moveType, TYPE_FIRE); EXPECT(ctx.selfTurnData[2].combinedPledge, 1);
    // Water with Fire is Water (the rainbow), Grass with Water is Grass (the
    // swamp), whichever comes first.
    reset(); ctx.moveNoCur = MOVE_WATER_PLEDGE; ctx.selected[2] = MOVE_FIRE_PLEDGE;
    EXPECT(TryPledgeCombination(&bs, &ctx, 0), 1); EXPECT(ctx.turnData[2].pledgeCombination, 1);
    reset(); ctx.moveNoCur = MOVE_FIRE_PLEDGE; ctx.selected[2] = MOVE_WATER_PLEDGE;
    EXPECT(TryPledgeCombination(&bs, &ctx, 0), 1); EXPECT(ctx.turnData[2].pledgeCombination, 1);
    reset(); ctx.moveNoCur = MOVE_GRASS_PLEDGE; ctx.selected[2] = MOVE_WATER_PLEDGE;
    EXPECT(TryPledgeCombination(&bs, &ctx, 0), 1); EXPECT(ctx.turnData[2].pledgeCombination, 3);
    // Alone: the same Pledge, no Pledge, an ally that has moved or fainted,
    // a single battle.
    reset(); ctx.moveNoCur = MOVE_FIRE_PLEDGE; ctx.selected[2] = MOVE_FIRE_PLEDGE; EXPECT(TryPledgeCombination(&bs, &ctx, 0), 0);
    ctx.selected[2] = MOVE_EMBER; EXPECT(TryPledgeCombination(&bs, &ctx, 0), 0);
    ctx.selected[2] = MOVE_GRASS_PLEDGE; ctx.acted[2] = TRUE; EXPECT(TryPledgeCombination(&bs, &ctx, 0), 0);
    ctx.acted[2] = FALSE; ctx.battleMons[2].hp = 0; EXPECT(TryPledgeCombination(&bs, &ctx, 0), 0);
    reset(); sBattleType = 0; ctx.moveNoCur = MOVE_FIRE_PLEDGE; ctx.selected[2] = MOVE_GRASS_PLEDGE; EXPECT(TryPledgeCombination(&bs, &ctx, 0), 0);
    EXPECT(ctx.movePower, 0);
    // The rainbow doubles an added effect's chance; not Secret Power's, and
    // with Serene Grace not a flinch's again.
    reset(); sMove = (MoveTbl){ MOVE_EFFECT_BURN_HIT, 10 }; ctx.moveNoCur = MOVE_EMBER;
    EXPECT(MoveEffectChance(&bs, &ctx), 10);
    ctx.fieldSideConditionFlags[0] = 4 << SIDE_CONDITION_RAINBOW_SHIFT; EXPECT(MoveEffectChance(&bs, &ctx), 20);
    ctx.battleMons[0].ability = ABILITY_SERENE_GRACE; EXPECT(MoveEffectChance(&bs, &ctx), 40);
    sMove.effect = MOVE_EFFECT_FLINCH_HIT; EXPECT(MoveEffectChance(&bs, &ctx), 20);
    ctx.battleMons[0].ability = 0; EXPECT(MoveEffectChance(&bs, &ctx), 20);
    ctx.moveNoCur = MOVE_SECRET_POWER; EXPECT(MoveEffectChance(&bs, &ctx), 10);
    ctx.moveNoCur = MOVE_BITE; ctx.fieldSideConditionFlags[0] = 0; ctx.fieldSideConditionFlags[1] = 4 << SIDE_CONDITION_RAINBOW_SHIFT;
    EXPECT(MoveEffectChance(&bs, &ctx), 10);
    return 0;
}
"""

    def test_the_pledges_combine_into_one_move(self):
        # Pokemon Central (Acquapatto, Fiammapatto, Erbapatto): with an ally's
        # other Pledge, one waits and the other goes next as a move of 150 of
        # the winning type, with STAB, leaving a rainbow over the user's side
        # or a sea of fire or a swamp around the target's for four turns.
        from test_ability_behaviour import HEADER, run_c
        import import_battle_messages
        for move in ("WATER_PLEDGE", "FIRE_PLEDGE", "GRASS_PLEDGE"):
            self.assertImplemented(move, "MOVE_EFFECT_PLEDGE")
        script = effect_script("MOVE_EFFECT_PLEDGE")
        self.assertIn("SetMoveConditionFlag MOVE_WATER_PLEDGE, BATTLER_CATEGORY_ATTACKER", script)
        self.assertIn(f"PrintMessage msg_0197_{import_battle_messages.port_row('pledge waiting'):05d}, TAG_NICKNAME_NICKNAME", script)
        self.assertIn(f"PrintMessage msg_0197_{import_battle_messages.port_row('pledge combined'):05d}, TAG_NONE", script)
        waiting = script[script.index("\n_WAIT:"):]
        self.assertIn("MOVE_STATUS_NO_MORE_WORK", waiting)
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        kinds = re.search(r"static int PledgeKind\(u16 move\) \{.*?\n\}\n\nstatic const u8 sPledgeTypes\[\] = [^;]*;", commands, re.S).group(0)
        flinches = re.search(r"static const u16 sFlinchEffects\[\] = \{.*?\};", overlay, re.S).group(0)
        functions = "\n".join([kinds, function(commands, "TryPledgeCombination"), flinches, function(overlay, "MoveEffectChance")])
        run_c(self, HEADER + '#include "constants/battle_script_imports.h"\n' + self.PLEDGE_PROGRAM.replace("@FUNCTIONS@", functions))
        # The combined move's STAB and the swamp's quartered Speed.
        self.assertIn("ctx->selfTurnData[battlerIdAttacker].combinedPledge && BattleMoveTbl(ctx, moveNo)->effect == MOVE_EFFECT_PLEDGE",
                      function(overlay, "CalcTypeEffectiveness"))
        speed = function(overlay, "CheckSortSpeed")
        for battler in ("1", "2"):
            self.assertIn(f"SIDE_CONDITION_SWAMP) {{\n        speed{battler} /= 4;", speed)
        # The condition once the combined move has hit; the sea of fire at
        # each turn's end; the three running out; Court Change taking them.
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        additional = function(controller, "TryAdditionalMoveEffect")
        pledge = additional[additional.index("case MOVE_EFFECT_PLEDGE:"):]
        for part in ("combinedPledge", "combination == 1 ? ctx->battlerIdAttacker : target", "|= 4 << shift",
                     "BATTLE_SUBSCRIPT_PLEDGE_CONDITION"):
            self.assertIn(part, pledge[:pledge.index("break;")])
        self.assertIn("case UMC_STATE_SEA_OF_FIRE:", controller)
        self.assertIn("DamageDivide(ctx->battleMons[battlerId].maxHp * -1, 8)", controller[controller.index("case UMC_STATE_SEA_OF_FIRE:"):controller.index("case UMC_STATE_INGRAIN:")])
        self.assertIn("BATTLE_SUBSCRIPT_PLEDGE_CONDITION_END", controller[controller.index("case UFC_STATE_PLEDGES:"):controller.index("case UFC_STATE_WISH:")])
        court = function(commands, "BtlCmd_SetMoveConditionFlag")
        court = court[court.index("case MOVE_COURT_CHANGE:"):]
        self.assertIn("SIDE_CONDITION_RAINBOW | SIDE_CONDITION_SEA_OF_FIRE | SIDE_CONDITION_SWAMP", court[:court.index("break;")])

    def test_instruct_has_its_target_use_its_last_move_again(self):
        # Pokemon Central (Imposizione): straight after, PP spent, not the
        # moves that wait, charge, recharge, copy or call another.
        from test_hold_effects import subscript_named
        self.assertImplemented("INSTRUCT", "MOVE_EFFECT_INSTRUCT")
        self.assertIn("MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_INSTRUCT", effect_script("MOVE_EFFECT_INSTRUCT"))
        self.assertEqual(side_effect_subscript("MOVE_SUBSCRIPT_PTR_INSTRUCT"), "BATTLE_SUBSCRIPT_INSTRUCT")
        self.assertIn("SetMoveConditionFlag MOVE_INSTRUCT, BATTLER_CATEGORY_DEFENDER", subscript_named("BATTLE_SUBSCRIPT_INSTRUCT"))
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        banned = re.search(r"sMovesInstructCannotRepeat\[\] = \{(.*?)\};", commands, re.S).group(1)
        for move in ("INSTRUCT", "BIDE", "FOCUS_PUNCH", "BEAK_BLAST", "SHELL_TRAP", "SKETCH", "TRANSFORM", "MIMIC", "KINGS_SHIELD", "STRUGGLE"):
            self.assertIn(f"MOVE_{move},", banned)
        effects = re.search(r"sEffectsInstructCannotRepeat\[\] = \{(.*?)\};", commands, re.S).group(1)
        for effect in ("RECHARGE_AFTER", "FLY", "DIG", "DIVE", "SHADOW_FORCE", "151"):
            self.assertIn(f"MOVE_EFFECT_{effect},", effects)
        self.assertIn("CheckMoveCallsOtherMove(move) == TRUE", function(commands, "MoveCanBeInstructed"))
        controller = (ROOT / "src/battle/battle_controller_player.c").read_text()
        instructing = function(controller, "TryInstruct")
        self.assertIn("ctx->battleMons[battlerId].movePPCur[index]--;", instructing)
        self.assertIn("ctx->unk_2184 = MULTIHIT_SKIP_OBEDIENCE_CHECK | MULTIHIT_SKIP_PP_DECREMENT;", instructing)
        end = function(controller, "ov12_0224D368")
        self.assertLess(end.index("TryInstruct(battleSystem, ctx)"), end.index("TryDancer(battleSystem, ctx)"))

if __name__ == "__main__":
    unittest.main()
