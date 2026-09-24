    .include "macros/btlcmd.inc"

    .data

// Sky Drop (Pokemon Central, Cadutalibera), two turns. The first lifts the
// target: the move fails on an ally, on a Pokemon behind a substitute or
// already in the air or underground, and says a Pokemon of 200 kg or more is
// too heavy; otherwise it is a charge turn -- no accuracy, no damage -- whose
// lift a guard still stops, and subscript 470 takes both into the sky once
// it has got through. The second drops the target, which comes down before
// the hit so that this turn's accuracy is the move's only one; a Flying type
// takes nothing (CalcTypeEffectiveness). SetMoveConditionFlag does the three
// steps, told apart by the user's lock.
_000:
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_STATUS2, STATUS2_LOCKED_INTO_MOVE, _DROP
    SetMoveConditionFlag MOVE_SKY_DROP, BATTLER_CATEGORY_DEFENDER
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0, _FAIL
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 2, _TOO_HEAVY
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_SKY_DROP_LIFT
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE|BATTLE_STATUS_CHARGE_TURN
    End

_FAIL:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End

_TOO_HEAVY:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    // {0} is too heavy to be lifted!
    PrintMessage msg_0197_01939, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End

_DROP:
    SetMoveConditionFlag MOVE_SKY_DROP, BATTLER_CATEGORY_DEFENDER
    CalcCrit
    CalcDamage
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SEMI_INVULNERABLE
    Call BATTLE_SUBSCRIPT_CHARGE_MOVE_CLEANUP
    End
