# Ability data-flow prerequisites

Source: `hg-engine-newgold-reference` at `41a28e2255b2805378163c7f4d6c1d87541174d1`. The three commits after `1b872926` change only `data/Trainers.c`, `data/Encounters.c`, `data/Species.c`, `data/learnsets/learnsets.json` and one `armips/include/flags.s` constant; no ability source, manifest or text bank in this census is affected. Original target: pret `e97c7fc975a7447f288c42acc2e155f5a673e30f`. Function ranges in the TSV use the pinned xMAP already used by the migration inventory. Line numbers and ranges refer to the pinned original sources; current conversion milestones are recorded in the TSV and MIGRATION.md.

`ability-consumers.tsv` contains 68 evidence rows. This is a bounded consumer/dependency census, **not proof that every ROM path is now closed**. Positive width boundaries are separated from width-safe ASM and from functions exposed only if unrelated offsets move.

## Converted byte boundaries and remaining contracts

M10 converted the AI pair `ov10_0221D0A8` and `ov10_0221D188` to matching vanilla C in `src/battle/trainer_ai_ability.c`; both complete HG/SS ROMs remain identical to M9. Both read the revealed-ability cache and raw battle ability. Change width only after an ABI decision. M11 also converted `ov10_0221F62C` and `ov10_0221FE8C` to matching C, preserving complete ROMs. M12 also converted the two overlay-83 record constructors to matching C. M13 converted both renderers: the opponent matches exactly; the player differs only by a proven independent instruction reorder. M14 converted all three Frontier record producers/importer to matching C, preserving both complete ROMs. M15 converted both Pokéwalker boundaries: the receiver matches exactly; the Trainer House exporter has a proven private stack-slot exchange. M16 implements saved storage and the setter contract; battle/UI and external export compatibility remain pending. The AI cache already has native C writer/reset functions, `BattlerSetAbility` and `ov12_0225859C`.

Fourteen additional original ASM byte boundaries are established: all now converted to C (twelve matching, two with compiled-instruction equivalence proofs before modifications):

- AI raw/cache readers: `ov10_0221D0A8`, `ov10_0221D188` (M10 matching C), `ov10_0221F62C` (M11 matching C).
- AI accessor narrowing: `ov10_0221FE8C` (M11 matching C; original cast retained). It truncates a party ability before comparisons with 10, 11 or 18; IDs266,267,274 can alias those values. This is separate from layout relocation.
- Frontier record producers/importer: `ov80_02229F6C`, `ov80_02236734`, `ov80_0222A140` (M14 matching C; original 56-byte record and ability byte retained).
- Pokéwalker-related record producer/setter: `ov112_021F33D8` (M15 NONMATCHING, instruction-equivalent C), `ov112_021EEAF0` (M15 matching C). Trainer House/gift ability fields remain bytes; the external protocol is unchanged.
- Two overlay83 UI producer/renderer pairs: `ov83_02241E18`/`ov83_022421E0`, `ov83_02245D48`/`ov83_02246114`. M12 converted both constructors to matching C, retaining their original byte fields. The menus use message banks 31 (player Pokémon/item rental) and 33 (opponent move information using CP). Both renderers are now C (M13); ability fields are still u8.

- Battle-copy packet producer: `BattleController_EmitBattleMonToPartyMonCopy` is matching C in M17. It still reads the raw BattleMon ability byte; its destination at packet+0x24 is a full u32, so the setter input is safe. Both complete ROMs equal M16.

These are additional dependency targets, **not a revision of the original hook-only42ASM census**. Some have no explicit source ability patch; they expose shortcomings to resolve before claiming end-to-end native IDs0–319. Do not automatically reproduce source truncation or silently alter protocol semantics.

PC producer/renderer are already the M6 matching-C prerequisite. The party-heal sender is matching C in M7; summary producer/display are the M8 prerequisite. Those are not part of the fourteen above.

