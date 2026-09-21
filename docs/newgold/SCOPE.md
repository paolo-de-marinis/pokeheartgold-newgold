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
| antonsynd/pokeheartgold-slop (decompilation only) | `808283ee2`, `mainline`; a fork of the same base carrying 141 source files pret has not decompiled yet |

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
that ask.

**What is left.**

1. Cries. PlayCryEx clamps anything above species 495 to Bulbasaur rather than
   reading past the sound archive, so the added species sound wrong but nothing
   breaks. Giving them their own cries needs that function decompiled and the
   archive extended. The slop fork above has already decompiled the file it
   lives in, so what is left is the sound data rather than the function.
2. Three trainers still cannot be read: two want Galarian Slowpoke and
   Slowbro, which are forms this game has no species for, and one wants a
   double battle with no partner.
3. Footprints and Dex entries, needed only if the Dex is widened; an added
   species records nothing in it today, deliberately.
4. The remaining interface work the reference ships: the EV and IV viewer, the
   static HP bar, the machine labels in the bag, deletable HMs and reusable
   repels. Each of these lives in code pret has not decompiled, so each carries
   a conversion with it. The slop fork listed among the sources has done some
   of that conversion; it is a remote on this repository and its files are
   taken one at a time when a feature needs them, rather than merged wholesale.

   Taking one is two of their commits, not one: the commit that split the
   overlay into address-ordered pieces, and the commit that decompiled the
   function. `git log --format=%H --diff-filter=A slop/mainline -- <path>`
   finds them. Each is cherry-picked with `-n`, their harness and tooling
   (`tools/`, `.claude/`, `scripts/`) restored away, and what is left — `asm/`,
   `src/`, `include/`, `main.lsf` — committed with `--author` set to theirs, or
   to this branch's author with them as a `Co-authored-by:` trailer when the
   result had to be adapted by hand. One overlay per commit, and both ROMs and
   the tests before the next: a main.lsf out of step does not fail clearly.
   The pinned revision in the source table moves the first time something is
   taken.
5. Expanded pockets and thirty boxes, which change the save layout.

## Method

1. The reference is read, never transcribed. Each item is described as an
   observable difference from vanilla HGSS, then implemented with
   pokeheartgold's own structures, resources and build system.
2. No hooks, byte patches, repointed tables, injected overlays or hardcoded
   addresses. If a behaviour lives in a function pret has not decompiled yet,
   that function is decompiled first — matching retail, because this branch
   must stay mergeable with upstream — and only then changed.
3. Byte-level comparison against a compiled reference ROM is not an acceptance
   criterion. Equivalence is judged on game behaviour.
4. Each change builds both HeartGold and SoulSilver and keeps the focused host
   tests passing.
