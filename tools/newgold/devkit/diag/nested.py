#!/usr/bin/env python3
"""melonDS on a display of its own, where nothing reaches the desktop.

    nested.py start ROM [SAVE]  a headless KWin, an X server inside it and the
                                melonDS flatpak on that, from a copy of ROM and SAVE
    nested.py press KEYS...     A B X Y L R up down left right start select; tX,Y taps
                                the bottom screen at DS pixel (X, Y); a number waits
                                that many frames
    nested.py shot OUT.png      the window: the menu bar, then both screens at 1:1
    nested.py stop              everything start started

play.py drives the melonDS on the desktop, through KWin, a virtual keyboard
and Spectacle, all of which reach the desktop session. Here KWin runs with
its virtual backend, its own D-Bus and its own runtime directory; a rootful
Xwayland is a window in it, and its XTEST keeps the keys and taps inside
that X server (the rootless Xwayland KWin would start sends XTEST on to the
compositor, which drops it). melonDS gets a HOME of its own -- its config,
with the keys bound below, and nothing of the player's -- and no sound
socket. The state, the ROM copy and the save live in build/nested/; the
save is melonDS's own, next to the ROM copy.
"""
import os
import re
import shutil
import signal
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
STATE = ROOT / "build/nested"
APP = "net.kuribo64.melonDS"
CONFIG = f"home/.var/app/{APP}/config/melonDS/melonDS.toml"
# The DS buttons as melonDS's config names them, the Qt key code bound to
# each, and the X keysym that presses it.
KEYS = {"A": (90, "z"), "B": (88, "x"), "X": (83, "s"), "Y": (65, "a"), "L": (81, "q"), "R": (87, "w"),
        "Up": (16777235, "Up"), "Down": (16777237, "Down"), "Left": (16777234, "Left"),
        "Right": (16777236, "Right"), "Start": (16777220, "Return"), "Select": (16777219, "BackSpace")}
BUTTONS = {k.lower(): k for k in KEYS}
MENU, SCREEN = 19, 192   # the window's menu bar, and a DS screen's height
FRAME = 1 / 60


def _env(**more):
    return {"PATH": "/usr/bin:/bin", "HOME": str(STATE / "home"), "XDG_RUNTIME_DIR": str(STATE / "run"),
            "LANG": "C.UTF-8", **more}


def _wait(what, check, seconds=30):
    end = time.time() + seconds
    while not check():
        if time.time() > end:
            raise SystemExit(f"{what} did not come up; see {STATE}/*.log")
        time.sleep(0.2)


def _spawn(name, argv, env):
    log = open(STATE / f"{name}.log", "w")
    process = subprocess.Popen(argv, env=env, stdout=log, stderr=log, start_new_session=True)
    (STATE / f"{name}.pid").write_text(str(process.pid))


def _display():
    return (STATE / "display").read_text().strip()


def bind(text):
    """A melonDS config with its [Instance0.Keyboard] bindings set to KEYS,
    the table added if it has none -- with its parent, which melonDS's
    writer will not leave implicit."""
    if "[Instance0]" not in text:
        text += "\n[Instance0]\n"
    if "[Instance0.Keyboard]" not in text:
        text += "\n[Instance0.Keyboard]\n"
    start = text.index("[Instance0.Keyboard]")
    end = text.find("\n[", start + 1)
    end = len(text) if end < 0 else end
    block = text[start:end]
    for button, (code, _) in KEYS.items():
        block, found = re.subn(rf"^{button} = -?\d+$", f"{button} = {code}", block, flags=re.M)
        if not found:
            block = block.rstrip("\n") + f"\n{button} = {code}\n"
    return text[:start] + block + text[end:]


