# devkit

What anyone building on this tree uses to work on the game -- the port or
any other hack. It goes with the engine, not with New Gold's content: the
in-game tools konefr wrote for himself (the Cherrygrove vendor, the EV
presets) are part of his game and live in its data, not here.

The port's own machinery -- the importers that read konefr's tree and write
this one's data -- is next door in `tools/newgold/import/`, and the ledger
in `tools/newgold/ledger.py`.

## The debug ROM

    make -j10 COMPARE=0 NEWGOLD_DIAG=1

builds the game with the diagnostics in, to `build/heartgold.us.diag/`
(`GAME_VERSION=SOULSILVER` works the same way). Without the variable the
ROM is byte for byte the ROM without them; `tests/newgold/test_diag.py`
fails on a hook outside `#ifdef NEWGOLD_DIAG`. What the diagnostics record,
and why they are shaped the way they are, is `docs/newgold/DIAGNOSTICS.md`.
The ROM side is `src/newgold/diag/` and `include/newgold/diag.h`.

## savedit.py

Edits a save file the way the game reads it -- checksums, the half the
game loads, the blocks by name. The party (`--party SPECIES:LEVEL::MOVE+MOVE`,
always the player's own, so it obeys), the bag, TMs, badges, the Dex, the
position (`--where MAP:X:Y:DIR`, as a warp so the map builds itself), script
flags (`--flag NAME`) and variables (`--var NAME=VALUE`). The gym saves in
`~/hgss-saves/gyms` are made with it; their README says how.

It is a library as well: every option is a function of a `Save`, and it
reads everything else -- the party and all nine hundred box slots decoded,
the bag, the Dex, the position, any flag or variable by name -- with the
game's own names out of its message banks. `Save.image()` writes back only
the newest half and only the blocks that changed, so a save opened and
written back unchanged is the same bytes; `tests/newgold/test_savedit.py`
holds it to that. The game's next save goes into the other half and writes
only the PC boxes `boxModifiedFlag` names, so `image()` adds every box it
changed to that flag -- otherwise the next boot would call the save corrupt
and load the one before; the test replays the game's save to check it.
Pokemon it makes are the game's in the details that bite: the moves
`InitBoxMonMoveset` would give, `Mail_Init`'s empty mail record, the stats
of the form's own record (`ResolveMonForm`).

It holds a Pokemon to what its species can have. `learnable_moves` is every
move a species can know at any level, each with every way it is learnt: its
level-up learnset (`wotbl.narc`; level 0 is on evolving) without the moves
`IsMoveUnimplemented` flags, which `LoadLevelUpLearnset_HandleAlternateForm`
drops for every reader, the TMs, HMs and TRs its `personal.json` record is
compatible with (`sTMHMMoves` and `ItemToTMHMId` in `src/item.c`), the move
tutors (`waza_oshie.json` through `sTutorMoves`, at the record
`GetMoveTutorLearnsetIndex` reads; and the Blackthorn tutor's script,
`scr_seq_0948_T30R0601.s`, which teaches its move to a Pokemon of the type
its `GetMonTypes` tests name), its own egg moves (`kowaza_list.narc`) -- an
egg's, for a species an egg hatches as (`pms.narc`, `Daycare_GetEggSpecies`,
`sIncenseMons`), with the one `Daycare_LightBallCheck` adds for a parent's
Light Ball, or, for a species no egg hatches as, the Day-Care's
(`Daycare_LearnEggMovesFrom`: a Mirror Herb, or two of the same species) --
a Rotom form's own move (`sRotomFormMoves`, which the Rotom Catalog
teaches), and the same for its pre-evolutions (`evo.json`, and
`EvolvedPassiveForm`'s two form species: a form the game never evolves into
has none). `species_abilities` is its first, second and hidden ability by
the slot the game keeps each in: the personality's low bit (an Ability
Capsule turns it over) or `MON_HIDDEN_ABILITY_BIT`, which
`UpdateBoxMonAbility` reads again on evolving. `edit_mon` and `new_mon`
refuse anything else (`Illegal`), and a move given twice, which the game
never teaches (`TryAppendBoxMonMove`). The level is not checked: a level-up move
is allowed at any level, as an egg inherits one both its parents know
whatever the level it is learnt at (`InheritMoves`); for a species no egg
hatches as, a move above its level is for the user to avoid. A species
change brings the new species' moves at that level (`preset_moves`) and the
ability the game gives it, and only a Pokemon keeping its species keeps a
move it already knew that no rule lists, an event's. The moves a script
gives one Pokemon only -- Brock's traded Rhyhorn's Thunder Fang
(`SetMonMove`), the spiky-eared Pichu's Volt Tackle and Pain Split -- are
such moves: kept on the Pokemon that has them, never added to another.

