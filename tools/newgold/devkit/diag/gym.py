#!/usr/bin/env python3
"""Fight what a save stands the player in front of, and report it as text.

    gym.py SAVE [--move N] [--frames N]

Without --move it picks, each turn, the move that hits hardest by the game's
own data: power from the move table, same-type bonus from the personal
records, and the type chart from the battle's source. That is a heuristic --
no accuracy, no stat stages, no status moves unless nothing else is left --
but it is enough to play a leader rather than lose to one on purpose. A move
the battle says did nothing to a foe (Levitate against a Ground move) is not
chosen against that species again in the battle.

The ROM is the NEWGOLD_DIAG=1 build, run in-process by core.py. Nothing is
drawn and nothing is looked at: after every few frames the diagnostics'
memory says what the battle printed, who is fighting, and whether the game
is waiting for the player, and the player answers through the game's own
menus -- a touch on FIGHT, on a move, on a Pokemon -- exactly where a thumb
would go. B moves text on and declines "will you switch?" and a caught
Pokemon's nickname; A moves it on through an evolution, which B would stop,
and a caught Pokemon's Dex entry, which B does not close. A move a level-up
brings to a Pokemon that knows four is learned or given up by a rule
(forgets): the strongest damaging move of each type is kept, strongest
first, then the other damaging moves, then the rest. A wild battle's "Use
next Pokemon?" is answered with the next one. A wild Pokemon the caller
wants caught is weakened and a ball thrown at it (fight's catch).

The report is the battle's own lines, the battlers each turn, what the
trainer's AI spent, anything that asserted, and the party before and after.
"""
import argparse
import os
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import savedit  # noqa: E402
from core import Core, pin_clock  # noqa: E402
from markers import BATTLER, DIAG_ELF, STATES, Markers  # noqa: E402
from party import badges, party, sealed_mons  # noqa: E402

ROOT = Path(__file__).resolve().parents[4]
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
# The bottom screen, in its own pixels (256 by 192).
FIGHT = (128, 83)
RUN = (128, 170)             # under FIGHT
MOVES = [(64, 51), (192, 51), (64, 116), (192, 116)]
PARTY = [(64, 35), (192, 38), (64, 78), (192, 81), (64, 123), (192, 126)]
SHIFT = (127, 113)
KEEP_BATTLING = (128, 139)   # "will you switch?" -- the lower of the two
GIVE_UP = (128, 67)          # "give up on learning this new move?" -- the upper of the two
USE_NEXT = (128, 67)         # a wild battle's "Use next Pokemon?" -- the upper; the lower flees
FORGET_A_MOVE = (128, 67)    # "Make it forget another move?" -- the upper, "Forget a move!"
# The battle party menu a move to forget opens (its mode 3): on screen 6 the
# four moves where the fight menu has them, the new one below and the back
# arrow, which gives the new one up; on screen 7, a move's page, FORGET.
LEARN_MOVES, LEARN_BACK, LEARN_FORGET = [(64, 73), (192, 73), (64, 120), (192, 120)], (234, 170), (104, 170)
LEARN_MODE, LEARN_LIST, LEARN_PAGE = 3, 6, 7
BAG = (40, 170)              # left of RUN
POKEMON = (216, 170)         # right of RUN
# The battle bag, overlay 8, by its hitbox tables: the Poke Balls pocket at
# the upper right (ov08_02225B4C), a pocket page's first item at the upper
# left (ov08_02225B68), USE along the bottom (ov08_02225ADC).
BALLS, FIRST_ITEM, USE = (192, 43), (64, 31), (104, 171)
IN_BAG = 8                   # gDiagBattlePrompt while the bag is up (SSI_STATE_8)
MARGIN = 50                  # a Pokemon to catch is weakened while it has more than this share of its HP
# The lines after which the party screen asks who comes in for a Pokemon that
# is still standing: a pivot move's or Parting Shot's, the Eject items',
# Baton Pass's (whose move line is the last before the screen) and Shed
# Tail's. A Baton Pass with nobody to pass to says "But it failed!" after it.
PIVOT_LINES = ("went back to", "switched out with the Eject Button", "switched out by the Eject Pack",
               "used Baton Pass!", "shed its tail to create a decoy!")