def start(rom, save=None):
    if (STATE / "kwin.pid").exists():
        raise SystemExit("already started: nested.py stop first")
    (STATE / "run").mkdir(parents=True, exist_ok=True)
    (STATE / "run").chmod(0o700)
    (STATE / "home").mkdir(exist_ok=True)
    shutil.copyfile(rom, STATE / "home/rom.nds")
    (STATE / "home/rom.sav").unlink(missing_ok=True)
    if save:
        shutil.copyfile(save, STATE / "home/rom.sav")
    socket = f"newgold-{os.getpid()}"
    _spawn("kwin", ["dbus-run-session", "--", "kwin_wayland", "--virtual", "--socket", socket,
                    "--width", "1024", "--height", "768"], _env())
    _wait("KWin", (STATE / "run" / socket).exists)
    number = next(n for n in range(20, 100) if not Path(f"/tmp/.X{n}-lock").exists()
                  and not Path(f"/tmp/.X11-unix/X{n}").exists())
    (STATE / "display").write_text(f":{number}")
    _spawn("xwayland", ["Xwayland", f":{number}", "-geometry", "1000x740"], _env(WAYLAND_DISPLAY=socket))
    _wait("Xwayland", Path(f"/tmp/.X11-unix/X{number}").exists)
    melon = ["flatpak", "run", "--nosocket=wayland", "--socket=x11", "--nosocket=pulseaudio",
             "--env=SDL_AUDIODRIVER=dummy", APP]
    config = STATE / CONFIG
    config.parent.mkdir(parents=True, exist_ok=True)
    config.write_text(bind(config.read_text() if config.exists() else ""))
    _spawn("melonds", melon + [str(STATE / "home/rom.nds")], _env(DISPLAY=f":{number}", QT_QPA_PLATFORM="xcb"))
    _wait("melonDS's window", lambda: _window() is not None)
    print(f"melonDS on {_display()}, {STATE}")


def stop_one(name):
    """Its process group, asked to end and then made to: Xwayland removes its
    socket and lock only when asked."""
    pid = STATE / f"{name}.pid"
    if pid.exists():
        group = int(pid.read_text())
        for sig in (signal.SIGTERM, signal.SIGKILL):
            try:
                os.killpg(group, sig)
            except ProcessLookupError:
                break
            time.sleep(1)
        pid.unlink()


def stop():
    for name in ("melonds", "xwayland", "kwin"):
        stop_one(name)
    print("stopped")


def _x():
    from Xlib import display
    return display.Display(_display())


def _window(d=None):
    from Xlib import X
    d = d or _x()

    def walk(w):
        for child in w.query_tree().children:
            try:
                if child.get_attributes().map_state == X.IsViewable and "melonDS" in str(child.get_wm_name()) \
                        and child.get_geometry().height > SCREEN:
                    return child
            except Exception:
                continue
            found = walk(child)
            if found:
                return found
        return None
    return walk(d.screen().root)


def press(words):
    from Xlib import X, XK
    from Xlib.ext import xtest
    d = _x()
    w = _window(d)
    w.set_input_focus(X.RevertToParent, X.CurrentTime)
    d.sync()
    for word in words:
        if word.isdigit():
            time.sleep(int(word) * FRAME)
        elif word.startswith("t") and "," in word:
            x, y = map(int, word[1:].split(","))
            at = d.screen().root.translate_coords(w, 0, 0)   # the window in root coordinates
            xtest.fake_input(d, X.MotionNotify, x=at.x + x, y=at.y + MENU + SCREEN + y)
            d.sync()
            time.sleep(2 * FRAME)
            for event, frames in ((X.ButtonPress, 8), (X.ButtonRelease, 4)):
                xtest.fake_input(d, event, 1)
                d.sync()
                time.sleep(frames * FRAME)
        elif word.lower() in BUTTONS:
            code = d.keysym_to_keycode(XK.string_to_keysym(KEYS[BUTTONS[word.lower()]][1]))
            for event, frames in ((X.KeyPress, 6), (X.KeyRelease, 4)):
                xtest.fake_input(d, event, code)
                d.sync()
                time.sleep(frames * FRAME)
        else:
            raise SystemExit(f"{word}: a button ({' '.join(BUTTONS)}), tX,Y or a number of frames")


def shot(out):
    from PIL import Image
    from Xlib import X
    w = _window()
    g = w.get_geometry()
    raw = w.get_image(0, 0, g.width, g.height, X.ZPixmap, 0xFFFFFFFF)
    Image.frombytes("RGB", (g.width, g.height), raw.data, "raw", "BGRX").save(out)
    print(out)


def main():
    command, args = (sys.argv[1] if len(sys.argv) > 1 else "help"), sys.argv[2:]
    if command == "start" and args:
        start(*args[:2])
    elif command == "press":
        press(args)
    elif command == "shot" and args:
        shot(args[0])
    elif command == "stop":
        stop()
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
