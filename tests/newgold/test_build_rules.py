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
import unittest
from functools import lru_cache

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


if __name__ == "__main__":
    unittest.main()
