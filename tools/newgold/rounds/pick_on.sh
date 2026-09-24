#!/bin/bash
# Continue a cherry-pick in the current worktree, resolving what has a known
# shape (the ability test, the message bank, the BattleContext size check,
# the switch-in steps' end); stop at the first other conflict.
#     pick_on.sh [--no-size]
# --no-size leaves a size-check conflict to sizefix.py (which measures the
# size with the compiler) instead of size_check.py's ours-plus-delta.
S=$(dirname "$(readlink -f "$0")")
SIZE=1
[ "$1" = "--no-size" ] && SIZE=
GMM=files/msgdata/msg/msg_0197.gmm
BCP=src/battle/battle_controller_player.c
OV=src/battle/overlay_12_0224E4FC.c
while true; do
    u=$(git diff --name-only --diff-filter=U)
    if [ -z "$u" ]; then
        git rev-parse -q --verify CHERRY_PICK_HEAD >/dev/null || { echo "done"; exit 0; }
    fi
    if [ -n "$SIZE" ] && echo "$u" | grep -qx $BCP && [ "$(grep -c '^<<<<<<<' $BCP)" = 1 ] && grep -q 'BattleContextSizeCheck\[' <(awk '/^<<<<<<< /{p=1} p' $BCP); then
        python3 $S/size_check.py && git add $BCP
    fi
    if echo "$u" | grep -qx $OV; then
        python3 $S/entry_case.py >/dev/null
        grep -q '^<<<<<<<' $OV || git add $OV
    fi
    for h in include/constants/battle_subscript.h include/constants/battle.h; do
        if echo "$u" | grep -qx $h; then
            # appended defines on both sides: keep both, ours first
            python3 $S/keep_both.py $h && git add $h
        fi
    done
    if echo "$u" | grep -qx tests/newgold/test_ability_effects.py; then
        python3 $S/resolve_ability_test.py && git add tests/newgold/test_ability_effects.py || exit 1
    fi
    if echo "$u" | grep -qx tests/newgold/test_battle_messages.py; then
        python3 $S/port_rows.py && git add tests/newgold/test_battle_messages.py
    fi
    if echo "$u" | grep -qx $GMM; then
        python3 $S/keep_both.py $GMM && python3 $S/fix_gmm.py && git add $GMM || exit 1
    fi
    left=$(git diff --name-only --diff-filter=U)
    if [ -n "$left" ]; then
        echo "CONFLICT in: $left"; exit 1
    fi
    GIT_EDITOR=true git cherry-pick --continue 2>&1 | grep -E '^\[|error' | head -3
    git rev-parse -q --verify CHERRY_PICK_HEAD >/dev/null || { [ -z "$(git diff --name-only --diff-filter=U)" ] && { echo "done"; exit 0; }; }
done
