#!/usr/bin/env python3
"""Check the trainer table.

Trainer data is read by index and its party is built from names, so what can go
wrong quietly is a party that names something the ROM does not define, a level
outside what the game accepts, or a party longer than a team can be.
"""

import functools
import json
import os
import re
import shlex
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import REFERENCE, function

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import gmm  # noqa: E402
import import_moves  # noqa: E402
import import_species  # noqa: E402
import import_trainer_text  # noqa: E402
import import_trainers  # noqa: E402
import wotbl  # noqa: E402

TRAINERS = ROOT / "files/poketool/trainer/trainers.json"
PARTY_MAX = 6


def defined(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


# The two functions that turn a party entry's override byte into its
# personality and its ability, the real ones out of src/trainer_data.c, run on
# the host. Each line of input is either `t MODIFIER`, a trainer starting with
# that personality modifier, or `m RATIO FIRST SECOND HIDDEN BYTE`, one of its
# Pokemon: its species' gender ratio as personal.json writes it (a fraction,
# through the real GENDER_RATIO) and three abilities, and its override
# byte. For each Pokemon it prints the modifier after it and the ability it
# was given.
PARTY_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/pokemon.h"
#include "constants/trainers.h"
typedef uint8_t u8;
typedef uint32_t u32;
typedef struct { u32 ability; } Pokemon;
static int stats[64];
static int GetMonBaseStat_HandleAlternateForm(int species, int form, int stat) {
    assert(species == 1 && form == 0 && stat >= 0 && stat < 64);
    return stats[stat];
}
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr == MON_DATA_ABILITY);
    mon->ability = *(const u32 *)value;
}
@FUNCTIONS@
int main(void) {
    unsigned pid = 0, first, second, hidden, byte;
    double ratio;
    char kind;
    while (scanf(" %c", &kind) == 1) {
        if (kind == 't') {
            assert(scanf("%u", &pid) == 1);
            continue;
        }
        assert(kind == 'm' && scanf("%lf %u %u %u %u", &ratio, &first, &second, &hidden, &byte) == 5);
        stats[BASE_GENDER_RATIO] = GENDER_RATIO(ratio);
        stats[BASE_ABILITY_1] = first;
        stats[BASE_ABILITY_2] = second;
        stats[BASE_HIDDEN_ABILITY] = hidden;
        Pokemon mon = { 0xFFFF };
        TrMon_OverridePidGender(1, 0, byte, &pid);
        TrMon_ApplyAbilitySlot(&mon, 1, 0, byte);
        printf("%u %u\n", pid, mon.ability);
    }
    return 0;
}
"""


# CreateNPCTrainerParty's seed species, the real TrMon_SeedSpecies and its
# generated table, run on the host: a species number in, the one the
# personality is seeded with out.
SEED_FIXTURE = r"""
#include <stdint.h>
#include <stdio.h>
#include "constants/species.h"
typedef uint16_t u16;
@TABLE@
@FUNCTION@
int main(void) {
    unsigned species;
    while (scanf("%u", &species) == 1) {
        printf("%u\n", TrMon_SeedSpecies((u16)species));
    }
    return 0;
}
"""


def seed_species(numbers):
    source = (ROOT / "src/trainer_data.c").read_text()
    program = (SEED_FIXTURE.replace("@TABLE@", (ROOT / "src/data/trainer_seed_species.h").read_text())
               .replace("@FUNCTION@", function(source, "TrMon_SeedSpecies")))
    with tempfile.TemporaryDirectory(prefix="newgold-trseed-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], check=True)
        output = subprocess.run([str(path / "test")], input="\n".join(map(str, numbers)) + "\n",
                                capture_output=True, text=True, check=True).stdout
    return [int(line) for line in output.split()]


def engine_species(names):
    """hg-engine's number for each name, worked out from its header at the
    engine's revision: a number, or a sum of numbers and names."""
    text = gmm.git_show(gmm.ENGINE, "include/constants/species.h")
    defs = dict(re.findall(r"^#define (\w+)\s+\(?([\w +]+?)\)?\s*(?://.*)?$", text, re.M))

    def value(term):
        return sum(int(t) if t.isdigit() else value(defs[t]) for t in term.replace(" ", "").split("+"))
    return {name: value(defs[name]) for name in names}


