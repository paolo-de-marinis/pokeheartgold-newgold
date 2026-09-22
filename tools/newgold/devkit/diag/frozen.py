#!/usr/bin/env python3
"""Read the ARM9 out of a melonDS savestate, for a game that has stopped.

    frozen.py STATE.ml1 [ELF]

Shift+F1 in melonDS writes the state beside the ROM. Its ARM9 section is the
registers; CPSR 0x97 is abort mode, where the BIOS parks a data abort with
the faulting instruction eight bytes before the link register. The last
0x4000 bytes of the CP15 section are the DTCM, which holds the stack, and
every word in it that looks like a return address is named against the ELF,
so the call chain reads off. Overlays share addresses: each section's own
answer is listed, and the loaded overlay is the true one.
"""
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import where  # noqa: E402
from markers import DIAG_ELF  # noqa: E402

MODES = {0x10: "user", 0x11: "fiq", 0x12: "irq", 0x13: "supervisor", 0x17: "abort", 0x1B: "undefined", 0x1F: "system"}


def section(state, magic):
    i = state.find(magic)
    if i < 0:
        raise SystemExit(f"no {magic.decode()} section in the state")
    length = struct.unpack_from("<I", state, i + 4)[0]
    return state[i + 16:i + 16 + length]


def main():
    state = Path(sys.argv[1]).read_bytes()
    elf = Path(sys.argv[2]) if len(sys.argv) > 2 else DIAG_ELF
    table = where._elf(elf)
    arm9 = section(state, b"ARM9")
    regs = struct.unpack_from("<22I", arm9, 0)
    r, cpsr = regs[2:18], regs[18]
    name = lambda a: where.function_at(a, table=table)  # noqa: E731
    print(f"halted {regs[1]}, CPSR {cpsr:#x} ({MODES.get(cpsr & 0x1F, '?')} mode, {'Thumb' if cpsr & 0x20 else 'ARM'})")
    for i in range(0, 16, 4):
        print("  " + "  ".join(f"r{j:<2} {r[j]:08x}" for j in range(i, i + 4)))
    print(f"pc {r[15]:#x}: {name(r[15])}")
    if (cpsr & 0x1F) == 0x17:
        fault = r[14] - 8
        print(f"data abort at {fault:#x}: {name(fault)}")
    else:
        print(f"lr {r[14]:#x}: {name(r[14])}")
    dtcm = section(state, b"CP15")[-0x4000:]
    print("return addresses on the stack, newest first:")
    seen = 0
    for i in range(0, len(dtcm), 4):
        word = struct.unpack_from("<I", dtcm, i)[0]
        if 0x02000000 <= word < 0x02400000 and word & 1 and word - 1 in range(0x02000000, 0x02400000):
            found = name(word)
            if "+" in found:
                print(f"  {word:#x}: {found}")
                seen += 1
                if seen >= 40:
                    print("  ...")
                    break


if __name__ == "__main__":
    main()
