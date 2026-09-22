    .include "macros/btlcmd.inc"
    .data
// Powder went off: the Fire move's user takes what hpCalc holds, and the move
// is spent.
_000:
    PrintAttackMessage
    Wait
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_BURNED
    Wait
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // When the flame touched the powder on the Pokémon, it exploded!
    PrintMessage msg_0197_01411, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
