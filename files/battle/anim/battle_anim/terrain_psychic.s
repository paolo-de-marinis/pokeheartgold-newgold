    .include "macros/btlanim.inc"

    .data

// Psychic Terrain's start, BATTLE_ANIMATION_PSYCHIC_TERRAIN: Psychic's
// waves, its background of its own scrolled in waves behind both Pokemon,
// then the battle's background back.
_000:
    ChangeBackground 52, 0x800001
    WaitBackgroundShown
    WaveBackground 50
    WaitBackgroundChanged
    RepeatSE SEQ_SE_DP_480, 0, 4, 2
    Wait 40
    ClearVars
    SetVar 4, 1
    RestoreBackground 52, 0x1000001
    WaitForTasks
    WaitBackgroundChanged
    End
