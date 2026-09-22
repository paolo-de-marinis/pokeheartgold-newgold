    .include "macros/btlcmd.inc"

    .data

// Every Room Service on the field answers Trick Room being put up: one stage
// of Speed off its holder, and the item is gone. The whole field is walked in
// Speed order because Trick Room turns them all over at once, which is also
// why the Trick Room move and the send-out check both hand the job to this one
// script rather than to a per-battler copy of it.
//
// The drop goes through BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE as a held item's,
// so what refuses it -- Mist, a Clear Body, a Clear Amulet -- is read there
// rather than here. The item goes either way, which is what the reference's
// script does. The two batching flags are put back afterwards so the next
// holder still gets its own animation.

_start:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 0

_loop:
    GetMonBySpeedOrder BSCRIPT_VAR_BATTLER_STAT_CHANGE
    GetItemHoldEffect BATTLER_CATEGORY_SIDE_EFFECT_MON, BSCRIPT_VAR_TEMP_DATA
    CompareVarToValue OPCODE_NEQ, BSCRIPT_VAR_TEMP_DATA, HOLD_EFFECT_DROP_SPEED_IN_TRICK_ROOM, _continue
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP
    PlayBattleAnimation BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_HELD_ITEM
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    RemoveItem BATTLER_CATEGORY_SIDE_EFFECT_MON

_continue:
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_BATTLER_SPEED_TEMP, 1
    GoToIfValidMon BSCRIPT_VAR_BATTLER_SPEED_TEMP, _loop
    End
