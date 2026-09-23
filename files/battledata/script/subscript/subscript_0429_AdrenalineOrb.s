    .include "macros/btlcmd.inc"

    .data

// Intimidate reaching a Pokemon that holds an Adrenaline Orb. The reference
// leaves the orb unread; this is Pokemon Central's (Fifasfera): the Attack
// drop is tried as for anyone else, then the orb raises the holder's Speed a
// stage and is spent -- also when an ability kept the Attack where it was, but
// not when the Attack was already as low as it goes (or, with Contrary, as
// high), so that Intimidate failed outright, and not when the Speed has no
// room left. The Intimidate subscript has the holder as SIDE_EFFECT_MON, the
// drop set up in SIDE_EFFECT_PARAM and TYPE, and the Intimidator as ATTACKER.

_000:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SIDE_EFFECT_MON, ABILITY_CONTRARY, _contrary
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_ATK, 0, _intimidateOnly
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_SPEED, 12, _intimidateOnly
    GoTo _orb

_contrary:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_ATK, 12, _intimidateOnly
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_STAT_CHANGE_SPEED, 0, _intimidateOnly

_orb:
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    // The Speed gets its own animation, as Room Service's holders each do.
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UPDATE_STAT_STAGES
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_STAT_STAGE_CHANGE_SHOWN
    // "The {item} raised {0}'s Speed!", and the orb is gone.
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_STAT_CHANGE
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP
    UpdateVar OPCODE_SET, BSCRIPT_VAR_MESSAGE, STAT_SPEED
    Call BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT
    // The Intimidator is still the one the rest of the entry reads.
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER
    End 

_intimidateOnly:
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End 
