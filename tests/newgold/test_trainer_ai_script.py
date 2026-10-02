#!/usr/bin/env python3
"""The trainer AI's script (src/battle/trainer_ai_script.c) as the words it is.

Every line starts with the word index it sits at, and every jump or table
names in a comment the word it reaches, counted from the word after the
command's last argument. A word added or dropped moves everything after it,
so this checks each index and each reach against the words themselves.
"""

import functools
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
    names the target's and the attacker's abilities, the move, its effect
    and its type, the field's conditions and how many of the attacker's
    party could come in; it is the battle's first turn and the battler's
    first out, the target is a foe, and the move is a status move."""
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
                "AI_IF_FIELD_CONDITIONS_MASK": lambda: given["field"] & field(args[0]),
                "AI_IF_TARGET_IS_PARTNER": lambda: False,
                "AI_GOTO": lambda: True}.get(op)
        if test:
            index = after + int(args[-1]) if test() else after
            continue
        if op in ("AI_IF_TEMP_EQUAL_TO", "AI_IF_TEMP_NOT_EQUAL_TO"):
            index = after + int(args[-1]) if (loaded == args[0]) == (op == "AI_IF_TEMP_EQUAL_TO") else after
            continue
        if op == "AI_LOAD_BATTLER_ABILITY":
            loaded = given[{"AI_BATTLER_TARGET": "target", "AI_BATTLER_ATTACKER": "attacker"}[args[0]]]
        elif op == "AI_LOAD_CURRENT_MOVE":
            loaded = given["move"]
        elif op == "AI_LOAD_TYPE_FROM" and args[0] == "4":
            loaded = given["type"]
        elif op == "AI_FLAG_MOVE_DAMAGE_SCORE":
            loaded = "0"        # a status move is not compared
        elif op == "AI_LOAD_CURRENT_WEATHER":
            loaded = str(weather(given["field"]))
        elif op == "AI_LOAD_IS_FIRST_TURN_IN_BATTLE":
            loaded = "1"
        elif op == "AI_LOAD_TURN_COUNT":
            loaded = "0"
        elif op == "AI_COUNT_ALIVE_PARTY_BATTLERS":
            loaded = str(given["party"])
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


@functools.lru_cache(maxsize=None)
def field(expression):
    """The value of a field condition expression: FIELD_CONDITION_* names
    (constants/battle.h) and the script's AI_WEATHER_HOLDS."""
    text = (ROOT / "include/constants/battle.h").read_text() + SCRIPT.read_text()
    names = dict(re.findall(r"^#define ((?:FIELD_CONDITION|AI_WEATHER)_\w+)\s+(.+?)\s*(?://.*)?$", text, re.M))
    return eval(re.sub(r"[A-Z][A-Z0-9_]*", lambda m: f"({field(names[m.group(0)])})", expression))


