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

    def address(self, name):
        return self.table[name][0] if name in self.table else None

    def read(self, ram, name, width=4):
        address = self.address(name)
        if address is None:
            return None
        return struct.unpack_from("<I" if width == 4 else "<H", ram, address - MAIN_RAM)[0]

    def describe(self, ram):
        """One line: the field, the encounter, the battle, and what failed."""
        w = lambda name: self.read(ram, name)  # noqa: E731
        look = where.look(ram, self.address("sFieldSysPtr"), self.page, self.sector)
        field = "field down" if look is None else f"at {look[0]} party {look[1]}"
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
            f"asserts {asserts}" + (f" last at {where.function_at(w('gDiagAssertReturn'), table=self.table)}" if asserts else ""),
            f"alloc failures {allocs}" + (f" last {w('gDiagAllocFailSize')} bytes from heap {w('gDiagAllocFailHeap')}" if allocs else ""),
        ]
        # A switch left on explains a run that behaves oddly.
        on = {name: self.read(ram, name, width) for name, width in SWITCHES.items()}
        on = {name: value for name, value in on.items() if value}
        if on:
            parts.append("switches " + " ".join(f"{name[5:]}={value}" for name, value in on.items()))
        return " | ".join(parts)
