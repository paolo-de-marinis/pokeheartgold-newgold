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
| reference | `1fa3c9366` — konefr/hg-engine-newgold, `heartgold-modern` |
| port | 910 commits |
| generated | 2026-09-24 11:29 |

<!-- LEDGER:SUMMARY:START -->
```
Overall                                                                    95%
  done, seen running   █████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  10%
  done, never played   ███████████████████████████████░░░░░░░░░░░░░░░░░░░  62%
  partial              ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   8%
  still to do          ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0%
  deferred / no scope  ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  20%

Implementation         ████████████████████████████████████████████████░░  96%
Verified in play       ███████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  14%
Audit rows closed      ███████████████████████████████████████████░░░░░░░  86%

Audit: 48 of 344 rows in docs/newgold/AUDIT-*.md still open.
The port is finished when none is, or each is closed with a reason.
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
Tests       145 files
ROM         165.7 MB of 268.4 MB   (2G card, 62% used)
```
<!-- LEDGER:COUNTS:END -->

---

## hg-engine engine features

75 toggles are enabled in the reference's own `config.h`. These are the ones
that carry behaviour.

| Feature | Detail | State |
| --- | --- | :-- |
| Fairy type and the effectiveness chart | type 18, the twelve chart rows, Sylveon and 66 species, 30 moves, its name in `msg_0735` and its icon in the battle graphics archive. The Dex's type search has it since the seventh round (ff4204d23, and 4c4f631ee for konefr's Fairy Meganium and Mismagius), which the reference never gave its lists | ✅ done |
| Story level cap | wired in C to badges and flags 118/123/454 — 10→13→19→22→30→34→36→100, the same NPCs as konefr's `GetLevelCap`: Elder Li, Falkner, Proton, Bugsy, Whitney, Silver at the Burned Tower, Morty. It acts as his build does: a Pokemon at the cap wins no experience from a battle, so its bar does not move, and still gets the effort values; experience past the cap's threshold is cut back for whoever carries it; and, as his `config.h` keeps `UNCAP_CANDIES_FROM_LEVEL_CAP` and `ALLOW_LEVEL_CAP_EVOLVE`, a Rare Candy still levels past the cap and can evolve a Pokemon that has reached it. For an hour on 2026-09-22 the candy was refused here; it is not | ✅ done |
| Hidden abilities | `TRPOKE_ABILITY_OVERRIDE_HIDDEN`; eleven trainer Pokémon ask for one | ✅ done |
| Ability field past one byte | save, battle record, AI memory, PC box, summary — and the personal record, whose three ability bytes now have their full values past the end of it | ✅ done |
| Reusable TMs, deletable HMs | `REUSABLE_TMS`, `DELETABLE_HMS`, plus the machine badge in the bag; since the fifth round the 240 machines past HM08 teach their moves too, every species has a bit for all 340, a TR is spent when used and carries its own badge, and the TM case sorts TMs, then TRs, then HMs (3396fa25c to 8c902ecf2) | ✅ done |
| EV and IV viewer | L shows effort, R shows individuals, Select restores stats | ✅ done |
| Expanded pockets, thirty boxes | change the save layout — and caused the first black battle | ✅ done |
| Scaled and capture experience | `EXPERIENCE_FORMULA_GEN`, `IMPLEMENT_CAPTURE_EXPERIENCE` | ✅ done |
| Eleven ball multipliers, critical capture | nine did match, and the last two do now: Moon Ball is the six species a Moon Stone evolves rather than HGSS's fourteen families, and Sport Ball is worth its extra half only in the Bug-Catching Contest. The audit found a third the row missed — Heavy Ball now weighs the Pokémon in all four bands instead of asking its catch rate in the last one — and two on the critical throw: the rate counts the Johto dex, and catching a species already registered shows as a critical. Dream and Beast Ball are not port work here: no ball ID or graphic reaches either, so neither can be thrown. The reference's own critical roll never sets the flag it tests, which would make a critical throw a guaranteed escape after one shake; since 82eef4cd7 a critical throw is decided by one shake check, as in the games (Paolo, 2026-09-23). Since 2026-09-23 the catch itself is hg-engine's generation 8/9 formula (540cd1805), with two of its slips not copied -- the badges counted as bitmasks, and the Heavy Ball's -20 wrapping a u32 -- and the Friend Ball keeps the 150 friendship the reference's config documents rather than the 200 its code writes | ✅ done |
| Reusable repels, overworld poison, friendship threshold | repels and poison each on a matching decompilation, and the row was right about Sylveon: `EVO_HAS_MOVE_TYPE` asked for the Fairy move and not the friendship, and now asks for both. Eevee also lists Sylveon ahead of Espeon and Umbreon, because this loop stops at the first row that matches and she was last | ✅ done |
| Static HP bar, vitamin caps, low-HP music | `STATIC_HP_BAR`, `UPDATE_VITAMIN_EV_CAPS`, `DISABLE_CRITICAL_HP_WARNING` | ✅ done |
| Item restoration, friendship effects, AI item grab | `RESTORE_ITEMS_AT_BATTLE_END`, `FRIENDSHIP_EFFECTS`, `AI_CAN_GRAB_ITEMS` | ✅ done |
| Champions move values | the reference writes seven move records as a choice its own `config.h` settles -- power, type, accuracy and effect chance on, PP off. Four of the seven are retail moves the settings move off HeartGold's values, and those four are here now: Growth is Grass, Crabhammer hits at 95, Bone Rush is 30 a blow, and Iron Head flinches one time in five rather than three in ten. The other three -- Protect, Sandstorm, Night Slash -- are written as a choice too, and the branch the settings pick is the value this game already had, because `CHAMPIONS_PP_CHANGES` is the one that is off: nothing was owed on them. Each of the four takes konefr's whole record rather than the one field the setting decides, because half of his Crabhammer is neither game's move. | ✅ done |
| Retail move data | hg-engine's type, power, accuracy, PP, effect chance and named flags for moves 1..467, read at `d0380a487` by `import_moves.py`, which used to write only the records it added: 130 records changed -- Thunderbolt, Flamethrower, Surf and Ice Beam 90, Charm, Sweet Kiss and Moonlight Fairy, Whirlwind and Roar never missing (accuracy 0 is 'never misses' in both trees) -- and the engine's Hidden Power at 60 and Fury Cutter doubling from 40 to 160. konefr changed no retail move, so this is all engine; his trainers were balanced against these numbers. What is still not the engine's is an audit row | ✅ done |
| Widened Pokédex and footprints | footprints and Dex text for all 1041: entry, category, height and weight in twenty-seven banks | ✅ done |
| Bigger card | `RomSize 1G → 2G`, 256 MiB, `test_rom_budget.py` holds the margin | ✅ done |
| Per-move toggled mechanics | seven settings, and the row was stale on three of them. Protean was already generation nine -- once per appearance, the flag cleared on switch-in -- and Natural Gift was already done by the item import, which is where that setting lives: it picks the power on each berry's record and `test_items.py` holds all 64. Unseen Fist had its quarter damage and its way through a Protect; what was missing was the line the reference prints when the guard does not hold, and that is subscript 399 now. Three are new work and are done: Snow Warning summons snow rather than hail, which meant snow -- a field condition rather than a name in `battle_script_imports.h`, five turns counted down, an Ice-type's Defence half again as much, Ice Body fed, Blizzard sure of itself, Slush Rush and Snow Cloak reading it, Weather Ball not; Booster Energy cannot be tricked or stolen off the sixteen Paradox species, and can be off the four from the DLC, which is exactly what `VANILLA_PARADOX_BOOSTER_ENERGY_BEHAVIOUR` decides. Two are not port work: Battle Bond's generation-nine boost reads a Greninja whose form is 1; the forms are species here, and what is missing is the in-battle form change that makes one, so it stays an unwritten ability on the Abilities row rather than debt here; and Corrosive Gas carries `FLAG_UNUSABLE_UNIMPLEMENTED` in the reference's own move data, so konefr's game will not teach it and its effect is a plain hit -- the guarded items its setting names are guarded against a move nobody can use. What the snow leaves behind, named in the scripts: no weather animation, entry 54 being past the end of this game's table, and no overworld-weather guard, because Drizzle, Drought and Sand Stream here still set the permanent bits that guard reads | ✅ done |
| Expanded prize money, gender, music, roamer tables | checked one by one, and all four are the same shape as the mart: hg-engine repoints a ROM table to a retyped copy in C so it can be edited, and this is a decompilation, where all four already are C. What is left is whether the copies say the same thing. Prize money: 129 rows, identical. Roamers: the same 41 routes in the same order under a different spelling, the same four species at the same levels. Music: three of the four tables identical; the eyes-meet table differs in two rows, where the reference names the two Johto Ace Trainer classes and the cartridge names the other two. Gender: the reference calls Koga and Bruno female where the cartridge says `TRAINER_DOUBLE`, and it has a row for class 128, which the cartridge's table stops one short of -- reading that class's gender here read the byte after the array. All three differences are konefr's and are here now, marked in the source as his; `test_expanded_tables.py` holds all four tables to the reference | ✅ done |
| Mart expansion | the decomp already holds the mart tables in C (`src/scrcmd_mart.c`); `MART_EXPANSION` is stock hg-engine and konefr never touched it | ⬜ not needed |
| BDHCAM routine | `ov01_021FB04C` — map-editing infrastructure, no map touched | ⬜ not needed |
| Mega Evolution, Primal Reversion, seasons | out of scope by SCOPE.md until asked for. The species and their forms are here -- the megas, the primals, Deerling's seasons -- as species of their own; what is not here is the machinery that turns one into another, and New Gold never turns Mega on | ⬜ deferred |
| Z-Moves, Dynamax, Terastallization | states and flags with TODOs upstream — not behaviour to reproduce | ⬜ out of scope |

