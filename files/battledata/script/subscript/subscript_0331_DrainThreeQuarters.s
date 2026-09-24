    .include "macros/btlcmd.inc"

    .data

Start:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_HIT_DAMAGE
    CompareVarToValue OPCODE_GT, BSCRIPT_VAR_HP_CALC, -1, EndScript
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, 3
    // Three quarters of the damage, rounded to the nearest and a half up
    // (Showdown's gen-9 drain rounds): the damage is negative here, and the
    // division rounds towards zero, and at least 1.
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_HP_CALC, -2
    DivideVarByValue BSCRIPT_VAR_HP_CALC, 4

CheckLeechBoost:
    CheckItemHoldEffect CHECK_OPCODE_NOT_HAVE, BATTLER_CATEGORY_ATTACKER, HOLD_EFFECT_LEECH_BOOST, DrainHealth
    GetItemEffectParam BATTLER_CATEGORY_ATTACKER, BSCRIPT_VAR_CALC_TEMP
    UpdateVar OPCODE_ADD, BSCRIPT_VAR_CALC_TEMP, 0x00000064
    UpdateVarFromVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, BSCRIPT_VAR_CALC_TEMP
    UpdateVar OPCODE_DIV, BSCRIPT_VAR_HP_CALC, 100

DrainHealth:
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_LIQUID_OOZE, DamageInstead
    UpdateVar OPCODE_MUL, BSCRIPT_VAR_HP_CALC, -1
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} had its energy drained!
    PrintMessage msg_0197_00082, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    End 

DamageInstead:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_ATTACKER, ABILITY_MAGIC_GUARD, EndScript
    AbilityPopup BATTLER_CATEGORY_DEFENDER, -1
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // It sucked up the liquid ooze!
    PrintMessage msg_0197_00720, TAG_NONE
    Wait 
    WaitButtonABTime 30

EndScript:
    End 
