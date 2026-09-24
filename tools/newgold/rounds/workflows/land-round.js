// Template: a round's landing: integrate the branches, review, fix, docs, an independent check (round 9, 2026-09-24).
// Kept from .rounds/round9/round9-land.js; tools/newgold/rounds/README.md says how a round runs.
export const meta = {
  name: 'round9-land',
  description: 'Integrate the nine round-9 branches onto newgold, review the merge, fix, build/boot/gyms, write the docs, check independently',
  phases: [
    { title: 'Integrate', detail: 'shift numbers, cherry-pick nine branches onto r9-integrate, resolve, build three ROMs, boot, suite' },
    { title: 'Review', detail: 'every branch survived; the numbered lists and layouts' },
    { title: 'Fix', detail: 'confirmed findings; gyms replayed' },
    { title: 'Docs', detail: 'the audit and the ledger' },
    { title: 'Check', detail: 'independent: nothing lost, boots, suite, docs honest' },
  ],
}

// Where things were on the machine these ran on; set them for yours.
const HOME_ = '/home/paolo'
const TREE = `${HOME_}/hgss-newgold`                     // the main tree, branch newgold
const WORKTREES = `${HOME_}/hgss-worktrees`              // one git worktree per agent
const ROUNDS = `${WORKTREES}/.rounds`                    // rows, reports, scratch: on disk, never /tmp
const MEMORY = `${HOME_}/.claude/projects/-home-paolo-Porting-HGSS/memory`
const ENV = `${HOME_}/hgss-build/env.sh`                 // the project's own wine
const SAVES = `${HOME_}/hgss-saves`                      // Paolo's saves: scratch copies only
const REF = `${HOME_}/Porting HGSS/hg-engine-newgold-reference`
const CAPPED = `${TREE}/tools/newgold/devkit/capped`     // every heavy command runs under it
const MERGE_TOOLS = `${TREE}/tools/newgold/rounds`
const WT = `${WORKTREES}/integrate`
const R = `${ROUNDS}`
const SCR = `${R}/round9/land`
const CONTEXT = `
PROJECT: ${TREE} is pokeheartgold (HeartGold decompilation) with hg-engine (engine layer, reference d0380a487) and konefr's New Gold (reference 1fa3c9366) ported into it as a real decompilation. Round 9 ran nine agents, each in ${WORKTREES}/<name> on branch r9-<name> from newgold at 09fec466b: moves-types, battle, species, trainers-abilities, items, extra2, dex, extra1, ui. All nine are finished; their reports (commits, numbers taken, overlay-12 bytes, notes) are in ${R}/round9/results.json. newgold's tip is c7792defc (09fec466b plus save-editor and docs commits only). The integration happens in the worktree ${WT}, on branch r9-integrate (already created from c7792defc, tools linked; its build/ holds round 8's outputs). Read ${MEMORY}/hgss-merging-parallel-rounds.md, hgss-build-needs-project-wine.md, hgss-scratch-on-disk.md, hgss-two-layers-engine-and-newgold.md, hgss-owner-decisions-2026-09-23.md and -24.md first; the merge tools are in ${MERGE_TOOLS} (shift_branch.py BASE BRANCH TARGET NEWBRANCH renumbers a branch's new battle subscripts / MOVE_SUBSCRIPT_PTR / msg_0197 rows / BMON_DATA after the target's; pick_on.sh continues a cherry-pick auto-resolving the known shapes; probe_size.py measures BattleContext with mwcc; keep_both.py, fix_gmm.py, entry_case.py, size_check.py, resolve_ability_test.py, port_rows.py, clean_stale_scripts.py). Round 8's map for the format: ${R}/round8/map.txt; round 8's landing learnt that two branches making the same edit (a test count) merge silently into one -- check such counters by hand.

MEMORY CAP: run EVERY build, emulator, harness walk, gym replay and test suite through ${CAPPED} (\`capped -m 8G make -j8 ...\`, \`capped python3 ...\`); scratch, logs, dumps and ROM copies under ${SCR}/ (never /tmp); tests with TMPDIR=${SCR}/tmp (test_saveui's fake-ROM test needs the real /tmp: that one failure is expected). Stop every process you start; never 'pkill -f'/'pgrep -f' a pattern in your own command line.

RULES: never touch ${TREE}'s working tree, never merge into newgold, never push. Build ALWAYS as '. ${ENV} && capped -m 8G make -j8 COMPARE=0 <targets>' in ${WT} (the ROM targets directly; GAME_VERSION=SOULSILVER; NEWGOLD_DIAG=1). Generated archives in the source tree can be stale (the main tree once packed 733 old icon files): the fresh worktree has none yet -- keep it clean. Commits: short lowercase subject 'area: ...', plain prose body, last line 'Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>'; cherry-picked commits keep their messages. The saves in ${SAVES} are Paolo's: scratch copies only (falkner.sav and whitney.sav were changed by Paolo: use gyms/before-ot-fix/falkner.sav for Falkner, and tools/newgold/devkit/diag/whitney.py for Whitney: her badge waits for a walk after the fight).`

