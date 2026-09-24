#!/bin/bash
# build_at.sh [-o DIR] [-t hg,ss,dhg,dss] [COMMIT...]: build the ROMs and
# record their md5s, at each COMMIT in turn (checked out detached; the branch
# is put back at the end), or where the working tree is if none is given.
# Run in the repository to build, after env.sh. Each make runs under capped
# (CAP=8G) with JOBS=8; logs and md5.txt go to DIR (default build/at).
# Targets: hg, ss (HeartGold, SoulSilver), dhg, dss (their NEWGOLD_DIAG=1
# builds); default hg,ss. One line per commit: COMMIT subject hg MD5 ss MD5.
HERE=$(dirname "$(readlink -f "$0")")
# Copies of the helpers: an older commit checked out may not have them.
TOOLS=$(mktemp -d "${TMPDIR:-/tmp}/build_at.XXXXXX")
cp "$HERE/../devkit/capped" "$HERE/clean_stale_scripts.py" "$TOOLS/"
CAPPED=$TOOLS/capped
CLEAN=$TOOLS/clean_stale_scripts.py
trap 'rm -rf "$TOOLS"' EXIT
OUT=build/at
TARGETS=hg,ss
while getopts o:t:h opt; do
    case $opt in
        o) OUT=$OPTARG ;;
        t) TARGETS=$OPTARG ;;
        *) sed -n '2,9s/^# //p' "$0"; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
cd "$(git rev-parse --show-toplevel)" || exit 1
command -v wine > /dev/null || { echo "no wine on PATH: source env.sh first"; exit 1; }
mkdir -p "$OUT"
OUT=$(readlink -f "$OUT")

rom() {
    case $1 in
        hg) echo "build/heartgold.us/pokeheartgold.us.nds" ;;
        ss) echo "GAME_VERSION=SOULSILVER build/soulsilver.us/pokesoulsilver.us.nds" ;;
        dhg) echo "NEWGOLD_DIAG=1 build/heartgold.us.diag/pokeheartgold.us.nds" ;;
        dss) echo "NEWGOLD_DIAG=1 GAME_VERSION=SOULSILVER build/soulsilver.us.diag/pokesoulsilver.us.nds" ;;
        *) echo "unknown target $1" >&2; return 1 ;;
    esac
}

build() {  # build TAG: every target at what is checked out now
    local line="$1 $(git log -1 --format=%s)" t args
    # The ROM targets do not depend on the host tools: build them first, for
    # a fresh worktree and for a commit that changed one.
    if ! "$CAPPED" -m "${CAP:-8G}" make -j"${JOBS:-8}" tools > "$OUT/$1.tools.log" 2>&1; then
        echo "$1 tools FAILED (log $OUT/$1.tools.log)" | tee -a "$OUT/md5.txt"
        return 1
    fi
    for t in ${TARGETS//,/ }; do
        args=$(rom "$t") || return 1
        python3 "$CLEAN" > /dev/null
        # shellcheck disable=SC2086
        if ! "$CAPPED" -m "${CAP:-8G}" make -j"${JOBS:-8}" COMPARE=0 $args > "$OUT/$1.$t.log" 2>&1; then
            echo "$1 $t FAILED (log $OUT/$1.$t.log)" | tee -a "$OUT/md5.txt"
            grep -E 'error|Error' "$OUT/$1.$t.log" | head -5
            return 1
        fi
        line="$line $t $(md5sum < "${args##* }" | cut -c1-32)"
    done
    echo "$line" | tee -a "$OUT/md5.txt"
}

if [ $# = 0 ]; then
    build "$(git rev-parse --short=9 HEAD)$(git diff --quiet HEAD || echo +changes)"
    exit
fi
git diff --quiet HEAD && git diff --cached --quiet || { echo "the working tree has changes: commit or stash them first"; exit 1; }
commits=""   # resolved before HEAD moves: HEAD~1 means the same commit throughout
for c in "$@"; do commits="$commits $(git rev-parse --verify -q "$c^{commit}")" || { echo "no commit $c"; exit 1; }; done
back=$(git symbolic-ref -q --short HEAD || git rev-parse HEAD)
trap 'git checkout -q "$back"; python3 "$CLEAN" > /dev/null; rm -rf "$TOOLS"' EXIT
rc=0
for c in $commits; do
    git checkout -q --detach "$c" || exit 1
    build "$(git rev-parse --short=9 HEAD)" || rc=1
done
exit $rc
