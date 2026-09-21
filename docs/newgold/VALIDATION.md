# Native NewGold validation

Validation date: 2026-09-19. Input revisions are pinned in `MIGRATION.md`.
This report distinguishes source tests, a matching vanilla ROM, a modified ROM
build, and emulator/hardware testing. The latter is not implied by compilation.

## Final fidelity comparison with the original NewGold build

The user clarified that the required result is a faithful native C port of the
hack, not a byte-identical final ROM. The compiled original remains the
behavior/data reference. The final fidelity gate is **PENDING**. An actual intermediate comparison at M16 is now complete: both
ROMs build, but they are not byte-identical. All 960 decoded ability texts agree.
See [REFERENCE_BUILD.md](REFERENCE_BUILD.md) for hashes, differences and scope.
Build the currently pinned NewGold revision in an isolated
copy, preserving its original toolchain/configuration and recording the exact
base-ROM hash, dependencies and any required external inputs. Keep the reference
checkout unchanged. Use comparable game/region/revision inputs for both builds.
The original Makefile explicitly accepts US HeartGold (`IPKE`), reads `rom.nds`
and produces `test.nds`; it does not provide an equivalent SoulSilver target.
The matching upstream HG baseline already built here is a reproducible candidate
input, subject to checking the reference's complete build requirements.

Record build hashes for provenance. The completed intermediate byte comparison
is diagnostic, not an acceptance criterion for the whole hack. A source-level port can have a different code/layout binary
while implementing the same behavior; do not call that byte-identical, and do
not add hooks or address constraints merely to force equality. If the binaries
differ, separately compare decoded game data/resources and representative
gameplay behavior against that compiled reference. Explain every remaining
unverified area; host-function tests or matching vanilla prerequisites alone
cannot satisfy this final comparison. The archived M16 comparison does not
close the final gate or establish gameplay parity for the unfinished port. It was
built at the earlier pin `1b872926`; the pin advanced to `41a28e22` on
2026-09-20 with data-only changes, so the final gate needs a fresh reference
build rather than reuse of that archive.

## Toolchain

The build uses the tools and archive URLs specified by upstream
`.github/workflows/build.yml`, with no alternative compiler or ROM patch layer:

| Upstream CI asset | SHA-256 |
| --- | --- |
| `https://github.com/pret/pokeheartgold/raw/workflows/assets/mwccarm.zip` | `dc386e37b2176e960954a733de928337d9b7e7620b9e94228008c31774339ace` |
| `https://github.com/pret/pokeheartgold/raw/workflows/assets/NitroSDK-3_2-060901.7z` | `0ee935e34237cb1954e657083cd80a31ec9de1aeddd9468cceef684cac75b491` |

The normal project MWCC versions/flags remain unchanged. Wine and GNU ARM
binutils were extracted from official Arch Linux packages into a temporary local
runtime; no system packages or tracked build rules were changed. All 11 native
project helper tools built successfully. The exact CI formatter, clang-format
19.1.7, is installed in a temporary virtual environment.

The workspace path contains a space, which the upstream Makefiles do not handle.
Validation therefore uses a separate copy without one. Through M18 that copy and
its toolchain lived under `/tmp`; a reboot before M19 removed both, so they were
rebuilt under `/home/paolo/hgss-build`, which survives restarts. The rebuilt copy
is a `git clone` of the port branch, so every tracked blob matches by
construction, including `charmap.txt`'s required CRLF working-tree conversion.
Subsequent builds copy only the milestone's changed files, leaving unrelated
working changes out. The per-milestone logs, ROMs and maps under
`build/milestones/` are unaffected by the loss and remain the evidence chain; the
older `/tmp` baseline and vanilla-conversion logs referenced below are gone.

The toolchain was rebuilt from the same upstream CI assets, both re-checked
against the SHA-256 values above, plus wine, pugixml and `arm-none-eabi-binutils`
extracted from this host's own Arch package mirror into
`/home/paolo/hgss-build/deps/root` without installing system packages. The
extracted ARM binutils is again 2.47. On this host the build environment is:

```sh
source /home/paolo/hgss-build/env.sh
cd /home/paolo/hgss-build/pokeheartgold-validation
make -j4 COMPARE=1
make -j4 GAME_VERSION=SOULSILVER COMPARE=1
```

`env.sh` sets `PATH`, `PKG_CONFIG_PATH`, `LD_LIBRARY_PATH`, `LIBRARY_PATH`,
`CPATH` and the wine variables for that extracted runtime. For intentionally
modified ROMs use `COMPARE=0`. On another machine, use `INSTALL.md` and a
checkout without spaces; the paths above are local validation paths, not new
project dependencies.

## Results

