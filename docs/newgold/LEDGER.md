# New Gold port ledger

Everything hg-engine and konefr change against vanilla HeartGold, and where the
native port stands on each. The one thing written by hand is the state on each
row, in the commit that moves it. Everything else — the counters, the
percentages at the top, `README.md`'s copy of both, and `docs/index.html` —
is generated from this file by `tools/newgold/ledger.py`. The summary was the
last part kept by hand and it was the part that was wrong, which is the whole
argument.

| | |
| --- | --- |
| base | `e97c7fc9` — pret/pokeheartgold |
| reference | `ccf2c9f5` — konefr/hg-engine-newgold, `heartgold-modern` |
| port | 189 commits |
| generated | 2026-09-22 18:07 |

<!-- LEDGER:SUMMARY:START -->
```
Overall                                                                    90%
  done, seen running   ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   8%
  done, never played   ██████████████████████████████████░░░░░░░░░░░░░░░░  67%
  partial              █████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  10%
  still to do          ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   4%
  deferred / no scope  █████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  10%

Implementation         ████████████████████████████████████████████████░░  96%
Verified in play       ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  11%

Overall and Implementation: done 1, partial a half, deferred rows
out of the denominator. Verified in play: of the rows that are done,
the share seen running. All three from the states in the tables.
```
<!-- LEDGER:SUMMARY:END -->

<!-- LEDGER:COUNTS:START -->
```
Species     ██████████████████████████████████████████████████  1028 / 1028
Moves       ██████████████████████████████████████████████████   923 /  923
Abilities   ██████████████████████████████████████████████████   319 /  319
Items       ██████████████████████████████████████████████████  2685 / 2685
Trainers    ██████████████████████████████████████████████████   738 /  738
Tests       63 files
ROM         151.1 MB of 268.4 MB   (2G card, 56% used)
```
<!-- LEDGER:COUNTS:END -->

---

## hg-engine engine features

75 toggles are enabled in the reference's own `config.h`. These are the ones
that carry behaviour.