---

## Engine content

The whole range, after the criterion changed: the platform has to carry what
konefr *could* reach, not only what the game reaches today.

| Item | Detail | State |
| --- | --- | :-- |
| Species | Every species konefr's tree NAMES is here -- all 1028 of them, counted by name as the items are -- and, since 2026-09-22, every form it numbers as a species as well: 396 of them, from `SPECIES_MEGA_VENUSAUR` at 1042 to `SPECIES_MEGA_BAXCALIBUR` at 1437 -- the megas, the primals, the Alolan, Galarian, Hisuian and Paldean forms, the Gigantamax forms, Rotom's and Deoxys's kin among the newer generations. Each is a species of its own here, as the two Galarian Slowpoke were already: its own personal record, pictures, icon, heights, learnset (its base's where the reference gives it none), cry (its base's), name (its base's), Dex text (its base's), footprint, hidden ability, and its evolutions. What is not here is the machinery that turns one form into another: Mega Evolution, primal reversion, Dynamax, the ability-driven changes. `NUM_SPECIES` is the last form; `NATIONAL_DEX_COUNT` stays on Pecharunt, so the Dex has 1027 pages, and a form met, caught or evolved into registers as its base species and prints its number. The picture rule: every species that can be female has a female picture, the male one again where the reference draws no difference | ✅ 1028 / 1028 |
| Moves | 131 effect scripts, 59 subscripts, 62 side-effect table slots, and the three "X used Y!" lines each move reads from bank 3. Until 2026-09-23 that bank stopped at Shadow Force, so any move past 467 stopped the battle the moment it was used -- Morty's Misdreavus found it with Hex | ✅ 923 / 923 |
| Abilities | 317 of the 318 do something — 123 retail effects and 194 of the 195 added. The last 31 came in the fifth round, each from its Pokémon Central page where the reference leaves it empty (Paolo, 2026-09-23: none stays empty): the primal weathers, Parental Bond, Illusion, Emergency Exit and Wimp Out, Dancer, the Terapagos and Ogerpon abilities -- the Tera forms being species, they act as the form comes in -- Mega Sol, Shields Down, Battle Bond and the ally and switch-in abilities. The 319th constant, TEMP4, is a slot the engine reserved and named "Placeholder", carried by no species, and `test_ability_effects.py` counts it apart. `PENDING` holds Commander since the seventh round, when a block list stopped counting as an ability's reading (acc7c51ae): Tatsugiri and Dondozo get nothing in a double battle yet, an open audit row; Gulp Missile and Poison Puppeteer, which had passed the same way, do what Pokemon Central says (a76cef294, 66281a56e). None of the 31 has been seen on an emulator: the harness renders no battle, and the evidence is host tests and the built scripts | 🟠 317 / 318 |
| Level-up learnsets | 1042; the entry is a word now, so a move past 511 can be learnt. HeartGold's own 493 learn hg-engine's moves since a65853039, with konefr's fifteen over them in ef3b52436, so Dunsparce learns Hyper Drill and Dudunsparce can be had; trainers given no moves take theirs from these | ✅ done |
| Battle script commands | 294 opcodes, name- and number-identical to the reference. Every command a script here runs does what the reference's does: the last two that only read their operands -- SetMoveConditionFlag, which is Powder, Laser Focus, Glaive Rush and Throat Chop, and ChangeExecutionOrderPriority, which is After You and Quash -- got their state, their consumers and, for the order, the reference's re-sort of whoever has not moved yet after every move. 13 added handlers are still stubs -- CheckProtectContactMoves is done now, the six shields answering a touch -- and `test_battle_commands.py` names each one and proves no script runs it but AbilityPopup, the later games' banner naming an ability, which the scripts run on purpose and which must do nothing else: when it cleared the ability's once-guard, a Surge announced its terrain for ever (6482b58d3). The others wait on mega and ultra burst, totems, Zero to Hero's form change, the batched messages of a spread move, the background a terrain's end redraws and the reference's switch after a move, or no script in the reference runs them either | 🟠 281 / 294 |
| Cries | `PlayCryEx` decompiled in `src/unk_02005D10.c` and linked by `main.lsf`, and the 495 ceiling is gone. The row said the bank was mapped twice on one path; it was every path, and it was not harmless. `PlayCryEx` mapped its species to a bank and then handed that bank back to `PlayCry` on all fourteen of its modes, and to `sub_02006AC0` on four more, and both map again — which only does no harm while the bank falls outside the added-species range 508 to 1041. 199 of the 534 do not: Cryogonal is species 664 and bank 997, the second lookup read 997 as a species, and Cryogonal played Veluza's cry. `PlayCryEx` now keeps its argument a species for the two functions that look a bank up for themselves and spends a new `bank` local on everything that asks the archive. `tests/newgold/test_cries.py` checks that each way in maps once and pins the 199 that made it matter | ✅ fixed |
| Items | 2685 of 2685: every item konefr's tree defines has a counterpart here. They are imported by name and renumbered densely from where this tree was -- their Black Augurite is 1691 and this one's is 537, because taking their ids would renumber every item in Paolo's save, his bag and every held item in the data -- and `tools/newgold/import/item_map.csv` is the mapping, 2685 of their names against 2685 ids here. This pass brought 2129 of them: ITEMS_COUNT 564 to 2693, the eight over their range being the slots HeartGold left empty that konefr filled with real items, so the gap stays here and their item is numbered beside it. 518 icons are built from konefr's PNGs, resolved by archive member and never by name; the other 1611 take ITEM_NONE's question mark knowingly, because konefr's art for them is byte-identical to `none.png`. 84 of their constants are reserved gaps with no name in 222.txt and are written the way this game already writes an empty slot. Descriptions are konefr's own single line, "Custom item description", for everything but the eighteen the pass before wrote prose for -- their description bank is that one line for the whole game. The 556 records both trees share now carry konefr's numbers rather than Game Freak's -- 277 prices, an Amulet Coin among them at 30000 against 100, and all 64 of Natural Gift's sixth-generation powers; Prism Scale keeps this engine's party-use evolution instead of the reference's hold effect, which is the one disagreement left and it is deliberate. Since the fifth round every one of the 64 hold effects the range brought is read -- where they fall short of the games is an audit row -- and the twenty-one Mints, the Ability Capsule and the Ability Patch work from the party menu, the four Nectars, the Reveal Glass and the Rotom Catalog from the bag. What is not true yet: the DNA Splicers do nothing, because they keep the fused Reshiram or Zekrom in the save, in the extension konefr's config turns on -- an open audit row; and nothing puts any of the 2129 in the world -- no mart, no hidden item, no wild Pokemon carrying one beyond the nine already imported | ✅ 2685 / 2685 |
| Evolutions | 494 species evolve: every line the reference draws between two species this tree names, the forms included now that they are species -- Kubfu takes the Scroll of Waters to Rapid Strike Urshifu, Galarian Slowpoke the Galarica Wreath to Galarian Slowking, the Antique Sinistea and Masterpiece Poltchageist take the chipped pot, and a form that evolves keeps its form, an Antique Sinistea becoming an Antique Polteageist as the reference carries the number over. What is still not here since the sixth round's methods (the magnetic field, a level by the time of day, in the rain, with a Dark type in the party, by nature, a move used twenty times, three critical hits, damage taken, a thousand steps walked out of the ball, Gimmighoul's coins, the Bisharp a Bisharp defeats, Karrablast traded for Shelmet): Milcery's nine rows, whose spin the reference never checks and whose forms it numbers wrongly -- an open audit row, with Paolo's design to build: the Ice Path and a held Berry -- and a female-form target (Unfezant, Pyroar) is a species of its own here that the Dex counts as its base. The seventh round added the Moss Rock and the Ice Rock (196be0087) and Karrablast and Shelmet evolving in a GTS trade (3e8629c64). `import_evolutions.py` reports every row it cannot express. hg-engine's own changes to eight of HeartGold's species are in as well, read at `d0380a487` with `--engine-reworks`: the Linking Cord for Kadabra, Machoke, Graveler and Haunter, the Thunder Stone for Magneton and Nosepass, the Leaf and Ice Stones for Eevee, a Prism Scale trade for Feebas. Until 2026-09-23 they were left out as a rework rather than a change, and Magnezone, Probopass, Leafeon and Glaceon could not be had: their retail rows name Mt. Coronet, Eterna and Route 217 | 🟠 partial |
| Evolution archive | evo.narc's row stopped being a multiple of four when Sylveon made it eight evolutions, and o2narc wrote each member's padding over the next member instead of after this one: the allocation table strode 52 bytes through a 50-byte image, so every Pokemon from Ivysaur on read another one's evolutions. Fixed in `tools/o2narc/Options.cpp`; `tests/newgold/test_narc_alignment.py` checks all 115 built archives | ✅ fixed |
| Text, as hg-engine writes it | every bank hg-engine d0380a487 writes or generates, row for row, in this tree's numbering: battle messages (197, 1787 rows as the engine has them, the port's own lines after it and every script and C reference moved to the engine's rows and tags), the "X used Y!" lines and move names, descriptions and capitals (003, 749-751), type names (735), item names, descriptions, articles and plurals (221-224, from the engine's per-generation banks 830-853 through `item_map.csv`), species names, Dex entries, classifications and measures (237, 238, 803, 811-817, 823), the bag, PC, field, blackout, party, summary and shop banks (010, 024, 040, 203, 300, 302, 435), ability text (720-722) and trainer names and lines (728, 729). Each is written by an importer that takes a revision. Found on the way and fixed: 2045 item descriptions read "Custom item description", because the importer had taken hg-engine's one-row custom-item bank for the real one; 27 banks were out of order from Victini on, so the Dex showed the species two along; trainer names never reached the ROM, because the rule that makes their bank had no prerequisites. Forms are species here, and a form's rows take its base species' text, which is what hg-engine shows | ✅ done |
| Effects with a script but no C | none left: what test_move_effects.py's UNREAD_HERE still lists is either an effect no move uses, a check the script itself does, or a data bit the C reads -- the last with C to write, Parting Shot's switch, landed in the sixth round (d40343570). The row said 22 on 2026-09-23 morning; it counted only the effects with no script at all before that | ✅ done |

