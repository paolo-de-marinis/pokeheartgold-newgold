#!/bin/bash
# The playthrough from a new game, leg after leg, on the diagnostics ROM this
# tree builds: what a round runs once, in the background, after its landing.
#
#   . ~/hgss-build/env.sh && tools/newgold/devkit/capped -m 4G tools/newgold/chain.sh DIR [LEG]
#
# DIR is the cache NEWGOLD_CHAIN_FROM=DIR reads (test_scenarios.py): each leg
# that passes leaves its in-game save and its report there, NAME.sav and
# NAME.txt, the report's last line naming the commit it was played on; a leg
# that fails leaves there what the last run to pass it left. The run itself
# plays in DIR/run, on a copy of the ROM and its ELF (the tree may be rebuilt
# meanwhile), and stops at the first leg that fails; DIR/chain.log has a line
# for the run and one for each leg: its exit code, its time and its report's
# first line (PASS or FAIL, its frames). With LEG the run starts at that leg,
# from the save DIR keeps of the leg before: a run that stopped, resumed.
#
# The legs play in the order their "from" links draw, read from the tree.
# Both HeartGold builds are made: the legs play the diagnostics one, and a
# leg's savedit edit (12b's --train) measures the save's blocks from the
# plain one, build/heartgold.us, which a fresh tree does not have.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
DIR=$(realpath -m "${1:?usage: chain.sh DIR [LEG]}")
FIRST=${2:-}
RUN=$DIR/run
mkdir -p "$RUN/tmp"
rm -f "$RUN"/playthrough_* "$RUN/build.log"
export TMPDIR=$RUN/tmp
cd "$ROOT" || exit 1
log() { echo "$*" | tee -a "$DIR/chain.log"; }
COMMIT=$(git rev-parse --short=9 HEAD)$(git diff --quiet HEAD -- || echo "+changes")
for build in build/heartgold.us build/heartgold.us.diag; do
    diag=$([ "$build" = build/heartgold.us.diag ] && echo NEWGOLD_DIAG=1)
    make -j4 COMPARE=0 $diag "$build/pokeheartgold.us.nds" >> "$RUN/build.log" 2>&1 \
        || { log "$COMMIT: the build of $build failed ($RUN/build.log)"; exit 1; }
done
cp build/heartgold.us.diag/pokeheartgold.us.nds build/heartgold.us.diag/main.elf "$RUN/"
LEGS=$(python3 - <<'PY'
import glob, json, os
before = {os.path.basename(p)[:-5]: json.load(open(p)).get("from") for p in glob.glob("tests/newgold/scenarios/playthrough_*.json")}
after = {leg_before: leg for leg, leg_before in before.items()}
order, leg = [], None
while leg in after:
    leg = after[leg]
    order.append(leg)
assert len(order) == len(before), "the legs are not one chain"
print("\n".join(order))
PY
) || { log "$COMMIT: the legs are not one chain"; exit 1; }
[ -z "$FIRST" ] || grep -qx "$FIRST" <<< "$LEGS" || { log "$COMMIT: no leg $FIRST"; exit 1; }
log "$(date '+%F %T') $COMMIT $(md5sum < "$RUN/pokeheartgold.us.nds" | cut -c1-32)${FIRST:+ from $FIRST}"
for name in $LEGS; do
    from=()
    if [ -n "$FIRST" ]; then
        [ "$name" = "$FIRST" ] || continue
        FIRST= from=(--from "$DIR")
    fi
    t0=$(date +%s)
    timeout 5400 python3 tools/newgold/devkit/diag/scene.py --scenario "tests/newgold/scenarios/$name.json" --chain "$RUN" \
        "${from[@]}" --rom "$RUN/pokeheartgold.us.nds" --elf "$RUN/main.elf" > "$RUN/$name.out" 2>&1
    rc=$?
    log "$name rc=$rc $(( $(date +%s) - t0 ))s $(head -1 "$RUN/$name.txt" 2>/dev/null)"
    [ $rc -eq 0 ] && [ -f "$RUN/$name.sav" ] || { log "STOPPED at $name ($RUN/$name.txt)"; exit 1; }
    echo "  played on $COMMIT" >> "$RUN/$name.txt"
    cp "$RUN/$name.sav" "$RUN/$name.txt" "$DIR/"
done
log "CHAIN PASSED"
