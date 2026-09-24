#!/usr/bin/env python3
"""Rewrite a round's branch so its new numbers follow a target's.

usage: shift_branch.py BASE BRANCH TARGET NEWBRANCH

Every commit of BASE..BRANCH is rewritten (same message, author, dates) so
that the battle subscripts, move subscript pointers and msg_0197 rows the
branch added after BASE's last ones start after TARGET's last ones instead.
Only files the branch touched can hold the new numbers, so only those are
rewritten. Prints the three shifts.
"""
import os
import re
import subprocess
import sys
import tempfile

if len(sys.argv) != 5:
    sys.exit(__doc__)
BASE, BRANCH, TARGET, NEW = sys.argv[1:5]
SUB_DIR = "files/battledata/script/subscript/"
HEADER = "include/constants/battle_subscript.h"
GMM = "files/msgdata/msg/msg_0197.gmm"
BATTLE_H = "include/constants/battle.h"


def git(*args, env=None, input=None):
    return subprocess.run(["git", *args], check=True, capture_output=True, env=env, input=input).stdout


def last(rev):
    header = git("show", f"{rev}:{HEADER}").decode()
    sub = max(int(n) for n in re.findall(r"^#define BATTLE_SUBSCRIPT_\w+\s+(\d+)", header, re.M))
    ptr = max(int(n) for n in re.findall(r"^#define MOVE_SUBSCRIPT_PTR_\w+\s+(\d+)", header, re.M))
    msg = max(int(n) for n in re.findall(r'id="msg_0197_(\d+)"', git("show", f"{rev}:{GMM}").decode()))
    bmon = max(int(n) for n in re.findall(r"^#define BMON_DATA_\w+\s+(\d+)", git("show", f"{rev}:{BATTLE_H}").decode(), re.M))
    return sub, ptr, msg, bmon


b_sub, b_ptr, b_msg, b_bmon = last(BASE)
t_sub, t_ptr, t_msg, t_bmon = last(TARGET)
# Only the numbers the branch itself added move, BASE's last to BRANCH's: a
# higher one it quotes is somebody else's (the reference's
# subscript_0469_PARTING_SHOT, "the reference's subscript 458").
l_sub, l_ptr, l_msg, l_bmon = last(BRANCH)
d_sub, d_ptr, d_msg, d_bmon = t_sub - b_sub, t_ptr - b_ptr, t_msg - b_msg, t_bmon - b_bmon
print(f"subscripts +{d_sub}, pointers +{d_ptr}, messages +{d_msg}, BMON_DATA +{d_bmon}")


def new_path(path):
    m = re.fullmatch(re.escape(SUB_DIR) + r"subscript_(\d{4})_(\w+)\.s", path)
    if m and b_sub < int(m.group(1)) <= l_sub:
        return f"{SUB_DIR}subscript_{int(m.group(1)) + d_sub:04d}_{m.group(2)}.s"
    return path


def new_text(path, text):
    if path == HEADER:
        text = re.sub(r"^(#define BATTLE_SUBSCRIPT_\w+\s+)(\d+)", lambda m: m.group(1) + (str(int(m.group(2)) + d_sub) if b_sub < int(m.group(2)) <= l_sub else m.group(2)), text, flags=re.M)
        text = re.sub(r"^(#define MOVE_SUBSCRIPT_PTR_\w+\s+)(\d+)", lambda m: m.group(1) + (str(int(m.group(2)) + d_ptr) if b_ptr < int(m.group(2)) <= l_ptr else m.group(2)), text, flags=re.M)
    if path == BATTLE_H:
        text = re.sub(r"^(#define BMON_DATA_\w+\s+)(\d+)", lambda m: m.group(1) + (str(int(m.group(2)) + d_bmon) if b_bmon < int(m.group(2)) <= l_bmon else m.group(2)), text, flags=re.M)
    text = re.sub(r"msg_0197_(\d{5})", lambda m: f"msg_0197_{int(m.group(1)) + d_msg:05d}" if b_msg < int(m.group(1)) <= l_msg else m.group(0), text)
    if path == GMM:
        text = re.sub(r'(id="msg_0197_(\d+)" index=")(\d+)"', lambda m: f'{m.group(1)}{int(m.group(2))}"', text)
    if path:
        # "subscript 441" in a comment, wrapped as "subscript\n// 441" too
        text = shift_prose(text)
    # a subscript named by its file in a test or a comment
    text = re.sub(r"subscript_(\d{4})_", lambda m: f"subscript_{int(m.group(1)) + d_sub:04d}_" if b_sub < int(m.group(1)) <= l_sub else m.group(0), text)
    return text


