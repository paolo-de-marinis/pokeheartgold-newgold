#!/usr/bin/env python3
"""Check the four gyms to Morty -- the leaders and their juniors -- as data.

The ledger's verification row for these four gyms asks four things: parties,
levels, held items, and the AI using what it carries. Three of those are a
question about data and are answered here, for every trainer standing in
Violet, Azalea, Goldenrod and Ecruteak: 18 trainers and 72 Pokemon, each one
compared field for field against konefr's `data/Trainers.c`.

The fourth is not a question about data and is not answered here. Whether the
AI reaches for the potions in a leader's bag, and whether it plays around the
Sitrus Berry or the Focus Sash the Pokemon in front of it is holding, is
decided in `asm/overlay_10_trainer_ai*.s` -- vanilla assembly this port has
never decompiled and does not touch. Nothing in this file runs a turn of
battle. What it can say is that the ingredients are there: the flags are the
numbers konefr wrote, the potions are in the bag, and every held item names a
hold effect that some line of this tree actually reads. Somebody still has to
watch Morty heal.

The set of trainers is not guessed from ids. konefr's own
`trainer_worklog_start_to_morty.md` groups his table by where the trainer
stands, and its four `Gym` sections name these eighteen; the pinned table
below is that list, and `test_the_set_is_the_one_konefr_s_worklog_names`
re-derives it from the document whenever the checkout is present. The battle
data itself always comes from `data/Trainers.c`, never from the worklog, which
is generated and can be older than the tree.
"""

import collections
import json
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE as REFERENCE_PATH

sys.path.insert(0, str(ROOT / "tests/newgold"))
sys.path.insert(0, str(ROOT / "tools/newgold/devkit"))
import savedit  # noqa: E402
import test_hold_effects  # noqa: E402

REFERENCE = Path(REFERENCE_PATH) if REFERENCE_PATH is not None else None
needs_reference = unittest.skipIf(REFERENCE is None, "the reference checkout is not here")

TRAINERS = ROOT / "files/poketool/trainer/trainers.json"
PERSONAL = ROOT / "files/poketool/personal/personal.json"
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"

# How this repository spells the four names konefr spells differently in the
# eighteen records below. The importer's own table is longer; these are the
# ones the gyms actually reach, written out so a rename on either side fails
# here rather than being absorbed.
ALIASES = {
    "ITEM_TWISTED_SPOON": "ITEM_TWISTEDSPOON",
    "ITEM_LEEK": "ITEM_STICK",
    "MOVE_FEINT_ATTACK": "MOVE_FAINT_ATTACK",
    "ABILITY_COMPOUND_EYES": "ABILITY_COMPOUNDEYES",
}

# konefr's slot is a byte hg-engine hands to the retail personality code before
# it writes the ability: 0x00 does nothing to the personality, 0x20 sets its
# low bit, 0x02 is the FEMALE gender nibble. The gender and ability nibbles
# that do the same here.
SLOTS = {"TRAINER_POKEMON_ABILITY_1": ("TRPOKE_GENDER_OVERRIDE_OFF", "TRPOKE_ABILITY_OVERRIDE_OFF"),
         "TRAINER_POKEMON_ABILITY_2": ("TRPOKE_GENDER_OVERRIDE_OFF", "TRPOKE_ABILITY_OVERRIDE_SECOND"),
         "TRAINER_POKEMON_ABILITY_HIDDEN": ("TRPOKE_GENDER_OVERRIDE_FEMALE", "TRPOKE_ABILITY_OVERRIDE_HIDDEN")}

# What each ability nibble does to the personality's low bit.
LOW_BIT = {"TRPOKE_ABILITY_OVERRIDE_OFF": None, "TRPOKE_ABILITY_OVERRIDE_FIRST": 0,
           "TRPOKE_ABILITY_OVERRIDE_SECOND": 1, "TRPOKE_ABILITY_OVERRIDE_HIDDEN": None,
           "TRPOKE_ABILITY_OVERRIDE_SECOND_BY_NAME": None}

BATTLE_TYPES = {"SINGLE_BATTLE": 0, "DOUBLE_BATTLE": 2, "NO_PARTNER_DOUBLE_BATTLE": 3}

HAS_MOVES, HAS_ITEM, HAS_ABILITY = 0x01, 0x02, 0x04

Gym = collections.namedtuple("Gym", "town badge cap trainers")

