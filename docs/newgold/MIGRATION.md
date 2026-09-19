# NewGold native migration

This branch extends `pret/pokeheartgold` with native source/data implementations
of `konefr/hg-engine-newgold`. The reference patch engine is kept outside this
repository. It is not linked, embedded, or used to build the port.

## Reference revisions

| Input | Revision |
| --- | --- |
| pokeheartgold upstream | `e97c7fc975a7447f288c42acc2e155f5a673e30f` |
| NewGold, `heartgold-modern` | `1b872926eaa0363816d4e376fad1531435b04b9c` |
| Upstream HeartGold symbol map | `ea4460e154ddaaca5a6deebd4b5254c2a3d484ae`, `heartgoldus.xMAP` |

Branch: `port/newgold-native`. The original analysis was read-only; no earlier
port commits, build, or saved migration document existed in this workspace.
The initial classification describes **original functions**, not completed work.

Use the reference's default `include/config.h` and `include/debug.h` settings.
The release generation is 9, but individual Champions settings also apply.
Do not replace these choices with a blanket assumption of Generation 9 behavior.

## Progress counters

| Metric | Count / state |
| --- | --- |
| Originally identified hook targets | 344 distinct functions |
| Original C / ASM targets | 302 / 42 |
| Originally unresolved hook declarations | 5 |
| Intended targets after evidence-based resolution | 349 distinct functions |
| Original C / ASM including resolved targets | 307 / 42 |
| Semantically unidentified hook targets remaining | 0 |
| Source hook-installation anomalies retained in the record | 5 |
| ASM targets converted to C | 0 |
| ASM targets remaining | 42 |
| Entire hook replacements made unnecessary | 0 |
| Instruction-patch behaviors represented natively | 0 |
| Features ported | 0 |
| Features checked in a running ROM | 0 |
| Complete ROM build | Pending baseline toolchain setup |
| NewGold hook / binary instruction patch / executable ASM implementations added | 0 / 0 / 0 |

These are distinct metrics. Several hooks can touch one function; one hook can
replace a function implementing many features. Porting Rage does **not** retire
the entire `ServerBeforeAct` replacement. Data relocation is not executable
patching. Field and battle script `.s` files assemble bytecode, not ARM code.

Statuses: `NOT STARTED`, `MAPPED`, `VANILLA C DECOMPILED`, `PORTED`, `BUILDS`,
`VERIFIED`. Verification must state its scope: host function test, matching
vanilla ROM, modified ROM build, or emulator/hardware scenario. A successful host
test is not a ROM verification. NewGold-modified functions intentionally differ
from the vanilla binary; matching applies to the preceding vanilla conversion.

## Dependency graph

```mermaid
flowchart TD
    BASE[Upstream baseline and toolchain] --> FIX[Isolated original-mechanic fixes]
    BASE --> REPEL[Vanilla repel routines in C]
    REPEL --> REUSE[Reusable repels and native field script]
    BASE --> ABI[Required vanilla ASM consumers converted to C]
    ABI --> IDS[Species, move, ability, item and form IDs and structures]
    IDS --> DATA[Native tables, resources and serialization]
    DATA --> TYPE[Type chart and grounding]
    TYPE --> BATTLE[Damage, criticals, accuracy and shared battle helpers]
    BATTLE --> MOVES[Move effects and native battle bytecode]
    BATTLE --> ABILITY[Ability and held-item effects]
    MOVES --> ORDER[Priority, speed and action sequencing]
    ABILITY --> ORDER
    ORDER --> WEATHER[Weather, terrain and residual ordering]
    WEATHER --> FORMS[Mega, primal and other form lifecycles]
    DATA --> STORAGE[Expanded saves, PC, bag and interfaces]
    FORMS --> PRESENT[Battle UI, animations and audio]
    STORAGE --> PRESENT
    ORDER --> AI[Trainer AI consumers]
    DATA --> TRAINERS[Trainer, encounter and species rebalancing]
    DATA --> EXP[Experience, capture and level caps]
    EXP --> PRESENT
```

This graph gives prerequisites, not permission to migrate everything in one
commit. Extend structures only for a concrete feature and inspect every C and
ASM consumer before moving fields or changing their widths.

## Feature ledger

