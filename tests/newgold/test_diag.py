#!/usr/bin/env python3
"""The diagnostics exist only in a NEWGOLD_DIAG=1 build.

The promise docs/newgold/DIAGNOSTICS.md makes is that the ordinary build is
byte for byte the build without them. That holds as long as every mention of
a diagnostic outside its own folder sits under #ifdef NEWGOLD_DIAG, which is
what this reads the sources for; the ROM itself was compared when the folder
came in, and this is what keeps the next hook honest.
"""

import re
import sys
import unittest

from test_level_cap import ROOT

OWN = {ROOT / "src/newgold/diag/diag.c", ROOT / "include/newgold/diag.h"}
MENTION = re.compile(r"\b(gDiag\w*|Diag_\w+)\b")


def unguarded(path):
    """Every diagnostic mentioned on a line no #ifdef NEWGOLD_DIAG covers."""
    stack, found = [], []
    for number, line in enumerate(path.read_text().splitlines(), 1):
        directive = line.strip()
        if directive.startswith("#"):
            words = directive[1:].split()
            if words[0] in ("if", "ifdef", "ifndef"):
                stack.append(words[0] == "ifdef" and words[1] == "NEWGOLD_DIAG")
            elif words[0] in ("else", "elif"):
                stack[-1] = False
            elif words[0] == "endif":
                stack.pop()
            continue
        if not any(stack):
            found += [f"{path.relative_to(ROOT)}:{number}: {name}" for name in MENTION.findall(line)]
    return found