---

## konefr's own work

69 commits — the content that makes New Gold a hack rather than an engine.

| Item | Detail | State |
| --- | --- | :-- |
| Trainers | Falkner through Morty and the Chuck gym; Denise has her Mareanie now that the species exists | ✅ 738 / 738 |
| Wild encounters | every map, the Whirl Islands and Cianwood's surf included; a slot list the reference leaves short takes its last species rather than a hole | ✅ 142 / 142 |
| Headbutt trees | routes 29-39, the Exeggcute filler replaced | ✅ done |
| Vanilla species rebalance | 35 species: 5 type changes, 15 ability changes, 28 stat spreads | ✅ done |
| Vanilla evolutions, learnsets, hidden abilities | the row was right on all three counts: 15 learnsets and 15 hidden abilities, exact, and nine evolutions of which Primeape and Stantler had landed. The seven left were levels and nothing else — Bayleef 32 to 35, Cyndaquil 14 to 16, Quilava 36 to 35, Totodile 18 to 16, Croconaw 30 to 35, Flaaffy 30 to 35, Marill 18 to 22 — so the item range that came in this morning was not what they were waiting for. Written by `import_evolutions.py --levels-only`, which matches a row by method and target and moves it only where both sides give a bare number, so the reference writing Kirlia's Dawn Stone as the literal 109 stays the spelling difference it is and hg-engine's own rework of a vanilla method, the Linking Cord as a stone for Kadabra's line and the Ice Stone for Glaceon, is the engine's and is on the Evolutions row. The reference also gives Annihilape and Wyrdeer an `EVO_FORM_ARGUMENT` row counting twenty uses of the move: that is hg-engine's method rather than konefr's change, and this tree has neither the method nor a form argument on a Pokemon to count into, so the `EVO_HAS_MOVE` line konefr added beside it is the whole of what was owed and the rest is not port work. `tests/newgold/test_evolutions.py` pins the nine and, with the reference checkout present, proves no vanilla level disagrees with `data/Evolutions.c` at all | ✅ done |
| Irrigation and Evaporate | his only two abilities — Water absorb with +2 Attack, and Water immunity | ✅ done |
| Solar Seeds | Fire special 25 BP multi-hit with burn; borrows Bullet Seed's animation | ✅ done |
| Bug-Catching Contest | Butterfree through Escavalier, levels 20-30, evolution-item prizes | ✅ done |
| Cherrygrove vendor and EV presets | his debug vendor, patched into a built script file — excluded in `SCOPE.md` | ⬜ out of scope |
| Linking Cord for any trade | his `e26576dd1`: a Pokemon that evolves by trading alone evolves when a Linking Cord is used on it -- Phantump, Pumpkaboo and the rest. It sits ahead of the engine's own case, the trade with a held item, as in his code; the engine's stone rows for Kadabra and the other three are on the Evolutions row, not this one | ✅ done |
| konefr's text | what `d0380a487..1fa3c9366` changes in the text: Irrigation, Eelevate and Evaporate's names and descriptions, Solar Seeds' name, description and "used" lines, the three Galarian names, the lines and names of trainers 47, 383 and Proton, and bank 550's vendor lines, which nothing here reads since the vendor itself is out of scope. Written by the same importers at `1fa3c9366`, on top of the engine's text, so the engine layer is the commit before | ✅ done |
| Water Absorb and Leaf Guard fixes | the row had it backwards. Leaf Guard's sunshine is HGSS's own and was never port work — but it left Rest out, and the Rest subscript now asks the same two questions the other six statuses ask. Water Absorb had the damaging-move guard and not the no-self-trigger one; it has both. Dry Skin keeps only the power check, in the reference as here | ✅ done |

