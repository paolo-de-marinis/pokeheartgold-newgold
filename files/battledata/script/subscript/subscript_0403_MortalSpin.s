    .include "macros/btlcmd.inc"

    .data

// Mortal Spin's clearing of its user's side -- the binding, Leech Seed and the
// entry hazards -- once the move is over (TryAdditionalMoveEffect). The
// reference runs Rapid Spin's subscript there, which is this one command in
// its tree; here subscript 115 raises Rapid Spin's Speed as well. The poison
// is each target's additional effect, effect script 371.
_000:
    RapidSpin
    End
