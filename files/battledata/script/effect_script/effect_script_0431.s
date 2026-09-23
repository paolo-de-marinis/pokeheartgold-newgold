    .include "macros/btlcmd.inc"

    .data

// Eerie Spell hurts and takes three PP from the move its target used last,
// an added effect at the record's chance of 100 that Sheer Force trades for
// power and Shield Dust or a Covert Cloak turns away, and that a fainted
// target does not suffer (Pokemon Central, Inquietantesimo): subscript 454.
// A sound move, it goes round a substitute, and so does its effect.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_EERIE_SPELL
    CalcCrit
    CalcDamage
    End
