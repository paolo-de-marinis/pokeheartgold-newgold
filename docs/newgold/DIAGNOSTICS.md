# Diagnostics

A build with `NEWGOLD_DIAG=1` carries a few dozen bytes of state the game
writes as it goes and a handful of switches it reads, so that a run -- on the
headless harness or on somebody's melonDS -- can be asked where it got to and
what failed, from a copy of its memory, without stopping it. The ordinary
build has none of it and is byte for byte the build without it.

    make -j10 COMPARE=0 NEWGOLD_DIAG=1

goes to `build/heartgold.us.diag/` (its own directory, so it never shares an
object with the ordinary build) and puts `pokeheartgold.us.nds` and `main.elf`
there. `GAME_VERSION=SOULSILVER` works the same way.

## Where it lives

- `include/newgold/diag.h` -- the globals and the three functions, declared
  only under `#ifdef NEWGOLD_DIAG`.
- `src/newgold/diag/diag.c` -- their definitions, in the static module so an
  overlay can write them and a dump can find them at one address.
- The hook sites, each under the same `#ifdef`: `Battle_Run`, `GF_ASSERT`,
  the two `Heap_Alloc` failures, the main menu's communication error, the
  encounter roll, the wild encounter task, the step check, and the battle
  setup's map, background and terrain. `grep -rn NEWGOLD_DIAG src include`
  is the full list.
- `tools/newgold/devkit/` -- the readers, the headless player, the save
  editor and the harness; its README says what is where.
- `tests/newgold/test_diag.py` -- reads every source and fails on a
  diagnostic mentioned outside the `#ifdef`, which is what keeps the ordinary
  build clean after the next hook is added.

## What is recorded

| Global | Written by | Says |
| --- | --- | --- |
| `gDiagBattleState`, `gDiagBattleTicks` | `Battle_Run` | The state the battle overlay is in and how many frames it has been there. A battle that hangs stops one of these; a battle that runs walks INIT to EXIT. |
| `gDiagBattleStateSeen` | `Battle_Run` | One bit a state, cleared when a battle starts, so a finished battle reads as the list of states it passed through. |
| `gDiagAssertCount`, `gDiagAssertReturn` | `GF_ASSERT` | How many assertions failed, and the address the last one returns to: the `bl` before it is the assertion, and `markers.py` names the function. |
| `gDiagAllocFailCount`, `gDiagAllocFailHeap`, `gDiagAllocFailSize` | `Heap_Alloc`, `Heap_AllocAtEnd` | How many allocations failed, and the last one's heap and size. |
| `gDiagHeapLowWater` | `Heap_Alloc`, `Heap_AllocAtEnd`, `Heap_Create` | For every heap, the largest block it could still hand out at its fullest: the free list walked after each allocation, the smallest answer kept, all ones again when the heap is created. The margin a heap really has, rather than a failure after it ran out. |
| `gDiagWildStage`, `gDiagWildTicks` | `Task_WildEncounter` | How far the wild encounter task got and how often it ran. |
| `gDiagLastWildSpecies`, `gDiagLastWildLevel` | the encounter generator | What the encounter actually made. |
| `gDiagLastBattleMap`, `gDiagLastBattleBg`, `gDiagLastBattleTerrain` | the battle setup | Where the battle was started from and what it chose to draw. A battle whose screen stays black has usually failed to choose one of these. |

| `gDiagBattleText`, `gDiagBattleTextCount` | `BattleSystem_PrintBattleMessage` | The last sixteen lines the battle printed, in the game's own character codes (`charmap.txt` decodes them). The battle as text: "Falkner used a Potion!", "It's super effective!". |
| `gDiagBattlers`, `gDiagBattlePrompt`, `gDiagBattleCommand` | `BattleContext_Main`, every frame | The four battlers -- species, level, HP, status, held item, moves and PP -- and where the player is in choosing (a command, a move, a target, a Pokemon). |
| `gDiagAiItemCount`, `gDiagAiItemLast` | the trainer AI's item use | What the trainer spent in battle. |
| `gDiagCryCount`, `gDiagCrySpecies`, `gDiagCryBank`, `gDiagCryStarted` | `PlayCry` | How many cries were asked for; the last one's species and form as the caller gave them (`species + (form << 16)`), the sound archive bank it became, and whether the sound system started it. A cry that falls back to bank 1 or does not start is a species whose cry does not play. |

