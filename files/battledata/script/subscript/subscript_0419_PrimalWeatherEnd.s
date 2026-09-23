    .include "macros/btlcmd.inc"

    .data

// No Pokemon on the field keeps the strong weather up any more: it ends, and
// no other weather comes back in its place. The reference's subscripts 368 and
// 369, which it runs only on a switch and a faint.
_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_HEAVY_RAIN, _HeavyRain
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_STRONG_WINDS, _StrongWinds
    // The harsh sunlight faded.
    PrintMessage msg_0197_01444, TAG_NONE
    GoTo _Ended

_HeavyRain:
    // The heavy rain has lifted!
    PrintMessage msg_0197_01448, TAG_NONE
    GoTo _Ended

_StrongWinds:
    // The mysterious strong winds have dissipated!
    PrintMessage msg_0197_01452, TAG_NONE

_Ended:
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_WEATHER
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS
    End
