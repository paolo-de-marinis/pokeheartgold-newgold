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

    def test_lightning_rod_and_storm_drain_are_absorbing_abilities(self):
        # Flag 0 marks down a move the target's ability swallows. From the
        # fifth generation Lightning Rod and Storm Drain swallow their type as
        # Volt Absorb and Water Absorb do (BattleContext_CheckMoveImmunityFromAbility):
        # they go to the same type checks.
        lines = words()

        def reach(index):
            script, _ = lines[index]
            return index + len(script) + int(script[-1])

        def type_check(index):
            self.assertEqual(lines[index][0], ["AI_LOAD_TYPE_FROM", "4"])
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
                              ("ABILITY_STORM_DRAIN", "TYPE_WATER"), ("ABILITY_FLASH_FIRE", "TYPE_FIRE")):
            self.assertEqual(type_check(absorbers[ability]), kind, ability)


if __name__ == "__main__":
    unittest.main()