And the switches, zero unless something outside the game writes them:

| Switch | Read by | Does |
| --- | --- | --- |
| `gDiagIgnoreCommunicationError` | the main menu | Continue works in a harness that emulates no wireless, where the menu otherwise shows a communication error and resets. |
| `gDiagForceEncounter` | the encounter roll | The roll always succeeds, so the first step on a tile that has encounters starts one. It forces the roll and nothing else: an earlier version also answered "this tile has encounters" and produced a battle in New Bark Town, whose table is surf-only, against species zero. |
| `gDiagForceBattleSpecies` | the step check | The next step starts a wild battle against that species wherever the player stands, indoors included. |
| `gDiagForceTutorial` | the step check | The next step starts the catching demonstration (Lyra's Marill against a Lv. 2 Rattata, played by the game's own finger), wherever the player stands; the story reaches it only on Route 29 with Lyra. |
| `gDiagWarpX`, `gDiagWarpZ` | the step check | The next step check puts the player on that tile. The overworld is one coordinate space, so a Route 29 tile written from New Bark Town is Route 29 with its grass and its table. |
| `gDiagBattleSeed` | `BattleSetup_New` | Nonzero: the battle's RNG is seeded with it instead of the clock's seed, so a battle goes the same way however many frames came before it -- the AI's choices, every roll left to the RNG. |
| `gDiagForceCritical` | `TryCriticalHit` | 1: the critical-hit roll lands; 2: it fails. The roll only: Battle Armor, Shell Armor and Lucky Chant still refuse a critical hit, and an always-critical move or stage still gets one. Both sides. |
| `gDiagForceHit` | `BattleSystem_CheckMoveHit`, `BtlCmd_TryOHKOMove` | 1: the accuracy roll hits; 2: it misses. A move accurate to 100 or more still hits; a one-hit KO move still fails on a higher-level target or on Sturdy. |
| `gDiagForceDamageRoll` | `DamageCalcDefault`, `ApplyDamageRange` | 1: the top of the damage range (100%); 2: the bottom (85%). |
| `gDiagForceEffect` | `ov12_02250490`, `BtlCmd_CheckEffectActivation` | 1: an additional effect's roll succeeds (a burn, a flinch, a stat drop); 2: it fails. A certain effect still happens. |

The four forced rolls work the same way: the check says which roll it is about to
ask for (`Diag_RollNext`), and `BattleSystem_Random` hands its value to `Diag_Roll`,
which answers the forced one when that switch is on. The RNG advances as it always
does, so forcing one roll moves no other. A scenario holds them (`"hold"`, or a
`hold:` step to change one mid-battle); `tests/newgold/scenarios/rolls_forced_*.json`,
`accuracy_forced.json` and `battle_seed.json` show each at work.

The other chance rolls are not forced, only fixed by the seed: the flinch of a King's
Rock, a Razor Fang or Stench, the contact abilities' three in ten (Static, Flame Body,
Poison Point, Effect Spore, Cute Charm and the like) and Toxic Chain among them.

## Reading it

Every reader takes the ELF the ROM was linked from, `build/heartgold.us.diag/main.elf`
by default. Symbols move with every build; a reading against the wrong ELF is
noise, not a wrong answer.

- `tools/newgold/devkit/diag/live.py [--follow]` reads the RAM of the melonDS that
  is running, through the memory mapping its process holds open, and prints
  one line: field and party, encounter, battle state, failures. `--follow`
  prints every change until Ctrl-C. This is how a play session is watched.
- `tools/newgold/devkit/diag/party.py` reads the party out of the same memory,
  decrypted the way the game does it: species, level, experience, HP and
  held item, which is how a level cap or a held item is checked without
  trusting the screen.
- `tools/newgold/devkit/diag/play.py launch|focus|press|hold|shot|quit` drives the
  melonDS on this desktop -- the flatpak, its window through KWin, its keys
  through a virtual keyboard in whatever mapping the player set, its window
  through Spectacle -- so a gym is played from a shell, one screenshot a
  turn, with the readers above watching the same game.
