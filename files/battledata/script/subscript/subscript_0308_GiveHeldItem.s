    .include "macros/btlcmd.inc"

    .data

// Called by Bestow.
_Start:
    // Nothing to give, or a target that holds something already: the move
    // fails (Pokemon Central, Cediregalo; the engine's BattleController_BeforeMove.c
    // at d0380a487 asks it before the move).
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE, _MoveFailed
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, ITEM_NONE, _MoveFailed
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_QUICK_CLAW_FLAG, 0, _MoveFailed
    CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_DEFENDER, BMON_DATA_CUSTAP_FLAG, 0, _MoveFailed
    // Nor can Mail, or an item the user's or the target's species keeps, go
    // (CanTrickHeldItem): Trick's command asks both, and with the target's
    // hand empty the swap it allows is the gift, and the player's Pokemon
    // handing over what it started with has it back when the battle is over,
    // as a tricked one does (NoteHeldItemGiven). Sticky Hold, its other
    // refusal, keeps nothing from Bestow, which takes no item from the target
    // (Showdown's bestow): the second address is the next line, which tells
    // the command not to ask it.
    TrySwapItems _MoveFailed, _Give

_Give:
    // Klutz does not stop it: the ability keeps an item from working, not
    // from changing hands (Bulbapedia's Klutz: Switcheroo works as usual;
    // Showdown's bestow asks nothing of it). The engine's subscript printed
    // "{0}'s Klutz made Bestow ineffective!" and gave nothing.
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    // {0} received {2} from {1}!
    PrintMessage msg_0197_01740, TAG_NICKNAME_NICKNAME_ITEM, BATTLER_CATEGORY_DEFENDER, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    // Cache the attacker's held item.
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_TEMP_DATA
    // Remove the held item from the attacker.
    UpdateMonData OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_HELD_ITEM, ITEM_NONE
    // Set the defender's held item to the cached value.
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_HELD_ITEM, BSCRIPT_VAR_TEMP_DATA
    Wait 
    WaitButtonABTime 30
    End 

_MoveFailed:
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
