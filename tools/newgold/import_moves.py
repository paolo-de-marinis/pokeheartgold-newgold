#!/usr/bin/env python3
"""Bring the reference's moves into this game, with the scripts they need.

This used to take a list of fourteen moves, and for the two bytes
pokeheartgold has never named -- the flag byte and the contest pair -- it
copied them from a model move chosen by hand. That does not scale to four
hundred, and it was also wrong: a model is a guess.

So the two bytes are derived instead. The reference names its flags, and four
hundred and sixty-one moves exist on both sides, which is enough to solve for
which bit is which: a bit that is set exactly when the reference names a given
flag is that flag. Seven of the eight pin down that way.

    bit 0  FLAG_CONTACT        bit 4  FLAG_MIRROR_MOVE
    bit 1  FLAG_PROTECT        bit 5  (see below)
    bit 2  FLAG_MAGIC_COAT     bit 6  FLAG_KEEP_HP_BAR
    bit 3  FLAG_SNATCH         bit 7  FLAG_HIDE_SHADOW

Bit 5 has no name in the reference. It is set on two hundred and eight moves,
every one of them damaging, and on no status move at all -- it is the King's
Rock flag, which the reference handles elsewhere. It is taken from the moves
this game already has with the same effect, which agrees with the existing
table on 93.7% of them, and left clear for a status move, which is right on
all of them.

The contest pair is named on both sides. The type maps exactly --
CONTEST_COOL is 0, BEAUTY 1, CUTE 2, SMART 3, TOUGH 4, right on all four
hundred and sixty-one -- and the appeal map is learnt from the vanilla moves
each run rather than written down, so it cannot go stale.

WHAT A MOVE'S EFFECT IS

A move names its effect, and the two sides do not agree on the names: the
reference calls effect 202 BADLY_POISON_HIT where this game calls it
FLINCH_POISON_HIT, and worse, it calls 62 SP_DEF_DOWN_2 where this game calls
62 ACC_DOWN_2 and puts SP_DEF_DOWN_2 at 64. Matching by name would quietly
give a move the wrong effect. What both sides do share is the scripts: effect
script 202 is the same file in both trees, because both were dumped from the
same ROM. So up to 276, the last effect retail had, an effect is matched by
its NUMBER and the names are ignored.

Past 276 the two sides diverge for real -- this game numbered the ten effects
it added from 277, the reference numbered its own hundred and thirty from the
same place -- so there a name match finds the ten already here and everything
else is new. A new effect brings its script with it, and the subscripts that
script reaches, and the names of everything they mention that this game has
not got: the scripts are data in a command language both trees share, so they
are copied rather than rewritten.

Some of those scripts reach for things this game has no C for yet: terrains,
the Drives, the Memories. The script assembles, the move exists, and the part
that does nothing is listed by tests/newgold/test_move_effects.py rather than
left to be discovered in play.

Usage: import_moves.py REFERENCE_CHECKOUT [--write]
"""
import argparse
import collections
import re
import shutil
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TABLE = ROOT / "files/poketool/waza/waza_tbl.narc"
NAMES = ROOT / "files/msgdata/msg/msg_0750.gmm"
CAPS = ROOT / "files/msgdata/msg/msg_0751.gmm"
DESCRIPTIONS = ROOT / "files/msgdata/msg/msg_0749.gmm"
EFFECT_SCRIPTS = ROOT / "files/battledata/script/effect_script"
MOVE_SCRIPTS = ROOT / "files/battledata/script/move_script"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"
MOVE_EFFECTS_H = ROOT / "include/constants/move_effects.h"
MOVES_H = ROOT / "include/constants/moves.h"
IMPORTS_H = ROOT / "include/constants/battle_script_imports.h"
COMMANDS = ROOT / "src/battle/battle_command.c"

HANDPICKED_ANIMATIONS = 28

RECORD = "<HBBBBBBHbBBBH"
RECORD_SIZE = 16

# The last effect retail had. Up to here the two trees hold the same script at
# the same index, whatever either calls it.
LAST_VANILLA_EFFECT = 276

# The same for the subscripts, and for the table of side effects that points
# into them. Past these two this repository had numbered its own additions
# from the same place the reference numbered its own, so a number there means
# different things in the two trees and only a name match carries over.
LAST_VANILLA_SUBSCRIPT = 296
LAST_VANILLA_POINTER = 144

SPLITS = {"SPLIT_PHYSICAL": 0, "SPLIT_SPECIAL": 1, "SPLIT_STATUS": 2}