What the player was given outside the bag is read where the game keeps it:
the running shoes (`LocalFieldData.player`, in a struct
`src/save_local_field_data.c` declares for itself, which `compile_c` takes
as a declaration), the start menu's entries by the flag each case of
`FieldSystem_ShouldDrawStartMenuIcon` checks, the Pokégear's cards and map
(`SavePokegear`'s bitfields), and the level cap `GetLevelCap` makes of the
badges and its milestones.

The story is read out of the event scripts (`story()`). A step starts at a
marker -- a `GiveBadge`, a scripted `TrainerBattle`, `GiveRunningShoes`,
`GivePokedex`, `RegisterPokegearCard`, `ScrCmd_804`, `NatDexFlagAction 1`,
an item given after `GoToIfNoItemSpace` -- or, where no other step passes, a
`SetFlag` of a story flag (one of any section of flags.h but those that are
no story: hide/show, items, trainers, system), a `GiveItemNoCheck`, or a
`SetVar` of a variable that keeps the player out of a gym (Morty's, until
the Burned Tower); it runs straight on, through `GoTo` and `Call`, to `End`
or the next marker, a jump decided on what it wrote itself before it, and a
battle whose win runs into a marker opens that marker's step. After a
battle the field is built again and runs its map's OnLoad and OnResume
scripts (`fieldmap.c`), so the walk runs them too: Route 36's hides the
Sudowoodo once it was fought. A step also brings its scene before the
marker: what the game writes on every way there from the script's entry
with no other marker on it (`_before`) -- the Burned Tower's beasts, hidden
before the `SetVar` that opens Morty's gym; the Expansion Card's flag, set
before its card, is one step with it. Each step has what it writes, what
the game tests on the way to it from the script's entry (a trigger tile's variable, the map's frame
table, `CheckBadge`, `HasItem`, `GoToIfSet` and the rest: the positive
ones), and the steps that give that. `badge_chains()` is each badge's gym in
order -- Whitney beaten, the lass's trigger, the badge, TM45 -- from those
links and the step a walk stops at (Pryce's TM07, given in the badge's
scene). `run_step` runs a step on a save as the game would, each jump decided
on the save (Chuck's badge starts the Rocket takeover only as the third
midgame badge; a gift the bag has no room for, `GoToIfNoItemSpace`, is not
given), taking what `TakeItem` takes and the money `SubMoneyImmediate` does,
and naming what it does not do itself (a Pokemon or an egg given, a roamer
let loose); noting what each thing it writes held before (`record`), and
`undo_step` takes one back: given that record, each thing
the run left untouched since goes back to what it found; the rest -- a
step done by playing -- by what the step writes: undone, a flag it only
held for the scene (`FLAG_ENGAGING_STATIC_POKEMON` around a battle) left
alone, a `SetVar` in a gym put back to what the step before it there sets,
or to the gate's value, or to the highest lower value a script gives it
(0, the new game's, with none), any other `SetVar` left and named, as its
old value is not known.

Where the player can stand is read from the land data (the file
`filesystem_files_def.h` gives `NARC_fielddata_landdata_land_data`): each
tile's attribute, its collision bit and its behaviour byte, which the field's
loader reads after a member's sound section (`ov01_021F4AAC`;
`TerrainAttributes_Load`'s fixed offset is right only where that section is
empty, and Sprout Tower's is not). `ground(map)` is where the game puts the
player on a map, in the order tried: the fly point (`GetFlyWarpData` over
`sSpawnMaps`), the heal spawn (`GetDeathWarpData`, a row that is one), each
warp of its zone events -- its own tile, or the first free neighbour of a
door set in a wall -- and, on a matrix shared with other maps, a step in
from another map's ground; `preset(map)` is the first of them, with the
direction the game faces the player in. `tile_problem` says why a tile is
no place to stand: off the map's chunks, a wall, surfable water
(`MetatileBehavior_IsSurfableWater`), an object of the map, or -- in a
building (`MapHeader_IsInBuilding`) -- joined to no arrival and no person of
the map: the empty space around a room. Outside, ledges and climbs part
ground the player reaches, so there it is not asked. `town_map()` is the
Pokégear's town map, both regions, drawn as the game draws it: the tiles'
PNG laid out by the screen `PokegearMap_LoadGraphics` loads, over the window
`ov101_021EAF40` copies, in the colours of the NCLR
`PokegearMap_LoadPalettes` loads for it (a new game's skin). `town_tiles()`
is where each map is on it -- a map of the main matrix at the chunks it
owns, rows moved as
`PokegearMap_InitInternal` moves them, any other at its header's world
coordinates -- and `town_tile` where the Pokégear marks the player.

`machine_table()` is every TM, TR and HM as the bag keeps them: in
`SortTMHMPocket`'s order, each with its move, the move's type, how many the
bag takes, and whether a use spends it (a TR, as `PartyMenu_LearnMoveToSlot`
takes one only then).

Nothing the game has is typed into it: all of it is read from the tree as
the build would compile it, and read again once a file it came from has
changed (`fresh()`, which saveui calls before every request; a reading is
kept only while its files are unchanged). The save's layout -- every size,
offset and limit, from the Pokemon's size and the Dex's offsets to the party
size, `MAX_EV_PER_STAT` and `Mail_Init`'s values -- is what the host
compiler makes of the headers with `config.mk`'s defines, 32-bit pointers
and signed char (`_layout`, `compile_c`: nothing is run, the numbers are
read out of the assembly). The learnsets' entries and the move records are
laid out as `include/pokemon.h`'s `LEVEL_UP_LEARNSET_` macros and
`struct MoveTbl` say. The tables are read out of the C that has them: the block
order (`GetSubstruct`), `gNatureStatMods`, `ResolveMonForm`'s forms, the
pockets (`struct Bag`, `Bag_GetItemPocket`, `sPockets`), which items are
TMs, HMs and TRs (`ItemIsTM` and the rest), the message banks
(`message_format.c`'s Buffer functions), the icons' numbers
(`GetMonIconNaixEx`). The blocks' sizes are the one thing measured from the
build, since the game's `Save_*_sizeof` exist in no other form; the page
says when a header the layout is read from is newer than that build.

What the game has only as code -- a Pokemon's byte offsets and bits, the
footers, the encryption's generator, `SHINY_CHECK`, the nature as
`pid % 25`, `GENDER_RATIO`, the flash's halves, the clock's 999 hours, the tutor
record's index, the badges' two bytes, a TM's one copy, the machines' sort,
`CalcMonStats`, `UpdateBoxMonAbility`, `InitBoxMonMoveset`, `LoadEggMoves`,
the learnsets' filter, the Day-Care's egg moves, `DexSpeciesIsInvalid`, a
tile's collision bit and behaviour byte, the land data's sound section --
stays code in savedit, and `TheCodeSaveditKeeps` in `test_savedit.py` reads
each from the tree and fails the day they differ.

## saveui.py

A double click on `Editor salvataggi` in this folder (`Editor
salvataggi.desktop`) starts the save editor and opens it in the browser; a
second double click while it runs only opens the page again, and "Chiudi
l'editor" in the page stops it. From a terminal it is

    python3 tools/newgold/devkit/saveui.py

on http://127.0.0.1:8765 (this machine only; the next free port if that one
is taken). `python3 tools/newgold/devkit/saveui.py --install-launcher` also
puts it in the desktop's application menu.

Which folder holds the saves and which ROMs melonDS plays are chosen in the
page, "Cartelle e ROM", browsing the disk from the home folder, and kept in
`~/.config/newgold-saveui/settings.json` for the next start. Until something
is chosen the folder is `~/hgss-saves` and the ROMs are the ones built under
`--build` (this tree's `build/`); every ROM is an emulator slot, the `.sav`
of the same name beside it, and "Gioca" wants a HeartGold one (the cartridge
header's game code) since the saves are HeartGold's. With no folder there
the page opens on "Cartelle e ROM" and nothing is read or written until one
is chosen. `--library DIR` sets the folder for one run; `--build DIR` is
also where the save layout is measured (`heartgold.us`: without its
`main.sbin` and `main.elf`, during a `make clean` for one, the page says so
instead of reading any save); `--no-browser` only prints the address.
Standard library only; the page is `saveui.html` next to it.

On the left, the library: every `.sav` under the folder and every emulator
slot (the `.sav` melonDS reads beside each ROM), each with the player, the
badges, the party's icons, where the player stands, the save counter and
the date, and a red mark on a file that is not a valid save. From there a
file is opened, duplicated, renamed, put in the bin or taken back out of it,
its history of backups shown and any of them restored; "Carica
nell'emulatore" copies it into a slot, "Prendi dall'emulatore" copies a slot
into the library, and "Gioca" loads it into HeartGold's slot, normal or
diagnostics or any HeartGold ROM chosen, and starts melonDS the way
`diag/play.py launch` does -- then waits for its window, and if none comes
the page shows what flatpak said (`~/.cache/newgold-saveui/melonds.log`).
A slot holding a save that no library file is -- what was played there
since it was loaded -- is not loaded over without asking: the page offers
to take it into the library first. A slot's own "Gioca" starts melonDS on
it as it is.

On the right, the open save, in tabs: Allenatore (name, ids, money, gender,
coins, play time, and the story), Squadra and Box (every Pokemon, a
slot editor for species, level, nature, ability, held item, moves, IVs, EVs
and friendship; adding, removing, reordering, moving between box and
party), Borsa (the machines as a checklist, the Pokedex's way: every TM, TR
and HM with its move and type, "ce l'ho", and a count for a TR, which a use
spends; searched by "MT 45" as by "TM045"; written as the game keeps the
pocket, 101 slots at most), Pokedex (per
species, all at once, and the two switches), Posizione (the `--where`
write, the map picked from a list or on the town map), Flag e variabili (by
name) and Info (the two halves and the block table). The name can only be written in letters and digits: that is all
`savedit.charcode` knows, although the game's character set has more. The
species list leaves out what a Pokemon cannot be (the egg, the retail form
rows 496-507, the forms only a battle has).

Posizione: the map field is a search over every map, grouped by its section
(the name the game shows) with its region and kind, as a move field is --
Italian words for its constant's words match too ("centro", "palestra"),
and a map a blackout sends the player to is tagged; above it the
Pokégear's town map, both regions, with the player marked and the player's
section lit. Hovering names the places under the pointer and the one a
click picks (the town, the route), which fills the field; on a phone the
map keeps its size and scrolls in its box, and a first tap names, a second
picks. A map picked in the field lights its section on the town map.
Picking a map puts in x, y and the direction the game itself would give --
the fly point, the heal spawn, a door's arrival (`savedit.preset`), or
empties them where there is none; they stay editable, and the server
refuses in Italian a tile off the map or where the player could not stand,
naming the place that is safe (`savedit.tile_problem`).

The story in Allenatore: the start menu's entries and the running shoes,
the Pokédex and the Pokégear (each card on its own, as
`SavePokegear_RegisterCard` ORs it in), the level cap, the sixteen badges
each with its gym's steps beside it, and every other step by place, with a
search that also matches the constants a step writes and tests (`squirt`
finds the Flower Shop's bottle and the Sudowoodo that wants it). A step
another of its place shares a name with, or named only by a constant, says
what tells it apart. Ticking a step runs it as the game does and offers the
steps before it (in its gym, or the ones giving what it tests), or those
alone ("Solo i passi prima"), which leaves the save just before it, to play
it; unticking takes it back and offers the ones after it. What a run here
found is kept beside the file's backups (`storia.json`), so a step ticked
and unticked leaves the file as it was, and a variable an undo could only
leave is shown under its step while it holds that value. Nothing is forced,
so a save can stand between two steps -- Whitney beaten, the badge not
given. A badge ticked on its own asks: as the game (its step, with what the
script writes with it) or the bit alone, which says the counters it leaves.
Each step shows what it writes -- and what the editor does not do, an egg
given, a roamer -- and what the game tests before it, met or not, and the
step giving it: the Sudowoodo wants the SquirtBottle, which the Flower Shop
gives only with the Plain Badge; under a badge, the steps outside its gym
that test it can be ticked there too. A tick keeps what was typed in the
form above it and not saved yet.

In the Pokemon dialog a move is picked only from the species'
`learnable_moves`, each shown with all its sources as tags (Lv. 36, MT 035,
Insegnante, Mossa uovo, da Ponyta Lv. 20...), and the ability from its
`species_abilities`. Changing the species puts in, at once, the moves the
game gives the new species at that level and the ability it would give this
Pokemon as that species; typing its own species back puts back its own.
"Mosse per livello" puts in the same moves, and moves put in this way follow
the level while they are left alone. The server refuses in Italian a move or
an ability the species cannot have, whatever sent it; a move the Pokemon
already knew that the species does not learn (an event's, or one the data no
longer gives it) stays while it is left alone and the species is kept, and
the card marks it "non la impara". A move field's list leaves out the moves
the other fields hold, so the page never makes a move twice; the server
still refuses moves sent with one twice, naming it, and a Pokemon an older
editor gave a move twice keeps it while its moves are left alone. Saving a
Pokemon from its dialog, even with nothing changed, brings any PP above the
move's maximum (`GetMoveMaxPP`; an older savedit wrote 40) down to it; a
Pokemon not saved keeps what it has. An ability that is not the one the game
would give the Pokemon (its species written alone by an older editor) is
marked "non sua", and the dialog has it chosen again. A new Pokemon's
friendship is its species' own.

The page has no game data of its own. What exists and every limit -- the
badges and the byte each is kept in, the pockets in the game's order, the
stats, the natures' raised and lowered stat, the directions, the genders,
each item's most, the party, box, level, IV and EV limits -- comes in
`/api/data` from the tree; the page keeps only the Italian names, keyed by
the tree's constants (`BADGE_ZEPHYR`, `POCKET_TMHMS`, `STAT_SPATK`,
`TYPE_FAIRY`, `START_MENU_ICON_BAG`, `GEARCARD_RADIO`, a story flag,
`MAP_TYPE_CAVE`, `MAP_REGION_KANTO`...), and
shows a constant it has no name for as itself. A part the server cannot
read from the tree -- the town map, the story, the machines, the start
menu's entries, the level cap, the field moves -- comes empty with the
reason (`errors`), which the page shows in a banner, and the rest still
loads. When the tree changes under a running server, the page, which polls it, asks for the data again and
reopens the save it shows, icons included; no reload. The emulator slots are
the ROMs `config.mk` and the Makefile say make builds.

Nothing is deleted. Before every write the file is copied to
`LIBRARY/.backups/<its path>/<timestamp>.sav` -- an emulator slot to
`.backups/emulatore/<slot>/` -- the new bytes go to a temporary file that
has to open with `savedit.Save`, and a rename puts it in place. "Annulla
ultima modifica" restores the newest backup, keeping the state it replaces
as a backup too -- unless the file has changed since that edit (a session in
melonDS), which going back would throw away; Cronologia restores any backup
on purpose. The page sends the version of the file it shows with every
edit, and a file that has moved on since is reloaded rather than written
with the old values. The bin is `LIBRARY/.trash/<timestamp>/<its path>`,
and a file's backups go with it (`.backups/.cestino/`); a new file never
inherits the history of an old one of the same name (that is set aside in
`.backups/.vecchie/`). melonDS writes its `.sav` back when it closes, so
while it runs the page says so and refuses every write to a slot, and
taking one, however the slot is reached. A slot is loaded or played only beside a
real ROM -- a Nintendo DS header whose two checksums hold, and a file as
long as the header says -- in a folder the melonDS flatpak can write to
(`flatpak info --show-permissions` says `home` here; never `/tmp`, which the
sandbox keeps private); the page shows why a slot is not usable.
`--dry-run-launch`, or `SAVEUI_DRY_RUN=1`, makes "Gioca" print the command
instead of starting melonDS, and skips the sandbox check with it; the tests
run that way. Paths outside the library and the slots,
symbolic links included, are refused, and the server answers only this page
(its own Host and Origin, JSON bodies). `tests/newgold/test_saveui.py`
drives every endpoint against a temporary library.

## harness/

The emulator with no screen: the melonDS libretro core, driven from a list
of actions fixed before the run.

- `boot_check.c` -- the host: presses, touches, holds and pokes at given
  frames, memory dumps, a small window of memory sampled every so many
  frames, screenshots, a save put where the core reads it, and the clock
  pinned (`clock:SECONDS`): the core takes the console's from the host's, and
  the boot's random pre-size follows it.
- `smoke.py` -- builds the host, runs the ROMs, and the scripted route
  through the opening. A run is at `smoke.CLOCK` unless its actions name a
  clock (`clock:-1` is the host's), so the RNG's seed and the time of day are
  the same every run and a replay does what the last one did.
- `where.py` -- symbols out of `main.elf`, and the player's position and
  party out of a memory dump.
- `save_budget.py` -- how the save's blocks fit their sectors.
- `boots.py BUILD OUT OFFSET...` -- one ROM booted at many console clocks
  (`clock:`, a second each), each boot's pre-size, the arena it left and
  what would be left at the largest pre-size, and a screen that stayed
  blank: the sweep behind test_boot's one pinned boot.

## diag/

Reading what the debug ROM records, and playing it without looking.

- `core.py` -- the same core run in-process, one frame at a time, so a
  script can read memory after every frame and decide what to press. In
  Python the core reads the C library's clock: `pin_clock()`, first thing in
  a script, runs it again with a `time()` preloaded that answers the same
  second as the harness's.
- `gym.py SAVE` -- fights what the save stands the player in front of,
  through the game's own menus, and reports the battle as text: every line
  it printed, the battlers each turn, what the trainer's AI spent, what
  asserted and where, the party before and after. No image.
- `watch.py` -- the same text for the melonDS that is running.
- `live.py` -- one line about the running melonDS: field, encounter,
  battle, failures.
- `party.py` -- the party of the running game, decrypted as the game does.
- `play.py` -- drives the melonDS on this desktop: launch, focus, keys,
  a screenshot when one is really needed.
- `nested.py` -- the same melonDS on a display of its own (a headless
  KWin, a rootful Xwayland in it, a HOME and runtime directory of its own
  under `build/nested/`), so nothing opens, sounds or types on the desktop:
  start from a ROM and a save, keys and taps, a screenshot, stop.
- `frozen.py` -- the ARM9 out of a melonDS savestate once the game stopped.
- `battle.py`, `dump.py` -- a wild battle forced on Route 29 in the
  harness, and its memory dumps read back.
- `pc.py SAVE` -- the PC's storage system opened from a save standing in
  front of a PC, and how full every heap got.
- `scene.py SAVE OUT STEP...` -- any scene played from a save by steps
  given on the command line (presses, taps, drags, waits, pokes by symbol),
  with screenshots and every heap's low water where asked, the communication
  error held off. The marts, the Move Relearner, the summary, the bag, the
  PC, trades, the Union Room, the GTS's first screens and the Pokeathlon's
  team choice were measured with it.
- `species.py OUT` -- every species and form through the screens that load
  its resources: in the PC, in boxes savedit fills (its icon, its sprite,
  its name, Dex number, types and ability on the hover, and its summary's
  Info and Skills pages with the cry it asks for); the Pokedex's list,
  every page and cry; its DETAILS, the AREA page against zukan_enc and
  every entry of FORMS with both pictures; and a wild battle for each, to
  the command prompt, as markers. A picture is compared with its PNG, a
  text with every other place the same string is drawn. `OUT/report.txt`
  lists what failed, `OUT/fail/` holds a screenshot of each failure;
  `--only`, `--walk` and `--jobs` narrow it. The whole of it is about three
  quarters of an hour at twelve jobs (`--walk pc,details` two hours at two),
  and nothing may be built meanwhile: every job reads the ROM and the ELFs.
- `markers.py` -- the decoding the others share.
- `whitney.py SAVE` -- gym.py for Whitney, and the walk her badge waits
  for: after the fight, south onto the Lass's trigger and back to her.
- `trace.py SAVE --touch X,Y,WAIT ...` -- the battle scripts and controller
  commands a turn runs through, frame by frame; Ally Switch's turn was
  followed with it.
- `ingame_save.py SAVE OUT` -- the game continues a save and saves it
  through the start menu; OUT is what it wrote to flash. A save savedit
  wrote is proved on it.
- `heapblocks.py DUMP [--heap N]` -- one heap's used and free blocks in a
  memory dump, biggest first, with their first bytes: what fills a heap
  when an allocation from it fails.
- `heaplens/` -- how full the four boot heaps and the arena get, scene by
  scene (`lens.json`: each heap's least left, failed allocations,
  asserts). `drive.py SAVE OUT STEP...` plays steps from a save -- the start
  menu's applications, the PC, a catch, an evolution, a communication error;
  `gymlens.py` a leader's fight; `opening.py` the opening. `saves.py`
  makes the saves the scenes start from, `scenes.sh` is round 7's catalogue
  of scenes, and `snap.sh TREE DEST` copies a tree's build and tools aside
  (run with `SNAP=DEST`), so a long run reads one build while the tree is
  rebuilt under it.
- A game that stops in-process raises no data abort: the script writes
  `core.state()` to a file, and `frozen.py` reads it as it reads a melonDS
  savestate.

Every reader takes the ELF the ROM was linked from, the debug build's by
default, and refuses a game from another build: symbols move every time.

## capped

    capped [-m 4G] COMMAND...

The command in its own systemd scope with a memory cap (4G unless told,
and no more than 1G of swap): past it the kernel kills that command alone,
not the machine. A harness walk once grew to 12 GB a copy and took the
session down with it. Builds, emulators, harness walks, gym replays and
test suites run under it: `capped -m 8G make -j8 ...`.

## Builds and ROMs

- `xmap.py objects|diff|growth` -- a module's bytes by object file and by
  symbol, from a build's `main.elf.xMAP`, and how it grew between two
  builds: overlay 12's end is where the main arena starts, and its budget
  is read with this.
- `ndsfiles.py A B` -- which files of two ROMs differ, by their paths in
  the ROM's file system, arm9, arm7 and the overlays.
- `narccheck.py ARCHIVE FOLDER` -- a built NARC's members against the files
  its `.narcorder` lists: a stale archive in the source tree.
