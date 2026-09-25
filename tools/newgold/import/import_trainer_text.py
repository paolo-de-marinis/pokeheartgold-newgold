#!/usr/bin/env python3
"""Write the trainers' text as the reference builds it at a revision.

In the reference, data/Trainers.c holds every trainer's name and lines, and
tools/source/trainerdatagen turns it into four things; this is that generator
again, so the port can be written from either layer:

  - bank 729, trainer names: '{TRNAME}' + .name for every trainer. The port
    builds that bank from trainers.json (files/msgdata/msg.mk), so the names go
    there; nothing in trainers.json but the names and "messages" is touched;
  - bank 728, trainer lines: one row per .text entry, walking sTrainerTextOrder
    and each listed trainer's entries in order (WriteTrainerTextData);
  - trtbl.narc (a/0/5/7): per row, a u16 trainer id and a u16 TRMSG type;
  - trtblofs.narc (a/1/3/1): per trainer, up to the last one that has any text,
    the byte offset of its first entry in trtbl, 0 for a trainer without text.

scripts/msg_cat.py then joins the generated files one per line, turning " into
” and ' and ` into ’; so does this. trainers.json also keeps an unused copy of
each trainer's lines under "messages"; it is kept equal to bank 728.

    import_trainer_text.py [--revision REV] [--write]

REV defaults to the engine (d0380a487); ccf2c9f5 is New Gold.
"""
import argparse
import difflib
import json
import re
import struct
import sys

import gmm
import import_trainers
from wotbl import build_narc, read_narc

TRAINERS = gmm.ROOT / "files/poketool/trainer/trainers.json"
TRTBL = gmm.ROOT / "files/poketool/trmsg/trtbl.narc"
TRTBLOFS = gmm.ROOT / "files/poketool/trmsg/trtblofs.narc"
LITERAL = r'"((?:[^"\\]|\\.)*)"'
STRING = r'((?:"(?:[^"\\]|\\.)*"\s*)+)'


def c_string(literals):
    """The value of adjacent C literals ("a\\n" "b" is one string). Trainers.c
    spells \\n as '\\\\n' so that the generated text carries the two characters
    msgenc reads; nothing else is escaped, and anything else is refused rather
    than guessed at."""
    return "".join(re.sub(r"\\(.)", lambda m: {"\\": "\\", '"': '"'}[m[1]], literal)
                   for literal in re.findall(LITERAL, literals))


def msg_cat(text):
    return text.replace('"', "”").replace("'", "’").replace("`", "’")


