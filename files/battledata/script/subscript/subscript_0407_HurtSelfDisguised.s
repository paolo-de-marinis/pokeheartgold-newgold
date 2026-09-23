    .include "macros/btlcmd.inc"

    .data

// A confused Pokemon hit itself, and its Disguise or Ice Face took the blow:
// the end of the reference's subscript 39 when its CalcConfusionDamage breaks
// the face. The form has changed by the time this runs.
_000:
    // {0} is confused!
    PrintMessage msg_0197_00150, TAG_NICKNAME, BATTLER_CATEGORY_ATTACKER
    Wait 
    WaitButtonABTime 30
    PlayBattleAnimation BATTLER_CATEGORY_ATTACKER, BATTLE_ANIMATION_CONFUSED
    Wait 
    // It hurt itself in its confusion!
    PrintMessage msg_0197_00797, TAG_NONE
    Wait 
    WaitButtonABTime 30
    UnlockMoveChoice BATTLER_CATEGORY_ATTACKER
    Call BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE
    Call BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE
    End 
