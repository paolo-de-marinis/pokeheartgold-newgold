# Diagnostics

The readers for what a `NEWGOLD_DIAG=1` build records. What is recorded, and
why it is built this way, is in `docs/newgold/DIAGNOSTICS.md`.

- `live.py` -- read the game somebody is playing in melonDS, from its own
  process memory, without pausing it. `--follow` prints every change.
- `dump.py` -- read the memory dumps a harness run wrote, one line a dump, so
  the run reads as a timeline.
- `gym.py SAVE` -- fight whatever the save puts the player in front of, in
  the headless harness, with the game answering its own prompts
  (`gDiagAutoBattle`): the report is the battle's own text, the battlers
  each time the game waits, what the trainer's AI spent, and the party at
  the end. No screen, no key, no image -- a gym in a few hundred lines of
  text.
- `watch.py` -- the same text for the melonDS that is running: every line
  the battle prints, and the battlers whenever it waits for the player.
- `battle.py` -- play the opening in the harness and start a wild battle on
  Route 29, forced, then read the dumps back.
- `party.py` -- the party of the game running in melonDS, decrypted as the game
  does it: species, level, experience, HP, held item. Experience is what the
  level cap acts on.
- `frozen.py` -- read the ARM9 out of a melonDS savestate (Shift+F1) once the
  game has stopped: the mode, the faulting instruction, the call chain off
  the stack, every address named against the ELF.
- `play.py` -- drive the melonDS on this desktop: launch it on a ROM, bring its
  window to the front, tap its keys through a virtual keyboard, capture its
  window. A gym can be played from a shell, one screenshot a turn.
- `markers.py` -- the decoding the readers share.

Every one of them takes the ELF the running ROM was linked from, and defaults
to the diag build's. Symbols move with every build, so a reading against the
wrong ELF is noise rather than a wrong answer.