def generate(revision):
    """(names, rows, trtbl, trtblofs) as trainerdatagen and msg_cat.py make
    them at `revision`; rows are (trainer, type name, text) in bank order."""
    source = gmm.git_show(revision, "data/Trainers.c")
    header = gmm.git_show(revision, "include/trainer_data.h")
    if source is None or header is None:
        raise SystemExit(f"{revision}: no data/Trainers.c")
    types = {m[1]: int(m[2]) for m in re.finditer(r"#define (TRMSG_\w+)\s+(\d+)", header)}
    table, order = source.split("const u16 sTrainerTextOrder[] = {")
    order = [int(n) for n in re.findall(r"\d+", order.split("}")[0])]
    blocks = re.split(r"^\s*\[(\d+)\] = \{", table, flags=re.M)
    trainers = [blocks[i + 1] for i in range(1, len(blocks), 2)]
    if [int(blocks[i]) for i in range(1, len(blocks), 2)] != list(range(len(trainers))):
        raise SystemExit(f"{revision}: trainers are not 0..{len(trainers) - 1} in order")

    names = [msg_cat(c_string(re.search(r"\.name\s*=\s*" + STRING, block)[1])) for block in trainers]
    texts = [[(kind, msg_cat(c_string(text))) for kind, text in
              re.findall(r"\.type\s*=\s*(\w+),\s*\.text\s*=\s*" + STRING, block)] for block in trainers]
    if sum(map(len, texts)) != source.count(".type = TRMSG_"):
        raise SystemExit(f"{revision}: a text entry this reader does not understand")
    # A double battle prints its trainer's defeat line from TRMSG_DBL_LOSE_1
    # (subscript_0004_BattleWin.s), and hg-engine's rule for a double without
    # a partner is that its line is written there. konefr's two -- Mark #395,
    # and Nelson #389 once import_trainers.py corrects his battle type -- keep
    # their retail TRMSG_LOSE, which the battle never reads: the line is
    # retyped, not rewritten. KONEFR-NOTES.md, Allenatori 7.
    for index, block in enumerate(trainers):
        kinds = [kind for kind, _ in texts[index]]
        if (import_trainers.battle_type(index, block) == "NO_PARTNER_DOUBLE_BATTLE"
                and "TRMSG_LOSE" in kinds and "TRMSG_DBL_LOSE_1" not in kinds):
            texts[index] = [("TRMSG_DBL_LOSE_1" if kind == "TRMSG_LOSE" else kind, text)
                            for kind, text in texts[index]]

    rows, trtbl, offsets = [], b"", [0] * len(trainers)
    for trainer in order:
        if texts[trainer]:
            offsets[trainer] = len(trtbl)
        for kind, text in texts[trainer]:
            trtbl += struct.pack("<HH", trainer, types[kind])
            rows.append((trainer, kind, text))
    last = max((i for i, entries in enumerate(texts) if entries), default=-1)
    trtblofs = b"".join(struct.pack("<H", offset) for offset in offsets[:last + 1])
    return names, rows, trtbl, trtblofs


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    names, rows, trtbl, trtblofs = generate(args.revision)
    data = json.loads(TRAINERS.read_text(encoding="utf-8"))
    trainers = data["trainers"]
    if len(trainers) != len(names):
        raise SystemExit(f"trainers.json has {len(trainers)} trainers, {args.revision} {len(names)}")
    messages = [[] for _ in trainers]
    for trainer, kind, text in rows:
        messages[trainer].append({"type": kind, "message": text})

    changed = 0
    for index, trainer in enumerate(trainers):
        for key, value in (("name", "{TRNAME}" + names[index]), ("messages", messages[index])):
            if trainer.get(key, []) != value:
                print(f"trainer {index} {key}: {trainer.get(key)!r} -> {value!r}"[:300])
                trainer[key] = value
                changed += 1
    old = [row["text"] for row in gmm.read(728)]
    new = [gmm.escape(text) for _, _, text in rows]
    for op, i1, i2, j1, j2 in difflib.SequenceMatcher(None, old, new, autojunk=False).get_opcodes():
        if op != "equal":
            print(f"728 {op} rows {i1}..{i2 - 1} -> {j1}..{j2 - 1}: {old[i1:i2]!r} -> {new[j1:j2]!r}")
    narcs = {TRTBL: build_narc([trtbl], 4), TRTBLOFS: build_narc([trtblofs], 4)}
    for path, archive in narcs.items():
        before = read_narc(path.read_bytes())[0][0]
        if path.read_bytes() != archive:
            member = read_narc(archive)[0][0]
            moved = sum(a != b for a, b in zip(before[::2], member[::2])) if path == TRTBLOFS else None
            print(f"{path.name}: member {len(before)} -> {len(member)} bytes"
                  + (f", {moved} offsets change" if moved is not None else ""))

    print(f"{args.revision}: {len(names)} names, {len(rows)} lines, {changed} trainers.json fields change")
    if not args.write:
        print("nothing written; pass --write")
        return
    TRAINERS.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    gmm.write(728, [gmm.new_row(728, index, text) for index, text in enumerate(new)])
    for path, archive in narcs.items():
        path.write_bytes(archive)


if __name__ == "__main__":
    sys.exit(main())
