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
| `gDiagWildStage`, `gDiagWildTicks` | `Task_WildEncounter` | How far the wild encounter task got and how often it ran. |
| `gDiagLastWildSpecies`, `gDiagLastWildLevel` | the encounter generator | What the encounter actually made. |
| `gDiagLastBattleMap`, `gDiagLastBattleBg`, `gDiagLastBattleTerrain` | the battle setup | Where the battle was started from and what it chose to draw. A battle whose screen stays black has usually failed to choose one of these. |

| `gDiagBattleText`, `gDiagBattleTextCount` | `BattleSystem_PrintBattleMessage` | The last sixteen lines the battle printed, in the game's own character codes (`charmap.txt` decodes them). The battle as text: "Falkner used a Potion!", "It's super effective!". |
| `gDiagBattlers`, `gDiagBattlePrompt`, `gDiagBattleCommand` | `BattleContext_Main`, every frame | The four battlers -- species, level, HP, status, held item, moves and PP -- and where the player is in choosing (a command, a move, a target, a Pokemon). |
| `gDiagAiItemCount`, `gDiagAiItemLast` | the trainer AI's item use | What the trainer spent in battle. |

And the switches, zero unless something outside the game writes them:

| Switch | Read by | Does |
| --- | --- | --- |
| `gDiagIgnoreCommunicationError` | the main menu | Continue works in a harness that emulates no wireless, where the menu otherwise shows a communication error and resets. |
| `gDiagForceEncounter` | the encounter roll | The roll always succeeds, so the first step on a tile that has encounters starts one. It forces the roll and nothing else: an earlier version also answered "this tile has encounters" and produced a battle in New Bark Town, whose table is surf-only, against species zero. |
| `gDiagForceBattleSpecies` | the step check | The next step starts a wild battle against that species wherever the player stands, indoors included. |
| `gDiagWarpX`, `gDiagWarpZ` | the step check | The next step check puts the player on that tile. The overworld is one coordinate space, so a Route 29 tile written from New Bark Town is Route 29 with its grass and its table. |

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
- `tools/newgold/devkit/diag/gym.py SAVE` fights, in the headless harness, whatever
  the save stands the player in front of, with the auto-battle switch on,
  and prints the battle as text; `tools/newgold/devkit/diag/watch.py` prints the
  same text from the melonDS that is running. Neither needs a screen, and
  neither costs an image to read -- this is how a gym is checked.
- `tools/newgold/devkit/diag/dump.py OUTDIR` reads the `ram:` dumps of a harness run
  the same way, one line a dump, and pastes the run's shots into a sheet.
- `tools/newgold/devkit/diag/battle.py OUTDIR encounter|battle:SPECIES` plays the
  opening in the harness, warps to Route 29, throws a switch, and reads the
  dumps back. About ten minutes from a cold boot. The harness does not draw
  a battle -- its screen goes black the moment overlay 12 loads, on every
  build -- so what it proves is that the encounter rolled, what it made, and
  how far `Battle_Run` got. Whether it draws is a question only melonDS
  answers.

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

## Why it is shaped this way

The main arena has about 44 KB to spare after boot, and a new heap is carved
from it. The first version of the assertion hook recorded `__FILE__` and
`__LINE__` at every `GF_ASSERT` site; that is a string and a literal per site,
17 KB across the static module, and the ROM stopped booting. The return
address costs the site nothing -- `bl Diag_AssertFail` is the size of
`bl GF_AssertFail` -- so that is what is kept, and the ELF turns it back
into a function.

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
