    .include "macros/btlanim.inc"

    .data

// Electric Terrain's start, BATTLE_ANIMATION_ELECTRIC_TERRAIN: the field
// turns yellow, as Spark turns it, and Discharge's lightning runs out over
// the ground from under both Pokemon, twice.
_000:
    LoadParticles 0, 453
    TintBackground 1, 0, 12, 0x33FF
    WaitForTasks
    AddParticle 0, 3, ANIM_POS_ATTACKER
    AddParticle 0, 3, ANIM_POS_DEFENDER
    RepeatSE SEQ_SE_DP_W085B, 0, 4, 7
    Wait 14
    AddParticle 0, 3, ANIM_POS_ATTACKER
    AddParticle 0, 3, ANIM_POS_DEFENDER
    WaitParticles
    UnloadParticles 0
    TintBackground 1, 12, 0, 0x33FF
    WaitForTasks
    End
