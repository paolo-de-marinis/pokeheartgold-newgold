#!/usr/bin/env python3
"""The melonDS libretro core, driven from Python one frame at a time.

boot_check.c runs a list of actions fixed before the run starts; this runs
the same core in-process, so a script can look at memory after every frame
and decide what to press next. That is what lets a battle be played through
the game's own menus with nothing but memory to go on. The frame the core
draws is only copied when asked for (shot), and a battle is drawn in it
like anything else.

    core = Core(rom, save=path)          # a save is put where the core reads it
    core.step(60)                        # run frames
    core.press("A", 6)                   # hold a button for some frames
    core.touch(128, 83, 6)               # touch the bottom screen, in its own pixels
    core.ram()                           # main RAM, as bytes
    core.word(address)                   # one word of it, without copying the rest
    core.poke(address, value, width=4)   # write main RAM
    core.shot()                          # the next frame, both screens, as a PIL image
    Core(rom, save=path, record="run.mp4")   # every frame and its sound, to an mp4

Recording is off unless asked for, and costs nothing then: the audio the
core hands over is dropped and no frame is copied. On, every frame the core
draws (both screens, the top over the bottom) and the samples that came with
it go down two pipes to ffmpeg, which writes H.264 at the DS's own frame rate
(the core's, 59.83 per second) with the game's sound in AAC; close() finishes
the file. A run records at roughly the speed it plays without recording.

Two cores can drive it, picked by NEWGOLD_CORE (a path; Core(core=...) for
one instance): melonDS DS 1.3.1 (MELONDSDS, melonDS 1.x as Paolo's melonDS
is, unpacked under ~/hgss-build/deps/melondsds; the default) and melonDS
0.9.3 (MELONDS, Arch's libretro-melonds, the harness's first). Each boots the ROM directly on
its built-in BIOS and firmware, draws in software, runs without its JIT
(NEWGOLD_JIT=1 turns it on: faster, but on melonDS DS no wild battle ever
starts) and keeps the console's clock at CLOCK; main RAM
is the core's memory 2 on both, from 0x02000000. melonDS 0.9.3 reads and
writes the save file itself; melonDS DS is handed it and gives it back as
memory, and core.py keeps the same file for it (save_file).

Both mix the game's sound alike: the music, the clicks and the cries.

A script calls pin_clock() first, before it does anything else.
"""
import ctypes
import hashlib
import os
import queue
import shutil
import struct
import subprocess
import sys
import tempfile
import threading
from pathlib import Path

# The two cores the harness knows. NEWGOLD_CORE names the one a run uses (a
# path; Core(core=...) overrides it for one instance); NEWGOLD_JIT=1 turns
# either core's JIT recompiler on, off by default.
MELONDS = Path("/usr/lib/libretro/melonds_libretro.so")      # melonDS 0.9.3, Arch's libretro-melonds
MELONDSDS = Path.home() / "hgss-build/deps/melondsds/melondsds_libretro.so"   # melonDS DS 1.3.1
CORE = Path(os.environ.get("NEWGOLD_CORE") or MELONDSDS)
JIT = os.environ.get("NEWGOLD_JIT") == "1"
MAIN_RAM = 0x02000000
BUTTONS = {"B": 0, "Y": 1, "SELECT": 2, "START": 3, "UP": 4, "DOWN": 5, "LEFT": 6, "RIGHT": 7,
           "A": 8, "X": 9, "L": 10, "R": 11}
OPTIONS = {b"melonds_boot_directly": b"enabled", b"melonds_console_mode": b"DS",
           b"melonds_use_external_bios": b"disabled", b"melonds_opengl_renderer": b"disabled",
           b"melonds_threaded_renderer": b"disabled", b"melonds_jit_enable": b"disabled",
           b"melonds_screen_layout": b"Top/Bottom", b"melonds_touch_mode": b"Touch"}

ENV = ctypes.CFUNCTYPE(ctypes.c_bool, ctypes.c_uint, ctypes.c_void_p)
VIDEO = ctypes.CFUNCTYPE(None, ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint, ctypes.c_size_t)
AUDIO = ctypes.CFUNCTYPE(None, ctypes.c_int16, ctypes.c_int16)
AUDIO_BATCH = ctypes.CFUNCTYPE(ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t)
POLL = ctypes.CFUNCTYPE(None)
STATE = ctypes.CFUNCTYPE(ctypes.c_int16, ctypes.c_uint, ctypes.c_uint, ctypes.c_uint, ctypes.c_uint)

