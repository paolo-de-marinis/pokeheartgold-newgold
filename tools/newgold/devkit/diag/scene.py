#!/usr/bin/env python3
"""Play a scene from a save, step by step, and check what it shows.

    scene.py SAVE OUT STEP... [--rom ROM] [--elf ELF]
    scene.py --scenario FILE [--out DIR] [--rom ROM] [--elf ELF]
    ... --record RUN.mp4        either, filmed: every frame and its sound (core.py)

A step is one of
    A, B, X, Y, START, SELECT, UP, DOWN, LEFT, RIGHT, L, R   a press, then 20 frames
    BUTTON*N                    the same N times
    wait:N                      N frames
    touch:X,Y                   a tap on the bottom screen, in its own pixels
    drag:X1,Y1,X2,Y2            a touch held from one point to the other
    shot:NAME                   the next frame, both screens, to OUT/NAME.png
    heaps:LABEL                 every heap's largest block at its fullest, and
                                the allocation failures and asserts so far
    untilheap:HEAP_ID_N[:MAX]   A, every 40 frames, until that heap is made
                                (400 presses at most by default)
    poke:SYMBOL=VALUE           a word of the ROM's memory, by name
    hold:SYMBOL=VALUE           the same before every frame from now on; 0 lets go
    field[:N]                   A until the field is up and the player can move,
                                and through any text box on the way (N frames at most)
    fight[:N[:T]]               A until a battle is up, then gym.py's player plays
                                it to the end (N: always move slot N; T: stop at the
                                command prompt after T turns, to expect what they did)
    teach:B,SLOT,MOVE[,PP]      battler B's move in that slot (0-3), and its PP (5 by
                                default), written into the running battle: a move
                                no trainer's data gives, for the AI to use
    goto:MAP,X,Y                walk there: the path planned from the tree's map data
                                (tile attributes, ledges, warps) and the objects in
                                RAM, planned again when left or blocked; A through
                                text boxes, gym.py's player through battles. MAP is
                                MAP_... or a number; X, Y as the game counts them
                                (the matrix's tiles outdoors). A tile someone stands
                                on is reached beside them, facing them.

    scene.py mart.sav out wait:300 A*3 untilheap:HEAP_ID_FIELD2 heaps:mart shot:mart

A scenario is the same run kept as a test: a JSON file (tests/newgold/
scenarios/) naming a save, the savedit.py options applied to a scratch copy
of it, the switches held from the first frame, the steps, and what has to be
true at the end. It ends in PASS or FAIL and why; a failure keeps a shot of
both screens and the last battle lines.

    {"about": "Falkner, beaten with the six at the cap",
     "save": "gyms/falkner.sav", "edit": ["--badges", "0"],
     "hold": {"gDiagBattleSeed": 7},
     "steps": ["field", "A", "fight", "field"],
     "expect": {"lines": ["Falkner sent out Pidgey!"], "badges": 1}}

A save's path is taken in ~/hgss-saves unless it is absolute; the saves there
are Paolo's and only a copy is ever edited. In "expect", "lines" have to be
printed by the battle, in that order (a part of the line is enough), and
"no_lines" never; "heaps" is the least a heap may have had left at its
fullest (gDiagHeapLowWater); every other key is a value read out of main RAM
by name, through the ELF's symbols and the offsets the tree's own headers
give: map, x, y, party (the count), badges, flag:FLAG_..., var:VAR_...,
battlerN.species|hp|maxHp|level|partySlot|status|item (gDiagBattlers; N
counts the player's side even), or any gDiag* global. A value is a number,
a constant's name (MAP_..., SPECIES_..., ITEM_..., MOVE_...), [low, high],
or for a status the flags as markers.py names them ("BRN", "" for none).
"asserts" and "alloc_failures" are 0 unless the file says otherwise. A step
may also be {"expect": {...}}, checked when the run gets there.

The ROM is the NEWGOLD_DIAG=1 HeartGold build, run by core.py at the pinned
clock; the heaps are its gDiagHeapLowWater, read by markers.py. The harness
has no wireless, so the communication error the game raises for it is held
off (gDiagIgnoreCommunicationError) every frame, and the Union Room, trades
and the GTS's first screens can be reached. A shot draws a battle as the
game does -- both sprites, the HP boxes, the message box -- since the frame
comes from the core's own video callback (core.shot).
"""
import argparse
import json
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from core import Core, pin_clock  # noqa: E402
from markers import BATTLER, DIAG_ELF, STATES, STATUS, Markers  # noqa: E402
import savedit  # noqa: E402

