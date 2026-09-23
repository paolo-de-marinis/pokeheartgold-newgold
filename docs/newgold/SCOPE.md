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
| konefr/hg-engine-newgold (behaviour reference) | `ccf2c9f5e954348041df5b195bd804ff18d05e66`, `heartgold-modern`, 2026-09-21, "Rebalance Chuck gym trainers" |
| hg-engine the reference forked from | `d0380a487`, the parent of konefr's first commit |
| antonsynd/pokeheartgold-slop | `808283ee2`, `mainline`; not an input, with one exception named in the method: `src/unk_02005D10.c` |

The reference is `https://github.com/konefr/hg-engine-newgold.git`, branch
`heartgold-modern`, and it is checked out locally at that pin in
`/home/paolo/Porting HGSS/hg-engine-newgold-reference`. Every importer reads
from there and from nowhere else. **Never read hg-engine upstream.** The
reference is hg-engine *plus* konefr's 73 commits, and his changes have to come
last: taking a record from upstream would silently drop whatever he did to it.
Farigiraf's learnset (species 1031) is the only thing he has touched above
species 493 so far, and the rest of his rebalance sits inside the vanilla 493
and is already imported — but that will grow, so the importers point at his
tree from the start. When he publishes new commits the checkout is refetched
and the pin above is updated.

## What New Gold actually is

The reference is BluRosie's **hg-engine** plus **73 commits**,
`d0380a487..ccf2c9f5`, beginning 2026-09-03: konefr, Francesco Greco (the same
person) and four by github-actions[bot], which are his patchers. They touch 37
files and are the hack itself; everything older is the engine it happens to sit
on.

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
* **Engine switches they turned on** — exactly five: `IMPLEMENT_LEVEL_CAP`,
  `LEVEL_CAP_VARIABLE`, `UNCAP_CANDIES_FROM_LEVEL_CAP`,
  `ALLOW_LEVEL_CAP_EVOLVE` and `DELETABLE_HMS`. Every other setting is the
  engine's default.

## Two layers

The port is meant to become two things. The split itself is deferred until
further notice (the last section). What holds from now is working so that it
stays possible: everything new knows which layer it belongs to, and no commit
mixes the two.

| Layer | What it is |
| --- | --- |
| **Engine** | pokeheartgold with hg-engine's features as hg-engine ships them, and no hack's content. The devkit, `tools/newgold/devkit/`, belongs here: anyone building a hack on this tree uses it. |
| **New Gold** | everything konefr added or changed on top of hg-engine. This repository is going to him. |

**Provenance is read in the repositories, never inferred.** The reference
holds both histories, and the boundary is one commit:

```
d0380a487   BluRosie's hg-engine, the parent of konefr's first commit
ccf2c9f5    konefr's tip today
```

`d0380a487..ccf2c9f5` is 73 linear commits and no merges: konefr, Francesco
Greco (the same person) and four by github-actions[bot], which are his
patchers. So:

* whatever that range introduces **or modifies** is New Gold;
* whatever hg-engine has at `d0380a487` and pret does not is Engine, with the
  values and defaults it has at `d0380a487`;
* whatever is in neither repository — decompilations, the harness, the port's
  own infrastructure — goes in the lowest layer that needs it. That is almost
  always the engine, because hg-engine's range already needs it: the learnset
  entry became a word for 923 moves, not for konefr.

The motive never counts; where it sits in the history does. To check:

```
REF="/home/paolo/Porting HGSS/hg-engine-newgold-reference"
git -C "$REF" log --oneline -S <SYMBOL> d0380a487..ccf2c9f5   # any commit: konefr's
git -C "$REF" show d0380a487:<file>                           # hg-engine's value
git -C "$REF" show ccf2c9f5:<file>                            # New Gold's value
```

What belongs to whom, already checked against the reference:

* **Configuration.** konefr changed exactly five switches from hg-engine's
  defaults: `IMPLEMENT_LEVEL_CAP`, `LEVEL_CAP_VARIABLE`,
  `UNCAP_CANDIES_FROM_LEVEL_CAP`, `ALLOW_LEVEL_CAP_EVOLVE`, `DELETABLE_HMS`. At
  `d0380a487` all five are commented out. The other seventy active switches
  are hg-engine's defaults: Engine.
* **Level cap.** The mechanism is hg-engine's and reads `LEVEL_CAP_VARIABLE`;
  the ladder 10→13→19→22→30→34→36 wired into `GetLevelCap` is konefr's.
* **Vanilla species.** The 38 records konefr rebalanced — 35 of HeartGold's
  species and three Galarian forms — and their evolutions, learnsets and hidden
  abilities: New Gold. The engine would carry `d0380a487`'s values.
* **Abilities and moves.** Evaporate (319) and Solar Seeds (923), with
  `MOVE_EFFECT_BURN_MULTI_HIT`, the subscript `ABSORB_AND_ATK_UP_2_STAGE` and
  the animation: New Gold. Their extension point is `NUM_OF_CUSTOM_MOVES`.
  Irrigation (314) sits in `ABILITY_TEMP2`, a slot hg-engine already had: the
  slot is Engine, the name and the effect are konefr's.
* **Behaviour changes.** The Water Absorb and Leaf Guard fixes, and the Linking
  Cord evolving an `EVO_TRADE` species too (`e26576dd1`), are in the range: New
  Gold, even though they look like corrections.
* **Content.** Trainers, wild encounters, headbutt trees, the Bug-Catching
  Contest, the text of bank 550, the Cherrygrove vendor and the EV presets: New
  Gold. The vendor and the presets are konefr's development tools *inside the
  game*, not to be confused with the devkit.

