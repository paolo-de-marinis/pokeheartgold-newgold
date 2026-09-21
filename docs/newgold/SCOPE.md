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
| konefr/hg-engine-newgold (behaviour reference) | `41a28e2255b2805378163c7f4d6c1d87541174d1`, `heartgold-modern` |
| hg-engine the reference forked from | `d0380a487`, the parent of konefr's first commit |
| antonsynd/pokeheartgold-slop | `808283ee2`, `mainline`; not an input, with one exception named in the method: `src/unk_02005D10.c` |

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

## Measured scope

Counted from the reference's trainer, wild-encounter and headbutt tables — what
the player can actually meet:

| Kind | Referenced | Beyond vanilla HGSS |
| --- | ---: | ---: |
| Species met directly | 395 | **38** (> 493) |
| Species with the evolution closure | 450 | **65** (> 493) |
| Moves | 370 | **13** (> 467), plus Solar Seeds |
| Abilities (of those species) | 139 | **21** (> 123), two of them konefr's |
| Items in rosters | 42 | to be counted |

This is the number that matters. hg-engine defines 1,476 species, ~923 moves
and 320 abilities; New Gold's content uses a small slice of that. Nothing is
implemented because the engine defines it — only because the game reaches it.

Following the evolution table from those 395 adds 55 more reachable species,
27 of them beyond vanilla: the Lillipup, Tympole, Sewaddle, Yamask, Trubbish,
Karrablast, Foongus, Joltik, Ferroseed, Klink, Elgyem, Litwick and Shelmet
lines, the Bunnelby, Fletchling, Litleo, Espurr, Phantump, Pumpkaboo, Noibat
and Applin lines, Sizzlipede, Sylveon, Dedenne, Bouffalant, Emolga, and the
convergent forms Wyrdeer, Kleavor, Ursaluna, Annihilape, Farigiraf, Dudunsparce
and Hydrapple. Sylveon confirms the Fairy type is required, not optional.

Still to be counted the same way: gift and static encounters placed by scripts,
and what the Pokédex and PC displays must cover.

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
* Enabled in the engine but unreachable in the content as it stands, and so
  deferred until it is not: **Mega Evolution** (no mega stone appears anywhere
  in the trainer or species data — Eviolite is the only held item whose name
  ends that way), **Primal Reversion** (neither Kyogre nor Groudon is
  reachable) and **seasons** (Deerling and Sawsbuck are not). Each is a large
  feature involving form lifecycles, assets and interface work; none of it
  would be visible in the game konefr has built so far, which reaches Morty.
  Recheck these when later content lands.

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
Critical captures, which were in the engine and missing from this list.

**What is left.**

1. The interface the engine turns on and konefr left on: the EV and IV viewer
   in the summary, the HP bar that drains at a fixed rate, and the machine
   move labels in the bag. Each lives in code pret has not decompiled, so each
   carries a conversion with it.
2. Dex entries for the added species. hg-engine's Pokedex covers all of them;
   this one stops at 493 and records nothing for the rest, which is why
   catching one is silent rather than a crash. Widening it is the Dex data
   archives and the screen that reads them, and footprints come with it.
3. Expanded pockets and thirty boxes, which change the save layout.

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
