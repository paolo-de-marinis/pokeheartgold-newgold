#include "newgold/diag.h"

#include "global.h"

// Built in with NEWGOLD_DIAG=1 and nothing without it. The hook sites are the
// places in the game that write these, each under the same #ifdef; the readers
// are in tools/newgold/diag. Everything lives in the static module so an
// overlay can write it and a memory dump can find it at one address.
#ifdef NEWGOLD_DIAG

u32 gDiagBattleState;
u32 gDiagBattleTicks;
u32 gDiagBattleStateSeen;

u32 gDiagAssertCount;
u32 gDiagAssertReturn;

u32 gDiagAllocFailCount;
u32 gDiagAllocFailHeap;
u32 gDiagAllocFailSize;

u32 gDiagIgnoreCommunicationError;
u32 gDiagForceEncounter;
u16 gDiagForceBattleSpecies;
u16 gDiagWarpX;
u16 gDiagWarpZ;

u32 gDiagWildStage;
u32 gDiagWildTicks;
u32 gDiagLastWildSpecies;
u32 gDiagLastWildLevel;
u32 gDiagLastBattleMap;
u32 gDiagLastBattleBg;
u32 gDiagLastBattleTerrain;

void Diag_BattleState(int state) {
    if ((u32)state == gDiagBattleState) {
        gDiagBattleTicks++;
    } else {
        if (state == 0) {
            gDiagBattleStateSeen = 0; // a new battle
        }
        gDiagBattleState = state;
        gDiagBattleTicks = 0;
    }
    if (state < 32) {
        gDiagBattleStateSeen |= 1u << state;
    }
}

void Diag_AllocFailed(u32 heapId, u32 size) {
    gDiagAllocFailCount++;
    gDiagAllocFailHeap = heapId;
    gDiagAllocFailSize = size;
}

// Records where the assertion returns to, then lets GF_AssertFail decide what
// to do about it as it always has. Assembly because that address is in lr and
// nothing in C can read it. The load spells its offset out: this compiler's
// assembler turned a bare [r0] after the literal load into [r0, #0x78].
// clang-format off
asm void Diag_AssertFail(void) {
    ldr r0, =gDiagAssertReturn
    mov r1, lr
    str r1, [r0]
    ldr r0, =gDiagAssertCount
    ldr r1, [r0, #0]
    add r1, r1, #1
    str r1, [r0]
    push {lr}
    bl GF_AssertFail
    pop {pc}
}
// clang-format on

#endif // NEWGOLD_DIAG