def lcrng(seed, rolls):
    """LCRandom after SetLCRNGSeed(seed), rolled `rolls` times."""
    value = seed
    for _ in range(rolls):
        seed = (seed * 1103515245 + 24691) & 0xFFFFFFFF
        value = seed >> 16
    return value


def run_parties(lines):
    """[(modifier, ability)] for each `m` line, through the real functions."""
    source = (ROOT / "src/trainer_data.c").read_text()
    program = PARTY_FIXTURE.replace("@FUNCTIONS@", function(source, "TrMon_OverridePidGender")
                                    + "\n" + function(source, "TrMon_ApplyAbilitySlot"))
    with tempfile.TemporaryDirectory(prefix="newgold-trpoke-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], check=True)
        output = subprocess.run([str(path / "test")], input="\n".join(lines) + "\n",
                                capture_output=True, text=True, check=True).stdout
    return [tuple(map(int, line.split())) for line in output.splitlines()]


@functools.lru_cache(maxsize=1)
def personal():
    return {"SPECIES_" + row["species"]: row for row in
            json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]}


@functools.lru_cache(maxsize=1)
def abilities():
    return {name: int(value) for name, value in re.findall(
        r"#define (ABILITY_\w+)\s+(\d+)\b", (ROOT / "include/constants/abilities.h").read_text())}


def party_lines(trainer, byte_of):
    """The fixture's lines for a party, each Pokemon's byte from byte_of. Each
    starts from 0x88, a male trainer's modifier; both sides of a comparison
    start the same."""
    lines = ["t 136"]
    for member in trainer:
        row = personal()[member["species"]]
        first, second = row["abilities"]
        lines.append(f"m {row['genderRatio']} {abilities()[first]} {abilities()[second]} "
                     f"{abilities()[row.get('hiddenAbility') or 'ABILITY_NONE']} {byte_of(member)}")
    return lines


def override_constants():
    text = (ROOT / "include/constants/trainers.h").read_text()
    return {name: int(value) for name, value in re.findall(r"#define (TRPOKE_\w+_OVERRIDE_\w+)\s+(\d+)", text)}


