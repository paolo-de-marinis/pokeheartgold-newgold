    .include "macros/btlcmd.inc"

    .data

_000:
    PrintAttackMessage 
    Wait 
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_HANDLE_SNOW_TEMPORARY
    End 
