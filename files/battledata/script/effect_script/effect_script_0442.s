    .include "macros/btlcmd.inc"

    .data

// Instruct has its target use its last move again straight away (Pokemon
// Central, Imposizione): subscript 460, once the move has reached it.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_INSTRUCT
    End
