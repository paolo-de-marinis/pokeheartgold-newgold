# NewGold on pokeheartgold — scope

This branch reimplements konefr's **New Gold** on top of `pret/pokeheartgold`,
written the way pokeheartgold writes code. The reference repository is a
**behaviour specification only**: nothing is copied from it, and its engine
architecture (hooks, byte replacements, repointed tables, injected overlays,
fixed RAM addresses) is not reproduced. The goal is that the resulting ROM
plays like New Gold, not that it resembles hg-engine internally.

| Input | Revision |
| --- | --- |
| pokeheartgold (base) | `e97c7fc975a7447f288c42acc2e155f5a673e30f`, `master` |
| konefr/hg-engine-newgold (behaviour reference) | `41a28e2255b2805378163c7f4d6c1d87541174d1`, `heartgold-modern`, 2026-09-20, "bug fixing pre sea route 40-41" |
| hg-engine the reference forked from | `d0380a487`, the parent of konefr's first commit |
| antonsynd/pokeheartgold-slop | `808283ee2`, `mainline`; not an input, with one exception named in the method: `src/unk_02005D10.c` |

The reference is `https://github.com/konefr/hg-engine-newgold.git`, branch
`heartgold-modern`, and it is checked out locally at that pin in
`/home/paolo/Porting HGSS/hg-engine-newgold-reference`. Every importer reads
from there and from nowhere else. **Never read hg-engine upstream.** The
reference is hg-engine *plus* konefr's 67 commits, and his changes have to come
last: taking a record from upstream would silently drop whatever he did to it.
Farigiraf's learnset (species 1031) is the only thing he has touched above
species 493 so far, and the rest of his rebalance sits inside the vanilla 493
and is already imported — but that will grow, so the importers point at his
tree from the start. When he publishes new commits the checkout is refetched
and the pin above is updated.

## What New Gold actually is

The reference is BluRosie's **hg-engine** plus **67 commits** by konefr and
Francesco Greco, beginning 2026-09-03. Those 67 commits touch 37 files and are
the hack itself; everything older is the engine it happens to sit on.

Their own work is:

* **Rebalanced content** — trainers (3,092 changed lines), wild encounters
  (1,520), headbutt tables (335), species tweaks (298), learnsets (262),
  evolutions, hidden abilities, a few move records.
* **New mechanics** — abilities Irrigation (314) and Evaporate (319), the move
  Solar Seeds with its animation, the battle effect `BURN_MULTI_HIT` and the
  subscript `ABSORB_AND_ATK_UP_2_STAGE`, plus fixes to Leaf Guard and Water
  Absorb.
* **New scripted content** — the Cherrygrove vendor (297 lines of script and
  148 lines of new script commands), Bug-Catching Contest encounters and
  rewards.
* **Engine switches they turned on** — the level cap system with
  `UNCAP_CANDIES_FROM_LEVEL_CAP` and `ALLOW_LEVEL_CAP_EVOLVE`, and
  `DELETABLE_HMS`. Every other setting is the engine's default.

## The criterion

**The platform has to carry what New Gold could reach, not what it reaches
today.** konefr is moving New Gold's development onto this repository, so this
is no longer a port of a finished hack — it is the thing he will build on. He
must be able to open `Trainers.c`, put any Pokemon in a party, and have it work
without asking anyone for an import first. A species the engine defines and
this port does not is a trap: he would find it by playing, long after writing
it.

That reverses the rule this file was written under, which was *implement only
what the game reaches*. That rule was right while this was a port of a fixed
piece of content, and it is what got the first phase done at a sane size. It
stops being right the moment the content starts growing here.

The target is hg-engine's own range, in full:

| Kind | Here now | Target | To add |
| --- | ---: | ---: | ---: |
| Species | 574 | 1075 | **501** |
| Moves | 495 | 922 | **427** |
| Abilities | 150 | 319 | **169** |

### The scope that was measured, and why it is kept

The table below is what the first phase was sized against: everything the
player can meet, counted from the reference's trainer, wild-encounter and
headbutt tables. It is no longer the measure of what to implement, but it is
still the measure of what is *exercised* — the part of the range that has been
played rather than merely defined — so it stays as a record.

| Kind | Referenced | Beyond vanilla HGSS |
| --- | ---: | ---: |
| Species met directly | 395 | **38** (> 493) |
| Species with the evolution closure | 450 | **65** (> 493) |
| Moves | 370 | **13** (> 467), plus Solar Seeds |
| Abilities (of those species) | 139 | **21** (> 123), two of them konefr's |
| Items in rosters | 42 | to be counted |

## Out of scope

Engine features the reference ships but leaves off, or that pokeheartgold
already implements equivalently:

* Disabled in the reference's own configuration: transparent textboxes, wild
  double battles, dynamic wild species forms, Pokéathlon shop expansion,
  weather-driven terrain, whole-party Rock Smash, skipping tutorial info,
  victory poses, end-of-turn weather message removal, items disabled in
  trainer battles.
