    .include "macros/btlcmd.inc"

    .data

// A sea of fire at a turn's end: the controller has worked the eighth into
// HP_CALC for the Pokemon in MSG_TEMP (UMC_STATE_SEA_OF_FIRE).
_000:
    // {0} is hurt by the sea of fire!
    PrintMessage msg_0197_01929, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    GoToSubscript BATTLE_SUBSCRIPT_UPDATE_HP
