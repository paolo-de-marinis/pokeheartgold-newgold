#!/bin/bash
# suite_at.sh [-o DIR] COMMIT...: the host suite on an export of each commit
# (git archive into DIR; nothing is built there, so the tests that need a ROM
# skip), under capped, TMPDIR=DIR/tmp. One line per commit -- its Ran/OK/
# FAILED and the tests that failed -- to DIR/suite-summary.txt (default
# build/suite-at); the full output to DIR/suite-COMMIT.log.
HERE=$(dirname "$(readlink -f "$0")")
OUT=build/suite-at
while getopts o:h opt; do
    case $opt in
        o) OUT=$OPTARG ;;
        *) sed -n '2,6s/^# //p' "$0"; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
[ $# -gt 0 ] || { sed -n '2,6s/^# //p' "$0"; exit 2; }
cd "$(git rev-parse --show-toplevel)" || exit 1
mkdir -p "$OUT/tmp"
OUT=$(readlink -f "$OUT")
for c in "$@"; do
    c=$(git rev-parse --short=9 --verify -q "$c^{commit}") || { echo "no commit"; exit 1; }
    d=$OUT/at-$c
    rm -rf "$d"; mkdir -p "$d"
    git archive "$c" | tar -x -C "$d"
    (cd "$d" && TMPDIR=$OUT/tmp timeout 1200 "$HERE/../devkit/capped" python3 -m unittest discover -s tests/newgold -t tests/newgold > "$OUT/suite-$c.log" 2>&1)
    echo "$c: $(grep -E '^(Ran|OK|FAILED)' "$OUT/suite-$c.log" | tr '\n' ' ') $(grep -E '^(FAIL|ERROR):' "$OUT/suite-$c.log" | sed 's/ (.*//' | tr '\n' ' ')" | tee -a "$OUT/suite-summary.txt"
    rm -rf "$d"
done
