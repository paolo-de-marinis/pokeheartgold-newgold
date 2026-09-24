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
ROUNDS = ROOT / "tools/newgold/rounds"
DEVKIT = ROOT / "tools/newgold/devkit"

GMM_ROW = ('\t<row id="msg_0197_{n:05d}" index="{n}">\n'
           '\t\t<attribute name="window_context_name">used</attribute>\n'
           '\t\t<language name="English">{text}</language>\n'
           '\t</row>\n')


def gmm(rows):
    return "<body>\n" + "".join(GMM_ROW.format(n=n, text=t) for n, t in rows) + "</body>\n"


class Repo:
    """A throwaway repository with the four files shift_branch.py reads."""

    def __init__(self, path):
        self.path = path
        self.git("init", "-q", "-b", "main")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.com")

    def git(self, *args, env=None):
        return subprocess.run(["git", *args], cwd=self.path, check=True, capture_output=True, text=True,
                              env={**os.environ, **(env or {})}).stdout

    def write(self, files):
        for name, text in files.items():
            path = self.path / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        self.git("add", "-A")

    def commit(self, message, date="2026-09-24T10:00:00+02:00"):
        self.git("commit", "-q", "-m", message, env={"GIT_AUTHOR_DATE": date, "GIT_COMMITTER_DATE": date})
        return self.git("rev-parse", "HEAD").strip()

    def show(self, rev, path):
        return self.git("show", f"{rev}:{path}")


def lists(subscripts, pointers, bmon, rows):
    header = "".join(f"#define BATTLE_SUBSCRIPT_{name} {n}\n" for name, n in subscripts)
    header += "".join(f"#define MOVE_SUBSCRIPT_PTR_{name} {n}\n" for name, n in pointers)
    files = {"include/constants/battle_subscript.h": header,
             "include/constants/battle.h": "".join(f"#define BMON_DATA_{name} {n}\n" for name, n in bmon),
             "files/msgdata/msg/msg_0197.gmm": gmm(rows)}
    for name, n in subscripts:
        files[f"files/battledata/script/subscript/subscript_{n:04d}_{name.title()}.s"] = f"    // subscript {n}\n"
    return files