## AI cache: source inconsistency and native ABI resolution

Before M18, native `TrainerAIData.abilities` was u8[4], relative0x3C / BattleContext+0x390. Following heldItems start at relative0x40; moveData starts at relative0x8A / context0x3DE. Source `BattleAIWorkTable` still declares `u8 ai_tokusyu_no[4]` at 0x3C, but `armips/asm/abilities.s` replaces the writer at02248648 with a halfword store to context0x3E0 + 2*battler. That storage lies inside the old move-table area; source `armips/asm/moves.s` moves the move table to 0x317E. Therefore its relocation depends on move expansion.

The original ASM versions of both readers load cache 0x390 and BattleMon ability 0x2D67. The original native reset `ov12_0225859C` clears cache 0x390. No replacement/reset patch was found. Default reachability was checked: native `ov10_0221C278` dispatches through `ov10_0222B0B4`, which retains both ability handlers. Source `src/battle/ai.c` replaces only overlay 12 AITypeCalc; enabled overlay10 manifest hooks contain only the binding switch restriction. DEBUG_BATTLE_SCENARIOS entry replacements are disabled by default. Relevant ARMIPS AI edits change move-data offsets, not these cache loads.

This establishes a **static producer/consumer inconsistency in the default source**, not an emulator-verified gameplay defect. It should not be copied as architecture. Prefer one typed native cache with coherent write/read/reset. Decide how to preserve the native BattleContext ABI first; simply changing u8[4] to u16[4] shifts following AI fields and later BattleContext members consumed by extensive ASM. M18 target-compiler assertions now verify the unchanged AI held-item/move-data offsets, BattleMon stride/neighbor fields and complete BattleContext prefix. A u16[4] cache is appended to BattleContext at 0x3158; allocation grows from 0x3158 to 0x3160 using the existing sizeof-based allocator. AI initialization, revelation, inference/query and switch reset all use this field. The old bytes remain reserved. This avoids moving unrelated ASM consumers and does not reproduce the source producer/consumer inconsistency.

## Patch-only targets now identified

- `abilities.s`02054248 is inside **GiveMon**, already C upstream; its original body is superseded by the source's full GiveMon hook at020541DC. It does not establish an independent ASM blocker. Source replacement still declares a u8 ability and passes its address to the u16-reading edited setter: record as a pointer-width inconsistency requiring a native safe interface.
- 022585CC..02258654 belongs to **ov12_022585B8**, already C upstream: raw Forecast/Trace/Multitype candidate checks.
- 022481BC/022481CC belongs to **ov12_0224819C**, already C upstream: message ability reveal -> AI cache writer.
- Summary and party-heal addresses are covered by the separately active matching-C conversions.

## Storage/serialization decisions required before enabling IDs above255

