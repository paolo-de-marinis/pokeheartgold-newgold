#!/usr/bin/env python3
"""What a NEWGOLD_DIAG=1 build has recorded, read out of a copy of main RAM.

Both readers in this folder come here: live.py with the RAM of a running
melonDS, dump.py with the dumps a harness run wrote. The names are the globals
in include/newgold/diag.h and the ELF says where each one is.
"""
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(ROOT / "tools/newgold/devkit/harness"))
import where  # noqa: E402

DIAG_ELF = ROOT / "build/heartgold.us.diag/main.elf"
MAIN_RAM = 0x02000000
STATES = ["INIT", "LINK_INIT", "LINK_MAIN", "UNK_A_INIT", "UNK_A_MAIN", "UNK_B_INIT", "UNK_B_MAIN",
          "SYNC", "BATTLE_INIT", "BATTLE_MAIN", "END_INIT", "END_MAIN", "END_WAIT",
          "EVOLUTION_INIT", "EVOLUTION_MAIN", "EXIT"]
SWITCHES = {"gDiagIgnoreCommunicationError": 4, "gDiagForceEncounter": 4, "gDiagForceBattleSpecies": 2,
            "gDiagForceTutorial": 2, "gDiagWarpX": 2, "gDiagWarpZ": 2, "gDiagBattleSeed": 4,
            "gDiagForceCritical": 4, "gDiagForceHit": 4, "gDiagForceDamageRoll": 4, "gDiagForceEffect": 4}


PROMPTS = {1: "choose a command", 2: "choose a command", 3: "choose a move", 4: "choose a move",
           5: "choosing a target", 6: "choose a target", 9: "choose a Pokemon", 10: "choose a Pokemon"}
STATUS = [(7, "SLP"), (1 << 3, "PSN"), (1 << 4, "BRN"), (1 << 5, "FRZ"), (1 << 6, "PAR"), (1 << 7, "TOX")]
BATTLER = "<HHHBBIH4H4B2x"  # DiagBattler, include/newgold/diag.h
TEXT_LINES, TEXT_CHARS = 16, 96


def _names(header, prefix):
    # The first define of a number names it: moves.h goes on to number
    # MOVE_ATTRIBUTE_* from 0, which would call Ice Punch "Attribute Priorty".
    names = {}
    for m in re.finditer(rf"#define ({prefix}[A-Z0-9_]+)\s+(\d+)\s*(?://.*)?$", (ROOT / header).read_text(), re.M):
        names.setdefault(int(m.group(2)), m.group(1)[len(prefix):].replace("_", " ").title())
    return names


