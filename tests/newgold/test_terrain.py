#!/usr/bin/env python3
"""Check that a terrain can be laid, read and run out.

Terrain is a chain with five links and no link is worth anything on its own:
the move has to carry the effect whose script lays a terrain, that script has
to call the subscript that announces it, the command has to know which of the
four the move being used wants, the turn loop has to count it down, and the
subscript it runs at zero has to clear it again. Break any one and the terrain
either never appears or never leaves, and neither is visible from the compiler.
"""

import re
import unittest

from test_level_cap import ROOT
from test_move_effects import moves, records, rows

COMMANDS = ROOT / "src/battle/battle_command.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"
EFFECT_SCRIPTS = ROOT / "files/battledata/script/effect_script"
SUBSCRIPT_H = ROOT / "include/constants/battle_subscript.h"
EFFECTS_H = ROOT / "include/constants/move_effects.h"

# A terrain and the move that lays it are spelled the same, which is why one
# list does for both MOVE_<name> and the terrain value <name>.
TERRAINS = ("GRASSY_TERRAIN", "MISTY_TERRAIN", "ELECTRIC_TERRAIN", "PSYCHIC_TERRAIN")


def subscript_number(name):
    text = SUBSCRIPT_H.read_text()
    match = re.search(r"#define BATTLE_SUBSCRIPT_" + name + r"\s+(\d+)", text)
    assert match, f"BATTLE_SUBSCRIPT_{name} is not in {SUBSCRIPT_H}"
    return int(match.group(1))


def subscript(number):
    found = list(SUBSCRIPTS.glob(f"subscript_{number:04d}_*.s"))
    assert len(found) == 1, f"subscript {number} is {found}"
    return found[0].read_text()


def command_body(name):
    match = re.search(r"\nBOOL " + name + r"\([^)]*\) \{\n(.*?)\n\}\n",
                      COMMANDS.read_text(), re.S)
    assert match, f"{name} is not in {COMMANDS}"
    return match.group(1)


def overlay_function(name):
    match = re.search(r"\n[a-zA-Z_0-9 ]*\b" + name + r"\([^)]*\) \{\n(.*?)\n\}\n",
                      OVERLAY.read_text(), re.S)
    assert match, f"{name} is not in {OVERLAY}"
    return match.group(1)


def effect_script_of(move):
    return (EFFECT_SCRIPTS / f"effect_script_{records()[moves()[move]][0]:04d}.s").read_text()


class TerrainTests(unittest.TestCase):
    def test_the_four_moves_share_the_effect_that_lays_a_terrain(self):
        table = records()
        numbers = moves()
        effects = {name: table[numbers[name]][0] for name in TERRAINS}
        self.assertEqual(len(set(effects.values())), 1,
                         f"the terrain moves do not share one effect: {effects}")
        effect = next(iter(effects.values()))
        script = (EFFECT_SCRIPTS / f"effect_script_{effect:04d}.s").read_text()
        self.assertIn("UpdateTerrainOverlay", script)
        self.assertIn("BATTLE_SUBSCRIPT_CREATE_TERRAIN_OVERLAY", script)

    def test_the_command_knows_which_terrain_each_move_wants(self):
        body = command_body("BtlCmd_UpdateTerrainOverlay")
        for terrain in TERRAINS:
            self.assertRegex(body, r"case MOVE_" + terrain + r":\s*\n\s*terrainType = " + terrain + ";",
                             f"MOVE_{terrain} does not lay {terrain}")

    def test_the_turn_loop_counts_the_terrain_down_and_ends_it(self):
        text = CONTROLLER.read_text()
        self.assertIn("UFC_STATE_TERRAIN", text, "terrain is not in the field-condition loop")
        self.assertIn("ctx->terrainOverlayTurns--", text, "nothing counts the terrain down")
        self.assertIn("BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END", text,
                      "nothing runs the script that ends a terrain")

    def test_the_end_subscript_clears_every_terrain_it_names(self):
        text = subscript(subscript_number("HANDLE_TERRAIN_END"))
        for terrain in TERRAINS:
            self.assertIn(f"GotoIfTerrainOverlayIsType {terrain},", text,
                          f"the end script does not test for {terrain}")
        # One clear per terrain, or a terrain outlives the message saying it left.
        self.assertEqual(text.count("UpdateTerrainOverlay TRUE,"), len(TERRAINS))

    def test_both_terrain_scripts_print_messages_that_exist(self):
        bank = rows("msg_0197")
        for number in (subscript_number("CREATE_TERRAIN_OVERLAY"),
                       subscript_number("HANDLE_TERRAIN_END"),
                       subscript_number("PSYCHIC_TERRAIN_PROTECTION"),
                       subscript_number("ELECTRIC_TERRAIN_PROTECTION"),
                       subscript_number("MISTY_TERRAIN_PROTECTION")):
            text = subscript(number)
            printed = re.findall(r"PrintMessage (?:msg_0197_0*(\d+)|(\d+))", text)
            self.assertTrue(printed, f"subscript {number} prints nothing")
            for symbolic, raw in printed:
                message = int(symbolic or raw)
                self.assertIn(message, bank,
                              f"subscript {number} prints message {message}, "
                              f"which is not in msg_0197")


