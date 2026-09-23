    .include "macros/btlcmd.inc"

    .data

// Stuff Cheeks. The reference fails it before it runs when the user holds no
// berry (BattleController_BeforeMove.c:1939, its IS_ITEM_BERRY: Cheri to Rowap,
// and Roseli to Maranga), so nothing else it holds is eaten.
_000:
    CompareMonDataToValue OPCODE_LTE, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, FIRST_BERRY_IDX - 1, _NO_BERRY
    CompareMonDataToValue OPCODE_LTE, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, LAST_BERRY_IDX, _BERRY
    CompareMonDataToValue OPCODE_LTE, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_ROSELI_BERRY - 1, _NO_BERRY
    CompareMonDataToValue OPCODE_GT, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_MARANGA_BERRY, _NO_BERRY

_BERRY:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_ATTACKER|MOVE_SUBSCRIPT_PTR_STUFF_CHEEKS
    End 

_NO_BERRY:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
