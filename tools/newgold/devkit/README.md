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
