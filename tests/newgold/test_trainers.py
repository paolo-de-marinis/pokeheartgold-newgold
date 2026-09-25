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


# The Trainer record as include/trainer_data.h declares it, laid out on the
# host: the units its name holds, and where the Frontier's messages sit.
TRAINER_LAYOUT = r"""
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef struct { u16 msg_bank, msg_no, fields[2]; } MailMessage;
@PLAYER_NAME_LENGTH@
@DECLARATIONS@
int main(void) {
    Trainer trainer;
    printf("%u %u %u %u\n", (unsigned)(sizeof(trainer.name) / sizeof(*trainer.name)),
           (unsigned)offsetof(Trainer, name), (unsigned)offsetof(Trainer, winMessage), (unsigned)sizeof(Trainer));
    return 0;
}
"""


def trainer_layout():
    header = (ROOT / "include/trainer_data.h").read_text()
    declarations = re.search(r"typedef struct TrainerData \{.*?\} Trainer;", header, re.S)[0]
    player = re.search(r"#define PLAYER_NAME_LENGTH\s+\d+", (ROOT / "include/constants/global.h").read_text())[0]
    with tempfile.TemporaryDirectory(prefix="newgold-trainer-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(TRAINER_LAYOUT.replace("@DECLARATIONS@", declarations)
                                     .replace("@PLAYER_NAME_LENGTH@", player))
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c11", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], check=True)
        return tuple(map(int, subprocess.run([str(path / "test")], capture_output=True, text=True,
                                             check=True).stdout.split()))


