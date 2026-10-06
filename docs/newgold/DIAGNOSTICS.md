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
| `gDiagBattleBackground` | `BattleSystem_ChangeBackground` | The background drawn again partway through the battle, as its tiles' member of a/0/0/7: a terrain's (351 Electric, 353 Misty, 355 Grassy, 357 Psychic) or the battle's own again (3 + its BattleBg). 0 until the first, and not cleared between battles. |
| `gDiagMoveAnimationCount` | `BtlCmd_PlayMoveAnimation` | How many move animations that command has sent the display since the console started: one for each move that plays its own, or the one an added move borrows (`MoveAnimationFor`). |
| `gDiagMoveAnimation` | `BtlCmd_PlayMoveAnimation` | The move whose animation that command sent the display last: the move's own, or the one it borrows (`MoveAnimationFor`, Secret Power's by the ground). 0 until the first, and not cleared between battles. |
| `gDiagBackgroundTilesLine` | `Task_BattleSystem_LoadBackgroundTiles` | The scanline (REG_VCOUNT) on which the battle background's tiles last started going to VRAM: 192 to 262 is the VBlank, after the battle's VBlank work has sent the hardware the colours PaletteData holds. Set at the battle's start and at every background drawn again (a terrain's, the battle's own back); 0 until the first, and not cleared between battles. |
| `gDiagBattleAnimation` | `BtlCmd_PlayBattleAnimationOnMons` | The last battle animation that command sent the display, a `BATTLE_ANIMATION_*` number: a terrain's start (50 Grassy, 51 Misty, 52 Electric, 53 Psychic) or a Leech Seed's drain (32). Not set when the Battle Scene option or a substitute keeps it from playing. 0 until the first, and not cleared between battles. |
| `gDiagHealthBoxesHiddenBy` | `ov12_02261D30` | The last battle animation that hid the health boxes as it played, a `BATTLE_ANIMATION_*` number: a weather's (18 to 22), a binding move's damage, a terrain's start (50 to 53). Moves' animations are not counted. 0 until the first, and not cleared between battles. |
| `gDiagDexShown` | `ov18_021F1BC8` | The Pokedex's top screen, the grid's and a species' pages': the species it drew last there, the one the Dex shows for the species (`PokedexApp_ShownSpecies`: the form seen first while only forms have been seen), as `species | form << 16`. 0 until the first, and not cleared when the Dex closes. |
| `gDiagDexFormShown`, `gDiagDexFormTypes`, `gDiagDexAreaSpecies`, `gDiagDexAreaPlaces` | `ov18_021F5EFC`, `PokedexApp_ShowFormTypes`, `ov18_021E8528` | The Pokedex's FORMS page: the entry it drew last, as `species | form << 16`, and the types it showed for it, `type1 | type2 << 8`; its AREA page: the species whose areas it read last (a form's own, the entry FORMS was left on) and how many places its four records name. 0 until the first, and not cleared when the Dex closes. |
| `gDiagDexSizeShown`, `gDiagDexSizeIcon` | `ov18_021F4DDC`, `ov18_021F4D64` | The Pokedex's SIZE page: the front it drew last beside the trainer and the icon it drew last, as `species | form << 16`: the species the Dex shows, as the FORMS page's first entry (the form a species caught only as its forms was seen as first). 0 until the first, and not cleared when the Dex closes. |
| `gDiagMartOwnedRows` | `ov31_0225DD14` | The mart's list as it was painted last: a bit for each of the page's six rows that shows "Owned" in place of a price (a TM in the bag, which the mart does not sell again), bit 0 the top row. 0 for a page with none, and not cleared when the mart closes. |
| `gDiagMartConfirmLine` | `ov31_0225E5FC` | The line a mart printed last to confirm a purchase, its msg_0435 row: 14 "OK, 3. That'll be $900.", 51 a TM by name, "TM094? Certainly. That'll be $1500." The counters' "Would you like" is not counted. 0 until the first, and not cleared when the mart closes. |
| `gDiagFieldMessage` | `ovFieldMain_ReadAndExpandMsgDataViaBuffer` | The last message a field script put in its box -- an NPC's line, a sign's, a standard script's "obtained" -- as `bank << 16 \| row`, the bank its member of the message archive (`msg_0397_R39R0101` is 397). What the field said, where a battle has `gDiagBattleText`; a scenario expects a line by it while the line is up. 0 until the first. |
| `gDiagBattleText`, `gDiagBattleTextCount` | `BattleSystem_PrintBattleMessage` | The last sixteen lines the battle printed, in the game's own character codes (`charmap.txt` decodes them). The battle as text: "Falkner used a Potion!", "It's super effective!". |
| `gDiagBattlers`, `gDiagBattlePrompt`, `gDiagBattleCommand` | `BattleContext_Main`, every frame | The four battlers -- species, level, HP, status, held item, moves and PP -- and where the player is in choosing (a command, a move, a target, a Pokemon). |
| `gDiagAiItemCount`, `gDiagAiItemLast` | the trainer AI's item use | What the trainer spent in battle; the readers' summary names the last item. |
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
| `gDiagForceSpeedTie` | `CheckSortSpeed` | 1: a speed tie goes to the second of the two battlers compared -- the pair swaps, so in a single battle the foe moves first; 2: to the first, the player. The roll only: priority, the Quick Claw, the Lagging Tail, Stall and Trick Room still order the pair first, and only a tie is rolled. Every ordering the game sorts by Speed, the AI's own guess included. |
| `gDiagForceThaw` | `ov12_0224B528`'s frozen step | 1: a frozen Pokemon's one-in-five thaw on its own turn happens; 2: it stays frozen. The roll only: a move that thaws its user as it is chosen still does, and a hit that thaws its target still does. |

