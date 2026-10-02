#!/usr/bin/env python3
"""Play a scene from a save, step by step, and check what it shows.

    scene.py SAVE OUT STEP... [--rom ROM] [--elf ELF]      SAVE "new": an empty flash
    scene.py --scenario FILE [--out DIR] [--chain DIR] [--rom ROM] [--elf ELF]
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
                                and through any text box on the way (N frames at most);
                                a battle up on the way, its end screens too, gym.py's
                                player plays to its end
    fight[:N[:T]]               A until a battle is up, then gym.py's player plays
                                it to the end (N: always the move in slot N, counted
                                1 to 4 -- 0 the first with PP -- where teach: counts
                                0 to 3; T: stop at the command prompt after T turns,
                                to expect what they did); nothing when the field
                                stays free through five presses
    teach:B,SLOT,MOVE[,PP]      battler B's move in that slot (0-3), and its PP (5 by
                                default), written into the running battle: a move
                                no trainer's data gives, for the AI to use: a foe
                                that has given its move this turn is asked again
    set:B,FIELD,VALUE           battler B's hp, status (its flags as markers.py names
                                them: "BRN", "PSN"), ability (ABILITY_...), item
                                (ITEM_...) or speed (the stat before its stages),
                                written into the running battle: a state no battle
                                starts in, two speeds alike for a tie (hp last: the
                                battler is found by the HP gDiagBattlers shows, a
                                frame behind)
    goto:MAP,X,Y[,N]            walk there: the path planned from the tree's map data
                                (tile attributes, ledges, warps) and the objects in
                                RAM, planned again when left or blocked; A through
                                text boxes, gym.py's player through battles. MAP is
                                MAP_... or a number; X, Y as the game counts them
                                (the matrix's tiles outdoors). A tile someone stands
                                on -- or started on, wherever they have wandered
                                since -- is reached beside them, facing them.
                                N frames at most (30000 by default): a route
                                of the playthrough, with its battles, takes more
    flee:N                      from now on the battles goto and field play run from
                                a wild Pokemon when the player's has under N% of its
                                HP left
    catch:SPECIES|new|none      from now on the battles goto, field and fight play
                                catch that wild species, or any, while the Pokedex has
                                it not caught and the bag has a ball: gym.fight weakens
                                it and throws them; none stops
    heal:MAP,X,Y                where pace: heals: the tile before a Pokemon Center's
                                nurse, UP and A there, when the party's first has under
                                flee:'s share of its HP
    pace:MAP,X1,Y1,X2,Y2,KEY,V[,N]  walk from one tile to the other and back, through
                                what the grass sends, until the expectation KEY reads
                                at least V (party 3, party1.level 8, caught:SPECIES_...
                                1); N frames at most (30000 by default)
    newgame[:N]                 from an empty flash (no save) through the intro, the
                                title, NEW GAME, the Oak speech (no information, the
                                boy, the default name) to the bedroom, the player free
    starter:SPECIES             the starter machine, opened by the A before it: turned
                                to that Pokemon and taken, and B through what follows,
                                which says no to the nickname
    save                        the game saved through the start menu as a player saves,
                                the flash kept for the next leg of a chain

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
are Paolo's and only a copy is ever edited. A scenario with no save starts a
new game (newgame). One that names another as "from", a leg of a chain
(the playthrough), starts from the in-game save that one made (save): the
legs of a run share a directory (--chain), where each leaves its report,
NAME.txt, and on a pass its save, NAME.sav; a leg whose leg before has not
run plays it first, and one whose leg before failed fails without playing.

In "expect", "lines" have to be printed by the battle, in that order (a
part of the line is enough), "new_lines" the same since the check before
this one (a later phase's lines, not matched by an earlier phase's alike),
"once_lines" exactly once each since the check before (one line where a
rule prints one, not two), and "no_lines" never; "heaps" is the least a
heap may have had left at its fullest (gDiagHeapLowWater); every other key
is a value read out of main RAM by name, through the ELF's symbols and the
offsets the tree's own headers give: map, x, y, party (the count),
partyN.species|item|level|exp|hp|maxHp (the party as its save block holds
it, slot N from 0, once the field is up: what a battle gave back),
bag:ITEM_... (how many the bag holds), badges, running_shoes (1 once the
player has them: PlayerSaveData's, which no flag says),
options.textSpeed|soundMethod|battleStyle|battleScene|buttonMode|frame (the
start menu's settings as Options holds them: text speed 2 fast, battle
scene 1 off, battle style 1 set), flag:FLAG_..., var:VAR_...,
caught:SPECIES_... (1 once the Pokedex has it caught),
battlerN.species|hp|maxHp|level|partySlot|status|item|moveK|ppK
(gDiagBattlers; N counts the player's side even, K is a move slot, 0 to
3), music (the sequence the field's sound handle plays, -1
for none: a load the sound heap cannot hold leaves it empty and counts as no
failed allocation), or any gDiag* global. A value is a number, a constant's
name (MAP_..., SPECIES_..., ITEM_..., MOVE_..., SEQ_...), [low, high], or for
a status the flags as markers.py names them ("BRN", "" for none).
"asserts" and "alloc_failures" are 0 unless the file says otherwise. A step
may also be {"expect": {...}}, checked when the run gets there.

The ROM is the NEWGOLD_DIAG=1 HeartGold build, run by core.py at the pinned
clock; the heaps are its gDiagHeapLowWater, read by markers.py. melonDS
0.9.3 has no wireless: the communication error the game raises for it at
the main menu is held off (gDiagIgnoreCommunicationError, held every frame
on either core), so Continue works, and the Union Room, trades and the
GTS's first screens can be reached. melonDS DS reaches the field without
it. On 0.9.3 the comm heap then stays in heap 3 all the same (0x7080
bytes; DIAGNOSTICS.md): its heap-3 figures are that much short. A shot
draws a battle as the game does -- both sprites, the HP boxes, the message
box -- since the frame comes from the core's own video callback (core.shot).
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
# DiagBattler's fields in BATTLER's order, then its two arrays, a name a slot.
BATTLER_FIELDS = ("species", "hp", "maxHp", "level", "partySlot", "status", "item",
                  *(f"move{k}" for k in range(4)), *(f"pp{k}" for k in range(4)))
# party.mons' keys, the fields a scenario may name.
PARTY_FIELDS = ("species", "item", "level", "exp", "hp", "maxHp")
# The Options bitfields (include/options.h), the settings a scenario may name.
OPTION_FIELDS = ("textSpeed", "soundMethod", "battleStyle", "battleScene", "buttonMode", "frame")
CONSTANTS = {"MAP_": "include/constants/maps.h", "SPECIES_": "include/constants/species.h",
             "ITEM_": "include/constants/items.h", "MOVE_": "include/constants/moves.h",
             "SEQ_": "include/constants/sndseq.h", "ABILITY_": "include/constants/abilities.h"}
STEPS = ("wait", "touch", "drag", "shot", "poke", "hold", "heaps", "untilheap", "field", "fight", "goto", "teach",
         "set", "newgame", "starter", "save", "flee", "catch", "heal", "pace")


def readable(step_or_key, key=False):
    """Whether scene.py knows a step (or, with key, an expectation's key)
    without running anything: a scenario's typo is found by the fast test."""
    import re
    from core import BUTTONS
    if key:
        return (step_or_key in ("lines", "new_lines", "once_lines", "no_lines", "heaps", "asserts", "alloc_failures", "map", "x", "y",
                                "party", "badges", "music", "running_shoes")
                or step_or_key.startswith(("flag:", "var:", "gDiag"))
                or re.fullmatch(r"caught:SPECIES_\w+", step_or_key) is not None
                or re.fullmatch(r"bag:ITEM_\w+", step_or_key) is not None
                or re.fullmatch(rf"battler[0-3]\.({'|'.join(BATTLER_FIELDS)})", step_or_key) is not None
                or re.fullmatch(rf"party[0-5]\.({'|'.join(PARTY_FIELDS)})", step_or_key) is not None
                or re.fullmatch(rf"options\.({'|'.join(OPTION_FIELDS)})", step_or_key) is not None)
    if isinstance(step_or_key, dict):
        return list(step_or_key) == ["expect"] and all(readable(k, True) for k in step_or_key["expect"])
    kind = step_or_key.partition(":")[0]
    return kind in STEPS or step_or_key.partition("*")[0] in BUTTONS


@savedit.tree_cache
def battle_layout():
    """BattleMon's size and the offsets teach: and set: write, from the tree's headers."""
    names = ("sizeof(BattleMon)", "__builtin_offsetof(BattleMon, moves)", "__builtin_offsetof(BattleMon, movePPCur)",
             "__builtin_offsetof(BattleMon, hp)", "__builtin_offsetof(BattleContext, battleMons)",
             "__builtin_offsetof(BattleContext, unk_0)", "__builtin_offsetof(BattleMon, status)",
             "__builtin_offsetof(BattleMon, ability)", "__builtin_offsetof(BattleMon, item)",
             "__builtin_offsetof(BattleMon, speed)", "__builtin_offsetof(BattleContext, unk_314C)")
    return dict(zip(("size", "moves", "pp", "hp", "mons", "select", "status", "ability", "item", "speed", "chose"), savedit.compile_c(
        exprs=names, headers=savedit.LAYOUT_HEADERS + ("battle/battle.h",))[0]))


@savedit.tree_cache
def caught_at():
    """Where the Pokedex keeps its caught flags, one bit a species from 1."""
    return savedit.compile_c(exprs=("__builtin_offsetof(Pokedex, caughtSpecies)",))[0][0]


@savedit.tree_cache
def options_layout():
    """Where SAVE_PLAYERDATA keeps each option: PLAYERDATA.options plus the
    bitfield's place in Options, as savedit.bitfield() gives it."""
    (at,), raws = savedit.compile_c(("__builtin_offsetof(PLAYERDATA, options)",),
                                    tuple(("Options", f".{name} = ~0u") for name in OPTION_FIELDS))
    return {name: (at + byte, width, mask) for name, (byte, width, mask) in zip(OPTION_FIELDS, map(savedit.bitfield, raws))}


@savedit.tree_cache
def field_layout():
    """Where the field keeps what a walk reads, from the tree's headers: the
    offsets of the fields followed from sFieldSysPtr, and textbox_open's bit."""
    names = ("FieldSystem, location", "FieldSystem, taskman", "FieldSystem, playerAvatar",
             "FieldSystem, processManager", "FieldSystem, runningFieldMap", "FieldSystem, mapObjectManager",
             "FieldProcessManager, isPaused", "PlayerAvatar, mapObject", "LocalMapObject, currentX",
             "LocalMapObject, currentZ", "MapObjectManager, objectCount", "MapObjectManager, objects",
             "LocalMapObject, initialX", "LocalMapObject, initialZ", "LocalMapObject, currentFacing",
             "FieldProcessManager, child")
    values, (textbox,) = savedit.compile_c(
        exprs=tuple(f"__builtin_offsetof({n})" for n in names) + ("sizeof(LocalMapObject)",),
        inits=(("FieldSystem", ".textbox_open = 1"),),
        headers=savedit.LAYOUT_HEADERS + ("field_system.h", "player_avatar.h", "map_object.h"))
    out = {n.replace(", ", "."): v for n, v in zip(names, values)}
    out["LocalMapObject.size"] = values[-1]
    out["FieldSystem.textbox_open"] = savedit.set_bit(textbox)
    return out


@savedit.tree_cache
def select_states():
    """BattleSelectState's numbers by name, as battle_controller_player.c
    counts them (BattleContext.unk_0, a battler's place in choosing)."""
    import re
    text = savedit.source("src/battle/battle_controller_player.c").read_text()
    body = re.search(r"typedef enum BattleSelectState \{(.*?)\}", text, re.S).group(1)
    return {name.strip(): i for i, name in enumerate(n for n in body.split(",") if n.strip())}


def asks_again(state, chose, moves, pp):
    """Whether teach: has a battler asked for its move again: it gave one
    this turn from the request (SSI_STATE_13 or 14, BattleContext.unk_314C's
    bit 1) -- not a move it is locked into or encored into, which nobody
    asks for -- and it knows one it can use now."""
    states = select_states()
    return (state in (states["SSI_STATE_13"], states["SSI_STATE_14"]) and bool(chose & 2)
            and any(m and p for m, p in zip(moves, pp)))


def c_declarations(path, name):
    """For compile_c: a .c file's includes, and what it declares after them
    up to the end of `name` ("struct X", "enum Y") -- a struct it keeps to
    itself, with the ones it holds."""
    import re
    text = savedit.source(path).read_text()
    end = re.search(rf"^(?:typedef )?{name} \{{.*?^\}}[^;\n]*;", text, re.S | re.M).end()
    includes = list(re.finditer(r'^#include "(.*)"\n', text[:end], re.M))
    return tuple(m.group(1) for m in includes), (text[includes[-1].end():end],)


@savedit.tree_cache
def app_layout():
    """What newgame:, starter: and save: read, from the tree: main.c's
    running OverlayManager, the Oak speech's state and the naming screen it
    opens, the starter machine's cursor, the start menu's buttons (its
    cursor is FieldSystem.unkD3) and the save's progress -- offsets, and the
    numbers of the states waited for."""
    out = {}
    for path, name, exprs in (
            ("src/main.c", "struct UnkStruct_02111868", ("__builtin_offsetof(struct UnkStruct_02111868, overlayManager)",)),
            ("src/oaks_speech.c", "enum OakSpeechMainState", ("OAK_SPEECH_MAIN_STATE_TUTORIAL_MENU_HANDLE_INPUT",)),
            ("src/naming_screen.c", "enum NamingScreenMainState", ("NS_MAIN_STATE_INPUT_LOOP",)),
            ("src/choose_starter_app.c", "struct ChooseStarterAppWork", (
                "__builtin_offsetof(struct ChooseStarterAppWork, curSelection)",
                "__builtin_offsetof(struct ChooseStarterAppWork, state)", "CHOOSE_STARTER_STATE_HANDLE_INPUT",
                "SELECT_STATE_CONFIRM")),
            ("src/start_menu.c", "enum StartMenuAction", ("START_MENU_ACTION_SAVE",)),):
        headers, decls = c_declarations(path, name)
        out.update(zip(exprs, savedit.compile_c(exprs=exprs, headers=headers, decls=decls)[0]))
    names = ("OverlayManager, template.exec", "OverlayManager, proc_state", "OverlayManager, data",
             "OakSpeechData, state", "OakSpeechData, overlayManager", "TaskManager, func", "TaskManager, env",
             "StartMenuTaskData, state", "StartMenuTaskData, numActiveButtons", "StartMenuTaskData, selectionToAction",
             "FieldSystem, unkD3", "SaveData, saveCounter", "SaveData, lastGoodSector")
    values = savedit.compile_c(exprs=tuple(f"__builtin_offsetof({n})" for n in names) + ("START_MENU_STATE_HANDLE_INPUT",),
                               headers=savedit.LAYOUT_HEADERS + ("overlay_manager.h", "oaks_speech_internal.h", "task.h",
                                                                  "start_menu.h", "field_system.h"))[0]
    out.update({n.replace(", ", "."): v for n, v in zip(names, values)})
    out["START_MENU_STATE_HANDLE_INPUT"] = values[-1]
    return {key.replace("__builtin_offsetof(struct ", "").replace(", ", ".").rstrip(")"): value
            for key, value in out.items()}


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
        # A ladder's foot warps when pressed its way, so no step is taken
        # that way from it: Sprout Tower 1F's (6, 16), LADDER_NORTH, below
        # its (6, 15), LADDER_SOUTH, sent the walk up to 2F and back for ever.
        pressed = kinds["press"].get(here[1] & 0xFF) if here and warps(m).get((x, z)) else None
        for direction, (dx, dz) in STEP.items():
            nx, nz = x + dx, z + dz
            there = tile(m, nx, nz)
            if there is None or direction == pressed:
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
        self.lines, self._count, self._checked = [], 0, 0
        self._text_count = self.markers.address("gDiagBattleTextCount")
        self._field = self.markers.address("sFieldSysPtr")
        self.hooks = [self._poke, self._collect]
        self.saved = None       # the flash an in-game save left (save), for the next leg
        self.flee = 0           # flee:N
        self.catch = None       # catch:, a species number or "new"
        self.healer = None      # heal:, (map, x, y)

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
            # A battle up on the way -- its end screens still to go through, or
            # one a trainer started -- gym.py's player plays to its end, as
            # goto's does; its frames are not counted in N.
            end = core.frames + int(rest or 12000)
            while core.frames < end and (self.in_battle() or not self.movable()):
                if self.in_battle():
                    import gym
                    started = core.frames
                    gym.fight(core, self.markers, hooks, self.say, -1, core.frames + 60000,
                              since=core.word(self._text_count), partner=self.partner_prompt(), flee=self.flee,
                              catch=self.balls_for)
                    self._collect(core)
                    if self.in_battle():
                        break       # gym.py's player could not end it
                    end += core.frames - started
                elif not self._chain("FieldSystem.runningFieldMap") or self.textbox():
                    core.press("A", 6, hooks)
                    core.step(20, hooks)
                else:
                    core.step(1, hooks)
            if not self.movable():
                self.say(f"[{core.frames}] the field never let the player move")
        elif kind == "goto":
            name, x, y, *most = rest.split(",")
            done, said = self.goto((self.number(name) if not name.isdigit() else int(name), int(x), int(y)),
                                   *map(int, most))
            self.say(f"[{core.frames}] {said}")
            return None if done else [said]
        elif kind == "teach":
            # teach:BATTLER,SLOT,MOVE[,PP] -- what a battler knows, written into
            # the battle as it runs (the trainer's data cannot say it): with the
            # others' PP at 0, the AI has that move to use and no other.
            battler, slot, move, *pp = rest.split(",")
            at = self.battle_mon(int(battler))
            if at is None:
                return [f"battler {battler} is not in the battle: {self.markers.battle(core.ram())}"]
            self.teach(int(battler), at, int(slot), self.number(move), int(pp[0]) if pp else 5)
        elif kind == "set":
            # set:BATTLER,FIELD,VALUE -- a battler's hp, status, ability, item or speed,
            # written into the battle as it runs, as teach: writes its moves.
            battler, field, value = rest.split(",")
            at, layout = self.battle_mon(int(battler)), battle_layout()
            if at is None:
                return [f"battler {battler} is not in the battle: {self.markers.battle(core.ram())}"]
            if field == "status":
                number = sum(mask for mask, name in STATUS if name in value.split())
            else:
                number = self.number(value)
            core.poke(at + layout[field], number, 2 if field in ("ability", "item", "speed") else 4)
        elif kind == "newgame":
            return self.new_game(int(rest or 40000))
        elif kind == "starter":
            return self.starter(self.number(rest))
        elif kind == "save":
            return self.save()
        elif kind == "fight":
            import gym
            idle = presses = 0
            while self.markers.read(core.ram(), "gDiagBattleState") != BATTLE_MAIN:
                # The field free, press after press, with no text box: nobody
                # is there to fight -- one who spotted the player on a goto
                # has been fought on it. The first press talks to whoever
                # the player faces; four more with the field still free and
                # the step gives up, rather than 300 presses later.
                idle = idle + 1 if self.movable() and not self.textbox() else 0
                if idle > 4 or presses == 300:
                    self.say(f"[{core.frames}] no battle came up")
                    return None
                core.press("A", 6, hooks)
                core.step(30, hooks)
                presses += 1
            slot, _, turns = rest.partition(":")
            gym.fight(core, self.markers, hooks, self.say, int(slot) if slot else -1, core.frames + 60000,
                      turns=int(turns) if turns else None, since=core.word(self._text_count),
                      partner=self.partner_prompt(), catch=self.balls_for)
            self._collect(core)
        elif kind == "flee":
            self.flee = int(rest)
        elif kind == "catch":
            self.catch = None if rest == "none" else rest if rest == "new" else self.number(rest)
        elif kind == "heal":
            name, x, y = rest.split(",")
            self.healer = (self.number(name), int(x), int(y))
        elif kind == "pace":
            name, x1, y1, x2, y2, key, least, *most = rest.split(",")
            return self.pace((self.number(name), int(x1), int(y1)), (self.number(name), int(x2), int(y2)),
                             key, self.number(least), int(most[0]) if most else 30000)
        else:
            button, _, times = step.partition("*")
            for _ in range(int(times or 1)):
                core.press(button, 6, hooks)
                core.step(20, hooks)
        return None

    # -- the applications --------------------------------------------------

    def app(self):
        """(the name of the running application's exec function, among those
        the steps wait for, else None; its OverlayManager): main.c's, or
        the one it opened -- the naming screen the Oak speech opens, the
        application the field launched (the starter machine)."""
        layout, core = app_layout(), self.core
        manager = core.word(self.markers.address("_02111868") + layout["UnkStruct_02111868.overlayManager"])
        if core.word(self._field) and self._chain("FieldSystem.processManager", "FieldProcessManager.child"):
            manager = self._chain("FieldSystem.processManager", "FieldProcessManager.child")
        names = {self.markers.address(n) & ~1: n for n in ("OakSpeech_Main", "NamingScreenApp_Main", "ChooseStarter_Main")}
        name = manager and names.get(core.word(manager + layout["OverlayManager.template.exec"]) & ~1)
        if name == "OakSpeech_Main":
            data = core.word(manager + layout["OverlayManager.data"])
            naming = core.word(data + layout["OakSpeechData.overlayManager"])
            if naming:
                return names.get(core.word(naming + layout["OverlayManager.template.exec"]) & ~1), naming
        return name, manager

    def through(self, button="A"):
        """One beat of a scripted scene on the field: the button for a text
        box or before the map runs, a frame otherwise (a press as the player
        gets control would talk to whoever they face)."""
        if not self._chain("FieldSystem.runningFieldMap") or self.textbox():
            self.core.press(button, 6, self.hooks)
            self.core.step(20, self.hooks)
        else:
            self.core.step(1, self.hooks)

    def new_game(self, frames):
        """newgame: from an empty flash to the player's first step in the
        bedroom. A through the intro, the title and NEW GAME; in the Oak
        speech B at its first menu, which takes the last choice (no
        information needed), A for the rest (the boy, yes, yes); the naming
        screen closed with START, which puts the cursor on OK, and A (an
        empty name is given the game's default)."""
        core, hooks, layout = self.core, self.hooks, app_layout()
        end = core.frames + frames
        while core.frames < end and not self.movable():
            name, manager = self.app()
            state = manager and core.word(manager + layout["OverlayManager.proc_state"])
            if name == "OakSpeech_Main" and core.word(core.word(manager + layout["OverlayManager.data"])
                                                      + layout["OakSpeechData.state"]) \
                    == layout["OAK_SPEECH_MAIN_STATE_TUTORIAL_MENU_HANDLE_INPUT"]:
                core.press("B", 6, hooks)
                core.step(20, hooks)
            elif name == "NamingScreenApp_Main":
                if state == layout["NS_MAIN_STATE_INPUT_LOOP"]:
                    core.press("START", 6, hooks)
                    core.press("A", 6, hooks)
                core.step(20, hooks)
            else:
                self.through()
        if not self.movable():
            return [f"the new game never reached the field in {frames} frames"]
        self.say(f"[{core.frames}] a new game on the field at {self.location()}")

    def starter(self, species):
        """starter:SPECIES -- the starter machine, opened by the step before
        (A facing it): turned until that Pokemon's ball is in front (its
        cursor, ChooseStarterAppWork.curSelection, over the machine's sSpecies),
        A to look, to be asked and to take it; then B through the lines until
        the player can move, which answers no to the nickname."""
        import re
        core, hooks, layout = self.core, self.hooks, app_layout()
        machine = re.search(r"static const int sSpecies\[\] = \{(.*?)\};",
                            savedit.source("src/choose_starter_app.c").read_text(), re.S).group(1)
        order = [self.number(name.strip()) for name in machine.split(",") if name.strip()]
        end, seen = core.frames + 20000, False
        while core.frames < end:
            name, manager = self.app()
            if name != "ChooseStarter_Main":
                if seen and self.movable():
                    break
                self.through("B" if seen else "A")
                continue
            seen = True
            work = core.word(manager + layout["OverlayManager.data"])
            if core.word(manager + layout["OverlayManager.proc_state"]) != layout["CHOOSE_STARTER_STATE_HANDLE_INPUT"]:
                core.step(1, hooks)
            elif order[core.word(work + layout["ChooseStarterAppWork.curSelection"])] != species \
                    and core.word(work + layout["ChooseStarterAppWork.state"]) != layout["SELECT_STATE_CONFIRM"]:
                core.press("RIGHT", 6, hooks)
            else:
                core.press("A", 6, hooks)
        if not (seen and self.movable()):
            return [f"the starter machine {'never opened' if not seen else 'never let the player go'}"]

    def save(self, frames=12000):
        """save: -- the game saved as a player saves it: X, the start menu's
        cursor (FieldSystem.unkD3) moved onto SAVE -- the menu's buttons are
        in RAM, not where they sit, so each direction is tried from where it
        is until SAVE is under it -- A through the questions until the write
        has begun (SaveData.saveCounter moves) and is done (lastGoodSector
        turns to the half written, Save_WriteManFinish), and B until the
        player can move again. The flash as the game left it is kept
        (self.saved) for the next leg of a chain: melonDS DS hands it over
        as memory; melonDS 0.9.3 writes it nowhere while it runs, nor when
        the game is unloaded, and cannot be asked."""
        import ctypes
        core, hooks, layout = self.core, self.hooks, app_layout()
        if not core._sram:
            return [f"{core.name} hands no flash back: save needs melonDS DS, core.py's default"]
        end = core.frames + frames
        data = core.word(self.markers.address("sSaveDataPtr"))
        counter, half = data + layout["SaveData.saveCounter"], data + layout["SaveData.lastGoodSector"]
        start, first = core.word(counter), core.word(half, 2)
        while core.frames < end and not self.movable():
            self.through()
        core.press("X", 6, hooks)

        def menu():
            task = self._chain("FieldSystem.taskman")
            if not task or core.word(task + layout["TaskManager.func"]) & ~1 != self.markers.address("Task_StartMenu") & ~1:
                return None
            env = core.word(task + layout["TaskManager.env"])
            if core.word(env + layout["StartMenuTaskData.state"], 2) != layout["START_MENU_STATE_HANDLE_INPUT"]:
                return None
            at = env + layout["StartMenuTaskData.selectionToAction"]
            return [core.word(at + i, 1) for i in range(core.word(env + layout["StartMenuTaskData.numActiveButtons"]))]
        while core.frames < end and menu() is None:
            core.step(1, hooks)
        buttons, cursor = menu() or [], core.word(self._field) + layout["FieldSystem.unkD3"]
        if layout["START_MENU_ACTION_SAVE"] not in buttons:
            return [f"the start menu has no SAVE: {buttons}"]
        tried = set()
        for press in range(40):
            here = core.word(cursor, 1)
            if here < len(buttons) and buttons[here] == layout["START_MENU_ACTION_SAVE"]:
                break
            direction = next((d for d in STEP if (here, d) not in tried), list(STEP)[press % 4])
            tried.add((here, direction))
            core.press(direction, 6, hooks)
            core.step(10, hooks)
        while core.frames < end and core.word(counter) == start:
            core.press("A", 6, hooks)
            core.step(34, hooks)
        while core.frames < end and core.word(half, 2) == first:
            core.step(10, hooks)
        if core.word(half, 2) == first:
            return [f"the game did not save in {frames} frames (counter {start} -> {core.word(counter)})"]
        self.saved = ctypes.string_at(*core._sram)
        while core.frames < end and not self.movable():
            core.press("B", 6, hooks)
            core.step(20, hooks)
        self.say(f"[{core.frames}] saved at {self.location()}: counter {start} -> {core.word(counter)}")

    # -- catching and training ---------------------------------------------

    def caught(self, ram, species):
        """Whether the Pokedex has `species` caught."""
        import party
        import where
        at = party.block(where.Memory(ram), self.elf, savedit.block_ids().index("SAVE_POKEDEX")) - 0x02000000 + caught_at()
        return ram[at + (species - 1) // 8] >> (species - 1) % 8 & 1

    def balls_for(self, species):
        """For gym.fight: the balls the bag holds when catch: wants this wild
        species -- itself, or "new", and not caught yet -- else 0. The bag in
        the save, which the battle copies and gives back at its end."""
        import party
        import where
        if self.catch not in ("new", species):
            return 0
        ram = self.core.ram()
        if self.caught(ram, species):
            return 0
        bag = party.block(where.Memory(ram), self.elf, savedit.block_ids().index("SAVE_BAG")) - 0x02000000
        start, slots = savedit.pocket_at("balls")
        return sum(struct.unpack_from("<HH", ram, bag + start + 4 * i)[1] for i in range(slots))

    def pace(self, a, b, key, least, frames):
        """pace: -- from one tile to the other and back until `key` reads at
        least `least`; at the heal: tile between two walks when the party's
        first Pokemon has under flee:'s share of its HP (or none)."""
        import party
        end, ends, walks = self.core.frames + frames, [a, b], 0
        while self.core.frames < end:
            now = self.value(self.core.ram(), key) or 0
            if now >= least:
                self.say(f"[{self.core.frames}] pace: {key} {now} after {walks} walks")
                return None
            first = party.mons(self.core.ram(), self.elf)[0]
            if self.healer and first["hp"] * 100 < max(self.flee, 1) * first["maxHp"]:
                for step in (f"goto:{','.join(map(str, self.healer))}", "UP", "A", "field"):
                    self.run(step)
            done, said = self.goto(ends[0], end - self.core.frames)
            self.say(f"[{self.core.frames}] pace: {said}")
            if not done:
                return [f"pace: {said}"]
            ends.reverse()
            walks += 1
        return [f"pace: {key} is {self.value(self.core.ram(), key)}, under {least}, after {frames} frames"]

    # -- the navigator -----------------------------------------------------

    def objects(self):
        """The tiles the map's live objects stand on -- the player and the
        Pokemon following them apart -- read from MapObjectManager, each
        mapped to the tile it started on."""
        layout, core = field_layout(), self.core
        manager = self._chain("FieldSystem.mapObjectManager")
        player = self._chain("FieldSystem.playerAvatar", "PlayerAvatar.mapObject")
        here = self.location()
        if not manager or not here:
            return {}
        count = core.word(manager + layout["MapObjectManager.objectCount"])
        first = core.word(manager + layout["MapObjectManager.objects"])
        out = {}
        for i in range(min(count, 64)):
            obj = first + i * layout["LocalMapObject.size"]
            # flags bit 0 is MAPOBJECTFLAG_ACTIVE; id 253 is obj_partner_poke, which steps aside
            if obj == player or not core.word(obj) & 1 or core.word(obj + 8) == 253:
                continue
            x, z = core.word(obj + layout["LocalMapObject.currentX"]), core.word(obj + layout["LocalMapObject.currentZ"])
            x0, z0 = core.word(obj + layout["LocalMapObject.initialX"]), core.word(obj + layout["LocalMapObject.initialZ"])
            out[(tile(here[0], x, z) or (here[0],))[0:1] + (x, z)] = (tile(here[0], x0, z0) or (here[0],))[0:1] + (x0, z0)
        return out

    def facing(self):
        """The direction the player faces, as STEP names it (DIR_NORTH 0,
        SOUTH 1, WEST 2, EAST 3)."""
        obj = self._chain("FieldSystem.playerAvatar", "PlayerAvatar.mapObject")
        return obj and ("UP", "DOWN", "LEFT", "RIGHT")[self.core.word(obj + field_layout()["LocalMapObject.currentFacing"]) & 3]

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
        something stands on, or started on, is reached beside it where it
        stands now, facing it. Returns
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
                          since=core.word(self._text_count), partner=self.partner_prompt(), flee=self.flee,
                          catch=self.balls_for)
                self._collect(core)
                continue
            if not self.movable():
                if self.textbox():
                    texts += 1
                    core.press("A", 6, hooks)
                    core.step(10, hooks)
                elif not self._chain("FieldSystem.runningFieldMap"):
                    # A screen over the field that waits for a press: a phone
                    # call (Elm's as the player leaves Mr. Pokemon's house),
                    # the blackout's. B, not A: a call ends in the Pokegear's
                    # list of numbers, where A calls the one under the cursor
                    # and B, twice, closes the Pokegear.
                    core.press("B", 6, hooks)
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
                # Whoever started on the goal is sought where they stand now:
                # Black Belt Lung wanders along Cianwood Gym's row 3, and
                # from (17, 3) he blocks the only way to his own (15, 3).
                target = next((now for now, start in objects.items() if start == goal), goal)
                goals = [target]
                if target in objects or not (tile(*target) and not tile(*target)[1] & savedit.COLLISION):
                    goals = [(target[0], target[1] + dx, target[2] + dz) for dx, dz in STEP.values()]
                path = None
            if here in goals:
                if target in objects and target not in self.objects():
                    path = None     # they walked on while the player came
                    continue
                if goals != [target]:   # face whoever stands on the goal
                    want = next(d for d, (dx, dz) in STEP.items() if (here[1] + dx, here[2] + dz) == target[1:])
                    # A pressed while the turn still plays is not read: the
                    # mother once never gave the Pokegear for an A one frame
                    # too early. And a 4-frame turn right after a step is
                    # not always taken (Cianwood Gym): press until it is.
                    for _ in range(4):
                        core.press(want, 4, hooks)
                        core.step(16, hooks)
                        if self.facing() == want:
                            break
                else:
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

    def teach(self, battler, at, slot, move, pp):
        """teach:'s write, for a battler that may have chosen its move. A foe
        is asked for its move as the turn's choosing starts -- on turn one
        before the player's prompt, later with it -- and the battle keeps
        the slot it gave, running whatever that holds when it moves: one
        asked before fight:N:T stopped ran a slot teach: emptied ("The wild
        Chansey's - is disabled!"), or the move taught over the one it had
        chosen. An answer on its way is let in first (SSI_STATE_4 to 6, a
        message), the moves are written, and a battler that has given its
        move (asks_again) is put back to SSI_STATE_3, where the battle asks
        it again with the moves it knows now."""
        layout, core, states = battle_layout(), self.core, select_states()
        context = at - layout["mons"] - battler * layout["size"]
        state, chose = context + layout["select"] + battler, context + layout["chose"] + battler
        on_its_way = {states[n] for n in ("SSI_STATE_4", "SSI_STATE_5", "SSI_STATE_6", "SSI_STATE_15",
                                          "SSI_STATE_NO_MOVES", "SSI_STATE_END")}
        for _ in range(300):
            if core.word(state, 1) not in on_its_way:
                break
            core.step(1, self.hooks)
        core.poke(at + layout["moves"] + 2 * slot, move, 2)
        core.poke(at + layout["pp"] + slot, pp, 1)
        moves = [core.word(at + layout["moves"] + 2 * k, 2) for k in range(4)]
        pp = [core.word(at + layout["pp"] + k, 1) for k in range(4)]
        if asks_again(core.word(state, 1), core.word(chose, 1), moves, pp):
            core.poke(chose, core.word(chose, 1) & ~6, 1)
            core.poke(state, states["SSI_STATE_3"], 1)

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
        if name == "music":
            # SND_HANDLE_FIELD's player, the first of sSoundWork's handles
            # (src/sound.c): 1 at 0x34 for a sequence, its number at 0x38
            # (NNS_SndPlayerGetSeqNo).
            import re
            handles = int(re.search(r"/\* (0x[0-9A-F]+) \*/ NNSSndHandle \w+\[SND_HANDLE_MAX\];",
                                    (ROOT / "src/sound.c").read_text()).group(1), 16)
            player = struct.unpack_from("<I", ram, markers.address("sSoundWork") + handles - 0x02000000)[0]
            if not player or struct.unpack_from("<H", ram, player + 0x34 - 0x02000000)[0] != 1:
                return -1
            return struct.unpack_from("<H", ram, player + 0x38 - 0x02000000)[0]
        if name in ("map", "x", "y"):
            here = self.location()
            return here and here[("map", "x", "y").index(name)]
        memory = where.Memory(ram)
        if name == "party":
            return memory.word(party.block(memory, self.elf, where.SAVE_PARTY) + where.PARTY_COUNT)
        if name == "badges":
            return party.badges(ram, self.elf)
        if name.startswith("options."):
            at = party.block(memory, self.elf, savedit.block_ids().index("SAVE_PLAYERDATA")) - 0x02000000
            offset, width, mask = options_layout()[name.partition(".")[2]]
            return savedit.get_bits(ram, (at + offset, width, mask))
        if name == "running_shoes":
            at = party.block(memory, self.elf, savedit.block_ids().index("SAVE_LOCAL_FIELD_DATA")) - 0x02000000
            offset, width, mask = savedit._given_layout()["shoes"]
            return savedit.get_bits(ram, (at + offset, width, mask))
        if name.startswith("bag:"):
            return party.bag(ram, self.elf, self.number(name[len("bag:"):]))
        if name.startswith("party") and "." in name:
            slot, field = name[len("party"):].split(".")
            mons = party.sealed_mons(self.core, self.elf, self.hooks)
            return mons[int(slot)][field] if int(slot) < len(mons) else None
        if name.startswith("caught:"):
            return self.caught(ram, self.number(name[len("caught:"):]))
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
        ram, wrong, since = self.core.ram(), [], self._checked
        if final:
            expect = {"asserts": 0, "alloc_failures": 0, **expect}
        for key, start in (("lines", 0), ("new_lines", self._checked)):
            at = start
            for line in expect.get(key, []):
                found = next((i for i in range(at, len(self.lines)) if line in self.lines[i]), None)
                if found is None:
                    earlier = any(line in printed for printed in self.lines[:at])
                    wrong.append(f"the line {line!r} was not printed" + (" since the check before" if key == "new_lines" else "")
                                 + (" in that order" if earlier else ""))
                else:
                    at = found + 1
        self._checked = len(self.lines)
        for line in expect.get("once_lines", []):
            times = sum(line in printed for printed in self.lines[since:])
            if times != 1:
                wrong.append(f"the line {line!r} was printed {times} times since the check before, not once")
        wrong += [f"the line {line!r} was printed" for line in expect.get("no_lines", [])
                  if any(line in printed for printed in self.lines)]
        low = self.markers.heaps(ram)
        for heap, least in expect.get("heaps", {}).items():
            if heap not in low:
                wrong.append(f"{heap} never allocated")
            elif low[heap] < self.number(least):
                wrong.append(f"{heap} had {low[heap]:#x} left at its fullest, under {self.number(least):#x}")
        for name, expected in expect.items():
            if name in ("lines", "new_lines", "once_lines", "no_lines", "heaps"):
                continue
            test, said = self.wanted(name, expected)
            value = self.value(ram, name)
            if not test(value):
                wrong.append(f"{name} is {value}, not {said}")
        return wrong


def leg_save(path, chain, rom=ROM, elf=DIAG_ELF):
    """The save a leg starts from, when it names the leg before ("from"):
    the one that leg's in-game save left in the chain's directory, the leg
    played first, on the same ROM, when it has not been yet. (the save or
    None, the report's lines when there is none)."""
    before = json.loads(Path(path).read_text())["from"]
    save, report = chain / f"{before}.sav", chain / f"{before}.txt"
    if not save.exists() and not report.exists():
        subprocess.run([sys.executable, __file__, "--scenario", str(Path(path).with_name(f"{before}.json")),
                        "--chain", str(chain), "--rom", str(rom), "--elf", str(elf)], stdout=subprocess.DEVNULL)
    if save.exists():
        return save, []
    lines = report.read_text().splitlines() if report.exists() else [f"{before} did not run"]
    kind = "SKIP" if lines[0].startswith("SKIP") else "FAIL"
    return None, [f"{kind} {Path(path).name}: the leg before, {before}, left no save"] + [f"  {line}" for line in lines]


def scenario(path, rom=ROM, elf=DIAG_ELF, out=None, record=None, chain=None):
    """Run one scenario file: (True, False, or None when it cannot run here;
    the report's lines). A leg of a chain writes its report, and on a pass
    the in-game save it made, to the chain's directory as NAME.txt and
    NAME.sav, for the leg after it."""
    spec = json.loads(Path(path).read_text())
    chain = Path(chain or tempfile.mkdtemp(prefix="newgold-chain-"))
    chain.mkdir(parents=True, exist_ok=True)
    save, report, saved = None, [], None
    if "from" in spec:
        save, report = leg_save(path, chain, rom, elf)
    elif "save" in spec:
        save = Path(spec["save"]) if Path(spec["save"]).is_absolute() else SAVES / spec["save"]
        if not save.exists():
            save, report = None, [f"SKIP {Path(path).name}: {save} is not on this machine"]
    # no save and nothing said: a new game, from the flash as it leaves the factory
    passed = None if report[:1] and report[0].startswith("SKIP") else False
    if not report:
        passed, report, saved = play_scenario(path, spec, save, rom, elf, out, record)
    (chain / f"{Path(path).stem}.txt").write_text("\n".join(report) + "\n")
    if passed and saved:
        (chain / f"{Path(path).stem}.sav").write_bytes(saved)
    return passed, report


def play_scenario(path, spec, save, rom, elf, out, record):
    out = Path(out or tempfile.mkdtemp(prefix=f"newgold-scene-{Path(path).stem}-"))
    out.mkdir(parents=True, exist_ok=True)
    copy = None
    if save:
        copy = out / "save.sav"
        shutil.copyfile(save, copy)
    if spec.get("edit"):
        edit = subprocess.run([sys.executable, str(ROOT / "tools/newgold/devkit/savedit.py"), *spec["edit"], str(copy)],
                              capture_output=True, text=True)
        if edit.returncode:
            return False, [f"FAIL {Path(path).name}: savedit.py {' '.join(spec['edit'])}: "
                           + (edit.stderr.strip().splitlines() or ["failed"])[-1]], None
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
    return not wrong, report, scene.saved


def main():
    pin_clock()
    if "--scenario" in sys.argv:
        parser = argparse.ArgumentParser()
        parser.add_argument("--scenario", type=Path, required=True)
        parser.add_argument("--out", type=Path)
        parser.add_argument("--record", type=Path, help="the run, picture and sound, to this mp4 (core.py)")
        parser.add_argument("--rom", default=ROM)
        parser.add_argument("--elf", type=Path, default=DIAG_ELF)
        parser.add_argument("--chain", type=Path, help="where the legs of a chain leave their saves (a new "
                                                        "directory, and the legs before played, by default)")
        args = parser.parse_args()
        from gym import quiet
        out = quiet()
        passed, report = scenario(args.scenario, args.rom, args.elf, args.out, args.record, args.chain)
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
    from gym import quiet
    sys.stdout = quiet()    # the core's own chatter off, as --scenario has it
    scene = Scene(None if args.save == "new" else args.save, args.rom, args.elf, args.out, say=print, record=args.record)
    for step in args.steps:
        scene.run(step)
    print(scene.markers.describe(scene.core.ram()))
    if scene.saved:
        (args.out / "saved.sav").write_bytes(scene.saved)
    scene.core.close()


if __name__ == "__main__":
    main()