# Each gym in the order the game is played, the badge its leader gives, the
# level cap the player is held to while it is fought, and its trainers in the
# order konefr's worklog lists them -- juniors first, leader last.
GYMS = [
    Gym("Violet", "BADGE_ZEPHYR", 13, [(50, "Abe"), (29, "Rod"), (20, "Falkner")]),
    Gym("Azalea", "BADGE_HIVE", 22,
        [(67, "Benny"), (10, "Amy & Mimi"), (68, "Al"), (69, "Josh"), (21, "Bugsy")]),
    Gym("Goldenrod", "BADGE_PLAIN", 30,
        [(5, "Victoria"), (70, "Samantha"), (22, "Carrie"), (71, "Cathy"), (30, "Whitney")]),
    Gym("Ecruteak", "BADGE_FOG", 36,
        [(494, "Georgina"), (89, "Grace"), (493, "Edith"), (46, "Martha"), (31, "Morty")]),
]

TRAINER_COUNT, POKEMON_COUNT = 18, 72

# Party size per trainer, in the order above. Pinned so a party that loses or
# gains a Pokemon fails without the checkout.
PARTY_SIZES = {50: 3, 29: 4, 20: 5,
               67: 5, 10: 4, 68: 3, 69: 3, 21: 5,
               5: 4, 70: 2, 22: 3, 71: 3, 30: 5,
               494: 6, 89: 4, 493: 4, 46: 4, 31: 5}

# The AI each trainer is given: the number this table stores, and the flags
# konefr names to build it. Composites are written out -- Whitney's record
# says F_TRAINER_EXPERT_AI, which is the first three of these.
SUPER, EVALUATE, EXPERT, STATUS, HEALING = (
    "F_PRIORITIZE_SUPER_EFFECTIVE", "F_EVALUATE_ATTACKS", "F_EXPERT_ATTACKS",
    "F_PRIORITIZE_STATUS_MOVES", "F_PRIORITIZE_HEALING")
AI = {
    50: (1, {SUPER}), 29: (1, {SUPER}), 20: (3, {SUPER, EVALUATE}),
    67: (1, {SUPER}), 10: (1, {SUPER}), 68: (1, {SUPER}), 69: (1, {SUPER}),
    21: (15, {SUPER, EVALUATE, EXPERT, STATUS}),
    5: (1, {SUPER}), 70: (1, {SUPER}), 22: (5, {SUPER, EXPERT}), 71: (5, {SUPER, EXPERT}),
    30: (271, {SUPER, EVALUATE, EXPERT, STATUS, HEALING}),
    494: (5, {SUPER, EXPERT}), 89: (5, {SUPER, EXPERT}), 493: (5, {SUPER, EXPERT}),
    46: (5, {SUPER, EXPERT}), 31: (7, {SUPER, EVALUATE, EXPERT}),
}

# What each leader keeps in its own bag for the AI to reach for. No junior in
# the four gyms carries anything.
BAGS = {20: ["ITEM_SUPER_POTION", "ITEM_SUPER_POTION"],
        21: ["ITEM_SUPER_POTION"],
        30: ["ITEM_SUPER_POTION", "ITEM_SUPER_POTION"],
        31: ["ITEM_HYPER_POTION", "ITEM_HYPER_POTION"]}

# The ten Pokemon whose ability konefr writes by name rather than by slot --
# Bugsy's five and Whitney's five, the only two trainers in his whole table
# that set TRAINER_DATA_TYPE_ABILITY. This table has no field for a named
# ability, and does not need one: every one of these is one of that species'
# own three, so the slot override already here reaches it. Four of them were
# reaching the wrong one until the importer learnt this rule.
NAMED_ABILITIES = {
    (21, "SPECIES_LEDIAN"): "ABILITY_IRON_FIST",
    (21, "SPECIES_SHUCKLE"): "ABILITY_STURDY",
    (21, "SPECIES_ARIADOS"): "ABILITY_COMPOUNDEYES",
    (21, "SPECIES_SCIZOR"): "ABILITY_TECHNICIAN",
    (21, "SPECIES_HERACROSS"): "ABILITY_GUTS",
    (30, "SPECIES_FURRET"): "ABILITY_FRISK",
    (30, "SPECIES_AMBIPOM"): "ABILITY_TECHNICIAN",
    (30, "SPECIES_WIGGLYTUFF"): "ABILITY_CUTE_CHARM",
    (30, "SPECIES_FARIGIRAF"): "ABILITY_SAP_SIPPER",
    (30, "SPECIES_MILTANK"): "ABILITY_THICK_FAT",
}