All paths below are relative to the corresponding repository. Rows summarize
the existing analysis; the generated manifest ledger supplies individual patch
and hook declarations. A family marked MAPPED is not a claim that every behavior
inside it has been implemented or completely specified.

| Subsystem / category | NewGold implementation | Native target and original state | Current state | Dependencies and validation |
| --- | --- | --- | --- | --- |
| Rage cleanup / executable logic | `src/individual/ServerBeforeAct.c::ServerBeforeActInternal`, `SBA_RAGE`; `armips/asm/moves.s` Rage fix | `src/battle/battle_controller_player.c::BattleControllerPlayer_BeforeTurn`, C | MAPPED | No expansion; planned host and ROM regression checks; see M1 |
| Fire Fang / Shadow Force classification / executable logic | `bytereplacement`, `0225848C` | `src/battle/overlay_12_0224E4FC.c::ov12_02258440`, C | MAPPED | Shared live-battle and AI predicate; see M2 |
| Reusable repels / executable logic and script | `src/repel.c`, `hooks`, `routinepointers`, `armips/asm/repel.s`, common-script changes | `asm/overlay_02_02248728.s::PlayerStepEvent_RepelCounterDecrement`; `asm/overlay_15.s::BagApp_GetRepelStepCountAddr`, ASM; native common script and script command table | MAPPED | Validate vanilla C conversions before feature; default source selects Max, then Super, then normal Repel, not necessarily last used |
| Core battle state / executable logic | `include/battle.h`, `src/battle/battle_start.c`, `armips/asm/moves.s` | `include/battle/battle.h`, `BattleContext_New`, `BattleContext_Init`, C with ASM consumers | MAPPED | Required consumers must be C before layout changes; ABI/offset/save checks |
| Expanded move IDs, data and bytecode / data, script, executable logic | `data/Moves.c`, `src/moves.c`, `src/battle/battle_script_commands.c` | `include/constants/moves.h`, `include/constants/move_effects.h`, `src/battle/battle_command.c`, `files/poketool/waza`, `files/battledata/script`, C/data | MAPPED | IDs, table limits, script command dispatch and messages; per-effect tests |
| Damage, accuracy and criticals / executable logic | `src/individual/CalcBaseDamage.c`, `src/battle/battle_calc_damage.c`, `src/battle/other_battle_calculators.c` | `CalcMoveDamage`, `TryCriticalHit`, `BattleSystem_CheckMoveHit`, C | MAPPED | Type, item, ability and state prerequisites; exact integer rounding and RNG |
| Fairy and effectiveness / executable logic, data, resource | `src/battle/battle_pokemon.c`, `src/battle/other_battle_calculators.c`, `armips/asm/fairy.s` | `sTypeEffectiveness`, `CalculateTypeEffectiveness`, `Battler_GetType`, `ov12_02252054`, C; some AI/UI ASM | MAPPED | Native type constants and graphics; Hidden Power, plates and AI consumers |
| Expanded abilities / executable logic and data | `include/constants/ability.h`, `data/AbilityFlags.c`, `src/battle/ability.c`, `src/individual/SwitchInAbilityCheck.c`, `src/individual/MoveHitDefenderAbilityCheck.c` | `TryAbilityOnEntry`, `CheckAbilityEffectOnHit`, ability accessors, C; widened fields have ASM consumers | MAPPED | Ability ID/storage width, summary/AI consumers; per-ability behavioral cases |
| Held items and restoration / executable logic and data | `src/battle/battle_item.c`, `src/individual/CheckDefenderItemEffectOnHit.c`, `src/battle/battle_start.c` | `TryUseHeldItem`, `CheckItemEffectOnHit`, `CanTrickHeldItem`, `TryFling`, C | MAPPED | Item IDs/data and battle lifecycle; preserve restoration and AI item settings |
| Speed and priority / executable logic | `src/battle/other_battle_calculators.c`, `src/individual/ServerBeforeAct.c` | `CheckSortSpeed`, `SortMonsBySpeed`, `SortExecutionOrderBySpeed`, player controller, C | MAPPED | State and ability/item prerequisites; ties, RNG and midturn changes |
| Action and hit sequencing / executable logic | `src/individual/BattleController_BeforeMove.c`, `ServerDoPostMoveEffects.c`, `ServerHPCalc.c`, `BattleController_MoveEnd.c` | `src/battle/battle_controller_player.c`, C | MAPPED | Move/item/ability primitives; multihit, spread, faint and per-target timing |
| Weather and terrain / executable logic and script | `src/battle/weather.c`, `src/individual/ServerFieldConditionCheck.c` | Field/mon condition states in `battle_controller_player.c`, weather commands, C | MAPPED | Battle state, ordering and presentation; source TODO states remain documented |
| Mega and primal / executable logic, data, resource | `src/battle/mega.c`, `src/individual/ServerBeforeAct.c`, `src/battle/battle_pokemon.c`, `src/battle/battle_input.c` | Native form/data helpers and before-turn controller, C; presentation mixed C/ASM | MAPPED | Species/forms, items, ability/weather lifecycle, resources, UI; revert/persistence tests |
| Illusion and other forms / executable logic and resource | `src/individual/BattleFormChangeCheck.c`, `src/battle/battle_pokemon.c`, `asm/battle/battle_hooks.s` | Form checks, battle input, HP bar and encounter controllers, mixed C/ASM | MAPPED | Separate actual and displayed identity; cries, names, targeting and break/revert checks |
| Trainer AI / executable logic | `src/battle/ai.c`, `armips/asm/trainer_ai.s` | `src/battle/trainer_ai.c`, `asm/overlay_10_trainer_ai.s`, mixed C/ASM | MAPPED | C conversion of required AI routines, then new move/type/ability consumers |
| Capture and EXP / executable logic, script, resource | `src/battle/battle_script_commands.c`, `src/individual/CalculateBallShakes.c`, capture stubs | Capture/EXP commands and tasks in `src/battle/battle_command.c`, C; ball animation ASM | MAPPED | Pokédex, item modifiers, EXP lifecycle and animation; release-config comparisons |
| Battle presentation / executable logic and resource | `src/battle/anim.c`, `src/battle/battle_input.c`, ability popup command, HP speed patches | `battle_input.c`, `battle_hp_bar.c`, `battle_system.c`; `asm/overlay_07.s`, mixed C/ASM | MAPPED | Native tasks/windows/sprites, animation C conversions and generated assets |
| Pokémon and forms / executable logic and data | `src/pokemon.c`, `data` species/form tables, `armips/data` | `src/pokemon.c`, `include/pokemon_types_def.h`, native personal/learnset/evolution resources, C/data | MAPPED | IDs, forms, bounds, serialization and all ASM consumers |
| Level caps / executable logic | `src/pokemon.c::GetLevelCap` and EXP paths | Native Pokémon/EXP C and flags/variables | MAPPED | Preserve badge/story thresholds and candy/evolution configuration |
| Konefr species, teams and encounters / data | `armips/data` personal/trainer/encounter edits | Native personal, trainer and encounter JSON/data; `src/trainer_data.c::CreateNPCTrainerParty`, C | MAPPED | Expanded species/ability/move/item support before dependent team rows |
| Bug-catching contest and field events / script and data | Contest data and patched field scripts | Native contest CSV, judging C and field bytecode | MAPPED | Species IDs and native message/script resources; reward and encounter checks |
| Shops and EV presets / executable logic and script | Expanded mart scripts and overloaded egg command | `src/scrcmd_mart.c`, `src/scrcmd_party.c`, native map scripts, C/script | MAPPED | Preserve password/vendor behavior; use dedicated semantic commands, no species-ID command overloading |
| Poison, TMs/HMs, vitamins and friendship / executable logic and data | `src/field.c`, `src/pokemon.c`, item functions, config | `src/script_pokemon_util.c`, `src/party_menu_items.c`, `src/use_item_on_mon.c`, `src/pokemon.c`, C | MAPPED | Separate small behavioral milestones; source config and RNG/message checks |
| Save and PC expansion / executable logic and data | Save/storage structs and patches, 30-box configuration | `src/save.c`, `src/pokemon_storage_system.c`, C; PC UI `asm/overlay_14.s` | MAPPED | Serialization sizes, checksums, bounds, UI consumers and explicit save compatibility |
| Bag expansion / executable logic and data | Pocket expansion and repoints | `src/bag.c`, C; bag application `asm/overlay_15.s` | MAPPED | Native arrays/serialization and all UI consumers; inventory bounds |
| Summary, EV/IV viewer and Pokédex / executable logic and resource | Summary/UI changes and expansion patches | `asm/unk_02088288.s`, `asm/unk_0208C3E4.s`, mixed Pokédex C/ASM | MAPPED | C conversions, species/ability data widths, strings and display resources |
| Cries and audio expansion / executable logic and resource | Cry pseudobanks and `NNSi_SndArcLoadBank_hook` | `src/sound.c`, `asm/unk_02005D10.s`, `lib/asm/nnsys.s`, mixed C/ASM | MAPPED | Understand pseudobank contract; native bank/resource loading and boundary tests |
| Overworld/followers, camera, seasons and roamers / executable logic, data, resource | Field/follower routines, BDHCam, seasons and roamer patches | Native field/follower/camera/roamer C with overlay consumers | MAPPED | Resolve BDHCam contract, native resource tables and state consumers before implementation |
| Injected overlays/linker support / build-system support | `rom.ld`, `hooks`, `armhooks`, `bytereplacement`, `repoints`, `routinepointers`, `armips/global.s` | Native C object lists in `main.lsf`, existing overlay and data build | NOT STARTED | Retire feature by feature; no hook compatibility layer or executable blobs |