* Present but unfinished upstream: Dynamax and Terastallization exist as states
  and flags with TODOs, so they are not behaviour to reproduce.
* Already equivalent in pokeheartgold: wild slot selection, hidden item table,
  swarms, default mart tiers, Rock Smash behaviour.
* konefr's Cherrygrove vendor, which the earlier reading of this file listed
  as content to port. It is not content: the script calls itself "New Gold
  debug vendor", asks for a password, hands out Rare Candies, and drives the
  developer EV presets that make up the 148 lines added to script_commands.c —
  twelve invalid species numbers, 2000 to 2011, that set the first party
  Pokemon's effort values to a chosen spread. It is also written as a patch
  into a built script file rather than as source. A player never sees it and
  the method here would not reproduce it that way, so it stays out.
* **Mega Evolution**, **Primal Reversion** and **seasons**. Each is a large
  feature of form lifecycles, assets and interface work rather than a record in
  a table, and none of the three is in the expansion's work order. Widening the
  species, move and ability range does not drag them in: a Mega form is not a
  species record, and the one battle-script command this port does not define,
  `GoToIfSecondHitOfParentalBond`, is Mega's. They stay out until asked for.

## Work order

**Done.** The behaviour switches that need no new data: the story level cap,
reusable TMs, the vitamin ceiling, overworld poison, the friendship threshold,
the low-HP warning, the scaled experience formula, capture experience and the
modern ball multipliers.

The data: the Fairy type and its place in the chart; 27 ability names; the 65
species New Gold reaches, with personal records, learnsets, evolutions, battle
sprites, heights, party icons and names; the experience yield widened past the
Gen 4 ceiling; and the 491 of HGSS's own 493 species the hack rewrites. Then
konefr's content itself: 140 of 142 encounter maps, 650 of 738 trainers, and
the headbutt trees. Then twenty-five of the twenty-six added abilities: only
Cud Chew is still a name, and it is one in the reference too.

The battle script command set: pokeheartgold has 225 commands and hg-engine
has 294, the same 225 at the same opcodes plus 69 of its own. All 69 are
written, at those opcodes and under those names, so a battle script written
for that engine assembles and runs here. Seventeen of them ask about a feature
this game never had — terrain overlays, Parental Bond, Terastallization, the
primal weathers, the paradox abilities, totems — and answer accordingly rather
than asserting.

Twenty-eight moves, including konefr's own Solar Seeds: thirteen his trainers
and learnsets name, four that are how the convergent forms are reached, ten
his own learnset changes hand out, and Sticky Web. Six items: five that make a
Pokemon evolve and the Eviolite. The six evolutions that were waiting on them.
The fifteen learnsets konefr changed himself, which is what his learnset work
amounts to once the engine's modern dataset is set aside. Hidden abilities,
for the 383 species whose one this game has and for the four trainer Pokemon
that ask. The two Galarian forms, as species of their own, with Quick Draw
for one of them; the Bug-Catching Contest's prizes, written into the script
this game has the source for rather than patched into the built bytes.

The cries, which needed a reader and writer for the sound archive before
anything could be added to it. Every trainer in the reference now reads,
including the one that wanted a double battle with nobody to partner it.
Deletable HMs, the last of the four engine switches konefr turned on himself.
Critical captures, which were in the engine and missing from this list. The
HP bar that drains at a fixed rate. Trick and Switcheroo taking the player's
item, which the engine allows because it hands every item back at the end.

Reading the engine's `include/config.h` end to end closed that list. Of its
seventy-five settings konefr changed exactly two groups himself: the level cap
with its candy exemptions, and deletable HMs. Both are in. The rest are the
engine's own defaults, and the ones that are visible in play were found by
this sweep rather than by the commit list — critical captures, the items
handed back, the friendship effects, Trick — which is why the sweep was worth
doing and why it is recorded as finished here.

**What is left.**

1. The EV and IV viewer in the summary. L, R and Select swap the stats page
   between the raw stats, the effort values and the individual values, and the
   stat names take a + or a - for the nature. It lives in code pret has not
   decompiled, so it carries a conversion with it: the reference reaches it
   through two hand-written hooks into the summary's input handling, and here
   the summary's own code has to be converted first.
2. The quantity a TM shows in the bag list. The machine badges are done, but
   the row still prints a count beside a TM, which the engine drops once TMs
   are reusable — the count means nothing when the item is never spent. It is
   the same row renderer, `ov15_021FF570`, still in assembly.
3. Dex entries for the added species. hg-engine's Pokedex covers all of them;
   this one stops at 493 and records nothing for the rest, which is why
   catching one is silent rather than a crash. Widening it is the Dex data
   archives and the screen that reads them, and footprints come with it.
4. Expanded pockets and thirty boxes, which change the save layout.

Then a session on melonDS covering those four, written up in
`VALIDATION.md`. **That write-up is the precondition for everything below.**
Nothing of the expansion starts over an unproven base: if something in that
session does not pass, it is fixed first.

## Next phase: the whole range

