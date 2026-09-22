    .include "macros/btlcmd.inc"

    .data

// One stat, one ability, one stage. The C picks the stat, the battler and
// whose ability is credited for it; all this adds is the pause every
// post-move ability script begins with. Everything at this site that moves a
// single stat shares it.
_000:
    WaitButtonABTime 15
    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE
    End 
