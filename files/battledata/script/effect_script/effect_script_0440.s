    .include "macros/btlcmd.inc"

    .data

// Shell Trap strikes both foes if a foe's physical hit sprang it this turn --
// it has come straight after that hit -- and otherwise fails when its turn
// comes round at -3, saying so (Pokemon Central, Gusciotrappola).
// SetMoveConditionFlag answers in CALC_TEMP whether it was sprung.
_000:
    SetMoveConditionFlag MOVE_SHELL_TRAP, BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _NOT_SPRUNG
    CalcCrit
    CalcDamage
    End

_NOT_SPRUNG:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0}'s shell trap didn't work!
    PrintMessage msg_0197_01891, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End
