#!/usr/bin/env python3
"""savedit.py as a library: what it reads, and that each writer writes only
what it should.

The save editor page puts every one of these in front of a real playthrough,
so the property that matters most is the negative one: opening a save and
writing it back changes nothing, and changing the third Pokemon leaves the
other five byte for byte. The save here is built from an empty region and
sealed the way the game seals one -- the older half different from the
newest, the blocks' own checksum fields zero, as the game leaves most of them.
"""

import re
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness")]
import save_budget  # noqa: E402
import savedit as sv  # noqa: E402

BUILD = ROOT / "build/heartgold.us"


def reference_crc16(data, crc=0xFFFF):
    """GF_CalcCRC16 as savedit first wrote it, a bit at a time."""
    for byte in data:
        crc ^= byte << 8
        for _ in range(8):
            crc = ((crc << 1) ^ 0x1021) & 0xFFFF if crc & 0x8000 else (crc << 1) & 0xFFFF
    return crc


def seal_footers(region, table, count):
    """SaveSlot_BuildFooter for both slots, the blocks' fields left alone."""
    for spec in sv.slot_specs(table):
        at = spec["offset"] + spec["size"] - sv.CHUNK_FOOTER
        struct.pack_into("<IIIHH", region, at, count, spec["size"], sv.CHUNK_MAGIC, spec["slot"],
                         sv.crc16(region[spec["offset"]:at]))


def game_like_save(path):
    """Two halves, the second newer (counter 2 against 1) and different."""
    table = sv.blocks()
    old = bytearray(save_budget.REGION)
    seal_footers(old, table, 1)
    raw = sv.build_save(old)
    new = bytearray(old)
    player = next(b for b in table if b["id"] == "SAVE_PLAYERDATA")
    new[player["offset"] + sv.NAME:player["offset"] + sv.NAME + 4] = struct.pack("<HH", sv.charcode("A")[0], 0xFFFF)
    seal_footers(new, table, 2)
    raw[sv.HALF:sv.HALF + len(new)] = new
    Path(path).write_bytes(bytes(raw))


def the_game_saves(path):
    """The game's next save of this file, as bytes: SaveData_New loads the
    newest half and keeps its PC flag (save.c's boxModifiedFlags), Continue
    clears the copy in RAM, and the save writes the other half -- the main
    slot whole, of the PC slot only the boxes the kept flag names, then the
    rest of the slot, each slot under a footer computed over RAM."""
    save = sv.Save(path)
    ram, raw = bytearray(save.region), bytearray(save.raw)
    pc = save.entry("SAVE_PCSTORAGE")["offset"]
    kept = struct.unpack_from("<I", ram, pc + sv.BOX_MODIFIED)[0]
    struct.pack_into("<I", ram, pc + sv.BOX_MODIFIED, 0)
    other = sv.HALF - save.half
    for spec in save.specs:
        start, end = spec["offset"], spec["offset"] + spec["size"]
        struct.pack_into("<IIIHH", ram, end - sv.CHUNK_FOOTER, save.counter() + 1, spec["size"], sv.CHUNK_MAGIC,
                         spec["slot"], sv.crc16(ram[start:end - sv.CHUNK_FOOTER]))
        if start == pc:
            written = [(pc + n * sv.BOX, pc + (n + 1) * sv.BOX) for n in range(sv.NUM_BOXES) if kept >> n & 1]
            written.append((pc + sv.NUM_BOXES * sv.BOX, end))
        else:
            written = [(start, end)]
        for lo, hi in written:
            raw[other + lo:other + hi] = ram[lo:hi]
    return bytes(raw)


def party_save(blank, path):
    """The game-like save with a party of six and a boxed Mew, as a
    player's save would have."""
    save = sv.Save(blank)
    me = sv.owner(save)
    n = sv.species_numbers()
    for name in ("CHIKORITA", "PIDGEY", "RAICHU", "EEVEE", "GEODUDE", "SHEDINJA"):
        sv.add_party_mon(save, sv.new_mon(n[name], 20, me))
    sv.set_box_mon(save, 2, 5, sv.new_mon(n["MEW"], 30, me, party=False))
    Path(path).write_bytes(save.image())


class SaveditLibraryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (BUILD / "main.sbin").exists():
            raise unittest.SkipTest("the ROM has not been built")
        cls.tmp = tempfile.TemporaryDirectory()
        cls.blank = Path(cls.tmp.name) / "blank.sav"
        game_like_save(cls.blank)
        cls.path = Path(cls.tmp.name) / "party.sav"
        party_save(cls.blank, cls.path)

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def open(self):
        return sv.Save(self.path)

    def written(self, save):
        """The image, reopened the way the page checks every write."""
        out = Path(self.tmp.name) / "out.sav"
        out.write_bytes(save.image())
        return sv.Save(out)

    def changed_bytes(self, before, after):
        return [i for i in range(len(before)) if before[i] != after[i]]

    def block_range(self, save, name):
        entry = save.entry(name)
        return save.half + entry["offset"], save.half + entry["offset"] + entry["size"]

    def assert_only(self, save, names):
        """Every changed byte is in the newest half, inside a named block or
        a footer of the slot holding it."""
        before = self.path.read_bytes()
        after = save.image()
        allowed = [self.block_range(save, name) for name in names]
        for spec in save.specs:
            if any(int(save.entry(name)["slot"]) == spec["slot"] for name in names):
                end = save.half + spec["offset"] + spec["size"]
                allowed.append((end - sv.CHUNK_FOOTER, end))
        stray = [i for i in self.changed_bytes(before, after) if not any(lo <= i < hi for lo, hi in allowed)]
        self.assertEqual(stray[:8], [], f"bytes changed outside {names}")

    def test_a_save_from_before_the_misc_block_grew(self):
        """Save_GetLegacySlotSpecs' layout: the misc block at
        SAVE_MISC_LEGACY_SIZE, every block after it and the PC's slot where
        they were. It is read in that layout, and written back in it, for
        the game to convert when it loads it."""
        legacy = sv.blocks(legacy=True)
        if legacy == sv.blocks():
            self.skipTest("the ROM built here has the misc block at its old size")
        region = bytearray(save_budget.REGION)
        player = next(b for b in legacy if b["id"] == "SAVE_PLAYERDATA")
        region[player["offset"] + sv.NAME:player["offset"] + sv.NAME + 4] = struct.pack("<HH", sv.charcode("A")[0], 0xFFFF)
        seal_footers(region, legacy, 1)
        path = Path(self.tmp.name) / "legacy.sav"
        path.write_bytes(bytes(sv.build_save(region)))
        save = sv.Save(path)
        self.assertTrue(save.legacy)
        self.assertEqual(save.table, legacy)
        self.assertEqual(save.image(), path.read_bytes(), "unchanged, it stays byte for byte")
        sv.set_profile(save, money=4242)
        path.write_bytes(save.image())
        again = sv.Save(path)
        self.assertTrue(again.legacy, "an edit keeps the layout the game will convert")
        self.assertEqual(sv.profile(again)["money"], 4242)

    def test_a_pokemon_s_types_are_the_game_s(self):
        """GetMonData's MON_DATA_TYPE_1/_2: the species' two, one when they
        are the same; Arceus with Multitype its plate's, Silvally with RKS
        System its memory's (src/pokemon.c)."""
        n, ab = sv.species_numbers(), sv.constants("include/constants/abilities.h", "ABILITY_")
        items = {v["const"]: k for k, v in sv.item_table().items()}
        self.assertEqual(sv.mon_types(n["CHARIZARD"], 0, 0), ["FIRE", "FLYING"])
        self.assertEqual(sv.mon_types(n["CLEFAIRY"], 0, 0), ["FAIRY"])
        self.assertEqual(sv.mon_types(n["ARCEUS"], ab["ABILITY_MULTITYPE"], items["ITEM_FLAME_PLATE"]), ["FIRE"])
        self.assertEqual(sv.mon_types(n["ARCEUS"], ab["ABILITY_MULTITYPE"], 0), ["NORMAL"])
        self.assertEqual(sv.mon_types(n["SILVALLY"], ab["ABILITY_RKS_SYSTEM"], items["ITEM_WATER_MEMORY"]), ["WATER"])
        self.assertEqual(sv.mon_types(n["WORMADAM"], 0, 0, form=1), ["BUG", "GROUND"], "a Sandy Cloak: its form's record")
        self.assertRegex(sv.c_function("src/pokemon.c", "static u32 GetBoxMonDataInternal("),
                         r"(?s)case MON_DATA_TYPE_1:.*ABILITY_MULTITYPE.*ABILITY_RKS_SYSTEM.*"
                         r"GetMonBaseStat_HandleAlternateForm\(blockA->species, blockB->form,")
        self.assertEqual(sv.describe_mon(sv.party_raw(self.open())[0])["types"],
                         sv.mon_types(sv.describe_mon(sv.party_raw(self.open())[0])["species"], 0, 0))

    def test_the_layout_is_the_headers_as_they_are(self):
        """The save's sizes and offsets are what the host compiler makes of
        the headers: one saved since they were read is read again, and the
        module's names follow it."""
        header = sv.ROOT / "include/constants/pokemon.h"
        self.assertIn(header, sv._READ, "the layout watches every header the compiler read")
        kept, dex = sv.NUM_BOXES, sv.DEX_ENABLED
        self.addCleanup(lambda: vars(sv).update(sv._layout()))
        sv.NUM_BOXES = sv.DEX_ENABLED = 0
        sv.fresh()
        self.assertEqual(sv.NUM_BOXES, 0, "nothing changed, nothing read")
        sv._READ[header] -= 1   # as if saved since
        sv.fresh()
        self.assertEqual((sv.NUM_BOXES, sv.DEX_ENABLED), (kept, dex))

    def test_an_edited_table_is_read_again(self):
        """Paolo's data is the tree as it is: a file changed since a reader
        read it is read again, one left alone is not."""
        kept = sv.personal_records()
        sv.fresh()
        self.assertIs(sv.personal_records(), kept, "nothing changed, nothing read")
        sv._READ[sv.ROOT / "files/poketool/personal/personal.json"] -= 1   # as if saved since
        sv.fresh()
        self.assertIsNot(sv.personal_records(), kept)
        self.assertEqual(sv.personal_records(), kept)

    def test_a_reading_the_tree_moved_under_is_not_kept(self):
        """saveui reads in threads: a file saved while a reader is reading
        it, and another request's fresh() in between, and what that reader
        read may be the old file's. It is not kept, and the file is watched
        again the next time it is read."""
        path = sv.ROOT / "files/poketool/personal/personal.json"
        calls = []

        @sv.tree_cache
        def reader():
            sv.source("files/poketool/personal/personal.json")
            calls.append(len(calls))
            if len(calls) == 1:
                sv._READ[path] -= 1     # saved while it was being read
                sv.fresh()              # and another request has seen it
            return len(calls)
        self.addCleanup(sv._CACHES.remove, reader)
        self.assertEqual(reader(), 1)
        self.assertEqual(reader(), 2, "read again")
        self.assertEqual(reader(), 2, "and kept this time")
        self.assertIn(path, sv._READ)

    def test_a_define_is_read_as_the_compiler_reads_it(self):
        """A comment after the value, as pokemon.h writes MAX_EV_PER_STAT's,
        is no part of it; a define commented out is none."""
        header = Path(self.tmp.name) / "probe.h"
        header.write_text("#define SPECIES_A 152 // a note\n#define SPECIES_B   7 /* another */\n"
                          "// #define SPECIES_C 9\n#define SPECIES_D (SPECIES_A + 1)\n")
        self.addCleanup(sv._READ.pop, header, None)
        self.assertEqual(sv.constants(str(header), "SPECIES_"), {"SPECIES_A": 152, "SPECIES_B": 7})

    def test_crc16_is_the_bitwise_one(self):
        data = bytes(range(256)) * 9
        self.assertEqual(sv.crc16(data), reference_crc16(data))
        self.assertEqual(sv.crc16(b""), reference_crc16(b""))

    def test_opening_and_writing_back_changes_nothing(self):
        for path in (self.blank, self.path):
            save = sv.Save(path)
            self.assertEqual(save.half, sv.HALF, "the newer half is the second")
            self.assertEqual(save.image(), path.read_bytes())

    def test_a_write_touches_only_the_newest_half(self):
        save = self.open()
        sv.set_profile(save, money=1234)
        after = save.image()
        before = self.path.read_bytes()
        self.assertEqual(after[:sv.HALF], before[:sv.HALF], "the older half is the save before")
        again = self.written(save)
        self.assertEqual(sv.profile(again)["money"], 1234)
        self.assert_only(save, ["SAVE_PLAYERDATA"])

    def test_the_cli_still_writes_both_halves(self):
        out = Path(self.tmp.name) / "cli.sav"
        out.write_bytes(self.path.read_bytes())
        subprocess.run([sys.executable, str(ROOT / "tools/newgold/devkit/savedit.py"), str(out), "--badges", "3"],
                       check=True, capture_output=True)
        raw = out.read_bytes()
        self.assertEqual(raw[:sv.HALF], raw[sv.HALF:])
        self.assertEqual(sv.profile(sv.Save(out))["johto"], 0b111)

    def test_reading_the_party(self):
        party = [sv.describe_mon(raw) for raw in sv.party_raw(self.open())]
        self.assertEqual([m["species_name"] for m in party],
                         ["Chikorita", "Pidgey", "Raichu", "Eevee", "Geodude", "Shedinja"])
        for mon in party:
            self.assertTrue(mon["ok"])
            self.assertEqual((mon["level"], mon["ot_name"], mon["ivs"]), (20, "A", [31] * 6))
            self.assertEqual(mon["nickname"], mon["species_name"])
            self.assertTrue(all(m["pp"] == m["pp_max"] for m in mon["moves"]))
        self.assertEqual(party[5]["stats"][0], 1, "Shedinja has one HP")

    def test_editing_the_third_leaves_the_other_five(self):
        save = self.open()
        before = sv.party_raw(save)
        n, moves = sv.species_numbers(), sv.move_numbers()
        # Raichu's Double Team, which a Garchomp can learn too (a machine).
        known = next(m for m in sv.describe_mon(before[2])["moves"] if m["id"] == moves["DOUBLE_TEAM"])
        raw = sv.edit_mon(before[2], species=n["GARCHOMP"], level=50, nature=sv.bank(sv.NATURE_NAMES).index("Jolly"),
                          item=234, moves=[known["id"], moves["DRAGON_CLAW"]], ivs=[31, 31, 31, 0, 0, 31],
                          evs=[0, 252, 4, 252, 0, 0])
        sv.set_party_mon(save, 2, raw)
        after = sv.party_raw(self.written(save))
        self.assertEqual([a == b for a, b in zip(before, after)], [True, True, False, True, True, True])
        mon = sv.describe_mon(after[2])
        old = sv.describe_mon(before[2])
        self.assertEqual((mon["species_name"], mon["level"], mon["nature_name"], mon["item"]),
                         ("Garchomp", 50, "Jolly", 234))
        self.assertEqual([m["id"] for m in mon["moves"]], [known["id"], moves["DRAGON_CLAW"]])
        self.assertEqual(mon["moves"][0]["pp"], known["pp"], "a move it knew keeps its PP")
        self.assertEqual((mon["ivs"], mon["evs"]), ([31, 31, 31, 0, 0, 31], [0, 252, 4, 252, 0, 0]))
        self.assertEqual(mon["exp"], sv.experience_for("SLOW", 50))
        self.assertEqual(mon["personality"] & 0xFF, old["personality"] & 0xFF, "the gender byte stays")
        self.assertEqual(mon["hp"], mon["stats"][0], "a healthy Pokemon stays at full HP")
        self.assertEqual((mon["ot_name"], mon["ot_id"], mon["nickname"]), (old["ot_name"], old["ot_id"], "Garchomp"))
        record = sv.personal_records()[n["GARCHOMP"]]
        self.assertEqual(mon["stats"], sv.stat_line(record, 50, mon["ivs"], mon["evs"], mon["nature"]))
        self.assert_only(save, ["SAVE_PARTY"])

    def test_editing_only_the_item_leaves_the_stats(self):
        save = self.open()
        raw = sv.party_raw(save)[0]
        mon = sv.open_mon(raw)
        struct.pack_into("<H", mon["party"], 6, 3)  # hurt, so a stats pass would show
        hurt = sv.seal_mon(mon)
        edited = sv.describe_mon(sv.edit_mon(hurt, item=1))
        self.assertEqual((edited["item"], edited["hp"]), (1, 3))
        self.assertEqual(sv.open_mon(sv.edit_mon(hurt, item=1))["party"], sv.open_mon(hurt)["party"])

    def test_a_party_pokemon_has_the_games_empty_mail(self):
        """The mail record Mail_Init leaves, which READ on a held Mail
        needs; an all-zero one sends the game to its error screen."""
        # A Chikorita the game made (fresh-newbark.sav); the third message's
        # number is whatever the heap held, MailMsg_Init leaves it alone.
        game = bytes.fromhex("00000000000207ff" + "ff" * 22 + "0000" + "ffff0000ffffffff" * 2 + "ffffed00ffffffff")
        self.assertEqual((sv.MAIL_INIT[:0x32], sv.MAIL_INIT[0x34:]), (game[:0x32], game[0x34:]))

        def mail(raw):
            return bytes(sv.open_mon(raw)["party"][sv.MAIL_AT:sv.MAIL_AT + len(sv.MAIL_INIT)])
        save = self.open()
        self.assertEqual({mail(raw) for raw in sv.party_raw(save)}, {sv.MAIL_INIT})
        sv.deposit(save, 0, 0, 0)
        sv.withdraw(save, 0, 0)
        self.assertEqual(mail(sv.party_raw(save)[-1]), sv.MAIL_INIT, "withdrawn as the box-to-party copy does")
        old = sv.open_mon(sv.party_raw(save)[0])
        old["party"][sv.MAIL_AT:sv.MAIL_AT + len(sv.MAIL_INIT)] = bytes(len(sv.MAIL_INIT))
        cli_made = sv.mon_crypt(bytes(old["party"]), old["personality"])
        raw = sv.party_raw(save)[0][:sv.BOX_MON] + cli_made
        self.assertEqual(mail(raw), bytes(len(sv.MAIL_INIT)))
        self.assertEqual(mail(sv.edit_mon(raw, item=137)), sv.MAIL_INIT, "an all-zero one is mended on an edit")

    def test_what_a_species_can_learn(self):
        """Every way, at any level, checked against the data by hand:
        Charizard's record in personal.json has TM35 (sTMHMMoves' 35th is
        Flamethrower), its wotbl learnset has Flamethrower at 30 and Air
        Slash at 0 (on evolving), waza_oshie.json gives it TUTOR_HEAT_WAVE,
        Charmander's kowaza record has Metal Claw; Vulpix learns Incinerate
        at 16, Ninetales never does; and Surf reaches none of them."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        items = {row["const"]: row["id"] for row in sv.item_table().values()}
        charizard = sv.learnable_moves(n["CHARIZARD"])
        flamethrower = charizard[moves["FLAMETHROWER"]]
        self.assertIn({"how": "level", "level": 30}, flamethrower)
        self.assertIn({"how": "machine", "item": items["ITEM_TM35"]}, flamethrower, "every source, not the first")
        self.assertIn({"how": "level", "level": 24, "from": n["CHARMANDER"]}, flamethrower)
        self.assertNotIn({"how": "machine", "item": items["ITEM_TM35"], "from": n["CHARMANDER"]}, flamethrower,
                         "the same TM as its own is not another way")
        self.assertIn({"how": "level", "level": 0}, charizard[moves["AIR_SLASH"]])
        self.assertIn({"how": "tutor"}, charizard[moves["HEAT_WAVE"]])
        self.assertIn({"how": "egg", "from": n["CHARMANDER"]}, charizard[moves["METAL_CLAW"]])
        self.assertEqual(sv.learnable_moves(n["POLIWRATH"])[moves["CIRCLE_THROW"]], [{"how": "egg", "daycare": True}],
                         "Poliwrath's own egg move, learnt at the Day-Care (Daycare_LearnEggMovesFrom)")
        self.assertNotIn(moves["SURF"], charizard)
        self.assertEqual(sv.learnable_moves(n["NINETALES"])[moves["INCINERATE"]],
                         [{"how": "level", "level": 16, "from": n["VULPIX"]}])
        self.assertEqual(sv.tutor_moves(n["CHARIZARD"]), [moves[name] for name in (
            "MUD_SLAP", "FURY_CUTTER", "THUNDER_PUNCH", "FIRE_PUNCH", "OMINOUS_WIND", "SNORE", "AIR_CUTTER",
            "OUTRAGE", "TWISTER", "HEAT_WAVE", "SWIFT", "TAILWIND", "HEADBUTT")], "its own record, not the next")
        self.assertEqual([s for s, _ in sv.evolution_line(n["NINETALES_ALOLAN"])],
                         [n["NINETALES_ALOLAN"], n["VULPIX_ALOLAN"]], "a regional form's own line")
        self.assertEqual(sv.evolution_line(n["MARILL"]), [(n["MARILL"], True), (n["AZURILL"], True)],
                         "Marill hatches without the Sea Incense")
        self.assertEqual(sv.evolution_line(n["ALCREMIE"]), [(n["ALCREMIE"], False), (n["MILCERY"], True)],
                         "a Milcery evolves into it (evo.json); pms.narc: an egg is a Milcery")
        self.assertEqual(sv.evolution_line(n["VOLBEAT"]), [(n["VOLBEAT"], True)], "Daycare_GetEggSpecies' Illumise egg")
        self.assertEqual([s for s, _ in sv.evolution_line(n["RAICHU_ALOLAN"])], [n["RAICHU_ALOLAN"]],
                         "no evolution in evo.json makes one: not its base's Pikachu")
        self.assertEqual([s for sources in sv.learnable_moves(n["RAICHU_ALOLAN"]).values() for s in sources if "from" in s],
                         [], "nothing from a Pikachu or a Pichu")
        self.assertEqual([s for s, _ in sv.evolution_line(n["DUDUNSPARCE_THREE_SEGMENT"])],
                         [n["DUDUNSPARCE_THREE_SEGMENT"], n["DUNSPARCE"]], "EvolvedPassiveForm's")

        me = sv.owner(self.open())
        young = sv.new_mon(n["CHARIZARD"], 5, me)
        grown = sv.describe_mon(sv.edit_mon(young, moves=[moves["FLARE_BLITZ"], moves["METAL_CLAW"]]))
        self.assertEqual([m["name"] for m in grown["moves"]], ["Flare Blitz", "Metal Claw"],
                         "learnt at 62, known at 5")
        with self.assertRaises(sv.Illegal) as refused:
            sv.edit_mon(young, moves=[moves["SURF"], moves["EMBER"]])
        self.assertEqual((refused.exception.species, refused.exception.moves), (n["CHARIZARD"], [moves["SURF"]]))
        with self.assertRaises(sv.Illegal):
            sv.new_mon(n["CHARIZARD"], 5, me, moves=[moves["SURF"]])

    def test_a_rotom_form_has_its_own_move(self):
        """The Rotom Catalog teaches each appliance form its move
        (sRotomFormMoves): a Heat Rotom may know Overheat, a Rotom in no
        appliance may not."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        self.assertIn({"how": "form"}, sv.learnable_moves(n["ROTOM"], 1)[moves["OVERHEAT"]])
        self.assertNotIn({"how": "form"}, sv.learnable_moves(n["ROTOM"], 0).get(moves["OVERHEAT"], []))
        mon = sv.open_mon(sv.new_mon(n["ROTOM"], 30, sv.owner(self.open())))
        mon["blocks"][1][0x18] |= 1 << 3
        heat = sv.edit_mon(sv.seal_mon(mon), moves=[moves["OVERHEAT"], moves["THUNDER_SHOCK"]])
        self.assertEqual([m["name"] for m in sv.describe_mon(heat)["moves"]], ["Overheat", "Thunder Shock"])

    def test_the_blackthorn_tutor_teaches_a_type(self):
        """scr_seq_0948_T30R0601.s teaches Draco Meteor to a Pokemon that
        GetMonTypes calls Dragon: Druddigon and Applin, with no tutor bit of
        their own for it, and Silvally, Dragon with the Dragon Memory; not
        Charizard."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        taught = {"how": "tutor", "type": "DRAGON"}
        for name in ("DRUDDIGON", "APPLIN", "SILVALLY"):
            self.assertIn(taught, sv.learnable_moves(n[name]).get(moves["DRACO_METEOR"], []), name)
        self.assertNotIn(moves["DRACO_METEOR"], sv.learnable_moves(n["CHARIZARD"]))
        sv.new_mon(n["DRUDDIGON"], 30, sv.owner(self.open()), moves=[moves["DRACO_METEOR"]])

    def test_a_light_ball_egg_knows_volt_tackle(self):
        """GiveEggToPlayer runs Daycare_LightBallCheck on a Pichu egg: with a
        parent holding a Light Ball it knows Volt Tackle, and so may the
        Pikachu and Raichu it becomes."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        ball = sv.constants("include/constants/items.h", "ITEM_")["ITEM_LIGHT_BALL"]
        self.assertIn({"how": "egg", "item": ball}, sv.learnable_moves(n["PICHU"])[moves["VOLT_TACKLE"]])
        self.assertIn({"how": "egg", "item": ball, "from": n["PICHU"]}, sv.learnable_moves(n["RAICHU"])[moves["VOLT_TACKLE"]])
        sv.new_mon(n["PICHU"], 5, sv.owner(self.open()), moves=[moves["VOLT_TACKLE"], moves["THUNDER_SHOCK"]])

    def test_an_event_move_stays_while_untouched(self):
        """A Pokemon the game made may know a move no rule lists: it keeps it
        while it keeps its species and the move, and loses nothing else."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        event = sv.build_mon("CHARIZARD", 50, moves=[moves["SURF"], moves["EMBER"]])
        kept = sv.describe_mon(sv.edit_mon(event, moves=[moves["SURF"], moves["FLAMETHROWER"]], level=51))
        self.assertEqual([m["name"] for m in kept["moves"]], ["Surf", "Flamethrower"])
        with self.assertRaises(sv.Illegal):
            sv.edit_mon(event, moves=[moves["SURF"], moves["WATERFALL"]])
        with self.assertRaises(sv.Illegal, msg="a new species: the old moves sent back are refused too"):
            sv.edit_mon(event, species=n["CHARMELEON"], moves=[moves["SURF"], moves["EMBER"]])
        self.assertEqual(sv.describe_mon(sv.edit_mon(event, item=1))["moves"][0]["name"], "Surf")

    def test_an_older_editors_moves_are_marked(self):
        """The old CLI's Machamp in falkner.sav: Focus Energy twice, every PP
        40. The second Focus Energy is a repeat, and 40 is above Focus
        Energy's 30 and Karate Chop's 25; GetMoveMaxPP counts three PP Ups
        at most."""
        moves = sv.move_numbers()
        known = [moves["FOCUS_ENERGY"], moves["FOCUS_ENERGY"], moves["KARATE_CHOP"], moves["FORESIGHT"]]
        mon = sv.open_mon(sv.build_mon("MACHAMP", 13, moves=known))
        for i in range(4):
            mon["blocks"][1][8 + i], mon["blocks"][1][12 + i] = 40, 0   # what that CLI wrote
        mon["blocks"][1][12 + 3] = 7
        self.assertEqual([(m["pp"], m["pp_max"], m["repeat"]) for m in sv.describe_mon(sv.seal_mon(mon))["moves"]],
                         [(40, 30, False), (40, 30, True), (40, 25, False), (40, 64, False)])

    def test_a_move_given_twice_is_refused(self):
        """The game never teaches a move the Pokemon knows: new_mon, edit_mon
        and the CLI refuse a move given twice; a Pokemon that knows one twice
        keeps it through an edit that leaves its moves alone."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        twice = [moves["FOCUS_ENERGY"], moves["FOCUS_ENERGY"], moves["KARATE_CHOP"]]
        with self.assertRaises(sv.Illegal) as refused:
            sv.new_mon(n["MACHAMP"], 13, sv.owner(self.open()), moves=twice[:2])
        self.assertEqual(refused.exception.twice, moves["FOCUS_ENERGY"])
        old = sv.build_mon("MACHAMP", 13, moves=twice)
        with self.assertRaises(sv.Illegal):
            sv.edit_mon(old, moves=twice + [moves["LOW_KICK"]])
        self.assertEqual([m["id"] for m in sv.describe_mon(sv.edit_mon(old, level=14))["moves"]], twice)
        with self.assertRaises(SystemExit):
            sv.parse_party("MACHAMP:13::FOCUS_ENERGY+FOCUS_ENERGY")

    def test_an_edit_brings_pp_down_to_the_maximum(self):
        """An older savedit gave every move 40 PP: an edit brings each down
        to GetMoveMaxPP's, and leaves one at or below it."""
        moves = sv.move_numbers()
        old = sv.open_mon(sv.build_mon("MACHAMP", 13, moves=[moves["FOCUS_ENERGY"], moves["FORESIGHT"]]))
        for i in range(2):
            old["blocks"][1][8 + i], old["blocks"][1][12 + i] = 40, 0   # what that CLI wrote
        old = sv.seal_mon(old)
        self.assertEqual([m["pp"] for m in sv.describe_mon(sv.edit_mon(old, item=1))["moves"]], [30, 40])

    def test_a_new_species_brings_its_own_moves_and_ability(self):
        """preset_moves at its level, never the old moves, and the ability
        UpdateBoxMonAbility gives the new species from the Pokemon's bits."""
        n = sv.species_numbers()
        raichu = sv.party_raw(self.open())[2]
        was = sv.describe_mon(raichu)
        mon = sv.describe_mon(sv.edit_mon(raichu, species=n["PONYTA"]))
        self.assertEqual([m["id"] for m in mon["moves"]], sv.preset_moves(n["PONYTA"], 20))
        self.assertEqual(mon["moves"][0]["pp"], mon["moves"][0]["pp_max"])
        slot = sv.ability_slot(n["PONYTA"], 0, was["hidden_ability"], was["ability_bit"])
        self.assertEqual(mon["ability"], {a["slot"]: a["id"] for a in sv.species_abilities(n["PONYTA"])}[slot])
        self.assertEqual((mon["nature"], mon["ivs"], mon["evs"], mon["item"], mon["level"]),
                         (was["nature"], was["ivs"], was["evs"], was["item"], was["level"]))
        with self.assertRaises(sv.Illegal):
            sv.edit_mon(raichu, species=n["CHARMANDER"], ability=1)   # Blaze and nothing else

    def test_an_ability_is_kept_the_way_the_game_keeps_it(self):
        """Ponyta: Run Away, Flash Fire, and Flame Body hidden. The second
        is the personality's low bit -- here 0x7E, a female one step from
        the male 0x7F, so the byte moves further to keep her female -- and
        the hidden one is MON_HIDDEN_ABILITY_BIT, which the game reads again
        on evolving: a Rapidash made of her has Flame Body too."""
        n = sv.species_numbers()
        self.assertEqual([(a["slot"], a["name"]) for a in sv.species_abilities(n["PONYTA"])],
                         [(0, "Run Away"), (1, "Flash Fire"), (sv.HIDDEN_SLOT, "Flame Body")])
        self.assertEqual([a["slot"] for a in sv.species_abilities(n["CHARMANDER"])], [0, sv.HIDDEN_SLOT])
        she = sv.build_mon("PONYTA", 30, personality=0x5A5A007E, ot_id=0x00010002)
        was = sv.describe_mon(she)
        self.assertEqual((was["ability_slot"], was["gender"]), (0, 1))
        second = sv.describe_mon(sv.edit_mon(she, ability=1))
        self.assertEqual((second["ability_name"], second["ability_slot"], second["personality"] & 1), ("Flash Fire", 1, 1))
        self.assertEqual((second["gender"], second["nature"], second["shiny"]), (was["gender"], was["nature"], was["shiny"]))
        hidden = sv.edit_mon(she, ability=sv.HIDDEN_SLOT)
        read = sv.describe_mon(hidden)
        self.assertEqual((read["ability_name"], read["hidden_ability"], read["ability_slot"]), ("Flame Body", True, 2))
        self.assertEqual(read["personality"], was["personality"], "the bit, not the personality")
        evolved = sv.describe_mon(sv.edit_mon(hidden, species=n["RAPIDASH"]))
        self.assertEqual((evolved["ability_name"], evolved["hidden_ability"]), ("Flame Body", True))
        back = sv.describe_mon(sv.edit_mon(hidden, ability=0))
        self.assertEqual((back["ability_name"], back["hidden_ability"]), ("Run Away", False))
        # Phanpy has one ability, Donphan two: Phanpy's first chosen is Donphan's first.
        odd = sv.build_mon("PHANPY", 20, personality=0x5A5A0073, ot_id=0x00010002)
        first = sv.edit_mon(odd, ability=0)
        self.assertEqual(sv.describe_mon(first)["ability_bit"], 0)
        self.assertEqual(sv.describe_mon(sv.edit_mon(first, species=n["DONPHAN"]))["ability_slot"], 0)
        self.assertEqual(sv.describe_mon(sv.edit_mon(odd, species=n["DONPHAN"]))["ability_slot"], 1, "left alone, the bit")

    def test_no_level_up_move_the_engine_never_implemented(self):
        """LoadLevelUpLearnset_HandleAlternateForm drops the moves whose
        waza_tbl flag says unimplemented: Pawmot learns Revival Blessing as it
        evolves and is never given it. (Kadabra's Ally Switch at 15 was the
        example until it was implemented; a new one at 15 knows it now.)"""
        n, moves = sv.species_numbers(), sv.move_numbers()
        unimplemented = sv.unimplemented_moves()
        self.assertIn(moves["REVIVAL_BLESSING"], unimplemented)
        self.assertNotIn(moves["ALLY_SWITCH"], unimplemented)
        self.assertEqual([m for row in sv.learnsets() for _, m in row if m in unimplemented], [])
        self.assertEqual(sv.preset_moves(n["KADABRA"], 15), [moves[m] for m in ("TELEPORT", "PSYBEAM", "REFLECT", "ALLY_SWITCH")])
        levels = [s for s in sv.learnable_moves(n["PAWMOT"]).get(moves["REVIVAL_BLESSING"], []) if s["how"] == "level"]
        self.assertEqual(levels, [], "not offered as a level-up move either")

    def test_a_new_pokemon_knows_each_move_once(self):
        """InitBoxMonMoveset skips a move already known: Metapod learns
        Harden twice and knows it once, Pidgeotto keeps Sand Attack once."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        self.assertEqual(sv.preset_moves(n["METAPOD"], 1), [moves["HARDEN"]])
        for species, level in (("METAPOD", 1), ("PIDGEOTTO", 5)):
            known = [m["id"] for m in sv.describe_mon(sv.new_mon(n[species], level, sv.owner(self.open())))["moves"]]
            self.assertEqual(len(known), len(set(known)), species)
        self.assertEqual([m["id"] for m in sv.describe_mon(sv.build_mon("METAPOD", 1))["moves"]], [moves["HARDEN"]],
                         "the CLI's default too")
        with self.assertRaises(SystemExit):
            sv.parse_party("CHIKORITA:5::TACKLE+TACKLE")

    def test_the_cli_makes_only_species_a_pokemon_can_be(self):
        """What the page refuses, the CLI does too: a battle's Mega, a
        retail form row, the egg."""
        for text in ("MEGA_CHARIZARD_X:50", "ROTOM_WASH:20", "EGG:5", "NOSUCHMON:5"):
            with self.assertRaises(SystemExit, msg=text):
                sv.parse_party(text)
        with self.assertRaises(SystemExit):
            sv.put_in_box(self.open(), 1, "mega_venusaur", 40)
        self.assertEqual(sv.parse_party("chikorita:5")[0][0], "CHIKORITA")

    def test_the_cli_names_a_pokemon_as_the_game_prints_it(self):
        """build_mon writes the species bank's name, not its constant."""
        self.assertEqual(sv.describe_mon(sv.build_mon("MR_MIME", 5))["nickname"], "Mr. Mime")

    def test_a_form_has_its_own_stats(self):
        """CalcMonStats reads the form's record (ResolveMonForm): a Rotom
        Wash is SPECIES_ROTOM in form 2, with Rotom Wash's base stats."""
        n, records = sv.species_numbers(), sv.personal_records()
        for base, form, row in (("ROTOM", 2, "ROTOM_WASH"), ("GIRATINA", 1, "GIRATINA_ORIGIN"),
                                ("DEOXYS", 3, "DEOXYS_SPD"), ("ROTOM", 0, "ROTOM")):
            mon = sv.open_mon(sv.new_mon(n[base], 50, sv.owner(self.open())))
            mon["blocks"][1][0x18] |= form << 3
            raw = sv.edit_mon(sv.seal_mon(mon), level=51)
            got = sv.describe_mon(raw)
            self.assertEqual(got["form"], form)
            self.assertEqual(got["stats"], sv.stat_line(records[n[row]], 51, got["ivs"], got["evs"], got["nature"]), row)

    def test_a_nature_keeps_gender_and_shininess(self):
        shiny_one = ((0x1111 ^ 0x2222 ^ 0x3344 ^ 5) << 16) | 0x3344
        self.assertTrue(sv.is_shiny(shiny_one, 0x1111_2222))
        for personality, ot_id in ((0x12345678, 0x0001_0002), (shiny_one, 0x1111_2222), (7, 7)):
            shiny = sv.is_shiny(personality, ot_id)
            for nature in range(25):
                p = sv.personality_for_nature(personality, nature, ot_id)
                self.assertEqual((p % 25, p & 0xFF, sv.is_shiny(p, ot_id)), (nature, personality & 0xFF, shiny))

    def test_any_box_slot(self):
        save = self.open()
        before = [sv.box_raw(save, b, s) for b in range(30) for s in range(30)]
        self.assertEqual(sv.describe_mon(before[2 * 30 + 5])["species_name"], "Mew")
        me, n = sv.owner(save), sv.species_numbers()
        sv.set_box_mon(save, 29, 29, sv.new_mon(n["TOGEKISS"], 40, me, party=False))
        again = self.written(save)
        after = [sv.box_raw(again, b, s) for b in range(30) for s in range(30)]
        self.assertEqual([i for i in range(900) if before[i] != after[i]], [899])
        self.assertEqual(sv.describe_mon(after[899])["level"], 40)
        self.assertEqual(sv.boxes(again)["mons"][29][29]["species_name"], "Togekiss")
        self.assert_only(save, ["SAVE_PCSTORAGE"])

    def test_the_games_next_save_after_a_box_edit(self):
        """The game writes only the boxes the PC flag names into the older
        half; a box changed here that the flag left out would be the old one
        there under the new footer, and the next boot would load the save
        before with 'The save file is corrupted'."""
        save = self.open()
        pc = save.entry("SAVE_PCSTORAGE")["offset"]
        self.assertIn(pc, [spec["offset"] for spec in save.specs], "the boxes open their slot")
        sv.set_box_mon(save, 29, 0, sv.new_mon(sv.species_numbers()["TOGEKISS"], 40, sv.owner(save), party=False))
        edited = Path(self.tmp.name) / "boxed.sav"
        edited.write_bytes(save.image())
        flag_at = save.half + pc + sv.BOX_MODIFIED
        self.assertEqual(struct.unpack_from("<I", edited.read_bytes(), flag_at)[0], 1 << 2 | 1 << 29,
                         "the fixture's Mew in box 3, and box 30")
        after = Path(self.tmp.name) / "after.sav"
        after.write_bytes(the_game_saves(edited))
        again = sv.Save(after)
        self.assertEqual((again.half, again.valid(0), again.valid(sv.HALF)), (0, True, True))
        self.assertEqual(sv.boxes(again)["mons"][29][0]["species_name"], "Togekiss")
        # The same edit with box 30 left out of the flag, as image() once wrote it.
        broken = bytearray(edited.read_bytes())
        struct.pack_into("<I", broken, flag_at, 1 << 2)
        spec = next(s for s in save.specs if s["offset"] == pc)
        footer = save.half + spec["offset"] + spec["size"] - sv.CHUNK_FOOTER
        struct.pack_into("<H", broken, footer + sv.FOOTER_CRC_AT, sv.crc16(broken[save.half + pc:footer]))
        edited.write_bytes(bytes(broken))
        after.write_bytes(the_game_saves(edited))
        self.assertFalse(sv.Save(after).valid(0), "the replay catches what the game calls corrupt")

    def test_moving_between_party_and_box(self):
        save = self.open()
        party = sv.party_raw(save)
        sv.deposit(save, 1, 0, 0)
        self.assertEqual(sv.box_raw(save, 0, 0), party[1][:sv.BOX_MON])
        self.assertEqual(sv.party_raw(save), party[:1] + party[2:])
        self.assertEqual(bytes(save.block("SAVE_PARTY")[8 + 5 * sv.PARTY_MON:8 + 6 * sv.PARTY_MON]),
                         sv.EMPTY_PARTY_MON, "ZeroMonData's empty slot")
        sv.withdraw(save, 0, 0)
        back = sv.describe_mon(sv.party_raw(save)[-1])
        self.assertEqual((back["species_name"], back["level"], back["hp"]), ("Pidgey", 20, back["stats"][0]))
        self.assertIsNone(sv.open_mon(sv.box_raw(save, 0, 0)))
        sv.swap_party_mons(save, 0, 5)
        self.assertEqual(sv.party_raw(save)[5], party[0])
        for _ in range(5):
            sv.remove_party_mon(save, 0)
        with self.assertRaises(ValueError):
            sv.remove_party_mon(save, 0)
        with self.assertRaises(ValueError):
            sv.deposit(save, 0, 1, 0)
        self.assertEqual(len(sv.party_raw(save)), 1)

    def test_the_bag(self):
        save = self.open()
        items = {row["const"]: row["id"] for row in sv.item_table().values()}
        sv.set_item(save, items["ITEM_POTION"], 3)
        sv.set_item(save, items["ITEM_CHESTO_BERRY"], 2)
        sv.set_item(save, items["ITEM_CHERI_BERRY"], 5)
        sv.set_item(save, items["ITEM_TM01"], 1)
        with self.assertRaises(ValueError):
            sv.set_item(save, items["ITEM_TM02"], 2)  # New Gold never uses one up
        bag = sv.bag(self.written(save))
        self.assertEqual([(i["name"], i["quantity"]) for i in bag["medicine"]], [("Potion", 3)])
        self.assertEqual([i["name"] for i in bag["berries"]], ["Cheri Berry", "Chesto Berry"], "sorted by id")
        self.assertEqual(len(bag["TMsHMs"]), 1)
        sv.set_item(save, items["ITEM_CHERI_BERRY"], 0)
        self.assertEqual([i["name"] for i in sv.bag(save)["berries"]], ["Chesto Berry"])
        self.assert_only(save, ["SAVE_BAG"])

    def test_the_dex(self):
        save = self.open()
        n = sv.species_numbers()
        sv.set_dex(save, [n["BULBASAUR"], n["UNOWN"]], seen=True, caught=True)
        sv.set_dex(save, [n["PIDGEY"]], seen=True, caught=False)
        sv.set_dex_switches(save, enabled=True, national=True)
        dex = sv.dex(self.written(save))
        self.assertEqual((dex["enabled"], dex["national"]), (True, True))
        self.assertEqual(dex["seen"], sorted([n["BULBASAUR"], n["PIDGEY"], n["UNOWN"]]))
        self.assertEqual(dex["caught"], sorted([n["BULBASAUR"], n["UNOWN"]]))
        self.assertEqual(save.block("SAVE_POKEDEX")[sv.UNOWN_SEEN], 0, "Unown A recorded")
        # The genders the Dex draws: seen first, then the other one.
        sv.set_dex(save, [n["NIDORAN_F"], n["NIDORAN_M"], n["STARYU"]], seen=True, caught=False)
        block = save.block("SAVE_POKEDEX")
        genders = lambda s: tuple((block[at + ((s - 1) >> 3)] >> ((s - 1) & 7)) & 1  # noqa: E731
                                  for at in (sv.DEX_GENDERS, sv.DEX_GENDERS + sv.DEX_SEEN - sv.DEX_CAUGHT))
        self.assertEqual(genders(n["NIDORAN_F"]), (1, 1), "only female: no male sprite to draw")
        self.assertEqual((genders(n["NIDORAN_M"]), genders(n["STARYU"])), ((0, 0), (0, 0)))
        self.assertEqual(genders(n["PIDGEY"]), (0, 1), "male first, female second")
        at, mask = sv.DEX_FORM_ORDERS["SHAYMIN"]
        block[at] = 0xFF   # Save_Pokedex_Init: no form seen yet
        sv.set_dex(save, [n["SHAYMIN"]], seen=True, caught=False)
        self.assertEqual(block[at] & mask, 0, "Land Forme first, not the empty order's Sky")
        # Every Dex form in order, as Pokedex_TryAppendSeenForm appends them.
        sv.set_dex_forms(save, n["SHAYMIN"], [1])
        self.assertEqual(block[at] & mask, 0b11, "Sky alone: its only entry repeated")
        sv.set_dex_forms(save, n["SHELLOS"], [0, 1])
        self.assertEqual(block[sv.DEX_FORM_ORDERS["SHELLOS"][0]] & 0b11, 0b10)
        sv.set_dex_forms(save, n["ROTOM"], [5, 0])
        rotom = int.from_bytes(block[sv.DEX_FORM_ORDERS["ROTOM"][0]:][:4], "little")
        self.assertEqual(rotom & 0x3FFFF, 5 | 0 << 3 | 0o7777 << 6, "then 7s: no more")
        sv.set_dex_forms(save, n["UNOWN"], range(28))
        self.assertEqual(bytes(block[sv.UNOWN_SEEN:sv.UNOWN_SEEN + 28]), bytes(range(28)))
        sv.set_dex_forms(save, n["DEOXYS"], [3, 1])
        self.assertEqual((block[sv.DEX_SEEN - 1], block[sv.DEX_GENDERS - 1]), (0x13, 0xFF))
        with self.assertRaises(ValueError):
            sv.set_dex_forms(save, n["BURMY"], [3])
        self.assertTrue(sv.flag_is_set(save, 0x6B), "FLAG_GOT_POKEDEX: POKéDEX in the start menu")
        with self.assertRaises(ValueError):
            sv.set_dex(save, [n["EGG"]], True, True)
        self.assert_only(save, ["SAVE_POKEDEX", "SAVE_PLAYERDATA", "SAVE_FLAGS"])

    def test_flags_vars_and_position(self):
        save = self.open()
        sv.write_flag(save, 0x76, True)
        sv.write_var(save, 0x4079, 2)
        sv.set_position(save, 80, 10, 9, 0)
        again = self.written(save)
        self.assertTrue(sv.flag_is_set(again, 0x76))
        self.assertFalse(sv.flag_is_set(again, 0x77))
        self.assertEqual(sv.var_value(again, 0x4079), 2)
        self.assertEqual(sv.position(again)["current"], {"map": 80, "warp": -1, "x": 10, "y": 9, "direction": 0})
        self.assertEqual(set(sv.position(again)["special"]), {"map", "warp", "x", "y", "direction"})
        self.assertTrue(sv.position(again)["by_warp"])
        found = sv.find_flags(again, "UNK_076")
        self.assertIn({"kind": "flag", "name": "FLAG_UNK_076", "number": 0x76, "value": 1}, found)
        self.assert_only(save, ["SAVE_FLAGS", "SAVE_LOCAL_FIELD_DATA"])

    def test_the_profile(self):
        save = self.open()
        sv.set_name(save, "Paolo")
        sv.set_trainer_id(save, 0x0102_0304)
        sv.set_profile(save, money=999999, gender=1, johto=0b1011, kanto=0x80, coins=50, play_time=[12, 34, 56])
        with self.assertRaises(ValueError):
            sv.set_profile(save, money=1_000_000)
        profile = sv.profile(self.written(save))
        self.assertEqual(profile, {"name": "Paolo", "id": 0x0304, "sid": 0x0102, "money": 999999, "gender": 1,
                                   "johto": 0b1011, "kanto": 0x80, "coins": 50, "play_time": [12, 34, 56]})
        self.assert_only(save, ["SAVE_PLAYERDATA"])

    def test_the_names_are_the_games(self):
        self.assertEqual(sv.species_name(sv.species_numbers()["PIKACHU"]), "Pikachu")
        self.assertEqual(sv.move_table()[sv.move_numbers()["TACKLE"]]["pp"], 35)
        self.assertEqual(sv.decode_text(sv.encode_text("Farfetch’d", 10)), "Farfetch’d")
        pockets = {row["const"]: row["pocket"] for row in sv.item_table().values()}
        self.assertEqual((pockets["ITEM_POTION"], pockets["ITEM_MASTER_BALL"], pockets["ITEM_TM01"]),
                         ("medicine", "balls", "TMsHMs"))
        maps = sv.map_table()
        self.assertEqual(maps[sv.constants("include/constants/maps.h", "MAP_")["MAP_ROUTE_29"]]["name"], "Route 29")

    def test_where_the_player_can_stand(self):
        """A preset is where the game itself puts the player -- a town's fly
        point, an interior's heal spawn, a warp's tile on a route and in a
        cave -- facing as the game does, and each is a spot; a wall, water,
        the void around a room and the black off the chunks are not."""
        num, dirs = sv.constants("include/constants/maps.h", "MAP_"), sv.constants("include/constants/global_fieldmap.h", "DIR_")
        for name, how, x, y, facing in (("MAP_NEW_BARK", "fly", 695, 397, "DIR_SOUTH"),
                                        ("MAP_VIOLET_POKECENTER_1F", "heal", 8, 13, "DIR_NORTH"),
                                        ("MAP_ROUTE_29", "warp", 626, 389, "DIR_SOUTH"),
                                        ("MAP_UNION_CAVE_1F", "warp", 27, 43, "DIR_SOUTH")):
            self.assertEqual(sv.preset(num[name]), {"how": how, "x": x, "y": y, "direction": dirs[facing]}, name)
            self.assertIsNone(sv.tile_problem(num[name], x, y), name)
        self.assertEqual(sv.preset(num["MAP_ROUTE_9"])["how"], "edge", "no warp: where it meets the next map")
        self.assertIsNone(sv.tile_problem(80, 10, 9), "the tiles the other tests write")
        self.assertIsNone(sv.tile_problem(33, 655, 400))
        self.assertEqual(sv.tile_problem(num["MAP_ROUTE_32"], 468, 418), "wall")
        self.assertEqual(sv.tile_problem(num["MAP_NEW_BARK"], *next(p for p, w in sorted(sv.ground(num["MAP_NEW_BARK"])[1].items())
                                                                     if w == "water")), "water")
        self.assertEqual(sv.tile_problem(num["MAP_VIOLET_POKECENTER_1F"], 20, 20), "apart", "the void around the room")
        self.assertEqual(sv.tile_problem(33, 5, 5), "off")
        self.assertIsNone(sv.preset(num["MAP_EVERYWHERE"]))
        # Sprout Tower's land data has a sound section before its attributes:
        # read at the fixed offset, its ladder and its monks stand in walls.
        tower = num["MAP_SPROUT_TOWER_3F"]
        self.assertTrue(all(sv.tile_problem(tower, o["x"], o["z"]) in (None, "object") for o in sv.map_events(tower)["objects"]))

    def test_the_town_map(self):
        """The Pokégear's town map as a PNG of its window, and each map's
        tiles on it: a map of the main matrix at its chunks, rows moved as
        the Pokégear moves them; an interior at its world coordinates."""
        town, num = sv.town_map(), sv.constants("include/constants/maps.h", "MAP_")
        self.assertEqual((town["cols"], town["rows"], town["dx"], town["dy"]), (47, 20, 0, 2))
        self.assertEqual(struct.unpack(">II", town["png"][16:24]), (8 * town["cols"], 8 * town["rows"]))
        rows, palette = sv._png_rows(town["png"])
        self.assertEqual((len(rows[0]), len(rows)), (8 * town["cols"], 8 * town["rows"]), "the PNG reads back")
        self.assertEqual(palette, sv._nclr(f"{sv.TOWN_MAP}/pgmap_gra_00000020.NCLR"), "the NCLR the game loads, skin 0")
        self.assertEqual(palette[3 * 2:3 * 3], bytes(sv._png_rows((sv.ROOT / sv.TOWN_MAP / "pgmap_gra_00000010.png").read_bytes())[1][3 * 2:3 * 3]),
                         "today the art's PNG agrees with it")
        tiles = sv.town_tiles()
        violet = {(x, y + town["dy"]) for x, y in sv.map_chunks(num["MAP_VIOLET"])}
        self.assertEqual(set(tiles[num["MAP_VIOLET"]]), violet)
        header = sv.map_headers()["MAP_VIOLET_POKECENTER_1F"]
        self.assertEqual(tiles[num["MAP_VIOLET_POKECENTER_1F"]], [(int(header["worldMapX"]), int(header["worldMapY"]) + town["dy"])])
        self.assertIn(sv.town_tile(num["MAP_VIOLET_POKECENTER_1F"], 8, 13, (0, 0)), violet)
        self.assertEqual(sv.town_tile(33, 655, 400, (0, 0)), (655 // 32, 400 // 32 + town["dy"]))
        row = sv.map_table()[num["MAP_VIOLET_POKECENTER_1F"]]
        self.assertEqual((row["section"], row["region"], row["type"]), ("MAPSEC_VIOLET_CITY", "MAP_REGION_JOHTO", "MAP_TYPE_INTERIOR"))

    def test_a_bad_checksum_is_reported(self):
        raw = bytearray(sv.party_raw(self.open())[0])
        raw[20] ^= 0xFF
        self.assertEqual(sv.describe_mon(bytes(raw))["ok"], False)
        with self.assertRaises(ValueError):
            sv.edit_mon(bytes(raw), level=5)

    def test_what_the_player_was_given(self):
        """The running shoes, the start menu's entries by the flag each
        checks, the Pokégear's cards and map; nothing else is touched."""
        save = self.open()
        flags = sv.constants("include/constants/flags.h", "FLAG_")
        icons = {entry["icon"]: entry for entry in sv.menu_unlocks()}
        self.assertEqual(icons["START_MENU_ICON_TRAINER_CARD"]["flag"], flags["FLAG_GOT_BAG"] + 1, "CheckGotMenuIconI")
        self.assertEqual(icons["START_MENU_ICON_POKEGEAR"]["flag"], flags["FLAG_GOT_POKEGEAR"])
        self.assertTrue(icons["START_MENU_ICON_RUNNING_SHOES"]["shoes"])
        self.assertFalse(sv.running_shoes(save))
        sv.set_menu_unlock(save, "START_MENU_ICON_RUNNING_SHOES", True)
        sv.set_menu_unlock(save, "START_MENU_ICON_BAG", True)
        sv.set_pokegear(save, cards=3, map_level=2)
        with self.assertRaises(ValueError):
            sv.set_pokegear(save, map_level=sv.pokegear_cards()["map_levels"])
        again = self.written(save)
        self.assertTrue(sv.running_shoes(again))
        self.assertTrue(sv.flag_is_set(again, flags["FLAG_GOT_BAG"]))
        self.assertEqual(sv.pokegear(again), {"cards": 3, "map_level": 2})
        self.assertEqual([c["const"] for c in sv.pokegear_cards()["cards"]], ["GEARCARD_MAP", "GEARCARD_RADIO"])
        self.assert_only(save, ["SAVE_LOCAL_FIELD_DATA", "SAVE_FLAGS", "SAVE_POKEGEAR"])

    def test_the_level_cap(self):
        """GetLevelCap's milestones, latest first: whitney.sav's Zephyr and
        Hive make 30, the Burned Tower 36."""
        save = self.open()
        self.assertEqual(sv.level_cap(save), 10)
        bits = {b["const"]: b["bit"] for b in sv.badges()}
        sv.set_profile(save, johto=1 << bits["BADGE_ZEPHYR"] | 1 << bits["BADGE_HIVE"])
        self.assertEqual(sv.level_cap(save), 30)
        sv.write_flag(save, sv.constants("include/constants/flags.h", "FLAG_")["FLAG_HIDE_BURNED_TOWER_1F_RIVAL"], True)
        self.assertEqual(sv.level_cap(save), 36)
        self.assertEqual(sv.field_move_badges()["BADGE_PLAIN"], ["MOVE_STRENGTH"])
        # The moves are named after FieldMove_Check* functions: each must be a field move the party menu offers.
        self.assertLessEqual({m for ms in sv.field_move_badges().values() for m in ms},
                             set(re.findall(r"MOVE_\w+", sv.c_table("src/party_menu.c", "sFieldMoves"))))

    def test_the_story_is_read_from_the_scripts(self):
        """Every badge's gym is a chain of steps with its GiveBadge in it;
        Whitney's is beaten, stopped by the lass, the badge, the TM, each
        needing the one before; Morty's opens with the Burned Tower; the
        Sudowoodo wants the SquirtBottle, which the Flower Shop gives only
        with the Plain Badge."""
        steps, chains = {s["id"]: s for s in sv.story()}, sv.badge_chains()
        self.assertEqual(set(chains), {b["const"] for b in sv.badges()})
        for badge, chain in chains.items():
            self.assertIn(("badge", badge), {(steps[i]["kind"], steps[i]["key"]) for i in chain})
        whitney = [steps[i] for i in chains["BADGE_PLAIN"]]
        self.assertEqual([(s["kind"], s["key"]) for s in whitney],
                         [("battle", "TRAINER_LEADER_WHITNEY"), ("flag", "FLAG_UNK_0B7"), ("badge", "BADGE_PLAIN"),
                          ("item", "ITEM_TM45")])
        self.assertEqual(whitney[1]["needs"], [[[("var", "VAR_UNK_410A"), "eq", 1], [whitney[0]["id"]]]],
                         "the lass's trigger tile")
        self.assertEqual(whitney[2]["needs"], [[[("flag", "FLAG_UNK_0B7"), "eq", 1], [whitney[1]["id"]]]])
        morty = steps[chains["BADGE_FOG"][0]]
        self.assertEqual((morty["kind"], morty["key"], morty["section"]), ("gate", "VAR_UNK_4079", "Burned Tower"))
        self.assertEqual([s["id"] for s in steps.values() if s["kind"] == "gate"], [morty["id"]],
                         "Elm's lab and the Kimono Girls set VAR_UNK_4079 again, after the gym opened")
        self.assertEqual([(steps[i]["kind"], steps[i]["key"]) for i in chains["BADGE_GLACIER"]],
                         [("badge", "BADGE_GLACIER"), ("item", "ITEM_TM07")], "TM07 follows the badge in one scene")
        bottle = [("item", "ITEM_SQUIRTBOTTLE", 1), "eq", 1]
        sudowoodo = next(s for s in steps.values() if bottle in [need for need, _ in s["needs"]])
        shop = steps[next(by for need, by in sudowoodo["needs"] if need == bottle)[0]]
        self.assertEqual((shop["kind"], shop["key"]), ("item", "ITEM_SQUIRTBOTTLE"))
        self.assertEqual(shop["needs"], [[[("badge", "BADGE_PLAIN"), "eq", 1], [whitney[2]["id"]]]])

    def test_a_story_step_runs_as_the_game_runs_it(self):
        """Whitney beaten with the badge not given yet; the badge, whose
        undo puts her back to crying; the TM; Chuck's badge starting the
        Rocket takeover only as the third midgame badge."""
        save = self.open()
        variables = sv.constants("include/constants/vars.h", "VAR_")
        flags = sv.constants("include/constants/flags.h", "FLAG_")
        beaten, lass, badge, tm = sv.badge_chains()["BADGE_PLAIN"]
        sv.run_step(save, beaten)
        self.assertEqual(sv.var_value(save, variables["VAR_UNK_410A"]), 1)
        self.assertTrue(sv.flag_is_set(save, flags["FLAG_UNK_084"]))
        self.assertEqual([s in sv.story_state(save)["done"] for s in (beaten, lass, badge, tm)], [True, False, False, False])
        sv.run_step(save, lass)
        self.assertIn(["badge", "BADGE_PLAIN", 1], sv.run_step(save, badge))
        self.assertEqual((sv.var_value(save, variables["VAR_UNK_410A"]), sv.level_cap(save)), (2, 34))
        self.assertFalse(sv.flag_is_set(save, flags["FLAG_UNK_084"]))
        self.assertEqual(sv.undo_step(save, badge), [])
        self.assertEqual(sv.var_value(save, variables["VAR_UNK_410A"]), 1, "back to what the step before set")
        self.assertTrue(sv.flag_is_set(save, flags["FLAG_UNK_084"]))
        self.assertEqual(sv.profile(save)["johto"], 0)
        sv.run_step(save, tm)
        tm45 = sv.constants("include/constants/items.h", "ITEM_")["ITEM_TM45"]
        self.assertEqual([i["item"] for i in sv.bag(save)["TMsHMs"]], [tm45])
        chuck = next(s for s in sv.badge_chains()["BADGE_STORM"] if sv._step(s)["kind"] == "badge")
        takeover = variables["VAR_SCENE_ROCKET_TAKEOVER"]
        sv.run_step(save, chuck)
        self.assertEqual(sv.var_value(save, takeover), 0, "the first midgame badge")
        sv.undo_step(save, chuck)
        sv.write_var(save, variables["VAR_MIDGAME_BADGES"], 2)
        sv.run_step(save, chuck)
        self.assertEqual((sv.var_value(save, takeover), sv.var_value(save, variables["VAR_MIDGAME_BADGES"])), (1, 3))
        self.assert_only(save, ["SAVE_FLAGS", "SAVE_PLAYERDATA", "SAVE_BAG"])

    def test_a_story_flag_is_one_of_no_other_kind(self):
        """A SetFlag starts a step for a flag of any section of flags.h but
        those that are no story -- each of them a heading flags.h has, or a
        hide flag would start steps the day one is renamed -- so a flag a
        hack adds under a heading of its own is the story's too."""
        self.assertLessEqual(set(sv._NOT_STORY), set(sv.flag_sections().values()))
        self.assertEqual(sv._secondary("SetFlag", ("FLAG_UNK_0B7",), {}), ("flag", "FLAG_UNK_0B7"))
        self.assertEqual(sv._secondary("SetFlag", ("FLAG_A_NEW_GOLD_SCENE",), {}), ("flag", "FLAG_A_NEW_GOLD_SCENE"))
        for kept in ("FLAG_HIDE_ROUTE_36_SUDOWOODO", "FLAG_DAILY_GOT_HAIRCUT"):
            self.assertIsNone(sv._secondary("SetFlag", (kept,), {}), kept)

    def test_a_battle_runs_the_scripts_the_field_runs_after_it(self):
        """The Sudowoodo's battle rebuilds Route 36, whose OnLoad script
        hides the tree while FLAG_ENGAGING_STATIC_POKEMON is set: the step
        writes that, and running it leaves the tree gone."""
        flags = sv.constants("include/constants/flags.h", "FLAG_")
        sudowoodo = next(s for s in sv.story() if s["kind"] == "flag" and s["key"] == "FLAG_UNK_0B4")
        self.assertIn(["flag", "FLAG_HIDE_ROUTE_36_SUDOWOODO", 1, False], sudowoodo["writes"])
        save = self.open()
        sv.run_step(save, sudowoodo["id"])
        self.assertTrue(sv.flag_is_set(save, flags["FLAG_HIDE_ROUTE_36_SUDOWOODO"]))
        self.assertFalse(sv.flag_is_set(save, flags["FLAG_ENGAGING_STATIC_POKEMON"]))
        self.assertIn(sudowoodo["id"], sv.story_state(save)["done"])
        # FLAG_ENGAGING_STATIC_POKEMON is set and cleared around the battle:
        # the step leaves it as it was, and taking it back does not set it --
        # Route 36's OnLoad would hide the tree for good.
        self.assertNotIn("FLAG_ENGAGING_STATIC_POKEMON", [w[1] for w in sudowoodo["writes"]])
        sv.undo_step(save, sudowoodo["id"])
        self.assertFalse(sv.flag_is_set(save, flags["FLAG_ENGAGING_STATIC_POKEMON"]))
        self.assertFalse(sv.flag_is_set(save, flags["FLAG_HIDE_ROUTE_36_SUDOWOODO"]))

    def test_a_step_brings_its_scene_before_its_marker(self):
        """What the game writes on every way to a step's marker, since no
        other marker: the Burned Tower's beasts hidden before its SetVar
        opens Morty's gym, the Mystery Egg given in the talk that ends with
        the Pokédex, the Expansion Card's flag set with its card -- one
        step, whose test is both."""
        flags = sv.constants("include/constants/flags.h", "FLAG_")
        steps = {s["id"]: s for s in sv.story()}
        gate = steps[sv.badge_chains()["BADGE_FOG"][0]]
        self.assertIn(["flag", "FLAG_HIDE_BURNED_TOWER_B1F_RAIKOU", 1, False], gate["writes"])
        self.assertIn(["var", "VAR_UNK_4076", 1, False], gate["writes"])
        dex = next(s for s in steps.values() if s["kind"] == "GivePokedex")
        self.assertIn(["item", "ITEM_MYSTERY_EGG", 1, False], dex["writes"])
        card = next(s for s in steps.values() if s["kind"] == "RegisterPokegearCard" and ("flag", "FLAG_GOT_EXPN_CARD", 1) in s["tests"])
        self.assertIn(("card", "", 2), card["tests"])
        self.assertEqual([s for s in steps.values() if s["key"] == "FLAG_GOT_EXPN_CARD"], [], "no step of its own")
        pryce = [steps[i] for i in sv.badge_chains()["BADGE_GLACIER"]]
        self.assertNotIn("VAR_MIDGAME_BADGES", [w[1] for s in pryce if s["kind"] == "item" for w in s["writes"]],
                         "what follows a marker is its step's, not the next one's")
        save = self.open()
        sv.run_step(save, gate["id"])
        self.assertTrue(sv.flag_is_set(save, flags["FLAG_HIDE_BURNED_TOWER_B1F_RAIKOU"]))
        self.assertIn(gate["id"], sv.story_state(save)["done"])

    def test_a_step_takes_and_pays_as_the_script_does(self):
        """TakeItem and TakeItemNoCheck take the item (the Exp. Share for
        the Red Scale), SubMoneyImmediate takes the money, a gift the bag
        has no room for is not given (Whitney's TM45, already held: neither
        the TM nor its flag), and what the editor does not do -- an egg
        given -- is named among the writes."""
        items, flags = sv.constants("include/constants/items.h", "ITEM_"), sv.constants("include/constants/flags.h", "FLAG_")
        steps = {s["id"]: s for s in sv.story()}
        share = next(s for s in steps.values() if s["kind"] == "item" and s["key"] == "ITEM_EXP__SHARE")
        self.assertIn(["item", "ITEM_RED_SCALE", -1, False], share["writes"])
        save = self.open()
        sv.set_item(save, items["ITEM_RED_SCALE"], 1)
        sv.run_step(save, share["id"])
        self.assertEqual((sv._items(save)[items["ITEM_RED_SCALE"]], sv._items(save)[items["ITEM_EXP__SHARE"]]), (0, 1))
        self.assertIn(share["id"], sv.story_state(save)["done"])
        candy = next(s for s in steps.values() if s["key"] == "ITEM_RAGECANDYBAR" and ["money", "", -300, False] in s["writes"])
        sv.set_profile(save, money=1000)
        sv.run_step(save, candy["id"])
        self.assertEqual(sv.profile(save)["money"], 700)
        tm = sv.badge_chains()["BADGE_PLAIN"][3]
        save = self.open()
        sv.set_item(save, items["ITEM_TM45"], 1)
        self.assertEqual(sv.run_step(save, tm), [], "no room: std_bag_is_full, and nothing else")
        self.assertFalse(sv.flag_is_set(save, flags["FLAG_GOT_TM45_FROM_WHITNEY"]))
        primo = next(s for s in steps.values() if s["key"] == "FLAG_GOT_MAREEP_EGG_FROM_PRIMO")
        self.assertTrue(any(w[0] == "other" and w[1].startswith("GiveEgg SPECIES_MAREEP") for w in primo["writes"]))
        save, found = self.open(), {}
        before = save.image()
        sv.run_step(save, primo["id"], found)
        sv.undo_step(save, primo["id"], sv.record(save, found))
        self.assertEqual(save.image(), before)

    def test_a_step_taken_back_puts_back_what_it_found(self):
        """Run with a record, a step taken back leaves the save as it was;
        a record the save has moved on from is passed over, key by key."""
        variables = sv.constants("include/constants/vars.h", "VAR_")
        sudowoodo = next(s["id"] for s in sv.story() if s["kind"] == "flag" and s["key"] == "FLAG_UNK_0B4")
        save, found = self.open(), {}
        before = save.image()
        sv.run_step(save, sudowoodo, found)
        self.assertEqual(found["flag:FLAG_HIDE_ROUTE_36_SUDOWOODO"], 0)
        sv.undo_step(save, sudowoodo, sv.record(save, found))
        self.assertEqual(save.image(), before, "back byte for byte")
        beaten = sv.badge_chains()["BADGE_PLAIN"][0]
        save, found = self.open(), {}
        sv.run_step(save, beaten, found)
        done = sv.record(save, found)
        sv.write_var(save, variables["VAR_UNK_410A"], 7)
        self.assertEqual(sv.undo_step(save, beaten, done), [])
        self.assertEqual(sv.var_value(save, variables["VAR_UNK_40DA"]), 0, "the record's")
        self.assertEqual(sv.var_value(save, variables["VAR_UNK_410A"]), 0, "the gym's, not the record's")

    def test_a_gym_step_taken_back_without_a_record(self):
        """A step done by playing has no record: a gym's variable no earlier
        step of it sets goes back to the value that keeps the gym as it was
        -- Whitney's to 0, Morty's gate to the one that turns the player
        away -- and the step no longer counts as done."""
        variables = sv.constants("include/constants/vars.h", "VAR_")
        save = self.open()
        beaten = sv.badge_chains()["BADGE_PLAIN"][0]
        sv.run_step(save, beaten)
        self.assertEqual(sv.undo_step(save, beaten), [])
        self.assertEqual([sv.var_value(save, variables[v]) for v in ("VAR_UNK_410A", "VAR_UNK_40DA")], [0, 0])
        gate = sv.badge_chains()["BADGE_FOG"][0]
        sv.run_step(save, gate)
        self.assertEqual(sv.undo_step(save, gate), [])
        self.assertEqual(sv.var_value(save, variables["VAR_UNK_4079"]), sv._gates()[0]["VAR_UNK_4079"])
        self.assertNotIn(gate, sv.story_state(save)["done"])

    def test_the_machines_as_the_bag_keeps_them(self):
        """Every machine, in SortTMHMPocket's order, with its move, the
        move's type and how many the bag takes."""
        table, items = sv.machine_table(), sv.constants("include/constants/items.h", "ITEM_")
        self.assertEqual(len(table), len([m for m in sv.machines() if m[1] is not None]))
        first = table[0]
        self.assertEqual((first["item"], sv.move_table()[first["move"]]["name"], first["type"], first["limit"]),
                         (items["ITEM_TM01"], "Focus Punch", "FIGHTING", 1))
        groups = [sv._machine_order((row["item"], 1))[1] for row in table]
        self.assertEqual(groups, sorted(groups), "the TMs, then the TRs, then the HMs")
        hm01, tr00 = (next(r for r in table if r["item"] == items[name]) for name in ("ITEM_HM01", "ITEM_TR00"))
        self.assertEqual((hm01["limit"], hm01["spent"], tr00["spent"], first["spent"]),
                         (sv.BAG_TMHM_QUANTITY_MAX, False, True, False))


class TheCodeSaveditKeeps(unittest.TestCase):
    """What savedit keeps as code rather than reads: the game has it only as
    code too -- a function, a macro, a struct the compiler lays out -- so
    each is held here to the tree's own, and fails the day they differ."""

    def fields(self, kind, *names):
        values, _ = sv.compile_c(tuple(f"__builtin_offsetof({kind}, {name})" for name in names))
        return dict(zip(names, values))

    def mask(self, kind, init):
        """The bits a bitfield takes in its struct, as one number."""
        _, (raw,) = sv.compile_c(inits=((kind, init),))
        return int.from_bytes(raw, "little")

    def test_the_pokemon_record_is_laid_out_as_savedit_reads_it(self):
        """The offsets and bits savedit reads and writes inside a Pokemon."""
        self.assertEqual(self.fields("BoxPokemon", "personality", "checksum", "dataBlocks"),
                         {"personality": 0, "checksum": 6, "dataBlocks": 8})
        self.assertEqual(self.fields("PokemonDataBlockA", "species", "heldItem", "otID", "expAndAbility", "friendship",
                                     "ability", "originLanguage", "hpEV", "spDefEV"),
                         {"species": 0, "heldItem": 2, "otID": 4, "expAndAbility": 8, "friendship": 0x0C,
                          "ability": 0x0D, "originLanguage": 0x0F, "hpEV": 0x10, "spDefEV": 0x15})
        self.assertEqual(self.fields("PokemonDataBlockB", "moves", "moveCurrentPPs", "movePPUps", "unused2"),
                         {"moves": 0, "moveCurrentPPs": 8, "movePPUps": 12, "unused2": 0x1A})
        self.assertEqual(self.fields("PokemonDataBlockC", "nickname", "originGame"), {"nickname": 0, "originGame": 0x17})
        self.assertEqual(self.fields("PokemonDataBlockD", "otName", "pokeball", "HGSS_Pokeball"),
                         {"otName": 0, "pokeball": 0x1B, "HGSS_Pokeball": 0x1E})
        self.assertEqual(self.fields("PartyPokemon", "status", "level", "hp", "maxHP", "spdef"),
                         {"status": 0, "level": 4, "hp": 6, "maxHP": 8, "spdef": 18})
        a, b, d = "PokemonDataBlockA", "PokemonDataBlockB", "PokemonDataBlockD"
        self.assertEqual(self.mask(a, ".exp = ~0u"), sv.EXP_BITS << 8 * 8)
        self.assertEqual(self.mask(a, ".abilityMSB = 1"), 1 << 31 << 8 * 8)
        self.assertEqual(self.mask(b, ".hpIV = ~0u, .atkIV = ~0u, .defIV = ~0u, .speedIV = ~0u, .spAtkIV = ~0u, "
                                      ".spDefIV = ~0u"), (1 << 30) - 1 << 8 * 0x10, "IVs: five bits each, in order")
        self.assertEqual(self.mask(b, ".isEgg = 1"), 1 << 30 << 8 * 0x10)
        self.assertEqual(self.mask(b, ".hasNickname = 1"), 1 << 31 << 8 * 0x10)
        self.assertEqual(self.mask(b, ".gender = ~0u"), 3 << 1 << 8 * 0x18)
        self.assertEqual(self.mask(b, ".form = ~0u"), 0x1F << 3 << 8 * 0x18)
        self.assertEqual(self.mask(b, ".unused1 = ~0u"), 3 << 6 << 8 * 0x19, "the hidden-ability bit's byte")
        self.assertEqual(self.mask(d, ".metLevel = ~0u"), 0x7F << 8 * 0x1C)
        self.assertEqual(self.mask(d, ".otGender = 1"), 0x80 << 8 * 0x1C)

    def test_the_rest_of_the_save_is_laid_out_as_savedit_packs_it(self):
        """The footers, the play time, a Location and the party's counts,
        packed by struct formats; and the dynamic warp, a Location of
        LocalFieldData, which src/save_local_field_data.c declares."""
        self.assertEqual(self.fields("struct SaveChunkFooter", "count", "size", "magic", "slot", "crc"),
                         dict(zip(("count", "size", "magic", "slot", "crc"), (0, 4, 8, 12, 14))), "<IIIHH")
        self.assertEqual(self.fields("struct SaveArrayFooter", "magic", "saveno", "size", "idx", "crc"),
                         dict(zip(("magic", "saveno", "size", "idx", "crc"), (0, 4, 8, 12, 14))), "<IIIH, then crc")
        self.assertEqual(self.fields("IGT", "hours", "minutes", "seconds"), {"hours": 0, "minutes": 2, "seconds": 3})
        self.assertEqual(self.fields("Location", "mapId", "warpId", "x", "y", "direction"),
                         dict(zip(("mapId", "warpId", "x", "y", "direction"), (0, 4, 8, 12, 16))), "<5i")
        self.assertEqual(self.fields("PartyCore", "maxCount", "curCount"), {"maxCount": 0, "curCount": 4})
        text = (ROOT / "src/save_local_field_data.c").read_text()
        members = re.findall(r"^\s*(\w+) (\w+);", text[text.index("struct LocalFieldData {"):], re.M)
        self.assertEqual(members[:5], [("Location", "currentPosition"), ("Location", "entrancePosition"),
                                       ("Location", "previousPosition"), ("Location", "dynamicWarp"),
                                       ("Location", "specialSpawn")],
                         "the dynamic warp is 3 * LOCATION in, the special spawn 4 *")

    def test_the_mail_is_mail_init_s(self):
        """MAIL_INIT is Mail_Init and MailMsg_Init over struct Mail: the same
        fields set to the same things, where the compiler puts them."""
        init = sv.c_function("src/mail.c", "void Mail_Init(")
        self.assertEqual(dict(re.findall(r"mail->(\w+)(?:\[i\]\.raw)? = (\w+);", init)),
                         {"author_otId": "0", "author_gender": "PLAYER_GENDER_MALE", "author_language": "gGameLanguage",
                          "author_version": "gGameVersion", "mail_type": "MAIL_NONE", "mon_icons": "0xFFFF",
                          "form_flags": "0"})
        self.assertIn("StringFillEOS(mail->author_name, PLAYER_NAME_LENGTH + 1)", init)
        self.assertIn("MailMsg_Init(&mail->unk_20[i])", init)
        message = sv.c_function("src/mail_message.c", "void MailMsg_Init(")
        self.assertEqual(re.findall(r"mailMessage->(\w+)(?:\[i\])? = (\w+);", message),
                         [("msg_bank", "MAILMSG_BANK_NONE"), ("fields", "EC_WORD_NULL")], "the number left alone")
        at = self.fields("Mail", "author_gender", "author_language", "author_version", "mail_type", "author_name",
                         "mon_icons", "form_flags", "unk_20")
        self.assertEqual(at, {"author_gender": 4, "author_language": 5, "author_version": 6, "mail_type": 7,
                              "author_name": 8, "mon_icons": 8 + 2 * (sv.PLAYER_NAME_LENGTH + 1),
                              "form_flags": 14 + 2 * (sv.PLAYER_NAME_LENGTH + 1),
                              "unk_20": 16 + 2 * (sv.PLAYER_NAME_LENGTH + 1)})
        self.assertEqual(len(sv.MAIL_INIT), sv.compile_c(("sizeof(Mail)",))[0][0])

    def test_the_game_s_rules_are_the_ones_savedit_follows(self):
        """The rules that exist only as code: the encryption's generator,
        the shiny test, the nature, the gender ratio's scale, the nature's
        tenth, the flash's halves, the clock's end, the tutor's record, the
        badges' bytes, a TM's one copy, the machines' order, the ability a
        Pokemon's bits give it and the Dex pages."""
        pokemon = (ROOT / "src/pokemon.c").read_text()
        self.assertIn("*seed = *seed * 1103515245 + 24691;\n    return (u16)(*seed >> 16);",
                      sv.c_function("src/math_util.c", "static u16 MonEncryptionLCRNG("), "mon_crypt")
        self.assertRegex(pokemon, r"#define SHINY_CHECK\(otid, pid\) \(\(\s*\\\s*\(\(\(otid\) & 0xFFFF0000u\) >> 16u\) \^ "
                                  r"\(\(otid\) & 0xFFFFu\) \^ \(\(\(pid\) & 0xFFFF0000u\) >> 16u\) \^ \(\(pid\) & 0xFFFFu\)\)"
                                  r"\s*\\\s*< 8u\)", "is_shiny")
        self.assertIn("return (u8)(pid % 25);", sv.c_function("src/pokemon.c", "u8 GetNatureFromPersonality("))
        self.assertIn("#define GENDER_RATIO(frac) ((frac) <= 1 ? (u8)((frac) * 254.75) : 255)",
                      (ROOT / "include/constants/pokemon.h").read_text())
        self.assertIn("GENDER_RATIO({{ mon.genderRatio }})", (ROOT / "files/poketool/personal/personal.json.txt").read_text())
        self.assertEqual([sv.GENDER_RATIO(f) for f in (0.0, 0.125, 0.5, 1.0, 2.0)], [0, 31, 127, 254, 255])
        gender = sv.c_function("src/pokemon.c", "u8 GetGenderBySpeciesAndPersonality_PreloadedPersonal(")
        self.assertRegex(gender, r"if \(ratio > \(u8\)pid\) \{\s*gender = MON_FEMALE;")
        nature = sv.c_function("src/pokemon.c", "u16 ModifyStatByNature(")
        self.assertRegex(nature, r"(?s)case 1:.*retVal = n \* 110;\s*retVal /= 100;.*case -1:.*retVal = n \* 90;\s*retVal /= 100;")
        self.assertIn(f"adrs = {sv.HALF:#x};", sv.c_function("src/save.c", "static u32 GetChunkOffsetFromCurrentSaveSlot("))
        self.assertIn("adrs += 0x100 - (adrs % 0x100);", sv.c_function("src/save.c", "static void SaveData_InitSubstructs("),
                      "blocks(): a slot's first block on a 0x100 boundary")
        self.assertIn("adrs += (0x100 - (adrs % 0x100));", sv.c_function("src/save.c", "static void SaveData_InitSlotSpecs("),
                      "slot_specs(): and the next slot too")
        self.assertIn(f"hours = {sv.MAX_PLAY_HOURS};", sv.c_function("src/igt.c", "void AddIGTSeconds("))
        tutor = sv.c_function("src/field/scrcmd_move_tutor.c", "static u16 GetMoveTutorLearnsetIndex(")
        self.assertIn("u16 index = species > SPECIES_ARCEUS ? species - 2 : species;", tutor, "tutor_moves")
        self.assertIn("return index - 1;", tutor)
        badge = sv.c_function("src/player_data.c", "void PlayerProfile_SetBadgeFlag(")
        self.assertRegex(badge, r"if \(badge_no < 8\) \{\s*profile->johtoBadges \|= \(1 << badge_no\);\s*\} else \{\s*"
                                r"profile->kantoBadges \|= \(1 << badge_no - 8\);", "badges()")
        self.assertIn("if (!ItemIsMachine(partyMenu->args->itemId) || ItemIsTR(partyMenu->args->itemId)) {",
                      sv.c_function("src/party_menu_items.c", "void PartyMenu_LearnMoveToSlot("),
                      "machine_table: only a TR is used up")
        self.assertIn("u16 max = ItemIsTM(itemId) ? 1 : BAG_TMHM_QUANTITY_MAX;",
                      sv.c_function("src/bag.c", "static ItemSlot *Bag_GetItemSlotForAdd("), "item_limit")
        self.assertRegex(sv.c_function("src/bag.c", "static int MachineSortGroup("),
                         r"if \(ItemIsHM\(itemId\)\) \{\s*return 2;\s*\}\s*if \(ItemIsTR\(itemId\)\) \{\s*return 1;\s*\}\s*"
                         r"return 0;", "_machine_order")
        ability = sv.c_function("src/pokemon.c", "void UpdateBoxMonAbility(")
        self.assertRegex(ability, r"(?s)MON_SWAP_ABILITY_SLOT_BIT\) \{\s*pid \^= 1;\s*\}\s*if \(\(GetBoxMonData\(boxMon, "
                                  r"MON_DATA_UNUSED_113, NULL\) & MON_HIDDEN_ABILITY_BIT\) && hiddenAbility != ABILITY_NONE\)"
                                  r".*else if \(ability2 != ABILITY_NONE\) \{\s*if \(pid & 1\) \{\s*SetBoxMonData\(boxMon, "
                                  r"MON_DATA_ABILITY, &ability2\);", "ability_slot")
        self.assertIn("return (species >= FIRST_DEX_GAP && species <= LAST_DEX_GAP) || species > NATIONAL_DEX_COUNT;",
                      sv.c_function("src/pokedex.c", "BOOL DexSpeciesIsInvalid("), "dex_species")

    def test_the_stats_are_calc_mon_stats(self):
        """stat_line and _set_party_stats are CalcMonStats (src/pokemon.c):
        each stat's formula, Shedinja's one HP, and how the HP it had
        follows a new maximum."""
        calc = sv.c_function("src/pokemon.c", "void CalcMonStats(")
        self.assertRegex(calc, r"if \(species == SPECIES_SHEDINJA\) \{\s*newMaxHp = 1;\s*\} else \{\s*"
                               r"newMaxHp = \(baseStats->hp \* 2 \+ hpIv \+ hpEv / 4\) \* level / 100 \+ level \+ 10;")
        for stat in ("atk", "def", "speed", "spatk", "spdef"):
            name = "new" + stat[0].upper() + stat[1:]
            self.assertRegex(calc, rf"{name} = \(baseStats->{stat} \* 2 \+ {stat}Iv \+ {stat}Ev / 4\) \* level / 100 \+ 5;\s*"
                                   rf"{name} = ModifyStatByNature\(nature, \(u16\){name}, STAT_{stat.upper()}\);", stat)
        self.assertRegex(calc, r"if \(hp != 0 \|\| maxHp == 0\) \{\s*if \(species == SPECIES_SHEDINJA\) \{\s*hp = 1;\s*"
                               r"\} else if \(hp == 0\) \{\s*hp = newMaxHp;\s*\} else if \(newMaxHp - maxHp < 0\) \{\s*"
                               r"if \(hp > newMaxHp\) \{\s*hp = newMaxHp;\s*\}\s*\} else \{\s*hp \+= newMaxHp - maxHp;")
        self.assertIn("nature = GetMonNatureAfterMint(mon);", calc, "a Mint's nature, as _set_party_stats reads it")
        self.assertRegex(sv.c_function("src/pokemon.c", "u8 GetMonNatureAfterMint("),
                         r"u32 mint = \(GetMonData\(mon, MON_DATA_UNUSED_114, NULL\) & MON_MINT_NATURE_MASK\) >> 1;\s*"
                         r"if \(mint != 0\) \{\s*return \(u8\)\(mint - 1\);")
        self.assertRegex(sv.c_function("src/pokemon.c", "static u32 GetBoxMonDataInternal("),
                         r"case MON_DATA_UNUSED_114:\s*ret = blockB->unused2;", "the Mint in block B's unused2")
        # And savedit's numbers are those: Chikorita at 50, IVs 31, no EVs, a neutral nature.
        record = sv.personal_records()[sv.species_numbers()["CHIKORITA"]]
        neutral = next(n for n, mods in enumerate(sv.nature_mods()) if not any(mods))
        self.assertEqual(sv.stat_line(record, 50, [31] * 6, 0, neutral)[0], (record["hp"] * 2 + 31) * 50 // 100 + 50 + 10)

    def test_what_a_new_pokemon_is_given_is_the_game_s(self):
        """preset_moves is InitBoxMonMoveset: the learnset up to the level,
        a move known already skipped (MOVE_APPEND_KNOWN), the first dropped
        when four are known; ability_of is CreateBoxMon's, the second on an
        odd personality when there is one; egg_moves reads the lists the
        way LoadEggMoves does."""
        moveset = sv.c_function("src/pokemon.c", "void InitBoxMonMoveset(")
        self.assertRegex(moveset, r"LEVEL_UP_LEARNSET_LEVEL_MASK\) > \(level << LEVEL_UP_LEARNSET_LEVEL_SHIFT\)\) \{\s*break;")
        self.assertRegex(moveset, r"if \(TryAppendBoxMonMove\(boxMon, move\) == MOVE_APPEND_FULL\) \{\s*"
                                  r"DeleteBoxMonFirstMoveAndAppend\(boxMon, move\);")
        self.assertRegex(sv.c_function("src/pokemon.c", "u32 TryAppendBoxMonMove("),
                         r"if \(cur_move == move\) \{\s*ret = MOVE_APPEND_KNOWN;")
        self.assertRegex(sv.c_function("src/pokemon.c", "void CreateBoxMon("),
                         r"iv = \(u32\)GetMonBaseStat\(species, BASE_ABILITY_2\);\s*if \(iv != 0\) \{\s*"
                         r"if \(fixedPersonality & 1\) \{\s*SetBoxMonData\(boxMon, MON_DATA_ABILITY, &iv\);")
        eggs = sv.c_function("src/get_egg.c", "u8 LoadEggMoves(")
        self.assertIn("species * MAX_EGG_MOVES * sizeof(u16), MAX_EGG_MOVES * sizeof(u16)", eggs)
        self.assertIn("dest[numEggMoves] != 0xFFFF", eggs)
        self.assertIn("LoadEggMoves(GetBoxMonData(learner, MON_DATA_SPECIES, NULL), eggMoves)",
                      sv.c_function("src/scrcmd_daycare.c", "static void Daycare_LearnEggMovesFrom("),
                      "learnable_moves: the Day-Care teaches a species' own egg moves, whatever its stage")
        self.assertRegex(sv.c_function("src/pokemon.c", "void LoadLevelUpLearnset_HandleAlternateForm("),
                         r"if \(!IsMoveUnimplemented\(LEVEL_UP_LEARNSET_MOVE\(levelUpLearnset\[i\]\)\)\) \{\s*"
                         r"levelUpLearnset\[j\+\+\] = levelUpLearnset\[i\];", "learnsets(): every reader gets it filtered")

    def test_the_machines_sit_where_the_template_packs_them(self):
        """machine_places: the bits personal.json.txt sets, and nothing for a
        number it does not pack; TM01's and HM01's bits are the places
        ItemToTMHMId gives those items."""
        layout = sv.machine_layout()
        self.assertEqual(len(set(layout.values())), len(layout), "one bit each")
        self.assertEqual(sv.machine_places({"tms": [93], "hms": [9], "machines": [50]}), [], "not packed, not set")
        items = sv.constants("include/constants/items.h", "ITEM_")
        self.assertEqual(sv.machines()[layout["tms", 1]][1], items["ITEM_TM01"])
        self.assertEqual(sv.machines()[layout["hms", 1]][1], items["ITEM_HM01"])
        self.assertEqual(sv.machine_places({"tms": [2, 1], "hms": [1]}), [layout["tms", 2], layout["tms", 1], layout["hms", 1]])

    def test_what_was_given_is_kept_where_savedit_reads_it(self):
        """The running shoes are LocalFieldData.player's hasRunningShoes, a
        bool16 the start menu and GiveRunningShoes read and write; a card is
        OR'd into registeredCards; the map's level is set as given."""
        self.assertIn("return &localFieldData->player;",
                      sv.c_function("src/save_local_field_data.c", "PlayerSaveData *LocalFieldData_GetPlayer("))
        self.assertIn("playerSaveData->hasRunningShoes == TRUE",
                      sv.c_function("src/player_avatar.c", "BOOL PlayerSaveData_CheckRunningShoes("))
        self.assertIn("PlayerSaveData_SetRunningShoesFlag(sub, TRUE);",
                      sv.c_function("src/scrcmd_17.c", "BOOL ScrCmd_GiveRunningShoes("))
        self.assertRegex(sv.c_function("src/save_pokegear.c", "void SavePokegear_RegisterCard("),
                         r"case GEARCARD_MAP:\s*pokegear->registeredCards \|= GEARCARD_MAP;\s*break;\s*"
                         r"case GEARCARD_RADIO:\s*pokegear->registeredCards \|= GEARCARD_RADIO;")
        self.assertIn("pokegear->mapUnlockLevel = mapUnlockLevel;",
                      sv.c_function("src/save_pokegear.c", "void Pokegear_SetMapUnlockLevel("))
        at, width, _ = sv._given_layout()["shoes"]
        self.assertEqual(width, 2, "bool16")
        (player, location), _ = sv.compile_c(("__builtin_offsetof(struct LocalFieldData, player)", "sizeof(Location)"),
                                             headers=sv.LAYOUT_HEADERS + ("player_avatar.h",),
                                             decls=(sv.c_struct("src/save_local_field_data.c", "LocalFieldData"),))
        self.assertEqual(at, player, "hasRunningShoes is PlayerSaveData's first field")
        self.assertGreater(player, 4 * location, "after the five Locations")

    def test_a_tile_is_read_as_the_field_reads_it(self):
        """The collision bit and the behaviour byte of a tile's attribute
        (sub_020548C0, GetMetatileBehavior), and the land data's sound
        section, which the field's loader reads before the attributes
        (ov01_021F4AAC: four bytes, then as many as their top half says);
        every member keeps its size where _land_attributes reads it."""
        asm = (ROOT / "asm/unk_02054648.s").read_text()
        body = lambda text, fn: text[text.index(f"{fn}:"):text.index(f"thumb_func_end {fn}")]
        self.assertRegex(body(asm, "sub_020548C0"), r"ldrh r0, \[r0\]\s+asr r0, r0, #0xf\s+lsl r0, r0, #0x18\s+"
                                                  r"lsr r1, r0, #0x18\s+mov r0, #1\s+and r1, r0")
        self.assertEqual(sv.COLLISION, 1 << 15)
        self.assertRegex(body(asm, "GetMetatileBehavior"), r"ldrh r0, \[r0\]\s+add sp, #4\s+lsl r0, r0, #0x18\s+lsr r0, r0, #0x18")
        self.assertEqual(sv.BEHAVIOR, 0xFF)
        loader = body((ROOT / "asm/overlay_01_021F4704.s").read_text(), "ov01_021F4AAC")
        self.assertRegex(loader, r"(?s)mov r1, #4\s+add r2, r4, r2\s+bl NARC_ReadFile\s+.*asr r0, r0, #0x10\s+lsl r0, r0, #0x10\s+"
                                 r"lsr r1, r0, #0x10\s+beq \w+.*bl NARC_ReadFile")
        self.assertEqual({struct.unpack_from("<H", member, sv.TERRAIN_OFFSET - 4)[0] for member in sv._land()}, {0x1234},
                         "the sound section's header: its magic, then its size")

    def test_a_story_step_does_what_the_script_commands_do(self):
        """_walk and _apply are the commands they stand in for: a trainer
        flag at TRAINER_FLAG_BASE, a battle taken as won, the bag's room
        checked before an item is given, Switch and Case a Compare, the
        Dex's switch, the National Dex in both places, the badge's bit."""
        self.assertIn("Save_VarsFlags_SetFlagInArray(varsFlags, trainer + TRAINER_FLAG_BASE);",
                      sv.c_function("src/script_manager.c", "void TrainerFlagSet("))
        self.assertIn("*retBattleWon = IsBattleResultWin(*winFlag);",
                      sv.c_function("src/scrcmd_battle.c", "BOOL ScrCmd_CheckBattleWon("))
        self.assertIn("Pokedex_Enable(pokedex);", sv.c_function("src/scrcmd_17.c", "BOOL ScrCmd_GivePokedex("))
        self.assertIn("PlayerProfile_SetBadgeFlag(Save_PlayerData_GetProfile(ctx->fieldSystem->saveData), badgeIdx);",
                      sv.c_function("src/scrcmd_17.c", "BOOL ScrCmd_GiveBadge("))
        self.assertIn("Pokegear_SetMapUnlockLevel(SaveData_Pokegear_Get(ctx->fieldSystem->saveData), ScriptReadByte(ctx));",
                      sv.c_function("src/scrcmd_c.c", "BOOL ScrCmd_804("))
        self.assertRegex(sv.c_function("src/scrcmd_c.c", "BOOL ScrCmd_NatDexFlagAction("),
                         r"if \(action == 1\) \{\s*Pokedex_SetNatDexFlag\([^;]*\);\s*PlayerProfile_SetNatDexFlag\(")
        fieldmap = (ROOT / "src/field/fieldmap.c").read_text()
        self.assertLess(fieldmap.index("TryStartMapScriptByType(fieldSystem, INIT_SCRIPT_ON_LOAD);"),
                        fieldmap.index("TryStartMapScriptByType(fieldSystem, INIT_SCRIPT_ON_RESUME);"),
                        "a field built again runs its OnLoad script, then its OnResume one")
        macros = (ROOT / "asm/macros/script.inc").read_text()
        for battle in sv._BATTLES:
            self.assertRegex(macros, rf"\.macro {battle}\b")
        self.assertRegex(macros, r"\.macro GoToIfNoItemSpace item, quantity, target\s*ItemVars \\item, \\quantity\s*"
                                 r"HasSpaceForItem VAR_SPECIAL_x8004, VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT")
        self.assertRegex(macros, r"\.macro GiveItemNoCheck item, quantity\s*ItemVars \\item, \\quantity\s*"
                                 r"CallStd std_give_item_verbose")
        self.assertRegex(macros, r"\.macro Switch var\s*CopyVar VAR_SPECIAL_x8008, \\var")
        self.assertRegex(macros, r"\.macro Case value, target\s*Compare VAR_SPECIAL_x8008, \\value\s*GoToIf eq, \\target")


if __name__ == "__main__":
    unittest.main()