# A double battle's target screen: the foes above, battler 3 on the left and
# battler 1 on the right, and the player's two below, the first on the left.
# A move on the user's side is confirmed on its own panel.
FOE_PANELS = [(64, 43), (192, 43)]
OWN_PANELS = {0: (64, 115), 2: (192, 115)}
RANGE_USER, RANGE_USER_SIDE, RANGE_ALLY = 1 << 4, 1 << 5, 1 << 8   # include/constants/moves.h
BATTLE_MAIN, EXIT = STATES.index("BATTLE_MAIN"), STATES.index("EXIT")
EVOLVING = (STATES.index("EVOLUTION_INIT"), STATES.index("EVOLUTION_MAIN"))


def narc(path):
    """The members of an archive, as bytes."""
    data = path.read_bytes()
    count = struct.unpack_from("<H", data, 0x18)[0]
    spans = [struct.unpack_from("<II", data, 0x1C + 8 * i) for i in range(count)]
    base = data.index(b"GMIF") + 8
    return [data[base + start:base + end] for start, end in spans]


class Scorer:
    """How hard a move hits a Pokemon, from the data this tree builds."""

    def __init__(self):
        self.moves = narc(ROOT / "files/poketool/waza/waza_tbl.narc")
        self.personal = narc(ROOT / "files/poketool/personal/personal.narc")
        header = (ROOT / "include/constants/pokemon.h").read_text()
        # TYPE_FORESIGHT is 0xFE: read as a bare \d+ it is 0, and the Foresight
        # marker row becomes "Normal does nothing to Normal".
        numbers = {name: int(value, 0) for name, value in
                   re.findall(r"#define (TYPE_\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b", header)}
        source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        table = source[source.index("sTypeEffectiveness[][3] = {"):]
        table = table[:table.index("};")]
        self.chart = {(numbers[a], numbers[d]): numbers[m] / 10
                      for a, d, m in re.findall(r"\{\s*(TYPE_\w+),\s*(TYPE_\w+),\s*(TYPE_MUL_\w+)\s*\}", table)}

    def types(self, species):
        record = self.personal[species] if species < len(self.personal) else b""
        return set(record[6:8]) if len(record) >= 8 else set()

    def panel(self, move, battler, tries):
        """Where to touch on the target screen for this move of this battler."""
        record = self.moves[move] if move < len(self.moves) else b""
        reach = struct.unpack_from("<H", record, 8)[0] if len(record) >= 10 else 0
        if reach & (RANGE_USER | RANGE_USER_SIDE):
            return OWN_PANELS[battler]
        if reach & RANGE_ALLY:
            return OWN_PANELS[2 - battler]
        # The player's first aims at battler 3, its second at battler 1, each
        # at the other foe when that touch is not taken (the foe gone).
        return FOE_PANELS[(tries + battler // 2) % 2]

    def kind(self, move):
        record = self.moves[move] if move < len(self.moves) else b""
        return record[4] if len(record) >= 5 else None

    def strength(self, move, user):
        """A move's power with its same-type bonus, 0 for a status move: how
        forgets() ranks what a Pokemon knows, against no foe in particular."""
        record = self.moves[move] if move < len(self.moves) else b""
        if len(record) < 5 or record[3] == 0:
            return 0
        return record[3] * (1.5 if record[4] in self.types(user) else 1)

    def score(self, move, user, target):
        record = self.moves[move] if move < len(self.moves) else b""
        # effect (2 bytes), split, power, type: import_moves.py's RECORD.
        if len(record) < 5 or record[3] == 0:
            return 0.1  # a status move, or one this table does not know: last resort
        power, kind = record[3], record[4]
        value = power * (1.5 if kind in self.types(user) else 1)
        for defending in self.types(target):
            value *= self.chart.get((kind, defending), 1)
        return value


def forgets(scorer, species, moves):
    """Which of a Pokemon's moves -- the four it knows, then the one a
    level-up or a machine brings -- it lets go: the last in the order it
    keeps them, the strongest damaging move of each type first, strongest
    first, then its other damaging moves, then the moves that deal no
    damage; on a tie the move known before, so 4 is the new one given up."""
    power = [scorer.strength(move, species) for move in moves]
    order = sorted(range(len(moves)), key=lambda i: -power[i])
    kinds, best = set(), []
    for i in order:
        if power[i] and scorer.kind(moves[i]) not in kinds:
            kinds.add(scorer.kind(moves[i]))
            best.append(i)
    ranked = best + [i for i in order if power[i] and i not in best] + [i for i in range(len(moves)) if not power[i]]
    return ranked[-1]


def battler_hp(line):
    """The HP a battler line of markers.battle gives, "you Raichu Alolan L30
    12/80 ...": found by its shape, since a species name can be two words."""
    return int(re.search(r" (\d+)/\d+", line).group(1))


def runs(view, wild, flee):
    """Whether the player runs this turn: a wild battle, and its Pokemon
    (markers.battle's first line) under `flee` percent of its HP."""
    hp = re.search(r" (\d+)/(\d+)", view[0]) if view else None
    return bool(wild and hp and int(hp.group(1)) * 100 < flee * int(hp.group(2)))


def throws_now(hp, max_hp, hit, damaging):
    """Whether a wild Pokemon to be caught gets a ball this turn rather than
    the player's weakest damaging move: at MARGIN percent of its HP or
    under, within half again the most a move has taken off it (a critical
    hit, a high roll), or with no damaging move left to weaken it."""
    return hp * 100 <= MARGIN * max_hp or 2 * hp <= 3 * hit or not damaging


def may_run(wild, line):
    """Whether the player may still run after this battle line: a wild
    battle, until a try has failed ("You couldn't get away!") or the
    Pokemon is trapped ("You can't escape!", CantEscape: Wrap, Mean Look...,
    with no turn spent, so trying again would choose RUN for ever); it
    fights instead."""
    return (wild or line.startswith("You encountered a wild")) and "get away" not in line and "escape" not in line


def aimed_at(ram, markers, battler):
    """The foe a move of the player's `battler` (0 or 2) is scored against:
    the one its touch on the target screen goes to (Scorer.panel) --
    battler 3 for the first, battler 1 for the second -- or the other foe
    when that one is not up (no battler 3 in a single battle, or fainted)."""
    at, size = markers.address("gDiagBattlers") - 0x02000000, struct.calcsize(BATTLER)
    first, other = (3, 1) if battler == 0 else (1, 3)
    foe = struct.unpack_from(BATTLER, ram, at + first * size)
    return foe if foe[0] and foe[1] else struct.unpack_from(BATTLER, ram, at + other * size)


@savedit.tree_cache
def bag_state_at():
    """Where the battle bag keeps the state its task runs (BattleBag.state)."""
    return savedit.compile_c(exprs=("__builtin_offsetof(BattleBag, state)",),
                             headers=savedit.LAYOUT_HEADERS + ("battle_bag.h",))[0][0]


def task_data(ram, markers, func, priority):
    """Where the data of the task running `func` at `priority` is in `ram`
    (a SysTask's priority, data and func in a row; a task ended is
    cleared, and the function's address in a literal pool is no task), or
    None."""
    func = markers.address(func) & ~1
    for word in (func | 1, func):
        for m in re.finditer(re.escape(struct.pack("<I", word)), ram):
            if m.start() % 4 == 0:
                at, data = struct.unpack_from("<II", ram, m.start() - 8)
                if at == priority and 0x02000000 <= data < 0x02400000:
                    return data - 0x02000000
    return None


def bag_screen(ram, markers):
    """The battle bag's state: 1 its pockets, 2 a pocket's items, 3 an
    item's USE, anything else between them. Found through the bag's task,
    the one running ov08_02222670 at priority 100, the bag its data; None
    when there is none."""
    bag = task_data(ram, markers, "ov08_02222670", 100)
    return None if bag is None else ram[bag + bag_state_at()]


@savedit.tree_cache
def learn_layout():
    """What learn_menu reads of the battle party menu and its arguments."""
    names = ("BattlePartyMenu, args", "BattlePartyMenu, screen", "BattlePartyMenu, mons", "BattlePartyMenuMon, moves",
             "BattlePartyMenuArgs, selectedPos", "BattlePartyMenuArgs, cannotSwitch", "BattlePartyMenuArgs, mode")
    values = savedit.compile_c(exprs=tuple(f"__builtin_offsetof({n})" for n in names)
                               + ("sizeof(BattlePartyMenuMon)", "sizeof(((BattlePartyMenuMon *)0)->moves[0])"),
                               headers=savedit.LAYOUT_HEADERS + ("battle_party_menu.h",))[0]
    return dict(zip(("args", "screen", "mons", "moves", "slot", "move", "mode", "mon", "entry"), values))


def learn_menu(ram, markers):
    """The battle party menu while a level-up asks which move to forget:
    (its screen, the party slot learning, the four moves that Pokemon
    knows, the one it wants to learn), or None. Its task runs ov08_0221BE98
    at priority 0, the menu its data; in that mode (3) the menu lists the
    party by slot, selectedPos is the one learning and cannotSwitch holds
    the new move."""
    menu = task_data(ram, markers, "ov08_0221BE98", 0)
    layout = learn_layout()
    if menu is None:
        return None
    args = struct.unpack_from("<I", ram, menu + layout["args"])[0] - 0x02000000
    if not 0 <= args < len(ram) or ram[args + layout["mode"]] != LEARN_MODE:
        return None
    slot = ram[args + layout["slot"]] % 6
    mon = menu + layout["mons"] + slot * layout["mon"] + layout["moves"]
    known = [struct.unpack_from("<H", ram, mon + k * layout["entry"])[0] for k in range(4)]
    return ram[menu + layout["screen"]], slot, known, struct.unpack_from("<H", ram, args + layout["move"])[0]


def throw(core, markers, hold, frames=1500):
    """The bag's first ball thrown: BAG, then the Poke Balls pocket, the
    first ball on its page and USE, each touched while the bag's state says
    that screen takes input -- again while it fades in, when a touch is not
    read, and BAG again while the command menu is still asking (its buttons
    come up a little after the prompt). True once the bag has closed on it."""
    touches, seen, end = {1: BALLS, 2: FIRST_ITEM, 3: USE}, False, core.frames + frames
    while core.frames < end:
        prompt = markers.read(core.ram(), "gDiagBattlePrompt")
        if prompt == 1 and not seen:
            core.touch(*BAG, 6, hold)
        core.step(10, hold)
        ram = core.ram()
        if markers.read(ram, "gDiagBattlePrompt") != IN_BAG:
            if seen:
                return True
            continue
        seen = True
        state = bag_screen(ram, markers)
        if state in touches:
            core.touch(*touches[state], 6, hold)
    return False


def relieve(core, markers, hold, slot, frames=900):
    """Party slot `slot` sent in for the Pokemon out: POKEMON while the
    command prompt still asks, then, once the party screen asks (prompt 9
    or 10), the slot's place on it and SHIFT. True once the prompt has
    moved past the party screen."""
    end, asked = core.frames + frames, False
    while core.frames < end:
        prompt = markers.read(core.ram(), "gDiagBattlePrompt")
        if prompt == 1 and not asked:
            core.touch(*POKEMON, 6, hold)
        elif prompt in (9, 10):
            asked = True
            core.step(20, hold)
            core.touch(*PARTY[place(core.ram(), markers, slot)], 6, hold)
            core.step(30, hold)
            core.touch(*SHIFT, 6, hold)
        elif asked:
            return True
        core.step(10, hold)
    return False


def wasted(line, foe, move):
    """The (foe species, move) this battle line shows did nothing to the
    foe -- what the type chart does not know: Levitate against a Ground
    move, an immunity an ability or a form gives -- or None. The move is the
    last the player's first Pokemon chose (ponytail: in a double battle the
    partner's is not told apart)."""
    said = ("makes Ground moves", "doesn’t affect", "doesn't affect", "is unaffected")
    if move and any(part in line for part in said) and ("opposing" in line or "wild" in line):
        return foe, move
    return None


def second_down(ram, markers):
    """Whether the player's second Pokemon in a double battle has fainted."""
    second = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000 + 2 * struct.calcsize(BATTLER))
    return second[0] != 0 and second[1] == 0


def reserve(ram, markers):
    """The party slot the party screen after a faint or a pivot sends: the
    first Pokemon with HP left, by party slot, that is not already out --
    in a double battle, not the partner still standing. place() finds it on
    the screen."""
    at, size = markers.address("gDiagBattlers") - 0x02000000, struct.calcsize(BATTLER)
    out = {mon[4] for mon in (struct.unpack_from(BATTLER, ram, at + b * size) for b in (0, 2)) if mon[0] and mon[1]}
    species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)
    hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
    return next((i for i in range(6) if species[i] and hp[i] and i not in out), None)