---

## Two layers

The split into an engine and New Gold, deferred until further notice: `SCOPE.md` has the rule that holds meanwhile and the same seven steps. Every row is deferred, so none of them moves a percentage.

| Item | Detail | State |
| --- | --- | :-- |
| konefr's five switches configurable | `IMPLEMENT_LEVEL_CAP`, `LEVEL_CAP_VARIABLE`, `UNCAP_CANDIES_FROM_LEVEL_CAP`, `ALLOW_LEVEL_CAP_EVOLVE`, `DELETABLE_HMS`: off in the engine, on in New Gold. Today they are wired always on | ⬜ deferred |
| `GetLevelCap` reads the variable | as hg-engine does, `LEVEL_CAP_VARIABLE`, with konefr's ladder 10→13→19→22→30→34→36 as data rather than code | ⬜ deferred |
| konefr's abilities and move behind the extension points | Irrigation, Evaporate, Solar Seeds; `ABILITY_TEMP2` and `NUM_OF_CUSTOM_MOVES` at 0 in the engine | ⬜ deferred |
| Importers that take a revision | `d0380a487` gives the engine's data, `1fa3c9366` New Gold's | ⬜ deferred |
| The separation recounted by provenance | the old count, 8 mixed commits of 175, looked only at file paths; the rule is what `d0380a487..1fa3c9366` introduces or modifies | ⬜ deferred |
| The split | `git tag port-history`; `engine` from pret `e97c7fc9` with the matching decompilations cherry-picked and the rest regenerated at `d0380a487`; `newgold` rebuilt on it at `1fa3c9366`; `git merge -s ours` of the published branch, so the push is a fast-forward | ⬜ deferred |
| The engine-only configuration played | never built yet | ⬜ deferred |

