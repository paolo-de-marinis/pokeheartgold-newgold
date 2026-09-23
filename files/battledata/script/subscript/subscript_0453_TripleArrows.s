    .include "macros/btlcmd.inc"

    .data

// Triple Arrows' two added effects, each rolled on its own: a half chance of
// a stage less Defense and three in ten of a flinch, both doubled by Serene
// Grace (Pokemon Central, Triplodardo). The side effect that brings this
// here is sure, at the record's chance of 100, so that Sheer Force and a
// Covert Cloak take both away as they take any added effect.
_000:
    Random 99, 0
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_SERENE_GRACE, _DEFENSE_SERENE
    CompareVarToValue OPCODE_GT, BSCRIPT_VAR_CALC_TEMP, 49, _FLINCH
    GoTo _DEFENSE

_DEFENSE_SERENE:
    CompareVarToValue OPCODE_GT, BSCRIPT_VAR_CALC_TEMP, 99, _FLINCH

_DEFENSE:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE

_FLINCH:
    Random 99, 0
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_SERENE_GRACE, _FLINCH_SERENE
    CompareVarToValue OPCODE_GT, BSCRIPT_VAR_CALC_TEMP, 29, _END
    GoTo _FLINCH_ROLLED

_FLINCH_SERENE:
    CompareVarToValue OPCODE_GT, BSCRIPT_VAR_CALC_TEMP, 59, _END

_FLINCH_ROLLED:
    Call BATTLE_SUBSCRIPT_FLINCH_MON

_END:
    End
