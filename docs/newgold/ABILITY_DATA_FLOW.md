# Ability data-flow prerequisites

Source: `hg-engine-newgold-reference` at `1b872926eaa0363816d4e376fad1531435b04b9c`. Original target: pret `e97c7fc975a7447f288c42acc2e155f5a673e30f`. Function ranges in the TSV use the pinned xMAP already used by the migration inventory. Line numbers and ranges refer to the pinned original sources; current conversion milestones are recorded in the TSV and MIGRATION.md.

`ability-consumers.tsv` contains 67 evidence rows. This is a bounded consumer/dependency census, **not proof that every ROM path is now closed**. Positive width boundaries are separated from width-safe ASM and from functions exposed only if unrelated offsets move.

## Converted byte boundaries and remaining contracts

M10 converted the AI pair `ov10_0221D0A8` and `ov10_0221D188` to matching vanilla C in `src/battle/trainer_ai_ability.c`; both complete HG/SS ROMs remain identical to M9. Both read the revealed-ability cache and raw battle ability. Change width only after an ABI decision. M11 also converted `ov10_0221F62C` and `ov10_0221FE8C` to matching C, preserving complete ROMs. M12 also converted the two overlay-83 record constructors to matching C. M13 converted both renderers: the opponent matches exactly; the player differs only by a proven independent instruction reorder. M14 converted all three Frontier record producers/importer to matching C, preserving both complete ROMs. M15 converted both Pokéwalker boundaries: the receiver matches exactly; the Trainer House exporter has a proven private stack-slot exchange. Next define the native ability storage/setter contract and close the external-record paths. The AI cache already has native C writer/reset functions, `BattlerSetAbility` and `ov12_0225859C`.

Thirteen additional original ASM byte boundaries are established; all are now C (eleven matching, two with compiled-instruction equivalence proofs):

- AI raw/cache readers: `ov10_0221D0A8`, `ov10_0221D188` (M10 matching C), `ov10_0221F62C` (M11 matching C).
- AI accessor narrowing: `ov10_0221FE8C` (M11 matching C; original cast retained). It truncates a party ability before comparisons with 10, 11 or 18; IDs266,267,274 can alias those values. This is separate from layout relocation.
- Frontier record producers/importer: `ov80_02229F6C`, `ov80_02236734`, `ov80_0222A140` (M14 matching C; original 56-byte record and ability byte retained).
- Pokéwalker-related record producer/setter: `ov112_021F33D8` (M15 NONMATCHING, instruction-equivalent C), `ov112_021EEAF0` (M15 matching C). Trainer House/gift ability fields remain bytes; the external protocol is unchanged.
- Two overlay83 UI producer/renderer pairs: `ov83_02241E18`/`ov83_022421E0`, `ov83_02245D48`/`ov83_02246114`. M12 converted both constructors to matching C, retaining their original byte fields. The menus use message banks 31 (player Pokémon/item rental) and 33 (opponent move information using CP). Both renderers are now C (M13); ability fields are still u8.

These are additional dependency targets, **not a revision of the original hook-only42ASM census**. Some have no explicit source ability patch; they expose shortcomings to resolve before claiming end-to-end native IDs0–319. Do not automatically reproduce source truncation or silently alter protocol semantics.

PC producer/renderer are already the M6 matching-C prerequisite. The party-heal sender is matching C in M7; summary producer/display are the M8 prerequisite. Those are not part of the thirteen above.

## AI cache: source inconsistency and native ABI constraint

Native `TrainerAIData.abilities` is u8[4], relative0x3C / BattleContext+0x390. Following heldItems start at relative0x40; moveData starts at relative0x8A / context0x3DE. Source `BattleAIWorkTable` still declares `u8 ai_tokusyu_no[4]` at0x3C, but `armips/asm/abilities.s` replaces the writer at02248648 with a halfword store to context0x3E0 + 2*battler. That storage lies inside the old move-table area; source `armips/asm/moves.s` moves the move table to0x317E. Therefore its relocation depends on move expansion.

Both AI readers above still load original cache0x390 and original BattleMon ability0x2D67. Native reset `ov12_0225859C` clears original cache0x390. No replacement/reset patch was found. Default reachability was checked: native `ov10_0221C278` dispatches through `ov10_0222B0B4`, which retains both ability handlers. Source `src/battle/ai.c` replaces only overlay12 AITypeCalc; enabled overlay10 manifest hooks contain only the binding switch restriction. DEBUG_BATTLE_SCENARIOS entry replacements are disabled by default. Relevant ARMIPS AI edits change move-data offsets, not these cache loads.