- `tools/newgold/devkit/diag/nested.py start|press|shot|stop` does the same on a
  display nothing else sees: a headless KWin with its own D-Bus, a rootful
  Xwayland inside it whose XTEST keeps keys and taps to itself, and melonDS
  with a HOME of its own and no sound -- for an agent that must not open a
  window on the desktop. A battle is seen this way on melonDS itself; the
  headless harness draws one too (`core.py`'s shot, below).
- `tools/newgold/devkit/diag/gym.py SAVE` fights, in the headless harness, whatever
  the save stands the player in front of, with the auto-battle switch on,
  and prints the battle as text; `tools/newgold/devkit/diag/watch.py` prints the
  same text from the melonDS that is running. Neither needs a screen, and
  neither costs an image to read -- this is how a gym is checked.
- `tools/newgold/devkit/diag/pc.py SAVE` opens the PC's storage system from
  a save standing in front of a PC (`savedit.py --where 158:11:13:0`, Violet
  City's), pages through the boxes and prints every heap's margin; gym.py's
  last line prints the same margins after a gym fight.
- `tools/newgold/devkit/diag/dump.py OUTDIR` reads the `ram:` dumps of a harness run
  the same way, one line a dump, and pastes the run's shots into a sheet.
- `tools/newgold/devkit/diag/battle.py OUTDIR encounter|battle:SPECIES` plays the
  opening in the harness, warps to Route 29, throws a switch, and reads the
  dumps back. About ten minutes from a cold boot. Its shots come through
  `boot_check`'s framebuffer, which went black the moment overlay 12 loaded,
  so what it proves is that the encounter rolled, what it made, and how far
  `Battle_Run` got. `core.py`'s shot takes the frame from the core's own
  video callback (3f37ceeac) and draws a battle whole -- the background,
  both sprites, the HP boxes and the message box -- and `scene.py`'s
  `shot:` step, the scenarios' too, is that shot.

A frozen melonDS answers too. `Shift+F1` writes a savestate beside the ROM,
and `tools/newgold/devkit/diag/frozen.py STATE.ml1` reads its `ARM9` section as the
registers -- CPSR 0x97 is abort mode, where the faulting instruction is eight
bytes before the link register -- and the end of its `CP15` section as the
stack, naming every return address against the ELF. Overlay symbols overlap
by address, so each overlay's own answer is listed and the loaded one is the
true one. The first thing it caught was not the game: a generated save whose
player object stood at Route 29's coordinates inside a one-chunk gym, which
`GetLocalSoundplateID` read through a null pointer. The harness had passed
it, because its core reads a null as zero.

## The harness's emulator

`tools/newgold/devkit/diag/core.py` runs a libretro melonDS in-process, and
`NEWGOLD_CORE` (a path) says which; `NEWGOLD_JIT=1` turns its JIT on.

- melonDS DS 1.3.1, `~/hgss-build/deps/melondsds/melondsds_libretro.so`
  (the melonds-ds release, melonDS commit 7117178, newer than the melonDS
  1.1 Paolo plays on): the default. core.py sets
  `melonds_render_mode=software` (it then asks for no OpenGL context),
  `melonds_threaded_renderer=disabled`, `melonds_console_mode=ds`,
  `melonds_boot_mode=direct`, `melonds_sysfile_mode=builtin`,
  `melonds_network_mode=disabled`, `melonds_mic_input=silence`,
  `melonds_show_cursor=disabled`, one `top-bottom` layout with no gap,
  `melonds_touch_mode=touch`, `melonds_dsi_sdcard=disabled`, English
  firmware, and `melonds_start_time_mode=sync`: the core reads the host's
  clock at every frame, which `pin_clock()`'s shim answers with the pinned
  second while a frame runs, so the console says 2023-11-14 22:13:20
  throughout, as on 0.9.3. (`real` sets the clock once and lets it run; the
  `absolute` options take their seconds from the host.) The save goes in
  and out as the core's memory 0, kept in the same `.sav` file 0.9.3
  writes.
- melonDS 0.9.3, `/usr/lib/libretro/melonds_libretro.so` (Arch's
  libretro-melonds), the harness's first core:
  `NEWGOLD_CORE=/usr/lib/libretro/melonds_libretro.so`. `boot_check.c`,
  `smoke.py` and `test_boot.py` still run it.

Both play every scenario to the same battle lines (on the landed tree, all
eighteen, but for the command prompt's line printed once more on 0.9.3
where `revival_blessing_aegislash` stops at it), and each repeats itself:
Falkner on melonDS DS gave the same frames, lines and RAM run after run,
with the JIT off and again with it on. Where they differ is emulation:

- melonDS DS starts the game a frame sooner (the main loop's
  `gSystem.frameCounter` first moves at frame 23, at 24 on 0.9.3), so its
  VBlank count runs one ahead at any frame; and it hands the game a button
  a frame later (A held from frame 700 is in `gSystem.heldKeysRaw` at the
  end of frame 701, of 700 on 0.9.3, and let go a frame later too). A
  script that times a press by frame count, or compares frame counts
  across the cores, has to allow for both.
- Continue seeds the field's RNG (`RngSeedFromRTC`: 0xbb160017 plus the
  VBlank count, at the pinned second). Measured on the tenth round's lab
  branch, melonDS DS came to it a frame later and two counts higher:
  0xbb160215 on 0.9.3 at frame 861, 0xbb160217 on melonDS DS at 862. The
  loading before it has grown since, the title's and the menu's music with
  it (the pseudobanks, 51f7a1ca3 .. 904c0baa3), and on the landed tree both
  cores leave 0xbb160231, 538 VBlanks: at frame 892 on 0.9.3 and 891 on
  melonDS DS, whose frame of head start is all that shows there. Which wild
  Pokemon a walk meets follows from that seed alone: each core given the
  other's RNG state after Continue met the other's. A walk's wild battles
  hold no `gDiagBattleSeed`, so their turns are seeded by the clock and the
  VBlank count as well: a walk with wild battles plays out per core. The
  scenarios that force a wild Pokemon and expect its HP to the point, and
  the walk to Cherrygrove, set `sLCRNG_State` to 0xbb160215 after Continue
  (67a15906a, a0effe0ab, 77a7080e6) -- the seed their expectations were
  written against, no longer either core's own -- and `test_scenarios`
  holds every scenario that forces a wild Pokemon to it.
- The boot's random pre-size is 0xa8 on melonDS DS, 0xe8 on 0.9.3: the
  heaps start 0x40 bytes apart.
- melonDS 0.9.3 emulates no wireless. Both cores make the comm system's
  heap at the main menu (heap 15, 0x7080 bytes taken from the end of heap
  3 by `Heap_CreateAtEnd` in `unk_02037C94.s`); melonDS DS destroys it
  before Continue, 0.9.3 never does -- and without
  `gDiagIgnoreCommunicationError` it resets at the main menu and never
  reaches the field, where melonDS DS reaches Route 29 in the same frames
  as with it held. So on 0.9.3 that block stays at the top of heap 3 in
  the field: heap 3's low water on Route 29 is 0x188d8 there and 0x1f8e8
  on melonDS DS. A heap-3 margin measured on 0.9.3 is 0x7010 short of melonDS DS's,
  which is the one to trust.
- Frame counts differ in battles, the lines the same. On the landed tree
  Falkner takes 16586 frames on melonDS DS and 16484 on 0.9.3: its battle
  102 more on melonDS DS, all of them at the command prompts (between the
  prompt showing and the move) and around the faints, where gym.py waits
  on the game; `double_replacement`, the double from `gyms/bugsy.sav`, 41
  fewer. (On the lab branch Falkner took 16556 against 16555, and that
  double 45 more.) It is not slower loading: there the frames less the
  VBlank count agreed within one at every run's end. The JIT changes the
  counts again.
- Speed, frames a second over a whole scenario, on the lab branch: Falkner
  143 on melonDS DS
  and 178 on 0.9.3 with the JIT off, 235 and 266 with it on; the walk
  from New Bark to Route 29 107 and 132 with the JIT off, 196 on 0.9.3
  with it on. The landed tree, three runs at a time, came within 7% of them.
- With the JIT on, melonDS DS starts no wild battle at all: on the lab
  branch, in every scenario with one (the forced Geodudes, the Sentret on
  the walk to Route 29, the Rattata on the walk to Cherrygrove), the
  encounter's screen effect
  (`sub_020551B8`, called from `Task_WildEncounter`'s first state) never
  says it is done, `gDiagWildStage` stays at 1 and the run waits until its
  frames are spent. The trainer battles play (Falkner, the double from
  `gyms/bugsy.sav`). It is the JIT's doing, not the encounter's: the same
  Sentret, rolled from the same RNG state with the JIT off, is met and
  beaten. On the landed tree `rolls_forced_high` still stops at wild stage
  1. melonDS 0.9.3's JIT plays wild battles. core.py says so on stderr when
  `NEWGOLD_JIT=1` meets melonDS DS.
- Either core's JIT also boots faster, and so moves the Continue's seed
  (on the landed tree 0xbb160241 on melonDS DS, 0xbb160230 on 0.9.3) and
  every wild Pokemon after it. Scenarios run with the JIT off.
- The threaded renderer, off on both (core.py's options), changes nothing a
  run shows: Falkner's frames, lines and RAM on either core, the walk to
  Cherrygrove's on melonDS DS, and four shots from the field into a wild
  battle's start, each the same byte for byte; it plays 12 to 18% faster.
- Two runs in one Python process replay the same on melonDS DS -- the walk
  from New Bark twice, 8927 frames and the same RAM each time, as in a
  process of its own -- and not on 0.9.3, which keeps state across
  `retro_deinit` and `retro_init` (8940 frames, then 8927 and other RAM).
  scene.py and `test_scenarios` still play a scenario in a process of its
  own.

## The music that did not play

From 4c8176ea1 to the pseudobanks, the intro's, the title's, the towns', the
routes' and ordinary trainer battles' music never played, on either core
and on melonDS 1.1 alike, while the gyms' and the other battles' music, the
clicks and the cries did: the harness's recordings found it.
`InitSoundData` loads the sound archive's INFO and FAT blocks for good into
the sound heap, `SND_HEAP_SIZE` bytes whatever the archive holds, and the
added species' cry banks, wave archives and file entries had grown them
from HeartGold's 0x13954 bytes to 0x1bbec: 0x61c0 was left on Route 29,
whose music wants 0xa95c, and `SND_WORK.currentSeqNo` named a sequence the
BGM handle never loaded. A cry is now a wave archive alone, hg-engine's
pseudobank (51f7a1ca3, 86a7ace16, ae812433b, c0b0909bb, 904c0baa3): the
blocks cost 0x135a0, every scene's music plays, and `continue_route29.json`
expects Route 29's (the audit's "Found by the harness's core work").

## Why it is shaped this way

The main arena is what is left after the static module and the largest
overlay (overlay 12, the battle), and the heaps are carved from it at boot.
The first version of the assertion hook recorded `__FILE__` and
`__LINE__` at every `GF_ASSERT` site; that is a string and a literal per site,
17 KB across the static module, and the ROM stopped booting.

By the seventh round overlay 12 had grown into nearly all of that room: the
ordinary build had 0x72C bytes left once the file system's table was loaded,
and the diagnostics, 0x1420 bytes across the static module and overlay 12,
no longer fitted -- `FS_TryLoadTable`'s allocation failed at boot and the
screen stayed blank. For a while a diagnostics build took 0x2000 back from
the default heap on its own; once the moves-types merge left the ordinary
build short as well, the default heap (`sDefaultHeapSpec` in `src/system.c`)
went from 0xD200 to 0x8000 in both builds, which the communication-error
screen, the most it was ever seen to hold, fills to 0x5950. Both builds now
have the same heaps, so the low-water marker reads the heap the game has.
`tests/newgold/test_heaps.py` checks each built ROM's map against what the
boot takes from the arena, so the next growth fails a test, not the screen.

The return address costs the site nothing -- `bl Diag_AssertFail` is the
size of `bl GF_AssertFail` -- so that is what is kept, and the ELF turns it
back into a function.

A trail (a ring of the last sixteen places reached, for a hang that says
nothing) was used once and is not kept: it has no fixed sites, and one with
sites everywhere is the thing above again. When something hangs, add the
markers for that hang under the same `#ifdef`, read them, and take them out.

## Adding one

1. Declare it in `include/newgold/diag.h`, define it in `diag.c`.
2. Write it at the site under `#ifdef NEWGOLD_DIAG`; the header comes in
   through `global.h`.
3. Print it in `tools/newgold/devkit/diag/markers.py`; `test_diag.py` fails on a
   global no reader prints.
4. Build both ways. The ordinary ROM must not change a byte.