# Four Pokemon in these gyms are declared by a trainer that carries movesets
# and konefr gives them no moveset. Both engines write all four slots whatever
# is there, so in his game each walks into battle with MOVE_NONE four times
# and Struggles. It is his slip, and the importer gives each the moves the
# game made it with (KONEFR-NOTES.md, Allenatori 5); the pin keeps which four
# they are, so that a fifth one arriving fails.
MOVELESS = {(29, "SPECIES_NOIBAT"), (29, "SPECIES_DELIBIRD"),
            (22, "SPECIES_SKITTY"), (22, "SPECIES_HERDIER")}


def made_with(species, level):
    """The moves CreateMon gives a Pokemon it makes, InitBoxMonMoveset
    (src/pokemon.c) as savedit.preset_moves runs it on this tree's
    learnsets: what a party entry that names no moves is left with."""
    names = {}
    for name, number in savedit.move_numbers().items():
        names.setdefault(number, "MOVE_" + name)
    _, number = savedit.personal(species[len("SPECIES_"):])
    return [names[move] for move in savedit.preset_moves(number, level)]


def trainers():
    return json.loads(TRAINERS.read_text())["trainers"]


def abilities():
    """Each species' first, second and hidden ability, from the personal data."""
    rows = json.loads(PERSONAL.read_text())["baseStats"]
    return {"SPECIES_" + row["species"]:
            (row["abilities"][0], row["abilities"][1], row.get("hiddenAbility"))
            for row in rows}


def resolved(slots, species, override):
    """The ability a slot override actually reaches, the way the game does it.

    TrMon_ApplyAbilitySlot writes it on once the Pokemon exists. A second or
    hidden slot the species does not fill falls back to the first.
    """
    first, second, hidden = slots[species]
    if override in ("TRPOKE_ABILITY_OVERRIDE_SECOND", "TRPOKE_ABILITY_OVERRIDE_SECOND_BY_NAME"):
        return second if second != "ABILITY_NONE" else first
    if override == "TRPOKE_ABILITY_OVERRIDE_HIDDEN":
        return hidden or first
    return first


def native(name):
    return ALIASES.get(name, name)


def gym_members():
    """(gym, trainer id, trainer record, party entry) for all 72."""
    table = trainers()
    for gym in GYMS:
        for index, _ in gym.trainers:
            for member in table[index]["party"]:
                yield gym, index, table[index], member


# --- konefr's C, read here rather than through the importer that wrote the
# --- table, so that a mistake made at import time cannot agree with itself.

def reference_blocks():
    source = (REFERENCE / "data/Trainers.c").read_text(errors="replace")
    pieces = re.split(r"\n\s*\[(\d+)\] = \{", source)
    # The dialogue is not battle data, and it is the only part carrying free
    # text, so cutting it off keeps the brace matching below honest.
    return {int(pieces[i]): pieces[i + 1].split(".text = {", 1)[0]
            for i in range(1, len(pieces), 2)}


def group(body, field):
    """The text inside `.field = { ... }`."""
    start = body.index(f".{field} = {{") + len(f".{field} = {{")
    depth, end = 1, start
    while depth:
        depth += (body[end] == "{") - (body[end] == "}")
        end += 1
    return body[start:end - 1]


def braced(text):
    """Each top-level `{ ... }` in text, without its braces."""
    out, depth, start = [], 0, 0
    for index, character in enumerate(text):
        if character == "{":
            if depth == 0:
                start = index
            depth += 1
        elif character == "}":
            depth -= 1
            if depth == 0:
                out.append(text[start + 1:index])
    return out


def reference_flags():
    """Every AI flag konefr defines, and what the composites expand to."""
    text = (REFERENCE / "include/trainer_data.h").read_text(errors="replace")
    bits = {name: 1 << int(shift) for name, shift
            in re.findall(r"#define (F_[A-Z0-9_]+)\s+\(1 << (\d+)\)", text)}
    composite = {name: re.findall(r"F_[A-Z0-9_]+", body) for name, body
                 in re.findall(r"#define (F_[A-Z0-9_]+)\s+\(([^)]*\|[^)]*)\)", text)}
    return bits, composite