| Feature | Detail | State |
| --- | --- | :-- |
| Fairy type and the effectiveness chart | type 18, the twelve chart rows, Sylveon and 66 species, 30 moves, its name in `msg_0735` and its icon in the battle graphics archive. The Dex's type search is not part of it: the reference never touches those lists, so there it covers seventeen types and 493 species too | ✅ done |
| Story level cap | wired in C to badges and flags 118/123/454 — 10→13→19→22→30→34→36→100, and it acts as the reference's does: a Pokemon at the cap wins no experience from a battle, so its bar does not move, and still gets the effort values; a Rare Candy is refused at the cap; experience past the cap's threshold is cut back for whoever carries it. It used to hand the experience over and cut it at the end, which is what Paolo saw as a bar that filled and snapped back | ✅ done |
| Hidden abilities | `TRPOKE_ABILITY_OVERRIDE_HIDDEN`; eleven trainer Pokémon ask for one | ✅ done |
| Ability field past one byte | save, battle record, AI memory, PC box, summary — and the personal record, whose three ability bytes now have their full values past the end of it | ✅ done |
| Reusable TMs, deletable HMs | `REUSABLE_TMS`, `DELETABLE_HMS`, plus the machine badge in the bag | ✅ done |
| EV and IV viewer | L shows effort, R shows individuals, Select restores stats | ✅ done |
| Expanded pockets, thirty boxes | change the save layout — and caused the first black battle | ✅ done |
| Scaled and capture experience | `EXPERIENCE_FORMULA_GEN`, `IMPLEMENT_CAPTURE_EXPERIENCE` | ✅ done |
| Eleven ball multipliers, critical capture | nine did match, and the last two do now: Moon Ball is the six species a Moon Stone evolves rather than HGSS's fourteen families, and Sport Ball is worth its extra half only in the Bug-Catching Contest. The audit found a third the row missed — Heavy Ball now weighs the Pokémon in all four bands instead of asking its catch rate in the last one — and two on the critical throw: the rate counts the Johto dex, and catching a species already registered shows as a critical. Dream and Beast Ball are not port work here: no ball ID or graphic reaches either, so neither can be thrown. The reference's own critical roll never sets the flag it tests, which would make a critical throw a guaranteed escape; the roll stays the animation and says so in a comment | ✅ done |
| Reusable repels, overworld poison, friendship threshold | repels and poison each on a matching decompilation, and the row was right about Sylveon: `EVO_HAS_MOVE_TYPE` asked for the Fairy move and not the friendship, and now asks for both. Eevee also lists Sylveon ahead of Espeon and Umbreon, because this loop stops at the first row that matches and she was last | ✅ done |
| Static HP bar, vitamin caps, low-HP music | `STATIC_HP_BAR`, `UPDATE_VITAMIN_EV_CAPS`, `DISABLE_CRITICAL_HP_WARNING` | ✅ done |
| Item restoration, friendship effects, AI item grab | `RESTORE_ITEMS_AT_BATTLE_END`, `FRIENDSHIP_EFFECTS`, `AI_CAN_GRAB_ITEMS` | ✅ done |
| Champions move values | the reference writes seven move records as a choice its own `config.h` settles -- power, type, accuracy and effect chance on, PP off. Four of the seven are retail moves the settings move off HeartGold's values, and those four are here now: Growth is Grass, Crabhammer hits at 95, Bone Rush is 30 a blow, and Iron Head flinches one time in five rather than three in ten. The other three -- Protect, Sandstorm, Night Slash -- are written as a choice too, and the branch the settings pick is the value this game already had, because `CHAMPIONS_PP_CHANGES` is the one that is off: nothing was owed on them. Each of the four takes konefr's whole record rather than the one field the setting decides, because half of his Crabhammer is neither game's move. Found while checking this row and not part of it: 107 more retail moves carry HeartGold's data where konefr carries his own -- his Thunderbolt is 90, this one's is 95 -- and 35 differ in the flag bits. That is the importer's rule, which only ever writes a record it adds, and it is a gap of its own rather than this one's | ✅ done |
| Widened Pokédex and footprints | footprints and Dex text for all 1041: entry, category, height and weight in twenty-seven banks | ✅ done |
| Bigger card | `RomSize 1G → 2G`, 256 MiB, `test_rom_budget.py` holds the margin | ✅ done |
| Per-move toggled mechanics | seven settings, and the row was stale on three of them. Protean was already generation nine -- once per appearance, the flag cleared on switch-in -- and Natural Gift was already done by the item import, which is where that setting lives: it picks the power on each berry's record and `test_items.py` holds all 64. Unseen Fist had its quarter damage and its way through a Protect; what was missing was the line the reference prints when the guard does not hold, and that is subscript 399 now. Three are new work and are done: Snow Warning summons snow rather than hail, which meant snow -- a field condition rather than a name in `battle_script_imports.h`, five turns counted down, an Ice-type's Defence half again as much, Ice Body fed, Blizzard sure of itself, Slush Rush and Snow Cloak reading it, Weather Ball not; Booster Energy cannot be tricked or stolen off the sixteen Paradox species, and can be off the four from the DLC, which is exactly what `VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR` decides. Two are not port work: Battle Bond's generation-nine boost reads a Greninja whose form is 1 and this tree has base species only, so it stays an unwritten ability on the Abilities row rather than debt here; and Corrosive Gas carries `FLAG_UNUSABLE_UNIMPLEMENTED` in the reference's own move data, so konefr's game will not teach it and its effect is a plain hit -- the guarded items its setting names are guarded against a move nobody can use. What the snow leaves behind, named in the scripts: no weather animation, entry 54 being past the end of this game's table, and no overworld-weather guard, because Drizzle, Drought and Sand Stream here still set the permanent bits that guard reads | ✅ done |
| Expanded prize money, gender, music, roamer tables | checked one by one, and all four are the same shape as the mart: hg-engine repoints a ROM table to a retyped copy in C so it can be edited, and this is a decompilation, where all four already are C. What is left is whether the copies say the same thing. Prize money: 129 rows, identical. Roamers: the same 41 routes in the same order under a different spelling, the same four species at the same levels. Music: three of the four tables identical; the eyes-meet table differs in two rows, where the reference names the two Johto Ace Trainer classes and the cartridge names the other two. Gender: the reference calls Koga and Bruno female where the cartridge says `TRAINER_DOUBLE`, and it has a row for class 128, which the cartridge's table stops one short of -- reading that class's gender here read the byte after the array. All three differences are konefr's and are here now, marked in the source as his; `test_expanded_tables.py` holds all four tables to the reference | ✅ done |
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
| Species | 1042 sprite directories, 1277 icons, heights, learnsets, evolutions. Every species konefr's tree NAMES is here -- all 1028 of them -- and this tree carries eighteen forms besides. The bar used to read 1041 of 1075 and mean nothing: that was the highest constant on each side, and the reference leaves forty-eight reserved gaps between Arceus and its own additions where this tree numbers densely. Counted by name, as the items are. Every species that can be female has a female picture now -- the male one again where the reference draws no difference, which is how the repository keeps its own; the importer used to leave it empty, and a female Sylveon sent out against Falkner read an empty archive member and aborted, the first thing Paolo's play found. `test_sprites.py` keeps it | ✅ 1028 / 1028 |
| Moves | 131 effect scripts, 59 subscripts, 62 side-effect table slots | ✅ 923 / 923 |
| Abilities | 280 do something — 123 retail effects and 157 added; of the other 39, sixteen are a name in the reference too and the rest want a primal weather, a paradox booster or a form this tree has not got | 🟠 280 / 319 |
| Level-up learnsets | 1042; the entry is a word now, so a move past 511 can be learnt | ✅ done |
| Battle script commands | 294 opcodes, name- and number-identical to the reference. Every command a script here runs does what the reference's does: the last two that only read their operands -- SetMoveConditionFlag, which is Powder, Laser Focus, Glaive Rush and Throat Chop, and ChangeExecutionOrderPriority, which is After You and Quash -- got their state, their consumers and, for the order, the reference's re-sort of whoever has not moved yet after every move. 19 added handlers are still stubs, and `test_battle_commands.py` names each one and proves no script runs it: they wait on mega and ultra burst, tera, totems, primal weather, Parental Bond and the batched messages of a spread move, none of which this tree has | 🟠 275 / 294 |
| Cries | `PlayCryEx` decompiled in `src/unk_02005D10.c` and linked by `main.lsf`, and the 495 ceiling is gone. The row said the bank was mapped twice on one path; it was every path, and it was not harmless. `PlayCryEx` mapped its species to a bank and then handed that bank back to `PlayCry` on all fourteen of its modes, and to `sub_02006AC0` on four more, and both map again — which only does no harm while the bank falls outside the added-species range 508 to 1041. 199 of the 534 do not: Cryogonal is species 664 and bank 997, the second lookup read 997 as a species, and Cryogonal played Veluza's cry. `PlayCryEx` now keeps its argument a species for the two functions that look a bank up for themselves and spends a new `bank` local on everything that asks the archive. `tests/newgold/test_cries.py` checks that each way in maps once and pins the 199 that made it matter | ✅ fixed |
| Items | 2685 of 2685: every item konefr's tree defines has a counterpart here. They are imported by name and renumbered densely from where this tree was -- their Black Augurite is 1691 and this one's is 537, because taking their ids would renumber every item in Paolo's save, his bag and every held item in the data -- and `tools/newgold/item_map.csv` is the mapping, 2685 of their names against 2685 ids here. This pass brought 2129 of them: ITEMS_COUNT 564 to 2693, the eight over their range being the slots HeartGold left empty that konefr filled with real items, so the gap stays here and their item is numbered beside it. 518 icons are built from konefr's PNGs, resolved by archive member and never by name; the other 1611 take ITEM_NONE's question mark knowingly, because konefr's art for them is byte-identical to `none.png`. 84 of their constants are reserved gaps with no name in 222.txt and are written the way this game already writes an empty slot. Descriptions are konefr's own single line, "Custom item description", for everything but the eighteen the pass before wrote prose for -- their description bank is that one line for the whole game. The 556 records both trees share now carry konefr's numbers rather than Game Freak's -- 277 prices, an Amulet Coin among them at 30000 against 100, and all 64 of Natural Gift's sixth-generation powers; Prism Scale keeps this engine's party-use evolution instead of the reference's hold effect, which is the one disagreement left and it is deliberate. What is not true yet: 64 hold effects came in with the range and no line in src/ reads one, so those items are an ordinary rock to carry, Ability Shield included; 29 records name one of the six field-use routines konefr has and this game has not -- the twenty Mints, the four Nectars, Ability Capsule, Reveal Glass, DNA Splicers, Rotom Catalog -- and were given routine 0, so they sit in the bag and do nothing rather than jumping past the end of `sItemFieldUseFuncs`; and nothing puts any of the 2129 in the world -- no mart, no hidden item, no wild Pokemon carrying one beyond the nine already imported | ✅ 2685 / 2685 |
| Evolutions | 434 species evolve, 458 rows: every line the reference draws between two species this tree names is here, the 163 species that had none brought in as a set and Scyther given Kleavor beside Scizor, all by methods this engine already runs -- level, stone, trade, friendship, a known move, the sex-split levels. What is not here is what cannot be said yet: 26 lines whose base or target is a form this tree has no species for (the Galarian, Hisuian and Paldean forms, Pumpkaboo's sizes, Alcremie's creams, the Antique Sinistea and Masterpiece Poltchageist that take the chipped pot, Rapid Strike Urshifu, Galarian Slowking), and 29 rows by a method this engine has not got -- level by time of day, in rain, by nature, with a Dark type in the party, after a move used twenty times, the Let's Go and specific-partner trades, the magnetic field, Alcremie's spins -- so `ITEM_SCROLL_OF_WATERS`, `ITEM_GALARICA_WREATH` and `ITEM_CHIPPED_POT` exist and reach nothing. `import_evolutions.py` reports every one and writes nothing it cannot express | 🟠 partial |
| Evolution archive | evo.narc's row stopped being a multiple of four when Sylveon made it eight evolutions, and o2narc wrote each member's padding over the next member instead of after this one: the allocation table strode 52 bytes through a 50-byte image, so every Pokemon from Ivysaur on read another one's evolutions. Fixed in `tools/o2narc/Options.cpp`; `tests/newgold/test_narc_alignment.py` checks all 115 built archives | ✅ fixed |
| Effects with a script but no C | none. The last two were Techno Blast and Multi-Attack, and the whole-range item import finished them: their scripts already read a held Drive or Memory and set the move's type from it, and what those scripts were reading were placeholders in `battle_script_imports.h` carrying konefr's hold-effect numbers 147 to 150 -- which in this game are Eviolite, Air Balloon, Absorb Bulb and Cell Battery, so Techno Blast was taking its type off those four. The Drives and the Memories are real items with real hold effects now and the placeholders are gone | ✅ done |

