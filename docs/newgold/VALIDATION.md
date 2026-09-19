# Native NewGold validation

Validation date: 2026-09-19. Input revisions are pinned in `MIGRATION.md`.
This report distinguishes source tests, a matching vanilla ROM, a modified ROM
build, and emulator/hardware testing. The latter is not implied by compilation.

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
