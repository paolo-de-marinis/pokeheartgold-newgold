#!/usr/bin/env python3
"""The party of the game running in melonDS: species, level, experience, HP, item.

    party.py [ELF]

Read out of the save block the field keeps in main RAM, decrypted the way the
game does it (savedit.py has the cipher and the block order), so the numbers
are the ones the game is using. Experience is what the level cap acts on: a
Pokemon at the cap is held at the cap's threshold, one above it keeps what it
wins and does not level.
"""
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import savedit  # noqa: E402
import where  # noqa: E402
from live import main_ram  # noqa: E402
from markers import DIAG_ELF, MAIN_RAM  # noqa: E402

ROOT = where.ROOT
BLOCK_A_SIZE = 32


def party(ram, elf):
    memory = where.Memory(ram)
    field = memory.word(where.symbol("sFieldSysPtr", elf))
    if not field:
        raise SystemExit("the field is down; the party is read through it")
    save = memory.word(field + where.SAVE_DATA)
    page = where.constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
    sector = where.constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")
    headers = save + where.DYNAMIC_REGION + page * sector + 4
    offset = memory.word(headers + where.SAVE_PARTY * where.HEADER_SIZE + where.HEADER_OFFSET)
    base = save + where.DYNAMIC_REGION + offset
    count = memory.word(base + where.PARTY_COUNT)
    names = {v: k[len("SPECIES_"):] for k, v in savedit.species_numbers().items()}
    items = {int(m.group(2)): m.group(1)[len("ITEM_"):] for m in
             re.finditer(r"^#define (ITEM_[A-Z0-9_]+)\s+(\d+)\s*$", (ROOT / "include/constants/items.h").read_text(), re.M)}
    out = []
    for slot in range(count):
        mon = base + 8 + slot * savedit.PARTY_MON - MAIN_RAM
        raw = ram[mon:mon + savedit.PARTY_MON]
        personality, checksum = struct.unpack_from("<IxxH", raw, 0)
        blocks = savedit.mon_crypt(bytes(raw[8:8 + 4 * BLOCK_A_SIZE]), checksum)
        first = savedit.shuffle_order(personality)[0] * BLOCK_A_SIZE
        species, item, _, exp = struct.unpack_from("<HHII", blocks, first)
        stats = savedit.mon_crypt(bytes(raw[savedit.BOX_MON:]), personality)
        level, _, hp, max_hp = struct.unpack_from("<BBHH", stats, 4)
        out.append(f"{slot + 1}. {names.get(species, species)} L{level} exp {exp} HP {hp}/{max_hp}"
                   + (f" holding {items.get(item, item)}" if item else ""))
    return out


def main():
    elf = Path(sys.argv[1]) if len(sys.argv) > 1 else DIAG_ELF
    print("\n".join(party(main_ram(), elf)))


if __name__ == "__main__":
    main()