| Revision / change | HeartGold | SoulSilver | Behavioral evidence |
| --- | --- | --- | --- |
| Unmodified upstream | PASS, exact retail SHA-1 | PASS, exact retail SHA-1 | Both ROMs byte-identical to retail |
| Vanilla repel ASM-to-C conversions | PASS, exact retail SHA-1 | PASS, exact retail SHA-1 | Both converted functions are MATCHING C |
| Rage cleanup | PASS | PASS | Actual-C regression passes, upstream fails; no new compiler/assembler warnings |
| Fire Fang / Shadow Force classification | PASS | PASS | Actual-C helper and live/AI predicates pass; upstream fails; no new compiler/assembler warnings |
| Reusable repels | PASS | PASS | Actual-C/reference tests and compiled command/script/message checks pass; runtime UI pending |
| Overworld poison disabled | PASS | PASS | Actual-C accessor/counter checks match the reference zero-mask semantics; compiled function has only expected read/validation calls |
| Existing friendship evolution threshold | PASS | PASS | Complete native function/RTC tests, reference branches and unchanged-method comparisons pass; exactly three ARM9 comparison immediates change |
| Vanilla PC constructor/ability renderer in C | PASS, exact M5 SHA-1 | PASS, exact M5 SHA-1 | Both functions and complete ROMs are MATCHING; no NewGold ability changes enabled |
| Vanilla party-heal notification in C | PASS, exact M6 SHA-1 | PASS, exact M6 SHA-1 | Complete ROMs are MATCHING; four-byte packet and receiver contract preserved |
| Vanilla summary loader/renderer in C | PASS, exact M7 SHA-1 | PASS, exact M7 SHA-1 | Complete ROMs are MATCHING; summary layout and behavior unchanged |
| Ability names/descriptions | PASS | PASS | Only three message members change; all 960 decoded strings equal pinned NewGold |
| Vanilla AI ability inference/query in C | PASS, exact M9 SHA-1 | PASS, exact M9 SHA-1 | Complete ROMs and overlay 10 are MATCHING; original AI behavior retained |
| Vanilla AI ability switching in C | PASS, exact M10 SHA-1 | PASS, exact M10 SHA-1 | Complete ROMs and overlay 10 are MATCHING; existing RNG/accessor/cast behavior retained |
| Vanilla Frontier summary record constructors in C | PASS, exact M11 SHA-1 | PASS, exact M11 SHA-1 | Complete ROMs and overlay 83 are MATCHING; original record layout and accessor order retained |
| Vanilla Frontier summary renderers in C | PASS | PASS | Opponent MATCHING; player differs only by proven independent instruction reordering; boot/menu smoke passes |

Baseline HeartGold SHA-1: `4fcded0e2713dc03929845de631d0932ea2b5a37`.
Baseline SoulSilver SHA-1: `f8dc38ea20c17541a43b58c5e6d18c1732c7e582`.
Baseline logs were `/tmp/hgss-build-deps/baseline-heartgold.log` and
`/tmp/hgss-build-deps/baseline-soulsilver.log`, removed with the tmpfs before M19;
the recorded retail SHA-1 results above stand, but that pair is no longer on disk.
The linker already warns about unset `MWLibraries` and `MWLibraryFiles` in the
successful baseline; Wine emits Mesa display warnings. These are environmental
baseline warnings, not warnings introduced by ported C.

Run the current focused checks with:

```sh
python3 -m unittest discover -s tests/newgold -t tests/newgold -v
git diff --check
```

The tests compile actual source functions with small host fixtures and the
project's real constants. They do not emulate the full DS memory layout. The
Wonder Guard check also compiles the pinned vanilla helper and demonstrates that
the original fails the regression while preserving unrelated effect behavior.

ROM scenarios still to execute are listed with their features in `MIGRATION.md`.

Vanilla conversion logs were `/tmp/hgss-build-deps/vanilla-decomp-heartgold.log`
and `/tmp/hgss-build-deps/vanilla-decomp-soulsilver.log`, removed with the tmpfs
before M19. They recorded no new compiler warnings; the archived per-milestone
logs under `build/milestones/` remain available.

## M1 — Rage build outputs

Artifacts and module audit: `build/milestones/01-rage/verification.json`.

| ROM | SHA-1 |
| --- | --- |
| HeartGold with Rage fix | `261b0df5ff7bf90c4e0adfe0e77a799410ebeb1e` |
| SoulSilver with Rage fix | `f0bb25badb9a3f1089caa36b139b8d4f1b7ea9b6` |

Both complete builds passed without compiler/assembler warnings. The corrected
function grows by four bytes, and the native linker adjusts downstream symbols
and callers. Changed overlays are 8, 10 and 12; an ARM9 call relocation changes
accordingly. No NitroFS/NARC data or ARM7 bytes change. Exact clang-format 19
checks pass for both modified battle files, as does `git diff --check`.

## M2 — Wonder Guard classification build outputs

Artifacts and module audit: `build/milestones/02-wonder-guard/verification.json`.

| ROM | SHA-1 |
| --- | --- |
| HeartGold through M2 | `b21ffd80674a16695b5e4b99fbcdb880baf544ec` |
| SoulSilver through M2 | `9dfca73b095c64ddcafffe4a2170bddfd4f731c3` |

Both full builds pass without compiler/assembler warnings. Only overlay 12
changes relative to M1; ARM9, ARM7, other overlays and every non-overlay resource
are identical. The host regression exercises 1,108 helper cases, 17,728 AI
predicates and 35,456 live-battle predicates; its negative check fails on the
original Fire Fang/Shadow Force classification. These are function-boundary
checks, not complete emulator battles.

## M3 — Reusable repel build outputs

Artifacts and binary audit: `build/milestones/03-reusable-repels/verification.json`.

| ROM | SHA-1 |
| --- | --- |
| HeartGold through M3 | `696f6cd9a3e6d459fe1db71a4038ca719d59f6ac` |
| SoulSilver through M3 | `197cebdcbc60448e4dd7c104d7d955799797ebba` |

Both full builds pass without compiler/assembler warnings. Binary checks confirm
854 command-table entries and entry 853 pointing to `ScrCmd_UseNextRepel | 1`.
Common-script entry 72 resolves to valid compiled code containing one use command
with `VAR_SPECIAL_RESULT`; the common bank has 73 entries. Compiled message bank
40 contains 119 rows, with generated message symbols 117 and 118.

