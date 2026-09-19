# NewGold baseline manifest inventory

This is a pinned, reproducible **baseline mapping**, not a progress claim. Current milestone status and counters belong in the migration document; regenerating this inventory must not reset that progress.

- NewGold: `1b872926eaa0363816d4e376fad1531435b04b9c`.
- pokeheartgold: `e97c7fc975a7447f288c42acc2e155f5a673e30f`.
- xMAP branch: `ea4460e154ddaaca5a6deebd4b5254c2a3d484ae`; `heartgoldus.xMAP` SHA-256 `f3a80da12ae51e2cc90123a2838c79c53a2ff422cc4bf1378cdf2c465cf0a611`.

The script reads committed blobs using `git show`, so subsequent working-tree edits or port commits do not change the original-state classification. It evaluates manifest conditionals like NewGold scripts/make.py, with the checked-in configuration and no additional `-D` flags. All declarations, including disabled declarations, remain in the TSV.

| Measure | Count |
|---|---:|
| Enabled hook declarations (Thumb + ARM) | 370 |
| Distinct declared hook sites, normalized to RAM | 367 |
| Strictly matched original functions | 344 |
| Strict matches already C | 302 |
| Strict matches still ASM | 42 |
| Originally unresolved declarations | 5 |
| Intended original functions after resolving the five | 349 |
| Intended targets already C | 307 |
| Intended targets still ASM | 42 |
| Semantically unidentified active hook targets | 0 |
| Source declarations with an incorrect region | 5 |

These are original functions, not features, lines of code, or port completion. Multiple hooks may intercept one function; file-offset and RAM spellings are normalized before site deduplication. Inline ASM is checked at the function definition, not inferred solely from the .c extension. The three inline-ASM functions in battle_hp_bar.c are not among these active hook targets.

| Manifest | All declarations | Enabled declarations |
|---|---:|---:|
| hooks | 391 | 369 |
| armhooks | 1 | 1 |
| bytereplacement | 309 | 158 |
| repoints | 83 | 69 |
| routinepointers | 5 | 5 |

For byte replacements and pointer patches, a containing symbol identifies location only; it does not establish semantics, dependencies, or whether the patched bytes are executable. Such rows remain `unclassified patch/data` until inspected. This inventory does not cover every ARMIPS edit, generated asset, field/battle script, or newly introduced unhooked function. Those require the feature-level migration ledger.

## Resolution of the five encounter targets

The pinned xMAP identifies all five exact names and starting addresses in overlay 2 (`OVY_2`, RAM base `0x02245B80`). `main.lsf` places src/field/encounter_check.o in that overlay; src/field/encounter_check.c defines each function. The five NewGold function bodies in src/field/encounter_check.c are identical to the vanilla bodies after whitespace normalization (asserted by the script).

| NewGold declaration | Exact symbol / address | Target source |
|---|---|---|
| hooks:647 (arm9) | EncounterSlot_WildMonSlotRoll_Land / 0x0224768C | src/field/encounter_check.c:632 |
| hooks:648 (arm9) | EncounterSlot_WildMonSlotRoll_Surfing / 0x02247720 | src/field/encounter_check.c:662 |
| hooks:649 (arm9) | EncounterSlot_WildMonSlotRoll_Fishing / 0x02247764 | src/field/encounter_check.c:678 |
| hooks:650 (arm9) | EncounterSlot_WildMonSlotRoll_RockSmash / 0x0224779C | src/field/encounter_check.c:694 |
| hooks:651 (arm9) | EncounterSlot_WildMonSlotRoll_Headbutt / 0x022477C0 | src/field/encounter_check.c:700 |

**Source anomaly:** the declarations say `arm9`, whereas the exact symbols are in overlay 2. NewGold scripts/make.py:360–368 chooses base/arm9.bin for an arm9 entry and subtracts 0x02000000; it does not infer an overlay from the address. Hence the written file offsets are 0x24768C, 0x247720, 0x247764, 0x24779C and 0x2477C0. This is evidence of an installation error in the reference source, not permission to silently reinterpret its behavior. Mapping the intended functions resolves their identity; it does not prove a produced NewGold ROM executes these five replacements. They require no gameplay change in the native port because the current replacement bodies preserve vanilla slot probabilities.

## Original ASM target backlog

Each row is an original function requiring feature-level investigation and, if it needs modification, vanilla ASM-to-C conversion before NewGold behavior is applied. This is the baseline backlog; later converted functions remain listed here as originally ASM.

