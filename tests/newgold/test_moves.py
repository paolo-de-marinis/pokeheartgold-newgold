#!/usr/bin/env python3
"""Check the move table and the moves added to it.

Move data is read by index out of one archive, so a record in the wrong place
gives some other move's power and type. The names and descriptions are read
the same way out of their own archives, and nothing checks that the three
agree with each other.
"""

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

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness", "devkit/diag")]
import import_moves  # noqa: E402

LAST_RETAIL = 467

REFERENCE = Path(os.environ.get(
    "NEWGOLD_REFERENCE", "/home/paolo/Porting HGSS/hg-engine-newgold-reference"))


def constants(path, prefix):
    text = (ROOT / path).read_text()
    return {m[1]: int(m[2]) for m in
            re.finditer(r"#define (" + prefix + r"[A-Z0-9_]+)\s+(\d+)\s*$", text, re.M)}


def rows(name):
    text = (ROOT / "files/msgdata/msg" / name).read_text()
    return re.findall(r'<row id="[^"]+" index="(\d+)">', text)


class MoveTests(unittest.TestCase):
    def setUp(self):
        self.moves = constants("include/constants/moves.h", "MOVE_")
        self.table = import_moves.read_table()
        # Everything numbered past retail: the reference's moves, brought in
        # by tools/newgold/import/import_moves.py.
        self.added = {name[len("MOVE_"):]: number for name, number in self.moves.items()
                      if number > LAST_RETAIL}

    def test_the_archive_regenerates_byte_for_byte(self):
        """The importer rebuilds the whole archive, so it has to rebuild the
        part it did not touch exactly as it found it."""
        self.assertEqual(import_moves.write_table(self.table),
                         import_moves.TABLE.read_bytes())

    def test_every_move_has_a_record(self):
        highest = max(self.moves.values())
        self.assertEqual(len(self.table), highest + 1)
        for record in self.table:
            self.assertEqual(len(record), import_moves.RECORD_SIZE)

    def test_the_added_moves_are_numbered_after_retail(self):
        self.assertEqual(sorted(self.added.values()),
                         list(range(LAST_RETAIL + 1, LAST_RETAIL + 1 + len(self.added))))

    def test_retail_moves_sit_at_their_numbers(self):
        # A few whose numbers anything shifted by one record would spoil.
        # Thunderbolt is hg-engine's 90, not HeartGold's 95.
        types = constants("include/constants/pokemon.h", "TYPE_")
        for name, power, type_, pp in (("POUND", 40, "TYPE_NORMAL", 35),
                                       ("THUNDERBOLT", 90, "TYPE_ELECTRIC", 15),
                                       ("SHADOW_FORCE", 120, "TYPE_GHOST", 5)):
            _, _, gotPower, gotType, _, gotPP = struct.unpack(
                import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])[:6]
            self.assertEqual((gotPower, gotType, gotPP), (power, types[type_], pp), name)

    def test_every_added_move_is_usable(self):
        effects = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
        scripts = {int(re.match(r"effect_script_(\d+)", p.stem).group(1)) for p in
                   (ROOT / "files/battledata/script/effect_script").glob("effect_script_*.s")}
        for name, index in sorted(self.added.items(), key=lambda pair: pair[1]):
            effect, split, power, type_, accuracy, pp = struct.unpack(
                import_moves.RECORD, self.table[index])[:6]
            self.assertIn(effect, effects.values(), name)
            self.assertIn(effect, scripts, f"{name} has no effect script")
            self.assertLess(split, 3, name)
            self.assertLessEqual(power, 250, name)
            self.assertLessEqual(accuracy, 100, name)
            self.assertTrue(1 <= pp <= 40, name)

    def test_the_settings_the_reference_runs_under_are_the_ones_read(self):
        """Three of the added moves have a value written as a choice, and the
        reference's own configuration settles it. Reading the other branch
        would give a weaker Hyper Drill and a Moonblast that lowers Sp. Atk
        three times as often."""
        expected = {"HYPER_DRILL": ("power", 120), "PSYSHIELD_BASH": ("power", 90),
                    "MOONBLAST": ("effectChance", 10)}
        field = {"power": 2, "effectChance": 6}
        for name, (key, value) in expected.items():
            record = struct.unpack(import_moves.RECORD, self.table[self.added[name]])
            self.assertEqual(record[field[key]], value, f"{name} {key}")

    # Four retail moves the same settings move off their HeartGold values, and
    # the three the settings leave alone. Pinned here; checked against the
    # reference itself below when the checkout is there.
    CHAMPIONS_RETAIL = {"GROWTH": dict(type=12, pp=20),
                        "CRABHAMMER": dict(power=100, accuracy=95),
                        "BONE_RUSH": dict(power=30, accuracy=90),
                        "IRON_HEAD": dict(effectChance=20)}
    CHAMPIONS_UNMOVED = {"PROTECT": dict(pp=10), "SANDSTORM": dict(pp=10),
                         "NIGHT_SLASH": dict(pp=15)}
    FIELD = {"power": 2, "type": 3, "accuracy": 4, "pp": 5, "effectChance": 6}

    def test_retail_priorities_are_the_later_games(self):
        """Pinned without the reference: what hg-engine gives the seven retail
        moves whose bracket changed after Generation IV."""
        wanted = {"PROTECT": 4, "DETECT": 4, "ENDURE": 4, "FAKE_OUT": 3,
                  "EXTREME_SPEED": 2, "FOLLOW_ME": 2, "TELEPORT": -6}
        for name, priority in wanted.items():
            record = struct.unpack(import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])
            self.assertEqual(record[8], priority, name)

    def test_sweet_scent_lowers_evasion_by_two(self):
        record = struct.unpack(import_moves.RECORD, self.table[self.moves["MOVE_SWEET_SCENT"]])
        self.assertEqual(record[0], 64)
        script = (ROOT / "files/battledata/script/effect_script/effect_script_0064.s").read_text()
        self.assertIn("MOVE_SUBSCRIPT_PTR_EVASION_DOWN_2_STAGES", script)

    def test_howl_is_the_engine_s_rise_for_the_user_s_side(self):
        ranges = import_moves.constants("include/constants/moves.h", "RANGE_")
        effects = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
        record = struct.unpack(import_moves.RECORD, self.table[self.moves["MOVE_HOWL"]])
        self.assertEqual((record[0], record[7]), (effects["MOVE_EFFECT_HOWL"], ranges["RANGE_USER_SIDE"]))

    def test_poison_gas_and_cotton_spore_hit_both_foes(self):
        ranges = import_moves.constants("include/constants/moves.h", "RANGE_")
        for name in ("POISON_GAS", "COTTON_SPORE"):
            record = struct.unpack(import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])
            self.assertEqual(record[7], ranges["RANGE_ADJACENT_OPPONENTS"], name)

    def test_the_four_retail_moves_the_settings_move(self):
        """CHAMPIONS_PP_CHANGES is off and the other four are on, so of the
        seven retail moves the reference writes as a choice, four take a value
        this game did not have: a Grass-type Growth, a 95-accuracy Crabhammer,
        a 30-power Bone Rush and an Iron Head that flinches one time in five."""
        for name, wanted in {**self.CHAMPIONS_RETAIL, **self.CHAMPIONS_UNMOVED}.items():
            record = struct.unpack(import_moves.RECORD, self.table[self.moves[f"MOVE_{name}"]])
            for key, value in wanted.items():
                self.assertEqual(record[self.FIELD[key]], value, f"{name} {key}")

    # Where a retail record is not hg-engine's, and why. Everything else in
    # 1..467 -- type, power, accuracy, PP, effect chance, priority, effect, and
    # the seven flag bits both games name -- is the engine's (d0380a487).
    RETAIL_EXCEPTIONS = {
        ("CONVERSION_2", "target"): "the engine's aims at every adjacent Pokemon with Generation "
                                    "IV's command; Generation V's single target and command are "
                                    "not written",
    }

    @unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")
    def test_retail_records_are_hg_engine_s(self):
        """Fairy is 9 there and 18 here, so a type is compared by name; an
        effect up to 276 by number, where both trees keep retail's scripts,
        and past it by name, where each numbered its own."""
        engine = import_moves.gmm.ENGINE
        import_moves.read_conditions(REFERENCE)
        blocks = import_moves.records_in(import_moves.gmm.git_show(engine, "data/Moves.c", REFERENCE))
        numbers = {int(value): name for name, value in re.findall(
            r"^#define MOVE_([A-Z0-9_]+)\s+(\d+)\s*$",
            import_moves.gmm.git_show(engine, "include/constants/moves.h", REFERENCE), re.M)
            if name in blocks}
        theirs = {name: int(value) for name, value in re.findall(
            r"^#define (MOVE_EFFECT_[A-Z0-9_]+)\s+(\d+)\s*$",
            import_moves.gmm.git_show(engine, "include/constants/move_effects.h", REFERENCE), re.M)}
        ours = constants("include/constants/move_effects.h", "MOVE_EFFECT_")
        types = constants("include/constants/pokemon.h", "TYPE_")
        ranges = import_moves.constants("include/constants/moves.h", "RANGE_")
        named = sum(1 << bit for bit in import_moves.FLAG_BITS.values())
        for move in range(1, LAST_RETAIL + 1):
            name, block = numbers[move], blocks[numbers[move]]
            effect = import_moves.field(block, "effect")
            record = struct.unpack(import_moves.RECORD, self.table[move])
            wanted = {
                "effect": (record[0], theirs[effect] if theirs[effect] <= import_moves.LAST_VANILLA_EFFECT
                           else ours[effect]),
                "power": (record[2], import_moves.number(block, "power")),
                "type": (record[3], types[import_moves.field(block, "type")]),
                "accuracy": (record[4], import_moves.number(block, "accuracy")),
                "pp": (record[5], import_moves.number(block, "pp")),
                "effectChance": (record[6], import_moves.number(block, "effectChance")),
                "priority": (record[8], import_moves.number(block, "priority")),
                "target": (record[7], import_moves.ranges(block, ranges)),
                "flags": (record[9] & named, sum(1 << import_moves.FLAG_BITS[flag]
                                                 for flag in import_moves.named_flags(block))),
            }
            for key, (got, want) in wanted.items():
                if (name, key) in self.RETAIL_EXCEPTIONS:
                    self.assertNotEqual(got, want, f"{name} {key} is the engine's now: drop the exception")
                else:
                    self.assertEqual(got, want, f"{name} {key}")

    @unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")
    def test_bit_5_is_the_engines_unimplemented_flag(self):
        """Every record, retail and added, carries bit 5 exactly when the
        engine names FLAG_UNUSABLE_UNIMPLEMENTED for the move; konefr flag the
        same seventy-nine. It used to be retail's King's Rock bit, which no
        longer decides anything."""
        flagged = set()
        for revision in (import_moves.gmm.ENGINE, import_moves.gmm.NEWGOLD):
            blocks = import_moves.records_in(import_moves.gmm.git_show(revision, "data/Moves.c", REFERENCE))
            names = {f"MOVE_{name}" for name, block in blocks.items()
                     if "FLAG_UNUSABLE_UNIMPLEMENTED" in import_moves.named_flags(block)}
            self.assertTrue(not flagged or names == flagged, revision)
            flagged = names
        self.assertEqual(len(flagged), 79)
        numbers = {self.moves[name] for name in flagged}
        carried = {move for move, record in enumerate(self.table)
                   if struct.unpack(import_moves.RECORD, record)[9] & 1 << 5}
        self.assertEqual(carried, numbers)

    def test_hidden_power_is_the_table_s_60(self):
        """hg-engine fixes Hidden Power at 60 in its damage calculation,
        whatever the IVs. Here the battle command and the AI still work out
        retail's 30 to 70 and pass it in, so CalcMoveDamage has to take the
        table's power for Hidden Power over the one it is given."""
        record = struct.unpack(import_moves.RECORD, self.table[self.moves["MOVE_HIDDEN_POWER"]])
        self.assertEqual(record[2], 60)
        source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        body = source[source.index("int CalcMoveDamage("):]
        choice = re.search(r"if \(([^\n]*)\) \{\n\s*movePower = BattleMoveTbl\(ctx, moveNo\)->power;\n"
                           r"\s*\} else \{\n\s*movePower = power;", body)
        self.assertIsNotNone(choice, "CalcMoveDamage no longer chooses between the table and its argument")
        self.assertIn("moveNo == MOVE_HIDDEN_POWER", choice.group(1))

    def test_fury_cutter_doubles_40_up_to_160(self):
        """hg-engine's Fury Cutter is 40 and counts three uses (40, 80, 160);
        retail's was 10 and counted five. Runs the real command."""
        self.assertEqual(struct.unpack(import_moves.RECORD, self.table[self.moves["MOVE_FURY_CUTTER"]])[2], 40)
        source = (ROOT / "src/battle/battle_command.c").read_text()
        command = source[source.index("BOOL BtlCmd_CalcFuryCutterPower("):]
        command = command[:command.index("\n}\n") + 3]
        program = """
            #include <assert.h>
            typedef int BOOL;
            #define FALSE 0
            typedef struct BattleSystem BattleSystem;
            typedef struct { struct { unsigned furyCutterCount : 3; } unk88; } BattleMon;
            typedef struct { BattleMon battleMons[4]; int battlerIdAttacker, moveNoCur, movePower; } BattleContext;
            typedef struct { int power; } MoveTbl;
            static MoveTbl table = { 40 };
            static MoveTbl *BattleMoveTbl(BattleContext *ctx, int move) { (void)ctx; (void)move; return &table; }
            static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
            static int secondStrike;
            static BOOL ParentalBond_IsSecondStrike(BattleContext *ctx) { (void)ctx; return secondStrike; }
        """ + command + """
            int main(void) {
                static const int power[] = { 40, 80, 160, 160, 160, 160 };
                BattleContext ctx = { .battlerIdAttacker = 1 };
                for (int use = 0; use < 6; use++) {
                    BtlCmd_CalcFuryCutterPower(0, &ctx);
                    assert(ctx.movePower == power[use]);
                }
                // Parental Bond's second strike is the same use: 40, 40.
                ctx.battleMons[1].unk88.furyCutterCount = 0;
                BtlCmd_CalcFuryCutterPower(0, &ctx);
                secondStrike = 1;
                BtlCmd_CalcFuryCutterPower(0, &ctx);
                assert(ctx.movePower == 40);
                return 0;
            }
        """
        with tempfile.TemporaryDirectory(prefix="newgold-fury-cutter-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", str(c), "-o", str(exe)],
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_hurricane_and_the_storms_answer_to_the_weather(self):
        """The reference (other_battle_calculators.c) drops Thunder and
        Hurricane to 50 in the sun, and lets Thunder, Hurricane and the three
        Storms through the rain without an accuracy roll."""
        source = (ROOT / "src/battle/battle_controller_player.c").read_text()
        for weather, then, want in (
                ("SUN_ALL", "hitChance = 50;", {"THUNDER", "HURRICANE"}),
                ("RAIN_ALL", "ctx->moveStatusFlag &= ~MOVE_STATUS_MISSED;",
                 {"THUNDER", "HURRICANE", "BLEAKWIND_STORM", "WILDBOLT_STORM", "SANDSEAR_STORM"})):
            # The weather is the one the attacker's move sees (BattlerMoveWeather).
            found = re.findall(r"if \(\(?(?:weather|BattlerMoveWeather\(battleSystem, ctx, battlerIdAttacker\)) & FIELD_CONDITION_" + weather
                               + r"\)?\s*&&([^{]*)\{\s*" + re.escape(then), source)
            self.assertEqual(len(found), 1, weather)
            self.assertEqual(set(re.findall(r"MOVE_EFFECT_([A-Z_]+)", found[0])), want, weather)

    # Forty-one damaging moves carry no power, and the reference carries them
    # the same way, because the battle works the damage out instead: a Z-move
    # takes the power of the move it was made from, and five more take the
    # user's friendship or the target's health.
    POWER_AT_RUNTIME = {"GUARDIAN_OF_ALOLA", "NATURES_MADNESS", "PIKA_PAPOW",
                        "VEEVEE_VOLLEY", "HARD_PRESS"}

    def test_a_status_move_has_no_power_and_a_damaging_one_has_some(self):
        for name, index in self.added.items():
            if name.endswith(("_PHYSICAL", "_SPECIAL")) or name in self.POWER_AT_RUNTIME:
                continue
            _, split, power = struct.unpack(import_moves.RECORD, self.table[index])[:3]
            self.assertEqual(power == 0, split == 2, name)

    def test_the_three_message_banks_agree_with_the_table(self):
        last = str(len(self.table) - 1)
        for bank in ("msg_0749.gmm", "msg_0750.gmm", "msg_0751.gmm"):
            indices = rows(bank)
            self.assertEqual(len(indices), len(self.table), bank)
            self.assertEqual(indices[-1], last, bank)

    def test_a_move_s_text_is_hg_engine_s_for_the_same_move(self):
        """The text is hg-engine's, and past retail it is found by the move's
        name: Hone Claws is 471 there and 499 here. The retail renames, the
        opposing line and Hidden Power's description are the engine's."""
        text = {bank: [row["text"] for row in import_moves.gmm.read(bank)] for bank in (3, 749, 750, 751)}
        self.assertEqual(text[750][self.moves["MOVE_DOUBLE_SLAP"]], "Double Slap")
        self.assertEqual(text[750][self.moves["MOVE_FAINT_ATTACK"]], "Feint Attack")
        self.assertEqual(text[751][self.moves["MOVE_VICE_GRIP"]], "VISE GRIP")
        self.assertEqual(text[750][self.moves["MOVE_HONE_CLAWS"]], "Hone Claws")
        self.assertEqual(text[749][self.moves["MOVE_HIDDEN_POWER"]],
                         "A unique attack that\\nvaries in type\\ndepending on the\\nPokémon using it.")
        self.assertEqual(text[3][3 * self.moves["MOVE_POUND"] + 2],
                         "The opposing {STRVAR_1 1, 0, 0} used\\nPound!")
        self.assertEqual(text[3][3 * self.moves["MOVE_HONE_CLAWS"]],
                         "{STRVAR_1 1, 0, 0} used\\nHone Claws!")

    @unittest.skipUnless(REFERENCE.exists(), "the reference checkout is not here")
    def test_the_text_banks_are_what_the_importer_writes(self):
        """Every row of the five banks is `import_moves.py --text` at the
        engine revision, or at New Gold's for the rows konefr changed."""
        engine = import_moves.text_banks(import_moves.gmm.ENGINE)
        newgold = import_moves.text_banks(import_moves.gmm.NEWGOLD)
        for bank, texts in engine.items():
            rows = [row["text"] for row in import_moves.gmm.read(bank)]
            self.assertEqual(len(rows), len(texts), bank)
            for index, row in enumerate(rows):
                self.assertIn(row, (texts[index], newgold[bank][index]), f"bank {bank} row {index}")

    def test_every_added_move_borrows_an_animation_that_exists(self):
        """The animation archive stops where retail's moves stopped."""
        source = (ROOT / "src/battle/battle_command.c").read_text()
        body = re.search(r"static const u16 borrowed\[NUM_ADDED_MOVES\] = \{(.*?)\};", source, re.S).group(1)
        borrowed = re.findall(r"MOVE_[A-Z0-9_]+", body)
        self.assertEqual(len(borrowed), len(self.added))
        for move in borrowed:
            self.assertIn(move, self.moves, move)
            self.assertLessEqual(self.moves[move], LAST_RETAIL, move)


if __name__ == "__main__":
    unittest.main()
