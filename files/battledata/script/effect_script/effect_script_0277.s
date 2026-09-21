    .include "macros/btlcmd.inc"

    .data

// Acrobatics: twice the power with nothing in hand.
_000:
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE, _HELD
    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 20

_HELD:
    CalcCrit 
    CalcDamage 
    End 
