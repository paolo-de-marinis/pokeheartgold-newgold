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
| Species | 395 | **38** (> 493) |
| Moves | 370 | **13** (> 467), plus Solar Seeds |
| Abilities (of those species) | 139 | **21** (> 123), two of them konefr's |
| Items in rosters | 42 | to be counted |

This is the number that matters. hg-engine defines 1,476 species, ~923 moves
and 320 abilities; New Gold's content uses a small slice of that. Nothing is
implemented because the engine defines it — only because the game reaches it.

Still to be counted the same way: species obtainable by evolution, gift and
static encounters from scripts, Pokédex and PC display requirements.

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
