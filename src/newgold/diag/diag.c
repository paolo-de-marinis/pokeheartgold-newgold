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
u32 gDiagAssertStack[DIAG_ASSERT_STACK_WORDS];

u32 gDiagAllocFailCount;
u32 gDiagAllocFailHeap;
u32 gDiagAllocFailSize;

u32 gDiagIgnoreCommunicationError;
u32 gDiagForceEncounter;
u16 gDiagForceBattleSpecies;
u16 gDiagWarpX;
u16 gDiagWarpZ;

u16 gDiagBattleText[DIAG_BATTLE_TEXT_LINES][DIAG_BATTLE_TEXT_CHARS];
u32 gDiagBattleTextCount;
u32 gDiagLastMessage[5];
DiagBattler gDiagBattlers[4];
u16 gDiagPartySpecies[6];
u16 gDiagPartyHp[6];
u32 gDiagBattleCommand;
u32 gDiagBattleScript[3];
u32 gDiagBattlePrompt;

u32 gDiagAiItemCount;
u32 gDiagAiItemLast;

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

void Diag_BattleText(const u16 *text) {
    u16 *line = gDiagBattleText[gDiagBattleTextCount % DIAG_BATTLE_TEXT_LINES];
    int i;

    for (i = 0; i < DIAG_BATTLE_TEXT_CHARS - 1 && text[i] != 0xFFFF; i++) {
        line[i] = text[i];
    }
    line[i] = 0xFFFF;
    gDiagBattleTextCount++;
}

void Diag_AllocFailed(u32 heapId, u32 size) {
    gDiagAllocFailCount++;
    gDiagAllocFailHeap = heapId;
    gDiagAllocFailSize = size;
}

// Records where the assertion returns to and the top of the stack, then lets
// GF_AssertFail decide what to do about it as it always has. Assembly because
// that address is in lr and nothing in C can read it. r0-r3 are the caller's
// scratch. The loads spell their offsets out: this compiler's assembler
// turned a bare [r0] after the literal load into [r0, #0x78].
// clang-format off
asm void Diag_AssertFail(void) {
    ldr r0, =gDiagAssertReturn
    mov r1, lr
    str r1, [r0]
    ldr r0, =gDiagAssertCount
    ldr r1, [r0, #0]
    add r1, r1, #1
    str r1, [r0, #0]
    mov r2, sp
    ldr r3, =gDiagAssertStack
    mov r1, #DIAG_ASSERT_STACK_WORDS
@copy:
    ldr r0, [r2, #0]
    str r0, [r3, #0]
    add r2, #4
    add r3, #4
    sub r1, #1
    bne @copy
    push {lr}
    bl GF_AssertFail
    pop {pc}
}
// clang-format on

#endif // NEWGOLD_DIAG
