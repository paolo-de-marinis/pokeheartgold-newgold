#!/bin/sh
# cc.sh SRC OUT.o [VARIABLE=VALUE...]: compile a .c, or assemble a .s, the way
# the build does -- the command is the Makefile's own (make print-MW_COMPILE,
# print-MW_ASSEMBLE), so GAME_VERSION=SOULSILVER, NEWGOLD_DIAG=1 and the like
# pass through. Runs in the repository the command is run in, after env.sh.
# INCLUDE=DIR is searched first: a header changed for the experiment (a
# NUM_BOXES, a struct) without touching the tree's.
set -e
[ $# -ge 2 ] || { sed -n '2,7s/^# //p' "$0"; exit 2; }
src=$(realpath "$1"); out=$(realpath -m "$2"); shift 2
[ -z "$INCLUDE" ] || INCLUDE=$(realpath "$INCLUDE")
cd "$(git rev-parse --show-toplevel)"
case $src in
    *.c) var=MW_COMPILE ;;
    *.s) var=MW_ASSEMBLE ;;
    *) echo "cc.sh: $src is neither .c nor .s" >&2; exit 2 ;;
esac
cmd=$(make -s --no-print-directory "print-$var" "$@" | sed -n "s/^$var is a [a-z]* variable set to \[\(.*\)\]\$/\1/p")
[ -n "$cmd" ] || { echo "cc.sh: make printed no $var" >&2; exit 1; }
cmd=${cmd% -gccdep -MD}                                    # no dependency file
case $src in "$PWD"/asm/*) cmd="$cmd -DPM_ASM" ;; esac      # the Makefile's ASM_OBJS get it
[ -z "$INCLUDE" ] || cmd=$(printf '%s' "$cmd" | sed "s| -gccinc | -gccinc -i $INCLUDE |")
mkdir -p build
tmp=build/cc_$$.o   # mwcc writes a relative path reliably
eval "$cmd -c -o $tmp \"\$src\""
mv "$tmp" "$out"
