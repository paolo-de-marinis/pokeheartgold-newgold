#!/bin/bash
# The playthrough from a new game, leg after leg, on the diagnostics ROM this
# tree builds: what a round runs once, in the background, after its landing.
#
#   . ~/hgss-build/env.sh && tools/newgold/devkit/capped -m 4G tools/newgold/chain.sh DIR
#
# DIR is the cache NEWGOLD_CHAIN_FROM=DIR reads (test_scenarios.py): each leg
# that passes leaves its in-game save and its report there, NAME.sav and
# NAME.txt, the report's last line naming the commit it was played on; a leg
# that fails leaves there what the last run to pass it left. The run itself
# plays in DIR/run, on a copy of the ROM and its ELF (the tree may be rebuilt
# meanwhile), and stops at the first leg that fails; DIR/chain.log has a line
# for the run and one for each leg: its exit code, its time and its report's
# first line (PASS or FAIL, its frames).
set -u
export LC_ALL=C         # the legs in byte order, which is the chain's: 04_ before 04b
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
DIR=$(realpath -m "${1:?usage: chain.sh DIR}")
RUN=$DIR/run
mkdir -p "$RUN/tmp"
rm -f "$RUN"/playthrough_*
export TMPDIR=$RUN/tmp
cd "$ROOT" || exit 1
log() { echo "$*" | tee -a "$DIR/chain.log"; }
COMMIT=$(git rev-parse --short=9 HEAD)$(git diff --quiet HEAD -- || echo "+changes")
make -j4 COMPARE=0 NEWGOLD_DIAG=1 build/heartgold.us.diag/pokeheartgold.us.nds > "$RUN/build.log" 2>&1 \
    || { log "$COMMIT: the build failed ($RUN/build.log)"; exit 1; }
cp build/heartgold.us.diag/pokeheartgold.us.nds build/heartgold.us.diag/main.elf "$RUN/"
log "$(date '+%F %T') $COMMIT $(md5sum < "$RUN/pokeheartgold.us.nds" | cut -c1-32)"
for leg in tests/newgold/scenarios/playthrough_*.json; do
    name=$(basename "$leg" .json)
    t0=$(date +%s)
    timeout 5400 python3 tools/newgold/devkit/diag/scene.py --scenario "$leg" --chain "$RUN" \
        --rom "$RUN/pokeheartgold.us.nds" --elf "$RUN/main.elf" > "$RUN/$name.out" 2>&1
    rc=$?
    log "$name rc=$rc $(( $(date +%s) - t0 ))s $(head -1 "$RUN/$name.txt" 2>/dev/null)"
    [ $rc -eq 0 ] && [ -f "$RUN/$name.sav" ] || { log "STOPPED at $name ($RUN/$name.txt)"; exit 1; }
    echo "  played on $COMMIT" >> "$RUN/$name.txt"
    cp "$RUN/$name.sav" "$RUN/$name.txt" "$DIR/"
done
log "CHAIN PASSED"
