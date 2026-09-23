    .include "macros/btlcmd.inc"

    .data

// Incinerate burns up the Berry the target was holding. The shape is Knock
// Off's, and so are the two guards in front of it: a substitute takes the
// flames instead, and a Berry already being eaten this turn is not there to
// burn. TryIncinerate is the one that knows whether there was a Berry at all
// and whether Sticky Hold kept hold of it; it takes the branch when there is
// nothing to say, and otherwise leaves the burnt Berry and its owner in the
// temporaries for the line below.
//
// The reference runs this from C after the move, off the move number; here it
// is an ordinary on-hit side effect named by the effect script, which is where
// this game keeps that sort of thing.
_000:
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _end
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_CUSTAP_FLAG, 0, _end
    TryIncinerate _end
    // {0}’s {1} was burned up!
    PrintMessage msg_0197_01573, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30

_end:
    End
