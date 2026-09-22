    .include "macros/btlcmd.inc"

    .data

// What Soundproof's script says, but about whichever Pokemon the C left in
// battlerIdTemp rather than about the target. Sweet Veil and the three
// priority-blocking abilities all cover their ally as well as themselves, so
// the one that refuses the move is not always the one it was aimed at.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    // {0}’s {1} blocks {2}!
    PrintMessage msg_0197_00689, TAG_NICKNAME_ABILITY_MOVE, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    End
