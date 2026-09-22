#!/usr/bin/env python3
"""What a NEWGOLD_DIAG=1 build has recorded, read out of a copy of main RAM.

Both readers in this folder come here: live.py with the RAM of a running
melonDS, dump.py with the dumps a harness run wrote. The names are the globals
in include/newgold/diag.h and the ELF says where each one is.
"""
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / "tools/newgold"))
import where  # noqa: E402

DIAG_ELF = ROOT / "build/heartgold.us.diag/main.elf"
MAIN_RAM = 0x02000000
STATES = ["INIT", "LINK_INIT", "LINK_MAIN", "UNK_A_INIT", "UNK_A_MAIN", "UNK_B_INIT", "UNK_B_MAIN",
          "SYNC", "BATTLE_INIT", "BATTLE_MAIN", "END_INIT", "END_MAIN", "END_WAIT",
          "EVOLUTION_INIT", "EVOLUTION_MAIN", "EXIT"]
SWITCHES = {"gDiagIgnoreCommunicationError": 4, "gDiagForceEncounter": 4, "gDiagForceBattleSpecies": 2,
            "gDiagWarpX": 2, "gDiagWarpZ": 2}


class Markers:
    def __init__(self, elf=DIAG_ELF):
        self.elf = Path(elf)
        if not self.elf.exists():
            raise SystemExit(f"{self.elf} is not built (make NEWGOLD_DIAG=1 COMPARE=0)")
        self.table = where._elf(self.elf)
        self.page = where.constant("SAVE_PAGE_MAX", "include/constants/save_arrays.h")
        self.sector = where.constant("SAVE_SECTOR_SIZE", "include/constants/save_arrays.h")

    def matches(self, ram):
        """Whether the game in this memory is the build the ELF came from.

        The static ARM9 module sits at the start of main RAM. Its first two
        kilobytes are the secure area, which the ROM carries encrypted, and
        its start is the same in every build; the code after that is not,
        so a quarter of a megabyte of it has to match the build's own copy
        or every symbol read is a number from a different build.
        """
        binary = self.elf.with_name("main.sbin")
        if not binary.exists():
            return True
        code = binary.read_bytes()[0x800:0x40000]
        return ram[0x800:0x800 + len(code)] == code

    def address(self, name):
        return self.table[name][0] if name in self.table else None

    def read(self, ram, name, width=4):
        address = self.address(name)
        if address is None:
            return None
        return struct.unpack_from("<I" if width == 4 else "<H", ram, address - MAIN_RAM)[0]

    def callers(self, ram):
        """Return addresses among the stack words saved at the last assertion."""
        base = self.address("gDiagAssertStack")
        if base is None:
            return "?"
        words = struct.unpack_from("<16I", ram, base - MAIN_RAM)
        names = [where.function_at(word, table=self.table) for word in words
                 if 0x02000000 <= word < 0x02400000 and word & 1]
        names = [n.split(",")[0] for n in names if "+" in n]
        return " < ".join(names[:4]) or "nothing on the stack looks like a return"

    def describe(self, ram):
        """One line: the field, the encounter, the battle, and what failed."""
        w = lambda name: self.read(ram, name)  # noqa: E731
        look = where.look(ram, self.address("sFieldSysPtr"), self.page, self.sector)
        field = "field down" if look is None else f"at {look[0]} party {look[1]}"
        if not self.matches(ram):
            return f"{field} | the game running is not the build this ELF is from; reopen the ROM"
        if self.address("gDiagBattleState") is None:
            return f"{field} | no diagnostics in this build"
        state, seen = w("gDiagBattleState"), w("gDiagBattleStateSeen")
        reached = ",".join(STATES[i] for i in range(16) if seen >> i & 1)
        asserts, allocs = w("gDiagAssertCount"), w("gDiagAllocFailCount")
        parts = [
            field,
            f"wild stage {w('gDiagWildStage')} after {w('gDiagWildTicks')} sp {w('gDiagLastWildSpecies')} L{w('gDiagLastWildLevel')}"
            f" map {w('gDiagLastBattleMap')} bg {w('gDiagLastBattleBg')} terrain {w('gDiagLastBattleTerrain')}",
            f"battle {STATES[state] if state < 16 else state} {w('gDiagBattleTicks')} ticks [{reached}]",
            f"asserts {asserts}" + (f" last at {where.function_at(w('gDiagAssertReturn'), table=self.table)}"
                                   f" called from {self.callers(ram)}" if asserts else ""),
            f"alloc failures {allocs}" + (f" last {w('gDiagAllocFailSize')} bytes from heap {w('gDiagAllocFailHeap')}" if allocs else ""),
        ]
        # A switch left on explains a run that behaves oddly.
        on = {name: self.read(ram, name, width) for name, width in SWITCHES.items()}
        on = {name: value for name, value in on.items() if value}
        if on:
            parts.append("switches " + " ".join(f"{name[5:]}={value}" for name, value in on.items()))
        return " | ".join(parts)