ROOT = Path(__file__).resolve().parents[4]
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
SAVES = Path.home() / "hgss-saves"
BATTLE_MAIN = STATES.index("BATTLE_MAIN")
# DiagBattler's fields in BATTLER's order, the arrays left out.
BATTLER_FIELDS = ("species", "hp", "maxHp", "level", "partySlot", "status", "item")
CONSTANTS = {"MAP_": "include/constants/maps.h", "SPECIES_": "include/constants/species.h",
             "ITEM_": "include/constants/items.h", "MOVE_": "include/constants/moves.h"}
STEPS = ("wait", "touch", "drag", "shot", "poke", "hold", "heaps", "untilheap", "field", "fight", "goto", "teach")


def readable(step_or_key, key=False):
    """Whether scene.py knows a step (or, with key, an expectation's key)
    without running anything: a scenario's typo is found by the fast test."""
    import re
    from core import BUTTONS
    if key:
        return (step_or_key in ("lines", "no_lines", "heaps", "asserts", "alloc_failures", "map", "x", "y",
                                "party", "badges")
                or step_or_key.startswith(("flag:", "var:", "gDiag"))
                or re.fullmatch(rf"battler[0-3]\.({'|'.join(BATTLER_FIELDS)})", step_or_key) is not None)
    if isinstance(step_or_key, dict):
        return list(step_or_key) == ["expect"] and all(readable(k, True) for k in step_or_key["expect"])
    kind = step_or_key.partition(":")[0]
    return kind in STEPS or step_or_key.partition("*")[0] in BUTTONS


@savedit.tree_cache
def battle_layout():
    """BattleMon's size and the offsets teach: writes, from the tree's headers."""
    names = ("sizeof(BattleMon)", "__builtin_offsetof(BattleMon, moves)", "__builtin_offsetof(BattleMon, movePPCur)",
             "__builtin_offsetof(BattleMon, hp)", "__builtin_offsetof(BattleContext, battleMons)",
             "__builtin_offsetof(BattleContext, unk_0)")
    return dict(zip(("size", "moves", "pp", "hp", "mons", "select"), savedit.compile_c(
        exprs=names, headers=savedit.LAYOUT_HEADERS + ("battle/battle.h",))[0]))


@savedit.tree_cache
def field_layout():
    """Where the field keeps what a walk reads, from the tree's headers: the
    offsets of the fields followed from sFieldSysPtr, and textbox_open's bit."""
    names = ("FieldSystem, location", "FieldSystem, taskman", "FieldSystem, playerAvatar",
             "FieldSystem, processManager", "FieldSystem, runningFieldMap", "FieldSystem, mapObjectManager",
             "FieldProcessManager, isPaused", "PlayerAvatar, mapObject", "LocalMapObject, currentX",
             "LocalMapObject, currentZ", "MapObjectManager, objectCount", "MapObjectManager, objects")
    values, (textbox,) = savedit.compile_c(
        exprs=tuple(f"__builtin_offsetof({n})" for n in names) + ("sizeof(LocalMapObject)",),
        inits=(("FieldSystem", ".textbox_open = 1"),),
        headers=savedit.LAYOUT_HEADERS + ("field_system.h", "player_avatar.h", "map_object.h"))
    out = {n.replace(", ", "."): v for n, v in zip(names, values)}
    out["LocalMapObject.size"] = values[-1]
    out["FieldSystem.textbox_open"] = savedit.set_bit(textbox)
    return out


# -- the navigator's map, from the tree -------------------------------------
#
# goto: plans a walk from the data the game itself reads: each map's matrix
# and the land data's tile attributes (the collision bit, the behaviour byte:
# ledges, doors, the warp mats), the zone events' warps, and the map objects
# standing in main RAM right now. Nothing is aimed by eye.

STEP = {"UP": (0, -1), "DOWN": (0, 1), "LEFT": (-1, 0), "RIGHT": (1, 0)}


