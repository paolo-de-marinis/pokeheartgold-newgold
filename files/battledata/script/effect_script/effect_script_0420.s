    .include "macros/btlcmd.inc"

    .data

// Steel Beam and Mind Blown cost their user half its maximum HP, rounded up,
// once the move is over, hit or miss, through Protect or a substitute; not
// when there was no target for it, and Magic Guard alone spares it -- Rock
// Head and Reckless have nothing to do with it (Pokemon Central, Raggio
// d'Acciaio, Sbalorditesta). The mark here is what ov12_0224E1BC answers
// after the move: this script runs only for a move that goes off at a target.
// Mind Blown is an explosion, so a Damp on the field stops it before the
// move, and it costs nothing (DampStopsMove in ov12_0224C38C).
_000:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_LOSE_HALF_MAX_HP
    CalcCrit
    CalcDamage
    End
