#!/usr/bin/env python3
"""Read and write a message bank, and read the reference's text at a revision.

A bank is files/msgdata/msg/msg_NNNN*.gmm. tools/msgenc reads its rows in
DOCUMENT order and ignores index=, so a bank is only right when its rows are
dense and in index order: import_dex_text.py once appended two rows at the end
of a bank, and every row after 573 was read one species along. write() sorts,
and refuses a gap.

A row is a dict: index, id, context ("used" or "garbage"), text (the English
language element, as the gmm spells it: \\n and {STRVAR ...} literal, & < >
escaped), and extra (any other language elements, verbatim -- a garbage row's
Japanese placeholder is what msgenc turns into that many spaces).

The reference's banks are data/text/NNN.txt, one row per line, read with git
at a revision so that the engine (d0380a487) and New Gold (ccf2c9f5) can each
be written from their own tree.
"""
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MSG = ROOT / "files/msgdata/msg"
REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
ENGINE = "d0380a487"    # hg-engine, the parent of konefr's first commit
NEWGOLD = "8cbe6ab86"   # konefr's tip

HEADER = '<?xml version="1.0"?>\n<body language="English">\n'
FOOTER = "</body>\n"
ROW = re.compile(
    r'\t<row id="(?P<id>[^"]*)" index="(?P<index>\d+)">\n'
    r'\t\t<attribute name="window_context_name">(?P<context>[^<]*)</attribute>\n'
    r'\t\t<language name="English">(?P<text>.*?)</language>\n'
    r'(?P<extra>(?:\t\t<language name="[^"]*">.*?</language>\n)*)'
    r'\t</row>\n', re.S)


def path_of(bank):
    """msg_0197.gmm, or msg_0003_EVERYWHERE.gmm: the one file for this number."""
    found = sorted(MSG.glob(f"msg_{bank:04d}.gmm")) or sorted(MSG.glob(f"msg_{bank:04d}_*.gmm"))
    if len(found) != 1:
        raise SystemExit(f"bank {bank}: {len(found)} files")
    return found[0]


def read(bank):
    text = path_of(bank).read_text(encoding="utf-8")
    rows = [dict(index=int(m["index"]), id=m["id"], context=m["context"], text=m["text"], extra=m["extra"])
            for m in ROW.finditer(text)]
    if len(rows) != text.count("<row id="):
        raise SystemExit(f"bank {bank}: a row this reader does not understand")
    return rows


def write(bank, rows):
    rows = sorted(rows, key=lambda row: row["index"])
    indices = [row["index"] for row in rows]
    if indices != list(range(len(rows))):
        raise SystemExit(f"bank {bank}: rows are not 0..{len(rows) - 1} without a gap")
    ids = [row["id"] for row in rows]
    if len(set(ids)) != len(ids):
        raise SystemExit(f"bank {bank}: a row id twice")
    body = "".join(
        f'\t<row id="{row["id"]}" index="{row["index"]}">\n'
        f'\t\t<attribute name="window_context_name">{row["context"]}</attribute>\n'
        f'\t\t<language name="English">{row["text"]}</language>\n'
        f'{row.get("extra", "")}'
        f'\t</row>\n' for row in rows)
    path_of(bank).write_text(HEADER + body + FOOTER, encoding="utf-8")


def new_row(bank, index, text, name=None):
    """A used row; its id is msg_NNNN_XXXXX unless the bank names its rows."""
    return dict(index=index, id=name or f"msg_{bank:04d}_{index:05d}", context="used", text=text, extra="")


def garbage_row(bank, index, width, name=None):
    """A row msgenc encodes as `width` spaces, which is how retail's unused
    rows read; a used row of spaces encodes as nothing."""
    return dict(index=index, id=name or f"msg_{bank:04d}_{index:05d}", context="garbage", text="",
                extra=f'\t\t<language name="日本語">{"X" * width}</language>\n')


def escape(text):
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def git_show(revision, path, reference=REFERENCE):
    result = subprocess.run(["git", "-C", str(reference), "show", f"{revision}:{path}"],
                            capture_output=True, text=True, encoding="utf-8")
    if result.returncode:
        return None
    return result.stdout


def reference_rows(revision, bank, reference=REFERENCE):
    """data/text/NNN.txt at a revision, one entry a row, escaped for a gmm;
    None when the revision has no such file (the bank is retail's there).

    The files are CRLF, some end without a newline, and a blank line is a
    row: msgenc counts it, so this does too."""
    text = git_show(revision, f"data/text/{bank:03d}.txt", reference)
    if text is None:
        return None
    text = text.replace("\r\n", "\n")
    if text == "":
        return []
    if text.endswith("\n"):
        text = text[:-1]
    return [escape(line) for line in text.split("\n")]


def _check():
    assert reference_rows(ENGINE, 203) is not None
    assert reference_rows(ENGINE, 550) is None and len(reference_rows(NEWGOLD, 550)) == 66
    assert len(reference_rows(ENGINE, 197)) == 1787 and len(reference_rows(ENGINE, 300)) == 227
    rows = read(203)
    assert [row["index"] for row in rows] == list(range(len(rows)))
    assert rows[0]["context"] == "garbage" and "日本語" in rows[0]["extra"]
    assert escape("B&W <x>") == "B&amp;W &lt;x&gt;"
    print("gmm.py: ok")


if __name__ == "__main__":
    _check()
