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
import re
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
        return sorted(folder.glob("*.sav")) if folder.is_dir() else []

    def test_dragging_a_pokemon(self):
        """op "move": the page's drag. Onto another the two swap; onto an
        empty box slot or past the party's last it goes there; the party
        keeps one Pokemon able to battle, and every box it touched is marked
        for the game's next save."""
        names = lambda out: [m["species_name"] for m in out["party"]]
        start = names(self.ok(f"/api/save?f=gyms/test.sav"))
        out = self.edit("move", {"from": {"kind": "party", "slot": 0}, "to": {"kind": "party", "slot": 1}})
        self.assertEqual(names(out)[:2], [start[1], start[0]])
        out = self.edit("move", {"from": {"kind": "party", "slot": 0}, "to": {"kind": "box", "box": 29, "slot": 29}})
        self.assertEqual(out["boxes"]["mons"][29][29]["species_name"], start[1])
        self.assertEqual(len(out["party"]), len(start) - 1)
        out = self.edit("move", {"from": {"kind": "box", "box": 29, "slot": 29}, "to": {"kind": "party", "slot": len(out["party"])}})
        self.assertEqual(names(out)[-1], start[1], "past the last: it joins at the end")
        self.assertIsNone(out["boxes"]["mons"][29][29])
        self.assertEqual(out["party"][-1]["hp"], out["party"][-1]["stats"][0], "at full HP")
        save = sv.Save(self.save)
        pc = save.entry("SAVE_PCSTORAGE")["offset"]
        self.assertTrue(struct.unpack_from("<I", save.region, pc + sv.BOX_MODIFIED)[0] >> 29 & 1, "box 30 marked for the game")
        for n in range(len(out["party"]) - 1):   # all but one into box 29
            self.edit("move", {"from": {"kind": "party", "slot": 0}, "to": {"kind": "box", "box": 28, "slot": n}})
        self.assertIn("almeno un Pokémon", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "move", "args": {
            "from": {"kind": "party", "slot": 0}, "to": {"kind": "box", "box": 1, "slot": 0}}}))
        self.assertIn("posizione non valida", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "move", "args": {
            "from": {"kind": "shelf"}, "to": {"kind": "box", "box": 1, "slot": 0}}}))

    def test_a_start_replaces_an_editor_running_older_code(self):
        self.assertEqual(saveui.already_serving(self.port), saveui.CODE, "the running one says what code it is")
        self.assertIsNone(saveui.already_serving(1), "nothing answers there")
        self.assertTrue(saveui.stop_outdated(self.port), "asked to stop, it stops")
        self.assertIsNone(saveui.already_serving(self.port))

    def test_a_changed_tree_is_what_the_page_gets_next(self):
        """A file of the tree saved since it was read: the next request reads
        it again, and the state the page polls says the tree has moved on,
        so the page asks for the names and the limits again."""
        seen = self.ok("/api/data")["tree"]
        self.assertEqual(self.ok("/api/state")["tree"], seen)
        header = sv.ROOT / "include/constants/pokemon.h"
        self.ok("/api/data")
        sv._READ[header] -= 1   # as if saved since
        self.assertEqual(self.ok("/api/state")["tree"], seen + 1)
        self.assertEqual(self.ok("/api/data")["tree"], seen + 1)

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
        self.assertEqual(self.ok(f"/api/species?species={n}&level=20")["preset"], sv.preset_moves(n, 20))

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

    def test_a_build_older_than_the_headers_is_said(self):
        """The blocks are measured from the build, their fields read from
        the headers: a header saved after the build was linked is named, a
        build linked after them names none."""
        old = Path(tempfile.mkdtemp(dir=self.tmp.name))
        (old / "main.elf").write_bytes(b"")
        os.utime(old / "main.elf", ns=(0, 0))
        self.assertIn("include/constants/pokemon.h", sv.build_behind(old))
        os.utime(old / "main.elf", ns=(1 << 62, 1 << 62))
        self.assertEqual(sv.build_behind(old), [])
        self.assertIsInstance(self.ok("/api/library")["behind"], list)

    def test_a_pokemon_is_held_to_the_headers_limits(self):
        """New Gold's MAX_EV_PER_STAT is 252, not the byte's 255, and a
        level is at most MAX_LEVEL: what the headers say, not the editor."""
        edit = {"f": "gyms/test.sav", "op": "party_edit"}
        self.assertEqual(sv.MAX_EV_PER_STAT, 252)
        self.assertIn("da 0 a 252", self.refused("/api/edit", {**edit, "args": {"slot": 0, "evs": [253, 0, 0, 0, 0, 0]}}))
        self.assertIn(f"da 1 a {sv.MAX_LEVEL}", self.refused("/api/edit", {**edit, "args": {"slot": 0, "level": 101}}))

    def test_an_icon_has_the_games_palette(self):
        status, png = self.call(f"/api/icon?species={sv.species_numbers()['PIKACHU']}")
        self.assertEqual(status, 200)
        self.assertTrue(png.startswith(b"\x89PNG"))
        self.assertIn(b"tRNS", png)
        self.assertEqual(self.call("/api/icon?species=1&egg=1")[0], 200)
        self.assertIn(saveui.ICONS / f"poke_icon_{sv.species_numbers()['PIKACHU'] + 7:08d}.png", sv._READ,
                      "an icon served is watched: a new one moves the tree on, and the page asks again")
        # The browser keeps it but asks each time: a restarted server gives the same address.
        url = f"http://127.0.0.1:{self.port}/api/icon?species={sv.species_numbers()['PIKACHU']}"
        with urllib.request.urlopen(url) as response:
            tag = response.headers["ETag"]
            self.assertEqual((response.headers["Cache-Control"], tag.strip('"')), ("no-cache", saveui.digest(png)[:16]))
        with self.assertRaises(urllib.error.HTTPError) as unchanged:
            urllib.request.urlopen(urllib.request.Request(url, headers={"If-None-Match": tag}))
        self.assertEqual(unchanged.exception.code, 304)
        unchanged.exception.close()
        with urllib.request.urlopen(urllib.request.Request(url, headers={"If-None-Match": '"0"'})) as response:
            self.assertEqual(response.read(), png, "another icon than the browser's: this one")

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

    def test_a_backup_cut_short_is_passed_over(self):
        """A kill in the middle of copying a backup (before backups were
        written whole) left a short file that undo stopped at."""
        before = self.save.read_bytes()
        self.edit("trainer", {"money": 1})
        self.edit("trainer", {"money": 2})
        short = self.library / ".backups/gyms/test.sav/29991231-235959-999999.sav"
        short.write_bytes(before[:4096])
        self.assertEqual(self.ok("/api/undo", {"f": "gyms/test.sav"})["profile"]["money"], 1)
        self.ok("/api/undo", {"f": "gyms/test.sav"})
        self.assertEqual(self.save.read_bytes(), before)
        self.assertEqual([p.name for p in self.backups() if p.name.startswith(".")], [], "no partial copies left")

    def test_nothing_changed_writes_nothing(self):
        now = self.ok("/api/save?f=gyms/test.sav")["party"][0]
        out = self.edit("party_edit", {"slot": 0, "species": now["species"], "level": now["level"],
                                       "nature": now["nature"], "moves": [m["id"] for m in now["moves"]]})
        self.assertEqual((self.backups(), out["changed"]), ([], False))
        self.assertTrue(self.edit("trainer", {"money": 5})["changed"])

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

    def test_what_a_species_offers(self):
        """The dialog's lists: every move Charizard can learn, each with all
        its sources, its two abilities by slot, the game's moves at the
        level, and the ability a Pokemon's bits give it as Charizard."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        out = self.ok(f"/api/species?species={n['CHARIZARD']}&level=5&hidden=1&bit=1")
        offered = {m["id"]: m["sources"] for m in out["moves"]}
        self.assertEqual(offered, sv.learnable_moves(n["CHARIZARD"]))
        self.assertGreater(len(offered[moves["FLAMETHROWER"]]), 3, "every source, not the first")
        self.assertNotIn(moves["SURF"], offered)
        self.assertEqual([a["slot"] for a in out["abilities"]], [0, sv.HIDDEN_SLOT])
        self.assertEqual((out["ability"], out["preset"]), (sv.HIDDEN_SLOT, sv.preset_moves(n["CHARIZARD"], 5)))
        self.assertEqual(out["friendship"], sv.personal_records()[n["CHARIZARD"]]["friendship"],
                         "a new one's friendship is its species' own")
        self.assertEqual(self.ok(f"/api/species?species={n['CHARIZARD']}&bit=1")["ability"], 0, "no second: the first")

    def test_the_page_takes_the_game_from_the_tree(self):
        """What exists -- the badges, the pockets in the game's order, the
        stats, directions and genders, every limit -- comes in /api/data from
        the tree; the page's Italian names are keyed by the tree's constants,
        so a key that names nothing there is a translation of something gone."""
        data = self.ok("/api/data")
        self.assertEqual([p["const"] for p in data["pockets"]][:2], ["POCKET_ITEMS", "POCKET_MEDICINE"], "sPockets' order")
        self.assertEqual(data["limits"]["ev"], sv.MAX_EV_PER_STAT)
        self.assertEqual([b["const"] for b in data["badges"] if b["field"] == "kanto"][0], "BADGE_BOULDER")
        page = (ROOT / "tools/newgold/devkit/saveui.html").read_text()
        types = {name[len("TYPE_"):] for name in sv.constants("include/constants/pokemon.h", "TYPE_")}
        header = (ROOT / "include/map_header.h").read_text()
        for table, known in (("BADGE_NAMES", {b["const"] for b in data["badges"]}),
                             ("POCKET_NAMES", {p["const"] for p in data["pockets"]}),
                             ("STAT_NAMES", {s["const"] for s in data["stats"]}),
                             ("DIR_NAMES", {d["const"] for d in data["directions"]}),
                             ("GENDER_MARKS", {g["const"] for g in data["genders"]}), ("TYPES", types),
                             ("PLAYER_GENDER_NAMES", {g["const"] for g in data["player_genders"]}),
                             ("REGION_NAMES", set(re.findall(r"\b(MAP_REGION_\w+)", header))),
                             ("MAP_TYPE_NAMES", set(re.findall(r"\b(MAP_TYPE_\w+)", header)))):
            keys = set(re.findall(r"(\w+):", re.search(rf"const {table} = \{{(.*?)\}};", page, re.S).group(1)))
            self.assertLessEqual(keys, known, table)
        words = {w for m in data["maps"] for w in m["const"].split("_")}
        self.assertLessEqual(set(re.findall(r"(\w+):", re.search(r"const MAP_WORDS_IT = \{(.*?)\};", page, re.S).group(1))), words,
                             "MAP_WORDS_IT: words of the maps' constants")
        # The story's words, whose values are sentences: a key starts the table or follows a comma.
        flags = set(sv.constants("include/constants/flags.h", "FLAG_"))
        for table, known in (("MENU_NAMES", {m["icon"] for m in data["menu"]}),
                             ("CARD_NAMES", {c["const"] for c in data["pokegear"]["cards"]}),
                             ("STORY_NAMES", flags | {s["key"] for s in data["story"]})):
            text = re.search(rf"const {table} = \{{(.*?)\}};", page, re.S).group(1)
            keys = set(re.findall(r"(?:^|[{,]\s*)(\w+):", text))
            self.assertTrue(keys, table)
            self.assertLessEqual(keys, known, table)

    def test_only_what_the_species_can_have(self):
        """A move the species never learns, or an ability slot it lacks, is
        refused in Italian naming both; the species' own are written, a new
        species brings its own moves and ability, and the old moves sent
        back with it are refused like any other."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        f = "gyms/test.sav"
        said = self.refused("/api/edit", {"f": f, "op": "party_edit", "args": {"slot": 0, "moves": [moves["SURF"], moves["TACKLE"]]}})
        self.assertIn("Chikorita non può imparare Surf", said)
        said = self.refused("/api/edit", {"f": f, "op": "box_edit", "args": {"box": 2, "slot": 5, "ability": sv.HIDDEN_SLOT}})
        self.assertIn("Mew non ha un'abilità nascosta", said)
        self.assertIn("Chikorita non può imparare Surf", self.refused("/api/edit", {"f": f, "op": "box_add", "args": {
            "box": 0, "slot": 0, "species": n["CHIKORITA"], "level": 5, "moves": [moves["SURF"]]}}))
        self.assertEqual(self.backups(f), [], "nothing written")
        out = self.edit("party_edit", {"slot": 0, "moves": [moves["RAZOR_LEAF"], moves["ANCIENT_POWER"]], "ability": 1})
        self.assertEqual(([m["name"] for m in out["party"][0]["moves"]], out["party"][0]["ability_name"]),
                         (["Razor Leaf", "Ancient Power"], "Leaf Guard"))
        pidgey = out["party"][1]
        self.assertIn("Chikorita non può imparare", self.refused("/api/edit", {"f": f, "op": "party_edit", "args": {
            "slot": 1, "species": n["CHIKORITA"], "moves": [m["id"] for m in pidgey["moves"]]}}))
        out = self.edit("party_edit", {"slot": 1, "species": n["CHIKORITA"], "level": pidgey["level"]})
        self.assertEqual([m["id"] for m in out["party"][1]["moves"]], sv.preset_moves(n["CHIKORITA"], pidgey["level"]))
        self.assertEqual(out["party"][1]["ability_slot"], sv.ability_slot(n["CHIKORITA"], 0, pidgey["hidden_ability"],
                                                                          pidgey["ability_bit"]))
        out = self.edit("box_add", {"box": 0, "slot": 0, "species": n["EEVEE"], "level": 10, "ability": sv.HIDDEN_SLOT,
                                    "moves": [moves["WISH"], moves["TACKLE"]]})
        self.assertEqual((out["boxes"]["mons"][0][0]["ability_name"], out["boxes"]["mons"][0][0]["hidden_ability"]),
                         ("Anticipation", True))

    def test_an_ability_its_species_would_not_give_is_said_and_mended(self):
        """A Pokemon whose species was written alone, as the old editor did:
        it kept the old species' ability. It is said, and a slot sent for
        it writes that slot's ability, even the one its bits already pick."""
        n = sv.species_numbers()
        save = sv.Save(self.save)
        was = sv.describe_mon(sv.party_raw(save)[0])["ability_name"]      # Chikorita's
        mon = sv.open_mon(sv.party_raw(save)[0])
        struct.pack_into("<H", mon["blocks"][0], 0, n["PONYTA"])
        sv.set_party_mon(save, 0, sv.seal_mon(mon))
        self.save.write_bytes(save.image())
        now = self.ok("/api/save?f=gyms/test.sav")["party"][0]
        self.assertEqual((now["species_name"], now["ability_name"], now["ability_ok"]), ("Ponyta", was, False))
        out = self.edit("party_edit", {"slot": 0, "ability": now["ability_slot"]})
        self.assertTrue(out["changed"])
        mended = out["party"][0]
        self.assertTrue(mended["ability_ok"])
        self.assertIn(mended["ability_name"], [a["name"] for a in sv.species_abilities(n["PONYTA"])])
        self.assertTrue(all(m["ability_ok"] for m in out["party"][1:]), "the ones the game made are right")

    def test_an_event_move_is_kept_until_it_is_changed(self):
        """A Pokemon the game made may know what no rule lists: editing it
        keeps that move while the move and the species stay."""
        n, moves = sv.species_numbers(), sv.move_numbers()
        save = sv.Save(self.save)
        sv.set_box_mon(save, 0, 0, sv.build_mon("CHARIZARD", 40, moves=[moves["SURF"], moves["EMBER"]])[:sv.BOX_MON])
        self.save.write_bytes(save.image())
        out = self.edit("box_edit", {"box": 0, "slot": 0, "level": 41, "moves": [moves["SURF"], moves["FLAMETHROWER"]]})
        self.assertEqual([(m["name"], m["learnable"]) for m in out["boxes"]["mons"][0][0]["moves"]],
                         [("Surf", False), ("Flamethrower", True)], "the page marks the one the species does not learn")
        self.assertIn("Charizard non può imparare Waterfall", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "box_edit",
            "args": {"box": 0, "slot": 0, "moves": [moves["WATERFALL"], moves["FLAMETHROWER"]]}}))

    def test_a_move_twice_is_refused_only_when_the_moves_change(self):
        """The old CLI's Machamp knows Focus Energy twice: an edit that
        leaves its moves keeps them; moves sent with one twice, to it, to a
        boxed one or to a new one, are refused naming the move."""
        moves = sv.move_numbers()
        twice = [moves["FOCUS_ENERGY"], moves["FOCUS_ENERGY"], moves["KARATE_CHOP"], moves["FORESIGHT"]]
        save = sv.Save(self.save)
        sv.set_party_mon(save, 0, sv.build_mon("MACHAMP", 13, moves=twice))
        sv.set_box_mon(save, 0, 0, sv.build_mon("MACHAMP", 13, moves=twice)[:sv.BOX_MON])
        self.save.write_bytes(save.image())
        out = self.edit("party_edit", {"slot": 0, "level": 14, "moves": twice})
        self.assertEqual([m["id"] for m in out["party"][0]["moves"]], twice, "left alone, kept")
        changed = twice[:3] + [moves["LOW_KICK"]]
        for op, args in (("party_edit", {"slot": 0, "moves": changed}), ("box_edit", {"box": 0, "slot": 0, "moves": changed}),
                         ("box_add", {"box": 0, "slot": 1, "species": sv.species_numbers()["MACHOP"], "level": 13,
                                      "moves": twice[:2]})):
            self.assertIn("Focus Energy compare due volte", self.refused("/api/edit", {"f": "gyms/test.sav", "op": op, "args": args}))

    def test_saving_a_pokemon_brings_its_pp_down(self):
        """The old CLI's Machamp has 40 PP on every move: saved from the
        dialog, even with nothing changed, each comes down to its maximum;
        the one next to it, not saved, keeps its 40s and its move twice."""
        moves = sv.move_numbers()
        twice = [moves["FOCUS_ENERGY"], moves["FOCUS_ENERGY"], moves["KARATE_CHOP"], moves["FORESIGHT"]]
        save = sv.Save(self.save)

        def old_cli(moves):   # what that CLI wrote: 40 PP, no PP Ups
            mon = sv.open_mon(sv.build_mon("MACHAMP", 13, moves=moves))
            for i in range(4):
                mon["blocks"][1][8 + i], mon["blocks"][1][12 + i] = 40, 0
            return sv.seal_mon(mon)
        for slot in (0, 1):
            sv.set_party_mon(save, slot, old_cli(twice))
        sv.set_box_mon(save, 0, 0, old_cli(twice)[:sv.BOX_MON])
        self.save.write_bytes(save.image())
        out = self.edit("party_edit", {"slot": 0, "level": 13, "moves": twice})
        self.assertTrue(out["changed"])
        self.assertEqual([(m["pp"], m["pp_max"]) for m in out["party"][0]["moves"]], [(30, 30), (30, 30), (25, 25), (40, 40)])
        self.assertEqual([(m["pp"], m["repeat"]) for m in out["party"][1]["moves"]],
                         [(40, False), (40, True), (40, False), (40, False)], "untouched")
        out = self.edit("box_edit", {"box": 0, "slot": 0})
        self.assertEqual([m["pp"] for m in out["boxes"]["mons"][0][0]["moves"]], [30, 30, 25, 40])

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

    def test_the_position_tab(self):
        """What the Posizione tab offers: every map's tiles on the town map
        (/api/data's "world"), the town map itself, the place the game puts
        the player on a map (/api/place), and a tile refused in Italian when
        the player could not stand there, naming the place that is safe."""
        data = self.ok("/api/data")
        self.assertEqual((data["world"]["cols"], data["world"]["rows"]), (47, 20))
        self.assertIn(33, data["world"]["main"])
        self.assertEqual(data["world"]["buildings"], sorted(sv.buildings()), "MapHeader_IsInBuilding's, not the page's")
        centre = sv.constants("include/constants/maps.h", "MAP_")["MAP_VIOLET_POKECENTER_1F"]
        self.assertIn(centre, data["world"]["heals"], "a heal spawn: tagged in the list")
        self.assertEqual(re.findall(r'"MAP_TYPE_\w+"', (ROOT / "tools/newgold/devkit/saveui.html").read_text()), [])
        self.assertIn([655 // 32, 400 // 32 + 2], data["world"]["tiles"]["33"])
        self.assertEqual(self.ok("/api/place?map=33"), {"map": 33, "x": [576, 671], "y": [384, 415], "preset": {
            "how": "warp", "x": 626, "y": 389, "direction": 1, "said": saveui.ARRIVALS["warp"]}})
        self.assertIn("non è un luogo", self.refused("/api/place?map=0"))
        status, png = self.call("/api/townmap.png")
        self.assertEqual((status, struct.unpack(">II", png[16:24])), (200, (8 * 47, 8 * 20)))
        url = f"http://127.0.0.1:{self.port}/api/townmap.png"
        with urllib.request.urlopen(url) as response:
            tag = response.headers["ETag"]
        with self.assertRaises(urllib.error.HTTPError) as unchanged:
            urllib.request.urlopen(urllib.request.Request(url, headers={"If-None-Match": tag}))
        self.assertEqual(unchanged.exception.code, 304)
        unchanged.exception.close()
        position = lambda where, x, y: {"f": "gyms/test.sav", "op": "position", "args": {"map": where, "x": x, "y": y}}
        wall = self.refused("/api/edit", position(33, 576, 384))
        self.assertIn("casella bloccata", wall)
        self.assertIn("(626, 389)", wall, "the safe place named")
        new_bark = sv.constants("include/constants/maps.h", "MAP_")["MAP_NEW_BARK"]
        water = next(p for p, w in sorted(sv.ground(new_bark)[1].items()) if w == "water")
        self.assertIn("è acqua", self.refused("/api/edit", position(new_bark, *water)))
        centre = sv.constants("include/constants/maps.h", "MAP_")["MAP_VIOLET_POKECENTER_1F"]
        self.assertIn("fuori dalle stanze", self.refused("/api/edit", position(centre, 20, 20)))
        self.assertEqual(self.backups(), [], "a refused position writes nothing")
        out = self.edit("position", {"map": centre, "x": 8, "y": 13, "direction": 0})
        self.assertEqual(out["position"]["tile"], [15, 8 + 2], "the Pokégear's mark: Violet City's tile")

    def test_the_story_and_what_the_player_was_given(self):
        """The story's steps and the gyms come in /api/data, the save's
        state of them in /api/save; op "story" runs steps as the game does
        and takes them back, saying which variables it left; "menu" and
        "pokegear" are the switches the start menu and the Pokégear read."""
        data = self.ok("/api/data")
        beaten, lass, badge, tm = data["chains"]["BADGE_PLAIN"]
        steps = {s["id"]: s for s in data["story"]}
        self.assertEqual(steps[beaten]["trainer"], "Whitney")
        self.assertEqual([m["icon"] for m in data["menu"]][-1], "START_MENU_ICON_RUNNING_SHOES")
        self.assertEqual(data["level_cap"]["none"], 10)
        out = self.ok("/api/save?f=gyms/test.sav")
        self.assertEqual((out["given"]["shoes"], out["given"]["level_cap"]), (False, 10))
        self.assertNotIn(beaten, out["story"]["done"])
        out = self.edit("story", {"run": [beaten]})
        self.assertIn(["var", "VAR_UNK_410A", 1], out["report"]["ran"][beaten])
        self.assertIn(beaten, out["story"]["done"])
        self.assertNotIn(badge, out["story"]["done"], "Whitney beaten, the badge not given yet")
        out = self.edit("story", {"run": [lass, badge]})
        self.assertEqual((out["profile"]["johto"] != 0, out["given"]["level_cap"]), (True, 34))
        out = self.edit("story", {"undo": [badge]})
        self.assertEqual(out["report"], {"ran": {}, "left": {}})
        self.assertEqual((out["profile"]["johto"], out["given"]["level_cap"]), (0, 10))
        # What each run found is kept beside the backups: taken back, the
        # steps put it back, the variables too.
        records = self.library / ".backups/gyms/test.sav" / saveui.STORY_RECORDS
        self.assertEqual(set(json.loads(records.read_text())), {beaten, lass})
        out = self.edit("story", {"undo": [lass, beaten]})
        self.assertEqual(out["report"]["left"], {})
        now, then = sv.Save(self.save), sv.Save(self.template)
        for block in ("SAVE_FLAGS", "SAVE_PLAYERDATA", "SAVE_BAG"):
            self.assertEqual(bytes(now.block(block))[:-sv.save_budget.CRC], bytes(then.block(block))[:-sv.save_budget.CRC],
                             f"{block} as it was")
        # A step outside a gym taken back with no record of its run leaves
        # its variables, and says so while they hold what it left.
        step = next(s for s in data["story"] if not s["badge"] and any(w[0] == "var" and not w[3] for w in s["writes"]))
        self.edit("story", {"run": [step["id"]]})
        records.unlink()
        out = self.edit("story", {"undo": [step["id"]]})
        self.assertTrue(out["report"]["left"][step["id"]])
        self.assertEqual(out["story"]["left"], out["report"]["left"])
        out = self.edit("menu", {"icon": "START_MENU_ICON_RUNNING_SHOES", "on": True})
        self.assertEqual((out["given"]["shoes"], out["given"]["menu"]["START_MENU_ICON_RUNNING_SHOES"]), (True, True))
        out = self.edit("pokegear", {"cards": 3, "map_level": 1})
        self.assertEqual(out["given"]["pokegear"], {"cards": 3, "map_level": 1})
        self.assertIn("passo della storia", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "story",
                                                                       "args": {"run": ["0000:1"]}}))
        self.assertIn("livello della mappa", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "pokegear",
                                                                        "args": {"map_level": 3}}))
        self.assertIn("non è una voce del menu", self.refused("/api/edit", {"f": "gyms/test.sav", "op": "menu",
                                                                            "args": {"icon": "START_MENU_ICON_EXIT", "on": 1}}))
        self.assertEqual(len(self.backups()), 8, "one backup a write")

    def test_the_machines(self):
        """op "machines": the checklist's changes written as the game keeps
        the pocket -- sorted TMs, TRs, HMs, a removal closing the gap -- and
        refused in Italian past a machine's limit, past the pocket's slots,
        or for an item that is no machine."""
        items = {row["const"]: row["id"] for row in sv.item_table().values()}
        table = self.ok("/api/data")["machines"]
        self.assertEqual(table[0]["item"], items["ITEM_TM01"])
        out = self.edit("machines", {"changes": [{"item": items["ITEM_HM01"], "quantity": 1},
                                                 {"item": items["ITEM_TR00"], "quantity": 5},
                                                 {"item": items["ITEM_TM01"], "quantity": 1}]})
        self.assertEqual([(s["item"], s["quantity"]) for s in out["bag"]["TMsHMs"]],
                         [(items["ITEM_TM01"], 1), (items["ITEM_TR00"], 5), (items["ITEM_HM01"], 1)])
        out = self.edit("machines", {"changes": [{"item": items["ITEM_TM01"], "quantity": 0},
                                                 {"item": items["ITEM_TM02"], "quantity": 1}]})
        self.assertEqual([s["item"] for s in out["bag"]["TMsHMs"]], [items["ITEM_TM02"], items["ITEM_TR00"], items["ITEM_HM01"]])
        refused = lambda changes: self.refused("/api/edit", {"f": "gyms/test.sav", "op": "machines",
                                                             "args": {"changes": changes}})
        self.assertIn("una MT è una sola", refused([{"item": items["ITEM_TM03"], "quantity": 2}]))
        self.assertIn("non è una MT", refused([{"item": items["ITEM_POTION"], "quantity": 1}]))
        slots = next(p["slots"] for p in self.ok("/api/data")["pockets"] if p["name"] == "TMsHMs")
        many = [{"item": row["item"], "quantity": 1} for row in table[:slots + 1]]
        self.assertIn(f"ha {slots} posti: ne servirebbero", refused(many))
        self.assertEqual(len(self.backups()), 2, "a refused change writes nothing")

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
        self.assertIn("melonDS", self.refused("/api/take", {"slot": "hg-diag", "name": "presa"}))
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
                               ("trainer", {"play_time": [1, 2]}, "ore, minuti e secondi"),
                               ("trainer", {"gender": sv.PLAYER_GENDER_FEMALE + 1}, "genere")):
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

    def test_one_lock_across_a_change_of_folder(self):
        self.assertIs(saveui.Library(self.library, self.build).lock, saveui.Handler.library.lock)

    def test_only_this_page_may_ask(self):
        body = {"f": "gyms/test.sav", "op": "trainer", "args": {"money": 1}}
        self.assertEqual(self.call("/api/edit", body, {"Origin": "http://evil.example"})[0], 403)
        self.assertEqual(self.call("/api/edit", body, {"Content-Type": "text/plain"})[0], 403)
        self.assertEqual(self.call("/api/library", None, {"Host": "evil.example"})[0], 403)
        self.assertEqual(self.backups(), [])
        self.assertEqual(self.server.server_address[0], "127.0.0.1")


if __name__ == "__main__":
    unittest.main()
