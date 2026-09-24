#!/bin/bash
# stage_content.sh REPO_PATH CONTENT_FILE: stage CONTENT_FILE's bytes as
# REPO_PATH (in the repository the command runs in), leaving the working tree
# alone -- one commit's version of a file the working tree has further on.
[ $# = 2 ] || { sed -n '2,4s/^# //p' "$0"; exit 2; }
blob=$(git hash-object -w "$2") || exit 1
mode=$(git ls-files -s -- "$1" | awk '{print $1}'); mode=${mode:-100644}
git update-index --add --cacheinfo "$mode,$blob,$1"