---

## konefr's own work

69 commits — the content that makes New Gold a hack rather than an engine.

| Item | Detail | State |
| --- | --- | :-- |
| Trainers | Falkner through Morty and the Chuck gym; Denise has her Mareanie now that the species exists | ✅ 738 / 738 |
| Wild encounters | every map, the Whirl Islands and Cianwood's surf included; a slot list the reference leaves short takes its last species rather than a hole | ✅ 142 / 142 |
| Headbutt trees | routes 29-39, the Exeggcute filler replaced | ✅ done |
| Vanilla species rebalance | 35 species: 5 type changes, 15 ability changes, 28 stat spreads | ✅ done |
| Vanilla evolutions, learnsets, hidden abilities | the row was right on all three counts: 15 learnsets and 15 hidden abilities, exact, and nine evolutions of which Primeape and Stantler had landed. The seven left were levels and nothing else — Bayleef 32 to 35, Cyndaquil 14 to 16, Quilava 36 to 35, Totodile 18 to 16, Croconaw 30 to 35, Flaaffy 30 to 35, Marill 18 to 22 — so the item range that came in this morning was not what they were waiting for. Written by `import_evolutions.py --levels-only`, which matches a row by method and target and moves it only where both sides give a bare number, so the reference writing Kirlia's Dawn Stone as the literal 109 stays the spelling difference it is and hg-engine's own rework of a vanilla method, the Linking Cord for a trade and the Ice Stone for Glaceon, stays out of this row. The reference also gives Annihilape and Wyrdeer an `EVO_FORM_ARGUMENT` row counting twenty uses of the move: that is hg-engine's method rather than konefr's change, and this tree has neither the method nor a form argument on a Pokemon to count into, so the `EVO_HAS_MOVE` line konefr added beside it is the whole of what was owed and the rest is not port work. `tests/newgold/test_evolutions.py` pins the nine and, with the reference checkout present, proves no vanilla level disagrees with `data/Evolutions.c` at all | ✅ done |
| Irrigation and Evaporate | his only two abilities — Water absorb with +2 Attack, and Water immunity | ✅ done |
| Solar Seeds | Fire special 25 BP multi-hit with burn; borrows Bullet Seed's animation | ✅ done |
| Bug-Catching Contest | Butterfree through Escavalier, levels 20-30, evolution-item prizes | ✅ done |
| Cherrygrove vendor and EV presets | his debug vendor, patched into a built script file — excluded in `SCOPE.md` | ⬜ out of scope |
| Water Absorb and Leaf Guard fixes | the row had it backwards. Leaf Guard's sunshine is HGSS's own and was never port work — but it left Rest out, and the Rest subscript now asks the same two questions the other six statuses ask. Water Absorb had the damaging-move guard and not the no-self-trigger one; it has both. Dry Skin keeps only the power check, in the reference as here | ✅ done |

