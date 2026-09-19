# Native NewGold validation

Validation date: 2026-09-19. Input revisions are pinned in `MIGRATION.md`.
This report distinguishes source tests, a matching vanilla ROM, a modified ROM
build, and emulator/hardware testing. The latter is not implied by compilation.

## Required final comparison with the original NewGold build

The user additionally requires building the original konefr repository and
checking whether its ROM equals the native port's ROM. This gate is **PENDING**.
Build pinned NewGold `1b872926eaa0363816d4e376fad1531435b04b9c` in an isolated
copy, preserving its original toolchain/configuration and recording the exact
base-ROM hash, dependencies and any required external inputs. Keep the reference
checkout unchanged. Use comparable game/region/revision inputs for both builds.
The original Makefile explicitly accepts US HeartGold (`IPKE`), reads `rom.nds`
and produces `test.nds`; it does not provide an equivalent SoulSilver target.
The matching upstream HG baseline already built here is a reproducible candidate
input, subject to checking the reference's complete build requirements.

Record both ROM hashes and an actual byte-for-byte comparison, regardless of
the expected result. A source-level port can have a different code/layout binary
while implementing the same behavior; do not call that byte-identical, and do
not add hooks or address constraints merely to force equality. If the binaries
differ, separately compare decoded game data/resources and representative
gameplay behavior against that compiled reference. Explain every remaining
unverified area; host-function tests or matching vanilla prerequisites alone
cannot satisfy this final comparison. No original NewGold build comparison has
yet been performed.

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
Validation therefore uses a separate copy at `/tmp/pokeheartgold-validation`.
The initial copy was checked against every tracked upstream blob (respecting
`charmap.txt`'s required CRLF working-tree conversion). Subsequent builds copy
only the milestone's changed files, leaving unrelated working changes out.

On this host, the build environment is:

```sh
export PATH=/tmp/hgss-build-deps/arch/usr/bin:$PATH
export WINEPREFIX=/tmp/hgss-build-deps/wineprefix
export WINEDEBUG=-all
export WINEDLLOVERRIDES=mscoree,mshtml=
cd /tmp/pokeheartgold-validation
make -j4 COMPARE=1
make -j4 GAME_VERSION=SOULSILVER COMPARE=1
```

For intentionally modified ROMs use `COMPARE=0`. On another machine, use
`INSTALL.md` and a checkout without spaces; the `/tmp` paths above are local
validation paths, not new project dependencies.

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

Baseline HeartGold SHA-1: `4fcded0e2713dc03929845de631d0932ea2b5a37`.
Baseline SoulSilver SHA-1: `f8dc38ea20c17541a43b58c5e6d18c1732c7e582`.
Baseline logs: `/tmp/hgss-build-deps/baseline-heartgold.log` and
`/tmp/hgss-build-deps/baseline-soulsilver.log`.
The linker already warns about unset `MWLibraries` and `MWLibraryFiles` in the
successful baseline; Wine emits Mesa display warnings. These are environmental
baseline warnings, not warnings introduced by ported C.

Run the current focused checks with:

```sh
python3 -m unittest discover -s tests/newgold -v
git diff --check
```

The tests compile actual source functions with small host fixtures and the
project's real constants. They do not emulate the full DS memory layout. The
Wonder Guard check also compiles the pinned vanilla helper and demonstrates that
the original fails the regression while preserving unrelated effect behavior.

ROM scenarios still to execute are listed with their features in `MIGRATION.md`.

Vanilla conversion logs: `/tmp/hgss-build-deps/vanilla-decomp-heartgold.log`
and `/tmp/hgss-build-deps/vanilla-decomp-soulsilver.log`. No new compiler warnings.

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
