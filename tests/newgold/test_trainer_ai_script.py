#!/usr/bin/env python3
"""The trainer AI's script (src/battle/trainer_ai_script.c) as the words it is.

Every line starts with the word index it sits at, and every jump or table
names in a comment the word it reaches, counted from the word after the
command's last argument. A word added or dropped moves everything after it,
so this checks each index and each reach against the words themselves.
"""

import re
import unittest

from test_level_cap import ROOT

SCRIPT = ROOT / "src/battle/trainer_ai_script.c"
LINE = re.compile(r"^\s*/\* ([0-9A-F]{4}) \*/ (.*?),(?:\s*//\s*(.*))?$")


def words():
    """{index: (words, comment)} for every line of the script array."""
    body = SCRIPT.read_text().split("const u32 ov10_02220AAC[] = {", 1)[1].split("\n};", 1)[0]
    lines, last = {}, None
    for line in body.splitlines():
        match = LINE.match(line)
        if match:
            last = int(match.group(1), 16)
            lines[last] = ([w.strip() for w in match.group(2).split(",")], match.group(3) or "")
        elif line.strip() and not line.strip().startswith("//"):
            # a table carried over several lines
            lines[last][0].extend(w.strip() for w in line.split("//")[0].split(",") if w.strip())
    return lines


def table(lines, index):
    """The words of the table at the index, up to its end."""
    script = lines[index][0]
    return script[:script.index("AI_TABLE_END")]


def follow(lines, start, stop, **given):
    """What the script adds to a move's score from start until it reaches stop
    or ends, run as the AI runs it with only the commands met here: given
    names the target's and the attacker's abilities, the move and its effect."""
    index, score, loaded = start, 0, None
    while index != stop:
        script = lines[index][0]
        op, args, after = script[0], script[1:], index + len(script)
        test = {"AI_IF_LOADED_EQUAL_TO": lambda: loaded == args[0],
                "AI_IF_LOADED_NOT_EQUAL_TO": lambda: loaded != args[0],
                "AI_IF_LOADED_IN_TABLE": lambda: loaded in table(lines, after + int(args[0])),
                "AI_IF_LOADED_NOT_IN_TABLE": lambda: loaded not in table(lines, after + int(args[0])),
                "AI_IF_MOVE_EQUAL_TO": lambda: given["move"] == args[0],
                "AI_IF_CURRENT_MOVE_EFFECT_EQUAL_TO": lambda: given["effect"] == args[0],
                "AI_IF_CURRENT_MOVE_EFFECT_NOT_EQUAL_TO": lambda: given["effect"] != args[0],
                "AI_GOTO": lambda: True}.get(op)
        if test:
            index = after + int(args[-1]) if test() else after
            continue
        if op == "AI_LOAD_BATTLER_ABILITY":
            loaded = given[{"AI_BATTLER_TARGET": "target", "AI_BATTLER_ATTACKER": "attacker"}[args[0]]]
        elif op == "AI_LOAD_CURRENT_MOVE":
            loaded = given["move"]
        elif op == "AI_ADD_TO_MOVE_SCORE":
            score += int(args[0])
        elif op == "AI_POP_OR_END":
            return score
        else:
            raise AssertionError(f"{index:04X}: {op} is not followed here")
        index = after
    return score


def battle_list(name):
    """A move list of the battle's (overlay_12_0224E4FC.c), by its name."""
    source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
    return re.findall(r"MOVE_\w+", re.search(name + r"\[\] = \{(.*?)\};", source, re.S).group(1))


