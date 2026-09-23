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


if __name__ == "__main__":
    unittest.main()
