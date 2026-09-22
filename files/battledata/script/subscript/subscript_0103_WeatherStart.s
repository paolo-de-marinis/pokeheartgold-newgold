    .include "macros/btlcmd.inc"

    .data

// Every weather a move starts comes through here to have its message shown, so
// this is where Protosynthesis is told the sky has changed: cleared for anyone
// it had switched on, then offered the new sky. Only one of the two ever does
// anything -- ActivateParadoxAbility asks whether the sun is out, and
// ResetParadoxAbility asks whether anyone is boosted.
//
// The reference has a copy of this pair in each weather's own subscript
// instead, because it moved every weather's flag-setting out of the effect
// scripts. This game still sets those flags in the effect script, and this is
// the one place all four weathers meet.

_000:
    Call BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE
    ResetParadoxAbility ABILITY_PROTOSYNTHESIS
    ActivateParadoxAbility ABILITY_PROTOSYNTHESIS
    End