---

## Verification

This is the section that holds the overall number down.

| Item | Detail | State |
| --- | --- | :-- |
| Boot and menus | both ROMs boot to a drawn screen; the scripted walk to the summary is HeartGold only | ✅ done |
| EV and IV viewer | six and a quarter minutes from a cold boot; captures in `validation/` | ✅ done |
| A battle renders | forced against species 19, 575, 900 and 1041, indoors and on Route 29's grass: background, sprite, name, and the battle runs to its end | ✅ done |
| A battle from a wild encounter | nine in a row on Route 29 from a cold boot, each from the game's own check, each running INIT to EXIT and handing the field back | ✅ done |
| The four gyms to Morty | Falkner played through on melonDS on 2026-09-22 from `hgss-saves/gyms/falkner.sav` at cap 13 -- his party from konefr's `Trainers.c`, his two Potions used, no experience at the cap, the Zephyr Badge and TM51. Bugsy, Whitney and Morty on 2026-09-23 headlessly with `tools/newgold/devkit/diag/gym.py`, every one won, no assertion: Bugsy at cap 22 -- Ledian, Scizor, Heracross, Ariados, Shuckle and his Super Potion -- and the badge counted 1 -> 2 in RAM after the fight; Whitney at cap 30 -- Furret, Wigglytuff, Miltank, Ambipom, Farigiraf; Morty at cap 36 -- Misdreavus, Annihilape, Mismagius, Gengar, Shuppet -- and the badge 3 -> 4. Whitney's badge was the one not seen until the seventh round: as in retail she cries and gives it only when spoken to again after her Lass (`FLAG_UNK_0B7`). No party gained a point of experience at its cap. Whitney and Morty were fought with parties picked against them, because the bot never switches; the mixed saves lost, on matchups, and until bank 3 was complete they stopped on Morty's Hex. Replayed on 56b3cfacf, after the text became hg-engine's and konefr's, as a regression check: all four won again, Falkner's badge 0 -> 1 now read headlessly too, no assertion. And again on 01e14329a, after the retail moves took hg-engine's numbers: all four won, badges 0 -> 1, 1 -> 2, 3 -> 4, no assertion; Bugsy took twice as long to beat. And on c9b5c2ec9, after the third round changed burns, paralysis, critical hits and the protect family: the first replay caught four status scripts overflowing the script buffer at Falkner's Toxic Orb, fixed there; replayed, all four won, no assertion, Bugsy by Machamp's last 4 HP. And on 7d65064ea, after the fourth round's damage chain, form changes and Neutralizing Gas: Falkner, Bugsy and Whitney won; Morty was lost -- Annihilape's Drain Punch, four times effective, took Tyranitar in one hit where it had left 5 HP before, and Mismagius landed two critical Dazzling Gleams -- every hit inside its range and no assertion, a matchup the bot cannot switch out of. With Honchkrow moved to second, whose Brave Bird takes Annihilape in one, Morty was won and the badge counted 3 -> 4. And on d3d5ec433, after the fifth round -- every ability, every hold effect, hg-engine's learnsets for the retail species, the machines past HM08: all four won, badges 0 -> 1, 1 -> 2, 3 -> 4, no assertion and no allocation that failed. And on c49e5dd94, after the sixth round and with the saves still in the layout from before the DNA Splicers, which the game converts as it loads them: Falkner, Whitney and Morty won; Bugsy was lost to Ariados on the rolls -- Stealth Rock and Sticky Web took what they should, a quarter from Togekiss and a sixteenth from Machamp -- with Umbreon and Sylveon on their level-up moves, Helping Hand and Baby Doll Eyes; given moves for the fight, the same six won and the badge counted 1 -> 2. No assertion, no allocation that failed. And after the seventh round, checked on its integration branch and replayed on 017ef7d2a once it was on newgold, on the diagnostics build with the default heap at 0x8000: all four won, badges 0 -> 1, 1 -> 2, 2 -> 3 -- Whitney's too, walked to her Lass's scene and back -- and 3 -> 4, no assertion and no allocation that failed. Falkner was won from the save before the OT fix and from a copy put back in Violet Gym, falkner.sav now standing in Cianwood; from played-falkner-1727.sav the fight was lost, on the bot's moves, with its Typhlosion asleep through several turns | ✅ 4 / 4 |
| The seven level-cap steps | the cap seen holding in battle at 13, 22, 30 and 36 -- a party at the cap wins no experience from a leader -- and the badges that move it seen landing for Zephyr, Hive and Fog. The rise itself, a Pokemon levelling past the old cap after the badge, and the 10 and 19 and 34 steps, are still unseen; `savedit.py` sets badges one at a time | 🟠 partial |
| The species in play | all 1438 species and forms: sprite, icon, cry, name, Dex, an ability that does something. `species.py` (0365359e6 and 0395ef9b2) walked them in the seventh round, 1488 species and forms and 3671 variants -- every gender, every ability -- through the PC and its icons, the summary, the Dex's 1025 pages and a battle each, and 51 more battles for the abilities only a second or hidden slot carries. What it found the round fixed: Surge battles hanging, 18 cries that never played, the Normal second type undrawn, the summary's cry asking for the ability as the form, savedit's Dex; the 16 striped icons it flagged are fixed by 6c59633e0 and ee3154572, four of them seen since in the Dex grid. What it cannot see is in the audit: a battle is judged by its markers, the harness drawing none, with the wild Pokemon always form 0; the Dex's FORMS page was not walked; nobody listened to the cries | ✅ seen |
| Automated tests | All but one read source and data, `test_boot.py` runs both ROMs and the diagnostics build. Each memory bug got its regression test after the fact, not before, and the two that caught something before it shipped are the newest: the nickname lines that come in threes, and the stubs a script must not run | 🟠 partial |

