    .include "macros/btlcmd.inc"

    .data

// Hex: twice the damage against a Pokemon that is already suffering from
// something. Facade asks the same question of the attacker. A Comatose
// Pokemon counts as asleep, read raw, as the reference's
// effect_script_0287_DOUBLE_DAMAGE_ON_STATUS.s has it.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, ABILITY_COMATOSE, _SUFFERING
    CompareMonDataToValue OPCODE_FLAG_NOT, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_ALL, _HEALTHY

_SUFFERING:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_POWER_MULTI, 20

_HEALTHY:
    CalcCrit 
    CalcDamage 
    End 
