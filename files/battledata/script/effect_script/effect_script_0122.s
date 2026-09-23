    .include "macros/btlcmd.inc"

    .data

// Present. With Parental Bond it strikes twice when it wounds, at the power of
// the first roll, and once when it heals (the reference's script; Pokemon
// Central, Amorefiliale), which is why the move is on the single-strike list
// and asks for the ability itself.
_000:
    GotoIfSecondHitOfParentalBond _SECOND_STRIKE
    Present _004
    CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_PARENTAL_BOND, _DAMAGE
    SetParentalBondFlag 

_SECOND_STRIKE:
    SetMultiHit 2, MULTIHIT_MULTI_HIT_MOVE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE, AFTER_MOVE_MESSAGE_MULTI_HIT

_DAMAGE:
    CalcCrit 
    CalcDamage 
    End 

_004:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRESENT_HEAL
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_IGNORE_TYPE_IMMUNITY
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MOVE_EFFECT_CHANCE, 1
    End 