def reference_record(body, slots):
    """konefr's trainer, in the shape this repository's table stores."""
    kinds = 0
    types = {name: int(value, 0) for name, value in re.findall(
        r"#define (TRAINER_DATA_TYPE_[A-Z_]+)\s+(0x[0-9A-Fa-f]+)",
        (REFERENCE / "include/trainer_data.h").read_text(errors="replace"))}
    for name in re.findall(r"TRAINER_DATA_TYPE_[A-Z_]+",
                           re.search(r"\.trainerType\s*=\s*([^,]+),", body).group(1)):
        kinds |= types[name]

    party = []
    for member in braced(group(body, "party")):
        species = re.search(r"\.species\s*=\s*(SPECIES_[A-Z0-9_]+)", member).group(1)
        gender, nibble = SLOTS[re.search(r"\.abilitySlot\s*=\s*(\w+)", member).group(1)]
        entry = {
            "difficulty": int(re.search(r"\.ivs\s*=\s*(\d+)", member).group(1)),
            "genderOverride": gender,
            "abilityOverride": nibble,
            "level": int(re.search(r"\.level\s*=\s*(\d+)", member).group(1)),
            "species": species,
        }
        if kinds & HAS_ITEM:
            held = re.search(r"\.item\s*=\s*(ITEM_[A-Z0-9_]+)", member)
            entry["item"] = native(held.group(1)) if held else "ITEM_NONE"
        if kinds & HAS_MOVES:
            moves = re.findall(r"\bMOVE_[A-Z0-9_]+", group(member, "moves")) \
                if ".moves = {" in member else []
            # An entry he left without moves has the ones it was made with.
            entry["moves"] = [native(move) for move in moves if move != "MOVE_NONE"] \
                or made_with(species, entry["level"])
        if kinds & HAS_ABILITY:
            named = re.search(r"\.ability\s*=\s*(ABILITY_[A-Z0-9_]+)", member)
            if named:
                wanted = native(named.group(1))
                # The named ability is written, and the slot still acts on
                # the personality: the one nibble that does both.
                [entry["abilityOverride"]] = [
                    override for override in LOW_BIT
                    if LOW_BIT[override] == LOW_BIT[nibble] and resolved(slots, species, override) == wanted]
        seal = re.search(r"\.ballSeal\s*=\s*(\d+)", member)
        entry["capsule"] = int(seal.group(1)) if seal else 0
        party.append(entry)

    names = {0: "TRTYPE_MON", HAS_MOVES: "TRTYPE_MON_MOVES",
             HAS_ITEM: "TRTYPE_MON_ITEM", HAS_MOVES | HAS_ITEM: "TRTYPE_MON_ITEM_MOVES"}
    return {
        "type": names[kinds & (HAS_MOVES | HAS_ITEM)],
        "class": re.search(r"\.trainerClass\s*=\s*(TRAINERCLASS_[A-Z0-9_]+)", body).group(1),
        "name": "{TRNAME}" + re.search(r'\.name\s*=\s*"([^"]*)"', body).group(1),
        "items": [native(name) for name in re.findall(r"\bITEM_[A-Z0-9_]+", group(body, "items"))
                  if name != "ITEM_NONE"],
        "double": BATTLE_TYPES[re.search(r"\.battleType\s*=\s*(\w+)", body).group(1)],
        "party": party,
    }


