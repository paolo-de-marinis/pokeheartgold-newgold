    .include "macros/btlcmd.inc"

    .data

// Grassy Terrain at a turn's end: the controller has worked the sixteenth
// into HP_CALC for the Pokemon in MSG_TEMP (UMC_STATE_GRASSY_TERRAIN). The
// reference's subscript 346, which has no animation either.
_000:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} had its HP restored.
    PrintMessage msg_0197_01396, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