# The bits solved for against the moves both sides have. Bit 5 is not here:
# the reference does not name it.
FLAG_BITS = {
    "FLAG_CONTACT": 0,
    "FLAG_PROTECT": 1,
    "FLAG_MAGIC_COAT": 2,
    "FLAG_SNATCH": 3,
    "FLAG_MIRROR_MOVE": 4,
    "FLAG_KEEP_HP_BAR": 6,
    "FLAG_HIDE_SHADOW": 7,
}
KINGS_ROCK_BIT = 5
CONTEST_TYPES = {"CONTEST_COOL": 0, "CONTEST_BEAUTY": 1, "CONTEST_CUTE": 2,
                 "CONTEST_SMART": 3, "CONTEST_TOUGH": 4}

# The same thing under two spellings. Everything else an imported script names
# and this game has not got is written out as a constant; these would be
# written twice instead, once under each name.
SPELLINGS = {
    "MOVEATTRIBUTE_TYPE": "MOVE_ATTRIBUTE_TYPE",
    "BATTLER_CATEGORY_MSG_BATTLER_TEMP": "BATTLER_CATEGORY_MSG_TEMP",
}

# Some of the reference's fields are written as a choice between two values,
# and which way it goes is a setting in its own configuration -- so the
# configuration is read rather than guessed at. Filled by read_conditions().
CONDITIONS = {}


def read_conditions(reference):
    for name, value in re.findall(r"#define (CHAMPIONS_[A-Z_]+)\s+(\d+)",
                                  (reference / "include/config.h").read_text()):
        CONDITIONS[name] = bool(int(value))


def resolve(text):
    """`((SETTING) ? (a) : (b))` is whichever of the two the setting picks."""
    choice = re.fullmatch(r"\(\((\w+)\)\s*\?\s*\(([^()]+)\)\s*:\s*\(([^()]+)\)\)", text)
    if not choice:
        return text
    if choice.group(1) not in CONDITIONS:
        raise SystemExit(f"{choice.group(1)} is not a setting the reference's config.h names")
    return choice.group(2 if CONDITIONS[choice.group(1)] else 3).strip()


# What a previous run appended, so that a run reads what was here before it
# and adding a move twice is the same as adding it once.
GENERATED = (r"\n// The rest of the reference's moves.*?(?=\n// NUM_MOVES sizes)",
             r"\n// The effects the reference brings with it.*?(?=\n#endif)",
             r"\n// The subscripts the reference brings with it.*?(?=\n#endif)")


def original(path):
    text = (ROOT / path).read_text()
    for pattern in GENERATED:
        text = re.sub(pattern, "", text, flags=re.S)
    return text


def constants(path, prefix):
    """Plain numbers and the (1 << n) the bit-set constants are written as."""
    text = original(path)
    out = {}
    for match in re.finditer(r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\(1 << (\d+)\)|\d+)\s*$", text, re.M):
        out[match[1]] = 1 << int(match[3]) if match[3] else int(match[2])
    return out


def header_defines(root):
    """Every plain constant a tree's headers define, by name."""
    out = {}
    for path in sorted((root / "include").rglob("*.h")):
        for match in re.finditer(r"^\s*#define\s+([A-Z][A-Z0-9_]*)\s+(.+?)\s*$",
                                 path.read_text(errors="replace"), re.M):
            out.setdefault(match.group(1), match.group(2))
    return out


def as_number(text):
    match = re.fullmatch(r"\(?\s*(0x[0-9A-Fa-f]+|\d+)\s*\)?", text or "")
    return int(match.group(1), 0) if match else None


def reference_records(reference):
    """Every move block the reference declares, by name."""
    source = (reference / "data/Moves.c").read_text(errors="replace")
    out = {}
    for match in re.finditer(r"\[MOVE_([A-Z0-9_]+)\]\s*=\s*\{", source):
        start = source.index("{", match.start())
        depth, end = 0, start
        while True:
            depth += (source[end] == "{") - (source[end] == "}")
            end += 1
            if depth == 0:
                break
        out[match.group(1)] = source[start:end]
    return out


def named_flags(block):
    match = re.search(r"\.flags\s*=\s*(.+?)\n", block, re.S)
    return set(re.findall(r"FLAG_[A-Z0-9_]+", match.group(1))) if match else set()


def contest_field(block, key):
    section = re.search(r"\.contest\s*=\s*\{(.*?)\}", block, re.S)
    if not section:
        return None
    match = re.search(r"\." + key + r"\s*=\s*([A-Z0-9_]+)", section.group(1))
    return match.group(1) if match else None


