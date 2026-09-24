#!/usr/bin/env python3
"""A heap's blocks in a RAM dump: its used blocks biggest first, with their
first bytes, and its free blocks.

    heapblocks.py DUMP [--heap 37] [--min 1000] [--elf ELF]

DUMP is main memory from 0x02000000 (a harness 'ram:' action, core.ram()).
The heap is found as the game finds it, through sHeapInfo's handle table
(the ELF says where that is; the debug build's by default); its NNS
expanded heap is walked by its used and free lists. 37 is the Pokedex's
heap (HEAP_ID_POKEDEX_APP): an allocation that fails in it starts here.
"""
import argparse
import struct
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import where  # noqa: E402
from markers import DIAG_ELF, MAIN_RAM  # noqa: E402


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("dump", type=Path)
    parser.add_argument("--heap", type=int, default=37)
    parser.add_argument("--min", type=int, default=1000, help="list used blocks from this size up")
    parser.add_argument("--elf", type=Path, default=DIAG_ELF)
    args = parser.parse_args()
    ram = args.dump.read_bytes()
    u32 = lambda a: struct.unpack_from("<I", ram, a - MAIN_RAM)[0]  # noqa: E731
    handles, _, _, _, idxs = struct.unpack_from("<5I", ram, where._elf(args.elf)["sHeapInfo"][0] - MAIN_RAM)
    if not handles:
        sys.exit("no heaps yet: the dump is from before Heap_InitSystem")
    h = u32(handles + 4 * ram[idxs + args.heap - MAIN_RAM])

    def walk(head):
        out, block = [], u32(h + head)
        while block:
            out.append((block, u32(block + 4)))
            block = u32(block + 0xC)
        return out

    start, end = u32(h + 0x18), u32(h + 0x1C)
    used, free = walk(0x2C), walk(0x24)
    print(f"heap {args.heap} {start:#x}-{end:#x} ({end - start}) used {sum(s + 16 for _, s in used)} in {len(used)}, "
          f"free {sum(s for _, s in free)} in {len(free)}, largest {max((s for _, s in free), default=0)}")
    print("free blocks:", sorted(((hex(a), s) for a, s in free), key=lambda x: -x[1])[:8])
    sizes = Counter(s - 16 for _, s in used)
    small = sum(n * (s + 16) for s, n in sizes.items() if s < args.min)
    print(f"blocks under {args.min} bytes: {sum(n for s, n in sizes.items() if s < args.min)} taking {small} with headers")
    for a, s in sorted(used, key=lambda x: -x[1]):
        if s - 16 < args.min:
            break
        data = a + 0x20  # the NNS block head, 16 bytes, then the game's MemoryBlock, 16
        head = ram[data - MAIN_RAM:data - MAIN_RAM + 16]
        print(f"{a:#x} size {s - 16:6d} ({s - 16:#x})  {head.hex(' ')}  {head[:4]!r}")


if __name__ == "__main__":
    main()
