    .include "macros/btlcmd.inc"

    .data

// Steel Beam and Mind Blown cost their user half its maximum HP, rounded up,
// once the move is over, hit or miss, through Protect or a substitute; not
// when there was no target for it, and Magic Guard alone spares it -- Rock
// Head and Reckless have nothing to do with it (Pokemon Central, Raggio
// d'Acciaio, Sbalorditesta). The mark here is what ov12_0224E1BC answers
// after the move: this script runs only for a move that goes off at a target.
// Mind Blown is an explosion, so a Damp on the field stops it and costs
// nothing, as Self-Destruct's script has it (effect script 7).
_000:
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_MOVE_NO_CUR, MOVE_MIND_BLOWN, _MARK
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ALL, ABILITY_DAMP, _DAMP

_MARK:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_LOSE_HALF_MAX_HP
    CalcCrit
    CalcDamage
    End

_DAMP:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0}'s {1} prevents {2} from using {3}!
    PrintMessage msg_0197_00628, TAG_NICKNAME_ABILITY_NICKNAME_MOVE, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