---

## Why 95% and not 96%

The points between the two numbers are the verification column, and the reason
it is not a formality is that four silent bugs surfaced in one evening, on
2026-09-21, every one of them introduced by the expansion:

- the cry archive read thirteen entries along its own table
- `LEVEL_UP_LEARNSET_MAX` was 21 against Mr. Rime's twenty-seven moves, and
  two more buffers for the same data were sized by hand — `0x2c` in the move
  tutor, `50` in the egg search
- a learnset entry kept its move in nine bits, and the learnsets were
  written before the moves past 495 existed: 1060 entries naming them were
  skipped as missing and never written again, so those Pokemon never learnt
  them by level
- tables indexed by a species number had not grown with it: `evo.narc` stayed
  575 members long because its rule did not depend on the header that sizes
  it, and two tables in C were read past their end

None fails a build and none fails a test. Three of them can produce a black
screen; the fourth leaves moves out of a learnset and says nothing. Four in
one evening was not a rate that exhausts itself — it was the rate they were
being looked for. What is left is not writing code. It is turning the game on.

Two apparent fifths were the instrument rather than the game — a forced land
encounter on a map whose table is surf-only, and a teleport that wrote the
player's tile without the position vector that goes with it — which is its
own lesson about what a diagnostic switch may do.

The figures are in the blocks above and nowhere in this prose. This heading
once kept two percentages the summary had long since left, so `ledger.py`
writes it now, and `test_ledger.py` fails on a figure typed here by hand.

Not counted here: whatever konefr publishes after the reference pinned at the
top.

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