Only the following named NitroFS resources change from M2:

* `a/0/1/2`: only member 3 changes; the script NARC retains 965 members.
* `a/0/2/7`: only member 40 changes; the message NARC retains 829 members.

Other non-overlay files and ARM7 are identical. Native ARM9/field symbol movement
causes relocation updates in 118 overlays; these are normal linker-generated
changes, not changes to 118 gameplay subsystems or imported binary patches.

All six current focused tests pass, including pinned NewGold comparisons.
clang-format 19 passes for all modified C/header files, and whitespace checks
pass. NewGold input/audio/display behavior still requires the listed emulator
or hardware scenarios; no interactive ROM test has been claimed.

## M4 — Overworld poison build outputs

Artifacts, compiled-function disassembly and audit:
`build/milestones/04-overworld-poison/verification.json`.

| ROM | SHA-1 |
| --- | --- |
| HeartGold through M4 | `90c6bd0e58025a389ea5e0c9a3715572f3d8fdd9` |
| SoulSilver through M4 | `04a81be999b967adfd5eddc4094b488a0ee3e12a` |

Both full builds pass without compiler/assembler warnings. `ApplyPoisonStep`
compiles to 54 bytes, with only `Party_GetCount`, `Party_GetMonByIndex`,
`MonNotFaintedOrEgg` and `GetMonData` as direct callees, followed by a zero return.
All named non-overlay NitroFS resources and ARM7 bytes are identical to M3.
ARM9 symbol relocation updates change 118 overlays, without resource changes.

Seven focused tests pass through M4. The new check covers 10,240 single-Pokémon
cases, mixed parties, retained checksum-failure effects and all 65,536 step
counter values. The pinned reference's changed mask is applied only to the
test oracle, never to a built ROM. Actual field scenes and battle poison still
require the emulator/hardware checks in the migration ledger. Clang-format 19
and whitespace checks pass for the scoped change.

## M5 — Friendship evolution build outputs

Artifacts, function disassembly and audit:
`build/milestones/05-friendship-evolution/verification.json`.

| ROM | SHA-1 |
| --- | --- |
| HeartGold through M5 | `c094900f501bd22a662b4d2a69580141fe5ebd36` |
| SoulSilver through M5 | `b41899eb0b12d741bd4bf915be8b6b2e88d06d6d` |

Both complete builds pass without compiler/assembler warnings. Each uncompressed
ARM9 differs from M4 in exactly three bytes, 220 to 160, at the comparison
immediates in `GetMonEvolution`. Its size remains 1,032 bytes. Every one of the
513 NitroFS files, including overlays, and ARM7 remain byte-identical to M4.
These addresses are inspection evidence only; no build step patches bytes.

All ten focused tests pass, including the three new friendship tests and pinned
NewGold comparisons. Native RTC classification, all friendship values/hours,
guards and 72,576 unrelated-method comparisons pass; vanilla fails the 160
boundary. Clang-format 19 and whitespace checks pass. Runtime evolution/party
menu scenarios remain pending, as do the separate expanded evolution methods
and Fairy/Sylveon data required for full NewGold evolution behavior.

## Runtime smoke — Both M5 ROMs

Evidence, runner source, exact commands, core provenance and framebuffer captures
are archived in `build/milestones/05-friendship-evolution/runtime-smoke`.
The source working directory was `/tmp/hgss-runtime-smoke`; the archive preserves
the original command/provenance paths. See its `README.md` and both per-game
`result.json` files for reproduction and screenshot hashes.

The already installed melonDS libretro core (`0.9.3 66b5d263`, package
`libretro-melonds 20260719.185838.g66b5d2634cd0-1.1`) ran each ROM for 1,436
frames and exited successfully. Software rendering, interpreter mode, built-in
FreeBIOS and generated firmware used isolated system/save directories. No
external BIOS, existing save or user emulator configuration was used or changed.

Visual inspection confirms the correct HeartGold/SoulSilver title at frame 728,
the new-game information menu at frame 1,216 and tutorial text reached through
emulated D-pad/A input at frame 1,436. Both 256×384 framebuffers and audio
callbacks advanced; audio was not listened to. ROM hashes remained unchanged.

This is **boot/rendering/menu-input verification only**. No ported battle,
repel, poison or friendship feature was exercised in gameplay; that counter
remains zero. No save/reload, field movement or hardware test is implied.

## M6 — Matching PC display C prerequisites

Artifacts, maps, overlay binaries and audit:
`build/milestones/06-pc-ability-cvalidation/verification.json`.

Both complete ROMs are byte-for-byte identical to M5, retaining its SHA-1 and
SHA-256 values. The entire 80,512-byte overlay 14 is identical as well.
`ov14_021E7358` and `ov14_021F528C` are MATCHING C; their original field widths,
call sequence and behavior are preserved. No NONMATCHING implementation or
assembly wrapper is used. The constructor's C symbol omits two unchanged
alignment bytes from its reported size; actual ROM bytes do not differ.

Both full builds pass without compiler/assembler warnings. Native size/offset
assertions, all ten existing behavioral tests, clang-format 19 and whitespace
checks pass. Assembly partition review confirms that only the two converted
functions were removed; all other assembly/data lines are preserved.
The M5 emulator boot/menu evidence covers the exact same binaries. This does
not enable or verify the pending NewGold ability-width changes.

