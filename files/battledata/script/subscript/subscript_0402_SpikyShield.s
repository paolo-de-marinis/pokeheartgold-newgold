    .include "macros/btlcmd.inc"

    .data

// Spiky Shield pricked what touched it: the attacker takes what hpCalc holds,
// as the reference's subscript 450.
_000:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} was hurt!
    PrintMessage msg_0197_01562, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
