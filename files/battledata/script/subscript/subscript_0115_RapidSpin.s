    .include "macros/btlcmd.inc"

    .data

// From Generation VIII Rapid Spin also raises its user's Speed by one. The
// reference makes the raise the move's own side effect (effect script 129) and
// clears the field afterwards, in ServerDoPostMoveEffects.c, when the user is
// still standing. This tree has no such pass, and the clearing is this
// subscript, the move's additional effect (effect script 129), so the raise is
// put here, ahead of the clearing as it is there, and both wait on the user's
// HP as the reference's clearing does. The rise is an indirect one: nothing is
// said at the top. A target with Shield Dust keeps the field as it is
// (Pokemon Central, Rapigiro, Generation IX), unless Mold Breaker ignores it.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _end
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_SHIELD_DUST, _end
    RapidSpin 

_end:
    End 