def place(ram, markers, slot):
    """Where the battle's party screen shows party slot `slot`: the battle
    keeps its own order (gDiagPartyOrder), which a switch changes -- the
    Pokemon that came in moves to the top."""
    order = struct.unpack_from("<6B", ram, markers.address("gDiagPartyOrder") - 0x02000000)
    return order.index(slot)


def quiet():
    """The core prints its own diagnostics to the process's stdout and stderr;
    keep ours, and Python's own stderr so a crash still says why."""
    keep, keep_err = os.dup(1), os.dup(2)
    null = os.open(os.devnull, os.O_WRONLY)
    os.dup2(null, 1)
    os.dup2(null, 2)
    sys.stderr = os.fdopen(keep_err, "w", buffering=1)
    return os.fdopen(keep, "w", buffering=1)


def fight(core, markers, hold, say, move=-1, frames=40000, scorer=None, turns=None, since=0, partner=None, flee=0,
          catch=None, shift=None):
    """Play the battle that is up until it is over or the core reaches
    `frames`, and return the last line it printed. `move` is a move slot,
    1 to 4, to use every turn; 0 the first with PP; -1 the hardest-hitting
    by the Scorer. `hold` runs before every frame, `say` gets the report.
    With `turns`, it stops as the turn after that many starts its choosing,
    the battle waiting, so what a turn did can be read (on turn one before
    the command menu is up: see below); called again, it goes on,
    and `since` (the text counter then) keeps it from saying old lines again.
    The player's own Revival Blessing opens the party menu in its revive
    mode, which takes only a fainted Pokemon: the first fainted is chosen.
    `partner`, in a double battle, says where the player's second Pokemon is
    in choosing (its BattleContext.unk_0, as gDiagBattlePrompt is the
    first's); it chooses as the first does, from its own moves. A move that
    asks for a target is aimed, every turn, by the player's first at battler
    3 and by its second at battler 1 -- at the other foe when that touch is
    not taken -- and one on the user's side at the user or its partner; each
    scores its moves against the foe it aims at (aimed_at). With
    `flee`, a percentage, the player runs from a wild Pokemon when its own has
    less than that share of its HP left, as a player walking a long route
    does rather than black out.

    With `catch`, a function of a wild Pokemon's species giving how many
    balls the player may throw at it (0: none, it is not wanted), the
    player weakens a wanted one with its weakest damaging move while the
    wild one has more than MARGIN percent of its HP and more than half again
    the most that move has taken off it, then throws them, one a turn, from
    the bag: the battle keeps a copy of the bag, so the balls thrown are
    counted here. Running, when `flee` says so, comes first.

    With `shift`, a party slot, a wild battle's first Pokemon out is
    relieved by that one at the first prompt: it fights, and the first,
    which has been out, shares what the battle pays -- the way a player
    trains a Pokemon too weak to win its own battles.

    Memory is read every four frames, but the text ring is decoded only when
    its counter has moved: decoding it every time halved the frame rate.
    """
    scorer = scorer or Scorer()
    seen, last_view, stuck, idle, last_line = set(range(since)), None, 0, 0, ""
    refused, last_slot = set(), None   # moves the game turned down this turn: Taunt, Disable, no PP
    last_count, last_asserts, restarts, decoded = 0, 0, 0, None
    last_prompt, commands, revive, use_next = None, 0, None, None
    moves_chosen, tries = {}, 0        # the move each of the player's two took, for its target screen
    wild, useless = False, set()       # useless: (foe, move) a line said did nothing
    wild_battle, weakening, foe_before, hit, thrown = False, False, None, 0, 0
    learning = None                    # the (party slot, move) a level-up's choice was said for
    while core.frames < frames:
        core.step(4, hold)
        ram = core.ram()
        # A console reset clears the diagnostics with the rest of memory: the
        # line counter going backwards is how it shows. Say so, and start the
        # lines over, or everything after it looks like silence.
        count = markers.read(ram, "gDiagBattleTextCount")
        if count < last_count:
            restarts += 1
            say(f"[{core.frames}] the game restarted")
            seen = set()
            if restarts > 2:
                break
        last_count = count
        asserts = markers.read(ram, "gDiagAssertCount")
        if asserts != last_asserts:
            say(f"[{core.frames}] an assertion failed: " + markers.describe(ram).split("asserts ", 1)[1].split(" | ")[0])
            at = markers.address("gDiagLastMessage")
            if at is not None:
                say(f"[{core.frames}]   the last message asked for: row, tag, params = {struct.unpack_from('<5I', ram, at - 0x02000000)}")
                say(f"[{core.frames}]   the last message a script asked for: row, archive, member, position = "
                    f"{struct.unpack_from('<4I', ram, markers.address('gDiagLastScriptMessage') - 0x02000000)}")
                say(f"[{core.frames}]   the script running: archive, member, position = "
                    f"{struct.unpack_from('<3I', ram, markers.address('gDiagBattleScript') - 0x02000000)}")
            last_asserts = asserts
        for index, line in markers.text(ram) if count != decoded else ():
            if index not in seen and line:
                seen.add(index)
                last_line = line
                if last_slot is not None and any(word in line for word in ("can’t use", "can't use", "is disabled", "no PP left", "can’t be used")):
                    refused.add(last_slot)
                if " used " in line and not line.startswith("The foe") and "Leader" not in line:
                    refused.clear()
                if " used Revival Blessing!" in line and not line.startswith(("The opposing", "The wild")):
                    revive = core.frames
                if "But it failed" in line or "was revived" in line:
                    revive = None
                if "Use next Pok" in line:
                    use_next = core.frames
                wild_battle = wild_battle or line.startswith("You encountered a wild")
                wild = may_run(wild, line)
                useless.add(wasted(line, aimed_at(ram, markers, 0)[0], moves_chosen.get(0)))
                if not line.startswith("What will"):
                    say(f"[{core.frames}] {line}")
        decoded = count
        state = markers.read(ram, "gDiagBattleState")
        if state == EXIT:
            say(f"[{core.frames}] the battle is over")
            break
        view = markers.battle(ram)
        prompt = markers.read(ram, "gDiagBattlePrompt")
        you_hp = battler_hp(view[0]) if view and view[0].startswith("you") else 1
        # A turn's command is the first place's to give, or, with the first
        # place empty in a double battle, the second's.
        asked = partner() if you_hp == 0 and partner else prompt
        # A turn's choosing starts at 1 or, on turn one, at 2, where the
        # player waits for the AI's choice and the menu is not up yet
        # (markers.PROMPTS): `turns` stops there, where on turn one the foe
        # has often not answered yet, so a teach: or set: then is what its
        # first choice is made with (teach: asks again one that has).
        if asked in (1, 2) and last_prompt not in (1, 2):
            commands += 1
        last_prompt = asked
        if asked in (1, 2) and turns is not None and commands > turns:
            return last_line
        if prompt == 2:
            pass        # no menu to touch until the AI has chosen
        elif prompt == 1:
            if view != last_view:
                say(f"[{core.frames}]   " + "\n          ".join(view[:-1]))
                last_view = view
            at = markers.address("gDiagBattlers") - 0x02000000
            you = struct.unpack_from(BATTLER, ram, at)
            foe = struct.unpack_from(BATTLER, ram, at + struct.calcsize(BATTLER))
            if foe_before is not None:
                hit, foe_before = max(hit, foe_before - foe[1]), None
            wanted = bool(catch and wild_battle and foe[1] and thrown < catch(foe[0]))
            hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
            relieving = (shift is not None and wild_battle and you[4] != shift and hp[shift] and you[1]
                         and commands == 1 and not wanted)
            damaging = [i for i in range(4) if you[7 + i] and you[11 + i] and scorer.score(you[7 + i], you[0], foe[0]) > 0.1]
            if relieving:
                say(f"[{core.frames}] party slot {shift} relieves slot {you[4]}")
                relieve(core, markers, hold, shift)
                shift = None
            elif runs(view, wild, flee):
                core.touch(*RUN, 6, hold)
            elif wanted and throws_now(foe[1], foe[2], hit, damaging):
                say(f"[{core.frames}] ball {thrown + 1} of {catch(foe[0])} thrown")
                if throw(core, markers, hold):
                    thrown += 1
                else:
                    catch = None    # the bag never opened or never closed: fight on
                    say(f"[{core.frames}] the bag did not take the throw")
            else:
                weakening = wanted
                foe_before = foe[1] if wanted else None
                core.touch(*FIGHT, 6, hold)
            core.step(20, hold)
        elif prompt in (3, 4):
            moves = view[0].split("|")[1].split(",")
            usable = [i for i, part in enumerate(moves) if not part.strip().endswith(" 0") and i not in refused]
            slot = move - 1 if 1 <= move <= 4 and move - 1 not in refused else (usable or [0])[0]
            if move < 0 and usable:
                you = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000)
                foe = aimed_at(ram, markers, 0)
                usable = [i for i in usable if (foe[0], you[7 + i]) not in useless] or usable
                slot = max(usable, key=lambda i: scorer.score(you[7 + i], you[0], foe[0]))
                gentle = [i for i in usable if scorer.score(you[7 + i], you[0], foe[0]) > 0.1]
                if weakening and gentle:
                    slot = min(gentle, key=lambda i: scorer.score(you[7 + i], you[0], foe[0]))
            last_slot = slot
            moves_chosen[0] = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000)[7 + slot]
            tries = 0       # each one's target screen starts from its own foe
            core.touch(*MOVES[slot], 6, hold)
            core.step(20, hold)
        elif revive is not None and core.frames - revive > 90:
            species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)
            hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
            fainted = [i for i in range(6) if species[i] and not hp[i]]
            if fainted:
                core.touch(*PARTY[place(ram, markers, fainted[0])], 6, hold)
                core.step(30, hold)
                core.touch(*SHIFT, 6, hold)
                core.step(60, hold)
            revive = core.frames    # again later if the menu was not up yet
        elif prompt in (5, 6) or (partner and prompt not in (1, 2, 3, 4) and partner() in (5, 6)):
            battler = 0 if prompt in (5, 6) else 2
            core.touch(*scorer.panel(moves_chosen.get(battler, 0), battler, tries), 6, hold)
            core.step(20, hold)
            tries += 1
        elif partner and prompt not in (1, 2, 3, 4) and partner() == 1:
            core.touch(*FIGHT, 6, hold)
            core.step(20, hold)
        elif partner and prompt not in (1, 2, 3, 4) and partner() in (3, 4):
            second = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000
                                        + 2 * struct.calcsize(BATTLER))
            usable = [i for i in range(4) if second[7 + i] and second[11 + i]]
            slot = move - 1 if 1 <= move <= 4 else (usable or [0])[0]
            if move < 0 and usable:
                foe = aimed_at(ram, markers, 2)
                slot = max(usable, key=lambda i: scorer.score(second[7 + i], second[0], foe[0]))
            moves_chosen[2] = second[7 + slot]
            tries = 0
            core.touch(*MOVES[slot], 6, hold)
            core.step(20, hold)
        elif use_next is not None:
            # A wild battle's lead has fainted with others left: the upper
            # button goes on with the next Pokemon; the lower one flees, and
            # the SHIFT touch of the branch below lands on it. The buttons
            # come up a while after the question is printed (sooner or later
            # with the save's text speed), and a touch there on the party
            # screen after them lands on nothing: touch it for five seconds,
            # then leave the party screen to the branch below.
            core.touch(*USE_NEXT, 6, hold)
            core.step(30, hold)
            if core.frames - use_next > 300:
                use_next = None
        elif state == BATTLE_MAIN and (you_hp == 0 or second_down(ram, markers)) and reserve(ram, markers) is not None:
            stuck += 1
            if stuck > 60:
                # The party screen after a faint, for the first of the
                # player's two or, in a double battle, the second -- also
                # at the end of a turn where a Revive or a Revival Blessing
                # gave an empty place someone to send. With no one to send
                # the place stays empty, and B below moves the text on.
                core.touch(*PARTY[place(ram, markers, reserve(ram, markers))], 6, hold)
                core.step(30, hold)
                core.touch(*SHIFT, 6, hold)
                core.step(60, hold)
                stuck = 0
        elif (any(line in last_line for line in PIVOT_LINES) and not last_line.startswith(("The opposing", "The wild"))
              and reserve(ram, markers) is not None):
            # Parting Shot, U-turn, Baton Pass, Shed Tail, an Eject Button or
            # an Eject Pack has sent the player's Pokemon back, and the party
            # screen asks who comes in: the first that can, once the screen
            # is up. Until a "Go!" line the touches land on nothing.
            core.touch(*PARTY[place(ram, markers, reserve(ram, markers))], 6, hold)
            core.step(30, hold)
            core.touch(*SHIFT, 6, hold)
            core.step(60, hold)
        elif "forget another move" in last_line:
            # A move learnt by level with four already known: "Forget a
            # move!", once the buttons are up; the menu that opens decides.
            core.touch(*FORGET_A_MOVE, 6, hold)
            core.step(30, hold)
        elif "should be forgotten" in last_line:
            # The menu's moves: the one forgets() lets go touched, then its
            # page's FORGET; the new one given up by the back arrow.
            menu = learn_menu(ram, markers)
            if menu and menu[0] == LEARN_LIST:
                _, slot, known, new = menu
                species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)[slot]
                gone = forgets(scorer, species, known + [new])
                if (slot, new) != learning:
                    say(f"[{core.frames}] the rule lets go of {'the new move' if gone == 4 else f'move {gone + 1}'}")
                    learning = (slot, new)
                core.touch(*(LEARN_BACK if gone == 4 else LEARN_MOVES[gone]), 6, hold)
            elif menu and menu[0] == LEARN_PAGE:
                core.touch(*LEARN_FORGET, 6, hold)
            core.step(30, hold)
        elif "give up on learning" in last_line:
            # The new move given up (the back arrow above): the top button,
            # once the question has finished printing and the buttons are
            # up. B here would say no to giving it up, and the whole thing
            # would be asked again for ever.
            core.touch(*GIVE_UP, 6, hold)
            core.step(30, hold)
        elif "Will you switch" in last_line:
            core.touch(*KEEP_BATTLING, 6, hold)
            core.step(30, hold)
            last_line = ""
        else:
            stuck = 0
            idle += 1
            if idle % 8 == 0:
                # A through an evolution and a caught Pokemon's Dex entry,
                # which B would stop or never close; B declines its nickname.
                core.press("A" if state in EVOLVING or "added to the Pok" in last_line else "B", 4, hold)

    return last_line


