# Original konefr build and comparison at M16

The original pinned repository builds successfully without tracked source or
configuration changes. Its ROM is **not byte-identical** to the native M16 port.
This is an intermediate measurement: the port is incomplete, and gameplay
parity is not established. The user subsequently clarified that final acceptance means faithful behavior
and data, not whole-ROM byte identity. Use this build for that fidelity gate.

| Input / output | Value |
| --- | --- |
| NewGold revision | `1b872926eaa0363816d4e376fad1531435b04b9c` |
| Native milestone | `ed91e50c`, saved-ability storage |
| Game / region | US HeartGold, `IPKE` for both |
| Original command | `make -j4`, default config, `AUTO_TEST` unset |
| Original build directory | `/tmp/newgold-original-validation` |
| Input vanilla ROM SHA-256 | `65f02a56842b75aa92d775d56d657a56fe3fa993550b04dc20704ab82d760105` |
| Original output size | 192,211,424 bytes |
| Native output size | 134,217,728 bytes |
| Original output SHA-256 | `34d3f4d65bf7915bd4b7a8c16462a503f69e45676c5a8634ac2371de88e9015a` |
| Native output SHA-256 | `610716ab5b4b195428585c152d377d552b5356ee5802c0fb9a212abc6d2eb2a1` |

The original input is the matching upstream HeartGold ROM built earlier from
pret. The original Makefile accepts HeartGold only; no comparable original
SoulSilver build is claimed. The reference checkout used for source analysis
remains untouched; generated output lives in the separate build copy.

Actual whole-file byte comparison returns false, with the first difference at
ROM offset 20 (0x14). File sizes also differ. Comparing NitroFS resources by name
finds 384 common files: 335 are identical, 49 differ. The JSON report lists every
path. This excludes executable overlays, which are not named NitroFS resources.
No executable behavior equivalence is inferred from these counts.

Message banks 720/721/722 extracted from both compiled ROMs each contain 320
entries. All 960 decoded ability names/uppercase names/descriptions are exactly
equal. Their encoded binary members differ, demonstrating why resource content
must be checked independently from ROM identity. Most other NewGold resources
and executable behavior remain unported.

Both native games and the original NewGold ROM complete the same 1,436-frame
melonDS smoke: boot, rendering, D-pad/A menu input, readable tutorial text.
Each run uses a fresh directory, no user save/configuration and no external
BIOS. This does not verify abilities, battles, field features, saves, transfers
or overall gameplay parity.

## Reproducibility and evidence

The original Makefile downloads several tools from moving branches. Exact
resolved versions are recorded, not assumed to reproduce an older release ROM:

| Dependency | Resolved revision / version |
| --- | --- |
| ARM GCC | Arch `16.2.0-1` |
| ARM binutils | `2.47` |
| ARM newlib | Arch `4.6.0.20260123-1` |
| ndstool | `fa6b6d01881363eb2cd6e31d794f51440791f336` (Makefile pin) |
| armips | `6cc2955197630cba605500b6c375620eb8a91826` |
| armips filesystem submodule | `9948b73240448d7fd9f733428eaad9c9af959903` |
| nitrogfx submodule | `a8fd94a3e582ded71eda5b9f5f0c69258544bb22` (repository pin) |
| adpcm-xq | `2000733c6d92d73c10ddae3ae80232e173d565c8` |
| ntrWavTool | `0fda2edbaa346b9142117e05400811370acb3157` |
| ndspy | `4.1.0` |

`build/reference-newgold/` archives the original ROM, full build log, dependency
revisions, resolved Python packages, tool/config hashes, runtime evidence,
`comparison-m16.json` and runnable `compare-original-newgold.py`. The original
build emits existing tool/source/linker warnings, including unused source
variables and RWX segments; it is not described as warning-free. The build ends
successfully with `Done. See output test.nds.` No fixes were made to its source.

The small external git shim archives actual clone/checkout revisions before the
Makefile deletes tool source directories; it forwards operations to `/usr/bin/git`
unchanged. It does not modify compilation or ROM contents. Downloaded GCC/newlib
packages were checked against the Arch database SHA-256 values and extracted
locally, with no system package installation.

A final behavioral comparison still needs representative gameplay scenarios
for the completed port. Binary inequality alone neither proves nor disproves
behavioral equivalence. Keep the native architecture; do not add hooks or fixed
addresses to force a matching binary.
