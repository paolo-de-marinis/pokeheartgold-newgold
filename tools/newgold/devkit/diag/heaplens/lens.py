#!/usr/bin/env python3
"""How full the four boot heaps and the main arena get, scene by scene.

The diagnostics build keeps gDiagHeapLowWater[heap]: the largest block the
heap could still hand out, at its fullest, updated after every allocation.
This reads it after every frame. A scene starts by writing the heap's
largest free block *now* into the marker (so the scene's number is the least
it had at any moment of the scene, starting state included) and ends by
reading it back. Whenever a heap reaches a new all-time low, the heap's
blocks are walked (the NNS expanded heap's used list) so the report can say
what was in it at that moment: which child heaps, and how much the heap's
own allocations took.

The library under drive.py (scenes from a save), gymlens.py (a gym leader's
fight) and opening.py (a new game's opening): each writes OUT/lens.json --
per scene the least left in each boot heap, the arena, failed allocations
and asserts -- and OUT/log.txt.
"""
import ctypes
import json
import os
import struct
import sys
from pathlib import Path

# The tree whose build and tools are read: a snapshot (snap.sh) named by
# SNAP, or this one.
TREE = Path(os.environ.get("SNAP") or Path(__file__).resolve().parents[5])
for sub in ("tools/newgold/devkit/diag", "tools/newgold/devkit/harness", "tools/newgold/devkit"):
    sys.path.insert(0, str(TREE / sub))
from core import Core  # noqa: E402
from markers import Markers  # noqa: E402

MAIN = 0x02000000
ARENA_LO = 0x023FFDA0          # OS arena lo[0] (0x027FFDA0, mirrored), hi[0] 9 words on
BOOT = (0, 1, 2, 3)
NAMES = {0: "DEFAULT", 1: "1 (save)", 2: "2", 3: "3 (general)"}
EXPH = 0x45585048              # 'EXPH', an expanded heap's head


