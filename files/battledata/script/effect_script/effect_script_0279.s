    .include "macros/btlcmd.inc"

    .data

// Hex: twice the damage against a Pokemon that is already suffering from
// something. Facade asks the same question of the attacker.
_000:
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_ALL, _HEALTHY
    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 20

_HEALTHY:
    CalcCrit 
    CalcDamage 
    End 
