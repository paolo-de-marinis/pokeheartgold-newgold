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
| Rage cleanup | Pending | Pending | Planned actual-C status/state/RNG regression |
| Fire Fang / Shadow Force classification | Pending | Pending | Planned actual-C helper and live/AI predicate regression |

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