def _charmap():
    table = {}
    for line in (ROOT / "charmap.txt").read_text(encoding="utf-8").splitlines():
        m = re.match(r"^([0-9A-F]{4})=(.*)$", line)
        if m:
            table[int(m.group(1), 16)] = {"\\n": " ", "\\r": " ", "\\f": " "}.get(m.group(2), m.group(2))
    return table


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

        The static ARM9 module sits at the start of main RAM. Its first four
        kilobytes hold the secure area and a word the game writes at start,
        and its start is the same in every build; the code after that is
        not, so a quarter of a megabyte of it has to match the build's own
        copy or every symbol read is a number from a different build.
        """
        binary = self.elf.with_name("main.sbin")
        if not binary.exists():
            return True
        code = binary.read_bytes()[0x1000:0x40000]
        return ram[0x1000:0x1000 + len(code)] == code

    def address(self, name):
        return self.table[name][0] if name in self.table else None

    def read(self, ram, name, width=4):
        address = self.address(name)
        if address is None:
            return None
        return struct.unpack_from("<I" if width == 4 else "<H", ram, address - MAIN_RAM)[0]

    def callers(self, ram, loaded=("main",)):
        """Return addresses among the stack words saved at the last assertion.

        An address in overlay space names a function in every overlay placed
        there; the answer taken is the first section in `loaded` that has one,
        and only failing that the first alphabetically -- which in a battle is
        OVY_114 rather than OVY_12, and was every name past main on the line.
        """
        base = self.address("gDiagAssertStack")
        if base is None:
            return "?"
        words = struct.unpack_from("<64I", ram, base - MAIN_RAM)
        names = []
        for word in words:
            if not (0x02000000 <= word < 0x02400000 and word & 1):
                continue
            answers = [a.strip() for a in where.function_at(word, table=self.table).split(",") if "+" in a]
            if answers:
                names.append(next((a for s in loaded for a in answers if a.endswith(f"({s})")), answers[0]))
        return " < ".join(names[:12]) or "nothing on the stack looks like a return"

    def block(self):
        """The address and length of every diagnostic global, for sampling."""
        spans = sorted((value, value + max(size, 4)) for name, (value, size, _, _) in self.table.items()
                       if name.startswith("gDiag") and 0x02000000 <= value < 0x02400000)
        start, end = spans[0]
        for a, b in spans[1:]:
            if a - end > 0x1000:
                raise SystemExit(f"the diagnostics are not together: a gap at {end:#x}; keep them all zero-initialised")
            end = max(end, b)
        return start, end - start

    def text(self, ram, base=None):
        """The battle's printed lines still in the ring, oldest first, with their index."""
        if self.address("gDiagBattleText") is None:
            return []
        charmap = getattr(self, "_charmap", None) or _charmap()
        self._charmap = charmap
        count = self.read_at(ram, "gDiagBattleTextCount", base)
        where = self.address("gDiagBattleText") - (base if base is not None else MAIN_RAM)
        lines = []
        for index in range(max(0, count - TEXT_LINES), count):
            at = where + (index % TEXT_LINES) * TEXT_CHARS * 2
            codes = struct.unpack_from(f"<{TEXT_CHARS}H", ram, at)
            chars = []
            for code in codes:
                if code == 0xFFFF:
                    break
                chars.append(charmap.get(code, "?"))
            lines.append((index, re.sub(r"\s+", " ", "".join(chars)).strip()))
        return lines

    def battle(self, ram, base=None):
        """The battlers and the prompt, as lines of text."""
        if self.address("gDiagBattlers") is None:
            return []
        if not hasattr(self, "_species"):
            self._species = _names("include/constants/species.h", "SPECIES_")
            self._moves = _names("include/constants/moves.h", "MOVE_")
            self._items = _names("include/constants/items.h", "ITEM_")
        at = self.address("gDiagBattlers") - (base if base is not None else MAIN_RAM)
        size = struct.calcsize(BATTLER)
        out = []
        for battler in range(4):
            species, hp, max_hp, level, slot, status, item, *rest = struct.unpack_from(BATTLER, ram, at + battler * size)
            if not species:
                continue
            moves, pp = rest[:4], rest[4:]
            flags = [name for mask, name in STATUS if status & mask]
            side = "you" if battler % 2 == 0 else "foe"
            line = f"{side} {self._species.get(species, species)} L{level} {hp}/{max_hp}" + (f" {' '.join(flags)}" if flags else "")
            if item:
                line += f" holding {self._items.get(item, item)}"
            if side == "you":
                line += " | " + ", ".join(f"{i + 1}:{self._moves.get(m, m)} {p}" for i, (m, p) in enumerate(zip(moves, pp)) if m)
            out.append(line)
        prompt = self.read_at(ram, "gDiagBattlePrompt", base)
        out.append("prompt: " + PROMPTS.get(prompt, f"none ({prompt})"))
        return out

    def heaps(self, ram, base=None):
        """{heap name: the largest block it had left at its fullest} for every
        heap that allocated since it was created (gDiagHeapLowWater)."""
        at = self.address("gDiagHeapLowWater")
        if at is None:
            return {}
        if not hasattr(self, "_heaps"):
            enum = re.search(r"enum HeapID \{(.*?)\}", (ROOT / "include/constants/heap.h").read_text(), re.S).group(1)
            self._heaps = [n.strip().split("=")[0].strip() for n in enum.split(",") if n.strip() and not n.strip().startswith("//")]
        count = self.table["gDiagHeapLowWater"][1] // 4
        words = struct.unpack_from(f"<{count}I", ram, at - (base if base is not None else MAIN_RAM))
        return {(self._heaps[i] if i < len(self._heaps) else i): v for i, v in enumerate(words) if v != 0xFFFFFFFF}

    def read_at(self, ram, name, base=None):
        address = self.address(name)
        if address is None:
            return None
        return struct.unpack_from("<I", ram, address - (base if base is not None else MAIN_RAM))[0]

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
        # Overlay 12 is the battle; between BATTLE_INIT and EXIT it is loaded.
        loaded = ("main", "OVY_12") if STATES.index("BATTLE_INIT") <= state < STATES.index("EXIT") else ("main",)
        parts = [
            field,
            f"wild stage {w('gDiagWildStage')} after {w('gDiagWildTicks')} sp {w('gDiagLastWildSpecies')} L{w('gDiagLastWildLevel')}"
            f" map {w('gDiagLastBattleMap')} bg {w('gDiagLastBattleBg')} terrain {w('gDiagLastBattleTerrain')}",
            f"battle {STATES[state] if state < 16 else state} {w('gDiagBattleTicks')} ticks [{reached}]",
            f"asserts {asserts}" + (f" last at {where.function_at(w('gDiagAssertReturn'), table=self.table)}"
                                   f" called from {self.callers(ram, loaded)}" if asserts else ""),
            f"alloc failures {allocs}" + (f" last {w('gDiagAllocFailSize')} bytes from heap {w('gDiagAllocFailHeap')}" if allocs else ""),
        ]
        low = self.heaps(ram)
        if low:
            parts.append("least left " + " ".join(f"{name.replace('HEAP_ID_', '')}:{value:#x}" for name, value in low.items()))
        # A switch left on explains a run that behaves oddly.
        on = {name: self.read(ram, name, width) for name, width in SWITCHES.items()}
        on = {name: value for name, value in on.items() if value}
        if on:
            parts.append("switches " + " ".join(f"{name[5:]}={value}" for name, value in on.items()))
        return " | ".join(parts)
