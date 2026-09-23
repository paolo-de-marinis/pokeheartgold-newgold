    .include "macros/btlcmd.inc"

    .data

// Corrosive Gas on one of its targets: the held item is melted away for the
// rest of the battle, as Knock Off's is knocked off, with its own line;
// Sticky Hold keeps it, and so does a substitute, and the items that make a
// Pokemon what it is cannot go (Pokemon Central, Gas Corrosivo). Knock Off's
// subscript (142) asks the same.
_000:
    CheckSubstitute BATTLER_CATEGORY_DEFENDER, _END
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_QUICK_CLAW_FLAG, 0, _END
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_CUSTAP_FLAG, 0, _END
    TryKnockOff _END
    PrintBufferedMessage
    Wait
    WaitButtonABTime 30

_END:
    End
