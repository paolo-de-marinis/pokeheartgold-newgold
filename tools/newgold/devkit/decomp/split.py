#!/usr/bin/env python3
"""split.py ASM FUNC... : take each FUNC out of ASM's .text, the text after it
going to asm/<stem>_<next addr>.s (text only; the sections after .text stay in
ASM), and declare in asm/include/<inc> what the parts reach across the split
and the C functions. Run in the repository: asm/include is relative."""
import re, sys
from pathlib import Path

if len(sys.argv) < 3:
    sys.exit(__doc__)
asm = Path(sys.argv[1]); funcs = sys.argv[2:]
lines = asm.read_text().split("\n")
head_end = next(i for i, l in enumerate(lines) if l.strip() == ".text")
text_end = next((i for i, l in enumerate(lines) if i > head_end and re.match(r"\s*\.(rodata|data|bss)\b", l)), len(lines))
header = lines[:head_end]
inc_name = re.findall(r'\.include "(\w+\.inc)"', "\n".join(header))[0]
cuts = []
for f in funcs:
    s = next(i for i, l in enumerate(lines) if re.match(rf"\s*thumb_func_start {f}$", l))
    e = next(i for i, l in enumerate(lines) if re.match(rf"\s*thumb_func_end {f}$", l))
    n = next(i for i in range(e + 1, text_end) if re.match(r"\s*(thumb|arm)_func_start ", lines[i]))
    nxt = lines[n].split()[1]
    cuts.append((s, n, nxt))
cuts.sort()
parts = []  # (path, lines)
first = lines[:cuts[0][0]]
for k, (s, n, nxt) in enumerate(cuts):
    end = cuts[k + 1][0] if k + 1 < len(cuts) else text_end
    body = lines[n:end]
    while body and body[-1].strip() == "":
        body.pop()
    addr = re.search(r"_([0-9A-F]{8})$", nxt).group(1)
    path = asm.with_name(f"{asm.stem}_{addr}.s")
    parts.append((path, header + ["\t.text", ""] + body + [""]))
while first and first[-1].strip() == "":
    first.pop()
first_all = first + [""] + lines[text_end:]
parts.insert(0, (asm, first_all))
# public declarations already in the header of ASM
pub_header = [l for l in header if l.startswith(".public")]
# the header's .public lines go to every new part too
label = re.compile(r"^(\w+):")
ident = re.compile(r"\b([A-Za-z_]\w*)\b")
defs = {}
for p, ls in parts:
    for l in ls:
        m = label.match(l)
        if m:
            defs.setdefault(m.group(1), p)
cross = set()
for p, ls in parts:
    for l in ls:
        code = label.sub("", l.split(";")[0])
        if "func_start" in code or "func_end" in code:
            continue
        for tok in ident.findall(code):
            if tok in defs and defs[tok] != p:
                cross.add(tok)
for p, ls in parts:
    p.write_text("\n".join(ls))
inc = Path("asm/include") / inc_name
text = inc.read_text().rstrip("\n").split("\n")
have = {l.split()[1] for l in text if l.startswith(".public")}
add = sorted((cross | set(funcs)) - have)
inc.write_text("\n".join(text + [f".public {s}" for s in add]) + "\n")
print("parts:", [str(p) for p, _ in parts]); print("declared:", add)
