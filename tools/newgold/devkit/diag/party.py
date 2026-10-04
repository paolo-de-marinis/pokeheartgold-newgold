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
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import savedit  # noqa: E402
import where  # noqa: E402
from live import main_ram  # noqa: E402
from markers import DIAG_ELF, MAIN_RAM  # noqa: E402

ROOT = where.ROOT
BLOCK_A_SIZE = 32
SAVE_PLAYERDATA = 1  # the block table's order, save_budget.py and savedit.py --show


def block(memory, elf, index):
    """Where save block `index` sits in the RAM copy the field keeps."""
    field = memory.word(where.symbol("sFieldSysPtr", elf))
    if not field:
        raise SystemExit("the field is down; the save is read through it")
    save = memory.word(field + where.SAVE_DATA)
    page = where.constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
    sector = where.constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")
    headers = save + where.DYNAMIC_REGION + page * sector + 4
    offset = memory.word(headers + index * where.HEADER_SIZE + where.HEADER_OFFSET)
    return save + where.DYNAMIC_REGION + offset


def badges(ram, elf):
    """The Johto badges the player holds, as a count: one bit each, packed
    the way savedit.py --badges writes them."""
    at = block(where.Memory(ram), elf, SAVE_PLAYERDATA) + savedit.JOHTO_BADGES - MAIN_RAM
    return bin(ram[at]).count("1")


def sealed(raw):
    """Whether a Pokemon's bytes are as the game leaves them between uses:
    neither half marked decrypted, and the checksum the box half's words
    add up to. A frame can end while the game is decrypting one in place
    (AcquireMonLock) or encrypting it again (ReleaseMonLock); read then, a
    level-13 Shinx after Falkner's battle came out as species 2142."""
    personality, flags, checksum = struct.unpack_from("<IHH", raw, 0)
    words = struct.unpack("<64H", savedit.mon_crypt(bytes(raw[8:8 + 4 * BLOCK_A_SIZE]), checksum))
    return not flags & 3 and sum(words) & 0xFFFF == checksum


def mons(ram, elf):
    """The party as the game holds it, each Pokemon in its order: species,
    item, exp, level, hp, maxHp, its four moves and their PP, its other
    stats, ability and status, whether it is an egg, and whether it was
    sealed (above)."""
    memory = where.Memory(ram)
    base = block(memory, elf, where.SAVE_PARTY)
    out = []
    for slot in range(memory.word(base + where.PARTY_COUNT)):
        mon = base + 8 + slot * savedit.PARTY_MON - MAIN_RAM
        raw = ram[mon:mon + savedit.PARTY_MON]
        personality, checksum = struct.unpack_from("<IxxH", raw, 0)
        blocks = savedit.mon_crypt(bytes(raw[8:8 + 4 * BLOCK_A_SIZE]), checksum)
        first = savedit.shuffle_order(personality)[0] * BLOCK_A_SIZE
        species, item, _, exp, _, ability = struct.unpack_from("<HHIIBB", blocks, first)
        second = savedit.shuffle_order(personality)[1] * BLOCK_A_SIZE
        moves, pp = list(struct.unpack_from("<4H", blocks, second)), list(blocks[second + 8:second + 12])
        egg = struct.unpack_from("<I", blocks, second + 0x10)[0] >> 30 & 1     # PokemonDataBlockB.isEgg
        stats = savedit.mon_crypt(bytes(raw[savedit.BOX_MON:]), personality)
        status, level, _, hp, max_hp, *rest = struct.unpack_from("<IBBHHHHHHH", stats, 0)
        a, b = (blocks[savedit.shuffle_order(personality)[i] * BLOCK_A_SIZE:][:BLOCK_A_SIZE] for i in (0, 1))
        ivword = struct.unpack_from("<I", b, 0x10)[0]
        # NewGold keeps the ability's ninth bit in experience's top bit (PokemonDataBlockA).
        out.append({"species": species, "item": item, "exp": exp, "level": level, "hp": hp, "maxHp": max_hp,
                    "moves": moves, "pp": pp, "ability": ability | (exp >> 31) << 8, "status": status, "egg": egg,
                    "sealed": sealed(raw),
                    # the stats in STAT_* order after HP, the EVs and IVs in the record's, and
                    # Hyper Training's bits as a mask, bit 0 STAT_HP's (savedit.hyper_trained)
                    **dict(zip(("atk", "def", "speed", "spatk", "spdef"), rest)),
                    "evs": list(a[0x10:0x16]), "ivs": [(ivword >> (5 * i)) & 0x1F for i in range(6)],
                    "hyper": sum(1 << i for i, on in enumerate(savedit.hyper_trained(b)) if on)})
    return out


def sealed_mons(core, elf, hooks=(), frames=60):
    """mons() of a running core once every Pokemon is sealed: read again a
    frame later while one is not, `frames` at most. scene.py's party
    expectations and gym.py's closing list read the party this way."""
    out = mons(core.ram(), elf)
    for _ in range(frames):
        if all(m["sealed"] for m in out):
            break
        core.step(1, hooks)
        out = mons(core.ram(), elf)
    return out


def bag(ram, elf, item):
    """How many of `item` the bag holds, in whichever pocket."""
    memory = where.Memory(ram)
    at = block(memory, elf, savedit.block_ids().index("SAVE_BAG")) - MAIN_RAM
    for pocket in savedit.pockets():
        for slot in range(pocket["slots"]):
            got, quantity = struct.unpack_from("<HH", ram, at + pocket["at"] + 4 * slot)
            if got == item:
                return quantity
    return 0


def party(ram, elf, found=None):
    """The party as lines, from `found` (sealed_mons) or read from `ram`
    once; a Pokemon caught mid-encryption is said to be."""
    names = {v: k for k, v in savedit.species_numbers().items()}
    items = {int(m.group(2)): m.group(1)[len("ITEM_"):] for m in
             re.finditer(r"^#define (ITEM_[A-Z0-9_]+)\s+(\d+)\s*$", (ROOT / "include/constants/items.h").read_text(), re.M)}
    return [f"{slot + 1}. {names.get(m['species'], m['species'])} L{m['level']} exp {m['exp']} HP {m['hp']}/{m['maxHp']}"
            + (f" holding {items.get(m['item'], m['item'])}" if m["item"] else "")
            + ("" if m["sealed"] else " (read mid-encryption)")
            for slot, m in enumerate(found if found is not None else mons(ram, elf))]


def main():
    elf = Path(sys.argv[1]) if len(sys.argv) > 1 else DIAG_ELF
    print("\n".join(party(main_ram(), elf)))


if __name__ == "__main__":
    main()
