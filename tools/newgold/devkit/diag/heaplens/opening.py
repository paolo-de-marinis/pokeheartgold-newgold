#!/usr/bin/env python3
"""Cold boot, the opening, the Pokegear walk, Route 29 and a forced wild
battle -- battle.py's route, frame for frame, in-process -- with the boot
heaps measured stage by stage.

    opening.py OUTDIR SPECIES

smoke.py's scripted route, so it goes as far as that route does: since the
Pokegear walk was lengthened it ends in a Pokemon Center, not on Route 29
(the forced battle then never comes); the opening's stages are measured.
"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from lens import TREE, Core, Lens, Markers, play  # noqa: E402
import smoke  # noqa: E402

if len(sys.argv) != 3:
    sys.exit(__doc__)
out, species = Path(sys.argv[1]), int(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
elf = TREE / "build/heartgold.us.diag/main.elf"
m = Markers(elf)
at = lambda name: f"{m.address(name):x}"  # noqa: E731

opening = [a for stage in smoke.ROUTES for a in smoke.ROUTES[stage]]
pokegear, after = smoke.legs(smoke.WALKS["pokegear"], smoke.ROUTE_FRAMES["skills"] + 100)
route29, end = smoke.legs(smoke.WALKS["route29"], after + 100)
leave = ["u:200", "l:400"] + [s for _ in range(6) for s in ("d:60", "r:14")]
outdoors, outside = smoke.legs(leave, end + 100)
actions = opening + pokegear + route29 + outdoors
actions += [f"poke:{outside}:{at('gDiagWarpX')}:2:655", f"poke:{outside}:{at('gDiagWarpZ')}:2:400"]
begin = outside + 1200
actions.append(f"hold:{begin}:200:{at('gDiagForceBattleSpecies')}:2:{species}")
roam, done = smoke.legs(["d:60", "u:60", "l:60", "r:60"] * 8, begin + 30)
actions += roam
total = done + 500

# Stage boundaries: the opening's own frames, then the walks.
stages = [(0, "boot: publisher screens, intro movie, title"), (3000, "controls tutorial, Oak's speech, naming screen"),
          (smoke.ROUTE_FRAMES["name"], "bedroom (first field load)"),
          (smoke.ROUTE_FRAMES["bedroom"], "downstairs, mother"),
          (smoke.ROUTE_FRAMES["downstairs"], "out into New Bark (map change)"),
          (smoke.ROUTE_FRAMES["outside"], "to the lab, Elm's speech (map change)"),
          (smoke.ROUTE_FRAMES["lab"], "choose starter app"),
          (smoke.ROUTE_FRAMES["starter"], "start menu, party, summary"),
          (smoke.ROUTE_FRAMES["skills"] + 100, "Pokegear walk: lab, Lyra, house, mother"),
          (after + 100, "Route 29 walk"),
          (end + 100, "outdoors, warp to R29 grass"),
          (begin, f"forced wild battle (species {species}) and run"),
          ]
for frame, name in stages:
    actions.append(f"mark:{frame}:{name}")
actions += [f"shot:{f}:{out}/s_{f:06d}.png" for f in range(300, total, 300)]

core = Core(TREE / "build/heartgold.us.diag/pokeheartgold.us.nds")
logf = open(out / "log.txt", "w", buffering=1)
lens = Lens(core, m, log=lambda s: print(s, file=logf))
state_log = []


def on(kind, value):
    if kind == "mark":
        lens.begin(value)
    elif kind == "shot":
        path, image = value
        image.save(path)


lens.begin(stages[0][1])
# the first mark at frame 0 fires after frame 0: drop it, begin() is already called
actions = [a for a in actions if not a.startswith("mark:0:")]
play(core, actions, total, [lens.hook], on)
lens.end()
ram = core.ram()
print(m.describe(ram), file=logf)
lens.dump(out / "lens.json")
core.close()