## M7 — Matching party-heal notification prerequisite

Artifacts, maps, overlay binaries, disassembly and protocol audit:
`build/milestones/07-party-heal-cvalidation/verification.json`.

Both full ROMs are byte-for-byte identical to M6 and retain the M5 hashes.
`BattleControl_EmitPartyStatusHeal` remains 44 bytes with the same command,
ability-byte and move-halfword stores. All other overlay-12 instructions/data
remain unchanged after the ordinary ASM partition and C insertion.

Builds pass without compiler/assembler warnings; packet size/offset assertions,
all ten existing behavioral tests, clang-format 19 and whitespace checks pass.
The receiver audit and an enumeration of all 320 reference ability IDs confirm
that the byte conversion preserves its Mold Breaker test in the release range.
This does not test actual Heal Bell/Aromatherapy battles or enable new abilities.
The existing boot/menu smoke covers these identical ROM binaries.

## M8 — Matching summary data/display prerequisites

Artifacts, maps, ARM9 binaries and audit:
`build/milestones/08-summary-cvalidation/verification.json`.

Both full ROMs are byte-for-byte identical to M7 and retain the M5 hashes.
`sub_0208981C` is 1,076 bytes; `sub_0208D178` is 764 bytes. Typed record/prefix
layout assertions compile successfully, and both full builds pass without
compiler/assembler warnings. The final source passes clang-format 19 and
whitespace checks, plus the existing behavioral tests. No widened ability field
or EV/IV display logic is enabled yet. Boot/menu smoke covers the same binary;
summary gameplay interaction has not been separately exercised.

## M9 — Native ability text resources

Artifacts, ROMs, logs, decoded banks and reusable audit script:
`build/milestones/09-ability-messages/verification.json`.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `bf5a8fc0345e3f8d41dd1771fa734d7d20383c26` | `fbf2c1372349a7f96bbdffbdc870dca4fe829451e8cd792c816fdc1824ea74db` |
| SoulSilver | `7d3744f11a8c865253498f75cbea485819559fa0` | `0e5e667e49e5207427bf8423814bfeee463c7be71933edb1c21532fd682ae528` |

Both full builds pass without compiler/assembler warnings. ARM9, ARM7, all
overlays and all other resources are byte-identical to M8. Only message NARC
`a/0/2/7` members 720/721/722 change, each containing 320 entries. Native
`msgenc` decoding verifies all 960 text payloads against pinned NewGold.
All twelve focused tests and whitespace checks pass. No emulator ability-display
check has been performed for this milestone; new ability mechanics remain pending.

## M10 — Matching AI ability inference/query prerequisites

Artifacts, maps, overlay binaries, logs and runnable source/binary audit:
`build/milestones/10-ai-ability-cvalidation/verification.json` and
`audit-ai-ability-c.py` in the same directory.

Both complete ROMs retain the M9 SHA-1/SHA-256 values and match M9 byte for byte.
The entire 62,560-byte overlay 10 matches; `ov10_0221D0A8` is 224 bytes and
`ov10_0221D188` is 216 bytes. The audit verifies unchanged remaining assembly
and C symbol ownership. Both builds pass without compiler/assembler warnings;
all twelve tests, scoped clang-format 19 and whitespace checks pass.

This validates the vanilla conversion, including its existing byte fields.
NewGold ability widening and AI gameplay scenarios remain pending. No new
emulator verification is claimed for these M9-identical binaries.

## M11 — Matching AI switching prerequisites

Evidence and runnable audit: `build/milestones/11-ai-switch-cvalidation/verification.json`
and `audit-ai-switch-c.py` in the same directory.

Both complete ROMs and overlay 10 are byte-identical to M10, retaining the M9
hashes. `ov10_0221F62C` is 452 bytes; `ov10_0221FE8C` is 388 bytes. The archive
records C symbol ownership and unchanged remaining assembly. Both full builds
pass without compiler/assembler warnings; all twelve tests, scoped formatting
and whitespace checks pass. The first compiled C versions already match.
Vanilla byte narrowing is deliberately retained; expanded ability semantics and
emulator switching scenarios remain pending.

## M12 — Matching Frontier summary record prerequisites

Evidence and runnable audit: `build/milestones/12-frontier-ui-cvalidation/verification.json`
and `audit-frontier-ui-c.py` in the same directory.

Both complete ROMs retain the M9 hashes and match M11 byte for byte. All 43,264
bytes of overlay 83 match. `ov83_02241E18` is 472 bytes; `ov83_02245D48` is
476 bytes. The first C versions match; record/field offset assertions compile,
and remaining assembly partitions are unchanged. Both builds pass without
compiler/assembler warnings; twelve tests, scoped formatting and whitespace
checks pass. The associated renderers remain ASM, ability fields remain u8, and
no in-game menu verification has been performed for this milestone.

## M13 — Frontier summary renderers: one matching, one instruction-equivalent

ROMs, maps, before/after overlays, logs and runnable proof:
`build/milestones/13-frontier-renderer-cvalidation/verification.json` and
`audit-frontier-renderer-c.py` in the same directory. Runtime evidence is under
its `runtime-smoke` directory.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `6971feb1fc72f4254078269ae2f1fecdeb55bf6f` | `7edb12853c005a05d85b20abea362200491c722c938fbc763deaf89afdba8ba5` |
| SoulSilver | `e48ef72086bb2d7c0ee4e61d2d322f6c91cee95f` | `a343df9937c350e96bb6dbc2f0275bd6231c1deeccdb015f28ce61a137fdfd35` |

