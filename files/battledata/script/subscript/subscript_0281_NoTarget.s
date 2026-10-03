    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    // A move with no one left to hit fails, as from the fifth generation
    // (Showdown's gen-9 useMoveInner: '-fail' for no target, '-notarget'
    // before), where HeartGold said "But there was no target...".
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait 
    WaitButtonABTime 30
    UnlockMoveChoice BATTLER_CATEGORY_ATTACKER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MOVE_NO_CUR, MOVE_RAGE, _027
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_RAGE, _027
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_RAGE

_027:
    End 