shift = lambda n, base, top, d: str(int(n) + d) if base < int(n) <= top else n


def shift_prose(text):
    return re.sub(r"((?i:subscripts?)\s+(?:(?://+|#) ?)?)(\d{3})(?:(-|\.\.| to | and )(\d{3}))?",
                  lambda m: m.group(1) + shift(m.group(2), b_sub, l_sub, d_sub) + (m.group(3) + shift(m.group(4), b_sub, l_sub, d_sub) if m.group(4) else ""), text)


def new_message(text):
    # the numbers a commit message quotes: "subscript 411", "subscripts 415-417",
    # "pointer 217", "rows 01805-01807", msg_0197_01805
    text = shift_prose(text)
    text = re.sub(r"(pointer )(\d{3})", lambda m: m.group(1) + shift(m.group(2), b_ptr, l_ptr, d_ptr), text)
    text = re.sub(r"(BMON_DATA_\w+ (?:= |is |at )?)(\d{3})\b", lambda m: m.group(1) + shift(m.group(2), b_bmon, l_bmon, d_bmon), text)
    text = re.sub(r"\b0([1-9]\d{3})\b", lambda m: f"{int(m.group(1)) + d_msg:05d}" if b_msg < int(m.group(1)) <= l_msg else m.group(0), text)
    return new_text("", text)


commits = git("rev-list", "--reverse", f"{BASE}..{BRANCH}").decode().split()
parent = BASE
index = tempfile.mktemp()
env = dict(os.environ, GIT_INDEX_FILE=index)
for c in commits:
    git("read-tree", c, env=env)
    touched = git("diff", "--name-only", BASE, c).decode().split("\n")
    for path in filter(None, touched):
        entry = git("ls-files", "-s", "--", path, env=env).decode().split()
        if not entry:
            continue  # deleted by the branch
        mode, blob = entry[0], entry[1]
        text = git("cat-file", "blob", blob)
        try:
            out = new_text(path, text.decode()).encode()
        except UnicodeDecodeError:
            out = text
        dest = new_path(path)
        if out != text or dest != path:
            blob = git("hash-object", "-w", "--stdin", input=out).decode().strip()
            if dest != path:
                git("update-index", "--force-remove", "--", path, env=env)
            git("update-index", "--add", "--cacheinfo", f"{mode},{blob},{dest}", env=env)
    tree = git("write-tree", env=env).decode().strip()
    meta = git("log", "-1", "--format=%an%x00%ae%x00%aI%x00%cn%x00%ce%x00%cI", c).decode().split("\0")
    msg = new_message(git("log", "-1", "--format=%B", c).decode()).encode()
    cenv = dict(os.environ, GIT_AUTHOR_NAME=meta[0], GIT_AUTHOR_EMAIL=meta[1], GIT_AUTHOR_DATE=meta[2],
                GIT_COMMITTER_NAME=meta[3], GIT_COMMITTER_EMAIL=meta[4], GIT_COMMITTER_DATE=meta[5].strip())
    parent = git("commit-tree", tree, "-p", parent, env=cenv, input=msg).decode().strip()
os.unlink(index)
git("branch", "-f", NEW, parent)
print(f"{NEW}: {len(commits)} commits rewritten")
