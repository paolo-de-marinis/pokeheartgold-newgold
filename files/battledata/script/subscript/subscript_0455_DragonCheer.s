    .include "macros/btlcmd.inc"

    .data

// Dragon Cheer on the ally: a critical stage more, two for a Dragon-type,
// with Focus Energy's line; nothing for one already cheered or pumped
// (Pokemon Central, Grido del Drago). SetMoveConditionFlag leaves in
// CALC_TEMP whether it took.
_000:
    SetMoveConditionFlag MOVE_DRAGON_CHEER, BATTLER_CATEGORY_SIDE_EFFECT_MON
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAILED
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    // {0} is getting pumped!
    PrintMessage msg_0197_00276, TAG_NICKNAME, BATTLER_CATEGORY_SIDE_EFFECT_MON
    Wait
    WaitButtonABTime 30
    End

_FAILED:
    PrintAttackMessage
    Wait
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End
