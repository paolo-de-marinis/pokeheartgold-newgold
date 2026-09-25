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


if __name__ == "__main__":
    unittest.main()
