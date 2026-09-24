#!/usr/bin/env python3
"""The melonDS libretro core, driven from Python one frame at a time.

boot_check.c runs a list of actions fixed before the run starts; this runs
the same core in-process, so a script can look at memory after every frame
and decide what to press next. That is what lets a battle be played through
the game's own menus with nothing but memory to go on. The frame the core
draws is only copied when asked for (shot); a battle draws black here.

    core = Core(rom, save=path)          # a save is put where the core reads it
    core.step(60)                        # run frames
    core.press("A", 6)                   # hold a button for some frames
    core.touch(128, 83, 6)               # touch the bottom screen, in its own pixels
    core.ram()                           # main RAM, as bytes
    core.poke(address, value, width=4)   # write main RAM
    core.shot()                          # the next frame, both screens, as a PIL image
"""
import ctypes
import os
import shutil
import tempfile
from pathlib import Path

CORE = Path("/usr/lib/libretro/melonds_libretro.so")
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


class GameInfo(ctypes.Structure):
    _fields_ = [("path", ctypes.c_char_p), ("data", ctypes.c_void_p), ("size", ctypes.c_size_t), ("meta", ctypes.c_char_p)]


class Variable(ctypes.Structure):
    _fields_ = [("key", ctypes.c_char_p), ("value", ctypes.c_char_p)]


class Core:
    def __init__(self, rom, save=None):
        self.dir = tempfile.mkdtemp(prefix="newgold-core-")
        self._dir = ctypes.c_char_p(self.dir.encode())
        if save:
            shutil.copyfile(save, Path(self.dir) / (Path(rom).stem + ".sav"))
        self.buttons, self.touching, self.tx, self.ty = set(), False, 0, 0
        self.frames = 0
        self._grab, self._frame = False, None
        self.lib = ctypes.CDLL(str(CORE))
        self._callbacks = [ENV(self._env), VIDEO(self._video), AUDIO(lambda l, r: None),
                           AUDIO_BATCH(lambda d, n: n), POLL(lambda: None), STATE(self._input)]
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
        if not self.lib.retro_load_game(ctypes.byref(info)):
            raise SystemExit("the core would not load the ROM")
        self.lib.retro_get_memory_data.restype = ctypes.c_void_p
        self.lib.retro_get_memory_size.restype = ctypes.c_size_t

    def _env(self, cmd, data):
        if cmd in (9, 31):  # system and save directory
            ctypes.cast(data, ctypes.POINTER(ctypes.c_char_p))[0] = self._dir.value
            return True
        if cmd == 15:  # a core option
            var = ctypes.cast(data, ctypes.POINTER(Variable))[0]
            value = OPTIONS.get(var.key)
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
            self.lib.retro_run()
            self.frames += 1

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
        self._grab = True
        self.step(1, hooks)
        self._grab = False
        data, width, height, pitch = self._frame
        return Image.frombuffer("RGBX", (width, height), data, "raw", "BGRX", pitch, 1).convert("RGB")

    def ram(self):
        return ctypes.string_at(self.lib.retro_get_memory_data(2), self.lib.retro_get_memory_size(2))

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
        self.lib.retro_unload_game()
        self.lib.retro_deinit()
        shutil.rmtree(self.dir, ignore_errors=True)
