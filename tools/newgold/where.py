#!/usr/bin/env python3
"""Read where the player is, and what is in the party, out of a memory dump.

Aiming a scripted walk by eye does not work: the camera moves with the player,
so a screenshot says where things sit relative to each other and never where
the player is. Searching memory for a number that moves with them does not
settle either — what turns up responds to both directions, which is a counter
or the camera.

The answer is already in this repository. sFieldSysPtr is a real symbol in the
built ROM, and the three structs between it and the player's tile are
decompiled, so the walk is:

    sFieldSysPtr -> FieldSystem.playerAvatar -> PlayerAvatar.mapObject
                 -> LocalMapObject.currentX, .currentZ

and the party is the save block beside it. Nothing here is a guessed address:
the one address is looked up in main.elf and every offset is a field this
repository declares.

Usage: where.py DUMP... (dumps come from boot_check's ram: action)
"""

import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MAIN_RAM = 0x02000000

# FieldSystem, PlayerAvatar, LocalMapObject, PartyCore, SaveData: every one of
# these is a field this repository declares, counted from its own header.
PLAYER_AVATAR = 0x40   # FieldSystem.playerAvatar
SAVE_DATA = 0x0C       # FieldSystem.saveData
MAP_OBJECT = 0x30      # PlayerAvatar.mapObject
CURRENT_X = 0x64       # LocalMapObject.currentX
CURRENT_Z = 0x6C       # LocalMapObject.currentZ
DYNAMIC_REGION = 0x10  # SaveData.dynamic_region
HEADER_SIZE = 0x10     # sizeof(struct SaveArrayHeader)
HEADER_OFFSET = 8      # SaveArrayHeader.offset
PARTY_COUNT = 4        # PartyCore.curCount
SAVE_PARTY = 2


def constant(name, header):
    match = re.search(rf"#define {name}\s+(0x[0-9A-Fa-f]+|\d+)", (ROOT / header).read_text())
    if not match:
        raise SystemExit(f"{name} is not in {header}")
    return int(match.group(1), 0)


def symbol(name, elf=None):
    """Where the linker put it, so nothing here is a guessed address."""
    b = (elf or ROOT / "build/heartgold.us/main.elf").read_bytes()
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
    for i in range(symtab[5] // 16):
        o = symtab[4] + i * 16
        nm, value = struct.unpack("<II", b[o:o + 8])
        end = b.index(b"\0", strtab[4] + nm)
        if b[strtab[4] + nm:end].decode() == name:
            return value
    raise SystemExit(f"{name} is not in the ROM")


class Memory:
    def __init__(self, path):
        self.ram = Path(path).read_bytes()

    def word(self, address):
        offset = address - MAIN_RAM
        if not 0 <= offset < len(self.ram) - 4:
            return None
        return struct.unpack_from("<I", self.ram, offset)[0]

    def chain(self, *steps):
        address = steps[0]
        for step in steps[1:]:
            address = self.word(address)
            if not address:
                return None
            address += step
        return self.word(address)


def look(path, field_sys_ptr, page_max, sector):
    memory = Memory(path)
    field = memory.word(field_sys_ptr)
    if not field:
        return None
    avatar = memory.word(field + PLAYER_AVATAR)
    obj = memory.word(avatar + MAP_OBJECT) if avatar else None
    where = (memory.word(obj + CURRENT_X), memory.word(obj + CURRENT_Z)) if obj else None

    save = memory.word(field + SAVE_DATA)
    party = None
    if save:
        headers = save + DYNAMIC_REGION + page_max * sector + 4
        offset = memory.word(headers + SAVE_PARTY * HEADER_SIZE + HEADER_OFFSET)
        if offset is not None:
            party = memory.word(save + DYNAMIC_REGION + offset + PARTY_COUNT)
    return where, party


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__.strip().splitlines()[-1])
    field_sys_ptr = symbol("sFieldSysPtr")
    page_max = constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
    sector = constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")
    for path in sys.argv[1:]:
        result = look(path, field_sys_ptr, page_max, sector)
        if result is None:
            print(f"{path}: the field system is not up")
            continue
        where, party = result
        print(f"{path}: at {where}, party {party}")


if __name__ == "__main__":
    main()
