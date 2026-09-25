    .include "macros/btlcmd.inc"

    .data

// Solar Beam's and Shadow Force's first turn (TryChargeTurn, which buffers the
// charge line and marks Shadow Force's user). The attack message first, as
// the engine's subscripts 422 and 426 say it; then the charge as retail's
// scripts had it -- subscript 13 as the side effect, which plays the charge,
// says the line and locks the user in -- or, with a Power Herb, the charge
// and the herb spent at once (subscript 217) and the effect script's hit,
// which a locked user goes to.
_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, HOLD_EFFECT_CHARGE_SKIP, _POWER_HERB
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_VANISH_CHARGE_TURN
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE|BATTLE_STATUS_CHARGE_TURN
    End

_POWER_HERB:
    Call BATTLE_SUBSCRIPT_ITEM_SKIP_CHARGE_TURN
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_BATTLER_TARGET, BATTLER_NONE, _NO_TARGET
    LockMoveChoice BATTLER_CATEGORY_ATTACKER
    GoToEffectScript

_NO_TARGET:
    UpdateMonData OPCODE_FLAG_OFF, BATTLER_CATEGORY_ATTACKER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_SEMI_INVULNERABLE
    Call BATTLE_SUBSCRIPT_CHARGE_MOVE_CLEANUP
    End
