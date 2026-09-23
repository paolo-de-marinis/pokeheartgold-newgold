    .include "macros/btlcmd.inc"

    .data

// Dragon Cheer raises the critical-hit ratio of the user's ally, by two stages
// for a Dragon-type, and fails with no ally standing (Pokemon Central, Grido
// del Drago), as Aromatic Mist does (effect script 409). Subscript 455 does
// the cheering and refuses an ally already cheered or pumped.
_000:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER
    CompareMonDataToValue OPCODE_EQU, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_DRAGON_CHEER
    End

_NO_PARTNER:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