The six forced rolls work the same way: the check says which roll it is about to
ask for (`Diag_RollNext`), and `BattleSystem_Random` hands its value to `Diag_Roll`,
which answers the forced one when that switch is on. The RNG advances as it always
does, so forcing one roll moves no other. Between frames no roll is waiting
(`gDiagRollNext` is zero): the readers' one-line summary names one that is, a
check that named a roll and took none. A scenario holds them (`"hold"`, or a
`hold:` step to change one mid-battle); `tests/newgold/scenarios/rolls_forced_*.json`,
`accuracy_forced.json`, `speed_tie.json` and `battle_seed.json` show each at work;
`scene.py`'s `set:B,speed,N` gives two battlers the same Speed for a tie.

The other chance rolls are not forced, only fixed by the seed: the flinch of a King's
Rock, a Razor Fang or Stench, the contact abilities' three in ten (Static, Flame Body,
Poison Point, Effect Spore, Cute Charm and the like) and Toxic Chain among them.

## konefr's developer vendor

konefr's debug vendor (b23dc7360) is development help, not a player's: in a
diagnostics build only, the EV/IV trainer (Cherrygrove's Pokemon Center) has a
page after Sets -- SELECT on the Sets page -- with his password, 0-2-5-1 (Up/Down
a digit, Left/Right to move, A to try), then his Rare Candies at 1 each, 1, 10, 50
or 99 at once. Every line of it is under `#ifdef NEWGOLD_DIAG` in
`src/ev_iv_trainer_app.c` (`test_developer_vendor` reads for any outside it), so
the ordinary build is the build without it; the scenario
`ev_iv_trainer_developer_vendor` plays it.

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
  reads (and never writes back: no in-game save on it).
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
- With the JIT on, melonDS DS started no wild battle until the game
  stopped running DSProt (`FieldMap_Init` in src/field/fieldmap.c says
  why): the encounter's screen effect (`sub_020551B8`, called from
  `Task_WildEncounter`'s first state) read a table address the JIT had
  compiled from a literal DSProt writes, rotated by sixteen bits, took a
  data abort, and `gDiagWildStage` stayed at 1. A melonDS savestate of such
  a run reads with frozen.py: undefined mode, the effect's addresses on the
  stack. Wild battles play with the JIT now, and
  `tests/newgold/scenarios/wild_battle_jit.json` (`"jit": true`) keeps it so.
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

Where the diagnostics' bytes go (HeartGold, the twelfth round with its
fixes: 0x1540 of the arena, 0x1BE8 left on the plain builds and 0x6A8 on the
diagnostics ones; how far the two builds' maps move `SDK_STATIC_BSS_END`
and overlay 12's end): 0x1360 in the static module -- the battle's text
ring 0xC00, the heaps' low-water marks 0x2C0, the assertion's stack 0x100,
the four battlers 0x70 and the other globals, then `diag.c`'s functions and
the hooks in `heap.c`, `battle_setup.c`, `encounter.c`, the cry's and
`main.c` -- and 0x1E0 in overlay 12, `Diag_BattleView` 0x128 and the
battle's hooks. `xmap.py diff` sums the static module's objects to 0x135C; the
other 4 bytes are alignment at the ends of its sections, which the two builds
place differently, not bytes of the diagnostics'. Everything loaded with a
battle lies on the chain that ends at the arena (main, overlays 0, 6, 7 and
12), and the data cannot leave the static module without a change to the link:
the readers find it at one address from the boot on, and an overlay's `.bss`
is cleared at each load and shared with the overlays placed over it. Code that
only an overlay off that chain calls costs nothing there: the field overlay
ends 0x38000 below the arena, and the catching demonstration's starter moved
into it (0x40). What else would give room back gives a diagnostic up: eight
lines of the battle's text instead of sixteen, 0x600; sixteen words of the
assertion's stack instead of sixty-four, 0xC0.

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
