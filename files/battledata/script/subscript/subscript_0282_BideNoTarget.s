    .include "macros/btlcmd.inc"

    .data

_000:
    // {0} unleashed energy!
    PrintMessage msg_0197_00335, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_LOCKED_INTO_MOVE
    // A move with no one left to hit fails, as from the fifth generation
    // (Showdown's gen-9 useMoveInner: '-fail' for no target, '-notarget'
    // before), where HeartGold said "But there was no target...".
    // But it failed!
    PrintMessage msg_0197_00796, TAG_NONE
    Wait 
    WaitButtonABTime 30
    End 
