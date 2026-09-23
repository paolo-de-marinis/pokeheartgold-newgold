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
        known = sv.describe_mon(before[2])["moves"][0]
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
        with self.assertRaises(ValueError):
            sv.set_dex(save, [n["EGG"]], True, True)
        self.assert_only(save, ["SAVE_POKEDEX", "SAVE_PLAYERDATA"])

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

    def test_a_bad_checksum_is_reported(self):
        raw = bytearray(sv.party_raw(self.open())[0])
        raw[20] ^= 0xFF
        self.assertEqual(sv.describe_mon(bytes(raw))["ok"], False)
        with self.assertRaises(ValueError):
            sv.edit_mon(bytes(raw), level=5)


if __name__ == "__main__":
    unittest.main()