The numbers are in *The criterion* above — 501 species, 427 moves, 169
abilities. This is affordable, and the reason is that the infrastructure is
already here. Nothing restarts and no tool is rewritten; the existing ones are
widened.

* Seventeen importers in `tools/newgold/`, all idempotent — run again over an
  imported tree they answer "0 to change". For the species this is widening a
  range, not writing code: `import_species.py`, `import_sprites.py` and
  `import_icons.py` (which copy rather than convert), `heights.py`,
  `import_evolutions.py`, `import_hidden_abilities.py`, `import_moves.py`,
  `import_cries.py` with `sdat.py` for the sound archive, and `wotbl.py`,
  which round-trips the learnset archive and checks it before appending.
* The battle script command set is **complete**: 295 defined against the 278
  the reference uses, 96% overlapping. The remaining 427 moves are effect
  script translation, not engine work.
* The ability dispatch points are already ported — 222 call sites across
  `src/battle/overlay_12_0224E4FC.c` and its neighbours. The median ability is
  **one line** in one of them. The remaining 169 are insertions, not
  architecture.
* Animations are borrowed by number and `import_moves.py` already does it.
* The cries are solved at the root: `PlayCryEx` is decompiled in
  `src/unk_02005D10.c` and `main.lsf` links the object, so there is no longer a
  ceiling at 495. Extending the sound archive is running the same two tools
  over a wider range.
* Thirty-six tests in `tests/newgold/`, one per area, so a regression shows up
  the same day.
* Of hg-engine's 349 hook targets, 307 are already C in pokeheartgold. The 37
  still in assembly are not on this path.

**First step: expand the ROM.** `rom.rsf`, `RomSize 1G` to `RomSize 2G`.
128,766,012 bytes of 134,217,728 are used today, about 5.2 MiB free.
`pokegra.narc` is 12,838,796 bytes for 574 species, 21.8 KiB each, so 501 more
species is about 10.7 MiB of battle sprites alone before icons and cries. It
does not fit otherwise. If more room is wanted later, `pokegra.narc` is not
compressed today — there is no LZ step in its `.mk`.

Then, in order:

1. Every species' data: personal records, learnsets, evolutions, names, hidden
   abilities. This is the free part, roughly 130 bytes a species.
2. The remaining 169 abilities.
3. The remaining 427 moves: records, effect scripts, animations by number.
4. Graphics: battle sprites, heights, icons.
5. Cries for every species, not only the ones in play today.
6. Dex entries and footprints across the new range, consistent with what the
   phase before did for the species it added.

**Steps 2 and 3 are not optional.** Importing species without their abilities
and moves is worse than not importing them: konefr would have hundreds of
Pokemon whose abilities do nothing and whose moves cannot be learnt, and no
sign of it until he played.

The discipline does not change. A matching decompilation stays in its own
commit, separate from the behaviour change, and that commit does not alter a
byte of either ROM. HeartGold and SoulSilver both build and `tests/newgold/`
passes at every step.

It closes with another melonDS session, aimed at the expansion: one species
taken at random from each generation added, with its sprite, icon, cry, name
and Dex entry, and one new ability and one new move working in a battle.
`VALIDATION.md` is updated with it.

## Method

1. The reference is read, never transcribed. Each item is described as an
   observable difference from vanilla HGSS, then implemented with
   pokeheartgold's own structures, resources and build system.
2. No hooks, byte patches, repointed tables, injected overlays or hardcoded
   addresses. If a behaviour lives in a function pret has not decompiled yet,
   that function is decompiled here first — matching retail, because this
   branch must stay mergeable with upstream — and only then changed, as two
   commits: the conversion, then the change. That separation is what keeps a
   later merge with pret cheap, and it is why the conversions are done here
   rather than taken from a fork that has done its own. Those forks decompile
   whole overlays in coverage order; this one decompiles the functions New
   Gold has to change, so what they have and what is needed overlap by
   accident rather than by design. Reading someone else's conversion to
   understand a function is fine; copying it is not.

   The exception is `src/unk_02005D10.c`, where PlayCryEx lives, and it is
   worth naming because the argument above is about averages and this file is
   not average. The slop fork has it — 942 lines, fifty functions, their
   main.lsf linking `src/unk_02005D10.o` rather than the assembly. Here the
   whole file is assembly and PlayCryEx alone is 512 lines of it, several
   times the size of the routines the other branch was converting at nine
   minutes each, and it is exactly what stands between this port and the
   cries. So when the cries are done that file is taken rather than redone:
   cherry-picked with `-n`, their harness and tooling restored away, and
   committed with the author line set to theirs.

   One trap, which has already cost a wrong answer once: their tree keeps the
   original `.s` beside the C, and the two `.s` files are byte-identical. That
   says nothing about what is built. The linker script is the authority — read
   `main.lsf`, not whether the assembly is still in the tree.
3. Byte-level comparison against a compiled reference ROM is not an acceptance
   criterion. Equivalence is judged on game behaviour.
4. Each change builds both HeartGold and SoulSilver and keeps the focused host
   tests passing.
