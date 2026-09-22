    .include "macros/btlcmd.inc"

    .data

// Putting Trick Room up says so itself and then lets every Room Service on
// the field answer it. Taking it back down is the branch below and answers
// nothing, so it still buffers its line and leaves the printing to the move's
// own side effect.
//
// The line for putting it up is printed here rather than buffered, which is
// the reference's own arrangement of this script and the reason it can run the
// Room Services afterwards: a buffered line would not be read out until after
// this script had finished, and the Speed drops would be announced before the
// dimensions they answer to.

_000:
    CompareVarToValue OPCODE_FLAG_SET, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_TRICK_ROOM, _014
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_TRICK_ROOM_INIT
    // {0} twisted the dimensions!
    PrintMessage msg_0197_01070, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait
    WaitButtonABTime 30
    TrickRoom
    Call BATTLE_SUBSCRIPT_ROOM_SERVICE
    End

_014:
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_FIELD_CONDITION, FIELD_CONDITION_TRICK_ROOM
    // {0} restored the twisted dimensions!
    BufferMessage msg_0197_01073, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER

_022:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    TrickRoom 
    End 
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End 