`ov83_02246114` is MATCHING C, 2,056 bytes. `ov83_022421E0` remains 1,588 bytes
but is NONMATCHING. Its eight-byte difference is exactly this equivalent schedule:

```text
Previous: STR r0,[sp,#4]; MOVS r0,#0; STR r0,[sp,#8]; LDR r3,[sp,#32]
Native C: LDR r3,[sp,#32]; STR r0,[sp,#4]; MOVS r0,#0; STR r0,[sp,#8]
```

The moved load touches neither the stored stack locations nor r0; it does not
set flags. The same MOVS sets flags in both sequences, and no branch enters the
block interior. The audit asserts these exact sequences, equal function sizes,
C symbol ownership and unchanged remaining assembly. Reordering the comparison
copy back proves all other 43,256 overlay bytes identical; no normalized copy is
written to a build output. This is a compiled-instruction equivalence proof,
not a claim of exact matching or a runtime Frontier-menu test.

In both ROMs, only NitroFS file 83 (overlay 83) changes. ARM9, ARM7 and every
other resource/overlay are identical to M12. Both full builds pass without
compiler/assembler warnings. All twelve existing tests, formatting and whitespace
checks pass. Ability storage remains u8; no new ability mechanics are enabled.

Both final ROMs additionally ran for 1,436 frames in isolated directories with
the same installed melonDS core as M5 (SHA-256
`5efc1975eabf12b66502b0ca68d823e9ba96cda8b680482d625e862b8f4c680e`). Both
processes exited successfully; visual inspection confirms legible tutorial text
at frame 1,436 reached by D-pad/A menu input. Exact commands, screenshots, logs,
source and provenance are archived. No external BIOS, existing save or user
configuration was used. This validates boot/rendering/menu input only; the
feature-gameplay verification count remains zero.

## M14 — Matching Frontier Pokémon record prerequisites

Evidence and runnable audit:
`build/milestones/14-frontier-mon-cvalidation/verification.json` and
`audit-frontier-mon-c.py` in that directory.

Both complete ROMs are byte-for-byte identical to M13 and retain its SHA-1 and
SHA-256 values. All 81,504 overlay-80 bytes match. The C-owned functions are
`ov80_02229F6C` (468 bytes), `ov80_0222A140` (460 bytes) and
`ov80_02236734` (472 bytes). The audit also verifies unchanged remaining ASM
partitions. Native record size/ability-offset and NARC-entry-size assertions
compile successfully. Both complete builds pass without compiler/assembler
warnings; twelve existing tests, scoped clang-format 19 and whitespace checks
pass. The M13 boot/menu smoke covers these identical ROMs; no Frontier gameplay
verification or ability widening is claimed. Original NewGold ROM comparison
remains pending, as recorded in the final gate above.

## M15 — Pokéwalker receive/export prerequisites

Evidence, maps, before/after overlays, ROMs and runnable proof are archived in
`build/milestones/15-pokewalker-mon-cvalidation/verification.json` and
`audit-pokewalker-mon-c.py`. Runtime evidence is under `runtime-smoke`.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `5ff5d273bf1e68bd0905a6b91f970d821e1262a9` | `64986f86742a4d65ee05395b0776cc78acfb3cfaa1d772de6f4b2c7f3dc74810` |
| SoulSilver | `eeea8cbf899c1940e029fed21d72678cc325530d` | `f8d8ab9803f36d535b18930a7d34e6d72c68ea609a1161cfe85650825cb27245` |

`ov112_021EEAF0` is MATCHING C, 512 bytes. `ov112_021F33D8` is NONMATCHING C,
460 bytes, with an instruction-equivalence proof: its move-copy cursor and IV
accumulator exchange private SP+4/SP+8 slots. Exactly eight Thumb SP-relative
loads/stores differ. Their registers and opcodes are unchanged; neither address
escapes, stack depth is fixed inside the function, and the nickname buffer
passed to callees starts at SP+32. The validator checks every reference to those
slots and the exact before/after instruction words. Swapping the comparison
copy back proves all other 106,712 overlay-112 bytes identical. This operation
is only an audit in memory, never a ROM/build patch.

In both games only NitroFS file 112 changes; ARM9, ARM7 and all other overlay and
resource payloads are identical to M14. Both builds pass without new compiler
or assembler warnings. Record layout assertions, all twelve existing tests,
scoped clang-format 19 and whitespace checks pass. No expanded ability field
or mechanic is enabled yet, and no Pokéwalker hardware transfer is claimed.

Both final ROMs also complete 1,436 frames in fresh isolated melonDS processes,
using the same installed core/provenance and interpreter/software settings as
M13. Visual checks confirm tutorial text reached through D-pad/A input. Commands,
logs, screenshots and ROM hashes are archived. No user save/configuration or
external BIOS is used. This is boot/rendering/menu-input verification only;
feature-gameplay verification remains zero. Comparison with the original
compiled NewGold ROM is still pending.

## M16 — Nine-bit saved abilities and safe setter inputs

Evidence: `build/milestones/16-saved-abilities/verification.json`, build logs,
ROMs, maps, Pokémon object/disassembly, host log, runnable
`audit-ability-storage.py`, and `runtime-smoke`.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `d1b021213731f22c1af7950b5f35a856588a4466` | `610716ab5b4b195428585c152d377d552b5356ee5802c0fb9a212abc6d2eb2a1` |
| SoulSilver | `75b6d926539287a9171b7a53f7f824b8b87f113f` | `f8c5e28d3a25bbf06f325e6fba0b282a1aa8d89acc80ee1674705928ce550817` |

