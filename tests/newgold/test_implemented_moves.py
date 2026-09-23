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
        self.assertIn("ctx->turnData[ctx->battlerIdStatChange].statRaised = TRUE;",
                      function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_ChangeStatStage"))
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
        self.assertIn("ctx->moveUsedBefore = ctx->moveUsedLast;\n    ctx->moveUsedLast = ctx->moveNoCur;",
                      function(controller, "NoteMoveUsed"))
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

if __name__ == "__main__":
    unittest.main()
