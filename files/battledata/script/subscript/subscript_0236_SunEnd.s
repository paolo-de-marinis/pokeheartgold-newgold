    .include "macros/btlcmd.inc"

    .data

_000:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_SUN
    // The sunlight faded.
    PrintMessage msg_0197_00809, TAG_NONE
    Wait
    WaitButtonABTime 30
    // The sun has gone, and Protosynthesis with it. The reference also calls
    // the switch-in ability check from here; that is for the weather abilities
    // that re-announce themselves, and is not part of this.
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS
    End
