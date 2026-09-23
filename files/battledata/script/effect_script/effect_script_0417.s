    .include "macros/btlcmd.inc"

    .data

// Speed Swap trades the user's Speed for the target's once the move has got
// through Protect (Pokemon Central, Velociscambio): subscript 441, as Power
// Split's side effect runs its own.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_SPEED_SWAP
    End
