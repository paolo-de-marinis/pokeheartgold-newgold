    .include "macros/btlcmd.inc"

    .data

// The ordinary perish count, started by a touch rather than by a song, which
// is why it catches everyone on the field and not only the two involved.
_000:
    WaitButtonABTime 15
    TryPerishSong _030
    // All Pokémon hearing the song will faint in three turns!
    PrintMessage msg_0197_00822, TAG_NONE
    Wait 
    WaitButtonABTime 30

_030:
    End 
