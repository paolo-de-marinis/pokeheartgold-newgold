    .include "macros/btlcmd.inc"

    .data

// An Eject Button or an Eject Pack sending its holder back once the move is
// over (the reference's subscript_0340_HANDLE_SWITCHING_ITEMS at d0380a487,
// which is both). The holder is in MSG_BATTLER_TEMP; CheckSwitchItemOnHit or
// CheckEjectPack has asked everything else. With nobody to come in nothing
// happens and the item stays. The rest
// is the tail of the pivot moves' subscript, 175, for a Pokemon that is not
// the attacker: Pursuit has its chance, Natural Cure its say, and the holder's
// trainer chooses who comes in.

_000:
    TryReplaceFaintedMon BATTLER_CATEGORY_MSG_BATTLER_TEMP, TRUE, _end
    PlayBattleAnimation BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_HELD_ITEM, ITEM_EJECT_PACK, _EJECT_PACK
    // {0} is switched out with the Eject Button!
    PrintMessage msg_0197_01622, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP
    GoTo _SWITCHED

_EJECT_PACK:
    // {0} is switched out by the Eject Pack!
    PrintMessage msg_0197_01625, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP

_SWITCHED:
    Wait 
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_MSG_BATTLER_TEMP
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_MSG_BATTLER_TEMP
    Call BATTLE_SUBSCRIPT_PURSUIT
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_HP, 0, _end
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_MSG_BATTLER_TEMP, _SWITCH_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BMON_DATA_STATUS, STATUS_NONE

_SWITCH_OUT:
    DeletePokemon BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait 
    HealthbarSlideOut BATTLER_CATEGORY_MSG_BATTLER_TEMP
    Wait 
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_end:
    End 