class TrainerTests(unittest.TestCase):
    def setUp(self):
        self.trainers = json.loads(TRAINERS.read_text())["trainers"]
        self.species = defined("include/constants/species.h", "SPECIES_")
        self.items = defined("include/constants/items.h", "ITEM_")
        self.moves = defined("include/constants/moves.h", "MOVE_")
        self.classes = defined("include/constants/trainer_class.h", "TRAINERCLASS_")

    def test_every_name_is_defined(self):
        for index, trainer in enumerate(self.trainers):
            self.assertIn(trainer["class"], self.classes, index)
            for item in trainer["items"]:
                self.assertIn(item, self.items, index)
            for member in trainer["party"]:
                self.assertIn(member["species"], self.species, index)
                if "item" in member:
                    self.assertIn(member["item"], self.items, index)
                for move in member.get("moves", []):
                    self.assertIn(move, self.moves, index)

    def test_parties_are_legal(self):
        for index, trainer in enumerate(self.trainers):
            self.assertLessEqual(len(trainer["party"]), PARTY_MAX, index)
            for member in trainer["party"]:
                self.assertGreaterEqual(member["level"], 1, index)
                self.assertLessEqual(member["level"], 100, index)
                self.assertLessEqual(len(member.get("moves", [])), 4, index)

    def test_declared_type_matches_the_party(self):
        for index, trainer in enumerate(self.trainers):
            carriesMoves = "MOVES" in trainer["type"]
            carriesItem = "ITEM" in trainer["type"]
            for member in trainer["party"]:
                self.assertEqual("moves" in member, carriesMoves, index)
                self.assertEqual("item" in member, carriesItem, index)

    def test_the_rebalance_landed(self):
        """Falkner is the first gym New Gold reworks, and his team shows it:
        five Pokemon, every one of them holding something, where HeartGold gave
        him two and nothing."""
        falkner = next(t for t in self.trainers if t["name"].endswith("Falkner"))
        self.assertEqual([m["level"] for m in falkner["party"]], [12, 12, 12, 13, 13])
        self.assertEqual(falkner["type"], "TRTYPE_MON_ITEM_MOVES")
        for member in falkner["party"]:
            self.assertNotEqual(member["item"], "ITEM_NONE", member["species"])
        # The Leek, which this game calls the Stick, and an Eviolite: both are
        # items the port had to add before this trainer could be read at all.
        held = {member["item"] for member in falkner["party"]}
        self.assertIn("ITEM_STICK", held)
        self.assertIn("ITEM_EVIOLITE", held)

    def test_a_party_entry_can_name_every_species(self):
        """The species field is 11 bits of species and 5 of form, hg-engine's
        split. Platinum's was 10 and 6, which wrapped every species from 1024
        on: Koraidon (1025) was read as species 1, form 1."""
        header = (ROOT / "include/trainer_data.h").read_text()
        mask = int(re.search(r"#define TRPOKE_SPECIES_MASK\s+(0x[0-9A-Fa-f]+)", header)[1], 16)
        shift = int(re.search(r"#define TRPOKE_FORM_SHIFT\s+(\d+)", header)[1])
        self.assertEqual(mask + 1, 1 << shift)
        numbers = re.findall(r"#define SPECIES_\w+\s+(\d+)\b", (ROOT / "include/constants/species.h").read_text())
        self.assertLessEqual(max(map(int, numbers)), mask)
        # Every place that unpacks the field, and the one that packs it.
        for path in ("src/trainer_data.c", "src/application/pokegear/phone/scripts/phone_scripts_generic.c"):
            text = (ROOT / path).read_text()
            self.assertEqual(text.count("species & TRPOKE_SPECIES_MASK"), 4, path)
            self.assertNotRegex(text, r"species & 0x3FF|>> 10\b", path)
        template = (ROOT / "files/poketool/trainer/trpoke.json.txt").read_text()
        self.assertIn("<< TRPOKE_FORM_SHIFT)", template)
        for index, trainer in enumerate(self.trainers):
            for member in trainer["party"]:
                self.assertLess(member.get("form", 0), 1 << (16 - shift), index)

    def test_a_move_the_engine_has_no_effect_for_leaves_its_slot_empty(self):
        """hg-engine's BLOCK_LEARNING_UNIMPLEMENTED_MOVES: a trainer's Pokemon
        is not given a move flagged FLAG_UNUSABLE_UNIMPLEMENTED, and the slot
        stays where it was. Two in konefr's table carry one: Morty's Annihilape
        goes in with Bulk Up, nothing, Drain Punch and Taunt, and Issac's
        Whismur without Echoed Voice."""
        party = function((ROOT / "src/trainer_data.c").read_text(), "CreateNPCTrainerParty")
        self.assertEqual(re.findall(r"MonSetMoveInSlot\(mon, ([^;]*)\);", party),
                         ["TrMon_UsableMove(monSpeciesMoves[i].moves[j]), (u8)j", "TrMon_UsableMove(monSpeciesItemMoves[i].moves[j]), (u8)j"])
        # The flag is bit 5 of each record's flag byte (offset 11), written from
        # the engine's move data by import_moves.py.
        table = (ROOT / "files/poketool/waza/waza_tbl.narc").read_bytes()
        count = struct.unpack_from("<H", table, 0x18)[0]
        spans = [struct.unpack_from("<II", table, 0x1C + 8 * i) for i in range(count)]
        base = table.index(b"GMIF") + 8
        numbers = {int(v): n for n, v in re.findall(r"#define (MOVE_\w+)\s+(\d+)\b",
                                                    (ROOT / "include/constants/moves.h").read_text())}
        listed = [numbers[i] for i, (a, _) in enumerate(spans) if table[base + a + 11] & 0x20]
        self.assertEqual(len(listed), 79)
        carried = {(index, member["species"], move) for index, trainer in enumerate(self.trainers)
                   for member in trainer["party"] for move in member.get("moves", []) if move in listed}
        self.assertEqual(carried, {(31, "SPECIES_ANNIHILAPE", "MOVE_RAGE_FIST"),
                                   (391, "SPECIES_WHISMUR", "MOVE_ECHOED_VOICE")})

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_unimplemented_moves_are_the_engine_s(self):
        """The flag in the move table is the importer's reading of d0380a487's
        data/Moves.c; konefr flags the same 79."""
        table = (ROOT / "files/poketool/waza/waza_tbl.narc").read_bytes()
        count = struct.unpack_from("<H", table, 0x18)[0]
        spans = [struct.unpack_from("<II", table, 0x1C + 8 * i) for i in range(count)]
        base = table.index(b"GMIF") + 8
        numbers = {int(v): n for n, v in re.findall(r"#define MOVE_(\w+)\s+(\d+)\b",
                                                    (ROOT / "include/constants/moves.h").read_text())}
        listed = [numbers[i] for i, (a, _) in enumerate(spans) if table[base + a + 11] & 0x20]
        for revision in (gmm.ENGINE, gmm.NEWGOLD):
            blocks = import_moves.records_in(gmm.git_show(revision, "data/Moves.c"))
            flagged = {name for name, block in blocks.items()
                       if "FLAG_UNUSABLE_UNIMPLEMENTED" in import_moves.named_flags(block)}
            self.assertEqual(set(listed), flagged, revision)

    def test_the_override_byte_gives_the_slot_it_names(self):
        """The ability is written outright, as hg-engine writes it, and not left
        to the personality, whose low bit an entry that leaves it alone carries
        over from the one before. SECOND sets that bit and SECOND_BY_NAME does
        not; the FEMALE nibble sets the modifier to the gender ratio less two."""
        c = override_constants()
        female = c["TRPOKE_GENDER_OVERRIDE_FEMALE"]
        cases = [  # (ability nibble, gender nibble, second, hidden) -> (modifier, ability)
            ("OFF", 0, 22, 33, 0x89, 11),
            ("FIRST", 0, 22, 33, 0x88, 11),
            ("SECOND", 0, 22, 33, 0x89, 22),
            ("SECOND", 0, 0, 33, 0x89, 11),
            ("SECOND_BY_NAME", 0, 22, 33, 0x89, 22),
            ("HIDDEN", 0, 22, 33, 0x89, 33),
            ("HIDDEN", 0, 22, 0, 0x89, 11),
            ("HIDDEN", female, 22, 33, 127 - 2, 33),
        ]
        lines = []
        for slot, gender, second, hidden, _, _ in cases:
            byte = gender | c["TRPOKE_ABILITY_OVERRIDE_" + slot] << 4
            lines += ["t 137", f"m 0.5 11 {second} {hidden} {byte}"]
        self.assertEqual(run_parties(lines), [(pid, ability) for *_, pid, ability in cases])

    def test_falkner_s_team_is_female_as_konefr_s_is(self):
        """konefr's hidden slot is the FEMALE gender nibble to the personality
        code, so Falkner's Hoothoot sets the modifier to its gender ratio less
        two, 0x7D, and it stays there for all five: female, as in his build.
        Translated as a plain ability override they were all 0x88, male."""
        c = override_constants()
        falkner = self.trainers[20]
        self.assertEqual(falkner["name"], "{TRNAME}Falkner")
        results = run_parties(party_lines(falkner["party"], lambda member: c[member["genderOverride"]]
                                          | c[member["abilityOverride"]] << 4))
        self.assertEqual([pid & 0xFF for pid, _ in results], [0x7D] * 5)

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_every_party_gets_konefr_s_personality_modifier_and_ability(self):
        """For every Pokemon in konefr's table, the modifier the real
        TrMon_OverridePidGender leaves after it, from this table's byte, is the
        one it leaves from his slot byte, the byte hg-engine hands it; and the
        ability TrMon_ApplyAbilitySlot writes is the one hg-engine writes: the
        one named outright, or the slot's."""
        source = gmm.git_show(gmm.NEWGOLD, "data/Trainers.c")
        header = gmm.git_show(gmm.NEWGOLD, "include/trainer_data.h")
        raw = {name: int(value, 16) for name, value in re.findall(
            r"#define (TRAINER_POKEMON_ABILITY_\w+)\s+0x([0-9A-Fa-f]+)", header)}
        blocks = re.split(r"\n\s*\[(\d+)\] = \{", source)
        c = override_constants()
        ours, theirs, expected, where = [], [], [], []
        for index, block in ((int(blocks[i]), blocks[i + 1].split(".text = {", 1)[0])
                             for i in range(1, len(blocks), 2)):
            members = re.findall(r"\{[^{}]*\.abilitySlot[^{}]*(?:\{[^{}]*\}[^{}]*)*\}", block)
            party = self.trainers[index]["party"]
            self.assertEqual(len(members), len(party), index)
            slots = iter([re.search(r"\.abilitySlot\s*=\s*(\w+)", m)[1] for m in members])
            ours += party_lines(party, lambda member: c[member["genderOverride"]]
                                | c[member["abilityOverride"]] << 4)
            theirs += party_lines(party, lambda member: raw[next(slots)])
            for member, text in zip(party, members):
                row = personal()[member["species"]]
                slot = re.search(r"\.abilitySlot\s*=\s*(\w+)", text)[1]
                named = re.search(r"\.ability\s*=\s*(ABILITY_\w+)", text)
                if named:
                    wanted = import_trainers.native(named[1])
                elif slot == "TRAINER_POKEMON_ABILITY_2" and row["abilities"][1] != "ABILITY_NONE":
                    wanted = row["abilities"][1]
                elif slot == "TRAINER_POKEMON_ABILITY_HIDDEN":
                    wanted = row["hiddenAbility"]
                else:
                    wanted = row["abilities"][0]
                expected.append(abilities()[wanted])
                where.append((index, member["species"]))
        ours, theirs = run_parties(ours), run_parties(theirs)
        for place, (pid, ability), (reference_pid, _), wanted in zip(where, ours, theirs, expected):
            self.assertEqual((pid, ability), (reference_pid, wanted), place)
        compared = len(ours)
        self.assertEqual(compared, sum(len(t["party"]) for t in self.trainers))

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_personality_seed_is_the_engine_s_species_number(self):
        """A trainer Pokemon's personality is seeded with its difficulty,
        level, species and trainer (enemy_party.c:277), and past Arceus
        hg-engine numbers species otherwise: Morty's Annihilape is 568 here and
        1029 there. Seeded with 568 it was Jolly; konefr's is Bashful."""
        party = function((ROOT / "src/trainer_data.c").read_text(), "CreateNPCTrainerParty")
        self.assertEqual(party.count(".level + TrMon_SeedSpecies(species) + enemies->trainerId[partyIndex];"), 4)
        ours = {name: int(number) for name, number in re.findall(
            r"#define (SPECIES_\w+)\s+(\d+)\b", (ROOT / "include/constants/species.h").read_text())}
        named = sorted({member["species"] for trainer in self.trainers for member in trainer["party"]})
        engine = engine_species(named)
        self.assertEqual(dict(zip(named, seed_species([ours[name] for name in named]))), engine)

        c = override_constants()
        morty = next(i for i, t in enumerate(self.trainers) if t["name"] == "{TRNAME}Morty")
        members = self.trainers[morty]["party"]
        modifiers = run_parties(party_lines(members, lambda member: c[member["genderOverride"]]
                                            | c[member["abilityOverride"]] << 4))
        (k, member), = [(k, m) for k, m in enumerate(members) if m["species"] == "SPECIES_ANNIHILAPE"]
        rolls = int(re.search(r"#define TRAINERCLASS_LEADER_MORTY\s+(\d+)",
                              (ROOT / "include/constants/trainer_class.h").read_text())[1])
        seed = member["difficulty"] + member["level"] + seed_species([ours["SPECIES_ANNIHILAPE"]])[0] + morty
        personality = (lcrng(seed, rolls) << 8) + modifiers[k][0]
        self.assertEqual(personality % 25, 18)  # Bashful

    def test_added_species_reach_trainers(self):
        named = {member["species"] for trainer in self.trainers for member in trainer["party"]}
        added = {f"SPECIES_{name}" for name in import_species.added_species()}
        self.assertTrue(added & named, "the rebalance should hand added species to trainers")

    def test_the_name_bank_is_remade_when_trainers_json_changes(self):
        """Bank 729 is made from trainers.json by files/msgdata/msg.mk. Its rule
        once had no prerequisites, so after the first build no edit to a name
        ever reached the ROM."""
        rule = re.search(r"^\$\(TRNAME_GMM\):(.*)$", (ROOT / "files/msgdata/msg.mk").read_text(), re.M)
        self.assertIsNotNone(rule, "no rule makes $(TRNAME_GMM)")
        self.assertLessEqual({"$(TRAINER_JSON)", "$(TRNAME_TEMPLATE)"}, set(rule.group(1).split()))

    def test_konefr_s_names_and_lines(self):
        """New Gold: Youngster Mikey and Bird Keeper Peter as konefr renamed
        them, their lines where his trtbl map puts them -- with the win line
        he gave Peter inserted as row 661 and everything after it one along.
        hg-engine's Mikey and Peter are the engine layer, the commit before
        his text."""
        self.assertEqual(self.trainers[47]["name"], "{TRNAME}Pippo Franco")
        self.assertEqual(self.trainers[383]["name"], "{TRNAME}Pietro Pacciani")
        lines = [row["text"] for row in gmm.read(728)]
        self.assertEqual(len(lines), 1718)
        self.assertEqual(lines[649], "Mi scappa la pipì, papà!\\r")
        self.assertEqual(lines[662], "I should train again at the Gym in\\nViolet City.\\n")
        trtbl = wotbl.read_narc((ROOT / "files/poketool/trmsg/trtbl.narc").read_bytes())[0][0]
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 649), (47, 0))     # TRMSG_INTRO
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 661), (383, 20))   # TRMSG_WIN, his
        self.assertEqual(struct.unpack_from("<HH", trtbl, 4 * 662), (383, 2))    # TRMSG_AFTER

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_text_is_what_the_generator_makes_at_new_gold(self):
        """import_trainer_text.py is trainerdatagen and msg_cat.py again; at
        ccf2c9f5 it reproduces every name, bank 728 and both map archives, and
        at d0380a487 it differs only in konefr's three trainers."""
        names, rows, trtbl, trtblofs = import_trainer_text.generate(gmm.NEWGOLD)
        self.assertEqual([trainer["name"] for trainer in self.trainers], ["{TRNAME}" + name for name in names])
        self.assertEqual([row["text"] for row in gmm.read(728)], [gmm.escape(text) for _, _, text in rows])
        self.assertEqual((ROOT / "files/poketool/trmsg/trtbl.narc").read_bytes(), wotbl.build_narc([trtbl], 4))
        self.assertEqual((ROOT / "files/poketool/trmsg/trtblofs.narc").read_bytes(), wotbl.build_narc([trtblofs], 4))
        engine_names = import_trainer_text.generate(gmm.ENGINE)[0]
        self.assertEqual({i for i, (a, b) in enumerate(zip(engine_names, names)) if a != b}, {47, 383})

if __name__ == "__main__":
    unittest.main()