class TerrainRulesTests(unittest.TestCase):
    """What the terrain does to a move once one is down.

    The compiler cannot tell a terrain that is read from one that is ignored,
    so each rule is checked where it was written: the damage maths, the turn
    order, the move refusal, and the two effect scripts that were waiting on a
    terrain to exist.
    """

    def test_the_damage_maths_weighs_every_terrain(self):
        body = overlay_function("CalcMoveDamage")
        for terrain in TERRAINS:
            self.assertIn(f"case {terrain}:", body,
                          f"the damage maths ignores {terrain}")
        # Grassy Terrain muffles the three Ground moves that shake the ground.
        for move in ("MOVE_EARTHQUAKE", "MOVE_MAGNITUDE", "MOVE_BULLDOZE"):
            self.assertIn(move, body, f"the grass does not muffle {move}")

    def test_grassy_glide_is_hurried_by_the_grass(self):
        body = overlay_function("BattlerMovePriority")
        self.assertRegex(body, r"MOVE_GRASSY_GLIDE.*GRASSY_TERRAIN",
                         "Grassy Glide does not read the grass")

    def test_the_terrain_can_refuse_a_move(self):
        body = overlay_function("BattleContext_CheckMoveImmunityFromAbility")
        for name in ("PSYCHIC_TERRAIN_PROTECTION", "ELECTRIC_TERRAIN_PROTECTION",
                     "MISTY_TERRAIN_PROTECTION"):
            self.assertIn(f"BATTLE_SUBSCRIPT_{name}", body,
                          f"nothing ever runs {name}")
        # Rest is the effect the reference counts alongside the sleep moves, in
        # both the Electric and the Misty refusal; Sweet Veil and a Minior's
        # shell refuse it too.
        self.assertEqual(body.count("MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP"), 4,
                         "Sweet Veil, Shields Down and the two terrains should each count Rest")

    def test_psyblade_asks_the_terrain_for_its_power(self):
        text = effect_script_of("PSYBLADE")
        self.assertIn("GotoIfTerrainOverlayIsType ELECTRIC_TERRAIN", text)
        self.assertIn("BSCRIPT_VAR_MOVE_POWER, 120", text)

    def test_steel_roller_and_ice_spinner_sweep_the_terrain_away(self):
        text = effect_script_of("STEEL_ROLLER")
        self.assertEqual(text, effect_script_of("ICE_SPINNER"),
                         "the two moves no longer share one effect")
        self.assertIn("MOVE_SUBSCRIPT_PTR_END_TERRAIN", text)
        # Steel Roller alone fails with nothing to tear up.
        self.assertIn("MOVE_STEEL_ROLLER", text)
        self.assertIn("BATTLE_SUBSCRIPT_BUT_IT_FAILED", text)

    def test_the_side_effect_pointer_lands_on_the_end_terrain_script(self):
        """The pointer is an index into the table, so the two have to agree."""
        table = re.search(r"sMoveStatusChangeScripts\[\] = \{(.*?)\n\};",
                          OVERLAY.read_text(), re.S).group(1)
        entries = re.findall(r"BATTLE_SUBSCRIPT_[A-Z0-9_]+", table)
        pointer = re.search(r"#define MOVE_SUBSCRIPT_PTR_END_TERRAIN\s+(\d+)",
                            SUBSCRIPT_H.read_text())
        self.assertTrue(pointer, "MOVE_SUBSCRIPT_PTR_END_TERRAIN is not defined")
        self.assertEqual(entries[int(pointer.group(1))],
                         "BATTLE_SUBSCRIPT_HANDLE_TERRAIN_END")

    def test_defog_blows_the_terrain_away_too(self):
        text = subscript(subscript_number("DEFOG"))
        for terrain in TERRAINS:
            self.assertIn(f"GotoIfTerrainOverlayIsType {terrain},", text,
                          f"Defog does not clear {terrain}")
        self.assertEqual(text.count("UpdateTerrainOverlay TRUE,"), len(TERRAINS))