def weather(value):
    """What command 2E loads for the field (ov10_0221D594)."""
    number = 0
    for name, n in (("RAIN_ALL", 2), ("SANDSTORM_ALL", 3), ("SUN_ALL", 1), ("HAIL_ALL", 4), ("SNOW_ALL", 4), ("FOG", 5)):
        if value & field("FIELD_CONDITION_" + name):
            number = n
    return number


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
        # Body Fire and Sap Sipper Grass, and New Gold's Irrigation and
        # Evaporate Water. Each goes to a check of the move's type that takes
        # 12 off its score.
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
        while True:
            while lines[index][0][0] == "AI_IF_LOADED_EQUAL_TO":
                absorbers[lines[index][0][1]] = reach(index)
                index += 3
            self.assertEqual(lines[index][0][0], "AI_GOTO")
            if reach(index) == 0x0079:
                break
            index = reach(index)
        for ability, kind in (("ABILITY_VOLT_ABSORB", "TYPE_ELECTRIC"), ("ABILITY_MOTOR_DRIVE", "TYPE_ELECTRIC"),
                              ("ABILITY_LIGHTNINGROD", "TYPE_ELECTRIC"), ("ABILITY_WATER_ABSORB", "TYPE_WATER"),
                              ("ABILITY_STORM_DRAIN", "TYPE_WATER"), ("ABILITY_DRY_SKIN", "TYPE_WATER"),
                              ("ABILITY_FLASH_FIRE", "TYPE_FIRE"), ("ABILITY_WELL_BAKED_BODY", "TYPE_FIRE"),
                              ("ABILITY_LEVITATE", "TYPE_GROUND"), ("ABILITY_EARTH_EATER", "TYPE_GROUND"),
                              ("ABILITY_SAP_SIPPER", "TYPE_GRASS"), ("ABILITY_IRRIGATION", "TYPE_WATER"),
                              ("ABILITY_EVAPORATE", "TYPE_WATER")):
            self.assertEqual(type_check(absorbers[ability]), kind, ability)

    def test_a_status_move_an_ability_swallows_is_marked_down(self):
        # BattleContext_CheckMoveImmunityFromAbility swallows a status move
        # of the ability's type aimed at the holder as it swallows a damaging
        # one: flag 0 takes 12 off it as off a damaging one, unless the
        # attacker passes the ability by. Before, a status move went from 002A
        # to the sound checks and missed every absorber: Sand Attack into
        # Earth Eater and Soak into Water Absorb scored 0, as did Thunder
        # Wave into Lightning Rod. A status move aimed at the user or the
        # field is not swallowed, nor Spikes by Earth Eater, nor anything by
        # Evaporate or Levitate. New Gold's Irrigation swallows Soak.
        from test_move_effects import moves, records
        lines = words()
        types = {int(n): name for name, n in re.findall(r"#define (TYPE_[A-Z]+)\s+(\d+)",
                                                        (ROOT / "include/constants/pokemon.h").read_text())}
        ranges = dict(re.findall(r"#define (RANGE_\w+)\s+\(?(?:1 << )?(\d+)\)?",
                                 (ROOT / "include/constants/moves.h").read_text()))
        not_a_foe = {1 << int(ranges[name]) for name in ("RANGE_USER", "RANGE_USER_SIDE", "RANGE_FIELD", "RANGE_OPPONENT_SIDE",
                                                         "RANGE_ALLY", "RANGE_SINGLE_TARGET_USER_SIDE")}
        absorbed = {"TYPE_ELECTRIC", "TYPE_WATER", "TYPE_FIRE", "TYPE_GROUND", "TYPE_GRASS"}
        names, data = {n: f"MOVE_{name}" for name, n in moves().items()}, records()
        kind = {names[n]: types[r[3]] for n, r in enumerate(data) if n in names}
        aimed = {names[n] for n, r in enumerate(data) if n in names and r[1] == 2 and types[r[3]] in absorbed
                 and r[7] not in not_a_foe}
        self.assertEqual(lines[0x2A2C][0][0], "AI_IF_LOADED_NOT_IN_TABLE")
        self.assertEqual(set(table(lines, 0x2A2F + int(lines[0x2A2C][0][1]))), aimed)
        takers = {"TYPE_ELECTRIC": ("ABILITY_VOLT_ABSORB", "ABILITY_MOTOR_DRIVE", "ABILITY_LIGHTNINGROD"),
                  "TYPE_WATER": ("ABILITY_WATER_ABSORB", "ABILITY_STORM_DRAIN", "ABILITY_DRY_SKIN", "ABILITY_IRRIGATION"),
                  "TYPE_FIRE": ("ABILITY_FLASH_FIRE", "ABILITY_WELL_BAKED_BODY"), "TYPE_GROUND": ("ABILITY_EARTH_EATER",),
                  "TYPE_GRASS": ("ABILITY_SAP_SIPPER",)}
        everyone = [a for group in takers.values() for a in group] + ["ABILITY_EVAPORATE", "ABILITY_LEVITATE", "ABILITY_NONE"]
        for move in sorted(aimed) + ["MOVE_CHARGE", "MOVE_AQUA_RING", "MOVE_RAIN_DANCE", "MOVE_SPIKES", "MOVE_SHORE_UP"]:
            for ability in everyone:
                score = -12 if move in aimed and ability in takers[kind[move]] else 0
                for attacker, expected in (("ABILITY_NONE", score), ("ABILITY_MOLD_BREAKER", 0), ("ABILITY_TURBOBLAZE", 0)):
                    self.assertEqual(follow(lines, 0x0028, 0x007E, target=ability, attacker=attacker, move=move,
                                            effect="?", type=kind[move], field=0, party=0), expected, (move, ability, attacker))

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
            to the sound checks (007E) or to the absorbing abilities (2A26,
            test_a_status_move_an_ability_swallows_is_marked_down)."""
            index, out = reach(0x002A), []
            while index not in (0x007E, 0x2A26):
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

    def test_snow_is_not_hail_where_they_part(self):
        # Command 2E reads snow as hail (4), which the moves snow changes as
        # hail does want; where the two part, the field itself is asked. Hail
        # replaces snow (effect script 164): flag 0 takes 8 off it as a repeat
        # only under hail, and flag 9 gives it its first-turn bonus under
        # snow. Snow hurts no one, so the Fly and Dig line at 1672 asks for
        # hail alone.
        lines = words()
        hail, snow = field("FIELD_CONDITION_HAIL"), field("FIELD_CONDITION_SNOW_TEMP")
        self.assertEqual(weather(snow), weather(hail))
        none = dict(target="ABILITY_NONE", attacker="ABILITY_NONE")
        self.assertEqual(follow(lines, 0x05CD, None, field=hail, **none), -8)
        self.assertEqual(follow(lines, 0x05CD, None, field=snow, **none), 0)
        self.assertEqual(follow(lines, 0x290A, None, field=hail), 0)
        self.assertEqual(follow(lines, 0x290A, None, field=snow), 5)
        script = lines[0x1672][0]
        self.assertEqual(script[0], "AI_IF_FIELD_CONDITIONS_MASK")
        self.assertTrue(field(script[1]) & hail and not field(script[1]) & snow)

    def test_a_weather_move_that_fails_is_marked_down(self):
        # A weather move fails under its own weather, under a strong weather,
        # which only another replaces, and under the weather the map brought
        # (effect scripts 115, 136, 137 and 164, Snowscape's subscript 339):
        # flag 0 takes 8 off it and flag 9 gives it no first-turn bonus.
        lines = words()
        holding = ("HEAVY_RAIN", "EXTREMELY_HARSH_SUNLIGHT", "STRONG_WINDS", "RAIN_PERMANENT", "SANDSTORM_PERMANENT",
                   "SUN_PERMANENT", "HAIL_PERMANENT", "SNOW_PERMANENT")
        none = dict(target="ABILITY_NONE", attacker="ABILITY_NONE")
        for effect, own, start in (("MOVE_EFFECT_WEATHER_SANDSTORM", "SANDSTORM", 0x052E),
                                   ("MOVE_EFFECT_WEATHER_RAIN", "RAIN", 0x058E),
                                   ("MOVE_EFFECT_WEATHER_SUN", "SUN", 0x05A7),
                                   ("MOVE_EFFECT_WEATHER_HAIL", "HAIL", 0x05CD),
                                   ("MOVE_EFFECT_WEATHER_SNOW", "SNOW_TEMP", 0x2987)):
            other = "SUN" if own == "RAIN" else "RAIN"
            for name, fails in ((None, False), (own, True), (other, False), *((h, True) for h in holding)):
                value = field("FIELD_CONDITION_" + name) if name else 0
                self.assertEqual(follow(lines, start, 0x007E, field=value, effect=effect, **none), -8 if fails else 0,
                                 (effect, name))
                self.assertEqual(follow(lines, 0x28E6, None, field=value, effect=effect), 0 if fails else 5,
                                 (effect, name))
        # Chilly Reception brings Snowscape's snow and then sends its user
        # back, which is worth the move whenever someone can come in.
        snow = field("FIELD_CONDITION_SNOW_TEMP")
        for party, value, score in ((0, snow, -8), (0, 0, 0), (1, snow, 0)):
            self.assertEqual(follow(lines, 0x2987, 0x007E, field=value, effect="MOVE_EFFECT_SNOW_AND_SWITCH",
                                    party=party, **none), score, (party, value))
        self.assertEqual(follow(lines, 0x28E6, None, field=snow, effect="MOVE_EFFECT_SNOW_AND_SWITCH"), 0)
        self.assertEqual(follow(lines, 0x28E6, None, field=0, effect="MOVE_EFFECT_SNOW_AND_SWITCH"), 5)
        # Every other move keeps flag 9's bonus unless the sun is up, as
        # retail's fell into Sunny Day's lines.
        for name, score in ((None, 5), ("SUN", 0), ("RAIN", 5), ("RAIN_PERMANENT", 5), ("HEAVY_RAIN", 5)):
            value = field("FIELD_CONDITION_" + name) if name else 0
            self.assertEqual(follow(lines, 0x28E6, None, field=value, effect="MOVE_EFFECT_HIT"), score, name)


if __name__ == "__main__":
    unittest.main()
