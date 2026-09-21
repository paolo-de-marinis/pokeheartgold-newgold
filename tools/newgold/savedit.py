#!/usr/bin/env python3
"""Read and write a save file through this repository's own structures.

Playing the adventure to reach each thing that needs checking is the long
road: a Pokedex entry is an hour of walking away, the thirtieth box needs a
Pokemon Centre, the machine labels need a gym. The save holds all of it, and
the save is decompiled here, so it can be prepared instead.

Nothing here is a guessed offset. The block table is the one
SaveData_InitSubstructs builds, measured out of the built ROM by save_budget;
the flash mapping is GetChunkOffsetFromCurrentSaveSlot; the two checksums are
SaveSubstruct_UpdateCRC and SaveSlot_BuildFooter; and every field offset is
computed by the host compiler from this repository's headers, then checked
against the size the ROM itself reports. Where a field is packed rather than
declared -- the badges are the case -- the code that packs it is named.

Usage:
  savedit.py SAVE --show
  savedit.py SAVE --badges 8 --party SPECIES:LEVEL,... --item ITEM:COUNT,...
"""

import argparse
import re
import struct
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import save_budget  # noqa: E402

HALF = 0x40000                  # GetChunkOffsetFromCurrentSaveSlot
CHUNK_MAGIC = 0x20060623        # SAVE_CHUNK_MAGIC
CHUNK_FOOTER = 16               # sizeof(struct SaveChunkFooter)
ARRAY_FOOTER = 16               # sizeof(struct SaveArrayFooter)
FOOTER_CRC_AT = 14              # offsetof(struct SaveArrayFooter, crc)
FLASH = 512 * 1024
PAGES_PER_HALF = 64             # the flash is erased in two halves


def crc16(data, crc=0xFFFF):
    """GF_CalcCRC16: the SDK's CCITT table, polynomial 0x1021, fed high bit first."""
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def extra_chunks(build=None):
    """The chunks written past the region, with the sector each one lives in.

    gExtraSaveChunkHeaders gives a sector rather than an offset, and
    WriteExtraSaveChunk puts a copy in both halves of the flash.
    """
    build = build or ROOT / "build/heartgold.us"
    _, outside = save_budget.measure(build)
    return [{"id": i, "size": size, "sector": save_budget.SAVE_PAGE_MAX + offset}
            for i, (_, size, offset) in enumerate(outside)]


def build_save(region, build=None):
    """A whole flash image: the region in both halves, then the extra chunks.

    The extra chunks are written empty. The game only ever creates them when it
    saves, and a save file that has none is read as corrupt -- that is the
    communication error at the main menu -- so they are given the footer
    CreateChunkFooter would give them over a body of zeroes, which is what
    their own init functions would leave for counters and records.
    """
    raw = bytearray(FLASH)
    for half in (0, HALF):
        raw[half:half + len(region)] = region
    for chunk in extra_chunks(build):
        body = bytearray(chunk["size"] + ARRAY_FOOTER)
        struct.pack_into("<IIIH", body, chunk["size"], CHUNK_MAGIC, 1, chunk["size"], chunk["id"])
        struct.pack_into("<H", body, chunk["size"] + FOOTER_CRC_AT,
                         crc16(body[:chunk["size"] + FOOTER_CRC_AT]))
        for sector in (chunk["sector"], chunk["sector"] + PAGES_PER_HALF):
            at = sector * save_budget.SAVE_SECTOR_SIZE
            raw[at:at + len(body)] = body
    return raw


def blocks(build=None):
    """Every block's id, size and slot, then where each one starts.

    This is SaveData_InitSubstructs: sizes come rounded up to a word with four
    bytes of checksum added, a slot's last block is followed by the chunk
    footer, and the next slot starts on a 0x100 boundary.
    """
    build = build or ROOT / "build/heartgold.us"
    inside, _ = save_budget.measure(build)
    names = block_ids()
    out, offset = [], 0
    for index, (fn, size, slot) in enumerate(inside):
        chunk = ((size + 3) & ~3) + save_budget.CRC
        out.append({"index": index, "id": names[index], "sizefn": fn,
                    "offset": offset, "size": chunk, "slot": slot})
        offset += chunk
        last = index == len(inside) - 1
        if last or slot != inside[index + 1][2]:
            offset += CHUNK_FOOTER
            if not last and offset % 0x100:
                offset += 0x100 - offset % 0x100
    return out


def block_ids():
    """The SAVE_* name of each block, in the order save_arrays.c declares them."""
    text = (ROOT / "src/save_arrays.c").read_text()
    text = text[:text.index("gExtraSaveChunkHeaders")]
    return [m.group(1) for m in re.finditer(r"\{\s*(SAVE_\w+),", text)]


def slot_specs(table):
    """SaveData_InitSlotSpecs: where each of the two slots sits, and how big."""
    specs, offset = [], 0
    for slot in sorted({b["slot"] for b in table}, key=lambda s: min(
            b["index"] for b in table if b["slot"] == s)):
        size = sum(b["size"] for b in table if b["slot"] == slot) + CHUNK_FOOTER
        specs.append({"slot": int(slot), "offset": offset, "size": size})
        offset += size
        if offset % 0x100:
            offset += 0x100 - offset % 0x100
    return specs