class Lens:
    def __init__(self, core, markers, log=None):
        self.core, self.m = core, markers
        self.lw = markers.address("gDiagHeapLowWater")
        self.info = markers.address("sHeapInfo")
        self.enum = None
        self.scene, self.scene_start = None, 0
        self.scene_min, self.rows, self.scene_at = {}, [], {}
        self.low = {h: 0xFFFFFFFF for h in BOOT}
        self.low_at = {}
        self.arena = None
        self.arena_changes = []
        self.log = log or (lambda s: None)

    # -- raw memory ---------------------------------------------------------
    def _base(self):
        return self.core.lib.retro_get_memory_data(2)

    def u32(self, address, base=None):
        base = base or self._base()
        return struct.unpack("<I", ctypes.string_at(base + ((address - MAIN) & 0x3FFFFF), 4))[0]

    def u16(self, address, base=None):
        base = base or self._base()
        return struct.unpack("<H", ctypes.string_at(base + ((address - MAIN) & 0x3FFFFF), 2))[0]

    def u8(self, address, base=None):
        base = base or self._base()
        return ctypes.string_at(base + ((address - MAIN) & 0x3FFFFF), 1)[0]

    # -- the heap system ----------------------------------------------------
    def heap_names(self):
        if self.enum is None:
            import re
            text = (TREE / "include/constants/heap.h").read_text()
            body = re.search(r"enum HeapID \{(.*?)\}", text, re.S).group(1)
            self.enum = [n.strip() for n in body.split(",") if n.strip()]
        return self.enum

    def handle(self, heap):
        base = self._base()
        handles, idxs = self.u32(self.info, base), self.u32(self.info + 16, base)
        if not handles:
            return 0
        return self.u32(handles + 4 * self.u8(idxs + heap, base), base)

    def free_blocks(self, handle):
        base = self._base()
        out, block = [], self.u32(handle + 0x24, base)
        while block and len(out) < 4096:
            out.append((block, self.u32(block + 4, base)))
            block = self.u32(block + 0xC, base)
        return out

    def largest_free(self, heap):
        h = self.handle(heap)
        return max((s for _, s in self.free_blocks(h)), default=0) if h else None

    def layout(self, heap):
        """What the heap holds: child heaps by name, its own blocks by count."""
        base = self._base()
        h = self.handle(heap)
        if not h:
            return None
        start, end = self.u32(h + 0x18, base), self.u32(h + 0x1C, base)
        handles = self.u32(self.info, base)
        raws = self.u32(self.info + 8, base)
        idxs = self.u32(self.info + 16, base)
        total = self.u16(self.info + 20, base)
        max_heaps = self.u16(self.info + 24, base)
        raw_to_index = {self.u32(raws + 4 * i, base): i for i in range(max_heaps)}
        index_to_id = {}
        for hid in range(total):
            index_to_id.setdefault(self.u8(idxs + hid, base), hid)
        names = self.heap_names()
        children, own, own_bytes = [], {}, 0
        block = self.u32(h + 0x2C, base)
        n = 0
        while block and n < 8192:
            n += 1
            size = self.u32(block + 4, base)
            data = block + 0x10
            if self.u32(data, base) == EXPH and data in raw_to_index:
                hid = index_to_id.get(raw_to_index[data])
                name = names[hid] if hid is not None and hid < len(names) else hid
                children.append((str(name).replace("HEAP_ID_", ""), size))
            else:
                own_bytes += size + 0x10
                own[size] = own.get(size, 0) + 1
            block = self.u32(block + 0xC, base)
        free = sorted((s for _, s in self.free_blocks(h)), reverse=True)
        big_own = sorted(((s, c) for s, c in own.items()), reverse=True)[:6]
        return {"size": end - start, "children": children, "own_blocks": sum(own.values()),
                "own_bytes": own_bytes, "largest_own": [(hex(s), c) for s, c in big_own],
                "free": [hex(s) for s in free[:6]], "free_total": sum(free)}

    # -- per frame ----------------------------------------------------------
    def watch(self, core, base):
        """Failed allocations, assertions and resets, the frame they happen."""
        if not hasattr(self, "_w"):
            self._w = {n: self.m.address(n) for n in ("gDiagAllocFailCount", "gDiagAssertCount", "gSystem")}
            self._last = {}
            self.events = []
        now = {n: self.u32(a + (0x2C if n == "gSystem" else 0), base) for n, a in self._w.items() if a}
        for n, v in now.items():
            before = self._last.get(n)
            if before is not None and v != before and (n != "gSystem" or v < before):
                extra = {}
                if n == "gDiagAllocFailCount":
                    extra = {"heap": self.u32(self.m.address("gDiagAllocFailHeap"), base),
                             "size": self.u32(self.m.address("gDiagAllocFailSize"), base)}
                if n == "gDiagAssertCount":
                    extra = {"return": hex(self.u32(self.m.address("gDiagAssertReturn"), base))}
                self.events.append((core.frames, self.scene, n, before, v, extra))
                self.log(f"[{core.frames}] EVENT {n} {before} -> {v} {extra}")
        self._last = now

    def hook(self, core):
        base = self._base()
        self.watch(core, base)
        # Before Heap_InitSystem the markers are uninitialised memory.
        if not self.u32(self.info, base):
            return
        values = struct.unpack("<4I", ctypes.string_at(base + self.lw - MAIN, 16))
        for heap in BOOT:
            v = values[heap]
            if v < self.scene_min.get(heap, 0xFFFFFFFF):
                self.scene_min[heap] = v
                if heap in (0, 3):
                    self.scene_at[heap] = {"frame": core.frames, "layout": self.layout(heap)}
            if v < self.low[heap]:
                self.low[heap] = v
                if heap in (0, 3, 1):
                    self.low_at[heap] = {"frame": core.frames, "scene": self.scene, "value": v,
                                         "layout": self.layout(heap)}
        lo, hi = struct.unpack("<II", ctypes.string_at(base + ARENA_LO - MAIN, 4)
                               + ctypes.string_at(base + ARENA_LO + 36 - MAIN, 4))
        if (lo, hi) != self.arena:
            self.arena = (lo, hi)
            self.arena_changes.append((core.frames, self.scene, hex(lo), hex(hi), hex(hi - lo)))

    def begin(self, name):
        if self.scene is not None:
            self.end()
        self.scene, self.scene_start = name, self.core.frames
        self.scene_min, self.scene_at = {}, {}
        self.fails0 = self.m.read(self.core.ram(), "gDiagAllocFailCount")
        self.asserts0 = self.m.read(self.core.ram(), "gDiagAssertCount")
        # The scene's number is the least left after an allocation made in
        # the scene; what the heap had as it started is kept beside it.
        self.scene_start_free = {}
        for heap in BOOT:
            now = self.largest_free(heap)
            if now is not None:
                self.core.poke(self.lw + 4 * heap, 0xFFFFFFFF)
                self.scene_start_free[heap] = now
        self.log(f"[{self.core.frames}] scene {name}")

    def end(self, note=""):
        if self.scene is None:
            return
        ram = self.core.ram()
        row = {"scene": self.scene, "frames": [self.scene_start, self.core.frames],
               "low": {NAMES[h]: self.scene_min.get(h) for h in BOOT},
               "alloc_fail": self.m.read(ram, "gDiagAllocFailCount") - self.fails0,
               "asserts": self.m.read(ram, "gDiagAssertCount") - self.asserts0,
               "arena_free": hex(self.arena[1] - self.arena[0]) if self.arena else None,
               "start_free": {NAMES[h]: v for h, v in getattr(self, "scene_start_free", {}).items()},
               "note": note, "at": {NAMES[h]: v for h, v in self.scene_at.items()}}
        if row["alloc_fail"]:
            row["fail_heap"] = self.m.read(ram, "gDiagAllocFailHeap")
            row["fail_size"] = self.m.read(ram, "gDiagAllocFailSize")
        self.rows.append(row)
        self.log(f"[{self.core.frames}] end {self.scene}: " + " ".join(
            f"{k}:{v:#x}" if v is not None else f"{k}:-" for k, v in row["low"].items())
            + f" fails {row['alloc_fail']} asserts {row['asserts']} {note}")
        self.scene = None

    def dump(self, path):
        Path(path).write_text(json.dumps({"rows": self.rows, "low": {NAMES[h]: v for h, v in self.low.items()},
                                          "low_at": {NAMES[h]: v for h, v in self.low_at.items()},
                                          "arena": self.arena_changes, "events": getattr(self, "events", [])}, indent=1, default=str))