class DiagnosticsTests(unittest.TestCase):
    def test_every_hook_is_under_the_define(self):
        loose = []
        for folder, suffix in (("src", "*.c"), ("include", "*.h")):
            for path in sorted((ROOT / folder).rglob(suffix)):
                if path not in OWN:
                    loose += unguarded(path)
        self.assertEqual(loose, [], "diagnostics outside #ifdef NEWGOLD_DIAG:\n" + "\n".join(loose))

    def test_the_build_gates_the_define(self):
        config = (ROOT / "config.mk").read_text()
        self.assertIn("ifeq ($(NEWGOLD_DIAG),1)", config)
        before, block = config.split("ifeq ($(NEWGOLD_DIAG),1)", 1)
        self.assertIn("-DNEWGOLD_DIAG", block.split("endif", 1)[0])
        self.assertNotIn("-DNEWGOLD_DIAG", before + block.split("endif", 1)[1])
        self.assertIn("Object src/newgold/diag/diag.o", (ROOT / "main.lsf").read_text())

    def test_the_readers_know_every_marker(self):
        # A global the readers never print is one nobody will notice going wrong.
        # Every extern diag.h declares, whatever its type and however many
        # elements: the check once read 'unsigned int' and 'short' only, three
        # of the header's 45, and diag.h declares nearly all 'unsigned long'.
        header = (ROOT / "include/newgold/diag.h").read_text()
        names = set(re.findall(r"^extern\b[^;()]*?\b(gDiag\w+)\s*(?:\[[^\]]*\]\s*)*;", header, re.M))
        self.assertEqual(len(names), len(re.findall(r"^extern\b[^;()]*;", header, re.M)))
        self.assertIn("gDiagBattlers", names)
        read = set()
        for script in (ROOT / "tools/newgold/devkit/diag").glob("*.py"):
            read |= set(re.findall(r"gDiag\w+", script.read_text()))
        self.assertEqual(names - read, set(), "in diag.h and read by nothing")

    def test_a_one_hit_ko_move_s_accuracy_is_forced_too(self):
        # BattleSystem_CheckMoveHit returns on the flat hit rate before its
        # roll; Fissure, Horn Drill, Guillotine and Sheer Cold roll in
        # BtlCmd_TryOHKOMove, each of its two rolls named just before it.
        from test_dex_range import c_function
        body = c_function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_TryOHKOMove")
        rolls = re.findall(r"#ifdef NEWGOLD_DIAG\n\s*Diag_RollNext\(DIAG_ROLL_HIT\);\n#endif\n\s*if \(\(BattleSystem_Random\(battleSystem\) % 100\) < hitChance", body)
        self.assertEqual(len(rolls), 2)
        self.assertEqual(body.count("BattleSystem_Random("), 2)

    def test_every_speed_tie_roll_is_forced(self):
        # CheckSortSpeed rolls a tie in five places, one per ordering rule
        # (the Quick Claw's, the Lagging Tail's, Stall's, Trick Room's and
        # plain Speed); the chain between the two marks makes no other roll,
        # and the second mark forgets the first when no tie came.
        from test_dex_range import c_function
        body = c_function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "CheckSortSpeed")
        start = body.index("Diag_RollNext(DIAG_ROLL_SPEED_TIE);")
        end = body.index("Diag_RollNext(DIAG_ROLL_NONE);")
        self.assertEqual(body[start:end].count("BattleSystem_Random(battleSystem) & 1"), 5)
        self.assertEqual(body.count("BattleSystem_Random("), 5)

    def test_the_thaw_roll_is_forced(self):
        # A frozen Pokemon's one-in-five thaw on its own turn: the roll the
        # frozen step takes is named just before it.
        from test_dex_range import c_function
        body = c_function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224B528")
        rolls = re.findall(r"#ifdef NEWGOLD_DIAG\n\s*Diag_RollNext\(DIAG_ROLL_THAW\);\n#endif\n"
                           r"\s*if \(BattleSystem_Random\(battleSystem\) % 5 != 0\)", body)
        self.assertEqual(len(rolls), 1)

    def test_gym_reads_the_hp_past_a_two_word_species(self):
        # markers.battle names a form in two words; gym.py once took the
        # fourth word for the HP, read "L30" and died without a word.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import battler_hp
        self.assertEqual(battler_hp("you Raichu Alolan L30 0/80 | 1:Thunderbolt 15"), 0)
        self.assertEqual(battler_hp("you Iron Crown L30 103/103 holding Leftovers | 1:Smart Strike 10"), 103)
        self.assertEqual(battler_hp("you Porygon2 L30 57/90 PSN | 1:Tackle 35"), 57)

    def test_a_battle_line_reads_past_its_control_codes(self):
        # "{WAIT 3}Gotcha!\nX was caught!{WAIT 2}" read as "?{WAIT}..." and
        # gym.py, cutting a line at "?{", printed it empty.
        import struct
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        import markers
        code = {char: number for number, char in markers._charmap().items()}
        wait = lambda frames: [0xFFFE, 0x0202, 1, frames]    # noqa: E731
        line = wait(3) + [code[c] for c in "Gotcha!"] + [0xE000] + [code[c] for c in "Togepi was caught!"] \
            + wait(2) + [0xFFFF]
        ram = bytearray(0x400)
        struct.pack_into("<I", ram, 0, 1)
        struct.pack_into(f"<{len(line)}H", ram, 0x100, *line)
        reader = object.__new__(markers.Markers)
        reader.table = {"gDiagBattleTextCount": (markers.MAIN_RAM,), "gDiagBattleText": (markers.MAIN_RAM + 0x100,)}
        self.assertEqual(reader.text(bytes(ram)), [(0, "Gotcha! Togepi was caught!")])

    def test_gym_runs_from_a_wild_pokemon_only_when_its_own_is_low(self):
        # flee:40 in a scenario: RUN under 40% of the HP, in a wild battle.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import runs
        low, high = ["you Cyndaquil L7 7/24 | 1:Tackle 50"], ["you Cyndaquil L7 12/24 | 1:Tackle 50"]
        self.assertTrue(runs(low, True, 40))
        self.assertFalse(runs(high, True, 40))
        self.assertFalse(runs(low, False, 40))      # a trainer's
        self.assertFalse(runs(low, True, 0))        # no flee: step, as before
        self.assertTrue(runs(high, True, 100))
        self.assertTrue(runs(["you Raichu Alolan L30 12/80 | 1:Thunderbolt 15"], True, 40))

    def test_gym_tries_to_run_once_and_fights_when_it_cannot(self):
        # A wrapped Cyndaquil was told it could not get away 384 times, no
        # turn spent, until the walk ran out of frames. A trapped Pokemon is
        # told "You can't escape!" (CantEscape, msg_0197 row 01948); a try
        # that failed and spent the turn, "You couldn't get away!".
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import may_run
        for refusal in ("You can’t escape!", "You couldn’t get away!"):
            wild = False
            for line, after in (("You encountered a wild Ekans!", True), ("The wild Ekans used Wrap!", True),
                                (refusal, False), ("The wild Ekans used Leer!", False)):
                wild = may_run(wild, line)
                self.assertIs(wild, after, line)
        self.assertFalse(may_run(False, "You are challenged by Youngster Joey!"))

    def test_gym_weakens_a_pokemon_to_catch_then_throws(self):
        # catch: the weakest damaging move while the wild one has more than
        # half its HP and more than half again the most a move took off it;
        # a ball once it has not, or when nothing can weaken it.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import throws_now
        self.assertFalse(throws_now(20, 20, 0, True))
        self.assertFalse(throws_now(11, 20, 0, True))
        self.assertTrue(throws_now(10, 20, 0, True))
        self.assertTrue(throws_now(15, 20, 10, True))      # one more hit could take it
        self.assertFalse(throws_now(16, 20, 10, True))
        self.assertTrue(throws_now(20, 20, 0, False))      # nothing damaging: a ball at once

    def test_gym_finds_the_battle_bag_by_its_task(self):
        # The bag's screen is read from its own state, through the task that
        # runs it (priority 100, the bag its data); the same function's
        # address in a literal pool is no task, and an ended task is cleared.
        import struct
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import bag_screen, bag_state_at

        class Markers:
            def address(self, name):
                return 0x02229A58 if name == "ov08_02222670" else None
        ram = bytearray(0x400000)
        struct.pack_into("<I", ram, 0x1000, 0x02229A59)                     # a literal pool
        self.assertIsNone(bag_screen(bytes(ram), Markers()))
        struct.pack_into("<IIII", ram, 0x2008, 100, 0x02300000, 0x02229A59, 0)
        ram[0x300000 + bag_state_at()] = 2
        self.assertEqual(bag_screen(bytes(ram), Markers()), 2)
        self.assertEqual(bag_state_at(), 0x114A)

    def test_gym_touches_bag_until_the_bag_opens_then_each_screen(self):
        # The command prompt comes a little before its buttons: a BAG touched
        # at once was not read, twice in one leg, and the throw given up. BAG
        # again while the prompt asks; then the pocket, the ball and USE as
        # the bag's own state comes to each.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        import gym
        from unittest import mock

        class Core:
            frames, touches = 0, []

            def ram(self):
                return b""

            def step(self, frames, hold):
                self.frames += frames

            def touch(self, x, y, frames, hold):
                self.touches.append((x, y))
                self.frames += frames + 4
        core = Core()
        prompt = lambda: 1 if core.frames < 60 else 8 if core.frames < 300 else 13       # noqa: E731
        markers = type("Markers", (), {"read": lambda self, ram, name: prompt()})()
        screen = lambda ram, markers: 1 if core.frames < 120 else 2 if core.frames < 180 else 3   # noqa: E731
        with mock.patch.object(gym, "bag_screen", screen):
            self.assertTrue(gym.throw(core, markers, []))
        self.assertGreater(core.touches.count(gym.BAG), 1)
        firsts = [core.touches.index(t) for t in (gym.BAG, gym.BALLS, gym.FIRST_ITEM, gym.USE)]
        self.assertEqual(firsts, sorted(firsts))

    def test_gym_relieves_the_first_with_the_slot_shift_names(self):
        # shift: POKEMON while the command prompt asks, then on the party
        # screen the slot's place -- by the battle's order -- and SHIFT.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        import gym
        from unittest import mock

        class Core:
            frames, touches = 0, []

            def ram(self):
                return b""

            def step(self, frames, hold):
                self.frames += frames

            def touch(self, x, y, frames, hold):
                self.touches.append((x, y))
                self.frames += frames + 4
        core = Core()
        prompt = lambda: 1 if core.frames < 40 else 10 if gym.SHIFT not in core.touches else 13    # noqa: E731
        markers = type("Markers", (), {"read": lambda self, ram, name: prompt()})()
        with mock.patch.object(gym, "place", lambda ram, markers, slot: {2: 1}[slot]):
            self.assertTrue(gym.relieve(core, markers, [], 2))
        self.assertEqual(core.touches[-3:], [gym.POKEMON, gym.PARTY[1], gym.SHIFT])

    def test_gym_drops_a_move_a_foe_turned_away(self):
        # Proton's Koffing: a Geodude used Bulldoze into its Levitate ten
        # times, the type chart scoring it twice effective, and fell.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import wasted
        koffing, bulldoze = 109, 523
        self.assertEqual(wasted("The opposing Koffing makes Ground moves miss by using Levitate!", koffing, bulldoze),
                         (koffing, bulldoze))
        self.assertEqual(wasted("It doesn’t affect the wild Koffing...", koffing, bulldoze), (koffing, bulldoze))
        self.assertIsNone(wasted("It doesn’t affect Geodude...", koffing, bulldoze))     # the foe's move
        self.assertIsNone(wasted("The opposing Koffing used Sludge!", koffing, bulldoze))
        self.assertIsNone(wasted("The opposing Koffing is unaffected!", koffing, None))   # nothing chosen yet

    def test_a_pokemon_read_mid_encryption_is_not_taken_for_sealed(self):
        # A frame can end with the game re-encrypting a party Pokemon; scene.py
        # reads the party again until every one is sealed.
        import struct
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from party import sealed
        import savedit
        plain = bytes(range(128))
        checksum = sum(struct.unpack("<64H", plain)) & 0xFFFF
        raw = struct.pack("<IHH", 0x10203, 0, checksum) + savedit.mon_crypt(plain, checksum)
        self.assertTrue(sealed(raw))
        self.assertFalse(sealed(struct.pack("<IHH", 0x10203, 1, checksum) + raw[8:]))       # AcquireMonLock's
        self.assertFalse(sealed(raw[:8] + plain[:52] + raw[8 + 52:]))                        # half re-encrypted

    def test_the_closing_party_list_waits_for_every_pokemon_sealed(self):
        # gym.py's closing list, which whitney.py prints too, read the party
        # once: a frame that ended inside the game's decryption gave Whitney's
        # replay a slot-3 species 19423 at exp 2775330619. It reads again a
        # frame later while one is not sealed, as scene.py's party
        # expectations do, and says so of one that never is.
        from unittest import mock
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        import party
        reads = iter([[{"sealed": False}], [{"sealed": False}], [{"sealed": True}]])

        class Core:
            frames = 0

            def ram(self):
                return b""

            def step(self, frames, hooks):
                self.frames += frames
        core = Core()
        with mock.patch.object(party, "mons", lambda ram, elf: next(reads)):
            self.assertEqual(party.sealed_mons(core, None), [{"sealed": True}])
        self.assertEqual(core.frames, 2)
        torn = {"species": 19423, "item": 0, "exp": 2775330619, "level": 1, "hp": 0, "maxHp": 0, "sealed": False}
        self.assertTrue(party.party(b"", None, [torn])[0].endswith("(read mid-encryption)"))

    def test_gym_touches_the_target_panel_a_move_asks_for(self):
        # A double battle's target screen: a move on the user (Revival
        # Blessing) is confirmed on the user's own panel, an attack goes to a
        # foe's -- the player's first to battler 3's, its second to battler
        # 1's, every turn, whatever touches came before -- and to the other
        # foe's when that one is gone. Read from the moves' range in waza_tbl.
        sys.path[:0] = [str(ROOT / "tools/newgold/devkit/diag"), str(ROOT / "tools/newgold/devkit")]
        from gym import FOE_PANELS, OWN_PANELS, Scorer
        from savedit import move_numbers
        moves, scorer = move_numbers(), Scorer()
        self.assertEqual(scorer.panel(moves["REVIVAL_BLESSING"], 0, 0), OWN_PANELS[0])
        self.assertEqual(scorer.panel(moves["REVIVAL_BLESSING"], 2, 0), OWN_PANELS[2])
        self.assertEqual(scorer.panel(moves["THUNDERBOLT"], 0, 0), FOE_PANELS[0])
        self.assertEqual(scorer.panel(moves["THUNDERBOLT"], 0, 1), FOE_PANELS[1])
        self.assertEqual(scorer.panel(moves["THUNDERBOLT"], 2, 0), FOE_PANELS[1])
        self.assertEqual(scorer.panel(moves["THUNDERBOLT"], 2, 1), FOE_PANELS[0])

    def test_gym_scores_a_move_against_the_foe_it_aims_at(self):
        # The player's first aims at battler 3 and its second at battler 1
        # (above); each picked its move by battler 1's types, so the first
        # chose against the foe it would not hit.
        import struct
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from gym import aimed_at
        from markers import BATTLER

        class At:
            address = staticmethod(lambda name: 0x02000000)

        def battlers(*mons):
            return b"".join(struct.pack(BATTLER, species, hp, 50, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                            for species, hp in mons)
        double = battlers((25, 50), (16, 40), (26, 50), (74, 40))
        self.assertEqual(aimed_at(double, At, 0)[0], 74)
        self.assertEqual(aimed_at(double, At, 2)[0], 16)
        self.assertEqual(aimed_at(battlers((25, 50), (16, 40), (26, 50), (74, 0)), At, 0)[0], 16)
        self.assertEqual(aimed_at(battlers((25, 50), (16, 0), (26, 50), (74, 40)), At, 2)[0], 74)
        self.assertEqual(aimed_at(battlers((25, 50), (16, 40), (0, 0), (0, 0)), At, 0)[0], 16)    # a single battle

    def test_a_foe_that_gave_its_move_is_asked_again_by_teach(self):
        # A foe gives its move as the turn's choosing starts, and the battle
        # runs the slot it gave: asked before teach:, one ran a slot teach:
        # emptied ("The wild Chansey's - is disabled!"). teach: asks again a
        # battler that gave its move this turn (SSI_STATE_13 or 14, unk_314C
        # bit 1), and no other: one locked into or encored into its move was
        # not asked, and one with nothing usable would have nothing to give.
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from scene import asks_again, select_states
        states = select_states()
        self.assertEqual((states["SSI_STATE_3"], states["SSI_STATE_13"], states["SSI_STATE_14"]), (3, 13, 14))
        lick, none = [122, 0, 0, 0], [5, 0, 0, 0]
        self.assertTrue(asks_again(14, 2 | 1, lick, none))
        self.assertTrue(asks_again(13, 2, lick, none))
        self.assertFalse(asks_again(3, 1, lick, none))         # not asked for its move yet: it will be
        self.assertFalse(asks_again(14, 1, lick, none))        # locked or encored: given no request
        self.assertFalse(asks_again(14, 2, lick, [0, 0, 0, 0]))

    def test_nested_melonds_binds_every_button(self):
        # nested.py writes melonDS's key table before melonDS starts; a table
        # whose parent was implicit made melonDS's toml writer abort.
        import tomllib
        sys.path.insert(0, str(ROOT / "tools/newgold/devkit/diag"))
        from nested import KEYS, bind
        for text in ("", "[Instance0]\n\n[Instance0.Keyboard]\nA = -1\nHK_Lid = -1\n"):
            config = bind(text)
            self.assertIn("[Instance0]\n", config)
            keyboard = tomllib.loads(config)["Instance0"]["Keyboard"]
            self.assertEqual({k: keyboard[k] for k in KEYS}, {k: code for k, (code, _) in KEYS.items()})

    def test_a_heap_margin_is_its_largest_free_block_at_its_fullest(self):
        """Diag_HeapUsed walks an expanded heap's free list as
        NNS_FndGetTotalFreeSizeForExpHeap does -- the list at +0x24 of the
        head, a block's size at +4 and the next at +0xC, 32-bit -- and keeps
        the largest block when it is the smallest seen. Compiled on the host
        with -m32, so the pointers are the game's four bytes."""
        from test_dex_range import c_function, run_native
        source = (ROOT / "src/newgold/diag/diag.c").read_text()
        program = HEAP_MARGIN.replace("@CREATED@", c_function(source, "Diag_HeapCreated")) \
                             .replace("@USED@", c_function(source, "Diag_HeapUsed"))
        run_native(self, program, "newgold-heap-margin-", flags=("-m32",))

    def test_a_forced_roll_is_the_one_its_check_reads_that_way(self):
        """Diag_Roll answers, for the check Diag_RollNext named, the value that
        check reads as the forced outcome -- a critical hit's remainder of 0
        or 1, the accuracy's 0 or 99, the damage's 0 (100%) or 15 (85%), an
        effect's 0 or 99 -- the RNG's own value with the switch off, and
        forgets the check either way, so the next roll is the RNG's. A
        speed tie's is odd (the pair swaps: the second asked goes first) or
        even."""
        from test_dex_range import c_function, run_native
        source = (ROOT / "src/newgold/diag/diag.c").read_text()
        table = re.search(r"static const u8 sDiagForcedRolls\[\]\[2\] = \{.*?\};", source, re.S).group(0)
        program = FORCED_ROLL.replace("@TABLE@", table).replace("@NEXT@", c_function(source, "Diag_RollNext")) \
                             .replace("@ROLL@", c_function(source, "Diag_Roll"))
        header = (ROOT / "include/newgold/diag.h").read_text()
        program = program.replace("@DEFINES@", "\n".join(re.findall(r"^#define DIAG_ROLL_\w+ \d+$", header, re.M)))
        run_native(self, program, "newgold-forced-roll-")


FORCED_ROLL = r"""
#include <assert.h>
#include <stdio.h>
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
@DEFINES@
u32 gDiagForceCritical, gDiagForceHit, gDiagForceDamageRoll, gDiagForceEffect, gDiagForceSpeedTie, gDiagForceThaw, gDiagRollNext;
@TABLE@
@NEXT@
@ROLL@
static u16 roll(u32 kind, u32 *sw, u32 value, u16 natural) {
    *sw = value;
    Diag_RollNext(kind);
    return Diag_Roll(natural);
}
int main(void) {
    assert(roll(DIAG_ROLL_CRITICAL, &gDiagForceCritical, 1, 777) % 24 == 0);   /* lands at any stage */
    assert(roll(DIAG_ROLL_CRITICAL, &gDiagForceCritical, 2, 777) % 2 != 0);    /* fails at stage 2, 1 in 2 */
    assert(roll(DIAG_ROLL_HIT, &gDiagForceHit, 1, 777) % 100 + 1 <= 1);        /* hits anything accurate at all */
    assert(roll(DIAG_ROLL_HIT, &gDiagForceHit, 2, 777) % 100 + 1 > 99);        /* misses all under 100 */
    assert(100 - roll(DIAG_ROLL_DAMAGE, &gDiagForceDamageRoll, 1, 777) % 16 == 100);
    assert(100 - roll(DIAG_ROLL_DAMAGE, &gDiagForceDamageRoll, 2, 777) % 16 == 85);
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 1, 777) % 100 < 1);
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 2, 777) % 100 >= 99);
    assert(roll(DIAG_ROLL_SPEED_TIE, &gDiagForceSpeedTie, 1, 776) & 1);      /* the pair swaps */
    assert(!(roll(DIAG_ROLL_SPEED_TIE, &gDiagForceSpeedTie, 2, 777) & 1));   /* it stays */
    assert(roll(DIAG_ROLL_THAW, &gDiagForceThaw, 1, 777) % 5 == 0);          /* it thaws out */
    assert(roll(DIAG_ROLL_THAW, &gDiagForceThaw, 2, 775) % 5 != 0);          /* it stays frozen */
    assert(roll(DIAG_ROLL_EFFECT, &gDiagForceEffect, 0, 777) == 777);        /* off: the RNG's */
    assert(gDiagRollNext == DIAG_ROLL_NONE);                                   /* forgotten */
    gDiagForceCritical = 1;
    assert(Diag_Roll(777) == 777);                                             /* no check named: the RNG's */
    Diag_RollNext(DIAG_ROLL_CRITICAL);
    Diag_Roll(777);
    assert(Diag_Roll(778) == 778);                                             /* one roll a check */
    printf("PASS: a forced roll is the one its check reads as that outcome, once.\n");
    return 0;
}
"""


HEAP_MARGIN = r"""
#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
typedef unsigned char u8;
typedef unsigned int u32;
#define DIAG_HEAPS 176
u32 gDiagHeapLowWater[DIAG_HEAPS];
@CREATED@
@USED@
static u8 head[0x40], blocks[3][0x10];
static void block(int i, u32 size, u8 *next) { memcpy(blocks[i] + 4, &size, 4); memcpy(blocks[i] + 0xC, &next, 4); }
int main(void) {
    u8 *first = blocks[0];
    memcpy(head + 0x24, &first, 4);
    block(0, 0x100, blocks[1]);
    block(1, 0x5000, blocks[2]);
    block(2, 0x40, NULL);
    Diag_HeapCreated(5);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x5000);   /* the largest block, not the sum */
    block(1, 0x6000, blocks[2]);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x5000);   /* a roomier moment does not raise it */
    block(1, 0x80, blocks[2]);
    Diag_HeapUsed(5, head);
    assert(gDiagHeapLowWater[5] == 0x100);    /* a fuller one lowers it */
    Diag_HeapCreated(5);
    assert(gDiagHeapLowWater[5] == 0xFFFFFFFF);
    Diag_HeapUsed(DIAG_HEAPS, head);          /* out of range: ignored */
    printf("PASS: a heap's margin is its largest free block at its fullest.\n");
    return 0;
}
"""


if __name__ == "__main__":
    unittest.main()
