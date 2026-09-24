    .include "macros/btlcmd.inc"

    .data

// Lightning Rod and Storm Drain swallow the move and raise the holder's
// Sp. Atk a stage (BSCRIPT_VAR_SIDE_EFFECT_PARAM says so). The Sp. Atk twin of
// 297 and 372, for the compare takes the stat as a literal: one already at +6
// has made the move useless.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STAT_CHANGE_SPATK, 12, _MAXED
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End

_MAXED:
    // {0}’s {1} made {2} useless!
    PrintMessage msg_0197_00638, TAG_NICKNAME_ABILITY_MOVE, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
