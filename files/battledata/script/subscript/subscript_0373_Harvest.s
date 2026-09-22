    .include "macros/btlcmd.inc"

    .data

// The berry goes back into the hand here rather than in C, so the party copy
// goes with it -- the same command Recycle uses for the same job, and the
// same line, because finding a berry again is what both of them do.
_000:
    AbilityPopup BATTLER_CATEGORY_MSG_BATTLER_TEMP, -1
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP
    // {0} found one {1}!
    PrintMessage msg_0197_00589, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
