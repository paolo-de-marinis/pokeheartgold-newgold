    .include "macros/btlcmd.inc"

    .data

// Bolt Beak and Fishious Rend: twice the power unless the target has already
// had its turn. The reference asks that as a turn order question in C; this
// engine marks a battler that has acted in its action slot, which is what
// IfMovedThisTurn and Payback both read.
_000:
    IfMovedThisTurn BATTLER_CATEGORY_DEFENDER, _HIT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 20

_HIT:
    CalcCrit 
    CalcDamage 
    End 