class GymSet(unittest.TestCase):
    """Who is in the four gyms."""

    def test_the_pinned_table_is_eighteen_trainers_and_seventy_two_pokemon(self):
        table = trainers()
        indices = [index for gym in GYMS for index, _ in gym.trainers]
        self.assertEqual(len(indices), len(set(indices)))
        self.assertEqual(len(indices), TRAINER_COUNT)
        self.assertEqual(sum(len(table[index]["party"]) for index in indices), POKEMON_COUNT)
        self.assertEqual({index: len(table[index]["party"]) for index in indices}, PARTY_SIZES)
        for gym in GYMS:
            for index, name in gym.trainers:
                self.assertEqual(table[index]["name"], "{TRNAME}" + name, index)

    def test_the_last_trainer_in_each_gym_is_its_leader(self):
        table = trainers()
        for gym in GYMS:
            index, name = gym.trainers[-1]
            self.assertEqual(table[index]["class"], f"TRAINERCLASS_LEADER_{name.upper()}")
            for junior, _ in gym.trainers[:-1]:
                self.assertNotIn("LEADER", table[junior]["class"], junior)

    @needs_reference
    def test_the_set_is_the_one_konefr_s_worklog_names(self):
        """konefr groups his own table by where each trainer stands.

        The worklog is generated and can be older than `Trainers.c`, so it is
        only ever asked who is in a gym -- never what they carry.
        """
        document = (REFERENCE / "trainer_worklog_start_to_morty.md").read_text(errors="replace")
        found = []
        for section in document.split("\n## ")[1:]:
            heading = section.split("\n", 1)[0]
            if re.search(r"\bGym\b", heading):
                town = heading.split(". ", 1)[1].replace(" Gym", "").strip()
                found.append((town, [(int(index), name.strip()) for index, name in
                                     re.findall(r"^### \[(\d+)\] (.+)$", section, re.M)]))
        self.assertEqual(found, [(gym.town, gym.trainers) for gym in GYMS])


class GymParties(unittest.TestCase):
    """What they carry, against konefr's own records."""

    @needs_reference
    def test_every_record_matches_the_reference(self):
        table, blocks, slots = trainers(), reference_blocks(), abilities()
        bits, composite = reference_flags()
        checked = 0
        for gym in GYMS:
            for index, name in gym.trainers:
                wanted = reference_record(blocks[index], slots)
                here = {key: table[index][key] for key in wanted}
                self.assertEqual(here, wanted, f"{name} [{index}]")
                flags = re.findall(r"F_[A-Z0-9_]+",
                                   re.search(r"\.aiFlags\s*=\s*([^,]+),", blocks[index]).group(1))
                named = set()
                for flag in flags:
                    named.update(composite.get(flag, [flag]))
                self.assertEqual(named, AI[index][1], f"{name} [{index}]")
                self.assertEqual(sum(bits[flag] for flag in named),
                                 table[index]["ai_flags"], f"{name} [{index}]")
                checked += len(wanted["party"])
        self.assertEqual(checked, POKEMON_COUNT)

    def test_the_ai_flags_are_the_pinned_numbers(self):
        table = trainers()
        self.assertEqual({index: table[index]["ai_flags"] for index in AI},
                         {index: number for index, (number, _) in AI.items()})

    def test_only_the_leaders_carry_anything_in_their_own_bag(self):
        table = trainers()
        carried = {index: table[index]["items"] for gym in GYMS
                   for index, _ in gym.trainers if table[index]["items"]}
        self.assertEqual(carried, BAGS)

    def test_amy_and_mimi_are_the_only_double_battle(self):
        table = trainers()
        doubles = {index for gym in GYMS for index, _ in gym.trainers if table[index]["double"]}
        self.assertEqual(doubles, {10})
        self.assertEqual(table[10]["double"], BATTLE_TYPES["DOUBLE_BATTLE"])

    def test_a_declared_moveset_is_a_moveset(self):
        """No gym Pokemon is left without moves.

        A party entry under a moveset-carrying trainer that gives no moves is
        written as MOVE_NONE four times, and both engines set all four slots
        unconditionally -- so the Pokemon has nothing to use. konefr left four
        like that; each has the moves the game made it with.
        """
        empty = set()
        for gym, index, trainer, member in gym_members():
            if "MOVES" not in trainer["type"]:
                continue
            if not member.get("moves"):
                empty.add((index, member["species"]))
            else:
                self.assertLessEqual(len(member["moves"]), 4, index)
        self.assertEqual(empty, set())
        table = trainers()
        for index, species in MOVELESS:
            member = next(entry for entry in table[index]["party"] if entry["species"] == species)
            self.assertEqual(member["moves"], made_with(species, member["level"]), f"[{index}] {species}")

    @needs_reference
    def test_the_moveless_four_are_moveless_in_the_reference_too(self):
        blocks = reference_blocks()
        for index, species in MOVELESS:
            member = next(entry for entry in braced(group(blocks[index], "party"))
                          if species in entry)
            self.assertNotIn(".moves", member, f"[{index}] {species}")


