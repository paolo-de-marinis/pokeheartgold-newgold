    .include "macros/btlcmd.inc"

    .data

// Tera Shift: a Terapagos coming in has become its Terastal Form by the time
// this runs, and hpCalc holds what its maximum HP grew by, which the update
// gives it too, as Power Construct's does. The reference names the ability
// and has no script for it.
_000:
    // {0} transformed!
    Call BATTLE_SUBSCRIPT_FORM_CHANGE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    Wait
    End