# The core sets the console's clock from the host's time, so the RNG's seed
# and the time of day followed the second a run started in, and one replay
# could differ from the next. boot_check.c answers time() itself; in-process
# the core binds the C library's, and only a library preloaded comes before
# it. pin_clock() runs the script again, once, with one that answers CLOCK
# (smoke.CLOCK, test_boot's), in UTC as boot_check's clock: does.
#
# melonDS 0.9.3 asks time() at every read of the console's clock, which then
# stands still at CLOCK. melonDS DS asks clock_gettime(): in its "sync" time
# mode at every frame, so its clock stands still at CLOCK the same way (its
# "real" mode sets the clock once and lets it run, and a wild Pokemon rolled
# after a few seconds of play is then another one). The shim answers that
# call with CLOCK too, but only while Core sets newgold_pin_realtime -- in
# retro_load_game and retro_run -- so the rest of the process keeps the real
# time. (Its "absolute" start-time options would give no seconds: those it
# takes from the host.)
CLOCK = 1700000000
SHIM = r"""
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdlib.h>
#include <time.h>
int newgold_pin_realtime;
time_t time(time_t *out) {
    const char *pinned = getenv("NEWGOLD_CLOCK");
    struct timespec now;
    time_t t;
    if (pinned) {
        t = (time_t)strtoll(pinned, NULL, 10);
    } else {
        clock_gettime(CLOCK_REALTIME, &now);
        t = now.tv_sec;
    }
    if (out) *out = t;
    return t;
}
int clock_gettime(clockid_t id, struct timespec *out) {
    static int (*real)(clockid_t, struct timespec *);
    const char *pinned = newgold_pin_realtime && id == CLOCK_REALTIME ? getenv("NEWGOLD_CLOCK") : NULL;
    if (pinned) {
        out->tv_sec = (time_t)strtoll(pinned, NULL, 10);
        out->tv_nsec = 0;
        return 0;
    }
    if (!real) real = (int (*)(clockid_t, struct timespec *))dlsym(RTLD_NEXT, "clock_gettime");
    return real(id, out);
}
"""


def pin_clock(seconds=CLOCK):
    shim = Path(tempfile.gettempdir()) / f"newgold-clock-{hashlib.sha1(SHIM.encode()).hexdigest()[:8]}.so"
    preload = os.environ.get("LD_PRELOAD", "")
    if os.environ.get("NEWGOLD_CLOCK") == str(seconds) and str(shim) in preload.split():
        return
    if not shim.exists():
        source, built = shim.with_suffix(f".{os.getpid()}.c"), shim.with_suffix(f".{os.getpid()}.tmp")
        source.write_text(SHIM)
        subprocess.run(["cc", "-O2", "-shared", "-fPIC", "-o", str(built), str(source), "-ldl"], check=True)
        source.unlink()
        os.replace(built, shim)
    os.execve(sys.executable, sys.orig_argv, {**os.environ, "NEWGOLD_CLOCK": str(seconds), "TZ": "UTC0",
                                              "LD_PRELOAD": f"{shim} {preload}".strip()})


def ds_options():
    """melonDS DS's options: the software renderer (it asks for no OpenGL
    context then), a DS booted directly on its built-in BIOS and firmware, no
    network, no microphone, no cursor drawn over the touch screen, the two
    screens top over bottom with no gap, and the clock kept at the host's
    time -- CLOCK, under pin_clock()."""
    return {b"melonds_render_mode": b"software", b"melonds_threaded_renderer": b"disabled",
            b"melonds_console_mode": b"ds", b"melonds_boot_mode": b"direct",
            b"melonds_sysfile_mode": b"builtin", b"melonds_network_mode": b"disabled",
            b"melonds_mic_input": b"silence", b"melonds_show_cursor": b"disabled",
            b"melonds_number_of_screen_layouts": b"1", b"melonds_screen_layout1": b"top-bottom",
            b"melonds_screen_gap": b"0", b"melonds_touch_mode": b"touch", b"melonds_dsi_sdcard": b"disabled",
            b"melonds_firmware_language": b"en", b"melonds_firmware_username": b"melonDS DS",
            b"melonds_start_time_mode": b"sync"}


