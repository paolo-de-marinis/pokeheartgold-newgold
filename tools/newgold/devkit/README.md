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
the learnsets' filter, the Day-Care's egg moves, `DexSpeciesIsInvalid` --
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
the sixteen badges, coins, play time), Squadra and Box (every Pokemon, a
slot editor for species, level, nature, ability, held item, moves, IVs, EVs
and friendship; adding, removing, reordering, moving between box and
party), Borsa, Pokedex (per
species, all at once, and the two switches), Posizione (the `--where`
write), Flag e variabili (by name) and Info (the two halves and the block
table). The name can only be written in letters and digits: that is all
`savedit.charcode` knows, although the game's character set has more. The
species list leaves out what a Pokemon cannot be (the egg, the retail form
rows 496-507, the forms only a battle has); a position must be a tile of
the map, not the black around it.

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
the card marks it "non la impara". A move known twice (an older editor's)
is marked "doppia" and stays while the moves are left alone; moves sent with one twice are
refused, naming it. Saving a Pokemon from its dialog, even with nothing
changed, brings any PP above the move's maximum (`GetMoveMaxPP`; an older
savedit wrote 40) down to it, and the card, the box's tooltip and the
dialog mark such a move "PP oltre il massimo"; a Pokemon not saved keeps
what it has. An ability that is not the one the game
would give the Pokemon (its species written alone by an older editor) is
marked "non sua", and the dialog has it chosen again. A new Pokemon's
friendship is its species' own.

The page has no game data of its own. What exists and every limit -- the
badges and the byte each is kept in, the pockets in the game's order, the
stats, the natures' raised and lowered stat, the directions, the genders,
each item's most, the party, box, level, IV and EV limits -- comes in
`/api/data` from the tree; the page keeps only the Italian names, keyed by
the tree's constants (`BADGE_ZEPHYR`, `POCKET_TMHMS`, `STAT_SPATK`,
`TYPE_FAIRY`...), and shows a constant it has no name for as itself. When
the tree changes under a running server, the page, which polls it, asks for
the data again and reopens the save it shows, icons included; no reload.
The emulator slots are the ROMs `config.mk` and the Makefile say make
builds.

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
  frames, screenshots, a save put where the core reads it.
- `smoke.py` -- builds the host, runs the ROMs, and the scripted route
  through the opening.
- `where.py` -- symbols out of `main.elf`, and the player's position and
  party out of a memory dump.
- `save_budget.py` -- how the save's blocks fit their sectors.

## diag/

Reading what the debug ROM records, and playing it without looking.

- `core.py` -- the same core run in-process, one frame at a time, so a
  script can read memory after every frame and decide what to press.
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
- `frozen.py` -- the ARM9 out of a melonDS savestate once the game stopped.
- `battle.py`, `dump.py` -- a wild battle forced on Route 29 in the
  harness, and its memory dumps read back.
- `pc.py SAVE` -- the PC's storage system opened from a save standing in
  front of a PC, and how full every heap got.
- `species.py OUT` -- every species and form through the screens that load
  its resources: in the PC, in boxes savedit fills (its icon, its sprite,
  its name, Dex number, types and ability on the hover, and its summary
  with the cry it asks for); the Pokedex's list, every page and cry; and a
  wild battle for each, to the command prompt, as markers. A picture is
  compared with its PNG, a text with every other place the same string is
  drawn. `OUT/report.txt` lists what failed, `OUT/fail/` holds a
  screenshot of each failure; `--only`, `--walk` and `--jobs` narrow it.
  The whole of it is about three quarters of an hour at twelve jobs, and
  nothing may be built meanwhile: every job reads the ROM and the ELFs.
- `markers.py` -- the decoding the others share.

Every reader takes the ELF the ROM was linked from, the debug build's by
default, and refuses a game from another build: symbols move every time.
