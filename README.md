# Pokémon HeartGold and SoulSilver

This branch is an incremental native source port of
[hg-engine-newgold](https://github.com/konefr/hg-engine-newgold) onto pokeheartgold.
It is not yet a complete NewGold game. See the [migration ledger](docs/newgold/MIGRATION.md)
for implemented features, original ASM conversions, dependencies and validation.
Build modified ROMs with `make COMPARE=0` or `make soulsilver COMPARE=0` after
following the upstream setup instructions below. The retail checksums describe
the unmodified upstream base, not the modified ROMs.

This is a WIP disassembly of Pokémon HeartGold and SoulSilver. For instructions on how to set up the repository, please read [INSTALL.md](INSTALL.md).

The upstream base builds the following ROMs:

* [**pokeheartgold.us.nds**](https://datomatic.no-intro.org/index.php?page=show_record&s=28&n=4787) `sha1: 4fcded0e2713dc03929845de631d0932ea2b5a37`
* [**pokesoulsilver.us.nds**](https://datomatic.no-intro.org/index.php?page=show_record&s=28&n=4788) `sha1: f8dc38ea20c17541a43b58c5e6d18c1732c7e582`

For contacts and other pret projects, see [pret.github.io](https://pret.github.io/).
