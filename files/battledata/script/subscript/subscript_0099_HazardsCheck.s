    .include "macros/btlcmd.inc"

    .data

// The hazards on the side a Pokemon comes out on, one at a time in the order
// they were laid (the queue AddEntryHazardToQueue keeps), as the games do from
// the fifth generation on and the reference's subscript 99 walks them. Each
// hazard's own block ends by going back for the next; JumpToCurrentEntryHazard
// falls through to the end once the queue is spent, which sets the walk back
// to the start for the next Pokemon, so no way out of the walk skips it.
_000:
_NEXT:
    // A Pokemon one hazard has made faint meets no more of them.
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_SWITCHED_MON, BMON_DATA_HP, 0, _DRAIN
    JumpToCurrentEntryHazard BATTLER_CATEGORY_SWITCHED_MON, _SPIKES, _TOXIC_SPIKES, _STEALTH_ROCK, _STICKY_WEB, _NEXT
    End

// Walks the rest of the queue without meeting anything.
_DRAIN:
    JumpToCurrentEntryHazard BATTLER_CATEGORY_SWITCHED_MON, _DRAIN, _DRAIN, _DRAIN, _DRAIN, _DRAIN
    End

// Only the Pokemon on the ground meets the spikes and the web: the battle's
// own test (BattlerIsGrounded).
_TOXIC_SPIKES:
    GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON, _TOXIC_SPIKES_GROUNDED
    GoTo _NEXT

_TOXIC_SPIKES_GROUNDED:
    CheckToxicSpikes BATTLER_CATEGORY_SWITCHED_MON, _NEXT
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0x00000002, _BADLY_POISON
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_CALC_TEMP, 0x00000001, _POISON
    // The poison spikes disappeared from around your team’s feet!
    PrintMessage msg_0197_01065, TAG_NONE_SIDE, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    RemoveEntryHazardFromQueue BATTLER_CATEGORY_SWITCHED_MON, HAZARD_IDX_TOXIC_SPIKES
    GoTo _NEXT

_POISON:
    // Heavy-Duty Boots. The reference guards the poisoning and not the
    // absorbing above it, so a grounded Poison type in boots still soaks the
    // spikes up.
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _NEXT
    Call BATTLE_SUBSCRIPT_POISON
    GoTo _NEXT

_BADLY_POISON:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _NEXT
    Call BATTLE_SUBSCRIPT_BADLY_POISON
    GoTo _NEXT

_STICKY_WEB:
    GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON, _STICKY_WEB_GROUNDED
    GoTo _NEXT

_STICKY_WEB_GROUNDED:
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _NEXT
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_SWITCH
    CompareVarToValue OPCODE_FLAG_NOT, BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE, SIDE_CONDITION_STICKY_WEB, _NEXT
    // Mirror Armor sends a stat drop back where it came from, and a web has
    // nowhere to send it, so the mon simply keeps its Speed.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, ABILITY_MIRROR_ARMOR, _NEXT
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_PARAM, MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    GoTo _NEXT

_SPIKES:
    GotoIfGrounded BATTLER_CATEGORY_SWITCHED_MON, _SPIKES_GROUNDED
    GoTo _NEXT

_SPIKES_GROUNDED:
    // Magic Guard keeps the damage off, the spikes' and the stones'; from the
    // fifth generation it no longer turns the poison spikes and the web away.
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, ABILITY_MAGIC_GUARD, _NEXT
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _NEXT
    CheckSpikes BATTLER_CATEGORY_SWITCHED_MON, _NEXT
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_SWITCH
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} is hurt by the spikes!
    PrintMessage msg_0197_00429, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    GoTo _NEXT

_STEALTH_ROCK:
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, ABILITY_MAGIC_GUARD, _NEXT
    CheckItemHoldEffect CHECK_OPCODE_HAVE, BATTLER_CATEGORY_SWITCHED_MON, HOLD_EFFECT_IGNORE_ENTRY_HAZARDS, _NEXT
    CheckStealthRock BATTLER_CATEGORY_SWITCHED_MON, _NEXT
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_SWITCH
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_NO_BLINK
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // Pointed stones dug into {0}!
    PrintMessage msg_0197_01079, TAG_NICKNAME, BATTLER_CATEGORY_SWITCHED_MON
    Wait
    WaitButtonABTime 30
    GoTo _NEXT