class GymAbilities(unittest.TestCase):
    """The ten Pokemon whose ability konefr writes by name."""

    def test_each_named_ability_is_the_one_the_slot_reaches(self):
        table, slots = trainers(), abilities()
        seen = {}
        for gym, index, trainer, member in gym_members():
            key = (index, member["species"])
            if key in NAMED_ABILITIES:
                seen[key] = resolved(slots, member["species"], member["abilityOverride"])
        self.assertEqual(seen, NAMED_ABILITIES)

    @needs_reference
    def test_the_named_abilities_are_the_ones_the_reference_names(self):
        blocks = reference_blocks()
        named = {}
        for gym in GYMS:
            for index, _ in gym.trainers:
                for member in braced(group(blocks[index], "party")):
                    ability = re.search(r"\.ability\s*=\s*(ABILITY_[A-Z0-9_]+)", member)
                    if ability:
                        species = re.search(r"\.species\s*=\s*(SPECIES_[A-Z0-9_]+)", member).group(1)
                        named[(index, species)] = native(ability.group(1))
        self.assertEqual(named, NAMED_ABILITIES)


class GymHeldItems(unittest.TestCase):
    """Whether what a gym Pokemon holds does anything at all."""

    def test_every_held_item_names_a_hold_effect_something_reads(self):
        """An item with an unread hold effect is a rock to carry.

        Sixty-four of konefr's hold effects arrived with his item range and no
        line of this tree reads one yet -- `test_hold_effects.py` counts them.
        None of them may be in a gym, because the gyms are the one part of the
        game that has been rebalanced around what the Pokemon hold.
        """
        rows = {line.split(",")[0]: line.split(",")[2]
                for line in ITEM_DATA.read_text().splitlines()[1:] if line.strip()}
        read = set(test_hold_effects.effects_read())
        for path in (ROOT / "files/battledata").rglob("*"):
            if path.is_file():
                read.update(re.findall(r"HOLD_EFFECT_[A-Z0-9_]+", path.read_text(errors="replace")))

        held = {member["item"] for _, _, _, member in gym_members()
                if member.get("item", "ITEM_NONE") != "ITEM_NONE"}
        self.assertEqual(len(held), 15)
        for item in sorted(held):
            self.assertIn(item, rows, item)
            self.assertNotEqual(rows[item], "HOLD_EFFECT_NONE", item)
            self.assertIn(rows[item], read, f"{item} holds {rows[item]} and nothing reads it")


class GymLevels(unittest.TestCase):
    """The levels, against the cap the player is held to at each gym."""

    def ladder(self):
        """GetLevelCap's clauses, in the order the function asks them."""
        source = (ROOT / "src/pokemon.c").read_text()
        body = source[source.index("u8 GetLevelCap(void) {"):]
        body = body[:body.index("\n}")]
        clauses = re.findall(r"if \([^)]*?, ([A-Z_0-9]+)\)\) \{\s*return (\w+);", body)
        default = re.search(r"\n    return (\w+);\s*$", body).group(1)
        return clauses + [("", default)]

    def test_each_leader_s_ace_is_the_cap_the_player_is_held_to(self):
        """A gym's cap is what GetLevelCap answers before its badge is given.

        The badge clause is the one that lifts the cap afterwards, so the cap
        while the gym is being fought is the clause immediately below it.
        """
        ladder = self.ladder()
        table = trainers()
        for gym in GYMS:
            position = next(i for i, (condition, _) in enumerate(ladder) if condition == gym.badge)
            cap = int(ladder[position + 1][1])
            self.assertEqual(cap, gym.cap, gym.town)
            leader, name = gym.trainers[-1]
            self.assertEqual(max(member["level"] for member in table[leader]["party"]), cap, name)

    def test_no_gym_pokemon_is_over_the_cap_it_is_fought_under(self):
        for gym, index, trainer, member in gym_members():
            self.assertLessEqual(member["level"], gym.cap, f"[{index}] {member['species']}")
            self.assertGreaterEqual(member["level"], 1, index)

    def test_the_gyms_climb(self):
        table = trainers()
        aces = [max(member["level"] for member in table[gym.trainers[-1][0]]["party"])
                for gym in GYMS]
        self.assertEqual(aces, sorted(aces))
        self.assertEqual(aces, [gym.cap for gym in GYMS])


if __name__ == "__main__":
    print(f"konefr's trainer data: "
          f"{REFERENCE if REFERENCE is not None else 'unavailable; pinned expectations only'}")
    unittest.main()
