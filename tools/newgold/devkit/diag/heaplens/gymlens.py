#!/usr/bin/env python3
"""gym.py's leader fight with the boot heaps measured (lens.py).

    gymlens.py SAVE OUTDIR [gym.py options]

Two scenes: the save continued up to the battle, and the battle to the
badge. SAVE is a scratch copy of a gym save, as for gym.py.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import lens as L  # noqa: E402
import gym  # noqa: E402

if len(sys.argv) < 3:
    sys.exit(__doc__)
save, out = sys.argv[1], Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
state = {}


class LensCore(gym.Core):
    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self.lens = L.Lens(self, L.Markers(gym.DIAG_ELF))
        self.lens.begin("continue from the save, the leader's lines")
        state["lens"] = self.lens
        state["battle_seen"] = False

    def step(self, frames=1, hooks=()):
        lens = self.lens
        for _ in range(frames):
            lens.hook(self)
            for hook in hooks:
                hook(self)
            self.lib.retro_run()
            self.frames += 1
            if not state["battle_seen"] and lens.u32(state.setdefault("bs", lens.m.address("gDiagBattleState"))) not in (0, 15):
                state["battle_seen"] = True
                lens.begin("trainer battle (gym leader), to the badge")

    def close(self):
        self.lens.end()
        self.lens.dump(out / "lens.json")
        super().close()


gym.Core = LensCore
gym.ROM = L.TREE / "build/heartgold.us.diag/pokeheartgold.us.nds"
sys.argv = ["gym.py", save] + sys.argv[3:]
gym.main()
