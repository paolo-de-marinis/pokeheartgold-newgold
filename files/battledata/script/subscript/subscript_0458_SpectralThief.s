    .include "macros/btlcmd.inc"

    .data

// Spectral Thief, once it has reached its target and before it strikes: the
// user takes the target's raised stages (SetMoveConditionFlag) and says so,
// and the damage is worked out again with them, the critical hit already
// decided (Pokemon Central, Ombrafurto). The controller runs this from
// command 27, where the move is about to connect.
_000:
    PrintAttackMessage
    Wait
    SetMoveConditionFlag MOVE_SPECTRAL_THIEF, BATTLER_CATEGORY_DEFENDER
    // {0} stole the target's boosted stats!
    PrintMessage msg_0197_01873, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    CalcDamage
    End
