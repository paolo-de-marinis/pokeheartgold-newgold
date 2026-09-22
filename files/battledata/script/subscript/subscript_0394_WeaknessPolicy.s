    .include "macros/btlcmd.inc"

    .data

// Two stages of Attack and two of Sp. Atk, then the policy is spent. Both
// raises go through BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE as a held item's, so
// each prints the bank's own item-credited sentence and the Contrary flip and
// the ceiling are read once, in the stat change command, rather than twice
// here. A stat with no room left says so and comes back; the other is still
// tried and the item still goes, which is what the reference's script does.
_000:
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_HELD_ITEM
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_MSG_BATTLER_TEMP
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_2_STAGES
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    RemoveItem BATTLER_CATEGORY_MSG_TEMP
    End
