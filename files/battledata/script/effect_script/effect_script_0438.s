    .include "macros/btlcmd.inc"

    .data

// Court Change swaps the screens, Mist, Safeguard, Tailwind and the entry
// hazards of the two sides (Pokemon Central, Cambiocampo); SetMoveConditionFlag
// does the swapping. It is the field's: Protect and Magic Coat have nothing to
// do with it.
_000:
    SetMoveConditionFlag MOVE_COURT_CHANGE, BATTLER_CATEGORY_ATTACKER
    // {0} swapped the battle effects affecting each side of the field!
    BufferMessage msg_0197_01876, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    End
