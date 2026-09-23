    .include "macros/btlcmd.inc"

    .data

// Mortal Spin: the poison its hit gives, then Rapid Spin's clearing of the
// user's side. The reference poisons through the move's side effect and runs
// Rapid Spin's subscript after the move whenever the user is standing
// (ServerDoPostMoveEffects.c:1166-1175); its own subscript 444 is this pair,
// unused there. Here the one side effect runs both, after every hit that
// did not fail, so the target is asked about first: a fainted one is not
// poisoned, and the poison subscript turns a substitute away itself.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HP, 0, _SPIN
    Call BATTLE_SUBSCRIPT_POISON

_SPIN:
    RapidSpin
    End