def learn_appeal(blocks, moves, table, last_vanilla):
    """What byte each of the reference's appeals is, read off the moves here.

    Learnt rather than written down so it cannot go stale, and only from the
    vanilla records, which are the ones this repository has not touched.
    """
    seen = collections.defaultdict(collections.Counter)
    for name, number in moves.items():
        if not 0 < number <= last_vanilla or name not in blocks:
            continue
        appeal = contest_field(blocks[name], "appeal")
        if appeal:
            seen[appeal][struct.unpack(RECORD, table[number])[10]] += 1
    return {appeal: counts.most_common(1)[0][0] for appeal, counts in seen.items()}


def learn_kings_rock(blocks, moves, table, last_vanilla):
    """Whether a move with a given effect carries bit 5, from the moves here."""
    seen = collections.defaultdict(collections.Counter)
    for name, number in moves.items():
        if not 0 < number <= last_vanilla:
            continue
        fields = struct.unpack(RECORD, table[number])
        seen[fields[0]][fields[9] >> KINGS_ROCK_BIT & 1] += 1
    return {effect: counts.most_common(1)[0][0] for effect, counts in seen.items()}


def field(block, key):
    match = re.search(r"\." + key + r"\s*=\s*([^,\n]+)", block)
    return resolve(match.group(1).strip()) if match else None


def ranges(block, known):
    """RANGE_ constants are a bit set; the reference names one or more."""
    text = field(block, "target") or "RANGE_SINGLE_TARGET"
    value = 0
    for name in re.findall(r"RANGE_[A-Z_]+", text):
        if name not in known:
            raise SystemExit(f"this game has no {name}")
        value |= known[name]
    return value


def number(block, key):
    numbers = re.findall(r"\d+", field(block, key) or "0")
    return int(numbers[-1]) if numbers else 0


def read_table():
    data = TABLE.read_bytes()
    count = struct.unpack("<H", data[0x18:0x1A])[0]
    fatb = 0x1C
    offsets = [struct.unpack("<II", data[fatb + 8 * i:fatb + 8 * i + 8]) for i in range(count)]
    gmif = data.index(b"GMIF") + 8
    return [data[gmif + start:gmif + end] for start, end in offsets]


def write_table(records):
    """Rebuild the archive: one member per record, all the same size."""
    fatb = b"BTAF" + struct.pack("<IHH", 12 + 8 * len(records), len(records), 0)
    fatb += b"".join(struct.pack("<II", i * RECORD_SIZE, (i + 1) * RECORD_SIZE)
                     for i in range(len(records)))
    fnbt = b"BTNF" + struct.pack("<IIHH", 16, 4, 0, 1)
    data = b"".join(records)
    gmif = b"GMIF" + struct.pack("<I", 8 + len(data)) + data
    size = 16 + len(fatb) + len(fnbt) + len(gmif)
    header = b"NARC" + struct.pack("<HHIHH", 0xFFFE, 0x0100, size, 16, 3)
    return header + fatb + fnbt + gmif


def append_rows(path, prefix, texts, start, write):
    """Rewrite every row from `start` on, so running this twice is the same as
    running it once."""
    text = path.read_text()
    text = re.sub(r'\t<row id="[^"]+" index="(\d+)">.*?\t</row>\n',
                  lambda m: "" if int(m.group(1)) >= start else m.group(0), text, flags=re.S)
    # The caps bank names its rows after the text. Two moves can share that
    # text -- a Z-move has a physical and a special half under one name -- and
    # the row id becomes a macro, so a repeat takes its index as well.
    taken = set(re.findall(r'<row id="([^"]+)"', text))
    block = ""
    for offset, value in enumerate(texts):
        index = start + offset
        # A row id becomes a macro name, so it has to be one: Trick-or-Treat
        # written straight out is `trick` followed by `-or-treat`, which the
        # preprocessor reads as a redefinition of Trick.
        name = (f"{prefix}_" + re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_")
                if prefix == "msg_0751" else f"{prefix}_{index:05d}")
        if name in taken:
            name = f"{name}_{index:05d}"
        taken.add(name)
        block += (f'\t<row id="{name}" index="{index}">\n'
                  f'\t\t<attribute name="window_context_name">used</attribute>\n'
                  f'\t\t<language name="English">{value}</language>\n'
                  f'\t</row>\n')
    if write:
        path.write_text(text.replace("</body>", block + "</body>", 1))
    return len(texts)


