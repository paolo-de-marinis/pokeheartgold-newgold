    .include "macros/btlcmd.inc"

    .data

// Corrosive Gas melts the held item of every Pokemon next to its user, once
// it has got through Protect (Pokemon Central, Gas Corrosivo): subscript 456,
// once for each target the move goes on to.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_CORROSIVE_GAS
    End
