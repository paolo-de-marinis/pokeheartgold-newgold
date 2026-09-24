    .include "macros/btlcmd.inc"

    .data

// Damp keeping the attacker from an explosion (DampStopsMove, which names
// the holder in ABILITY_MON and ends the move once this is said).
_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    // {0}’s {1} prevents {2} from using {3}!
    PrintMessage msg_0197_00628, TAG_NICKNAME_ABILITY_NICKNAME_MOVE, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    End 
