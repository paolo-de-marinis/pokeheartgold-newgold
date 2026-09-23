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
holds it to that.

## saveui.py

    python3 tools/newgold/devkit/saveui.py

opens the save editor in the browser, on http://127.0.0.1:8765 (this
machine only; the next free port if that one is taken). `--library DIR`
picks the folder of saves, `~/hgss-saves` by default; `--build DIR` the
folder holding `heartgold.us`, `heartgold.us.diag` and the rest, this tree's
`build/` by default, which is where the save layout is measured and where
the emulator slots are; `--no-browser` only prints the address. Ctrl+C
stops it. Standard library only; the page is `saveui.html` next to it.

On the left, the library: every `.sav` under the folder and every emulator
slot (the `.sav` melonDS reads beside each ROM), each with the player, the
badges, the party's icons, where the player stands, the save counter and
the date, and a red mark on a file that is not a valid save. From there a
file is opened, duplicated, renamed, put in the bin or taken back out of it,
its history of backups shown and any of them restored; "Carica
nell'emulatore" copies it into a slot, "Prendi dall'emulatore" copies a slot
into the library, and "Gioca" loads it into HeartGold's slot, normal or
diagnostics, and starts melonDS the way `diag/play.py launch` does.

On the right, the open save, in tabs: Allenatore (name, ids, money, gender,
the sixteen badges, coins, play time), Squadra and Box (every Pokemon, a
slot editor for species, level, nature, held item, moves -- with the
learnset at that level a click away -- IVs, EVs and friendship; adding,
removing, reordering, moving between box and party), Borsa, Pokedex (per
species, all at once, and the two switches), Posizione (the `--where`
write), Flag e variabili (by name) and Info (the two halves and the block
table). The name can only be written in letters and digits: that is all
`savedit.charcode` knows, although the game's character set has more.

Nothing is deleted. Before every write the file is copied to
`LIBRARY/.backups/<its path>/<timestamp>.sav` -- an emulator slot to
`.backups/emulatore/<slot>/` -- the new bytes go to a temporary file that
has to open with `savedit.Save`, and a rename puts it in place. "Annulla
ultima modifica" restores the newest backup, keeping the state it replaces
as a backup too. The bin is `LIBRARY/.trash/<timestamp>/<its path>`. melonDS
writes its `.sav` back when it closes, so while it runs the page says so and
refuses every write to a slot. Paths outside the library and the slots,
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
- `markers.py` -- the decoding the others share.

Every reader takes the ELF the ROM was linked from, the debug build's by
default, and refuses a game from another build: symbols move every time.