phase('Integrate')
const integrated = await agent(`${CONTEXT}

YOUR JOB: integrate the nine branches. For each, in an order that keeps conflicts small (suggested: extra1 first -- build rules; then ui, dex, extra2, items, trainers-abilities, battle, species, moves-types last -- it holds the MOVE_EFFECT numbers 445/446, which land in the binary waza_tbl.narc and cannot be renumbered): shift_branch.py 09fec466b r9-<name> r9-integrate r9-<name>-shifted, 'git cherry-pick 09fec466b..r9-<name>-shifted', pick_on.sh on each stop; resolve every other conflict so BOTH sides' behaviour survives (read both commits). Known in advance: several branches grew the same bitfields (SelfTurnData.unk0_11, MoveConditions -- moves-types took it to a fourth byte, size check 0x3264) and BattleContext -- recompute the spare bits and measure the size with probe_size.py; species ported the before-move pass for called moves (9c6d6d8bb) which other branches' move logic may meet; moves-types decompiled overlay 8's party-menu pieces; the test lists (test_ability_effects PENDING/STILL_TO_DO, test_retail_effect_scripts STILL_DIFFERENT, test_battle_messages' count, test_move_effects) -- recompute from the integrated state; decompilations whose context changed must stay byte-identical where they land (rebuild both ROMs at the commit and its parent for any whose asm/main.lsf context changed). Then build HeartGold, SoulSilver and the diagnostics build; run test_heaps (the three boot margins -- they must stay positive; report them) and test_boot; the full suite. Fix what the merge broke in one closing commit 'tests: what the ninth round's merge moved' (or a code-fix commit). Write ${R}/round9/map.txt: one line per picked commit 'old -> new subject || what it closes', plus dropped ones with why. Report: the order, each conflict and resolution, the numbers each branch ended with, the structures' sizes, the md5s, the margins, the suite, the r9-integrate tip.`, { label: 'integrate:r9', phase: 'Integrate' })

const FINDINGS = { type: 'object', properties: {
  lens: { type: 'string' },
  findings: { type: 'array', items: { type: 'object', properties: {
    severity: { type: 'string', enum: ['critical', 'high', 'medium', 'low'] },
    title: { type: 'string' }, evidence: { type: 'string' }, fix: { type: 'string' },
  }, required: ['severity', 'title', 'evidence', 'fix'] } },
  checked: { type: 'string' },
}, required: ['lens', 'findings', 'checked'] }
const LENSES = [
  { key: 'survived', prompt: `LENS: DID EVERY BRANCH SURVIVE? For each of the nine, compare its changes ('git diff 09fec466b r9-<name>' and its commits) with r9-integrate: every hunk present or replaced by an equivalent the integrator explained. Hardest where branches met: the called-move before-move pass (species) against Sky Drop, Revival Blessing and the battle branch's trainer AI and trapping rules; the Berry-eating paths (moves-types) against trainers-abilities' stolen-item restore; the ui branch's decompilations and lazy loads; extra1's no-op make against every branch's generated files.` },
  { key: 'numbers', prompt: `LENS: THE NUMBERED LISTS AND LAYOUTS in r9-integrate: battle subscripts unique, contiguous, each file named by its number and packed (extra1's archive rules: only what the build makes, in number order); MOVE_SUBSCRIPT_PTR and its table; msg_0197 rows unique, contiguous, every place naming one names the right row (grep for any shifted number still named by its old value); BMON_DATA; MOVE_EFFECT 445/446 and waza_tbl.narc regenerated by the importer (rerun import_moves.py against the reference repo path: nothing changes); TryAbilityOnEntry's cases and the post-move steps' numbering; BattleContext's size check against a compiler probe; the bitfields' widths; the boot margins from test_heaps' own numbers.` },
]
phase('Review')
const reviews = await parallel(LENSES.map(l => () => agent(`${CONTEXT}\n\nThe nine branches were integrated into r9-integrate in ${WT}; the integrator's report:\n${integrated}\n\n${l.prompt}\n\nDo NOT change files or commit (a probe compile of one object is fine): findings only, each with evidence.`, { label: `review:${l.key}`, phase: 'Review', schema: FINDINGS })))
const all = reviews.filter(Boolean).flatMap(r => r.findings.map(f => ({ ...f, lens: r.lens })))
log(`${all.length} findings`)

