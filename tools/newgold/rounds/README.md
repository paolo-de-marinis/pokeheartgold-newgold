# rounds

A round is several agents working at once, each in its own git worktree on
its own branch, closing rows of the audit; its landing brings the branches
together into newgold. Nine rounds were run this way. These are the tools
they were merged with, the workflow scripts that ran them, and what each
round learnt the hard way. Every tool works on the repository it is run in;
one that takes arguments prints its usage without them.

## A round, end to end

**Worktrees.** One per agent, under `~/hgss-worktrees/<name>`, on branch
`rN-<name>` from newgold's tip:

    git worktree add ~/hgss-worktrees/battle -b r9-battle newgold
    cd ~/hgss-worktrees/battle
    ln -s ~/hgss-newgold/tools/mwccarm ~/hgss-newgold/tools/bin tools/
    for f in ARM9-TS.lcf.template mwldarm.response.template sub/ARM7-TS.lcf.template; do
        cp ~/hgss-newgold/$f $f; done

The compiler, the prebuilt tools and the linker templates are ignored
files, so a worktree needs them from the main tree. `build_at.sh` builds a
fresh worktree, host tools first.

**The rows.** The open rows go to a rows file (`.rounds/roundN/open_rows_rN.txt`)
and each agent gets its share in the workflow's `args` -- the rows, and its
share of the overlay-12 budget (the battle overlay's end is where the main
arena starts; `tests/newgold/test_heaps.py` fails a build that would boot
white). `workflows/audit-round.js` is the round: the rules every agent gets
(decompile to matching C first, one commit one thing, the owner's
decisions, a test that fails if reverted), the memory cap, and the report
it returns. Reports go to `.rounds/roundN/results.json`.

**The numbered lists.** Nine branches from one commit all append to the
same lists, and each takes the same next numbers. What collides, every round:

- battle subscripts: `include/constants/battle_subscript.h` and the file
  names `files/battledata/script/subscript/subscript_NNNN_Name.s`;
- `MOVE_SUBSCRIPT_PTR_*` and its positional table in
  `src/battle/overlay_12_0224E4FC.c`;
