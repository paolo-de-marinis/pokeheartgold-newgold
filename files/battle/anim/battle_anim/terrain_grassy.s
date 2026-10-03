    .include "macros/btlanim.inc"

    .data

// Grassy Terrain's start, BATTLE_ANIMATION_GRASSY_TERRAIN: the field turns
// green, as Grass Whistle turns it, light rises from the ground under both
// Pokemon, as under an Ingrain user, and leaves spring up around them, as
// they do for Grass Knot.
_000:
    LoadParticles 0, 465
    LoadParticles 1, 293
    TintBackground 1, 0, 8, 0x2BF4
    WaitForTasks
    AddParticle 1, 0, ANIM_POS_ATTACKER
    AddParticle 1, 0, ANIM_POS_DEFENDER
    RepeatSE SEQ_SE_DP_W145C, 0, 2, 12
    Wait 10
    AddParticle 0, 0, ANIM_POS_ATTACKER
    AddParticle 0, 1, ANIM_POS_ATTACKER
    AddParticle 0, 0, ANIM_POS_DEFENDER
    AddParticle 0, 1, ANIM_POS_DEFENDER
    PlaySEPan SEQ_SE_DP_300, 0
    WaitParticles
    UnloadParticles 0
    UnloadParticles 1
    TintBackground 1, 8, 0, 0x2BF4
    WaitForTasks
    End
