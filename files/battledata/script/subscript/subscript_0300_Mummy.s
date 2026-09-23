    .include "macros/btlcmd.inc"

    .data

// Whatever touched the holder wears the holder's ability now. Mummy and
// Lingering Aroma share this, so the ability written is the one the C put in
// BSCRIPT_VAR_MSG_ABILITY_TEMP rather than Mummy by name. Each has its own
// line, the way the reference prints them (subscript_0306), and the one the
// holder had is the one said.
_000:
    WaitButtonABTime 15
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_MSG_ABILITY_TEMP
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_MSG_ABILITY_TEMP, ABILITY_MUMMY, _MUMMY
    // A lingering aroma clings to {0}!
    PrintMessage msg_0197_01453, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    GoTo _END

_MUMMY:
    // {0}’s ability became Mummy!
    PrintMessage msg_0197_01306, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER

_END:
    Wait 
    WaitButtonABTime 30
    End 
