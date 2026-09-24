#!/usr/bin/env python3
"""Show that two builds differ only in where things are placed.

Every named symbol in a section (C objects with their sizes, assembly labels
up to the next symbol) is compared by name between the two builds: same
bytes once relocated words are masked, and the same relocations (offset in
the symbol, type, target name, addend). Local names lose their $NNNN suffix.
Usage: relocmp.py OLD_DIR NEW_DIR SECTION[=file.sbin] ...   (build directories, after env.sh)"""
import bisect, re, subprocess, sys
from collections import defaultdict

RE = 'arm-none-eabi-readelf'
def norm(n): return re.sub(r'\$\d+$', '', n)
def run(*a): return subprocess.run([RE, *a], capture_output=True, text=True).stdout.splitlines()

def load(d, section, sbin):
    elf = f'{d}/main.elf'
    idx, base = set(), None
    for l in run('-SW', elf):
        m = re.match(r'\s*\[\s*(\d+)\]\s+(\S+)\s+\S+\s+([0-9a-f]+)', l)
        if m and m.group(2) == section:
            idx.add(int(m.group(1))); a = int(m.group(3), 16); base = a if base is None else min(base, a)
    data = open(f'{d}/{sbin}', 'rb').read()
    pts = []
    for l in run('-sW', elf):
        p = l.split()
        if len(p) >= 8 and p[0].endswith(':') and p[6].isdigit() and int(p[6]) in idx \
                and p[3] in ('FUNC', 'OBJECT', 'NOTYPE') and not p[7].startswith(('$', '.')):
            a = int(p[1], 16) & ~1 if p[3] == 'FUNC' else int(p[1], 16)
            if base <= a < base + len(data):
                pts.append((a, int(p[2], 0 if not p[2].startswith('0x') else 16), norm(p[7])))
    pts.sort()
    starts = sorted({a for a, _, _ in pts} | {base + len(data)})
    tab = defaultdict(list)
    for a, sz, name in pts:
        if not sz:
            sz = next(s for s in starts if s > a) - a
        tab[name].append((a, sz))
    rel = defaultdict(list)
    cur = None
    for l in run('-rW', elf):
        m = re.match(r"Relocation section '\.rela(\S+)'", l)
        if m: cur = m.group(1); continue
        p = l.split()
        if cur == section and len(p) >= 5 and re.match(r'^[0-9a-f]{8}$', p[0]):
            add = int(p[6], 16) if len(p) > 6 else 0
            if len(p) > 6 and p[5] == '-': add = -add
            rel[int(p[0], 16)].append((p[2], norm(p[4]), add))
    return base, data, tab, rel

def within(keys, start, size):
    return keys[bisect.bisect_left(keys, start):bisect.bisect_left(keys, start + size)]


def check(old, new, section, sbin):
    (b0, d0, t0, r0), (b1, d1, t1, r1) = load(old, section, sbin), load(new, section, sbin)
    k0, k1 = sorted(r0), sorted(r1)   # the relocations' offsets, for a symbol's range by bisection
    bad = moved = n = 0
    for name in sorted(set(t0) ^ set(t1)):
        print(f'  {section}: {name} only in {"old" if name in t0 else "new"}'); bad += 1
    for name in sorted(set(t0) & set(t1)):
        if len(t0[name]) != 1 or len(t1[name]) != 1:
            continue
        (a0, s0), (a1, s1) = t0[name][0], t1[name][0]
        s = min(s0, s1)  # an assembly label runs to the next symbol, which may be padding
        n += 1; moved += a0 != a1
        x = bytearray(d0[a0 - b0:a0 - b0 + s]); y = bytearray(d1[a1 - b1:a1 - b1 + s])
        rs0 = sorted((q - a0, r) for q in within(k0, a0, s) for r in r0[q])
        rs1 = sorted((q - a1, r) for q in within(k1, a1, s) for r in r1[q])
        if rs0 != rs1:
            print(f'  {name}: relocations differ'); bad += 1; continue
        for off, (typ, _, _) in rs0:
            w = 2 if typ in ('R_ARM_THM_PC22', 'R_ARM_THM_CALL', 'R_ARM_THM_XPC22') else 0
            span = 4
            x[off:off + span] = y[off:off + span] = b'\0' * span
        if x != y:
            print(f'  {name}: bytes differ'); bad += 1
    print(f'{section}: {n} symbols compared, {moved} moved, {bad} problems')
    return bad

if __name__ == '__main__':
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    old, new = sys.argv[1], sys.argv[2]
    bad = sum(check(old, new, *(a.partition('=')[0], a.partition('=')[2] or a.partition('=')[0] + '.sbin')) for a in sys.argv[3:])
    sys.exit(1 if bad else 0)
