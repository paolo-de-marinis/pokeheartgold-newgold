    .include "macros/btlcmd.inc"

    .data

// Whatever touched the holder is a Mummy now. The message reads the ability
// back off the attacker, so it has to be written first.
_000:
    WaitButtonABTime 15
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, ABILITY_MUMMY
    // {0}’s Ability became {1}!
    PrintMessage msg_0197_01276, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