This establishes a **static producer/consumer inconsistency in the default source**, not an emulator-verified gameplay defect. It should not be copied as architecture. Prefer one typed native cache with coherent write/read/reset. Decide how to preserve the native BattleContext ABI first; simply changing u8[4] to u16[4] shifts following AI fields and later BattleContext members consumed by extensive ASM. Compiler-generated offsetof assertions have **not** been run in this census; source comments and original instructions support the listed offsets.

## Patch-only targets now identified

- `abilities.s`02054248 is inside **GiveMon**, already C upstream; its original body is superseded by the source's full GiveMon hook at020541DC. It does not establish an independent ASM blocker. Source replacement still declares a u8 ability and passes its address to the u16-reading edited setter: record as a pointer-width inconsistency requiring a native safe interface.
- 022585CC..02258654 belongs to **ov12_022585B8**, already C upstream: raw Forecast/Trace/Multitype candidate checks.
- 022481BC/022481CC belongs to **ov12_0224819C**, already C upstream: message ability reveal -> AI cache writer.
- Summary and party-heal addresses are covered by the separately active matching-C conversions.

## Storage/serialization decisions required before enabling IDs above255

1. **Saved Pokémon:** source stores the ninth ability bit in EXP bit31 and uses only low21 EXP bits. Implement typed native masks/accessors while preserving encryption/checksum, every direct EXP read/write, and save interpretation. `GetBoxMonDataInternal` also directly compares block ability for Multitype. Source AddBoxMonData(ABILITY) assigns rather than adds; native currently rejects/no-ops that case. Define the intended contract explicitly.
2. **Setter pointer ABI:** current native SetBoxMonDataInternal reads one byte; source edited setter reads two. Audit and convert actual byte-backed callers, not merely prototypes: GiveMon, TrainerHouse importer, Frontier importer, Pokéwalker setter. Existing u32/int locals used by CreateBoxMon/form assignment are already large enough. Battle-copy packet at+0x24 needs producer-width verification before changing this setter ABI.
3. **Personal resources:** native abilities[2] are bytes at0x16/17. Source halfwords at0x16/1A use a different layout. Native `personal.json.txt` emits the native struct and sizeof; preserve native generation and validate every member offset rather than importing source binary records.
4. **Battle record:** source places halfword ability at0x7A while retaining stride0xC0 and old0x27 as dummy. Prove padding availability in native layout; do not insert a halfword at0x27 and shift unrelated fields. C SetBattlerVar must read the selected16-bit payload, not data8.
5. **PC/summary/UI records:** prefer per-record fields and stable other offsets. Native PC's28-byte record, summary form/ability swap, and overlay83 records each require explicit allocation/offset assertions. Do not recreate executable scratch storage. Full other-field offset-consumer lists are not completed here, so in-place growth is not authorized by this census.
6. **Compact serialization:** `sub_02072A98`/`sub_02072D64` copy raw EXP and byte ability into a0x70 record. Their ASM callers `sub_020306DC`/`sub_02030724` advance0x70 but do not read ability; classify them as size/offset consumers only. Preserve that ABI or convert those loops deliberately.
7. **External records:** Frontier, TrainerHouse, Pokéwalker and link/trade compatibility need an explicit policy. A byte wire/save field cannot be enlarged just because a runtime field grows. Native names/descriptions/constants must be expanded before displaying any new ID. Hidden-ability assignment/form tables and per-ability mechanics are later features, not consequences of width alone.

## Checks that avoid unnecessary work

The party-heal packet can remain byte-sized for the currently traced predicate: receiver `ov12_02259358` compares carried byte only with Mold Breaker104, and noID0–319 collides with104 after truncation (first360). Its party Soundproof43 check uses full GetMonData output. Widening the sender's BattleMon load suffices for this currently established behavior. Do not report a packet bug or widen the protocol without new evidence.

Reviewed ASM paths already holding full ability results include ov08_0221D184/ov08_0221E120 (halfword UI record), ov83_0223FD4C (direct name formatting), AGB_GetBoxMonAbility/MigrateBoxMon (word payload), and the AI/party accessor-only paths listed in the TSV. These are not mandatory decompilation tasks solely because IDs become wider.

Suggested bounded validation after each conversion: matching original routine/wholeROM first; then actual-C host checks for IDs0,123,255,256,319 and every battler slot through cache reveal/reset/guess; explicit alias cases266/267/274; saved ability+EXP roundtrip/checksum and form reassignment; byte-backed setter input under sanitizer; personal binary member size/offset checks; UI name/description bounds. ROM boot is not ability gameplay validation. No new tests or runtime behavior checks were performed by this census.