def animation_for(block, moves, table, last_vanilla, types):
    """An existing move to borrow the animation from.

    The added moves are past the end of the animation archive, so each one
    plays another move's. The nearest match is one of the same type and the
    same split, and among those the closest in power -- a Fairy special of
    ninety takes the animation of whatever this game already has that looks
    most like it.
    """
    want_type = types.get(field(block, "type"))
    want_split = SPLITS.get(field(block, "split"))
    want_power = number(block, "power")
    best, best_cost = None, None
    for name, n in moves.items():
        if not 0 < n <= last_vanilla:
            continue
        fields = struct.unpack(RECORD, table[n])
        if fields[3] != want_type or fields[1] != want_split:
            continue
        cost = abs(fields[2] - want_power)
        if best_cost is None or cost < best_cost:
            best, best_cost = name, cost
    if best is not None:
        return best
    for name, n in sorted(moves.items(), key=lambda item: item[1]):
        if 0 < n <= last_vanilla and struct.unpack(RECORD, table[n])[1] == want_split:
            return name
    return "TACKLE"


def scripts_by_number(directory, pattern):
    out = {}
    for path in directory.glob("*.s"):
        match = re.match(pattern, path.name)
        if match:
            out[int(match.group(1))] = path
    return out


# Four commands take an argument their own implementation reads and throws
# away: the battler is not a parameter, it is always the target. The
# reference's scripts leave it out, and a zero is the nothing it already was.
IGNORED_ARGUMENT = {"HandleMagicPowder", "HandleTrickOrTreat",
                    "HandleForestsCurse", "HandleSoak"}

# The command macros, both trees'. Filled by read_macros().
OUR_MACROS, THEIR_MACROS, CONDITIONAL = {}, {}, set()


def read_macros(reference):
    for macros, path in ((OUR_MACROS, ROOT / "asm/macros/btlcmd.inc"),
                         (THEIR_MACROS, reference / "asm/include/battle_commands.inc")):
        for match in re.finditer(r"^\s*\.macro\s+(\w+)([^\n]*)",
                                 path.read_text(errors="replace"), re.M):
            arguments = []
            for argument in match.group(2).split(","):
                name, _, default = argument.strip().partition("=")
                name = name.replace(":req", "").strip()
                if name:
                    arguments.append((name, default.strip() or None))
            macros[match.group(1)] = arguments
    # A command whose later arguments sit inside a .if may be written with
    # fewer of them; one whose do not may not.
    for match in re.finditer(r"^\s*\.macro\s+(\w+)[^\n]*\n(.*?)^\s*\.endm",
                             (ROOT / "asm/macros/btlcmd.inc").read_text(), re.M | re.S):
        if ".if" in match.group(2):
            CONDITIONAL.add(match.group(1))


def native(text):
    """A copied script, in this tree's spelling.

    One command, AbilityPopup, takes a second argument the reference gives a
    default for and this tree's macro file does not. Writing the default out
    is better than giving that file -- which is a decompilation, and matches --
    a default of its own.
    """
    text = re.sub(r"^#include .*\n\.include \"battle_commands.inc\"\n",
                  "    .include \"macros/btlcmd.inc\"\n", text, count=1)
    text = re.sub(r"^\.data$", "    .data", text, count=1, flags=re.M)
    for theirs, ours in SPELLINGS.items():
        text = re.sub(rf"\b{theirs}\b", ours, text)
    lines = []
    for line in text.splitlines():
        body, comment, rest = line.partition("//")
        match = re.match(r"(\s+)(\w+)\s*(.*)$", body.rstrip())
        if match and match.group(2) in OUR_MACROS:
            name = match.group(2)
            arguments = [argument.strip() for argument in match.group(3).split(",") if argument.strip()]
            wanted, theirs = OUR_MACROS[name], THEIR_MACROS.get(name, [])
            while len(arguments) < len(wanted) and len(arguments) < len(theirs) \
                    and theirs[len(arguments)][1] is not None:
                arguments.append(theirs[len(arguments)][1])
            if len(arguments) < len(wanted) and name not in CONDITIONAL:
                if name not in IGNORED_ARGUMENT:
                    raise SystemExit(f"{name} takes {len(wanted)} arguments here, the "
                                     f"reference's script gives {len(arguments)}, and this "
                                     f"does not know what the rest should be")
                arguments += ["0"] * (len(wanted) - len(arguments))
            if arguments:
                body = f"{match.group(1)}{name} " + ", ".join(arguments)
        lines.append(body + comment + rest)
    return "\n".join(lines) + "\n"


