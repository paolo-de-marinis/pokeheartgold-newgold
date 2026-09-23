    .include "macros/btlcmd.inc"

    .data

// An Air Balloon says so once, on the way in. The C has already decided that
// the holder is off the ground and has set the flag, so this is the sentence
// and nothing else.
_000:
    // {0} floats in the air with its {1}!
    PrintMessage msg_0197_01370, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
