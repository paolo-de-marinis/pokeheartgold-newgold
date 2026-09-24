#!/usr/bin/env python3
"""fncmp.py OBJ_A OBJ_B FUNC [FUNC...]: compare functions between two objects
(the assembly's and a decompilation's: matching C is FUNC matching; after
env.sh, for arm-none-eabi-objdump and -readelf).

Each function is the objdump block from its label to the next function
label. Branches compare by target offset from the function start, calls and
literal words by symbol name (from a relocation, or from the resolved
target), everything else by its bytes."""
import re, subprocess, sys

ADDR = {}

def funcs(obj):
    names = set()
    for l in subprocess.run(['arm-none-eabi-readelf', '-sW', obj], capture_output=True, text=True).stdout.splitlines():
        p = l.split()
        if len(p) >= 8 and p[3] == 'FUNC' and not p[7].startswith('$'):
            names.add(p[7])
        if len(p) >= 8 and p[3] in ('FUNC', 'OBJECT', 'NOTYPE') and not p[7].startswith(('$', '.')):
            ADDR.setdefault(obj, {})[int(p[1], 16) & ~1] = p[7]
    return names

def resolve(obj, sym):
    m = re.match(r'(\.\w+)\+0x([0-9a-f]+)$', sym)
    if m:
        return ADDR.get(obj, {}).get(int(m.group(2), 16) & ~1, sym)
    return re.sub(r'[-+]0x[0-9a-f]+$', '', sym)

def blocks(obj):
    fn = funcs(obj)
    out, cur = {}, None
    for l in subprocess.run(['arm-none-eabi-objdump', '-dr', '-z', obj], capture_output=True, text=True).stdout.splitlines():
        if l.startswith('Disassembly of section'):
            cur = None; continue
        m = re.match(r'^([0-9a-f]+) <([^>]+)>:$', l)
        if m:
            if m.group(2) in fn:
                cur = m.group(2); out[cur] = (int(m.group(1), 16), [])
            continue
        if cur and l.strip():
            out[cur][1].append(l)
    return out

def norm(start, lines, obj):
    global OBJ
    OBJ = obj
    ins = []
    for l in lines:
        m = re.match(r'\s+([0-9a-f]+):\s+(R_ARM_\w+)\s+(\S+)', l)
        if m:
            ins[-1]['rel'] = resolve(OBJ, m.group(3)); continue
        m = re.match(r'\s+([0-9a-f]+):\s+((?:[0-9a-f]{4,8} ?)+)\t?(.*)', l)
        if m:
            ins.append({'off': int(m.group(1), 16) - start, 'hex': m.group(2).split(), 'text': m.group(3).strip()})
    out = []
    for i in ins:
        t = i['text']; op = t.split('\t')[0] if t else ''
        if 'rel' in i:
            out.append(f"{op or 'word'} ={i['rel']}")
        elif op.startswith('bl') and not op.startswith('bls') and op in ('bl', 'blx'):
            m = re.search(r'<([^>+]+)', t)
            out.append(f"{op} ={m.group(1) if m else '?'}")
        elif re.match(r'b(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le|al|hs|lo)?(\.n|\.w)?$', op):
            tgt = int(t.split('\t')[1].split()[0], 16) - start
            out.append(f"{op} +{tgt:#x}")
        else:
            out.append(' '.join(i['hex']))
    return out, ins

def main():
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    a, b, *names = sys.argv[1:]
    A, B = blocks(a), blocks(b)
    bad = 0
    for n in names:
        (sa, la), (sb, lb) = A[n], B[n]
        x, xi = norm(sa, la, a); y, yi = norm(sb, lb, b)
        # the assembly may pad with a trailing zero halfword or nop before the next function
        while len(x) > len(y) and x[-1] in ('0000', '46c0'):
            x.pop()
        while len(y) > len(x) and y[-1] in ('0000', '46c0'):
            y.pop()
        if x == y:
            print(f'{n}: match ({len(x)} items)')
            continue
        bad += 1
        print(f'{n}: MISMATCH ({len(x)} vs {len(y)})')
        for i in range(max(len(x), len(y))):
            p = x[i] if i < len(x) else ''; q = y[i] if i < len(y) else ''
            pt = xi[i]['text'] if i < len(xi) else ''; qt = yi[i]['text'] if i < len(yi) else ''
            print(f"{'  ' if p == q else '>>'} {p:28.28} {pt:30.30} | {q:28.28} {qt:30.30}")
    sys.exit(1 if bad else 0)

if __name__ == "__main__":
    main()