phase('Fix')
const fixed = await agent(`${CONTEXT}\n\nIntegrator's report:\n${integrated}\n\nAll the review findings, as JSON:\n${JSON.stringify(all, null, 1)}\n\nYOUR JOB: check each finding (some may be wrong: say so with evidence), fix every real one on r9-integrate in commits of one thing with a test where one can hold it. Then rebuild HeartGold, SoulSilver and the diagnostics build, run test_heaps, test_boot (10 boots of each ROM with the harness, capped) and the full suite, and replay the four gyms on the diagnostics build with tools/newgold/devkit/diag/gym.py on scratch copies (see RULES for which saves): each badge won, no assertion, no failed allocation -- report the lines. Update ${R}/round9/map.txt if commits changed. Report each finding as fixed / not a defect / left, the commits, md5s, margins, suite, gyms, and the tip.`, { label: 'fix:r9', phase: 'Fix' })

phase('Docs')
const docs = await agent(`${CONTEXT}\n\nIntegrator's report:\n${integrated}\n\nFix report:\n${fixed}\n\nYOUR JOB, on r9-integrate in ${WT}: one commit 'docs: the ninth round's rows closed and its findings added' (as 46fed1c81 did for round 8: 'git show --stat 46fed1c81'). In docs/newgold/AUDIT-2026-09-23.md close each row round 9 closed with the commit that closes it (the reports and map.txt; translate hashes to their r9-integrate hashes by subject), keep open with the remaining part where a report says not_closed (retail effect scripts: 151 Solar Beam and 272 Shadow Force, with the new reason; Commander's counters sub-point: a host test), close with the reason: 'Kleavor's only wild slot' as konefr's own data (his ff4c57ff5 contest patch; the extra2 report's evidence), 'the Union Room's heaps are close' as measured (the ui report); '78 moves the engine leaves unimplemented' is done except the 18 Max moves, out of scope; add the new findings from every report as open rows with their severity in a new section 'Found in the ninth round, 2026-09-24'. docs/newgold/LEDGER.md: the rows whose state changed (moves: every effect but the 18 Max moves; the harness can now watch a battle -- nested.py runs melonDS on a display of its own, and core.py draws battles per the moves-types report: say what was seen). Then 'python3 tools/newgold/ledger.py' and check '--check' and test_ledger pass. Report the open rows before and after.`, { label: 'docs:r9', phase: 'Docs' })

phase('Check')
const check = await agent(`${CONTEXT}\n\nReports -- integrate:\n${integrated}\n\nfix:\n${fixed}\n\ndocs:\n${docs}\n\nYOUR JOB, adversarially and read-only (commit nothing): (1) range-diff and file-level comparison: every change of the nine r9-* branches is in r9-integrate or its replacement is explained; (2) rebuild the three ROMs (capped, -j8) and confirm the fix report's md5s; boot each 10 times in the harness, capped; test_heaps' margins; (3) the full suite; (4) spot-check ten closed audit rows against the commits they name, and that no not_closed row was marked done; (5) the ledger is current. Report findings marked critical/high/medium/low with evidence, or 'none'.`, { label: 'check:r9', phase: 'Check' })

return { integrated, reviews: reviews.filter(Boolean), fixed, docs, check }