---

## Verification

This is the section that holds the overall number down.

| Item | Detail | State |
| --- | --- | :-- |
| Boot and menus | both ROMs boot to a drawn screen; the scripted walk to the summary is HeartGold only | ✅ done |
| EV and IV viewer | six and a quarter minutes from a cold boot; captures in `validation/` | ✅ done |
| A battle renders | forced against species 19, 575, 900 and 1041, indoors and on Route 29's grass: background, sprite, name, and the battle runs to its end | ✅ done |
| A battle from a wild encounter | nine in a row on Route 29 from a cold boot, each from the game's own check, each running INIT to EXIT and handing the field back | ✅ done |
| The four gyms to Morty | Falkner played through on melonDS on 2026-09-22, from `hgss-saves/gyms/falkner.sav` at cap 13: Hoothoot, Farfetch'd, Doduo, Delibird and Murkrow, the party konefr's `Trainers.c` gives him, his two Potions used at the right moments, his lines on the last Pokemon, no experience for a party at the cap, the Zephyr Badge and TM51 at the end. Half of it was played from a shell with `tools/newgold/diag/play.py`. Two assertions fired on a Pokemon's way into battle and returned; the build now keeps the stack at an assertion, so the next run names who asked. Bugsy, Whitney and Morty are still to play, their saves ready | 🟠 1 of 4 |
| The seven level-cap steps | `savedit.py` sets badges one at a time — thirty seconds a step | 🔴 never |
| The 1041 species in play | sprite, icon, cry, name, Dex, an ability that does something | 🔴 never |
| Automated tests | All but one read source and data, `test_boot.py` runs both ROMs and the diagnostics build. Each memory bug got its regression test after the fact, not before, and the two that caught something before it shipped are the newest: the nickname lines that come in threes, and the stubs a script must not run | 🟠 partial |

