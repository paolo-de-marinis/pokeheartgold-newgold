    .include "macros/btlcmd.inc"

    .data

// A Dancer locked into another move -- by a Choice item, an Encore or a
// rampage -- still takes up the dance, and the dance fails (Pokemon Central,
// Sincrodanza): its name, then "But it failed!".
_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_BUT_IT_FAILED
    End 
