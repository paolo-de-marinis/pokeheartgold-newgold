    .ifndef ASM_BATTLE_ANIM_SCRIPT_INC
    .set ASM_BATTLE_ANIM_SCRIPT_INC, 1
#define __ASM_PM_

#include "constants/sndseq.h"

// The battle animations' script, which overlay 7 runs (ov07_0221BE44): a word
// for the command, then its operands, a word each. The moves' animations
// (a/0/1/0) and the battle animations (a/0/6/1, PlayBattleAnimation's) are
// written in it. Only the commands this tree's own scripts use are here,
// named by what they do; hg-engine's armips/include/animscriptcmd.s
// (d0380a487) has the rest under its names.

// Where an effect is placed (AddParticle, ov07_022353E4): the battler the
// animation plays on or its target, or the middle of either's side of the
// field, as Mist and Safeguard place theirs.
    .equ ANIM_POS_ATTACKER, 3
    .equ ANIM_POS_DEFENDER, 4
    .equ ANIM_POS_ATTACKER_SIDE, 19
    .equ ANIM_POS_DEFENDER_SIDE, 20

    .macro Wait frames
    .long 0x0, \frames
    .endm

    // Until the tasks the commands before started are over.
    .macro WaitForTasks
    .long 0x1
    .endm

    .macro End
    .long 0x4
    .endm

    // A variable the next commands read, 0 to 9, and all ten back to 0.
    .macro SetVar var, value
    .long 0xC, \var, \value
    .endm

    .macro ClearVars
    .long 0x43
    .endm

    // A background of the animations' own over the battle's, and the
    // battle's back (Psychic's, Moonlight's, Trick Room's), with the
    // waits for the new one to be up and for the change to be over.
    .macro ChangeBackground background, mode
    .long 0x10, \background, \mode
    .endm

    .macro RestoreBackground background, mode
    .long 0x12, \background, \mode
    .endm

    .macro WaitBackgroundShown
    .long 0x13
    .endm

    .macro WaitBackgroundChanged
    .long 0x14
    .endm

    // The animations' background scrolled in waves, Psychic's (length 50).
    .macro WaveBackground length
    .long 0x2D, 76, 1, \length
    .endm

    .macro PlaySEPan se, pan
    .long 0x16, \se, \pan
    .endm

    // The sound effect again every so many frames, so many times.
    .macro RepeatSE se, pan, frames, times
    .long 0x19, \se, \pan, \frames, \times
    .endm

    // The battle background's colours blended toward a colour (RGB555), from
    // one strength to another out of 16, with a pause of delay between the
    // steps (PaletteData_BeginPaletteFade): the weathers' tint, delay 1.
    .macro TintBackground delay, from, to, colour
    .long 0x2D, 33, 5, 0, \delay, \from, \to, \colour
    .endm

    // An emitter of the effect loaded in a slot, at a position.
    .macro AddParticle slot, emitter, position
    .long 0x2E, \slot, \emitter, \position
    .endm

    // Until every effect on screen is over.
    .macro WaitParticles
    .long 0x32
    .endm

    .macro UnloadParticles slot
    .long 0x35, \slot
    .endm

    // An effect of a/0/2/9 into a slot, with the sprite resources its
    // emitters draw with, as every retail animation loads one.
    .macro LoadParticles slot, effect
    .long 0x38
    .long 0x39, 0
    .long 0x39, 1
    .long 0x39, 2
    .long 0x39, 3
    .long 0x3A, 4, 0, 0, 0
    .long 0x3A, 5, 0, 1, 1
    .long 0x3A, 6, 0, 2, 2
    .long 0x3A, 7, 0, 3, 3
    .long 0x2D, 78, 1, 0
    .long 0x33, \slot, \effect
    .long 0x1
    .long 0x3B
    .long 0x3C, 0
    .long 0x3C, 1
    .long 0x3C, 2
    .long 0x3C, 3
    .endm

    .endif