---

## Why 71% and not 78%

The points between the two numbers are the verification column, and the reason
it is not a formality is that four silent memory bugs surfaced in one evening,
every one of them introduced by the expansion:

- the cry archive read thirteen entries along its own table
- `LEVEL_UP_LEARNSET_MAX` was 21 against Mr. Rime's twenty-seven moves, and
  two more buffers for the same data were sized by hand — `0x2c` in the move
  tutor, `50` in the egg search
- tables indexed by a species number had not grown with it: `evo.narc` stayed
  575 members long because its rule did not depend on the header that sizes
  it, and two tables in C were read past their end

None fails a build, none fails a test, and each can produce a black screen.
Two apparent fifths were the instrument rather than the game — a forced land
encounter on a map whose table is surf-only, and a teleport that wrote the
player's tile without the position vector that goes with it — which is its
own lesson about what a diagnostic switch may do.
Three in three hours is not a rate that exhausts itself — it is the rate they
are being looked for. What is left is not writing code. It is turning the game
on.

Not counted here: the rebalance konefr is still publishing, and the 2139 engine
items no content reaches.

---

## Keeping this current

`tools/newgold/ledger.py` does three things, and `tests/newgold/test_ledger.py`
fails if any of them is behind.

It reads the counters out of the repository — the species, move, ability and
item ceilings from the headers on both sides, the trainers from
`trainers.json`, the tests from `tests/newgold/`, the ROM from the header of
the card it just built — and writes them between the `LEDGER:COUNTS` markers
here and in `README.md`.

It counts the states in the tables below and writes the summary from them. A
done row scores one and a partial row a half; deferred rows leave the
denominator rather than counting as failures. "Verified in play" is, of the
rows that are done, the share that has been seen running. Assigning a row its
state is the judgement; none of the arithmetic is.

It renders `docs/index.html` from this file: the heading, both blocks of bars,
and the four tables, each row's three columns becoming a name, a bar and a
chip, with the state choosing the chip's class and the bar's width.
