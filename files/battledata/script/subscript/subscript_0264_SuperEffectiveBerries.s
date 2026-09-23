    .include "macros/btlcmd.inc"

    .data

// A type-resist Berry. The final modifier has taken the half already and
// left its mark on the target (ResistBerryModifier), the reference's 6.9.13;
// what is left is to eat the Berry and say so, before the health bar moves.
// Cheek Pouch answers the Berry as it does any other, once the hit is over
// and if the holder still stands (the reference's subscript 412 calls its
// Cheek Pouch subscript unless the hit fainted it).
_000:
    CompareVarToVar OPCODE_NEQ, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET, _END
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_DEFENDER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_RESIST_BERRY, _END
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_DEFENDER_SELF_TURN_STATUS_FLAGS, SELF_TURN_FLAG_RESIST_BERRY
    PlayBattleAnimation BATTLER_CATEGORY_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    // The {1} weakened the damage to {0}!
    PrintMessage msg_0197_01527, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait 
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_MSG_TEMP
    CheckAbility CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_MSG_TEMP, ABILITY_CHEEK_POUCH, _END
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_TEMP, BMON_DATA_CHEEK_POUCH_PENDING, 1

_END:
    End 
