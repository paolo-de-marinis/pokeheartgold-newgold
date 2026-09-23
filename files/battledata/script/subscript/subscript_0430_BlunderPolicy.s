    .include "macros/btlcmd.inc"

    .data

// A move that missed on the accuracy roll, and a Blunder Policy on the one who
// used it: the miss is told as ever, then the policy sharply raises its
// holder's Speed and is spent. ov12_0224C5F8 has already asked whether the
// miss was the roll's and whether the Speed has room; the reference has no
// script for it, this follows Pokemon Central (Fiascopolizza). The raise goes
// through BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE as a held item's two stages --
// "The Blunder Policy sharply raised {0}'s Speed!" -- so Contrary turns it
// into a drop there.

_000:
    Call BATTLE_SUBSCRIPT_MISSED
    // A crash on the miss can have taken the holder down with it.
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0, _end
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_HELD_ITEM
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_UP_2_STAGES
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    RemoveItem BATTLER_CATEGORY_ATTACKER

_end:
    End 
