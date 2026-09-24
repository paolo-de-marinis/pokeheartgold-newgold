#!/bin/bash
# snap.sh TREE DEST: copy what the harness reads out of TREE -- its diagnostics
# build (ROM, ELF, main.sbin; the plain build's ELF and main.sbin, which savedit
# measures the save's blocks from), the headers and sources the readers parse, the
# data files savedit reads, the devkit itself -- into DEST (about 800 MB), so
# a run reads one build while the tree is rebuilt under it. Point the lens at
# it with SNAP=DEST; any devkit tool run from DEST/tools/newgold/devkit reads
# DEST as its tree.
set -e
[ $# = 2 ] || { sed -n '2,7s/^# //p' "$0"; exit 2; }
W=$(readlink -f "$1")
rm -rf "$2"; mkdir -p "$2"
D=$(readlink -f "$2")
mkdir -p "$D/build/heartgold.us.diag" "$D/build/heartgold.us" "$D/tools/newgold" "$D/lib"
cp -r "$W/tools/newgold/devkit" "$W/tools/newgold/import" "$D/tools/newgold/"
cp -r "$W/include" "$W/src" "$D/"
cp -r "$W/lib/include" "$D/lib/"
cp "$W/charmap.txt" "$W/config.mk" "$D/"
cp -r "$W/files" "$D/"   # savedit reads banks, archives, scripts, art: all of it (reflinked on btrfs)
cp "$W"/build/heartgold.us.diag/{pokeheartgold.us.nds,main.elf,main.sbin,main.elf.xMAP} "$D/build/heartgold.us.diag/"
cp "$W"/build/heartgold.us/{main.elf,main.sbin} "$D/build/heartgold.us/"   # savedit measures the save from them
du -sh "$D"