def numbered(text, prefix):
    return {prefix + name: int(value) for name, value in
            re.findall(r"#define " + prefix + r"([A-Z0-9_]+)\s+\(?(\d+)\)?", text)}


def camel(name):
    return "".join(word.capitalize() for word in name.split("_"))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    reference = args.reference

    read_conditions(reference)
    read_macros(reference)
    blocks = reference_records(reference)
    moves = constants("include/constants/moves.h", "MOVE_")
    rangesets = constants("include/constants/moves.h", "RANGE_")
    types = constants("include/constants/pokemon.h", "TYPE_")
    ours_effects = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
    their_defines = header_defines(reference)
    # move_effects.h is where they live, bar one the reference declares beside
    # the move table itself. MOVE_EFFECT_FLAG_ is a different family entirely.
    their_effects = {}
    for path in ["include/constants/move_effects.h", "include/move_data.h"]:
        for name, value in re.findall(r"#define MOVE_EFFECT_([A-Z0-9_]+)\s+(\d+)\s*$",
                                      (reference / path).read_text(errors="replace"), re.M):
            if not name.startswith("FLAG_"):
                their_effects.setdefault(f"MOVE_EFFECT_{name}", int(value))
    table = read_table()

    header = original("include/constants/moves.h")
    last_vanilla = moves["MOVE_" + re.search(r"#define NUM_MOVES\s+MOVE_([A-Z0-9_]+)",
                                             header).group(1)]
    plain = {name[len("MOVE_"):]: value for name, value in moves.items()}
    appeals = learn_appeal(blocks, plain, table, last_vanilla)
    kings_rock = learn_kings_rock(blocks, plain, table, last_vanilla)

    # An effect keeps its number up to where retail stopped, because up to
    # there both trees hold the same script at that index. Past it, a name the
    # ten effects this game added answers to is that one, and the rest are new.
    first_effect = max(ours_effects.values()) + 1
    effect_id, new_effects = {}, []
    for name, theirs in sorted(their_effects.items(), key=lambda item: item[1]):
        if theirs <= LAST_VANILLA_EFFECT:
            effect_id[name] = theirs
        elif name in ours_effects:
            effect_id[name] = ours_effects[name]
        else:
            effect_id[name] = first_effect + len(new_effects)
            new_effects.append((effect_id[name], theirs, name))

    # Subscripts line up the way the effects do, and so does the table of
    # side effects that points into them: the two trees agree up to where
    # retail stopped, and past it each numbered its own from the same place.
    subscript_h = original("include/constants/battle_subscript.h")
    ours_subs = numbered(subscript_h, "BATTLE_SUBSCRIPT_")
    ours_pointers = numbered(subscript_h, "MOVE_SUBSCRIPT_PTR_")
    their_header = "".join(path.read_text(errors="replace")
                           for path in sorted((reference / "include").rglob("*.h")))
    their_subs = numbered(their_header, "BATTLE_SUBSCRIPT_")
    their_pointers = numbered(their_header, "MOVE_SUBSCRIPT_PTR_")
    their_targets = {"MOVE_SUBSCRIPT_PTR_" + pointer: "BATTLE_SUBSCRIPT_" + target
                     for pointer, target in re.findall(
                         r"\[MOVE_SUBSCRIPT_PTR_([A-Z0-9_]+)\]\s*=\s*BATTLE_SUBSCRIPT_([A-Z0-9_]+)",
                         (reference / "src/moves.c").read_text(errors="replace"))}

    their_effect_scripts = scripts_by_number(reference / "data/battle_scripts/effects",
                                             r"effect_script_(\d+)_")
    their_subscript_files = scripts_by_number(reference / "data/battle_scripts/subscripts",
                                              r"subscript_(\d+)_")

    resolved = {}        # the reference's name -> the number this game gives it
    new_subscripts = []  # (mine, theirs, name)
    new_pointers = []    # (mine, name, the subscript it points at)
    pending = []

    def subscript_for(name):
        if name not in resolved:
            if name not in their_subs:
                raise SystemExit(f"an imported script names {name}, which the reference has not got")
            theirs = their_subs[name]
            if theirs <= LAST_VANILLA_SUBSCRIPT:
                resolved[name] = theirs
            elif name in ours_subs:
                resolved[name] = ours_subs[name]
            else:
                resolved[name] = max(ours_subs.values()) + 1 + len(new_subscripts)
                new_subscripts.append((resolved[name], theirs, name))
                pending.append(native(their_subscript_files[theirs].read_text(errors="replace")))
        return resolved[name]

    def pointer_for(name):
        if name not in resolved:
            if name not in their_pointers:
                raise SystemExit(f"an imported script names {name}, which the reference has not got")
            theirs = their_pointers[name]
            if theirs <= LAST_VANILLA_POINTER:
                resolved[name] = theirs
            elif name in ours_pointers:
                resolved[name] = ours_pointers[name]
            else:
                resolved[name] = max(ours_pointers.values()) + 1 + len(new_pointers)
                new_pointers.append((resolved[name], name, their_targets[name]))
                subscript_for(their_targets[name])
        return resolved[name]

    copied = {mine: native(their_effect_scripts[theirs].read_text(errors="replace"))
              for mine, theirs, _ in new_effects}
    imported = dict(copied)
    pending.extend(copied.values())
    while pending:
        text = pending.pop()
        for token in re.findall(r"\bBATTLE_SUBSCRIPT_[A-Z0-9_]+", text):
            subscript_for(token)
        for token in re.findall(r"\bMOVE_SUBSCRIPT_PTR_[A-Z0-9_]+", text):
            pointer_for(token)
    for mine, theirs, _ in new_subscripts:
        imported[f"s{mine}"] = native(their_subscript_files[theirs].read_text(errors="replace"))

    # Everything those scripts name that no header here defines.
    ours_names = set()
    for path in sorted((ROOT / "include").rglob("*.h")):
        if path == IMPORTS_H:
            continue  # written by this, so not something that was already here
        text = original(path.relative_to(ROOT))
        ours_names |= set(re.findall(r"#define\s+([A-Z][A-Z0-9_]*)", text))
        ours_names |= set(re.findall(r"^\s*([A-Z][A-Z0-9_]{2,})\s*(?:=|,)", text, re.M))
    ours_names |= set(re.findall(r"^\s*\.macro\s+(\w+)", (ROOT / "asm/macros/btlcmd.inc").read_text(), re.M))
    ours_names |= {"TRUE", "FALSE"}
    # The names this run is about to define are not missing, they are pending.
    ours_names |= {name for _, _, name in new_effects}

    # The new moves, in the reference's own order.
    their_moves = {name: as_number(value) for name, value in their_defines.items()
                   if name.startswith("MOVE_") and name[len("MOVE_"):] in blocks}
    # A move the reference numbers inside retail's range is a retail move, and
    # this game has it already -- under its own spelling, which for six of them
    # is not the reference's. Those get the reference's name as well, so that
    # data written against the reference compiles here unchanged.
    order = sorted((value, name[len("MOVE_"):]) for name, value in their_moves.items()
                   if value is not None and value > last_vanilla
                   and name[len("MOVE_"):] not in plain)
    aliases = sorted((value, name[len("MOVE_"):]) for name, value in their_moves.items()
                     if value is not None and 0 < value <= last_vanilla
                     and name[len("MOVE_"):] not in plain)
    first_move = max(plain.values()) + 1

    added, names, caps, descriptions, borrowed = [], [], [], [], []
    for offset, (_, name) in enumerate(order):
        block = blocks[name]
        effect = field(block, "effect")
        if effect not in effect_id:
            raise SystemExit(f"{name} has effect {effect}, which the reference does not define")
        split = SPLITS[field(block, "split")]
        flags = sum(1 << bit for flag, bit in FLAG_BITS.items() if flag in named_flags(block))
        if split != SPLITS["SPLIT_STATUS"] and kings_rock.get(effect_id[effect], 1):
            flags |= 1 << KINGS_ROCK_BIT
        added.append((first_move + offset, name, struct.pack(
            RECORD,
            effect_id[effect],
            split,
            number(block, "power"),
            types[field(block, "type")],
            number(block, "accuracy"),
            number(block, "pp"),
            number(block, "effectChance"),
            ranges(block, rangesets),
            number(block, "priority"),
            flags,
            appeals.get(contest_field(block, "appeal"), 0),
            CONTEST_TYPES.get(contest_field(block, "contestType"), 0),
            0)))
        borrowed.append((name, animation_for(block, plain, table, last_vanilla, types)))
        names.append(re.search(r'\.name = "([^"]*)"', block).group(1))
        caps.append(re.search(r'\.capsName = "([^"]*)"', block).group(1))
        text = re.search(r'\.description = "((?:[^"\\\\]|\\\\.)*)"', block).group(1)
        # The reference's text goes through a C compiler first, so it doubles
        # every backslash; the message banks here take them single.
        text = re.sub(r"\\\\(.)", r"\\\1", text)
        descriptions.append(text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;"))

    # The moves this run is about to number are not missing either.
    ours_names |= {"MOVE_" + name for _, name in order}

    # What the copied scripts mention and this game has not got a name for.
    # The subscripts and the side-effect slots have a home already; the rest --
    # the terrains, the Drives, the Memories -- get one written for them.
    naming = {name: number_ for name, number_ in resolved.items() if name not in ours_names}
    unknown = {}
    for text in imported.values():
        for token in re.findall(r"\b[A-Z][A-Z0-9_]{3,}\b", re.sub(r"//.*", "", text)):
            if token in ours_names or token in unknown or token in resolved:
                continue
            value = as_number(their_defines.get(token))
            if value is None:
                raise SystemExit(f"an imported script names {token}, which nothing defines")
            unknown[token] = value

    print(f"{len(added)} moves to add, identifiers {first_move} to {first_move + len(added) - 1}")
    print(f"{len(new_effects)} effects to add, identifiers "
          f"{first_effect} to {first_effect + len(new_effects) - 1}")
    print(f"{len(new_subscripts)} subscripts to add, identifiers "
          + (f"{new_subscripts[0][0]} to {new_subscripts[-1][0]}" if new_subscripts else "none"))
    print(f"{len(new_pointers)} side-effect slots to add, identifiers "
          + (f"{new_pointers[0][0]} to {new_pointers[-1][0]}" if new_pointers else "none"))
    print(f"{len(aliases)} retail moves the reference spells differently: "
          + ", ".join(name for _, name in aliases))
    print(f"{len(unknown)} constants to write out for them")
    if not args.write:
        print("nothing written; pass --write")
        return

    # The scripts. An effect script is named by the effect it is, a subscript
    # keeps the number it has in the reference, because nothing renumbers.
    for mine, _, _ in new_effects:
        (EFFECT_SCRIPTS / f"effect_script_{mine:04d}.s").write_text(copied[mine])
    for mine, theirs, name in new_subscripts:
        spelling = re.match(r"subscript_\d+_(.+)\.s", their_subscript_files[theirs].name).group(1)
        (SUBSCRIPTS / f"subscript_{mine:04d}_{camel(spelling)}.s").write_text(imported[f"s{mine}"])
    for identifier, _, _ in added:
        (MOVE_SCRIPTS / f"move_script_{identifier:04d}.s").write_text(
            "    .include \"macros/btlcmd.inc\"\n\n    .data\n\n_000:\n    GoToEffectScript \n")

    IMPORTS_H.write_text(
        "#ifndef POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H\n"
        "#define POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H\n"
        "\n"
        "// What the imported battle scripts name and this game has not got:\n"
        "// the terrains, the Drives, the Memories, the weather the reference\n"
        "// added. A script that mentions one of these assembles and runs; the\n"
        "// branch it guards is never taken, because nothing here sets it. The\n"
        "// list is what tests/newgold/test_move_effects.py counts down.\n"
        "\n"
        + "".join(f"#define {name:<46} {value}\n"
                 for name, value in sorted(unknown.items(), key=lambda item: (item[1], item[0])))
        + "\n#endif // POKEHEARTGOLD_CONSTANTS_BATTLE_SCRIPT_IMPORTS_H\n")
    include = (ROOT / "asm/macros/btlcmd.inc").read_text()
    if "battle_script_imports.h" not in include:
        (ROOT / "asm/macros/btlcmd.inc").write_text(include.replace(
            '#include "constants/battle_subscript.h"',
            '#include "constants/battle_subscript.h"\n#include "constants/battle_script_imports.h"', 1))

    # The subscripts the imported scripts reach, and the side-effect slots
    # that point at them, beside the ones this game already had.
    subscript_text = subscript_h
    block = ("\n// The subscripts the reference brings with it, and its names for the\n"
             "// ones this game already had. A number here is this game's, not the\n"
             "// reference's: the two agree up to "
             f"{LAST_VANILLA_SUBSCRIPT} and each numbered its own after that.\n\n"
             + "".join(f"#define {name:<51} {number_}\n"
                      for name, number_ in sorted(naming.items(), key=lambda item: item[1])
                      if name.startswith("BATTLE_SUBSCRIPT_"))
             + "\n"
             + "".join(f"#define {name:<51} {number_}\n"
                      for name, number_ in sorted(naming.items(), key=lambda item: item[1])
                      if name.startswith("MOVE_SUBSCRIPT_PTR_"))
             + "\n")
    at = subscript_text.rindex("\n#endif")
    (ROOT / "include/constants/battle_subscript.h").write_text(
        subscript_text[:at] + block + subscript_text[at:])

    # The table a side effect is looked up in. It is indexed by the slot, so
    # it grows by exactly the slots that were added, in their order.
    table_file = ROOT / "src/battle/overlay_12_0224E4FC.c"
    text = table_file.read_text()
    start = text.index("static const int sMoveStatusChangeScripts")
    end = text.index("\n};", start)
    body = text[text.index("{", start) + 1:end].rstrip().rstrip(",")
    keep = [line.strip().rstrip(",") for line in body.splitlines() if line.strip()]
    keep = keep[:max(ours_pointers.values()) + 1] + [target for _, _, target in sorted(new_pointers)]
    table_file.write_text(text[:start] + "static const int sMoveStatusChangeScripts[] = {\n"
                          + ",\n".join("    " + entry for entry in keep)
                          + text[end:])

    # The effect numbers, beside the ones this game already had.
    effects_text = original("include/constants/move_effects.h")
    marker = "\n#endif"
    body = ("\n// The effects the reference brings with it, each one the script that came\n"
            "// with it. They keep this game's numbering, not the reference's: up to\n"
            f"// {LAST_VANILLA_EFFECT} the two agree on what a number means even where they disagree on\n"
            "// what to call it, and past it this game had already spent ten of its own.\n"
            + "".join(f"#define MOVE_EFFECT_{name[len('MOVE_EFFECT_'):]:<44} {mine}\n"
                     for mine, _, name in new_effects))
    at = effects_text.rindex(marker)
    MOVE_EFFECTS_H.write_text(effects_text[:at] + body + effects_text[at:])

    # The move numbers.
    moves_text = original("include/constants/moves.h")
    body = ("\n// The rest of the reference's moves, in its own order. This game numbers\n"
            "// them from where it had stopped rather than where the reference puts\n"
            "// them, because the twenty-eight above were already numbered that way and\n"
            "// nothing reads a move by number across the two trees.\n"
            + "".join(f"#define MOVE_{name:<26} {identifier}\n" for identifier, name, _ in added)
            + "\n// Six retail moves the reference spells differently. Same move, same\n"
            "// number: this is so that data written against the reference compiles.\n"
            + "".join(f"#define MOVE_{name:<26} {value}\n" for value, name in aliases)
            + "\n")
    at = moves_text.index("\n// NUM_MOVES sizes")
    moves_text = moves_text[:at] + body + moves_text[at:]
    moves_text = re.sub(r"#define NUM_MOVES_TOTAL MOVE_[A-Z0-9_]+",
                        f"#define NUM_MOVES_TOTAL MOVE_{added[-1][1]}", moves_text)
    MOVES_H.write_text(moves_text)

    # The table, which must stay dense, and the three banks beside it.
    while len(table) < first_move:
        table.append(bytes(RECORD_SIZE))
    for identifier, _, record in added:
        if identifier < len(table):
            table[identifier] = record
        else:
            table.append(record)
    TABLE.write_bytes(write_table(table))
    append_rows(NAMES, "msg_0750", names, first_move, True)
    append_rows(CAPS, "msg_0751", caps, first_move, True)
    append_rows(DESCRIPTIONS, "msg_0749", descriptions, first_move, True)

    # The animations. The twenty-eight already there were chosen by hand and
    # are left alone; the rest are the nearest move this game has.
    text = COMMANDS.read_text()
    start = text.index("    static const u16 borrowed[NUM_ADDED_MOVES] = {")
    end = text.index("    };", start) + len("    };")
    # The twenty-eight already there were chosen by hand, one at a time, and
    # are better than anything this can work out; everything past them is.
    kept = text[start:end].splitlines()[1:-1][:HANDPICKED_ANIMATIONS]
    rows_ = kept + [f"        MOVE_{model + ',':<18} // {name.title().replace('_', ' ')}"
                    for name, model in borrowed]
    COMMANDS.write_text(text[:start]
                        + "    static const u16 borrowed[NUM_ADDED_MOVES] = {\n"
                        + "\n".join(rows_) + "\n    };" + text[end:])
    print("written")


if __name__ == "__main__":
    main()