@savedit.tree_cache
def behaviours():
    """The behaviours a walk treats apart, by name without TILE_BEHAVIOR_,
    as the tree's enum numbers them."""
    names = ("JUMP_NORTH", "JUMP_SOUTH", "JUMP_WEST", "JUMP_EAST", "DOOR", "WARP_ENTRANCE_NORTH", "WARP_NORTH",
             "WARP_PANEL", "LADDER_DOWN", "ESCALATOR", "ESCALATOR_FLIP_FACE", "WARP_ENTRANCE_SOUTH", "WARP_SOUTH",
             "WARP_ENTRANCE_EAST", "WARP_EAST", "WARP_STAIRS_EAST", "WARP_ENTRANCE_WEST", "WARP_WEST",
             "WARP_STAIRS_WEST", "LADDER_NORTH", "LADDER_SOUTH")
    values = savedit.compile_c(exprs=tuple(f"TILE_BEHAVIOR_{n}" for n in names),
                               headers=savedit.LAYOUT_HEADERS + ("constants/metatile_behavior.h",))[0]
    b = dict(zip(names, values))
    return {
        # a ledge is jumped over in its own direction and nowhere else
        "jump": {b["JUMP_NORTH"]: "UP", b["JUMP_SOUTH"]: "DOWN", b["JUMP_WEST"]: "LEFT", b["JUMP_EAST"]: "RIGHT"},
        # FieldSystem_CheckTransition: these warp the moment they are stepped on
        "on_step": {b[n] for n in ("WARP_ENTRANCE_NORTH", "WARP_NORTH", "WARP_PANEL", "LADDER_DOWN", "ESCALATOR",
                                   "ESCALATOR_FLIP_FACE")},
        # FieldSystem_CheckMapTransition: these warp when the player stands on
        # them and presses this way, into the wall; a door, from the tile before it
        "press": {b["WARP_ENTRANCE_SOUTH"]: "DOWN", b["WARP_SOUTH"]: "DOWN", b["WARP_ENTRANCE_EAST"]: "RIGHT",
                  b["WARP_EAST"]: "RIGHT", b["WARP_STAIRS_EAST"]: "RIGHT", b["WARP_ENTRANCE_WEST"]: "LEFT",
                  b["WARP_WEST"]: "LEFT", b["WARP_STAIRS_WEST"]: "LEFT", b["LADDER_NORTH"]: "UP",
                  b["LADDER_SOUTH"]: "DOWN"},
        "door": b["DOOR"],
    }


