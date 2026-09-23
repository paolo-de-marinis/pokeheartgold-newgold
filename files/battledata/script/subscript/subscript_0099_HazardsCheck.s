    .include "macros/btlcmd.inc"

    .data

_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, ABILITY_MAGIC_GUARD, _105
    // Only the Pokemon on the ground meets the spikes and the web: the battle's
    // own test (BattlerIsGrounded), so an Air Balloon, Eelevate or a
    // Baton-passed Ingrain answers here as everywhere else.
    GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON, _037
    GoTo _085

_037:
    CheckToxicSpikes BATTLER_CATEGORY_SWITCHED_MON, _065
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0x00000002, _063
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0x00000001, _059
    // The poison spikes disappeared from around your team’s feet!
    PrintMessage msg_0197_01065, TAG_NONE_SIDE, BATTLER_CATEGORY_SWITCHED_MON
    Wait 
    WaitButtonABTime 30
    GoTo _065

_059:
    // Heavy-Duty Boots. The reference guards the poisoning and not the
    // absorbing above it, so a grounded Poison type in boots still soaks the
    // spikes up, and it jumps clear to the end of the script rather than on to
    // the next hazard -- which costs nothing, since the boots turn away every
    // hazard left below.
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _105
    Call BATTLE_SUBSCRIPT_POISON
    GoTo _065

_063:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _105
    Call BATTLE_SUBSCRIPT_BADLY_POISON

_065:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _SPIKES
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_SWITCH
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE, SIDE_CONDITION_STICKY_WEB, _SPIKES
    // Mirror Armor sends a stat drop back where it came from, and a web has
    // nowhere to send it, so the mon simply keeps its Speed.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, ABILITY_MIRROR_ARMOR, _SPIKES
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE

_SPIKES:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _085
    CheckSpikes BATTLER_CATEGORY_SWITCHED_MON, _085
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_SWITCH
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hurt by the spikes!
    PrintMessage msg_0197_00429, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON
    Wait 
    WaitButtonABTime 30

_085:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _105
    CheckStealthRock BATTLER_CATEGORY_SWITCHED_MON, _105
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_SWITCH
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // Pointed stones dug into {0}!
    PrintMessage msg_0197_01079, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON
    Wait 
    WaitButtonABTime 30

_105:
    End 