- `msg_0197` rows (`files/msgdata/msg/msg_0197.gmm`, written by
  `tools/newgold/import/import_battle_messages.py`'s `PORT_ROWS`), and the
  `FIRST_PORT_ROW + N` count in `test_battle_messages.py`;
- `BMON_DATA_*` in `include/constants/battle.h`;
- the switch-in steps' `case N:` in `TryAbilityOnEntry`, before `end`, and
  the post-move steps' cases;
- `BattleContextSizeCheck` in `src/battle/battle_controller_player.c`, and
  the spare bits of bitfields several branches grow (`SelfTurnData.unk0_11`);
- the test lists: `test_ability_effects.py`'s `PENDING` and `STILL_TO_DO`,
  `test_retail_effect_scripts.py`'s `STILL_DIFFERENT`, `test_move_effects.py`;
- `MOVE_EFFECT_*` numbers, which land in the binary `waza_tbl.narc` and
  cannot be renumbered: one agent a round owns them, and lands last.

The prompt names the next free number of each list; the landing moves them.

**The landing** (`workflows/land-round.js`) runs in its own worktree
(`~/hgss-worktrees/integrate`, branch `rN-integrate` from newgold's tip).
For each branch, in an order that keeps conflicts small:

    shift_branch.py BASE rN-battle rN-integrate rN-battle-shifted
    git cherry-pick BASE..rN-battle-shifted
    pick_on.sh                      # at every stop

`shift_branch.py` rewrites the branch (a temporary index and commit-tree:
same messages, authors and dates) so the subscripts, pointers, message rows
and BMON_DATA it added start after what is already integrated -- in the
headers, the file names, the tests and the commit messages ("subscript 441",
"rows 01805-01807"). Only numbers the branch itself added move; a higher one
it quotes (the reference's subscript 469) is somebody else's.
`pick_on.sh` then resolves the conflicts that have a known shape and
continues the pick, and stops at the first other one, which is read and
resolved by hand so both sides' behaviour survives. Its resolvers, each
usable alone:

- `keep_both.py FILE...` -- every block ours then theirs (appended
  defines); `--fn` puts a closing brace between two new functions that
  shared one;
- `theirs_then_ours.py FILE` -- theirs, then the lines only ours has (a
  comment both sides extended);
- `fix_gmm.py` -- puts back the `</row>` a union merge of two appended
  blocks drops in msg_0197 (so never merge that file with `merge=union`);
- `entry_case.py` -- renumbers theirs' switch-in `case N:` steps after ours;
- `resolve_ability_test.py` -- `PENDING` is ours less what the picked
  commit took out of its parent's, plus what it added, and `STILL_TO_DO`
  its size; an empty one is written `set()` (`{}` would be a dict);
- `port_rows.py` -- `FIRST_PORT_ROW + N`: ours plus the picked commit's delta;
- `selfturn.py` -- both sides' `SelfTurnData` fields, `unk0_11` less the
  bits the picked commit took;
- `size_check.py` -- the size check as ours plus the picked commit's delta,
  its comment extended. Sizes do not add (padding): when in doubt,
  `pick_on.sh --no-size` stops there instead, and `sizefix.py "CLAUSE"`
  resolves it with the size measured by `probe_size.py`, which compiles
  candidate sizes with mwcc and prints the one that compiles (`diag` for the
  NEWGOLD_DIAG layout). The Tera Shell merge once compiled wrong silently
  because a grep hid "Errors caused tool to abort".

After the last pick: `clean_stale_scripts.py` (a renamed subscript's old
`.bin` would be packed), the three ROMs (`build_at.sh -t hg,ss,dhg`),
`test_heaps.py`'s boot margins, `test_boot.py`, the full suite. Host tests
compile stubs of the C they test, so a merge that makes a function call a
new helper breaks another branch's test: those go in one closing commit at
the tip, "tests: what the Nth round's merge moved". The integrator writes
`.rounds/roundN/map.txt`, one line per pick: `old -> new subject || what it closes`.

**Review, fix, docs, check.** Reviewers read the result read-only:

- `survive.py BASE rN-integrate rN-battle-shifted ...` -- every line a
  branch added is still there, and every line it removed stayed removed;
  `--blocks` finds each run of added lines whole and in order;
- `cmp_pairs.py .rounds/roundN/map.txt` -- each pick's patch against the
  original's, file by file, and its message;
- `files_cmp.py [--since REV] BASE TIP rN-battle ...` -- per file, whether
  the tip holds the branch's version, or which of its lines it lacks; REV is
  the last pick, so the fixes after it are marked. Two branches that make the
  same edit (a test count) merge silently into one: check such counters by hand.

A fixer checks each finding and fixes the real ones on `rN-integrate`; the
gyms are replayed on the diagnostics build (`devkit/diag/gym.py`, and
`devkit/diag/whitney.py` for Whitney, whose badge waits for a walk after the
fight) on scratch copies of `~/hgss-saves/gyms`; the docs agent closes the
audit rows and reruns `tools/newgold/ledger.py`; an independent agent
rebuilds, boots and runs the suite again. Then newgold is fast-forwarded to
`rN-integrate`, the main tree's ROMs are rebuilt, and Paolo pushes.

After a round the main tree's build can stop on stale `.d` files naming a
removed `.inc`, and on archives built before a fix: delete them.

## One commit, one thing

- `build_at.sh [-o DIR] [-t hg,ss,dhg,dss] [COMMIT...]` -- the ROMs at each
  commit, md5s to `DIR/md5.txt`: a decompilation commit changes neither ROM.
  Without commits, the working tree as it is.
- `suite_at.sh [-o DIR] COMMIT...` -- the host suite on an export of each
  commit: each passes on its own.
- `test_index.sh TESTMODULE...` -- the tests against what is staged.
- `stage_hunks.py FILE PATTERN...` -- stage only the hunks that contain a
  pattern; `stage_content.sh PATH FILE` -- stage a whole version of a file
  the working tree has moved past.

## Memory and scratch

`/tmp` is a RAM disk, and the PC ran out of memory twice with three
workflows at once. Every build, emulator, harness walk, gym replay and test
suite runs under `tools/newgold/devkit/capped` (`capped -m 8G make -j8 ...`;
a command past its cap is killed alone); scratch, logs, dumps and ROM copies
go under `~/hgss-worktrees/.rounds/<task>/`, with `TMPDIR` there for tests
(test_saveui's fake-ROM test needs the real /tmp: that one failure is
expected). Nine agents at once: make -j6 each, at most two or three
emulators each, `species.py` with a few jobs.

If a round stops half way, every commit an agent made is on its branch and
every finished report is in the workflow's journal: resume only the
unfinished agents, and never send a message to a workflow's agent -- it
starts a second copy in the same worktree.

## workflows/

The Workflow tool's scripts, kept as templates: the prompts are the part
worth keeping. The paths they ran with are constants at the top of each.

- `audit-round.js` -- a round: nine agents, one worktree each (round 9).
- `land-round.js` -- its landing: integrate, review lenses, fix, docs, check.
- `memory-budget.js` -- a late branch merged, then the boot-time arena
  measured three ways and won back, with a margin test (round 7).
- `diagnose-fix-review.js` -- failures found in play: a diagnosis each, one
  fixer, one adversarial reviewer (the Pokedex bugs).
- `feature-shots-review.js` -- a feature, reviewed with the reviewer's own
  harness screenshots (the paged Dex entries).
- `editor-feature.js`, `editor-legal.js` -- save-editor features: research,
  builders, review lenses, fix.

## Not kept

What the rounds wrote that is not here stays in
`~/hgss-worktrees/.rounds/` (nothing was deleted). One line each, by
folder; RND is that folder.

- RND/tools, RND/scratch-archive root: `msg_filter.py`, `seq_edit.py` --
  round 5's commit subjects, fixed in the code; `renumber_subscripts.py` --
  the renumbering inside a pick, before `shift_branch.py`; older copies of
  the merge tools.
- RND/round7/integrate.js, r7-land/round7-land-wf_*.js,
  round8/audit-round8-wf_*.js, round8-land-wf_*.js -- earlier versions of
  the round 9 pair.
- RND/r7-land/{buildat.sh, runchecks.sh}, round8/land/{b.sh, verify/vb.sh},
  round9/land/verify/run.sh, dex-pages/review/build_*.sh and every
  per-worktree build.sh / bt.sh / measure.sh -- `build_at.sh`.
- RND/round8/land/fix/boot10.py -- test_boot ten times; since round 9
  test_boot pins the clock and works out the largest pre-size, and
  `devkit/harness/boots.py` boots across the clock.
- RND/round8/land/audit-survive/{mf.sh, stashes.py} -- one file's
  sequential merge, round 8's stashes.
- RND/round7/tmp/verify/gyms/rungym.py, rungym_whitney.py (both rounds) --
  gym.py now keeps its traceback and reads two-word species; Whitney's walk
  is `devkit/diag/whitney.py`.
- RND/round7/tmp/verify/timeshift.c, round8/tmp/extra1/white/faketime.c --
  boot_check's `clock:` and core.py's `pin_clock()`.
- RND/round9/tmp/dex/vd/* -- melonDS on a nested display, now
  `devkit/diag/nested.py`; `burst.py`'s contact sheets of it.
- RND/round8/tmp/ui/scene.py -- `devkit/diag/scene.py`.
- RND/dex-bugs/B/where_stuck.py -- `core.state()` and `frozen.py`.
- RND/round7/tmp/{xref.py, ovl_ends.py, walk_arena.py, walk_heaps.py,
  arena_dump.py, boot_itcmfs.py}, budget/*, heaplens/scripts/asm_*.py,
  verify/{asm_heap0.py, savepeek.py, battle/*}, lens_hgengine/* -- the
  round-7 arena hunt's probes; test_heaps.py and the heap lens hold what
  they found.
- RND/round8/tmp/{battle, dex, items, moves-types, species, extra*},
  round9/tmp/* -- per-branch patches, drafts of tests now in
  tests/newgold, Dex area probes (now `dex_areas.py`), snapshots of C.
- RND/dex-pages/{harness, review, scratch} -- the paged Dex's shots and
  probes; `dexshot.py` is `scene.py`'s job now.
- RND/dex-bugs/* -- the three Dex failures' walks and probes.
- RND/editor-story/*, saveui-*/*, scratch-archive/{legal-*, saveui-*} --
  the save editor's research probes, intermediate versions and patches,
  all landed.
- RND/scratch-archive root -- the flat harness before `devkit/diag`
  (battlerun.py, grass*.py, routewatch.py, watch*.sh ...); one-off audits,
  comparisons and apply-patch scripts of rounds 1-6; staged test drafts;
  build helpers; small C probes.
- RND/scratch-archive/{e1, decomp, dexr7, ui_r5, ui_r6, x1, var, rod, mt,
  r7mt, mv, extra1, extra2, battle, battle197, species*, ta*, followers,
  sp, sp2, heap, dna, dexc, pk1, c1, patches, btx, chuck, moves_audit_x7,
  audit27_*, g197grp, g728s, grp_mvab, items*, spforms_audit,
  trainers_audit, triage_*} -- per-task scratch: the best of each tool
  family is in `devkit/decomp/`, the rest were one-offs.
- Third-party copies (Showdown's `.ts`, Pokemon Central's Lua module,
  hg-engine checkouts, msgenc), compiled probes and `boot_check` binaries,
  ROM copies and logs: not tools.