## M1 — Correct Rage cleanup

* Vanilla: leaving Rage incorrectly retains its bit and clears unrelated volatile
  flags in `BattleControllerPlayer_BeforeTurn`.
* Reference: `ServerBeforeActInternal`, `SBA_RAGE`, clears only `STATUS2_RAGE`;
  the same correction appears as an instruction patch in `armips/asm/moves.s`.
* Implementation: change the existing assignment to `&= ~STATUS2_RAGE`.
  No structures, resources, overlays, RNG calls or other turn states change.
* Planned automated check: compile the actual source function with a host
  fixture and demonstrate failure on upstream and success on the port. Cover
  every other status bit, continuing Rage, absent Rage,
  two/four battlers, inactive battlers, state transitions and four existing RNG
  draws. This does not test the Nintendo DS ABI or rendering.
* Required ROM check: use Rage, retain another volatile condition, then choose
  another move. That condition must persist and later hits must not raise Attack
  through Rage. Check the other battlers remain unaffected in doubles.
* Dependencies: baseline build only. Whole `ServerBeforeAct` hook remains pending.

## M2 — Correct Fire Fang / Shadow Force effectiveness timing

* Reference: `bytereplacement` changes effect 273 to 272 at `0225848C`.
* Target: `src/battle/overlay_12_0224E4FC.c::ov12_02258440`.
* Implement with `MOVE_EFFECT_SHADOW_FORCE`, replacing
  `MOVE_EFFECT_FLINCH_BURN_HIT` in the charge-phase predicate.
