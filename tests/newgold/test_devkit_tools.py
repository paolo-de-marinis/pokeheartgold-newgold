#!/usr/bin/env python3
"""The devkit's and the rounds' own tools, each tried on something small made
for it: a git repository of a few commits, a conflict, a stand-in for the
program a tool hands its command to, a map of two objects.
"""
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEVKIT = ROOT / "tools/newgold/devkit"


class CappedTests(unittest.TestCase):
    """capped hands the command to systemd-run: a stand-in for it says what it got."""

    def run_capped(self, *args):
        with tempfile.TemporaryDirectory() as tmp:
            stand_in = Path(tmp) / "systemd-run"
            stand_in.write_text('#!/bin/sh\nprintf "%s|" "$@"\n')
            stand_in.chmod(0o755)
            return subprocess.run([str(DEVKIT / "capped"), *args], capture_output=True, text=True,
                                  env={**os.environ, "PATH": f"{tmp}:{os.environ['PATH']}"})

    def test_the_default_cap(self):
        self.assertEqual(self.run_capped("make", "-j8").stdout,
                         "--user|--scope|-q|-p|MemoryMax=4G|-p|MemorySwapMax=1G|--|make|-j8|")

    def test_a_cap_given(self):
        self.assertEqual(self.run_capped("-m", "8G", "python3", "walk.py", "a b").stdout,
                         "--user|--scope|-q|-p|MemoryMax=8G|-p|MemorySwapMax=1G|--|python3|walk.py|a b|")

    def test_no_command_is_the_usage(self):
        run = self.run_capped("-m", "2G")
        self.assertEqual(run.returncode, 2)
        self.assertIn("capped [-m 4G] COMMAND...", run.stdout)


if __name__ == "__main__":
    unittest.main()
