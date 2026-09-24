#!/usr/bin/env python3
"""What a module of the ROM is made of, and how it grew, from mwld's xMAPs.

    xmap.py objects XMAP MODULE             the module's bytes by object file
    xmap.py diff OLD NEW MODULE [N]         growth by object, then by symbol
    xmap.py growth OLD NEW MODULE [N]       growth by function: retail ones
                                            grown, new ones, gone ones

XMAP is a build's main.elf.xMAP; MODULE is main, OVY_12 (the battle, whose
end is where the main arena starts), ... -- its .bss counts with it. An
object's span runs to the next object's start, so padding is counted where
the linker put it; symbols are matched by name (objects get renamed), a
static's $NNN suffix dropped. N is how many lines of each list (30, 25).
"""
import collections
import re
import sys
from pathlib import Path

ENTRY = re.compile(r"^  ([0-9A-F]{8}) ([0-9A-F]{8}) (\.\S+)\s+(\S+)\t\((.+)\)$")


def parse(path, module):
    """(address, size, section, name, object, module) of every entry of MODULE and MODULE.bss."""
    out, current = [], None
    for line in Path(path).read_text(encoding="latin-1").splitlines():
        if line.startswith("# ."):
            current = line[3:].strip()
            continue
        if line.startswith("# ") and not line.startswith("# Exception"):
            current = None
            continue
        if current in (module, module + ".bss"):
            m = ENTRY.match(line)
            if m:
                out.append((int(m[1], 16), int(m[2], 16), m[3], m[4], m[5], current))
    return out


def objspans(entries):
    """Bytes per (section, object): each run of one object's entries, to the next run's start."""
    runs = []
    for address, size, section, name, obj, module in entries:
        key = (section, obj)
        if runs and runs[-1][0] == key:
            runs[-1][2] = max(runs[-1][2], address + size)
        else:
            runs.append([key, address, address + size])
    spans = collections.Counter()
    for i, (key, start, end) in enumerate(runs):
        following = runs[i + 1][1] if i + 1 < len(runs) and runs[i + 1][1] >= start else end
        if following - start > (end - start) + 0x40:
            following = end   # .bss after data: the next run is in another region
        spans[key] += max(following - start, end - start)
    return spans


def byobj(entries):
    out = collections.Counter()
    for (section, obj), size in objspans(entries).items():
        out[obj] += size
    return out


def syms(entries):
    out = {}
    for address, size, section, name, obj, module in entries:
        if size == 0 or name.startswith(("$", ".")):
            continue
        name = re.sub(r"\$\d+$", "$", name)
        out[(name, obj)] = out.get((name, obj), 0) + size
    return out


def objects(xmap, module):
    sizes = byobj(parse(xmap, module))
    for obj, size in sizes.most_common(40):
        print(f"{size:8X} {obj}")
    print("total", hex(sum(sizes.values())))


def diff(old, new, module, n=30):
    eo, en = parse(old, module), parse(new, module)
    bo, bn = byobj(eo), byobj(en)
    d = sorted(((bn[o] - bo[o], o, bo[o], bn[o]) for o in set(bo) | set(bn) if bn[o] != bo[o]), reverse=True)
    print(f"== {module} objects: old {sum(bo.values()):#x} new {sum(bn.values()):#x} delta {sum(bn.values()) - sum(bo.values()):+#x}")
    for x in d[:n]:
        print(f"  {x[0]:+8d} ({x[0]:+#7x})  {x[1]}  {x[2]:#x} -> {x[3]:#x}")
    if len(d) > n:
        print(f"  ... {len(d) - n} more; smallest: " + ", ".join(f"{x[1]} {x[0]:+d}" for x in d[-5:]))
    no, nn, where = collections.Counter(), collections.Counter(), {}
    for (name, obj), size in syms(eo).items():
        no[name] += size
        where.setdefault(name, obj)
    for (name, obj), size in syms(en).items():
        nn[name] += size
        where[name] = obj
    fd = sorted(((nn[k] - no[k], k, no[k], nn[k]) for k in set(no) | set(nn) if nn[k] != no[k]), reverse=True)
    print(f"== {module} symbols changed: {len(fd)}; new {sum(1 for x in fd if x[2] == 0)}, gone {sum(1 for x in fd if x[3] == 0)}")
    for x in fd[:n]:
        print(f"  {x[0]:+7d}  {x[1]} ({where[x[1]]})  {x[2]:#x} -> {x[3]:#x}")
    print("  shrunk most:")
    for x in fd[-8:]:
        print(f"  {x[0]:+7d}  {x[1]} ({where[x[1]]})  {x[2]:#x} -> {x[3]:#x}")


def growth(old, new, module, n=25):
    def table(path):
        sizes, where, section = collections.Counter(), {}, {}
        for address, size, sec, name, obj, m in parse(path, module):
            if size == 0 or name.startswith(("$", ".")):
                continue
            name = "@anon" if name.startswith("@") else re.sub(r"\$\d+$", "$", name)
            sizes[name] += size
            where[name], section[name] = obj, sec
        return sizes, where, section
    o, wo, so = table(old)
    nw, wn, sn = table(new)
    grown = sorted(((nw[k] - o[k], k) for k in nw if k in o and nw[k] != o[k]), reverse=True)
    added = sorted(((nw[k], k) for k in nw if k not in o), reverse=True)
    gone = sorted(((o[k], k) for k in o if k not in nw), reverse=True)
    print(f"{module}: symbol bytes {sum(o.values()):#x} -> {sum(nw.values()):#x}; grown/shrunk retail symbols "
          f"{sum(x for x, _ in grown):+#x} ({len(grown)}), new symbols {sum(x for x, _ in added):+#x} ({len(added)}), "
          f"gone {-sum(x for x, _ in gone):+#x} ({len(gone)})")
    bysec = collections.Counter()
    for s, k in added:
        bysec[sn[k]] += s
    print("  new by section:", {k: hex(v) for k, v in bysec.items()})
    net = collections.Counter()
    for s, k in added + grown:
        net[wn[k]] += s
    for s, k in gone:
        net[wo[k]] -= s
    print("  net growth by object (functions, new+grown-gone):")
    for k, v in net.most_common(12):
        print(f"    {v:+#8x} {k}")
    print("  most grown:")
    for x, k in grown[:n]:
        print(f"    {x:+#7x} {k} ({wn[k]}) {o[k]:#x}->{nw[k]:#x}")
    print("  biggest new:")
    for x, k in added[:n]:
        print(f"    {x:#7x} {k} ({wn[k]}, {sn[k]})")
    if gone:
        print("  gone:", ", ".join(f"{k} {x:#x}" for x, k in gone[:10]))


def main():
    commands = {"objects": (objects, 2), "diff": (diff, 3), "growth": (growth, 3)}
    if len(sys.argv) < 2 or sys.argv[1] not in commands or len(sys.argv) - 2 < commands[sys.argv[1]][1]:
        sys.exit(__doc__)
    run, fixed = commands[sys.argv[1]]
    args = sys.argv[2:]
    run(*args[:fixed], *[int(a) for a in args[fixed:fixed + 1]])


if __name__ == "__main__":
    main()
