#!/usr/bin/env python3
"""Check the build's own rules: what make does before it compiles anything.

Most of it is read from make's database (make -p), which is the makefiles
the way make understood them, after every include and conditional, without
building a thing. WINPATH is emptied for it: its only use is a winepath call,
and a wine started outside the project's prefix makes one in ~/.wine.
"""

import os
import re
import subprocess
import tempfile
import unittest
from functools import lru_cache
from pathlib import Path

from test_level_cap import ROOT


def run_make(*args):
    env = {k: v for k, v in os.environ.items() if not k.startswith("MAKE")}
    env["LC_ALL"] = "C"
    return subprocess.run(["make", "-C", str(ROOT), "COMPARE=0", "WINPATH=", *args],
                          capture_output=True, text=True, env=env)


@lru_cache(maxsize=None)
def database():
    result = run_make("-pn", "print-NOTHING")
    assert result.returncode == 0, result.stderr
    return result.stdout


class BuildRuleTests(unittest.TestCase):
    def test_no_target_is_intermediate(self):
        """GNU make 4.4 read the bare .SECONDARY: as every target secondary,
        so intermediate, and walked an intermediate's prerequisites again for
        each target naming it: a fresh tree's first build walked the message
        headers under headers.done once per script per pass, for half an hour
        and more before it compiled anything."""
        db = database()
        features = re.search(r"^\.FEATURES := (.*)$", db, re.M).group(1).split()
        if "notintermediate" not in features:
            self.skipTest("this make has no .NOTINTERMEDIATE; the bare .SECONDARY: stays")
        self.assertRegex(db, r"(?m)^\.NOTINTERMEDIATE:\s*$")
        self.assertNotRegex(db, r"(?m)^\.SECONDARY:\s*$")

    def test_dependency_files_name_the_tree_relative_to_it(self):
        """mwcc writes the tree's headers by absolute path. Kept absolute, a
        build directory copied into a worktree made its objects depend on the
        first checkout's headers -- an edit in the worktree rebuilt nothing --
        and a generated .naix it named matched no rule once it was missing.
        Runs fixdep's sed on a dependency file as mwcc writes one."""
        text = (ROOT / "common.mk").read_text()
        body = re.search(r"ifneq \(\$\(WINPATH\),\)\n.*?define fixdep\n(.*?)\n", text, re.S).group(1)
        program = re.search(r"-i '([^']*)'", body).group(1)
        program = program.replace("$(PROJECT_ROOT_NT)", "Z:/home/somebody/tree/").replace("$(WORK_DIR)", ".").replace("$$", "$")
        written = ("build/heartgold.us/src/foo.o: src/foo.c \\\r\n"
                   "\tZ:\\home\\somebody\\tree\\include\\global.h \\\r\n"
                   "\tZ:\\home\\somebody\\tree\\files\\data\\resdat.naix\r\n")
        fixed = subprocess.run(["sed", program], input=written, capture_output=True, text=True).stdout
        self.assertEqual(fixed, "build/heartgold.us/src/foo.o: src/foo.c \\\n"
                                "\t./include/global.h \\\n"
                                "\t./files/data/resdat.naix\n")

    def test_a_deleted_include_does_not_stop_the_next_build(self):
        """A dependency file named its headers and includes with no rule for
        any of them, so one deleted later -- overlay_12_battle_command.inc
        after 5d57ce707 -- was a target make had no rule for, and the build
        stopped until the .d was removed by hand. Runs each fixdep on a
        dependency file as the tools write one, with sed -r as platform.mk
        sets SED, deletes an include it names and builds again."""
        env = {k: v for k, v in os.environ.items() if not k.startswith("MAKE")}
        env["LC_ALL"] = "C"
        bodies = re.findall(r"define fixdep\n(.*?)\nendef", (ROOT / "common.mk").read_text(), re.S)
        self.assertEqual(len(bodies), 2)
        for body in bodies:
            with tempfile.TemporaryDirectory(prefix="newgold-fixdep-") as directory:
                path = Path(directory)
                (path / "Makefile").write_text(
                    "SED := sed -r\nPROJECT_ROOT_NT := Z:/nowhere\nWORK_DIR := .\n"
                    f"define fixdep\n{body}\nendef\n"
                    "x.o: x.s\n\ttouch $@\n\tcp written.d x.d\n\t$(call fixdep,x.d)\n"
                    "include $(wildcard x.d)\n")
                (path / "written.d").write_text("x.o: x.s \\\r\n\tgone.inc \\\r\n\tkept.inc \r\n")
                for name in ("x.s", "gone.inc", "kept.inc"):
                    (path / name).touch()
                first = subprocess.run(["make", "-C", directory], capture_output=True, text=True, env=env)
                self.assertEqual(first.returncode, 0, first.stderr)
                (path / "gone.inc").unlink()
                second = subprocess.run(["make", "-C", directory], capture_output=True, text=True, env=env)
                self.assertEqual(second.returncode, 0, second.stderr)
                self.assertIn("touch x.o", second.stdout)

    def test_what_o2narc_builds_depends_on_o2narc(self):
        """f9de102b7 changed where o2narc puts an archive's members, and the
        Dex archives it had already built kept the old layout until they
        were deleted by hand: nothing o2narc builds depended on it. Every
        target whose recipe runs it now does, and jsonproc, handed the rest
        of $^, still gets only the json and the template."""
        rules = re.findall(r"^([^#\s%][^:\n]*):(?!=)([^\n]*)\n(?:#[^\n]*\n)*((?:\t[^\n]*\n)+)", database(), re.M)
        users = {target: prerequisites.split() for target, prerequisites, recipe in rules if "$(O2NARC)" in recipe}
        self.assertIn("files/application/zukanlist/zkn_data/zukan_data.narc", users)
        tool = None
        for target, prerequisites in users.items():
            found = [p for p in prerequisites if p.endswith("/tools/o2narc/o2narc")]
            self.assertTrue(found, f"{target} does not depend on o2narc")
            tool = found[0]
        result = run_make("-n", "-W", tool, *sorted(users))
        self.assertEqual(result.returncode, 0, result.stderr)
        jsonproc = [line for line in result.stdout.splitlines() if "/jsonproc " in line]
        self.assertEqual(len(jsonproc), len(users), result.stdout)
        for line in jsonproc:
            self.assertNotIn("o2narc", line)
            self.assertEqual(len(line.split()), 4, line)

    def test_a_naix_is_made_by_making_its_archive(self):
        """nitroarc writes an archive's .naix beside it. A pattern rule with
        no recipe is no rule at all, so a .naix a dependency file named was
        "nothing to be done" when stale and "no rule" when missing."""
        result = run_make("-n", "-W", "files/data/resdat.json.txt", "files/data/resdat.naix")
        self.assertIn("nitroarc -cf files/data/resdat.narc", result.stdout, result.stdout + result.stderr)

    def test_a_target_that_is_never_a_file_only_orders(self):
        """files_for_compile and check_scripts are names, not files: as an
        ordinary prerequisite each is remade on every run and makes its
        dependents out of date, which recompiled all 797 game objects, and
        the script archive with the objects that read its index, on every
        build with nothing changed. They only have to come first."""
        db = database()
        for target, name in (("build/heartgold.us/src/alph_checks.o", "files_for_compile"),
                             ("build/heartgold.us/asm/overlay_96.o", "files_for_compile"),
                             ("files/fielddata/script/scr_seq.narc", "check_scripts")):
            # the prerequisites, not a target-specific variable
            rules = [m.group(1) for m in re.finditer(rf"^{re.escape(target)}:(.*)$", db, re.M) if "=" not in m.group(1)]
            self.assertEqual(len(rules), 1, target)
            normal, _, order_only = rules[0].partition("|")
            self.assertTrue(name not in normal.split() and name in order_only.split(), f"{target}: {name}")

    def test_a_zone_event_is_rebuilt_for_the_header_its_json_names(self):
        """A zone's events name their scripts by the ids of the header the
        json gives ({{ header }}); only the assembler knew which, and the
        dependency file it wrote was never read, so a renumbered script left
        the old ids in the archive. Each bin depends on its own X.bin.d, and
        once built, through it, on that header."""
        db = database()
        prerequisites = {}
        for m in re.finditer(r"^(files/fielddata/eventdata/zone_event/[^:\s]+\.bin):(.*)$", db, re.M):
            if "=" not in m.group(2):
                prerequisites.setdefault(m.group(1), set()).update(m.group(2).replace("|", " ").split())
        jsons = sorted((ROOT / "files/fielddata/eventdata/zone_event").glob("*.json"))
        self.assertEqual(len(prerequisites), len(jsons))
        built = 0
        for json in jsons:
            bin_ = f"files/fielddata/eventdata/zone_event/{json.stem}.bin"
            self.assertIn(bin_ + ".d", prerequisites[bin_])
            header = re.match(r'\s*\{\s*"header":\s*"([^"]+)"', json.read_text())
            if header and (ROOT / (bin_ + ".d")).exists():
                built += 1
                self.assertIn("files/" + header.group(1), prerequisites[bin_], bin_)
        print(f"{built} of {len(jsons)} zone events depend on their json's header")

    def test_safari_enc_is_built_beside_its_json(self):
        """Its recipe writes $*.s and $*.o. The rule was an explicit one, which
        has no stem, so they were '.s' and '.o' in the tree's root."""
        result = run_make("-n", "-W", "files/arc/safari_enc.json", "files/arc/safari_enc.narc")
        self.assertIn("files/arc/safari_enc.json files/arc/safari_enc.json.txt files/arc/safari_enc.s", result.stdout,
                      result.stdout + result.stderr)

    def test_zukan_enc_naix_is_made_before_anything_is_compiled(self):
        """The Pokedex includes zukan_enc.naix, which is sed's copy of the
        version's own index, not an archive's. Only `filesystem` asked for
        it, and with -j the objects do not wait for that: a build after
        clean-zukan-enc, or a first one, could compile the Pokedex first."""
        prerequisites = re.search(r"^files_for_compile:(.*)$", database(), re.M).group(1).split()
        self.assertIn("files/application/zukanlist/zkn_data/zukan_enc.naix", prerequisites)

    def test_no_suffix_rule_is_live(self):
        """make's built-in suffix rules matched stray files: a .d.p beside a
        .d was Pascal source to it, and a way to remake the .d."""
        self.assertRegex(database(), r"(?m)^\.SUFFIXES:[ \t]*$")

    def test_a_battle_script_archive_holds_script_n_at_member_n(self):
        """The archive rule packed every .bin in the folder, so a script
        renumbered or removed left its old .bin in the next build and every
        script after it ran another's code. Reads the index the build wrote:
        member N is the .bin of the .s numbered N, and there is no other."""
        for name in ("subscript", "effect_script", "move_script"):
            index = ROOT / f"files/battledata/script/{name}.naix"
            if not index.exists():
                self.skipTest(f"{index.name} is not built")
            members = re.findall(rf"^#define NARC_{name}_(\w+)_bin (\d+)$", index.read_text(), re.M)
            sources = sorted((s.stem for s in (ROOT / f"files/battledata/script/{name}").glob("*.s")),
                             key=lambda stem: int(re.search(r"_(\d+)", stem).group(1)))
            self.assertEqual([stem for stem, _ in members], sources, name)
            for stem, member in members:
                self.assertEqual(int(re.search(r"_(\d+)", stem).group(1)), int(member), stem)

    def numbered_narc(self, directory, sources):
        """A folder of numbered sources, each copied to its .bin, packed by
        filesystem.mk's numbered_narc with the tree's nitroarc: returns a
        function that runs make and gives what it printed and the members
        the index names, in order."""
        nitroarc = ROOT / "tools/nitroarc/nitroarc"
        if not nitroarc.exists():
            self.skipTest("nitroarc is not built")
        body = re.search(r"^define numbered_narc\n(.*?)\nendef$", (ROOT / "filesystem.mk").read_text(), re.S | re.M).group(1)
        path = Path(directory)
        (path / "a/d").mkdir(parents=True)
        (path / "Makefile").write_text(
            f"NARC := {nitroarc}\nFORCE:\n.PHONY: FORCE\n"
            f"define numbered_narc\n{body}\nendef\n"
            "a/d/%.bin: a/d/%.s\n\tcp $< $@\n"
            "$(eval $(call numbered_narc,a/d.narc,a/d,$(patsubst %.s,%.bin,$(wildcard a/d/*.s))))\n")
        for name in sources:
            (path / "a/d" / name).write_text(name)
        env = {k: v for k, v in os.environ.items() if not k.startswith("MAKE")}
        env["LC_ALL"] = "C"

        def make():
            result = subprocess.run(["make", "-C", directory, "a/d.narc"], capture_output=True, text=True, env=env)
            self.assertEqual(result.returncode, 0, result.stderr)
            index = (path / "a/d.naix").read_text()
            return result.stdout, re.findall(r"^#define NARC_d_(\w+)_bin \d+$", index, re.M)
        return make

    def test_an_archive_is_rebuilt_when_only_a_member_is_removed(self):
        """The archive depended on its members' files alone, so deleting the
        last script made nothing newer: the archive kept the old member until
        something else rebuilt it. The list of members is a prerequisite now,
        rewritten only when it changes, so a run with nothing changed still
        rebuilds nothing."""
        with tempfile.TemporaryDirectory(prefix="newgold-narcorder-") as directory:
            make = self.numbered_narc(directory, ["x_0000.s", "x_0001.s", "x_0002.s"])
            self.assertEqual(make()[1], ["x_0000", "x_0001", "x_0002"])
            printed, _ = make()
            self.assertNotIn("nitroarc", printed, "a run with nothing changed rebuilt the archive")
            (Path(directory) / "a/d/x_0002.s").unlink()
            self.assertEqual(make()[1], ["x_0000", "x_0001"])

    def test_an_archive_packs_its_members_in_number_order(self):
        """The list was sorted by name, which is number order only while
        every number has four digits: a script past 9999, or one written
        without the zeros, went where its name sorts."""
        with tempfile.TemporaryDirectory(prefix="newgold-narcorder-") as directory:
            make = self.numbered_narc(directory, ["x_10000.s", "x_0200.s", "x_10.s", "x_9.s"])
            self.assertEqual(make()[1], ["x_9", "x_10", "x_0200", "x_10000"])


if __name__ == "__main__":
    unittest.main()
