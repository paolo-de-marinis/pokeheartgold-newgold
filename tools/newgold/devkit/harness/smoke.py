#!/usr/bin/env python3
"""Boot a built ROM in an emulator and look at what comes up.

Every test beside this one reads source or data. None of them can tell whether
the ROM starts, and the changes that would stop it starting — the save region,
the heaps — are exactly the ones whose failure is a silent assertion at boot
rather than a build error.

This drives the melonDS libretro core directly, with no emulator front end and
no BIOS of its own: boot_check.c is a headless libretro host, about two hundred
lines, that loads a ROM, runs frames, presses buttons, touches the screen and
writes out what was on it.

    smoke.py --frames 3000 --shot 2999 --out /tmp/shots

Usage without arguments boots both ROMs far enough to know they are running.

boot_check.c takes its actions on the command line, one per argument:

    press:FRAME:LEN:BUTTON          a joypad button, by libretro's id
    mash:FROM:UNTIL:PERIOD:LEN:BUTTON   the same, every PERIOD frames
    touch:FRAME:LEN:X:Y             the touch screen, in its own pixels
    tap:FROM:UNTIL:PERIOD:LEN:X:Y   the same, every PERIOD frames
    shot:FRAME:PATH                 write the framebuffer out
    save:FRAME:PATH                 write the emulator's state out
    load:PATH                       start from a state instead of a boot
    clock:SECONDS                   the host clock the core reads, pinned
    ram:FRAME:PATH                  write the console's own memory out

save and load are what make anything past the opening practical: reaching the
overworld by script is twenty thousand frames of tutorial, and a state taken
there costs one frame to return to.

ram is for finishing the route. Aiming the last few tiles of a walk by eye
from screenshots does not converge — the camera moves with the player, so the
picture says where things are relative to each other and not where the player
is. Dumping the memory at two positions and looking for the halfword that
changed by one is how to find where the game keeps the answer.
"""

import argparse
import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
HOST = Path(__file__).resolve().parent / "boot_check.c"
CORE = Path("/usr/lib/libretro/melonds_libretro.so")
ROMS = {
    "heartgold": ROOT / "build/heartgold.us/pokeheartgold.us.nds",
    "soulsilver": ROOT / "build/soulsilver.us/pokesoulsilver.us.nds",
}
# The build with the diagnostics in (make NEWGOLD_DIAG=1 COMPARE=0); the
# readers in tools/newgold/devkit/diag want this one.
DIAG_ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"

# Enough to get past the publisher screens, the intro and the title, which is
# where a save or heap that does not fit would have stopped it.
OPENING = ["press:1000:10:8", "press:1200:10:3", "press:1500:10:8",
           "press:1800:10:3", "press:2100:10:8", "press:2400:10:8"]