class TerrainAbilityTests(unittest.TestCase):
    """The abilities a terrain unlocks, and the state they keep."""

    SURGES = {
        "ABILITY_GRASSY_SURGE": "GRASSY_TERRAIN",
        "ABILITY_MISTY_SURGE": "MISTY_TERRAIN",
        "ABILITY_ELECTRIC_SURGE": "ELECTRIC_TERRAIN",
        "ABILITY_PSYCHIC_SURGE": "PSYCHIC_TERRAIN",
    }

    def test_each_surge_lays_its_own_terrain_on_the_way_in(self):
        body = overlay_function("TryAbilityOnEntry")
        for ability, terrain in self.SURGES.items():
            block = body[body.index(f"case {ability}:"):]
            self.assertEqual(re.search(r"terrainType = ([A-Z_]+);", block).group(1), terrain,
                             f"{ability} does not lay {terrain}")
        # Hadron Engine lays the same terrain Electric Surge does, and has a
        # second script for finding it already down.
        self.assertIn("case ABILITY_HADRON_ENGINE:", body)
        self.assertIn("BATTLE_SUBSCRIPT_HADRON_ENGINE_NO_TERRAIN_SETUP", body)

    def test_a_surge_announces_itself_once(self):
        # The Surges' only guard against acting twice is abilityActivatedFlag,
        # and their subscript shows the ability popup. A popup that cleared
        # the flag sent every battle with a Surge on the field into an endless
        # "An electric current ran across the battlefield!" (the species
        # check's battle walk, Tapu Koko and the others).
        text = COMMANDS.read_text()
        start = text.index("BOOL BtlCmd_AbilityPopup(")
        body = text[start:text.index("\n}\n", start)]
        self.assertNotIn("abilityActivatedFlag", body)

    def test_the_paradox_boost_is_read_wherever_a_stat_is_used(self):
        text = OVERLAY.read_text()
        for stat in ("STAT_ATK", "STAT_SPATK", "STAT_DEF", "STAT_SPDEF", "STAT_SPEED"):
            self.assertRegex(text, r"paradoxBoostedStat\[\w+\] == " + stat,
                             f"nothing reads a Paradox boost of {stat}")

    def test_the_paradox_commands_walk_every_battler(self):
        """Each rewinds onto itself so the next battler gets its own script."""
        for name in ("BtlCmd_ActivateParadoxAbility", "BtlCmd_ResetParadoxAbility"):
            body = command_body(name)
            self.assertIn("BattleScriptIncrementPointer(ctx, -2)", body,
                          f"{name} runs one battler and stops")
            self.assertIn("BattleScriptGotoSubscript(ctx, NARC_a_0_0_1", body)

    def test_a_message_about_one_Pokemon_has_all_three_of_its_rows(self):
        """A nickname message is picked by side: the row given, then the wild
        one, then the opposing trainer's. Only defining the first prints some
        other message at anyone but the player's own Pokemon."""
        rows = {int(number) for number in
                re.findall(r'<row id="msg_0197_(\d+)"',
                           (ROOT / "files/msgdata/msg/msg_0197.gmm").read_text())}
        for number in [subscript_number(name) for name in (
                "CREATE_TERRAIN_OVERLAY", "HANDLE_TERRAIN_END",
                "PSYCHIC_TERRAIN_PROTECTION", "ELECTRIC_TERRAIN_PROTECTION",
                "MISTY_TERRAIN_PROTECTION", "HADRON_ENGINE_NO_TERRAIN_SETUP",
                "PARADOX_ABILITY_START", "PARADOX_ABILITY_END")]:
            for message, tag in re.findall(r"PrintMessage msg_0197_(\d+), (TAG_\w+)",
                                           subscript(number)):
                if not tag.startswith("TAG_NICKNAME"):
                    continue
                for offset in range(3):
                    self.assertIn(int(message) + offset, rows,
                                  f"subscript {number:04d} prints msg_0197_{message} as "
                                  f"{tag}, so msg_0197_{int(message) + offset:05d} has to exist")


if __name__ == "__main__":
    unittest.main()
