    .include "macros/btlcmd.inc"

    .data

// The Psychic Terrain turns away a move that was going to arrive early. The C
// has already decided that -- see BattleContext_CheckMoveImmunityFromAbility --
// so all that is left is to say so.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    // {0} is protected by the Psychic Terrain!
    PrintMessage msg_0197_01471, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
