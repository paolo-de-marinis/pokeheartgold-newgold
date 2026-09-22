    .include "macros/btlcmd.inc"

    .data

_000:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    HandleForestsCurse 0
    // Grass type was added to {0}!
    PrintMessage msg_0197_01390, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