| Original function | Baseline target | Example NewGold implementation |
|---|---|---|
| ov01_021FB04C | asm/overlay_01_021FB04C.s:18 | asm/field/bdhcam_routine.s:794 |
| ov01_021FB164 | asm/overlay_01_021FB04C.s:177 | asm/field/bdhcam_routine.s:751 |
| PlayerStepEvent_RepelCounterDecrement | asm/overlay_02_02248728.s:6963 | src/repel.c:13 |
| ov07_0221F81C | asm/overlay_07.s:7931 | asm/battle/battle_hooks.s:349 |
| ov07_0221F8B0 | asm/overlay_07.s:8014 | src/battle/anim.c:27 |
| ov07_0221FB7C | asm/overlay_07.s:8474 | src/battle/battle_input.c:916 |
| ov07_0223261C | asm/overlay_07.s:46259 | src/battle/battle_script_commands.c:3804 |
| ov07_02232630 | asm/overlay_07.s:46272 | src/battle/battle_script_commands.c:3838 |
| ov07_02232644 | asm/overlay_07.s:46285 | src/battle/battle_script_commands.c:3821 |
| ov07_0223476C | asm/overlay_07.s:50840 | asm/other_hook.s:115 |
| ov10_022203A4 | asm/overlay_10_trainer_ai.s:8913 | asm/battle/battle_hooks.s:375 |
| ov112_021E9480 | asm/overlay_112.s:7136 | src/field/pokewalker.c:142 |
| ov112_021F0E14 | asm/overlay_112.s:22511 | src/field/overworld_table.c:1721 |
| ov12_0223843C | asm/overlay_12_022378C0.s:817 | asm/battle/battle_hooks.s:26 |
| BattleController_EmitHealthbarSlideIn | asm/overlay_12_battle_controller.s:1261 | asm/battle/battle_hooks.s:411 |
| ov12_02258EE0 | asm/overlay_12_battle_controller_opponent.s:907 | src/battle/battle_pokemon.c:283 |
| ov12_02258EF4 | asm/overlay_12_battle_controller_opponent.s:919 | src/battle/battle_pokemon.c:334 |
| ov12_02258F08 | asm/overlay_12_battle_controller_opponent.s:931 | src/battle/battle_pokemon.c:385 |
| ov12_02259968 | asm/overlay_12_battle_controller_opponent.s:2336 | asm/battle/battle_hooks.s:562 |
| ov12_02259BA8 | asm/overlay_12_battle_controller_opponent.s:2606 | asm/battle/battle_hooks.s:550 |
| ov12_02259D48 | asm/overlay_12_battle_controller_opponent.s:2806 | asm/battle/battle_hooks.s:592 |
| ov12_0225B960 | asm/overlay_12_battle_controller_opponent.s:6395 | asm/battle/battle_hooks.s:678 |
| ov12_0225BE38 | asm/overlay_12_battle_controller_opponent.s:6983 | asm/battle/battle_hooks.s:706 |
| ov12_0225C18C | asm/overlay_12_battle_controller_opponent.s:7391 | asm/battle/battle_hooks.s:623 |
| ov12_0225C6C8 | asm/overlay_12_battle_controller_opponent.s:8032 | asm/battle/battle_hooks.s:651 |
| ov12_0225D644 | asm/overlay_12_battle_controller_opponent.s:9948 | asm/battle/battle_hooks.s:436 |
| ov12_02261464 | asm/overlay_12_battle_controller_opponent.s:17674 | src/battle/battle_pokemon.c:670 |
| ov12_022615F0 | asm/overlay_12_battle_controller_opponent.s:17878 | src/battle/battle_pokemon.c:745 |
| ov14_021E64D0 | asm/overlay_14.s:1508 | src/pokemon.c:731 |
| ov14_021E7358 | asm/overlay_14.s:3443 | asm/other_hook.s:806 |
| ov14_021F528C | asm/overlay_14.s:31497 | asm/other_hook.s:818 |
| BagApp_GetRepelStepCountAddr | asm/overlay_15.s:685 | asm/other_hook.s:611 |
| ov15_021FE914 | asm/overlay_15.s:10709 | src/bag.c:561 |
| ov15_021FF570 | asm/overlay_15.s:12266 | asm/general_hooks.s:126 |
| ov64_021E6E30 | asm/overlay_64.s:2606 | src/field/overworld_table.c:1721 |
| ov96_021E91B8 | asm/overlay_96.s:6636 | src/field/overworld_table.c:1721 |
| sub_02006A0C | asm/unk_02005D10.s:1619 | src/pokemon.c:1631 |
| sub_02075E14 | asm/unk_020755E8.s:1038 | asm/other_hook.s:598 |
| sub_020771E8 | asm/unk_020755E8.s:3373 | asm/other_hook.s:584 |
| sub_02088B40 | asm/unk_02088288.s:1037 | asm/other_hook.s:496 |
| sub_0208D178 | asm/unk_0208C3E4.s:1683 | asm/other_hook.s:481 |
| NNSi_SndArcLoadBank | lib/asm/nnsys.s:26240 | asm/arm_hooks.s:6 |

## Reproduce

Download the map from https://raw.githubusercontent.com/pret/pokeheartgold/ea4460e154ddaaca5a6deebd4b5254c2a3d484ae/heartgoldus.xMAP (the script checks the hash), then run:

```sh
python3 inventory.py /path/to/hg-engine-newgold /path/to/pokeheartgold /path/to/heartgoldus.xMAP /path/to/output
```

Only the output directory is written. Git repositories must contain the two pinned commits. Python standard library and git are the only requirements. The script asserts the baseline totals and the five equal encounter bodies; these checks verify the mapping method, not gameplay or a built ROM.
