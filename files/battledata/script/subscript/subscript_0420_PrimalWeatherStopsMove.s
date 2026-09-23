    .include "macros/btlcmd.inc"

    .data

// A damaging Water move in extremely harsh sunlight, or a Fire move in heavy
// rain, used and spent for nothing: the reference's subscripts 370 and 371 in
// one, the weather telling which.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HEAVY_RAIN, _HeavyRain
    // The Water-type attack evaporated in the harsh sunlight!
    PrintMessage msg_0197_01443, TAG_NONE
    GoTo _End

_HeavyRain:
    // The Fire-type attack fizzled out in the heavy rain!
    PrintMessage msg_0197_01447, TAG_NONE

_End:
    Wait
    WaitButtonABTime 30
    End