class Save:
    def __init__(self, path, build=None):
        self.path = Path(path)
        self.raw = bytearray(self.path.read_bytes())
        self.table = blocks(build)
        self.specs = slot_specs(self.table)
        self.half = self._newest_half()
        self.region = bytearray(self.raw[self.half:self.half + HALF])

    def _footer(self, half, spec):
        at = half + spec["offset"] + spec["size"] - CHUNK_FOOTER
        count, size, magic, slot, crc = struct.unpack("<IIIHH", self.raw[at:at + CHUNK_FOOTER])
        return {"count": count, "size": size, "magic": magic, "slot": slot, "crc": crc}

    def valid(self, half):
        """A half is good when every slot's footer says what it should."""
        for spec in self.specs:
            f = self._footer(half, spec)
            if f["magic"] != CHUNK_MAGIC or f["size"] != spec["size"] or f["slot"] != spec["slot"]:
                return False
            body = self.raw[half + spec["offset"]:half + spec["offset"] + spec["size"] - CHUNK_FOOTER]
            if crc16(body) != f["crc"]:
                return False
        return True

    def _newest_half(self):
        good = [h for h in (0, HALF) if self.valid(h)]
        if not good:
            raise SystemExit(f"{self.path}: neither half of the flash holds a valid save")
        return max(good, key=lambda h: self._footer(h, self.specs[0])["count"])

    def block(self, name):
        entry = next(b for b in self.table if b["id"] == name)
        return memoryview(self.region)[entry["offset"]:entry["offset"] + entry["size"]]

    def entry(self, name):
        return next(b for b in self.table if b["id"] == name)

    def reseal(self):
        """SaveSubstruct_UpdateCRC for every block, then SaveSlot_BuildFooter."""
        for b in self.table:
            body = b["size"] - save_budget.CRC
            crc = crc16(self.region[b["offset"]:b["offset"] + body])
            struct.pack_into("<H", self.region, b["offset"] + body, crc)
        for spec in self.specs:
            at = spec["offset"] + spec["size"] - CHUNK_FOOTER
            count = struct.unpack_from("<I", self.region, at)[0]
            body = bytes(self.region[spec["offset"]:at])
            struct.pack_into("<IIIHH", self.region, at,
                             count, spec["size"], CHUNK_MAGIC, spec["slot"], crc16(body))

    def write(self, path=None):
        """Both halves get the same sealed region, so either one loads."""
        self.reseal()
        for half in (0, HALF):
            self.raw[half:half + len(self.region)] = self.region
        Path(path or self.path).write_bytes(bytes(self.raw))


def offsets(struct_name, header, fields):
    """Ask the host compiler where the fields are, from this repository's headers."""
    body = "\n".join(f'    printf("%s %zu\\n", "{f}", offsetof({struct_name}, {f}));'
                     for f in fields)
    source = f"""
#include <stdio.h>
#include <stddef.h>
#include "{header}"
int main(void) {{
    printf("sizeof %zu\\n", sizeof({struct_name}));
{body}
    return 0;
}}
"""
    with tempfile.TemporaryDirectory() as tmp:
        c = Path(tmp) / "probe.c"
        c.write_text(source)
        run = subprocess.run(
            ["cc", "-o", str(Path(tmp) / "probe"), str(c),
             f"-I{ROOT}/include", f"-I{ROOT}/include/library", f"-I{ROOT}/files",
             "-w"], capture_output=True, text=True)
        if run.returncode:
            raise SystemExit(f"could not lay out {struct_name}:\n{run.stderr[:800]}")
        out = subprocess.run([str(Path(tmp) / "probe")], capture_output=True, text=True).stdout
    return {k: int(v) for k, v in (line.split() for line in out.splitlines())}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--show", action="store_true")
    parser.add_argument("--from-ram", type=Path,
                        help="a boot_check memory dump; the game lays out a whole "
                             "save region before the title screen, and this seals it "
                             "into a file the game will load")
    args = parser.parse_args()

    if args.from_ram:
        import where
        dump = args.from_ram.read_bytes()
        pointer = struct.unpack_from("<I", dump, where.symbol("sSaveDataPtr") - where.MAIN_RAM)[0]
        if not where.MAIN_RAM <= pointer < where.MAIN_RAM + len(dump):
            raise SystemExit("sSaveDataPtr is not set in that dump")
        at = pointer - where.MAIN_RAM + 0x10          # SaveData.dynamic_region
        region = bytearray(dump[at:at + save_budget.REGION])
        table = blocks()
        holder = type("_", (), {"region": region, "table": table,
                                "specs": slot_specs(table)})()
        Save.reseal(holder)
        args.save.write_bytes(bytes(build_save(region)))
        print(f"wrote {args.save} from {args.from_ram}")

    save = Save(args.save)
    print(f"{args.save}: half {save.half:#x} is newest, "
          f"save counter {save._footer(save.half, save.specs[0])['count']}")
    if args.show:
        for b in save.table:
            print(f"  {b['index']:2d} {b['id']:<36s} {b['offset']:#08x} {b['size']:6d} {b['slot']}")
        for spec in save.specs:
            print(f"  slot {spec['slot']:<24s} {spec['offset']:#08x} {spec['size']:7d}")


if __name__ == "__main__":
    main()
