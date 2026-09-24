#!/usr/bin/env python3
"""Cut a data label out of an asm file's .rodata/.data and move what follows
it to a new file, so a C object can be linked between the two.

usage: datasplit.py FILE LABEL NEXT_LABEL NEWFILE

FILE keeps everything before LABEL; the lines from LABEL up to NEXT_LABEL are
printed (they go to C); NEWFILE gets NEXT_LABEL to the end, under the
section directive in force at NEXT_LABEL.  Both files get a .public for every
label one defines and the other references.
"""
import re
import sys

if len(sys.argv) != 5:
    sys.exit(__doc__)
src, label, nxt, newfile = sys.argv[1:5]
lines = open(src).read().split('\n')
a = next(i for i, l in enumerate(lines) if l.startswith(label + ':'))
b = next(i for i, l in enumerate(lines) if l.startswith(nxt + ':'))
# the section in force at b
section = None
for l in lines[:b]:
    m = re.match(r'\s*\.(text|rodata|data|bss)\s*$', l)
    if m:
        section = m.group(1)
first = next(i for i, l in enumerate(lines) if re.match(r'\s*\.(text|rodata|data|bss)\s*$', l))
header = lines[:first]
A = lines[first:a]
cut = lines[a:b]
B = ['\t.' + section, ''] + lines[b:]
# a .global / .size for the cut label sitting just before it stays in A: drop
while A and (A[-1].strip() == '' or re.match(r'\s*\.(global|size)\s+' + re.escape(label) + r'\b', A[-1])):
    A.pop()

label_re = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*):')
tok_re = re.compile(r'[A-Za-z_][A-Za-z0-9_]*')


def defined(part):
    return {m.group(1) for l in part for m in [label_re.match(l)] if m}


def referenced(part):
    r = set()
    for l in part:
        code = l.split(';')[0]
        m = re.match(r'\s*(?:[A-Za-z_][A-Za-z0-9_]*:)?\s*(b[a-z]*|\.word|\.4byte|\.long|\.short)\s+(.*)', code)
        if m:
            r.update(tok_re.findall(m.group(2)))
    return r


dA, dB = defined(A), defined(B)
ab = sorted(referenced(A) & dB)  # A uses B's
ba = sorted(referenced(B) & dA)  # B uses A's
cross = sorted(set(ab) | set(ba))
open(src, 'w').write('\n'.join(header + ['.public ' + n for n in cross] + [''] + A).rstrip('\n') + '\n')
open(newfile, 'w').write('\n'.join(header + ['.public ' + n for n in cross] + [''] + B).rstrip('\n') + '\n')
print('A uses B:', len(ab), 'B uses A:', len(ba))
print('cut uses:', sorted(referenced(cut)))
print('\n'.join(cut[:3]), '...', '\n'.join(cut[-2:]))
