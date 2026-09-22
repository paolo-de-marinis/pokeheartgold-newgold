    .include "macros/btlcmd.inc"

    .data

// Transform without a move behind it. The animation is asked for by the move
// held in the temporary slot, because nothing is being used and moveNoCur
// belongs to whatever turn this entry happened in the middle of.
//
// The ability has to be copied by hand: Transform copies only the front of
// the record, which stops well short of it, and until this runs the copier
// is still holding the Imposter the popup needed.
_000:
    PlayMoveAnimation BATTLER_NONE
    Wait
    Transform
    // {0} transformed into {1}!
    PrintMessage msg_0197_00345, TAG_NICKNAME_POKE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    UpdateMonDataFromVar OPCODE_GET, BATTLER_CATEGORY_DEFENDER, BMON_DATA_ABILITY, BSCRIPT_VAR_TEMP_DATA
    UpdateMonDataFromVar OPCODE_SET, BATTLER_CATEGORY_ATTACKER, BMON_DATA_ABILITY, BSCRIPT_VAR_TEMP_DATA
    UpdateVar OPCODE_FLAG_OFF, BSCRIPT_VAR_BATTLE_STATUS, BATTLE_STATUS_MOVE_ANIMATIONS_OFF
    // Give the turn back the two battlers it was working with.
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_BATTLER_ATTACKER_TEMP
    UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_TARGET_TEMP
    End
