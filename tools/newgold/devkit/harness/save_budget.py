#!/usr/bin/env python3
"""Measure what the save holds against what it can hold.

Every block of the save is sized by a function that returns one sizeof. The
game adds them up at boot, packs them into the region, pages them, and asserts
twice that the result fits. Nothing checks any of it when the ROM is built, so
a struct that grows past the region — a wider Dex, more boxes — shows up as an
assertion on a real save file and nowhere else.

The sizes are read back out of the built ROM rather than recomputed: each
Save_*_sizeof is two or three Thumb instructions returning a constant, so the
answer here is the one the game will use. The packing repeats what
SaveData_InitSubstructs and SaveData_InitSlotSpecs do, for the same reason.

Usage: save_budget.py [BUILD_DIR]
"""

import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
ARRAYS = ROOT / "src/save_arrays.c"
MAIN_BASE = 0x02000000

def _constant(name, default):
    text = (ROOT / "include/constants/save_arrays.h").read_text()
    match = re.search(rf"#define {name}\s+(0x[0-9A-Fa-f]+|\d+)", text)
    return int(match.group(1), 0) if match else default


SAVE_PAGE_MAX = _constant("SAVE_PAGE_MAX", 35)
SAVE_SECTOR_SIZE = _constant("SAVE_SECTOR_SIZE", 0x1000)
REGION = SAVE_PAGE_MAX * SAVE_SECTOR_SIZE
FOOTER = 16  # sizeof(struct SaveChunkFooter)
CRC = 4      # every chunk carries one past its own size
# The flash is erased in two halves of sixty-four sectors, so that is the
# ceiling the pages below have to stay under.
PAGES_PER_HALF = 64

ENTRY = re.compile(r"\{\s*(\w+),\s*([^,]+?),\s*\(SAVESIZEFN\)(\w+),", re.S)


def chunks():
    """The region's blocks in order, then the chunks written past it.

    Each entry gives which slot it belongs to — the save proper or the boxes —
    because the two are paged separately.
    """
    text = ARRAYS.read_text()
    cut = text.index("gExtraSaveChunkHeaders")
    inside = [(m.group(3), m.group(2).strip()) for m in ENTRY.finditer(text[:cut])]
    outside = [(m.group(3), m.group(2).strip()) for m in ENTRY.finditer(text[cut:])]
    return inside, outside


def page_offset(expression):
    """`SAVE_PAGE_MAX`, or `SAVE_PAGE_MAX + n`, as a number of pages past it."""
    match = re.fullmatch(r"SAVE_PAGE_MAX(?:\s*\+\s*(\d+))?", expression)
    if not match:
        raise SystemExit(f"an extra chunk sits at {expression!r}, which this does not read")
    return int(match.group(1) or 0)


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
    found = {}
    for i in range(symtab[5] // 16):
        o = symtab[4] + i * 16
        name, value = struct.unpack("<II", b[o:o + 8])
        end = b.index(b"\0", strtab[4] + name)
        found.setdefault(b[strtab[4] + name:end].decode(), value)
    return found


def constant(code, address, read):
    """The value a "return sizeof(x)" of two or three instructions hands back."""
    halves = struct.unpack("<8H", code)
    if (halves[0] & 0xF800) == 0x2000:  # mov r0, #imm8
        value = halves[0] & 0xFF
        if (halves[1] & 0xF800) == 0x0000 and halves[1]:  # lsl r0, r0, #imm5
            value <<= (halves[1] >> 6) & 0x1F
        return value
    if (halves[0] & 0xF800) == 0x4800:  # ldr r0, [pc, #imm]
        word = read(((address + 4) & ~3) + ((halves[0] & 0xFF) << 2), 4)
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

    inside, outside = chunks()
    return ([(name, sizeof(name), slot) for name, slot in inside],
            [(name, sizeof(name), page_offset(where)) for name, where in outside])


def layout(inside, outside):
    """What the game works out at boot: bytes in the region, then pages."""
    region, slots, order = 0, {}, []
    for index, (name, size, slot) in enumerate(inside):
        chunk = ((size + 3) & ~3) + CRC
        if slot not in slots:
            slots[slot] = 0
            order.append(slot)
        slots[slot] += chunk
        region += chunk
        last = index == len(inside) - 1
        if last or slot != inside[index + 1][2]:
            region += FOOTER
            if not last and region % 0x100:
                region += 0x100 - region % 0x100

    pages = [((slots[slot] + FOOTER + SAVE_SECTOR_SIZE - 1) // SAVE_SECTOR_SIZE, slot)
             for slot in order]
    highest = sum(count for count, _ in pages)
    for name, size, offset in outside:
        highest = max(highest, SAVE_PAGE_MAX + offset
                      + (size + SAVE_SECTOR_SIZE - 1) // SAVE_SECTOR_SIZE)
    return region, pages, highest


def main():
    build = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "build/heartgold.us"
    inside, outside = measure(build)
    for name, size, slot in inside:
        print(f"  {slot:<24s} {name:40s} {size:7d}")
    region, pages, highest = layout(inside, outside)
    print()
    print(f"  region        {region:7d} of {REGION} bytes, {REGION - region} free")
    for count, slot in pages:
        print(f"  {slot:<24s} {count:3d} pages")
    print(f"  pages used    {sum(c for c, _ in pages):3d} of {SAVE_PAGE_MAX} (SAVE_PAGE_MAX)")
    print(f"  highest page  {highest:3d} of {PAGES_PER_HALF} in the flash half, "
          f"{PAGES_PER_HALF - highest} free")
    if region > REGION or sum(c for c, _ in pages) > SAVE_PAGE_MAX:
        raise SystemExit("the save does not fit its region")
    if highest > PAGES_PER_HALF:
        raise SystemExit("the save does not fit the flash")


if __name__ == "__main__":
    main()