**One commit, one thing.** If konefr's content needs the engine widened, that
is two commits: the engine first, then the content that uses it. The commit is
the atom: splitting one afterwards means rewriting the history of a public
repository with a collaborator on it, which is not done. It holds for konefr's
new commits too: when they are imported, the import commit carries only his
data.

**The reference's defects** are neither engine nor content: they are bugs to
fix — Route 30 with 11 of its 12 slots, Solar Seeds' animation pointing at
Ember. Each is fixed in the layer of the thing it corrects, and the commit says
why it was not copied, so that it does not come back when konefr regenerates
his data.

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

The target is hg-engine's own range, in full: every species, move, ability
and item the reference names. How far the tree has got is not written here,
because a number typed into this file goes stale the day after: the counters
at the top of `LEDGER.md` are generated from the tree by
`tools/newgold/ledger.py` and say it. At the time of writing all four ranges
are imported -- species with their forms, moves, abilities, items -- and what
does not work yet is a row of the ledger or of the audit.

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
  as content to port. It is not content a player meets: the script calls itself "New Gold
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

The interface the engine turns on: the machine badges in the bag, with the
count beside a reusable TM dropped; and the EV and IV viewer in the summary,
where L, R and Select swap the stats page between the stats, the effort values
and the individual values, and a nature-moved stat name is finally legible.
Four functions of overlay 15 and two of the summary were converted for it,
each in its own commit, each leaving both ROMs byte for byte unchanged.

Reading the engine's `include/config.h` end to end closed that list. Of its
seventy-five settings konefr changed exactly two groups himself: the level cap
with its candy exemptions, and deletable HMs. Both are in. The rest are the
engine's own defaults, and the ones that are visible in play were found by
this sweep rather than by the commit list — critical captures, the items
handed back, the friendship effects, Trick — which is why the sweep was worth
doing and why it is recorded as finished here.

**What is left** is kept in two places, and not in this file: the rows of
`LEDGER.md` that are not done, and the rows of `docs/newgold/AUDIT-*.md` that
are still open. The ledger's summary counts both -- the audit's open rows
too, since 2026-09-23 -- from the files themselves. The port is finished when
the ledger has nothing partial or still to do and the audit has no open row,
or when each one left is closed with a written reason.

## The whole range

Done, in the order this file set out on 2026-09-21: the ROM first, 1G to 2G
in `rom.rsf`, because the battle sprites alone of five hundred more species
did not fit in what was left; then every species' data, the abilities, the
moves with their effect scripts and borrowed animations, the graphics, the
cries -- the sound archive has a reader and writer, and `PlayCryEx` is C --
and the Dex text, all written by importers that are idempotent and, since
the two-layer rule, take a revision. The abilities and moves were not
optional: species whose abilities do nothing and whose moves cannot be
learnt would have been worse than no species.

The discipline does not change. A matching decompilation stays in its own
commit, separate from the behaviour change, and that commit does not alter a
byte of either ROM. HeartGold and SoulSilver both build and `tests/newgold/`
passes at every step.

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

## The cycle

The method above, as the loop every change goes through:

```
decide the change
 └─ is what it touches already C?
      yes -> make it. One commit.
      no  -> a) check whether the slop fork has it:
                   git ls-tree -r --name-only slop/mainline | grep <unit>
                 if it does, minutes instead of hours
             b) decompile to MATCHING, and commit only that.
                Neither ROM changes by a byte.
             c) then the change, in a separate commit.
 └─ build HeartGold and SoulSilver, run tests/newgold/
 └─ update the row's state in LEDGER.md, in the SAME commit as the work
```

(a) is for reading: their C is the fastest way to understand the function, and
what is committed is still this tree's own conversion, in the shape (b) asks
for — point 2 of the method says why their files are not taken.

(b) is the part that gets lost, so here is why. It is the only moment at
which the decompilation can be checked: the ROM is what it was, byte for byte,
so the C is exactly the assembly. After the change the ROM differs for two
reasons at once and they can no longer be told apart. And it makes the
behaviour change portable: the day pret decompiles the same function, their
version is taken and commit (c) is cherry-picked on top of it.

**Assembly is not a reason to stop.** If a change needs a routine that is still
assembly, decompiling it is part of the change; it does not make the row
🟠 partial.

## Deferred until further notice

The split into the two layers is not work for now. These are its steps. The
ledger carries the same list as its *Two layers* section, every row ⬜
deferred, so they can be seen and stay out of the denominator.

1. konefr's five switches made configurable: off in the engine, on in New
   Gold. Today the port has them wired always on.
2. `GetLevelCap` reading `LEVEL_CAP_VARIABLE` as hg-engine does, with konefr's
   ladder as data.
3. Irrigation, Evaporate and Solar Seeds moved behind the extension points:
   `ABILITY_TEMP2` and `NUM_OF_CUSTOM_MOVES` at 0 in the engine.
4. The importers taking a revision: at `d0380a487` the engine's data, at
   `ccf2c9f5` New Gold's.
5. Recounting the separation by the provenance rule. The old count, 8 mixed
   commits of 175, looked only at file paths.
6. The split, without rewriting published history: `git tag port-history`; an
   `engine` branch from pret (`e97c7fc9`) with the matching decompilations
   cherry-picked and everything else regenerated at `d0380a487`; `newgold`
   rebuilt on top of `engine` at `ccf2c9f5`; then, on the rebuilt branch,
   `git merge -s ours` of the published `newgold`, so the push is a
   fast-forward and no clone breaks.
7. Building and playing the engine-only configuration, which has never been
   built.

**One exception.** If, before then, ordinary work already touches one of these
areas — the level cap, one of the five switches, one of konefr's abilities —
that piece is done the layered way already, in its own commit. No campaign for
it, but no new work written the old way either.
