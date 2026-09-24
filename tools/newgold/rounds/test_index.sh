#!/bin/sh
# test_index.sh TESTMODULE...: run tests/newgold modules against what is
# staged, not the working tree -- a commit of one thing passes on its own.
# The index is checked out whole under $TMPDIR (put TMPDIR on disk: it is a
# copy of the tree); TEST_INDEX_PATHS="tests src include ..." narrows it.
# Nothing is built there, so tests that need a ROM skip.
set -e
[ $# -gt 0 ] || { sed -n '2,7s/^# \{0,1\}//p' "$0"; exit 2; }
cd "$(git rev-parse --show-toplevel)"
T=$(mktemp -d "${TMPDIR:-/tmp}/test_index.XXXXXX")
trap 'rm -rf "$T"' EXIT
if [ -n "$TEST_INDEX_PATHS" ]; then
    # shellcheck disable=SC2086
    git ls-files -z -- $TEST_INDEX_PATHS | xargs -0 git checkout-index --prefix="$T/"
else
    git checkout-index -a --prefix="$T/"
fi
cd "$T/tests/newgold"
python3 -m unittest "$@" > "$T/out" 2>&1 && ok=0 || ok=$?
tail -3 "$T/out"
exit $ok
