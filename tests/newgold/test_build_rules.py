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


if __name__ == "__main__":
    unittest.main()
