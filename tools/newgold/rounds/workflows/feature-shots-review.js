// Template: a feature built, reviewed with its own screenshots from the harness, fixed (the paged Dex entries, 2026-09-24).
// Kept from .rounds/dex-pages/dex-pages-wf_1b2582f5-047.js; tools/newgold/rounds/README.md says how a round runs.
export const meta = {
  name: 'dex-pages',
  description: 'Pokedex entries longer than three lines show in two alternating pages, konefr words kept; built, screenshotted, reviewed, fixed',
  phases: [
    { title: 'Build', detail: 'the printer pages an entry of more than 3 lines; the importer wraps into at most 2 pages; tests; ROMs; screenshots' },
    { title: 'Review', detail: 'words, pages, both Dex pages that print entries, retail unchanged, memory, suite' },
    { title: 'Fix', detail: 'the confirmed findings' },
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
const WT = `${WORKTREES}/saveui`
const SCR = `${ROUNDS}/dex-pages`
const CONTEXT = `
PROJECT: ${TREE} is pokeheartgold (HeartGold decompilation) with hg-engine (engine layer, reference d0380a487) and konefr's New Gold (reference 1fa3c9366) ported into it as a real decompilation. Reference repository ${REF}: read it only through git at those two revisions. Rules of this port: assembly that needs a change is first decompiled to MATCHING C in its own commit (HeartGold and SoulSilver byte-identical before and after), then the behaviour change in a separate commit; reference defects are fixed canonically and the commit says why; one commit, one thing.

WHAT WAS FOUND (branch dex-text, now in newgold at e36dd7b0c): the Pokedex prints a species' entry (HeartGold msg_0803, SoulSilver msg_0804; 805..810 are other languages, printed only up to Arceus) with ov18_021EE984 into a 28x6-tile window (224 x 48 px) -- window 11 of ov18_021F9F3C or 85 of ov18_021F9FDC on the Info page, window 4 of ov18_021FBDB4 on the capture page (ov18_021F8CCC) -- font 0 (widths from files/graphic/font.narc member 0), a line every 16 px, so 3 lines; it centres the BLOCK by its widest line, x = (224 - widest)/2 in u32 (an over-wide line wraps it and the page shows one clipped line). tools/newgold/import/import_species_text.py (entry_window, glyph_widths, character_codes, line_widths, fits, fit_entry) rewraps an entry too wide for the window, only at spaces, into at most 3 lines; 46 entries were fixed that way; 116 (listed as LEFT_FOR_PAOLO in tests/newgold/test_dex_entries.py; Iron Crown, row 1039, among them; 12 of konefr's have no line break at all) need 4 lines, Enamorus and its Therian form 5.

PAOLO DECIDED (2026-09-24): "Seconda pagina" -- an entry longer than 3 lines shows its first 3 lines, then the next ones, alternating by itself every few seconds; every word stays konefr's, no text changes.

RULES: work in the worktree ${WT} on branch dex-pages ('git -C ${WT} checkout -b dex-pages e36dd7b0c' -- the worktree is clean at dex-text; newgold's working tree ${TREE} must not be touched, and never push). Its build/ is a real directory now (not a link to the main tree's). Build ALWAYS as '. ${ENV} && make -j16 COMPARE=0 <target>' (the ROM targets directly; 'GAME_VERSION=SOULSILVER'; 'NEWGOLD_DIAG=1' for the diagnostics build). /tmp is nearly full: keep scratch files, logs and screenshots under ${SCR}/ and run tests with TMPDIR=${SCR}/tmp (test_saveui's fake-ROM test needs the real /tmp: ignore that one failure). Never 'pkill -f' a pattern in your own command line. Commits: short lowercase subject 'area: ...', plain prose body (what and why), last line 'Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>'.`

phase('Build')
const built = await agent(`${CONTEXT}

YOUR JOB:
1. The printer: make an entry of more than 3 lines show as pages of 3 lines -- page 1 (lines 1-3), then page 2 (lines 4-6), back to page 1, alternating by itself (pick a period a reader can finish a page in, about 4 seconds at 60 fps, and say why) for as long as the entry is on screen, on BOTH pages that print entries (the Info page and the capture page, and wherever else ov18_021EE984 or its callers print one -- find every caller). Each page is centred by its own widest line; an entry of 3 lines or fewer is drawn exactly as today (same pixels, no timer). The timer/redraw must be driven by the Dex's own per-frame task and stop cleanly when the page changes, the species changes, or the Dex closes (no stray redraw into a freed window). If any routine you must change is still assembly, decompile it to matching C first in its own commit (both ROMs byte-identical, md5s in the message). Also make the centring safe: a line wider than the window must not wrap x (clamp at 0) -- a separate small commit.
2. The text: the importer now wraps an entry that does not fit 3 lines into at most 6 lines (two pages of 3), only at spaces, each line <= 224 px, keeping konefr's words and characters exactly, and keeping his own line breaks wherever they already fit (entries that fit today stay byte-identical); regenerate the banks (803..810, as the importers write them) and show that a rerun against the reference at d0380a487 and at 1fa3c9366 reproduces them. An entry that cannot fit even 6 lines is reported (there should be none).
3. Tests: update tests/newgold/test_dex_entries.py -- LEFT_FOR_PAOLO goes; every entry fits at most 2 pages; the words equal konefr's; the entries that fit 3 lines are unchanged. Add a host test for the paging logic if it can be compiled on the host as other tests do (see how tests/newgold compile C), else test the split and timing through the importer's measure.
4. Build HeartGold, SoulSilver and the diagnostics build. With the harness (tools/newgold/devkit/diag; the round-7 ui branch r7-ui has core.py's screenshot and species.py: export them to ${SCR} if newgold lacks them; the dex-text fixer's dexshot.py may be in ${ROUNDS}/dex-pages/dexshot/) take screenshots of Iron Crown's Info page on page 1 and on page 2, of Enamorus (5 lines), and of a retail entry (e.g. Bulbasaur) before and after to show it unchanged; save them in ${SCR}/shots/.
5. Memory: overlay 18 must not push the main arena's start (read the build's map: which overlay ends last; the boot margin work happens elsewhere on overlay 12 -- say how many bytes your change adds to which overlay and whether it moves the arena). Run test_boot and the full tests/newgold suite.
Report: the commits, the period chosen, every caller handled, the md5s (and the byte-identical proofs for any decompilation), the entries rewrapped and their page counts, the screenshots' paths, the memory numbers, the test results.`, { label: 'build:pages', phase: 'Build' })

phase('Review')
const review = await agent(`${CONTEXT}\n\nThe paging was built on branch dex-pages in ${WT}; the builder's report:\n${built}\n\nYOUR JOB, adversarially, read-only (commit nothing; scratch under ${SCR}/review): (1) every changed entry's words and characters equal konefr's (1fa3c9366's data/Species.c pokedexEntry, quote substitution aside) with only line breaks moved, every line <= 224 px by font 0's widths read from the built ROM, at most 6 lines, and entries that fitted 3 lines are byte-identical to e36dd7b0c's; (2) the printer: read the C -- each page centred by its own widest line, page 2 really alternates and returns to page 1, no redraw after the window is freed (leave the Dex mid-alternation, change species mid-alternation, open the capture page), no change for 3-line entries; check it on the diagnostics build with the harness, taking your own screenshots at several frames; (3) any decompilation commit is byte-identical (rebuild both ROMs at it and its parent); (4) the arena margin at boot is not reduced by more than the builder says (test_boot passes, compare the map files); (5) the full suite passes (TMPDIR as above). Report findings marked critical/high/medium/low with evidence, or 'none'.`, { label: 'review:pages', phase: 'Review' })

phase('Fix')
const fixed = await agent(`${CONTEXT}\n\nBuilder's report:\n${built}\n\nReviewer's report:\n${review}\n\nYOUR JOB: verify each finding (some may be wrong: say so with evidence) and fix every real one on dex-pages in ${WT}, in commits of one thing each, with a test where one can hold it; if there are none, say so and change nothing. Rebuild HeartGold, SoulSilver and the diagnostics build, retake the Iron Crown page 1/page 2 screenshots, run test_boot and the full suite. Report each finding as fixed / not a defect / left (and why), the commits, the md5s, the final dex-pages tip and the screenshots' paths.`, { label: 'fix:pages', phase: 'Fix' })

return { built, review, fixed }
