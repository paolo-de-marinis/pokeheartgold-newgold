    .include "macros/btlcmd.inc"

    .data

// Electrify, on its hit: the target's move is Electric for the rest of the
// turn (Pokemon Central, Elettrocontagio). BattleMoveTypeForAbility reads the
// mark SetMoveConditionFlag leaves in the target's TurnData.
_000:
    SetMoveConditionFlag MOVE_ELECTRIFY, BATTLER_CATEGORY_DEFENDER
    // {0}'s moves have been electrified!
    PrintMessage msg_0197_01844, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
