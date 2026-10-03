    .include "macros/btlanim.inc"

    .data

// Misty Terrain's start, BATTLE_ANIMATION_MISTY_TERRAIN: Mist's mist swirls
// over both sides of the field while it turns pink, the misty background's
// hue.
_000:
    LoadParticles 0, 85
    TintBackground 1, 0, 10, 0x6E7F
    RepeatSE SEQ_SE_DP_W109, 0, 4, 3
    AddParticle 0, 0, ANIM_POS_ATTACKER_SIDE
    AddParticle 0, 0, ANIM_POS_DEFENDER_SIDE
    WaitParticles
    UnloadParticles 0
    TintBackground 1, 10, 0, 0x6E7F
    WaitForTasks
    End
