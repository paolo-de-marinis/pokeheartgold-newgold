    .include "macros/btlcmd.inc"

    .data

// Aromatic Mist raises the Sp. Def of the user's ally a stage (Pokemon
// Central, Nebularoma). With no ally to take it -- a single battle, or the
// partner down -- it fails, as Coaching does (effect script 383); an ally
// already at +6 is the stat-stage subscript's to refuse.
_000:
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_BATTLE_TYPE, BATTLE_TYPE_DOUBLES, _NO_PARTNER
    CompareMonDataToValue OPCODE_EQU, BATTLER_RELATIVE_ALLY|BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _NO_PARTNER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SP_DEFENSE_UP_1_STAGE
    End 

_NO_PARTNER:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