1. **Saved Pokémon — M16 implemented:** native Block A retains 32 bytes, uses EXP low21 bits and bit31 for abilityMSB, and preserves bits21–30. Get/Set/Add follow the reference, including ability assignment in Add. Multitype compares the complete ID. Actual native encryption, checksum, locking and compact serialization pass 32,768 host cases against the pinned reference edited cases; EXP curves/personal data are controlled test inputs.
2. **Setter pointer ABI — M16 implemented:** native ability setters now read u16. GiveMon has a u16 parameter; Frontier, Trainer House and Pokéwalker importers widen their protocol bytes into u16 locals. Existing u32/int assignment locals and the GBA migration word temporary are large enough. Battle-copy sender stores a complete word at SP+0x34, packet+0x24 (packet starts SP+0x10, length0x2C); receiver ov12_022591F4 passes this aligned field to SetMonData. Dynamic PC wrapper callers set items/markings, not abilities; traced follower/Frontier dynamic setters use Shiny Leaves/held-item attributes.
3. **Personal resources:** native abilities[2] are bytes at 0x16/17. Source halfwords at 0x16/1A use a different layout. Native `personal.json.txt` emits the native struct and sizeof; preserve native generation and validate every member offset rather than importing source binary records.
4. **Battle record — M18 implemented:** ability is u16 in the previously unused halfword at 0x7A; the0xC0 stride and all other members stay fixed, with old0x27 reserved. Native SetBattlerVar reads data16 and GetBattlerAbility returns u16. The private damage record and end-of-battle ability local are widened; the AI switch helper no longer narrows party abilities. Known raw byte consumers are now C. The sixteen remaining ASM GetBattlerAbility callsites preserve full registers/word temporaries, or compare directly; four apparent relative0x27 hits actually pass move-PP attributes to GetBattlerVar. No old2D67/new2DBA raw literal or BattleMon unk76 access remains in the reviewed sources. These are bounded checks, not a claim of complete game-wide consumer closure.
5. **PC/summary/UI records:** prefer per-record fields and stable other offsets. Native PC's28-byte record, summary form/ability swap, and overlay83 records each require explicit allocation/offset assertions. Do not recreate executable scratch storage. Full other-field offset-consumer lists are not completed here, so in-place growth is not authorized by this census.
6. **Compact serialization — M16 implemented:** `sub_02072A98`/`sub_02072D64` copy expAndAbility as the raw word and retain the separate ability byte in the0x70 record. Roundtrips preserve the ninth bit and reserved bits. Their ASM callers `sub_020306DC`/`sub_02030724` advance0x70 and do not read ability; their ABI is unchanged.
7. **External records:** Frontier, TrainerHouse, Pokéwalker and link/trade compatibility need an explicit policy. A byte wire/save field cannot be enlarged just because a runtime field grows. Native names/descriptions/constants must be expanded before displaying any new ID. Hidden-ability assignment/form tables and per-ability mechanics are later features, not consequences of width alone.

## Checks that avoid unnecessary work

The party-heal packet can remain byte-sized for the currently traced predicate: receiver `ov12_02259358` compares carried byte only with Mold Breaker104, and noID0–319 collides with104 after truncation (first360). Its party Soundproof43 check uses full GetMonData output. Widening the sender's BattleMon load suffices for this currently established behavior. Do not report a packet bug or widen the protocol without new evidence.

Reviewed ASM paths already holding full ability results include ov08_0221D184/ov08_0221E120 (halfword UI record), ov83_0223FD4C (direct name formatting), AGB_GetBoxMonAbility/MigrateBoxMon (word payload), and the AI/party accessor-only paths listed in the TSV. These are not mandatory decompilation tasks solely because IDs become wider.

Suggested bounded validation after each conversion: matching original routine/wholeROM first; then actual-C host checks for IDs0,123,255,256,319 and every battler slot through cache reveal/reset/guess; explicit alias cases266/267/274; saved ability+EXP roundtrip/checksum and form reassignment; byte-backed setter input under sanitizer; personal binary member size/offset checks; UI name/description bounds. ROM boot is not ability gameplay validation. The initial census performed no behavior tests; M16 adds the scoped saved-storage check. End-to-end ability gameplay remains unverified.

## M18 validation scope

The new host check uses actual BattleMon/TrainerAIData/BattleContext declarations
and actual native accessors, cache initialization/revelation/reset, both AI
handlers, packet producers, absorbing-switch selection and reward eligibility.
All 512 stored IDs across four battlers pass (2,048 cases), with suppression,
Gravity/Ingrain, known/guessed abilities, packet flags and unrelated cache slots.
IDs266/267/274 cannot alias10/11/18; all 512 end-of-battle reward eligibility cases
pass. RNG, party/personal data, script operands and reward tables are controlled.
The private damage record's width is compiled/asserted; complete damage formulas
and new ability effects are not behaviorally verified by this test. HG/SS builds,
all 14 checks and boot/menu smoke pass. UI/personal/field/export paths remain
separate prerequisites before assigning higher IDs throughout the game.
