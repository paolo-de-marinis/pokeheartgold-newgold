    .include "macros/btlcmd.inc"

    .data

// The salt at a turn's end: the controller has worked out the eighth, or the
// quarter, into HP_CALC (UMC_STATE_SALT_CURE).
_000:
    // {0} is hurt by Salt Cure!
    PrintMessage msg_0197_01853, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    GoToSubscript BATTLE_SUBSCRIPT_UPDATE_HP
