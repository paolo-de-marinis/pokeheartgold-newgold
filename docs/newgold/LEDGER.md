# New Gold port ledger

Everything hg-engine and konefr change against vanilla HeartGold, and where the
native port stands on each. The counters are derived from the repository; the
states are maintained by hand, in the commit that moves them. The percentages
at the top score a done row 1 and a partial row a half, over the rows that are
in scope — the deferred ones are left out of the denominator rather than
counted as failures.

`docs/index.html` is rendered from this file. Edit this one.

| | |
| --- | --- |
| base | `e97c7fc9` — pret/pokeheartgold |
| reference | `ccf2c9f5` — konefr/hg-engine-newgold, `heartgold-modern` |
| port | 148 commits |
| generated | 2026-09-21 22:09 |

<!-- LEDGER:SUMMARY:START -->
```
Overall                          67%
  done, seen running   ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   6%
  done, never played   █████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  34%
  partial              ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  38%
  still to do          ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  11%
  deferred / no scope  ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  11%

Implementation         ████████████████████████████████████░░░░░░░░░░░░░░  72%
Verified in play       ███████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  38%
```
<!-- LEDGER:SUMMARY:END -->

<!-- LEDGER:COUNTS:START -->
```
Species     ████████████████████████████████████████████████░░  1041 / 1075
Moves       ██████████████████████████████████████████████████   923 /  923
Abilities   ██████████████████████████████████████████████████   319 /  319
Items       ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   545 / 2684
Trainers    ██████████████████████████████████████████████████   738 /  738
Tests       47 files
ROM         143.8 MB of 268.4 MB   (2G card, 54% used)
```
<!-- LEDGER:COUNTS:END -->

---

## hg-engine engine features

75 toggles are enabled in the reference's own `config.h`. These are the ones
that carry behaviour.

| Feature | Detail | State |
| --- | --- | :-- |
| Fairy type and the effectiveness chart | type 18 and the twelve chart rows, Sylveon and 66 species, 30 moves — but no name string (`msg_0735` stops at 17) and no icon | 🟠 partial |
| Story level cap | wired in C to badges and flags 118/123/454 — 10→13→19→22→30→34→36→100 | ✅ done |
| Hidden abilities | `TRPOKE_ABILITY_OVERRIDE_HIDDEN`; eleven trainer Pokémon ask for one | ✅ done |
| Ability field past one byte | save, battle record, AI memory, PC box and summary widened; personal `abilities[2]` is still a byte, so 85 species truncate | 🟠 partial |
| Reusable TMs, deletable HMs | `REUSABLE_TMS`, `DELETABLE_HMS`, plus the machine badge in the bag | ✅ done |
| EV and IV viewer | L shows effort, R shows individuals, Select restores stats | ✅ done |
| Expanded pockets, thirty boxes | change the save layout — and caused the first black battle | ✅ done |
| Scaled and capture experience | `EXPERIENCE_FORMULA_GEN`, `IMPLEMENT_CAPTURE_EXPERIENCE` | ✅ done |
| Eleven ball multipliers, critical capture | nine match the reference; Moon keeps HGSS's fourteen-species table and Sport is ungated | 🟠 partial |
| Reusable repels, overworld poison, friendship threshold | repels and poison each on a matching decompilation; the 160 threshold misses Eevee → Sylveon | 🟠 partial |
| Static HP bar, vitamin caps, low-HP music | `STATIC_HP_BAR`, `UPDATE_VITAMIN_EV_CAPS`, `DISABLE_CRITICAL_HP_WARNING` | ✅ done |
| Item restoration, friendship effects, AI item grab | `RESTORE_ITEMS_AT_BATTLE_END`, `FRIENDSHIP_EFFECTS`, `AI_CAN_GRAB_ITEMS` | ✅ done |
| Champions move values | read from the reference's `config.h`; the added moves take them, four retail moves do not | 🟠 partial |
| Widened Pokédex and footprints | footprints for all 1041; the Dex text stops at 574, so 467 species have no entry | 🟠 partial |
| Bigger card | `RomSize 1G → 2G`, 256 MiB, `test_rom_budget.py` holds the margin | ✅ done |
| Per-move toggled mechanics | Protean, Battle Bond, Corrosive Gas, Snow Warning, Natural Gift, Unseen Fist, Booster Energy | 🟠 partial |
| Expanded prize money, gender, music, roamer tables | `EXPAND_*` — not checked one by one | 🟠 partial |
| Mart expansion | the decomp already holds the mart tables in C (`src/scrcmd_mart.c`); `MART_EXPANSION` is stock hg-engine and konefr never touched it | ⬜ not needed |
| BDHCAM routine | `ov01_021FB04C` — map-editing infrastructure, no map touched | ⬜ not needed |
| Mega Evolution, Primal Reversion, seasons | no mega stone in the data, no Kyogre or Groudon, no Deerling | ⬜ deferred |
| Z-Moves, Dynamax, Terastallization | states and flags with TODOs upstream — not behaviour to reproduce | ⬜ out of scope |

---

## Engine content

The whole range, after the criterion changed: the platform has to carry what
konefr *could* reach, not only what the game reaches today.