class ShiftBranchTests(unittest.TestCase):
    """shift_branch.py: a branch's numbers follow what was integrated before it."""

    def test_a_branch_follows_what_was_integrated_before_it(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = Repo(Path(tmp))
            base_lists = ([("OLD", 400)], [("OLD", 200)], [("OLD", 100)], [(1899, "old")])
            repo.write(lists(*base_lists))
            base = repo.commit("base")
            # the integrated branch took 401-402, pointer 201, BMON 101, row 1900
            repo.write(lists([("OLD", 400), ("FIRST", 401), ("SECOND", 402)], [("OLD", 200), ("FIRST", 201)],
                             [("OLD", 100), ("FIRST", 101)], [(1899, "old"), (1900, "first")]))
            target = repo.commit("the branch integrated first")
            repo.git("checkout", "-q", "-b", "mine", base)
            repo.write(lists([("OLD", 400), ("MINE", 401)], [("OLD", 200), ("MINE", 201)],
                             [("OLD", 100), ("MINE", 101)], [(1899, "old"), (1900, "mine")]))
            repo.write({"src/mine.c": "// subscript_0401_Mine, row msg_0197_01900; the reference's subscript 469\n"})
            repo.commit("battle: mine\n\nSubscript 401, pointer 201, BMON_DATA_MINE 101, row 01900;\n"
                        "the reference's subscript 469 stays.\n", date="2026-09-20T08:00:00+02:00")
            run = subprocess.run([sys.executable, str(ROUNDS / "shift_branch.py"), base, "mine", target, "shifted"],
                                 cwd=tmp, capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stderr)
            self.assertIn("subscripts +2, pointers +1, messages +1, BMON_DATA +1", run.stdout)
            header = repo.show("shifted", "include/constants/battle_subscript.h")
            self.assertIn("#define BATTLE_SUBSCRIPT_OLD 400", header)
            self.assertIn("#define BATTLE_SUBSCRIPT_MINE 403", header)
            self.assertIn("#define MOVE_SUBSCRIPT_PTR_MINE 202", header)
            self.assertIn("#define BMON_DATA_MINE 102", repo.show("shifted", "include/constants/battle.h"))
            self.assertIn('id="msg_0197_01901" index="1901"', repo.show("shifted", "files/msgdata/msg/msg_0197.gmm"))
            tree = repo.git("ls-tree", "-r", "--name-only", "shifted")
            self.assertIn("files/battledata/script/subscript/subscript_0403_Mine.s", tree)
            self.assertNotIn("subscript_0401_Mine.s", tree)
            self.assertEqual(repo.show("shifted", "src/mine.c"),
                             "// subscript_0403_Mine, row msg_0197_01901; the reference's subscript 469\n")
            message = repo.git("log", "-1", "--format=%B", "shifted")
            self.assertIn("Subscript 403, pointer 202, BMON_DATA_MINE 102, row 01901;", message)
            self.assertIn("the reference's subscript 469 stays.", message)
            self.assertEqual(repo.git("log", "-1", "--format=%aI", "shifted").strip(), "2026-09-20T08:00:00+02:00")
            self.assertEqual(repo.git("rev-parse", "shifted^").strip(), base)


class PickOnTests(unittest.TestCase):
    """pick_on.sh finishes a cherry-pick whose conflicts have a known shape."""

    def test_a_pick_that_appended_where_the_integration_did_goes_through(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo = Repo(Path(tmp))
            repo.write(lists([("OLD", 400)], [], [], [(0, "old"), (1, "old")]))
            base = repo.commit("base")
            repo.write(lists([("OLD", 400), ("FIRST", 401)], [], [], [(0, "old"), (1, "old"), (2, "first")]))
            repo.commit("integrated first")
            repo.git("checkout", "-q", "-b", "shifted", base)
            repo.write(lists([("OLD", 400), ("MINE", 402)], [], [], [(0, "old"), (1, "old"), (3, "mine")]))
            mine = repo.commit("battle: mine, shifted after first")
            repo.git("checkout", "-q", "main")
            self.assertNotEqual(subprocess.run(["git", "cherry-pick", mine], cwd=tmp, capture_output=True).returncode, 0)
            run = subprocess.run([str(ROUNDS / "pick_on.sh")], cwd=tmp, capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            self.assertEqual(repo.git("log", "-1", "--format=%s").strip(), "battle: mine, shifted after first")
            self.assertEqual(repo.show("HEAD", "include/constants/battle_subscript.h"),
                             "#define BATTLE_SUBSCRIPT_OLD 400\n#define BATTLE_SUBSCRIPT_FIRST 401\n"
                             "#define BATTLE_SUBSCRIPT_MINE 402\n")
            self.assertEqual(repo.show("HEAD", "files/msgdata/msg/msg_0197.gmm"),
                             gmm([(0, "old"), (1, "old"), (2, "first"), (3, "mine")]))


class ResolverTests(unittest.TestCase):
    """The resolvers that keep both sides of a conflict."""

    CONFLICT = "a\n<<<<<<< HEAD\nours 1\nshared\n=======\ntheirs 1\nshared\n>>>>>>> 1234567 (theirs)\nz\n"

    def resolve(self, script, text, *options):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "f.txt"
            path.write_text(text)
            subprocess.run([sys.executable, str(ROUNDS / script), *options, str(path)], check=True, capture_output=True)
            return path.read_text()

    def test_keep_both_is_ours_then_theirs(self):
        self.assertEqual(self.resolve("keep_both.py", self.CONFLICT), "a\nours 1\nshared\ntheirs 1\nshared\nz\n")

    def test_keep_both_fn_closes_the_first_function(self):
        self.assertEqual(self.resolve("keep_both.py", self.CONFLICT, "--fn"),
                         "a\nours 1\nshared\n}\n\ntheirs 1\nshared\nz\n")

    def test_theirs_then_ours_keeps_a_line_once(self):
        self.assertEqual(self.resolve("theirs_then_ours.py", self.CONFLICT), "a\ntheirs 1\nshared\nours 1\nz\n")

    def test_fix_gmm_closes_the_row_a_union_merge_drops(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "files/msgdata/msg/msg_0197.gmm"
            path.parent.mkdir(parents=True)
            text = gmm([(0, "a"), (1, "b")])
            path.write_text(text.replace("</language>\n\t</row>\n\t<row", "</language>\n\t<row", 1))
            subprocess.run([sys.executable, str(ROUNDS / "fix_gmm.py")], cwd=tmp, check=True, capture_output=True)
            self.assertEqual(path.read_text(), text)


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
