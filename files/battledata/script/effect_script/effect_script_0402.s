    .include "macros/btlcmd.inc"

    .data

// The reference runs Throat Chop as a plain hit under Sheer Force or behind the
// target's Covert Cloak, so neither lets the silence be set.
_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_SHEER_FORCE, _DAMAGE
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, HOLD_EFFECT_PREVENT_SECONDARY_EFFECTS, _DAMAGE
    SetMoveConditionFlag MOVE_THROAT_CHOP, BATTLER_CATEGORY_DEFENDER

_DAMAGE:
    CalcCrit 
    CalcDamage 
    End 
    
