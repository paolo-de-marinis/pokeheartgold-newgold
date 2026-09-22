    .include "macros/btlcmd.inc"

    .data

// Whatever touched the holder wears the holder's ability now. Mummy and
// Lingering Aroma share this, so the ability written is the one the C put in
// BSCRIPT_VAR_MSG_ABILITY_TEMP rather than Mummy by name. The message reads
// the ability back off the attacker, so it has to be written first.
_000:
    WaitButtonABTime 15
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_MSG_ABILITY_TEMP
    // {0}’s Ability became {1}!
    PrintMessage msg_0197_01276, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
