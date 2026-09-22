# Diagnostics

The readers for what a `NEWGOLD_DIAG=1` build records. What is recorded, and
why it is built this way, is in `docs/newgold/DIAGNOSTICS.md`.

- `live.py` -- read the game somebody is playing in melonDS, from its own
  process memory, without pausing it. `--follow` prints every change.
- `dump.py` -- read the memory dumps a harness run wrote, one line a dump, so
  the run reads as a timeline.
- `battle.py` -- play the opening in the harness and start a wild battle on
  Route 29, forced, then read the dumps back.
- `markers.py` -- the decoding the other three share.

Every one of them takes the ELF the running ROM was linked from, and defaults
to the diag build's. Symbols move with every build, so a reading against the
wrong ELF is noise rather than a wrong answer.
