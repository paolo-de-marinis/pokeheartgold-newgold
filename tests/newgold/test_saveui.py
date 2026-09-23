#!/usr/bin/env python3
"""saveui.py, the save editor page's server, driven over HTTP.

Every endpoint the page uses, against a library in a temporary folder and a
build folder whose emulator slots are temporary files too: the ROM's layout
is read through links to the real main.sbin and main.elf, the .nds files are
the real ROM's header alone (sealed again for their length), melonDS's
presence is a switch, and launches are SAVEUI_DRY_RUN's -- recorded, never
started. What is checked is what protects a real playthrough: a
backup before every write, a written file that reopens, an undo that gives
the old bytes back, nothing deleted, nothing reached outside the library and
the slots, and no slot written while melonDS runs.
"""

import json
import os
import struct
import sys
import tempfile
import threading
import unittest
import urllib.error
import urllib.request
from pathlib import Path

from test_level_cap import ROOT
from test_savedit import BUILD, game_like_save, party_save

sys.path[:0] = [str(ROOT / "tools/newgold/devkit")]
import savedit as sv  # noqa: E402
import saveui  # noqa: E402


def header_only(code=None):
    """The built ROM's cartridge header, saying it is all there is (and,
    given a game code, saying it is that game)."""
    with open(BUILD / "pokeheartgold.us.nds", "rb") as f:
        header = bytearray(f.read(0x200))
    if code:
        header[0x0C:0x10] = code
    struct.pack_into("<I", header, 0x80, 0x200)
    struct.pack_into("<H", header, 0x15E, saveui.nds_crc(header[:0x15E]))
    return bytes(header)


class SaveUiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (BUILD / "main.sbin").exists():
            raise unittest.SkipTest("the ROM has not been built")
        cls.tmp = tempfile.TemporaryDirectory()
        base = Path(cls.tmp.name)
        cls.template = base / "party.sav"
        game_like_save(base / "blank.sav")
        party_save(base / "blank.sav", cls.template)
        cls.build = base / "build"
        for variant in ("heartgold.us", "heartgold.us.diag"):
            folder = cls.build / variant
            folder.mkdir(parents=True)
            for name in ("main.sbin", "main.elf"):
                (folder / name).symlink_to(BUILD / name)
            (folder / "pokeheartgold.us.nds").write_bytes(header_only())
        cls.running = False
        cls.saved = saveui.melonds_running, os.environ.get("SAVEUI_DRY_RUN")
        saveui.melonds_running = lambda: cls.running
        os.environ["SAVEUI_DRY_RUN"] = "1"

    @classmethod
    def tearDownClass(cls):
        saveui.melonds_running, dry = cls.saved
        if dry is None:
            os.environ.pop("SAVEUI_DRY_RUN")
        else:
            os.environ["SAVEUI_DRY_RUN"] = dry
        cls.tmp.cleanup()

    def setUp(self):
        self.library = Path(tempfile.mkdtemp(dir=self.tmp.name))
        (self.library / "gyms").mkdir()
        self.save = self.library / "gyms/test.sav"
        self.save.write_bytes(self.template.read_bytes())
        (self.library / "junk.sav").write_bytes(b"\xff" * sv.FLASH)
        slot = self.build / "heartgold.us.diag/pokeheartgold.us.sav"
        slot.write_bytes(self.template.read_bytes())
        (self.build / "heartgold.us/pokeheartgold.us.sav").unlink(missing_ok=True)
        type(self).running = False
        self.server = saveui.serve(self.library, self.build, 0)
        self.port = saveui.Handler.port
        threading.Thread(target=self.server.serve_forever, daemon=True).start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()

    def call(self, path, body=None, headers=None):
        data = None if body is None else json.dumps(body).encode()
        request = urllib.request.Request(f"http://127.0.0.1:{self.port}{path}", data=data, headers={
            **({"Content-Type": "application/json"} if body is not None else {}), **(headers or {})})
        try:
            with urllib.request.urlopen(request) as response:
                raw = response.read()
                return response.status, raw if response.headers["Content-Type"].startswith("image/") else json.loads(raw)
        except urllib.error.HTTPError as e:
            with e:
                return e.code, json.loads(e.read())

    def ok(self, path, body=None):
        status, out = self.call(path, body)
        self.assertEqual(status, 200, out)
        return out

    def edit(self, op, args, f="gyms/test.sav"):
        return self.ok("/api/edit", {"f": f, "op": op, "args": args})

    def refused(self, path, body=None, status=400):
        got, out = self.call(path, body)
        self.assertEqual(got, status, out)
        return out["error"]

    def backups(self, key="gyms/test.sav"):
        folder = self.library / ".backups" / key
        return sorted(folder.iterdir()) if folder.is_dir() else []

    # -- the settings: the folder and the ROMs the page chooses -------------------

    def test_the_settings(self):
        base = Path(tempfile.mkdtemp(dir=self.tmp.name))
        saved = saveui.CONFIG, saveui.BROWSE_ROOTS, saveui.Handler.persist
        saveui.CONFIG, saveui.BROWSE_ROOTS, saveui.Handler.persist = base / "cfg/settings.json", [base], True
        try:
            out = self.ok("/api/settings")
            self.assertEqual(out["library"], str(self.library.resolve()))
            self.assertEqual([r["id"] for r in out["roms"]], ["hg-diag", "hg"])
            other = base / "altri salvataggi"
            other.mkdir()
            (other / "mio.sav").write_bytes(self.template.read_bytes())
            (base / "ss").mkdir()
            silver = base / "ss/silver.nds"
            silver.write_bytes(header_only(b"IPGE"))
            hg = out["roms"][0]["rom"]
            self.assertIn("non esiste", self.refused("/api/settings", {"library": str(base / "nuova"), "roms": []}))
            self.assertIn("non esiste", self.refused("/api/settings", {"library": str(other), "roms": [{"rom": str(base / "no.nds")}]}))
            self.assertIn(".nds", self.refused("/api/settings", {"library": str(other), "roms": [{"rom": str(other / "mio.sav")}]}))
            out = self.ok("/api/settings", {"library": str(other), "roms": [
                {"label": "La mia HG", "rom": hg}, {"label": "", "rom": str(silver)}, {"rom": hg}]})
            self.assertEqual([(r["id"], r["label"]) for r in out["roms"]], [("hg-diag", "La mia HG"), (saveui.rom_id(silver), "silver")])
            self.assertEqual(json.loads(saveui.CONFIG.read_text())["library"], str(other.resolve()), "kept for the next start")
            listing = self.ok("/api/library")
            self.assertEqual([e["f"] for e in listing["files"]], ["mio.sav"])
            self.assertEqual(listing["playable"], ["hg-diag"], "a SoulSilver ROM is a slot, not a game for these saves")
            key = saveui.rom_id(silver)
            self.assertIn("HeartGold", self.refused("/api/play", {"f": "mio.sav", "slot": key}))
            self.ok("/api/load", {"f": "mio.sav", "slot": key})
            self.assertEqual((base / "ss/silver.sav").read_bytes(), self.template.read_bytes(), "the .sav beside the ROM")
            created = self.ok("/api/settings", {"library": str(base / "nuova"), "roms": [], "create": True})
            self.assertTrue((base / "nuova").is_dir())
            self.assertEqual(created["roms"], [])
            # Browsing: folders, and ROMs when a ROM is wanted; nothing outside the roots.
            found = self.ok(f"/api/browse?want=nds&path={urllib.request.quote(str(base / 'ss'))}")
            self.assertEqual([f["name"] for f in found["files"]], ["silver.nds"])
            self.assertIn("altri salvataggi", self.ok(f"/api/browse?want=dir&path={urllib.request.quote(str(base))}")["dirs"])
            self.assertIn("si sfoglia solo", self.refused("/api/browse?want=dir&path=/etc"))
        finally:
            saveui.CONFIG, saveui.BROWSE_ROOTS, saveui.Handler.persist = saved

    # -- reading ------------------------------------------------------------

    def test_the_library(self):
        (self.library / ".hidden").mkdir()
        (self.library / ".hidden/secret.sav").write_bytes(self.template.read_bytes())
        (self.library / "link.sav").symlink_to(self.save)
        out = self.ok("/api/library")
        files = {e["f"]: e for e in out["files"]}
        self.assertEqual(set(files), {"gyms/test.sav", "junk.sav"}, "no hidden folder, no link")
        self.assertTrue(files["gyms/test.sav"]["valid"])
        self.assertEqual([m["name"] for m in files["gyms/test.sav"]["party"]][:2], ["Chikorita", "Pidgey"])
        self.assertFalse(files["junk.sav"]["valid"])
        self.assertEqual(files["junk.sav"]["error"], "nessuna delle due metà della flash contiene un salvataggio integro")
        self.assertEqual([(s["slot"], s["exists"]) for s in out["slots"]], [("hg-diag", True), ("hg", False)])
        self.assertEqual(out["playable"], ["hg-diag", "hg"])

    def test_a_save_in_full(self):
        out = self.ok("/api/save?f=gyms/test.sav")
        self.assertEqual(out["profile"]["name"], "A")
        self.assertEqual(len(out["party"]), 6)
        self.assertEqual(out["boxes"]["mons"][2][5]["species_name"], "Mew")
        self.assertEqual(out["info"]["counter"], 2)
        self.assertEqual(out["backups"], [])
        self.assertIn("FLAG_UNK_076", [r["name"] for r in self.ok("/api/flags?f=gyms/test.sav&q=UNK_076")["rows"]])
        found = self.ok("/api/flags?f=gyms/test.sav&q=UNK")
        self.assertEqual((len(found["rows"]), found["rows"][0]["kind"]), (300, "var"), "the variables first")
        self.assertGreater(found["total"], 1300)
        self.assertNotIn("VAR_BASE", [r["name"] for r in self.ok("/api/flags?f=gyms/test.sav&q=VAR_")["rows"]])
        data = self.ok("/api/data")
        self.assertEqual(len(data["natures"]), 25)
        self.assertIn(sv.species_numbers()["PIKACHU"], data["dex"])
        n = sv.species_numbers()["CHIKORITA"]
        self.assertEqual(self.ok(f"/api/learnset?species={n}&level=20"), sv.moveset(n, 20))

    def test_no_build_is_not_a_bad_save(self):
        """With no build to measure the layout from (a make clean, a wrong
        --build) no file can be read: the library says so once, rather
        than calling every save invalid."""
        empty = Path(tempfile.mkdtemp(dir=self.tmp.name))
        (empty / "heartgold.us").mkdir()
        library = saveui.Library(self.library, empty, roms=[])
        listing = library.listing()
        self.assertIn("non trovo la build", listing["build"])
        self.assertEqual({e["valid"] for e in listing["files"]}, {None})
        with self.assertRaises(saveui.Refused) as refused:
            library.detail("gyms/test.sav")
        self.assertEqual(refused.exception.code, "build")
        self.assertIsNone(self.ok("/api/library")["build"])

    def test_an_icon_has_the_games_palette(self):
        status, png = self.call(f"/api/icon?species={sv.species_numbers()['PIKACHU']}")
        self.assertEqual(status, 200)
        self.assertTrue(png.startswith(b"\x89PNG"))
        self.assertIn(b"tRNS", png)
        self.assertEqual(self.call("/api/icon?species=1&egg=1")[0], 200)

    # -- writing ------------------------------------------------------------

    def test_an_edit_is_backed_up_and_undone(self):
        before = self.save.read_bytes()
        out = self.edit("trainer", {"money": 123456, "johto": 0xFF, "name": "Paolo", "play_time": [5, 6, 7]})
        self.assertEqual((out["profile"]["money"], out["profile"]["johto"], out["profile"]["name"]),
                         (123456, 0xFF, "Paolo"))
        self.assertEqual(len(self.backups()), 1)
        self.assertEqual(self.backups()[0].read_bytes(), before)
        again = sv.Save(self.save)
        self.assertEqual(sv.profile(again)["play_time"], [5, 6, 7])
        # The Pokemon were the player's under the old name, and still are.
        self.assertEqual({m["ot_name"] for m in out["party"]}, {"Paolo"})
        self.ok("/api/undo", {"f": "gyms/test.sav"})
        self.assertEqual(self.save.read_bytes(), before)
        self.assertEqual([b.name.count("-") > 2 for b in self.backups()], [True, True], "nothing deleted")
        self.assertIn("nulla da annullare", self.refused("/api/undo", {"f": "gyms/test.sav"}))

    def test_a_page_that_is_behind_the_file(self):
        """The page read the file, then melonDS (here savedit) moved it on:
        the page's form, sent whole, must not put the old values back."""
        seen = self.ok("/api/save?f=gyms/test.sav")["version"]
        save = sv.Save(self.save)
        sv.set_profile(save, money=7777, johto=0b111)
        self.save.write_bytes(save.image())
        moved = self.save.read_bytes()
        got, out = self.call("/api/edit", {"f": "gyms/test.sav", "op": "trainer", "version": seen,
                                           "args": {"name": "Paola", "money": 3000, "johto": 0}})
        self.assertEqual((got, out["code"]), (400, "stale"))
        self.assertEqual(self.save.read_bytes(), moved)
        now = self.ok("/api/state?f=gyms/test.sav")["version"]
        self.assertNotEqual(now, seen)
        self.assertEqual(now, self.ok("/api/save?f=gyms/test.sav")["version"])
        out = self.ok("/api/edit", {"f": "gyms/test.sav", "op": "trainer", "version": now, "args": {"name": "Paola"}})
        self.assertEqual((out["profile"]["name"], out["profile"]["money"]), ("Paola", 7777))

    def test_undo_keeps_what_happened_after_the_edit(self):
        """An edit, then an hour in melonDS: Annulla would throw the hour
        away with the edit, so it refuses; Cronologia still restores."""
        self.edit("trainer", {"money": 1})
        save = sv.Save(self.save)
        sv.set_profile(save, johto=0b1, play_time=[3, 0, 0])
        self.save.write_bytes(save.image())
        played = self.save.read_bytes()
        self.assertIn("Cronologia", self.refused("/api/undo", {"f": "gyms/test.sav"}))
        self.assertEqual(self.save.read_bytes(), played)
        seen = self.ok("/api/save?f=gyms/test.sav")["version"]
        self.assertEqual(self.call("/api/undo", {"f": "gyms/test.sav", "version": "0" * 40})[1]["code"], "stale")
        out = self.ok("/api/restore", {"f": "gyms/test.sav", "backup": self.backups()[0].name})
        self.assertEqual(out["profile"]["money"], sv.profile(sv.Save(self.template))["money"])
        # Undo of that restore is allowed: nothing has touched the file since.
        self.assertNotEqual(out["version"], seen)
        out = self.ok("/api/undo", {"f": "gyms/test.sav", "version": out["version"]})
        self.assertEqual(self.save.read_bytes(), played)

    def test_nothing_changed_writes_nothing(self):
        now = self.ok("/api/save?f=gyms/test.sav")["party"][0]
        self.edit("party_edit", {"slot": 0, "species": now["species"], "level": now["level"],
                                 "nature": now["nature"], "moves": [m["id"] for m in now["moves"]]})
        self.assertEqual(self.backups(), [])

    def test_the_party(self):
        before = sv.party_raw(sv.Save(self.save))
        n = sv.species_numbers()
        out = self.edit("party_edit", {"slot": 2, "species": n["GARCHOMP"], "level": 55, "item": 234,
                                       "ivs": [31] * 6, "evs": [0, 252, 0, 252, 4, 0]})
        after = sv.party_raw(sv.Save(self.save))
        self.assertEqual([a == b for a, b in zip(before, after)], [True, True, False, True, True, True])
        self.assertEqual((out["party"][2]["species_name"], out["party"][2]["level"], out["party"][2]["item"]),
                         ("Garchomp", 55, 234))
        self.assertIn("510", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "party_edit",
                                                        "args": {"slot": 0, "evs": [255, 255, 1, 0, 0, 0]}}))
        self.assertIn("almeno una mossa", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "party_edit",
                                                                     "args": {"slot": 0, "moves": [0, 0]}}))
        self.edit("party_swap", {"a": 0, "b": 1})
        self.edit("party_remove", {"slot": 5})
        out = self.edit("party_add", {"species": n["MEW"], "level": 12, "nature": 3, "moves": []})
        self.assertEqual((out["party"][5]["species_name"], out["party"][5]["nature"]), ("Mew", 3))
        self.assertTrue(out["party"][5]["moves"], "no moves given: the species' own")
        self.assertEqual(out["party"][0]["species_name"], "Pidgey")
        self.assertIn("sei", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "party_add",
                                                        "args": {"species": 1, "level": 5}}))

    def test_a_player_with_no_name_gives_none(self):
        """A save sealed from RAM at the title screen has a name of zeroes,
        no EOS: a Pokemon made then would carry it as its trainer's."""
        save = sv.Save(self.save)
        save.block("SAVE_PLAYERDATA")[sv.NAME:sv.NAME + 16] = bytes(16)
        self.save.write_bytes(save.image())
        n = sv.species_numbers()
        self.assertIn("non ha ancora un nome", self.refused("/api/edit", {
            "f": "gyms/test.sav", "op": "box_add", "args": {"box": 0, "slot": 0, "species": n["CHIKORITA"], "level": 5}}))
        self.edit("trainer", {"name": "Paolo"})
        out = self.edit("box_add", {"box": 0, "slot": 0, "species": n["CHIKORITA"], "level": 5})
        self.assertEqual(out["boxes"]["mons"][0][0]["ot_name"], "Paolo")

    def test_the_boxes(self):
        n = sv.species_numbers()
        out = self.edit("box_add", {"box": 29, "slot": 29, "species": n["TOGEKISS"], "level": 40})
        self.assertEqual(out["boxes"]["mons"][29][29]["species_name"], "Togekiss")
        self.assertIn("occupato", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "box_add",
                                                             "args": {"box": 29, "slot": 29, "species": 1, "level": 5}}))
        out = self.edit("box_edit", {"box": 29, "slot": 29, "level": 41})
        self.assertEqual(out["boxes"]["mons"][29][29]["level"], 41)
        self.assertIn("sei", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "withdraw",
                                                        "args": {"box": 2, "slot": 5}}))
        out = self.edit("deposit", {"slot": 0, "box": 2})
        self.assertEqual(out["boxes"]["mons"][2][0]["species_name"], "Chikorita")
        self.assertEqual(len(out["party"]), 5)
        out = self.edit("withdraw", {"box": 2, "slot": 5})
        self.assertEqual(out["party"][-1]["species_name"], "Mew")
        out = self.edit("box_remove", {"box": 29, "slot": 29})
        self.assertIsNone(out["boxes"]["mons"][29][29])

    def test_only_species_a_pokemon_can_be(self):
        """504 is a row of the form table, not Rotom Wash; a Mega is a
        battle's. Neither is offered or made; one already there is kept."""
        n = sv.species_numbers()
        rows = {r["id"]: r for r in self.ok("/api/data")["species"]}
        self.assertEqual([i for i in range(n["EGG"], n["ROTOM_MOW"] + 1) if rows[i]["pick"]], [])
        self.assertFalse(rows[n["MEGA_VENUSAUR"]]["pick"])
        self.assertEqual(rows[n["SLOWPOKE_GALARIAN"]]["label"], "Slowpoke (Slowpoke Galarian)")
        self.assertTrue(rows[n["SLOWPOKE_GALARIAN"]]["pick"])
        for species in (n["ROTOM_WASH"], n["MEGA_VENUSAUR"]):
            self.assertIn("non si può scegliere", self.refused("/api/edit", {
                "f": "gyms/test.sav", "op": "box_add", "args": {"box": 0, "slot": 0, "species": species, "level": 40}}))
            self.assertIn("non si può scegliere", self.refused("/api/edit", {
                "f": "gyms/test.sav", "op": "party_edit", "args": {"slot": 0, "species": species}}))
        with self.assertRaises(ValueError):
            sv.new_mon(n["ROTOM_WASH"], 40, sv.owner(sv.Save(self.save)))
        save = sv.Save(self.save)
        sv.set_box_mon(save, 0, 0, sv.build_mon("ROTOM_WASH", 40)[:sv.BOX_MON])
        self.save.write_bytes(save.image())
        out = self.edit("box_edit", {"box": 0, "slot": 0, "species": n["ROTOM_WASH"], "item": 234})
        self.assertEqual((out["boxes"]["mons"][0][0]["species"], out["boxes"]["mons"][0][0]["item"]), (n["ROTOM_WASH"], 234))

    def test_bag_dex_position_flags(self):
        items = {row["const"]: row["id"] for row in sv.item_table().values()}
        out = self.edit("item", {"item": items["ITEM_POTION"], "quantity": 7})
        self.assertEqual(out["bag"]["medicine"], [{"item": items["ITEM_POTION"], "quantity": 7, "name": "Potion"}])
        out = self.edit("item", {"item": items["ITEM_POTION"], "quantity": 0})
        self.assertEqual(out["bag"]["medicine"], [])
        n = sv.species_numbers()
        out = self.edit("dex", {"changes": [{"id": n["BULBASAUR"], "seen": True, "caught": True}]})
        self.assertEqual((out["dex"]["seen"], out["dex"]["caught"]), ([n["BULBASAUR"]], [n["BULBASAUR"]]))
        out = self.edit("dex_all", {"mode": "caught"})
        self.assertEqual(len(out["dex"]["caught"]), len(sv.dex_species()))
        out = self.edit("dex_switches", {"enabled": True, "national": True})
        self.assertEqual((out["dex"]["enabled"], out["dex"]["national"]), (True, True))
        out = self.edit("position", {"map": 80, "x": 10, "y": 9, "direction": 0})
        self.assertEqual(out["position"]["current"]["map"], 80)
        self.assertTrue(out["position"]["by_warp"])
        self.edit("flag", {"number": 0x76, "value": True})
        self.edit("var", {"number": 0x4079, "value": 2})
        found = {r["name"]: r["value"] for r in self.ok("/api/flags?f=gyms/test.sav&q=UNK_07")["rows"]}
        self.assertEqual(found["FLAG_UNK_076"], 1)
        self.assertEqual(self.ok("/api/flags?f=gyms/test.sav&q=4079")["rows"][0]["value"], 2)
        self.assertEqual(len(self.backups()), 8, "one backup a write")
        self.assertIn("mappa", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "position",
                                                          "args": {"map": 60000, "x": 1, "y": 1}}))
        # Off the map, or on no map: Continue would leave the player on black.
        for where, x, y in ((0, 1, 1), (33, 5000, 5000), (80, 200, 200), (33, 5, 5)):
            self.refused("/api/edit", {"f": "gyms/test.sav", "op": "position", "args": {"map": where, "x": x, "y": y}})
        self.assertIn("x 576–671 e y 384–415", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "position",
                                                               "args": {"map": 33, "x": 5, "y": 5}}))
        out = self.edit("position", {"map": 33, "x": 655, "y": 400, "direction": 3})
        self.assertEqual(out["position"]["current"], {"map": 33, "warp": -1, "x": 655, "y": 400, "direction": 3})
        self.assertNotIn(0, [m["id"] for m in self.ok("/api/data")["maps"]])

    def test_files(self):
        self.edit("trainer", {"money": 1})
        self.assertEqual(self.ok("/api/duplicate", {"f": "gyms/test.sav", "name": "copia"})["f"], "copia.sav")
        self.assertIn("esiste già", self.refused("/api/duplicate", {"f": "gyms/test.sav", "name": "copia"}))
        self.assertEqual(self.ok("/api/rename", {"f": "gyms/test.sav", "name": "gyms/nuovo"})["f"], "gyms/nuovo.sav")
        self.assertFalse(self.save.exists())
        self.assertEqual(len(self.backups("gyms/nuovo.sav")), 1, "the history follows the file")
        self.ok("/api/trash", {"f": "gyms/nuovo.sav"})
        trash = self.ok("/api/library")["trash"]
        self.assertEqual([t["f"] for t in trash], ["gyms/nuovo.sav"])
        self.assertEqual(self.ok("/api/untrash", {"t": trash[0]["t"]})["f"], "gyms/nuovo.sav")
        backup = self.backups("gyms/nuovo.sav")[0]
        out = self.ok("/api/restore", {"f": "gyms/nuovo.sav", "backup": backup.name})
        self.assertEqual(out["profile"]["money"], sv.profile(sv.Save(self.template))["money"])
        self.assertEqual(len(self.backups("gyms/nuovo.sav")), 2)

    def test_a_new_file_has_no_history(self):
        """A history is the file's, through the bin and back: a new file
        under a name that had one must not undo into the old file."""
        self.ok("/api/duplicate", {"f": "gyms/test.sav", "name": "storia/a"})
        self.edit("trainer", {"money": 777}, f="storia/a.sav")
        self.ok("/api/trash", {"f": "storia/a.sav"})
        self.assertIn("non c'è più", self.refused("/api/trash", {"f": "storia/a.sav"}))
        self.ok("/api/duplicate", {"f": "junk.sav", "name": "storia/a"})
        self.assertIn("storia/a.sav", [e["f"] for e in self.ok("/api/library")["files"]])
        self.assertIn("nulla da annullare", self.refused("/api/undo", {"f": "storia/a.sav"}))
        trash = self.ok("/api/library")["trash"]
        self.assertEqual(self.call("/api/untrash", {"t": trash[0]["t"]})[1]["code"], "exists", "storia/a.sav is taken")
        self.assertEqual(self.ok("/api/untrash", {"t": trash[0]["t"], "name": "storia/b"})["f"], "storia/b.sav")
        self.assertEqual(len(self.backups("storia/b.sav")), 1, "its own history came back with it")
        self.ok("/api/undo", {"f": "storia/b.sav"})
        self.assertEqual(self.save.read_bytes(), (self.library / "storia/b.sav").read_bytes())
        # Renamed away, then the name used again.
        self.ok("/api/rename", {"f": "storia/b.sav", "name": "storia/c"})
        self.assertEqual(len(self.backups("storia/c.sav")), 2)
        self.ok("/api/duplicate", {"f": "junk.sav", "name": "storia/b"})
        self.assertEqual(self.backups("storia/b.sav"), [])

    def test_the_emulator_slots(self):
        slot = self.build / "heartgold.us.diag/pokeheartgold.us.sav"
        old = slot.read_bytes()
        self.edit("trainer", {"money": 42})
        type(self).running = True
        self.assertIn("melonDS", self.refused("/api/load", {"f": "gyms/test.sav", "slot": "hg-diag"}))
        self.assertIn("melonDS", self.refused("/api/play", {"f": "gyms/test.sav", "slot": "hg-diag"}))
        self.assertIn("melonDS", self.refused("/api/edit", {"f": "emu:hg-diag", "op": "trainer", "args": {"money": 1}}))
        self.assertEqual(slot.read_bytes(), old)
        type(self).running = False
        # The slot holds a save no library file is (the edit moved the one it
        # matched): progress made in melonDS would be, so it is asked for.
        got, out = self.call("/api/load", {"f": "gyms/test.sav", "slot": "hg-diag"})
        self.assertEqual((got, out["code"]), (400, "unsaved"))
        self.assertIn("contiene progressi", self.refused("/api/play", {"f": "gyms/test.sav", "slot": "hg-diag"}))
        self.assertEqual(slot.read_bytes(), old)
        self.ok("/api/load", {"f": "gyms/test.sav", "slot": "hg-diag", "force": True})
        self.assertEqual(slot.read_bytes(), self.save.read_bytes())
        self.assertEqual(self.backups("emulatore/hg-diag")[0].read_bytes(), old)
        # A slot the library holds a copy of is loaded over without asking.
        self.ok("/api/duplicate", {"f": "gyms/test.sav", "name": "copia"})
        self.edit("trainer", {"money": 43})
        self.ok("/api/load", {"f": "gyms/test.sav", "slot": "hg-diag"})
        # Gioca on the slot itself: melonDS on it as it is, nothing copied.
        before = slot.read_bytes()
        self.ok("/api/play", {"f": "emu:hg-diag", "slot": "hg-diag"})
        self.assertEqual(saveui.LAUNCHED[-1], (self.build / "heartgold.us.diag/pokeheartgold.us.nds").resolve())
        self.assertEqual(slot.read_bytes(), before)
        self.ok("/api/play", {"f": "gyms/test.sav", "slot": "hg"})
        self.assertEqual(saveui.LAUNCHED[-1], (self.build / "heartgold.us/pokeheartgold.us.nds").resolve())
        self.assertIn("non c'è lo slot", self.refused("/api/play", {"f": "gyms/test.sav", "slot": "ss"}))
        self.assertEqual(self.ok("/api/take", {"slot": "hg-diag", "name": "dal-gioco"})["f"], "dal-gioco.sav")
        self.assertEqual((self.library / "dal-gioco.sav").read_bytes(), slot.read_bytes())
        self.assertIn("non è un salvataggio valido", self.refused("/api/load", {"f": "junk.sav", "slot": "hg-diag"}))
        out = self.edit("trainer", {"money": 7}, f="emu:hg-diag")
        self.assertEqual(out["profile"]["money"], 7)

    # -- what it will not do ------------------------------------------------

    def test_a_slot_needs_a_rom_melonds_can_play(self):
        rom = self.build / "heartgold.us.diag/pokeheartgold.us.nds"
        slot = rom.with_suffix(".sav")
        good = rom.read_bytes()
        launched = len(saveui.LAUNCHED)
        try:
            rom.write_bytes(b"fake\n")
            error = self.refused("/api/play", {"f": "gyms/test.sav", "slot": "hg-diag"})
            self.assertIn("non è una ROM del Nintendo DS (5 byte", error)
            self.assertIn(str(rom), error)
            self.assertIn("non è una ROM", self.refused("/api/load", {"f": "gyms/test.sav", "slot": "hg-diag"}))
            self.assertEqual(slot.read_bytes(), self.template.read_bytes(), "nothing written")
            self.assertEqual(len(saveui.LAUNCHED), launched, "nothing launched")
            listed = {s["slot"]: s for s in self.ok("/api/library")["slots"]}
            self.assertIn("non è una ROM", listed["hg-diag"]["problem"])
            self.assertEqual(self.ok("/api/library")["playable"], ["hg"])
            rom.write_bytes(good[:0x1FF])
            self.assertIn("non è una ROM", saveui.rom_problem(rom, slot))
            header = bytearray(good)
            struct.pack_into("<I", header, 0x80, 0x10000)
            struct.pack_into("<H", header, 0x15E, saveui.nds_crc(header[:0x15E]))
            rom.write_bytes(header)
            self.assertIn("troncata", saveui.rom_problem(rom, slot))
        finally:
            rom.write_bytes(good)
        self.assertIsNone(saveui.rom_problem(rom, slot))
        # Launched for real, melonDS's sandbox keeps /tmp to itself.
        os.environ.pop("SAVEUI_DRY_RUN")
        try:
            problem = saveui.rom_problem(rom, slot)
            self.assertIsNotNone(problem)
            self.assertTrue("/tmp" in problem or "flatpak" in problem, problem)
        finally:
            os.environ["SAVEUI_DRY_RUN"] = "1"

    def test_the_built_rom_passes(self):
        """The real ROM and the real slot beside it, only read."""
        real = BUILD / "pokeheartgold.us.nds"
        if not real.exists() or saveui.flatpak_folders() is None:
            self.skipTest("no built ROM or no melonDS flatpak here")
        os.environ.pop("SAVEUI_DRY_RUN")
        try:
            self.assertIsNone(saveui.rom_problem(real, real.with_suffix(".sav")))
        finally:
            os.environ["SAVEUI_DRY_RUN"] = "1"

    def test_what_is_refused_is_said_in_italian(self):
        (self.library / "corto.sav").write_bytes(self.template.read_bytes()[:1000])
        (self.library / "vuoto.sav").write_bytes(b"")
        files = {e["f"]: e for e in self.ok("/api/library")["files"]}
        self.assertIn("il file ha 1000 byte, un salvataggio ne ha 524288", files["corto.sav"]["error"])
        self.assertIn("il file ha 0 byte", files["vuoto.sav"]["error"])
        for op, args, said in (("var", {"number": 1, "value": 2}, "variabile: da 16384"),
                               ("flag", {"number": 0xFFFF, "value": True}, "flag: da 1"),
                               ("dex", {"changes": [{"id": 494, "seen": True, "caught": False}]}, "pagina nel Pokédex"),
                               ("trainer", {"play_time": [1, 2]}, "ore, minuti e secondi")):
            self.assertIn(said, self.refused("/api/edit", {"f": "gyms/test.sav", "op": op, "args": args}))
        self.assertIn("non c'è più", self.refused("/api/rename", {"f": "gone.sav", "name": "altro"}))
        self.assertIn("non c'è più", self.refused("/api/trash", {"f": "gone.sav"}))
        self.assertFalse((self.library / ".trash").exists(), "no empty folder left in the bin")

    def test_paths_that_leave_the_library(self):
        outside = Path(self.tmp.name) / "outside.sav"
        outside.write_bytes(self.template.read_bytes())
        (self.library / "gyms/out").symlink_to(Path(self.tmp.name))
        for f in ("../outside.sav", str(outside), "gyms/../../outside.sav", ".backups/x.sav",
                  "gyms/out/outside.sav", "emu:../../x", "emu:ss", "gyms/test"):
            self.refused(f"/api/save?f={f}")
            self.refused("/api/edit", {"f": f, "op": "trainer", "args": {"money": 1}})
        self.refused("/api/duplicate", {"f": "gyms/test.sav", "name": "../escape"})
        self.refused("/api/untrash", {"t": "../gyms/test.sav"})
        self.refused("/api/restore", {"f": "gyms/test.sav", "backup": "../../gyms/test.sav"})
        self.refused("/api/edit", {"f": "gyms/test.sav", "op": "__init__", "args": {}})
        self.assertEqual(sv.profile(sv.Save(outside))["money"], sv.profile(sv.Save(self.template))["money"])

    def test_a_slot_reached_through_the_library_is_a_slot(self):
        """A library folder that holds a ROM's folder lists the slot's .sav
        as a file; written that way while melonDS runs, melonDS would write
        over it when it closes."""
        library = saveui.Library(self.tmp.name, self.build)
        rel = "build/heartgold.us.diag/pokeheartgold.us.sav"
        self.assertIn(rel, [e["f"] for e in library.listing()["files"]])
        type(self).running = True
        with self.assertRaises(saveui.Refused) as refused:
            library.edit(rel, "trainer", {"money": 1})
        self.assertIn("melonDS", str(refused.exception))
        with self.assertRaises(saveui.Refused):
            library.throw(rel)
        type(self).running = False
        self.assertEqual(library.edit(rel, "trainer", {"money": 1})["profile"]["money"], 1)

    def test_no_library_folder_reads_and_writes_nothing(self):
        library = saveui.Library(Path(self.tmp.name) / "nessuna", self.build)
        listing = library.listing()
        self.assertEqual((listing["missing"], listing["files"], listing["trash"]), (True, [], []))
        for call in (lambda: library.detail("a.sav"), lambda: library.duplicate("emu:hg-diag", "a"),
                     lambda: library.edit("emu:hg-diag", "trainer", {"money": 1})):
            with self.assertRaises(saveui.Refused) as refused:
                call()
            self.assertEqual(refused.exception.code, "nolibrary")
        self.assertFalse((Path(self.tmp.name) / "nessuna").exists())

    def test_only_this_page_may_ask(self):
        body = {"f": "gyms/test.sav", "op": "trainer", "args": {"money": 1}}
        self.assertEqual(self.call("/api/edit", body, {"Origin": "http://evil.example"})[0], 403)
        self.assertEqual(self.call("/api/edit", body, {"Content-Type": "text/plain"})[0], 403)
        self.assertEqual(self.call("/api/library", None, {"Host": "evil.example"})[0], 403)
        self.assertEqual(self.backups(), [])
        self.assertEqual(self.server.server_address[0], "127.0.0.1")


if __name__ == "__main__":
    unittest.main()
