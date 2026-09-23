    .include "macros/btlcmd.inc"

    .data

// Costar copying its ally's stat changes on the way in. The reference gives
// the ability no effect and no script; the line is Psych Up's, which says
// the same thing, and the stages are already copied by the time this runs.

_000:
    WaitButtonABTime 15
    // {0} copied {1}’s stat changes!
    PrintMessage msg_0197_00452, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