class TrainerAIScriptTests(unittest.TestCase):
    def test_every_index_and_every_reach_is_the_words(self):
        lines = words()
        at = 0
        for index in sorted(lines):
            self.assertEqual(index, at, f"line {index:04X}")
            script, comment = lines[index]
            at = index + len(script)
            if index < 0x20:
                continue
            reaches = [int(n, 16) for n in re.findall(r"(?:->|table) ([0-9A-F]{4})", comment)]
            offsets = [int(w) for w in script[1:] if re.fullmatch(r"-?\d+", w)][-len(reaches):] if reaches else []
            self.assertEqual([at + o for o in offsets], reaches, f"line {index:04X}: {script} // {comment}")

    def test_every_absorbing_ability_reaches_its_type_check(self):
        # Flag 0 marks down a move the target's ability swallows
        # (BattleContext_CheckMoveImmunityFromAbility). From the fifth
        # generation Lightning Rod and Storm Drain swallow their type as Volt
        # Absorb and Water Absorb do; Dry Skin, which retail's word 0049 meant
        # and asked as Levitate, takes Water, Earth Eater Ground, Well-Baked
        # Body Fire and Sap Sipper Grass. Each goes to a check of the move's
        # type that takes 12 off its score.
        lines = words()

        def reach(index):
            script, _ = lines[index]
            return index + len(script) + int(script[-1])

        def type_check(index):
            self.assertEqual(lines[index][0], ["AI_LOAD_TYPE_FROM", "4"])
            self.assertEqual(reach(index + 2), 0x09DD)
            return lines[index + 2][0][1]

        self.assertEqual(lines[0x0035][0], ["AI_LOAD_BATTLER_ABILITY", "AI_BATTLER_TARGET"])
        absorbers = {}
        index = 0x0037
        while lines[index][0][0] == "AI_IF_LOADED_EQUAL_TO":
            absorbers[lines[index][0][1]] = reach(index)
            index += 3
        self.assertEqual(lines[index][0][0], "AI_GOTO")
        index = reach(index)
        while lines[index][0][0] == "AI_IF_LOADED_EQUAL_TO":
            absorbers[lines[index][0][1]] = reach(index)
            index += 3
        self.assertEqual(lines[index][0][0], "AI_GOTO")
        self.assertEqual(reach(index), 0x0079)
        for ability, kind in (("ABILITY_VOLT_ABSORB", "TYPE_ELECTRIC"), ("ABILITY_MOTOR_DRIVE", "TYPE_ELECTRIC"),
                              ("ABILITY_LIGHTNINGROD", "TYPE_ELECTRIC"), ("ABILITY_WATER_ABSORB", "TYPE_WATER"),
                              ("ABILITY_STORM_DRAIN", "TYPE_WATER"), ("ABILITY_DRY_SKIN", "TYPE_WATER"),
                              ("ABILITY_FLASH_FIRE", "TYPE_FIRE"), ("ABILITY_WELL_BAKED_BODY", "TYPE_FIRE"),
                              ("ABILITY_LEVITATE", "TYPE_GROUND"), ("ABILITY_EARTH_EATER", "TYPE_GROUND"),
                              ("ABILITY_SAP_SIPPER", "TYPE_GRASS")):
            self.assertEqual(type_check(absorbers[ability]), kind, ability)

    def test_a_ghost_type_is_not_held(self):
        # From the sixth generation nothing holds a Ghost-type
        # (Battler_HasGhostType): flag 0 marks Mean Look, Block, Spider Web
        # (PREVENT_ESCAPE) and Octolock down against one, a third type
        # included (command 52), and Octolock against a target already held.
        lines = words()

        def reach(index):
            script, _ = lines[index]
            return index + len(script) + int(script[-1])

        def ran(effect):
            """The lines flag 0 runs for a status move with the effect, from
            the jump that takes such a move on (002A) to the one that goes on
            to the sound checks (007E)."""
            index, out = reach(0x002A), []
            while index != 0x007E:
                script = lines[index][0]
                if script[0].startswith("AI_IF_CURRENT_MOVE_EFFECT_"):
                    taken = (script[1] == effect) != ("NOT" in script[0])
                    index = reach(index) if taken else index + len(script)
                elif script[0] == "AI_GOTO":
                    index = reach(index)
                else:
                    out.append(index)
                    index += len(script)
            return out

        self.assertEqual(ran("MOVE_EFFECT_DEF_DOWN"), [])
        for effect in ("MOVE_EFFECT_PREVENT_ESCAPE", "MOVE_EFFECT_OCTOLOCK"):
            held = next(i for i in ran(effect) if lines[i][0][:3] == ["AI_IF_VOLATILE_STATUS", "AI_BATTLER_TARGET", "0x4000000"])
            self.assertEqual(reach(held), 0x09DA, effect)
            at = next(i for i in ran(effect) if lines[i][0] == ["AI_FLAG_BATTLER_IS_TYPE", "AI_BATTLER_TARGET", "TYPE_GHOST"])
            self.assertEqual(lines[at + 3][0][:2], ["AI_IF_LOADED_EQUAL_TO", "1"])
            self.assertEqual(reach(at + 3), 0x09DA, effect)

    def test_teravolt_and_turboblaze_pass_abilities_by(self):
        # The battle takes Teravolt and Turboblaze for Mold Breaker
        # (AbilityBreaksMolds), and so does every check of flag 0 that lets
        # the attacker's Mold Breaker past the target's ability: each asks a
        # table of the three. Flag 7's line at 2508 is an ability worth having.
        lines = words()
        by_name = [i for i, (script, _) in lines.items() if script[0].startswith("AI_IF_LOADED") and "ABILITY_MOLD_BREAKER" in script]
        self.assertEqual(by_name, [0x2508])
        checks = [i for i, (script, _) in lines.items() if script[0] == "AI_IF_LOADED_IN_TABLE"
                  and table(lines, i + 3 + int(script[1])) == ["ABILITY_MOLD_BREAKER", "ABILITY_TERAVOLT", "ABILITY_TURBOBLAZE"]]
        self.assertLessEqual({0x0032, 0x0085, 0x0288, 0x03EE, 0x043C, 0x0448, 0x045A, 0x0490, 0x055C, 0x0630, 0x097E}, set(checks))
        # Soundproof's line, one of them: Growl on a Soundproof target is
        # marked down, unless the attacker passes the ability by.
        for attacker, score in (("ABILITY_NONE", -10), ("ABILITY_MOLD_BREAKER", 0),
                                ("ABILITY_TERAVOLT", 0), ("ABILITY_TURBOBLAZE", 0)):
            self.assertEqual(follow(lines, 0x007E, 0x00A9, target="ABILITY_SOUNDPROOF", attacker=attacker,
                                    move="MOVE_GROWL"), score, attacker)

    def test_soundproof_knows_every_sound_move(self):
        # Soundproof keeps every move of the battle's sound list off its
        # holder (sSoundMoves, BattleContext_CheckMoveImmunityFromAbility):
        # flag 0 marks each down against a Soundproof target, but the three
        # aimed at the user's side, and none when the attacker passes the
        # ability by. Retail knew eleven.
        lines = words()
        sound = battle_list("sSoundMoves")
        own_side = {"MOVE_HEAL_BELL", "MOVE_HOWL", "MOVE_CLANGOROUS_SOUL"}
        self.assertLessEqual(own_side, set(sound))
        for move in sound + ["MOVE_TACKLE"]:
            aimed = -10 if move in set(sound) - own_side else 0
            self.assertEqual(follow(lines, 0x007E, 0x00A9, target="ABILITY_SOUNDPROOF", attacker="ABILITY_NONE",
                                    move=move), aimed, move)
            self.assertEqual(follow(lines, 0x007E, 0x00A9, target="ABILITY_SOUNDPROOF", attacker="ABILITY_TERAVOLT",
                                    move=move), 0, move)

    def test_wind_rider_and_bulletproof_refuse_their_moves(self):
        # Wind Rider takes a wind move and Bulletproof refuses a ball or bomb
        # move (sWindMoves, sBallAndBombMoves): flag 0 takes 12 off the one,
        # as for the absorbing abilities, and 10 off the other, as for
        # Soundproof, unless the attacker passes the ability by. Sandstorm and
        # Tailwind are not aimed at the target, whose Wind Rider takes nothing
        # from them.
        lines = words()
        for ability, moves, left_out, score in (
                ("ABILITY_WIND_RIDER", battle_list("sWindMoves"), {"MOVE_SANDSTORM", "MOVE_TAILWIND"}, -12),
                ("ABILITY_BULLETPROOF", battle_list("sBallAndBombMoves"), set(), -10)):
            self.assertLessEqual(left_out, set(moves))
            for move in moves + ["MOVE_TACKLE"]:
                aimed = score if move in set(moves) - left_out else 0
                self.assertEqual(follow(lines, 0x007E, 0x00A9, target=ability, attacker="ABILITY_NONE", move=move),
                                 aimed, (ability, move))
                self.assertEqual(follow(lines, 0x007E, 0x00A9, target=ability, attacker="ABILITY_MOLD_BREAKER",
                                        move=move), 0, (ability, move))
                self.assertEqual(follow(lines, 0x007E, 0x00A9, target="ABILITY_NONE", attacker="ABILITY_NONE",
                                        move=move), 0, move)


if __name__ == "__main__":
    unittest.main()