# A route through the opening, found frame by frame and kept so it need not be
# found again. Each stage carries on from the one before it, so --to outside
# runs all of them; the whole thing is about two and a half minutes.
#
# The opening is scripted and takes no random turns, so the same frames give
# the same result every time. What it does not survive is a change to the game
# that moves any of it: if a stage stops arriving where it says, the frames
# after it are wrong rather than the game.
ROUTES = {
    # Publisher screens, the sunrise, the title, the controls tutorial (touch
    # only), the "do you understand" prompt and the information menu.
    "name": [
        "mash:900:3000:40:6:8",
        "tap:3000:26000:70:12:225:163",     # the Touch panel, bottom right
        "tap:12000:26000:410:12:128:73",    # Yes, when it is asked
        "tap:12200:26000:430:12:128:153",   # NO INFO NEEDED
        "mash:16000:26000:60:8:8",
        "mash:26100:26600:40:8:8",          # a letter, so the name is not empty
    ],
    # OK on the keyboard, then the rest of the professor's introduction.
    "bedroom": [
        "tap:27180:27380:60:15:215:71",     # OK
        "mash:27470:31050:40:8:8",
        "tap:27550:31050:120:12:225:163",
    ],
    # Up and left to the stairs, down them, and through the conversation.
    "downstairs": [
        "press:31150:250:4", "press:31430:350:6", "press:31810:250:4",
        "press:32090:250:6", "press:32370:150:4",
        "mash:32600:35500:25:8:8",
    ],
    # Out of the front door, into New Bark Town.
    "outside": ["press:35550:400:5", "press:35980:250:5"],
    # West across the town, past the man who stops you leaving, to the sign,
    # and in through the laboratory door, then through the Professor's speech.
    "lab": [
        "press:36530:20:0",                 # close the menu the walk opened
        "press:36600:250:5", "press:36880:650:6", "press:37610:450:4",
        "press:38130:300:7", "press:38490:250:4",
        "mash:38760:39100:25:8:8",
        "press:39140:250:7", "press:39450:200:4",
        "press:39720:150:7", "press:39900:300:4", "press:40230:150:5",
        "press:40410:350:6", "press:40820:400:4",
        "mash:41280:45200:25:8:8",
    ],
    # Face the Professor, hear him out, then four tiles right and one up to
    # stand under the machine the starters are on, and take one. The tile is
    # the whole trick: one either side of it and the press finds a memo.
    "starter": [
        "press:45550:60:4",
        "mash:45650:59000:25:8:8",
        "press:59100:20:0",
        "press:59160:19:7", "press:59192:19:7", "press:59224:9:7",
        "press:59250:19:4", "press:59290:8:4",
        "press:59320:50:8",
        "mash:59410:60100:30:8:8",
        "mash:60150:61400:40:10:0",         # no, it does not want a nickname
    ],
    # The menu, the party, that Pokemon, its summary, and right one page to
    # the stats. L, R and Select answer from there.
    "skills": [
        "mash:61500:62900:35:10:8",
        "press:63000:20:9",
        "touch:63200:25:42:74",             # POKEMON
        "touch:63900:25:60:25",             # the first party slot
        "touch:64600:25:192:40",            # SUMMARY
        "press:65300:15:7",
    ],
}
ROUTE_FRAMES = {"name": 27200, "bedroom": 31100, "downstairs": 35500,
                "outside": 36500, "lab": 45500, "starter": 61450, "skills": 65900}


# Past the opening the route is better kept as legs than as frame numbers: a
# leg is "hold this direction this long", and the frames are worked out from
# the list, so inserting one step does not move every number after it.
#
# Each leg is preceded by a touch on RUN, in case a wild battle has started,
# and by a mash of B, which closes a message box. That matters more than it
# sounds: walking into a wall or an NPC opens one, and every later direction
# press is then eaten by it, which reads exactly like a wall that is not there.
# A leg of "m" mashes A instead, for a conversation, which B will not advance.
LEG_RUN = (127, 172)        # the RUN button, in the bottom screen's own pixels
LEG_ESCAPE = 25             # frames to hold that touch
LEG_CLEAR = 240             # frames of B before the leg
LEG_SETTLE = 20             # frames after it, so a sample is not mid-step
BUTTONS = {"u": 4, "d": 5, "l": 6, "r": 7, "a": 8}


def legs(route, start=300):
    """The actions for a list of "direction:frames" legs."""
    actions, frame = [], start
    for leg in route:
        direction, hold = leg.split(":")
        hold = int(hold)
        if direction == "m":
            actions.append(f"mash:{frame}:{frame + hold}:30:8:8")
            frame += hold + LEG_SETTLE
            continue
        actions.append(f"touch:{frame}:{LEG_ESCAPE}:{LEG_RUN[0]}:{LEG_RUN[1]}")
        frame += LEG_ESCAPE + 15
        actions.append(f"mash:{frame}:{frame + LEG_CLEAR}:30:8:0")
        frame += LEG_CLEAR + LEG_SETTLE
        actions.append(f"press:{frame}:{hold}:{BUTTONS[direction]}")
        frame += hold + LEG_SETTLE
    return actions, frame