Both builds pass with no new compiler/assembler warnings. Target layout
assertions preserve Block A 32 bytes, boxed 136 bytes, compact 112 bytes and the
original EXP-word/ability-byte offsets. Inspection of compiled Thumb confirms
low21 masking and the high ability bit in bit31. ARM9 and 118 overlay payloads
change after relinking; ARM7 and every non-overlay resource are identical to
M15. No instruction normalization or output patching is used.

All thirteen focused checks pass. The new test compares actual native selected
accessor cases against the pinned reference functions, with real native crypto,
checksum, locks and compact serialization under ASan/UBSan. All 512 encodings,
32 shuffle values and both lock states pass (32,768 cases), including EXP
boundary/wrap/cap behavior, preserved reserved bits, ability reassignment,
compact roundtrips and checksum rejection. Controlled curves/personal inputs
replace unrelated game-data access; this is not whole-ROM gameplay execution.

Frontier, Trainer House and Pokéwalker byte imports now use correctly sized
locals. GiveMon takes u16. Static paired packet tracing confirms the unchanged
battle-copy receiver already receives a full word. External records are still
byte-limited; BattleMon, AI, UI and assignment data remain prerequisites before
higher IDs can be enabled coherently. No complete edited accessor hook is
counted as retired, because the reference also handles met level there.

Both native ROMs ran 1,436 frames in fresh melonDS processes. Final images show
the readable intro reached through menu input. The same smoke also passed for
the original NewGold build. Runtime commands, core provenance and screenshots
are archived; actual ability gameplay and cross-ROM behavior remain unverified.

## M17 — Matching battle-to-party packet producer

Both complete ROMs are byte-for-byte identical to M16 and retain its SHA-1 and
SHA-256 hashes. All 226,176 overlay 12 bytes match in both games. The 356-byte
`BattleController_EmitBattleMonToPartyMonCopy` is owned by
`battle_controller_mon_copy.o`. Unchanged ASM partitions, packet 44-byte size,
ability word at 0x24 and status2 at 0x1C are checked. The full builds, all thirteen
focused tests, formatting and whitespace checks pass without new compiler or
assembler warnings. Evidence and runnable audit are in
`build/milestones/17-battle-mon-copy-cvalidation`.

M16 boot/menu smoke and original-ROM comparison apply to these identical ROMs.
This is a validated vanilla C prerequisite; the BattleMon source ability remains
u8, and no expanded ability gameplay or protocol change is enabled yet.

## M18 — Battle ability IDs and coherent AI cache

Evidence: `build/milestones/18-battle-abilities/verification.json`, full build
logs, maps/ROMs, host-test log, runnable audit and runtime-smoke records.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `b0ef8ed8d4647c512c08150492aa9bd1e6fddab4` | `2cb97987200f9970c86cf996db091375170ffa737b28dac281c4b4af873ce123` |
| SoulSilver | `c70a864195f7623d67f6f8603e451f1acb168dc2` | `6f8c1b388acd4e128d45d5adf23d00dc7055ac618243e1af762723143c00ecb2` |

Both full builds pass without new compiler/assembler warnings. Target assertions
verify BattleMon stride 0xC0, ability 0x7A, PP 0x2C, item 0x78, effects 0x80; original
AI held-item 0x40 and move-table 0x8A offsets; BattleContext mons 0x2D40, appended
cache 0x3158 and total size 0x3160. No other context member is moved. Source checks
find no BattleMon unk76 accesses or remaining raw old-ability literal; all sixteen
ASM GetBattlerAbility calls preserve the complete return value.

All fourteen host checks pass. The new test runs actual structs and native
ability accessors, cache initialization/revelation/query/reset, AI switch selection,
packet producers and end-of-battle reward eligibility with ASan/UBSan. It covers
all 512 IDs in four battlers (2,048 cases), suppression and Gravity/Ingrain,
known/guessed abilities, per-slot reset, unchanged neighboring data, the existing
44-byte full-ID packet, absorbing aliases and 512 reward cases. Personal data,
party access, RNG, script input, reward tables and transport are controlled.
The private damage record's width is asserted, but the complete damage formula,
battle loader and modern ability effects are not claimed as executed by this test.

ARM7 and every non-overlay resource remain identical to M17. Overlay10/12 code
changes; overlay8 and ARM9 also reflect linking changes. The decompressed ARM9
diff is two bytes and overlay8 is 25 bytes with unchanged ASM sources; raw compressed
sizes are not evidence of changed game data. Whole-ROM identity is neither
expected nor an acceptance condition for this native behavior change.

Both ROMs run 1,436 frames in isolated melonDS processes and reach the readable
intro through menu input. This smoke does not exercise a battle. Actual NewGold
ability gameplay parity remains unverified; UI, field, personal assignment and
external-record compatibility are still dependencies before broader high-ID use.

## M19 — Full ability IDs in the PC box display record

Evidence: `build/milestones/19-pc-ability-width/verification.json`, both build
logs, maps, ROMs, `pc_box_display.o`, `OVY_14.sbin`, host-test log, runnable
audit and runtime-smoke records.