class SystemInfo(ctypes.Structure):
    _fields_ = [("library_name", ctypes.c_char_p), ("library_version", ctypes.c_char_p),
                ("valid_extensions", ctypes.c_char_p), ("need_fullpath", ctypes.c_bool),
                ("block_extract", ctypes.c_bool)]


class AvInfo(ctypes.Structure):
    # struct retro_system_av_info: its geometry, then its timing
    _fields_ = [("base_width", ctypes.c_uint), ("base_height", ctypes.c_uint), ("max_width", ctypes.c_uint),
                ("max_height", ctypes.c_uint), ("aspect", ctypes.c_float), ("fps", ctypes.c_double),
                ("sample_rate", ctypes.c_double)]


class GameInfo(ctypes.Structure):
    _fields_ = [("path", ctypes.c_char_p), ("data", ctypes.c_void_p), ("size", ctypes.c_size_t), ("meta", ctypes.c_char_p)]


class Variable(ctypes.Structure):
    _fields_ = [("key", ctypes.c_char_p), ("value", ctypes.c_char_p)]


class Core:
    def __init__(self, rom, save=None, record=None, core=None):
        self.dir = tempfile.mkdtemp(prefix="newgold-core-")
        self._dir = ctypes.c_char_p(self.dir.encode())
        self.save_file = Path(self.dir) / (Path(rom).stem + ".sav")
        if save:
            shutil.copyfile(save, self.save_file)
        self.buttons, self.touching, self.tx, self.ty = set(), False, 0, 0
        self.frames = 0
        self._grab, self._frame = False, None
        self._ffmpeg, self._sound = None, None
        self.core = Path(core or CORE)
        self.lib = ctypes.CDLL(str(self.core))
        info = SystemInfo()
        self.lib.retro_get_system_info(ctypes.byref(info))
        self.name = f"{info.library_name.decode()} {info.library_version.decode()}"
        self.ds = info.library_name == b"melonDS DS"
        self.options = ds_options() if self.ds else dict(OPTIONS)
        self.options[b"melonds_jit_enable"] = b"enabled" if JIT else b"disabled"
        if JIT and self.ds:
            print("core.py: with melonDS DS's JIT no wild battle starts (the encounter's screen effect "
                  "never ends); scenarios run with NEWGOLD_JIT off", file=sys.stderr)
        self._callbacks = [ENV(self._env), VIDEO(self._video), AUDIO(self._sample),
                           AUDIO_BATCH(self._samples), POLL(lambda: None), STATE(self._input)]
        env, video, audio, batch, poll, state = self._callbacks
        self.lib.retro_set_environment(env)
        self.lib.retro_set_video_refresh(video)
        self.lib.retro_set_audio_sample(audio)
        self.lib.retro_set_audio_sample_batch(batch)
        self.lib.retro_set_input_poll(poll)
        self.lib.retro_set_input_state(state)
        self.lib.retro_init()
        self._rom = Path(rom).read_bytes()
        self._rombuf = ctypes.create_string_buffer(self._rom, len(self._rom))
        info = GameInfo(str(rom).encode(), ctypes.cast(self._rombuf, ctypes.c_void_p), len(self._rom), None)
        try:
            self._pin = ctypes.c_int.in_dll(ctypes.CDLL(None), "newgold_pin_realtime")
        except ValueError:      # no pin_clock(): the host's time, as it always was
            self._pin = ctypes.c_int()
        self._pin.value = 1
        loaded = self.lib.retro_load_game(ctypes.byref(info))
        self._pin.value = 0
        if not loaded:
            raise SystemExit("the core would not load the ROM")
        self.lib.retro_get_memory_data.restype = ctypes.c_void_p
        self.lib.retro_get_memory_size.restype = ctypes.c_size_t
        # melonDS 0.9.3 reads and writes <save directory>/<rom>.sav itself;
        # melonDS DS hands the save to the frontend as memory, which is filled
        # from that file here, before the first frame, and written back to it
        # when it changes (every second of the game's time, and at close()).
        self._sram = None
        if self.ds:
            self._sram = (self.lib.retro_get_memory_data(0), self.lib.retro_get_memory_size(0))
            if save:
                data = Path(save).read_bytes()[:self._sram[1]]
                ctypes.memmove(self._sram[0], data, len(data))
            self._saved = ctypes.string_at(*self._sram)
        if record:
            self.record(record)

    def record(self, path):
        """From the next frame on, the picture and the sound to an mp4 at
        `path`, through ffmpeg; close() finishes it."""
        av = AvInfo()
        self.lib.retro_get_system_av_info(ctypes.byref(av))
        self._recording = path
        self._size = (av.base_width, av.base_height)
        # ffmpeg takes raw sound at a whole number of samples a second, and
        # melonDS DS mixes 32728.498 (33513982/1024): labelled 32728, the
        # sound would run 15 ppm slow and end 55 ms after the picture an hour
        # in. The picture is labelled slow by the same factor, and the two
        # stay together.
        rate = int(av.sample_rate)
        audio, into = os.pipe()
        self._ffmpeg = subprocess.Popen(
            ["ffmpeg", "-loglevel", "error", "-y",
             "-probesize", "32", "-f", "rawvideo", "-pix_fmt", "bgr0", "-s", f"{av.base_width}x{av.base_height}",
             "-framerate", f"{av.fps * rate / av.sample_rate:.6f}", "-i", "pipe:0",
             "-probesize", "32", "-f", "s16le", "-ar", str(rate), "-ac", "2", "-i", f"pipe:{audio}",
             # twice the size, pixels kept square and sharp; the sound as it
             # was mixed, which the AAC encoder resamples to 32 kHz
             "-vf", "scale=iw*2:ih*2:flags=neighbor", "-c:v", "libx264", "-preset", "veryfast",
             "-crf", "18", "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "160k", str(path)],
            stdin=subprocess.PIPE, pass_fds=(audio,))
        os.close(audio)
        # The sound goes down its pipe from a thread of its own: ffmpeg reads
        # its two inputs as it pleases -- the first frames of one while the
        # other waits -- and one thread writing both blocked on the one
        # ffmpeg was not reading, forever.
        self._sound, self._sounds = bytearray(), queue.Queue()
        self._silence, self._heard = bytes(4 * round(av.sample_rate / av.fps)), False
        sound_pipe = os.fdopen(into, "wb")

        def pour():
            for chunk in iter(self._sounds.get, None):
                sound_pipe.write(chunk)
                sound_pipe.flush()
            sound_pipe.close()
        self._pourer = threading.Thread(target=pour, daemon=True)
        self._pourer.start()
        self._grab = True

    def _sample(self, left, right):
        if self._sound is not None:
            self._sound += struct.pack("<hh", left, right)

    def _samples(self, data, frames):
        if self._sound is not None:
            self._sound += ctypes.string_at(data, frames * 4)
        return frames

    def _record(self):
        if self._frame is not None:
            data, width, height, pitch = self._frame
            if pitch != width * 4:
                data = b"".join(data[row * pitch:row * pitch + width * 4] for row in range(height))
            self._ffmpeg.stdin.write(data)      # a frame the core did not draw repeats the last
        if not self._heard and not self._sound:
            # melonDS 0.9.3 hands over no sound with its first frame, and
            # every sound after it came a frame early: a frame's silence there
            self._sound += self._silence
        else:
            self._heard = True
        self._sounds.put(bytes(self._sound))
        self._sound.clear()

    def _stop_recording(self):
        self._ffmpeg.stdin.close()
        self._sounds.put(None)
        self._pourer.join()
        failed = self._ffmpeg.wait()
        self._ffmpeg, self._sound, self._grab = None, None, False
        if failed:      # the mp4's index is written last: a full disk shows only here
            raise RuntimeError(f"ffmpeg could not finish {self._recording} (exit {failed})")

    def _env(self, cmd, data):
        if cmd in (9, 31):  # system and save directory
            ctypes.cast(data, ctypes.POINTER(ctypes.c_char_p))[0] = self._dir.value
            return True
        if cmd == 15:  # a core option
            var = ctypes.cast(data, ctypes.POINTER(Variable))[0]
            value = self.options.get(var.key)
            if value is None:
                return False
            ctypes.cast(data, ctypes.POINTER(Variable))[0].value = value
            return True
        if cmd == 10:  # pixel format: XRGB8888 is 1
            return ctypes.cast(data, ctypes.POINTER(ctypes.c_int))[0] == 1
        if cmd in (2, 3):
            ctypes.cast(data, ctypes.POINTER(ctypes.c_bool))[0] = cmd == 3
            return True
        if cmd == 17:
            ctypes.cast(data, ctypes.POINTER(ctypes.c_bool))[0] = False
            return True
        if cmd == 52:
            ctypes.cast(data, ctypes.POINTER(ctypes.c_uint))[0] = 0
            return True
        return cmd in (6, 8, 11, 16, 18, 32, 34, 35, 36, 37, 53, 54, 55, 62, 63, 67, 68)

    def _video(self, data, width, height, pitch):
        # Copied only when asked for: a frame is 384 KB, every frame.
        if self._grab and data:
            self._frame = (ctypes.string_at(data, pitch * height), width, height, pitch)

    def _input(self, port, device, index, id_):
        if port:
            return 0
        if device == 6:  # pointer
            return {0: self.tx, 1: self.ty, 2: int(self.touching)}.get(id_, 0)
        if device == 1:
            return int(id_ in self.buttons)
        return 0

    def step(self, frames=1, hooks=()):
        for _ in range(frames):
            for hook in hooks:
                hook(self)
            self._pin.value = 1
            self.lib.retro_run()
            self._pin.value = 0
            self.frames += 1
            if self._ffmpeg:
                self._record()
            if self._sram and self.frames % 60 == 0:
                self._write_save()

    def _write_save(self):
        now = ctypes.string_at(*self._sram)
        if now != self._saved:
            self.save_file.write_bytes(now)
            self._saved = now

    def press(self, button, frames=6, hooks=()):
        self.buttons = {BUTTONS[button]}
        self.step(frames, hooks)
        self.buttons = set()
        self.step(4, hooks)

    def touch(self, x, y, frames=6, hooks=()):
        # the pointer spans both screens, top over bottom, -0x7FFF..0x7FFF
        self.tx = int(((x / 256.0) * 2 - 1) * 0x7FFF)
        self.ty = int((((y + 192) / 384.0) * 2 - 1) * 0x7FFF)
        self.touching = True
        self.step(frames, hooks)
        self.touching = False
        self.step(4, hooks)

    def shot(self, hooks=()):
        """The next frame the core draws: the top screen over the bottom one."""
        from PIL import Image
        recording, self._grab = self._grab, True
        self.step(1, hooks)
        self._grab = recording
        data, width, height, pitch = self._frame
        return Image.frombuffer("RGBX", (width, height), data, "raw", "BGRX", pitch, 1).convert("RGB")

    def ram(self):
        return ctypes.string_at(self.lib.retro_get_memory_data(2), self.lib.retro_get_memory_size(2))

    def word(self, address, width=4):
        base = self.lib.retro_get_memory_data(2)
        return int.from_bytes(ctypes.string_at(base + address - MAIN_RAM, width), "little")

    def poke(self, address, value, width=4):
        base = self.lib.retro_get_memory_data(2)
        ctypes.memmove(base + address - MAIN_RAM, int(value).to_bytes(width, "little"), width)

    def state(self):
        """The core's savestate, in melonDS's own format: a run that finds
        the game stuck writes it to a file, and frozen.py reads the ARM9."""
        self.lib.retro_serialize_size.restype = ctypes.c_size_t
        size = self.lib.retro_serialize_size()
        buffer = ctypes.create_string_buffer(size)
        if not self.lib.retro_serialize(buffer, ctypes.c_size_t(size)):
            raise RuntimeError("the core would not write its state")
        return buffer.raw

    def close(self):
        if self._sram:
            self._write_save()
        self.lib.retro_unload_game()
        self.lib.retro_deinit()
        shutil.rmtree(self.dir, ignore_errors=True)
        if self._ffmpeg:        # last, so a recording that failed leaves the rest closed
            self._stop_recording()
