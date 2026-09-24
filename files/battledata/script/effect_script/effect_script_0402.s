    .include "macros/btlcmd.inc"

    .data

// Throat Chop silences its target only when it hits, as an added effect
// (Pokemon Central, Colpo Infernale): the side effect's roll is what Sheer
// Force, Shield Dust and the Covert Cloak stop. The reference sets the
// silence here, before the accuracy check, so a miss silenced too.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_THROAT_CHOP
    CalcCrit
    CalcDamage
    End
