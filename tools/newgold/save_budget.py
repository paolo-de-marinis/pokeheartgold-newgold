#!/usr/bin/env python3
"""Measure what the save's general region holds, against what it can hold.

Every block of the save is sized by a function that returns one sizeof, and the
game adds them up at boot and asserts the total fits. Nothing checks it when
the ROM is built, so a struct that grows past the region — widening the Dex,
adding boxes — shows up as an assertion on a real save file and nowhere else.

The sizes are read back out of the built ROM rather than recomputed: each
Save_*_sizeof is two or three Thumb instructions returning a constant, so the
answer here is the one the game will use.

Usage: save_budget.py [BUILD_DIR]
"""

import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ARRAYS = ROOT / "src/save_arrays.c"
MAIN_BASE = 0x02000000

SAVE_PAGE_MAX = 35
SAVE_SECTOR_SIZE = 0x1000
REGION = SAVE_PAGE_MAX * SAVE_SECTOR_SIZE


def size_functions():
    """The blocks of the general region, in order, then the extra chunks.

    gExtraSaveChunkHeaders lives past the region and is not counted against it.
    """
    text = ARRAYS.read_text()
    cut = text.index("gExtraSaveChunkHeaders")
    inside = re.findall(r"\(SAVESIZEFN\)([A-Za-z_0-9]+)", text[:cut])
    outside = re.findall(r"\(SAVESIZEFN\)([A-Za-z_0-9]+)", text[cut:])
    return inside, outside


def symbols(elf):
    b = elf.read_bytes()
    shoff, = struct.unpack("<I", b[0x20:0x24])
    shentsize, shnum, shstrndx = struct.unpack("<HHH", b[0x2E:0x34])
    def header(i):
        o = shoff + i * shentsize
        return struct.unpack("<IIIIIIIIII", b[o:o + 40])
    names = header(shstrndx)[4]
    sections = {}
    for i in range(shnum):
        fields = header(i)
        end = b.index(b"\0", names + fields[0])
        sections[b[names + fields[0]:end].decode()] = fields
    symtab, strtab = sections[".symtab"], sections[".strtab"]
    symbol_offset, symbol_size = symtab[4], symtab[5]
    string_offset = strtab[4]
    found = {}
    for i in range(symbol_size // 16):
        o = symbol_offset + i * 16
        name, value = struct.unpack("<II", b[o:o + 8])
        end = b.index(b"\0", string_offset + name)
        found.setdefault(b[string_offset + name:end].decode(), value)
    return found


def constant(code, address, read):
    """The value a two-instruction "return sizeof(x)" hands back."""
    halves = struct.unpack("<8H", code)
    if (halves[0] & 0xF800) == 0x2000:  # mov r0, #imm8
        value = halves[0] & 0xFF
        if (halves[1] & 0xF800) == 0x0000 and halves[1]:  # lsl r0, r0, #imm5
            value <<= (halves[1] >> 6) & 0x1F
        return value
    if (halves[0] & 0xF800) == 0x4800:  # ldr r0, [pc, #imm]
        pool = ((address + 4) & ~3) + ((halves[0] & 0xFF) << 2)
        word = read(pool, 4)
        if word:
            return struct.unpack("<I", word)[0]
    return None


def measure(build):
    binary = (build / "main.sbin").read_bytes()
    found = symbols(build / "main.elf")

    def read(address, count):
        offset = address - MAIN_BASE
        return binary[offset:offset + count] if 0 <= offset < len(binary) else None

    def sizeof(name):
        address = found.get(name)
        if address is None:
            raise SystemExit(f"{name} is not in the ROM")
        code = read(address & ~1, 16)
        value = constant(code, address & ~1, read) if code else None
        if value is None:
            raise SystemExit(f"{name} does not return a constant")
        return value

    inside, outside = size_functions()
    return ([(name, sizeof(name)) for name in inside],
            [(name, sizeof(name)) for name in outside])


def main():
    build = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "build/heartgold.us"
    inside, outside = measure(build)
    for name, size in inside:
        print(f"  {name:40s} {size:7d}")
    total = sum(size for _, size in inside)
    print(f"\n  {'general region':40s} {total:7d} of {REGION} bytes, {REGION - total} free")
    print(f"  {'extra chunks, past the region':40s} {sum(s for _, s in outside):7d}")
    if total > REGION:
        raise SystemExit("the save does not fit")


if __name__ == "__main__":
    main()
