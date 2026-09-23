    .include "macros/btlcmd.inc"

    .data

// Coaching. The reference fails it before it runs in a single battle, or when
// the user has no partner standing to coach (BattleController_BeforeMove.c:
// 4618); the rest of its failures are the stat-stage subscript's.
_000:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER
    CompareMonDataToValue OPCODE_EQU, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_COACHING
    End 

_NO_PARTNER:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