* Both live damage/type handling (`ov12_02251D28`) and AI effectiveness
  (`ov12_02252054`) call this helper; fix the shared helper once.
* Checks: Fire Fang is evaluated immediately; Shadow Force is deferred until its
  hit phase; other effects retain their existing classification. ROM checks
  include neutral/resisted Fire Fang against Wonder Guard (not only Shedinja's
  ordinarily super-effective matchup), super-effective attacks, Shadow Force
  charge/hit phases and AI evaluation.
* Dependencies: baseline build only; no Fairy/type-chart expansion required.

## Build and review policy

Use the upstream toolchain and normal build pipeline. The upstream build assumes
a checkout path without spaces; this workspace uses a separate space-free
validation copy instead of changing unrelated Makefiles. Baseline builds use
`COMPARE=1`; intentionally modified ROMs use `COMPARE=0`. Record both HeartGold
and SoulSilver results, introduced warnings, and any unexecuted ROM scenarios.

Run `git diff --check`, focused tests, and the repository's C formatting check.
Do not claim a whole-file format failure predating the port is introduced by a
one-line edit; preserve unrelated formatting. No PR is authorized.

Credit: the behavior reference is hg-engine/NewGold and its contributors; see
`UPSTREAM_CREDITS.md`. Decompiled vanilla code and architecture are from pret.
