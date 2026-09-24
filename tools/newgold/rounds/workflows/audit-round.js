// Template: a round: nine agents, one worktree each, closing open audit rows (round 9, 2026-09-24).
// Kept from .rounds/round9/audit-round9.js; tools/newgold/rounds/README.md says how a round runs.
// args (the Workflow tool's): one entry per worktree, the rows its agent
// closes and its share of the numbered lists, e.g.
//   [{ wt: 'moves-types', text: "OV12 BUDGET: 0x1000 bytes (...). YOU ARE THE ONLY AGENT THIS ROUND WHO ADDS MOVE_EFFECT NUMBERS (next after 444; ...). YOUR ROWS: 'Matcha Gotcha drains only when its burn rolls'; 'Body Press reads the user's own Defense under Wonder Room'; ..." },
//    { wt: 'battle', text: '...' }, ...]
export const meta = {
  name: 'audit-round9',
  description: 'Round 9: the 43 open audit rows (round 8 findings, the last two moves, the called-move before-move pass, the Wi-Fi loads) — nine agents, one worktree each',
  phases: [{ title: 'Implement', detail: 'nine agents, one worktree each, branches r9-* from newgold 09fec466b' }],
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
const ROWS = `${ROUNDS}/round9/open_rows_r9.txt`
const COMMON = `
You are closing open rows of a port's audit. Port: ${TREE} (pokeheartgold decompilation + hg-engine's full range + konefr's New Gold; forms are species 1042..1437 and register/print as their base; TYPE_FAIRY = 18; items renumbered via tools/newgold/import/item_map.csv). You work in your OWN git worktree (below), on its own branch r9-<name> from newgold at 09fec466b, with tools/mwccarm and tools/bin symlinked and an earlier build. Start EVERY shell command with \`cd <your worktree> &&\` or use absolute paths inside it. Never edit ${TREE} or another worktree. Do not push. Do NOT edit docs/newgold/LEDGER.md, docs/newgold/AUDIT-2026-09-23.md, README.md or docs/index.html -- report instead. The open rows' full text is in ${ROWS} and, with context, in docs/newgold/AUDIT-2026-09-23.md in your worktree (mostly the 'Found in the eighth round' section; the round-8 reports are in ${ROUNDS}/round8/results.json and map.txt). The memory notes in ${MEMORY}/ (MEMORY.md is the index) hold what earlier rounds learnt: read the ones your rows touch.

OWNER DECISIONS (Paolo -- apply, do not re-ask): reference defects are fixed to canonical behaviour, never copied, and the commit says why; every ability, move or item effect the reference leaves empty is programmed with its canonical effect -- the spec is its page on Pokemon Central, the Italian wiki (find the Italian name with WebSearch/WebFetch, e.g. "site:wiki.pokemoncentral.it <English name>"), latest generation and latest game version, adapted only where this game lacks the mechanic (no Terastallization, no Dynamax), with the adaptation said in the commit and the comment; where Pokemon Central's pages disagree, follow the latest game version's rule and say which page you followed; added species earn no Pokeathlon medals; marts stay retail; Pokewalker is out of scope; Mega Evolution, Z-Moves, Dynamax and Terastallization machinery stay out of scope; Black Belt Nob keeps konefr's team; the placeholder pictures stay konefr's; the saves in ${SAVES} are Paolo's -- never modify them (scratch copies only).

RULES (strict):
- Decompilation only: no byte patches, hooks, repointed tables or fixed addresses. Assembly is first converted to MATCHING C in its own commit that changes neither ROM by a byte (md5 of build/heartgold.us/pokeheartgold.us.nds and build/soulsilver.us/pokesoulsilver.us.nds before and after; examples bc8e8908b, cb17617bd, e87865d7f). The behaviour change is a separate commit.
- One commit, one thing. Engine (hg-engine d0380a487) and New Gold (konefr's range d0380a487..1fa3c9366, his tip) never share a commit; where both layers touch a thing, the engine's content first, then konefr's. Read the reference ONLY with git: REF="${REF}"; \`git -C "$REF" show d0380a487:<path>\`. Never read hg-engine upstream.
- Every behaviour change gets the smallest test in tests/newgold/ that fails if reverted (check by reverting).
- MEMORY CAP -- the PC ran out of RAM twice: run EVERY build, emulator, harness walk, gym replay and test suite through ${CAPPED} (a kernel memory cap in its own scope; default 4G): \`capped -m 6G make -j6 ...\`, \`capped python3 ...\`. Nine agents build at once: make -j6, at most two emulator/harness processes of yours at a time, species.py with at most 2 jobs; watch a long run's memory in its first minute. Scratch files, logs, dumps and ROM copies go under ${ROUNDS}/round9/tmp/<your worktree>/ (never /tmp, a RAM disk); run tests with TMPDIR there (test_saveui's fake-ROM test needs the real /tmp: that one failure is expected). Stop every process you start; never 'pkill -f' a pattern in your own command line.
- BUILD -- every make or wine command starts with \`. ${ENV} &&\`. Build the ROM targets directly:
  cd <wt> && . ${ENV} && capped -m 6G make -j6 COMPARE=0 build/heartgold.us/pokeheartgold.us.nds && capped -m 6G make -j6 COMPARE=0 GAME_VERSION=SOULSILVER build/soulsilver.us/pokesoulsilver.us.nds && capped python3 -m unittest discover -s tests/newgold
  Only test_ledger's counter test may fail; do not commit ledger files. A stale .d naming a removed file: delete it. Generated archives in the source tree can be stale (the main tree once held 733 old icon files): if a built archive looks wrong, delete it and its stale inputs.
- THE BOOT BUDGET: the main arena starts where overlay 12 (the battle) ends; the boot keeps 0x3068 bytes to spare in HeartGold/SoulSilver and 0x1C28 in the diagnostics builds, and tests/newgold/test_heaps.py fails when the boot would not fit (a white screen). Nine agents grow overlay 12 and the static module in parallel, so each has a share (below, 'OV12 BUDGET'): measure overlay 12's end (the build's xMAP / test_heaps' numbers) before and after your work and stay within your share; if a row cannot fit, stop it and report the size it needs. Do not change heap sizes, the arena or the LCF.
- Numbered lists others append to in parallel -- battle subscripts (next free 468, include/constants/battle_subscript.h), MOVE_SUBSCRIPT_PTR (next 237 and its positional table in overlay_12_0224E4FC.c), msg_0197 rows (append after msg_0197_01931, through tools/newgold/import/import_battle_messages.py PORT_ROWS, looked up by name in tests), BMON_DATA_* (next 109), BattleContext fields (append at the end of the added block; the size check in battle_controller_player.c is 0x3260 + ... now -- probe with the compiler), switch-in steps in TryAbilityOnEntry (before 'end', which is 37), post-move steps: keep one entry per commit, never hard-code a subscript or message number elsewhere, and say in your report which numbers you took.
- A battle script must fit BattleContext.battleScriptBuffer (650 words); test_battle_commands.py checks the built ones.
- Commit style: short lowercase subject 'area: what', plain prose paragraphs (what was wrong, evidence, what the reference / Pokemon Central says, what changed, layer, build/test), last line:
Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
  Stage files by name only.
- Budget: do what is sound within your session; for anything left, report precisely what remains.

REPORT (structured output): each commit (hash, subject, and the exact rows it closes, quoting each row's title as in the rows file), each row of yours not closed with the reason, the numbers and the overlay-12 bytes you took, and anything new you found (candidate audit rows with a severity).`
const SCHEMA = { type: 'object', properties: {
  worktree: { type: 'string' },
  commits: { type: 'array', items: { type: 'object', properties: { hash: { type: 'string' }, subject: { type: 'string' }, closes: { type: 'array', items: { type: 'string' } } }, required: ['hash', 'subject', 'closes'] } },
  not_closed: { type: 'array', items: { type: 'object', properties: { row: { type: 'string' }, reason: { type: 'string' } }, required: ['row', 'reason'] } },
  found: { type: 'string' },
}, required: ['worktree', 'commits', 'not_closed', 'found'] }
phase('Implement')
const results = await parallel(args.map(a => () => agent(
  `${COMMON}\n\nYOUR WORKTREE: ${WORKTREES}/${a.wt}\n\n${a.text}`,
  { label: `round9:${a.wt}`, phase: 'Implement', schema: SCHEMA }
)))
return results.filter(Boolean)
