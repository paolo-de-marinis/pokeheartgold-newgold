#ifndef POKEHEARTGOLD_NEWGOLD_DIAG_H
#define POKEHEARTGOLD_NEWGOLD_DIAG_H

// The diagnostics a NEWGOLD_DIAG=1 build carries. docs/newgold/DIAGNOSTICS.md
// says what each one is for and tools/newgold/diag reads them. Off, nothing
// in here exists and no hook site compiles to anything, so the ROM is byte
// for byte the ROM without them.
//
// Spelled without the SDK's typedefs (u32 is unsigned long, u16 unsigned
// short): assert.h includes this ahead of them.
#ifdef NEWGOLD_DIAG

// How the battle is going: the state Battle_Run is in, how many frames it has
// been there, and every state this battle has passed through, one bit each.
extern unsigned long gDiagBattleState;
extern unsigned long gDiagBattleTicks;
extern unsigned long gDiagBattleStateSeen;
void Diag_BattleState(int state);

// Every GF_ASSERT that failed, and the address the last one returns to: the
// bl just before it is the assertion. A return address costs the site
// nothing, where __FILE__ and __LINE__ cost the main arena more than it has.
extern unsigned long gDiagAssertCount;
extern unsigned long gDiagAssertReturn;
// The sixteen words under the stack pointer when the last one fired: the
// caller's saved registers and, among them, its own return address, so the
// reader can say who asked the function that asserted.
#define DIAG_ASSERT_STACK_WORDS 16
extern unsigned long gDiagAssertStack[DIAG_ASSERT_STACK_WORDS];
void Diag_AssertFail(void);

// Every allocation that failed, and the last one's heap and size.
extern unsigned long gDiagAllocFailCount;
extern unsigned long gDiagAllocFailHeap;
extern unsigned long gDiagAllocFailSize;
void Diag_AllocFailed(unsigned long heapId, unsigned long size);

// Switches. All zero unless something outside the game writes them.
extern unsigned long gDiagIgnoreCommunicationError; // Continue works where nothing emulates wireless
extern unsigned long gDiagForceEncounter;           // the encounter roll always succeeds
extern unsigned short gDiagForceBattleSpecies;      // the next step is a wild battle against it
extern unsigned short gDiagWarpX;                   // the next step check puts the player on this tile
extern unsigned short gDiagWarpZ;

// Where the last wild encounter got to.
extern unsigned long gDiagWildStage;
extern unsigned long gDiagWildTicks;
extern unsigned long gDiagLastWildSpecies;
extern unsigned long gDiagLastWildLevel;
extern unsigned long gDiagLastBattleMap;
extern unsigned long gDiagLastBattleBg;
extern unsigned long gDiagLastBattleTerrain;

#endif // NEWGOLD_DIAG

#endif // POKEHEARTGOLD_NEWGOLD_DIAG_H
