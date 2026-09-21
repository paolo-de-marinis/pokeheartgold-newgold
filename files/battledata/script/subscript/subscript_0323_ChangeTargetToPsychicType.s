    .include "macros/btlcmd.inc"

    .data

// Called by Magic Powder.
_Start:
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    HandleMagicPowder 0
    // {0} transformed into the Psychic type!
    PrintMessage 1585, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
