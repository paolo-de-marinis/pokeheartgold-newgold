    .include "macros/btlcmd.inc"

    .data

// A Red Card dragging out the Pokemon that hit its holder, once the move is
// over (the reference's subscript_0509_HANDLE_RED_CARD at d0380a487). The
// holder is in MSG_BATTLER_TEMP; CheckSwitchItemOnHit has asked everything
// else and, unless Suction Cups, Guard Dog or Ingrain hold the attacker,
// chosen who comes in. The card is spent either way -- Pokemon Central's
// Cartelrosso; the reference keeps it when the attacker is anchored. The switch commands work
// on the defender, so the attacker and the holder change places for them and
// are put back at the end. Once the attacker has gone, nothing of its own
// answers its move: U-turn's flag says so to the steps after this one.

_000:
    Call BATTLE_SUBSCRIPT_PUSH_ATTACKER_AND_DEFENDER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_MSG_BATTLER_TEMP
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_HELD_ITEM
    Wait 
    // {0} held up its Red Card against {1}!
    PrintMessage msg_0197_01716, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    RemoveItem BATTLER_CATEGORY_ATTACKER
    // A holder with Pickpocket lifts the attacker's item as the card leaves
    // its hands (CheckSwitchItemOnHit says so in TEMP_DATA): the taker is the
    // side-effect battler, the loser the message battler.
    CompareVarToValue OPCODE_EQU, BSCRIPT_VAR_TEMP_DATA, 0, _NO_PICKPOCKET
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_ABILITY_TAKES_ITEM
_NO_PICKPOCKET:
    // Against a Pokemon Commander holds on the field the card is spent and
    // does nothing (Pokemon Central, Torre di Comando).
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_COMMANDER, 0, _END
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_SUCTION_CUPS, _SUCTION_CUPS
    CheckAbility CHECK_OPCODE_HAVE, BATTLER_CATEGORY_DEFENDER, ABILITY_GUARD_DOG, _SUCTION_CUPS
    CompareMonDataToValue OPCODE_FLAG_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_MOVE_EFFECT, MOVE_EFFECT_FLAG_INGRAIN, _INGRAIN
    TryRestoreStatusOnSwitch BATTLER_CATEGORY_DEFENDER, _DRAG_OUT
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_STATUS, STATUS_NONE

_DRAG_OUT:
    DeletePokemon BATTLER_CATEGORY_DEFENDER
    Wait 
    HealthbarSlideOut BATTLER_CATEGORY_DEFENDER
    Wait 
    SwitchAndUpdateMon BATTLER_CATEGORY_FORCED_OUT
    Wait 
    PokemonSendOut BATTLER_CATEGORY_DEFENDER
    WaitTime 72
    HealthbarSlideIn BATTLER_CATEGORY_DEFENDER
    Wait 
    // {0} was dragged out!
    PrintMessage msg_0197_00603, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait 
    WaitButtonABTime 30
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_BATTLER_TARGET
    Call BATTLE_SUBSCRIPT_HAZARDS_CHECK
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN
    GoTo _END

// Suction Cups or Guard Dog, named by the line.
_SUCTION_CUPS:
    // {0} anchors itself with {1}!
    PrintMessage msg_0197_00659, TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_DEFENDER
    GoTo _ANCHORED

_INGRAIN:
    // {0} anchored itself with its roots!
    PrintMessage msg_0197_00542, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER

_ANCHORED:
    Wait 
    WaitButtonABTime 30

_END:
    Call BATTLE_SUBSCRIPT_POP_ATTACKER_AND_DEFENDER
    End 
