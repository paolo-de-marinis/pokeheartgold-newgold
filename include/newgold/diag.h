#ifndef POKEHEARTGOLD_NEWGOLD_DIAG_H
#define POKEHEARTGOLD_NEWGOLD_DIAG_H

// The diagnostics a NEWGOLD_DIAG=1 build carries. docs/newgold/DIAGNOSTICS.md
// says what each one is for and tools/newgold/devkit/diag reads them. Off, nothing
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
#define DIAG_ASSERT_STACK_WORDS 64
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

// The battle as text, so it can be followed without a screen. The last lines
// the battle printed, in the game's own character codes (charmap.txt decodes
// them), newest at gDiagBattleTextCount - 1 modulo the ring.
#define DIAG_BATTLE_TEXT_LINES 16
#define DIAG_BATTLE_TEXT_CHARS 96
extern unsigned short gDiagBattleText[DIAG_BATTLE_TEXT_LINES][DIAG_BATTLE_TEXT_CHARS];
extern unsigned long gDiagBattleTextCount;
void Diag_BattleText(const unsigned short *text);
// The last message the battle was asked to print, before its placeholders are
// filled: bank row, tag and the first three parameters. When filling them in
// fails -- a row or a name past the end of its bank -- this is the one.
extern unsigned long gDiagLastMessage[5];

// The four battlers as the battle sees them, refreshed every frame, and where
// the player's side is in choosing: gDiagBattlePrompt is the selection
// state (1 a command, 4 a move, 6 a target, 10 a Pokemon; 13 and up chosen).
typedef struct DiagBattler {
    unsigned short species;
    unsigned short hp;
    unsigned short maxHp;
    unsigned char level;
    unsigned char partySlot;
    unsigned long status;
    unsigned short item;
    unsigned short moves[4];
    unsigned char pp[4];
} DiagBattler;
extern DiagBattler gDiagBattlers[4];
// The player's party in the battle's own order -- the order its party
// screen shows -- as species and HP, so the Pokemon to send after a faint can
// be chosen from memory.
extern unsigned short gDiagPartySpecies[6];
extern unsigned short gDiagPartyHp[6];
extern unsigned long gDiagBattleCommand;
// The battle script running: its archive, its member and how far into it.
extern unsigned long gDiagBattleScript[3];
extern unsigned long gDiagBattlePrompt;

// What the trainer's own AI spent: how many items, and the last one.
extern unsigned long gDiagAiItemCount;
extern unsigned long gDiagAiItemLast;

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