# Found leg by leg against the built ROM, and kept so it need not be found
# again. It carries on from the state --to starter leaves, after Professor
# Elm's speech has been mashed through.
#
# The town will not let the player leave without the Pokegear -- the man at the
# western edge says so, in msg_0542_T20 rows 10 and 11 -- so the route goes
# home for it first. The door of the house is entered from the tile below it,
# which is why the walk drops to z=402 before lining up on x=695.
WALKS = {
    # Out of the laboratory, through Lyra's speech, into the house, to the
    # mother, and out again with the Pokegear in the menu.
    "pokegear": ["m:2500",                              # the aide's Poke Balls
                 "d:400", "d:300", "l:300", "d:300",    # down and out the door
                 "m:3000",                              # Lyra, outside the lab
                 "r:200", "d:100", "r:50", "u:250",     # onto the house's door
                 "r:60", "l:12", "m:2500",              # up to the mother
                 "u:12", "m:2500", "d:12", "m:2500",
                 # Out again. The door is one tile wide at x=3, and counting
                 # frames onto it does not land: the walk goes to the west wall
                 # and comes back a single tile, which is the same every run.
                 "d:250", "l:200", "r:12", "d:150"],
    # West out of the town -- the man at the edge takes a mash of A once the
    # Pokegear is in the bag -- and onto Route 29. The route's eastern corridor
    # is closed at x=651 for every row between z=394 and z=407: the way past is
    # the shore at z=410, and then z=412, which is south of every object the
    # map declares.
    "route29": ["l:400", "m:1500", "l:400",             # past the man, onto R29
                "d:700", "l:300", "d:60", "l:300",      # down to the shore
                "d:60", "l:400", "u:200", "l:150"],     # west along it, to x=606
}



def build(into):
    host = Path(into) / "boot_check"
    # -rdynamic: the core binds to the host's time(), which clock: pins.
    result = subprocess.run(["cc", "-O2", "-rdynamic", "-o", str(host), str(HOST), "-ldl"],
                            capture_output=True, text=True)
    if result.returncode != 0:
        raise SystemExit(result.stderr.strip())
    return host


def run(host, rom, frames, actions, workdir):
    system = Path(workdir) / "system"
    system.mkdir(exist_ok=True)
    result = subprocess.run([str(host), str(CORE), str(rom), str(system), str(frames)] + actions,
                            capture_output=True, text=True, timeout=900)
    ran = [l for l in result.stdout.splitlines() if l.startswith("ran ")]
    if not ran:
        raise SystemExit(f"{rom.name} did not run: {result.stdout} {result.stderr[-400:]}")
    return ran[0]


def to_png(source, destination):
    data = source.read_bytes()
    fields, at = [], 0
    while len(fields) < 4:
        while data[at:at + 1].isspace():
            at += 1
        end = at
        while not data[end:end + 1].isspace():
            end += 1
        fields.append(data[at:end])
        at = end
    at += 1
    width, height = int(fields[1]), int(fields[2])
    pixels = data[at:at + width * height * 3]
    raw = b"".join(b"\x00" + pixels[y * width * 3:(y + 1) * width * 3] for y in range(height))
    def chunk(kind, body):
        return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))
    destination.write_bytes(b"\x89PNG\r\n\x1a\n"
                            + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
                            + chunk(b"IDAT", zlib.compress(raw, 6))
                            + chunk(b"IEND", b""))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--frames", type=int, default=3000)
    parser.add_argument("--shot", type=int, action="append", default=[])
    parser.add_argument("--out", type=Path)
    parser.add_argument("--rom", choices=sorted(ROMS), action="append", default=[])
    parser.add_argument("--to", choices=list(ROUTES), help="play the opening this far")
    parser.add_argument("--state", type=Path, help="write the emulator's state out at the end")
    args = parser.parse_args()

    if not CORE.exists():
        raise SystemExit(f"{CORE} is not installed")
    out = args.out or Path(tempfile.mkdtemp(prefix="newgold-smoke-"))
    out.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="newgold-smoke-") as temp:
        host = build(temp)
        for name in args.rom or sorted(ROMS):
            rom = ROMS[name]
            if not rom.exists():
                print(f"  {name}: not built")
                continue
            if args.to:
                stages = list(ROUTES)[:list(ROUTES).index(args.to) + 1]
                opening = [action for stage in stages for action in ROUTES[stage]]
                frames = ROUTE_FRAMES[args.to]
            else:
                opening, frames = OPENING, args.frames
            shots = args.shot or [frames - 1]
            actions = opening + [f"shot:{at}:{Path(temp) / f'{name}-{at}.ppm'}" for at in shots]
            if args.state:
                actions.append(f"save:{frames - 10}:{args.state}")
            line = run(host, rom, frames, actions, temp)
            for at in shots:
                ppm = Path(temp) / f"{name}-{at}.ppm"
                if ppm.exists():
                    to_png(ppm, out / f"{name}-{at}.png")
            print(f"  {name}: {line}")
    print(f"captures in {out}")


if __name__ == "__main__":
    main()
