    .include "macros/btlcmd.inc"

    .data

// Belch. Nothing comes back up that did not go down first, so the move is
// only there to be used once this Pokemon has eaten a Berry in this battle.
//
// The reference refuses it twice over: once at the move menu, which is the
// half its own build compiles, and once on the way out, which is the half
// behind its Champions switch. This game keeps both -- the menu will not
// offer Belch, and the line below is what catches it when Sleep Talk or a
// called move reaches it anyway. The failure does not announce the move
// first: that is the reference's, which prints this instead of "used Belch!"
// rather than after it.
_000:
    CompareMonDataToValue OPCODE_EQU, BATTLER_CATEGORY_ATTACKER, BMON_DATA_BERRY_EATEN, 0, _NothingToBringUp
    CalcCrit 
    CalcDamage 
    End 

_NothingToBringUp:
    // {0} hasn’t eaten any held Berries, so it can’t possibly belch!
    PrintMessage msg_0197_01348, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End 