| ROM | SHA-1 | SHA-256 |
| --- | --- | --- |
| HeartGold | `fa6d4ab53e636663778fd5750fa3b6308d9dec2e` | `e73f33f95a043e55398bc16309b3fc216cb738748697814d5bc8b2efb5e16509` |
| SoulSilver | `6facb97d8dfc6ea7edc1bc8017dbfe66e9874dfa` | `1a362a418eb0137fecb5d468fb7d36ef07f4e8cd837e9051816a22d4abca33ac` |

Both full builds pass with no new compiler or assembler warnings; only the
pre-existing `MWLibraries` / `MWLibraryFiles` linker notices and wine's Mesa
messages appear. This is the first build on the rebuilt toolchain described
above, so it also re-establishes that environment. The CI-pinned clang-format
19.1.7 virtualenv was lost with the tmpfs; the host's clang-format 22.1.8
reports no change for either edited file, which were already formatted under
19.1.7.

The change is tightly scoped. Comparing each ROM with its M18 counterpart, the
**only** differing file of 513 is overlay 14; the decompressed ARM9, the ARM7
binary and every other file are byte-identical in both games. No relink note is
needed because nothing outside the edited overlay moved. Target assertions in
`src/pc_box_display.c` verify the record's new 0x20 size and the unchanged
offsets 0x04, 0x06, 0x08, 0x0C, 0x0D, 0x0E, 0x0F, 0x10 and 0x14, plus the
appended ability at 0x1C, so a later layout mistake fails both builds.

All fifteen host checks pass. The new one compiles the actual `ov14_021E7358`
and `ov14_021F528C` under ASan/UBSan and drives 512 ability IDs through record
construction and rendering, asserting the complete ID reaches the already-`u32`
`BufferAbilityName` parameter, that the original 0x0E byte is never written, and
that species, held item, personality, types, nature, markings, level, egg and
gender fields the remaining assembly reads keep their values. It also covers the
egg branch, an empty box slot and both Nidoran species. Box data, heap, message
format and windows are controlled stand-ins, and host pointer width moves every
field, so DS offsets remain the ROM build's assertions rather than the test's.

Both ROMs complete the same 1,436-frame melonDS smoke as earlier milestones,
using the identical core `5efc1975eabf12b66502b0ca68d823e9ba96cda8b680482d625e862b8f4c680e`
(melonDS 0.9.3), no external BIOS and no saved data. All twenty-two captured
frames are byte-identical to M18's, and frame 1436 shows the readable intro
text. The smoke never opens the PC, so it demonstrates an unchanged boot path,
not the widened display. Actual PC rendering of an ability above 255 is still
unverified in a running ROM, and no ID above 255 is assigned yet.

## Interface, Dex, pockets and boxes — emulator session

Date: 2026-09-21. The four items the expansion's precondition names are
implemented; this is what was checked on a running ROM and what was not.

### What the session can do now

`tools/newgold/boot_check.c` is a headless libretro host of about two hundred
lines: no emulator front end, no BIOS of its own, no configuration of the
user's. It loads the installed melonDS core, runs frames, presses buttons,
touches the screen and writes out the framebuffer.
`tools/newgold/smoke.py` drives it and `tests/newgold/test_boot.py` runs a
short one on every test pass.

This replaces the earlier milestones' arrangement, whose runner lived outside
the repository and is no longer on disk. It is in the repository now, so the
next session starts from a working harness rather than writing one.

### What was verified

Both ROMs, built at this commit, boot and keep running: publisher screens, the
sunrise intro, the title, and the controls tutorial reached through scripted
button presses and a scripted touch. Three thousand frames each, software
rendering, the core's own FreeBIOS, an isolated system and save directory.
Neither stops, resets, or shows an assertion.

That is the gate that matters for the save. Thirty boxes moved `SAVE_PAGE_MAX`
from 35 to 48 and grew heap 1 by the same 0xD000 out of the general heap, and
the widened Dex and pockets grew the region again. `SaveData_InitSubstructs`
and `SaveData_InitSlotSpecs` assert their results at boot and would have
stopped the game before the title. They do not.
`tools/newgold/save_budget.py` reads the same numbers out of the built ROM:
187,644 bytes of 196,608, forty-seven pages of forty-eight, highest page 60 of
the 64 the flash erases in a half.

### What was not verified

This is boot and menu evidence. None of the four items was exercised in play:

* The EV and IV viewer, which needs a Pokemon and the summary screen.
* The machine badges and the dropped count, which need the bag.
* A Dex entry for an added species, which needs one caught, and with it the
  two things the Dex screen is known to owe: it prints the species identifier
  rather than a National Dex number, and the area screen has nothing to say
  about a species no map places.
* The thirtieth box, which needs the PC.

Reaching any of them by script is a long frame-accurate sequence through
naming, the starter and the first route. The harness can drive it: buttons and
touch both work, an input can be repeated on a period, and the emulator's
state can be written out and started from, which is what makes the sequence
worth writing once rather than replaying every time.

The opening is now played all the way through. `smoke.py --to outside` runs
the route in about two and a half minutes: publisher screens, the sunrise, the
title, the controls tutorial — which is touch only, and which nothing reached
before the core's touch mode was answered — the "do you understand everything
so far" prompt, the information menu, the name entry, the professor's
introduction, the bedroom, the stairs, the conversation downstairs, and out of
the front door into New Bark Town. It can write the emulator's state out at
the end, and the four stages are named for where they arrive, so a later one
can be extended rather than rediscovered.

`--to skills` goes all the way: west across New Bark Town, past the man who
stops you leaving without a Pokemon, into the laboratory, through the
Professor's speech, four tiles right and one up to the machine the starters
sit on, a Chikorita taken from it, the nickname declined, then the menu, the
party, the summary and right one page to the stats. **Six and a quarter
minutes from a cold boot.**

