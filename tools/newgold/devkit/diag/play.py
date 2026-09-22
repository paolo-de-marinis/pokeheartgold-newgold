#!/usr/bin/env python3
"""Drive the melonDS on this desktop: press its keys, look at its window.

    play.py launch [ROM]        start melonDS (the flatpak) on a ROM, the diag build by default
    play.py focus               bring its window to the front (KWin, over D-Bus)
    play.py press KEYS...       tap keys in order: A B X Y up down left right start select, or a
                                number of frames to wait, e.g. `press A 30 A A down A`
    play.py hold KEY FRAMES     hold one key for that many frames (walking)
    play.py shot [OUT.png]      capture its window (Spectacle, the active window)
    play.py quit                close it

Keys go in through a virtual keyboard (/dev/uinput, the evdev module), so the
window has to be the active one: press and shot focus it first. The mapping is
read from melonDS's own config, so it is whatever the player set. Start and
Select are unbound there by default; `play.py bind` writes Enter and Backspace
for them, with melonDS closed.
"""
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
APP = "net.kuribo64.melonDS"
CONFIG = Path.home() / f".var/app/{APP}/config/melonDS/melonDS.toml"
DIAG_ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
FRAME = 1 / 60

# Qt key codes, as melonDS writes them, to evdev names.
QT_TO_EVDEV = {**{ord(c): f"KEY_{c}" for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"},
               16777235: "KEY_UP", 16777237: "KEY_DOWN", 16777234: "KEY_LEFT", 16777236: "KEY_RIGHT",
               16777220: "KEY_ENTER", 16777219: "KEY_BACKSPACE", 32: "KEY_SPACE"}
BUTTONS = ("A", "B", "X", "Y", "L", "R", "Up", "Down", "Left", "Right", "Start", "Select")


def mapping():
    text = CONFIG.read_text()
    block = text[text.index("[Instance0.Keyboard]"):]
    block = block[:block.find("\n[", 1)] if "\n[" in block[1:] else block
    found = {}
    for button in BUTTONS:
        m = re.search(rf"^{button} = (-?\d+)$", block, re.M)
        if m and int(m.group(1)) in QT_TO_EVDEV:
            found[button.lower()] = QT_TO_EVDEV[int(m.group(1))]
    return found


def focus():
    script = 'workspace.windowList().forEach(function (w) { if (w.resourceClass == "%s") { workspace.activeWindow = w; } });' % APP
    with tempfile.NamedTemporaryFile("w", suffix=".js", delete=False) as f:
        f.write(script)
    number = subprocess.run(["qdbus6", "org.kde.KWin", "/Scripting", "org.kde.kwin.Scripting.loadScript", f.name],
                            capture_output=True, text=True).stdout.strip()
    subprocess.run(["qdbus6", "org.kde.KWin", "/Scripting", "org.kde.kwin.Scripting.start"], capture_output=True)
    time.sleep(0.3)
    subprocess.run(["qdbus6", "org.kde.KWin", f"/Scripting/Script{number}", "org.kde.kwin.Script.stop"], capture_output=True)
    os.unlink(f.name)


def keyboard():
    from evdev import UInput, ecodes  # noqa: F401
    return UInput(name="newgold-play")


def tap(ui, key, frames=6):
    from evdev import ecodes
    code = getattr(ecodes, key)
    ui.write(ecodes.EV_KEY, code, 1); ui.syn(); time.sleep(frames * FRAME)
    ui.write(ecodes.EV_KEY, code, 0); ui.syn(); time.sleep(4 * FRAME)


def main():
    command, args = (sys.argv[1] if len(sys.argv) > 1 else "help"), sys.argv[2:]
    if command == "launch":
        rom = Path(args[0]) if args else DIAG_ROM
        subprocess.Popen(["flatpak", "run", APP, str(rom)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"launched melonDS on {rom}")
    elif command == "quit":
        subprocess.run(["flatpak", "kill", APP]); print("closed")
    elif command == "focus":
        focus(); print("focused")
    elif command == "shot":
        out = Path(args[0]) if args else Path(tempfile.gettempdir()) / "melonds.png"
        focus(); time.sleep(0.3)
        subprocess.run(["spectacle", "-a", "-b", "-n", "-o", str(out)], capture_output=True)
        print(out)
    elif command in ("press", "hold"):
        keys = mapping()
        focus(); time.sleep(0.3)
        ui = keyboard()
        try:
            if command == "hold":
                tap(ui, keys[args[0].lower()], int(args[1]))
            else:
                for word in args:
                    if word.isdigit():
                        time.sleep(int(word) * FRAME)
                    elif word.lower() in keys:
                        tap(ui, keys[word.lower()])
                    else:
                        raise SystemExit(f"{word} is not bound in melonDS; play.py bind sets Start and Select")
        finally:
            ui.close()
        print("pressed", " ".join(args))
    elif command == "bind":
        if subprocess.run(["pgrep", "-x", "melonDS"], capture_output=True).returncode == 0:
            raise SystemExit("close melonDS first; it writes its config on exit")
        text = CONFIG.read_text()
        text = re.sub(r"^Start = -1$", "Start = 16777220", text, count=1, flags=re.M)
        text = re.sub(r"^Select = -1$", "Select = 16777219", text, count=1, flags=re.M)
        CONFIG.write_text(text); print("Start is Enter, Select is Backspace")
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