def packed_units(name):
    """The units tools/msgenc makes of a {TRNAME} name, terminator included:
    the marker, nine bits a character in fifteen-bit units, and 0xFFFF."""
    bits = 9 * len(name)
    return 1 + bits // 15 + (bits % 15 > 1) + 1


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

    def test_the_first_silver_is_konefr_s(self):
        """Cherrygrove fights the Passerby Boy 495-497 (scr_seq_0850_T21.s);
        konefr's L7, difficulty 40 and Potion were written on 2, 3 and 265,
        which no script fights, and are carried to the Boy one species for
        one. The Boy keeps his class, name and lines."""
        script = (ROOT / "files/fielddata/script/scr_seq/scr_seq_0850_T21.s").read_text()
        self.assertEqual(re.findall(r"TrainerBattle (TRAINER_\w+)", script),
                         ["TRAINER_PASSERBY_BOY_2", "TRAINER_PASSERBY_BOY_3", "TRAINER_PASSERBY_BOY"])
        for boy, silver in ((495, 265), (496, 2), (497, 3)):
            self.assertEqual(self.trainers[boy]["party"], self.trainers[silver]["party"], boy)
            self.assertEqual(self.trainers[boy]["party"][0]["level"], 7, boy)
            self.assertEqual(self.trainers[boy]["items"], ["ITEM_POTION"], boy)
            self.assertEqual((self.trainers[boy]["class"], self.trainers[boy]["name"]),
                             ("TRAINERCLASS_PASSERBY", "{TRNAME}Boy"), boy)

    def test_no_pokemon_under_the_moves_flag_is_left_without_moves(self):
        """konefr left 20 party entries without .moves under the moves flag;
        his build writes MOVE_NONE over all four slots and they can only
        Struggle. Each has the moves CreateMon made it with (InitBoxMonMoveset,
        which savedit.preset_moves runs on this tree's learnsets)."""
        empty = [(index, member["species"]) for index, trainer in enumerate(self.trainers)
                 if "MOVES" in trainer["type"] for member in trainer["party"] if not member["moves"]]
        self.assertEqual(empty, [])
        lickitung = next(member for member in self.trainers[391]["party"] if member["species"] == "SPECIES_LICKITUNG")
        self.assertEqual((lickitung["level"], lickitung["moves"]),
                         (24, ["MOVE_ROLLOUT", "MOVE_SUPERSONIC", "MOVE_WRAP", "MOVE_DISABLE"]))

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_moves_filled_in_are_the_learnsets_as_they_are_now(self):
        """The import writes the moves of the 20 entries konefr left without
        any into trainers.json; this is each one against the default-moveset
        rule (import_trainers.default_moves) on the tree's learnsets now, so
        a learnset changed after the import fails here until the trainers are
        imported again."""
        source = gmm.git_show(gmm.NEWGOLD, "data/Trainers.c")
        blocks = re.split(r"\n\s*\[(\d+)\] = \{", source)
        filled = []
        for index, block in ((int(blocks[i]), blocks[i + 1]) for i in range(1, len(blocks), 2)):
            if "TRAINER_DATA_TYPE_MOVES" not in re.search(r"\.trainerType\s*=\s*([^,]+),", block)[1]:
                continue
            for slot, member in enumerate(import_trainers.party_members(block)):
                named = re.findall(r"\bMOVE_\w+", import_trainers.section(member, "moves")) if ".moves = {" in member else []
                if set(named) <= {"MOVE_NONE"}:
                    filled.append(self.trainers[index]["party"][slot])
        self.assertEqual(len(filled), 20)
        for member in filled:
            self.assertEqual(member["moves"], import_trainers.default_moves(member["species"], member["level"]),
                             f"{member['species']} L{member['level']}")

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_every_held_item_konefr_names_is_held(self):
        """His trainerdatagen writes a party Pokemon's .item only under
        TRAINER_DATA_TYPE_ITEMS, and three trainers name items without it:
        Chow's and Edmond's Oran Berries, Nob's Sitrus Berry and Black Belt.
        Here every item he names is held; a fourth trainer without the flag
        fails, to be looked at and noted."""
        source = gmm.git_show(gmm.NEWGOLD, "data/Trainers.c")
        blocks = re.split(r"\n\s*\[(\d+)\] = \{", source)
        unflagged = set()
        for index, block in ((int(blocks[i]), blocks[i + 1]) for i in range(1, len(blocks), 2)):
            named = [re.search(r"\.item\s*=\s*(ITEM_\w+)", member) for member in import_trainers.party_members(block)]
            named = [import_trainers.native(item[1]) if item else "ITEM_NONE" for item in named]
            if set(named) <= {"ITEM_NONE"}:
                continue
            if "TRAINER_DATA_TYPE_ITEMS" not in re.search(r"\.trainerType\s*=\s*([^,]+),", block)[1]:
                unflagged.add(index)
            self.assertIn("ITEM", self.trainers[index]["type"], index)
            self.assertEqual([member["item"] for member in self.trainers[index]["party"]], named, index)
        self.assertEqual(unflagged, {43, 52, 251})
        self.assertEqual([member["item"] for member in self.trainers[251]["party"]],
                         ["ITEM_SITRUS_BERRY", "ITEM_BLACK_BELT"])

    def test_a_double_battle_engages_by_sight_only_a_player_who_can_fight_it(self):
        """TryGetSeenByNpcTrainers, GetEngagingTrainerParams and the
        battle-type checks, run on the host for each battle type with a player
        who can fight a double (two usable Pokemon) and one who cannot. A
        double with a partner (TRAINER_BATTLE_DOUBLE) walks up with him; one
        without (Mark's and Nelson's, TRAINER_BATTLE_DOUBLE_NO_PARTNER) walks up
        alone, as a single trainer does -- looking for a partner who is not on
        the map asserted and read a null object. Neither sees a player with one
        usable Pokemon: this port's battle cannot run a double with one, it
        asserts in Party_GetMonByIndex, and talking to them gives only the
        intro (scr_seq_0953: TrainerIsDoubleBattle, PartyCheckForDouble)."""
        header = (ROOT / "include/unk_020632B0.h").read_text()
        record = re.search(r"typedef struct EngagingTrainer \{.*?\} EngagingTrainer;", header, re.S)[0]
        manager = (ROOT / "src/script_manager.c").read_text()
        sight = (ROOT / "src/trainer_sight.c").read_text()
        program = "\n".join([
            "#include <stdint.h>", "#include <stdio.h>", '#include "constants/std_script.h"',
            "typedef uint16_t u16; typedef uint32_t u32; typedef int BOOL; enum { FALSE, TRUE };",
            "typedef struct LocalMapObject { int partner; } LocalMapObject;",
            "typedef struct MapObjectManager MapObjectManager; typedef struct PlayerAvatar PlayerAvatar;",
            "typedef struct FieldSystem { MapObjectManager *mapObjectManager; PlayerAvatar *playerAvatar; } FieldSystem;",
            "enum { TRATTR_DOUBLEBTL = 1 };",
            record, re.search(r"^enum \{\n    ENGAGED_.*?^\};", sight, re.S | re.M)[0],
            "static int battleType, asserts, walks, engaged[2] = {-1, -1};",
            "static LocalMapObject trainer = {0}, partner = {1};",
            "static u32 MapObject_GetScriptID(LocalMapObject *object) { return 3000 + object->partner; }",
            "static u16 ScriptNumToTrainerNum(u16 script) { return script - 2999; }",
            "static int TrainerData_GetAttr(u32 trainer, int attr) { return attr == TRATTR_DOUBLEBTL ? battleType : -1; }",
            "static void GF_AssertFail(void) { asserts++; }",
            "static void StartMapSceneScript(FieldSystem *f, u16 script, LocalMapObject *o) { walks++; }",
            "static void FieldSystem_SetEngagedTrainer(FieldSystem *f, LocalMapObject *o, int a2, int a3, int a4, int trainerId, int type, int idx) { engaged[idx] = type; }",
            # The partner of a TRAINER_BATTLE_DOUBLE trainer is on the map; nobody else is.
            "static LocalMapObject *sub_02064520(FieldSystem *f, MapObjectManager *m, LocalMapObject *o, u32 trainerNum) {",
            "    if (battleType != TRAINER_BATTLE_DOUBLE) { GF_AssertFail(); return 0; }",
            "    return &partner;",
            "}",
            "void GetEngagingTrainerParams(EngagingTrainer *trainer, LocalMapObject *object, int unk0, int unk4);",
            # One trainer sees the player: the second look finds nobody.
            "static BOOL CheckSeenByNpcTrainers(FieldSystem *f, MapObjectManager *m, PlayerAvatar *p, LocalMapObject *excluded, EngagingTrainer *record) {",
            "    if (excluded) return FALSE;",
            "    GetEngagingTrainerParams(record, &trainer, 0, 0);",
            "    return TRUE;",
            "}",
            function(manager, "TrainerNumIsDouble"), function(manager, "TrainerNumHasDoublePartner"),
            function(sight, "GetEngagingTrainerParams"), function(sight, "TryGetSeenByNpcTrainers"),
            "int main(void) {",
            "    static const int types[] = {TRAINER_BATTLE_SINGLE, TRAINER_BATTLE_DOUBLE, TRAINER_BATTLE_DOUBLE_NO_PARTNER};",
            "    FieldSystem fieldSystem = {0, 0};",
            "    for (int i = 0; i < 3; i++) {",
            "        for (int eligible = 0; eligible < 2; eligible++) {",
            "            battleType = types[i]; asserts = walks = 0; engaged[0] = engaged[1] = -1;",
            "            BOOL seen = TryGetSeenByNpcTrainers(&fieldSystem, eligible);",
            "            printf(\"%d:%d %d %d %d %d %d\\n\", battleType, eligible, seen, walks, engaged[0], engaged[1], asserts);",
            "        }",
            "    }",
            "    return 0;",
            "}"])
        with tempfile.TemporaryDirectory(prefix="newgold-sight-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-unused-parameter",
                "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
            output = subprocess.run([str(path / "test")], capture_output=True, text=True, check=True).stdout
        # battle type:can fight a double -> seen, walks up, the two engaged
        # records' types (0 alone, 1 with a partner, -1 none), asserts.
        self.assertEqual(output.splitlines(), [
            "0:0 1 1 0 -1 0", "0:1 1 1 0 -1 0",  # single
            "2:0 0 0 -1 -1 0", "2:1 1 1 1 1 0",  # double with a partner
            "3:0 0 0 -1 -1 0", "3:1 1 1 0 -1 0",  # double without one
        ])

    def test_nelson_and_mark_are_doubles_without_a_partner(self):
        """konefr made Nelson #389 DOUBLE_BATTLE, the two-trainer kind, but he
        stands alone on Route 39 with single-battle lines; he made Mark #395
        NO_PARTNER_DOUBLE_BATTLE after meeting the same thing, and Nelson is
        corrected to it. A double prints the defeat line from
        TRMSG_DBL_LOSE_1, where both have their retail TRMSG_LOSE retyped."""
        route = json.loads((ROOT / "files/fielddata/eventdata/zone_event/040_R39.json").read_text())
        self.assertEqual([o["scriptId"] for o in route["objects"] if "NELSON" in str(o["scriptId"])],
                         ["std_trainer(TRAINER_PSYCHIC_M_NELSON)"])
        subscript = (ROOT / "files/battledata/script/subscript/subscript_0004_BattleWin.s").read_text()
        doubles = subscript[subscript.index("\n_TRAINER_LOSE_MSG_MULTI:"):]
        self.assertIn("TRAINER_MESSAGE_LOSE_1\n", doubles[:doubles.index("GoTo")])
        trtbl = wotbl.read_narc((ROOT / "files/poketool/trmsg/trtbl.narc").read_bytes())[0][0]
        rows = {struct.unpack_from("<HH", trtbl, at) for at in range(0, len(trtbl), 4)}
        for index, line in ((389, "Ooh, your Pokémon have potential.\\n"), (395, "I was wrong.\\n")):
            self.assertEqual(self.trainers[index]["double"], 3, index)
            self.assertIn({"type": "TRMSG_DBL_LOSE_1", "message": line}, self.trainers[index]["messages"])
            self.assertEqual([m["type"] for m in self.trainers[index]["messages"]],
                             ["TRMSG_INTRO", "TRMSG_DBL_LOSE_1", "TRMSG_AFTER"])
            self.assertIn((index, 4), rows)       # TRMSG_DBL_LOSE_1
            self.assertNotIn((index, 1), rows)    # TRMSG_LOSE

    def test_samantha_s_lines_name_her_persian(self):
        """konefr's eb4e20f17 made Beauty Samantha #70's Meowth a Persian with
        the same moves and her other Meowth a Wigglytuff; her retail lines,
        which he left alone, still said MEOWTH. Here they name the Persian;
        the engine layer's, whose party is two Meowth, keep MEOWTH."""
        samantha = self.trainers[70]
        self.assertEqual([m["species"] for m in samantha["party"]], ["SPECIES_PERSIAN", "SPECIES_WIGGLYTUFF"])
        lines = [m["message"] for m in samantha["messages"]]
        self.assertEqual(lines[1:], ["No!\\nOh, PERSIAN, I’m so sorry!\\n",
                                     "I taught PERSIAN moves for taking\\non any type...\\n"])
        self.assertIn("No!\\nOh, PERSIAN, I’m so sorry!\\n", [row["text"] for row in gmm.read(728)])
        if REFERENCE is not None:
            engine = [text for trainer, _, text in import_trainer_text.generate(gmm.ENGINE)[1] if trainer == 70]
            self.assertIn("I taught MEOWTH moves for taking\\non any type...\\n", engine)

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
        stays where it was. Two in konefr's table carried one, Morty's
        Annihilape Rage Fist and Issac's Whismur Echoed Voice; a move given its
        effect here (import_moves.IMPLEMENTED_HERE) is theirs again."""
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
        # The engine's 79, less the ones given their effect here.
        self.assertEqual(len(listed), 79 - len(import_moves.IMPLEMENTED_HERE))
        carried = {(index, member["species"], move) for index, trainer in enumerate(self.trainers)
                   for member in trainer["party"] for move in member.get("moves", []) if move in listed}
        self.assertEqual(carried, {entry for entry in {(31, "SPECIES_ANNIHILAPE", "MOVE_RAGE_FIST"),
                                                       (391, "SPECIES_WHISMUR", "MOVE_ECHOED_VOICE")}
                                   if entry[2][len("MOVE_"):] not in import_moves.IMPLEMENTED_HERE})

    @unittest.skipIf(REFERENCE is None, "the reference checkout is not here")
    def test_the_unimplemented_moves_are_the_engine_s(self):
        """The flag in the move table is the importer's reading of d0380a487's
        data/Moves.c, bar the moves given their effect here; konefr flags the
        same 79."""
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
                       if "FLAG_UNUSABLE_UNIMPLEMENTED" in import_moves.named_flags(block)
                       and name not in import_moves.IMPLEMENTED_HERE}
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

    def test_every_name_fits_the_record_it_is_copied_into(self):
        """EnemyTrainerSet_Init copies a name from bank 729 into Trainer.name,
        and one that does not fit is not copied at all: 'You defeated' then
        read whatever the stack held. Retail's eight units hold ten packed
        characters; konefr's Pippo Franco is nine units and the terminator,
        Pietro Pacciani ten and it. The record keeps retail's layout."""
        units, name, win, size = trainer_layout()
        self.assertEqual((name, win, size), (0x14, 0x24, 0x34))
        init = function((ROOT / "src/trainer_data.c").read_text(), "EnemyTrainerSet_Init")
        self.assertIn("battleSetup->trainer[i].name, TRAINER_NAME_LENGTH + 1);", init)
        self.assertEqual(units, int(re.search(r"#define TRAINER_NAME_LENGTH\s+(\d+)",
                                              (ROOT / "include/trainer_data.h").read_text())[1]) + 1)
        for index, trainer in enumerate(self.trainers):
            self.assertTrue(trainer["name"].startswith("{TRNAME}"), index)
            self.assertLessEqual(packed_units(trainer["name"][len("{TRNAME}"):]), units, trainer["name"])
        self.assertEqual(packed_units("Pietro Pacciani"), 11)

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
