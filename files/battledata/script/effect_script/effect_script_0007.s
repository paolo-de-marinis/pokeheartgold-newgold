    .include "macros/btlcmd.inc"

    .data

// Self-Destruct, Explosion and Misty Explosion. The user is at 0 HP from
// here on, as the reference's before-move step puts it, but its bar stays
// full until the move has done its damage: subscript 277 empties it and
// faints the user once the move is over, as the reference's post-move step
// 11.0 does. From the sixth generation the damage comes before the user
// faints (Pokemon Central, Esplosione); retail emptied the bar first.
_000:
    CheckIgnorableAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ALL, ABILITY_DAMP, _038
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_SELFDESTRUCTED, _035
    UpdateVar OPCODE_SET, BSCRIPT_VAR_CALC_TEMP, 0x10000000
    UpdateVarFromVar OPCODE_LEFT_SHIFT, BSCRIPT_VAR_CALC_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BSCRIPT_VAR_CALC_TEMP
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HP, 0

_035:
    CalcCrit 
    CalcDamage 
    End 

_038:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    // {0}’s {1} prevents {2} from using {3}!
    PrintMessage msg_0197_00628, TAG_NICKNAME_ABILITY_NICKNAME_MOVE, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ABILITY_MON, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_CHECK_LOOP_ONLY_ONCE
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End 