The tile is the whole trick, and it is why this took so long: one either side
of it and the press finds a memo instead of a Poke Ball. Thirty-two tiles were
visited by eye and none of them was it; with `where.py` reading the party
count, six tries found it.

### The EV and IV viewer, verified in play

On the stats page, with a Chikorita at level 5:

| | HP | Attack | Defense | Sp. Atk | Sp. Def | Speed |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Stats (Select) | 20/20 | 10 | 13 | 9 | 12 | 11 |
| Effort values (L) | 0 | 0 | 0 | 0 | 0 | 0 |
| Individual values (R) | 1 | 28 | 13 | 31 | 12 | 8 |

Every effort value is zero, which is what a Pokemon that has not fought has.
Every individual value is inside nought to thirty-one. And they agree with the
stats: Chikorita's base Attack is 49, so at level 5 with 28 there,
((2*49 + 28) * 5 / 100) + 5 is 11, and the stat is 11. An ordering mistake in
the table that maps the page's order onto the record's would have put Speed's
value under Sp. Atk and none of that would have held.

The captures are in `validation/`: `skills-stats.png`, `skills-evs.png` and
`skills-ivs.png`.

### The nature's mark, verified in play

In the same captures, Defense is drawn in red and Sp. Atk in blue, which is
the nature that raised one and lowered the other. That is the other half of
the summary work: HeartGold changed only the letter's shadow, a palette index
away from plain, and against the plate behind it that cannot be read. Here the
letter changes.

### What is still unplayed

* The machine badges and the missing count in the bag want a TM, which is a
  gym away. The bag itself opens and its eight pockets draw.
* A Dex entry for an added species wants one caught, and with it the two
  things the Dex screen is known to owe: it prints the species identifier
  rather than a National Dex number, and the area screen has nothing to say
  about a species no map places.
* The thirtieth box wants a Pokemon Centre.

The route can be extended to all three, and now has both the means: a walk can
be aimed with `where.py` and its result checked without looking at the screen.
### The gate out of New Bark, and what was behind it

Walking west from the laboratory stops at tile (676, 399) with "Wait a sec!".
Playing it out, waiting on it and pressing through it slowly all end the same
way, so it is a story gate rather than a mistimed press. Guessing at it got
nowhere; reading it took one grep. The line is row 10 of `msg_0542_T20`, and
row 11 is the rest of it: *"Did you leave your Pokegear at home? You should
ask your mom."*

So the gate is two errands, and the route now does both. Back into the house —
its door is at (696, 397), approached from below and entered with one more
step up, which is three tiles right and three down from where the walk from
the laboratory lands. Mum is at the table, three tiles right of the mat, and
gives the Pokegear. Out again, west, and the Professor catches you at the same
tile with "Wait one second!" to put his number in it. **Past that, tile (657,
400) is Route 29**, and the first step into the grass starts a wild battle.

That is where it stops now, and on something smaller: the Poke Ball pocket is
empty. Reading again rather than guessing, `msg_0373_R29` row 0 says who has
them — *"You can catch wild Pokemon with Poke Balls. Follow me!"* — so they
come with the catching tutorial on Route 29 itself, from Lyra or Ethan
depending on which you are.

The route reaches Route 29 and walks it west without that scene triggering.
Reading the map's own event data says why. `030_R29.json` has one coordinate
event: a strip one tile wide and seven tall at **x 666, z 396 to 402**,
running `scr_seq_R29_001` when `VAR_UNK_408B` is 1. The route crosses that
strip — twice, once each way, checked by walking east to (684, 400) and back —
and nothing happens, because the variable is 0.

Grepping for what sets it answers the rest: `scr_seq_0843_T20R0101`, the
laboratory, in the scene that takes the Mystery Egg back from you. So the
catching tutorial and its Poke Balls are on the **return** trip through
Route 29, after Mr Pokemon's errand, not the first one. That is a long way
round for five Poke Balls.

**Cherrygrove is the shorter way, and it is worth two of the three.** It has
the Mart, which sells Poke Balls, and the Pokemon Centre, whose PC is where
the thirtieth box would show. Route 29 west is passable along its southern
edge — the trees at (642, 410) are gone round by dropping a tile first, which
reaches (618, 412) — and Cherrygrove is at the end of it.

The walk got as far as tile (606, 408), by dropping south of the trees at
(642, 410), west, then north again. It stops there against a trainer standing
in the way with trees either side, which is a leg of walking rather than
another gate.

Two practical notes for whoever continues. A state saved while the player is
mid-step comes back corrupt and the core segfaults loading it, and so does one
saved shortly after a map change; save while standing still and well inside a
map, or chain the legs in one run from a state that loads. And the walk runs
from every wild battle by touching RUN at (127, 172) on the bottom screen —
which also means the starter takes no experience, so it stays at level five
and the battles stay short.

These legs were driven from saved states rather than from a cold boot, so they
are written here rather than folded into `smoke.py`'s route: putting them
there means one verification run from frame zero, which is worth doing when
the leg after them is known.

One caveat on determinism. The opening is scripted and arrives in the same
place every time, but the Pokemon it hands over is not the same one: the
console seeds itself from its clock, so the Chikorita's nature and individual
values differ from run to run. The route is repeatable; the numbers on the
screen are not, and a check written against it has to assert what must be true
rather than what was seen once.
