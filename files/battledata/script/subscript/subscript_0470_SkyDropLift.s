    .include "macros/btlcmd.inc"

    .data

// Sky Drop's first turn, once the move has got through to its target
// (effect script 445): the user takes it into the sky, both out of sight and
// out of reach, the user locked into the drop and the target held until then
// (Pokemon Central, Cadutalibera).
_000:
    PrintAttackMessage
    Wait
    PlayMoveAnimation BATTLER_CATEGORY_ATTACKER
    Wait
    LockMoveChoice BATTLER_CATEGORY_ATTACKER
    SetMoveConditionFlag MOVE_SKY_DROP, BATTLER_CATEGORY_DEFENDER
    ToggleVanish BATTLER_CATEGORY_ATTACKER, TRUE
    ToggleVanish BATTLER_CATEGORY_DEFENDER, TRUE
    // {0} took {1} into the sky!
    PrintMessage msg_0197_01932, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