def tile(map_id, x, z):
    """(the map that owns the tile, its attribute), or None off the map. On
    a matrix several maps share, the tile is the owner's."""
    matrix = savedit._matrix_of().get(map_id)
    if matrix is None:
        return None
    attr = savedit.attribute(matrix, x, z)
    if attr is None:
        return None
    width, _, owners, _ = savedit._matrix(matrix)
    return (owners[z // savedit.CHUNK_ROWS * width + x // savedit.CHUNK_TILES] if owners else map_id), attr


@savedit.tree_cache
def warps(map_id):
    """{(x, z): (map, x, z)}: where each of the map's warps puts the player,
    the target map's warp of that anchor. A warp to a map the tree has no
    events for (the dynamic ones) is left out."""
    maps = savedit.constants("include/constants/maps.h", "MAP_")
    out = {}
    for warp in savedit.map_events(map_id).get("warps", []):
        target = maps.get(warp["header"])
        arrivals = savedit.map_events(target).get("warps", []) if target is not None else []
        if warp["anchor"] < len(arrivals):
            out[(warp["x"], warp["z"])] = (target, arrivals[warp["anchor"]]["x"], arrivals[warp["anchor"]]["z"])
    return out


def plan(start, goals, blocked=frozenset(), most=300000):
    """The cheapest walk from `start` (map, x, z) to any of `goals`, as
    [(node, the direction held from it)], the last node a goal; None when
    there is none. A step costs 1, a ledge 2, a warp 4. `blocked` are tiles
    (map, x, z) something stands on."""
    import heapq
    kinds, water = behaviours(), savedit.surfable()
    goal_set = set(goals)

    def free(node):
        found = tile(*node)
        return found is not None and not found[1] & savedit.COLLISION and found[1] & 0xFF not in water \
            and found[1] & 0xFF not in kinds["on_step"] and (found[0], *node[1:]) not in blocked

    def edges(node):
        m, x, z = node
        here = tile(m, x, z)
        for direction, (dx, dz) in STEP.items():
            nx, nz = x + dx, z + dz
            there = tile(m, nx, nz)
            if there is None:
                continue
            owner, attr = there
            behaviour = attr & 0xFF
            warp = warps(owner).get((nx, nz))
            if warp and (behaviour == kinds["door"] or behaviour in kinds["on_step"]):
                yield warp, direction, 4
            elif kinds["jump"].get(behaviour) == direction:
                landing = (owner, nx + dx, nz + dz)
                if free(landing):
                    yield (tile(*landing)[0], nx + dx, nz + dz), direction, 2
            elif free((owner, nx, nz)):
                yield (owner, nx, nz), direction, 1
        warp = warps(m).get((x, z)) if here else None
        if warp:
            # A mat or a stair: pressed into the wall its behaviour names; any
            # other warp tile answers a press into whichever wall is beside it.
            direction = kinds["press"].get(here[1] & 0xFF) or next(
                (d for d, (dx, dz) in STEP.items() if (tile(m, x + dx, z + dz) or (0, savedit.COLLISION))[1]
                 & savedit.COLLISION), None)
            if direction:
                yield warp, direction, 4

    def matrix(m):
        return savedit._matrix_of().get(m), savedit._matrix(savedit._matrix_of()[m])[2] is not None or m

    goal_matrix = {matrix(g[0]) for g in goals if g[0] in savedit._matrix_of()}

    def guess(node):
        if matrix(node[0]) not in goal_matrix:
            return 0
        return min(abs(node[1] - g[1]) + abs(node[2] - g[2]) for g in goals)

    came, cost, queue, seen = {start: None}, {start: 0}, [(guess(start), 0, start)], 0
    while queue and seen < most:
        _, spent, node = heapq.heappop(queue)
        if node in goal_set:
            path = [(node, None)]
            while came[node]:
                node, direction = came[node]
                path.append((node, direction))
            return path[::-1]
        if spent > cost[node]:
            continue
        seen += 1
        for nxt, direction, step in edges(node):
            if spent + step < cost.get(nxt, 1 << 30):
                cost[nxt], came[nxt] = spent + step, (node, direction)
                heapq.heappush(queue, (spent + step + guess(nxt), spent + step, nxt))
    return None


class Scene:
    """A core running a save, with the switches it holds and every line the
    battle has printed since it started."""

    def __init__(self, save, rom=ROM, elf=DIAG_ELF, out=None, say=None, record=None):
        self.markers = Markers(elf)
        self.elf = Path(elf)
        self.out = Path(out) if out else None
        self.say = say or (lambda line: None)
        self.core = Core(rom, save=save, record=record)
        self.holds = {}
        self.hold("gDiagIgnoreCommunicationError", 1)
        self.lines, self._count = [], 0
        self._text_count = self.markers.address("gDiagBattleTextCount")
        self._field = self.markers.address("sFieldSysPtr")
        self.hooks = [self._poke, self._collect]

    def hold(self, name, value):
        address = self.markers.address(name)
        if address is None:
            raise SystemExit(f"{name} is not in this build")
        if value:
            self.holds[address] = (value, self.markers.table[name][1] or 4)
        else:
            self.holds.pop(address, None)

    def _poke(self, core):
        for address, (value, width) in self.holds.items():
            core.poke(address, value, width)

    def _collect(self, core):
        count = core.word(self._text_count)
        if count == self._count:
            return
        if count < self._count:     # a console reset clears the ring with the rest of memory
            self._count = 0
        self.lines += [line for index, line in self.markers.text(core.ram()) if index >= self._count and line]
        self._count = count

    # -- the field ---------------------------------------------------------

    def _chain(self, *fields):
        """The word at the end of a chain of fields from sFieldSysPtr; 0 when a
        pointer on the way is not set."""
        layout, address = field_layout(), self.core.word(self._field)
        for field in fields:
            if not address:
                return 0
            address = self.core.word(address + layout[field])
        return address

    def movable(self):
        """FieldSystem_IsPlayerMovementAllowed, read out of memory."""
        return bool(self.core.word(self._field) and not self._chain("FieldSystem.processManager", "FieldProcessManager.isPaused")
                    and self._chain("FieldSystem.runningFieldMap") and not self._chain("FieldSystem.taskman"))

    def textbox(self):
        """FieldSystem.textbox_open: a script's message box is on screen."""
        byte, bit = field_layout()["FieldSystem.textbox_open"]
        field = self.core.word(self._field)
        return bool(field and self.core.word(field + byte, 1) >> bit & 1)

    def location(self):
        """(map, x, y): the map from FieldSystem.location, the tile from the
        player's map object."""
        layout = field_layout()
        location = self._chain("FieldSystem.location")
        obj = self._chain("FieldSystem.playerAvatar", "PlayerAvatar.mapObject")
        if not location or not obj:
            return None
        return (self.core.word(location), self.core.word(obj + layout["LocalMapObject.currentX"]),
                self.core.word(obj + layout["LocalMapObject.currentZ"]))

    # -- steps -------------------------------------------------------------

    def run(self, step):
        """Play one step; a {"expect": ...} step returns what did not hold."""
        core, hooks = self.core, self.hooks
        if isinstance(step, dict):
            return self.check(step["expect"])
        kind, _, rest = step.partition(":")
        if kind == "wait":
            core.step(int(rest), hooks)
        elif kind == "touch":
            x, y = map(int, rest.split(","))
            core.touch(x, y, 6, hooks)
            core.step(20, hooks)
        elif kind == "drag":
            x1, y1, x2, y2 = map(int, rest.split(","))
            core.touching = True
            for k in range(21):
                # core.touch's mapping: the pointer spans both screens, top over bottom
                x, y = x1 + (x2 - x1) * k / 20, y1 + (y2 - y1) * k / 20
                core.tx = int(((x / 256.0) * 2 - 1) * 0x7FFF)
                core.ty = int((((y + 192) / 384.0) * 2 - 1) * 0x7FFF)
                core.step(3 if 0 < k < 20 else 10, hooks)
            core.touching = False
            core.step(20, hooks)
        elif kind == "shot":
            core.shot(hooks).save(self.out / f"{rest}.png")
        elif kind == "poke":
            name, value = rest.split("=")
            core.poke(self.markers.address(name), int(value, 0))
        elif kind == "hold":
            name, value = rest.split("=")
            self.hold(name, int(value, 0))
        elif kind == "heaps":
            ram = core.ram()
            print(f"== {rest} [frame {core.frames}] {self.failures(ram)}")
            for name, value in self.markers.heaps(ram).items():
                print(f"   {name:<24} {value:#8x} ({value})")
            sys.stdout.flush()
        elif kind == "untilheap":
            heap, _, most = rest.partition(":")
            for press in range(int(most or 400)):
                core.press("A", 6, hooks)
                core.step(40, hooks)
                if heap in self.markers.heaps(core.ram()):
                    print(f"[{core.frames}] {heap} made after {press + 1} presses")
                    break
            else:
                print(f"{heap} was never made: {self.markers.describe(core.ram())}")
        elif kind == "field":
            # A through the title and Continue until the field map runs; after
            # that A only for a text box, or the press that lands as the
            # player gets control talks to whoever the player faces.
            end = core.frames + int(rest or 12000)
            while core.frames < end and not self.movable() and not self.in_battle():
                if not self._chain("FieldSystem.runningFieldMap") or self.textbox():
                    core.press("A", 6, hooks)
                    core.step(20, hooks)
                else:
                    core.step(1, hooks)
            if not self.movable():
                self.say(f"[{core.frames}] the field never let the player move")
        elif kind == "goto":
            name, x, y = rest.split(",")
            done, said = self.goto((self.number(name) if not name.isdigit() else int(name), int(x), int(y)))
            self.say(f"[{core.frames}] {said}")
            return None if done else [said]
        elif kind == "teach":
            # teach:BATTLER,SLOT,MOVE[,PP] -- what a battler knows, written into
            # the battle as it runs (the trainer's data cannot say it): with the
            # others' PP at 0, the AI has that move to use and no other.
            battler, slot, move, *pp = rest.split(",")
            at, layout = self.battle_mon(int(battler)), battle_layout()
            if at is None:
                return [f"battler {battler} is not in the battle: {self.markers.battle(core.ram())}"]
            core.poke(at + layout["moves"] + 2 * int(slot), self.number(move), 2)
            core.poke(at + layout["pp"] + int(slot), int(pp[0]) if pp else 5, 1)
        elif kind == "fight":
            import gym
            for _ in range(300):
                if self.markers.read(core.ram(), "gDiagBattleState") == BATTLE_MAIN:
                    break
                core.press("A", 6, hooks)
                core.step(30, hooks)
            else:
                self.say(f"[{core.frames}] no battle came up")
                return None
            slot, _, turns = rest.partition(":")
            gym.fight(core, self.markers, hooks, self.say, int(slot) if slot else -1, core.frames + 60000,
                      turns=int(turns) if turns else None, since=core.word(self._text_count),
                      partner=self.partner_prompt())
            self._collect(core)
        else:
            button, _, times = step.partition("*")
            for _ in range(int(times or 1)):
                core.press(button, 6, hooks)
                core.step(20, hooks)
        return None

    # -- the navigator -----------------------------------------------------

    def objects(self):
        """The tiles the map's live objects stand on -- the player and the
        Pokemon following them apart -- read from MapObjectManager."""
        layout, core = field_layout(), self.core
        manager = self._chain("FieldSystem.mapObjectManager")
        player = self._chain("FieldSystem.playerAvatar", "PlayerAvatar.mapObject")
        here = self.location()
        if not manager or not here:
            return set()
        count = core.word(manager + layout["MapObjectManager.objectCount"])
        first = core.word(manager + layout["MapObjectManager.objects"])
        out = set()
        for i in range(min(count, 64)):
            obj = first + i * layout["LocalMapObject.size"]
            # flags bit 0 is MAPOBJECTFLAG_ACTIVE; id 253 is obj_partner_poke, which steps aside
            if obj == player or not core.word(obj) & 1 or core.word(obj + 8) == 253:
                continue
            x, z = core.word(obj + layout["LocalMapObject.currentX"]), core.word(obj + layout["LocalMapObject.currentZ"])
            out.add((tile(here[0], x, z) or (here[0],))[0:1] + (x, z))
        return out

    def in_battle(self):
        """A battle is running: Battle_Run has been through a state since the
        last one ended (gDiagBattleStateSeen), and is not at EXIT."""
        markers = self.markers
        return self.core.word(markers.address("gDiagBattleStateSeen")) != 0 and \
            self.core.word(markers.address("gDiagBattleState")) != STATES.index("EXIT")

    def goto(self, goal, frames=30000):
        """Walk to goal (map, x, z) by the plan the tree's data gives, again
        from wherever the player is whenever the plan is left or blocked;
        A through text boxes, gym.py's player through battles. A goal
        something stands on is reached beside it, facing it. Returns
        (True or False, one line saying how it went)."""
        import gym
        from core import BUTTONS
        core, hooks = self.core, self.hooks
        end, started = core.frames + frames, core.frames
        blocked, path, index, goals = {}, None, {}, [goal]
        replans = battles = texts = 0
        last, still = None, 0
        while core.frames < end:
            core.buttons = set()
            if self.in_battle():
                battles += 1
                gym.fight(core, self.markers, hooks, self.say, -1, core.frames + 60000,
                          since=core.word(self._text_count), partner=self.partner_prompt())
                self._collect(core)
                continue
            if not self.movable():
                if self.textbox():
                    texts += 1
                    core.press("A", 6, hooks)
                    core.step(10, hooks)
                else:
                    core.step(1, hooks)
                path = None if path and self.location() not in index else path
                continue
            here = self.location()
            if path is None or here not in index:
                # The objects are read when planning, not every frame: a
                # walk read at every frame ran at half the core's speed.
                objects = self.objects()
                goals = [goal]
                if goal in objects or not (tile(*goal) and not tile(*goal)[1] & savedit.COLLISION):
                    goals = [(goal[0], goal[1] + dx, goal[2] + dz) for dx, dz in STEP.values()]
                path = None
            if here in goals:
                if goals != [goal]:     # face whoever stands on the goal
                    core.press(next(d for d, (dx, dz) in STEP.items()
                                    if (here[1] + dx, here[2] + dz) == goal[1:]), 4, hooks)
                # A pressed while the turn still plays is not read: the mother
                # once never gave the Pokegear for an A one frame too early.
                core.step(16, hooks)
                return True, (f"goto {goal}: there in {core.frames - started} frames, {replans} plans, "
                              f"{battles} battles, {texts} text boxes")
            if path is None:
                blocked = {tile_: until for tile_, until in blocked.items() if until > core.frames}
                path = plan(here, goals, frozenset(objects) | frozenset(blocked))
                replans += 1
                if path is None:
                    return False, f"goto {goal}: no way from {here} (blocked {sorted(blocked)})"
                index = {node: i for i, (node, _) in enumerate(path)}
            direction = path[index[here]][1]
            if here == last:
                still += 1
                if still > 48:      # something the plan did not know stands in the way
                    nxt = path[index[here] + 1][0]
                    blocked[nxt] = core.frames + 600
                    path, still = None, 0
                    continue
            else:
                last, still = here, 0
            core.buttons = {BUTTONS[direction], BUTTONS["B"]}   # B runs, once the save has the shoes
            core.step(1, hooks)
        core.buttons = set()
        return False, f"goto {goal}: stopped at {self.location()} after {frames} frames, {replans} plans"

    def battle_mon(self, battler):
        """Where the battle keeps a battler's BattleMon: found in main RAM by
        the species, HP and maximum HP gDiagBattlers shows for it, since the
        battle's context lives on its heap and no symbol points at it."""
        import re
        ram, layout = self.core.ram(), battle_layout()
        shown = struct.unpack_from(BATTLER, ram, self.markers.address("gDiagBattlers") - 0x02000000
                                   + battler * struct.calcsize(BATTLER))
        species, hp, max_hp = shown[:3]
        pattern = re.escape(struct.pack("<H", species)) + b".{%d}" % (layout["hp"] - 2) + re.escape(struct.pack("<iI", hp, max_hp))
        found = [m.start() for m in re.finditer(pattern, ram, re.S) if m.start() % 4 == 0]
        return 0x02000000 + found[0] if len(found) == 1 else None

    def partner_prompt(self):
        """For gym.fight: where the player's second Pokemon is in choosing, in
        a double battle -- BattleContext.unk_0[2], the context found once
        through battle_mon -- or None."""
        context = {}

        def read():
            second = self.markers.address("gDiagBattlers") + 2 * struct.calcsize(BATTLER)
            if not self.core.word(second, 2) or not self.core.word(second + 2, 2):    # none, or fainted
                return None
            if "at" not in context:
                mon = self.battle_mon(0)
                context["at"] = mon and mon - battle_layout()["mons"]
            return self.core.word(context["at"] + battle_layout()["select"] + 2, 1) if context["at"] else None
        return read

    def failures(self, ram):
        return " ".join(f"{label}={self.markers.read(ram, name)}" for label, name in (
            ("allocfail", "gDiagAllocFailCount"), ("heap", "gDiagAllocFailHeap"),
            ("size", "gDiagAllocFailSize"), ("asserts", "gDiagAssertCount")))

    # -- expectations ------------------------------------------------------

    def value(self, ram, name):
        """A value of the game's memory by the name a scenario gives it."""
        import party
        import where
        markers = self.markers
        if name == "asserts":
            return markers.read(ram, "gDiagAssertCount")
        if name == "alloc_failures":
            return markers.read(ram, "gDiagAllocFailCount")
        if name.startswith("gDiag"):
            return markers.read(ram, name, markers.table[name][1] if name in markers.table else 4)
        if name in ("map", "x", "y"):
            here = self.location()
            return here and here[("map", "x", "y").index(name)]
        memory = where.Memory(ram)
        if name == "party":
            return memory.word(party.block(memory, self.elf, where.SAVE_PARTY) + where.PARTY_COUNT)
        if name == "badges":
            return party.badges(ram, self.elf)
        if name.startswith(("flag:", "var:")):
            kind, _, constant = name.partition(":")
            flags = party.block(memory, self.elf, savedit.block_ids().index("SAVE_FLAGS")) - 0x02000000
            if kind == "var":
                number = savedit.constants("include/constants/vars.h", "VAR_")[constant]
                return struct.unpack_from("<H", ram, flags + 2 * (number - savedit.VAR_BASE))[0]
            number = savedit.constants("include/constants/flags.h", "FLAG_")[constant]
            return ram[flags + savedit.FLAGS_AT + number // 8] >> (number % 8) & 1
        if name.startswith("battler") and "." in name:
            battler, field = name[len("battler"):].split(".")
            at = markers.address("gDiagBattlers") - 0x02000000 + int(battler) * struct.calcsize(BATTLER)
            return struct.unpack_from(BATTLER, ram, at)[BATTLER_FIELDS.index(field)]
        raise SystemExit(f"a scenario asks for {name!r}, which scene.py cannot read")

    @staticmethod
    def wanted(name, expected):
        """The expectation as a test on the value read: (test, how it is said)."""
        if isinstance(expected, list):
            low, high = (Scene.number(e) for e in expected)
            return (lambda v: v is not None and low <= v <= high), f"within [{low}, {high}]"
        if isinstance(expected, str) and name.endswith(".status"):
            names = sorted(expected.split())
            return (lambda v: sorted(n for mask, n in STATUS if v & mask) == names), f"status {expected or 'none'}"
        number = Scene.number(expected)
        return (lambda v: v == number), f"{number}"

    @staticmethod
    def number(value):
        if isinstance(value, int):
            return value
        for prefix, header in CONSTANTS.items():
            if value.startswith(prefix):
                return savedit.constants(header, prefix)[value]
        return int(value, 0)

    def check(self, expect, final=False):
        """What in `expect` does not hold, as sentences; [] when it all does."""
        self._collect(self.core)
        ram, wrong = self.core.ram(), []
        if final:
            expect = {"asserts": 0, "alloc_failures": 0, **expect}
        at = 0
        for line in expect.get("lines", []):
            found = next((i for i in range(at, len(self.lines)) if line in self.lines[i]), None)
            if found is None:
                earlier = any(line in printed for printed in self.lines[:at])
                wrong.append(f"the line {line!r} was not printed" + (" in that order" if earlier else ""))
            else:
                at = found + 1
        wrong += [f"the line {line!r} was printed" for line in expect.get("no_lines", [])
                  if any(line in printed for printed in self.lines)]
        low = self.markers.heaps(ram)
        for heap, least in expect.get("heaps", {}).items():
            if heap not in low:
                wrong.append(f"{heap} never allocated")
            elif low[heap] < self.number(least):
                wrong.append(f"{heap} had {low[heap]:#x} left at its fullest, under {self.number(least):#x}")
        for name, expected in expect.items():
            if name in ("lines", "no_lines", "heaps"):
                continue
            test, said = self.wanted(name, expected)
            value = self.value(ram, name)
            if not test(value):
                wrong.append(f"{name} is {value}, not {said}")
        return wrong


def scenario(path, rom=ROM, elf=DIAG_ELF, out=None, record=None):
    """Run one scenario file: (True, False, or None when it cannot run here;
    the report's lines)."""
    spec = json.loads(Path(path).read_text())
    save = Path(spec["save"]) if Path(spec["save"]).is_absolute() else SAVES / spec["save"]
    if not save.exists():
        return None, [f"SKIP {Path(path).name}: {save} is not on this machine"]
    out = Path(out or tempfile.mkdtemp(prefix=f"newgold-scene-{Path(path).stem}-"))
    out.mkdir(parents=True, exist_ok=True)
    copy = out / "save.sav"
    shutil.copyfile(save, copy)
    if spec.get("edit"):
        edit = subprocess.run([sys.executable, str(ROOT / "tools/newgold/devkit/savedit.py"), *spec["edit"], str(copy)],
                              capture_output=True, text=True)
        if edit.returncode:
            return False, [f"FAIL {Path(path).name}: savedit.py {' '.join(spec['edit'])}: "
                           + (edit.stderr.strip().splitlines() or ["failed"])[-1]]
    log, wrong, started = [], [], time.time()
    scene = Scene(copy, rom, elf, out, say=log.append, record=record)
    for name, value in spec.get("hold", {}).items():
        scene.hold(name, Scene.number(value))
    for step in spec["steps"]:
        where_ = json.dumps(step["expect"]) if isinstance(step, dict) else step
        wrong += [f"at {where_}: {w}" for w in scene.run(step) or []]
    wrong += scene.check(spec.get("expect", {}), final=True)
    report = [f"{'FAIL' if wrong else 'PASS'} {Path(path).name}: {scene.core.frames} frames in {time.time() - started:.0f} s"]
    report += [f"  {line.split('] ', 1)[-1]}" for line in log if "] goto " in line and not wrong]
    if wrong:
        scene.core.shot(scene.hooks).save(out / "fail.png")
        report += [f"  {w}" for w in wrong]
        report += ["  the battle's last lines:"] + [f"    {line}" for line in scene.lines[-12:]]
        report += [f"  at the end: {scene.markers.describe(scene.core.ram())}", f"  kept in {out}"]
        (out / "log.txt").write_text("\n".join(log) + "\n")
    scene.core.close()
    if not wrong:
        shutil.rmtree(out, ignore_errors=True)
    return not wrong, report


def main():
    pin_clock()
    if "--scenario" in sys.argv:
        parser = argparse.ArgumentParser()
        parser.add_argument("--scenario", type=Path, required=True)
        parser.add_argument("--out", type=Path)
        parser.add_argument("--record", type=Path, help="the run, picture and sound, to this mp4 (core.py)")
        parser.add_argument("--rom", default=ROM)
        parser.add_argument("--elf", type=Path, default=DIAG_ELF)
        args = parser.parse_args()
        from gym import quiet
        out = quiet()
        passed, report = scenario(args.scenario, args.rom, args.elf, args.out, args.record)
        print("\n".join(report), file=out)
        sys.exit(1 if passed is False else 0)
    parser = argparse.ArgumentParser()
    parser.add_argument("save")
    parser.add_argument("out", type=Path)
    parser.add_argument("steps", nargs="+")
    parser.add_argument("--rom", default=ROM)
    parser.add_argument("--elf", type=Path, default=DIAG_ELF)
    parser.add_argument("--record", type=Path, help="the run, picture and sound, to this mp4 (core.py)")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    scene = Scene(args.save, args.rom, args.elf, args.out, say=print, record=args.record)
    for step in args.steps:
        scene.run(step)
    print(scene.markers.describe(scene.core.ram()))
    scene.core.close()


if __name__ == "__main__":
    main()