def main():
    pin_clock()
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--move", type=int, default=-1,
                        help="the move slot to use, 1 to 4; 0 for the first with PP; left out, the hardest-hitting")
    parser.add_argument("--frames", type=int, default=40000)
    args = parser.parse_args()

    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    markers = Markers(DIAG_ELF)
    scorer = Scorer()
    core = Core(ROM, save=args.save)
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]
    read = lambda name: markers.read(core.ram(), name)  # noqa: E731

    # Title, Continue, and the leader's lines: A until the battle is up.
    while core.frames < 6000 and read("gDiagBattleState") != BATTLE_MAIN:
        core.press("A", 6, hold)
        core.step(30, hold)
    say(f"[{core.frames}] the battle is up")
    before = None

    last_line = fight(core, markers, hold, say, args.move, args.frames, scorer)

    ram = core.ram()
    say(f"[{core.frames}] trainer items {markers.read(ram, 'gDiagAiItemCount')}")
    # After a win the gym's script hands over the badge: the leader's lines,
    # the badge, the TM. A until the field is back and the count stops moving.
    if markers.read(ram, "gDiagBattleState") == EXIT:
        try:
            held = badges(ram, DIAG_ELF)
        except SystemExit:
            held = None
        for _ in range(60):
            core.press("A", 6, hold)
            core.step(60, hold)
            try:
                now = badges(core.ram(), DIAG_ELF)
            except SystemExit:
                continue
            if held is None:
                held = now
            elif now != held:
                say(f"[{core.frames}] badges {held} -> {now}")
                held = now
        say(f"[{core.frames}] badges held: {held}")
        ram = core.ram()
    say("at the end: " + markers.describe(ram))
    if markers.read(ram, "gDiagBattleState") != EXIT:
        say("the battle did not finish; last prompt " + str(markers.read(ram, "gDiagBattlePrompt"))
            + ", last line: " + repr(last_line[:80]))
    try:
        say("party at the end:\n  " + "\n  ".join(party(ram, DIAG_ELF, sealed_mons(core, DIAG_ELF, hold))))
    except SystemExit as field_down:
        say(f"party: {field_down}")
    core.close()


if __name__ == "__main__":
    main()