| Item | Detail | State |
| --- | --- | :-- |
| Species | 1042 sprite directories, 1277 icons, heights, learnsets, evolutions; every base species the reference names is here, the rest are its forms | 🟠 1041 / 1075 |
| Moves | 131 effect scripts, 59 subscripts, 62 side-effect table slots | ✅ 923 / 923 |
| Abilities | 149 do something — 123 retail effects and 26 added; the other 170 are a name and a species field, and `test_ability_effects.py` counts them down | 🟠 149 / 319 |
| Level-up learnsets | 1042; the entry is a word now, so a move past 511 can be learnt | ✅ done |
| Battle script commands | 294 opcodes, name- and number-identical to the reference; 24 of the added handlers still only consume their operands | 🟠 270 / 294 |
| Cries | `PlayCryEx` decompiled in `src/unk_02005D10.c` and linked by `main.lsf` — the 495 ceiling is gone, but the bank is mapped twice on one path | 🟠 partial |
| Items | 545 against the engine's 2684; nine Gen 8/9 evolution items are missing and Ability Shield is a dead identifier | 🟠 545 / 2684 |
| Effects with a script but no C | counted by `test_move_effects.py`; a move using one can stall a battle | 🔴 20 open |

---

## konefr's own work

69 commits — the content that makes New Gold a hack rather than an engine.

| Item | Detail | State |
| --- | --- | :-- |
| Trainers | Falkner through Morty and the Chuck gym; Denise (index 92) is still vanilla, skipped when Mareanie did not exist yet | 🟠 737 / 738 |
| Wild encounters | every map; route 40-41 landed, but the Whirl Islands and Cianwood's surf are still vanilla | 🟠 138 / 142 |
| Headbutt trees | routes 29-39, the Exeggcute filler replaced | ✅ done |
| Vanilla species rebalance | 35 species: 5 type changes, 15 ability changes, 28 stat spreads | ✅ done |
| Vanilla evolutions, learnsets, hidden abilities | learnsets and hidden abilities exact, 15 and 15; of the nine evolutions only Primeape and Stantler by move | 🟠 partial |
| Irrigation and Evaporate | his only two abilities — Water absorb with +2 Attack, and Water immunity | ✅ done |
| Solar Seeds | Fire special 25 BP multi-hit with burn; borrows Bullet Seed's animation | ✅ done |
| Bug-Catching Contest | Butterfree through Escavalier, levels 20-30, evolution-item prizes | ✅ done |
| Cherrygrove vendor and EV presets | his debug vendor, patched into a built script file — excluded in `SCOPE.md` | ⬜ out of scope |
| Water Absorb and Leaf Guard fixes | no self-trigger, damaging moves only; Leaf Guard restricted to sun | 🟠 partial |

---

## Verification

This is the section that holds the overall number down.

| Item | Detail | State |
| --- | --- | :-- |
| Boot and menus | both ROMs boot to a drawn screen; the scripted walk to the summary is HeartGold only | ✅ done |
| EV and IV viewer | six and a quarter minutes from a cold boot; captures in `validation/` | ✅ done |
| A battle renders | forced against species 19, 575, 900 and 1041, indoors and on Route 29's grass: background, sprite, name, and the battle runs to its end | ✅ done |
| A battle from a wild encounter | the same tile, the same species, the same terrain: started by the encounter check it freezes before `Battle_Run`, started directly it does not | 🔴 open |
| The four gyms to Morty | parties, levels, held items, and the AI using what it carries | 🔴 never |
| The seven level-cap steps | `savedit.py` sets badges one at a time — thirty seconds a step | 🔴 never |
| The 1041 species in play | sprite, icon, cry, name, Dex, an ability that does something | 🔴 never |
| Automated tests | 47 files, 198 checks: all but one read source and data, `test_boot.py` runs both ROMs — each memory bug got its regression test after the fact, not before | 🟠 partial |

---

## Why 67% and not 72%

The five points between the two numbers are the verification column, and the
reason it is not a formality is that four silent memory bugs surfaced in one
evening, every one of them introduced by the expansion:

- the cry archive read thirteen entries along its own table
- `LEVEL_UP_LEARNSET_MAX` was 21 against Mr. Rime's twenty-seven moves, and
  two more buffers for the same data were sized by hand — `0x2c` in the move
  tutor, `50` in the egg search
- tables indexed by a species number had not grown with it: `evo.narc` stayed
  575 members long because its rule did not depend on the header that sizes
  it, and two tables in C were read past their end

None fails a build, none fails a test, and each can produce a black screen.
Three in three hours is not a rate that exhausts itself — it is the rate they
are being looked for. What is left is not writing code. It is turning the game
on.

Not counted here: the rebalance konefr is still publishing, and the 2139 engine
items no content reaches.

---

## Keeping this current

`tools/newgold/ledger.py` regenerates the counters between the `LEDGER:COUNTS`
markers here and in `README.md` from the repository itself — the species, move
and ability ceilings from their headers, the trainer count from
`trainers.json`, the test count from `tests/newgold/`, and the ROM figures from
the built header. The states in the tables are edited by hand in the same
commit as the work they describe.