def play(core, actions, total, hooks, on=None):
    """boot_check's actions, frame for frame, in-process; "mark:FRAME:NAME"
    and "shot:FRAME:PATH" call on(kind, value) after that frame."""
    parsed = []
    for a in actions:
        kind, *f = a.split(":")
        parsed.append((kind, f))
    shots = {int(f[0]): f[1] for kind, f in parsed if kind == "shot"}
    marks = {}
    for kind, f in parsed:
        if kind == "mark":
            marks.setdefault(int(f[0]), []).append(f[1])
    for frame in range(total):
        pressed, touch = set(), None
        for kind, f in parsed:
            if kind == "press":
                at, ln, b = int(f[0]), int(f[1]), int(f[2])
                if at <= frame < at + ln:
                    pressed.add(b)
            elif kind == "mash":
                at, until, period, ln, b = map(int, f)
                if at <= frame < until and (frame - at) % period < ln:
                    pressed.add(b)
            elif kind == "tap":
                at, until, period, ln, x, y = map(int, f)
                if at <= frame < until and (frame - at) % period < ln:
                    touch = (x, y)
            elif kind == "touch":
                at, ln, x, y = map(int, f)
                if at <= frame < at + ln:
                    touch = (x, y)
        core.buttons = pressed
        if touch:
            core.touching = True
            core.tx = int(((touch[0] / 256.0) * 2 - 1) * 0x7FFF)
            core.ty = int((((touch[1] + 192) / 384.0) * 2 - 1) * 0x7FFF)
        else:
            core.touching = False
        for hook in hooks:
            hook(core)
        core._grab = frame in shots
        core.lib.retro_run()
        core.frames += 1
        core._grab = False
        for kind, f in parsed:
            if kind == "poke" and int(f[0]) == frame:
                core.poke(int(f[1], 16), int(f[3]), int(f[2]))
            elif kind == "hold" and int(f[0]) <= frame < int(f[0]) + int(f[1]):
                core.poke(int(f[2], 16), int(f[4]), int(f[3]))
        if frame in shots and core._frame and on:
            from PIL import Image
            data, width, height, pitch = core._frame
            on("shot", (shots[frame], Image.frombuffer("RGBX", (width, height), data, "raw", "BGRX", pitch, 1).convert("RGB")))
        for name in marks.get(frame, []):
            if on:
                on("mark", name)
    core.buttons, core.touching = set(), False
