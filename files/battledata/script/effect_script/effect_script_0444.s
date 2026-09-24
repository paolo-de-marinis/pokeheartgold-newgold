    .include "macros/btlcmd.inc"

    .data

// Water, Fire and Grass Pledge (Pokemon Central, Acquapatto, Fiammapatto,
// Erbapatto). Used while an ally still to move this turn has chosen another
// Pledge, one waits and does nothing, and the ally's goes next as a combined
// move: 150, of the type of the Pledge that beats the other -- Water over
// Fire, Fire over Grass, Grass over Water -- with STAB whoever uses it, and
// once it hits it leaves a rainbow, a sea of fire or a swamp for four turns
// (subscript 465, the hit's side effect). Alone, a Pledge is a plain
// hit. SetMoveConditionFlag decides, asked with Water Pledge's number for all
// three.
_000:
    SetMoveConditionFlag MOVE_WATER_PLEDGE, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 1, _WAIT
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _HIT
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    // The two moves have become one! It's a combined move!
    PrintMessage msg_0197_01916, TAG_NONE
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PLEDGE_CONDITION

_HIT:
    CalcCrit
    CalcDamage
    End

_WAIT:
    // {0} is waiting for {1}'s move...
    PrintMessage msg_0197_01909, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER_PARTNER
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
