#!/usr/bin/env python3
"""Play the opening in the harness, step onto Route 29, and start a wild battle.

    battle.py OUTDIR encounter            the roll is forced: the first step in grass
    battle.py OUTDIR battle:SPECIES       a battle against that species, from anywhere
    battle.py OUTDIR tutorial             the catching demonstration, from anywhere

No savestate: this machine writes them unreliably, and a run from a cold boot
cannot be wrong about what it is looking at. About ten minutes. The dumps and
shots land in OUTDIR and are read back with dump.py at the end.

The ROM is the NEWGOLD_DIAG=1 HeartGold build, which is the only one with the
switches this writes. Its shots come through boot_check's framebuffer, which
goes black the moment overlay 12 loads (core.py's shot draws a battle), so what
a run proves is that the encounter rolls, which species it made, and how far
Battle_Run got.
"""
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "harness"))
import smoke  # noqa: E402
from dump import report  # noqa: E402
from markers import DIAG_ELF, Markers  # noqa: E402

TILE, IDLE = (655, 400), 1200  # grass on Route 29, and a pause before the switch is thrown


def main():
    out, what = Path(sys.argv[1]), sys.argv[2]
    out.mkdir(parents=True, exist_ok=True)
    markers = Markers(DIAG_ELF)
    at = lambda name: f"{markers.address(name):x}"  # noqa: E731

    opening = [a for stage in smoke.ROUTES for a in smoke.ROUTES[stage]]
    pokegear, after = smoke.legs(smoke.WALKS["pokegear"], smoke.ROUTE_FRAMES["skills"] + 100)
    route29, end = smoke.legs(smoke.WALKS["route29"], after + 100)
    leave = ["u:200", "l:400"] + [s for _ in range(6) for s in ("d:60", "r:14")]
    outdoors, outside = smoke.legs(leave, end + 100)
    actions = opening + pokegear + route29 + outdoors
    # The field reads the warp itself, so there is no pointer chain to follow.
    actions += [f"poke:{outside}:{at('gDiagWarpX')}:2:{TILE[0]}", f"poke:{outside}:{at('gDiagWarpZ')}:2:{TILE[1]}"]
    begin = outside + IDLE
    if what == "encounter":
        actions.append(f"hold:{begin}:20000:{at('gDiagForceEncounter')}:4:1")
    elif what == "tutorial":
        actions.append(f"hold:{begin}:200:{at('gDiagForceTutorial')}:2:1")
    else:
        actions.append(f"hold:{begin}:200:{at('gDiagForceBattleSpecies')}:2:{what.split(':')[1]}")
    roam, done = smoke.legs(["d:60", "u:60", "l:60", "r:60"] * 8, begin + 30)
    actions += roam
    actions += [f"ram:{frame}:{out}/r_{frame:06d}.bin" for frame in range(outside, done + 400, 150)]
    actions += [f"shot:{frame}:{out}/s_{frame:06d}.ppm" for frame in range(begin, done + 400, 600)]
    with tempfile.TemporaryDirectory() as temp:
        print(f"outside at {outside}, switch at {begin}, done at {done}")
        print(smoke.run(smoke.build(temp), smoke.DIAG_ROM, done + 500, actions, temp))
    report(out, DIAG_ELF)


if __name__ == "__main__":
    main()
